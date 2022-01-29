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

compare:
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" bin/compare-api --binding="spec/libtest_binding.yml" --before-build="make libtest && shards build --without-development" $(OLD_VERSION) $(NEW_VERSION)

doc: test_binding
	crystal doc src/gi-crystal.cr src/auto/test-1.0/test.cr
