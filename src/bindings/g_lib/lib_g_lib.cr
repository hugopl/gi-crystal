lib LibGLib
  # Functions not declared by GObj Introspection

  # Memory related functions
  fun g_malloc0(size : LibC::SizeT) : Void*
  fun g_free(mem : Void*)

  # GList
  fun g_list_length(list : List*) : UInt32
  fun g_list_free(list : List*)
  fun g_list_free_full(list : List*, free_func : Proc(Void*, Nil))
  fun g_list_first(list : List*) : List*
  fun g_list_last(list : List*) : List*
  fun g_list_nth(list : List*, n : UInt32) : List*

  # GSList
  fun g_slist_length(list : SList*) : UInt32
  fun g_slist_nth(list : SList*, n : UInt32) : SList*
  fun g_slist_free(list : SList*)
  fun g_slist_free_full(list : SList*, free_func : Proc(Void*, Nil))

  # GBytes
  # This function is used by some bindings of other modules like
  # GTK widget template and Gio GResource.
  fun g_bytes_new_static(data : Void*, size : LibC::SizeT) : Void*
end
