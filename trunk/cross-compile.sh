
# mingw32 cross-compile

echo cross-compiling unwad.exe for windows

cd include/minizip
./cross-compile.sh
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