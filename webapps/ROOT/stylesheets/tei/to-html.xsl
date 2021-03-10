<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->
  
  <xsl:output method="html"/>
  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <!-- recurring paths & lists -->
  <xsl:variable name="resources"><xsl:value-of select="concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/')"/></xsl:variable>
  <xsl:variable name="epidoc"><xsl:value-of select="concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/epidoc/')"/></xsl:variable>
  <xsl:variable name="places" select="document(concat($resources, 'places.xml'))//tei:listPlace"/>
  <xsl:variable name="juridical_persons" select="document(concat($resources, 'juridical_persons.xml'))//tei:listOrg"/>
  <xsl:variable name="estates" select="document(concat($resources, 'estates.xml'))//tei:listPlace"/>
  <xsl:variable name="people" select="document(concat($resources, 'people.xml'))//tei:listPerson"/>
  <xsl:variable name="thesaurus" select="document(concat($resources, 'thesaurus.xml'))//tei:taxonomy"/>
  
  <!-- import @key values from markup in documents -->
  <xsl:variable name="docnames"><xsl:for-each select="document(concat($resources, 'all_documents.xml'))//tei:item"><xsl:value-of select="@n"/><xsl:text>#</xsl:text></xsl:for-each></xsl:variable>
  <xsl:variable name="docname" select="distinct-values(tokenize($docnames, '#'))"/>
  <xsl:variable name="keys">
    <xsl:for-each select="$docname">
      <xsl:variable name="doc_name" select="."/>
      <xsl:if test="fn:doc-available(concat($epidoc, $doc_name)) = fn:true()">
        <xsl:for-each select="document(concat($epidoc, $doc_name))//tei:div[@type='edition']//tei:placeName[@key!=''][@ref]">
          <p class="place_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'places/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select="document(concat($epidoc, $doc_name))//tei:div[@type='edition']//tei:geogName[@key!=''][@ref]">
          <p class="estate_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'estates/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select="document(concat($epidoc, $doc_name))//tei:div[@type='edition']//tei:persName[@key!=''][@ref]">
          <p class="person_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'people/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select="document(concat($epidoc, $doc_name))//tei:div[@type='edition']//tei:orgName[@key!=''][@ref]">
          <p class="jp_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'juridical_persons/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- import lists -->
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='places']]">
    <div class="imported_list"><xsl:apply-templates select="$places"/></div>
  </xsl:template>
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='juridical_persons']]">
    <div class="imported_list"><xsl:apply-templates select="$juridical_persons"/></div>
  </xsl:template>
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='estates']]">
    <div class="imported_list"><xsl:apply-templates select="$estates"/></div>
  </xsl:template>
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='people']]">
    <div class="imported_list"><xsl:apply-templates select="$people"/></div>
  </xsl:template>
  <xsl:template match="//tei:p[@n='import'][ancestor::tei:TEI[@xml:id='thesaurus']]">
    <div class="imported_list"><xsl:apply-templates select="$thesaurus"/></div>
  </xsl:template>
  
  <!-- order lists items -->
  <xsl:template match="//tei:listPlace[@type='places']">
    <xsl:apply-templates select="tei:place"><xsl:sort select="./tei:placeName[1]"/></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPlace[@type='estates']">
    <xsl:apply-templates select="tei:place"><xsl:sort select="./tei:geogName[1]"/></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listOrg">
    <xsl:apply-templates select="tei:org"><xsl:sort select="./tei:orgName[1]"/></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPerson">
    <xsl:apply-templates select="tei:person"><xsl:sort select="./tei:persName[1]"/></xsl:apply-templates>
  </xsl:template>
  
  <!-- display thesaurus -->
  <xsl:template match="//tei:taxonomy//tei:catDesc">
    <div class="list_item">
      <p><xsl:value-of select="."/></p>
    </div>
  </xsl:template>
  
  <!-- italics for titles and foreign terms -->
  <xsl:template match="tei:foreign[ancestor::tei:listOrg|ancestor::tei:listPerson|ancestor::tei:listPlace]|tei:title[ancestor::tei:listOrg|ancestor::tei:listPerson|ancestor::tei:listPlace]"><i><xsl:apply-templates/></i></xsl:template>
  
  <!-- display juridical persons, people, places, estates  -->
  <xsl:template match="//tei:listOrg/tei:org|//tei:listPerson/tei:person|//tei:listPlace/tei:place">
    <!-- variables -->
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="ancestor::tei:listOrg"><xsl:value-of select="substring-after(translate(tei:idno, '#', ''), 'juridical_persons/')"/></xsl:when>
        <xsl:when test="ancestor::tei:listPerson"><xsl:value-of select="substring-after(translate(tei:idno, '#', ''), 'people/')"/></xsl:when>
        <xsl:when test="ancestor::tei:listPlace[descendant::tei:geo]"><xsl:value-of select="substring-after(translate(tei:idno, '#', ''), 'places/')"/></xsl:when>
        <xsl:when test="ancestor::tei:listPlace[not(descendant::tei:geo)]"><xsl:value-of select="substring-after(translate(tei:idno, '#', ''), 'estates/')"/></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
    <xsl:variable name="links" select="tei:link"/>
    <xsl:variable name="linked_keys_jp"><xsl:for-each select="$keys//p[@class='jp_keys'][@id=$id]">
      <xsl:value-of select="lower-case(.)"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="all_linked_keys_jp" select="distinct-values(tokenize(lower-case($linked_keys_jp), '\s+?'))"/>
    <xsl:variable name="all_keys_jp"><xsl:for-each select="$all_linked_keys_jp"><xsl:sort/><xsl:value-of select="replace(., '_', ' ')"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="linked_keys_person"><xsl:for-each select="$keys//p[@class='person_keys'][@id=$id]">
      <xsl:value-of select="lower-case(.)"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="all_linked_keys_person" select="distinct-values(tokenize(lower-case($linked_keys_person), '\s+?'))"/>
    <xsl:variable name="all_keys_person"><xsl:for-each select="$all_linked_keys_person"><xsl:sort/><xsl:value-of select="replace(., '_', ' ')"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="linked_keys_place"><xsl:for-each select="$keys//p[@class='place_keys'][@id=$id]">
      <xsl:value-of select="lower-case(.)"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="all_linked_keys_place" select="distinct-values(tokenize(lower-case($linked_keys_place), '\s+?'))"/>
    <xsl:variable name="all_keys_place"><xsl:for-each select="$all_linked_keys_place"><xsl:sort/><xsl:value-of select="replace(., '_', ' ')"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="linked_keys_estate"><xsl:for-each select="$keys//p[@class='estate_keys'][@id=$id]">
      <xsl:value-of select="lower-case(.)"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="all_linked_keys_estate" select="distinct-values(tokenize(lower-case($linked_keys_estate), '\s+?'))"/>
    <xsl:variable name="all_keys_estate"><xsl:for-each select="$all_linked_keys_estate"><xsl:sort/><xsl:value-of select="replace(., '_', ' ')"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
    <xsl:variable name="linked_people">
      <xsl:for-each select="tei:link[@type='people']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/>
        <xsl:value-of select="$people//tei:person[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linking_people">
      <xsl:for-each select="$people//tei:person//tei:link/@corresp"><xsl:variable name="link" select="."/>
        <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:person/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linked_places">
      <xsl:for-each select="tei:link[@type='places']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/>
        <xsl:value-of select="$places//tei:place[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linking_places">
      <xsl:for-each select="$places//tei:place//tei:link/@corresp"><xsl:variable name="link" select="."/>
        <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:place/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linked_jp">
      <xsl:for-each select="tei:link[@type='juridical_persons']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/><xsl:value-of select="$juridical_persons//tei:org[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linking_jp">
      <xsl:for-each select="$juridical_persons//tei:org//tei:link/@corresp"><xsl:variable name="link" select="."/>
        <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:org/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linked_estates">
      <xsl:for-each select="tei:link[@type='estates']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:value-of select="$estates//tei:place[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="linking_estates">
      <xsl:for-each select="$estates//tei:place//tei:link/@corresp"><xsl:variable name="link" select="."/>
        <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:place/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_estates"><!-- estates linked to linking jp -->
      <xsl:for-each select="$linking_jp"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$juridical_persons//tei:org[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='estates']/@corresp"/>
          <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
              <xsl:value-of select="$estates//tei:place[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_estates1"><!-- estates linked to linked jp -->
      <xsl:for-each select="tei:link[@type='juridical_persons']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
          <xsl:variable name="link3" select="$juridical_persons//tei:org[descendant::tei:idno=$link2]//tei:link[@type='estates']/@corresp"/>
          <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_jp"><!-- jp linked to linking estates -->
      <xsl:for-each select="$linking_estates"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$estates//tei:place[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='juridical_persons']/@corresp"/>
          <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
              <xsl:value-of select="$juridical_persons//tei:org[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_jp1"><!-- jp linked to linked estates -->
      <xsl:for-each select="tei:link[@type='estates']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
          <xsl:variable name="link3" select="$estates//tei:place[descendant::tei:idno=$link2]//tei:link[@type='juridical_persons']/@corresp"/>
          <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_estates"><!-- estates linking to linking jp -->
      <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linking_jp, ' '), concat($link, ' '))">
            <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_jp"><!-- jp linking to linking estates -->
      <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linking_estates, ' '), concat($link, ' '))">
            <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each></xsl:for-each>
     </xsl:variable>
    <xsl:variable name="i_linking_estates1"><!-- estates linking to linked jp -->
      <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linked_jp, ' '), concat($link, ' '))">
            <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_jp1"><!-- jp linking to linked estates -->
    <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linked_estates, ' '), concat($link, ' '))">
            <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each></xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="links_est"><xsl:for-each select="$linked_estates|$linking_estates|$i_linked_estates1|$i_linked_estates|$i_linking_estates1|$i_linking_estates"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedest" select="distinct-values(tokenize(normalize-space($links_est), '\s+'))" />
    <xsl:variable name="links_jp"><xsl:for-each select="$linked_jp|$linking_jp|$i_linked_jp1|$i_linked_jp|$i_linking_jp1|$i_linking_jp"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedjp" select="distinct-values(tokenize(normalize-space($links_jp), '\s+'))" />
    <xsl:variable name="links_people"><xsl:for-each select="$linked_people|$linking_people"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedpeople" select="distinct-values(tokenize(normalize-space($links_people), '\s+'))" />
    <xsl:variable name="links_places"><xsl:for-each select="$linked_places|$linking_places"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedplaces" select="distinct-values(tokenize(normalize-space($links_places), '\s+'))" />
    
    <!-- display -->
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:if test="tei:orgName|tei:persName|tei:placeName"><p class="item_name"><xsl:apply-templates select="tei:orgName[1]|tei:persName[1]|tei:placeName[1]"/></p></xsl:if>
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><p class="item_name"><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)][1]"/></p></xsl:if>
      <p><xsl:if test="tei:orgName[@type='other']//text()|tei:persName[@type='other']//text()|tei:placeName[@type='other']//text()|tei:geogName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:orgName[@type='other']|tei:persName[@type='other']|tei:placeName[@type='other']|tei:geogName[@type='other']"/><br/></xsl:if>
        <xsl:if test="tei:geogName/tei:geo"><strong><xsl:text>Coordinates (Lat, Long): </xsl:text></strong><xsl:value-of select="tei:geogName/tei:geo"/><br/></xsl:if>
        <xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
        <xsl:if test="tei:note//text()"><strong><xsl:text>Commentary/Bibliography: </xsl:text></strong><xsl:apply-templates select="tei:note"/><br/></xsl:if>
        <xsl:if test="//tei:org and matches($all_keys_jp, '.*[a-zA-Z].*')"><strong><xsl:text>Linked keywords: </xsl:text></strong> 
          <xsl:value-of select="replace(replace($all_keys_jp, ',$', ''), '^, ', '')"/><br/></xsl:if>
        <xsl:if test="//tei:person and matches($all_keys_person, '.*[a-zA-Z].*')"><strong><xsl:text>Linked keywords: </xsl:text></strong> 
          <xsl:value-of select="replace(replace($all_keys_person, ',$', ''), '^, ', '')"/><br/></xsl:if>
        <xsl:if test="tei:geogName[descendant::tei:geo] and matches($all_keys_place, '.*[a-zA-Z].*')"><strong><xsl:text>Linked keywords: </xsl:text></strong> 
          <xsl:value-of select="replace(replace($all_keys_place, ',$', ''), '^, ', '')"/><br/></xsl:if>
        <xsl:if test="tei:geogName[not(descendant::tei:geo)] and matches($all_keys_estate, '.*[a-zA-Z].*')"><strong><xsl:text>Linked keywords: </xsl:text></strong> 
          <xsl:value-of select="replace(replace($all_keys_estate, ',$', ''), '^, ', '')"/><br/></xsl:if>
        <xsl:if test="tei:idno"><strong><xsl:text>Linked documents: </xsl:text></strong><a><xsl:attribute name="href"><xsl:choose>
          <xsl:when test="ancestor::tei:listOrg"><xsl:value-of select="concat('../indices/epidoc/juridical_persons.html#', $id)"/></xsl:when>
          <xsl:when test="ancestor::tei:listPerson"><xsl:value-of select="concat('../indices/epidoc/people.html#', $id)"/></xsl:when>
          <xsl:when test="ancestor::tei:listPlace[descendant::tei:geo]"><xsl:value-of select="concat('../indices/epidoc/places.html#', $id)"/></xsl:when>
          <xsl:when test="ancestor::tei:listPlace[not(descendant::tei:geo)]"><xsl:value-of select="concat('../indices/epidoc/estates.html#', $id)"/></xsl:when>
          </xsl:choose></xsl:attribute><xsl:text>see</xsl:text></a><br/></xsl:if>
      </p>
      
      <!-- display linked items -->
      <xsl:if test="$linkedjp!=''"><strong><xsl:text>Linked juridical persons: </xsl:text></strong>
        <ul><xsl:for-each select="$linkedjp"><xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
          <li class="linked_item"><a><xsl:attribute name="href"><xsl:value-of select="concat('./juridical_persons.html#', substring-after($key, 'juridical_persons/'))"/></xsl:attribute><xsl:apply-templates select="$juridical_persons/tei:org[descendant::tei:idno=$key]/tei:orgName[1]"/></a>
            <xsl:variable name="subtype" select="$links[@subtype][contains(concat(@corresp, ' '), concat($key, ' '))]/@subtype"/>
            <xsl:if test="$subtype"><xsl:text> (</xsl:text><xsl:value-of select="$subtype"/><xsl:text>)</xsl:text></xsl:if></li></xsl:for-each></ul><br/></xsl:if>
      
      <xsl:if test="$linkedest!=''"><strong><xsl:text>Linked estates: </xsl:text></strong>
        <ul><xsl:for-each select="$linkedest"><xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
          <li class="linked_item"><a><xsl:attribute name="href"><xsl:value-of select="concat('./estates.html#', substring-after($key, 'estates/'))"/></xsl:attribute><xsl:apply-templates select="$estates/tei:place[descendant::tei:idno=$key]/tei:geogName[1]"/></a>
            <xsl:variable name="subtype" select="$links[@subtype][contains(concat(@corresp, ' '), concat($key, ' '))]/@subtype"/>
            <xsl:if test="$subtype"><xsl:text> (</xsl:text><xsl:value-of select="$subtype"/><xsl:text>)</xsl:text></xsl:if></li></xsl:for-each></ul><br/></xsl:if>
      
      <xsl:if test="$linkedplaces!=''"><strong><xsl:text>Linked places: </xsl:text></strong>
        <ul><xsl:for-each select="$linkedplaces"><xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
          <li class="linked_item"><a><xsl:attribute name="href"><xsl:value-of select="concat('./places.html#', substring-after($key, 'places/'))"/></xsl:attribute><xsl:apply-templates select="$places/tei:place[descendant::tei:idno=$key]/tei:placeName[1]"/></a>
            <xsl:variable name="subtype" select="$links[@subtype][contains(concat(@corresp, ' '), concat($key, ' '))]/@subtype"/>
            <xsl:if test="$subtype"><xsl:text> (</xsl:text><xsl:value-of select="$subtype"/><xsl:text>)</xsl:text></xsl:if></li></xsl:for-each></ul><br/></xsl:if>
      
      <xsl:if test="$linkedpeople!=''"><strong><xsl:text>Linked people: </xsl:text></strong>
        <ul><xsl:for-each select="$linkedpeople"><xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
          <li class="linked_item"><a><xsl:attribute name="href"><xsl:value-of select="concat('./people.html#', substring-after($key, 'people/'))"/></xsl:attribute><xsl:apply-templates select="$people/tei:person[descendant::tei:idno=$key]/tei:persName[1]"/></a>
            <xsl:variable name="subtype" select="$links[@subtype][contains(concat(@corresp, ' '), concat($key, ' '))]/@subtype"/>
            <xsl:if test="$subtype"><xsl:text> (</xsl:text><xsl:value-of select="$subtype"/><xsl:text>)</xsl:text></xsl:if></li></xsl:for-each></ul><br/></xsl:if>
    </div>
  </xsl:template>
  
  
  <!-- MAP -->
  <xsl:template match="//tei:addSpan[@xml:id='map']">
    
    <!-- generate lists of places by type -->
    <xsl:variable name="map_polygons">
      <xsl:text>{</xsl:text>
      <xsl:for-each select="$places/tei:place[contains(descendant::tei:geo, ';')]">
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
        <xsl:value-of select="replace(replace(normalize-space(tei:geogName/tei:geo), ', ', ';'), '; ', ';')"/>
        <xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="map_points">
      <xsl:text>{</xsl:text>
      <xsl:for-each select="$places/tei:place[descendant::tei:geo/text()]">
        <!-- variables -->
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
        <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@class='place_keys'][@id=$id]"><xsl:value-of select="lower-case(.)"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="replace(normalize-space($linked_keys), ' ,', '')"/>
        <xsl:variable name="linked_jp">
          <xsl:for-each select="tei:link[@type='juridical_persons']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/><xsl:value-of select="$juridical_persons//tei:org[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="linking_jp">
          <xsl:for-each select="$juridical_persons//tei:org//tei:link/@corresp"><xsl:variable name="link" select="."/>
            <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:org/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
        <xsl:variable name="linked_estates">
          <xsl:for-each select="tei:link[@type='estates']/@corresp"><xsl:variable name="links1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links1"><xsl:variable name="link" select="translate(., '#', '')"/>
              <xsl:value-of select="$estates//tei:place[descendant::tei:idno=$link]//tei:idno"/><xsl:text> </xsl:text></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="linking_estates">
          <xsl:for-each select="$estates//tei:place//tei:link/@corresp"><xsl:variable name="link" select="."/>
            <xsl:if test="contains(concat($link, ' '), concat($idno, ' '))"><xsl:value-of select="$link/ancestor::tei:place/tei:idno"/><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linked_estates">
          <xsl:for-each select="$linking_jp"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$juridical_persons//tei:org[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='estates']/@corresp"/>
              <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
                <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
                  <xsl:value-of select="$estates//tei:place[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
                </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linked_estates1">
          <xsl:for-each select="tei:link[@type='juridical_persons']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
              <xsl:variable name="link3" select="$juridical_persons//tei:org[descendant::tei:idno=$link2]//tei:link[@type='estates']/@corresp"/>
              <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
                <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
                </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linked_jp">
          <xsl:for-each select="$linking_estates"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$estates//tei:place[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='juridical_persons']/@corresp"/>
              <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
                <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
                  <xsl:value-of select="$juridical_persons//tei:org[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
                </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linked_jp1">
          <xsl:for-each select="tei:link[@type='estates']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
              <xsl:variable name="link3" select="$estates//tei:place[descendant::tei:idno=$link2]//tei:link[@type='juridical_persons']/@corresp"/>
              <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
                <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
                </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linking_estates">
          <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
            <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
              <xsl:if test="contains(concat($linking_jp, ' '), concat($link, ' '))">
                <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linking_jp">
          <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
            <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
              <xsl:if test="contains(concat($linking_estates, ' '), concat($link, ' '))">
                <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linking_estates1">
          <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
            <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
              <xsl:if test="contains(concat($linked_jp, ' '), concat($link, ' '))">
                <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="i_linking_jp1">
          <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
            <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
              <xsl:if test="contains(concat($linked_estates, ' '), concat($link, ' '))">
                <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each></xsl:for-each></xsl:variable>
        <xsl:variable name="links_est"><xsl:for-each select="$linked_estates|$linking_estates|$i_linked_estates1|$i_linked_estates|$i_linking_estates1|$i_linking_estates"><xsl:value-of select="." /></xsl:for-each></xsl:variable>
        <xsl:variable name="links_jp"><xsl:for-each select="$linked_jp|$linking_jp|$i_linked_jp1|$i_linked_jp|$i_linking_jp1|$i_linking_jp"><xsl:value-of select="." /></xsl:for-each></xsl:variable>
        <!-- blue points -->
          <xsl:if test="not(contains($links_est, 'estates')) and not(contains($links_jp, 'juridical_persons')) and not(matches($all_keys, '.*(fiscal_property).*'))">
           <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#a@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:if>
        <!-- green points -->
          <xsl:if test="contains($links_est, 'estates') and not(contains($links_jp, 'juridical_persons')) and matches($all_keys, '.*(fiscal_property).*')">
            <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#b@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:if>
       <!-- green squares -->
        <xsl:if test="contains($links_est, 'estates') and not(contains($links_jp, 'juridical_persons')) and not(matches($all_keys, '.*(fiscal_property).*'))">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#c@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:if>
        <!-- red points -->
        <xsl:if test="not(contains($links_est, 'estates')) and contains($links_jp, 'juridical_persons') and not(matches($all_keys, '.*(fiscal_property).*'))">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#d@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:if>
        <!-- green+red points -->
        <xsl:if test="contains($links_est, 'estates') and contains($links_jp, 'juridical_persons') and matches($all_keys, '.*(fiscal_property).*')">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#e@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:if>
        <!-- green+red squares -->
        <xsl:if test="contains($links_est, 'estates') and contains($links_jp, 'juridical_persons') and not(matches($all_keys, '.*(fiscal_property).*'))">
          <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#f@</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
            <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:variable>
    
    <!-- add map -->
    <div class="row">
      <div id="mapid" class="map"></div>
      <script type="text/javascript">
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
        
        var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data: <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        });
        
        var mymap = L.map('mapid', {
        center: [44, 10.335],
        zoom: 6.5,
        layers: [osm, streets, grayscale, satellite, terrain, watercolor]
        });
        
        L.control.scale().addTo(mymap);
        
        var LeafIcon = L.Icon.extend({
        options: {iconSize: [15, 15]}
        });
        var blueIcon = new LeafIcon({iconUrl: '../../../assets/images/blue.png'}),
        greenIcon = new LeafIcon({iconUrl: '../../../assets/images/green.png'}),
        redIcon = new LeafIcon({iconUrl: '../../../assets/images/red.png'}),
        greenredIcon = new LeafIcon({iconUrl: '../../../assets/images/green-red.png'}); 
        greensquareIcon = new LeafIcon({iconUrl: '../../../assets/images/green-square.png'}),
        greenredsquareIcon = new LeafIcon({iconUrl: '../../../assets/images/green-red-square.png'}); 
        
        const polygons = <xsl:value-of select="$map_polygons"/>;
        const points = <xsl:value-of select="$map_points"/>;
        
        var polygons_places = [];
        var blue_places = [];
        var green_places = [];
        var red_places = [];
        var greenred_places = [];
        var greensquare_places = [];
        var greenredsquare_places = [];
        
        for (const [key, value] of Object.entries(points)) {
        if (key.includes('#a@')) {
        blue_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: blueIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('#b@')) {
        green_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('#c@')) {
        greensquare_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greensquareIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('#d@')) {
        red_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: redIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('#e@')) {
        greenred_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenredIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('#f@')) {
        greenredsquare_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: greenredsquareIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        };
        
        for (const [key, value] of Object.entries(polygons)) {
                var split_values = value.split(';');
                split_values.forEach(function(item, index, array) {
                array[index] = parseFloat(item);
                });
              var coords = chunkArray(split_values, 2);  <!-- function called from assets/scripts/maps.js -->
        polygons_places.push(L.polygon([coords], {color: 'orange'}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        }; 
        
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
        "Streets": streets,
        "Open Street Map": osm
        };
        
        var overlayMaps = {
        "Places linked to fiscal estates (green circle)": toggle_green_places,
        "Places linked to other estates (green square)": toggle_greensquare_places,
        "Places linked to juridical persons (red circle)": toggle_red_places,
        "Places linked to fiscal estates and juridical persons (green&amp;red circle)": toggle_greenred_places,
        "Places linked to other estates and juridical persons (green&amp;red square)": toggle_greenredsquare_places,
        "Places not linked to estates/juridical persons (blue circle)": toggle_blue_places,
        "Places not precisely located (orange area)": toggle_polygons
        };
        
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        
        L.Control.geocoder().addTo(mymap);
        
      </script>
    </div>
  </xsl:template>
  
</xsl:stylesheet>