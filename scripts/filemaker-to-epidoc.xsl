<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="xml"/>
    
    <xsl:template match="ROW">
        <?xml-model href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:space="preserve">
            <teiHeader xml:lang="en">
                <fileDesc>
                    <titleStmt>
                        <title><xsl:apply-templates select="./COL[3]/DATA"/></title>
                    </titleStmt>
                    <editionStmt>
                        <edition>Digital edition encoded for <ref target="http://fiscus.unibo.it">Fiscus Project</ref>
                            <date when="2021">2021</date>
                        </edition>
                    </editionStmt>
                    <publicationStmt>
                        <publisher>Fiscus - DISCI UniBo</publisher>
                        <idno type="filename">doc</idno>
                        <availability xml:lang="en" status="free">
                            <licence target="http://creativecommons.org/licenses/by-sa/4.0/">Metadata and
                                texts are released as Creative Commons, Attribution-ShareAlike 4.0 (CC BY-SA
                                4.0)</licence>
                        </availability>
                        <date when="2021"/>
                    </publicationStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <altIdentifier>
                                    <idno type="uri"/>
                                </altIdentifier>
                            </msIdentifier>
                            <msContents>
                                <summary>
                                    <rs type="text_type" ref="#"></rs>
                                    <rs type="record_source" ref="#"></rs>
                                    <rs type="document_tradition" ref="#"></rs>
                                    <rs type="fiscal_property"/>
                                </summary>
                                <msItem xml:id="msItem1">
                                    <textLang mainLang="" otherLangs=""/>
                                </msItem>
                            </msContents>
                            <history>
                                <origin>
                                    <origDate when="{./COL[1]/DATA}"> 
                                        <note type="displayed_date"><xsl:apply-templates select="./COL[2]/DATA"/></note>
                                        <note type="dating_elements"></note>
                                        <note type="topical_date"></note>
                                    </origDate>
                                    <origPlace/>
                                </origin>
                                <provenance type="findspot">
                                    <location>
                                        <placeName/>
                                    </location>
                                </provenance>
                            </history>
                        </msDesc>
                        <listPlace>
                    <place></place>
                </listPlace>
                <listPerson>
                    <person></person>
                </listPerson>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <textClass>
                        <keywords>
                            <term/>
                        </keywords>
                    </textClass>
                </profileDesc>
                <revisionDesc>
                    <listChange>
                        <change when="2021-04-18" who="scollavini">creation of record</change>
                    </listChange>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="edition">
                        <div type="textpart">
                            <ab>
                                <xsl:apply-templates select="./COL[5]/DATA"/>
                            </ab>
                        </div>
                    </div>
                    <div type="bibliography" subtype="editions">
                        <p><xsl:apply-templates select="./COL[4]/DATA"/></p>
                    </div>
                    <div type="bibliography" subtype="additional">
                        <p></p>
                    </div>
                    <div type="bibliography" subtype="links">
                        <p></p>
                    </div>
                    <div type="commentary">
                         <p>Persone: <xsl:apply-templates select="./COL[7]/DATA"/>.
                             Luoghi: <xsl:apply-templates select="./COL[8]/DATA"/>.
                            Chiese: <xsl:apply-templates select="./COL[10]/DATA"/>.
                            Cariche: <xsl:apply-templates select="./COL[6]/DATA"/>.
                             Note: <xsl:apply-templates select="./COL[9]/DATA"/>
                             Indice: <xsl:apply-templates select="./COL[11]/DATA"/></p>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>