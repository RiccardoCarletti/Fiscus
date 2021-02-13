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
        
        L.marker([43.885173623043144, 10.335706471960295]).addTo(mymap).bindPopup("<b>Elici</b>");
        L.marker([43.77357293200428, 11.253433227539064]).addTo(mymap).bindPopup("<b>Firenze</b>");
        L.marker([45.222008, 8.506020]).addTo(mymap).bindPopup("<b>Caresana</b>");
        L.marker([43.84368925703925, 10.50121307373047]).addTo(mymap).bindPopup("<b>Lucca</b>");
        L.marker([44.979350105922016, 8.80963459621853]).addTo(mymap).bindPopup("<b>Sale (AL)</b>");
        L.marker([44.653024159812, 9.60308074951172]).addTo(mymap).bindPopup("<b>Montereggio</b>");         
        L.marker([44.49433763356321, 11.346564442028466]).addTo(mymap).bindPopup("<b>Bologna</b>");                                    
        L.marker([45.070514475196006, 7.686738520969813]).addTo(mymap).bindPopup("<b>Torino</b>");                                    
        L.marker([45.53956, 10.22676]).addTo(mymap).bindPopup("<b>Brescia</b>");                                    
        L.marker([45.67856, 9.6499]).addTo(mymap).bindPopup("<b>Bergamo</b>");                                    
        L.marker([45.848337832045104, 12.815530702537218]).addTo(mymap).bindPopup("<b>Santa Maria di Sesto</b>");                                    
        L.marker([46.09394806275944, 13.431441663124135]).addTo(mymap).bindPopup("<b>Cividale</b>");                                    
        L.marker([45.66673498781084, 12.241601497044032]).addTo(mymap).bindPopup("<b>Treviso</b>");                                    
        L.marker([45.071910, 9.630140]).addTo(mymap).bindPopup("<b>Cotrebbia</b>");                                    
        L.marker([44.677747331712865, 11.043420284986498]).addTo(mymap).bindPopup("<b>Nonantola [Nonantula]</b>");                                    
        L.marker([45.060146181134385, 9.437843263149263]).addTo(mymap).bindPopup("<b>Olubra (Castel San Giovanni)</b>");                                    
        L.marker([44.831543726908244, 8.644868200644853]).addTo(mymap).bindPopup("<b>Orba</b>"); 
        L.marker([44.893879440219706, 8.666680678725244]).addTo(mymap).bindPopup("<b>Marengo</b>");      
        L.marker([45.69372, 12.71281]).addTo(mymap).bindPopup("<b>Biverone (San Stino di Livenza)</b>");                                    
        L.marker([45.22217726183735, 8.292337507009508]).addTo(mymap).bindPopup("<b>Auriola</b>");                                    
        L.marker([43.83489826128234, 10.41731986217201]).addTo(mymap).bindPopup("<b>Nozzano (Lucca)</b>");                                    
        L.marker([43.839336483090854, 10.446958271786572]).addTo(mymap).bindPopup("<b>Flexo (Montuolo)</b>");  
        L.marker([0, 0]).addTo(mymap).bindPopup("<b>Subto Ripa</b>");                                    
        L.marker([43.86639591266458, 10.344561338424684]).addTo(mymap).bindPopup("<b>Massarosa</b>");
        L.marker([44.47600751575516, 11.275609731674194]).addTo(mymap).bindPopup("<b>Casalecchio di Reno</b>");                                    
        L.marker([45.64322, 9.99241]).addTo(mymap).bindPopup("<b>Timoline; frazione di Corte Franca (BS) [Temulina]</b>");    
        L.marker([45.64322, 9.99241]).addTo(mymap).bindPopup("<b>Timoline</b>");                                    
        L.marker([45.599, 9.97193]).addTo(mymap).bindPopup("<b>Canelle Secco; Erbusco (BS) [Canellas]</b>");                                               
        L.marker([44.84143, 9.98257]).addTo(mymap).bindPopup("<b>Pieve di San Nicomede [Fontanabroculi; loco et fundo]</b>");
        L.marker([45.001480, 9.617170]).addTo(mymap).bindPopup("<b>Gossolengo</b>");    
        L.marker([0, 0]).addTo(mymap).bindPopup("<b>Griliano</b>");                                    
        L.marker([44.958611, 10.691410]).addTo(mymap).bindPopup("<b>Luzzara</b>");                                    
        L.marker([44.916199, 10.653110]).addTo(mymap).bindPopup("<b>Guastalla</b>");      
        L.marker([44.993778, 10.860800]).addTo(mymap).bindPopup("<b>Pegognaga</b>");               
        L.marker([43.901912348717254, 10.537523478269577]).addTo(mymap).bindPopup("<b>Saltocchio</b>");                                    
        L.marker([43.901742279092616, 10.538293942809105]).addTo(mymap).bindPopup("<b>Vinea Regis</b>");                                    
        L.marker([44.646673791982664, 10.919609097763898]).addTo(mymap).bindPopup("<b>Modena</b>");                                    
        L.marker([45.308989873094525, 12.073837271891536]).addTo(mymap).bindPopup("<b>Sacco (Piove di Sacco)</b>");                                    
        L.marker([44.64722337052603, 10.843892097473146]).addTo(mymap).bindPopup("<b>Cittanova [Cive Nova]</b>");                                    
        L.marker([45.407817096623695, 11.885859690573854]).addTo(mymap).bindPopup("<b>Padova</b>");       
        L.marker([45.76828142666548, 12.280131205916407]).addTo(mymap).bindPopup("<b>Lovadina (Spresiano; Treviso)</b>");    
        L.marker([45.05240425535817, 9.693280756473543]).addTo(mymap).bindPopup("<b>Piacenza</b>");                    
        L.marker([44.66718785944645, 9.533557891845705]).addTo(mymap).bindPopup("<b>Centenaro (Ferriere; Piacenza) </b>");      
        L.marker([44.66831404365939, 9.665308836847544]).addTo(mymap).bindPopup("<b>Boccolo dei Tassi (Bardi; Parma)</b>");     
        L.marker([45.95758532919401, 12.659462414649171]).addTo(mymap).bindPopup("<b>Pordenone [Naones]</b>");     
        L.marker([44.697088964344644, 9.598995619453492]).addTo(mymap).bindPopup("<b>Groppallo (Farini; Piacenza)</b>");         
        L.marker([45.2998119223148, 7.78668926563114]).addTo(mymap).bindPopup("<b>Cortereggio</b>");  
        L.marker([45.27361048143624, 7.820867355912925]).addTo(mymap).bindPopup("<b>Foglizzo Fulgitio</b>");       
        L.marker([45.563042358229524, 8.057964323088527]).addTo(mymap).bindPopup("<b>Biella [Bugella]</b>");     
        L.marker([45.65244828675087, 8.270537853240969]).addTo(mymap).bindPopup("<b>Sostegno [Sestinium]</b>");   
        L.marker([41.902782, 12.496366]).addTo(mymap).bindPopup("<b>Roma</b>");                                    
        L.marker([44.80205764295119, 10.322227464057507]).addTo(mymap).bindPopup("<b>Parma (prova)</b>");  
        L.marker([46.116498450522876, 8.293138760964213]).addTo(mymap).bindPopup("<b>Domodossola [Oxila]</b>");  
        L.marker([46.07957, 8.29973]).addTo(mymap).bindPopup("<b>Beura</b>");                                 
        L.marker([45.75679717465874, 8.487411159912883]).addTo(mymap).bindPopup("<b>Invorio</b>");    
        L.marker([44.974590, 9.831090]).addTo(mymap).bindPopup("<b>Cadeo (Piacenza) [Casa Dei]</b>");                                 
        L.marker([45.133247, 10.022651]).addTo(mymap).bindPopup("<b>Cremona</b>");
        
        <!--L.circle([43.885, 10.335], {
          color: 'red',
          fillColor: '#f03',
          fillOpacity: 0.5,
          radius: 500
          }).addTo(mymap);-->
        
        L.polygon([
        [45.21625206214063,8.293893188238146],
        [45.22292799339423,8.286163732409479],
        [45.23431881528846,8.29482525587082],
        [45.24012999402467,8.301339000463487],
        [45.2354063021579,8.319860994815828],
        [45.218978453364016,8.306558579206468],
        [45.21625206214063,8.293893188238146]
        ]).addTo(mymap).bindPopup("<b>Predalbora (Farini; Piacenza)</b>");
      </script>
    </div>
  </xsl:template>

</xsl:stylesheet>
