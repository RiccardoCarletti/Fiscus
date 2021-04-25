/* ***** autocomplete ***** */

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
        { selector: 'edge', style: { 'curve-style': 'bezier', 'width': 3, 'label': 'data(name)', 'target-arrow-shape': 'triangle', 'opacity': '0.6', 'z-index': '0', 'overlay-opacity': '0', 'events': 'no' } },
        { selector: 'node', style: { 'font-size': '22', 'label': 'data(name)', 'text-wrap': 'wrap', 'text-max-width': '280', 'text-valign': 'center', 'text-halign': 'center', 'shape': 'round-rectangle', 'padding': '20', 'border-width': 3, 'border-color': 'black', 'border-style': 'solid', 'font-weight': 'normal', 'text-events': 'yes', 'color': '#000', 'text-outline-width': '1', 'text-outline-opacity': '1', 'overlay-color': '#fff', 'width': 'label', 'height': 'label' } }, /* 'width': '300', 'height': '100' } }*/
        { selector: 'node[type="people_only"]', style: { 'background-color': '#97c2fc' } },
        { selector: 'node[type="people"]', style: { 'background-color': '#ffff80' } },
        { selector: 'node[type="juridical_persons"]', style: { 'background-color': '#ffb4b4' } },
        { selector: 'node[type="estates"]', style: { 'background-color': '#99ff99' } },
        { selector: 'node[type="places"]', style: { 'background-color': '#c2c2ff' } },
        { selector: 'edge[type="red"]', style: { 'line-color': 'red', 'target-arrow-color': 'red' } },
        { selector: 'edge[type="green"]', style: { 'line-color': 'green', 'target-arrow-color': 'green' } },
        { selector: 'edge[type="blue"]', style: { 'line-color': 'blue', 'target-arrow-color': 'blue' } },
        /*toggle*/
        { selector: 'node[type="people"].people_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="juridical_persons"].juridical_persons_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="estates"].estates_hidden', style: { 'display': 'none' } },
        { selector: 'node[type="places"].places_hidden', style: { 'display': 'none' } },
        {selector: 'edge[type="red"].red_hidden', style: {'display': 'none'} },
        {selector: 'edge[type="green"].green_hidden', style: {'display': 'none'} },
        {selector: 'edge[type="blue"].blue_hidden', style: {'display': 'none'} },
        {selector: 'edge.relation_type_hidden', style: {'label': ''} },
        {selector: 'node.searched', style: { 'background-color': 'red',  'width': '600px', 'height': '200px'} },
        {selector: '.hidden', style: {'display': 'none'} },
        {selector: ':selected', style: { 'background-color': 'red'} },
        /*wine*/
        {selector: 'node.highlighted', style: {'z-index': '9999'} },
        {selector: 'edge.highlighted', style: {'opacity': '0.8', 'width': '4', 'z-index': '9999'} },
        {selector: '.faded', style: {'events': 'no'} },
        {selector: 'node.faded', style: {'opacity': '0.08'} },
        {selector: 'edge.faded', style: {'opacity': '0.06'} }
        ];
        
        var inputSearch = "inputSearch", inputVal = "#inputSearch", btnSearch = "#btnSearch", reset = "#reset";
        var toggle_people = "toggle_people", toggle_juridical_persons = "toggle_juridical_persons", toggle_estates = "toggle_estates", 
        toggle_places = "toggle_places", toggle_red = "toggle_red", toggle_green = "toggle_green", toggle_blue = "toggle_blue", 
        toggle_relation_labels = "toggle_relation_labels";
          
        const cy_layout = { name: 'fcose', animate: false, nodeRepulsion: 100000000, nodeSeparation: 100, randomize: true, idealEdgeLength: 300,  boxSelectionEnabled: true, selectionType: 'additive' };
        
        var cy = cytoscape({ container: document.getElementById(my_graph), elements: graph_items, style: cy_style, layout: cy_layout }).panzoom();      
       
      /*fullscreen*/
       function openFullscreen() {
       if (document.getElementById(my_graph).requestFullscreen) { document.getElementById(my_graph).requestFullscreen(); } 
       else if (document.getElementById(my_graph).webkitRequestFullscreen) { document.getElementById(my_graph).webkitRequestFullscreen();} 
       else if (document.getElementById(my_graph).msRequestFullscreen) { document.getElementById(my_graph).msRequestFullscreen(); } } 
       
        /*toggle*/
      document.getElementById(toggle_people).addEventListener("click", function() { cy.elements().toggleClass('people_hidden'); });
      document.getElementById(toggle_juridical_persons).addEventListener("click", function() { cy.elements().toggleClass('juridical_persons_hidden'); });
      document.getElementById(toggle_estates).addEventListener("click", function() { cy.elements().toggleClass('estates_hidden'); });
      document.getElementById(toggle_places).addEventListener("click", function() { cy.elements().toggleClass('places_hidden'); });
      document.getElementById(toggle_red).addEventListener("click", function() { cy.elements().toggleClass('red_hidden'); });
      document.getElementById(toggle_green).addEventListener("click", function() { cy.elements().toggleClass('green_hidden'); });
      document.getElementById(toggle_blue).addEventListener("click", function() { cy.elements().toggleClass('blue_hidden'); });
      document.getElementById(toggle_relation_labels).addEventListener("click", function() { cy.elements().toggleClass('relation_type_hidden'); }); 
      
        /*autocomplete + search + show only selected + reset*/
        autocomplete(document.getElementById(inputSearch), graph_labels);
        
        $(btnSearch).on('click',function () { 
        cy.elements().removeClass('searched').addClass('hidden');
        cy.$('[name =  "' + $(inputVal).val() + '"]').addClass('searched').removeClass('hidden'); 
        cy.$('[name =  "' + $(inputVal).val() + '"]').neighborhood().removeClass('hidden'); 
        cy.zoom({level: 0.1, position: cy.$('[name =  "' + $(inputVal).val() + '"]').position()});
        });
        
        $(selected).on('click',function () { 
        cy.elements().removeClass('searched').addClass('hidden');
        cy.$(':selected').addClass('searched').removeClass('hidden');
        cy.$(':selected').neighborhood().removeClass('hidden'); 
        });
        
        $(reset).on('click',function () { 
        cy.elements().removeClass('searched').removeClass('hidden').unselect();
        });
