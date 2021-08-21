#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

/**
 * TestRegularEnum:
 * @TEST_VALUE1:
 * @TEST_VALUE2:
 * @TEST_VALUE3:
 */
typedef enum {
  TEST_VALUE1,
  TEST_VALUE2,
  TEST_VALUE3
} TestRegularEnum;

GType test_regular_enum_get_type();
#define TEST_TYPE_REGULAR_ENUM test_regular_enum_get_type()

G_END_DECLS
