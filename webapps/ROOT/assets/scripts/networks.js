/**** Cytoscape Panzoom ****/
/*!
Copyright (c) The Cytoscape Consortium

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

;(function(){ 'use strict';

  // registers the extension on a cytoscape lib ref
  var register = function( cytoscape, $ ){
    if( !cytoscape || !$ ){ return; } // can't register if cytoscape or jquery unspecified

    $.fn.cyPanzoom = $.fn.cytoscapePanzoom = function( options ){
      panzoom.apply( this, [ options, cytoscape, $ ] );

      return this; // chainability
    };

    // if you want a core extension
    cytoscape('core', 'panzoom', function( options ){ // could use options object, but args are up to you
      panzoom.apply( this, [ options, cytoscape, $ ] );

      return this; // chainability
    });

  };

  var defaults = {
    zoomFactor: 0.05, // zoom factor per zoom tick
    zoomDelay: 45, // how many ms between zoom ticks
    minZoom: 0.01, // min zoom level
    maxZoom: 10, // max zoom level
    fitPadding: 50, // padding when fitting
    panSpeed: 10, // how many ms in between pan ticks
    panDistance: 10, // max pan distance per tick
    panDragAreaSize: 75, // the length of the pan drag box in which the vector for panning is calculated (bigger = finer control of pan speed and direction)
    panMinPercentSpeed: 0.25, // the slowest speed we can pan by (as a percent of panSpeed)
    panInactiveArea: 8, // radius of inactive area in pan drag box
    panIndicatorMinOpacity: 0.5, // min opacity of pan indicator (the draggable nib); scales from this to 1.0
    zoomOnly: false, // a minimal version of the ui only with zooming (useful on systems with bad mousewheel resolution)
    fitSelector: undefined, // selector of elements to fit
    animateOnFit: function(){ // whether to animate on fit
      return false;
    },
    fitAnimationDuration: 1000, // duration of animation on fit

    // icon class names
    sliderHandleIcon: 'fa fa-minus',
    zoomInIcon: 'fa fa-plus',
    zoomOutIcon: 'fa fa-minus',
    resetIcon: 'fa fa-expand'
  };

  var panzoom = function( params, cytoscape, $ ){
    var cyRef = this;
    var options = $.extend(true, {}, defaults, params);
    var fn = params;

    var functions = {
      destroy: function(){
        var $this = $(cyRef.container());
        var $pz = $this.find(".cy-panzoom");

        $pz.data('winbdgs').forEach(function( l ){
          $(window).unbind( l.evt, l.fn );
        });

        $pz.data('cybdgs').forEach(function( l ){
          cyRef.off( l.evt, l.fn );
        });

        $pz.remove();
      },

      init: function(){
        var browserIsMobile = 'ontouchstart' in window;

        return $(cyRef.container()).each(function(){
          var $container = $(this);
          $container.cytoscape = cytoscape;

          var winbdgs = [];
          var $win = $(window);

          var windowBind = function( evt, fn ){
            winbdgs.push({ evt: evt, fn: fn });

            $win.bind( evt, fn );
          };

          var windowUnbind = function( evt, fn ){
            for( var i = 0; i < winbdgs.length; i++ ){
              var l = winbdgs[i];

              if( l.evt === evt && l.fn === fn ){
                winbdgs.splice( i, 1 );
                break;
              }
            }

            $win.unbind( evt, fn );
          };

          var cybdgs = [];

          var cyOn = function( evt, fn ){
            cybdgs.push({ evt: evt, fn: fn });

            cyRef.on( evt, fn );
          };

          var cyOff = function( evt, fn ){
            for( var i = 0; i < cybdgs.length; i++ ){
              var l = cybdgs[i];

              if( l.evt === evt && l.fn === fn ){
                cybdgs.splice( i, 1 );
                break;
              }
            }

            cyRef.off( evt, fn );
          };

          var $panzoom = $('<div class="cy-panzoom"></div>');
          $container.prepend( $panzoom );

          $panzoom.css('position', 'absolute'); // must be absolute regardless of stylesheet

          $panzoom.data('winbdgs', winbdgs);
          $panzoom.data('cybdgs', cybdgs);

          if( options.zoomOnly ){
            $panzoom.addClass("cy-panzoom-zoom-only");
          }

          // add base html elements
          /////////////////////////

          var $zoomIn = $('<div class="cy-panzoom-zoom-in cy-panzoom-zoom-button"><span class="icon '+ options.zoomInIcon +'"></span></div>');
          $panzoom.append( $zoomIn );

          var $zoomOut = $('<div class="cy-panzoom-zoom-out cy-panzoom-zoom-button"><span class="icon ' + options.zoomOutIcon + '"></span></div>');
          $panzoom.append( $zoomOut );

          var $reset = $('<div class="cy-panzoom-reset cy-panzoom-zoom-button"><span class="icon ' + options.resetIcon + '"></span></div>');
          $panzoom.append( $reset );

          var $slider = $('<div class="cy-panzoom-slider"></div>');
          $panzoom.append( $slider );

          $slider.append('<div class="cy-panzoom-slider-background"></div>');

          var $sliderHandle = $('<div class="cy-panzoom-slider-handle"><span class="icon ' + options.sliderHandleIcon + '"></span></div>');
          $slider.append( $sliderHandle );

          var $noZoomTick = $('<div class="cy-panzoom-no-zoom-tick"></div>');
          $slider.append( $noZoomTick );

          var $panner = $('<div class="cy-panzoom-panner"></div>');
          $panzoom.append( $panner );

          var $pHandle = $('<div class="cy-panzoom-panner-handle"></div>');
          $panner.append( $pHandle );

          var $pUp = $('<div class="cy-panzoom-pan-up cy-panzoom-pan-button"></div>');
          var $pDown = $('<div class="cy-panzoom-pan-down cy-panzoom-pan-button"></div>');
          var $pLeft = $('<div class="cy-panzoom-pan-left cy-panzoom-pan-button"></div>');
          var $pRight = $('<div class="cy-panzoom-pan-right cy-panzoom-pan-button"></div>');
          $panner.append( $pUp ).append( $pDown ).append( $pLeft ).append( $pRight );

          var $pIndicator = $('<div class="cy-panzoom-pan-indicator"></div>');
          $panner.append( $pIndicator );

          // functions for calculating panning
          ////////////////////////////////////

          function handle2pan(e){
            var v = {
              x: e.originalEvent.pageX - $panner.offset().left - $panner.width()/2,
              y: e.originalEvent.pageY - $panner.offset().top - $panner.height()/2
            }

            var r = options.panDragAreaSize;
            var d = Math.sqrt( v.x*v.x + v.y*v.y );
            var percent = Math.min( d/r, 1 );

            if( d < options.panInactiveArea ){
              return {
                x: NaN,
                y: NaN
              };
            }

            v = {
              x: v.x/d,
              y: v.y/d
            };

            percent = Math.max( options.panMinPercentSpeed, percent );

            var vnorm = {
              x: -1 * v.x * (percent * options.panDistance),
              y: -1 * v.y * (percent * options.panDistance)
            };

            return vnorm;
          }

          function donePanning(){
            clearInterval(panInterval);
            windowUnbind("mousemove", handler);

            $pIndicator.hide();
          }

          function positionIndicator(pan){
            var v = pan;
            var d = Math.sqrt( v.x*v.x + v.y*v.y );
            var vnorm = {
              x: -1 * v.x/d,
              y: -1 * v.y/d
            };

            var w = $panner.width();
            var h = $panner.height();
            var percent = d/options.panDistance;
            var opacity = Math.max( options.panIndicatorMinOpacity, percent );
            var color = 255 - Math.round( opacity * 255 );

            $pIndicator.show().css({
              left: w/2 * vnorm.x + w/2,
              top: h/2 * vnorm.y + h/2,
              background: "rgb(" + color + ", " + color + ", " + color + ")"
            });
          }

          function calculateZoomCenterPoint(){
            var pan = cyRef.pan();
            var zoom = cyRef.zoom();

            zx = $container.width()/2;
            zy = $container.height()/2;
          }

          var zooming = false;
          function startZooming(){
            zooming = true;

            calculateZoomCenterPoint();
          }


          function endZooming(){
            zooming = false;
          }

          var zx, zy;
          function zoomTo(level){
            if( !zooming ){ // for non-continuous zooming (e.g. click slider at pt)
              calculateZoomCenterPoint();
            }

            cyRef.zoom({
              level: level,
              renderedPosition: { x: zx, y: zy }
            });
          }

          var panInterval;

          var handler = function(e){
            e.stopPropagation(); // don't trigger dragging of panzoom
            e.preventDefault(); // don't cause text selection
            clearInterval(panInterval);

            var pan = handle2pan(e);

            if( isNaN(pan.x) || isNaN(pan.y) ){
              $pIndicator.hide();
              return;
            }

            positionIndicator(pan);
            panInterval = setInterval(function(){
              cyRef.panBy(pan);
            }, options.panSpeed);
          };

          $pHandle.bind("mousedown", function(e){
            // handle click of icon
            handler(e);

            // update on mousemove
            windowBind("mousemove", handler);
          });

          $pHandle.bind("mouseup", function(){
            donePanning();
          });

          windowBind("mouseup blur", function(){
            donePanning();
          });



          // set up slider behaviour
          //////////////////////////

          $slider.bind('mousedown', function(){
            return false; // so we don't pan close to the slider handle
          });

          var sliderVal;
          var sliding = false;
          var sliderPadding = 2;

          function setSliderFromMouse(evt, handleOffset){
            if( handleOffset === undefined ){
              handleOffset = 0;
            }

            var padding = sliderPadding;
            var min = 0 + padding;
            var max = $slider.height() - $sliderHandle.height() - 2*padding;
            var top = evt.pageY - $slider.offset().top - handleOffset;

            // constrain to slider bounds
            if( top < min ){ top = min }
            if( top > max ){ top = max }

            var percent = 1 - (top - min) / ( max - min );

            // move the handle
            $sliderHandle.css('top', top);

            var zmin = options.minZoom;
            var zmax = options.maxZoom;

            // assume (zoom = zmax ^ p) where p ranges on (x, 1) with x negative
            var x = Math.log(zmin) / Math.log(zmax);
            var p = (1 - x)*percent + x;

            // change the zoom level
            var z = Math.pow( zmax, p );

            // bound the zoom value in case of floating pt rounding error
            if( z < zmin ){
              z = zmin;
            } else if( z > zmax ){
              z = zmax;
            }

            zoomTo( z );
          }

          var sliderMdownHandler, sliderMmoveHandler;
          $sliderHandle.bind('mousedown', sliderMdownHandler = function( mdEvt ){
            var handleOffset = mdEvt.target === $sliderHandle[0] ? mdEvt.offsetY : 0;
            sliding = true;

            startZooming();
            $sliderHandle.addClass("active");

            var lastMove = 0;
            windowBind('mousemove', sliderMmoveHandler = function( mmEvt ){
              var now = +new Date;

              // throttle the zooms every 10 ms so we don't call zoom too often and cause lag
              if( now > lastMove + 10 ){
                lastMove = now;
              } else {
                return false;
              }

              setSliderFromMouse(mmEvt, handleOffset);

              return false;
            });

            // unbind when
            windowBind('mouseup', function(){
              windowUnbind('mousemove', sliderMmoveHandler);
              sliding = false;

              $sliderHandle.removeClass("active");
              endZooming();
            });

            return false;
          });

          $slider.bind('mousedown', function(e){
            if( e.target !== $sliderHandle[0] ){
              sliderMdownHandler(e);
              setSliderFromMouse(e);
            }
          });

          function positionSliderFromZoom(){
            var z = cyRef.zoom();
            var zmin = options.minZoom;
            var zmax = options.maxZoom;

            // assume (zoom = zmax ^ p) where p ranges on (x, 1) with x negative
            var x = Math.log(zmin) / Math.log(zmax);
            var p = Math.log(z) / Math.log(zmax);
            var percent = 1 - (p - x) / (1 - x); // the 1- bit at the front b/c up is in the -ve y direction

            var min = sliderPadding;
            var max = $slider.height() - $sliderHandle.height() - 2*sliderPadding;
            var top = percent * ( max - min );

            // constrain to slider bounds
            if( top < min ){ top = min }
            if( top > max ){ top = max }

            // move the handle
            $sliderHandle.css('top', top);
          }

          positionSliderFromZoom();

          cyOn('zoom', function(){
            if( !sliding ){
              positionSliderFromZoom();
            }
          });

          // set the position of the zoom=1 tick
          (function(){
            var z = 1;
            var zmin = options.minZoom;
            var zmax = options.maxZoom;

            // assume (zoom = zmax ^ p) where p ranges on (x, 1) with x negative
            var x = Math.log(zmin) / Math.log(zmax);
            var p = Math.log(z) / Math.log(zmax);
            var percent = 1 - (p - x) / (1 - x); // the 1- bit at the front b/c up is in the -ve y direction

            if( percent > 1 || percent < 0 ){
              $noZoomTick.hide();
              return;
            }

            var min = sliderPadding;
            var max = $slider.height() - $sliderHandle.height() - 2*sliderPadding;
            var top = percent * ( max - min );

            // constrain to slider bounds
            if( top < min ){ top = min }
            if( top > max ){ top = max }

            $noZoomTick.css('top', top);
          })();

          // set up zoom in/out buttons
          /////////////////////////////

          function bindButton($button, factor){
            var zoomInterval;

            $button.bind("mousedown", function(e){
              e.preventDefault();
              e.stopPropagation();

              if( e.button != 0 ){
                return;
              }

              var doZoom = function(){
                var zoom = cyRef.zoom();
                var lvl = cyRef.zoom() * factor;

                if( lvl < options.minZoom ){
                  lvl = options.minZoom;
                }

                if( lvl > options.maxZoom ){
                  lvl = options.maxZoom;
                }

                if( (lvl == options.maxZoom && zoom == options.maxZoom) ||
                  (lvl == options.minZoom && zoom == options.minZoom)
                ){
                  return;
                }

                zoomTo(lvl);
              };

              startZooming();
              doZoom();
              zoomInterval = setInterval(doZoom, options.zoomDelay);

              return false;
            });

            windowBind("mouseup blur", function(){
              clearInterval(zoomInterval);
              endZooming();
            });
          }

          bindButton( $zoomIn, (1 + options.zoomFactor) );
          bindButton( $zoomOut, (1 - options.zoomFactor) );

          $reset.bind("mousedown", function(e){
            if( e.button != 0 ){
              return;
            }

            var elesToFit = options.fitSelector?cyRef.elements(options.fitSelector):cyRef.elements();

            if( elesToFit.size() === 0 ){
              cyRef.reset();
            } else {
              var animateOnFit = typeof options.animateOnFit === 'function' ? options.animateOnFit.call() : options.animateOnFit;
              if(animateOnFit){
                cyRef.animate({
                  fit: {
                    eles: elesToFit,
                    padding: options.fitPadding
                  }
                }, {
                  duration: options.fitAnimationDuration
                });
              }
              else{
                cyRef.fit( elesToFit, options.fitPadding );
              }

            }

            return false;
          });



        });
      }
    };

    if( functions[fn] ){
      return functions[fn].apply(this, Array.prototype.slice.call( arguments, 1 ));
    } else if( typeof fn == 'object' || !fn ) {
      return functions.init.apply( this, arguments );
    } else {
      $.error("No such function `"+ fn +"` for jquery.cytoscapePanzoom");
    }

    return $(this);
  };


  if( typeof module !== 'undefined' && module.exports ){ // expose as a commonjs module
    module.exports = function( cytoscape, jquery ){
      register( cytoscape, jquery || require('jquery') );
    }
  } else if( typeof define !== 'undefined' && define.amd ){ // expose as an amd/requirejs module
    define('cytoscape-panzoom', function(){
      return register;
    });
  }

  if( typeof cytoscape !== 'undefined' && typeof jQuery !== 'undefined' ){ // expose to global cytoscape (i.e. window.cytoscape)
    register( cytoscape, jQuery );
  }

})();

/****** autocomplete ******/

function autocomplete(inp, arr) {
  /*two arguments, the text field element and an array of possible autocompleted values:*/
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
        /*If the arrow DOWN key is pressed, increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed, decrease the currentFocus variable:*/
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
    /*close all autocomplete lists in the document, except the one passed as an argument:*/
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
        { selector: 'edge', style: { 'curve-style': 'bezier', 'width': 3, 'label': 'data(name)', 'target-arrow-shape': 'triangle', 'opacity': '0.6', 'z-index': '0' } },
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
        
        {selector: 'node.searched', style: {'border-width': 10, 'border-color': 'red'} },
        {selector: '.hidden', style: {'display': 'none'} },
        {selector: '.hidden_label', style: {'label': ''} },
        {selector: 'node:selected', style: {'border-width': 10, 'border-color': 'orange', 'z-index': '99999', 'font-size': '80'} }
        ];
        
        var inputSearch = "inputSearch", inputVal = "#inputSearch", btnSearch = "#btnSearch", reset = "#reset";
        var toggle_people = "toggle_people", toggle_juridical_persons = "toggle_juridical_persons", toggle_estates = "toggle_estates", 
        toggle_places = "toggle_places", toggle_red = "toggle_red", toggle_green = "toggle_green", toggle_blue = "toggle_blue", 
        toggle_orange = "toggle_orange", toggle_labels = "toggle_labels";
          
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