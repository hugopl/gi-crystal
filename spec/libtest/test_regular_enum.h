#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

/**
 * TestRegularEnum:
 * @TEST_VALUE1: First value.
 * @TEST_VALUE2: Second value.
 * @TEST_VALUE3: Third value.
 *
 * Used to test regular enums.
 */
typedef enum {
  TEST_VALUE1,
  TEST_VALUE2,
  TEST_VALUE3
} TestRegularEnum;

GType test_regular_enum_get_type();
#define TEST_TYPE_REGULAR_ENUM test_regular_enum_get_type()

/**
 * TestIgnoredEnum:
 * @TEST_IGNORED_VALUE:
 *
 * Used to test ignored enums.
 */
typedef enum {
  TEST_IGNORED_VALUE
} TestIgnoredEnum;

GType test_ignored_enum_get_type();
#define TEST_TYPE_IGNORED_ENUM test_ignored_enum_get_type()

G_END_DECLS
