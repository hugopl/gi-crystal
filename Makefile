.PHONY: test just-test oldlibs-test generator test-binding libtest compare recompare doc

test: test-binding
	./bin/rspec

just-test:
	./bin/rspec

oldlibs-test: test-binding
	OLD_LIBS=1 ./bin/rspec


generator:
	shards build --error-trace

test-binding: libtest generator
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" ./bin/gi-crystal spec/libtest_binding.yml -o src/auto

libtest:
	+make --quiet -C ./spec/libtest

compare:
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" bin/compare-api --binding="spec/libtest_binding.yml" --before-build="make libtest && shards build --without-development" $(OLD_VERSION) $(NEW_VERSION)

recompare:
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" bin/compare-api --skip-old --binding="spec/libtest_binding.yml" --before-build="make libtest && shards build --without-development" $(OLD_VERSION) $(NEW_VERSION)

doc: test_binding
	crystal doc src/gi-crystal.cr src/auto/test-1.0/test.cr
