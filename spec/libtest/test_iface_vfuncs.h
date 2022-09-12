#pragma once

#include <glib-object.h>

#include "test_regular_enum.h"

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

  /**
   * TestIfaceVFuncsInterface::vfunc_return_string
   * @self: Self
   */
  char* (*vfunc_return_string)(TestIfaceVFuncs* self);

  /**
   * TestIfaceVFuncsInterface::vfunc_bubble_up
   * @self: Self
   */
  guint32 (*vfunc_bubble_up)(TestIfaceVFuncs* self);

  /**
   * TestIfaceVFuncsInterface::vfunc_bubble_up_with_args
   * @self: Self
   * @a: A uint32
   */
  guint32 (*vfunc_bubble_up_with_args)(TestIfaceVFuncs* self, guint32 a);

  /**
   * TestIfaceVFuncsInterface::vfunc_return_enum
   * @self: Self
   */
  TestRegularEnum (*vfunc_return_enum)(TestIfaceVFuncs* self);
};

/**
 * test_iface_vfuncs_call_vfunc:
 * @self: Self.
 * @name: Name of vfunc to call.
 * Returns: (nullable): A String representing the value returned by the vfunc
 *
 * Used to test vfunc call of vfuncs without activators, see the implementation for possible values for @name.
 */
gchar* test_iface_vfuncs_call_vfunc(TestIfaceVFuncs* self, const char* name);

G_END_DECLS
