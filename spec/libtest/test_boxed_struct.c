#include <glib-object.h>
#include <stdio.h>

#include "test_boxed_struct.h"

struct _TestBoxedStruct {
  char* data;
};

void test_boxed_struct_free(TestBoxedStruct* obj) {
  if (!obj)
    return;

  g_free(obj->data);
  g_free(obj);
}

TestBoxedStruct* test_boxed_struct_copy(const TestBoxedStruct* obj) {
  TestBoxedStruct* copy = g_malloc(sizeof(TestBoxedStruct));
  *copy = *obj;
  if (obj->data)
    copy->data = g_strdup(obj->data);

  return copy;
}

G_DEFINE_BOXED_TYPE(TestBoxedStruct, test_boxed_struct, test_boxed_struct_copy, test_boxed_struct_free)

TestBoxedStruct* test_boxed_struct_return_boxed_struct(const gchar* data) {
  TestBoxedStruct* value = g_malloc(sizeof(TestBoxedStruct));
  value->data = g_strdup(data);

  return value;
}

const TestBoxedStruct* test_boxed_struct_return_transfer_none(const TestBoxedStruct* self) {
  return self;
}

const gchar* test_boxed_struct_get_data(TestBoxedStruct* self) {
  return self->data;
}

void test_boxed_struct_set_data(TestBoxedStruct* self, const gchar* data) {
  if (self->data)
    g_free(self->data);
  self->data = g_strdup(data);
}
