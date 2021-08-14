#include "test_subject.h"
#include "test_iface.h"

/* Private structure definition. */
typedef struct {
  gchar *string;
} TestSubjectPrivate;

static void test_subject_iface_interface_init(TestIfaceInterface *iface) {
  iface->return_myself_as_interface = test_subject_return_myself_as_interface;
}

G_DEFINE_TYPE_WITH_CODE(TestSubject, test_subject, G_TYPE_OBJECT,
                        G_ADD_PRIVATE(TestSubject)
                        G_IMPLEMENT_INTERFACE(TEST_TYPE_IFACE,
                                              test_subject_iface_interface_init))


typedef enum {
  PROP_STRING = 1,
  N_PROPERTIES
} TestSubjectProperty;

static GParamSpec *obj_properties[N_PROPERTIES] = { NULL, };

static void test_subject_dispose(GObject *gobject) {
  // TestSubjectPrivate *priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  G_OBJECT_CLASS(test_subject_parent_class)->dispose(gobject);
}

static void test_subject_finalize(GObject *gobject) {
  TestSubjectPrivate *priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  g_free(priv->string);

  G_OBJECT_CLASS(test_subject_parent_class)->finalize(gobject);
}

static void test_subject_set_property(GObject *gobject, guint property_id, const GValue *value, GParamSpec *pspec) {
  TestSubjectPrivate *priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  switch ((TestSubjectProperty) property_id) {
  case PROP_STRING:
    g_free(priv->string);
    priv->string = g_value_dup_string(value);
    break;
  default:
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_subject_get_property(GObject *gobject, guint property_id, GValue *value, GParamSpec *pspec) {
  TestSubjectPrivate *priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  switch ((TestSubjectProperty) property_id) {
  case PROP_STRING:
    g_value_set_string(value, priv->string);
    break;
  default:
    /* We don't have any other property... */
    G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
    break;
  }
}

static void test_subject_class_init(TestSubjectClass *klass) {
  GObjectClass *object_class = G_OBJECT_CLASS(klass);

  object_class->set_property = test_subject_set_property;
  object_class->get_property = test_subject_get_property;
  object_class->dispose = test_subject_dispose;
  object_class->finalize = test_subject_finalize;

  obj_properties[PROP_STRING] = g_param_spec_string("string", "String", "A string property.",
                                                    NULL  /* default value */,
                                                    G_PARAM_STATIC_NAME | G_PARAM_CONSTRUCT | G_PARAM_READWRITE);

  g_object_class_install_properties(object_class, N_PROPERTIES, obj_properties);

}

static void test_subject_init(TestSubject *self) {
  // TestSubjectPrivate *priv = test_subject_instance_private(self);

  /* initialize all public and private members to reasonable default values.
   * They are all automatically initialized to 0 to begin with. */
}

TestSubject *test_subject_new(void) {
  return g_object_new(TEST_TYPE_SUBJECT, "string", "", NULL);
}

TestSubject *test_subject_new_from_string(const gchar *string) {
  return g_object_new(TEST_TYPE_SUBJECT, "string", string, NULL);
}

gchar* test_subject_concat_strings(TestSubject *self, int n, const gchar **strings) {
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

gchar* test_subject_concat_filenames(TestSubject *self, int n, const gchar **filenames) {
  return test_subject_concat_strings(self, n, filenames);
}

int test_subject_sum(TestSubject *self, int n, int* numbers) {
  int sum = 0;
  for(int i = 0; i < n; ++i)
    sum += numbers[i];
  return sum;
}

int test_subject_sum_nullable(TestSubject *self, int n, int* numbers) {
  return numbers == NULL ? 0 : test_subject_sum(self, n, numbers);
}

int test_subject_receive_nullable_object(TestSubject *self, TestSubject* nullable) {
  return nullable == NULL;
}

int test_subject_receive_arguments_named_as_crystal_keywords(TestSubject *self_, int def, int alias, int module, int out, int begin, int self, int end, int abstract, int in) {
  return def + alias + module + out + begin + self + end + abstract + in;
}

const gchar* test_subject_get_getter_without_args(TestSubject *self) {
  return "some string";
}

void test_subject_set_setter(TestSubject *self, const gchar* data) {
  g_object_set(G_OBJECT(self), "string", data, NULL);
}

TestFlagFlags test_subject_return_or_on_flags(TestSubject* self, TestFlagFlags flag1, TestFlagFlags flag2) {
  return flag1 | flag2;
}

void test_subject_put_42_on_out_argument(TestSubject *self, int *out) {
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

TestIface *test_subject_return_myself_as_interface(TestIface  *self) {
  TestSubject* subject = TEST_SUBJECT(self);
  g_object_set(subject, "string", __FUNCTION__, NULL);
  return self;
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

void test_subject_get_out_param(TestSubject* self, TestStruct *out) {
  out->in = 1;
  out->begin = 2;
}
