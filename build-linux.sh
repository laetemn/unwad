
# normal build

echo building unwad

cd include/minizip
./build.sh
cd ../..

g++ -Wall \
-I./include/pngpp -I./include \
unwad.cpp qmus2mid.cpp \
include/minizip/minizip.o include/minizip/ioapi.o include/minizip/zip.o include/minizip/unzip.o \
-lmagic -lpng -lz \
-o unwad

strip unwad

cd include/minizip
rm *.o