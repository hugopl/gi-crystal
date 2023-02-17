require "./gi_crystal/closure_data_manager"
require "./gi_crystal/util"

module GICrystal
  # A macro to check if a binding was generated and require it
  macro require(namespace, version)
    {% req_path = "#{__DIR__}/auto/#{namespace.underscore.id}-#{version.underscore.id}/#{namespace.underscore.id}.cr" %}
    {% unless file_exists?(req_path) %}
      {{ raise "Bindings for #{namespace.id}-#{version.id} not yet generated, run ./bin/gi-crystal first." }}
    {% end %}
    require {{ "gi-crystal/src/auto/#{namespace.underscore.id}-#{version.id}/#{namespace.underscore.id}" }}
  end
end
