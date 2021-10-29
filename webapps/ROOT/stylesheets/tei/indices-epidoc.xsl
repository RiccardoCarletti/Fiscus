<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to transform an EpiDoc index into HTML. Relies on common
       functionality in indices.xsl. -->

  <xsl:import href="indices.xsl" />

  <xsl:template name="render-instance-location">
    <!-- This field contains a single string with each location component separated by a "#". 
      The components are taken from stylesheets/solr/epidoc-index-utils.xsl. -->
    <xsl:variable name="location_parts" select="tokenize(., '#')" />
    <xsl:variable name="match_id">
      <xsl:text>local-</xsl:text>
      <xsl:value-of select="$location_parts[1]" />
      <xsl:text>-display-html</xsl:text>
    </xsl:variable>
    <li>
      <a href="{kiln:url-for-match($match_id, ($language, $location_parts[2]), 0)}">
        <span class="index-instance-file"><xsl:value-of select="substring-after($location_parts[2], 'doc')" /></span>
        <span class="index-instance-file-date"><xsl:text> [</xsl:text>
          <xsl:choose>
            <xsl:when test="starts-with($location_parts[3], '0')">
              <xsl:value-of select="replace(replace(substring($location_parts[3], 2), '–0', '–'), '–', ' – ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="replace(replace($location_parts[3], '–0', '–'), '–', ' – ')"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>]</xsl:text></span>
        <xsl:if test="$location_parts[4]!=''">
          <span class="index-instance-file-keys"><xsl:text>: </xsl:text><xsl:value-of select="$location_parts[4]" /></span>
        </xsl:if>
      </a>
    </li>
    <br/>
  </xsl:template>

</xsl:stylesheet>
