![Build Status](https://github.com/hugopl/gi-crystal/actions/workflows/ci.yml/badge.svg?branch=main)

# GI Crystal

GI Crystal is a binding generator used to generate Crystal bindings for GObject based libraries using
[GObject Introspection](https://gi.readthedocs.io/en/latest/).

If you are looking for GTK4 bindings for Crystal, go to [GTK4](https://github.com/hugopl/gtk4.cr)

I wrote this while studying GObject Introspection to contribute with [crystal-gobject](https://github.com/jhass/crystal-gobject)
but at some point I decided to take a different approach on how to generate the bindings, so I started this.

Besides the binding generator this shard provides bindings for GLib, GObject and Gio libraries.

## Installation

You are probably looking for the [GTK4](https://github.com/hugopl/gtk4.cr) shard, not this one, since this shard is only
useful if you are creating a binding for a GObject based library.

1. Add the dependency to your `shard.yml`:

   ```yaml
   developer_dependencies:
     gtk:
       github: hugopl/gi-crystal
   ```

2. Run `shards install`
3. Run `./bin/gi-crystal` to generate the bindings.

## Usage

Bindings are specified in [binding.yml](BINDING_YML.md) files. When you run the generator it will scan all `binding.yml`
files under the project directory and generate the bindings at `lib/gi-crystal/src/auto/`.

The generator is compiled in a _post-install_ task and can be found at `bin/gi-crystal` after you run `shards install`.

See https://github.com/hugopl/gtk4.cr for an example of how to use it.

If you want to use just GLib, GObject or Gio bindings do:

```Crystal
require "gi-crystal/glib"    # Just GLib bindings
require "gi-crystal/gobject" # GLib and GObject bindings
require "gi-crystal/gio"     # GLib, GObject and Gio bindings
```

## Memory Management ❤️‍🔥️

Crystal is a garbage collected language, you create objects and have faith that the GC will free them at some point in time,
while on the other hand GLib uses reference count, the clash of these two approaches of how to deal with memory management
can't end up in something beautiful without corner cases, etc... but we try our best to reduce the mess.

The basic rules are:

- All objects (except enums, flags and unions) are created in the heap (including non GObject C Structs).
- Boxed structs (except GValue) are always allocated by GLib but owned by Crystal wrappers.
- If the struct is passed from C to Crystal with "transfer none", the struct is copied anyway to ensure that every Crystal object
  wrapper always points to valid memory. On "transfer full" no copy is needed.
- All Crystal GObject wrappers have just a pointer to the C object (always allocated by GLib) and always hold a reference during their lifetime.

If you don't know what means `Transfer full`, `Transfer none` and few other terms about GOBject introspection, is worth to
[read the docs](https://gi.readthedocs.io/en/latest/annotations/giannotations.html#memory-and-lifecycle-management).

### Debugging

To help debug memory issues you can compile your code with `-Ddebugmemory`, this will print the object address and reference
counter to STDOUT when any wrapper object finalize method is called.

## How GObject is mapped to Crystal world

Despite of being written in a language that doesn't have object oriented features, GObject is an object oriented library by design so many things maps easily to OO languages. However each language has its way of doing things and some adaptation is always needed to have a better blending and let the bindings feels more native to the language.

### Class names

Class names do not have the module prefix, i.e. `GFile` from `GLib` module is mapped to `GLib::File`, `GtkLabel` is be mapped to `Gtk::Label`,
where `GLib` and `Gtk` are modules.

### Interfaces

GObject interfaces are mapped to Crystal modules + a dummy class that only implements this module, used when there's some
function returning the interface.

### Down Casts

If the object was created by Crystal code you can cast it like you do with any Crystal object instance, using `.as?` and `.as`.

If the object was created by C code, e.g. `Gtk::Builder` where you get everything as a `GObject::Object` instance, Crystal type system doesn't knows the exact type of the object in GObject type system so you need to cast it using `ClassName.cast(instance)` or `ClassName.cast?(instance)`. `.cast` throws a `TypeCastError` if the cast can't be made while `.cast?` just returns `nil`.

```Crystal
  builder = Gtk::Builder.new_from_string("...") # Returns a Gtk::Object
  label = Gtk::Label.cast(builder["label"])
```

## Signal Connections

Suppose you want to connect the `Gtk::Widget` `focus` signal, the C signature is:

```C
gboolean
user_function (GtkWidget       *widget,
               GtkDirectionType direction,
               gpointer         user_data)
```

The `user_data` parameter is used internally by bindings to pass closure data, so forget about it.

All signals are translated to a method named `#{signal_name}_signal`, that returns the signal object, the `_signal` suffix
exists to solve name conflicts like `Gtk::Window` `destroy` method and `destroy` signal.

So there are 3 ways to connect this signal to a callback:

```Crystal
def slot_with_sender(widget, direction)
  # ...
end
# Connect to a slot with all arguments
widget.focus_signal.connect(->slot_with_sender(Gtk::Widget, Gtk::Direction)

def slot_without_sender(direction)
  # ...
end
# Connect to a slot without the sender
widget.focus_signal.connect(->slot_without_sender(Gtk::Direction)

# Connect to a block (always without sender parameter)
widget.focus_signal.connect do |direction|
  # ...
end
```

If the signal requires a slot that returns nothing, a slot that returns nothing (Nil) must be used, this is a limitation of the current
implementation that will probably change in the future to just ignore the return value on those slots.

### After signals

Use the after keyword argument:

```Crystal
# Connect to a slot without the sender
widget.focus_signal.connect(->slot_without_sender(Gtk::Direction), after: true)

# Connect to a block (always without sender parameter)
widget.focus_signal.connect(after: true) do |direction|
  # ...
end
```

### Signals with details

```
# To connect the equivalent in C to "notify::my_property" do
widget.notify_signal["my_property"].connect do
  # ...
end
```
### Disconnecting signals

When you connect a signal it returns a `GObject::SignalConnection` object, call the disconnect method on it and it's done.

⚠️ Objects with signals connections will never be garbage collected, so remember to disconnect all signals from your object
if you want to really free up that beloved memory.

## GValue

When returned by methods or as signal parameters they are represented by `GObject::Value` class, however if a method accepts a
GValue as parameter you can pass any supported value. I.e. you can pass e.g. a plain Int32 to a method that in C expects a GValue.

## GObject inheritance

You can inherit GObjects, when you do so a new type is registered in GObject type system.

Crystal objects that inherit `GObject` returns the same object reference on casts, i.e. no memory allocation is done.
For more examples see the [inheritance tests](spec/inheritance_spec.cr).

## Declaring GObject signals

You can declare signals in your `GObject::Object` derived class using the `signal` macro, e.g.:

```Crystal
class Foo < GObject::Object
  signal my_signal_without_args
  signal my_signal(number : Int32, some_float : Float32)
end

# Using the signal
foo = Foo.new
foo.my_signal_without_args_signal.connect { puts "Got signal!" }
foo.my_signal_signal.connect { |a, b| puts "Got signal with #{a} and #{b}!" }

# emitting signals
foo.my_signal_without_args_signal.emit
foo.my_signal_signal.emit(42, 3.14)
```

⚠️ Meanwhile signals only support parameters of Integer, Float, String and Boolean types.

Also note that String parameters will be copied for each signal receiver, this is because the String goes to C, then back to
Crystal as a `const char*` pointer. This may change in the future.

## Declaring GObject properties

GObject Properties are declared using the `GObject::Property` annotation on the instance variable.

### Virtual Methods

Virtual methods must have the `GObject::Virtual` annotation, currently only virtual methods from interfaces are supported.

```Crystal
class Widget0 < Gtk::Widget
  @[GObject::Virtual]
  def snapshot(snapshot : Gtk::Snapshot)
  end
end

class Widget2 < Gtk::Widget
  # If there's a name conflict you can name your method whatever you want and use the name annotation attribute.
  @[GObject::Virtual(name: "snapshot")]
  def heyho(snapshot : Gtk::Snapshot)
  end
end
```

If for some reason (peformance or GICrystal bugs 🙊️) you don't want wrappers, you can create an unsafe virtual method:

```Crystal
class Widget3 < Gtk::Widget
  @[GObject::Virtual(unsafe: true)]
  def snapshot(snapshot : Pointer(Void))
    # User is responsible for memory management here, like in C.
  end
end
```

## GLib GError

GI-Crystal translates all GLib errors to different exceptions.

Example: `G_FILE_ERROR_EXIST` is a GLib error from domain `FILE_ERROR` with the code name `EXIST`, GICrystal translates this
in these the following exception classes:

```Crystal
module GLib
  class GLibError < RuntimeError
  end

  class FileError < GLibError
    class Exist < FileError
      def code : Int32
        # ...
      end
    end
    # ...
  end
end
```

So if you want to rescue from this specific error you must `rescue e : GLib::FileError::Exist`, if you want to rescue from any
error in this domain you must `rescue e : GLib::FileError`, and finally if you want to rescue from any GLib errors you do
`rescue e : GLib::GLibError`.

## Gio Async Pattern

All `*_async` methods with a `*_finish` methods receive a block, the block works as the `Gio::AsyncReadyCallback` and you need
to call the `*_finish` on the `result`, exceptions are raised by the `*_finish` functions on errors.

Example:

```Crystal
file = Gio::File.new_for_path("/my/nice/file")
file.read_async(0, nil) do |obj, result|
  obj.as(Gio::File).read_finish(result)
end
```

## Raw C Structs

At [binding.yml](BINDING_YML.md) file you can define the strategy used to bind the structs, if set to `auto`it will behave
like lsited bellow:

- If the struct have no pointer attributes it's mapped to a Crystal struct with the same memory layout of the C struct
  (`stack_struct` binding strategy).
- If the struct have pointer attributes it's mapped to a Crystal class with the same memory layout of the C struct, so a
  `finalize` method can be implemented to free the resources. Not that no setters are generated to pointer attributes, since
  we can't guess how this memory must be handled (`heap_struct` binding strategy).
- If the struct is a opaque pointer it's mapped to a Crystal class with a pointer to the C object, it's assumed that the
  object is a GObject Box, so the `g_boxed_*` family of functions are used to handle the memory (`heap_wrapper_struct`
  binding strategy).

## Contributing

See [HACKING.md](HACKING.md) for details about how the generator works.

1. Fork it (<https://github.com/hugopl/gi-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Hugo Parente Lima](https://github.com/hugopl) - creator and maintainer
