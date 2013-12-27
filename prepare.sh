#/bin/sh
#prepare openssl src

# using these variables to config openssl src version
opensslsrc_pkg="openssl-1.0.1e.tar.gz"
opensslsrc_pkg_dirname="openssl-1.0.1e"
# custom variables end


Xsed='/usr/bin/sed -e 1s/^X//'
ECHO="/bin/echo"
file="$0"
thisdir=`$ECHO "X$file" | $Xsed -e 's%/[^/]*$%%'`
opensslsrcdir="openssl-src"


# Find the directory that this script lives in.
thisdir=`$ECHO "X$file" | $Xsed -e 's%/[^/]*$%%'`
test "x$thisdir" = "x$file" && thisdir=.

# Follow symbolic links until we get to the real thisdir.
file=`ls -ld "$file" | /usr/bin/sed -n 's/.*-> //p'`
while test -n "$file"; do
  destdir=`$ECHO "X$file" | $Xsed -e 's%/[^/]*$%%'`

  # If there was a directory component, then change thisdir.
  if test "x$destdir" != "x$file"; then
    case "$destdir" in
      [\\/]* | [A-Za-z]:[\\/]*) thisdir="$destdir" ;;
    *) thisdir="$thisdir/$destdir" ;;
  esac
fi

file=`$ECHO "X$file" | $Xsed -e 's%^.*/%%'`
file=`ls -ld "$thisdir/$file" | /usr/bin/sed -n 's/.*-> //p'`
  done


  # Usually 'no', except on cygwin/mingw when embedded into
  # the cwrapper.
  WRAPPER_SCRIPT_BELONGS_IN_OBJDIR=no
  if test "$WRAPPER_SCRIPT_BELONGS_IN_OBJDIR" = "yes"; then
    # special case for '.'
    if test "$thisdir" = "."; then
      thisdir=`pwd`
    fi
    # remove .libs from thisdir
    case "$thisdir" in
      *[\\/].libs ) thisdir=`$ECHO "X$thisdir" | $Xsed -e 's%[\\/][^\\/]*$%%'` ;;
    .libs )   thisdir=. ;;
  esac
fi

# Try to get the absolute directory name.
absdir=`cd "$thisdir" && pwd`
test -n "$absdir" && thisdir="$absdir"

srcdir="$thisdir/$opensslsrcdir"
srcpkg="$thisdir/$opensslsrc_pkg"

if test -e "$srcpkg"; then
  srcpkg_dir="$thisdir/$opensslsrc_pkg_dirname"
  if test -e "$srcdir"; then
    $ECHO "remove existing $srcdir"
    rm -rf "$srcdir"
  fi
  if test -e "srcpkg_dir"; then
    $ECHO "remove existing tmp $srcpkg_dir"
    rm -rf "$srcpkg_dir"
  fi

  tar -xzf "$srcpkg"
  mv "$srcpkg_dir" "$srcdir"
  $ECHO "finish prepare openssl-src from $opensslsrc_pkg"
else
  $ECHO "Error! $srcpkg not found!"
fi

$ECHO "begin setup submodule"
$thisdir/setup_submodule.sh "$thisdir"



