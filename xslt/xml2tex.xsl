<?xml version="1.0" encoding="UTF-8"?>

<!--

    TeXCVMaker
    Copyright (C) 2014  Markus Schepke

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.schepke.info/my">

<xsl:output method="text" encoding="utf-8"/>

<xsl:param name="cv-name" select="cv/settings/name/normalize-space()" as="xs:string"/>
<xsl:param name="cv-address" select="cv/settings/address/normalize-space()" as="xs:string?"/>
<xsl:param name="cv-phone" select="cv/settings/phone/normalize-space()" as="xs:string*"/>
<xsl:param name="cv-email" select="cv/settings/email/normalize-space()" as="xs:string*"/>
<xsl:param name="cv-website" select="cv/settings/website/normalize-space()" as="xs:string*"/>
<xsl:param name="cv-nationality" select="cv/settings/nationality/normalize-space()" as="xs:string*"/>
<xsl:param name="cv-space-before" select="cv/settings/property[@key eq 'space-before']/normalize-space()" as="xs:string?"/>
<xsl:param name="cv-tab-left" select="cv/settings/property[@key eq 'tab-left']/normalize-space()" as="xs:string?"/>
<xsl:param name="cv-tab-right" select="cv/settings/property[@key eq 'tab-right']/normalize-space()" as="xs:string?"/>

<xsl:template match="cv" as="text()*">
\documentclass[10pt, a4paper, onecolumn, oneside]{scrartcl}
\usepackage[latin1]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[english]{babel}
\usepackage{parskip, graphicx, textcomp, marvosym}
\usepackage[pdftex, bookmarks, hyperindex, pdfborder={0 0 0}, pdftitle={Curriculum Vitae}, pdfauthor={<xsl:value-of select="$cv-name"/>}, pdfsubject={Curriculum Vitae of <xsl:value-of select="$cv-name"/>}, pdfkeywords={Curriculum Vitae, CV, R\'{e}sum\'{e}, Lebenslauf, <xsl:value-of select="$cv-name"/>}]{hyperref}
\usepackage[top=1.5cm, bottom=2cm, left=2cm, right=2cm]{geometry}
\title{Curriculum Vitae}
\author{<xsl:value-of select="$cv-name"/>}
\date{\today}
\pdfinfo{
  /Author(<xsl:value-of select="$cv-name"/>)
  /Creator(TeXCVMaker)
  /Title(Curriculum Vitae)
  /Subject(Curriculum Vitae of <xsl:value-of select="$cv-name"/>)
  /Keywords(Curriculum Vitae, CV, R\'{e}sum\'{e}, Lebenslauf, <xsl:value-of select="$cv-name"/>)
}
\pagestyle{empty}
\hyphenation{}
\begin{document}
\begin{center}
  \LARGE\textbf{\textsc{<xsl:value-of select="$cv-name"/>}}
\end{center}
\vspace{<xsl:value-of select="$cv-space-before"/>}
\begin{tabular}{p{<xsl:value-of select="$cv-tab-left"/>\textwidth}p{<xsl:value-of select="$cv-tab-right"/>\textwidth}}
  \sffamily \textit{Contact}     &amp; \sffamily <xsl:value-of select="my:address($cv-address)"/>
                                   \newline \Telefon{} <xsl:value-of select="string-join($cv-phone, ' \textopenbullet{} ')"/>
                                   \newline <xsl:value-of select="my:email($cv-email)"/>
                                   <xsl:if test="exists($cv-website)">\newline \ComputerMouse{} <xsl:value-of select="string-join(for $w in $cv-website return concat('\href{http://', $w, '/}{', $w, '}'), ' \textopenbullet{} ')"/></xsl:if> \\
  \sffamily \textit{Nationality} &amp; \sffamily <xsl:value-of select="string-join($cv-nationality, ' \textopenbullet{} ')"/>
\end{tabular}
<xsl:apply-templates select="section | pagebreak | p"/>
\end{document}
</xsl:template>

<xsl:template match="pagebreak" as="text()+">
\clearpage
\begin{center}
  {\LARGE\textbf{\textsc{<xsl:value-of select="$cv-name"/>}}} {\Large\textit{(continued)}}
\end{center}
</xsl:template>

<xsl:template match="section[item]" as="text()*">
\vspace{<xsl:value-of select="$cv-space-before"/>}\textbf{\textit{<xsl:apply-templates select="title/text()"/>}}

\begin{tabular}{p{<xsl:value-of select="$cv-tab-left"/>\textwidth}p{<xsl:value-of select="$cv-tab-right"/>\textwidth}}
<xsl:apply-templates select="item"/>
\end{tabular}
</xsl:template>

<xsl:template match="section[p]" as="text()*">
\vspace{<xsl:value-of select="$cv-space-before"/>}\textbf{\textit{<xsl:apply-templates select="title/text()"/>}}

<xsl:apply-templates select="p"/>
</xsl:template>

<xsl:template match="item" as="text()*">
  \sffamily <xsl:apply-templates select="label"/> &amp; \sffamily <xsl:apply-templates select="content"/> \\
</xsl:template>

<xsl:template match="label | content" as="text()*">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="p" as="text()+">
{\sffamily <xsl:apply-templates/>}
</xsl:template>

<xsl:template match="text()" as="text()">
    <xsl:value-of select="my:escape-tex(replace(., '\s+', ' '))"/>
</xsl:template>

<xsl:template match="strong" as="text()+">\textbf{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="emph" as="text()+">\textit{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="a" as="text()+">\href{<xsl:value-of select="@href"/>}{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="latex" as="text()"><xsl:value-of select="."/></xsl:template>

<xsl:template match="address" as="text()"><xsl:value-of select="my:address(my:escape-tex(normalize-space()))"/></xsl:template>

<xsl:template match="email" as="text()"><xsl:value-of select="my:email(normalize-space())"/></xsl:template>

<xsl:template match="br" as="text()"> \newline </xsl:template>

<xsl:template match="quad" as="text()"> \quad </xsl:template>

<xsl:template match="list" as="text()*">
    <xsl:for-each select="item">
        <xsl:apply-templates/>
        <xsl:if test="position() ne last()">
            <xsl:text> \textopenbullet{} </xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:function name="my:escape-tex" as="xs:string*">
    <xsl:param name="input" as="xs:string*"/>

    <xsl:for-each select="$input">
        <xsl:sequence select="replace(replace(replace(replace(., '([#$%&amp;\\^_{}~])', '\\$1'), '\\\\', '\\textbackslash{}'), '\\\^', '\\^{}'), '\\~', '\\~{}')"/>
    </xsl:for-each>
</xsl:function>

<xsl:function name="my:address" as="xs:string">
    <xsl:param name="input" as="xs:string*"/>

    <xsl:sequence select="if (exists($input))
                          then concat('\Letter{} ', string-join($input, ' \textopenbullet{} '))
                          else ''"/>
</xsl:function>

<xsl:function name="my:email" as="xs:string">
    <xsl:param name="input" as="xs:string*"/>

    <xsl:sequence select="if (exists($input))
                          then concat('\Email{} ', string-join(
                              for $i in $input
                              return concat('\href{mailto:', $i, '}{', $i, '}'),
                              ' \textopenbullet{} '))
                          else ''"/>
</xsl:function>

</xsl:stylesheet>
