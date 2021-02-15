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
    <xsl:apply-templates><xsl:sort select="tei:place/tei:placeName[1]" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPlace[@type='estates']">
    <xsl:apply-templates><xsl:sort select="tei:place/tei:geogName" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listOrg">
    <xsl:apply-templates><xsl:sort select="tei:org/tei:orgName" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="//tei:listPerson">
    <xsl:apply-templates><xsl:sort select="tei:person/tei:persName" order="ascending"></xsl:sort></xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="//tei:listPlace/tei:place">
    <div class="list_item">
      <xsl:if test="tei:placeName"><p><strong><xsl:apply-templates select="tei:placeName[1]"/></strong></p></xsl:if>
      <xsl:if test="tei:geogName[not(descendant::tei:geo)]"><p><strong><xsl:apply-templates select="tei:geogName[not(descendant::tei:geo)]"/></strong></p></xsl:if>
      <xsl:if test="tei:placeName[@type='other']//text()"><p><i><xsl:text>Also known as: </xsl:text></i><xsl:apply-templates select="tei:placeName[@type='other']"/></p></xsl:if>
      <xsl:if test="tei:geogName/tei:geo"><p><i><xsl:text>Coordinates (Lat, Long): </xsl:text></i><xsl:value-of select="tei:geogName/tei:geo"/></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="//tei:listOrg/tei:org">
    <div class="list_item">
      <xsl:if test="tei:orgName"><p><strong><xsl:apply-templates select="tei:orgName"/></strong></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:listPerson/tei:person">
    <div class="list_item">
      <xsl:if test="tei:persName"><p><strong><xsl:apply-templates select="tei:persName"/></strong></p></xsl:if>
      <xsl:if test="tei:idno"><p><i><xsl:text>Item number: </xsl:text></i><xsl:apply-templates select="tei:idno"/></p></xsl:if>
      <xsl:if test="tei:note//text()"><p><i><xsl:text>Commentary/Bibliography: </xsl:text></i><xsl:apply-templates select="tei:note"/></p></xsl:if>
      <xsl:if test="tei:link"><xsl:for-each select="tei:link"><p><i><xsl:text>Linked item (</xsl:text><xsl:value-of select="@type"/><xsl:text>): </xsl:text></i> <xsl:value-of select="@corresp"/> <xsl:if test="@subtype"><xsl:text> (</xsl:text><xsl:value-of select="@subtype"/><xsl:text>)</xsl:text></xsl:if></p></xsl:for-each></xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="//tei:taxonomy//tei:catDesc">
    <div class="list_item">
      <p><xsl:value-of select="."/></p>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:addSpan[@xml:id='map']">
    <xsl:variable name="imported_text" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/fiscus_framework/resources/places.xml'))//tei:listPlace"/>
    <xsl:variable name="map_points">
      <xsl:text>{</xsl:text><xsl:for-each select="$imported_text/tei:place">
        <xsl:text>"</xsl:text><xsl:value-of select="translate(tei:placeName[1], ',', '; ')"/><xsl:text>": "</xsl:text><xsl:choose>
          <xsl:when test="contains(tei:geogName/tei:geo, ';')"><xsl:value-of select="substring-before(tei:geogName/tei:geo, ';')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="tei:geogName/tei:geo"/></xsl:otherwise>
        </xsl:choose><xsl:text>"</xsl:text><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><xsl:text>}</xsl:text>
    </xsl:variable>
    <xsl:variable name="map_polygons">
      <xsl:text>{</xsl:text>
      <xsl:for-each select="$imported_text/tei:place[contains(descendant::tei:geo, ';')]">
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
