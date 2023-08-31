@CountyAreaFeature
Feature: County Area - Add , Update

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyAreaCollectionName = 'CreateCountyArea_'
    And def countyAreaCollectionNameRead = 'UserDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyAreaWithAllDetails
  Scenario Outline: Create a county Area information with all the fields
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartment')
    And def crateCountyDepartmentResponse = result.response
    And print crateCountyDepartmentResponse
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                        0 |
      | id       | entityIdData             |
      | code     | faker.getUserId()        |
      | name     | faker.getFirstName()     |
      | isActive | faker.getRandomBoolean() |
      | comments | faker.getRandomNumber()  |
    And set commandAreaDepartment
      | path |                                       0 |
      | id   | crateCountyDepartmentResponse.body.id   |
      | code | crateCountyDepartmentResponse.body.code |
      | name | crateCountyDepartmentResponse.body.name |
    And set commandAreaGLCode
      | path |                                              0 |
      | id   | crateCountyDepartmentResponse.body.glCode.id   |
      | name | crateCountyDepartmentResponse.body.glCode.name |
      | code | crateCountyDepartmentResponse.body.glCode.code |
    And set addCountyAreaPayload
      | path            | [0]                      |
      | header          | commandAreaHeader[0]     |
      | body            | commandAreaBody[0]       |
      | body.department | commandAreaDepartment[0] |
      | body.glCode     | commandAreaGLCode[0]     |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 201
    And def addCountyAreaResponse = response
    And print addCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyAreaResponse.body.id
    And match addCountyAreaResponse.body.name == addCountyAreaPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyAreaWithMandatoryDetails
  Scenario Outline: Create a county Area information with Mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartmentWithMandatoryFields')
    And def crateCountyDepartmentResponse = result.response
    And print crateCountyDepartmentResponse
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                        0 |
      | id       | entityIdData             |
      | code     | faker.getUserId()        |
      | name     | faker.getFirstName()     |
      | active   | faker.getRandomBoolean() |
      | comments | faker.getRandomNumber()  |
    And set commandAreaDepartment
      | path |                                       0 |
      | id   | crateCountyDepartmentResponse.body.id   |
      | code | crateCountyDepartmentResponse.body.code |
      | name | crateCountyDepartmentResponse.body.name |
    And set addCountyAreaPayload
      | path            | [0]                      |
      | header          | commandAreaHeader[0]     |
      | body            | commandAreaBody[0]       |
      | body.department | commandAreaDepartment[0] |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 201
    And def addCountyAreaResponse = response
    And print addCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyAreaResponse.body.id
    And match addCountyAreaResponse.body.name == addCountyAreaPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CountyDepatmentssBasedOnFlag
  Scenario Outline: Validate the county Locations are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetCountyDepartmentsIdCodeName'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/GetCountyDepartmentsIdCodeName-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | commandUserId   | commandUserId                                           |
      | tags            | []                                                      |
      | commandType     | "GetCountyDepartmentsIdCodeName"                        |
      | getType         | "Array"                                                 |
      | ttl             |                                                       0 |
    And set commandBodyRequest
      | path     |    0 |
      | code     |      |
      | isActive | true |
    And set getUsersCommandPagination
      | path        |      0 |
      | currentPage |      1 |
      | pageSize    |    100 |
      | sortBy      | "code" |
      | isAscending | false  |
    And set getCountyDepartmentsIdCodeNamePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | {}                           |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getCountyDepartmentsIdCodeNamePayload
    And request getCountyDepartmentsIdCodeNamePayload
    When method POST
    Then status 200
    And def getCountyDepartmentsIdCodeNameResponse = response
    And print getCountyDepartmentsIdCodeNameResponse
    And match each getCountyLocationsIdCodeNameResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
