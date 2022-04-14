#pragma once
#include <glib-object.h>

G_BEGIN_DECLS

/**
 * TestFloatRef:
 *
 * Used to test types that inherit `InitiallyUnowned`
 */
#define TEST_TYPE_FLOAT_REF test_float_ref_get_type()
G_DECLARE_DERIVABLE_TYPE(TestFloatRef, test_float_ref, TEST, FLOAT_REF, GInitiallyUnowned)

struct _TestFloatRefClass {
  GInitiallyUnownedClass parent_class;
};

/**
 * test_float_ref_new:
 *
 * Return a new FloatRef object
 */
GObject* test_float_ref_new();

G_END_DECLS
