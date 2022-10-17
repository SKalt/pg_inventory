# Contributing

Please do!

## Bug reports, feature requests

To report a bug or request a feature, please [create an issue][new-issue].
Make sure to search [for similar existing issues][issues] first.
Bug reports should contain steps to reproduce the bug, the expected behavior, as well as an explanation of how to tell which behavior is correct.
Similarly, feature request should include a breakdown of the desired new behavior and what that new behavior would let you do.

## Bug fixes, new features, or refactoring

Please [create an issue][new-issue] prior to starting work.
To develop, [create a fork of this repo][new-fork] and create a branch.
Prior to submitting a PR, make sure to run tests:

```sh
make ls-lint # check file naming conventions
make bin/test_query && bin/test_query ./db_object_kind # run tests serially
```

Finally, submit a PR referencing your issue.

## SQL Style guide

- `snake_case` names
- commas first
- try to wrap expressions that would overflow 80 columns
- comments should fold with the block they're documenting, e.g.

```sql
  , thing.to_document
    -- would get folded under the thing to document
```

- mildly prefer `--` comments

[issues]: https://github.com/skalt/pg_inventory/issues/
[new-issue]: https://github.com/SKalt/pg_inventory/issues/new/choose
[new-fork]: https://github.com/SKalt/pg_inventory/fork
