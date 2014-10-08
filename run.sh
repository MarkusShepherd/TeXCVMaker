#!/bin/sh

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

IN=$1
TEX=${IN%.*}.tex
OUTDIR=`dirname "$1"`

java -jar "$DIR/lib/saxon9he.jar" -s:"$IN" -xsl:"$DIR/xslt/xml2tex.xsl" -o:"$TEX" || exit 1
pdflatex -output-directory "$OUTDIR" "$TEX" || exit 1
pdflatex -output-directory "$OUTDIR" "$TEX" || exit 1

