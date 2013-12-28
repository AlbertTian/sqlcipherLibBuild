#/bin/sh

argn="$#"
if test $argn -eq 0; then
  echo "Error! Need file path!"
  exit
fi

file="$1"
if test ! -d $file; then
  echo "File path not exist!($file)"
  exit
fi
echo "begin setup submodule in:$file"

#for version v2.*
#sqlchipher_tag="v2.2.1"
#for verison v3.*
#sqlchipher_tag="v3.0.1"
#opensslxcode_revison="2afe0c639d9817b22ad100d64fa6a638c81e6cd6"

hasFile=$(ls "$file/sqlcipher"|wc -w)
needInitSubmodule=0
if test $hasFile -gt 0; then
  echo "try make clean sqlcipher"
  cd "$file/sqlcipher"
  make clean
  cd ..
else
  needInitSubmodule=1
fi

hasFile=$(ls "$file/openssl-xcode"|wc -w)
if test $hasFile -eq 0; then
  needInitSubmodule=1
fi

if test $needInitSubmodule -eq 1; then
  git submodule init
fi
git submodule update --recursive
git submodule

echo "finish setup submodule"

