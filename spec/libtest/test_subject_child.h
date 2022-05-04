#pragma once

#include "test_subject.h"

G_BEGIN_DECLS

#define TEST_TYPE_SUBJECT_CHILD test_subject_child_get_type()
G_DECLARE_DERIVABLE_TYPE(TestSubjectChild, test_subject_child, TEST, SUBJECT_CHILD, TestSubject)

typedef struct _TestSubjectChildClass {
  TestSubjectClass parent_class;

  /* Class virtual function fields. */
} TestSubjectChildClass;

TestSubject* test_subject_child_new(const gchar* string);

/**
 * test_subject_child_new_renamed: (rename-to test_subject_child_new)
 * @string:
 * Returns: (transfer full): Obj instance
 *
 * Used to test constructor genaration of renamed functions
 */
TestSubject* test_subject_child_new_renamed(const gchar* string);

/**
 * test_subject_child_new_constructor:
 * @string: value for the string property
 * Returns: (transfer full):
 *
 * Used to test constructors that returns the base class in C signature.
 */
TestSubject* test_subject_child_new_constructor(const gchar* string);

/**
 * test_subject_child_new_constructor_returning_null:
 * @string: value for the string property
 * Returns: (transfer full) (nullable):
 *
 * Used to test constructors that returns the base class in C signature and may return NULL.
 */
TestSubject* test_subject_child_new_constructor_returning_null(const gchar* string);

/**
 * test_subject_child_me_as_gobject:
 * Returns: (transfer none): Self obj casted to GObject
 *
 * Used to test object casts
 */
GObject* test_subject_child_me_as_gobject(TestSubjectChild* self);

G_END_DECLS
