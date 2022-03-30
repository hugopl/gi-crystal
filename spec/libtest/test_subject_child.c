#include "test_subject_child.h"

/* Private structure definition. */
typedef struct {
  gchar* not_used;
} TestSubjectChildPrivate;

G_DEFINE_TYPE_WITH_CODE(TestSubjectChild, test_subject_child, TEST_TYPE_SUBJECT, G_ADD_PRIVATE(TestSubjectChild))

static void test_subject_child_dispose(GObject* gobject) {
  // TestSubjectPrivate *priv = test_subject_get_instance_private(TEST_SUBJECT(gobject));

  G_OBJECT_CLASS(test_subject_child_parent_class)->dispose(gobject);
}

static void test_subject_child_finalize(GObject* gobject) {
  // TestSubjectChildPrivate *priv = test_subject_child_get_instance_private(TEST_SUBJECT_CHILD(gobject));

  // G_OBJECT_CLASS(test_subject_child_parent_class)->finalize(gobject);
}

static void test_subject_child_set_property(GObject* gobject, guint property_id, const GValue* value, GParamSpec* pspec) {
  // TestSubjectChildPrivate *priv = test_subject_child_get_instance_private(TEST_SUBJECT_CHILD(gobject));
}

static void test_subject_child_get_property(GObject* gobject, guint property_id, GValue* value, GParamSpec* pspec) {
  // TestSubjectChildPrivate *priv = test_subject_child_get_instance_private(TEST_SUBJECT_CHILD(gobject));
}

static void test_subject_child_class_init(TestSubjectChildClass* klass) {
  GObjectClass* object_class = G_OBJECT_CLASS(klass);

  object_class->set_property = test_subject_child_set_property;
  object_class->get_property = test_subject_child_get_property;
  object_class->dispose = test_subject_child_dispose;
  object_class->finalize = test_subject_child_finalize;
}

static void test_subject_child_init(TestSubjectChild* self) {
}

TestSubject* test_subject_child_new(const gchar* string) {
  return TEST_SUBJECT(g_object_new(TEST_TYPE_SUBJECT_CHILD, "string", string, NULL));
}

TestSubject* test_subject_child_new_renamed(const gchar* string) {
  return test_subject_child_new(string);
}

TestSubject* test_subject_child_new_constructor(const gchar* string) {
  return test_subject_child_new(string);
}

TestSubject* test_subject_child_new_constructor_returning_null(const gchar* string) {
  return NULL;
}

GObject* test_subject_child_me_as_gobject(TestSubjectChild* self) {
  return G_OBJECT(self);
}
