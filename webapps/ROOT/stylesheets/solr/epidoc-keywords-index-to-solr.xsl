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
      <xsl:for-each select="$keys"> <!-- + never used keys? -->
        <xsl:variable name="key" select="."/>
        <xsl:variable name="thes" select="document('../../content/fiscus_framework/resources/thesaurus.xml')//tei:catDesc[lower-case(@n)=lower-case($key)]"/>
        <xsl:variable name="keyword" select="$root//tei:div[@type='edition']//tei:rs[@key!=''][@key!=' '][@key!='#']/@key[contains(concat(' ', replace(lower-case(.), '#', ''), ' '), concat(' ', lower-case($key), ' '))]" />
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <xsl:if test="$thes">
          <field name="index_item_name">
            <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')" />
          </field>
          <field name="index_external_resource">
            <xsl:value-of select="concat('https://ausohnum.huma-num.fr/concept/', $thes[1]/@xml:id)" />    
          </field>
            
            <field name="index_thesaurus_hierarchy"> 
              <xsl:text>-</xsl:text>
              <!--<xsl:if test="$thes[ancestor::tei:category[5]][not(ancestor::tei:category[6])]">
              <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[2]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[3]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[4]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[5]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
            </xsl:if>
              <xsl:if test="$thes[ancestor::tei:category[4]][not(ancestor::tei:category[5])]">
              <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[2]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[3]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[4]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
            </xsl:if>
              <xsl:if test="$thes[ancestor::tei:category[3]][not(ancestor::tei:category[4])]">
              <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[2]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[3]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
            </xsl:if>
              <xsl:if test="$thes[ancestor::tei:category[2]][not(ancestor::tei:category[3])]">
              <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')"/>
              <xsl:value-of select="translate(translate($thes/ancestor::tei:category[2]/child::tei:catDesc/@n, '/', '／'), '_', ' ')"/>
            </xsl:if>
              <xsl:if test="$thes[ancestor::tei:category[1]][not(ancestor::tei:category[2])]">
              <xsl:value-of select="translate(translate($thes/@n, '/', '／'), '_', ' ')"/>
            </xsl:if>-->
            </field>
            
          </xsl:if>
          <xsl:if test="$thes/@xml:id='c26024'"><!-- to prevent having this indexed for all instances -->
            <field name="index_total_items">
            <xsl:value-of select="string(count($thesaurus//tei:catDesc))"/>
          </field>
          </xsl:if>
          <xsl:apply-templates select="$keyword" />
        </doc>
      </xsl:for-each>
    </add>
  </xsl:template>

  <xsl:template match="tei:rs/@key">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
