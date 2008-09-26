
# build for linux and windows

echo converting text files

g++ filechars.cpp -o filechars
./filechars readme.txt
rm filechars

./build-linux.sh

./cross-compile.sh

rm *.txt.h

echo preparing release packages

mkdir release/l; mkdir release/w
export l=./release/l/unwad/
export w=./release/w/unwad/
mkdir $l; mkdir $w
mkdir $l/magic; mkdir $w/magic
cp  magic/* $l/magic; cp  magic/* $w/magic
cp *.txt $l; cp *.txt $w
mv unwad.static $l/unwad
mv unwad.exe $w; cp *.dll $w

cd ./release/l/
rm ../linux/unwad.tar.gz
tar -cvvf ../linux/unwad.tar unwad/
gzip ../linux/unwad.tar

cd ../w/
rm ../windows/unwad.zip 
zip -r ../windows/unwad.zip unwad/

cd ../.. ; rm -r release/l; rm -r release/w