/*Last update 13 Feb 2021*/
/*var mymap = L.map('mapid').setView([44, 10.335], 6.5); L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaXZhZ2lvbmFraXMiLCJhIjoiY2treTVmZnhyMDBzdTJ2bWxyemY4anJtNSJ9.QrP-0v-7btCzG97ll23HKw', {
          maxZoom: 18,
          attribution: 'Map data <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
          'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
          id: 'mapbox/streets-v11',
          tileSize: 512,
          zoomOffset: -1
          }).addTo(mymap);
          
          L.marker([43.885173623043144, 10.335706471960295]).addTo(mymap).bindPopup("<b>Elici</b>");
          
          L.polygon([
          [45.21625206214063,8.293893188238146],
          [45.22292799339423,8.286163732409479],
          [45.23431881528846,8.29482525587082],
          [45.24012999402467,8.301339000463487],
          [45.2354063021579,8.319860994815828],
          [45.218978453364016,8.306558579206468],
          [45.21625206214063,8.293893188238146]
          ]).addTo(mymap).bindPopup("<b>Predalbora (Farini; Piacenza)</b>");*/
          
          
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