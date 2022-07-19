require "./struct_gen"

module Generator
  class HeapStructGen < StructGen
    def initialize(info : StructInfo)
      super(info)
    end
  end
end
