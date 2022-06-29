#include "test_iface_vfuncs.h"
#include <stdio.h>

#include "test_subject.h"

G_DEFINE_INTERFACE(TestIfaceVFuncs, test_iface_vfuncs, G_TYPE_OBJECT)

static void test_iface_vfuncs_default_init(TestIfaceVFuncsInterface* iface) {
}

void test_iface_vfuncs_call_vfunc(TestIfaceVFuncs* self, const char* name) {
  g_return_if_fail(TEST_IS_IFACE_VFUNCS(self));

  TestIfaceVFuncsInterface* iface = TEST_IFACE_VFUNCS_GET_IFACE(self);
  g_return_if_fail(iface);

  if (!strcmp(name, "vfunc_basic")) {
    g_return_if_fail(iface->vfunc_basic);
    iface->vfunc_basic(self, 1, 2.2, 3.3, "string", G_OBJECT(test_subject_new_from_string("hey")));
  } else
    g_warning("bad vfunc name: %s", name);
}
