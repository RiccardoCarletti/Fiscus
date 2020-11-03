<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of TEI documents into a Solr index document. -->

  <xsl:import href="tei-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:orgName[ancestor::tei:div]" group-by=".">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="inst-id" select="substring-after(@ref,'#')"/>
            <xsl:variable name="institution-id" select="document('../../content/xml/authority/listOrg.xml')//tei:org[@xml:id=$inst-id]/tei:orgName"/>
            <xsl:choose>
              <xsl:when test="$institution-id"><xsl:value-of select="$institution-id" /></xsl:when>
              <xsl:when test="$inst-id"><xsl:value-of select="$inst-id" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:orgName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
