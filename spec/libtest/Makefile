C_SOURCE=$(wildcard *.c)
H_SOURCE=$(wildcard *.h)
OBJ = $(addprefix ../build/,$(C_SOURCE:.c=.o))
LIBRARY_NAME=test
LIBRARY_BIN=../build/lib$(LIBRARY_NAME).so
GIR=../build/Test-1.0.gir
TYPELIB=../build/Test-1.0.typelib

# To help debug the Glib macros and reproduce then in Crystal we use -save-temps here
CC_FLAGS=-save-temps -c -Wall -g -fPIC `pkg-config gobject-2.0 --cflags`
LD_FLAGS=`pkg-config gobject-2.0 --libs`

all: $(TYPELIB)

$(LIBRARY_BIN): $(OBJ)
	$(CC) -shared -o $@ $^ $(LD_FLAGS)

../build/%.o: %.c %.h
	mkdir -p ../build
	$(CC) -o $@ $< $(CC_FLAGS)

clean:
	rm -rf $(OBJ) $(LIBRARY_BIN) *~ $(GIR) $(TYPELIB)

$(GIR): $(LIBRARY_BIN)
	g-ir-scanner --warn-all --namespace=Test --nsversion=1.0 --include=GObject-2.0 /usr/ --library=$(LIBRARY_NAME) --library-path=../build --pkg=gobject-2.0 -o $(GIR) $(H_SOURCE) $(C_SOURCE)

$(TYPELIB): $(GIR)
	g-ir-compiler $(GIR) -o $(TYPELIB)
