module GObjectIntrospection
  class Repository
    @@namespaces = Hash(String, Namespace).new

    def self.require(namespace : String, version : String? = nil) : Namespace
      @@namespaces[namespace] ||= Namespace.new(namespace, version)
    end
  end
end
