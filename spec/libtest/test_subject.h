#pragma once

#include <stdio.h>
#include <glib-object.h>

#include "test_iface.h"

G_BEGIN_DECLS

/**
 * TEST_CONSTANT_WITH_VALUE_ANNOTATION: (value 100)
 * A constant with a value annotation.
 */
#define TEST_CONSTANT_WITH_VALUE_ANNOTATION 10 * 10

/**
 * TEST_CONSTANT:
 * A constant.
 */
#define TEST_CONSTANT 123

/**
 * TestStruct:
 * @in: A attribute using a invalid Crystal keyword.
 * @begin: Another attribute using a invalid Crystal keyword.
 *
 * A plain struct to test stuff
 */
struct TestStruct {
  gint16 in;
  gint16 begin;
};

#define TEST_TYPE_SUBJECT test_subject_get_type()
G_DECLARE_DERIVABLE_TYPE(TestSubject, test_subject, TEST, SUBJECT, GObject)

struct _TestSubjectClass {
  GObjectClass parent_class;

  /* Class virtual function fields. */
};

/**
 * test_subject_new:
 * Returns: (transfer full): Obj instance
 */
TestSubject *test_subject_new(void);

/**
 * test_subject_receive_optional_array_and_len:
 * @buf: (array length=length) (element-type guint8) (nullable): a buffer
 * @length: buffer length
 * Returns: "buffer length"
 */
int test_subject_receive_optional_array_and_len(TestSubject *self, const char *buf, int length);

/**
 * test_subject_receive_nullable_object:
 * @nullable: (allow-none): A nullable object
 * Returns: 1 if nullable is null, 0 otherwise
 */
int test_subject_receive_nullable_object(TestSubject *self, TestSubject *nullable);

/**
 * test_subject_receive_arguments_named_as_crystal_keywords
 * Returns: Sum of all parameters
 */
int test_subject_receive_arguments_named_as_crystal_keywords(TestSubject *self_, int def, int alias, int module, int out, int begin, int self, int end, int abstract, int in);

/**
 * test_subject_get_getter_without_args:
 * Used to test transformation of this in `Subject#getter_without_args`, returns "some string"
 */
const gchar* test_subject_get_getter_without_args(TestSubject *self);

/**
 * test_subject_set_setter:
 * Used to test transformation of this in `Subject#setter=`.
 * This change the `string` attribute, same as `Subject#string=`
 */
void test_subject_set_setter(TestSubject *self, const gchar* data);

/**
 * test_subject_put_42_on_out_argument:
 * Test out arguments.
 */
void test_subject_put_42_on_out_argument(TestSubject *self, int *out);

/**
 * test_subject_return_list_of_strings_transfer_full:
 * Used to test GList transfer full conversions.
 *
 * Returns: (transfer full) (element-type utf8): `["one", "two"]`
 */
GList* test_subject_return_list_of_strings_transfer_full(TestSubject* self);

/**
 * test_subject_return_list_of_strings_transfer_container:
 * Used to test GList transfer container conversions.
 *
 * Returns: (transfer container) (element-type utf8): `["one", "two"]`
 */
GList* test_subject_return_list_of_strings_transfer_container(TestSubject* self);

/**
 * test_subject_return_myself_as_interface:
 * Returns: (transfer none):
 */
TestIface *test_subject_return_myself_as_interface(TestIface  *self);

G_END_DECLS
