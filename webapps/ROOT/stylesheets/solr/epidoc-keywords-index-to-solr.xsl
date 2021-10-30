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
    
    <xsl:variable name="key-values">
      <xsl:for-each select="//tei:rs[ancestor::tei:div/@type='edition'][@key!=''][@key!=' '][@key!='#']/@key">
        <xsl:value-of select="replace(lower-case(.), '#', '')" />
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="keys" select="distinct-values(tokenize($key-values, '\s+'))" />
    
    <add>
      <xsl:for-each select="$keys">
        <xsl:variable name="key-value" select="."/>
        <xsl:variable name="key" select="document('../../content/fiscus_framework/resources/thesaurus.xml')//tei:catDesc[lower-case(@n)=$key-value]"/>
        <xsl:variable name="keyword" select="$root//tei:div[@type='edition']//tei:rs[@key!=''][@key!=' '][@key!='#']/@key[contains(concat(' ', replace(lower-case(.), '#', ''), ' '), concat(' ', $key-value, ' '))]" />
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="normalize-space(replace($key-value, '_', ' '))" />
          </field>
          <field name="index_external_resource">
              <xsl:if test="$key">
                <xsl:value-of select="concat('https://ausohnum.huma-num.fr/concept/', $key[1]/@xml:id)" />
              </xsl:if>
          </field>
          <field name="index_total_items">
            <xsl:value-of select="string(count(document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/thesaurus.xml'))//tei:catDesc))"/>
          </field>
          <xsl:apply-templates select="$keyword" />
        </doc>
      </xsl:for-each>
    </add>
  </xsl:template>

  <xsl:template match="tei:rs/@key">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
