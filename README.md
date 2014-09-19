TeXCVMaker
==========

Simple tool to create CVs in TeX from XML input files

Run:
java -jar lib/saxon9he.jar -s:input.xml -xsl:xslt/xml2tex.xsl -o:output.tex
pdflatex output.tex
