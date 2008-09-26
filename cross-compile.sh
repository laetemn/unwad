
# mingw32 cross-compile

echo cross-compiling unwad.exe for windows

cd include/minizip
i586-mingw32msvc-gcc -c \
 -DWIN32=1 \
 -I./include -I.. \
minizip.c miniunz.c zip.c unzip.c iowin32.c ioapi.c
cd ../..

i586-mingw32msvc-g++ -Wall  \
-DMSW=1 \
 -I./include -I./include/pngpp \
unwad.cpp qmus2mid.cpp \
include/minizip/minizip.o include/minizip/ioapi.o include/minizip/iowin32.o include/minizip/zip.o include/minizip/unzip.o \
./lib/libregex.dll.a \
./lib/libmagic.dll.a \
./lib/libpng.dll.a ./lib/libz.dll.a \
-o unwad.exe

i586-mingw32msvc-strip unwad.exe

cd include/minizip
rm *.o
cd ../..