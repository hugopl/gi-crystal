require "./struct_gen"

module Generator
  class HeapWrapperStructGen < StructGen
    def initialize(info : StructInfo)
      super(info)
    end
  end
end
