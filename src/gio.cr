require "./gi-crystal"

# I recommend applications to add /lib/ to their repositories, this because new
# versions of GTK libraries can break gi-crystal, so your source tarball won't
# work anymore. Shipping /lib/ will include not only all crystal dependencies
# sources but the generated GTK bindings.
#
# Then to update a shard dependency simpel do:
#
# rm -rf lib/
# shards update
# git add lib/
# git commit -m"Crystal dependencies updated."
{% if file_exists?("#{__DIR__}/generated/gio-2.0/gio.cr") %}
  require "./generated/gio-2.0/gio"
{% else %}
  require "./auto/gio-2.0/gio"
{% end %}
