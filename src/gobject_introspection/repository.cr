module GObjectIntrospection
  class Repository
    @pointer : Pointer(LibGIRepository::Repository)
    @namespaces : Hash(String, Namespace)

    def self.default
      @@default ||= Repository.new(LibGIRepository.g_irepository_get_default)
    end

    def initialize(@pointer : Pointer(LibGIRepository::Repository))
      @namespaces = Hash(String, Namespace).new
    end

    def require(namespace : String, version : String? = nil) : Namespace
      @namespaces[namespace] ||= Namespace.new(namespace, version)
    end

    def find_by_name(namespace : String, name : String) : BaseInfo?
      ptr = LibGIRepository.g_irepository_find_by_name(self, namespace, name)
      BaseInfo.build(ptr) if ptr
    end

    def to_unsafe
      @pointer
    end
  end
end
