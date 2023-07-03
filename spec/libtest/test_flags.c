#include "test_flags.h"

// There no doc how to use glib-mkenums withotu meson or autotool, so fuck it...
GType test_flag_flags_get_type() {
  static gsize static_g_define_type_id = 0;

  if (g_once_init_enter(&static_g_define_type_id)) {
    static const GFlagsValue values[] = { { TEST_FLAG_OPTION1, "TEST_FLAG_OPTION1", "option1" },
                                          { TEST_FLAG_OPTION2, "TEST_FLAG_OPTION2", "option2" },
                                          { TEST_FLAG_ALL, "TEST_FLAG_ALL", "all" },
                                          { 0, NULL, NULL } };
    GType g_define_type_id = g_flags_register_static(g_intern_static_string("TestFlagFlags"), values);
    g_once_init_leave(&static_g_define_type_id, g_define_type_id);
  }

  return static_g_define_type_id;
}

GType test_empty_flags_get_type() {
  static gsize static_g_define_type_id = 0;

  if (g_once_init_enter(&static_g_define_type_id)) {
    static const GFlagsValue values[] = { { TEST_EMPTY_NONE, "TEST_EMPTY_NONE", "none" }, { 0, NULL, NULL } };
    GType g_define_type_id = g_flags_register_static(g_intern_static_string("TestEmptyFlags"), values);
    g_once_init_leave(&static_g_define_type_id, g_define_type_id);
  }

  return static_g_define_type_id;
}

GType test_ignored_flags_get_type() {
  static gsize static_g_define_type_id = 0;

  if (g_once_init_enter(&static_g_define_type_id)) {
    static const GFlagsValue values[]
      = { { TEST_IGNORED_FLAGS_VALUE, "TEST_IGNORED_FLAGS_VALUE", "value" }, { 0, NULL, NULL } };
    GType g_define_type_id = g_flags_register_static(g_intern_static_string("TestIgnoredFlags"), values);
    g_once_init_leave(&static_g_define_type_id, g_define_type_id);
  }

  return static_g_define_type_id;
}
