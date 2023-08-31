Feature: GenericLayoutPropertyType

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateGenericLayoutPropertyType_'
    And def genericLayoutNameCollectionNameRead = 'GenericLayoutPropertyTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutPropertyType']
    And def propertyCategory = [ "Condo","Subdivision","SectionLandAcreage","Land"]
    And def entityName = ['GenericLayoutPropertyType']
    And def fieldsCollection = ["Legal Description"]

  @CreateGenericLayoutCondoPropertyTypewithallfields
  Scenario Outline: Create a generic layout condo property type with all the fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[0]             |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    And match createGenericLayoutPropertyTypeResponse.body.longDescription == createGenericLayoutPropertyTypePayload.body.longDescription
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
       Examples: 
      | tenantid    |
      | tenantID[0] |
      

  @CreateGenericLayoutSubdivisionPropertyTypewithallfields
  Scenario Outline: Create a generic layout subdivision property type with all the fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[1]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    And match createGenericLayoutPropertyTypeResponse.body.longDescription == createGenericLayoutPropertyTypePayload.body.longDescription

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutSectionPropertyTypewithallfields
  Scenario Outline: Create a generic layout section property type with all the fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[2]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
	  And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    And match createGenericLayoutPropertyTypeResponse.body.longDescription == createGenericLayoutPropertyTypePayload.body.longDescription
	
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutLandPropertyTypewithallfields
  Scenario Outline: Create a generic layout land property type with all the fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[3]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    And match createGenericLayoutPropertyTypeResponse.body.longDescription == createGenericLayoutPropertyTypePayload.body.longDescription

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutLandPropertyTypewithMandatoryFields
  Scenario Outline: Create a generic layout land property type with only mandatory fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[3]		            |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
 @CreateGenericLayoutSectionPropertyTypewithMandatoryFields
  Scenario Outline: Create a generic layout section property type with only mandatory fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[2]		            |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @CreateGenericLayoutSubdivisionPropertyTypewithMandatoryFields
  Scenario Outline: Create a generic layout subdivision property type with only mandatory fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[1]		            |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
   @CreateGenericLayoutCondoPropertyTypewithMandatoryFields
  Scenario Outline: Create a generic layout condo property type with only mandatory fields and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[0]		            |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 201
    And def createGenericLayoutPropertyTypeResponse = response
    And print createGenericLayoutPropertyTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypewithMandatoryFieldsLayoutCodeMissing
  Scenario Outline: Create a generic layout property type with  mandatory fields missing and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[0]          |
      #| layoutCode        | faker.getUserId()          |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 400
   
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypewithMandatoryFieldsLayoutDescriptionMissing
  Scenario Outline: Create a generic layout property type with  mandatory fields missing and Validate
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path             |                        0 |
      | id               | entityIdData             |
      | layoutType       | layoutType[0]            |
      | fieldsCollection | fieldsCollection[0]      |
      | propertyCategory | propertyCategory[1]  |
      | layoutCode       | faker.getUserId()        |
      #| layoutDescription | faker.getRandomShortDescription() |
      | isActive         | faker.getRandomBoolean() |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 400
    
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutPropertyTypewithInvaliddata
  Scenario Outline: Create a generic layout property type with  invalid data
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
    And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set createGenericLayoutPropertyTypeCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]          |
      | propertyCategory  | propertyCategory[3]         |
      | layoutCode        | ""                                |
      | layoutDescription | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 400
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @GetGenericLayoutCondoPropertyType
      Scenario Outline: Get all the details of Generic Layout Condo Property Type
     
    Given url readBaseUrl
    And path '/api/GetGenericLayoutPropertyType'
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | createGenericLayoutPropertyTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | createGenericLayoutPropertyTypeResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyTypeResponse.header.correlationId |
      | commandUserId   | createGenericLayoutPropertyTypeResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | "GetGenericLayoutPropertyType"                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | createGenericLayoutPropertyTypeResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
      Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
@CreateGenericLayoutPropertyTypewithDuplicateValue
Scenario Outline: Create a generic layout property type with duplicate value
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutPropertyType'
     #Create Generic Layout Condo Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithallfields')
    And def createGenericLayoutPropertyTypeResponse = result.response
    And print createGenericLayoutPropertyTypeResponse
    And def propertyId = createGenericLayoutPropertyTypeResponse.body.layoutCode
    	 
    And def entityIdData = dataGenerator.entityID()
    And def layoutType = ['Property Type']
      And set createGenericLayoutPropertyTypeCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
       And set createGenericLayoutPropertyCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | propertyCategory  | propertyCategory[0]             |
      | layoutCode        | createGenericLayoutPropertyTypeResponse.body.layoutCode     |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutPropertyTypePayload
      | path   | [0]                                             |
      | header | createGenericLayoutPropertyTypeCommandHeader[0] |
      | body   | createGenericLayoutPropertyCommandBody[0]   |
    And print createGenericLayoutPropertyTypePayload
    And request createGenericLayoutPropertyTypePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:GenericLayoutPropertyType cannot be created'
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
     
      
      #@CreateGenericLayoutPropertyTypewithallfields
  #Scenario Outline: Create a generic layout  property type with all the fields and Validate
    #Given url commandBaseGenericLayout
    #And path '/api/CreateGenericLayoutPropertyType'
    #And def entityIdData = dataGenerator.entityID()
    #And def layoutType = ['Property Type']
    #And set createGenericLayoutPropertyTypeCommandHeader
      #| path            |                                                        0 |
      #| schemaUri       | schemaUri+"/CreateGenericLayoutPropertyType-v1.001.json" |
      #| commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      #| version         | "1.001"                                                  |
      #| sourceId        | dataGenerator.SourceID()                                 |
      #| tenantId        | <tenantid>                                               |
      #| id              | dataGenerator.Id()                                       |
      #| correlationId   | dataGenerator.correlationId()                            |
      #| entityId        | entityIdData                                             |
      #| commandUserId   | commandUserId                                            |
      #| entityVersion   |                                                        1 |
      #| tags            | []                                                       |
      #| commandType     | commandType[0]                                           |
      #| entityName      | entityName[0]                                            |
      #| ttl             |                                                        0 |
    #And set createGenericLayoutPropertyTypeCommandBody
      #| path              |                                 0 |
      #| id                | entityIdData                      |
      #| layoutType        | layoutType[0]                     |
      #| fieldsCollection  | fieldsCollection[0]               |
      #| propertyCategory  | <propertyCategory>               |
      #| layoutCode        | faker.getUserId()                 |
      #| layoutDescription | faker.getDescription()            |
      #| longDescription   | faker.getRandomShortDescription() |
      #| isActive          | faker.getRandomBoolean()          |
    #And set createGenericLayoutPropertyTypePayload
      #| path   | [0]                                             |
      #| header | createGenericLayoutPropertyTypeCommandHeader[0] |
      #| body   | createGenericLayoutPropertyTypeCommandBody[0]   |
    #And print createGenericLayoutPropertyTypePayload
    #And request createGenericLayoutPropertyTypePayload
    #When method POST
    #Then status 201
    #And def createGenericLayoutPropertyTypeResponse = response
    #And print createGenericLayoutPropertyTypeResponse
    #And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    #And print mongoResult
    #And match mongoResult == createGenericLayoutPropertyTypeResponse.body.id
    #And match createGenericLayoutPropertyTypeResponse.body.isActive == createGenericLayoutPropertyTypePayload.body.isActive
    #And match createGenericLayoutPropertyTypeResponse.body.layoutCode == createGenericLayoutPropertyTypePayload.body.layoutCode
    #And match createGenericLayoutPropertyTypeResponse.body.layoutType == createGenericLayoutPropertyTypePayload.body.layoutType
    #And match createGenericLayoutPropertyTypeResponse.body.layoutDescription == createGenericLayoutPropertyTypePayload.body.layoutDescription
    #And match createGenericLayoutPropertyTypeResponse.body.longDescription == createGenericLayoutPropertyTypePayload.body.longDescription
    #And match createGenericLayoutPropertyTypeResponse.body.id == createGenericLayoutPropertyTypePayload.body.id
    #And match createGenericLayoutPropertyTypeResponse.body.propertyCategory[0] == createGenericLayoutPropertyTypePayload.body.propertyCategory[0]
#
    #Examples: 
      #| tenantid    |propertyCategory|
      #| tenantID[0] |"Condo"|
      #| tenantID[0] |"Subdivision"|
      #| tenantID[0] |"Land"|
      
