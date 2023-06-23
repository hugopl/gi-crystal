#include "test_regular_enum.h"

GType test_regular_enum_get_type() {
  static gsize static_g_define_type_id = 0;

  if (g_once_init_enter(&static_g_define_type_id)) {
    static const GEnumValue values[] = { { TEST_VALUE1, "TEST_VALUE1", "value1" },
                                         { TEST_VALUE2, "TEST_VALUE2", "value2" },
                                         { TEST_VALUE3, "TEST_VALUE3", "value3" },
                                         { 0, NULL, NULL } };
    GType g_define_type_id = g_enum_register_static(g_intern_static_string("TestRegularEnum"), values);
    g_once_init_leave(&static_g_define_type_id, g_define_type_id);
  }

  return static_g_define_type_id;
}

GType test_ignored_enum_get_type() {
  static gsize static_g_define_type_id = 0;

  if (g_once_init_enter(&static_g_define_type_id)) {
    static const GEnumValue values[] = { { TEST_IGNORED_VALUE, "TEST_IGNORED_VALUE", "value" }, { 0, NULL, NULL } };
    GType g_define_type_id = g_enum_register_static(g_intern_static_string("TestIgnoredEnum"), values);
    g_once_init_leave(&static_g_define_type_id, g_define_type_id);
  }

  return static_g_define_type_id;
}
