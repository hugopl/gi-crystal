#include "test_iface_vfuncs.h"
#include <stdio.h>

#include "test_subject.h"

G_DEFINE_INTERFACE(TestIfaceVFuncs, test_iface_vfuncs, G_TYPE_OBJECT)

static void test_iface_vfuncs_default_init(TestIfaceVFuncsInterface* iface) {
}

gchar* test_iface_vfuncs_call_vfunc(TestIfaceVFuncs* self, const char* name) {
  gchar* buffer = NULL;

  g_return_val_if_fail(TEST_IS_IFACE_VFUNCS(self), NULL);

  TestIfaceVFuncsInterface* iface = TEST_IFACE_VFUNCS_GET_IFACE(self);
  g_return_val_if_fail(iface, NULL);

  if (!strcmp(name, "vfunc_basic")) {
    g_return_val_if_fail(iface->vfunc_basic, NULL);

    iface->vfunc_basic(self, 1, 2.2, 3.3, "string", G_OBJECT(test_subject_new_from_string("hey")));
    buffer = g_strdup("void");
  } else if (!strcmp(name, "vfunc_return_string")) {
    g_return_val_if_fail(iface->vfunc_return_string, NULL);

    buffer = g_strdup(iface->vfunc_return_string(self));
  } else if (!strcmp(name, "vfunc_return_enum")) {
    g_return_val_if_fail(iface->vfunc_return_enum, NULL);

    TestRegularEnum enum_retval = iface->vfunc_return_enum(self);
    buffer = g_enum_to_string(TEST_TYPE_REGULAR_ENUM, enum_retval);
  } else
    g_warning("bad vfunc name: %s", name);

  return buffer;
}
