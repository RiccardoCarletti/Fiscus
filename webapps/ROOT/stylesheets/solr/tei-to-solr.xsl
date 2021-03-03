<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
  
  <xsl:template match="tei:summary/tei:rs[@type='text_type']" mode="facet_ancient_document_type">
    <field name="ancient_document_type">
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="translate(translate(., '-', ''), '/', '／')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>-</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@key]" mode="facet_mentioned_keywords">
    <xsl:for-each select="tokenize(@key, ' #')">
      <field name="mentioned_keywords">
        <xsl:value-of select="lower-case(translate(translate(translate(., '_', ' '), '/', '／'), '#', ''))"/>
    </field>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="tei:geogName[@ref]" mode="facet_mentioned_estates">
    <field name="mentioned_estates">
      <xsl:variable name="ref" select="translate(@ref,' #', '')"/>
      <xsl:value-of select="translate(document('../../content/fiscus_framework/resources/estates.xml')//tei:place[descendant::tei:idno=$ref]/tei:geogName[1], '/', '／')" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName/tei:name[@nymRef]" mode="facet_person_name">
    <field name="person_name">
      <xsl:value-of select="@nymRef"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:TEI" mode="facet_complete_edition">
    <field name="complete_edition"> 
      <xsl:apply-templates select="." />
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template name="extra_fields">
    <xsl:call-template name="field_ancient_document_type"/>
    <xsl:call-template name="field_mentioned_keywords"/>
    <xsl:call-template name="field_mentioned_estates"/>
    <xsl:call-template name="field_person_name"/>
    <xsl:call-template name="field_complete_edition"/>
  </xsl:template>
  
  <xsl:template name="field_ancient_document_type">
    <xsl:apply-templates mode="facet_ancient_document_type" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary/tei:rs[@type='text_type']"/>
  </xsl:template>
  
  <xsl:template name="field_mentioned_keywords">
    <xsl:apply-templates mode="facet_mentioned_keywords" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
   <xsl:template name="field_mentioned_estates">
    <xsl:apply-templates mode="facet_mentioned_estates" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_person_name">
    <xsl:apply-templates mode="facet_person_name" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_complete_edition">
    <xsl:apply-templates mode="facet_complete_edition" select="/tei:TEI" />
  </xsl:template>

</xsl:stylesheet>
