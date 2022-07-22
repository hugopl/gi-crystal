#pragma once

#include <glib-object.h>

G_BEGIN_DECLS

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
 * TestRect
 * @origin: Rect origin
 * @width:
 * @height:
 */
typedef struct _TestRect {
  TestPoint origin;
  int width;
  int height;
} TestRect;

/**
 * TestTwoPoints
 * @points: two points
 */
typedef struct _TestTwoPoints {
  TestPoint points[2];
} TestTwoPoints;

/**
 * TestStruct:
 * @in: A attribute using a invalid Crystal keyword.
 * @begin: Another attribute using a invalid Crystal keyword.
 * @point: Another struct member of this struct.
 * @string: A string
 *
 * A plain struct to test stuff
 */
typedef struct _TestStruct {
  gint16 in;
  gint16 begin;
  TestPoint* point_ptr;
  TestPoint point;
  const char* string;
  int ignored_field;
} TestStruct;

/**
 * test_struct_initialize:
 */
void test_struct_initialize(TestStruct* self);

/**
 * test_struct_finalize:
 */
void test_struct_finalize(TestStruct* self);

G_END_DECLS
