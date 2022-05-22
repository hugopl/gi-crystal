# What's it?

Bindings in GI Crystal are defined in files named `binding.yml`, each yml file can define a single GObject namespace.

It's not necessary to write `binding.yml` files for namespace dependencies.

Examples on how to define a binding can be found at [GLib](src/bindings/g_lib/binding.yml) and [GObject](src/bindings/g_object/binding.yml) bindings.

# Supported keys

While gi-crystal remains in 0.x version this spec can change from one version to another.

## namespace

GObject namespace this file describes.

## version

Version of the GObject namespace this file describes.

## include

List of extra files that must be included in the binding, the generator will add an `require` call for each of then at the end of module definition.

## include_before

List of extra files that must be included in the binding, the generator will add an `require` call for each of then at the end of module definition *before* the inclusion of the wrappers.

## handmade

List of types that are going to be handmade. The generator does not generate implementation for handmade types since they are
 handmade by you 😉️.

## ignore

List of types and/or functions the generator will ignore. For types it does not generate any implementation and emit warnings
when some other function uses them. For functions the function/method is just not generated in bindings.

Functions must use the full C function name without arguments, Types must use the type name without the namespace prefix, i.e. `GPrivate` is just `Private`.
