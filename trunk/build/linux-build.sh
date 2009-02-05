#~/bin/bash

# normal build


cd ../include/minizip
  gcc -c -I.. \
  -Dunix=1 \
  minizip.c miniunz.c zip.c unzip.c ioapi.c
cd ../qmus2mid
  g++ -c \
  qmus2mid.cpp
cd ../..

export mz_dir=../include/minizip
export qm_dir=../include/qmus2mid

export includes="-I../include/pngpp -I../include -I.."
export linked="-lmagic -lpng -lz"
export static="/usr/lib/libmagic.a /usr/lib/libpng.a /usr/lib/libz.a"
export stuff="$qm_dir/qmus2mid.o $mz_dir/minizip.o $mz_dir/ioapi.o $mz_dir/zip.o $mz_dir/unzip.o"

cd src
  #echo building unwad.o
  #g++ -Wall $includes unwad.cpp -c
  echo building unwad
  #g++ -Wall $includes unwad.cpp -c
  g++ -Wall  unwad.cpp $includes $linked $stuff -o unwad
  strip unwad
  if echo "$BUILD_STATIC" | grep -q "1"; then
    #g++ -Wall $includes unwad.cpp -c
    g++ -Wall unwad.cpp $includes $static $stuff -o unwad.static
    strip unwad.static
  fi
  if echo "$BUILD_OBJECT" | grep -q "1"; then
    g++ -Wall -DUNWAD_OBJECT=1 $includes unwad.cpp -c
    #g++ -Wall unwad.cpp $includes $static $stuff -o unwad.static
    strip unwad.static
  fi
cd ..

mv include/minizip/*.o ../obj
mv include/qmus2mid/*.o ../obj
mv src/*.o ../obj
