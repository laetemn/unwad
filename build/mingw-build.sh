# Thanks to MP2E for putting together this version of the build script =) 

echo Preparing readme.txt...

g++ -O2 tools/filechars.cpp -o filechars.exe
strip filechars.exe
filechars.exe readme.txt
cp readme.txt.h include/readme.txt.h

echo Compiling MiniZip

cd include/minizip
gcc -c -DWIN32=1 -O2 -I./include -I.. minizip.c miniunz.c zip.c unzip.c iowin32.c ioapi.c
cd ../..

echo Compiling UnWad

g++ -Wall -DMSW=1 -O2 -I./include -I./include/pngpp src/unwad.cpp include/qmus2mid/qmus2mid.cpp include/minizip/minizip.o include/minizip/ioapi.o include/minizip/iowin32.o include/minizip/zip.o include/minizip/unzip.o ./lib/libregex.dll.a ./lib/libmagic.dll.a ./lib/libpng.dll.a ./lib/libz.dll.a -o unwad.exe
strip unwad.exe
