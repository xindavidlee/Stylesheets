<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:exsl="http://exslt.org/common"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="local"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="no" encoding="UTF-8"/>
  
  <!-- an index of elements that insert quotation marks -->
  <xsl:key name="quotation.elements" match="tei:quote|tei:q|tei:soCalled|tei:title[@level = ('a', 'u')]" use="local-name()"/>
  
  <!-- an index of elements with @xml:id attribute -->
  <xsl:key name="ids" match="*" use="@xml:id"/>
    
  <xsl:variable name="lsquo">‘</xsl:variable>
  <xsl:variable name="rsquo">’</xsl:variable>
  <xsl:variable name="ldquo">“</xsl:variable>
  <xsl:variable name="rdquo">”</xsl:variable>
  
  <xsl:variable name="docRoot" select="/"/>

  <!-- attribute sets -->
  <xsl:attribute-set name="global.flow.properties">
    <xsl:attribute name="font-family">GentiumPlus</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="line-height">2</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
    <xsl:attribute name="orphans">3</xsl:attribute>
    <xsl:attribute name="widows">3</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="global.side.margins">
    <xsl:attribute name="margin-left">1cm</xsl:attribute>
    <xsl:attribute name="margin-right">1cm</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="headerfooter.properties">
    <xsl:attribute name="font-family">Roboto-medium</xsl:attribute>
    <xsl:attribute name="font-size">7pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="heading.properties">
    <xsl:attribute name="font-family">Roboto</xsl:attribute>
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="text-transform">uppercase</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="space-before">1em</xsl:attribute>
    <xsl:attribute name="space-after">1em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="heading.body.properties">
    <xsl:attribute name="font-family">Roboto-medium</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="space-before">1em</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="heading.lowerblock.properties">
    <xsl:attribute name="font-family">Roboto-medium</xsl:attribute>
    <xsl:attribute name="font-size">8.3pt</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="back.font.properties">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="block.spacing.properties">
    <xsl:attribute name="space-before">1em</xsl:attribute>
    <xsl:attribute name="space-after">2em</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="indentedblock.properties">
    <xsl:attribute name="margin-left">2em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="pnr.properties">
    <xsl:attribute name="font-family">Roboto-medium</xsl:attribute>
    <xsl:attribute name="font-size">7pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="egXML.properties">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="text-indent">0pt</xsl:attribute>
    <xsl:attribute name="keep-together.within-page">5</xsl:attribute>
<!--    <xsl:attribute name="orphans">5</xsl:attribute>
    <xsl:attribute name="widows">5</xsl:attribute>-->
  </xsl:attribute-set>
  
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="font-family">DejaVu-mono</xsl:attribute>
    <xsl:attribute name="font-size">.8em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="table.properties">
    <xsl:attribute name="border">solid 0.1mm grey</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="cell.properties">
    <xsl:attribute name="padding">0.5em</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- ==================================================================================== -->
  <!-- PAGE DEFINITIONS                                                                     -->
  <!-- ==================================================================================== -->
  
  <xsl:template name="pageDef">
    <fo:layout-master-set>
      <fo:simple-page-master
        master-name="only"
        page-height="29.7cm"
        page-width="21cm"
        margin-top="2cm"
        margin-bottom="2cm"
        margin-left="2.5cm"
        margin-right="2.5cm">
        <fo:region-body
          margin-top="2cm"
          margin-bottom="2cm"
          xsl:use-attribute-sets="global.side.margins"/>
        <fo:region-before
          region-name="any-before"
          extent="2cm"/>
        <fo:region-after
          region-name="any-after"
          extent="2cm"/>
      </fo:simple-page-master>
      <fo:page-sequence-master master-name="article">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference
            master-reference="only"
            page-position="any"
            blank-or-not-blank="not-blank"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
    </fo:layout-master-set>
  </xsl:template>

  <!-- ==================================================================================== -->
  <!-- TEXT SKELETON                                                                        -->
  <!-- ==================================================================================== -->

  <xsl:template match="tei:TEI">    
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <!-- page definitions  -->
      <xsl:call-template name="pageDef"/>
      <!-- PDF outline -->
      <xsl:call-template name="PDF-outline"/>
      <fo:page-sequence
        master-reference="only"
        format="1"
        initial-page-number="1">
        <!-- header -->
        <fo:static-content flow-name="any-before">
          <xsl:call-template name="page.header"/>
        </fo:static-content>
        <!-- footer -->
        <fo:static-content flow-name="any-after">
          <xsl:call-template name="page.footer"/>
        </fo:static-content>
        <!-- body -->
        <fo:flow flow-name="xsl-region-body" 
          xsl:use-attribute-sets="global.flow.properties">
          <xsl:call-template name="front"/>
          <xsl:call-template name="body"/>
          <xsl:call-template name="back"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
  
  <xsl:template name="page.header">
    <fo:block xsl:use-attribute-sets="global.side.margins headerfooter.properties" text-align="right">
      <!-- a list-block looks like the best bet to get negative indent for page numbers with FOP --> 
      <fo:list-block>
        <fo:list-item>
          <fo:list-item-label><fo:block><xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/></fo:block></fo:list-item-label>
          <fo:list-item-body end-indent="-4em">
            <fo:block><fo:page-number/></fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="page.footer">
    <fo:block xsl:use-attribute-sets="global.side.margins headerfooter.properties" 
      padding-top="1em" border-top="solid black .5px">
      <xsl:choose>
        <xsl:when test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:seriesStmt">
          <xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:seriesStmt">
            <xsl:value-of select="tei:title[@level='j']"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="tei:biblScope[@unit='issue']/concat(upper-case(substring(@unit, 1, 1)), substring(@unit, 2))"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="tei:biblScope[@unit='issue']/@n"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="preceding-sibling::tei:publicationStmt/tei:date"/>
            <fo:block/>
            <fo:inline font-style="italic"><xsl:value-of select="tei:biblScope"/></fo:inline>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string-join(('Journal of the Text Encoding Initiative', /tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno, /tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date), ', ')"/>          
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="PDF-outline">
    <fo:bookmark-tree>
      <xsl:apply-templates select=".//tei:body/tei:div[tei:head]" mode="PDF-outline"/>
    </fo:bookmark-tree>
  </xsl:template>
  
  <xsl:template match="tei:div[tei:head]" mode="PDF-outline">
    <xsl:variable name="prepared">
      <xsl:apply-templates select="tei:head/node()[not(self::tei:note)]"/>
    </xsl:variable>
    <fo:bookmark internal-destination="{(@xml:id, generate-id())[1]}">
      <fo:bookmark-title>
        <xsl:apply-templates select="." mode="label"/>
        <xsl:value-of select="$prepared"/>
      </fo:bookmark-title>
      <xsl:apply-templates select="tei:div" mode="PDF-outline"/>
    </fo:bookmark>
  </xsl:template>
  
  <xsl:template name="front">
    <xsl:call-template name="article.title"/>
    <xsl:call-template name="author.notes"/>
  </xsl:template>
  
  <xsl:template name="body">
    <fo:block>
      <xsl:apply-templates select="/tei:TEI/tei:text/tei:body"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="back">
    <fo:block border-top="solid 1px black" xsl:use-attribute-sets="block.spacing.properties" keep-with-next="always"/>
    <xsl:apply-templates select="/tei:TEI/tei:text/tei:back/tei:div[@type='bibliography']"/>
    <xsl:call-template name="appendixes"/>
    <xsl:call-template name="endnotes"/>
    <fo:block border-top="solid 1px black" xsl:use-attribute-sets="block.spacing.properties" keep-with-next="always"/>
    <xsl:apply-templates select="/tei:TEI/tei:text/tei:front/tei:div[@type='abstract']"/>
    <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass"/>
    <xsl:call-template name="authors"/>    
  </xsl:template>
  
  <!-- ==================================================================================== -->
  <!-- FRONT STRUCTURE                                                                      -->
  <!-- ==================================================================================== -->
  
  <xsl:template name="article.title">
    <fo:block margin-top="2cm" margin-bottom="3cm"
      border-top="solid black 5px" border-bottom="solid black 3px" 
      padding-top="1cm" padding-bottom="1cm">
      <fo:block font-family="GentiumBookBasic" font-style="italic" font-size="24pt" line-height="1.2">
        <xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'], /tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type = 'main')]">
          <xsl:apply-templates/>
          <xsl:if test="position() != last()">
            <xsl:text>: </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
      <fo:block font-family="Roboto-medium" font-size="11pt" margin-top="1cm">
        <xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
          <xsl:call-template name="enumerate"/>
          <xsl:value-of select="string-join(tei:name/(tei:forename, tei:surname), ' ')"/>
        </xsl:for-each>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="author.notes">
    <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:div[@type='acknowledgements']">
      <fo:block>
        <fo:block xsl:use-attribute-sets="heading.properties" font-family="Roboto" font-size="13pt">Author's Note</fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:for-each>
  </xsl:template>
    
  <!-- ==================================================================================== -->
  <!-- BODY STRUCTURE                                                                       -->
  <!-- ==================================================================================== -->

  <xsl:template match="tei:div">
    <fo:block id="{(@xml:id,generate-id())[1]}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:body/tei:head">
    <fo:block xsl:use-attribute-sets="heading.body.properties">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:div/tei:head">
    <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
    <xsl:variable name="font-size">
      <xsl:choose>
        <xsl:when test="$depth &lt;= 1">15</xsl:when>
        <xsl:when test="$depth = 2">12</xsl:when>
        <xsl:when test="$depth = 3">10</xsl:when>
        <xsl:otherwise>8</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="heading.body.properties" font-size="{$font-size}pt">
      <xsl:apply-templates select="parent::*" mode="label"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <!-- label mode + associated functions: borrowed from tei2openedition -->
  <xsl:template match="*" mode="label">
    <xsl:param name="crossref.ptr" select="()" as="node()*"/>
    <xsl:variable name="label" select="local:get.label.name(., $crossref.ptr)"/>
    <xsl:variable name="number" select="local:get.label.number(.)"/>
    <xsl:variable name="postfix" select="local:get.label.postfix(., $crossref.ptr, $number)"/>
    <xsl:value-of select="string-join(($label[normalize-space()], concat($number, $postfix)), ' ')"/>
  </xsl:template>
  
  <xsl:function name="local:get.label.name">
    <xsl:param name="node"/>
    <xsl:param name="crossref.ptr"/>
    <xsl:variable name="rawLabel">
      <xsl:choose>
        <xsl:when test="$node/self::tei:div[@type eq 'appendix']">appendix</xsl:when>
        <xsl:when test="$node/self::tei:div"><xsl:if test="$crossref.ptr">section</xsl:if></xsl:when>
        <xsl:when test="$node/self::tei:figure[tei:graphic]">figure</xsl:when>
        <xsl:when test="$node/self::tei:figure[tei:eg|eg:egXML]">example</xsl:when>
        <xsl:otherwise><xsl:value-of select="$node/local-name()"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="contextLabel">
      <xsl:choose>
        <xsl:when test="not($crossref.ptr) or not($crossref.ptr/preceding-sibling::node()) or $crossref.ptr/preceding-sibling::node()[self::text()][not(ancestor::note)][normalize-space()][1][matches(., '[\.!?]\s*$')]">
          <xsl:value-of select="concat(upper-case(substring($rawLabel, 1, 1)), substring($rawLabel, 2))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rawLabel"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$contextLabel"/>
  </xsl:function>
  
  <xsl:function name="local:get.label.number">
    <xsl:param name="node"/>
    <xsl:choose>
      <xsl:when test="$node/self::tei:div[@type eq 'appendix']"><xsl:for-each select="$docRoot//tei:div[@type eq 'appendix'][deep-equal((@*|node()), $node/(@*|node()))]"><xsl:number count="tei:div[@type eq 'appendix'][tei:head]" level="multiple"/></xsl:for-each></xsl:when>
      <xsl:when test="$node/self::tei:div"><xsl:for-each select="$docRoot//tei:div[deep-equal((@*|node()), $node/(@*|node()))]"><xsl:number count="tei:div[tei:head]" level="multiple"/></xsl:for-each></xsl:when>
      <xsl:when test="$node/self::tei:figure[tei:graphic]"><xsl:for-each select="$docRoot//tei:figure[tei:graphic][deep-equal((@*|node()), $node/(@*|node()))]"><xsl:number count="tei:figure[tei:head[not(@type='license')]][tei:graphic]" level="any"/></xsl:for-each></xsl:when>
      <xsl:when test="$node/self::tei:figure[tei:eg|eg:egXML]"><xsl:for-each select="$docRoot//tei:figure[tei:eg|eg:egXML][deep-equal((@*|node()), $node/(@*|node()))]"><xsl:number count="tei:figure[tei:head[not(@type='license')]][tei:eg|eg:egXML]" level="any"/></xsl:for-each></xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$docRoot//*[deep-equal((@*|node()), $node/(@*|node()))]"><xsl:number count="*[name() eq $node/name()][tei:head]" level="any"/></xsl:for-each></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="local:get.label.postfix">
    <xsl:param name="node"/>
    <xsl:param name="crossref"/>
    <xsl:param name="number"/>
    <xsl:choose>
      <xsl:when test="$node/self::tei:div and not($crossref)">
        <xsl:value-of select="concat(if (not(contains($number, '.'))) then '.' else (), ' ')"/>
      </xsl:when>
      <xsl:when test="not($crossref)">
        <xsl:text>: </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="tei:body//tei:div/tei:p|tei:body/tei:p">
    <!-- a list-block looks like the best bet to get negative indent for paragraph numbers with FOP -->
    <fo:list-block>
      <fo:list-item>  
        <fo:list-item-label start-indent="-2em">
          <fo:block xsl:use-attribute-sets="pnr.properties" padding-top="2.5pt">
            <xsl:number count="tei:body//tei:div/tei:p|tei:body/tei:p" level="any"/>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body>
          <fo:block>
            <xsl:apply-templates/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </xsl:template>
  
  <xsl:template match="tei:p" priority="0">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- generate endnote pointer after subsequent punctuaton  -->
  <xsl:template match="tei:note">
    <xsl:variable name="nr">
      <xsl:number value="count(preceding::tei:note[if (current()/@place) then @place = current()/@place else not(@place)]|.)" format="{if (not(@place) or @place eq 'foot') then '1' else 'i'}"/>
    </xsl:variable>
    <!-- only 'pull' subsequent puntuation once (i.e. unless it is done for the preceding element) -->
    <xsl:if test="not(preceding-sibling::node()[normalize-space()][1][. intersect key('quotation.elements', local-name())])">
      <xsl:call-template name="include.punctuation"/>
    </xsl:if>
    <fo:inline font-size="5.4pt" vertical-align="super">
      <fo:basic-link internal-destination="note{$nr}" id="noteptr{$nr}">
        <xsl:value-of select="$nr"/>
      </fo:basic-link>
    </fo:inline>
  </xsl:template>

  <!-- group figure contents and headings in a block --> 
  <xsl:template match="tei:figure">
    <fo:block xsl:use-attribute-sets="block.spacing.properties">
      <xsl:for-each select="@xml:id">
        <xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
      </xsl:for-each>
      <fo:block xsl:use-attribute-sets="heading.lowerblock.properties">
        <xsl:apply-templates select="." mode="label"/>
        <xsl:apply-templates select="tei:head[not(@type='license')]/node()"/>
      </fo:block>
      <xsl:apply-templates select="*[not(self::tei:head)]"/>
      <xsl:for-each select="tei:head[@type eq 'license']">
        <fo:block xsl:use-attribute-sets="heading.lowerblock.properties">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:for-each>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:figure/tei:graphic">
    <fo:external-graphic content-width="scale-down-to-fit" content-height="scale-down-to-fit" inline-progression-dimension.maximum="80%" src="{resolve-uri(@url, base-uri())}"/>
  </xsl:template>
  
  <xsl:template match="eg:egXML">
    <fo:block xsl:use-attribute-sets="egXML.properties monospace.properties">
      <xsl:if test="not(parent::tei:figure)">
        <xsl:variable name="xslt.doc" select="doc('')"/>
        <xsl:for-each select="$xslt.doc//xsl:attribute-set[@name='block.spacing.properties']/*">
          <xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
<!--        
        <xsl:for-each select="$xslt.doc//xsl:attribute-set[@name='indentblock.properties']/*">
          <xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
-->      
      </xsl:if>
      <xsl:apply-templates select="node()" mode="egXML"/>
    </fo:block>
  </xsl:template>
  
  <!-- <eg> processing: borrowed from tei2odt, with a modification: strip accidental white-space -->
  <xsl:template match="tei:eg">
    <!-- try to determine accidental white-space (due to the XML formatting), and strip it from the <eg> lines -->
    <xsl:variable name="stripIndent" select="replace((text()[1][matches(., '^\s*\n(\s+)')], preceding::text()[not(normalize-space())][1])[1], '^\s*\n(\s+).*', '$1', 's')"/>
    <xsl:choose>
      <xsl:when test="parent::tei:figure">
        <fo:block xsl:use-attribute-sets="monospace.properties">
          <xsl:analyze-string select="." regex="\n">
            <xsl:matching-substring>
              <fo:block/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:analyze-string select="if (string-length($stripIndent) > 0) then replace(concat('@', .), concat('^@(', $stripIndent, ')?'), '', 's') else ." regex="\s">
                <xsl:matching-substring>
                  <xsl:text>&#160;</xsl:text>
                </xsl:matching-substring>
                <xsl:non-matching-substring><xsl:copy-of select="."/></xsl:non-matching-substring>
              </xsl:analyze-string>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline xsl:use-attribute-sets="monospace.properties"><xsl:apply-templates/></fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="egXML">
    <xsl:choose>
      <xsl:when test="node()">
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'start'"/>
        </xsl:call-template>
        <xsl:apply-templates select="node()" mode="egXML"/>
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'end'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="createTag">
          <xsl:with-param name="type" select="'empty'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="comment()|eg:comment" mode="egXML">
    <fo:block color="grey" start-indent="inherited-property-value(start-indent) +1em">
      <xsl:text>&lt;!--</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>--></xsl:text>
    </fo:block>
  </xsl:template>
  
  <!-- eg:egXML//text() processing: borrowed from tei2odt --> 
  <!--    Handling of whitespace is tricky within egXML. We basically want to preserve it,
    with some linebreaks, and try to indent helpfully if there were linebreaks in the original. -->
  <xsl:template match="text()[ancestor::eg:egXML]" mode="egXML">
    <xsl:variable name="container" select="parent::*"/>
    <xsl:variable name="currNode" select="."/>
    <xsl:analyze-string select="." regex="\n">
      <xsl:matching-substring>
        <fo:block/>
        <xsl:for-each select="$currNode/ancestor::*[not(descendant-or-self::eg:egXML)]"><xsl:text>&#160;</xsl:text></xsl:for-each>
        <xsl:if test="$currNode/following-sibling::node()"><xsl:text>&#160;</xsl:text></xsl:if>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:variable name="depth" select="count($currNode/ancestor::*[not(descendant-or-self::eg:egXML)])"/>
<!--
          <fo:inline start-indent="{$depth + 2}em" text-indent="{$depth + 2}em"><xsl:copy-of select="."/></fo:inline>
-->
        <xsl:copy-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template name="createTag">
    <xsl:param name="type"/>
    <xsl:variable name="parent-nss" select="../namespace::*"/>
    <xsl:variable name="isTop">
      <xsl:if
        test="parent::eg:egXML and (self::tei:TEI or parent::*/parent::tei:div[@type='example'])">
        <xsl:value-of select="'true'"/>
      </xsl:if>
    </xsl:variable>
    <fo:inline color="#01005F">
      <xsl:text>&lt;</xsl:text>
      <xsl:if test="$type = 'end'">
        <xsl:text>/</xsl:text>
      </xsl:if>
    </fo:inline>
    <fo:inline color="#1818B4">
      <xsl:value-of select="name()"/>
    </fo:inline>
    <xsl:if test="$type != 'end'">
      <xsl:for-each
        select="namespace::*">
        <xsl:variable name="ns-prefix" select="replace(name(), '_\d+$', '')"/>
        <xsl:variable name="ns-uri" select="string(.)"/>
        <xsl:if
          test="not($parent-nss[replace(name(), '_\d+$', '') = $ns-prefix and string(.) = $ns-uri]) or $isTop = 'true'">
          <!-- This namespace node doesn't exist on the parent, at least not with that URI, so we need to add a declaration. -->
          <fo:inline color="#189518">
            <xsl:text> xmlns</xsl:text>
            <xsl:if test="$ns-prefix != ''">
              <xsl:text>:</xsl:text>
              <xsl:value-of select="$ns-prefix"/>
            </xsl:if>
          </fo:inline>
          <xsl:text>="</xsl:text>
          <fo:inline color="#8B1410">
            <xsl:value-of select="$ns-uri"/>
          </fo:inline>
          <xsl:text>"</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="@*">
        <xsl:text> </xsl:text>
        <fo:inline color="#189518">
          <xsl:value-of select="name()"/>
        </fo:inline>
        <xsl:text>="</xsl:text>
        <xsl:if test=". != ''">
          <fo:inline color="#8B1410">
            <xsl:value-of select="."/>
          </fo:inline>
        </xsl:if>
        <xsl:text>"</xsl:text>
      </xsl:for-each>
    </xsl:if>
    <fo:inline color="#01005F">
      <xsl:if test="$type = 'empty'">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="tei:cit">
    <xsl:apply-templates select="tei:quote"/>
  </xsl:template>
  
  <xsl:template match="tei:cit[not(ancestor::tei:note)]/tei:quote">
    <xsl:call-template name="blockquote"/>
  </xsl:template>
    
  <xsl:template name="blockquote">
    <fo:block xsl:use-attribute-sets="indentedblock.properties">
      <xsl:choose>
        <xsl:when test="self::tei:quote">
          <xsl:apply-templates select="node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="."/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="ancestor::tei:cit[1]/*[not(self::tei:quote)]"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:cit[ancestor::tei:note]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- put parentheses around <bibl> or <ref> in <cit> -->
  <xsl:template match="tei:cit/tei:bibl|tei:cit/tei:ref" priority="1">
    <xsl:if test="not(ancestor::tei:note)">
      <fo:block/>
    </xsl:if>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:quote|tei:q">
    <xsl:variable name="quote.bool" select="if (not(parent::tei:cit) or ancestor::tei:note) then true() else false()"/>
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:if test="$quote.bool">
      <xsl:choose>
        <xsl:when test="$quoteLevel mod 2 = 1">
          <xsl:value-of select="$lsquo"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ldquo"/>          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:if test="$quote.bool">
      <xsl:choose>
        <xsl:when test="$quoteLevel mod 2 = 1">
          <xsl:value-of select="$rsquo"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rdquo"/>          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>  
  <!-- pull subsequent punctuation into generated quotation marks -->
  <xsl:template name="include.punctuation">
    <xsl:value-of select="following-sibling::node()[not(self::tei:note)][1]/self::text()[matches(., '^\s*[\p{P}-[:;\p{Ps}\p{Pe}]]')]/replace(., '^\s*([\p{P}-[\p{Ps}\p{Pe}]]+).*', '$1', 's')"/>
  </xsl:template>
  
  <xsl:template match="tei:quote//tei:supplied|tei:q//tei:supplied">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:quote//tei:gap|tei:q//tei:gap">
    <xsl:if test="preceding-sibling::node()[1]/self::text()[matches(., '[\S-[.]]$')]">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>…</xsl:text>
    <xsl:if test="following-sibling::node()[1]/self::text()[matches(., '^\S')]">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:quote/tei:p">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::tei:p"><fo:block/></xsl:if>
  </xsl:template>
  
  <!-- skip <p> inside inline lists -->
  <xsl:template match="tei:list[tokenize(@rend, '\s+') = 'inline']/tei:item/tei:p">
    <xsl:apply-templates/>
  </xsl:template>  
  
  <!-- replace external <ptr/> with link, whose label = @target -->
  <xsl:template match="tei:ptr[not(@type)]|tei:ref[not(@type)]">
    <fo:basic-link external-destination="{@target}" border="dotted thin grey">
      <xsl:value-of select="(normalize-space(),@target)[.][1]"/>
    </fo:basic-link>
  </xsl:template>
  
  <xsl:template match="tei:ptr[starts-with(@target, 'video:')]" priority="1">
    <fo:block>
      <xsl:value-of select="concat('[', @target, ']')"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:ptr[@type eq 'crossref']">
    <xsl:variable name="current" select="."/>
    <xsl:variable name="labels">
      <xsl:for-each select="tokenize(@target, '\s+')">
        <xsl:variable name="target" select="key('ids', substring-after(., '#'), $current/root())"/>
        <label type="{$target/name()}" n="{substring-after(current(), '#')}">
          <xsl:apply-templates select="$target" mode="label">
            <xsl:with-param name="crossref.ptr" select="$current"/>
          </xsl:apply-templates>
        </label>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each-group select="$labels/*" group-adjacent="@type">
      <xsl:variable name="counter.group" select="position()"/>
      <xsl:call-template name="enumerate"/>
      <xsl:for-each select="current-group()">
        <xsl:call-template name="enumerate"/>
        <xsl:choose>
          <xsl:when test="normalize-space()">
            <xsl:variable name="label.formatted">
              <xsl:choose>
                <xsl:when test="not(@type = preceding-sibling::*[1]/@type) and @type = following-sibling::*[1]/@type">
                  <xsl:value-of select="replace(., '^(\w+)', '$1s')"/>
                </xsl:when>
                <xsl:when test="@type = preceding-sibling::*[1]/@type">
                  <xsl:value-of select="normalize-space(replace(., '^(\w+)', ''))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <fo:basic-link internal-destination="{@n}" border="dotted thin grey">
              <xsl:value-of select="if ($counter.group = 1 and position() = 1) then $label.formatted else lower-case($label.formatted)"/>
            </fo:basic-link>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('[bad link to item: ', @n, ']')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="tei:ref[@type = ('crossref', 'bibl')]">
    <fo:basic-link internal-destination="{substring-after(@target, '#')}" border="dotted thin grey">
      <xsl:apply-templates/>
    </fo:basic-link>
  </xsl:template>
  
  <xsl:template match="tei:soCalled">
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$lsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ldquo"/>          
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$rsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rdquo"/>          
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:gi|tei:att|tei:val">
    <xsl:variable name="delimiters">
      <local:start>
        <xsl:choose>
          <xsl:when test="self::tei:gi">&lt;</xsl:when>
          <xsl:when test="self::tei:val">"</xsl:when>
          <xsl:when test="self::tei:att">@</xsl:when>
        </xsl:choose>
      </local:start>
      <local:end>
        <xsl:choose>
          <xsl:when test="self::tei:gi">&gt;</xsl:when>
          <xsl:when test="self::tei:val">"</xsl:when>
        </xsl:choose>
      </local:end>
    </xsl:variable>
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:apply-templates select="@*[not(name() = ('scheme'))]"/>
      <xsl:value-of select="$delimiters/local:start"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$delimiters/local:end"/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="tei:tag">
    <xsl:variable name="delimiters">
      <local:start>
        <xsl:choose>
          <xsl:when test="@type eq 'end'">&lt;/</xsl:when>
          <xsl:when test="@type eq 'pi'">&lt;?</xsl:when>
          <xsl:when test="@type eq 'comment'">&lt;!--</xsl:when>
          <xsl:when test="@type eq 'ms'">&lt;![CDATA[</xsl:when>
          <xsl:otherwise>&lt;</xsl:otherwise>
        </xsl:choose>
      </local:start>
      <local:end>
        <xsl:choose>
          <xsl:when test="@type eq 'pi'">?&gt;</xsl:when>
          <xsl:when test="@type eq 'comment'">--&gt;</xsl:when>
          <xsl:when test="@type eq 'ms'">]]&gt;</xsl:when>
          <xsl:when test="@type eq 'empty'">/&gt;</xsl:when>
          <xsl:otherwise>&gt;</xsl:otherwise>
        </xsl:choose>
      </local:end>
    </xsl:variable>
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:apply-templates select="@*[not(name() = ('scheme', 'type'))]"/>
      <xsl:value-of select="$delimiters/local:start"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$delimiters/local:end"/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="tei:code|tei:ident">
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="tei:emph|tei:mentioned|tei:term|tei:foreign">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <!-- only highlight //title[@level = ('m', 'j')] -->
  <xsl:template match="tei:title[@level = ('m', 'j')]">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="tei:title[@level = ('a', 'u')]">
    <xsl:variable name="quoteLevel" select="local:get.quoteLevel(.)"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$lsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ldquo"/>          
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:call-template name="include.punctuation"/>
    <xsl:choose>
      <xsl:when test="$quoteLevel mod 2 = 1">
        <xsl:value-of select="$rsquo"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rdquo"/>          
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:title[not(@level)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- untag bibliographical elements (except title or ref) in running text/notes: just process contents -->
  <xsl:template match="tei:bibl[not(ancestor::tei:div[@type='bibliography']|ancestor::tei:cit)]|tei:bibl[not(ancestor::tei:div[@type='bibliography'])]/*[not(self::tei:title or self::tei:ref or self::tei:ptr)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:text//tei:idno[not(parent::tei:bibl)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:list[tokenize(@rend, '\s+') = 'inline']">
    <xsl:variable name="rend" select="@rend"/>
    <xsl:variable name="type" select="@type"/>
    <xsl:for-each select="tei:item">
      <xsl:variable name="marker">
        <xsl:choose>
          <xsl:when test="$type eq 'gloss'">
            <xsl:value-of select="preceding-sibling::tei:label[1]"/>
          </xsl:when>
          <xsl:when test="tokenize($rend, '\s+') = 'ordered'">
            <xsl:text>(</xsl:text>
            <xsl:variable name="number"><xsl:number level="multiple" format="1.a"/></xsl:variable>
            <xsl:value-of select="replace($number, '\.', '')"/>
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:when test="tokenize($rend, '\s+') = 'bulleted'"><xsl:text>*</xsl:text></xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:variable>
      <fo:inline>
        <xsl:value-of select="$marker"/>
      </fo:inline>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::tei:item">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="tei:list">
    <xsl:variable name="maxLabelWidth" select="if (tokenize(@rend, '\s+') = 'ordered') then max(((count(ancestor::tei:list)) + 0.5, 2)) else 2"/>
    <xsl:apply-templates select="tei:head"/>
    <fo:list-block xsl:use-attribute-sets="block.spacing.properties" start-indent="from-parent(start-indent)" provisional-label-separation="{$maxLabelWidth}em" provisional-distance-between-starts="{$maxLabelWidth}em">
      <xsl:if test="not(ancestor::tei:list)">
        <xsl:attribute name="margin-left">1em</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::tei:head)]"/>
    </fo:list-block>
  </xsl:template>  
  
  <xsl:template match="tei:list/tei:head|tei:table/tei:head">
    <fo:block xsl:use-attribute-sets="heading.lowerblock.properties">
      <xsl:apply-templates select="parent::*" mode="label"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:list[not(@type='gloss')]/tei:item">
    <fo:list-item>
      <xsl:if test="not(tei:list)">
        <xsl:attribute name="keep-together.within-page">5</xsl:attribute>
      </xsl:if>
      <fo:list-item-label text-align="end" end-indent="label-end()">
        <fo:block>
          <xsl:choose>
            <xsl:when test="not(tokenize(parent::tei:list/@rend, '\s+') = 'ordered')">
              <xsl:variable name="depth" select="count(ancestor::tei:list[not(tokenize(@rend, '\s+') = 'ordered')])"/>
              <xsl:attribute name="font-family">DejaVu</xsl:attribute>
              <xsl:choose>
                <xsl:when test="$depth = 1">
                  <xsl:text>•</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 2">
                  <xsl:text>⚬</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 3">
                  <xsl:text>▪</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>–</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="nr"><xsl:number level="multiple" format="1.1.1.1.1"/></xsl:variable>
              <xsl:value-of select="$nr"/>
              <xsl:if test="string-length($nr) = 1">
                <xsl:text>.</xsl:text>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block><xsl:apply-templates/></fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  
  <xsl:template match="tei:list[@type='gloss']/tei:label">
    <fo:list-item space-before="1em" space-after="1em" keep-with-next="always">
      <fo:list-item-label><fo:block/></fo:list-item-label>
      <fo:list-item-body font-weight="bold">
        <fo:block><xsl:apply-templates/></fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="tei:list[@type='gloss']/tei:item">
    <fo:list-item>
      <xsl:if test="not(tei:list)">
        <xsl:attribute name="keep-together.within-page">5</xsl:attribute>
      </xsl:if>
      <fo:list-item-label><fo:block/></fo:list-item-label>
      <fo:list-item-body margin-left="2em">
        <fo:block><xsl:apply-templates/></fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  
  <xsl:template match="tei:table">
    <fo:block xsl:use-attribute-sets="block.spacing.properties">
      <xsl:apply-templates select="tei:head"/>
      <fo:table id="{(@xml:id, generate-id())[1]}" xsl:use-attribute-sets="table.properties">
        <xsl:variable name="numCols" select="sum(for $c in descendant::tei:row[1]/tei:cell return if ($c/@cols) then xs:integer($c/@cols) else 1)"/>
        <xsl:for-each select="1 to $numCols">
          <fo:table-column column-number="{position()}"/>
        </xsl:for-each>
        <fo:table-body>
          <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:row">
    <fo:table-row xsl:use-attribute-sets="table.properties">
      <xsl:if test="@role = 'label'">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>
  
  <xsl:template match="tei:cell">
    <fo:table-cell xsl:use-attribute-sets="table.properties cell.properties">    
      <xsl:for-each select="@cols">
        <xsl:attribute name="number-columns-spanned"><xsl:value-of select="."/></xsl:attribute>
      </xsl:for-each>
      <xsl:for-each select="@rows">
        <xsl:attribute name="number-rows-spanned"><xsl:value-of select="."/></xsl:attribute>
      </xsl:for-each>
      <xsl:if test="(self::*|parent::tei:row)/@role = 'label'">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
      </xsl:if>
      <fo:block><xsl:apply-templates/></fo:block>      
    </fo:table-cell>
  </xsl:template>  
  
  <!-- ==== -->
  <!-- back -->
  <!-- ==== -->
  
  <xsl:template match="tei:div[@type= ('bibliography', 'abstract')]">
    <fo:block xsl:use-attribute-sets="back.font.properties">
      <fo:block xsl:use-attribute-sets="heading.properties">
        <xsl:value-of select="@type"/>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="appendixes">
    <xsl:if test=".//tei:back/tei:div[@type='appendix']">
      <fo:block xsl:use-attribute-sets="back.font.properties">
        <fo:block xsl:use-attribute-sets="heading.properties">
          <xsl:text>Appendixes</xsl:text>
        </fo:block>
        <xsl:apply-templates select=".//tei:back/tei:div[@type='appendix']"/>
      </fo:block>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader/tei:profileDesc/tei:textClass">
    <fo:block xsl:use-attribute-sets="back.font.properties">
      <fo:block xsl:use-attribute-sets="heading.properties">
        <xsl:text>Index</xsl:text>
      </fo:block>
      <fo:block>
        <fo:inline font-family="Roboto" font-size="9pt" font-weight="bold">
          <xsl:text>Keywords: </xsl:text>
        </fo:inline>
        <xsl:value-of select="string-join(tei:keywords/tei:term, ', ')"/>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="authors">
    <fo:block xsl:use-attribute-sets="back.font.properties">
      <fo:block xsl:use-attribute-sets="heading.properties">
        <xsl:text>Authors</xsl:text>
      </fo:block>
      <fo:block>
        <xsl:for-each select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
          <fo:block xsl:use-attribute-sets="heading.body.properties" font-size="9pt" text-transform="uppercase">
            <xsl:value-of select="string-join(tei:name/(tei:forename, tei:surname), ' ')"/>
          </fo:block> 
          <fo:block>
            <xsl:apply-templates select="tei:affiliation"/>
          </fo:block>
        </xsl:for-each>
      </fo:block>
    </fo:block>
  </xsl:template>  
    
  <xsl:template match="tei:listBibl/tei:head">
    <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
    <xsl:variable name="font-size">
      <xsl:choose>
        <xsl:when test="$depth &lt;= 1">15</xsl:when>
        <xsl:when test="$depth = 2">12</xsl:when>
        <xsl:when test="$depth = 3">10</xsl:when>
        <xsl:otherwise>8</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block xsl:use-attribute-sets="heading.body.properties" font-size="{$font-size}pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <!-- untag all other <bibl> contents (except for <ref>) -->
  <xsl:template match="tei:listBibl//tei:bibl/*[not(self::tei:ref or self::tei:ptr or self::tei:hi)]" priority="0">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- check if author(ing instance/s) are the same as for preceding bibliographical entry -->
  <xsl:template match="tei:listBibl//tei:bibl">
    <xsl:variable name="dateOrTitle" select="(tei:date|tei:title)[1]"/>
    <fo:block id="{@xml:id}" start-indent="2em" text-indent="-2em">
      <xsl:call-template name="getAuthorInstance">
        <xsl:with-param name="dateOrTitle" select="$dateOrTitle"/>
      </xsl:call-template>
      <xsl:apply-templates select="$dateOrTitle|node()[. >> $dateOrTitle]"/>
    </fo:block>
  </xsl:template>
  
  <!-- copy author(ing instance/s) if they're different from those of the preceding bibliographical 
       entry; replace with ——— otherwise -->
  <xsl:template name="getAuthorInstance">
    <xsl:param name="dateOrTitle"/>
    <xsl:variable name="authorInstance.current" select="node()[. &lt;&lt; $dateOrTitle]"/>
    <xsl:variable name="bibl.prev" select="preceding-sibling::*[1]/self::tei:bibl"/>
    <xsl:variable name="authorInstance.prev" select="preceding-sibling::*[1]/self::tei:bibl/node()[. &lt;&lt; $bibl.prev/(tei:date|tei:title)[1]]"/>
    <xsl:choose>
      <xsl:when test="$bibl.prev and (local:authors.serialize($authorInstance.current/self::*) = local:authors.serialize($authorInstance.prev/self::*))">
        <xsl:text>———. </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$authorInstance.current"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- serialize author(ing instance/s) to {$elementName}|{normalize-space()} -->
  <xsl:function name="local:authors.serialize" as="xs:string?">
    <xsl:param name="nodes" as="element()*"/>
    <xsl:variable name="personList" select="for $e in $nodes return $e"/>
    <xsl:value-of select="normalize-space(string-join($personList/concat(local-name(), '|', normalize-space(.)), ' '))"/>
  </xsl:function>

  <xsl:template name="endnotes">
    <fo:block>
      <fo:block xsl:use-attribute-sets="heading.properties">
        <xsl:text>Notes</xsl:text>
      </fo:block>
      <xsl:apply-templates select=".//tei:text//tei:note" mode="endnotes"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:note" mode="endnotes">
    <xsl:variable name="nr">
      <xsl:number value="count(preceding::tei:note[if (current()/@place) then @place = current()/@place else not(@place)]|.)" format="{if (not(@place) or @place eq 'foot') then '1' else 'i'}"/>
    </xsl:variable>
    <fo:block>
      <fo:inline font-weight="bold" height="100%">
        <fo:basic-link internal-destination="noteptr{$nr}" id="note{$nr}" space-end="1em">
          <xsl:value-of select="$nr"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="tei:note/tei:p">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::tei:p">
      <fo:block/>
    </xsl:if>
  </xsl:template>
  
  <!-- text() following an element for which smart quotes are being generated: skip starting punctuation (this is pulled into the quotation marks) -->
  <xsl:template match="text()[matches(., '^\s*[\p{P}-[:;\p{Ps}\p{Pe}]]')]
    [preceding-sibling::node()[not(self::tei:note)][1]
    [. intersect key('quotation.elements', local-name())]]
    |
    text()[matches(., '^\s*[\p{P}-[\p{Ps}\p{Pe}]]')]
    [preceding-sibling::node()[1][self::tei:note]]">
    <xsl:value-of select="replace(., '^(\s*)[\p{P}-[\p{Ps}\p{Pe}]]+', '$1', 's')"/>
  </xsl:template>

  <xsl:function name="local:get.quoteLevel">
    <xsl:param name="current"/>
    <xsl:value-of select="count($current/ancestor::*[. intersect key('quotation.elements', local-name())])"/>
  </xsl:function>
  
  <xsl:template name="enumerate">
    <xsl:if test="position() > 1 and last() > 2">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:if test="position() > 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="position() > 1 and position() = last()">
      <xsl:text>and </xsl:text>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
