#include "test_float_ref.h"

typedef struct {
  int foo;
} TestFloatRefPrivate;

G_DEFINE_TYPE_WITH_CODE(TestFloatRef, test_float_ref, G_TYPE_INITIALLY_UNOWNED, G_ADD_PRIVATE(TestFloatRef))

typedef enum {
  PROP_FOO = 1,
  N_PROPERTIES,
} TestFloatRefProperty;

static GParamSpec* obj_properties[N_PROPERTIES] = {
  NULL,
};

static void test_float_ref_set_property(GObject* gobject, guint property_id, const GValue* value, GParamSpec* pspec) {
  TestFloatRefPrivate* priv = test_float_ref_get_instance_private(TEST_FLOAT_REF(gobject));

  switch (property_id) {
  case PROP_FOO:
    priv->foo = g_value_get_int(value);
    break;
  default:
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_float_ref_get_property(GObject* gobject, guint property_id, GValue* value, GParamSpec* pspec) {
  TestFloatRefPrivate* priv = test_float_ref_get_instance_private(TEST_FLOAT_REF(gobject));

  switch (property_id) {
  case PROP_FOO:
    g_value_set_int(value, priv->foo);
    break;
  default:
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_float_ref_class_init(TestFloatRefClass* klass) {
  GObjectClass* object_class = G_OBJECT_CLASS(klass);

  object_class->set_property = test_float_ref_set_property;
  object_class->get_property = test_float_ref_get_property;

  obj_properties[PROP_FOO] = g_param_spec_int("foo", "Foo", "A foo property.", INT_MIN, INT_MAX, 0,
                                              G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  g_object_class_install_properties(object_class, N_PROPERTIES, obj_properties);
}

static void test_float_ref_init(TestFloatRef* self) {
}

GObject* test_float_ref_new() {
  return g_object_new(TEST_TYPE_FLOAT_REF, 0, NULL);
}

GObject* test_float_ref_new_with_foo(int foo) {
  return g_object_new(TEST_TYPE_FLOAT_REF, "foo", foo, NULL);
}
