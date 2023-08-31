Feature: Book Type - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def bookTypeCollectionName = 'CreateBookType_'
    And def bookTypeCollectionNameRead = 'BookTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateBookType
  Scenario Outline: Create a book type information with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateBookType'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createBookCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateBookType-v1.001.json" |
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
      | commandType     | "CreateBookType"                        |
      | entityName      | "BookType"                              |
      | ttl             |                                       0 |
    And set createBookCommandBody
      | path         |                        0 |
      | id           | entityIdData             |
      | bookTypeName | faker.getFirstName()     |
      | code         | faker.getUserId()        |
      | recordType   | 'Document'               |
      | isActive     | faker.getRandomBoolean() |
    And set createBookCommandDocumentClass
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | name | faker.getLastName()           |
      | code | faker.getUserId()             |
    And set addBookTypePayload
      | path               | [0]                               |
      | header             | createBookCommandHeader[0]        |
      | body               | createBookCommandBody[0]          |
      | body.documentClass | createBookCommandDocumentClass[0] |
    And print addBookTypePayload
    And request addBookTypePayload
    When method POST
    Then status 201
    And def addBookTypeResponse = response
    And print addBookTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,bookTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addBookTypeResponse.body.id
    And match addBookTypeResponse.body.bookTypeName == addBookTypePayload.body.bookTypeName

    Examples: 
      | tenantid    |
      | tenantID[0] |
