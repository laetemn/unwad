echo X                                                 X
echo X                                                 X
echo X  Warning: this batch file has not been tested.  X
echo X                                                 X
echo X                                                 X

g++ filechars.cpp -o filechars.exe
filechars readme.txt
del filechars.exe

cd include\minizip
gcc -c -DWIN32=1 -I.\include -I.. minizip.c miniunz.c zip.c unzip.c iowin32.c ioapi.c
cd ..\..

g++ -Wall -DMSW=1 unwad.cpp qmus2mid.cpp -I./include -I./include/pngpp -Ldll -lmagic1 -lzlib1 -lregex2 -llibpng13  -o unwad.exe

cd include\minizip
del *.o
cd ..\..