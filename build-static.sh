
# static build (no .so / .dll)

g++ -Wall \
-I./include/pngpp \
unwad.cpp qmus2mid.cpp \
/usr/lib/libboost_filesystem.a /usr/lib/libboost_regex.a \
/usr/lib/libmagic.a \
/usr/lib/libpng.a /usr/lib/libz.a \
-o unwad

strip unwad