@GenericLayoutDesignLayoutPropertyTypeFeature
Feature: Deisgn Layout-Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericPropertyTypeDesignLayoutNameCollectionName = 'CreateGenericLayoutPropertyTypeLayoutDesign_'
    And def genericPropertyTypeDesignLayoutCollectionNameRead = 'GenericLayoutPropertyTypeLayoutDesignDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutPropertyTypeLayoutDesign','GetGenericLayoutPropertyTypeLayoutDesign']
    And def entityName = ['GenericLayoutPropertyTypeLayoutDesign']
    And def fieldType = ["TextInput","DropDown","DatePicker","TextArea","CheckBox","RadioOptions","InputWithSearch"]
    And def propertyCategory = [ "Condo","Subdivision","SectionLandAcreage","Land"]
    And def fieldsCollection = ["LegalDescription","MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def condoFields = ["PropertyType","PinNumber","CondoCode","CondoDescription","Building","LowUnit","HighUnit","Phase","LowGarage","HighGarage","Split","PartFlag","NotInSidwell","Notes"]
    And def subdivisionFields = ["PropertyType","PinNumber","SubdivsionCode","SubdivsionDescription","Phase","Town","Range","Area","Block","LowLot","HighLot","City","Partial","NotInSidwell","Notes"]
    And def sectionLandAcreageFields = ["PropertyType","PinNumber","Acreage","AcreageDescription","Section","Township","TownshipRange","Range","RangeDirection","Lot","Part","Acres","Area","Half","Quarter","NotInSidwell","Notes"]
    And def landFields = ["PropertyType","LandCorners","LandCornersDescription","Section","Town","TownDirection","Range","RangeDirection","CornerLetter","CornerNumber","Notes"]

  @CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSubdivision
  Scenario Outline: Create a generic layout Design Layout with all the fields field type as text input and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyTypeLayoutDesign'
    And def entityIdData = dataGenerator.entityID()
    # calling create Generic Layout Subdivision Property Type api
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/masterInfo/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithallfields')
    And def createGenericLayoutPropertyTypeResponse = result.response
    And print createGenericLayoutPropertyTypeResponse
    And def propertyId = createGenericLayoutPropertyTypeResponse.body.id
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[13]+"')]")
    And print filteredObject13
    And def filteredObject14 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[14]+"')]")
    And print filteredObject14
    # create generic layout property type design layout
    And set createGenericLayoutPropertyTypeDesignLayoutCommandHeader
      | path            |                                                                    0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyTypeLayoutDesign-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                              |
      | version         | "1.001"                                                              |
      | sourceId        | dataGenerator.SourceID()                                             |
      | tenantId        | <tenantid>                                                           |
      | id              | dataGenerator.Id()                                                   |
      | correlationId   | dataGenerator.correlationId()                                        |
      | entityId        | entityIdData                                                         |
      | commandUserId   | commandUserId                                                        |
      | entityVersion   |                                                                    1 |
      | tags            | []                                                                   |
      | commandType     | commandType[0]                                                       |
      | entityName      | entityName[0]                                                        |
      | ttl             |                                                                    0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject4[0].placeHolderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject5[0].placeHolderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject6[0].placeHolderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject7[0].placeHolderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject8[0].placeHolderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       9 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject9[0].placeHolderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject10[0].placeHolderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject11[0].placeHolderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject12[0].placeHolderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       13 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject13[0].placeHolderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       14 |
      | fieldId                              | filteredObject14[0].fieldId                              |
      | fieldCode                            | filteredObject14[0].fieldCode                            |
      | fieldName                            | filteredObject14[0].fieldName                            |
      | fieldLabel                           | filteredObject14[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                             |
      | ovveriddenLabelText                  | filteredObject14[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject14[0].placeHolderText                      |
      | isRequiredField                      | filteredObject14[0].isRequiredField                      |
      | helpText                             | filteredObject14[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject14[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject14[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject14[0].row                                  |
      | columnNumber                         | filteredObject14[0].columnNumber                         |
      | size                                 | filteredObject14[0].size                                 |
      | dataCommand                          | filteredObject14[0].dataCommand                          |
    And set createGenericLayoutPropertyTypeDesignLayoutCommandBody
      | path           |            0 |
      | id             | entityIdData |
      | propertyTypeId | propertyId   |
    And set createGenericLayoutPropertyTypeDesignLayoutPayload
      | path        | [0]                                                         |
      | header      | createGenericLayoutPropertyTypeDesignLayoutCommandHeader[0] |
      | body        | createGenericLayoutPropertyTypeDesignLayoutCommandBody[0]   |
      | body.fields | commandfields                                               |
    And print createGenericLayoutPropertyTypeDesignLayoutPayload
    And request createGenericLayoutPropertyTypeDesignLayoutPayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeDesignLayoutResponse = response
    And print createGenericLayoutPropertyTypeDesignLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,createGenericLayoutPropertyTypeDesignLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeDesignLayoutResponse.body.id
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.propertyTypeId == createGenericLayoutPropertyTypeDesignLayoutPayload.body.propertyTypeId
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.id == createGenericLayoutPropertyTypeDesignLayoutPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsCondo
  Scenario Outline: Create a generic layout Design Layout with all the fields field type as text input and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyTypeLayoutDesign'
    And def entityIdData = dataGenerator.entityID()
    # calling create Generic Layout condo Property Type api
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/masterInfo/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithallfields')
    And def createGenericLayoutPropertyTypeResponse = result.response
    And print createGenericLayoutPropertyTypeResponse
    And def propertyId = createGenericLayoutPropertyTypeResponse.body.id
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[13]+"')]")
    And print filteredObject13
    # create generic layout property type design layout
    And set createGenericLayoutPropertyTypeDesignLayoutCommandHeader
      | path            |                                                                    0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyTypeLayoutDesign-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                              |
      | version         | "1.001"                                                              |
      | sourceId        | dataGenerator.SourceID()                                             |
      | tenantId        | <tenantid>                                                           |
      | id              | dataGenerator.Id()                                                   |
      | correlationId   | dataGenerator.correlationId()                                        |
      | entityId        | entityIdData                                                         |
      | commandUserId   | commandUserId                                                        |
      | entityVersion   |                                                                    1 |
      | tags            | []                                                                   |
      | commandType     | commandType[0]                                                       |
      | entityName      | entityName[0]                                                        |
      | ttl             |                                                                    0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject4[0].placeHolderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject5[0].placeHolderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject6[0].placeHolderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject7[0].placeHolderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject8[0].placeHolderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       9 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject9[0].placeHolderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject10[0].placeHolderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject11[0].placeHolderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject12[0].placeHolderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       13 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject13[0].placeHolderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set createGenericLayoutPropertyTypeDesignLayoutCommandBody
      | path           |            0 |
      | id             | entityIdData |
      | propertyTypeId | propertyId   |
    And set createGenericLayoutPropertyTypeDesignLayoutPayload
      | path        | [0]                                                         |
      | header      | createGenericLayoutPropertyTypeDesignLayoutCommandHeader[0] |
      | body        | createGenericLayoutPropertyTypeDesignLayoutCommandBody[0]   |
      | body.fields | commandfields                                               |
    And print createGenericLayoutPropertyTypeDesignLayoutPayload
    And request createGenericLayoutPropertyTypeDesignLayoutPayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeDesignLayoutResponse = response
    And print createGenericLayoutPropertyTypeDesignLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,createGenericLayoutPropertyTypeDesignLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeDesignLayoutResponse.body.id
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.propertyTypeId == createGenericLayoutPropertyTypeDesignLayoutPayload.body.propertyTypeId
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.id == createGenericLayoutPropertyTypeDesignLayoutPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSectionLandAcreage
  Scenario Outline: Create a generic layout Design Layout with all the fields field type as text input and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyTypeLayoutDesign'
    And def entityIdData = dataGenerator.entityID()
    # calling create Generic Layout Section Land Acreage Property Type api
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/masterInfo/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSectionPropertyTypewithallfields')
    And def createGenericLayoutPropertyTypeResponse = result.response
    And print createGenericLayoutPropertyTypeResponse
    And def propertyId = createGenericLayoutPropertyTypeResponse.body.id
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[13]+"')]")
    And print filteredObject13
    And def filteredObject14 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[14]+"')]")
    And print filteredObject14
    And def filteredObject15 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[15]+"')]")
    And print filteredObject15
    And def filteredObject16 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[16]+"')]")
    And print filteredObject16
    # create generic layout property type design layout
    And set createGenericLayoutPropertyTypeDesignLayoutCommandHeader
      | path            |                                                                    0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyTypeLayoutDesign-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                              |
      | version         | "1.001"                                                              |
      | sourceId        | dataGenerator.SourceID()                                             |
      | tenantId        | <tenantid>                                                           |
      | id              | dataGenerator.Id()                                                   |
      | correlationId   | dataGenerator.correlationId()                                        |
      | entityId        | entityIdData                                                         |
      | commandUserId   | commandUserId                                                        |
      | entityVersion   |                                                                    1 |
      | tags            | []                                                                   |
      | commandType     | commandType[0]                                                       |
      | entityName      | entityName[0]                                                        |
      | ttl             |                                                                    0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject4[0].placeHolderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject5[0].placeHolderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject6[0].placeHolderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject7[0].placeHolderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject8[0].placeHolderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       9 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject9[0].placeHolderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject10[0].placeHolderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject11[0].placeHolderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject12[0].placeHolderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       13 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject13[0].placeHolderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       14 |
      | fieldId                              | filteredObject14[0].fieldId                              |
      | fieldCode                            | filteredObject14[0].fieldCode                            |
      | fieldName                            | filteredObject14[0].fieldName                            |
      | fieldLabel                           | filteredObject14[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                             |
      | ovveriddenLabelText                  | filteredObject14[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject14[0].placeHolderText                      |
      | isRequiredField                      | filteredObject14[0].isRequiredField                      |
      | helpText                             | filteredObject14[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject14[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject14[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject14[0].row                                  |
      | columnNumber                         | filteredObject14[0].columnNumber                         |
      | size                                 | filteredObject14[0].size                                 |
      | dataCommand                          | filteredObject14[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       15 |
      | fieldId                              | filteredObject15[0].fieldId                              |
      | fieldCode                            | filteredObject15[0].fieldCode                            |
      | fieldName                            | filteredObject15[0].fieldName                            |
      | fieldLabel                           | filteredObject15[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                             |
      | ovveriddenLabelText                  | filteredObject15[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject15[0].placeHolderText                      |
      | isRequiredField                      | filteredObject15[0].isRequiredField                      |
      | helpText                             | filteredObject15[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject15[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject15[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject15[0].row                                  |
      | columnNumber                         | filteredObject15[0].columnNumber                         |
      | size                                 | filteredObject15[0].size                                 |
      | dataCommand                          | filteredObject15[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       16 |
      | fieldId                              | filteredObject16[0].fieldId                              |
      | fieldCode                            | filteredObject16[0].fieldCode                            |
      | fieldName                            | filteredObject16[0].fieldName                            |
      | fieldLabel                           | filteredObject16[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                             |
      | ovveriddenLabelText                  | filteredObject16[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject16[0].placeHolderText                      |
      | isRequiredField                      | filteredObject16[0].isRequiredField                      |
      | helpText                             | filteredObject16[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject16[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject16[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject16[0].row                                  |
      | columnNumber                         | filteredObject16[0].columnNumber                         |
      | size                                 | filteredObject16[0].size                                 |
      | dataCommand                          | filteredObject16[0].dataCommand                          |
    And set createGenericLayoutPropertyTypeDesignLayoutCommandBody
      | path           |            0 |
      | id             | entityIdData |
      | propertyTypeId | propertyId   |
    And set createGenericLayoutPropertyTypeDesignLayoutPayload
      | path        | [0]                                                         |
      | header      | createGenericLayoutPropertyTypeDesignLayoutCommandHeader[0] |
      | body        | createGenericLayoutPropertyTypeDesignLayoutCommandBody[0]   |
      | body.fields | commandfields                                               |
    And print createGenericLayoutPropertyTypeDesignLayoutPayload
    And request createGenericLayoutPropertyTypeDesignLayoutPayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeDesignLayoutResponse = response
    And print createGenericLayoutPropertyTypeDesignLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,createGenericLayoutPropertyTypeDesignLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeDesignLayoutResponse.body.id
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.propertyTypeId == createGenericLayoutPropertyTypeDesignLayoutPayload.body.propertyTypeId
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.id == createGenericLayoutPropertyTypeDesignLayoutPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsLand
  Scenario Outline: Create a generic layout Design Layout with all the fields field type as text input and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyTypeLayoutDesign'
    And def entityIdData = dataGenerator.entityID()
    # calling create Generic Layout Land Property Type api
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/masterInfo/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutLandPropertyTypewithallfields')
    And def createGenericLayoutPropertyTypeResponse = result.response
    And print createGenericLayoutPropertyTypeResponse
    And def propertyId = createGenericLayoutPropertyTypeResponse.body.id
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[10]+"')]")
    And print filteredObject10
    # create generic layout property type design layout
    And set createGenericLayoutPropertyTypeDesignLayoutCommandHeader
      | path            |                                                                    0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyTypeLayoutDesign-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                              |
      | version         | "1.001"                                                              |
      | sourceId        | dataGenerator.SourceID()                                             |
      | tenantId        | <tenantid>                                                           |
      | id              | dataGenerator.Id()                                                   |
      | correlationId   | dataGenerator.correlationId()                                        |
      | entityId        | entityIdData                                                         |
      | commandUserId   | commandUserId                                                        |
      | entityVersion   |                                                                    1 |
      | tags            | []                                                                   |
      | commandType     | commandType[0]                                                       |
      | entityName      | entityName[0]                                                        |
      | ttl             |                                                                    0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject4[0].placeHolderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject5[0].placeHolderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[6]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject6[0].placeHolderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject7[0].placeHolderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject8[0].placeHolderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       9 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject9[0].placeHolderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject10[0].placeHolderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set createGenericLayoutPropertyTypeDesignLayoutCommandBody
      | path           |            0 |
      | id             | entityIdData |
      | propertyTypeId | propertyId   |
    And set createGenericLayoutPropertyTypeDesignLayoutPayload
      | path        | [0]                                                         |
      | header      | createGenericLayoutPropertyTypeDesignLayoutCommandHeader[0] |
      | body        | createGenericLayoutPropertyTypeDesignLayoutCommandBody[0]   |
      | body.fields | commandfields                                               |
    And print createGenericLayoutPropertyTypeDesignLayoutPayload
    And request createGenericLayoutPropertyTypeDesignLayoutPayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeDesignLayoutResponse = response
    And print createGenericLayoutPropertyTypeDesignLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,createGenericLayoutPropertyTypeDesignLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeDesignLayoutResponse.body.id
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.propertyTypeId == createGenericLayoutPropertyTypeDesignLayoutPayload.body.propertyTypeId
    And match createGenericLayoutPropertyTypeDesignLayoutResponse.body.id == createGenericLayoutPropertyTypeDesignLayoutPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @getGenericLayoutPropertyTypeLayoutDesign
  Scenario Outline: Get the generic Layout MasterInfo details
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyTypeLayoutDesignCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.commandUserId()               |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.commandUserId()               |
      | correlationId   | dataGenerator.commandUserId()               |
      | commandUserId   | commandUserId                               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[1]                              |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getGenericLayoutPropertyTypeLayoutDesignCommandBody
      | path           |                 0 |
      | propertyTypeId | getpropertyTypeId |
    And set getGenericLayoutPropertyTypeLayoutDesignPayload
      | path         | [0]                                                      |
      | header       | getGenericLayoutPropertyTypeLayoutDesignCommandHeader[0] |
      | body.request | getGenericLayoutPropertyTypeLayoutDesignCommandBody[0]   |
    And print getGenericLayoutPropertyTypeLayoutDesignPayload
    And request getGenericLayoutPropertyTypeLayoutDesignPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyTypeDesignLayoutResponse = response
    And print getGenericLayoutPropertyTypeDesignLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericPropertyTypeDesignLayoutCollectionNameRead+<tenantid>,getGenericLayoutPropertyTypeDesignLayoutResponse.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyTypeDesignLayoutResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
