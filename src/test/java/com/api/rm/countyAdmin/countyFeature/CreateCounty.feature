# This feature file created to use the response of these scenarios in the E2E Master County feature
Feature: Create the County functionality

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyMasterCollectionName = 'CreateCounty_'
    And def countyMasterCollectionNameRead = 'CountyDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @getCountyDetails
  Scenario Outline: Get the County Details
    Given url readBaseUrl
    And path '/api/GetCounty'
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetCounty-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | tags            | []                                      |
      | commandType     | "GetCounty"                             |
      | getType         | "Array"                                 |
      | ttl             |                                       0 |
    And set getCountyCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |                 1 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyPayload
      | path                | [0]                           |
      | header              | getCommandHeader[0]           |
      | body.request        | {}                            |
      | body.paginationSort | getCountyCommandPagination[0] |
    And print getCountyPayload
    And request getCountyPayload
    When method POST
    Then status 200

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createCounty
  Scenario Outline: Create a County with all the fields and validate the details
    Given url commandBaseUrl
    And path '/api/CreateCounty'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCounty-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | []                                      |
      | commandType     | "CreateCounty"                          |
      | entityName      | "County"                                |
      | ttl             |                                       0 |
    And set commandBody
      | path              |                           0 |
      | id                | entityIdData                |
      | name              |faker.getUserId()           |
      | code              |faker.getUserId()                   |
      | isActive          | true                        |
      | officialsName     | faker.getUserId()               |
      | officialsTitle    | faker.getUserId() |
      | startOfFiscalYear | "MAY"                     |
      | stateFipsCode     |                         111 |
      | countyFipsCode    |                         222 |
    And set commandAddress
      | path         |                0 |
      | addressLine1 | "Building 12"    |
      #     | addressLine2 | faker.getAddressLine() |
      | city         | "Pontiac"        |
      | state        | faker.getState() |
      | zipCode      | "48302"          |
    And set createCountyPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print createCountyPayload
    And request createCountyPayload
    When method POST
    Then status 201
    And print response
    And def createCountyResponse = response
    And print createCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyMasterCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCountyResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @create2ndCounty
  Scenario Outline: Create a 2nd County
    Given url commandBaseUrl
    And path '/api/CreateCounty'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCounty-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | []                                      |
      | commandType     | "CreateCounty"                          |
      | entityName      | "County"                                |
      | ttl             |                                       0 |
    And set commandBody
      | path              |                        0 |
      | id                | entityIdData             |
      | name              | faker.getFirstName()     |
      | code              | faker.getUserId()        |
      | isActive          | faker.getRandomBoolean() |
      | officialsName     | faker.getFirstName()     |
      | officialsTitle    | faker.getLastName()      |
      | startOfFiscalYear | faker.getRandomMonth()   |
      | stateFipsCode     |                      111 |
      | countyFipsCode    |                      222 |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set createCountyPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print createCountyPayload
    And request createCountyPayload
    When method POST
    Then status 400
    And print response
    And match response contains "County cannot be created. The count has already been setup"

    Examples: 
      | tenantid    |
      | tenantID[0] |
