# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Changes that change the generated API have a ⚠️.

## [0.17.0] 2023-07-14
### Added
- Annotate deprecated methods in bindings (#114).
- Add `#to_s`, `#==` and `.parse` to `GLib::Variant` (#113).
- Add GC resistant GObject subclasses 🎉️, thanks @BlobCodes (#107).
- Allow enum and flags to be ignored in binding.yml (#101).
- Print GI annotation info for vfunc, helping debugging.

### Fixed
- Bind false boolean constants to false (#111).
- Ensure Bool return type on vfuncs that return booleans (#110).
- Fix ownership transfer of vfunc return values (#102).
- Fix compilation for vfuncs returning nullable objects or strings (#104).

### Changed
- Ignore deprecated `GObject::ValueArray` object. (#115)

## [0.16.0] 2023-06-16
### Added
- Add test helper methods: `ClosureDataManager.count`, `ClosureDataManager.info` and `ClosureDataManager.deregister_all` (#92).
- Added bindings for `GLib.real_name` (#93).
- Added option to ignore constants in binding generation, thanks @charitybell (#95)

### Fixed
- Fix compilation with `-Ddebugmemory` for some struct bindings (#91).
- Convert boolean return values in virtual functions (#96).

### Changed
- Removed a lot of constants from GLib and GObject bindings (#97).

## [0.15.3] 2023-05-31
### Fixed
- Let struct bindings allocated on help to obey `-Ddebugmemory` flag.
- Translate GTK doc parameter markup to crystal doc style.

### Changed
- Removed version_from_shard dependency.

## [0.15.2] 2023-04-16
### Added
- Added declaration of `LibGLib.g_bytes_new_static`, used internally by other modules.

## [0.15.1] 2023-03-10
### Added
- Show Crystal version on generator logs.
- Support `Path` objects in signals, they are exposed as C strings to C code.

### Fixed
- Fix `GLib::SList` of modules (GObject interfaces) (#68).
- Fix `GLib::SList` of `GObject::Object`.
- Fix `GLib::List` of modules.
- Fix `GLib::List` of `GObject::Object`.
- Fix signals with modules (GObject interfaces) parameters.
- Do not use relative paths on `GiCrystal.require` macro (#70).
- Fix binding generation for modules with no errors that doesn't depend on GLib (#79).

## [0.15.0] 2023-01-15
### Fixed
- Fix callback generation of callbacks without user_data paramenter as last parameter (#63).
- Fix signal boolean parameters (#66).
- Allow chaining up unsafe vfuncs, thanks @BlobCodes.

## [0.14.0] 2022-09-02
### Added
- Added support to declare GObject properties in Crystal classes 🎉️, thanks @BlobCodes (#44).
- Added possibility to ignore some struct fields in binding generation (#58).
- Crystalize even more docs, thanks @GeopJr (#62).

### Fixed
- Enum and flags `#g_type` method now works (#56).
- Convert return values of vfuncs (#60).

### Changed
- Changed format of `binding.yml` file for better flexibility.
- Generate bindings for POD structs as Crystal structs (#58).
- Doc comments generation is now disabled by default (#59).

## [0.13.1] 2022-07-04
### Added
- Added option to complete ignore functions (i.e. ignore new added HarfBuzz functions that broke the generator).

## Fixed
- Fixed naming of virtual functions, now they can have any name.
- Correct generate code for structs with static array of structs, thanks @BlobCodes.

## [0.13.0] 2022-06-30
### Added
- Property constructors can be called in constructor super calls from user classes, e.g. `super(property: value)`.
- Show if return value is nullable in generated code, helping debug.
- Implement virtual functions and allow including interfaces, thanks @BlobCodes (#26).
- Implement unsafe virtual functions, thanks @BlobCodes (#41).
- Implement user-transparent GObject enums, thanks @BlobCodes

### Changed
- Use `GC.malloc_atomic` to allocate wrappers to reduce GC work, thanks @BlobCodes (#18).
- Move struct wrappers data inside struct, reducing 1 malloc call, thanks @BlobCodes (#19).
- Translate GError in return values or signal parameters to exception objects. (#25)
- Raise a compile error when using `GObject::ParamSpec.g_type`. (#24)
- Print info about ClosureDataManager when compiling using -Ddebugmemory.
- `GObject::GeneratedWrapper` annotation is now `GICrystal::GeneratedWrapper`.

### Fixed
- Don't use invalid characters when registering GObject types, thanks @BlobCodes (#30)
- Allow binding objects with functions named initialize/finalize, thanks @BlobCodes (#42)

## [0.12.0] 2022-06-04
### Added
- Signals can now be disconnected, `connect` method returns a `GObject::SignalConnection` object.
  - Disconnect signals from an object is important to let them be collected by the GC.
- Raises a compile time error if trying to inherit from a final GObject type.
- Initial support for user defined signals 🎉️, current supported parameter types are `Number`, `String` and `Boolean`.

### Changed
- `GLib::Bytes#data` now returns a `Slice(UInt8)` instead of `Enumerator(UInt8)`.
- `GLib::Bytes` constructor can accept any pointer + size in constructor, unsafe but doesn't copy data.
- Removed all `GObject::ParamSpec` subclasses, they don't need to be exposed in bindings, `GObject::ParamSpec` is enough.
- Requires crystal compiler version >= 1.4.1.

### Fixed
- Don't generate code for constructors with empty parameters (generic constructor will work).


## [0.11.0] 2022-05-18
### Added
- Allow user objects inheriting GObject to have custom constructors.
- Support signals with array of GObjects.
- Support signals with array of GObjetct Interfaces.
- Support signals with boxed structs.
- Support signals with enums.

### Fixed
- Avoid copy strings when creating quarks to store object qdata.
- Fix signals with nullable strings.
- Don't use `self` on method implementations, so they can be used in constructors before instance variables be set.

## [0.10.0] 2022-05-02
### Added
- Callback parameters are now supported.
- Fixed size array parameters raises `ArgumentError` if the size is less than the expected size.

### Fixed
- User classes can inherit from classes with size bigger than `GObject::Object` (e.g. `Gtk::Widget`).
- Methods with nilable handmade types (GValue/GVariant) in parameters now works.
- Strings in structs now works.
- Signals with return types now works.
- Methods named `initialize` are now correctly binded to `_initialize`, thanks @GeopJr.
- Fixed parameters of fixed size arrays.
- Fix `make doc`.

### Changed
- Wrapper instances are now re-used and shared, so all variables wrapping the same GObject now share the same address and hold
  just 1 reference to the GObject, this mean some things:

  - A lot less memory allocations! 🎉️.
  - Ordinary Crystal casts will work for Objects created from Crystal code and you rarely will need to use the `.cast` method.

## [0.9.0] 2022-04-17
### Added
- Add support to subclass a GObject 🎉️.

### Fixed
- Fixed memory leak in GObject proeprty constructors.
- Fixed crash when trying to free memory of C arrays in return values.
- Fixed problems with floating references.

## [0.8.0] 2022-04-14
### Added
- Module functions are generated.
- Very basic support for GObject subclassing.

### Fixed
- `g_main_context_invoke`, `g_main_context_invoke_full` and `g_closure_invoke` got the right `@[Raises]` annotation.
- Don't raise an exception if the C library creates an enum or flag with an invalid value (i.e. with reserved fields).
- Fix assignment of false value for boolean properties in constructor.
- Fixed problems with GObject float references.

### Changed
- ⚠️ `GObject::ParamSpec` if back on bindings, so notify signals need to declare it again.
- Some more functions were removed from the bindings, see commit `bd3cf6a3f96c5cb60796ef11ccceea242f4625cb` and `2194662ca53648972787c507e0d5e010253f218b`.
- Removed ameba development dependency.

## [0.7.0] 2022-04-03
### Added
- Better code blocks in documentation, thanks @GeopJr.
- It's possible to add `@[Raises]` annotation on functiosn that can executa a callback, thanks @BlobCodes.

### Fixed
- Structs with non pointers struct attributes works as expected.
- Structs comparisson now are made by `memcmp`.
- Use the correct unref function for GLib types.
- Fix Makefile to work with parallel jobs.
- Generate interface signals.

## [0.6.0] 2022-03-02
### Changed
- Bump required Crystal version to 1.3.2 since I'm only testing with this version 🤷️.

### Fixed
- Fix signals with nullable parameters.
- Fix methods returning arrays of primitive types of any kind.

## [0.5.0] 2022-02-18
### Added
- ⚠️ Implement functions that return non-null terminated array of strings.
- Added bindings for GLib::Bytes.

### Changed
- Convert compare-api tool to Crystal and improve it a lot, it will be a good tool to detect patches that break the API 😎️.
- Remove bindings for GLib `KeyFile` class, INI module in Crystal stdlib can replace it.

### Fixed
- `void*` return values in C are translated to `Pointer(Void)` instead of `Pointer(Nil)`.
- Constructors that may return `nil` now have the correct return type restriction.
- GObjetct flags with no elements are generated as a enum instead of a constant.

## [0.4.0] 2022-01-29
### Added
- Add `./bin/compare-api` script to compare APIs generated by two different versions of `gi-crystal`.
- Generate raw documentation for constants and enums.
- Print more GI annotations on generated code to ease debug.

### Changed
- Revert auto require of GObject module on gi-crystal since it makes the compiles require the file twice.

### Fixed
- ⚠️ Fix binding of functions with GError and more than one parameter.
- ⚠️ Constructor methods always return their own type despite the C function returns the parent type or not.

## [0.3.0] - 2022-01-23
### Changed
- Binding configuration now must be in binding.yml files.
- Command line no more need config paths, etc. gi-crystal can detect all bindings in the project and generate them.
- Need to run bin/gi-crystal manually before compile any project usign gi-crystal.
- Binding extra files are no longer copied into to generated output dir, but included directly.
- All generated files are now created under `lib/gi-crystal/src/auto/<module_dir>` by default.
- GError are now translated to Crystal exceptions.
- GLib/GObject bindings are required when `gi-crystal` is required.

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
