<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

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
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><p class="item_name"><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)]"/></p></xsl:if>
      <p><xsl:if test="tei:placeName[@type='other']//text()"><strong><xsl:text>Also known as: </xsl:text></strong><xsl:apply-templates select="tei:placeName[@type='other']"/><br/></xsl:if>
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
      <xsl:if test="tei:orgName"><p class="item_name"><xsl:apply-templates select="tei:orgName"/></p></xsl:if>
      <p><xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
      <xsl:if test="tei:note//text()"><strong><xsl:text>Commentary/Bibliography: </xsl:text></strong><xsl:apply-templates select="tei:note"/><br/></xsl:if>
        <xsl:if test="tei:link[@corresp]"><xsl:for-each select="tei:link[@corresp]"><strong><xsl:text>Linked to (</xsl:text><xsl:value-of select="@type"/><xsl:if test="@subtype"><xsl:text>; </xsl:text><xsl:value-of select="@subtype"/></xsl:if><xsl:text>): </xsl:text></strong> <xsl:apply-templates select="@corresp"/><br/></xsl:for-each></xsl:if>
        <xsl:if test="tei:idno"><strong><a><xsl:attribute name="href"><xsl:value-of select="concat('../indices/epidoc/juridical_persons.html#', substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/'))"/></xsl:attribute><xsl:text>See linked documents</xsl:text></a></strong><br/></xsl:if>
      </p>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listPerson/tei:person">
    <div class="list_item"><xsl:attribute name="id"><xsl:value-of select="substring-after(substring-after(translate(tei:idno, '#', ''), 'http://137.204.128.125/'), '/')"/></xsl:attribute>
      <xsl:if test="tei:persName"><p class="item_name"><xsl:apply-templates select="tei:persName"/></p></xsl:if>
      <p><xsl:if test="tei:idno"><strong><xsl:text>Item number: </xsl:text></strong><xsl:value-of select="translate(tei:idno, '#', '')"/><br/></xsl:if>
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
  
  <xsl:template match="//tei:addSpan[@xml:id='map']">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/places.xml'))//tei:listPlace"/>
    <xsl:variable name="map_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_text/tei:place[descendant::tei:geo/text()]">
        <xsl:text>"</xsl:text><xsl:value-of select="translate(tei:placeName[1], ',', '; ')"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(tei:geogName/tei:geo, ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="tei:geogName/tei:geo"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    <xsl:variable name="map_polygons">
      <xsl:text>{</xsl:text>
      <xsl:for-each select="$imported_text/tei:place[contains(descendant::tei:geo, ';')][descendant::tei:geo/text()]">
        <xsl:text>"</xsl:text><xsl:value-of select="translate(tei:placeName[1], ',', '; ')"/><xsl:text>": "[</xsl:text><xsl:value-of select="replace(translate(tei:geogName/tei:geo, ',', ''), '; ', '], [')"/><xsl:text>]"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:variable>
    
    <div class="row">
      <div id="mapid" class="map"></div>
      <script>
        var mymap = L.map('mapid').setView([44, 10.335], 6.5); L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
        maxZoom: 18,
        attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
        'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
        id: 'mapbox/streets-v11',
        tileSize: 512,
        zoomOffset: -1
        }).addTo(mymap);
       
        const points = <xsl:value-of select="$map_points"/>;
        const polygons = <xsl:value-of select="$map_polygons"/>;
        for (const [key, value] of Object.entries(points)) {
        L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)]).addTo(mymap).bindPopup(key);
        }
        <!--for (const [key, value] of Object.entries(polygons)) {
        L.polygon([value.replaceAll(" ", ", ").replaceAll(",,", ",")]).addTo(mymap).bindPopup(key);
        }--> <!-- tranform string value into array -->
        
        L.polygon([
        [45.21625206214063,8.293893188238146],
        [45.22292799339423,8.286163732409479],
        [45.23431881528846,8.29482525587082],
        [45.24012999402467,8.301339000463487],
        [45.2354063021579,8.319860994815828],
        [45.218978453364016,8.306558579206468],
        [45.21625206214063,8.293893188238146]
        ]).addTo(mymap).bindPopup("<b>Predalbora (Farini; Piacenza)</b>");
        
        <!-- L.marker([43, 11]).addTo(mymap).bindPopup("Nome luogo"); -->
        
        <!--L.circle([43.885, 10.335], {
          color: 'red',
          fillColor: '#f03',
          fillOpacity: 0.5,
          radius: 500
          }).addTo(mymap);-->
      </script>
    </div>
  </xsl:template>

</xsl:stylesheet>
