
# build for linux and windows
cd ..

echo converting text files

cd tools
  g++ filechars.cpp -o ../filechars
cd ..
./filechars *.txt
rm filechars

cd src
  ../build/linux-build.sh
cd ..

rm *.txt.h
