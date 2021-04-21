/* For polygons coordinates */
        function chunkArray(myArray, chunk_size){
        var index = 0;
        var arrayLength = myArray.length;
        var tempArray = [];
        for (index = 0; index < arrayLength; index += chunk_size) {
        myChunk = myArray.slice(index, index+chunk_size);
        tempArray.push(myChunk);
        }
        return tempArray;
        }

/*Maps layers*/
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
            
            var LeafIcon = L.Icon.extend({ options: {iconSize: [14, 14]} });
        var purpleIcon = new LeafIcon({iconUrl: '../../../assets/images/purple.png'}),
        goldenIcon = new LeafIcon({iconUrl: '../../../assets/images/golden.png'});
        
            for (var [key, value] of Object.entries(points)) {
            var info = key.substring(key.indexOf("@"), key.lastIndexOf("@"));
            symbols = info.replace('@c', '<img src="../../../assets/images/anchor.png" alt="anchor" class="mapicon"/>').replace('@d', '<img src="../../../assets/images/tower.png" alt="tower" class="mapicon"/>').replace('@e', '<img src="../../../assets/images/sella.png" alt="sella" class="mapicon"/>').replace('@f', '<img src="../../../assets/images/coin.png" alt="coin" class="mapicon"/>').replace('@g', '<img src="../../../assets/images/star.png" alt="star" class="mapicon"/>').replace('@h', '<img src="../../../assets/images/square.png" alt="square" class="mapicon"/>').replace('@i', '<img src="../../../assets/images/triangle.png" alt="triangle" class="mapicon"/>').replace('@j', '<img src="../../../assets/images/tree.png" alt="tree" class="mapicon"/>'); 
            if (key.includes('#a')) {
            purple_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            if (key.includes('c@')) {
            ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('d@')) {
            fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('e@')) {
            residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('f@')) {
            revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('g@')) {
            estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('h@')) {
            tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('i@')) {
            land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('j@')) {
            fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: purpleIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            }
            if (key.includes('#b')) {
            golden_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            if (key.includes('c@')) {
            ports_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('d@')) {
            fortifications_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('e@')) {
            residences_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('f@')) {
            revenues_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('g@')) {
            estates_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('h@')) {
            tenures_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('i@')) {
            land_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            if (key.includes('j@')) {
            fallow_places.push(L.marker([value.substring(0, value.lastIndexOf(",")), value.substring(value.lastIndexOf(",") +1)], {icon: goldenIcon}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + key.substring(0, key.indexOf("#")) + '</a> ' + symbols + ' <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("@") +1)) + '➚</a></span>'));
            }
            }
            };
            
            for (var [key, value] of Object.entries(polygons)) {
            var split_values = value.split(';');
            split_values.forEach(function(item, index, array) {
            array[index] = parseFloat(item);
            });
            
            var coords = chunkArray(split_values, 2);
            polygons_places.push(L.polygon([coords], {color: 'green'}).bindPopup('<a href="places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + key.substring(0, key.indexOf("#")) + '</a> <span class="block">See linked documents (' + key.substring(key.indexOf("#") +1, key.lastIndexOf("#")) + '): <a href="../indices/epidoc/places.html#0">'.replace("0", key.substring(key.lastIndexOf("#") +1)) + '➚</a></span>'));
            }; 
            
        var toggle_ports_places = L.layerGroup(ports_places);
        var toggle_fortifications_places = L.layerGroup(fortifications_places);
        var toggle_residences_places = L.layerGroup(residences_places);
        var toggle_revenues_places = L.layerGroup(revenues_places);
        var toggle_estates_places = L.layerGroup(estates_places);
        var toggle_tenures_places = L.layerGroup(tenures_places);
        var toggle_land_places = L.layerGroup(land_places);
        var toggle_fallow_places = L.layerGroup(fallow_places);
        var toggle_purple_places = L.layerGroup(purple_places); 
        var toggle_golden_places = L.layerGroup(golden_places);
        var toggle_polygons = L.layerGroup(polygons_places);
        
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
        
        var layers = [osm, streets, grayscale, satellite, terrain, watercolor];