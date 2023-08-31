@FundCodes
Feature: Fund Codes, Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def fundCodesCollectionName = 'CreateFundCode_'
    And def fundCodesCollectionNameRead = 'FundCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateFundCodes
  Scenario Outline: Create a Fund code with all the details
    Given url commandBaseUrl
    And path '/api/CreateFundCode'
    And def entityIdData = dataGenerator.entityID()
    And set createFundCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateFundCode-v1.001.json" |
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
      | commandType     | "CreateFundCode"                        |
      | entityName      | "FundCode"                              |
      | ttl             |                                       0 |
    And set createFundCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | fundCode1         | faker.getUserId()                 |
      | shortDescription | faker.getRandomShortDescription() |
      | longDescription  | faker.getRandomLongDescription()  |
      | isActive         | faker.getRandomBoolean()          |
      | fundType         | faker.getRandomFundType()         |
      | fund             | faker.getFirstName()              |
      | department       | faker.getLastName()               |
      | authority        | faker.getLastName()               |
      | project          | faker.getUserId()                 |
      | activity         | faker.getRandomShortDescription() |
      | account          | faker.getUserId()                 |
    And set createFundPayload
      | path   | [0]                        |
      | header | createFundCommandHeader[0] |
      | body   | createFundCommandBody[0]   |
    And print createFundPayload
    And request createFundPayload
    When method POST
    Then status 201
    And print response
    And def createFundResponse = response
    And print createFundResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,fundCodesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFundResponse.body.id
    And match createFundResponse.body.shortDescription == createFundPayload.body.shortDescription

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFundCodesWithMandatoryFields
  Scenario Outline: Create a Fund code with only Mandatory details
    Given url commandBaseUrl
    And path '/api/CreateFundCode'
    And def entityIdData = dataGenerator.entityID()
    And set createFundCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateFundCode-v1.001.json" |
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
      | commandType     | "CreateFundCode"                        |
      | entityName      | "FundCode"                              |
      | ttl             |                                       0 |
    And set createFundCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | fundCode         | faker.getUserId()                 |
      | shortDescription | faker.getRandomShortDescription() |
      | longDescription  | faker.getRandomLongDescription()  |
      | fundType         | faker.getRandomFundType()         |
      | authority        | faker.getLastName()               |
      | project          | faker.getUserId()                 |
      | activity         | faker.getRandomShortDescription() |
    And set createFundPayload
      | path   | [0]                        |
      | header | createFundCommandHeader[0] |
      | body   | createFundCommandBody[0]   |
    And print createFundPayload
    And request createFundPayload
    When method POST
    Then status 201
    And print response
    And def createFundResponse = response
    And print createFundResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,fundCodesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFundResponse.body.id
    And match createFundResponse.body.activity == createFundPayload.body.activity

    Examples: 
      | tenantid    |
      | tenantID[0] |
