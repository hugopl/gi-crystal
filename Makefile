.PHONY: test generator test_binding just-test libtest

test: generator test_binding just-test

oldlibs_test: generator test_binding
	OLD_LIBS=1 ./bin/rspec

just-test:
	./bin/rspec

generator:
	shards build --error-trace

test_binding: libtest
	rm -rf build
	GI_TYPELIB_PATH="./spec/build" LIBRARY_PATH="./spec/build" LD_LIBRARY_PATH="./spec/build" ./bin/gi-crystal Test -o build

libtest:
	make --quiet -C ./spec/libtest
