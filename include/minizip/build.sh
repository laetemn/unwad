
# normal build

gcc -c \
-Dunix=1 \
minizip.c miniunz.c zip.c unzip.c ioapi.c
# -o minizip
