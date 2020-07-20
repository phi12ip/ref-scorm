<xs:schema targetNamespace="http://ltsc.ieee.org/xsd/LOM"
           xmlns="http://ltsc.ieee.org/xsd/LOM"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
	   xmlns:hx = "http://ns.medbiq.org/lom/extend/v1/"
	   xmlns:hv = "http://ns.medbiq.org/lom/vocab/v1/"
	   xmlns:unique="http://ltsc.ieee.org/xsd/LOM/unique"
           xmlns:vocab="http://ltsc.ieee.org/xsd/LOM/vocab"
           xmlns:extend="http://ltsc.ieee.org/xsd/LOM/extend"
           elementFormDefault="qualified"
           version="IEEE LTSC LOM XML 1.0">

   <xs:annotation>
      <xs:documentation>
         This work is licensed under the Creative Commons Attribution-ShareAlike
         License.  To view a copy of this license, see the file license.txt,
         visit http://creativecommons.org/licenses/by-sa/1.0 or send a letter to
         Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
      </xs:documentation>
      <xs:documentation>
         This file represents a composite schema for validating
         LOM V1.0 instances.  This file is built by default to represent a 
         composite schema for validation of the following:          

         1) The use of LOM Base Schema vocabulary source/value pairs only
         2) Uniqueness constraints defined by 1484.12.1-2002
         3) No existenace of any defined extensions

         Alternative composite schemas can be assembled by selecting
         from the various alternative component schema listed below.
      </xs:documentation>
      <xs:documentation>
        *****************************************************************************
        **                           CHANGE HISTORY                                **
        *****************************************************************************
        ** 11/14/2003:  1)Updated comment describing vocab/strict.xsd.  Indicated  **
        **                that the strict.xsd is used to validate vocabularies     **
        **                defined in the LOM V1.0 Base Schema.                     **
        **              2)Moved included schema elementNames.xsd just before       **
        **                elementTypes.xsd.                                        **
        **              3)Moved the element declaration for the top-level lom      **
        **                metadata element to a separate file (rootElement.xsd)    **
        **                and included this file just after elementTypes.xsd.      **
        **              4)Moved the XML Schema import statements before the XML    **
        **                Schema include statements.                               **
        **              5)Moved the element group declaration named                **
        **                lom:customElements to a separate file (anyElement.xsd)   **
        **                and included this new file just before the XML Schema    **
        **                import statments.                                        **
        **                                                                         **
        ** 03/15/2004:  1)Switched which vocabulary vaidation approach is the      **
        **                default to be used by this template from vocab/loose.xsd **
        **                to vocab/strict.xsd.  Base on ballot resolution comment  **
        **                addressed on 03/15/2004                                  **
        **              2)Switched the extension validation approach to use        **
        **                extend/strict.xsd.  The XSD now is reprsentative of      **
        **                a schema that can be used to validate strictly           **
        **                conforming LOM XML Instances.                            **
        *****************************************************************************
      </xs:documentation>
   </xs:annotation>

   <!-- Learning Object Metadata -->

   <!-- Element uniqueness:  use one of the following                   -->
   <!-- Use unique/loose.xsd to relax element uniqueness constraints    -->
   <!-- Use unique/strict.xsd to enforce element uniqueness constraints -->

    <xs:import namespace="http://ltsc.ieee.org/xsd/LOM/unique"
              schemaLocation="unique/loose.xsd"/>

   <!--<xs:import namespace="http://ltsc.ieee.org/xsd/LOM/unique"
              schemaLocation="unique/strict.xsd"/>-->

   <!-- Vocabulary checking:  use one of the following                             -->
   <!-- Use vocab/loose.xsd to relax vocabulary enumeration constraints            -->
   <!-- Use vocab/strict.xsd to enforce the LOM V1.0 Base Schema vocabulary values -->
   <!-- Use vocab/custom.xsd to enforce custom vocabulary values                   -->

   <!--<xs:import namespace="http://ltsc.ieee.org/xsd/LOM/vocab"
              schemaLocation="vocab/loose.xsd"/> -->

   <!--   <xs:import namespace="http://ltsc.ieee.org/xsd/LOM/vocab"
              schemaLocation="vocab/strict.xsd"/> --> 

    <xs:import namespace="http://ltsc.ieee.org/xsd/LOM/vocab"
              schemaLocation="vocab/custom.xsd"/> 

   <!-- Custom elements:  use one of the following                     -->
   <!-- Use extend/strict.xsd to enforce strictly conforming elements  -->
   <!-- Use extend/custom.xsd to allow custom metadata elements        -->

   <!-- <xs:import namespace="http://ltsc.ieee.org/xsd/LOM/extend"
             schemaLocation="extend/strict.xsd"/> -->  

   <xs:import namespace="http://ltsc.ieee.org/xsd/LOM/extend"
              schemaLocation="extend/custom.xsd"/> 
  <xs:import namespace = "http://ns.medbiq.org/lom/extend/v1/" schemaLocation = "healthcare/healthcaremetadata.xsd"/>

  <xs:import namespace = "http://ns.medbiq.org/lom/vocab/v1/" schemaLocation = "healthcare/healthcarevocabularies.xsd"/>

   <xs:group name="customElements">
      <xs:choice>
         <xs:any namespace="##other" processContents="lax"/>
      </xs:choice>
   </xs:group>


   <!-- Data type declarations -->

   <!-- CharacterString -->
   <xs:simpleType name="CharacterString">
      <xs:restriction base="xs:string"/>
   </xs:simpleType>

   <!-- LanguageId -->
   <xs:simpleType name="LanguageIdOrNone">
      <xs:union memberTypes="LanguageId LanguageIdNone"/>
   </xs:simpleType>

   <xs:simpleType name="LanguageId">
      <xs:restriction base="xs:language"/>
   </xs:simpleType>

   <xs:simpleType name="LanguageIdNone">
      <xs:restriction base="xs:token">
         <xs:enumeration value="none"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- VCard -->
   <xs:simpleType name="VCard">
      <xs:restriction base="CharacterString"/>
   </xs:simpleType>

   <!-- MimeType -->
   <xs:simpleType name="MimeType">
      <xs:restriction base="CharacterString"/>
   </xs:simpleType>

   <!-- Size -->
   <xs:simpleType name="Size">
      <xs:restriction base="xs:nonNegativeInteger"/>
   </xs:simpleType>

   <!-- LangString -->
   <xs:complexType name="LangString">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
   </xs:complexType>

   <xs:complexType name="langString">
      <xs:simpleContent>
         <xs:extension base="CharacterString">
            <xs:attribute name="language" type="LanguageId"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>


   <xs:complexType name="DateTimeValue">
      <xs:simpleContent>
         <xs:extension base="DateTimeString">
           <xs:attributeGroup ref="unique:DateTimeValue"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- Regular expresion from Christian Klaue -->
   <xs:simpleType name="DateTimeString">
      <xs:restriction base="CharacterString">
         <xs:pattern value="([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]|[0-9][1-9][0-9]{2}|[1-9][0-9]{3})(\-(0[1-9]|1[0-2])(\-(0[1-9]|[1-2][0-9]|3[0-1])(T([0-1][0-9]|2[0-3])(:[0-5][0-9](:[0-5][0-9](\.[0-9]{1,}(Z|((\+|\-)([0-1][0-9]|2[0-3]):[0-5][0-9]))?)?)?)?)?)?)?"/>
      </xs:restriction>
   </xs:simpleType>

   <xs:complexType name="DurationValue">
      <xs:simpleContent>
         <xs:extension base="DurationString">
            <xs:attributeGroup ref="unique:DurationValue"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- Regular expresion from Christian Klaue -->
   <xs:simpleType name="DurationString">
      <xs:restriction base="CharacterString">
         <xs:pattern value="P([0-9]{1,}Y){0,1}([0-9]{1,}M){0,1}([0-9]{1,}D){0,1}(T([0-9]{1,}H){0,1}([0-9]{1,}M){0,1}([0-9]{1,}(\.[0-9]{1,}){0,1}S){0,1}){0,1}"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- Element declarations -->

   <!-- Duplicate declarations are included as comments. -->

   <!-- Learning Object Metadata -->
   <xs:element name="lom" type="lom">
      <xs:unique name="lomUnique">
         <xs:selector xpath="*"/>
         <xs:field xpath="@uniqueElementName"/>
      </xs:unique>
   </xs:element>

   <!-- 1 General -->
         <xs:element name="general" type="general" minOccurs="0">
            <xs:unique name="generalUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 1.1 Identifier -->
         <xs:element name="identifier" type="identifier">
            <xs:unique name="identifierUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 1.1.1 Catalog -->
         <xs:element name="catalog" type="catalog"/>

   <!-- 1.1.2 Entry -->
         <xs:element name="entry" type="entry"/>

   <!-- 1.2 Title -->
         <xs:element name="title" type="title"/>

   <!-- 1.5 Keyword -->
         <xs:element name="keyword" type="keyword"/>

   <!-- 1.6 Coverage -->
         <xs:element name="coverage" type="coverage"/>

   <!-- 1.7 Structure -->
         <xs:element name="structure" type="structure">
            <xs:unique name="structureUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 1.8 Aggregation Level -->
         <xs:element name="aggregationLevel" type="aggregationLevel">
            <xs:unique name="aggregationLevelUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 2 Life Cycle -->
         <xs:element name="lifeCycle" type="lifeCycle">
            <xs:unique name="lifeCycleUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 2.1 Version -->
         <xs:element name="version" type="version"/>

   <!-- 2.2 Status -->
         <xs:element name="status" type="status">
            <xs:unique name="statusUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 2.3 Contribute -->
         <xs:element name="contribute" type="contribute">
            <xs:unique name="contributeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 2.3.1 Role -->
         <xs:element name="role" type="role">
            <xs:unique name="roleUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

  <!-- 2.3.3 Date -->
        <xs:element name="date" type="date">
           <xs:unique name="dateUnique">
              <xs:selector xpath="*"/>
              <xs:field xpath="@uniqueElementName"/>
           </xs:unique>
        </xs:element>

   <!-- 3 Meta-Metadata -->
         <xs:element name="metaMetadata" type="metaMetadata">
            <xs:unique name="metaMetadataUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 3.3a Metadata Schema -->
         <xs:element name="metadataSchema" type="metadataSchema"/>

   <!-- 3.3a Metadata Schema -->
         <xs:element name="metadataSchema1" type="metadataSchema"/>

   <!-- 3.3a Metadata Schema -->
         <xs:element name="metadataSchema2" type="metadataSchema"/>

   <!-- 4 Technical -->
         <xs:element name="technical" type="technical">
            <xs:unique name="technicalUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 4.1 Format -->
         <xs:element name="format" type="format"/>

   <!-- 4.2 Size -->
         <xs:element name="size" type="size"/>

   <!-- 4.3 Location -->
         <xs:element name="location" type="location"/>

   <!-- 4.4 Requirement -->
         <xs:element name="requirement" type="requirement"/>

   <!-- 4.4.1 OrComposite -->
         <xs:element name="orComposite" type="orComposite">
            <xs:unique name="orCompositeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 4.4.1.1 Type -->
         <xs:element name="type" type="type">
            <xs:unique name="typeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 4.4.1.2 Name -->
         <xs:element name="name" type="name">
            <xs:unique name="nameUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 4.4.1.3 Minimum Version -->
         <xs:element name="minimumVersion" type="minimumVersion"/>

   <!-- 4.4.1.4 Maximum Version -->
         <xs:element name="maximumVersion" type="maximumVersion"/>

   <!-- 4.5 Installation Remarks -->
         <xs:element name="installationRemarks" type="installationRemarks"/>

   <!-- 4.6 Other Platform Requirements -->
         <xs:element name="otherPlatformRequirements" type="otherPlatformRequirements"/>

   <!-- 4.7 Duration -->
         <xs:element name="duration" type="duration">
            <xs:unique name="durationUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element> 

   <!-- 5 Educational -->
         <xs:element name="educational" type="educational">
            <xs:unique name="educationalUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.1 Interactivity Type -->
         <xs:element name="interactivityType" type="interactivityType">
            <xs:unique name="interactivityTypeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.2 Learning Resource Type -->
         <xs:element name="learningResourceType" type="learningResourceType">
            <xs:unique name="learningResourceTypeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.3 Interactivity Level -->
         <xs:element name="interactivityLevel" type="interactivityLevel">
            <xs:unique name="interactivityLevelUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.4 Semantic Density -->
         <xs:element name="semanticDensity" type="semanticDensity">
            <xs:unique name="semanticDensityUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.5 Intended End User Role -->
         <xs:element name="intendedEndUserRole" type="intendedEndUserRole">
            <xs:unique name="intendedEndUserRoleUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.6 Context -->
         <xs:element name="context" type="context">
            <xs:unique name="contextUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.7 Typical Age Range -->
         <xs:element name="typicalAgeRange" type="typicalAgeRange"/>
  
   <!-- 5.8 Difficulty -->
         <xs:element name="difficulty" type="difficulty">
            <xs:unique name="difficultyUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 5.9 Typical Learning Time -->
         <xs:element name="typicalLearningTime" type="typicalLearningTime">
            <xs:unique name="typicalLearningTimeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 6 Rights -->
         <xs:element name="rights" type="rights">
            <xs:unique name="rightsUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 6.1 Cost -->
         <xs:element name="cost" type="cost">
            <xs:unique name="costUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 6.2 Copyright and Other Restrictions -->
         <xs:element name="copyrightAndOtherRestrictions" type="copyrightAndOtherRestrictions">
            <xs:unique name="copyrightAndOtherRestrictionsUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 6.3 Description --> 
         <xs:element name="description" type="description"/>

   <!-- 7 Relation -->
         <xs:element name="relation" type="relation">
            <xs:unique name="relationUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 7.1 Kind -->
         <xs:element name="kind" type="kind">
            <xs:unique name="kindUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 7.2 Resource -->
         <xs:element name="resource" type="resource"/>

   <!-- 8 Annotation -->
         <xs:element name="annotation" type="annotation">
            <xs:unique name="annotationUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 8.1 Entity -->
         <xs:element name="entity" type="entity"/>

   <!-- 9 Classification -->
         <xs:element name="classification" type="classification">
            <xs:unique name="classificationUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 9.1 Purpose -->
         <xs:element name="purpose" type="purpose">
            <xs:unique name="purposeUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 9.2 Taxon Path -->
         <xs:element name="taxonPath" type="taxonPath">
            <xs:unique name="taxonPathUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 9.2.1 Source -->
         <xs:element name="source" type="source"/>

   <!-- 9.2.2 Taxon -->
         <xs:element name="taxon" type="taxon">
            <xs:unique name="taxonUnique">
               <xs:selector xpath="*"/>
               <xs:field xpath="@uniqueElementName"/>
            </xs:unique>
         </xs:element>

   <!-- 9.2.2.1 Id -->
         <xs:element name="id" type="id"/>

  <!-- Element type declarations -->

  <!-- Learning Object Metadata -->
  <xs:complexType name="lom">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="general"/>
      <xs:element ref="lifeCycle"/>
      <xs:element ref="metaMetadata"/>
      <xs:element ref="technical"/>
      <xs:element ref="educational"/>
      <xs:element ref="rights"/>
      <xs:element ref="relation"/>
      <xs:element ref="annotation"/>
      <xs:element ref="classification"/>
      <xs:element ref = "hx:healthcareMetadata"/>
      <xs:element ref = "hx:customElements"/>
    <!--  <xs:group ref="extend:customElements"/> -->
    </xs:choice>
    <xs:attributeGroup ref="unique:lom"/>
  </xs:complexType>
	
  <!-- 1 General -->
  <xs:complexType name="general">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="identifier"/>
      <xs:element ref="title"/>
      <xs:element name="language" type="LanguageIdOrNone"/>
      <xs:element name="description" type="LangString"/>
      <xs:element ref="keyword"/>
      <xs:element ref="coverage"/>
      <xs:element ref="structure"/>
      <xs:element ref="aggregationLevel"/>
      <xs:group ref="extend:customElements"/> 
    </xs:choice>
    <xs:attributeGroup ref="unique:general"/>
  </xs:complexType>

  <!-- 1.1 Identifier -->
  <xs:complexType name="identifier">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="catalog"/>
      <xs:element ref="entry"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:identifier"/>
  </xs:complexType>

  <!-- 1.1.1 Catalog -->
  <xs:complexType name="catalog">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:catalog"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 1.1.2 Entry -->
  <xs:complexType name="entry">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:entry"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 1.2 Title -->
  <xs:complexType name="title">
     <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:title"/>
  </xs:complexType>

  <!-- 1.5 Keyword -->
  <xs:complexType name="keyword">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
    <xs:attributeGroup ref="unique:keyword"/>
    <xs:attributeGroup ref="hx:keywordAttributeExtensions"/>
  </xs:complexType>

  <!-- 1.6 Coverage -->
  <xs:complexType name="coverage">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:coverage"/>
  </xs:complexType>

  <!-- 1.7 Structure -->
  <xs:complexType name="structure">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="structureValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:structure"/>
  </xs:complexType>

  <!-- 1.8 Aggregation Level -->
  <xs:complexType name="aggregationLevel">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="aggregationLevelValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:aggregationLevel"/>
  </xs:complexType>

  <!-- 2 Life Cycle -->
  <xs:complexType name="lifeCycle">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="version"/>
      <xs:element ref="status"/>
      <xs:element ref="contribute"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:lifeCycle"/>
  </xs:complexType>

  <!-- 2.1 Version -->
  <xs:complexType name="version">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:version"/>
  </xs:complexType>

  <!-- 2.2 Status -->
  <xs:complexType name="status">
     <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="statusValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:status"/>
  </xs:complexType>

  <!-- 2.3 Contribute -->
  <xs:complexType name="contribute">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="role"/>
      <xs:element name="entity" type="VCard"/>
      <xs:element ref="date"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:contribute"/>
  </xs:complexType>

  <!-- 2.3.1 Role -->
  <xs:complexType name="role">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="roleValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:role"/>
  </xs:complexType>

  <!-- 2.3.3 Date -->
  <xs:complexType name="date">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="dateTime" type="DateTimeValue"/>
         <xs:element name="description" type="description"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:date"/>
  </xs:complexType>

  <!-- 3 Meta-Metadata -->
  <xs:complexType name="metaMetadata">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="identifier"/>
      <xs:element name="contribute" type="contributeMeta"/>
      <xs:element ref="metadataSchema1"/>
      <xs:element ref="metadataSchema2"/>
      <xs:element ref="metadataSchema"/>
      <xs:element name="language" type="language"/> 
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:metaMetadata"/>
  </xs:complexType>

  <!-- 3.2 Contribute -->
  <xs:complexType name="contributeMeta">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element name="role" type="roleMeta"/>
      <xs:element name="entity" type="VCard"/> 
      <xs:element ref="date"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:contribute"/>
  </xs:complexType>

  <!-- 3.2.1 Role -->
  <xs:complexType name="roleMeta">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="roleMetaValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:role"/>
  </xs:complexType>

  <!-- 3.3a Metadata Schema -->
  <xs:complexType name="metadataSchema">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:metadataSchema"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

 <!-- 3.3b Metadata Schema Required for SCORM-->
  <xs:complexType name="metadataSchema1">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:metadataSchema"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 3.3b Metadata Schema Required for SCORM-->
  <xs:complexType name="metadataSchema2">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:metadataSchema"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 3.4 Language -->
  <xs:complexType name="language">
    <xs:simpleContent>
      <xs:extension base="LanguageId">
        <xs:attributeGroup ref="unique:language"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4 Technical -->
  <xs:complexType name="technical">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="format"/>
      <xs:element ref="size"/>
      <xs:element ref="location"/>
      <xs:element ref="requirement"/>
      <xs:element ref="installationRemarks"/>
      <xs:element ref="otherPlatformRequirements"/>
      <xs:element ref="duration"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:technical"/>
  </xs:complexType>

  <!-- 4.1 Format -->
  <xs:complexType name="format">
    <xs:simpleContent>
      <xs:extension base="MimeType">
        <xs:attributeGroup ref="unique:format"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4.2 Size -->
  <xs:complexType name="size">
    <xs:simpleContent>
      <xs:extension base="Size">
        <xs:attributeGroup ref="unique:size"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4.3 Location -->
  <xs:complexType name="location">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:location"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4.4 Requirement -->
  <xs:complexType name="requirement">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="orComposite"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:requirement"/>
  </xs:complexType>

  <!-- 4.4.1 OrComposite -->
  <xs:complexType name="orComposite">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="type"/>
      <xs:element ref="name"/>
      <xs:element ref="minimumVersion"/>
      <xs:element ref="maximumVersion"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:orComposite"/>
  </xs:complexType>

  <!-- 4.4.1.1 Type -->
  <xs:complexType name="type">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="typeValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:type"/>
  </xs:complexType>

  <!-- 4.4.1.2 Name -->
  <xs:complexType name="name">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="nameValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:name"/>
  </xs:complexType>

  <!-- 4.4.1.3 Minimum Version -->
  <xs:complexType name="minimumVersion">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:minimumVersion"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4.4.1.4 Maximum Version -->
  <xs:complexType name="maximumVersion">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:maximumVersion"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 4.5 Installation Remarks -->
  <xs:complexType name="installationRemarks">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:installationRemarks"/>
  </xs:complexType>

  <!-- 4.6 Other Platform Requirements -->
  <xs:complexType name="otherPlatformRequirements">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:otherPlatformRequirements"/>
  </xs:complexType>

  <!-- 4.7 Duration -->
  <xs:complexType name="duration">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="duration" type="DurationValue"/>
         <xs:element name="description" type="description"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:duration"/>
  </xs:complexType>

  <!-- 5 Educational -->
  <xs:complexType name="educational">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="interactivityType"/>
      <xs:element ref="learningResourceType"/>
      <xs:element ref="interactivityLevel"/>
      <xs:element ref="semanticDensity"/>
      <xs:element ref="intendedEndUserRole"/>
      <xs:element ref="context"/>
      <xs:element ref="typicalAgeRange"/>
      <xs:element ref="difficulty"/>
      <xs:element ref="typicalLearningTime"/>
      <xs:element name="description" type="LangString"/>
      <xs:element name="language" type="LanguageId"/> 
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:educational"/>
  </xs:complexType>

  <!-- 5.1 Interactivity Type -->
  <xs:complexType name="interactivityType">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="interactivityTypeValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:interactivityType"/>
  </xs:complexType>

  <!-- 5.2 Learning Resource Type -->
  <xs:complexType name="learningResourceType">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="learningResourceTypeValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:learningResourceType"/>
  </xs:complexType>

  <!-- 5.3 Interactivity Level -->
  <xs:complexType name="interactivityLevel">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="interactivityLevelValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:interactivityLevel"/>
  </xs:complexType>

  <!-- 5.4 Semantic Density -->
  <xs:complexType name="semanticDensity">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="semanticDensityValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:semanticDensity"/>
  </xs:complexType>

  <!-- 5.5 Intended End User Role -->
  <xs:complexType name="intendedEndUserRole">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="intendedEndUserRoleValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:intendedEndUserRole"/>
  </xs:complexType>

  <!-- 5.6 Context -->
  <xs:complexType name="context">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="contextValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:context"/>
  </xs:complexType>

  <!-- 5.7 Typical Age Range -->
  <xs:complexType name="typicalAgeRange">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:typicalAgeRange"/>
  </xs:complexType>

  <!-- 5.8 Difficulty -->
  <xs:complexType name="difficulty">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="difficultyValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:difficulty"/>
  </xs:complexType>

  <!-- 5.9 Typical Learning Time -->
  <xs:complexType name="typicalLearningTime">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="duration" type="DurationValue"/>
         <xs:element name="description" type="description"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:typicalLearningTime"/>
  </xs:complexType>

  <!-- 6 Rights -->
  <xs:complexType name="rights">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="cost"/>
      <xs:element ref="copyrightAndOtherRestrictions"/>
      <xs:element ref="description"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:rights"/>
  </xs:complexType>

  <!-- 6.1 Cost -->
  <xs:complexType name="cost">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="costValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:cost"/>
  </xs:complexType>

  <!-- 6.2 Copyright and Other Restrictions -->
  <xs:complexType name="copyrightAndOtherRestrictions">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="copyrightAndOtherRestrictionsValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:copyrightAndOtherRestrictions"/>
  </xs:complexType>

  <!-- 6.3 Description -->
  <xs:complexType name="description">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:description"/>
  </xs:complexType>

  <!-- 7 Relation -->
  <xs:complexType name="relation">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="kind"/>
      <xs:element ref="resource"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:relation"/>
  </xs:complexType>

  <!-- 7.1 Kind -->
  <xs:complexType name="kind">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="kindValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:kind"/>
  </xs:complexType>

  <!-- 7.2 Resource -->
  <xs:complexType name="resource">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="identifier"/>
      <xs:element ref="description"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:resource"/>
  </xs:complexType>

  <!-- 8 Annotation -->
  <xs:complexType name="annotation">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element name="entity" type="entity"/> 
      <xs:element ref="date"/>
      <xs:element ref="description"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:annotation"/>
  </xs:complexType>

  <!-- 8.1 Entity -->
  <xs:complexType name="entity">
    <xs:simpleContent>
      <xs:extension base="VCard">
        <xs:attributeGroup ref="unique:entity"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 9 Classification -->
  <xs:complexType name="classification">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="purpose"/>
      <xs:element ref="taxonPath"/>
      <xs:element ref="description"/>
      <xs:element ref="keyword"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:classification"/>
  </xs:complexType>

  <!-- 9.1 Purpose -->
  <xs:complexType name="purpose">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="source" type="sourceValue"/>
         <xs:element name="value" type="purposeValue"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:purpose"/>
  </xs:complexType>

  <!-- 9.2 Taxon Path -->
  <xs:complexType name="taxonPath">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="source"/>
      <xs:element ref="taxon"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:taxonPath"/>
  </xs:complexType>

  <!-- 9.2.1 Source -->
  <xs:complexType name="source">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:source"/>
  </xs:complexType>

  <!-- 9.2.2 Taxon -->
  <xs:complexType name="taxon">
    <xs:choice minOccurs="0" maxOccurs="unbounded">
      <xs:element ref="id"/>
      <xs:element name="entry" type="entryTaxon"/>
      <xs:group ref="extend:customElements"/>
    </xs:choice>
    <xs:attributeGroup ref="unique:taxon"/>
  </xs:complexType>

  <!-- 9.2.2.1 Id -->
  <xs:complexType name="id">
    <xs:simpleContent>
      <xs:extension base="CharacterString">
        <xs:attributeGroup ref="unique:id"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

  <!-- 9.2.2.2 Entry -->
  <xs:complexType name="entryTaxon">
      <xs:choice minOccurs="0" maxOccurs="unbounded">
         <xs:element name="string" type="langString"/>
         <xs:group ref="extend:customElements"/>
      </xs:choice>
      <xs:attributeGroup ref="unique:entry"/>
  </xs:complexType>



   <!-- **********Vocabulary type declarations************** -->

   <!-- Source -->
   <xs:complexType name="sourceValue">
      <xs:simpleContent>
         <xs:extension base="vocab:source">
            <xs:attributeGroup ref="unique:source"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>
  
   <xs:complexType name="structureValue">
      <xs:simpleContent>
         <xs:extension base="vocab:structure">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>
  
   <xs:complexType name="aggregationLevelValue">
      <xs:simpleContent>
         <xs:extension base="vocab:aggregationLevel">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 2.2 Status -->

   <xs:complexType name="statusValue">
      <xs:simpleContent>
         <xs:extension base="vocab:status">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 2.3.1 Role  -->

   <xs:complexType name="roleValue">
      <xs:simpleContent>
         <xs:extension base="vocab:role">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 3.2.1 Role  -->
 
   <xs:complexType name="roleMetaValue">
      <xs:simpleContent>
         <xs:extension base="vocab:roleMeta">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 4.4.1.1 Type -->

   <xs:complexType name="typeValue">
      <xs:simpleContent>
         <xs:extension base="vocab:type">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 4.4.1.2 Name  -->

   <xs:complexType name="nameValue">
      <xs:simpleContent>
         <xs:extension base="vocab:name">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.1 Interactivity Type  -->

   <xs:complexType name="interactivityTypeValue">
      <xs:simpleContent>
         <xs:extension base="vocab:interactivityType">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.2 Learning Resource Type -->

   <xs:complexType name="learningResourceTypeValue">
      <xs:simpleContent>
         <xs:extension base="vocab:learningResourceType">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.3 Interactivity Level -->

   <xs:complexType name="interactivityLevelValue">
      <xs:simpleContent>
         <xs:extension base="vocab:interactivityLevel">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.4 Semantic Density -->

   <xs:complexType name="semanticDensityValue">
      <xs:simpleContent>
         <xs:extension base="vocab:semanticDensity">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.5 Intended End User Role -->

   <xs:complexType name="intendedEndUserRoleValue">
      <xs:simpleContent>
         <xs:extension base="vocab:intendedEndUserRole">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.6 Context -->

   <xs:complexType name="contextValue">
      <xs:simpleContent>
         <xs:extension base="vocab:context">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 5.8 Difficulty -->

   <xs:complexType name="difficultyValue">
      <xs:simpleContent>
         <xs:extension base="vocab:difficulty">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 6.1 Cost -->

   <xs:complexType name="costValue">
      <xs:simpleContent>
         <xs:extension base="vocab:cost">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 6.2 Copyright and Other Restrictions -->

   <xs:complexType name="copyrightAndOtherRestrictionsValue">
      <xs:simpleContent>
         <xs:extension base="vocab:copyrightAndOtherRestrictions">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 7.1 Kind -->

   <xs:complexType name="kindValue">
      <xs:simpleContent>
         <xs:extension base="vocab:kind">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- 9.1 Purpose -->

   <xs:complexType name="purposeValue">
      <xs:simpleContent>
         <xs:extension base="vocab:purpose">
            <xs:attributeGroup ref="unique:value"/>
         </xs:extension>
      </xs:simpleContent>
   </xs:complexType>

   <!-- LOM V1.0 Base Schema vocabulary source and value declarations -->

   <!-- Source -->
   <xs:simpleType name="sourceValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="LOMv1.0"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 1.7 Structure -->
   <xs:simpleType name="structureValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="atomic"/>
         <xs:enumeration value="collection"/>
         <xs:enumeration value="networked"/>
         <xs:enumeration value="hierarchical"/>
         <xs:enumeration value="linear"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 1.8 Aggregation Level -->
   <xs:simpleType name="aggregationLevelValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="1"/>
         <xs:enumeration value="2"/>
         <xs:enumeration value="3"/>
         <xs:enumeration value="4"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 2.2 Status -->
   <xs:simpleType name="statusValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="draft"/>
         <xs:enumeration value="final"/>
         <xs:enumeration value="revised"/>
         <xs:enumeration value="unavailable"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 2.3.1 Role -->
   <xs:simpleType name="roleValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="author"/>
         <xs:enumeration value="publisher"/>
         <xs:enumeration value="unknown"/>
         <xs:enumeration value="initiator"/>
         <xs:enumeration value="terminator"/>
         <xs:enumeration value="validator"/>
         <xs:enumeration value="editor"/>
         <xs:enumeration value="graphical designer"/>
         <xs:enumeration value="technical implementer"/>
         <xs:enumeration value="content provider"/>
         <xs:enumeration value="technical validator"/>
         <xs:enumeration value="educational validator"/>
         <xs:enumeration value="script writer"/>
         <xs:enumeration value="instructional designer"/>
         <xs:enumeration value="subject matter expert"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 3.2.1 Role -->
   <xs:simpleType name="roleMetaValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="creator"/>
         <xs:enumeration value="validator"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 4.4.1.1 Type -->
   <xs:simpleType name="typeValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="operating system"/>
         <xs:enumeration value="browser"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 4.4.1.2 Name -->
   <xs:simpleType name="nameValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="pc-dos"/>
         <xs:enumeration value="ms-windows"/>
         <xs:enumeration value="macos"/>
         <xs:enumeration value="unix"/>
         <xs:enumeration value="multi-os"/>
         <xs:enumeration value="none"/>
         <xs:enumeration value="any"/>
         <xs:enumeration value="netscape communicator"/>
         <xs:enumeration value="ms-internet explorer"/>
         <xs:enumeration value="opera"/>
         <xs:enumeration value="amaya"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.1 Interactivity Type -->
   <xs:simpleType name="interactivityTypeValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="active"/>
         <xs:enumeration value="expositive"/>
         <xs:enumeration value="mixed"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.2 Learning Resource Type -->
   <xs:simpleType name="learningResourceTypeValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="exercise"/>
         <xs:enumeration value="simulation"/>
         <xs:enumeration value="questionnaire"/>
         <xs:enumeration value="diagram"/>
         <xs:enumeration value="figure"/>
         <xs:enumeration value="graph"/>
         <xs:enumeration value="index"/>
         <xs:enumeration value="slide"/>
         <xs:enumeration value="table"/>
         <xs:enumeration value="narrative text"/>
         <xs:enumeration value="exam"/>
         <xs:enumeration value="experiment"/>
         <xs:enumeration value="problem statement"/>
         <xs:enumeration value="self assessment"/>
         <xs:enumeration value="lecture"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.3 Interactivity Level -->
   <xs:simpleType name="interactivityLevelValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="very low"/>
         <xs:enumeration value="low"/>
         <xs:enumeration value="medium"/>
         <xs:enumeration value="high"/>
         <xs:enumeration value="very high"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.4 Semantic Density -->
   <xs:simpleType name="semanticDensityValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="very low"/>
         <xs:enumeration value="low"/>
         <xs:enumeration value="medium"/>
         <xs:enumeration value="high"/>
         <xs:enumeration value="very high"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.5 Intended End User Role -->
   <xs:simpleType name="intendedEndUserRoleValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="teacher"/>
         <xs:enumeration value="author"/>
         <xs:enumeration value="learner"/>
         <xs:enumeration value="manager"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.6 Context -->
   <xs:simpleType name="contextValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="school"/>
         <xs:enumeration value="higher education"/>
         <xs:enumeration value="training"/>
         <xs:enumeration value="other"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 5.8 Difficulty -->
   <xs:simpleType name="difficultyValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="very easy"/>
         <xs:enumeration value="easy"/>
         <xs:enumeration value="medium"/>
         <xs:enumeration value="difficult"/>
         <xs:enumeration value="very difficult"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 6.1 Cost -->
   <xs:simpleType name="costValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="yes"/>
         <xs:enumeration value="no"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 6.2 Copyright and Other Restrictions -->
   <xs:simpleType name="copyrightAndOtherRestrictionsValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="yes"/>
         <xs:enumeration value="no"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 7.1 Kind -->
   <xs:simpleType name="kindValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="ispartof"/>
         <xs:enumeration value="haspart"/>
         <xs:enumeration value="isversionof"/>
         <xs:enumeration value="hasversion"/>
         <xs:enumeration value="isformatof"/>
         <xs:enumeration value="hasformat"/>
         <xs:enumeration value="references"/>
         <xs:enumeration value="isreferencedby"/>
         <xs:enumeration value="isbasedon"/>
         <xs:enumeration value="isbasisfor"/>
         <xs:enumeration value="requires"/>
         <xs:enumeration value="isrequiredby"/>
      </xs:restriction>
   </xs:simpleType>

   <!-- 9.1 Purpose -->
   <xs:simpleType name="purposeValues">
      <xs:restriction base="xs:token">
         <xs:enumeration value="discipline"/>
         <xs:enumeration value="idea"/>
         <xs:enumeration value="prerequisite"/>
         <xs:enumeration value="educational objective"/>
         <xs:enumeration value="accessibility restrictions"/>
         <xs:enumeration value="educational level"/>
         <xs:enumeration value="skill level"/>
         <xs:enumeration value="security level"/>
         <xs:enumeration value="competency"/>
      </xs:restriction>
   </xs:simpleType>

</xs:schema>