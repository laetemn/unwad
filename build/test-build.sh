
# build for linux and windows
cd ..

echo converting text files

cd tools
  g++ filechars.cpp -o ../filechars
cd ..
./filechars *.txt
rm filechars

cd build
  ./linux-build.sh
  mv ../src/unwad .
cd ..

rm *.txt.h
