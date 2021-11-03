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


  <!-- MAP VARIABLES -->
  <xsl:variable name="places" select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/fiscus_framework/resources/places.xml'))/tei:TEI/tei:text/tei:body/tei:listPlace[@type='places']/tei:listPlace"/> <!-- used also by graphs -->
  
  <!-- @key values from markup in documents -->
  <xsl:variable name="texts" select="collection(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/xml/epidoc/?select=*.xml;recurse=yes'))/tei:TEI/tei:text/tei:body/tei:div[@type='edition']"/>
  <xsl:variable name="keys">
    <xsl:for-each select="$texts//tei:placeName[@key!=''][@ref]">
        <p id="{substring-after(@ref, 'places/')}"><xsl:value-of select="translate(@key, '#', '')"/><xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if></p>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- identifying places from uncertain tradition -->
  <xsl:variable name="uncertain_places">
    <xsl:for-each select="$texts">
      <xsl:for-each select="//tei:placeName[matches(lower-case(@key), '.*(uncertain_tradition).*')][@ref]">
        <xsl:text> </xsl:text><xsl:value-of select="substring-after(@ref, 'places/')"/><xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="certain_places">
    <xsl:for-each select="$texts">
      <xsl:for-each select="//tei:placeName[not(matches(lower-case(@key), '.*(uncertain_tradition).*'))][@ref]">
        <xsl:text> </xsl:text><xsl:value-of select="substring-after(@ref, 'places/')"/><xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  
  <!-- generate lists of places by type -->
  <xsl:variable name="map_polygons">
    <xsl:text>{</xsl:text>
    <xsl:for-each select="$places/tei:place[matches(descendant::tei:geo[not(@style='line')], '[\d+\.{0,1}\d+?,\s+?\d+\.{0,1}\d+;]+\s+\d+\.{0,1}\d+?,\s+\d+\.{0,1}\d+')]">
      <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
      <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
      <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
      <xsl:variable name="years" select="'0500/1500'"/>
      <xsl:variable name="mentioning_documents">
        <xsl:for-each select="$texts">
          <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
      <xsl:text>"</xsl:text><xsl:value-of select="$years"/><xsl:text>|</xsl:text><xsl:value-of select="$name"/>
      <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
      <xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
      <xsl:value-of select="replace(replace(normalize-space(tei:geogName/tei:geo[not(@style='line')]), ', ', ';'), '; ', ';')"/>
      <xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="map_lines">
    <xsl:text>{</xsl:text>
    <xsl:for-each select="$places/tei:place[matches(descendant::tei:geo[@style='line'], '[\d+\.{0,1}\d+?,\s+?\d+\.{0,1}\d+;]+\s+\d+\.{0,1}\d+?,\s+\d+\.{0,1}\d+')]">
      <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
      <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
      <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
      <xsl:variable name="years" select="'0500/1500'"/>
      <xsl:variable name="mentioning_documents">
        <xsl:for-each select="$texts">
          <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
      <xsl:text>"</xsl:text><xsl:value-of select="$years"/><xsl:text>|</xsl:text><xsl:value-of select="$name"/>
      <xsl:text>#</xsl:text><xsl:value-of select="$number_of_mentioning_documents"/>
      <xsl:text>#</xsl:text><xsl:value-of select="$id"/><xsl:text>": "</xsl:text>
      <xsl:value-of select="replace(replace(normalize-space(tei:geogName/tei:geo[@style='line']), ', ', ';'), '; ', ';')"/>
      <xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="map_points">
    <xsl:text>{</xsl:text>
    <xsl:for-each select="$places/tei:place[matches(descendant::tei:geo, '\d+[\.]{0,1}\d+?,\s+?\d+[\.]{0,1}\d+')]">
      <xsl:variable name="name" select="normalize-space(translate(tei:placeName[1], ',', '; '))"/>
      <xsl:variable name="id" select="substring-after(translate(tei:idno,'#',''), 'places/')"/>
      <xsl:variable name="idno" select="translate(translate(tei:idno, '#', ''), ' ', '')"/>
      <xsl:variable name="linked_keys"><xsl:for-each select="$keys/p[@id=$id]"><xsl:value-of select="lower-case(.)"/><xsl:text> </xsl:text></xsl:for-each></xsl:variable>
      <xsl:variable name="all_keys" select="concat(' ', normalize-space($linked_keys))"/>
      <xsl:variable name="years" select="'0500/1500'"/>
      <xsl:variable name="mentioning_documents">
        <xsl:for-each select="$texts">
          <xsl:for-each select=".[descendant::tei:placeName[contains(concat(@ref, ' '), concat($idno, ' '))]]"><p/></xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="number_of_mentioning_documents"><xsl:value-of select="count($mentioning_documents/p)"/></xsl:variable>
      <xsl:text>"</xsl:text><xsl:value-of select="$years"/><xsl:text>|</xsl:text><xsl:value-of select="$name"/>
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
      <xsl:if test="contains($uncertain_places, concat(' ',$id,' ')) and not(contains($certain_places, concat(' ',$id,' ')))"><xsl:text>k@</xsl:text></xsl:if> <!-- all occurrences from uncertain tradition -->
      <!--<xsl:if test="matches($all_keys, '.*(uncertain_tradition).*')"><xsl:text>k@</xsl:text></xsl:if> <!-\- at least one occurrence from uncertain tradition -\->-->
      <xsl:value-of select="$id"/><xsl:text>": "</xsl:text><xsl:choose>
        <xsl:when test="contains(normalize-space(tei:geogName/tei:geo), ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="normalize-space(tei:geogName/tei:geo)"/></xsl:otherwise>
      </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="map_labels">
    <xsl:text>[</xsl:text>
    <xsl:for-each select="$places/tei:place[matches(descendant::tei:geo, '\d+[\.]{0,1}\d+?,\s+?\d+[\.]{0,1}\d+') or matches(descendant::tei:geo, '[\d+\.{0,1}\d+?,\s+?\d+\.{0,1}\d+;]+\s+\d+\.{0,1}\d+?,\s+\d+\.{0,1}\d+')]">
      <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:placeName[1], ',', '; '))"/><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:variable>
  
  
  <!-- MAP -->
  <xsl:template match="//tei:addSpan[@xml:id='map']">
    <div class="row map_box">
      <div id="mapid" class="map"></div>
      <div class="legend">
        <p>
          <img src="../../../assets/images/golden.png" alt="golden circle" class="mapicon"/>Places linked to fiscal properties
          <img src="../../../assets/images/purple.png" alt="purple circle" class="mapicon"/>Places not linked to fiscal properties
          <img src="../../../assets/images/polygon.png" alt="green polygon" class="mapicon"/>Places not precisely located or wider areas
          <img src="../../../assets/images/line.png" alt="blue line" class="mapicon"/> Rivers
          <img src="../../../assets/images/black.png" alt="black" class="mapicon" style="margin-right:0"/> <img src="../../../assets/images/uncertain.png" alt="uncertain" class="mapicon" style="margin-left:2px"/>From uncertain tradition <br/>
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
        var lines = <xsl:value-of select="$map_lines"/>;
        var points = <xsl:value-of select="$map_points"/>;
        var map_labels = <xsl:value-of select="$map_labels"/>;
      </script>
      <script type="text/javascript" src="../../assets/scripts/maps.js"></script>
      <script type="text/javascript">
        var mymap = L.map('mapid', { center: [44, 10.335], zoom: 6, fullscreenControl: true, layers: layers });
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        L.control.scale().addTo(mymap);
        L.Control.geocoder().addTo(mymap);
        if (!window.location.href.includes('select')) {
        toggle_purple_places.addTo(mymap); 
        toggle_golden_places.addTo(mymap);
        toggle_polygons.addTo(mymap);
        toggle_lines.addTo(mymap); 
        }
        <!-- to display only places linked to a specific juridical person, whose IDs are in the URL -->
        if (window.location.href.includes('select')) { toggle_select_linked_places.addTo(mymap); }
        var url = String(window.location.href);
        url.substring(url.indexOf("select#") +1, url.lastIndexOf("#")).split("#").forEach(el => displayById(el));
        <!-- to open popup of specific place, whose ID is at the end of the URL -->
        openPopupById(window.location.href.substring(window.location.href.lastIndexOf("#") +1));
        
        <!--var sliderControl = L.control.sliderControl({layer: L.layerGroup(markers)});
        mymap.addControl(sliderControl);
        sliderControl.startSlider();-->
        <!-- to be fixed: what to put in $year; how to display date ranges; how to use legend filters (best to change approach and use separate arrays of places based on periods? Cf. https://github.com/svitkin/leaflet-timeline-slider) -->
      </script>
    </div>
  </xsl:template>
  
  
  <!-- GRAPH VARIABLES -->
  <xsl:variable name="juridical_persons" select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/fiscus_framework/resources/juridical_persons.xml'))/tei:TEI/tei:text/tei:body/tei:listOrg[@type='juridical_persons']/tei:listOrg"/>
  <xsl:variable name="estates" select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/fiscus_framework/resources/estates.xml'))/tei:TEI/tei:text/tei:body/tei:listPlace[@type='estates']/tei:listPlace"/>
  <xsl:variable name="people" select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/fiscus_framework/resources/people.xml'))/tei:TEI/tei:text/tei:body/tei:listPerson[@type='people']/tei:listPerson"/>
  <xsl:variable name="all_items" select="$places|$juridical_persons|$estates|$people"/>
  <xsl:variable name="thesaurus" select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/fiscus_framework/resources/thesaurus.xml'))/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy"/>
  
  <!-- generate lists of items, their relations and their labels -->  
  <xsl:variable name="graph_items">
    <xsl:text>{nodes:[</xsl:text>
    <xsl:for-each select="$all_items/tei:*[not(child::tei:*[1]='XXX')][child::tei:*[1]!=''][child::tei:idno!='']">
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
    <xsl:for-each select="$all_items/tei:*/tei:link[tokenize(concat(replace(@corresp, '#', ''), ' '), ' ')=$all_items/tei:*/tei:idno][not(starts-with(@corresp, ' '))][not(ends-with(@corresp, ' '))]">
      <xsl:variable name="id" select="parent::tei:*/tei:idno[1]"/>
      <xsl:variable name="relation_type"><xsl:choose>
        <xsl:when test="@subtype='' or @subtype='link' or @subtype='hasConnectionWith'"><xsl:text> </xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="@subtype"/></xsl:otherwise>
      </xsl:choose></xsl:variable>
      <xsl:variable name="cert" select="@cert"/>
      <xsl:variable name="color">
        <xsl:choose>
          <xsl:when test="parent::tei:person and @type='people'">
            <xsl:choose>
              <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='family']">
                <xsl:text>red</xsl:text>
              </xsl:when>
              <xsl:otherwise><xsl:text>green</xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="parent::tei:person or @type='people'">
            <xsl:text>blue</xsl:text>
          </xsl:when>
          <xsl:otherwise><xsl:text>orange</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not(contains(@corresp, ' '))">
          <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', replace(@corresp, '#', ''))"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
          <xsl:text>", target: "</xsl:text><xsl:value-of select="replace(@corresp, '#', '')"/><xsl:text>"</xsl:text> 
          <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
          <xsl:if test="$relation_type!=' '"><xsl:text>, subtype: "arrow"</xsl:text></xsl:if>
          <xsl:if test="$cert='low'"><xsl:text>, cert: "low"</xsl:text></xsl:if>
          <xsl:text>}}</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@corresp, ' ')">
          <xsl:for-each select="tokenize(@corresp, ' ')[replace(., '#', '')=$all_items/tei:*/tei:idno]">
            <xsl:variable name="single_item" select="replace(., '#', '')"/>
            <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', $single_item)"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
            <xsl:text>", target: "</xsl:text><xsl:value-of select="$single_item"/><xsl:text>"</xsl:text> 
            <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
            <xsl:if test="$relation_type!=' '"><xsl:text>, subtype: "arrow"</xsl:text></xsl:if>
            <xsl:if test="$cert='low'"><xsl:text>, cert: "low"</xsl:text></xsl:if>
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
    <xsl:for-each select="$all_items/tei:*[not(child::tei:*[1]='XXX')][child::tei:*[1]!=''][child::tei:idno!='']">
      <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>"</xsl:text>
      <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="people_graph_items">
    <xsl:text>{nodes:[</xsl:text>
    <xsl:for-each select="$people/tei:person[not(child::tei:persName='XXX')][child::tei:idno!=''][child::tei:persName!='']">
      <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="tei:idno[1]"/><xsl:text>", name: "</xsl:text>        
      <xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>", type: "people_only"}</xsl:text>
      <xsl:text>}</xsl:text>
      <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>], edges:[</xsl:text>
    <xsl:for-each select="$people/tei:person/tei:link[tokenize(concat(replace(@corresp, '#', ''), ' '), ' ')=$people/tei:person/tei:idno][@type='people'][not(starts-with(@corresp, ' '))][not(ends-with(@corresp, ' '))]">
      <xsl:variable name="id" select="parent::tei:*/tei:idno[1]"/>
      <xsl:variable name="relation_type"><xsl:choose>
        <xsl:when test="@subtype='' or @subtype='link' or @subtype='hasConnectionWith'"><xsl:text> </xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="@subtype"/></xsl:otherwise>
      </xsl:choose></xsl:variable>
      <xsl:variable name="cert" select="@cert"/>
      <xsl:variable name="color">
        <xsl:choose>
          <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='family']">
            <xsl:text>red</xsl:text>
          </xsl:when>
          <xsl:when test="$thesaurus//tei:catDesc[@n=$relation_type][@key='personal']">
            <xsl:text>green</xsl:text>
          </xsl:when>
          <xsl:otherwise><xsl:text>blue</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not(contains(@corresp, ' '))">
          <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', replace(@corresp, '#', ''))"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
          <xsl:text>", target: "</xsl:text><xsl:value-of select="replace(@corresp, '#', '')"/><xsl:text>"</xsl:text> 
          <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
          <xsl:if test="$relation_type!=' '"><xsl:text>, subtype: "arrow"</xsl:text></xsl:if>
          <xsl:if test="$cert='low'"><xsl:text>, cert: "low"</xsl:text></xsl:if>
          <xsl:text>}}</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@corresp, ' ')">
          <xsl:for-each select="tokenize(@corresp, ' ')[replace(., '#', '')=$people/tei:person/tei:idno]">
            <xsl:variable name="single_item" select="replace(., '#', '')"/>
            <xsl:text>{data: {id: "</xsl:text><xsl:value-of select="concat($id, ' + ', $single_item)"/><xsl:text>", name: "</xsl:text><xsl:value-of select="$relation_type"/><xsl:text>", source: "</xsl:text><xsl:value-of select="$id"/>
            <xsl:text>", target: "</xsl:text><xsl:value-of select="$single_item"/><xsl:text>"</xsl:text> 
            <xsl:text>, type: "</xsl:text><xsl:value-of select="$color"/><xsl:text>"</xsl:text>
            <xsl:if test="$relation_type!=' '"><xsl:text>, subtype: "arrow"</xsl:text></xsl:if>
            <xsl:if test="$cert='low'"><xsl:text>, cert: "low"</xsl:text></xsl:if>
            <xsl:text>}}</xsl:text>
            <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>]}</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="people_graph_labels">
    <xsl:text>[</xsl:text>
    <xsl:for-each select="$people/tei:person[not(child::tei:persName='XXX')][child::tei:persName!=''][child::tei:idno!='']">
      <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(translate(tei:*[1], ',', '; '))"/><xsl:text>"</xsl:text>
      <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:variable>
  
  
  <!-- GRAPH -->
  <xsl:template match="//tei:addSpan[@xml:id='relation_graph' or @xml:id='people_graph']">
    <div class="row graph_box" id="mygraph_box">
      <div class="legend">
        <p id="help"><a href="#">[CLOSE]</a> 
          <br/><strong>Ricerca tramite Search</strong>
          <br/>- Digitare il nome nel campo Search, selezionarlo fra i risultati che compaiono nel menu a tendina e cliccare su "Show".
          <br/>- Per effettuare una nuova ricerca che non tenga conto delle ricerche precedenti, occorre prima cliccare su "Reset".
          <br/>- Per visualizzare assieme più elementi, occorre ripetere la procedura senza cliccare su "Reset" fra le ricerche, assicurandosi che l’elemento cercato in precedenza sia rimasto selezionato, cioè bordato di arancione (cosa che avviene in automatico se non si clicca sul grafico; in caso contrario è comunque possibile riselezionarlo cliccandovi sopra).
          
          <br/><br/><strong>Ricerca tramite selezione sul grafico</strong>
          <br/>- Cliccare su uno o più elementi nel grafico (tenendo premuto Shift se gli elementi sono più d’uno) e cliccare su "Show".
          <br/>- È possibile combinare la ricerca tramite Search con quella tramite selezione sul grafico: selezionare prima gli elementi sul grafico (assicurandosi che siano bordati di arancione) ed effettuare poi la ricerca tramite Search, cliccando infine su "Show".
          <br/>- Una volta effettuata una ricerca tramite Search e/o tramite selezione sul grafico, è possibile aggiungere progressivamente alla visualizzazione gli elementi collegati ad uno o più degli elementi visualizzati cliccando con il tasto destro del mouse (o con l’equivalente combinazione su un trackpad) sull’elemento in questione.
          
          <br/><br/><strong>Tips</strong>
          <br/>- Se al primo utilizzo la ricerca non funziona, occorre ricaricare la pagina e riprovare.
          <br/>- Se cliccando su "Show" non zooma subito sugli elementi cercati, occorre cliccare una seconda volta su "Show".
          <br/>- Dopo aver deselezionato uno o più tipi di relazioni (Family relations, Interpersonal bonds...) per nasconderle nel grafico, occorre posizionarsi con il puntatore (o cliccare) su un punto qualsiasi del grafico affinché queste vengano effettivamente nascoste.
          <xsl:if test="@xml:id='relation_graph'"><br/>- Se un gruppo di elementi (People, Juridical persons, Estates, Places) viene selezionato o deselezionato più volte consecutive il sistema si blocca e occorre ricaricare la pagina.</xsl:if>
        </p>
        <p><span class="autocomplete"><input type="text" id="inputSearch" placeholder="Search"/></span><button id="btnSearch" class="button">Show</button> <button id="reset" class="button">Reset</button> <button onclick="openFullscreen();" class="button">Fullscreen</button> <a class="button" href="#help">Help</a></p>
      </div> 
      <div id="mygraph"></div>
      <div class="legend">
        <p>
          <xsl:choose>
            <xsl:when test="@xml:id='relation_graph'">
            <span class="people_label">People</span> <input type="checkbox" id="toggle_people" checked="true"/>
          <span class="jp_label">Juridical persons</span> <input type="checkbox" id="toggle_juridical_persons" checked="true"/>
          <span class="estates_label">Estates</span> <input type="checkbox" id="toggle_estates" checked="true"/>
          <span class="places_label">Places</span> <input type="checkbox" id="toggle_places" checked="true"/>
          <br/>
          </xsl:when>
            <xsl:when test="@xml:id='people_graph'">
              <span id="toggle_people"/><span id="toggle_juridical_persons"/><span id="toggle_estates"/><span id="toggle_places"/>
            </xsl:when>
          </xsl:choose>
          <span class="red_label">➔</span> Family relations <input type="checkbox" id="toggle_red" checked="true"/> 
          <span class="green_label">➔</span> Interpersonal bonds <input type="checkbox" id="toggle_green" checked="true"/>
          <span class="blue_label">➔</span> Other interpersonal links <input type="checkbox" id="toggle_blue" checked="true"/>
          <xsl:choose>
            <xsl:when test="@xml:id='relation_graph'">
              <span class="orange_label">➔</span> Other links <input type="checkbox" id="toggle_orange" checked="true"/>
            </xsl:when>
            <xsl:when test="@xml:id='people_graph'">
              <span id="toggle_orange"/>
            </xsl:when>
          </xsl:choose>
          <span class="alleged_label">⤑</span> Alleged relations <input type="checkbox" id="toggle_alleged" checked="true"/>
          <span class="relations_label"> Relation types </span> <input type="checkbox" id="toggle_labels" checked="true"/>
        </p>
      </div>
      <script type="text/javascript">
        var graph_items = <xsl:choose>
          <xsl:when test="@xml:id='relation_graph'"><xsl:value-of select="$graph_items"/></xsl:when>
          <xsl:when test="@xml:id='people_graph'"><xsl:value-of select="$people_graph_items"/></xsl:when>
        </xsl:choose>, 
        graph_labels = <xsl:choose>
          <xsl:when test="@xml:id='relation_graph'"><xsl:value-of select="$graph_labels"/></xsl:when>
          <xsl:when test="@xml:id='people_graph'"><xsl:value-of select="$people_graph_labels"/></xsl:when>
        </xsl:choose>, 
        my_graph = "mygraph", box = "mygraph_box";
       </script>
      <script type="text/javascript" src="../../assets/scripts/networks.js"></script>
    </div>
  </xsl:template>
  
</xsl:stylesheet>