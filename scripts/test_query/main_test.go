package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestSnapshots(t *testing.T) {
	repoRoot := getRepoRoot()
	servicePool := newDbServicePool(repoRoot)
	t.Cleanup(func() {
		servicePool.cleanup()
	})

	// glob for test cases
	glob := filepath.Join(repoRoot, "db_object_kind/*/queries/*/tests/*/*/")
	matches, err := filepath.Glob(glob)
	if err != nil {
		t.Fatalf("%+v", err)
	}
	if len(matches) == 0 {
		t.Fatal("something's wrong: no matches found")
	}
	testCases := make([]*testCase, len(matches))
	for i, dir := range matches {
		d, err := os.Stat(dir)
		if err != nil {
			t.Fatalf("%+v", err)
		}
		if !d.IsDir() {
			t.Fatalf("%s is not a directory", dir)
		}
		testCase, err := newTestCase(dir)
		if err != nil {
			t.Fatalf("%+v", err)
		}
		testCases[i] = testCase
	}
	cache := ioCache{cache: make(map[string]string, len(testCases))}
	for _, testCase := range testCases {
		name, err := filepath.Rel(repoRoot, testCase.targetTsvPath())
		if err != nil {
			t.Fatal(err)
		}
		t.Run(name, func(t *testing.T) {
			t.Parallel()
			err := runTest(testCase, servicePool, cache, false, false)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}
