# This feature file created to use the response of these scenarios in the E2E Book Type feature
@BookType
Feature: Book Type - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def bookTypecollectionname = 'CreateBookType_'
    And def  bookTypecollectionNameRead = 'BookTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateBookTypeWithAllFields
  Scenario Outline: Create a book type information with all the fields and Validate
    #Create a Book Type
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    #Get the Book Type
    Given url readBaseUrl
    And path '/api/GetBookType'
    And sleep(12000)
    And set getBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetBookType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetBookType"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getBookTypeCommandBody
      | path |                                   0 |
      | id   | addBookTypeResponse.header.entityId |
    And set getBookTypePayload
      | path         | [0]                         |
      | header       | getBookTypeCommandHeader[0] |
      | body.request | getBookTypeCommandBody[0]   |
    And print getBookTypePayload
    And request getBookTypePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getBookTypeAPIResponse = response
    And print getBookTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,bookTypecollectionNameRead+<tenantid>,addBookTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == getBookTypeAPIResponse.id
    And match getBookTypeAPIResponse.bookTypeName == addBookTypeResponse.body.bookTypeName
    #Get the Book Types
    Given url readBaseUrl
    And path '/api/GetBookTypes'
    And set getBookTypesCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetBookTypes-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetBookTypes"                           |
      | getType         | "Array"                                  |
      | ttl             |                                        0 |
    And set getBookTypesCommandBodyRequest
      | path         |                           0 |
      | request.code | getBookTypeAPIResponse.code |
    And set getBookTypesCommandDocumentClass
      | path |                                         0 |
      | id   | getBookTypeAPIResponse.documentClass.id   |
      | name | getBookTypeAPIResponse.documentClass.name |
      | code | getBookTypeAPIResponse.documentClass.code |
    And set getBookTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getBookTypesPayload
      | path                | [0]                                 |
      | header              | getBookTypesCommandHeader[0]        |
      | body.request        | {}                                  |
      | body.documentClass  | getBookTypesCommandDocumentClass[0] |
      | body.paginationSort | getBookTypesCommandPagination[0]    |
    And print getBookTypesPayload
    And request getBookTypesPayload
    When method POST
    Then status 200
    And def getBookTypesResponse = response
    And print getBookTypesResponse
    And match getBookTypesResponse.results[*].id contains addBookTypeResponse.body.code
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,bookTypecollectionNameRead+<tenantid>,addBookTypeResponse.body.id)
    And print mongoResult
    And def getBookTypesResponseCount = karate.sizeOf(getBookTypesResponse.results)
    And print getBookTypesResponseCount
    And match getBookTypesResponseCount == getBookTypesResponse.totalRecordCount
    And match each getBookTypesResponse.results[*].bookTypeName contains "Test"
    And match each getBookTypesResponse.results[*].bookTypeName == addBookTypeResponse.body.bookTypeName
    And match each getBookTypesResponse.results[*].active == true
    #Adding the comments
    And def entityName = "BookType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addBookTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "BookType"
    And def entityIdData = addBookTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #History Validations
    And def eventName = "BookTypeCreated"
    And def evnentType = "BookType"
    And def entityIdData = addBookTypeResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBookTypeInformationWithAllDetailsAndGetDetails
  Scenario Outline: Update a Book Type with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateBookType'
    #Create a Book Type and update
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    And set updateBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateBookType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | entityId        | addBookTypeResponse.header.entityId      |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateBookType"                         |
      | entityName      | "BookType"                               |
      | ttl             |                                        0 |
    And set updateBookTypeCommandBody
      | path         |                                   0 |
      | id           | addBookTypeResponse.header.entityId |
      | bookTypeName | faker.getFirstName()                |
      | code         | faker.getUserId()                   |
      | recordType   | 'Document'                          |
      | isActive     | faker.getRandomBoolean()            |
    And set updateBookTypeCommandDocumentClass
      | path |                                         0 |
      | id   | addBookTypeResponse.body.documentClass.id |
      | name | faker.getLastName()                       |
      | code | faker.getUserId()                         |
    And set updateBookTypePayload
      | path               | [0]                                   |
      | header             | updateBookTypeCommandHeader[0]        |
      | body               | updateBookTypeCommandBody[0]          |
      | body.documentClass | updateBookTypeCommandDocumentClass[0] |
    And print updateBookTypePayload
    And request updateBookTypePayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateBookTypeResponse = response
    And print updateBookTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,bookTypecollectionNameRead+<tenantid>,addBookTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateBookTypeResponse.body.id
    And match updateBookTypePayload.body.bookTypeName == updateBookTypeResponse.body.bookTypeName
    #Get the Book Type
    Given url readBaseUrl
    And path '/api/GetBookType'
    And sleep(12000)
    And set getBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetBookType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetBookType"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getBookTypeCommandBody
      | path |                                   0 |
      | id   | addBookTypeResponse.header.entityId |
    And set getBookTypePayload
      | path         | [0]                         |
      | header       | getBookTypeCommandHeader[0] |
      | body.request | getBookTypeCommandBody[0]   |
    And print getBookTypePayload
    And request getBookTypePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getBookTypeAPIResponse = response
    And print getBookTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,bookTypecollectionNameRead+<tenantid>,addBookTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == getBookTypeAPIResponse.id
    And match getBookTypeAPIResponse.bookTypeName == updateBookTypeResponse.body.bookTypeName
    #Get the Book Types
    Given url readBaseUrl
    And path '/api/GetBookTypes'
    And set getBookTypesCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetBookTypes-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetBookTypes"                           |
      | getType         | "Array"                                  |
      | ttl             |                                        0 |
    And set getBookTypesCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getBookTypesCommandDocumentClass
      | path |                                         0 |
      | id   | getBookTypeAPIResponse.documentClass.id   |
      | name | getBookTypeAPIResponse.documentClass.name |
      | code | getBookTypeAPIResponse.documentClass.code |
    And set getBookTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getBookTypesPayload
      | path                | [0]                                 |
      | header              | getBookTypesCommandHeader[0]        |
      | body.request        | {}                                  |
      | body.documentClass  | getBookTypesCommandDocumentClass[0] |
      | body.paginationSort | getBookTypesCommandPagination[0]    |
    And print getBookTypesPayload
    And request getBookTypesPayload
    When method POST
    Then status 200
    And def getBookTypesResponse = response
    And print getBookTypesResponse
    And match getBookTypesResponse.results[*].id contains addBookTypeResponse.body.id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,bookTypecollectionNameRead+<tenantid>,addBookTypeResponse.body.id)
    And print mongoResult
    And def getBookTypesResponseCount = karate.sizeOf(getBookTypesResponse.results)
    And print getBookTypesResponseCount
    And match getBookTypesResponseCount == getBookTypesResponse.totalRecordCount
    And match each getBookTypesResponse.results[*].active == true
    #Adding the comments
    And def entityName = "BookType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateBookTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "BookType"
    And def entityIdData = updateBookTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #History Validations
    And def eventName = "BookTypeUpdated"
    And def evnentType = "BookType"
    And def entityIdData = updateBookTypeResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateBookTypeWithInvalidData
  Scenario Outline: Create a book type information with invalidData to Mandatory Fields
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
      | path         |                    0 |
      | id           | entityIdData         |
      | bookTypeName | faker.getFirstName() |
      | code         | faker.getUserId()    |
      | recordType   | 'Document'           |
      | isActive     | entityIdData         |
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
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateBookTypeWithMissingMandatoryFields
  Scenario Outline: Create a book type information with missing Mandatory Fields
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
      | path         |                    0 |
      | id           | entityIdData         |
      | bookTypeName | faker.getFirstName() |
      | code         | faker.getUserId()    |
      | isActive     | entityIdData         |
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
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBookTypeInformationWithMissingMandatoryFields
  Scenario Outline: Update a Book Type with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateBookType'
    #Create a Book Type
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    And set updateBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateBookType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | entityId        | addBookTypeResponse.header.entityId      |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateBookType"                         |
      | entityName      | "BookType"                               |
      | ttl             |                                        0 |
    And set updateBookTypeCommandBody
      | path         |                                   0 |
      | id           | addBookTypeResponse.header.entityId |
      | bookTypeName | faker.getFirstName()                |
      | code         | faker.getUserId()                   |
      | recordType   | 'Document'                          |
      | isActive     | faker.getRandomBoolean()            |
    And set updateBookTypePayload
      | path   | [0]                            |
      | header | updateBookTypeCommandHeader[0] |
      | body   | updateBookTypeCommandBody[0]   |
    And print updateBookTypePayload
    And request updateBookTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBookTypeInformationWithInvalidData
  Scenario Outline: Update a Book Type with invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateBookType'
    #Creating Book Type to update
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    And set updateBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateBookType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | entityId        | addBookTypeResponse.header.entityId      |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateBookType"                         |
      | entityName      | "BookType"                               |
      | ttl             |                                        0 |
    And set updateBookTypeCommandBody
      | path         |                                   0 |
      | id           | addBookTypeResponse.header.entityId |
      | bookTypeName | faker.getFirstName()                |
      | code         | faker.getRandomBoolean()            |
      | recordType   | 'Document'                          |
      | isActive     | faker.getRandomBoolean()            |
    And set createBookCommandDocumentClass
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | name | faker.getLastName()           |
      | code | faker.getUserId()             |
    And set updateBookTypePayload
      | path   | [0]                            |
      | header | updateBookTypeCommandHeader[0] |
      | body   | updateBookTypeCommandBody[0]   |
    And print updateBookTypePayload
    And request updateBookTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateBookType
  Scenario Outline: Create a duplicate book type
    Given url commandBaseUrl
    And path '/api/CreateBookType'
    #Create a Book Type and update
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set duplicateBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateBookType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | entityId        | entityIdData                             |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "CreateBookType"                         |
      | entityName      | "BookType"                               |
      | ttl             |                                        0 |
    And set duplicateBookTypeCommandBody
      | path         |                             0 |
      | id           | entityIdData                  |
      | bookTypeName | faker.getFirstName()          |
      | code         | addBookTypeResponse.body.code |
      | recordType   | 'Document'                    |
      | isActive     | faker.getRandomBoolean()      |
    And set duplicateBookTypeCommandDocumentClass
      | path |                                         0 |
      | id   | addBookTypeResponse.body.documentClass.id |
      | name | faker.getLastName()                       |
      | code | faker.getUserId()                         |
    And set deleteBookTypePayload
      | path               | [0]                                      |
      | header             | duplicateBookTypeCommandHeader[0]        |
      | body               | duplicateBookTypeCommandBody[0]          |
      | body.documentClass | duplicateBookTypeCommandDocumentClass[0] |
    And print deleteBookTypePayload
    And request deleteBookTypePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:BookType cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDuplicateBookType
  Scenario Outline: Update a book type with duplicate name
    Given url commandBaseUrl
    And path '/api/UpdateBookType'
    #Create a Book Type
    And def result = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse = result.response
    And print addBookTypeResponse
    #Create a Book Type to use as a duplicate entity
    And def result1 = call read('CreateBookType.feature@CreateBookType')
    And def addBookTypeResponse1 = result1.response
    And print addBookTypeResponse1
    And set updateBookTypeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateBookType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addBookTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addBookTypeResponse.header.id            |
      | correlationId   | addBookTypeResponse.header.correlationId |
      | entityId        | addBookTypeResponse.header.entityId      |
      | commandUserId   | addBookTypeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateBookType"                         |
      | entityName      | "BookType"                               |
      | ttl             |                                        0 |
    And set updateBookTypeCommandBody
      | path         |                                   0 |
      | id           | addBookTypeResponse.header.entityId |
      | bookTypeName | faker.getFirstName()                |
      | code         | addBookTypeResponse1.body.code      |
      | recordType   | 'Document'                          |
      | isActive     | faker.getRandomBoolean()            |
    And set updateBookTypeCommandDocumentClass
      | path |                                         0 |
      | id   | addBookTypeResponse.body.documentClass.id |
      | name | faker.getLastName()                       |
      | code | faker.getUserId()                         |
    And set updateBookTypePayload
      | path               | [0]                                   |
      | header             | updateBookTypeCommandHeader[0]        |
      | body               | updateBookTypeCommandBody[0]          |
      | body.documentClass | updateBookTypeCommandDocumentClass[0] |
    And print updateBookTypePayload
    And request updateBookTypePayload
    When method POST
    Then status 500

    Examples: 
      | tenantid    |
      | tenantID[0] |

