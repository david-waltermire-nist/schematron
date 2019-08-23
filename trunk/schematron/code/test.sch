<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="http://www.w3.org/2005/xpath-functions" prefix="js"/>

    <sch:pattern>
        <sch:rule context="js:array[@key='controls']/js:map">
            <sch:report test="js:string[@key='id']"><sch:value-of select="js:string[@key='id']/text()"/></sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>