<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="t" version="2.0">
  <!-- Contains named templates for fiscus file structure (aka "metadata" aka "supporting data") -->

  <!-- Called from htm-tpl-structure.xsl -->

  <xsl:template name="fiscus-body-structure">
    <div id="metadata">
      <p>
        <b>Title: </b>
        <xsl:apply-templates select="//t:titleStmt/t:title"/>
        <br/>
        <b>Document number: </b>
        <xsl:value-of select="substring-after(replace(//t:publicationStmt//t:idno, ' ', ''), 'doc')"/>
        <br/>
        <b>Author(s): </b>
        <xsl:variable name="first-author" select="lower-case(//t:change[1]/@who)"/>
        <xsl:variable name="last-author" select="lower-case(//t:change[last()]/@who)"/>
        <xsl:variable name="name" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/tei/team.xml'))//t:p[@xml:id]"/> 
        <xsl:variable name="first-author-name" select="$name[@xml:id=$first-author]"/>
        <xsl:variable name="last-author-name" select="$name[@xml:id=$last-author]"/>
        <xsl:choose>
          <xsl:when test="$first-author-name"><xsl:value-of select="$first-author-name/t:emph"/></xsl:when>
          <xsl:when test="$first-author"><xsl:value-of select="$first-author"/></xsl:when>
          <xsl:otherwise><xsl:text>-</xsl:text></xsl:otherwise>
        </xsl:choose>
        <xsl:text> (file creation on </xsl:text><xsl:value-of select="//t:change[1]/@when"/><xsl:text>); </xsl:text>
        <xsl:choose>
          <xsl:when test="$last-author-name"><xsl:value-of select="$last-author-name/t:emph"/></xsl:when>
          <xsl:when test="$last-author"><xsl:value-of select="$last-author"/></xsl:when>
          <xsl:otherwise><xsl:text>-</xsl:text></xsl:otherwise>
        </xsl:choose>
        <xsl:text> (last change on </xsl:text><xsl:value-of select="//t:change[last()]/@when"/><xsl:text>)</xsl:text>
        <!--<xsl:for-each select="//t:change"><xsl:value-of select="@who"/>
         <xsl:text> (</xsl:text><xsl:value-of select="@when"/><xsl:text>). </xsl:text>
       </xsl:for-each>-->
        <br/>
        <b>Record source: </b>
        <xsl:apply-templates select="//t:summary/t:rs[@type = 'record_source']"/>
        <br/>
        <b>Document type: </b>
        <xsl:value-of select="translate(//t:summary/t:rs[@type = 'text_type'], '-', '')"/>
        <br/>
          <b>Document tradition: </b>
        <xsl:apply-templates select="//t:summary/t:rs[@type = 'document_tradition']"/>
        <br/>
        <b>Fiscal property: </b>
        <xsl:apply-templates select="//t:summary/t:rs[@type = 'fiscal_property']"/>
        <xsl:if test="//t:origPlace/node()"><br/>
        <b>Provenance: </b>
        <xsl:apply-templates select="//t:origPlace"/></xsl:if>
      </p>
      <p>
        <b>Date: </b>
        <xsl:apply-templates select="//t:origin/t:origDate/t:note[@type = 'displayed_date']/node()"/>
        <xsl:if test="//t:origin/t:origDate/t:note[@type = 'topical_date']/node()"><br/>
        <b>Topical date: </b>
        <xsl:apply-templates select="//t:origin/t:origDate/t:note[@type = 'topical_date']/node()"/></xsl:if>
        <xsl:if test="//t:origin/t:origDate/t:note[@type = 'dating_elements']/node()"><br/>
        <b>Dating elements: </b>
        <xsl:apply-templates select="//t:origin/t:origDate/t:note[@type = 'dating_elements']/node()"/></xsl:if>
        <xsl:if test="//t:origin/t:origDate/t:note[@type = 'redaction_date']/node()"><br/>
          <b>Date/period of redaction: </b>
          <xsl:apply-templates select="//t:origin/t:origDate/t:note[@type = 'redaction_date']/node()"/></xsl:if>
      </p>

      <p id="toggle_buttons"><b>Show/hide in the text: </b>
        <button class="placeName" id="toggle_placeName">places</button>
        <button class="persName" id="toggle_persName">people</button>
        <button class="orgName" id="toggle_orgName">juridical persons</button>
        <button class="geogName" id="toggle_geogName">estates</button>
        <button class="date" id="toggle_date">dates</button>
        <button class="rs" id="toggle_rs">keywords</button>
        <button class="links" id="toggle_links">links</button>
      </p>
      <script>
         $(document).ready(function(){
         $("#toggle_persName").click(function(){
         $(".persName").toggleClass("_persName");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_placeName").click(function(){
         $(".placeName").toggleClass("_placeName");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_orgName").click(function(){
         $(".orgName").toggleClass("_orgName");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_geogName").click(function(){
         $(".geogName").toggleClass("_geogName");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_date").click(function(){
         $(".date").toggleClass("_date");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_rs").click(function(){
         $(".rs").toggleClass("_rs");
         });
         });
         
         $(document).ready(function(){
         $("#toggle_links").click(function(){
         $(".links").toggleClass("_links");
         });
         });
       </script>
    </div>

    <div class="content" id="edition" data-section-content="data-section-content">
      <xsl:variable name="edtxt">
        <xsl:apply-templates select="//t:div[@type = 'edition']">
          <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
    </div>

    <div id="apparatus">
      <xsl:variable name="apptxt">
        <xsl:apply-templates select="//t:div[@type = 'apparatus']"/>
      </xsl:variable>
      <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
    </div>

    <xsl:if test="//t:div[@type='edition']//t:rs[@key!='']">
      <div id="keywords">
        <xsl:variable name="doc_keys">
          <xsl:for-each select="//t:div[@type='edition']//t:rs[@key!='']">
            <xsl:value-of select="lower-case(translate(@key, '#', ''))"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="unique_keys" select="distinct-values(tokenize($doc_keys, '\s+?'))"/>
        <xsl:variable name="sorted_keys"><xsl:for-each select="$unique_keys"><xsl:sort/><xsl:value-of select="replace(., '_', ' ')"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
        <p><b><i18n:text i18n:key="epidoc-xslt-fiscus-keywords">Keywords</i18n:text>: </b>
          <xsl:value-of select="$sorted_keys"/><xsl:text>.</xsl:text></p>
      </div>
    </xsl:if>
    
    <div id="bibliography">
      <xsl:if test="//t:div[@type = 'bibliography'][@subtype = 'editions']/t:p/node()"><p>
        <b><i18n:text i18n:key="epidoc-xslt-fiscus-bibliography">Editions and document
            summaries</i18n:text>: </b>
        <xsl:apply-templates select="//t:div[@type = 'bibliography'][@subtype = 'editions']/t:p/node()"/>
      </p></xsl:if>
      <xsl:if test="//t:div[@type = 'bibliography'][@subtype = 'additional']/t:p/node()"><p>
        <b><i18n:text i18n:key="epidoc-xslt-fiscus-bibliography">Bibliography</i18n:text>: </b>
        <xsl:apply-templates
          select="//t:div[@type = 'bibliography'][@subtype = 'additional']/t:p/node()"/>
      </p></xsl:if>
      <xsl:if test="//t:div[@type = 'bibliography'][@subtype = 'links']/t:p/node()"><p>
        <b><i18n:text i18n:key="epidoc-xslt-fiscus-bibliography">Links</i18n:text>: </b>
        <xsl:apply-templates select="//t:div[@type = 'bibliography'][@subtype = 'links']/t:p/node()"/>
      </p></xsl:if>
    </div>

    <xsl:if test="//t:div[@type = 'commentary']/t:p/node()">
      <div id="commentary">
      <p><b><i18n:text i18n:key="epidoc-xslt-fiscus-commentary">Commentary</i18n:text></b></p>
      <xsl:variable name="commtxt">
        <xsl:apply-templates select="//t:div[@type = 'commentary']//t:p"/>
      </xsl:variable>
      <xsl:apply-templates select="$commtxt" mode="sqbrackets"/>
    </div>
    </xsl:if>

    <!--<div id="images">
       <p><b>Images: </b></p>
       <xsl:choose>
         <xsl:when test="//t:facsimile//t:graphic">
           <xsl:for-each select="//t:facsimile//t:graphic">
             <span>&#160;</span>
             <xsl:apply-templates select="." />
           </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
           <xsl:for-each select="//t:facsimile[not(//t:graphic)]">
             <xsl:text>None available.</xsl:text>
           </xsl:for-each>
         </xsl:otherwise>
       </xsl:choose>
     </div>-->
  </xsl:template>

  <xsl:template name="fiscus-structure">
    <xsl:variable name="title">
      <xsl:call-template name="fiscus-title"/>
    </xsl:variable>

    <html>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <!-- Found in htm-tpl-cssandscripts.xsl -->
        <xsl:call-template name="css-script"/>
      </head>
      <body>
        <h1>
          <xsl:apply-templates select="$title"/>
        </h1>
        <xsl:call-template name="fiscus-body-structure"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="t:dimensions" mode="fiscus-dimensions">
    <xsl:if test="//text()">
      <xsl:if test="t:width/text()">w: <xsl:value-of select="t:width"/>
        <xsl:if test="t:height/text()">
          <xsl:text> x </xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="t:height/text()">h: <xsl:value-of select="t:height"/>
      </xsl:if>
      <xsl:if test="t:depth/text()">x d: <xsl:value-of select="t:depth"/>
      </xsl:if>
      <xsl:if test="t:dim[@type = 'diameter']/text()">x diam.: <xsl:value-of
          select="t:dim[@type = 'diameter']"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t:placeName | t:rs" mode="fiscus-placename">
    <!-- remove rs? -->
    <xsl:choose>
      <xsl:when
        test="contains(@ref, 'pleiades.stoa.org') or contains(@ref, 'geonames.org') or contains(@ref, 'slsgazetteer.org')">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="fiscus-invno">
    <xsl:if test="//t:idno[@type = 'invNo'][string(translate(normalize-space(.), ' ', ''))]">
      <xsl:text> (Inv. no. </xsl:text>
      <xsl:for-each
        select="//t:idno[@type = 'invNo'][string(translate(normalize-space(.), ' ', ''))]">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fiscus-title">
    <xsl:choose>
      <xsl:when
        test="//t:titleStmt/t:title/text() and number(substring(//t:publicationStmt/t:idno[@type = 'filename']/text(), 2, 5))">
        <xsl:value-of select="//t:publicationStmt/t:idno[@type = 'filename']/text()"/>
        <xsl:text>. </xsl:text>
        <xsl:value-of select="//t:titleStmt/t:title"/>
      </xsl:when>
      <xsl:when test="//t:titleStmt/t:title/text()">
        <xsl:value-of select="//t:titleStmt/t:title"/>
      </xsl:when>
      <xsl:when test="//t:sourceDesc//t:bibl/text()">
        <xsl:value-of select="//t:sourceDesc//t:bibl"/>
      </xsl:when>
      <xsl:when test="//t:idno[@type = 'filename']/text()">
        <xsl:value-of select="//t:idno[@type = 'filename']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>EpiDoc example output, Fiscus style</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:div//t:ref[not(@corresp)][starts-with(., 'http')]">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:attribute name="target">
        <xsl:value-of select="'_blank'"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
    
    <xsl:template match="t:div//t:ref[@corresp]">
    <xsl:choose>
      <xsl:when test="@type='fiscus'">
        <a target="_blank" href="{concat('./', @corresp, '.html')}"><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise>
        <a target="_blank" href="{@corresp}"><xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:foreign[not(ancestor::t:div[@type = 'edition'])]">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <xsl:template match="t:title[not(parent::t:titleStmt)][not(ancestor::t:div[@type = 'edition'])]">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <xsl:template match="t:persName[ancestor::t:div[@type = 'edition']]">
    <span class="persName"><xsl:apply-templates/></span>
    <xsl:if test="@ref !=''"><a target="_blank" class="links hidden"><xsl:attribute name="href"><xsl:value-of select="concat('../people.html#', substring-after(translate(@ref, '#', ''), 'people/'))"/></xsl:attribute> ???</a></xsl:if>
  </xsl:template>
  <xsl:template match="t:placeName[ancestor::t:div[@type = 'edition']]">
    <span class="placeName"><xsl:apply-templates/></span>
    <xsl:if test="@ref !=''"><a target="_blank" class="links hidden"><xsl:attribute name="href"><xsl:value-of select="concat('../places.html#', substring-after(translate(@ref, '#', ''), 'places/'))"/></xsl:attribute> ???</a></xsl:if>
  </xsl:template>
  <xsl:template match="t:orgName[ancestor::t:div[@type = 'edition']]">
    <span class="orgName"><xsl:apply-templates/></span>
    <xsl:if test="@ref !=''"><a target="_blank" class="links hidden"><xsl:attribute name="href"><xsl:value-of select="concat('../juridical_persons.html#', substring-after(translate(@ref, '#', ''), 'juridical_persons/'))"/></xsl:attribute> ???</a></xsl:if>
  </xsl:template>
  
  <xsl:template match="t:geogName[ancestor::t:div[@type = 'edition']]">
    <span class="geogName"><xsl:apply-templates/></span>
    <xsl:if test="@ref !=''"><a target="_blank" class="links hidden"><xsl:attribute name="href"><xsl:value-of select="concat('../estates.html#', substring-after(translate(@ref, '#', ''), 'estates/'))"/></xsl:attribute> ???</a></xsl:if>
  </xsl:template>
  
  <xsl:template match="t:rs[ancestor::t:div[@type = 'edition']]">
    <span class="rs"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="t:date[ancestor::t:div[@type = 'edition']]">
    <span class="date"><xsl:apply-templates/></span>
  </xsl:template>



</xsl:stylesheet>
