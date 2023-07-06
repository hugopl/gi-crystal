#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

/**
 * TEST_IGNORED_CONSTANT:
 * A constant ignored in the binding config.
 */
#define TEST_IGNORED_CONSTANT 123

/**
 * TEST_NON_IGNORED_CONSTANT:
 * A constant.
 */
#define TEST_NON_IGNORED_CONSTANT 123

/**
 * TEST_BOOLEAN_TRUE_CONSTANT:
 * A boolean constant with true value
 */
#define TEST_BOOLEAN_TRUE_CONSTANT TRUE

/**
 * TEST_BOOLEAN_FALSE_CONSTANT:
 * A boolean constant with false value
 */
#define TEST_BOOLEAN_FALSE_CONSTANT FALSE

G_END_DECLS
