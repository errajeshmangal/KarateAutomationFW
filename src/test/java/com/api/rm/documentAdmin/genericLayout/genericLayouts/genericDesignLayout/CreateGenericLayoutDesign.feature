@GenericLayoutDesign
Feature: Generic Layout Design - Add, Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayOutLayoutDesignCollectionName = 'CreategenericLayOutLayoutDesign_'
    And def genericLayOutLayoutDesignCollectionNameRead = 'genericLayOutLayoutDesignDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateGenericLayoutDesignLayout','GetgenericLayOutLayoutDesign']
    And def eventTypes = ['GenericLayoutDesignLayout']
    And def layOutType = ['Generic Layout']
    And def masterInfoFields = ['SingleFilingCode','MultipleFilingCode','CustomerOrder#']
    And def fieldTypes = ["TextInput","DropDown", "DatePicker", "TextArea", "CheckBox", "RadioOptions","InputWithSearch"]
    And def fieldCollections = ["LegalDescription", "MarriageLicence", "DeathCertificate","BirthCertificate", "MasterInfo"]
    And def sectionTypes  = ["Custom" , "PreBuilt"]

  @CreateGenericLayOutDesign
  Scenario Outline: Create Generic Layout design with only fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    #Call the generic layout master info
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyle'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call to get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #call the custom sections
    And def getCustomSectionResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getCustomSections')
    And def getCustomSectionResultResponse = getCustomSectionResult.response
    And print getCustomSectionResultResponse
    #Call the master info fields
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+masterInfoFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+masterInfoFields[1]+"')]")
    And print filteredObject1
    And set genericLayoutDesignCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set genericLayoutDesignCommandBody
      | path     |                                     0 |
      | id       | entityIdData                          |
      | layoutId | getGenericLayoutMasterInfoResponse.id |
    And set genericLayoutErrorValidations
      | path           |                 0 |
      | validationType | faker.getUserId() |
      | errorMessage   | faker.getUserId() |
    And set genericLayoutErrorValidations1
      | path           |                 0 |
      | validationType | faker.getUserId() |
      | errorMessage   | faker.getUserId() |
    And set genericLayoutDesignMasterInfoFields
      | path                |                                     0 |
      | fieldId             | filteredObject[0].fieldId             |
      | fieldCode           | filteredObject[0].fieldCode           |
      | fieldName           | filteredObject[0].fieldName           |
      | fieldType           | fieldTypes[0]                         |
      | ovveriddenLabelText | filteredObject[0].ovveriddenLabelText |
      | placeholderText     | filteredObject[0].placeholderText     |
      | isRequiredField     | filteredObject[0].isRequiredField     |
      | helpText            | filteredObject[0].helpText            |
      | row                 | filteredObject[0].row                 |
      | columnNumber        | filteredObject[0].columnNumber        |
      | size                | filteredObject[0].size                |
      | dataCommand         | filteredObject[0].dataCommand         |
    And set genericLayoutDesignMasterInfoFields
      | path                |                                      1 |
      | fieldId             | filteredObject1[0].fieldId             |
      | fieldCode           | filteredObject1[0].fieldCode           |
      | fieldName           | filteredObject1[0].fieldName           |
      | fieldType           | fieldTypes[0]                          |
      | ovveriddenLabelText | filteredObject1[0].ovveriddenLabelText |
      | placeholderText     | filteredObject1[0].placeholderText     |
      | isRequiredField     | filteredObject1[0].isRequiredField     |
      | helpText            | filteredObject1[0].helpText            |
      | row                 | filteredObject1[0].row                 |
      | columnNumber        | filteredObject1[0].columnNumber        |
      | size                | filteredObject1[0].size                |
      | dataCommand         | filteredObject1[0].dataCommand         |
    And set genericLayoutDesignCustomSections
      | path              |                                                           0 |
      | id                | getCustomSectionResultResponse.results[0].id                |
      | layoutType        | getCustomSectionResultResponse.results[0].layoutType        |
      | layoutCode        | getCustomSectionResultResponse.results[0].layoutCode        |
      | fieldsCollection  | fieldCollections[1]                                         |
      | layoutDescription | getCustomSectionResultResponse.results[0].layoutDescription |
      | longDescription   | getCustomSectionResultResponse.results[0].longDescription   |
      | sectionType       | sectionTypes[0]                                             |
      | isActive          | getCustomSectionResultResponse.results[0].isActive          |
    And set genericLayoutDesignPayload
      | path                                        | [0]                                 |
      | header                                      | genericLayoutDesignCommandHeader[0] |
      | body                                        | genericLayoutDesignCommandBody[0]   |
      | body.masterInfoFields                       | genericLayoutDesignMasterInfoFields |
      | body.masterInfoFields[0].errorAndValidation | genericLayoutErrorValidations       |
      | body.masterInfoFields[1].errorAndValidation | genericLayoutErrorValidations1      |
      | body.sections                               | genericLayoutDesignCustomSections   |
    And print genericLayoutDesignPayload
    And request genericLayoutDesignPayload
    When method POST
    Then status 201
    And def genericLayoutDesignResponse = response
    And print genericLayoutDesignResponse

    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |
