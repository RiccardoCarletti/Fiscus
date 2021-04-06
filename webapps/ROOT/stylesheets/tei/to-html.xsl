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
    <!--<xsl:variable name="i_linked_estates"><!-\- estates linked to linking jp -\->
      <xsl:for-each select="$linking_jp"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$juridical_persons//tei:org[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='estates']/@corresp"/>
          <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
              <xsl:value-of select="$estates//tei:place[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_estates1"><!-\- estates linked to linked jp -\->
      <xsl:for-each select="tei:link[@type='juridical_persons']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
          <xsl:variable name="link3" select="$juridical_persons//tei:org[descendant::tei:idno=$link2]//tei:link[@type='estates']/@corresp"/>
          <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_jp"><!-\- jp linked to linking estates -\->
      <xsl:for-each select="$linking_estates"><xsl:variable name="links0" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$links0"><xsl:variable name="links1" select="."/><xsl:variable name="links2" select="$estates//tei:place[descendant::tei:idno=translate(translate($links1, '#', ''), ' ', '')]//tei:link[@type='juridical_persons']/@corresp"/>
          <xsl:for-each select="$links2"><xsl:variable name="links3" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$links3"><xsl:variable name="links4" select="translate(., '#', '')"/>
              <xsl:value-of select="$juridical_persons//tei:org[descendant::tei:idno=translate($links4, ' ', '')]//tei:idno"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linked_jp1"><!-\- jp linked to linked estates -\->
      <xsl:for-each select="tei:link[@type='estates']/@corresp"><xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link2" select="translate(., '#', '')"/>
          <xsl:variable name="link3" select="$estates//tei:place[descendant::tei:idno=$link2]//tei:link[@type='juridical_persons']/@corresp"/>
          <xsl:for-each select="$link3"><xsl:variable name="link4" select="distinct-values(tokenize(., '\s+'))"/>
            <xsl:for-each select="$link4"><xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
            </xsl:for-each></xsl:for-each></xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_estates"><!-\- estates linking to linking jp -\->
      <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linking_jp, ' '), concat($link, ' '))">
            <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_jp"><!-\- jp linking to linking estates -\->
      <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linking_estates, ' '), concat($link, ' '))">
            <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each></xsl:for-each>
     </xsl:variable>
    <xsl:variable name="i_linking_estates1"><!-\- estates linking to linked jp -\->
      <xsl:for-each select="$estates//tei:place//tei:link[@type='juridical_persons']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linked_jp, ' '), concat($link, ' '))">
            <xsl:value-of select="$estates//tei:place[contains(string-join(descendant::tei:link[@type='juridical_persons']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each></xsl:for-each>
    </xsl:variable>
    <xsl:variable name="i_linking_jp1"><!-\- jp linking to linked estates -\->
    <xsl:for-each select="$juridical_persons//tei:org//tei:link[@type='estates']/@corresp">
        <xsl:variable name="link1" select="distinct-values(tokenize(., '\s+'))"/>
        <xsl:for-each select="$link1"><xsl:variable name="link" select="translate(., '#', '')"/>
          <xsl:if test="contains(concat($linked_estates, ' '), concat($link, ' '))">
            <xsl:value-of select="$juridical_persons//tei:org[contains(string-join(descendant::tei:link[@type='estates']/@corresp, ' '), concat($link, ' '))]//tei:idno"/><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each></xsl:for-each>
    </xsl:variable>-->
    
    <xsl:variable name="links_est"><xsl:for-each select="$linked_estates|$linking_estates"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable> <!-- |$i_linked_estates1|$i_linked_estates|$i_linking_estates1|$i_linking_estates -->
    <xsl:variable name="linkedest" select="distinct-values(tokenize(normalize-space($links_est), '\s+'))" />
    <xsl:variable name="links_jp"><xsl:for-each select="$linked_jp|$linking_jp"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable> <!-- |$i_linked_jp1|$i_linked_jp|$i_linking_jp1|$i_linking_jp -->
    <xsl:variable name="linkedjp" select="distinct-values(tokenize(normalize-space($links_jp), '\s+'))" />
    <xsl:variable name="links_people"><xsl:for-each select="$linked_people|$linking_people"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedpeople" select="distinct-values(tokenize(normalize-space($links_people), '\s+'))" />
    <xsl:variable name="links_places"><xsl:for-each select="$linked_places|$linking_places"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
    <xsl:variable name="linkedplaces" select="distinct-values(tokenize(normalize-space($links_places), '\s+'))" />
    
    <!-- display -->
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:if test="tei:orgName|tei:persName|tei:placeName"><h2 class="item_name"><xsl:apply-templates select="tei:orgName[1]|tei:persName[1]|tei:placeName[1]"/></h2></xsl:if>
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><h2 class="item_name"><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)][1]"/></h2></xsl:if>
      
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
      
      <!-- map for each juridical person having linked places -->
      <xsl:if test="ancestor::tei:listOrg and $linkedplaces!=''">
        <xsl:variable name="map_polygons">
          <xsl:text>{</xsl:text>
          <xsl:for-each select="$linkedplaces">
            <xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
            <xsl:for-each select="$places/tei:place[descendant::tei:idno=$key][contains(descendant::tei:geo, ';')]">
            <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
            <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
            <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
            <xsl:value-of select="replace(replace(normalize-space(tei:geogName/tei:geo), ', ', ';'), '; ', ';')"/>
              <xsl:text>", </xsl:text>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:text>!}</xsl:text>
        </xsl:variable>
        
        <xsl:variable name="map_points">
          <xsl:text>{</xsl:text> 
          <xsl:for-each select="$linkedplaces">
            <xsl:variable name="key" select="translate(translate(.,' ',''), '#', '')"/>
                <xsl:for-each select="$places/tei:place[descendant::tei:idno=$key][descendant::tei:geo/text()]">
                  <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
                  <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
                  <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
                  <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@class='place_keys'][@id=$id]"><xsl:value-of select="lower-case(.)"/><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
                  <xsl:variable name="all_keys" select="concat(' ', normalize-space($linked_keys))"/>
                  <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
                  <xsl:if test="not(matches($all_keys, '.*(fiscal_property).*'))"><xsl:text>#a@</xsl:text></xsl:if> <!-- fiscal -->
                  <xsl:if test="matches($all_keys, '.*(fiscal_property).*')"><xsl:text>#b@</xsl:text></xsl:if> <!-- not fiscal -->
                  <xsl:if test="matches($all_keys, '.* (ports|bridges/pontoons|maritime_trade|fluvial_transport|navicularii) .*')"><xsl:text>c@</xsl:text></xsl:if> <!-- ports -->
                  <xsl:if test="matches($all_keys, '.* (castle|fortress|tower|clusae/gates|walls|carbonaria|defensive_elements|incastellamento) .*')"><xsl:text>d@</xsl:text></xsl:if> <!-- fortifications -->
                  <xsl:if test="matches($all_keys, '.* (residential|palatium|laubia/topia) .*')"><xsl:text>e@</xsl:text></xsl:if> <!-- residences -->
                  <xsl:if test="matches($all_keys, '.* (mills|kilns|workshops|gynaecea|mints|overland_transport|local_markets|periodic_markets|decima|nona_et_decima|fodrum|albergaria/gifori|profits_of_justice|profits_of_mining/minting|tolls|teloneum|rights_of_use_on_woods/pastures/waters|coinage) .*')"><xsl:text>f@</xsl:text></xsl:if> <!-- revenues -->
                  <xsl:if test="matches($all_keys, '.* (villas|curtes|gai|massae|salae|demesnes|domuscultae|casali|mansi) .*')"><xsl:text>g@</xsl:text></xsl:if> <!-- estates -->
                  <xsl:if test="matches($all_keys, '.* (casae/cassinae_massaricie|casalini/fundamenta) .*')"><xsl:text>h@</xsl:text></xsl:if> <!-- tenures -->
                  <xsl:if test="matches($all_keys, '.* (petiae|landed_possessions) .*')"><xsl:text>i@</xsl:text></xsl:if> <!-- land -->
                  <xsl:if test="matches($all_keys, '.* (mines|quarries|forests|gualdi|cafagia|fisheries|saltworks|other_basins) .*')"><xsl:text>j@</xsl:text></xsl:if> <!-- fallow -->
                  <xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
                    <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
                  </xsl:choose><xsl:text>"</xsl:text>
                </xsl:for-each><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
              </xsl:for-each>
          <xsl:text>}</xsl:text>
        </xsl:variable>
        
        <div class="row">
          <div class="map_jp"><xsl:attribute name="id"><xsl:value-of select="concat('map', $id)"/></xsl:attribute></div>
          <div class="legend">
            <p>
              <img src="../../../assets/images/golden.png" alt="golden circle" class="mapicon"/>Places linked to fiscal properties
              <img src="../../../assets/images/purple.png" alt="purple circle" class="mapicon"/>Places not linked to fiscal properties
              <img src="../../../assets/images/polygon.png" alt="green polygon" class="mapicon"/>Places not precisely located or wider areas
              <br/>
              <img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>Ports and fords
              <img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>Fortifications
              <img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>Residences
              <img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>Markets, crafts and revenues
              <img src="../../../assets/images/star.png" alt="star" class="mapicon"/>Estates and estate units
              <img src="../../../assets/images/square.png" alt="square" class="mapicon"/>Tenures
              <img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>Land plots and rural buildings
              <img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>Fallow land
            </p>
          </div>
          <script type="text/javascript">
            var streets = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
            id: 'mapbox/streets-v11', 
            tileSize: 512, 
            zoomOffset: -1, 
            attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
            });
            var grayscale = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
            id: 'mapbox/light-v10', 
            tileSize: 512, 
            zoomOffset: -1, 
            attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
            });
            var satellite = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
            id: 'mapbox/satellite-streets-v11', 
            tileSize: 512, 
            zoomOffset: -1, 
            attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
            });
            var dare = L.tileLayer('https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
            minZoom: 4,
            maxZoom: 11,
            attribution: 'Map data <a href="https://imperium.ahlfeldt.se/">Digital Atlas of the Roman Empire</a> CC BY 4.0'
            });
            var terrain = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Tiles and source Esri',
            maxZoom: 13
            });
            var watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
            attribution: 'Map tiles <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>, Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            subdomains: 'abcd',
            minZoom: 1,
            maxZoom: 16,
            ext: 'jpg'
            });
            var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            });
            var <xsl:value-of select="concat('map', $id)"/> = L.map('<xsl:value-of select="concat('map', $id)"/>', { center: [44, 10.335], zoom: 5, layers: [osm, streets, grayscale, satellite, terrain, watercolor] });
            
            L.control.scale().addTo(<xsl:value-of select="concat('map', $id)"/>);
            var LeafIcon = L.Icon.extend({ options: {iconSize: [14, 14]} });
            var purpleIcon = new LeafIcon({iconUrl: '../../../assets/images/purple.png'}),
            goldenIcon = new LeafIcon({iconUrl: '../../../assets/images/golden.png'});
            
            var polygons = <xsl:value-of select="replace(replace($map_polygons, ', !', ''), '!', '')"/>;
            var points = <xsl:value-of select="replace($map_points, ', ,', ',')"/>;
            var polygons_places = [];
            var purple_places = [];
            var golden_places = [];
            var ports_places = [];
            var fortifications_places = [];
            var residences_places = [];
            var revenues_places = [];
            var estates_places = [];
            var tenures_places = [];
            var land_places = [];
            var fallow_places = [];
            
            for (var [key, value] of Object.entries(points)) {
            var info = key.substring(key.indexOf("@"), key.lastIndexOf("@"));
            symbols = info.replace('@c', '<img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>').replace('@d', '<img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>').replace('@e', '<img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>').replace('@f', '<img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>').replace('@g', '<img src="../../../assets/images/star.png" alt="star" class="mapicon"/>').replace('@h', '<img src="../../../assets/images/square.png" alt="square" class="mapicon"/>').replace('@i', '<img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>').replace('@j', '<img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>'); 
            if (key.includes('#a')) {
            purple_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            if (key.includes('c@')) {
            ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('d@')) {
            fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('e@')) {
            residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('f@')) {
            revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('g@')) {
            estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('h@')) {
            tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('i@')) {
            land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('j@')) {
            fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            }
            if (key.includes('#b')) {
            golden_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            if (key.includes('c@')) {
            ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('d@')) {
            fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('e@')) {
            residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('f@')) {
            revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('g@')) {
            estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('h@')) {
            tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('i@')) {
            land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('j@')) {
            fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            }
            };
            
            for (var [key, value] of Object.entries(polygons)) {
            var split_values = value.split(';');
            split_values.forEach(function(item, index, array) {
            array[index] = parseFloat(item);
            });
            var coords = chunkArray(split_values, 2);  <!-- function called from assets/scripts/maps.js -->
            polygons_places.push(L.polygon([coords], {color: 'green'}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
            }; 
            var toggle_ports_places = L.layerGroup(ports_places);
            var toggle_fortifications_places = L.layerGroup(fortifications_places);
            var toggle_residences_places = L.layerGroup(residences_places);
            var toggle_revenues_places = L.layerGroup(revenues_places);
            var toggle_estates_places = L.layerGroup(estates_places);
            var toggle_tenures_places = L.layerGroup(tenures_places);
            var toggle_land_places = L.layerGroup(land_places);
            var toggle_fallow_places = L.layerGroup(fallow_places);
            var toggle_purple_places = L.layerGroup(purple_places).addTo(<xsl:value-of select="concat('map', $id)"/>);
            var toggle_golden_places = L.layerGroup(golden_places).addTo(<xsl:value-of select="concat('map', $id)"/>);
            var toggle_polygons = L.layerGroup(polygons_places).addTo(<xsl:value-of select="concat('map', $id)"/>);
            
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
            "All places linked to fiscal properties": toggle_golden_places,
            "All places not linked to fiscal properties": toggle_purple_places,
            "Places not precisely located or wider areas": toggle_polygons,
            "Ports and fords": toggle_ports_places,
            "Fortifications": toggle_fortifications_places,
            "Residences": toggle_residences_places,
            "Markets, crafts and revenues": toggle_revenues_places,
            "Estates and estate units": toggle_estates_places,
            "Tenures": toggle_tenures_places,
            "Land plots and rural buildings": toggle_land_places,
            "Fallow land": toggle_fallow_places
            };
            
            L.control.layers(baseMaps, overlayMaps).addTo(<xsl:value-of select="concat('map', $id)"/>);
            L.Control.geocoder().addTo(<xsl:value-of select="concat('map', $id)"/>);
          </script>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <!-- GRAPH -->
  <xsl:template match="//tei:addSpan[@xml:id='graph']">
    <xsl:variable name="graph_people">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$people/tei:person">
        <xsl:variable name="name" select="normalize-space(translate(tei:persName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(translate(tei:idno[1],'#',''), 'people/')"/>
        <xsl:text>{id: </xsl:text><xsl:value-of select="$id"/><xsl:text>, label: '</xsl:text><xsl:value-of select="$name"/><xsl:text>'}</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    <xsl:variable name="graph_relations">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$people/tei:person/tei:link[@type='people']">
        <xsl:variable name="id" select="substring-after(ancestor::tei:person/tei:idno, 'people/')"/>
        <xsl:variable name="relation_type"><xsl:choose>
          <xsl:when test="@subtype!=''"><xsl:value-of select="@subtype"/></xsl:when><xsl:otherwise><xsl:text>link</xsl:text></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:variable name="color"><xsl:choose>
            <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='family']"><xsl:text>red</xsl:text></xsl:when>
            <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='personal']"><xsl:text>green</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>blue</xsl:text></xsl:otherwise>
          </xsl:choose></xsl:variable>
        <xsl:choose>
          <xsl:when test="not(contains(@corresp, ' '))">
            <xsl:text>{from: </xsl:text><xsl:value-of select="$id"/><xsl:text>, to: </xsl:text><xsl:value-of select="substring-after(@corresp, 'people/')"/>
            <xsl:text>, label: '</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>', arrows: "to", color: "</xsl:text><xsl:value-of select="$color"/>
            <xsl:text>"}</xsl:text>
          </xsl:when>
          <xsl:when test="contains(@corresp, ' ')">
            <xsl:for-each select="tokenize(@corresp, ' ')">
              <xsl:variable name="single_item" select="."/>
              <xsl:text>{from: </xsl:text><xsl:value-of select="$id"/><xsl:text>, to: </xsl:text><xsl:value-of select="substring-after($single_item, 'people/')"/>
              <xsl:text>, label: '</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>', arrows: "to", color: "</xsl:text><xsl:value-of select="$color"/>
              <xsl:text>"}</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="graph_labels">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$people/tei:person">
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:persName[1], ',', '; '))"/><xsl:text>"</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    
    <div class="row" style="padding: 40px 20px 60px 20px">
      <div id="mynetwork"></div>
      <div class="legend">
        <p>
          <span style="color:red">➔</span> family relations | 
          <span style="color:green">➔</span> personal bonds |
          <span style="color:blue">➔</span> other links
          <br/>[Zoom in and click on the arrows to show the relation types]
          <br/><button onclick="openFullscreen();" class="button">Fullscreen</button>
          <br/><span class="autocomplete"><input type="text" id="inputSearch" placeholder="Search"/></span><button id="btnSearch" class="button">Search</button>
        </p>
      </div>
      
      <script type="text/javascript">
        const people = <xsl:value-of select="$graph_people"/>;
        const relations = <xsl:value-of select="$graph_relations"/>;
        const labels = <xsl:value-of select="$graph_labels"/>;
        var nodes = new vis.DataSet(people);
        var edges = new vis.DataSet(relations);
        
        var container = document.getElementById('mynetwork');
        var data = {
        nodes: nodes,
        edges: edges
        };
        var options = {
        edges:{
            font: { 
                align: "horizontal",
                size: 5,
                color: "lightgrey"
            },
            chosen: { 
              label: function (values, id, selected, hovering) { 
                values.size = 16;
                values.color = "black";
                }
            } 
        },
        nodes:{
        shape: "box",
        widthConstraint: { maximum: 200 }
        },
        interaction:{
        navigationButtons: true
        },
        physics: {
        enabled: false,
        solver: "repulsion",
        repulsion: {
        nodeDistance: 250
        }
        }
        };
        var network = new vis.Network(container, data, options);
        network.stabilize();
        
        <!-- fullscreen -->
        var full = document.getElementById("mynetwork"); 
        function openFullscreen() {
        if (full.requestFullscreen) {
        full.requestFullscreen();
        } else if (full.webkitRequestFullscreen) {
        full.webkitRequestFullscreen();
        } else if (full.msRequestFullscreen) {
        full.msRequestFullscreen();
        }
        }
        
        <!-- search -->
       $("#btnSearch").on('click',function () {
       for (var i = 0; i&lt;people.length; i++){
       if (people[i].label.indexOf($("#inputSearch").val()) >=0) {
          if ($("#inputSearch").val() != ''){
          people[i].color = {
          background: "yellow"
          };
          };
          }
          else{
          delete people[i].color;
          }
          }
          new vis.Network(container, data, options).stabilize();
          });
          
          autocomplete(document.getElementById("inputSearch"), labels); <!-- function called from assets/networks.js -->
      </script>
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
        <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
        <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
        <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
        <xsl:variable name="linked_keys"><xsl:for-each select="$keys//p[@class='place_keys'][@id=$id]"><xsl:value-of select="lower-case(.)"/><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
        <xsl:variable name="all_keys" select="concat(' ', normalize-space($linked_keys))"/>
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
        <xsl:if test="not(matches($all_keys, '.*(fiscal_property).*'))"><xsl:text>#a@</xsl:text></xsl:if> <!-- fiscal -->
        <xsl:if test="matches($all_keys, '.*(fiscal_property).*')"><xsl:text>#b@</xsl:text></xsl:if> <!-- not fiscal -->
        <xsl:if test="matches($all_keys, '.* (ports|bridges/pontoons|maritime_trade|fluvial_transport|navicularii) .*')"><xsl:text>c@</xsl:text></xsl:if> <!-- ports -->
        <xsl:if test="matches($all_keys, '.* (castle|fortress|tower|clusae/gates|walls|carbonaria|defensive_elements|incastellamento) .*')"><xsl:text>d@</xsl:text></xsl:if> <!-- fortifications -->
        <xsl:if test="matches($all_keys, '.* (residential|palatium|laubia/topia) .*')"><xsl:text>e@</xsl:text></xsl:if> <!-- residences -->
        <xsl:if test="matches($all_keys, '.* (mills|kilns|workshops|gynaecea|mints|overland_transport|local_markets|periodic_markets|decima|nona_et_decima|fodrum|albergaria/gifori|profits_of_justice|profits_of_mining/minting|tolls|teloneum|rights_of_use_on_woods/pastures/waters|coinage) .*')"><xsl:text>f@</xsl:text></xsl:if> <!-- revenues -->
        <xsl:if test="matches($all_keys, '.* (villas|curtes|gai|massae|salae|demesnes|domuscultae|casali|mansi) .*')"><xsl:text>g@</xsl:text></xsl:if> <!-- estates -->
        <xsl:if test="matches($all_keys, '.* (casae/cassinae_massaricie|casalini/fundamenta) .*')"><xsl:text>h@</xsl:text></xsl:if> <!-- tenures -->
        <xsl:if test="matches($all_keys, '.* (petiae|landed_possessions) .*')"><xsl:text>i@</xsl:text></xsl:if> <!-- land -->
        <xsl:if test="matches($all_keys, '.* (mines|quarries|forests|gualdi|cafagia|fisheries|saltworks|other_basins) .*')"><xsl:text>j@</xsl:text></xsl:if> <!-- fallow -->
        <xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
         <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
          </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:variable>
    
    <!-- add map -->
    <div class="row">
      <div id="mapid" class="map"></div>
      <div class="legend">
        <p>
          <img src="../../../assets/images/golden.png" alt="golden circle" class="mapicon"/>Places linked to fiscal properties
          <img src="../../../assets/images/purple.png" alt="purple circle" class="mapicon"/>Places not linked to fiscal properties
          <img src="../../../assets/images/polygon.png" alt="green polygon" class="mapicon"/>Places not precisely located or wider areas
          <br/>
          <img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>Ports and fords
          <img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>Fortifications
          <img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>Residences
          <img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>Markets, crafts and revenues
          <img src="../../../assets/images/star.png" alt="star" class="mapicon"/>Estates and estate units
          <img src="../../../assets/images/square.png" alt="square" class="mapicon"/>Tenures
          <img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>Land plots and rural buildings
          <img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>Fallow land
        </p>
      </div>
      <script type="text/javascript">
        var streets = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/streets-v11', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        var grayscale = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/light-v10', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        var satellite = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        id: 'mapbox/satellite-streets-v11', 
        tileSize: 512, 
        zoomOffset: -1, 
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
        });
        var dare = L.tileLayer('https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
        minZoom: 4,
        maxZoom: 11,
        attribution: 'Map data <a href="https://imperium.ahlfeldt.se/">Digital Atlas of the Roman Empire</a> CC BY 4.0'
        });
        var terrain = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles and source Esri',
        maxZoom: 13
        });
        var watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
        attribution: 'Map tiles <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>, Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        subdomains: 'abcd',
        minZoom: 1,
        maxZoom: 16,
        ext: 'jpg'
        });
        var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        });
        
        var mymap = L.map('mapid', { center: [44, 10.335], zoom: 6.5, layers: [osm, streets, grayscale, satellite, terrain, watercolor] });
        L.control.scale().addTo(mymap);
        
        var LeafIcon = L.Icon.extend({ options: {iconSize: [14, 14]} });
        var purpleIcon = new LeafIcon({iconUrl: '../../../assets/images/purple.png'}),
        goldenIcon = new LeafIcon({iconUrl: '../../../assets/images/golden.png'});
        <!--var portsIcon = new LeafIcon({iconUrl: '../../../assets/images/anchor.png'}),
        fortificationsIcon = new LeafIcon({iconUrl: '../../../assets/images/tower.png'}),
        residencesIcon = new LeafIcon({iconUrl: '../../../assets/images/sella.png'}),
        revenuesIcon = new LeafIcon({iconUrl: '../../../assets/images/coin.png'}),
        estatesIcon = new LeafIcon({iconUrl: '../../../assets/images/star.png'}),
        tenuresIcon = new LeafIcon({iconUrl: '../../../assets/images/square.png'}),
        landIcon = new LeafIcon({iconUrl: '../../../assets/images/triangle.png'}),
        fallowIcon = new LeafIcon({iconUrl: '../../../assets/images/tree.png'}); -->
        
        const polygons = <xsl:value-of select="$map_polygons"/>;
        const points = <xsl:value-of select="$map_points"/>;
        
        var polygons_places = [];
        var purple_places = [];
        var golden_places = [];
        var ports_places = [];
        var fortifications_places = [];
        var residences_places = [];
        var revenues_places = [];
        var estates_places = [];
        var tenures_places = [];
        var land_places = [];
        var fallow_places = [];
        
        for (const [key, value] of Object.entries(points)) {
        var info = key.substring(key.indexOf("@"), key.lastIndexOf("@"));
        symbols = info.replace('@c', '<img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>').replace('@d', '<img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>').replace('@e', '<img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>').replace('@f', '<img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>').replace('@g', '<img src="../../../assets/images/star.png" alt="star" class="mapicon"/>').replace('@h', '<img src="../../../assets/images/square.png" alt="square" class="mapicon"/>').replace('@i', '<img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>').replace('@j', '<img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>'); 
        if (key.includes('#a')) {
        purple_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        if (key.includes('c@')) {
        ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('d@')) {
        fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('e@')) {
        residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('f@')) {
        revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('g@')) {
        estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('h@')) {
        tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('i@')) {
        land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('j@')) {
        fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        }
        
        if (key.includes('#b')) {
        golden_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        if (key.includes('c@')) {
        ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('d@')) {
        fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('e@')) {
        residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('f@')) {
        revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('g@')) {
        estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('h@')) {
        tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('i@')) {
        land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        if (key.includes('j@')) {
        fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> ' + symbols + ' <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
        }
        }
        };
        
        for (const [key, value] of Object.entries(polygons)) {
                var split_values = value.split(';');
                split_values.forEach(function(item, index, array) {
                array[index] = parseFloat(item);
                });
              var coords = chunkArray(split_values, 2);  <!-- function called from assets/scripts/maps.js -->
        polygons_places.push(L.polygon([coords], {color: 'green'}).bindPopup('<a href="#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.lastIndexOf("#")) + '</a> <span style="display:block">See linked documents: <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
        }; 

        var toggle_ports_places = L.layerGroup(ports_places);
        var toggle_fortifications_places = L.layerGroup(fortifications_places);
        var toggle_residences_places = L.layerGroup(residences_places);
        var toggle_revenues_places = L.layerGroup(revenues_places);
        var toggle_estates_places = L.layerGroup(estates_places);
        var toggle_tenures_places = L.layerGroup(tenures_places);
        var toggle_land_places = L.layerGroup(land_places);
        var toggle_fallow_places = L.layerGroup(fallow_places);
        var toggle_purple_places = L.layerGroup(purple_places).addTo(mymap); 
        var toggle_golden_places = L.layerGroup(golden_places).addTo(mymap);
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
        "All places linked to fiscal properties": toggle_golden_places,
        "All places not linked to fiscal properties": toggle_purple_places,
        "Places not precisely located or wider areas": toggle_polygons,
        "Ports and fords": toggle_ports_places,
        "Fortifications": toggle_fortifications_places,
        "Residences": toggle_residences_places,
        "Markets, crafts and revenues": toggle_revenues_places,
        "Estates and estate units": toggle_estates_places,
        "Tenures": toggle_tenures_places,
        "Land plots and rural buildings": toggle_land_places,
        "Fallow land": toggle_fallow_places
        };
        
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        L.Control.geocoder().addTo(mymap);
        
      </script>
    </div>
  </xsl:template>
  
</xsl:stylesheet>