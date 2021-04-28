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
  <xsl:variable name="texts" select="collection(concat($epidoc, '?select=*.xml;recurse=yes'))//tei:div[@type='edition']"/>
  
  <xsl:variable name="keys">
    <xsl:for-each select="$texts">
        <xsl:for-each select=".//tei:placeName[@key!=''][@ref]">
          <p class="place_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'places/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select=".//tei:geogName[@key!=''][@ref]">
          <p class="estate_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'estates/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select=".//tei:persName[@key!=''][@ref]">
          <p class="person_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'people/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
        <xsl:for-each select=".//tei:orgName[@key!=''][@ref]">
          <p class="jp_keys"><xsl:attribute name="id"><xsl:value-of select="substring-after(@ref, 'juridical_persons/')"/></xsl:attribute><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
        </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- import lists -->
  <xsl:template match="//tei:p[@n='import']">
    <div class="imported_list">
      <button onclick="topFunction()" id="scroll" title="Go to top">⬆  </button> 
      <script type="text/javascript">
        mybutton = document.getElementById("scroll");
        window.onscroll = function() {scrollFunction()};
        function scrollFunction() {
        if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) { mybutton.style.display = "block"; } 
        else { mybutton.style.display = "none"; }
        }
        function topFunction() {
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        } 
      </script>
      <xsl:if test="ancestor::tei:TEI[@xml:id='places']"><xsl:apply-templates select="$places"/></xsl:if>
      <xsl:if test="ancestor::tei:TEI[@xml:id='juridical_persons']"><xsl:apply-templates select="$juridical_persons"/></xsl:if>
      <xsl:if test="ancestor::tei:TEI[@xml:id='estates']"><xsl:apply-templates select="$estates"/></xsl:if>
      <xsl:if test="ancestor::tei:TEI[@xml:id='people']"><xsl:apply-templates select="$people"/></xsl:if>
    </div>
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
    
    <xsl:variable name="mentioning_documents">
          <xsl:for-each select="$texts">
              <xsl:for-each select=".[descendant::tei:*[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
    
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
        <xsl:if test="$number_of_mentioning_documents!=0"><strong><xsl:text>Linked documents (</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/><xsl:text>): </xsl:text></strong>
            <a><xsl:attribute name="href"><xsl:choose>
            <xsl:when test="ancestor::tei:listOrg"><xsl:value-of select="concat('../indices/epidoc/juridical_persons.html#', $id)"/></xsl:when>
            <xsl:when test="ancestor::tei:listPerson"><xsl:value-of select="concat('../indices/epidoc/people.html#', $id)"/></xsl:when>
            <xsl:when test="ancestor::tei:listPlace[descendant::tei:geo]"><xsl:value-of select="concat('../indices/epidoc/places.html#', $id)"/></xsl:when>
            <xsl:when test="ancestor::tei:listPlace[not(descendant::tei:geo)]"><xsl:value-of select="concat('../indices/epidoc/estates.html#', $id)"/></xsl:when>
          </xsl:choose></xsl:attribute><xsl:text>➚</xsl:text></a>
          <br/></xsl:if>
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
            <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
            <xsl:variable name="mentioning_documents">
                <xsl:for-each select="$texts">
                  <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
                </xsl:for-each>
              </xsl:variable>
              <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
              
            <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
            <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
            <xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
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
                  <xsl:variable name="mentioning_documents">
                    <xsl:for-each select="$texts">
                      <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
                  
                  <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
                  <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
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
        
        <div class="row map_box">
          <div class="map_jp"><xsl:attribute name="id"><xsl:value-of select="concat('map', $id)"/></xsl:attribute></div>
          <div class="legend" id="map_legend">
            <p>
              <img src="../../../assets/images/golden.png" alt="golden circle" class="mapicon"/>Places linked to fiscal properties
              <img src="../../../assets/images/purple.png" alt="purple circle" class="mapicon"/>Places not linked to fiscal properties
              <img src="../../../assets/images/polygon.png" alt="green polygon" class="mapicon"/>Places not precisely located or wider areas <br/>
              <img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>Ports, fords
              <img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>Fortifications
              <img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>Residences
              <img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>Markets, crafts, revenues
              <img src="../../../assets/images/star.png" alt="star" class="mapicon"/>Estates, estate units
              <img src="../../../assets/images/square.png" alt="square" class="mapicon"/>Tenures
              <img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>Land plots, rural buildings
              <img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>Fallow land
            </p>
          </div>
          <script type="text/javascript">
            var polygons = <xsl:value-of select="replace(replace($map_polygons, ', !', ''), '!', '')"/>;
            var points = <xsl:value-of select="replace($map_points, ', ,', ',')"/>;
            </script>
          <script type="text/javascript" src="../../assets/scripts/maps.js"></script>
          <script type="text/javascript">
            var <xsl:value-of select="concat('map', $id)"/> = L.map('<xsl:value-of select="concat('map', $id)"/>', 
            { center: [44, 10.335], zoom: 6, layers: layers });
            L.control.layers(baseMaps, overlayMaps).addTo(<xsl:value-of select="concat('map', $id)"/>);
            L.control.scale().addTo(<xsl:value-of select="concat('map', $id)"/>);
            L.Control.geocoder().addTo(<xsl:value-of select="concat('map', $id)"/>);
            toggle_purple_places.addTo(<xsl:value-of select="concat('map', $id)"/>);
            toggle_golden_places.addTo(<xsl:value-of select="concat('map', $id)"/>);
            toggle_polygons.addTo(<xsl:value-of select="concat('map', $id)"/>);
          </script>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <!-- GRAPH -->
  <xsl:template match="//tei:addSpan[@xml:id='graph']">
    <xsl:variable name="graph_items">
      <xsl:text>{nodes:[</xsl:text>
      <xsl:for-each select="$people/tei:person">
        <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="tei:idno[1]"/><xsl:text>", name: "</xsl:text>        
        <xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>", type: "people_only"}</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>], edges:[</xsl:text>
      <xsl:for-each select="$people//tei:link[@corresp!=''][@type='people']">
        <xsl:variable name="id" select="parent::tei:*/tei:idno[1]"/>
        <xsl:variable name="relation_type"><xsl:choose>
          <xsl:when test="@subtype='' or @subtype='link' or @subtype='hasConnectionWith'"><xsl:text> </xsl:text></xsl:when>
          <xsl:otherwise><xsl:value-of select="@subtype"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='family']"><xsl:text>red</xsl:text></xsl:when>
            <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='personal']"><xsl:text>green</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>blue</xsl:text></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="not(contains(@corresp, ' '))">
            <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', replace(@corresp, '#', ''))"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
            <xsl:text>", target: "</xsl:text><xsl:value-of select="replace(@corresp, '#', '')"/><xsl:text>"</xsl:text> 
            <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
            <xsl:text>}}</xsl:text>
          </xsl:when>
          <xsl:when test="contains(@corresp, ' ')">
            <xsl:for-each select="tokenize(@corresp, ' ')">
              <xsl:variable name="single_item" select="replace(., '#', '')"/>
              <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', $single_item)"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
              <xsl:text>", target: "</xsl:text><xsl:value-of select="$single_item"/><xsl:text>"</xsl:text> 
              <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
              <xsl:text>}}</xsl:text>
              <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]}</xsl:text>
    </xsl:variable>
    <xsl:variable name="graph_labels">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$people/tei:person">
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>"</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    
    <div class="row network_box" id="mynetwork_box">
      <div class="legend">
        <p>
          <span class="autocomplete"><input type="text" id="inputSearch" placeholder="Type a name here or select one or more items in the graph"  title="To select more items, hold Shift and click on them in the graph"/></span><button id="btnSearch" class="button">Show</button> <button id="reset" class="button">Reset</button> <button onclick="openFullscreen();" class="button">Fullscreen</button>
        </p>
      </div>
      <div id="mynetwork"></div>
      <div class="legend">
        <p>
          <span id="toggle_people"/><span id="toggle_juridical_persons"/><span id="toggle_estates"/><span id="toggle_places"/>
          <span class="red_label">➔</span> Family relations <input type="checkbox" id="toggle_red" checked="true"/> 
          <span class="green_label">➔</span> Interpersonal bonds <input type="checkbox" id="toggle_green" checked="true"/>
          <span class="orange_label"/>
          <span class="blue_label">➔</span> Other interpersonal links <input type="checkbox" id="toggle_blue" checked="true"/>
          <span class="relations_label"> Relation types </span> <input type="checkbox" id="toggle_relation_labels" checked="true"/>
        </p>
      </div>
      
      <script type="text/javascript">
          var graph_items = <xsl:value-of select="$graph_items"/>, graph_labels = <xsl:value-of select="$graph_labels"/>, my_graph = "mynetwork", box = "mynetwork_box";
        </script>
        <script type="text/javascript" src="../../assets/scripts/networks.js"></script>
     </div>
  </xsl:template>
  
  <!-- COMPLETE GRAPH -->
  <xsl:template match="//tei:addSpan[@xml:id='graphs']">
    <xsl:variable name="graph_items">
      <xsl:text>{nodes:[</xsl:text>
      <xsl:for-each select="$people/tei:person|$juridical_persons/tei:org|$estates/tei:place|$places/tei:place">
        <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="tei:idno[1]"/><xsl:text>", name: "</xsl:text>        
        <xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>"</xsl:text>
        <xsl:text>, type: "</xsl:text><xsl:choose>
          <xsl:when test="ancestor::tei:listPerson">people</xsl:when>
          <xsl:when test="ancestor::tei:listOrg">juridical_persons</xsl:when>
          <xsl:when test="ancestor::tei:listPlace[@type='estates']">estates</xsl:when>
          <xsl:when test="ancestor::tei:listPlace[@type='places']">places</xsl:when>
        </xsl:choose><xsl:text>"}</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>], edges:[</xsl:text>
      <xsl:for-each select="$people//tei:link[@corresp!='']|$juridical_persons//tei:link[@corresp!='']|$estates//tei:link[@corresp!='']|$places//tei:link[@corresp!='']">
        <xsl:variable name="id" select="parent::tei:*/tei:idno[1]"/>
        <xsl:variable name="relation_type"><xsl:choose>
          <xsl:when test="@subtype='' or @subtype='link' or @subtype='hasConnectionWith'"><xsl:text> </xsl:text></xsl:when>
          <xsl:otherwise><xsl:value-of select="@subtype"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:variable name="color">
          <xsl:choose>
            <xsl:when test="ancestor::tei:person and @type='people'">
              <xsl:choose>
                <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='family']"><xsl:text>red</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>green</xsl:text></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::tei:person or @type='people'"><xsl:text>orange</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>blue</xsl:text></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="not(contains(@corresp, ' '))">
            <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', replace(@corresp, '#', ''))"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
            <xsl:text>", target: "</xsl:text><xsl:value-of select="replace(@corresp, '#', '')"/><xsl:text>"</xsl:text> 
            <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
            <xsl:text>}}</xsl:text>
          </xsl:when>
          <xsl:when test="contains(@corresp, ' ')">
            <xsl:for-each select="tokenize(@corresp, ' ')">
              <xsl:variable name="single_item" select="replace(., '#', '')"/>
              <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', $single_item)"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
              <xsl:text>", target: "</xsl:text><xsl:value-of select="$single_item"/><xsl:text>"</xsl:text> 
              <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
              <xsl:text>}}</xsl:text>
              <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]}</xsl:text>
    </xsl:variable>
    <xsl:variable name="graph_labels">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$people/tei:person|$juridical_persons/tei:org|$estates/tei:place|$places/tei:place">
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>"</xsl:text>
        <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    
    <div class="row network_box" id="mygraph_box">
      <div class="legend">
        <p>
          <span class="autocomplete"><input type="text" id="inputSearch" placeholder="Type a name here or select one or more items in the graph"  title="To select more items, hold Shift and click on them in the graph"/></span><button id="btnSearch" class="button">Show</button> <button id="reset" class="button">Reset</button> <button onclick="openFullscreen();" class="button">Fullscreen</button>
        </p>
      </div>
      <div id="mygraph"></div>
      <div class="legend">
        <p>
          <span class="people_label">People</span> <input type="checkbox" id="toggle_people" checked="true"/>
          <span class="jp_label">Juridical persons</span> <input type="checkbox" id="toggle_juridical_persons" checked="true"/>
          <span class="estates_label">Estates</span> <input type="checkbox" id="toggle_estates" checked="true"/>
          <span class="places_label">Places</span> <input type="checkbox" id="toggle_places" checked="true"/>
          <span class="red_label">➔</span> Family relations <input type="checkbox" id="toggle_red" checked="true"/> 
          <span class="green_label">➔</span> Interpersonal bonds <input type="checkbox" id="toggle_green" checked="true"/>
          <span class="orange_label">➔</span> Other personal links <input type="checkbox" id="toggle_orange" checked="true"/>
          <span class="blue_label">➔</span> Other links <input type="checkbox" id="toggle_blue" checked="true"/>
          <span class="relations_label"> Relation types </span> <input type="checkbox" id="toggle_relation_labels" checked="true"/>
        </p>
      </div>
      
      <script type="text/javascript">
        var graph_items = <xsl:value-of select="$graph_items"/>, graph_labels = <xsl:value-of select="$graph_labels"/>, my_graph = "mygraph", box = "mygraph_box";
       </script>
      <script type="text/javascript" src="../../assets/scripts/networks.js"></script>
      <!--<script type="text/javascript" src="../../assets/scripts/wine.js"></script>-->
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
        <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
        <xsl:variable name="mentioning_documents">
          <xsl:for-each select="$texts">
            <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
        
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
        <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
        <xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
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
        <xsl:variable name="mentioning_documents">
          <xsl:for-each select="$texts">
              <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
        
        
        <xsl:text>"</xsl:text><xsl:value-of select="$name"/>
        <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
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
    
    <xsl:variable name="map_labels">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$places/tei:place[descendant::tei:geo/text()]">
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:placeName[1], ',', '; '))"/><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    
    <!-- add map -->
    <div class="row map_box">
      <div id="mapid" class="map"></div>
      <div class="legend">
        <p>
          <img src="../../../assets/images/golden.png" alt="golden circle" class="mapicon"/>Places linked to fiscal properties
          <img src="../../../assets/images/purple.png" alt="purple circle" class="mapicon"/>Places not linked to fiscal properties
          <img src="../../../assets/images/polygon.png" alt="green polygon" class="mapicon"/>Places not precisely located or wider areas <br/>
          <img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>Ports, fords
          <img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>Fortifications
          <img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>Residences
          <img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>Markets, crafts, revenues
          <img src="../../../assets/images/star.png" alt="star" class="mapicon"/>Estates, estate units
          <img src="../../../assets/images/square.png" alt="square" class="mapicon"/>Tenures
          <img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>Land plots, rural buildings
          <img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>Fallow land
        </p>
      </div>
      <script type="text/javascript">
        var polygons = <xsl:value-of select="$map_polygons"/>;
        var points = <xsl:value-of select="$map_points"/>;
        var map_labels = <xsl:value-of select="$map_labels"/>;
      </script>
      <script type="text/javascript" src="../../assets/scripts/maps.js"></script>
      <script type="text/javascript">
        var mymap = L.map('mapid', { center: [44, 10.335], zoom: 6, layers: layers });
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        L.control.scale().addTo(mymap);
        L.Control.geocoder().addTo(mymap);
        toggle_purple_places.addTo(mymap); 
        toggle_golden_places.addTo(mymap);
        toggle_polygons.addTo(mymap);
      </script>
    </div>
  </xsl:template>
  
</xsl:stylesheet>