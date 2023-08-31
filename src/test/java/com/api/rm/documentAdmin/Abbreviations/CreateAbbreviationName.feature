Feature: Abbreviation - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def abbreviationNameCollectionName = 'CreateAbbreviationName_'
    And def abbreviationNameCollectionNameRead = 'AbbreviationNameDetailViewModel'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateNameAbbreviation @abb
  Scenario Outline: Create a Name Abbreviation with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateAbbreviationName'
    And def entityIdData = dataGenerator.entityID()
    And set createAbbreviationCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateAbbreviationName-v1.001.json" |
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
      | commandType     | "CreateAbbreviationName"                        |
      | entityName      | "AbbreviationName"                              |
      | ttl             |                                               0 |
    And set createAbbreviationCommandBody
      | path             |                        0 |
      | id               | entityIdData             |
      | abbreviationType | "Name"                   |
      | translationType  | "Shortcuts"              |
      | enteredData      | faker.getUserId()     |
      | fullTranslation  | faker.getDescription()   |
      | isActive         | faker.getRandomBoolean() |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 201
    And def createAbbreviationResponse = response
    And print createAbbreviationResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createAbbreviationResponse.body.id
    And match createAbbreviationResponse.body.enteredData == createAbbreviationPayload.body.enteredData
    And match createAbbreviationResponse.body.fullTranslation == createAbbreviationPayload.body.fullTranslation

    Examples: 
      | tenantid    |
      | tenantID[0] |
