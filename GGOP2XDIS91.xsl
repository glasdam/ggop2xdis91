<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mm100="urn:oio:medcom:municipality:1.0.0"
    xmlns:mm104="urn:oio:medcom:municipality:1.0.4"
    xmlns:xdis="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2006/07/01/"
    exclude-result-prefixes="xs mm100 mm104"
    version="1.0">
    <xsl:output encoding="ISO-8859-1"
        method="xml"
        omit-xml-declaration="no"
        indent="yes" />
    
    <xsl:param name="SenderEAN" select="'SenderEAN'"/>
    <xsl:param name="ReceiverEAN" select="'ReceiverEAN'"/>
    
    <xsl:include href="text_extract.xsl"/>
    
    <xsl:template match="/mm104:Emessage">
        <xdis:Emessage>
            <xsl:for-each select="mm100:Envelope">
                <xsl:call-template name="copy_all"/>
            </xsl:for-each>
            <xdis:ClinicalEmail>
                <xsl:for-each select="mm104:RehabilitationPlan">
                    <xsl:apply-templates select="mm104:Letter | mm104:Sender | mm104:Receiver | mm104:Patient"/>
                    <xdis:AdditionalInformation>
                        <xdis:Priority>rutine</xdis:Priority>
                        <xdis:Subject>Genoptræningsplan (<xsl:value-of select="mm104:TypeOfRehabilitationPlan"/>)</xdis:Subject>
                    </xdis:AdditionalInformation>
                    <xdis:ClinicalInformation>
                        <xdis:Text01>
                            <xsl:apply-templates mode="text" select="mm104:GPCCReceiver | mm104:CCReceiver"/>
                            <xdis:Break/>
                            <xdis:Bold>Underskrivere</xdis:Bold><xdis:Break/>
                            <xsl:apply-templates mode="text" select="mm104:Sender/mm104:SignedBy | mm104:Sender/mm104:CoWriter"/>
                            <xdis:Break/>
                            <xdis:Bold>Yderligere patientoplysninger</xdis:Bold>
                            <xdis:Break/>
                            <xsl:apply-templates mode="text" select="mm104:Patient"/>
                            <xsl:for-each select="mm104:Relatives">
                                <xdis:Break/>
                                <xdis:Bold>Pårørende</xdis:Bold>
                                <xdis:Break/>
                                <xsl:apply-templates mode="text" select="mm104:Relative"/>                            
                            </xsl:for-each>
                            <xsl:for-each select="mm104:InformationForPatientAndRelatives">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Information om behandling til patient og pårørende'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:PracticalInformation">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Praktiske oplysninger'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:PatientSafetyAspects">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Patientsikkerhedsmæssige forhold'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:RehabilitationDeadline">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Tidsfrist for start af genoptræning'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:apply-templates mode="text" select="mm104:CurrentHospitalContact"/>
                            <xsl:apply-templates mode="text" select="mm104:HospitalAmbulatoryControl"/>
                            <xsl:for-each select="mm100:PatientHealthSummary">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Helbredsforhold inkl. beskrivelse af behandlingsforløb - Sammenfatning'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:AbilityAtDischargeSummary">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Helbredsrelateret funktionsevne på udskrivningstidspunktet - Sammenfatning'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:AbilityAtDischargeExtended">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Udvidet beskrivelse af helbredsrelateret funktionsevne på udskrivningstidspunktet'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:for-each select="mm104:RehabilitationNeedAndPotential">
                                <xsl:call-template name="formatted_text">
                                    <xsl:with-param name="title" select="'Patientens genoptræningsbehov og potentiale'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:apply-templates mode="text" select="mm104:ICD10Diagnoses"/>
                            <xsl:apply-templates mode="text" select="mm104:ICFClassifications"/>
                            <xsl:apply-templates mode="text" select="mm104:JournalExcerpt"/>
                            <xsl:apply-templates mode="text" select="mm104:ContactCounty | mm104:ContactMunicipality"/>
                            <xsl:apply-templates mode="text" select="mm104:HealthCareTeam"/>
                            <xsl:apply-templates mode="text" select="mm104:FinalResult"/>
                        </xdis:Text01>
                    </xdis:ClinicalInformation>
                </xsl:for-each>
                <xsl:for-each select="mm104:RehabilitationPlan/mm104:Reference">
                    <xsl:call-template name="copy_all"/>
                </xsl:for-each>
            </xdis:ClinicalEmail>
        </xdis:Emessage>
    </xsl:template>
    
    <xsl:template match="mm104:Letter">
        <xdis:Letter>
            <xsl:for-each select="mm104:Identifier">
                <xsl:call-template name="copy_all"/>
            </xsl:for-each>
            <xdis:VersionCode>XD9134L</xdis:VersionCode>
            <xsl:for-each select="mm104:StatisticalCode">
                <xsl:call-template name="copy_all"/>
            </xsl:for-each>
            <xsl:for-each select="mm104:Authorisation">
                <xsl:call-template name="copy_all"/>
            </xsl:for-each>
            <xdis:TypeCode>XDIS91</xdis:TypeCode>
            <xdis:StatusCode>nytbrev</xdis:StatusCode>
            <xsl:for-each select="mm104:EpisodeOfCareIdentifier">
                <xsl:call-template name="copy_all"/>
            </xsl:for-each>
        </xdis:Letter>
    </xsl:template>
    
    <xsl:template match="mm104:Sender">
        <xdis:Sender>
            <xdis:EANIdentifier>
                <xsl:value-of select="$SenderEAN"/>
            </xdis:EANIdentifier>
            <xsl:call-template name="copy_role"/>
        </xdis:Sender>
    </xsl:template>
    
    <xsl:template match="mm104:Receiver">
        <xdis:Receiver>
            <xdis:EANIdentifier>
                <xsl:value-of select="$ReceiverEAN"/>
            </xdis:EANIdentifier>
            <xsl:call-template name="copy_role"/>
        </xdis:Receiver>
    </xsl:template>
    
    <xsl:template match="mm104:Patient">
        <xdis:Patient>
            <xsl:call-template name="copy_role"/>
            <xsl:for-each select="mm100:Occupation">
                <xdis:OccupancyText>
                    <xsl:value-of select="text()"/>
                </xdis:OccupancyText>                
            </xsl:for-each>
            <xdis:EpisodeOfCareStatusCode>inaktiv</xdis:EpisodeOfCareStatusCode>
        </xdis:Patient>
    </xsl:template>
    
    
    <xsl:template name="copy_role">
        <xsl:for-each select="mm100:CivilRegistrationNumber | mm100:AlternativeIdentifier | mm100:PersonSurnameName | mm100:PersonGivenName | mm100:Identifier | mm104:IdentifierCode | mm100:OrganisationName | mm100:DepartmentName | mm100:UnitName | mm100:StreetName | mm100:SuburbName | mm100:DistrictName | mm100:PostCodeIdentifier | mm100:TelephoneSubscriberIdentifier | mm100:MedicalSpecialityCode">
            <xsl:call-template name="copy_all"/>                
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="copy_all">
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:element name="xdis:{local-name(.)}">
                    <xsl:for-each select="*|text()">
                        <xsl:call-template name="copy_all"/>
                    </xsl:for-each>                    
                </xsl:element>
            </xsl:when>
            <xsl:when test="self::text()">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="self::node()">
                <xsl:if test="local-name()">
                    <xsl:element name="xdis:{local-name(.)}"/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:message>
            Ukendt element: <xsl:value-of select="node-name(.)"/>
        </xsl:message>
    </xsl:template>
    
</xsl:stylesheet>