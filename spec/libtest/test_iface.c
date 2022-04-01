#include "test_iface.h"
#include <stdio.h>

G_DEFINE_INTERFACE(TestIface, test_iface, G_TYPE_OBJECT)

typedef enum {
  IFACE_INT32_SIGNAL = 1,
  N_SIGNALS
} TestSubjectSignals;

static guint obj_signals[N_SIGNALS] = {
  0,
};

static void test_iface_default_init(TestIfaceInterface* iface) {
  GParamSpec* float64_prop = g_param_spec_double("float64", "Float64", "A double (float64) property.", 0.0, DBL_MAX, 0.0,
                                                 G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  g_object_interface_install_property(iface, float64_prop);

  // Register signals
  /**
   * TestIface::variant:
   * @int: a integer 32 bits.
   */
  obj_signals[IFACE_INT32_SIGNAL]
    = g_signal_new("iface_int32", G_TYPE_FROM_CLASS(iface), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
                   0, // class_offset
                   NULL, // accumulator
                   NULL, // accumulator data
                   NULL, // C marshaller
                   G_TYPE_NONE, // return_type
                   1, // n_params
                   G_TYPE_INT, NULL);
}

TestIface* test_iface_return_myself_as_interface(TestIface* self) {
  g_return_val_if_fail(TEST_IS_IFACE(self), self);

  TestIfaceInterface* iface = TEST_IFACE_GET_IFACE(self);
  return iface->return_myself_as_interface(self);
}

void test_iface_interface_class_method() {
}
