<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
  
  <!-- lists -->
  <xsl:template match="response/result">
    <button type="button" onclick="topFunction()" id="scroll" title="Go to top">⬆  </button>
    <script type="text/javascript">
      <!-- scrolling down button -->
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
    
    <p>Total items: <xsl:value-of select="doc[1]/str[@name='index_total_items']" /></p>
    <button type="button" class="expander" onclick="$('.expanded').toggle();">Show/Hide all linked items</button>
    
    <div>
        <xsl:apply-templates select="doc[str[@name='index_item_name'][not(starts-with(., '~'))][not(starts-with(., '#'))]]">
          <xsl:sort select="lower-case(.)"/>
        </xsl:apply-templates>
    </div>
    
    <xsl:if test="doc[str[@name='index_item_name'][starts-with(., '#')]]">
      <h2>Personal names normalized forms</h2>
      <div>
          <xsl:apply-templates select="doc[str[@name='index_item_name'][starts-with(., '#')]]">
            <xsl:sort select="lower-case(.)"/>
          </xsl:apply-templates>
        </div>
    </xsl:if>
    
    <xsl:if test="doc[str[@name='index_item_name'][starts-with(., '~')]]">
      <h2>Items that have not been identified/normalized</h2>
      <div>
          <xsl:apply-templates select="doc[str[@name='index_item_name'][starts-with(., '~')]]">
            <xsl:sort select="lower-case(.)"/>
          </xsl:apply-templates>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- items in lists -->
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
      <h3 class="index_item_name"><xsl:value-of select="replace(replace(., '~ ', ''), '# ', '')"/></h3>
  </xsl:template>
  
  <!-- item other names -->
  <xsl:template match="str[@name='index_other_names']">
    <p><strong>Also known as: </strong><xsl:value-of select="."/></p>
  </xsl:template>
  
  <!-- item number -->
  <xsl:template match="str[@name='index_item_number']">
    <p><strong>Item number: </strong><xsl:value-of select="."/></p>
  </xsl:template>
  
  <!-- item coordinates -->
  <xsl:template match="str[@name='index_coordinates']">
    <p><strong>Coordinates (Lat, Long): </strong>
      <a target="_blank" href="{concat('../../texts/map.html#',substring-after(ancestor::doc/str[@name='index_item_number'], 'places/'))}" class="open_map"><xsl:text>See on map</xsl:text></a>
      <xsl:text> </xsl:text><xsl:value-of select="."/></p>
  </xsl:template>
  
  <!-- item notes, handling also included URIs -->
  <xsl:template match="str[@name='index_notes']">
    <p><strong>Commentary/Bibliography: </strong>
      <xsl:analyze-string select="." regex="(http:|https:)(\S+?)(\.|\)|\]|;|,|\?|!|:)?(\s|$)">
        <xsl:matching-substring>
          <a target="_blank" href="{concat(regex-group(1),regex-group(2))}"><xsl:value-of select="concat(regex-group(1),regex-group(2))"/></a>
          <xsl:value-of select="concat(regex-group(3),regex-group(4))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
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
            <xsl:value-of select="substring-before(substring-after(., '#'), '@')"/>
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
            <xsl:value-of select="substring-before(substring-after(., '#'), '@')"/>
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
            <xsl:value-of select="substring-before(substring-after(., '#'), '@')"/>
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
      <a target="_blank" href="{concat('../../texts/map.html#', substring-before(substring-after(., 'map.html#'), '~'))}" class="open_map">See on map</a>
      <xsl:text> </xsl:text>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="expanded hidden">
      <xsl:for-each select="$item">
        <li>
          <a target="_blank" href="{concat('places.html#', substring-before(., '#'))}">
            <xsl:value-of select="substring-before(substring-after(., '#'), '@')"/>
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
