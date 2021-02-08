<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:persName[ancestor::tei:div/@type='edition']" group-by="concat(., '-', @ref, '-', @key)">
        <xsl:variable name="pers-id" select="translate(replace(@ref, ' #', '; '), '#', '')"/>
        <xsl:variable name="person-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/tei/people.xml'))//tei:person[descendant::tei:idno=$pers-id]/tei:persName"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="." />
          </field>
          <field name="index_base_form">
            <xsl:choose>
              <xsl:when test="$person-id"><xsl:value-of select="$person-id" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="$pers-id" /></xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_keys">
            <xsl:value-of select="translate(replace(@key, ' #', '; '), '#', '')" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
