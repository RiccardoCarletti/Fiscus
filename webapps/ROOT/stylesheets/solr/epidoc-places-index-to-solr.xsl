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
      <xsl:for-each-group select="//tei:placeName[ancestor::tei:div/@type='edition']" group-by="concat(@ref, '-', ., '-', @key)">
        <xsl:variable name="pl-id" select="translate(replace(@ref, ' #', '; '), '#', '')"/>
        <xsl:variable name="place-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/tei/places.xml'))//tei:place[descendant::tei:idno=$pl-id]"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="$place-id/tei:placeName"><xsl:value-of select="$place-id/tei:placeName[1]" /> 
                <xsl:if test="$place-id/tei:placeName[2]"><xsl:text> [</xsl:text><xsl:value-of select="$place-id/tei:placeName[2]" /><xsl:text>]</xsl:text></xsl:if>
              </xsl:when>
              <xsl:when test="$pl-id and not($place-id)"><xsl:value-of select="$pl-id" /></xsl:when>
              <xsl:otherwise><xsl:text>~</xsl:text></xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_base_form">
            <xsl:value-of select="."/>
          </field>
          <field name="index_keys">
            <xsl:value-of select="translate(replace(@key, ' #', '; '), '#', '')" />
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
