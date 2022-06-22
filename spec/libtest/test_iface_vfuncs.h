#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

#define TEST_TYPE_IFACE_VFUNCS test_iface_vfuncs_get_type()

G_DECLARE_INTERFACE(TestIfaceVFuncs, test_iface_vfuncs, TEST, IFACE_VFUNCS, GObject)

struct _TestIfaceVFuncsInterface {
  GTypeInterface parent_iface;

  /**
   * TestIfaceVFuncsInterface::vfunc_basic
   * @self: Self
   * @i: A int32
   * @f: A float32
   * @d: A double, a.k.a. float64
   * @s: A string
   * @o: (transfer full): An Test::Subject object.
   */
  void (*vfunc_basic)(TestIfaceVFuncs* self, int i, float f, double d, const char* s, GObject* o);
};

/**
 * test_iface_vfuncs_call_vfunc:
 * @self: Self.
 * @name: Name of vfunc to call.
 *
 * Used to test vfunc call of vfuncs without activators.
 */
void test_iface_vfuncs_call_vfunc(TestIfaceVFuncs* self, const char* name);

G_END_DECLS
