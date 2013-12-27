#/bin/sh

BUILDTOOL="xctool"
build_exc_cmd="build"

project_file="sqlcipherLib/sqlcipherLib.xcodeproj"
scheme_name="sqlcipherLib"
configuration_name="Release"
sdk_name="iphoneos"

cmd_type="build"
if test $# -gt 0; then
  cmd_type=$1
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

if test $cmd_type = "rebuild"; then

  build_exc_cmd="clean"
  $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name" $build_exc_cmd
  build_exc_cmd="build"
  $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name" $build_exc_cmd

else

  $BUILDTOOL -project "$project_file" -scheme "$scheme_name" -configuration "$configuration_name" -sdk "$sdk_name" $build_exc_cmd

fi



