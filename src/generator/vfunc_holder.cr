require "./vfunc_gen"

module Generator
  module VFuncHolder
    macro render_vfuncs
      strinfo = struct_info
      if strinfo
        object.vfuncs.each do |vfunc|
          gen = VFuncGen.new(strinfo, vfunc)
          gen.generate(io) unless gen.skip?
        end
      end
    end

    private abstract def struct_info
  end
end
