
# windblows build

i586-mingw32msvc-gcc -c \
 -DWIN32=1 \
 -I./include -I.. \
minizip.c miniunz.c zip.c unzip.c iowin32.c ioapi.c
# -o minizip
