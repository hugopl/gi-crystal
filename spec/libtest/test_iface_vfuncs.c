#include "test_iface_vfuncs.h"
#include <stdio.h>

#include "test_subject.h"

G_DEFINE_INTERFACE(TestIfaceVFuncs, test_iface_vfuncs, G_TYPE_OBJECT)

static guint32 test_iface_vfuncs_default_vfunc_bubble_up(TestIfaceVFuncs* iface) {
  return 0xDEADBEEF;
}

static guint32 test_iface_vfuncs_default_vfunc_bubble_up_with_args(TestIfaceVFuncs* iface, guint32 a) {
  return a + 1;
}

static void test_iface_vfuncs_default_init(TestIfaceVFuncsInterface* iface) {
  iface->vfunc_bubble_up = test_iface_vfuncs_default_vfunc_bubble_up;
  iface->vfunc_bubble_up_with_args = test_iface_vfuncs_default_vfunc_bubble_up_with_args;
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
  } else if (!strcmp(name, "vfunc_return_bool")) {
    g_return_val_if_fail(iface->vfunc_return_bool, NULL);

    gboolean bool_retval = iface->vfunc_return_bool(self);
    buffer = bool_retval ? g_strdup("true") : g_strdup("false");
  } else if (!strcmp(name, "vfunc_return_enum")) {
    g_return_val_if_fail(iface->vfunc_return_enum, NULL);

    TestRegularEnum enum_retval = iface->vfunc_return_enum(self);
    buffer = g_enum_to_string(TEST_TYPE_REGULAR_ENUM, enum_retval);
  } else if (!strcmp(name, "vfunc_bubble_up")) {
    g_return_val_if_fail(iface->vfunc_bubble_up, NULL);

    iface->vfunc_bubble_up(self);
    buffer = g_strdup("success");
  } else if (!strcmp(name, "vfunc_bubble_up_with_args")) {
    g_return_val_if_fail(iface->vfunc_bubble_up_with_args, NULL);

    iface->vfunc_bubble_up_with_args(self, 5);
    buffer = g_strdup("success");
  } else if (!strcmp(name, "vfunc_return_nullable_string")) {
    g_return_val_if_fail(iface->vfunc_return_nullable_string, NULL);

    buffer = iface->vfunc_return_nullable_string(self);
    if (!buffer)
      buffer = "NULL";
    buffer = g_strdup(buffer);
  } else if (!strcmp(name, "vfunc_return_nullable_obj")) {
    g_return_val_if_fail(iface->vfunc_return_nullable_obj, NULL);

    TestSubject* obj = iface->vfunc_return_nullable_obj(self);
    buffer = g_strdup(obj ? "Obj" : "NULL");
  } else if (!strcmp(name, "vfunc_return_transfer_full_obj")) {
    g_return_val_if_fail(iface->vfunc_return_transfer_full_obj, NULL);

    GObject* obj = G_OBJECT(iface->vfunc_return_transfer_full_obj(self));
    if (obj) {
      int ref_value = obj->ref_count;
      g_object_unref(obj);
      buffer = g_strdup_printf("%i", ref_value);
    } else
      buffer = g_strdup("NULL");
  } else
    g_warning("bad vfunc name: %s", name);

  return buffer;
}
