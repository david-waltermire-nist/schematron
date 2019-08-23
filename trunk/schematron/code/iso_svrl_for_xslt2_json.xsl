<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron"
    xmlns:json="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:import href="iso_svrl_for_xslt2.xsl"/>

    <!-- Overrides skeleton.xsl -->
    <xsl:template name="handle-root" >
        <xsl:text>&#10;&#10;</xsl:text><xsl:comment>JSON SETUP</xsl:comment><xsl:text>&#10;</xsl:text>
        <!-- Process the top-level element -->
        <axsl:param name="json-file" as="xs:string?"/>
        
        <axsl:variable name="json-xml" select="unparsed-text($json-file) ! json-to-xml(.)"/>
        
        <axsl:template name="xsl:initial-template">
            <axsl:apply-templates select="$json-xml"/>
        </axsl:template>

        <axsl:template match="/">
            <xsl:call-template name="process-root">
                <xsl:with-param 	
                    name="title" select="(@id | iso:title)[last()]"/>
                <xsl:with-param name="version" select="'iso'" />
                <xsl:with-param name="schemaVersion" select="@schemaVersion" />
                <xsl:with-param name="queryBinding" select="@queryBinding" />
                <xsl:with-param name="contents">
                    <xsl:apply-templates mode="do-all-patterns"/>
                </xsl:with-param>
                
                <!-- "Rich" properties -->
                <xsl:with-param name="fpi" select="@fpi"/>
                <xsl:with-param name="icon" select="@icon"/>
                <xsl:with-param name="id" select="@id"/>
                <xsl:with-param name="lang" select="@xml:lang"/>
                <xsl:with-param name="see" select="@see" />
                <xsl:with-param name="space" select="@xml:space" />
            </xsl:call-template>
        </axsl:template>
    </xsl:template>
    
    <xsl:template name="generate-default-rules">
        <axsl:template match="*" mode="schematron-select-full-path">
            <axsl:apply-templates select="." mode="schematron-get-full-path"/>
        </axsl:template>

        <axsl:template match="*" mode="schematron-get-full-path">
            <axsl:choose>
                <axsl:when test="parent::*">
                    <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
                    <axsl:if test="parent::json:array">
                        <axsl:text>[</axsl:text><axsl:value-of select="count(preceding-sibling::*)+1"/><axsl:text>]</axsl:text>
                    </axsl:if>
                    <axsl:if test="@key">
                        <axsl:text>/</axsl:text>
                        <axsl:value-of select="@key"/>
                    </axsl:if>
                </axsl:when>
                <axsl:otherwise>
                    <axsl:text>/JSON</axsl:text>
                </axsl:otherwise>
            </axsl:choose>
        </axsl:template>
    </xsl:template>
</xsl:stylesheet>