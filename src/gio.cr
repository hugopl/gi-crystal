require "./gi-crystal"

# When testing gi-crystal it generates the bindings at ./generated, so if
# applications want to ship the ./lib in their releases there will be no problems
# since only ./src/generated is on .gitignore.
{% if file_exists?("#{__DIR__}/generated/gio-2.0/gio.cr") %}
  require "./generated/gio-2.0/gio"
{% else %}
  require "./auto/gio-2.0/gio"
{% end %}
