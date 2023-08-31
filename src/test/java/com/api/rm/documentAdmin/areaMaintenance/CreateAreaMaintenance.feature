Feature: Area Maintenance - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def areaMaintenanceCollectionName = 'CreateAreaMaintenance_'
    And def areaMaintenanceCollectionNameRead = 'AreaMaintenanceDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateAreaMaintenance
  Scenario Outline: Create a Area Maintenance with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateAreaMaintenance'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createAreaMaintenanceCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "CreateAreaMaintenance"                        |
      | entityName      | "AreaMaintenance"                              |
      | ttl             |                                              0 |
    And set createAreaMaintenanceCommandBody
      | path           |                        0 |
      | id             | entityIdData             |
      | areaCode       | faker.getUserId()        |
      | description    | faker.getRandomNumber()  |
      | townCode       | faker.getUserId()        |
      | townDirection  | faker.getDirection()     |
      | range          | faker.getUserId()        |
      | rangeDirection | faker.getDirection()     |
      | isActive       | faker.getRandomBoolean() |
    And set createAreaMaintenancePayload
      | path   | [0]                                   |
      | header | createAreaMaintenanceCommandHeader[0] |
      | body   | createAreaMaintenanceCommandBody[0]   |
    And print createAreaMaintenancePayload
    And request createAreaMaintenancePayload
    When method POST
    Then status 201
    And def createAreaMaintenanceResponse = response
    And print createAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,areaMaintenanceCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createAreaMaintenanceResponse.body.id
    And match createAreaMaintenanceResponse.body.townDirection == createAreaMaintenancePayload.body.townDirection

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAreaMaintenanceWithMandatoryFields
  Scenario Outline: Create a Area Maintenance with mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateAreaMaintenance'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createAreaMaintenanceCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "CreateAreaMaintenance"                        |
      | entityName      | "AreaMaintenance"                              |
      | ttl             |                                              0 |
    And set createAreaMaintenanceCommandBody
      | path        |                       0 |
      | id          | entityIdData            |
      | areaCode    | faker.getUserId()       |
      | description | faker.getRandomNumber() |
    And set createAreaMaintenancePayload
      | path   | [0]                                   |
      | header | createAreaMaintenanceCommandHeader[0] |
      | body   | createAreaMaintenanceCommandBody[0]   |
    And print createAreaMaintenancePayload
    And request createAreaMaintenancePayload
    When method POST
    Then status 201
    And def createAreaMaintenanceResponse = response
    And print createAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,areaMaintenanceCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createAreaMaintenanceResponse.body.id
    And match createAreaMaintenanceResponse.body.areaCode == createAreaMaintenancePayload.body.areaCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetAreaMaintenace
  Scenario Outline: Get the Area Maintenacne details
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.SourceID()                    |
      | correlationId   | dataGenerator.SourceID()                    |
      | commandUserId   | dataGenerator.SourceID()                    |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | "GetAreaMaintenance"                        |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |      0 |
      | id   | areaId |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,getCountyAreaMaintenanceResponse.id)
    And print mongoResult
    And match mongoResult == getCountyAreaMaintenanceResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
