# GI Crystal

GI Crystal is a binding generator used to generate Crystal bindings for GObject based libraries using
[GObject Introspection](https://gi.readthedocs.io/en/latest/).

If you are looking for GTK4 bindings for Crystal, go to [GTK4](https://github.com/hugopl/gtk4.cr)

I wrote this while studying GObject Introspection to contribute with [crystal-gobject](https://github.com/jhass/crystal-gobject)
but at some point I decided to take a different approach on how to generate the bindings, so I started this.

## Installation

You are probably looking for the [GTK4](https://github.com/hugopl/gtk4.cr) shard, not this one, since this shard is only
useful if you are creating a binding to a GObject based library.

1. Add the dependency to your `shard.yml`:

   ```yaml
   developer_dependencies:
     gtk:
       github: hugopl/gobj-bind-gen
   ```

2. Add the dependency to your `shard.yml`:
2. Run `shards install`

## Usage

See https://github.com/hugopl/gtk4.cr/blob/master/shard.yml for an example of how to use it.

## Memory Management ❤️‍🔥️

Crystal is garbage collected, you create objects and have faith that the GC will free them at some point while GLib uses
reference count, the clash of these two approaches of how to deal with memory management can't end up is something beautiful
without corner cases, etc... but we try our best to reduce the mess.

The basic rules are:

- All objects (except enums, flags and unions) are created in the heap (including non GObject C Structs).
- Boxed structs are always allocated by GLib but owned by Crystal wrappers.
- If the struct is passed from C to Crystal with "transfer none", the struct is copied anyway to ensure that every Crystal object
  wrapper always points to valid memory. On "transfer full" no copy is needed.
- All GObjects have just a pointer to the C object (always allocated by GLib) and always hold a reference during their lifetime

### Interfaces

GObject interfaces are mapped to Crystal modules + a dummy class that only implements this module, used when there's some
function returning the interface.

### Casts

Upcasts must have no problems while downcasts must be done using `ClassName.cast(instance)`, e.g.: `Gtk::Widget.cast(gobj)`.

A cast just creates a new wrapper object, so it increases the object reference count and allocate memory for the Crystal object instance.

No GTK warnings are triggered on bad casts, but it's on my plans to raise an exception if the cast can't be done and add a `cast?` method.

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

# Connect to a block
widget.focus_signal.connect do |direction|
  # ...
end
```

If the signal requires a slot that returns nothing, a slot that returns nothing (Nil) must be used, this is a limitation of the current
implementation that will probably change in the future to just ignore the return value those slots.

### After signals

Instead of `widget.focus_signal.connect`, use `widget.focus_signal.connect_after`.

### Signals with details

```
# To connect the equivalent in C to "notify::my_property" do
widget.notify_signal["my_property"].connect do |param|
  # ...
end
```

## GValue

When returned by methods or as signal parameters they are represented by `GObject::Value` class, however if a method accepts a
GValue as parameter you can pass any supported value. I.e. you can pass e.g. a plain Int32 to a method that in C expects a GValue.

## GObject inheritance

- TBD

## Declaring GObject signals

- TBD

## Contributing

1. Fork it (<https://github.com/hugopl/gi-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Hugo Parente Lima](https://github.com/hugopl) - creator and maintainer
