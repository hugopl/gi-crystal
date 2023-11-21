#include "test_subject.h"
#include "test_boxed_struct.h"
#include "test_iface.h"

G_DEFINE_QUARK(test - subject - error - quark, test_subject_error)

/* Private structure definition. */
typedef struct {
  gchar* string;
  gboolean boolean;
  int int32;
  TestRegularEnum _enum;
  TestIface* iface;
  GObject* gobj;
  char** str_list;
  gdouble float64;

  TestSubjectSimpleFunc simple_func;
  gpointer simple_func_target;
  GDestroyNotify simple_func_target_destroy_notify;
} TestSubjectPrivate;

static void test_subject_iface_interface_init(TestIfaceInterface* iface) {
  iface->return_myself_as_interface = test_subject_return_myself_as_interface;
}

G_DEFINE_TYPE_WITH_CODE(TestSubject, test_subject, G_TYPE_OBJECT,
                        G_ADD_PRIVATE(TestSubject) G_IMPLEMENT_INTERFACE(TEST_TYPE_IFACE, test_subject_iface_interface_init))

void test_subject_set_str_list(TestSubject* self, const char** list);

typedef enum {
  PROP_STRING = 1,
  PROP_BOOLEAN,
  PROP_INT32,
  PROP_IFACE,
  PROP_GOBJ,
  PROP_ENUM,
  PROP_STR_LIST,
  N_PROPERTIES,
  // interface properties
  PROP_FLOAT64
} TestSubjectProperty;

static GParamSpec* obj_properties[N_PROPERTIES] = {
  NULL,
};

static void test_subject_dispose(GObject* object) {
  TestSubject* self = TEST_SUBJECT(object);
  TestSubjectPrivate* priv = test_subject_get_instance_private(self);

  if (priv->simple_func_target_destroy_notify)
    priv->simple_func_target_destroy_notify(priv->simple_func_target);

  priv->simple_func = NULL;
  priv->simple_func_target = NULL;
  priv->simple_func_target_destroy_notify = NULL;

  G_OBJECT_CLASS(test_subject_parent_class)->dispose(object);
}

static void test_subject_finalize(GObject* gobject) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  g_free(priv->string);
  g_strfreev(priv->str_list);

  G_OBJECT_CLASS(test_subject_parent_class)->finalize(gobject);
}

static void test_subject_set_property(GObject* gobject, guint property_id, const GValue* value, GParamSpec* pspec) {
  TestSubject* self = TEST_SUBJECT(gobject);
  TestSubjectPrivate* priv = test_subject_get_instance_private(self);
  GObject* gobj = NULL; // Used on gobject properties

  switch (property_id) {
  case PROP_STRING:
    g_free(priv->string);
    priv->string = g_value_dup_string(value);
    break;
  case PROP_BOOLEAN:
    priv->boolean = g_value_get_boolean(value);
    break;
  case PROP_INT32:
    priv->int32 = g_value_get_int(value);
    break;
  case PROP_IFACE:
    if (priv->iface)
      g_object_unref(G_OBJECT(priv->iface));
    gobj = g_value_get_object(value);
    g_object_ref(gobj);
    priv->iface = TEST_IFACE(gobj);
    break;
  case PROP_GOBJ:
    gobj = g_value_get_object(value);
    g_set_object(&priv->gobj, gobj);
    break;
  case PROP_ENUM:
    priv->_enum = g_value_get_enum(value);
    break;
  case PROP_STR_LIST:
    test_subject_set_str_list(self, (const char**)g_value_get_boxed(value));
    break;
  case PROP_FLOAT64:
    priv->float64 = g_value_get_double(value);
    break;
  default:
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_subject_get_property(GObject* gobject, guint property_id, GValue* value, GParamSpec* pspec) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  switch (property_id) {
  case PROP_STRING:
    g_value_set_string(value, priv->string);
    break;
  case PROP_BOOLEAN:
    g_value_set_boolean(value, priv->boolean);
    break;
  case PROP_INT32:
    g_value_set_int(value, priv->int32);
    break;
  case PROP_IFACE:
    g_value_take_object(value, G_OBJECT(priv->iface));
    break;
  case PROP_GOBJ:
    g_value_take_object(value, G_OBJECT(priv->gobj));
    break;
  case PROP_ENUM:
    g_value_set_enum(value, priv->_enum);
    break;
  case PROP_STR_LIST:
    g_value_set_boxed(value, priv->str_list);
    break;
  case PROP_FLOAT64:
    g_value_set_double(value, priv->float64);
    break;
  default:
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_subject_class_init(TestSubjectClass* klass) {
  GObjectClass* object_class = G_OBJECT_CLASS(klass);

  object_class->set_property = test_subject_set_property;
  object_class->get_property = test_subject_get_property;
  object_class->dispose = test_subject_dispose;
  object_class->finalize = test_subject_finalize;

  obj_properties[PROP_STRING] = g_param_spec_string("string", "String", "A string property.", "",
                                                    G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  obj_properties[PROP_BOOLEAN] = g_param_spec_boolean("boolean", "Boolean", "A boolean property.", TRUE,
                                                      G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  obj_properties[PROP_INT32] = g_param_spec_int("int32", "Int32", "A int32 property.", INT_MIN, INT_MAX, 0,
                                                G_PARAM_STATIC_STRINGS | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);
  obj_properties[PROP_IFACE]
    = g_param_spec_object("iface", "IFace", "An IFace object.", TEST_TYPE_IFACE, G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE);
  obj_properties[PROP_GOBJ] = g_param_spec_object("gobj", "GObject", "An GObject object.", G_TYPE_OBJECT,
                                                  G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE);
  obj_properties[PROP_ENUM] = g_param_spec_enum("enum", "Enum", "An enum.", TEST_TYPE_REGULAR_ENUM, TEST_VALUE1,
                                                G_PARAM_STATIC_STRINGS | G_PARAM_READWRITE);
  obj_properties[PROP_STR_LIST]
    = g_param_spec_boxed("str_list", "StrList", "A null terminated list of strings", G_TYPE_STRV, G_PARAM_READWRITE);

  g_object_class_override_property(object_class, PROP_FLOAT64, "float64");
  g_object_class_install_properties(object_class, N_PROPERTIES, obj_properties);

  /**
   * TestSubject::variant:
   * @subject: the subject who sent the signal.
   * @variant: a GVariant
   */
  g_signal_new("variant", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               G_TYPE_VARIANT, NULL);
  /**
   * TestSubject::nullable-args:
   * @self: the subject who sent the signal.
   * @string: (nullable): a string or NULL.
   * @number: a number or NULL.
   */
  g_signal_new("nullable-args", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               2, // n_params
               G_TYPE_STRING, G_TYPE_INT, NULL);
  /**
   * TestSubject::return-int:
   * @subject: the subject that requires a int return value
   */
  g_signal_new("return-int", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_INT, // return_type
               0, // n_params
               NULL);
  /**
   * TestSubject::return-bool:
   * @subject: the subject
   * @boolean: A boolean value
   *
   * Used to test bool return values and parameters.
   */
  g_signal_new("return-bool", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_BOOLEAN, // return_type
               1, // n_params
               G_TYPE_BOOLEAN, NULL);
  /**
   * TestSubject::array-of-gobj:
   * @self: the subject who sent the signal.
   * @objs: (array length=n_objs) (element-type TestSubject): an array of TestSubject.
   * @n_objs: length of @objs.
   *
   * Used to test signals with array of GObject.
   */
  g_signal_new("array-of-gobj", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               2, // n_params
               G_TYPE_POINTER, G_TYPE_INT, NULL);
  /**
   * TestSubject::array-of-iface:
   * @self: the subject who sent the signal.
   * @objs: (array length=n_objs) (element-type TestIface): an array of TestIface.
   * @n_objs: length of @objs.
   *
   * Used to test signals with array of interfaces.
   */
  g_signal_new("array-of-iface", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               2, // n_params
               G_TYPE_POINTER, G_TYPE_INT, NULL);

  /**
   * TestSubject::iface:
   * @self: the subject who sent the signal.
   * @obj: a TestIface.
   *
   * Used to test signals with interfaces.
   */
  g_signal_new("iface", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               TEST_TYPE_IFACE, NULL);

  /**
   * TestSubject::enum:
   * @self: the subject who sent the signal.
   * @value: the enum value.
   *
   * Used to test signals with enums
   */
  g_signal_new("enum", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               TEST_TYPE_REGULAR_ENUM, NULL);
  /**
   * TestSubject::boxed:
   * @self: the subject who sent the signal.
   * @value: the boxed struct.
   *
   * Used to test signals with boxed structs
   */
  g_signal_new("boxed", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               TEST_TYPE_BOXED_STRUCT, NULL);
  /**
   * TestSubject::gvalue:
   * @self: the subject who sent the signal.
   * @gvalue: (nullable): the boxed struct.
   *
   * Used to test signals with boxed structs
   */
  g_signal_new("gvalue", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               G_TYPE_VALUE, NULL);

  /**
   * TestSubject::gerror:
   * @self: the subject who sent the signal.
   * @error: the error.
   *
   * Used to test signals with `GError` in params.
   */
  g_signal_new("gerror", G_TYPE_FROM_CLASS(klass), G_SIGNAL_RUN_LAST | G_SIGNAL_NO_RECURSE | G_SIGNAL_NO_HOOKS,
               0, // class_offset
               NULL, // accumulator
               NULL, // accumulator data
               NULL, // C marshaller
               G_TYPE_NONE, // return_type
               1, // n_params
               G_TYPE_ERROR, NULL);
}

static void test_subject_init(TestSubject* self) {
  // TestSubjectPrivate *priv = test_subject_instance_private(self);

  /* initialize all public and private members to reasonable default values.
   * They are all automatically initialized to 0 to begin with. */
}

TestSubject* test_subject_new_from_string(const gchar* string) {
  return g_object_new(TEST_TYPE_SUBJECT, "string", string, "int32", 0, NULL);
}

void test_subject_set_simple_func(TestSubject* self, TestSubjectSimpleFunc func, gpointer user_data,
                                  GDestroyNotify destroy) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(self);

  if (priv->simple_func_target_destroy_notify)
    priv->simple_func_target_destroy_notify(priv->simple_func_target);

  priv->simple_func = func;
  priv->simple_func_target = user_data;
  priv->simple_func_target_destroy_notify = destroy;
}

gboolean test_subject_call_simple_func(TestSubject* self, int number) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(self);
  if (!priv->simple_func)
    return FALSE;

  priv->simple_func(self, number, priv->simple_func_target);
  return TRUE;
}

void test_subject_set_str_list(TestSubject* self, const char** list) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(self);

  g_strfreev(priv->str_list);
  priv->str_list = g_strdupv((char**)list);
}

TestSubject* test_subject_may_return_null(TestSubject* self, gboolean return_nil) {
  return return_nil ? NULL : self;
}

gunichar test_subject_return_char(TestSubject* self, gunichar character) {
  return character;
}

void test_subject_transfer_full_param(GObject* subject) {
}

void test_subject_nullable_transfer_full_param(GObject* gobj) {
}

void test_subject_nullable_transfer_full_iface_param(TestIface* iface) {
}

gchar* test_subject_concat_strings(TestSubject* self, int n, const gchar** strings) {
  if (n == 0 || strings == NULL)
    return g_strdup("");

  int size = 0;
  for (int i = 0; i < n; ++i)
    size += strlen(strings[i]);

  gchar* ret = g_malloc(size + 1);

  gchar* ptr = ret;
  for (int i = 0; i < n; ++i) {
    strcpy(ptr, strings[i]);
    ptr += strlen(strings[i]);
  }

  return ret;
}

gchar* test_subject_concat_filenames(TestSubject* self, int n, const gchar** filenames) {
  return test_subject_concat_strings(self, n, filenames);
}

int test_subject_sum(TestSubject* self, int n, int* numbers) {
  int sum = 0;
  for (int i = 0; i < n; ++i)
    sum += numbers[i];
  return sum;
}

int test_subject_sum_nullable(TestSubject* self, int n, int* numbers) {
  return numbers == NULL ? 0 : test_subject_sum(self, n, numbers);
}

int test_subject_receive_nullable_object(TestSubject* self, TestSubject* nullable) {
  return nullable == NULL;
}

int test_subject_no_optional_param(int* int32, const gchar** str, TestRegularEnum* en, GObject** gobj) {
  return (int32 || str || en || gobj) ? -1 : 0;
}

int test_subject_receive_arguments_named_as_crystal_keywords(TestSubject* self_, int def, int alias, int module, int out,
                                                             int begin, int self, int end, int abstract, int in) {
  return def + alias + module + out + begin + self + end + abstract + in;
}

const gchar* test_subject_get_getter_without_args(TestSubject* self) {
  return "some string";
}

gboolean test_subject_is_bool(TestSubject* self) {
  TestSubjectPrivate* priv = test_subject_get_instance_private(TEST_SUBJECT(self));

  return priv->boolean;
}

void test_subject_set_setter(TestSubject* self, const gchar* data) {
  g_object_set(G_OBJECT(self), "string", data, NULL);
}

TestFlagFlags test_subject_return_or_on_flags(TestSubject* self, TestFlagFlags flag1, TestFlagFlags flag2) {
  return flag1 | flag2;
}

TestFlagFlags test_subject_return_bad_flag() {
  return (TestFlagFlags)17;
}

void test_subject_put_42_on_out_argument(TestSubject* self, int* out) {
  *out = 42;
}

const gchar** test_subject_return_null_terminated_array_transfer_none(TestSubject* self) {
  static const gchar* ret[] = { "Hello", "World", NULL };
  return ret;
}

gchar** test_subject_return_null_terminated_array_transfer_full(TestSubject* self) {
  gchar** ret = g_malloc_n(3, sizeof(gchar*));
  ret[0] = g_strdup("Hello");
  ret[1] = g_strdup("World");
  ret[2] = NULL;
  return ret;
}

gchar** test_subject_return_array_transfer_full(TestSubject* self, int* length) {
  *length = 2;
  gchar** ret = g_malloc_n(3, sizeof(gchar*));
  ret[0] = g_strdup("Hello");
  ret[1] = g_strdup("World");
  return ret;
}

gchar** test_subject_return_array_transfer_none(TestSubject* self, int* length) {
  *length = 2;
  static const char* ret[2] = { "Hello", "World" };
  return (char**)ret;
}

gchar** test_subject_return_array_transfer_container(TestSubject* self, int* length) {
  *length = 2;
  gchar** ret = g_malloc_n(3, sizeof(gchar*));
  ret[0] = (gchar*)"Hello";
  ret[1] = (gchar*)"World";
  return ret;
}

int* test_subject_return_int32_array_transfer_full(TestSubject* self, int* length) {
  *length = 2;
  int* ret = g_malloc_n(2, sizeof(int));
  ret[0] = 42;
  ret[1] = 43;
  return ret;
}

TestIface* test_subject_return_myself_as_interface(TestIface* self) {
  TestSubject* subject = TEST_SUBJECT(self);
  g_object_set(subject, "string", __FUNCTION__, NULL);
  return self;
}

GList* test_subject_return_list_of_iface_transfer_full(TestSubject* self) {
  GList* list = NULL;
  g_object_ref(self);
  list = g_list_append(list, self);
  list = g_list_append(list, test_subject_new_from_string("Born in C"));
  return list;
}

GList* test_subject_return_list_of_gobject_transfer_full(TestSubject* self) {
  return test_subject_return_list_of_iface_transfer_full(self);
}

GList* test_subject_return_list_of_strings_transfer_full(TestSubject* self) {
  GList* list = NULL;
  list = g_list_append(list, g_strdup("one"));
  list = g_list_append(list, g_strdup("two"));
  return list;
}

GList* test_subject_return_list_of_strings_transfer_container(TestSubject* self) {
  GList* list = NULL;
  list = g_list_append(list, "one");
  list = g_list_append(list, "two");
  return list;
}

GSList* test_subject_return_slist_of_iface_transfer_full(TestSubject* self) {
  GSList* list = NULL;
  g_object_ref(self);
  list = g_slist_append(list, self);
  list = g_slist_append(list, test_subject_new_from_string("Subject from C"));
  return list;
}

GSList* test_subject_return_slist_of_gobject_transfer_full(TestSubject* self) {
  return test_subject_return_slist_of_iface_transfer_full(self);
}

GSList* test_subject_return_slist_of_strings_transfer_full(TestSubject* self) {
  GSList* list = NULL;
  list = g_slist_append(list, g_strdup("one"));
  list = g_slist_append(list, g_strdup("two"));
  return list;
}

GSList* test_subject_return_slist_of_strings_transfer_container(TestSubject* self) {
  GSList* list = NULL;
  list = g_slist_append(list, "one");
  list = g_slist_append(list, "two");
  return list;
}

void test_subject_get_out_param(TestSubject* self, TestStruct* out) {
  out->in = 1;
  out->begin = 2;
}

static gchar* g_value_to_string(gchar* buffer, GValue* value) {
  const gchar* type_name = g_type_name(value->g_type);
  int type_name_size = strlen(type_name);
  strncpy(buffer, type_name, type_name_size);
  buffer += type_name_size;
  *buffer = ':';
  buffer++;

  GParamSpec* param;

  switch (value->g_type) {
  case G_TYPE_INT:
    buffer += sprintf(buffer, "%d", g_value_get_int(value));
    break;
  case G_TYPE_UINT:
    buffer += sprintf(buffer, "%u", g_value_get_uint(value));
    break;
  case G_TYPE_INT64:
    buffer += sprintf(buffer, "%ld", g_value_get_int64(value));
    break;
  case G_TYPE_UINT64:
    buffer += sprintf(buffer, "%lu", g_value_get_uint64(value));
    break;
  case G_TYPE_FLOAT:
    buffer += sprintf(buffer, "%0.2f", g_value_get_float(value));
    break;
  case G_TYPE_DOUBLE:
    buffer += sprintf(buffer, "%0.2f", g_value_get_double(value));
    break;
  case G_TYPE_STRING:
    buffer += sprintf(buffer, "%s", g_value_get_string(value));
    break;
  case G_TYPE_CHAR:
    *buffer++ = g_value_get_schar(value);
    break;
  case G_TYPE_UCHAR:
    buffer += sprintf(buffer, "%d", g_value_get_uchar(value));
    break;
  case G_TYPE_ENUM:
    buffer += sprintf(buffer, "%d", g_value_get_enum(value));
    break;
  case G_TYPE_PARAM:
    param = g_value_get_param(value);
    buffer += sprintf(buffer, "%s", g_param_spec_get_name(param));
    break;
  default:
    *buffer++ = '?';
  }
  *buffer++ = ';';
  return buffer;
}

const gchar* test_subject_array_of_g_values(TestSubject* self, int n, GValue* values) {
  static gchar buffer[1024];
  gchar* ptr = buffer;

  for (int i = 0; i < n; ++i) {
    ptr = g_value_to_string(ptr, &values[i]);
  }
  *ptr = 0;
  return buffer;
}

const gchar* test_subject_g_value_parameter(GValue* value) {
  static gchar buffer[128];
  gchar* ptr = g_value_to_string(buffer, value);
  *ptr = 0;
  return buffer;
}

void test_subject_g_value_by_out_parameter(GValue* value) {
  g_value_init(value, G_TYPE_INT);
  g_value_set_int(value, 42);
}

gchar* test_subject_g_variant_parameter(GVariant* variant) {
  return variant ? g_variant_print(variant, TRUE) : g_strdup("NULL");
}

GBytes* test_subject_string_to_bytes_transfer_full(const gchar* data) {
  int size = strlen(data);

  return g_bytes_new(data, size);
}

GBytes* test_subject_string_to_bytes_transfer_none(const gchar* data) {
  int size = strlen(data);
  gchar* copy = g_strdup(data);

  return g_bytes_new_take(copy, size);
}

TestEmptyFlags test_subject_receive_empty_flags(TestEmptyFlags flags) {
  return flags;
}

int test_subject_nullable_optimal_parameter(TestSubject* self, gchar** param) {
  if (param)
    *param = g_strdup("Hi There!");

  return 42;
}

int test_subject_sum_array_of_4_ints(TestSubject* self, int* array) {
  int acc = 0;
  for (int i = 0; i < 4; ++i)
    acc += array[i];
  return acc;
}

void test_subject_deprecated_method(TestSubject* self) {
}

GError* test_subject_return_g_error() {
  return g_error_new(G_FILE_ERROR, G_FILE_ERROR_FAILED, "whatever message");
}

void test_subject_raise_file_error(TestSubject* self, GError** error) {
  g_set_error(error, G_FILE_ERROR, G_FILE_ERROR_FAILED, "An error with ♥️");
}

void test_subject_raise_file_error2(TestSubject* self, int foo, GError** error) {
  test_subject_raise_file_error(self, error);
}
