Feature: Condo Maintenance - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def condoMaintenanceCollectionName = 'CreateCondoMaintenance_'
    And def condoMaintenanceCollectionNameRead = 'CondoMaintenanceDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCondoMaintenance
  Scenario Outline: Create a Condo Maintenance with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCondoMaintenance'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenance
    And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@@createAreaMaintenaceWithAllFieldsAndGetTheDetails')
    And def createAreaMaintenanceResponse = result.response
    And print createAreaMaintenanceResponse
    And set createCondoMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCondoMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCondoMaintenance"                        |
      | entityName      | "CondoMaintenance"                              |
      | ttl             |                                               0 |
    And set createCondoMaintenanceCommandBody
      | path           |                                 0 |
      | id             | entityIdData                      |
      | code           | faker.getUserId()                 |
      | description    | faker.getRandomNumber()           |
      | townCode       | faker.getUserId()                 |
      | townDirection  | faker.getDirection()              |
      | range          | faker.getUserId()                 |
      | rangeDirection | faker.getDirection()              |
      | isActive       | faker.getRandomBoolean()          |
      | liber          | faker.getRandomShortDescription() |
      | page           | faker.getRandomShortDescription() |
      | phase          | faker.getRandomNumber()           |
    And set createCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | createAreaMaintenanceResponse.body.id          |
      | code | createAreaMaintenanceResponse.body.areaCode    |
      | name | createAreaMaintenanceResponse.body.description |
    And set createCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | createCondoMaintenanceCommandHeader[0]   |
      | body          | createCondoMaintenanceCommandBody[0]     |
      | body.areaCode | createCondoMaintenanceCommandAreaCode[0] |
    And print createCondoMaintenancePayload
    And request createCondoMaintenancePayload
    When method POST
    Then status 201
    And def createCondoMaintenanceResponse = response
    And print createCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,condoMaintenanceCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCondoMaintenanceResponse.body.id
    And match createCondoMaintenanceResponse.body.code == createCondoMaintenancePayload.body.code
    And match createCondoMaintenanceResponse.body.liber == createCondoMaintenancePayload.body.liber

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCondoMaintenanceWithMandatoryFields
  Scenario Outline: Create a Condo Maintenance with mandatory fields and validate
    Given url commandBaseUrl
    And path '/api/CreateCondoMaintenance'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenance
    And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def createAreaMaintenanceResponse = result.response
    And print createAreaMaintenanceResponse
    And set createCondoMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCondoMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCondoMaintenance"                        |
      | entityName      | "CondoMaintenance"                              |
      | ttl             |                                               0 |
    And set createCondoMaintenanceCommandBody
      | path        |                       0 |
      | id          | entityIdData            |
      | code        | faker.getUserId()       |
      | description | faker.getRandomNumber() |
    And set createCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | createAreaMaintenanceResponse.body.id          |
      | code | createAreaMaintenanceResponse.body.areaCode    |
      | name | createAreaMaintenanceResponse.body.description |
    And set createCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | createCondoMaintenanceCommandHeader[0]   |
      | body          | createCondoMaintenanceCommandBody[0]     |
      | body.areaCode | createCondoMaintenanceCommandAreaCode[0] |
    And print createCondoMaintenancePayload
    And request createCondoMaintenancePayload
    When method POST
    Then status 201
    And def createCondoMaintenanceResponse = response
    And print createCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,condoMaintenanceCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCondoMaintenanceResponse.body.id
    And match createCondoMaintenanceResponse.body.description == createCondoMaintenancePayload.body.description
    And match createCondoMaintenanceResponse.body.areaCode.code == createCondoMaintenancePayload.body.areaCode.code

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @getCondoMaintenance
  Scenario Outline: Get the condo Maintenance
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.SourceID()                     |
      | correlationId   | dataGenerator.SourceID()                     |
      | commandUserId   | dataGenerator.SourceID()                     |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | "GetCondoMaintenance"                        |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |             0 |
      | id   | condoEntityId |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,getCountyCondoMaintenanceResponse.id)
    And print mongoResult
    And match mongoResult == getCountyCondoMaintenanceResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
