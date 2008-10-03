
# build for linux and windows
cd ..

echo converting text files

cd tools
  g++ filechars.cpp -o ../filechars
cd ..
./filechars *.txt
rm filechars

export BUILD_STATIC=1

cd src
  ../build/linux-build.sh
  ../build/cross-compile.sh
cd ..

rm *.txt.h

echo preparing release packages

mkdir release/l; mkdir release/w
export l=./release/l/unwad/
export w=./release/w/unwad/
mkdir $l; mkdir $w
mkdir $l/magic; mkdir $w/magic
cp  magic/* $l/magic; cp  magic/* $w/magic
cp *.txt $l; cp *.txt $w
mv src/unwad.static $l/unwad
mv src/unwad.exe $w; cp dll/*.dll $w
mv src/unwad build

cd ./release/l/
rm ../linux/unwad.tar.gz
tar -cvvf ../linux/unwad.tar unwad/
gzip ../linux/unwad.tar

cd ../w/
rm ../windows/unwad.zip 
zip -r ../windows/unwad.zip unwad/

cd ../.. ; rm -r release/l; rm -r release/w
