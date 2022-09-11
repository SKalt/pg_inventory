package main

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"
)

func getThisDir() string {
	_, file, _, _ := runtime.Caller(0)
	return filepath.Dir(file)
}

func TestSnapshots(t *testing.T) {
	repoRoot := filepath.Clean(filepath.Join(getThisDir(), "../.."))
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
	for _, testCase := range testCases {
		name, err := filepath.Rel(repoRoot, testCase.targetTsvPath())
		if err != nil {
			t.Fatal(err)
		}
		t.Run(name, func(t *testing.T) {
			t.Parallel()
			err := runTest(testCase, servicePool, false)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}
