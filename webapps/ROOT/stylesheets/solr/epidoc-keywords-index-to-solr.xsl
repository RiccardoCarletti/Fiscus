<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of keywords in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <xsl:variable name="root" select="." />
    
    <!--<xsl:variable name="key-values">
      <xsl:for-each select="//tei:rs[ancestor::tei:div/@type='edition']/@key">
        <xsl:value-of select="translate(normalize-space(.), ', ', '__')" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keys" select="distinct-values(tokenize($key-values, '__'))" />
    
    <add>
      <xsl:for-each select="$keys">
        <xsl:variable name="key-value" select="." />
        <xsl:variable name="keyword" select="$root//tei:div[@type='edition']//tei:rs[contains(@key, $key-value)]" />
        <xsl:variable name="keyword_ref" select="$root//tei:rs[ancestor::tei:div/@type='edition'][contains(@key, $key-value)]/@ref" />
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="$key-value" />
          </field>
          <!-\-<field name="index_base_form">
            <xsl:value-of select="$keyword_ref" />
          </field>
          <field name="index_keys">
            <xsl:value-of select="$keyword" />
          </field>-\->
          <xsl:apply-templates select="." />
        </doc>
      </xsl:for-each>
    </add>-->
    
      <add>
        <xsl:for-each-group select="//tei:rs[ancestor::tei:div/@type='edition']" group-by="concat(., '-', @ref, '-', @key)">
          <xsl:variable name="key-values">
            <xsl:for-each select="@key"><xsl:value-of select="translate(normalize-space(.), ', ', '__')" /></xsl:for-each>
          </xsl:variable>
          <xsl:variable name="keys" select="distinct-values(tokenize($key-values, '__'))" />
          <xsl:variable name="key-value">
            <xsl:for-each select="$keys"><xsl:value-of select="." /></xsl:for-each>
          </xsl:variable>
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
          <!--<field name="index_base_form">
            <xsl:value-of select="@ref" />
          </field>-->
            <field name="index_keys">
              <xsl:value-of select="@key" />
            </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
      </add>
  </xsl:template>

  <xsl:template match="tei:rs">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
