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
      <!-- button for scrolling down -->
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
    <div id="{substring-after(str[@name='index_external_resource'], '#')}" class="index_item">
      <xsl:apply-templates select="str[@name='index_item_name']" />
      <xsl:apply-templates select="str[@name='index_external_resource']" />
      <xsl:apply-templates select="arr[@name='index_instance_location']" />
    </div>
  </xsl:template>

  <!-- items name -->
  <xsl:template match="str[@name='index_item_name']">
      <h3 class="index_item_name"><xsl:value-of select="replace(replace(., '~ ', ''), '# ', '')"/></h3>
  </xsl:template>
  
  <!-- items links to external resources -->
  <xsl:template match="str[@name='index_external_resource']">
    <p><strong>Item entry: </strong><a target="_blank" href="{.}"><xsl:text>➚</xsl:text></a></p>
  </xsl:template>
  
  <!-- items list of linked documents -->
  <xsl:template match="arr[@name='index_instance_location']">
    <h4><xsl:text>Linked documents by date: </xsl:text></h4>
    <button type="button" class="expander" onclick="$(this).next().toggle();">Show/Hide</button>
    <ul class="index-instances inline-list expanded hidden">
        <xsl:apply-templates select="str">
          <xsl:sort><xsl:value-of select="substring-before(substring-after(substring-after(., '#doc'), '#'), '#')"/></xsl:sort>
        </xsl:apply-templates>
    </ul>
  </xsl:template>

  <!-- items single linked documents; template called from indices-epidoc.xsl -->
  <xsl:template match="arr[@name='index_instance_location']/str">
    <xsl:call-template name="render-instance-location" />
  </xsl:template>

</xsl:stylesheet>
