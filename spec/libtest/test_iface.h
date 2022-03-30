#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

#define TEST_TYPE_IFACE test_iface_get_type()

G_DECLARE_INTERFACE(TestIface, test_iface, TEST, IFACE, GObject)

struct _TestIfaceInterface {
  GTypeInterface parent_iface;

  TestIface* (*return_myself_as_interface)(TestIface* self);
};

/**
 * test_iface_return_myself_as_interface
 * Returns: (transfer none):
 */
TestIface* test_iface_return_myself_as_interface(TestIface* self);

/**
 * test_iface_interface_class_method:
 */
void test_iface_interface_class_method();

G_END_DECLS
