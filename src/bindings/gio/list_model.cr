module Gio
  module ListModel
    def items_changed(position : Int, removed : Int, added : Int) : Nil
      items_changed(position.to_u32, removed.to_u32, added.to_u32)
    end
  end
end
