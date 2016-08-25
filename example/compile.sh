#! /bin/sh

src_files=`find . -name "*.sl" -type f`
for file in $src_files; do
  echo "compiling $file ..."
  ../bin/slang -c $file
  tcc -o ${file%%.sl} ${file%%.sl}.c -lSDL2 -L/usr/local/lib
done
