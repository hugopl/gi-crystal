# What's it?

Bindings in GI Crystal are defined in files named `binding.yml`, each yml file can define a single GObject namespace.

It's not necessary to write `binding.yml` files for namespace dependencies.

Examples on how to define a binding can be found at [GLib](src/bindings/g_lib/binding.yml) and [GObject](src/bindings/g_object/binding.yml) bindings.

# Supported keys

While gi-crystal remains in 0.x version this spec can change from one version to another.

## namespace (string)

GObject namespace this file describes.

## version (string)

Version of the GObject namespace this file describes.

## include_before (list of strings)

List of extra files that must be included in the binding, the generator will add an `require` call for each of then at the end of module definition *before* the inclusion of the wrappers.

## require_after (list of strings)

List of extra files that must be included in the binding, the generator will add an `require` call for each of then at the end of module definition.

## lib_ignore (list of strings)

List of C functions that the generator will complete ignore, this means that it does not even generate
the C signature in the `lib` declaration.

This entry was created as a workaround for [issues](https://github.com/hugopl/gi-crystal/issues/53) generating bindings for
the HarfBuzz library, if you just want to not generate a binding for a specific function see _ignore_methods_ entry.

## execute_callback (list of strings)

List of C functions that may execute a callback, so the generator adds a `@[Raises]` annotation to it.

## ignore_constants (list of strings)

List of C `#define`s that the generator will ignore.

## types (list of BindingTypes)

List of types that require extra configuration, like be removed from generation, have methods removed, etc. Note that the
module name is considered a type, e.g. if you want to remove the C function `foo_bar` from module `Foo` bindings, you should
write:

```YAML
types:
  Foo:
    ignore_methods:
    - bar
```

# BindingTypes

## ignore (boolean)

If true, the type is ignored and no binding is generated for it, if the type is used in some method a warn is raised and the
method isn't generated.

## handmade (boolean)

If true, the type is handmade, the generator doesn't generate any code for it, methods using this type in the signature get
no type restrictions. This was create as an attempt to have flexible GValue and GVariant bindings.

## ignore_methods (list of strings)

List of methods the generator will not generate for this type, **you must use the function binding name, not the C symbol**,
so `g_object_ref` is just `ref` and if the GIR has a rename annotation, the renamed name must be used.

Even if the function is ignored here, their C signature still declared in the lib declaration, so you can write custom code that calls it.

## ignore fields (list of strings)

This is valid only for structs.

A list of fields in the structs that you don't want to create access for.

## binding_strategy (auto | stack_struct | heap_struct | heap_wrapper)

This is valid only for structs.

Plain structs are hard to bind properly, since the GIR information sometimes doesn't give a clear information about how the
structs must be used, so this flag allows the binding author to fine tune how the struct binding must be done, the possible
values are:

- `auto`: Let the generator choose what's better.
- `stack_struct`: Bind this as a Crystal struct, that is always allocated on stack.
- `heap_struct`: Bind this as a Crystal class with the C struct as attribute, so the struct is allocated on the heap and the
   memory is always copied to Crystal.
- `heap_wrapper`: Bind this as a Crystal class with a pointer to the C struct, like it's done got GObject types.
