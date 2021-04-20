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