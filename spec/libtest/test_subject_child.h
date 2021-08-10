#pragma once

#include "test_subject.h"

G_BEGIN_DECLS

#define TEST_TYPE_SUBJECT_CHILD test_subject_child_get_type()
G_DECLARE_DERIVABLE_TYPE(TestSubjectChild, test_subject_child, TEST, SUBJECT_CHILD, TestSubject)

struct _TestSubjectChildClass {
  GObjectClass parent_class;

  /* Class virtual function fields. */
};

TestSubjectChild *test_subject_child_new(const gchar *string);

/**
 * test_subject_child_new_renamed: (rename-to test_subject_child_new)
 * @string:
 * Returns: (transfer full): Obj instance
 *
 * Used to test constructor genaration of renamed functions
 */
TestSubjectChild *test_subject_child_new_renamed(const gchar *string);

G_END_DECLS
