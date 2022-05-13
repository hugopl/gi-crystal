#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

/**
 * BoxedStruct:
 * An example of GLib boxed struct.
 */
typedef struct _TestBoxedStruct TestBoxedStruct;

#define TEST_TYPE_BOXED_STRUCT (test_boxed_struct_get_type())

GType test_boxed_struct_get_type(void);

/**
 * test_boxed_struct_copy:
 * @obj:
 * Returns: newly allocated TextBoxedStruct
 */
TestBoxedStruct* test_boxed_struct_copy(const TestBoxedStruct* obj);

/**
 * test_boxed_struct_free:
 * @obj: (nullable):
 */
void test_boxed_struct_free(TestBoxedStruct* obj);

/*
 * test_boxed_struct_return_boxed_struct:
 * @data: Data to set on new BoxedStruct
 *
 * Returns: The only way to create this boxed struct.
 */
TestBoxedStruct* test_boxed_struct_return_boxed_struct(const gchar* data);

/*
 * test_boxed_struct_return_transfer_none:
 * Returns: (transfer none): Itself
 */
const TestBoxedStruct* test_boxed_struct_return_transfer_none(const TestBoxedStruct* self);

/**
 * test_boxed_struct_get_data:
 * Returns: data, a string.
 */
const gchar* test_boxed_struct_get_data(TestBoxedStruct* self);

/**
 * test_boxed_struct_set_data:
 * @data: Data that will be set in the boxed struct
 */
void test_boxed_struct_set_data(TestBoxedStruct* self, const gchar* data);

G_END_DECLS
