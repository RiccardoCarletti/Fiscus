<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->
  
  <xsl:output method="html"/>
  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='places']]">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/places.xml'))//tei:listPlace"/>
    <div class="imported_list">
      <xsl:apply-templates select="$imported_text"/>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='juridical_persons']]">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/juridical_persons.xml'))//tei:listOrg"/>
    <div class="imported_list">
      <xsl:apply-templates select="$imported_text"/>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='estates']]">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/estates.xml'))//tei:listPlace"/>
    <div class="imported_list">
      <xsl:apply-templates select="$imported_text"/>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='people']]">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/people.xml'))//tei:listPerson"/>
    <div class="imported_list">
      <xsl:apply-templates select="$imported_text"/>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='thesaurus']]">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/thesaurus.xml'))//tei:taxonomy"/>
    <div class="imported_list">
      <xsl:apply-templates select="$imported_text"/>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listPlace[@type='places']">
    <xsl:apply-templates select="tei:place"><xsl:sort select="./tei:placeName[1]" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPlace[@type='estates']">
    <xsl:apply-templates select="tei:place"><xsl:sort select="./tei:geogName[1]" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listOrg">
    <xsl:apply-templates select="tei:org"><xsl:sort select="./tei:orgName[1]" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPerson">
    <xsl:apply-templates select="tei:person"><xsl:sort select="./tei:persName[1]" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="//tei:listPlace/tei:place">
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/')"/></xsl:attribute>
      <xsl:if test="tei:placeName"><p class="item_name"><xsl:apply-templates select="tei:placeName[1]"/></p></xsl:if>
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><p class="item_name"><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)][1]"/></p></xsl:if>
      <p><xsl:if test="tei:placeName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:placeName[@type='other']"/><br/></xsl:if>
        <xsl:if test="tei:geogName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:geogName[@type='other']"/><br/></xsl:if>
        <xsl:if test="tei:geogName/tei:geo"><strong><xsl:text>Coordinates (Lat, Long): </xsl:text></strong><xsl:value-of select="tei:geogName/tei:geo"/><br/></xsl:if>
        <xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
        <xsl:if test="tei:note//text()"><strong><xsl:text>Commentary/Bibliography: </xsl:text></strong><xsl:apply-templates select="tei:note"/><br/></xsl:if>
        <xsl:if test="tei:link[@corresp]"><xsl:for-each select="tei:link[@corresp]"><strong><xsl:text>Linked to (</xsl:text><xsl:value-of select="@type"/><xsl:if test="@subtype"><xsl:text>; </xsl:text><xsl:value-of select="@subtype"/></xsl:if><xsl:text>): </xsl:text></strong> <xsl:apply-templates select="@corresp"/><br/></xsl:for-each></xsl:if>
        <xsl:if test="tei:idno"><strong><a><xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="ancestor::tei:listPlace[@type='places']"><xsl:value-of select="concat('../indices/epidoc/places.html#', substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/'))"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="concat('../indices/epidoc/estates.html#', substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/'))"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute><xsl:text>See linked documents</xsl:text></a></strong><br/></xsl:if>
      </p>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listOrg/tei:org">
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/')"/></xsl:attribute>
      <xsl:if test="tei:orgName"><p class="item_name"><xsl:apply-templates select="tei:orgName[1]"/></p></xsl:if>
      <p><xsl:if test="tei:orgName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:orgName[@type='other']"/><br/></xsl:if>
        <xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
        <xsl:if test="tei:note//text()"><strong><xsl:text>Commentary/Bibliography: </xsl:text></strong><xsl:apply-templates select="tei:note"/><br/></xsl:if>
        <xsl:if test="tei:link[@corresp]"><xsl:for-each select="tei:link[@corresp]"><strong><xsl:text>Linked to (</xsl:text><xsl:value-of select="@type"/><xsl:if test="@subtype"><xsl:text>; </xsl:text><xsl:value-of select="@subtype"/></xsl:if><xsl:text>): </xsl:text></strong> <xsl:apply-templates select="@corresp"/><br/></xsl:for-each></xsl:if>
        <xsl:if test="tei:idno"><strong><a><xsl:attribute name="href"><xsl:value-of select="concat('../indices/epidoc/juridical_persons.html#', substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:text>See linked documents</xsl:text></a></strong><br/></xsl:if>
      </p>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listPerson/tei:person">
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/')"/></xsl:attribute>
      <xsl:if test="tei:persName"><p class="item_name"><xsl:apply-templates select="tei:persName[1]"/></p></xsl:if>
      <p><xsl:if test="tei:persName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:persName[@type='other']"/><br/></xsl:if>
        <xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
        <xsl:if test="tei:note//text()"><strong><xsl:text>Commentary/Bibliography: </xsl:text></strong><xsl:apply-templates select="tei:note"/><br/></xsl:if>
        <xsl:if test="tei:link[@corresp]"><xsl:for-each select="tei:link[@corresp]"><strong><xsl:text>Linked to (</xsl:text><xsl:value-of select="@type"/><xsl:if test="@subtype"><xsl:text>; </xsl:text><xsl:value-of select="@subtype"/></xsl:if><xsl:text>): </xsl:text></strong> <xsl:apply-templates select="@corresp"/><br/></xsl:for-each></xsl:if>
        <xsl:if test="tei:idno"><strong><a><xsl:attribute name="href"><xsl:value-of select="concat('../indices/epidoc/people.html#', substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:text>See linked documents</xsl:text></a></strong><br/></xsl:if>
      </p>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:taxonomy//tei:catDesc">
    <div class="list_item">
      <p><xsl:value-of select="."/></p>
    </div>
  </xsl:template>
  
  <xsl:template match="//*/@corresp">
    <xsl:variable select="translate(.,'#','')" name="corresp"/>
    <xsl:variable name="place" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/places.xml'))//tei:listPlace/tei:place[tei:idno=$corresp]/tei:placeName[1]"/>
    <xsl:variable name="estate" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/estates.xml'))//tei:listPlace/tei:place[tei:idno=$corresp]/tei:geogName[1]"/>
    <xsl:variable name="person" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/people.xml'))//tei:listPerson/tei:person[tei:idno=$corresp]/tei:persName[1]"/>
    <xsl:variable name="juridical_person" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/juridical_persons.xml'))//tei:listOrg/tei:org[tei:idno=$corresp]/tei:orgName[1]"/>
    <xsl:choose>
      <xsl:when test="$place"><a><xsl:attribute name="href"><xsl:value-of select="concat('./places.html#', substring-after(substring-after(translate(.,'#',''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:apply-templates select="$place"/></a></xsl:when>
      <xsl:when test="$estate"><a><xsl:attribute name="href"><xsl:value-of select="concat('./estates.html#', substring-after(substring-after(translate(.,'#',''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:apply-templates select="$estate"/></a></xsl:when>
      <xsl:when test="$person"><a><xsl:attribute name="href"><xsl:value-of select="concat('./people.html#', substring-after(substring-after(translate(.,'#',''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:apply-templates select="$person"/></a></xsl:when>
      <xsl:when test="$juridical_person"><a><xsl:attribute name="href"><xsl:value-of select="concat('./juridical_persons.html#', substring-after(substring-after(translate(.,'#',''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:apply-templates select="$juridical_person"/></a></xsl:when>
      <xsl:otherwise><xsl:value-of select="translate(.,'#','')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- MAP -->
  <xsl:template match="//tei:addSpan[@xml:id='map']">
    <xsl:variable name="imported_places" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/places.xml'))//tei:listPlace"/>
    <xsl:variable name="imported_people" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/people.xml'))//tei:listPerson"/>
    <xsl:variable name="imported_juridical_persons" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/juridical_persons.xml'))//tei:listOrg"/>
    <xsl:variable name="imported_estates" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/estates.xml'))//tei:listPlace"/>
    <xsl:variable name="imported_thesaurus" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/thesaurus.xml'))//tei:taxonomy"/>
     
     <!-- to import keys related to <placeName>s from documents -->
    <xsl:variable name="docnames">
       <xsl:for-each select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/all_documents.xml'))//tei:item"><xsl:value-of select="@n"/><xsl:text>#</xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="docname" select="distinct-values(tokenize($docnames, '#'))"/>
      <xsl:variable name="keys">
        <xsl:for-each select="$docname">
          <xsl:variable name="doc_name" select="."/>
            <xsl:if test="fn:doc-available(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/epidoc/', $doc_name)) = fn:true()">
              <xsl:for-each select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/epidoc/', $doc_name))//tei:div[@type='edition']//tei:placeName[@key][@ref]">
                <p><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'places/')"/></xsl:attribute>
                  <xsl:text>#</xsl:text>
                <xsl:value-of select="substring-after(@ref, 'places/')"/>
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="translate(@key, '#', '')"/>
                <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
                </p>
              </xsl:for-each>
              <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
          </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="map_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_polygons">
      <xsl:text>{</xsl:text>
      <xsl:for-each select="$imported_places/tei:place[contains(descendant::tei:geo, ';')][descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "[</xsl:text><xsl:value-of select="replace(replace(normalize-space(tei:geogName/tei:geo), ', ', ','), '; ', ']; [')"/><xsl:text>]"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_blue_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="not($linked_jp) and not($linked_estates) and not($linking_jp) and not($linking_estates) and not(matches($all_keys, '.*(fiscal_property).*'))">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_green_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="matches($all_keys, '.*(fiscal_property).*') and not($linked_jp) and not($linking_jp)"> <!--<xsl:if test="$id='14' or $id='17'">-->
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_greensquare_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="not(matches($all_keys, '.*(fiscal_property).*')) and not($linked_jp) and not($linking_jp)">
            <xsl:if test="$linked_estates or $linking_estates">
        <!--<xsl:if test="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]">-->
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_red_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="not(matches($all_keys, '.*(fiscal_property).*')) and not($linked_estates) and not($linking_estates)">
          <xsl:if test="$linked_jp or $linking_jp">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_greenred_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="$linked_jp or $linking_jp">
          <xsl:if test="matches($all_keys, '.*(fiscal_property).*')">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_greenredsquare_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_places/tei:place[descendant::tei:geo/text()]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(substring-after(translate(descendant::tei:idno,'#',''), 'http://137.204.128.125/'), '/')"/>
        <xsl:variable name="linked_jp" select="descendant::tei:link[@type='juridical_persons']"/>
        <xsl:variable name="linked_estates" select="descendant::tei:link[@type='estates']"/>
        <xsl:variable name="linking_jp" select="$imported_juridical_persons//tei:org[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linking_estates" select="$imported_estates//tei:place[descendant::tei:link[contains(concat('#', substring-after(substring-after(translate(@corresp,'#',''), 'http://137.204.128.125/'), '/'), '#'), concat('#', $id, '#'))]]"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@id=$id]"><xsl:value-of select="lower-case(.)"/></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat($linked_keys, ' ')"/>
        <xsl:if test="$linked_jp or $linking_jp">
          <xsl:if test="$linked_estates or $linking_estates">
            <xsl:if test="not(matches($all_keys, '.*(fiscal_property).*'))">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:if></xsl:if></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    
    <div class="row">
      <div id="mapid" class="map"></div>
      <script>
        var streets = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/streets-v11', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors,  Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        
        var grayscale = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/light-v10', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors,  Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        
        var satellite = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/satellite-streets-v11', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors,  Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        
        var dare = L.tileLayer('https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
        minZoom: 4,
        maxZoom: 11,
        attribution: 'Map data <a href="https://imperium.ahlfeldt.se/">Digital Atlas of the Roman Empire</a> CC BY 4.0'
        });
        
        var terrain = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles: Esri. Source: Esri',
        maxZoom: 13
        });
        
        var watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
        attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Map data: <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        subdomains: 'abcd',
        minZoom: 1,
        maxZoom: 16,
        ext: 'jpg'
        });
        
        var mymap = L.map('mapid', {
        center: [44, 10.335],
        zoom: 6.5,
        layers: [streets, grayscale, satellite, terrain, watercolor]
        });
        
        var LeafIcon = L.Icon.extend({
        options: {iconSize: [15, 15]}
        });
        var blueIcon = new LeafIcon({iconUrl: '../../../assets/images/blue.png'}),
        greenIcon = new LeafIcon({iconUrl: '../../../assets/images/green.png'}),
        redIcon = new LeafIcon({iconUrl: '../../../assets/images/red.png'}),
        greenredIcon = new LeafIcon({iconUrl: '../../../assets/images/green-red.png'}); 
        greensquareIcon = new LeafIcon({iconUrl: '../../../assets/images/green-square.png'}),
        greenredsquareIcon = new LeafIcon({iconUrl: '../../../assets/images/green-red-square.png'}); 
        
        const points = <xsl:value-of select="$map_points"/>;
        const blue_points = <xsl:value-of select="$map_blue_points"/>;
        const green_points = <xsl:value-of select="$map_green_points"/>;
        const red_points = <xsl:value-of select="$map_red_points"/>;
        const greenred_points = <xsl:value-of select="$map_greenred_points"/>;
        const greensquare_points = <xsl:value-of select="$map_greensquare_points"/>;
        const greenredsquare_points = <xsl:value-of select="$map_greenredsquare_points"/>;
        const polygons = <xsl:value-of select="$map_polygons"/>;
        
        var blue_places = [];
        for (const [key, value] of Object.entries(blue_points)) {
        blue_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: blueIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        };
        
        var green_places = [];
        for (const [key, value] of Object.entries(green_points)) {
        green_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        };
       
       var red_places = [];
       for (const [key, value] of Object.entries(red_points)) {
       red_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: redIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
       };
        
        var greenred_places = [];
        for (const [key, value] of Object.entries(greenred_points)) {
        greenred_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenredIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        };
        
        var greensquare_places = [];
        for (const [key, value] of Object.entries(greensquare_points)) {
        greensquare_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greensquareIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        };
        
        var greenredsquare_places = [];
        for (const [key, value] of Object.entries(greenredsquare_points)) {
        greenredsquare_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenredsquareIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        };
        
        var polygons_places = [];
        <!--for (const [key, value] of Object.entries(polygons)) {
        L.polygon([value.split(';')<!-\-value.replaceAll(";", ",")-\->]).addTo(mymap).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        }-->
        polygons_places.push(L.polygon([
        [45.21625206214063,8.293893188238146],
        [45.22292799339423,8.286163732409479],
        [45.23431881528846,8.29482525587082],
        [45.24012999402467,8.301339000463487],
        [45.2354063021579,8.319860994815828],
        [45.218978453364016,8.306558579206468],
        [45.21625206214063,8.293893188238146]
        ], {color: 'orange'}).bindPopup('<a href="#35">Predalbora (Piacenza)</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#35">➚</a></span>'));
        
        var toggle_blue_places = L.layerGroup(blue_places).addTo(mymap); 
        var toggle_green_places = L.layerGroup(green_places).addTo(mymap);
        var toggle_red_places = L.layerGroup(red_places).addTo(mymap);
        var toggle_greensquare_places = L.layerGroup(greensquare_places).addTo(mymap);
        var toggle_greenredsquare_places = L.layerGroup(greenredsquare_places).addTo(mymap);
        var toggle_greenred_places = L.layerGroup(greenred_places).addTo(mymap);
        var toggle_polygons = L.layerGroup(polygons_places).addTo(mymap);
        
        var baseMaps = {
        "DARE": dare,
        "Terrain": terrain, 
        "Grayscale": grayscale,
        "Satellite": satellite,
        "Watercolor": watercolor,
        "Streets": streets
        };
        
        var overlayMaps = {
        "Places linked to fiscal estates (green circle)": toggle_green_places,
        "Places linked to other estates (green square)": toggle_greensquare_places ,
        "Places linked to juridical persons (red circle)": toggle_red_places,
        "Places linked to fiscal estates and juridical persons (green&amp;red circle)": toggle_greenred_places,
        "Places linked to other estates and juridical persons (green&amp;red square)": toggle_greenredsquare_places,
        "Places not linked to estates/juridical persons (blue circle)": toggle_blue_places,
        "Places not precisely located (orange area)": toggle_polygons
        };
        
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        
      </script>
    </div>
  </xsl:template>
  
</xsl:stylesheet>