#pragma once

#include <gio/gio.h>
#include <glib-object.h>

#include "test_subject.h"

G_BEGIN_DECLS

/*
 * Functions used to reproduce memory handling bugs, see spec/memory_spec.cr.
 */

/**
 * TestIntArrayFunc:
 * @values: (array length=n_values): integers
 * @n_values: number of integers
 * @user_data: (closure): user data
 *
 * Callback receiving a C array of integers, length after the array.
 */
typedef void (*TestIntArrayFunc)(const gint* values, gsize n_values, gpointer user_data);

/**
 * TestIntArrayLengthFirstFunc:
 * @n_values: number of integers
 * @values: (array length=n_values): integers
 * @user_data: (closure): user data
 *
 * Callback receiving a C array of integers, length before the array (i.e. at index 0).
 */
typedef void (*TestIntArrayLengthFirstFunc)(gsize n_values, const gint* values, gpointer user_data);

/**
 * test_subject_call_int_array_func:
 * @func: (scope call): callback called with the array {10, 20, 30, 40}.
 * @user_data: (closure func): user data passed to @func
 * @destroy: destroy notifier for @user_data
 */
void test_subject_call_int_array_func(TestSubject* self, TestIntArrayFunc func, gpointer user_data,
                                      GDestroyNotify destroy);

/**
 * test_subject_call_int_array_length_first_func:
 * @func: (scope call): callback called with the array {10, 20, 30, 40}.
 * @user_data: (closure func): user data passed to @func
 * @destroy: destroy notifier for @user_data
 */
void test_subject_call_int_array_length_first_func(TestSubject* self, TestIntArrayLengthFirstFunc func,
                                                   gpointer user_data, GDestroyNotify destroy);

/**
 * test_subject_return_list_of_boxed_transfer_full:
 * Returns: (transfer full) (element-type TestBoxedStruct): a list with two boxed structs.
 */
GList* test_subject_return_list_of_boxed_transfer_full(TestSubject* self);

/**
 * test_subject_new_held:
 * Returns: (transfer none): a non-floating subject owned by a static reference, like `gtk_window_new` does
 * with the toplevel window list. Release it with [func@Test.Subject.release_held].
 */
TestSubject* test_subject_new_held(void);

/**
 * test_subject_release_held:
 *
 * Drops the static reference taken by [ctor@Test.Subject.new_held].
 */
void test_subject_release_held(void);

/**
 * test_subject_sum_bytes_async:
 * @buffer: (array length=count) (element-type guint8): bytes to sum, must stay valid until @callback is called.
 * @count: number of bytes in @buffer
 * @cancellable: (nullable): a cancellable
 * @callback: (scope async): called when the operation finishes.
 * @user_data: (closure): user data passed to @callback
 *
 * Sums the bytes in @buffer, reading it only in a later main loop iteration, like `g_output_stream_write_async`
 * may do.
 */
void test_subject_sum_bytes_async(TestSubject* self, const guint8* buffer, gsize count, GCancellable* cancellable,
                                  GAsyncReadyCallback callback, gpointer user_data);

/**
 * test_subject_sum_bytes_finish:
 * @result: the result
 * Returns: the sum of the bytes.
 */
guint test_subject_sum_bytes_finish(TestSubject* self, GAsyncResult* result, GError** error);

G_END_DECLS
