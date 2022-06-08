require "./vfunc_gen"

module Generator
  module VFuncHolder
    macro render_vfuncs
      object.vfuncs.each do |vfunc|
        gen = VFuncGen.new(object, vfunc)
        gen.generate(io) unless gen.skip?
      end
    end
  end
end
