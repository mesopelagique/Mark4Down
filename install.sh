#!/bin/sh

package="Mark4Down"

TMP="${TMPDIR}"
if [ "x$TMP" = "x" ]; then
  TMP="/tmp/"
fi
TMP="${TMP}$package.$$"
rm -rf "$TMP" || true
mkdir "$TMP"
if [ $? -ne 0 ]; then
  echo "failed to mkdir $TMP" >&2
  exit 1
fi

cd $TMP

echo "⬇️  Download last component"
archive=$TMP/Mark4Down.4dbase.zip 
curl -sL https://github.com/mesopelagique/$package/releases/latest/download/$package.4dbase.zip -o $archive

unzip -q $archive -d $TMP/
src=$TMP/$package.4dbase

echo "🔍 Find 4D path"
dst="/Application/4D.app"
if [ ! -d "$dst" ]; then
  dst=$(mdfind kMDItemCFBundleIdentifier = "com.4d.4d" | head -n 1)
fi

if [ -d "$dst" ]; then
  dst=$dst/Contents/Components
  if [ ! -d "$dst" ]; then
    mkdir -p "$dst"
  fi
  if [ -d "$dst/$package.4dbase" ]; then
    echo "🗑  Remove previous installation"
    rm -Rf "$dst/$package.4dbase"
  fi
  echo "⏳ Install into $dst"

  cp -Rf $src $dst/

  echo "🧹 Clean"
  rm -rf "$TMP"
else
  echo "No 4D path. Component in $src" >&2
  exit 1
fi