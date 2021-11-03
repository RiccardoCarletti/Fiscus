<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- XSLT to convert index metadata and index Solr results into HTML. This is the common functionality
    for both TEI and EpiDoc indices. It should be imported by the specific XSLT for the document type
    (eg, indices-epidoc.xsl). -->

  <xsl:import href="to-html.xsl" />

  <xsl:template match="index_metadata" mode="title">
    <xsl:value-of select="tei:div/tei:head" />
  </xsl:template>

  <xsl:template match="index_metadata" mode="head">
    <xsl:apply-templates select="tei:div/tei:head/node()" />
  </xsl:template>
  
  <xsl:template name="maps_js">
    <!--<xi:include href="../../assets/scripts/maps.js" parse="text"/>-->
    <script type="text/javascript">
      /* For polygons coordinates */
      function chunkArray(myArray, chunk_size){
      var index = 0;
      var arrayLength = myArray.length;
      var tempArray = [];
      for (index = 0; index &lt; arrayLength; index += chunk_size) {
      myChunk = myArray.slice(index, index+chunk_size);
      tempArray.push(myChunk);
      }
      return tempArray;
      }
      
      /*Maps layers*/
      var dare = L.tileLayer('https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
      minZoom: 4,
      maxZoom: 11,
      attribution: 'Map data &lt;a href="https://imperium.ahlfeldt.se/"&gt;Digital Atlas of the Roman Empire&lt;/a&gt; CC BY 4.0'
      });
      var terrain = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Tiles and source Esri',
      maxZoom: 13
      });
      var watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
      attribution: 'Map tiles &lt;a href="http://stamen.com"&gt;Stamen Design&lt;/a&gt;, &lt;a href="http://creativecommons.org/licenses/by/3.0"&gt;CC BY 3.0&lt;/a&gt;, Map data &lt;a href="https://www.openstreetmap.org/copyright"&gt;OpenStreetMap&lt;/a&gt;',
      subdomains: 'abcd',
      minZoom: 1,
      maxZoom: 16,
      ext: 'jpg'
      });
      var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: 'Map data &lt;a href="https://www.openstreetmap.org/copyright"&gt;OpenStreetMap&lt;/a&gt;'
      }); 
      
      
      var polygons_places = [];
      var lines_places = [];
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
      var uncertain_places = [];
      var select_linked_places = [];
      
      var LeafIcon = L.Icon.extend({ options: {iconSize: [14, 14]} });
      var purpleIcon = new LeafIcon({iconUrl: '../../../assets/images/purple.png'}),
      goldenIcon = new LeafIcon({iconUrl: '../../../assets/images/golden.png'}),
      purpleUncertainIcon = new LeafIcon({iconUrl: '../../../assets/images/purple_uncertain.png'}),
      goldenUncertainIcon = new LeafIcon({iconUrl: '../../../assets/images/golden_uncertain.png'});
      
      for (var [key, value] of Object.entries(points)) {
      var info = key.substring(key.indexOf("@"), key.lastIndexOf("@"));
      symbols = info.replace('@c', '&lt;img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/&gt;').replace('@d', '&lt;img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/&gt;').replace('@e', '&lt;img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/&gt;').replace('@f', '&lt;img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/&gt;').replace('@g', '&lt;img src="../../../assets/images/star.png" alt="star" class="mapicon"/&gt;').replace('@h', '&lt;img src="../../../assets/images/square.png" alt="square" class="mapicon"/&gt;').replace('@i', '&lt;img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/&gt;').replace('@j', '&lt;img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/&gt;').replace('@k', '&lt;img src="../../../assets/images/uncertain.png" alt="uncertain" class="mapicon"/&gt;'); 
      if (key.includes('#a')) {
      purple_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      if (key.includes('c@')) {
      ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('d@')) {
      fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('e@')) {
      residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('f@')) {
      revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('g@')) {
      estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('h@')) {
      tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('i@')) {
      land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('j@')) {
      fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('k@')) {
      uncertain_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: purpleUncertainIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      }
      if (key.includes('#b')) {
      golden_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      if (key.includes('c@')) {
      ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('d@')) {
      fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('e@')) {
      residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('f@')) {
      revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('g@')) {
      estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('h@')) {
      tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('i@')) {
      land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('j@')) {
      fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      if (key.includes('k@')) {
      uncertain_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {time: key.substring(0, key.indexOf("|")), icon: goldenUncertainIcon, id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; ' + symbols + ' &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }
      }
      };
      
      for (var [key, value] of Object.entries(polygons)) {
      var split_values = value.split(';');
      split_values.forEach(function(item, index, array) {
      array[index] = parseFloat(item);
      });
      var coords = chunkArray(split_values, 2);
      polygons_places.push(L.polygon([coords], {time: key.substring(0, key.indexOf("|")), color: 'green', id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }; 
      
      for (var [key, value] of Object.entries(lines)) {
      var split_values = value.split(';');
      split_values.forEach(function(item, index, array) {
      array[index] = parseFloat(item);
      });
      var coords = chunkArray(split_values, 2);
      lines_places.push(L.polyline([coords], {time: key.substring(0, key.indexOf("|")), color: 'blue', id:key.substring(key.lastIndexOf("@") +1)}).bindPopup('&lt;a target="_blank" href="places.html#0"&gt;'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(key.indexOf("|") +1, key.indexOf("#")) + '&lt;/a&gt; &lt;span class="block"&gt;Linked documents: ' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '&lt;/span&gt;'));
      }; 
      
      var toggle_ports_places = L.layerGroup(ports_places);
      var toggle_fortifications_places = L.layerGroup(fortifications_places);
      var toggle_residences_places = L.layerGroup(residences_places);
      var toggle_revenues_places = L.layerGroup(revenues_places);
      var toggle_estates_places = L.layerGroup(estates_places);
      var toggle_tenures_places = L.layerGroup(tenures_places);
      var toggle_land_places = L.layerGroup(land_places);
      var toggle_fallow_places = L.layerGroup(fallow_places);
      var toggle_uncertain_places = L.layerGroup(uncertain_places);
      var toggle_purple_places = L.layerGroup(purple_places); 
      var toggle_golden_places = L.layerGroup(golden_places);
      var toggle_polygons = L.layerGroup(polygons_places);
      var toggle_lines = L.layerGroup(lines_places);
      var toggle_select_linked_places = L.layerGroup(select_linked_places);
      
      var baseMaps = {
      "DARE": dare,
      "Terrain": terrain, 
      "Watercolor": watercolor,
      "Open Street Map": osm
      };
      
      var overlayMaps = {
      "All places linked to fiscal properties": toggle_golden_places,
      "All places not linked to fiscal properties": toggle_purple_places,
      "Places not precisely located or wider areas": toggle_polygons,
      "Rivers": toggle_lines,
      "From uncertain tradition": toggle_uncertain_places,
      "Ports and fords": toggle_ports_places,
      "Fortifications": toggle_fortifications_places,
      "Residences": toggle_residences_places,
      "Markets, crafts and revenues": toggle_revenues_places,
      "Estates and estate units": toggle_estates_places,
      "Tenures": toggle_tenures_places,
      "Land plots and rural buildings": toggle_land_places,
      "Fallow land": toggle_fallow_places
      };
      
      var layers = [osm, terrain, watercolor];
      
      var markers = purple_places.concat(golden_places);
      
      function openPopupById(id){ for(var i = 0; i &lt; markers.length; ++i) { if (markers[i].options.id == id){ markers[i].openPopup(); }; }}
      
      function displayById(id){ for(var i = 0; i &lt; markers.length; ++i) { if (markers[i].options.id == id){
      toggle_select_linked_places.addLayer(markers[i]); 
      }; }}
    </script>
  </xsl:template>
  
  <xsl:template name="networks_js">
    <!--<xi:include href="../../assets/scripts/networks.js" parse="text"/>-->
    <script type="text/javascript">
      const cy_style = [
      { selector: 'edge', style: { 'curve-style': 'bezier', 'width': 3, 'label': 'data(name)', 'opacity': '0.6', 'z-index': '0' } },
      { selector: 'node', style: { 'font-size': '22', 'font-weight': 'bold' , 'label': 'data(name)', 'text-wrap': 'wrap', 'text-max-width': '280', 'text-valign': 'center', 'text-halign': 'center', 'shape': 'round-rectangle', 'padding': '20', 'border-width': 3, 'border-color': 'black', 'border-style': 'solid', 'width': 'label', 'height': 'label' } },
      { selector: 'node[type="people_only"]', style: { 'background-color': '#97c2fc' } },
      { selector: 'node[type="people"]', style: { 'background-color': '#ffff80' } },
      { selector: 'node[type="juridical_persons"]', style: { 'background-color': '#ffb4b4' } },
      { selector: 'node[type="estates"]', style: { 'background-color': '#99ff99' } },
      { selector: 'node[type="places"]', style: { 'background-color': '#c2c2ff' } },
      { selector: 'edge[type="red"]', style: { 'line-color': 'red', 'target-arrow-color': 'red' } },
      { selector: 'edge[type="green"]', style: { 'line-color': 'green', 'target-arrow-color': 'green' } },
      { selector: 'edge[type="blue"]', style: { 'line-color': 'blue', 'target-arrow-color': 'blue' } },
      { selector: 'edge[type="orange"]', style: { 'line-color': 'orange', 'target-arrow-color': 'orange' } },
      { selector: 'edge[subtype="arrow"]', style: { 'target-arrow-shape': 'triangle' } },
      { selector: 'edge[cert="low"]', style: { 'line-style': 'dashed' } },
      
      {selector: 'node.searched', style: {'border-width': 10, 'border-color': 'red'} },
      {selector: '.hidden', style: {'display': 'none'} },
      {selector: '.hidden_label', style: {'label': ''} },
      {selector: 'node:selected', style: {'border-width': 10, 'border-color': 'orange', 'z-index': '99999', 'font-size': '80'} }
      ];
      
      var inputSearch = "inputSearch", inputVal = "#inputSearch", btnSearch = "#btnSearch", reset = "#reset";
      var toggle_people = "toggle_people", toggle_juridical_persons = "toggle_juridical_persons", toggle_estates = "toggle_estates", 
      toggle_places = "toggle_places", toggle_red = "toggle_red", toggle_green = "toggle_green", toggle_blue = "toggle_blue", 
      toggle_orange = "toggle_orange", toggle_labels = "toggle_labels", toggle_alleged = "toggle_alleged";
      
      const cy_layout = { name: 'fcose', animate: false, nodeRepulsion: 100000000, nodeSeparation: 100, randomize: true, idealEdgeLength: 300,  boxSelectionEnabled: true, selectionType: 'additive' };
      
      var cy = cytoscape({ container: document.getElementById(my_graph), elements: graph_items, style: cy_style, layout: cy_layout }).panzoom();      
      
      /*fullscreen*/
      var full = box;
      function openFullscreen() {
      if (document.getElementById(full).requestFullscreen) { document.getElementById(full).requestFullscreen(); } 
      else if (document.getElementById(full).webkitRequestFullscreen) { document.getElementById(full).webkitRequestFullscreen();} 
      else if (document.getElementById(full).msRequestFullscreen) { document.getElementById(full).msRequestFullscreen(); } } 
      
      /*toggle*/
      document.getElementById(toggle_people).addEventListener("click", function() { cy.$('[type="people"]').toggleClass('hidden'); });
      document.getElementById(toggle_juridical_persons).addEventListener("click", function() { cy.$('[type="juridical_persons"]').toggleClass('hidden'); });
      document.getElementById(toggle_estates).addEventListener("click", function() { cy.$('[type="estates"]').toggleClass('hidden'); });
      document.getElementById(toggle_places).addEventListener("click", function() { cy.$('[type="places"]').toggleClass('hidden'); });
      document.getElementById(toggle_red).addEventListener("click", function() { cy.$('[type="red"]').toggleClass('hidden'); });
      document.getElementById(toggle_alleged).addEventListener("click", function() { cy.$('[cert="low"]').toggleClass('hidden'); });
      document.getElementById(toggle_green).addEventListener("click", function() { cy.$('[type="green"]').toggleClass('hidden'); });
      document.getElementById(toggle_blue).addEventListener("click", function() { cy.$('[type="blue"]').toggleClass('hidden'); });
      document.getElementById(toggle_orange).addEventListener("click", function() { cy.$('[type="orange"]').toggleClass('hidden'); });
      document.getElementById(toggle_labels).addEventListener("click", function() { cy.edges().toggleClass('hidden_label'); }); 
      
      /*autocomplete + search + show only selected + reset*/
      autocomplete(document.getElementById(inputSearch), graph_labels);
      
      $(btnSearch).on('click',function () { 
      cy.elements().removeClass('searched').addClass('hidden');
      cy.$('[name =  "' + $(inputVal).val() + '"]').addClass('searched').removeClass('hidden').select(); 
      cy.$('[name =  "' + $(inputVal).val() + '"]').neighborhood().removeClass('hidden'); 
      cy.$(':selected').addClass('searched').removeClass('hidden');
      cy.$(':selected').neighborhood().removeClass('hidden');
      cy.fit(cy.$(':selected').closedNeighborhood(), 10);
      });
      
      cy.nodes().on('cxttap', function(e){
      e.target.addClass('searched').select(); 
      e.target.neighborhood().removeClass('hidden'); 
      cy.fit(cy.$('searched').closedNeighborhood(), 10);
      });
      
      $(reset).on('click',function () { 
      cy.elements().removeClass('searched').removeClass('hidden').unselect(); 
      cy.fit(cy.elements, 10);
      return $('#inputSearch').val('');
      });
    </script>
  </xsl:template>

  <xsl:template match="response/result">
    <!-- scrolling down button -->
    <button type="button" onclick="topFunction()" id="scroll" title="Go to top">⬆  </button>
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

    <!-- GRAPH -->
    <xsl:if test="doc/str[@name='index_people_graph_labels'] or doc/str[@name='index_graph_labels']">
      <div><p>Please note that the graph may take some time to load.</p></div>
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
            <xsl:if test="doc/str[@name='index_graph_labels']"><br/>- Se un gruppo di elementi (People, Juridical persons, Estates, Places) viene selezionato o deselezionato più volte consecutive il sistema si blocca e occorre ricaricare la pagina.</xsl:if>
          </p>
          <p><span class="autocomplete"><input type="text" id="inputSearch" placeholder="Search"/></span><button id="btnSearch" class="button">Show</button> <button id="reset" class="button">Reset</button> <button onclick="openFullscreen();" class="button">Fullscreen</button> <a class="button" href="#help">Help</a></p>
        </div>
        <div id="mygraph"></div>
        <div class="legend">
          <p>
            <xsl:choose>
              <xsl:when test="doc/str[@name='index_graph_labels']">
                <span class="people_label">People</span> <input type="checkbox" id="toggle_people" checked="true"/>
                <span class="jp_label">Juridical persons</span> <input type="checkbox" id="toggle_juridical_persons" checked="true"/>
                <span class="estates_label">Estates</span> <input type="checkbox" id="toggle_estates" checked="true"/>
                <span class="places_label">Places</span> <input type="checkbox" id="toggle_places" checked="true"/>
                <br/>
              </xsl:when>
              <xsl:when test="doc/str[@name='index_people_graph_labels']">
                <span id="toggle_people"/><span id="toggle_juridical_persons"/><span id="toggle_estates"/><span id="toggle_places"/>
              </xsl:when>
            </xsl:choose>
            <span class="red_label">➔</span> Family relations <input type="checkbox" id="toggle_red" checked="true"/>
            <span class="green_label">➔</span> Interpersonal bonds <input type="checkbox" id="toggle_green" checked="true"/>
            <span class="blue_label">➔</span> Other interpersonal links <input type="checkbox" id="toggle_blue" checked="true"/>
            <xsl:choose>
              <xsl:when test="doc/str[@name='index_graph_labels']">
                <span class="orange_label">➔</span> Other links <input type="checkbox" id="toggle_orange" checked="true"/>
              </xsl:when>
              <xsl:when test="doc/str[@name='index_people_graph_labels']">
                <span id="toggle_orange"/>
              </xsl:when>
            </xsl:choose>
            <span class="alleged_label">⤑</span> Alleged relations <input type="checkbox" id="toggle_alleged" checked="true"/>
            <span class="relations_label"> Relation types </span> <input type="checkbox" id="toggle_labels" checked="true"/>
          </p>
        </div>
        <script type="text/javascript">
          var graph_items = <xsl:choose>
            <xsl:when test="doc/str[@name='index_graph_labels']"><xsl:value-of select="doc/str[@name='index_graph_items']"/></xsl:when>
            <xsl:when test="doc/str[@name='index_people_graph_labels']"><xsl:value-of select="doc/str[@name='index_people_graph_items']"/></xsl:when>
          </xsl:choose>,
          graph_labels = <xsl:choose>
            <xsl:when test="doc/str[@name='index_graph_labels']"><xsl:value-of select="doc/str[@name='index_graph_labels']"/></xsl:when>
            <xsl:when test="doc/str[@name='index_people_graph_labels']"><xsl:value-of select="doc/str[@name='index_people_graph_labels']"/></xsl:when>
          </xsl:choose>,
          my_graph = "mygraph", box = "mygraph_box";
        </script>
        <xsl:call-template name="networks_js"/> <!-- it should be included directly from ../../assets/scripts/networks.js -->
      </div>
  </xsl:if>

    <!-- MAP -->
    <xsl:if test="doc/str[@name='index_map_labels']">
          <div class="row map_box">
            <!--<div><p>Please note that the map may take some time to load.</p></div>-->
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
            var polygons = <xsl:value-of select="doc/str[@name='index_map_polygons']"/>;
            var lines = <xsl:value-of select="doc/str[@name='index_map_lines']"/>;
            var points = <xsl:value-of select="doc/str[@name='index_map_points']"/>;
            var map_labels = <xsl:value-of select="doc/str[@name='index_map_labels']"/>;
          </script>
            <xsl:call-template name="maps_js"/> <!-- it should be included directly from ../../assets/scripts/maps.js -->
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
        </xsl:if>

    <!-- items counter -->
    <xsl:if test="doc/str[@name='index_total_items']">
    <div>
      <p>Total items: <xsl:value-of select="doc/str[@name='index_total_items']" /></p>
    <button type="button" class="expander" onclick="$('.expanded').toggle();">Show/Hide all linked items</button>
    </div>
    </xsl:if>


    <!-- LISTS -->
    <div>
        <xsl:apply-templates select="doc[str[@name='index_item_name'][not(starts-with(., '~'))][not(starts-with(., '#'))]]">
          <xsl:sort select="lower-case(.)"/>
        </xsl:apply-templates>
    </div>

    <xsl:if test="doc[str[@name='index_item_name'][starts-with(., '#')]]">
      <h3 class="sublist_heading">Personal names normalized forms</h3>
      <div>
          <xsl:apply-templates select="doc[str[@name='index_item_name'][starts-with(., '#')]]">
            <xsl:sort select="lower-case(.)"/>
          </xsl:apply-templates>
        </div>
    </xsl:if>

    <xsl:if test="doc[str[@name='index_item_name'][starts-with(., '~')]]">
      <h3 class="sublist_heading">Items that have not been normalized</h3>
      <div>
          <xsl:apply-templates select="doc[str[@name='index_item_name'][starts-with(., '~')]]">
            <xsl:sort select="lower-case(.)"/>
          </xsl:apply-templates>
      </div>
    </xsl:if>
  </xsl:template>


  <!-- ITEMS IN LISTS -->
  <!-- items in lists structure -->
  <xsl:template match="result/doc">
    <div id="{substring-after(str[@name='index_item_number'], '/')}" class="index_item">
      <div>
      <xsl:apply-templates select="str[@name='index_item_name']" />
      <xsl:apply-templates select="str[@name='index_other_names']" />
      <xsl:apply-templates select="str[@name='index_item_number']" />
      <xsl:apply-templates select="str[@name='index_coordinates']" />
      <xsl:apply-templates select="str[@name='index_notes']" />
      <xsl:apply-templates select="str[@name='index_external_resource']" />
      <xsl:apply-templates select="str[@name='index_linked_keywords']" />
      </div>
      <xsl:apply-templates select="str[@name='index_linked_estates']" />
      <xsl:apply-templates select="str[@name='index_linked_juridical_persons']" />
      <xsl:apply-templates select="str[@name='index_linked_people']" />
      <xsl:apply-templates select="str[@name='index_linked_places']" />
      <xsl:apply-templates select="arr[@name='index_instance_location']" />
    </div>
  </xsl:template>

  <!-- item name -->
  <xsl:template match="str[@name='index_item_name']">
    <h3 class="index_item_name">
      <xsl:analyze-string select="replace(replace(normalize-space(.), '~ ', ''), '# ', '')" regex="italicsstart(.*?)italicsend">
        <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
      <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
    </xsl:analyze-string>
    </h3>
  </xsl:template>

  <!-- item other names -->
  <xsl:template match="str[@name='index_other_names']">
    <p><strong>Also known as: </strong>
      <xsl:analyze-string select="normalize-space(.)" regex="italicsstart(.*?)italicsend">
        <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
      </xsl:analyze-string>
    </p>
  </xsl:template>

  <!-- item number -->
  <xsl:template match="str[@name='index_item_number']">
    <p><strong>Item number: </strong><xsl:value-of select="."/></p>
  </xsl:template>

  <!-- item coordinates -->
  <xsl:template match="str[@name='index_coordinates']">
    <p><strong>Coordinates (Lat, Long): </strong>
      <a target="_blank" href="{concat('map.html#',substring-after(parent::doc/str[@name='index_item_number'], 'places/'))}" class="open_map"><xsl:text>See on map</xsl:text></a>
      <xsl:text> </xsl:text><xsl:value-of select="."/></p>
  </xsl:template>

  <!-- item notes, handling also included URIs -->
  <xsl:template match="str[@name='index_notes']">
    <p><strong>Commentary/Bibliography: </strong>
      <xsl:analyze-string select="normalize-space(.)" regex="italicsstart(.*?)italicsend">
        <xsl:matching-substring><i>
          <xsl:analyze-string select="regex-group(1)" regex="(http:|https:)(\S+?)(\.|\)|\]|;|,|\?|!|:)?(\s|$)">
            <xsl:matching-substring>
              <a target="_blank" href="{concat(regex-group(1),regex-group(2))}"><xsl:value-of select="concat(regex-group(1),regex-group(2))"/></a>
              <xsl:value-of select="concat(regex-group(3),regex-group(4))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
          </xsl:analyze-string>
        </i></xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:analyze-string select="." regex="(http:|https:)(\S+?)(\.|\)|\]|;|,|\?|!|:)?(\s|$)">
            <xsl:matching-substring>
              <a target="_blank" href="{concat(regex-group(1),regex-group(2))}"><xsl:value-of select="concat(regex-group(1),regex-group(2))"/></a>
              <xsl:value-of select="concat(regex-group(3),regex-group(4))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </p>
  </xsl:template>

  <!-- item links to external resources -->
  <xsl:template match="str[@name='index_external_resource']">
    <p><strong>Item number: </strong><a target="_blank" href="{.}"><xsl:value-of select="substring-after(., 'concept/')"/></a></p>
  </xsl:template>

  <!-- item linked keywords -->
  <xsl:template match="str[@name='index_linked_keywords']">
    <p><strong>Linked keywords: </strong><xsl:value-of select="."/></p>
  </xsl:template>

  <!-- item list of linked estates -->
  <xsl:template match="str[@name='index_linked_estates']">
    <xsl:variable name="item" select="tokenize(., '£')"/>
    <div class="linked_elements">
    <h4 class="inline"><xsl:text>Linked estates:</xsl:text></h4>
    <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
      <xsl:for-each select="$item">
        <li>
          <a target="_blank" href="{concat('estates.html#', substring-before(., '#'))}">
            <xsl:analyze-string select="substring-before(substring-after(normalize-space(.), '#'), '@')" regex="italicsstart(.*?)italicsend">
              <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
              <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
          <span class="link_type"><xsl:value-of select="substring-after(., '@')"/></span>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    </div>
  </xsl:template>

  <!-- item list of linked juridical persons -->
  <xsl:template match="str[@name='index_linked_juridical_persons']">
    <xsl:variable name="item" select="tokenize(., '£')"/>
    <div class="linked_elements">
      <h4 class="inline"><xsl:text>Linked juridical persons:</xsl:text></h4>
    <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
      <xsl:for-each select="$item">
        <li>
          <a target="_blank" href="{concat('juridical_persons.html#', substring-before(., '#'))}">
            <xsl:analyze-string select="substring-before(substring-after(normalize-space(.), '#'), '@')" regex="italicsstart(.*?)italicsend">
              <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
              <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
            <span class="link_type"><xsl:value-of select="substring-after(., '@')"/></span>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    </div>
  </xsl:template>

  <!-- item list of linked people -->
  <xsl:template match="str[@name='index_linked_people']">
    <xsl:variable name="item" select="tokenize(., '£')"/>
    <div class="linked_elements">
      <h4 class="inline"><xsl:text>Linked people:</xsl:text></h4>
    <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
      <xsl:for-each select="$item">
        <li>
          <a target="_blank" href="{concat('people.html#', substring-before(., '#'))}">
            <xsl:analyze-string select="substring-before(substring-after(normalize-space(.), '#'), '@')" regex="italicsstart(.*?)italicsend">
              <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
              <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
            <span class="link_type"><xsl:value-of select="substring-after(., '@')"/></span>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    </div>
  </xsl:template>

  <!-- item list of linked places -->
  <xsl:template match="str[@name='index_linked_places']">
    <xsl:variable name="item" select="tokenize(substring-after(., '~'), '£')"/>
    <div class="linked_elements">
      <h4 class="inline"><xsl:text>Linked places: </xsl:text></h4>
      <a target="_blank" href="{concat('map.html#', substring-before(substring-after(., 'map.html#'), '~'))}" class="open_map">See on map</a>
      <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
      <xsl:for-each select="$item">
        <li>
          <a target="_blank" href="{concat('places.html#', substring-before(., '#'))}">
            <xsl:analyze-string select="substring-before(substring-after(normalize-space(.), '#'), '@')" regex="italicsstart(.*?)italicsend">
              <xsl:matching-substring><i><xsl:value-of select="regex-group(1)"/></i></xsl:matching-substring>
              <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
            <span class="link_type"><xsl:value-of select="substring-after(., '@')"/></span>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    </div>
  </xsl:template>

  <!-- item list of linked documents -->
  <xsl:template match="arr[@name='index_instance_location']">
    <div class="linked_elements">
      <h4 class="inline"><xsl:text>Linked documents by date (</xsl:text><xsl:value-of select="count(str)"/><xsl:text>):</xsl:text></h4>
    <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
        <xsl:apply-templates select="str">
          <xsl:sort><xsl:value-of select="substring-before(substring-after(substring-after(., '#doc'), '#'), '#')"/></xsl:sort>
        </xsl:apply-templates>
    </ul>
    </div>
  </xsl:template>
  <!-- item single linked documents; template called from indices-epidoc.xsl -->
  <xsl:template match="arr[@name='index_instance_location']/str">
    <xsl:call-template name="render-instance-location" />
  </xsl:template>

</xsl:stylesheet>
