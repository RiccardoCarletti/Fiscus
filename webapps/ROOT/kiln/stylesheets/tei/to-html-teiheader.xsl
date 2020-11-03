<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's teiHeader into HTML. -->

  <xsl:template match="tei:teiHeader">
    <!-- Display metadata about this document, drawn from the TEI header. -->
    <div>
    <!--<p>Documento: <xsl:apply-templates select="//tei:titleStmt/tei:title"/></p>-->
      <p><strong>Responsabili scheda</strong>: <xsl:for-each select="//tei:editor[ancestor::tei:titleStmt]"><xsl:apply-templates select="."/><!--<xsl:if test="@role"><xsl:text> (</xsl:text><xsl:choose>
        <xsl:when test="@role='edition'"><xsl:text>edizione</xsl:text></xsl:when>
        <xsl:when test="@role='encoding'"><xsl:text>codifica</xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="@role"/></xsl:otherwise>
      </xsl:choose><xsl:text>)</xsl:text></xsl:if>--><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><br/>
        <strong>Numero scheda</strong>: <xsl:apply-templates select="//tei:publicationStmt/tei:authority"/><xsl:text> </xsl:text><xsl:apply-templates select="//tei:publicationStmt/tei:idno[@type='filename']"/> <xsl:text> (pubblicazione online: </xsl:text><xsl:value-of select="//tei:publicationStmt/tei:date/@when"/><xsl:text>)</xsl:text></p>
    </div>
    <div>
      <p><strong>Collocazione del documento</strong>: <xsl:apply-templates select="//tei:msIdentifier/tei:repository"/> <xsl:apply-templates select="//tei:msIdentifier/tei:idno[@type='invNo']"/><br/>
        <strong>Edizioni del documento</strong>: <xsl:for-each select="//tei:bibl[ancestor::tei:listBibl]"><xsl:apply-templates select="."/><xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if><xsl:if test="position()=last()"><xsl:text>.</xsl:text></xsl:if></xsl:for-each><br/>
        <strong>Tipologia di documento</strong>: <xsl:apply-templates select="//tei:summary/tei:term[@type='textType']"/><br/> <!-- *** -->
        <strong>Provenienza</strong>: <xsl:apply-templates select="//tei:origPlace"/><br/>
        <strong>Data</strong>: <xsl:apply-templates select="//tei:origDate"/></p>
    </div>
    <div>
      <p><strong>Luoghi</strong>: <xsl:for-each select="//tei:placeName[ancestor::tei:listPlace]"><xsl:apply-templates select="."/><xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if><xsl:if test="position()=last()"><xsl:text>.</xsl:text></xsl:if></xsl:for-each><br/>
        <strong>Persone</strong>: <xsl:for-each select="//tei:persName[ancestor::tei:listPerson]"><xsl:apply-templates select="."/><xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if><xsl:if test="position()=last()"><xsl:text>.</xsl:text></xsl:if></xsl:for-each><br/>
      <strong>Istituzioni/Enti</strong>: <xsl:for-each select="//tei:orgName[ancestor::tei:listOrg]"><xsl:apply-templates select="."/><xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if><xsl:if test="position()=last()"><xsl:text>.</xsl:text></xsl:if></xsl:for-each></p>
    </div>
    
    <xsl:if test="//tei:summary/tei:p/text()">
      <div>
        <h3>Regesto</h3>
        <xsl:apply-templates select="//tei:summary/tei:p"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:foreign">
    <i><xsl:apply-templates /></i>
  </xsl:template>

  <xsl:template match="tei:change">
    <li>
      <xsl:apply-templates select="@when" />
      <xsl:apply-templates />
      <xsl:apply-templates select="@who" />
    </li>
  </xsl:template>
  
  <xsl:template match="tei:respStmt">
    <p>
      <strong>
        <xsl:apply-templates select="tei:resp" />
        <xsl:text>: </xsl:text>
      </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:*[not(local-name()='resp')]" />
    </p>
  </xsl:template>

  <xsl:template match="tei:revisionDesc">
    <section>
      <h2 class="title" data-section-title="">
        <small><a href="#">File changelog</a></small>
      </h2>
      <div class="content" data-section-content="">
        <ul class="no-bullet">
          <xsl:apply-templates />
        </ul>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="tei:change/@when">
    <strong>
      <xsl:value-of select="." />
      <xsl:text>:</xsl:text>
    </strong>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:change/@who">
    <xsl:text> [</xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with(., '#')">
        <xsl:variable name="who-id" select="substring(., 2)" />
        <xsl:apply-templates select="ancestor::tei:teiHeader//*[@xml:id=$who-id]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>] </xsl:text>
  </xsl:template>

</xsl:stylesheet>
