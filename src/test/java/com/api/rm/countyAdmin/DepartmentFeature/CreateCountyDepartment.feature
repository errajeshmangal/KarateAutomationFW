# This feature file created to use the response of these scenarios in the E2E County Department feature
Feature: County Departments - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyDepartmentCollectionName = 'CreateCountyDepartment_'
    And def countyDepartmentCollectionNameRead = 'CountyDepartmentDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyDepartment
  Scenario Outline: Create a county department information with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def result = call read('../Location/CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def result1 = call read('../Location/CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse1 = result1.response
    And print addCountyLocationResponse1
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
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
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                        0 |
      | id             | entityIdData             |
      | name           | firstname                |
      | code           | faker.getUserId()        |
      | officialsName  | faker.getFirstName()     |
      | officialsTitle | faker.getLastName()      |
      | isActive       | faker.getRandomBoolean() |
    And set commandLocations
      | path |                                   0 |
      | id   | addCountyLocationResponse.body.id   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set commandLocations
      | path |                                    1 |
      | id   | addCountyLocationResponse1.body.id   |
      | name | addCountyLocationResponse1.body.name |
      | code | addCountyLocationResponse1.body.code |
    And set commandGlCode
      | path |                                          0 |
      | id   | addCountyLocationResponse.body.glCode.id   |
      | name | addCountyLocationResponse.body.glCode.name |
      | code | addCountyLocationResponse.body.glCode.code |
    And set addCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
      | body.glCode    | commandGlCode[0] |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 201
    And def addCountyDepartmentResponse = response
    And print addCountyDepartmentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyDepartmentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyDepartmentResponse.body.id
    And match addCountyDepartmentResponse.body.name == firstname
    And match addCountyDepartmentResponse.body.locations[0].name == addCountyLocationResponse.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyDepartmentWithMandatoryFields
  Scenario Outline: Create a county department information with only the mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def result = call read('../Location/CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
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
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                        0 |
      | id             | entityIdData             |
      | name           | firstname                |
      | code           | faker.getUserId()        |
      | officialsName  | faker.getFirstName()     |
      | officialsTitle | faker.getLastName()      |
      | isActive       | faker.getRandomBoolean() |
    And set commandLocations
      | path |                                   0 |
      | id   | addCountyLocationResponse.body.id   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set addCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 201
    And def addCountyDepartmentResponse = response
    And print addCountyDepartmentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyDepartmentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyDepartmentResponse.body.id
    And match addCountyDepartmentResponse.body.name == firstname
    And match addCountyDepartmentResponse.body.locations[0].name == addCountyLocationResponse.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
