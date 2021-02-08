<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <xsl:template match="//tei:listPlace/tei:place">
    <div class="list_item">
      <xsl:if test="tei:placeName"><p><strong><xsl:apply-templates select="tei:placeName[1]"/></strong></p></xsl:if>
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><p><strong><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)]"/></strong></p></xsl:if>
      <xsl:if test="tei:placeName[@type='other']"><p><i><xsl:text>Also known as: </xsl:text></i><xsl:apply-templates select="tei:placeName[@type='other']"/></p></xsl:if>
      <xsl:if test="tei:geogName/tei:geo"><p><i><xsl:text>Coordinates: </xsl:text></i><xsl:value-of select="tei:geogName/tei:geo"/></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="//tei:listOrg/tei:org">
    <div class="list_item">
      <xsl:if test="tei:orgName"><p><strong><xsl:apply-templates select="tei:orgName"/></strong></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listPerson/tei:person">
    <div class="list_item">
      <xsl:if test="tei:persName"><p><strong><xsl:apply-templates select="tei:persName"/></strong></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
