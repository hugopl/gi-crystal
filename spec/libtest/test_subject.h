#pragma once

#include <glib-object.h>
#include <stdio.h>

#include "test_flags.h"
#include "test_iface.h"
#include "test_regular_enum.h"

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
 * TestPoint:
 * @x: X
 * @y: Y
 *
 * Used to test simple structs
 */
typedef struct _TestPoint {
  int x;
  int y;
} TestPoint;

/**
 * TestStruct:
 * @in: A attribute using a invalid Crystal keyword.
 * @begin: Another attribute using a invalid Crystal keyword.
 * @point: Another struct member of this struct.
 *
 * A plain struct to test stuff
 */
typedef struct _TestStruct {
  gint16 in;
  gint16 begin;
  TestPoint* point_ptr;
  TestPoint point;
} TestStruct;

/**
 * TestSubject:
 *
 * Main class used to test all sort of things directly related or not to GObject.
 *
 * Example docs for testing:
 *
 * getter: [method@Test.Subject.get_out_param]
 *
 * setter: [method@Test.Subject.set_str_list]
 *
 * is: [method@Test.Subject.is_bool]
 *
 * initializer: [ctor@Test.Subject.new]
 *
 * code block:
 * ```c
 * #include <stdio.h>
 * int main() {
 *    printf("Hello, World!");
 *    return 0;
 * }
 * ```
 *
 */
#define TEST_TYPE_SUBJECT test_subject_get_type()
G_DECLARE_DERIVABLE_TYPE(TestSubject, test_subject, TEST, SUBJECT, GObject)

struct _TestSubjectClass {
  GObjectClass parent_class;

  /* Class virtual function fields. */
};

/**
 * test_subject_new_from_whatever:
 * @value:
 * Returns: (transfer full): Obj instance with value set on string property
 *
 * Used to test transformation of this into `Subject.from_string(...)`.
 */
TestSubject* test_subject_new_from_string(const gchar* string);

/**
 * test_subject_set_str_list:
 * @list: (array zero-terminated=1):
 *
 * Setter for str_list property.
 */
void test_subject_set_str_list(TestSubject* self, const char** list);

/**
 * test_subject_may_return_null:
 * @return_nil:
 * Returns: (transfer none) (nullable): Return self if `return_nil` is true, NULL otherwise.
 *
 * Used to test return null
 */
TestSubject* test_subject_may_return_null(TestSubject* self, gboolean return_nil);

/**
 * test_subject_transfer_full_param:
 * @subject: (transfer full):
 */
void test_subject_transfer_full_param(GObject* subject);

/**
 * test_subject_concat_strings:
 * @n: number of strings to concat.
 * @strings: (array length=n) (element-type utf8) (nullable): a buffer
 * Returns: strings concatenated.
 */
gchar* test_subject_concat_strings(TestSubject* self, int n, const gchar** strings);

/**
 * test_subject_concat_filenames:
 * @n: number of filenames to concat.
 * @filenames: (array length=n) (element-type filename): a buffer
 * Returns: (type filename)
 *
 * Used to test filename arguments as C arrays, non-nullable arrays and filename return values.
 */
gchar* test_subject_concat_filenames(TestSubject* self, int n, const gchar** filenames);

/**
 * test_subject_sum:
 * @n: number of integers to sum.
 * @numbers: (array length=n) (element-type int): integers
 *
 * Used to test non-nullable array of primitive arguments
 */
int test_subject_sum(TestSubject* self, int n, int* numbers);

/**
 * test_subject_sum_nullable:
 * @n: number of integers to sum.
 * @numbers: (array length=n) (element-type int) (nullable): integers
 *
 * Used to test non-nullable array of primitive arguments
 */
int test_subject_sum_nullable(TestSubject* self, int n, int* numbers);

/**
 * test_subject_receive_nullable_object:
 * @nullable: (allow-none): A nullable object
 * Returns: 1 if nullable is null, 0 otherwise
 */
int test_subject_receive_nullable_object(TestSubject* self, TestSubject* nullable);

/**
 * test_subject_no_optional_param:
 * @int32: (out) (optional):
 * @str: (out) (optional):
 * @en:  (out) (optional):
 * @gobj: (out) (optional) (transfer none):
 * Returns: -1 if any parameter has value != 0
 *
 * Used to test removal of optional parameters
 */
int test_subject_no_optional_param(int* int32, const gchar** str, TestRegularEnum* en, GObject** gobj);

/**
 * test_subject_receive_arguments_named_as_crystal_keywords
 * Returns: Sum of all parameters
 */
int test_subject_receive_arguments_named_as_crystal_keywords(TestSubject* self_, int def, int alias, int module, int out,
                                                             int begin, int self, int end, int abstract, int in);

/**
 * test_subject_get_getter_without_args:
 *
 * Used to test transformation of this in `Subject#getter_without_args`, returns "some string"
 */
const gchar* test_subject_get_getter_without_args(TestSubject* self);

/**
 * test_subject_is_bool: (get-property Boolean)
 *
 * Used to test boolean get properties, this must be mapped to `TestSubject#bool?`
 */
gboolean test_subject_is_bool(TestSubject* self);

/**
 * test_subject_set_setter:
 *
 * Used to test transformation of this in `Subject#setter=`.
 * This change the `string` attribute, same as `Subject#string=`
 */
void test_subject_set_setter(TestSubject* self, const gchar* data);

/**
 * test_subject_return_or_on_flags:
 * @flag1:
 * @flag2:
 *
 * Do a OR on two received flags
 */
TestFlagFlags test_subject_return_or_on_flags(TestSubject* self, TestFlagFlags flag1, TestFlagFlags flag2);

/**
 * test_subject_return_bad_flag:
 * Returns: A flag with bad values.
 *
 * Used to test bad flag values.
 */
TestFlagFlags test_subject_return_bad_flag();

/**
 * test_subject_put_42_on_out_argument:
 *
 * Test out arguments
 * TODO: Pending
 */
void test_subject_put_42_on_out_argument(TestSubject* self, int* out);

/**
 * test_subject_return_null_terminated_array_transfer_none:
 * Returns: (array zero-terminated=1) (transfer none):
 * Used to test return of null terminated arrays, full copy is always done.
 */
const gchar** test_subject_return_null_terminated_array_transfer_none(TestSubject* self);

/**
 * test_subject_return_null_terminated_array_transfer_full:
 * Returns: (array zero-terminated=1) (transfer full):
 * Used to test return of null terminated arrays, full copy is always done.
 */
gchar** test_subject_return_null_terminated_array_transfer_full(TestSubject* self);

/**
 * test_subject_return_array_transfer_full:
 * @length: (out) (transfer full):
 * Returns: (transfer full) (array length=length)
 */
gchar** test_subject_return_array_transfer_full(TestSubject* self, int* length);

/**
 * test_subject_return_array_transfer_none:
 * @length: (out) (transfer full):
 * Returns: (transfer none) (array length=length)
 */
gchar** test_subject_return_array_transfer_none(TestSubject* self, int* length);

/**
 * test_subject_return_array_transfer_container:
 * @length: (out) (transfer full):
 * Returns: (transfer container) (array length=length)
 */
gchar** test_subject_return_array_transfer_container(TestSubject* self, int* length);

/**
 * test_subject_return_int32_array_transfer_full:
 * @length: (out) (transfer full):
 * Returns: (transfer full) (array length=length)
 */
int* test_subject_return_int32_array_transfer_full(TestSubject* self, int* length);

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
 * test_subject_return_slist_of_strings_transfer_full:
 * Returns: (transfer full) (element-type utf8): `["one", "two"]`
 *
 * Used to test GSList transfer full conversions.
 */
GSList* test_subject_return_slist_of_strings_transfer_full(TestSubject* self);

/**
 * test_subject_return_slist_of_strings_transfer_container:
 * Returns: (transfer container) (element-type utf8): `["one", "two"]`
 *
 * Used to test GSList transfer container conversions.
 */
GSList* test_subject_return_slist_of_strings_transfer_container(TestSubject* self);

/**
 * test_subject_get_out_param:
 * @out: (out caller-allocates)
 *
 * Used to test out params and get_ remove, this must be `TestSubject#out_param`
 * out param will have in: 1, begin: 2 as value
 */
void test_subject_get_out_param(TestSubject* self, TestStruct* out);

/**
 * test_subject_array_of_g_values:
 * @n:
 * @values: (array length=n):
 * Returns: String in format "type:value;type:value;..." for each item.
 *
 * Used to test GValue in array parameters,
 */
const gchar* test_subject_array_of_g_values(TestSubject* self, int n, GValue* values);

/**
 * test_subject_g_value_parameter:
 * @value: A GValue
 * Returns: String in format "type:value;"
 *
 * Used to test single GValue parameter
 */
const gchar* test_subject_g_value_parameter(GValue* value);

/**
 * test_subject_g_value_by_out_parameter:
 * @value: (out caller-allocates): A GValue to be initialized and set to int32-42.
 *
 * Used to test GValues as out parameters
 */
void test_subject_g_value_by_out_parameter(GValue* value);

/**
 * test_subject_g_variant_parameter:
 * @variant: (transfer none): A GVariant
 * Returns: String representation of g_variant
 */
gchar* test_subject_g_variant_parameter(GVariant* variant);

/**
 * test_subject_string_to_bytes_transfer_full:
 * @data:
 * Returns: (transfer full)
 *
 * Used to test GLib::GBytes
 */
GBytes* test_subject_string_to_bytes_transfer_full(const gchar* data);

/**
 * test_subject_string_to_bytes_transfer_none:
 * @data:
 * Returns: (transfer none)
 *
 * Used to test GLib::GBytes
 */
GBytes* test_subject_string_to_bytes_transfer_none(const gchar* data);

/**
 * test_subject_receive_empty_flags:
 *
 * Used to test if empty flags are generated as basic enum with a None entry.
 */
TestEmptyFlags test_subject_receive_empty_flags(TestEmptyFlags flags);

/**
 * test_subject_nullable_optimal_parameter:
 * @param: (out) (transfer full) (nullable) (optional)
 */
int test_subject_nullable_optimal_parameter(TestSubject* self, gchar** param);

/**
 * test_subject_return_g_error:
 * Returns: (transfer full): A GError
 *
 * Used to test GError as return value
 */
GError* test_subject_return_g_error();

/**
 * test_subject_raise_file_error:
 *
 * Used to test GError translation into exceptions.
 */
void test_subject_raise_file_error(TestSubject* self, GError** error);

/**
 * test_subject_raise_file_error2:
 *
 * Used to test GError translation into exceptions, this time with more arguments.
 */
void test_subject_raise_file_error2(TestSubject* self, int foo, GError** error);

/**
 * test_subject_return_myself_as_interface:
 * Returns: (transfer none):
 */
TestIface* test_subject_return_myself_as_interface(TestIface* self);

G_END_DECLS
