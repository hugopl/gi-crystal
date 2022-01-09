# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
## Changed
- Binding configuration now must be in binding.yml files.
- Command line no more need config paths, etc. gi-crystal can detect all bindings in the project and generate them.
- Need to run bin/gi-crystal manually before compile any project usign gi-crystal.
- Binding extra files are no longer copied into to generated output dir, but included directly.
- All generated files are now created under `lib/gi-crystal/src/auto/<module_dir>` by default.

## [0.2.0] - 2022-01-09
### Fixed
- Interfaces returned by methods can be used in GValues.
- Append `?` to property getters that starts with `is_`.
- Constructors with transfer none proper handle reference counting.
- Always use fully qualified names on property return types

### Added
- `-Ddebugmemory` compiler option can be used to debug `finalize` calls.

## [0.1.0] - 2021-10-15
 - First Release.
