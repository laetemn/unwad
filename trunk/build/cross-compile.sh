
# mingw32 cross-compile

cd ../include/minizip
  i586-mingw32msvc-gcc -c -I.. \
 -DWIN32=1 \
  minizip.c miniunz.c zip.c unzip.c ioapi.c iowin32.c
cd ../qmus2mid
  i586-mingw32msvc-g++ -c \
  qmus2mid.cpp
cd ../..

export includes="-I../include/pngpp -I../include -I.."
export mz_dir=../include/minizip
export qm_dir=../include/qmus2mid
export bs="i586-mingw32msvc-g++ -DMSW=1 -Wall $includes unwad.cpp \
$qm_dir/qmus2mid.o \
$mz_dir/minizip.o $mz_dir/ioapi.o $mz_dir/iowin32.o $mz_dir/zip.o $mz_dir/unzip.o"
export static="../lib/libmagic.dll.a ../lib/libpng.dll.a ../lib/libz.dll.a ../lib/libregex.dll.a"

cd src
  echo building unwad for windows
  #cp ../dll/* .
  $bs $static -o unwad.exe
  i586-mingw32msvc-strip unwad.exe
  #rm *.dll
cd ..


rm include/minizip/*.o
rm include/qmus2mid/*.o