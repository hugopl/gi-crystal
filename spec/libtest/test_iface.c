#include <stdio.h>
#include "test_iface.h"

G_DEFINE_INTERFACE(TestIface, test_iface, G_TYPE_OBJECT)

static void test_iface_default_init (TestIfaceInterface *iface)
{
    /* add properties and signals to the interface here */
}

TestIface *test_iface_return_myself_as_interface(TestIface  *self) {
  g_return_val_if_fail(TEST_IS_IFACE(self), self);

  TestIfaceInterface* iface = TEST_IFACE_GET_IFACE(self);
  return iface->return_myself_as_interface(self);
}
