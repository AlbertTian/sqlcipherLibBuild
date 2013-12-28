#/bin/sh

BUILDTOOL="xctool"
#BUILDTOOL="xcodebuild"
build_exc_cmd="build"

project_file="sqlcipherLib/sqlcipherLib.xcodeproj"
scheme_name="sqlcipherLib"
configuration_name="Release"

cmd_type="build"
cmd_extra_option=""
if test $# -gt 0; then
  cmd_type=$1
  if test $# -gt 1; then
    cmd_extra_option=$2
  fi
else
  echo "usage: build [build, clean, rebuild] , default behavior is build."
fi

if test "clean" = $cmd_type; then
  build_exc_cmd="clean"
elif test "build" = $cmd_type; then
  build_exc_cmd="build"
elif test "rebuild" = $cmd_type; then
  build_exc_cmd="rebuild"
fi

echo "going to exec $cmd_type: $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name""
echo "press any key to continue...(or press \"n\" to cancel)"

cancel_cmd="y"
read -n1 cancel_cmd
echo $cancel_cmd
if test $cancel_cmd -a $cancel_cmd = "n"; then
  exit
fi

thisdir=`pwd`
openssl_path="$thisdir/openssl-xcode/openssl"
export OPENSSL_SRC=$openssl_path
echo "OPENSSL_SRC=$OPENSSL_SRC"
build_dir_name="build"
if test ! -d $build_dir_name; then
  mkdir $build_dir_name
fi
export BUILD_DIR="$thisdir/$build_dir_name"

cmd_extra_option="$cmd_extra_option BUILD_DIR=$BUILD_DIR"

if test $BUILDTOOL = "xcodebuild"; then
  build_exc_cmd=""
fi


sdk_name="iphonesimulator"
function fun_build()
{
  if test $cmd_type = "rebuild"; then
    build_exc_cmd="clean"
    $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name" $cmd_extra_option $build_exc_cmd
    build_exc_cmd="build"
  fi
  $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name" $cmd_extra_option $build_exc_cmd
}

fun_build

sdk_name="iphoneos"
fun_build

echo "create universal lib..."
iphoneos_lib_dir="$BUILD_DIR/Release-iphoneos"
iphonesimulator_lib_dir="$BUILD_DIR/Release-iphonesimulator"

LIBS_DIR="$thisdir/libs"
if test ! -d $LIBS_DIR; then
  mkdir $LIBS_DIR
fi

#create and check fat binary
lib_file_name="libcrypto.a"
lipo -create $iphoneos_lib_dir/$lib_file_name $iphonesimulator_lib_dir/$lib_file_name -output $LIBS_DIR/$lib_file_name
lipo -detailed_info $LIBS_DIR/$lib_file_name

lib_file_name="libsqlcipher.a"
lipo -create $iphoneos_lib_dir/$lib_file_name $iphonesimulator_lib_dir/$lib_file_name -output $LIBS_DIR/$lib_file_name
lipo -detailed_info $LIBS_DIR/$lib_file_name


