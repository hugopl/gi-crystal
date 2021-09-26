#include <stdio.h>
#include "test_iface.h"

G_DEFINE_INTERFACE(TestIface, test_iface, G_TYPE_OBJECT)

static void test_iface_default_init (TestIfaceInterface *iface)
{
  GParamSpec* float64_prop = g_param_spec_double("float64", "Float64", "A double (float64) property.",
                                                 0.0, DBL_MAX, 0.0,
                                                 G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  g_object_interface_install_property(iface, float64_prop);
}

TestIface *test_iface_return_myself_as_interface(TestIface  *self) {
  g_return_val_if_fail(TEST_IS_IFACE(self), self);

  TestIfaceInterface* iface = TEST_IFACE_GET_IFACE(self);
  return iface->return_myself_as_interface(self);
}

void test_iface_interface_class_method()
{
}
