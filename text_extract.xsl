<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mm100="urn:oio:medcom:municipality:1.0.0"
    xmlns:mm104="urn:oio:medcom:municipality:1.0.4"
    xmlns:xdis="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2006/07/01/"
    exclude-result-prefixes="xs mm100 mm104" version="1.0">

    <xsl:template mode="text" match="mm104:GPCCReceiver">
        <xdis:Bold>Kopimodtagere</xdis:Bold>
        <xdis:Break/>
        <xsl:text>Kopi til egen læge: </xsl:text>
        <xsl:apply-templates mode="text" select="*"/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:Deselected">
        <xsl:text>Fravalgt</xsl:text>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:CCReceiver | mm104:ResultReceiver | mm104:Location">
        <xsl:text>EAN: </xsl:text>
        <xsl:value-of select="mm100:EANIdentifier"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="mm104:IdentifierCode"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="mm100:Identifier"/>
        <xsl:for-each
            select="mm100:OrganisationName | mm100:DepartmentName | mm100:UnitName | mm100:StreetName | mm100:SuburbName">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="mm100:District | mm100:PostCodeIdentifier">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="mm100:PostCodeIdentifier"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="mm100:DistrictName"/>
        </xsl:if>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:SignedBy | mm104:CoWriter">
        <xsl:value-of select="mm104:PersonGivenName"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="mm104:PersonSurnameName"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="mm104:PersonTitle"/>
        <xsl:if test="mm100:IdentifierCode | mm100:Identifier">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="mm100:IdentifierCode"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="mm100:Identifier"/>
        </xsl:if>
        <xsl:for-each select="mm100:TelephoneSubscriberIdentifier | mm100:DepartmentName">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:Patient">
        <xsl:call-template name="e_contact"/>
        <xdis:Break/>
        <xsl:apply-templates mode="text" select="mm104:CoAddress"/>
        <xsl:text>Informeret samtykke: </xsl:text>
        <xsl:value-of select="../mm104:ConsentInformed"/>
        <xdis:Break/>
    </xsl:template>


    <xsl:template mode="text" match="mm104:Relative">
        <xsl:call-template name="name_address"/>
        <xdis:Break/>
        <xsl:if test="mm104:TelephoneSubscriber | mm104:EmailAddressIdentifier">
            <xsl:call-template name="e_contact"/>
            <xdis:Break/>
        </xsl:if>
    </xsl:template>

    <xsl:template mode="text" match="mm104:CurrentHospitalContact">
        <xdis:Break/>
        <xdis:Bold>Aktuel sygehuskontakt</xdis:Bold>
        <xdis:Break/>
        <xsl:text>Start: </xsl:text>
        <xsl:for-each select="mm104:Start">
            <xsl:call-template name="date_time"/>
        </xsl:for-each>
        <xdis:Break/>
        <xsl:text>Forventet Afslutning: </xsl:text>
        <xsl:for-each select="mm104:ExpectedEnd">
            <xsl:call-template name="date_time"/>
        </xsl:for-each>
        <xsl:value-of select="mm104:ExpectedEndText"/>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:HospitalAmbulatoryControl">
        <xdis:Break/>
        <xdis:Bold>Aftaler om kontrol og opfølgning</xdis:Bold>
        <xdis:Break/>
        <xsl:text>Dato for kontrol: </xsl:text>
        <xsl:for-each select="mm104:ExpectedStart">
            <xsl:call-template name="date_time"/>
        </xsl:for-each>
        <xsl:value-of select="mm104:ExpectedStartText"/>
        <xdis:Break/>
        <xsl:apply-templates mode="text" select="mm104:Location"/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:ICD10Diagnoses">
        <xdis:Break/>
        <xdis:Bold>Diagnoser</xdis:Bold>
        <xdis:Break/>
        <xsl:apply-templates mode="text" select="mm104:ICD10Diagnose/*"/>
        <xsl:for-each select="mm104:Text">
            <xsl:value-of select="."/>
            <xdis:Break/>            
        </xsl:for-each>
    </xsl:template>

    <xsl:template mode="text" match="mm104:PrimaryDiagnosis | mm104:SecondaryDiagnosis | mm104:ICFCode | mm104:ICFGradient">
        <xsl:value-of select="mm104:Text"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="mm104:Code"/>
        <xsl:text>)</xsl:text>
        <xdis:Break/>
    </xsl:template>
    
    <xsl:template mode="text" match="mm104:ICFClassifications">
        <xdis:Break/>
        <xdis:Bold>ICF-koder</xdis:Bold>
        <xdis:Break/>
        <xsl:apply-templates mode="text" select="mm104:ICFClassification/*"/>
    </xsl:template>
    
    <xsl:template mode="text" match="mm104:JournalExcerpt">
        <xdis:Break/>
        <xdis:Bold>
            <xsl:text>Uddrag fra journal: </xsl:text>
            <xsl:value-of select="mm104:TypeOfExcerpt"/>
        </xdis:Bold>
        <xdis:Break/>
        <xsl:for-each select="mm104:Signer">
            <xsl:value-of select="mm104:Date"/>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates mode="text" select="mm104:SignedBy"/>
        </xsl:for-each>
        <xsl:for-each select="mm104:Comment/* | mm104:Comment/text()">
            <xsl:call-template name="copy_all"/>    
        </xsl:for-each>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:ContactCounty">
        <xdis:Break/>
        <xdis:Bold>Spørgsmål til Regionen</xdis:Bold>
        <xdis:Break/>
        <xsl:if test="mm100:EANIdentifier">
            <xsl:call-template name="health_identifier"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:call-template name="name_address"/>
        <xsl:call-template name="e_contact">
            <xsl:with-param name="append" select="true()"/>
        </xsl:call-template>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:ContactMunicipality">
        <xdis:Break/>
        <xdis:Bold>Spørgsmål til Kommunen</xdis:Bold>
        <xdis:Break/>
        <xsl:if test="mm100:EANIdentifier">
            <xsl:call-template name="health_identifier"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:call-template name="name_address"/>
        <xsl:call-template name="e_contact">
            <xsl:with-param name="append" select="true()"/>
        </xsl:call-template>
        <xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:HealthCareTeam">
        <xdis:Break/>
        <xdis:Bold>Behandlende team under indlæggelse</xdis:Bold>
        <xdis:Break/>
        <xsl:for-each select="mm104:Member">
            <xsl:call-template name="name_address"/>
            <xsl:call-template name="health_identifier">
                <xsl:with-param name="append" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="e_contact">
                <xsl:with-param name="append" select="true()"/>
            </xsl:call-template>
            <xdis:Break/>
        </xsl:for-each>
    </xsl:template>


    <xsl:template mode="text" match="mm104:FinalResult">
        <xdis:Break/>
        <xdis:Bold>Slutstatusmodtager</xdis:Bold>
        <xdis:Break/>
        <xsl:apply-templates mode="text" select="*"/>
    </xsl:template>


    <!-- Helpers -->


    <xsl:template mode="text" match="mm104:CoAddress"> c/o adresse: <xsl:call-template
            name="name_address"/><xdis:Break/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:TelephoneSubscriber">
        <xsl:value-of select="mm104:TelephoneSubscriberCode"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="mm100:TelephoneSubscriberIdentifier"/>
    </xsl:template>

    <xsl:template mode="text" match="mm104:NoTelephoneReason">
        <xsl:text>Ingen tlf: </xsl:text>
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template name="name_address">
        <xsl:choose>
            <xsl:when
                test="mm100:PersonGivenName | mm100:PersonSurnameName | mm104:PersonGivenName | mm104:PersonSurnameName">
                <xsl:value-of select="mm100:PersonGivenName | mm104:PersonGivenName"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="mm100:PersonSurnameName | mm104:PersonSurnameName"/>
                <xsl:for-each select="mm100:RelationCode | mm104:PersonTitle">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:call-template name="address">
                    <xsl:with-param name="append" select="true()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="address"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="address">
        <xsl:param name="append" select="false()"/>
        <xsl:for-each
            select="mm100:OrganisationName | mm100:DepartmentName | mm100:UnitName | mm100:StreetName | mm100:SuburbName">
            <xsl:if test="$append or position() &gt; 1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="mm100:District | mm100:PostCodeIdentifier">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="mm100:PostCodeIdentifier"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="mm100:DistrictName"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="e_contact">
        <xsl:param name="append" select="false()"/>
        <xsl:for-each
            select="mm100:TelephoneSubscriberIdentifier | mm104:TelephoneSubscriber | mm104:NoTelephoneReason | mm104:EmailAddressIdentifier">
            <xsl:if test="$append or position() &gt; 1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:apply-templates mode="text" select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="health_identifier">
        <xsl:param name="append" select="false()"/>
        <xsl:variable name="ean">
            <xsl:for-each select="mm100:EANIdentifier">
                    <xsl:text>EAN: </xsl:text>
                    <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="identifier">
            <xsl:value-of select="mm100:IdentifierCode"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="mm100:Identifier"/>            
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="mm100:EANIdentifier and mm100:Identifier">
                <xsl:if test="$append">
                    <xsl:text>, </xsl:text>
                </xsl:if>                
                <xsl:value-of select="$ean"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$identifier"/>
            </xsl:when>
            <xsl:when test="mm100:EANIdentifier">
                <xsl:if test="$append">
                    <xsl:text>, </xsl:text>
                </xsl:if>                
                <xsl:value-of select="$ean"/>
            </xsl:when>
            <xsl:when test="mm100:Identifier">
                <xsl:if test="$append">
                    <xsl:text>, </xsl:text>
                </xsl:if>                
                <xsl:value-of select="$identifier"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formatted_text">
        <xsl:param name="title"/>
        <xdis:Break/>
        <xdis:Bold>
            <xsl:value-of select="$title"/>
        </xdis:Bold>
        <xdis:Break/>
        <xsl:for-each select="* | text()">
            <xsl:call-template name="copy_all"/>
        </xsl:for-each>
        <xdis:Break/>
    </xsl:template>

    <xsl:template name="plain_text">
        <xsl:param name="title"/>
        <xdis:Break/>
        <xsl:value-of select="$title"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="."/>
        <xdis:Break/>
    </xsl:template>

    <xsl:template name="date_time">
        <xsl:value-of select="mm104:Date"/>
        <xsl:for-each select="mm104:Time">
            <xsl:text> Kl. </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template mode="text" match="mm104:EmailAddressIdentifier | mm100:TelephoneSubscriberIdentifier">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template mode="text" match="*">
        <xsl:message>
            Ukendt element: <xsl:value-of select="node-name(.)"/>
        </xsl:message>
    </xsl:template>
    

</xsl:stylesheet>
