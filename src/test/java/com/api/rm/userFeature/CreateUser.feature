# This feature file created to use the response of these scenarios in the UserE2E feature
Feature: Create a New User

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def userCollectionName = 'CreateUser_'
    And def userCollectionNameRead = 'UserDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('../helpers/Wait.feature@wait')

  @createUserWithAllFields
  Scenario Outline: Scenario to create the new user
    Given url commandBaseUrl
    And path '/api/CreateUser'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | ["PII"]                                 |
      | commandType     | "CreateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path      |                   0 |
      | id        | entityIdData        |
      | firstName | firstname           |
      | lastName  | faker.getLastName() |
      | userId    | faker.getEmail()    |
      | isActive  | true                |
    And set createUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print createUserPayload
    And request createUserPayload
    When method POST
    Then status 201
    And def createUserResponse = response
    And print createUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,userCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createUserResponse.body.id
    And match createUserResponse.body.firstName == firstname

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createUserWithMandatoryFields
  Scenario Outline: Scenario to create the new user with mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateUser'
    And def userEmail = faker.getEmail()
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | ["PII"]                                 |
      | commandType     | "CreateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path   |            0 |
      | id     | entityIdData |
      | userId | userEmail    |
    And set createUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print createUserPayload
    And request createUserPayload
    When method POST
    Then status 201
    And def createUserResponse = response
    And print createUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,userCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createUserResponse.body.id
    And match createUserResponse.body.userId == userEmail

    Examples: 
      | tenantid    |
      | tenantID[0] |
