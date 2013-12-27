#/bin/sh

file="$1"

echo "arg1=$file"


#for version v2.*
sqlchipher_tag="v2.2.1"
#for verison v3.*
#sqlchipher_tag="v3.0.1"
opensslxcode_revison="2afe0c639d9817b22ad100d64fa6a638c81e6cd6"

cd "$file/sqlcipher"
make clean
#git branch -D working_build
#git checkout -b working_build "$sqlchipher_tag"

echo "using sqlchipher at tag: $sqlchipher_tag"

cd ../openssl-xcode
#git branch -D working_build
#git checkout -b working_build "$opensslxcode_revison"

echo "using openssl-xcode at revision: $opensslxcode_revison"

cd ..
git submodule update --recursive
git submodule

echo "finish setup submodule"

