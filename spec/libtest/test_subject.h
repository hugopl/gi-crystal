#pragma once

#include <stdio.h>
#include <glib-object.h>

#include "test_iface.h"
#include "test_flags.h"

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
 * test_subject_concat_strings:
 * @n: number of strings to concat.
 * @strings: (array length=n) (element-type utf8) (nullable): a buffer
 * Returns: strings concatenated.
 */
gchar* test_subject_concat_strings(TestSubject *self, int n, const gchar **strings);

/**
 * test_subject_concat_filenames:
 * @n: number of filenames to concat.
 * @filenames: (array length=n) (element-type filename) (nullable): a buffer
 *
 * Used to test filename arguments as C arrays
 */
gchar* test_subject_concat_filenames(TestSubject *self, int n, const gchar **filenames);

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
 *
 * Used to test transformation of this in `Subject#getter_without_args`, returns "some string"
 */
const gchar* test_subject_get_getter_without_args(TestSubject *self);

/**
 * test_subject_set_setter:
 *
 * Used to test transformation of this in `Subject#setter=`.
 * This change the `string` attribute, same as `Subject#string=`
 */
void test_subject_set_setter(TestSubject *self, const gchar* data);

/**
 * test_subject_return_or_on_flags:
 * @flag1:
 * @flag2:
 *
 * Do a OR on two received flags
 */
TestFlagFlags test_subject_return_or_on_flags(TestSubject* self, TestFlagFlags flag1, TestFlagFlags flag2);

/**
 * test_subject_put_42_on_out_argument:
 *
 * Test out arguments
 * TODO: Pending
 */
void test_subject_put_42_on_out_argument(TestSubject *self, int *out);

/**
 * test_subject_return_list_of_strings_transfer_full:
 * Returns: (transfer full) (element-type utf8): `["one", "two"]`
 *
 * Used to test GList transfer full conversions.
 */
GList* test_subject_return_list_of_strings_transfer_full(TestSubject* self);

/**
 * test_subject_return_list_of_strings_transfer_container:
 * Returns: (transfer container) (element-type utf8): `["one", "two"]`
 *
 * Used to test GList transfer container conversions.
 */
GList* test_subject_return_list_of_strings_transfer_container(TestSubject* self);

/**
 * test_subject_return_myself_as_interface:
 * Returns: (transfer none):
 */
TestIface *test_subject_return_myself_as_interface(TestIface  *self);

G_END_DECLS
