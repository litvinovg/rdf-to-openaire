<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#"
	xmlns:vivo="http://vivoweb.org/ontology/core#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:res="http://vivoweb.org/rdf-functions"
	xmlns:obo="http://purl.obolibrary.org/obo/"
	xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#"
	xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
	xmlns="https://www.openaire.eu/cerif-profile/1.2/"
	exclude-result-prefixes="geo"
	>

	<xsl:output method="xml" indent="yes" encoding="UTF-8" />

	<xsl:function name="res:id">
		<xsl:param name="cur_elements" as="node()*" />
		<xsl:for-each select="$cur_elements[self::*]">
			<xsl:choose>
				<xsl:when test="./@rdf:resource">
					<xsl:sequence select="./@rdf:resource" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="./*/@rdf:about" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	
	<xsl:function name="res:types">
		<xsl:param name="cur_elements" as="node()*" />
		<xsl:for-each select="$cur_elements[self::*]">
			<xsl:sequence select="res:id(./rdf:type)" />
			<xsl:sequence select="concat(namespace-uri(),local-name())" />
		</xsl:for-each>
	</xsl:function>

	<xsl:function name="res:get" as="node()*">
		<xsl:param name="cur_elements" as="node()*" />
		<xsl:for-each select="$cur_elements[self::*]">
			<xsl:choose>
				<xsl:when test="./@rdf:resource">
					<xsl:variable name="resource_uri"
						select="./@rdf:resource" />
					<xsl:sequence
						select="fn:root(current())//*[@rdf:about = $resource_uri]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="./*" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>

	<xsl:function name="res:distinct" as="node()*">
		<xsl:param name="cur_elements" as="node()*" />
		<xsl:for-each
			select="distinct-values($cur_elements[self::*]/@rdf:about)">
			<xsl:variable name="resource_uri" select="." />
			<xsl:sequence
				select="($cur_elements[@rdf:about = $resource_uri])[1]" />
		</xsl:for-each>
	</xsl:function>

	<xsl:template match="/">
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Person']">
			<xsl:call-template name="person" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF OrgUnit']">
			<xsl:call-template name="orgUnit" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Publication']">
			<xsl:call-template name="publication" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Event']">
			<xsl:call-template name="event" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Product']">
			<xsl:call-template name="product" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Funding']">
			<xsl:call-template name="funding" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Patent']">
			<xsl:call-template name="patent" />
		</xsl:for-each>
		<xsl:for-each
			select="//*[rdfs:comment/text() = 'CERIF Equipment']">
			<xsl:call-template name="equipment" />
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="person">
		<Person>
			<xsl:attribute name="id">
                     <xsl:value-of select="@rdf:about" />
                 </xsl:attribute>
			<xsl:call-template name="personName" />
			<xsl:call-template name="orcid" />
			<xsl:call-template name="scopusId" />
			<xsl:call-template name="researcherId" />
			<xsl:call-template name="email" />
			<xsl:call-template name="telephone" />
			<xsl:call-template name="electronicAddressUrl" />
			<xsl:call-template name="affiliation" />
		</Person>
	</xsl:template>

	<xsl:template name="publication">
		<Publication>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
			<xsl:call-template name="publicationType" />
			<xsl:call-template name="title" />
			<xsl:call-template name="nameAbbreviation" />
			<xsl:call-template name="volume" />
			<xsl:call-template name="issue" />
			<xsl:call-template name="edition" />
			<xsl:call-template name="startPage" />
			<xsl:call-template name="endPage" />
			<xsl:call-template name="doi" />
			<xsl:call-template name="issn" />
			<xsl:call-template name="isbn" />
			<xsl:call-template name="subject" />
			<xsl:call-template name="keyword" />
			<xsl:call-template name="abstract" />
		</Publication>
	</xsl:template>

	<xsl:template name="orgUnit">
		<OrgUnit>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
			<xsl:call-template name="orgType" />
			<xsl:call-template name="name" />
			<xsl:call-template name="acronym" />
			<xsl:call-template name="electronicAddressUrl" />
		</OrgUnit>
	</xsl:template>

	<xsl:template name="patent">
		<Patent>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
            <xsl:call-template name="patentType" />
		</Patent>
	</xsl:template>

	<xsl:template name="funding">
		<Funding>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
            <xsl:call-template name="fundingType" />
		</Funding>
	</xsl:template>

	<xsl:template name="event">
		<Event>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
            <xsl:call-template name="eventType" />
            <xsl:call-template name="name" />
            <xsl:call-template name="acronym" />
            <xsl:call-template name="countryCode" />
		</Event>
	</xsl:template>
	
	<xsl:template name="equipment">
		<Equipment>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
            <xsl:call-template name="name" />
		</Equipment>
	</xsl:template>

	<xsl:template name="product">
		<Product>
			<xsl:attribute name="id">
                <xsl:value-of select="@rdf:about" />
            </xsl:attribute>
            <xsl:call-template name="productType" />
            <xsl:call-template name="name" />
            <xsl:call-template name="url" />
            <xsl:call-template name="description" />
		</Product>
	</xsl:template>

	<xsl:template name="volume">
		<xsl:if test="bibo:volume">
			<Volume>
				<xsl:value-of select="bibo:volume[1]/text()" />
			</Volume>
		</xsl:if>
	</xsl:template>

	<xsl:template name="issue">
		<xsl:if test="bibo:issue">
			<Issue>
				<xsl:value-of select="bibo:issue[1]/text()" />
			</Issue>
		</xsl:if>
	</xsl:template>

	<xsl:template name="edition">
		<xsl:if test="bibo:edition">
			<Edition>
				<xsl:value-of select="bibo:edition[1]/text()" />
			</Edition>
		</xsl:if>
	</xsl:template>

	<xsl:template name="startPage">
		<xsl:if test="bibo:pageStart">
			<StartPage>
				<xsl:value-of select="bibo:pageStart[1]/text()" />
			</StartPage>
		</xsl:if>
	</xsl:template>

	<xsl:template name="endPage">
		<xsl:if test="bibo:pageEnd">
			<EndPage>
				<xsl:value-of select="bibo:pageEnd[1]/text()" />
			</EndPage>
		</xsl:if>
	</xsl:template>

	<xsl:template name="doi">
		<xsl:if test="bibo:doi">
			<DOI>
				<xsl:value-of select="bibo:doi[1]/text()" />
			</DOI>
		</xsl:if>
	</xsl:template>

	<xsl:template name="isbn">
		<xsl:for-each select="bibo:isbn10|bibo:isbn13">
			<ISBN>
				<xsl:value-of select="text()" />
			</ISBN>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="issn">
		<xsl:for-each select="bibo:issn">
			<ISSN>
				<xsl:value-of select="text()" />
			</ISSN>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="subject">
		<xsl:for-each select="res:get(vivo:hasSubjectArea)">
			<Subject>
				<xsl:attribute name="id">
	                <xsl:value-of select="@rdf:about" />
	            </xsl:attribute>
				<xsl:value-of select="text()" />
			</Subject>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="keyword">
		<xsl:for-each select="vivo:freetextKeyword">
			<xsl:variable name="lang" select="@xml:lang" /> 
			<xsl:for-each select="tokenize(text(), ',')">
				<Keyword>
					<xsl:attribute name="xml:lang">
		                <xsl:value-of select="$lang" />
		            </xsl:attribute>
					<xsl:value-of select="normalize-space(.)" />
				</Keyword>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="abstract">
		<xsl:for-each select="bibo:abstract">
			<Abstract>
				<xsl:attribute name="xml:lang">
	                <xsl:value-of select="@xml:lang" />
	            </xsl:attribute>
				<xsl:value-of select="text()" />
			</Abstract>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="description">
		<xsl:for-each select="bibo:abstract">
			<Description>
				<xsl:attribute name="xml:lang">
	                <xsl:value-of select="@xml:lang" />
	            </xsl:attribute>
				<xsl:value-of select="text()" />
			</Description>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="publicationType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type xmlns="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types">
			<xsl:choose>
 				<xsl:when test="$types = 'http://purl.obolibrary.org/obo/IAO_0000013'">
					<xsl:text>http://purl.org/coar/resource_type/c_6501</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Article'">
					<xsl:text>http://purl.org/coar/resource_type/c_18cf</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#BlogPosting'">
					<xsl:text>http://purl.org/coar/resource_type/c_6947</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#ConferencePaper'">
					<xsl:text>http://purl.org/coar/resource_type/c_5794</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#EditorialArticle'">
					<xsl:text>http://purl.org/coar/resource_type/c_b239</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Review'">
					<xsl:text>http://purl.org/coar/resource_type/c_efa0</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Book'">
					<xsl:text>http://purl.org/coar/resource_type/c_2f33</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Chapter'">
					<xsl:text>http://purl.org/coar/resource_type/c_3248</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/spar/fabio/Comment'">
					<xsl:text>http://purl.org/coar/resource_type/D97F-VB57</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#ConferencePoster'">
					<xsl:text>http://purl.org/coar/resource_type/c_6670</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Manuscript'">
					<xsl:text>http://purl.org/coar/resource_type/c_0040</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Letter'">
					<xsl:text>http://purl.org/coar/resource_type/c_0857</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.obolibrary.org/obo/OBI_0000272'">
					<xsl:text>http://purl.org/coar/resource_type/YZ1N-ZFT9</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Report'">
					<xsl:text>http://purl.org/coar/resource_type/c_93fc</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#ResearchProposal'">
					<xsl:text>http://purl.org/coar/resource_type/c_baaf</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Speech'">
					<xsl:text>http://purl.org/coar/resource_type/6NC7-GK9S</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Thesis'">
					<xsl:text>http://purl.org/coar/resource_type/c_46ec</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#WorkingPaper'">
					<xsl:text>http://purl.org/coar/resource_type/c_8042</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Journal'">
					<xsl:text>http://purl.org/coar/resource_type/c_0640</xsl:text>
				</xsl:when>
			</xsl:choose>
		</Type>
	</xsl:template>

	<xsl:template name="fundingType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type xmlns="https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types">
			<xsl:choose>
 				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Grant'">
					<xsl:text>https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Grant</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Award'">
					<xsl:text>https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Award</xsl:text>
				</xsl:when>
			</xsl:choose>
		</Type>
	</xsl:template>

	<xsl:template name="patentType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type xmlns="https://www.openaire.eu/cerif-profile/vocab/COAR_Patent_Types">
			<xsl:text>http://purl.org/coar/resource_type/c_15cd</xsl:text>
		</Type>
	</xsl:template>

	<xsl:template name="eventType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type xmlns="https://w3id.org/cerif/vocab/EventTypes">
			<xsl:choose>
 				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Conference'">
					<xsl:text>https://w3id.org/cerif/vocab/EventTypes#Conference</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Workshop'">
					<xsl:text>https://w3id.org/cerif/vocab/EventTypes#Workshop</xsl:text>
				</xsl:when>
 				<xsl:otherwise>
					<xsl:text>https://w3id.org/cerif/model#Event</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</Type>
	</xsl:template>

	<xsl:template name="productType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type xmlns="https://www.openaire.eu/cerif-profile/vocab/COAR_Product_Types">
			<xsl:choose>
 				<xsl:when test="$types = 'http://purl.org/ontology/bibo/AudioVisualDocument'">
					<xsl:text>http://purl.org/coar/resource_type/c_18cc</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Video'">
					<xsl:text>http://purl.org/coar/resource_type/c_12ce</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#CaseStudy'">
					<xsl:text>http://purl.org/coar/resource_type/c_e059</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Dataset'">
					<xsl:text>http://purl.org/coar/resource_type/c_ddb1</xsl:text>
				</xsl:when>
 				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Image'">
					<xsl:text>http://purl.org/coar/resource_type/c_c513</xsl:text>
				</xsl:when>
 				<xsl:when test="$types = 'http://purl.org/ontology/bibo/Map'">
					<xsl:text>http://purl.org/coar/resource_type/c_12cd</xsl:text>
				</xsl:when>
 				<xsl:otherwise>
					<xsl:text>https://w3id.org/cerif/model#ResultProduct</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</Type>
	</xsl:template>

	<xsl:template name="orgType">
		<xsl:variable name="types" select="res:types(.)" /> 
		<Type scheme="https://w3id.org/cerif/vocab/OrganisationTypes">
			<xsl:choose>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#University'">
					<xsl:text>https://w3id.org/cerif/vocab/OrganisationTypes#University</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#ClinicalOrganization'">
					<xsl:text>https://w3id.org/cerif/vocab/OrganisationTypes#NationalHealthService</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Company'">
					<xsl:text>https://w3id.org/cerif/vocab/OrganisationTypes#Company</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#GovernmentAgency'">
					<xsl:text>https://w3id.org/cerif/vocab/OrganisationTypes#Government</xsl:text>
				</xsl:when>
				<xsl:when test="$types = 'http://vivoweb.org/ontology/core#Hospital'">
					<xsl:text>https://w3id.org/cerif/vocab/OrganisationTypes#NationalHealthService</xsl:text>
				</xsl:when>
 				<xsl:otherwise>
					<xsl:text>https://w3id.org/cerif/model#OrganisationUnit</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</Type>
	</xsl:template>

	<xsl:template name="name">
		<xsl:for-each select="rdfs:label">
			<Name>
				<xsl:if test="@xml:lang">
					<xsl:attribute name="xml:lang">
                    	<xsl:value-of select="@xml:lang" />
                    </xsl:attribute>
				</xsl:if>
				<xsl:value-of select="text()" />
			</Name>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="title">
		<xsl:for-each select="rdfs:label">
			<Title>
				<xsl:if test="@xml:lang">
					<xsl:attribute name="xml:lang">
                    	<xsl:value-of select="@xml:lang" />
                    </xsl:attribute>
				</xsl:if>
				<xsl:value-of select="text()" />
			</Title>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="personName">
		<xsl:for-each
			select="res:get(res:get(obo:ARG_2000028)/vcard:hasName)[1]">
			<PersonName>
				<xsl:for-each select="vcard:familyName[1]">
					<FamilyNames>
						<xsl:value-of select="text()" />
					</FamilyNames>
				</xsl:for-each>
				<xsl:for-each select="vcard:givenName[1]">
					<FirstNames>
						<xsl:value-of select="text()" />
					</FirstNames>
				</xsl:for-each>
				<xsl:for-each select="vivo:middleName[1]">
					<OtherNames>
						<xsl:value-of select="text()" />
					</OtherNames>
				</xsl:for-each>
			</PersonName>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="orcid">
		<xsl:for-each select="res:id(vivo:orcidId)">
			<ORCID>
				<xsl:value-of select="." />
			</ORCID>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="countryCode">
		<xsl:for-each select="res:get(obo:RO_0001025)/geo:codeISO2">
			<CountryCode>
                <xsl:value-of select="text()" />
			</CountryCode>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="scopusId">
		<xsl:for-each select="vivo:scopusId">
			<ScopusAuthorID>
				<xsl:value-of select="text()" />
			</ScopusAuthorID>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="researcherId">
		<xsl:for-each select="vivo:researcherId">
			<ResearcherID>
				<xsl:value-of select="text()" />
			</ResearcherID>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="affiliation">
		<xsl:for-each
			select="res:distinct(res:get(res:get(obo:RO_0000053)/vivo:roleContributesTo))">
			<Affiliation>
				<OrgUnit>
					<xsl:attribute name="id">
                    	<xsl:value-of
						select="@rdf:about" />
                 	</xsl:attribute>
					<xsl:call-template name="acronym" />
				</OrgUnit>
			</Affiliation>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="acronym">
		<xsl:for-each select="vivo:abbreviation">
			<Acronym>
				<xsl:value-of select="." />
			</Acronym>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="nameAbbreviation">
		<xsl:for-each select="vivo:abbreviation">
			<NameAbbreviation>
				<xsl:value-of select="." />
			</NameAbbreviation>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="email">
		<xsl:for-each
			select="res:distinct(res:get(res:get(obo:ARG_2000028)/vcard:hasEmail))">
			<ElectronicAddress>
				<xsl:value-of
					select="concat('mailto:',vcard:email/text())" />
			</ElectronicAddress>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="electronicAddressUrl">
		<xsl:for-each
			select="res:distinct(res:get(res:get(obo:ARG_2000028)/vcard:hasURL))">
			<ElectronicAddress>
				<xsl:value-of select="vcard:url/text()" />
			</ElectronicAddress>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="url">
		<xsl:for-each
			select="res:distinct(res:get(res:get(obo:ARG_2000028)/vcard:hasURL))[1]">
			<URL>
				<xsl:value-of select="vcard:url/text()" />
			</URL>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="telephone">
		<xsl:for-each
			select="res:distinct(res:get(res:get(obo:ARG_2000028)/vcard:hasTelephone))">
			<xsl:choose>
				<xsl:when
					test="res:id(vitro:mostSpecificType) = 'http://www.w3.org/2006/vcard/ns#Fax'">
					<ElectronicAddress>
						<xsl:value-of
							select="concat('fax:',vcard:telephone/text())" />
					</ElectronicAddress>
				</xsl:when>
				<xsl:otherwise>
					<ElectronicAddress>
						<xsl:value-of
							select="concat('tel:',vcard:telephone/text())" />
					</ElectronicAddress>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>


</xsl:stylesheet>
