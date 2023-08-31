Feature: Create Menu Definition

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def MenuDefintionCollectionName = 'CreateMenuDefinition_'
    And def MenuDefintionCollectionNameRead = 'MenuDefinitionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateMenuDefinition"]
    And def entityName = ["MenuDefinition"]
    And def isActive = [true,false]

  @CreateMenuDefinitionWithAllFields
  Scenario Outline: Create Menu Definition with all details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                                 0 |
      | id              | entityIdData                      |
      | menuName        | faker.getUserId()                 |
      | menuDescription | faker.getRandomShortDescription() |
      | isActive        | faker.getRandomBooleanValue()     |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 201
    And def createMenuDefinitionResponse = response
    And print createMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuDefinitionResponse.body.id
    And match createMenuDefinitionPayload.body.id == createMenuDefinitionResponse.body.id
    And match createMenuDefinitionPayload.body.menuName == createMenuDefinitionResponse.body.menuName
    And match createMenuDefinitionPayload.body.menuDescription == createMenuDefinitionResponse.body.menuDescription
    And match createMenuDefinitionPayload.body.isActive == createMenuDefinitionResponse.body.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithMandatoryFields
  Scenario Outline: Create Menu Definition with mandatory details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                                 0 |
      | id              | entityIdData                      |
      | menuName        | faker.getUserId()                 |
      | menuDescription | faker.getRandomShortDescription() |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 201
    And def createMenuDefinitionResponse = response
    And print createMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuDefinitionResponse.body.id
    And match createMenuDefinitionPayload.body.id == createMenuDefinitionResponse.body.id
    And match createMenuDefinitionPayload.body.menuName == createMenuDefinitionResponse.body.menuName
    And match createMenuDefinitionPayload.body.menuDescription == createMenuDefinitionResponse.body.menuDescription
    And match createMenuDefinitionResponse.body.isActive == createMenuDefinitionResponse.body.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |
