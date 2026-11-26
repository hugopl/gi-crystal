#include "test_memory.h"
#include "test_boxed_struct.h"

static const gint int_array[] = {10, 20, 30, 40};

void test_subject_call_int_array_func(TestSubject* self, TestIntArrayFunc func, gpointer user_data,
                                      GDestroyNotify destroy) {
  func(int_array, G_N_ELEMENTS(int_array), user_data);
  if (destroy)
    destroy(user_data);
}

void test_subject_call_int_array_length_first_func(TestSubject* self, TestIntArrayLengthFirstFunc func,
                                                   gpointer user_data, GDestroyNotify destroy) {
  func(G_N_ELEMENTS(int_array), int_array, user_data);
  if (destroy)
    destroy(user_data);
}

GList* test_subject_return_list_of_boxed_transfer_full(TestSubject* self) {
  GList* list = NULL;
  list = g_list_append(list, test_boxed_struct_return_boxed_struct("one"));
  list = g_list_append(list, test_boxed_struct_return_boxed_struct("two"));
  return list;
}

static TestSubject* held_subject = NULL;

TestSubject* test_subject_new_held(void) {
  g_clear_object(&held_subject);
  held_subject = g_object_new(TEST_TYPE_SUBJECT, NULL);
  return held_subject;
}

void test_subject_release_held(void) {
  g_clear_object(&held_subject);
}

typedef struct {
  const guint8* buffer;
  gsize count;
} SumBytesData;

static gboolean sum_bytes_idle(gpointer user_data) {
  GTask* task = G_TASK(user_data);
  SumBytesData* data = g_task_get_task_data(task);
  guint sum = 0;

  for (gsize i = 0; i < data->count; i++)
    sum += data->buffer[i];

  g_task_return_int(task, sum);
  return G_SOURCE_REMOVE;
}

void test_subject_sum_bytes_async(TestSubject* self, const guint8* buffer, gsize count, GCancellable* cancellable,
                                  GAsyncReadyCallback callback, gpointer user_data) {
  GTask* task = g_task_new(self, cancellable, callback, user_data);
  SumBytesData* data = g_new(SumBytesData, 1);
  data->buffer = buffer;
  data->count = count;
  g_task_set_task_data(task, data, g_free);
  g_idle_add_full(G_PRIORITY_DEFAULT, sum_bytes_idle, task, g_object_unref);
}

guint test_subject_sum_bytes_finish(TestSubject* self, GAsyncResult* result, GError** error) {
  return (guint)g_task_propagate_int(G_TASK(result), error);
}
