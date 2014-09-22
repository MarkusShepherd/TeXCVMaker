#!/bin/sh

IN=$1
TEX=${IN%.*}.tex

java -jar lib/saxon9he.jar -s:$IN -xsl:xslt/xml2tex.xsl -o:$TEX
pdflatex $TEX
pdflatex $TEX

