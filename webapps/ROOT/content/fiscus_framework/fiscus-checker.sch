<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.ascc.net/xml/schematron" xmlns:t="http://www.tei-c.org/ns/1.0">
    <ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>
    <pattern name="Test names not to be empty">
        <rule context="//t:placeName[not(@type='other')][ancestor::t:listPlace[@type='places']]">
            <report test=".=''">one or more place names are empty</report>
        </rule>
        <rule context="//t:geogName[not(@type='other')][ancestor::t:listPlace[@type='estates']]">
            <report test=".=''">one or more estates names are empty</report>
        </rule>
        <rule context="//t:orgName[not(@type='other')][ancestor::t:listOrg]">
            <report test=".=''">one or more juridical person names are empty</report>
        </rule>
        <rule context="//t:persName[not(@type='other')][ancestor::t:listPerson]">
            <report test=".=''">one or more person names are empty</report>
        </rule>
    </pattern>
    <pattern name="Test presence of main name">
        <rule context="//t:place[ancestor::t:listPlace[@type='places']]">
            <report test="not(descendant::t:placeName[not(@type='other')][.//text()])">one or more places are without (main) name</report>
        </rule>
        <rule context="//t:place[ancestor::t:listPlace[@type='estates']]">
            <report test="not(descendant::t:geogName[not(@type='other')][.//text()])">one or more estates are without (main) name</report>
        </rule>
        <rule context="//t:org[ancestor::t:listOrg]">
            <report test="not(descendant::t:orgName[not(@type='other')][.//text()])">one or more juridical persons are without (main) name</report>
        </rule>
        <rule context="//t:person[ancestor::t:listPerson]">
            <report test="not(descendant::t:persName[not(@type='other')][.//text()])">one or more persons are without (main) name</report>
        </rule>
    </pattern>
    <pattern name="Test idno to be in the correct form">
        <rule context="//t:idno[ancestor::t:listPlace[@type='places']]">
            <report test="not(starts-with(.,'places/'))">one or more places ID are not starting with 'places/'</report>
            <report test="contains(substring-after(., 'places/'), ' ')">one or more places ID contain extra spaces</report>
            <report test="substring-after(., '/')=''">one or more places ID are emtpy</report>
        </rule>
        <rule context="//t:idno[ancestor::t:listPlace[@type='estates']]">
            <report test="not(starts-with(.,'estates/'))">one or more estates ID are not starting with 'estates/'</report>
            <report test="contains(substring-after(., 'estates/'), ' ')">one or more estates ID contain extra spaces</report>
            <report test="substring-after(., '/')=''">one or more estates ID are emtpy</report>
        </rule>
        <rule context="//t:idno[ancestor::t:listOrg]">
            <report test="not(starts-with(.,'juridical_persons/'))">one or more juridical persons ID are not starting with 'juridical_persons/'</report>
            <report test="contains(substring-after(., 'juridical_persons/'), ' ')">one or more juridical persons ID contain extra spaces</report>
            <report test="substring-after(., '/')=''">one or more juridical persons ID are emtpy</report>
        </rule>
        <rule context="//t:idno[ancestor::t:listPerson]">
            <report test="not(starts-with(.,'people/'))">one or more persons ID are not starting with 'people/'</report>
            <report test="contains(substring-after(., 'people/'), ' ')">one or more persons ID contain extra spaces</report>
            <report test="substring-after(., '/')=''">one or more persons ID are emtpy</report>
        </rule>
    </pattern>
    
    <pattern name="Test idno to be unique">
        <rule context="//t:place[ancestor::t:listPlace[@type='places']]">
            <report test="t:idno/text()=following-sibling::t:place/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=preceding-sibling::t:place/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPlace/following-sibling::t:listPlace//t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPlace/preceding-sibling::t:listPlace//t:idno/text()">one or more ID have duplicates</report>
        </rule>
        <rule context="//t:place[ancestor::t:listPlace[@type='estates']]">
            <report test="t:idno/text()=following-sibling::t:place/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=preceding-sibling::t:place/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPlace/following-sibling::t:listPlace//t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPlace/preceding-sibling::t:listPlace//t:idno/text()">one or more ID have duplicates</report>
        </rule>
        <rule context="//t:org[ancestor::t:listOrg]">
            <report test="t:idno/text()=following-sibling::t:org/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=preceding-sibling::t:org/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listOrg/following-sibling::t:listOrg//t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listOrg/preceding-sibling::t:listOrg//t:idno/text()">one or more ID have duplicates</report>
        </rule>
        <rule context="//t:person[ancestor::t:listPerson]">
            <report test="t:idno/text()=following-sibling::t:person/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=preceding-sibling::t:person/t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPerson/following-sibling::t:listPerson//t:idno/text()">one or more ID have duplicates</report>
            <report test="t:idno/text()=parent::t:listPerson/preceding-sibling::t:listPerson//t:idno/text()">one or more ID have duplicates</report>
        </rule>
    </pattern>
</schema>
