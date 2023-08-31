@GenericLayoutMasterInfo
Feature: Generic Layout Master info - Add, Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayOutMasterInfoCollectionName = 'CreateGenericLayoutMasterInfo_'
    And def genericLayOutMasterInfoCollectionNameRead = 'GenericLayoutMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateGenericLayoutMasterInfo','GetGenericLayoutMasterInfo']
    And def eventTypes = ['GenericLayoutMasterInfo']
    And def layOutType = ['GenericLayout']

  @CreateGenericLayOutMasterInfo-IndexingStyle
  Scenario Outline: Validate Create Generic Layout Master Info information with all the fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
    And set genericLayOutMasterInfoCommandBody
      | path                    |                                0 |
      | id                      | entityIdData                     |
      | layoutCode              | faker.getUserId()                |
      | workFlowType            | workFlowType                     |
      | layoutType              | layOutType[0]                    |
      | layoutDescription       | faker.getRandomNumber()          |
      | longDescription         | faker.getRandomLongDescription() |
      | isActive                | faker.getRandomBooleanValue()    |
      | indexingStyle           | indexingStyle                    |
      | isShowAutoIndexValues   | faker.getRandomBooleanValue()    |
      | verificationStyle       | verificationStyle                |
      | isVerifyInSequence      | faker.getRandomBooleanValue()    |
      | isAllowToVerifyOwnIndex | faker.getRandomBooleanValue()    |
      | isShowAutoIndex         | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def addGenericLayOutMasterInfoResponse = response
    And print addGenericLayOutMasterInfoResponse
    And print dbNameGenericLayout+genericLayOutMasterInfoCollectionName+<tenantid>+entityIdData
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addGenericLayOutMasterInfoResponse.body.id
    #   And match addGenericLayOutMasterInfoResponse.body.isShowAutoIndex == genericLayOutMasterInfoPayload.body.isShowAutoIndex
    And match addGenericLayOutMasterInfoResponse.body.layoutCode == genericLayOutMasterInfoPayload.body.layoutCode
    And match addGenericLayOutMasterInfoResponse.body.workFlowType == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayOutMasterInfo-FillingCashiering
  Scenario Outline: Validate Create Generic Layout Master Info information with all the fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
    And set genericLayOutMasterInfoCommandBody
      | path              |                                0 |
      | id                | entityIdData                     |
      | workFlowType      | workFlowType                     |
      | layoutCode        | faker.getUserId()                |
      | layoutType        | layOutType[0]                    |
      | layoutDescription | faker.getRandomNumber()          |
      | longDescription   | faker.getRandomLongDescription() |
      | isActive          | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def addGenericLayOutMasterInfoResponse = response
    And print addGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addGenericLayOutMasterInfoResponse.body.id
    And match addGenericLayOutMasterInfoResponse.body.layoutCode == genericLayOutMasterInfoPayload.body.layoutCode
    And match addGenericLayOutMasterInfoResponse.body.workFlowType == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayOutMasterInfo-IndexingStyleWithMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with Mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
    And set genericLayOutMasterInfoCommandBody
      | path              |                       0 |
      | id                | entityIdData            |
      | layoutCode        | faker.getUserId()       |
      | workFlowType      | workFlowType            |
      | layoutType        | layOutType[0]           |
      | layoutDescription | faker.getRandomNumber() |
      | indexingStyle     | indexingStyle           |
      | verificationStyle | verificationStyle       |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def addGenericLayOutMasterInfoResponse = response
    And print addGenericLayOutMasterInfoResponse
    And print dbNameGenericLayout+genericLayOutMasterInfoCollectionName+<tenantid>+entityIdData
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addGenericLayOutMasterInfoResponse.body.id
    And match addGenericLayOutMasterInfoResponse.body.layoutCode == genericLayOutMasterInfoPayload.body.layoutCode
    And match addGenericLayOutMasterInfoResponse.body.workFlowType == 1
    And match addGenericLayOutMasterInfoResponse.body.isActive == false

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayOutMasterInfo-FillingCashieringWithMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with all the fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
    And set genericLayOutMasterInfoCommandBody
      | path              |                       0 |
      | id                | entityIdData            |
      | workFlowType      | workFlowType            |
      | layoutCode        | faker.getUserId()       |
      | layoutType        | layOutType[0]           |
      | layoutDescription | faker.getRandomNumber() |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def addGenericLayOutMasterInfoResponse = response
    And print addGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addGenericLayOutMasterInfoResponse.body.id
    And match addGenericLayOutMasterInfoResponse.body.layoutCode == genericLayOutMasterInfoPayload.body.layoutCode
    And match addGenericLayOutMasterInfoResponse.body.workFlowType == 0
    And match addGenericLayOutMasterInfoResponse.body.isActive == false

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @getGenericLayoutMasterInfo
  Scenario Outline: Get the generic Layout MasterInfo details
    Given url readBaseGenericLayout
    And path '/api/'+commandTypes[1]
    And set getGenericLayoutCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.commandUserId()                |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.commandUserId()                |
      | correlationId   | dataGenerator.commandUserId()                |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[1]                              |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getGenericLayoutCommandBody
      | path |                         0 |
      | id   | genericMasterInfoEntityId |
    And set getGenericLayoutPayload
      | path         | [0]                              |
      | header       | getGenericLayoutCommandHeader[0] |
      | body.request | getGenericLayoutCommandBody[0]   |
    And print getGenericLayoutPayload
    And request getGenericLayoutPayload
    When method POST
    Then status 200
    And def getGenericLayoutResponse = response
    And print getGenericLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayOutMasterInfoCollectionNameRead+<tenantid>,getGenericLayoutResponse.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
