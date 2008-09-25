
# build for linux and windows

gcc -lstdc++ filechars.cpp -o filechars
./filechars readme.txt
rm filechars

./build-linux.sh

./cross-compile.sh