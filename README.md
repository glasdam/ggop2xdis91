#Konvertering af GGOP til XDIS91

Stylesheet til konvertering af GGOP version 1.0 til XDIS91 version XD9134L.

##Parametre

 - SenderEAN: Afsenders EAN-nummer fra VANSEnvelope.
 - ReceiverEAN: Modtagers EAN-nummer fra VANSEnvelope.

##Kendte uhensigtsmæssigheder

Stylesheetet kan ikke tælle antal FTX'er i efterfølgende konvertering til edifact. Derfor er al teksten sat i en Text01 (S14 i edifact). Der lægges op til at konverteringsleverandørerne selv foretager denne opdeling efter behov.

##Filer

 - README.md: Denne fil
 - GGOP2XDIS91.xsl: Konverteringsstylesheet, inkluderer text_extract.xsl.
 - text_extract.xsl: Konverteringsfunktionalitet til brug i GGOP2XDIS91.xsl.
 - ggop.xml: GGOP eksempel.
 - xdis91.xml: Resultat XDIS91 eksempel, fra konvertering af ggop.xml.

##Eksempel på kørsel

```
xsltproc --stringparam SenderEAN afsender --stringparam ReceiverEAN modtager GGOP2XDIS91.xsl ggop.xml > xdis91.xml
```
