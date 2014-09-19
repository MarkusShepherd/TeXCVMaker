<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" >

    <xsl:output method="text" encoding="utf-8"/>

    <xsl:param name="cv-name" select="cv/settings/name/normalize-space()" as="xs:string"/>
    <xsl:param name="cv-address" select="cv/settings/address/normalize-space()" as="xs:string?"/>
    <xsl:param name="cv-phone" select="cv/settings/phone/normalize-space()" as="xs:string?"/>
    <xsl:param name="cv-email" select="cv/settings/email/normalize-space()" as="xs:string?"/>
    <xsl:param name="cv-nationality" select="cv/settings/nationality/normalize-space()" as="xs:string?"/>
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

% \bibliographystyle{amsalpha}
% \selectbiblanguage{english}

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
\vspace{1cm}

\begin{tabular}{p{<xsl:value-of select="$cv-tab-left"/>\textwidth}p{<xsl:value-of select="$cv-tab-right"/>\textwidth}}
  \sffamily \textit{Contact}     &amp; \sffamily \Letter{} <xsl:value-of select="$cv-address"/>
                                   \newline \Telefon{} <xsl:value-of select="$cv-phone"/>
                                   \newline \Email{} \href{mailto:<xsl:value-of select="$cv-email"/>}{<xsl:value-of select="$cv-email"/>} \\
  \sffamily \textit{Nationality} &amp; \sffamily <xsl:value-of select="$cv-nationality"/>
\end{tabular}

<xsl:apply-templates select="section"/>

\end{document}
</xsl:template>

<xsl:template match="section" as="text()*">
\vspace{<xsl:value-of select="$cv-space-before"/>}\textbf{\textit{<xsl:value-of select="title/normalize-space()"/>}}
    
\begin{tabular}{p{<xsl:value-of select="$cv-tab-left"/>\textwidth}p{<xsl:value-of select="$cv-tab-right"/>\textwidth}}

<xsl:apply-templates select="item"/>

\end{tabular}
    
</xsl:template>

<xsl:template match="item" as="text()*">

  \sffamily <xsl:apply-templates select="label"/> &amp; \sffamily <xsl:apply-templates select="content"/> \\

</xsl:template>

<xsl:template match="label | content" as="text()*">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()" as="text()">
    <xsl:value-of select="normalize-space()"/>
</xsl:template>

<xsl:template match="strong" as="text()*">\textbf{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="emph" as="text()*">\textit{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="br" as="text()*"> \newline </xsl:template>

<xsl:template match="list" as="text()*">
    <xsl:for-each select="item">
        <xsl:apply-templates/>
        <xsl:if test="position() ne last()">
            <xsl:text> \textopenbullet{} </xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
