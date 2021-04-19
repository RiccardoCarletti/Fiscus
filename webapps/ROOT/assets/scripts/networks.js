/* ***** vis.js ***** */

function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
              b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
      x[i].parentNode.removeChild(x[i]);
    }
  }
}
/*execute a function when someone clicks in the document:*/
document.addEventListener("click", function (e) {
    closeAllLists(e.target);
});
} 





/* ***** cytoscape.js ***** */
        const cy_style = [
        { selector: 'node', style: { 'label': 'data(name)', 'shape': 'round-rectangle', 'height': 'label', 'width': 'label', 'padding': '20px', 'text-halign': 'center', 'text-valign': 'center', 'text-wrap': 'wrap', 'text-max-width': '280px', 'font-size': '22px', 'border-width': 3, 'border-color': 'black', 'border-style': 'solid' } },
        { selector: 'edge', style: { 'width': 3, 'label': 'data(name)', 'target-arrow-shape': 'triangle', 'curve-style': 'bezier' } },
        { selector: 'node[type="people_only"]', style: { 'background-color': '#97c2fc' } },
        { selector: 'node[type="people"]', style: { 'background-color': '#ffff80' } },
        { selector: 'node[type="juridical_persons"]', style: { 'background-color': '#ffb4b4' } },
        { selector: 'node[type="estates"]', style: { 'background-color': '#99ff99' } },
        { selector: 'node[type="places"]', style: { 'background-color': '#c2c2ff' } },
        { selector: 'edge[type="red"]', style: { 'line-color': 'red', 'target-arrow-color': 'red' } },
        { selector: 'edge[type="green"]', style: { 'line-color': 'green', 'target-arrow-color': 'green' } },
        { selector: 'edge[type="blue"]', style: { 'line-color': 'blue', 'target-arrow-color': 'blue' } },
         /*    toggle    */
        { selector: 'node[type="people"].people_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="juridical_persons"].juridical_persons_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="estates"].estates_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="places"].places_hidden', style: { 'display': 'none' } },
        {selector: 'edge[type="red"].red_hidden', style: {'display': 'none'} },
        {selector: 'edge[type="green"].green_hidden', style: {'display': 'none'} },
        {selector: 'edge[type="blue"].blue_hidden', style: {'display': 'none'} },
        {selector: 'edge.relation_type_hidden', style: {'label': ''} },
        {selector: 'node.highlighted', style: { 'background-color': 'red',  'width': '600px', 'height': '200px'} }
        ];
        
        const cy_layout =  { name: 'fcose', animate: false, nodeRepulsion: 100000000, nodeSeparation: 100, randomize: true, idealEdgeLength: 300 };