#include "test_struct.h"

void test_struct_initialize(TestStruct* self) {
  self->string = "hey";
}

void test_struct_finalize(TestStruct* self) {
}
