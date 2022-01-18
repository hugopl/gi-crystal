.PHONY: test generator test_binding just-test libtest doc

test: generator test_binding just-test

oldlibs_test: generator test_binding
	OLD_LIBS=1 ./bin/rspec

just-test:
	./bin/rspec

generator:
	shards build --error-trace --without-development

test_binding: libtest
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" ./bin/gi-crystal spec/libtest_binding.yml -o src/auto

libtest:
	make --quiet -C ./spec/libtest

doc: test_binding
	crystal doc src/gi-crystal.cr src/auto/g_lib-2.0/g_lib.cr src/auto/g_object-2.0/g_object.cr
