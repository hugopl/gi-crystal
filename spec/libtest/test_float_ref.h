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

  // These padding here are just to let this struct be bigger than GObjectClass and be sure we are registering the types
  // using the right struct sizes.
  int padding0;
  int padding1;
  int padding2;
  int padding3;
  int padding4;
};

/**
 * test_float_ref_new:
 * Returns: (transfer none):
 *
 * Return a new FloatRef object
 */
GObject* test_float_ref_new();

/**
 * test_float_ref_new_with_foo:
 * @foo: value of foo property
 * Returns: (transfer none):
 *
 * Used to test custom constructors returning float references
 */
GObject* test_float_ref_new_with_foo(int foo);

G_END_DECLS
