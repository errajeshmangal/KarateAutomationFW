@AbbreviationName
Feature: Abbreviation - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def abbreviationNameCollectionName = 'CreateAbbreviationName_'
    And def abbreviationNameCollectionNameRead = 'AbbreviationNameDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @createNameAbbreviationWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a Name Abbreviation with all the fields and Get the details
    #Create Name Abbreviation  and Get the Details
    Given url readBaseUrl
    When path '/api/GetAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    #getAllAbbreviationName
    And set  getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationNames-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "Array"                                          |
    And set getAbbreviationNamesCommandBodyRequest
      | path             |                                                 0 |
      | abbreviationType | addNameAbbreviationResponse.body.abbreviationType |
    And set getAbbreviationNamesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationNamesPayload
      | path                | [0]                                       |
      | header              | getAbbreviationNamesCommandHeader[0]      |
      | body.request        | getAbbreviationNamesCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationNamesCommandPagination[0]  |
    And print getAbbreviationNamesPayload
    And request getAbbreviationNamesPayload
    When method POST
    Then status 200
    And def getAbbreviationNamesResponse = response
    And print getAbbreviationNamesResponse
    And match   getAbbreviationNamesResponse.results[0].abbreviationType == addNameAbbreviationResponse.body.abbreviationType
    And def getAbbreviationNamesResponseCount = karate.sizeOf(getAbbreviationNamesResponse.results)
    And print getAbbreviationNamesResponseCount
    And match getAbbreviationNamesResponseCount == getAbbreviationNamesResponse.totalRecordCount
    #GetAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationName'
    And set getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationName-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | getAbbreviationNameResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | getAbbreviationNameResponse.header.id            |
      | correlationId   | getAbbreviationNameResponse.header.correlationId |
      | commandUserId   | getAbbreviationNameResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getAbbreviationNameCommandBody
      | path |                                   0 |
      | id   | addNameAbbreviationResponse.body.id |
    And set getAbbreviationNamePayload
      | path         | [0]                                 |
      | header       | getAbbreviationNameCommandHeader[0] |
      | body.request | getAbbreviationNameCommandBody[0]   |
    And print getAbbreviationNamePayload
    And request getAbbreviationNamePayload
    When method POST
    Then status 200
    And def getAbbreviationNameResponse = response
    And print getAbbreviationNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationNameCollectionNameRead+<tenantid>,addNameAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationNameResponse.id
    And match getAbbreviationNameResponse.abbreviationType == addNameAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationNameCreated"
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationName"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addNameAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
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

  @createNameAbbreviationWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a Name Abbreviation with Mandatory fields and Get the details
    #Create Name Abbreviation  and Get the Details
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
      | path             |                      0 |
      | id               | entityIdData           |
      | abbreviationType | "Name"                 |
      | translationType  | "Shortcuts"            |
      | enteredData      | faker.getCityCode()    |
      | fullTranslation  | faker.getDescription() |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 201
    And def addNameAbbreviationResponse = response
    And print addNameAbbreviationResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addNameAbbreviationResponse.body.id
    And match addNameAbbreviationResponse.body.enteredData == createAbbreviationPayload.body.
    And match addNameAbbreviationResponse.body.fullTranslation == createAbbreviationPayload.body.fullTranslation
    #getAllAbbreviationName
    And set  getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationNames-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "Array"                                          |
    And set getAbbreviationNamesCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getAbbreviationNamesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationNamesPayload
      | path                | [0]                                       |
      | header              | getAbbreviationNamesCommandHeader[0]      |
      | body.request        | getAbbreviationNamesCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationNamesCommandPagination[0]  |
    And print getAbbreviationNamesPayload
    And request getAbbreviationNamesPayload
    When method POST
    Then status 200
    And def getAbbreviationNamesResponse = response
    And print getAbbreviationNamesResponse
    And match each getAbbreviationNamesResponse.results[*].active == true
    And def getAbbreviationNamesResponseCount = karate.sizeOf(getAbbreviationNamesResponse.results)
    And print getAbbreviationNamesResponseCount
    And match getAbbreviationNamesResponseCount == getAbbreviationNamesResponse.totalRecordCount
    #GetAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationName'
    And set getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationName-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | getAbbreviationNameResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | getAbbreviationNameResponse.header.id            |
      | correlationId   | getAbbreviationNameResponse.header.correlationId |
      | commandUserId   | getAbbreviationNameResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getAbbreviationNameCommandBody
      | path |                                   0 |
      | id   | addNameAbbreviationResponse.body.id |
    And set getAbbreviationNamePayload
      | path         | [0]                                 |
      | header       | getAbbreviationNameCommandHeader[0] |
      | body.request | getAbbreviationNameCommandBody[0]   |
    And print getAbbreviationNamePayload
    And request getAbbreviationNamePayload
    When method POST
    Then status 200
    And def getAbbreviationNameResponse = response
    And print getAbbreviationNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationNameCollectionNameRead+<tenantid>,addNameAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationNameResponse.id
    And match getAbbreviationNameResponse.abbreviationType == addNameAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationNameCreated"
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationName"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addNameAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateNameAbbreviationsWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a Name abbreviation with all the fields and Get the details
    #Create Name abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    And set updateAbbreviationCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationName-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | entityId        | addNameAbbreviationResponse.header.entityId      |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateAbbreviationName"                         |
      | entityName      | "AbbreviationName"                               |
      | ttl             |                                                0 |
    And set updateAbbreviationNameCommandBody
      | path             |                                           0 |
      | id               | addNameAbbreviationResponse.header.entityId |
      | abbreviationType | "Name"                                      |
      | translationType  | "Shortcuts"                                 |
      | enteredData      | faker.getRandomShortDescription()           |
      | fullTranslation  | faker.getCityCode()                         |
      | isActive         | faker.getRandomBoolean()                    |
    And set updateAbbreviationNamePayload
      | path   | [0]                                  |
      | header | updateAbbreviationCommandHeader[0]   |
      | body   | updateAbbreviationNameCommandBody[0] |
    And print updateAbbreviationNamePayload
    And request updateAbbreviationNamePayload
    When method POST
    Then status 201
    And def updateAbbreviationNameResponse = response
    And print updateAbbreviationNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationNameCollectionName+<tenantid>,addNameAbbreviationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAbbreviationNameResponse.body.id
    And match updateAbbreviationNameResponse.body.enteredData == updateAbbreviationNamePayload.body.enteredData
    And match updateAbbreviationNameResponse.body.fullTranslation == updateAbbreviationNamePayload.body.fullTranslation
    #getAllAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationNames'
    And set getAbbreviationNamesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationNames-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationNames"                           |
      | getType         | "Array"                                          |
    And set getAbbreviationNamesCommandBodyRequest
      | path        |                                               0 |
      | enteredData | updateAbbreviationNameResponse.body.enteredData |
    And set getAbbreviationNamesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "translationType" |
      | isAscending | false             |
    And set getAbbreviationNamesPayload
      | path                | [0]                                       |
      | header              | getAbbreviationNamesCommandHeader[0]      |
      | body.request        | getAbbreviationNamesCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationNamesCommandPagination[0]  |
    And print getAbbreviationNamesPayload
    And request getAbbreviationNamesPayload
    When method POST
    Then status 200
    And def getAbbreviationNamesResponse = response
    And print getAbbreviationNamesResponse
    And match   getAbbreviationNamesResponse.results[0].enteredData == updateAbbreviationNameResponse.body.enteredData
    And def getAbbreviationNamesResponseCount = karate.sizeOf(getAbbreviationNamesResponse.results)
    And print getAbbreviationNamesResponseCount
    And match getAbbreviationNamesResponseCount == getAbbreviationNamesResponse.totalRecordCount
    #GetAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationName'
    And set getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationName-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getAbbreviationNameCommandBody
      | path |                                   0 |
      | id   | addNameAbbreviationResponse.body.id |
    And set getAbbreviationNamePayload
      | path         | [0]                                 |
      | header       | getAbbreviationNameCommandHeader[0] |
      | body.request | getAbbreviationNameCommandBody[0]   |
    And print getAbbreviationNamePayload
    And request getAbbreviationNamePayload
    When method POST
    Then status 200
    And def getAbbreviationApiNameResponse = response
    And print getAbbreviationApiNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationNameCollectionNameRead+<tenantid>,addNameAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationApiNameResponse.id
    And match getAbbreviationApiNameResponse.enteredData == updateAbbreviationNameResponse.body.enteredData
    # History Validation
    And def eventName = "AbbreviationNameUpdated"
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationName"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addNameAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
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

  @updateNameAbbreviationsWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a Name abbreviation with Mandatory fields and Get the details
    #Create Name abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    And set updateAbbreviationCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationName-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | entityId        | addNameAbbreviationResponse.header.entityId      |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateAbbreviationName"                         |
      | entityName      | "AbbreviationName"                               |
      | ttl             |                                                0 |
    And set updateAbbreviationNameCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | abbreviationType | "Name"                            |
      | translationType  | "Shortcuts"                       |
      | enteredData      | faker.getRandomShortDescription() |
      | fullTranslation  | faker.getCityCode()               |
    And set updateAbbreviationPayload
      | path   | [0]                                  |
      | header | updateAbbreviationCommandHeader[0]   |
      | body   | updateAbbreviationNameCommandBody[0] |
    And print updateAbbreviationNamePayload
    And request updateAbbreviationNamePayload
    When method POST
    Then status 201
    And def updateAbbreviationNameResponse = response
    And print updateAbbreviationNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationNameCollectionName+<tenantid>,addNameAbbreviationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAbbreviationNameResponse.body.id
    And match updateAbbreviationNameResponse.body.enteredData == updateAbbreviationNamePayload.body.enteredData
    And match updateAbbreviationNameResponse.body.translationType == addNameAbbreviationResponse.body.translationType
    And sleep(10000)
    #getAllAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationNames'
    And set  getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationNames-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "Array"                                          |
    And set getAbbreviationNamesCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getAbbreviationNamesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationNamesPayload
      | path                | [0]                                       |
      | header              | getAbbreviationNamesCommandHeader[0]      |
      | body.request        | getAbbreviationNamesCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationNamesCommandPagination[0]  |
    And print getAbbreviationNamesPayload
    And request getAbbreviationNamesPayload
    When method POST
    Then status 200
    And def getAbbreviationNamesResponse = response
    And print getAbbreviationNamesResponse
    And match each getAbbreviationNamesResponse.results[*].active == true
    And def getAbbreviationNamesResponseCount = karate.sizeOf(getAbbreviationNamesResponse.results)
    And print getAbbreviationNamesResponseCount
    And match getAbbreviationNamesResponseCount == getAbbreviationNamesResponse.totalRecordCount
    #GetAbbreviationName
    Given url readBaseUrl
    And path '/api/GetAbbreviationName'
    And set getAbbreviationNameCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetAbbreviationName-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | getAbbreviationNameResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | getAbbreviationNameResponse.header.id            |
      | correlationId   | getAbbreviationNameResponse.header.correlationId |
      | commandUserId   | getAbbreviationNameResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetAbbreviationName"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getAbbreviationNameCommandBody
      | path |                                   0 |
      | id   | getAbbreviationNameResponse.body.id |
    And set getAbbreviationNamePayload
      | path         | [0]                                 |
      | header       | getAbbreviationNameCommandHeader[0] |
      | body.request | getAbbreviationNameCommandBody[0]   |
    And print getAbbreviationNamePayload
    And request getAbbreviationNamePayload
    When method POST
    Then status 200
    And def getAbbreviationNameResponse = response
    And print getAbbreviationNameResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationNameCollectionNameRead+<tenantid>,addNameAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationNameResponse.id
    And match getAbbreviationNameResponse.enteredData == addNameAbbreviationResponse.body.enteredData
    # History Validation
    And def eventName = "AbbreviationNameUpdated"
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationName"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addNameAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationName"
    And def entityIdData = addNameAbbreviationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAbbreviationNameWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Abbreviation with Invalid Data to mandatory fields and Validate
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
      | path             |                                 0 |
      | id               | entityIdData                      |
      | abbreviationType | "Name"                            |
      # parsing short instead of shortcuts
      | translationType  | "Short"                           |
      | enteredData      | faker.getRandomShortDescription() |
      | fullTranslation  | faker.getCityCode()               |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAbbdreviationNameWithMissingMandatoryField
  Scenario Outline: Create a Abbreviation Name with missing mandatory fields and Validate
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
      | path             |                   0 |
      | id               | entityIdData        |
      | abbreviationType | "Name"              |
      | translationType  | "Shortcuts"         |
      | fullTranslation  | faker.getCityCode() |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAbbreviationNameWithDuplicateID
  Scenario Outline: Create a Abbreviation Name with duplicate Abbreviation Name ID and Validate
    #Create Name abbreviation and Update
    Given url commandBaseUrl
    When path '/api/CreateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
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
      | path             |                                            0 |
      | id               | entityIdData                                 |
      | abbreviationType | "Name"                                       |
      | translationType  | "Shortcuts"                                  |
      | enteredData      | addNameAbbreviationResponse.body.enteredData |
      | fullTranslation  | faker.getCityCode()                          |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:AbbreviationName cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAbbreviationNameeWithDuplicateData
  Scenario Outline: Update a Abbdreviation Name with  duplicate data and Validate
    #Create Name abbreviation and Update
    Given url readBaseUrl
    When path '/api/UpdateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse1
    And set updateAbbreviationCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationName-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | entityId        | addNameAbbreviationResponse.header.entityId      |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateAbbreviationName"                         |
      | entityName      | "AbbreviationName"                               |
      | ttl             |                                                0 |
    And set updateAbbreviationNameCommandBody
      | path             |                                             0 |
      | id               | entityIdData                                  |
      | abbreviationType | "Name"                                        |
      | translationType  | "shortcut"                                    |
      | enteredData      | addNameAbbreviationResponse1.body.enteredData |
      | fullTranslation  | faker.getCityCode()                           |
      | isActive         | faker.getRandomBoolean()                      |
    And set updateAbbreviationPayload
      | path   | [0]                                  |
      | header | updateAbbreviationCommandHeader[0]   |
      | body   | updateAbbreviationNameCommandBody[0] |
    And print updateAbbreviationNamePayload
    And request updateAbbreviationNamePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAbbreviationNameeWithInvaliDataToMandatoryFields
  Scenario Outline: Update a Abbdreviation Name with invalid data to mandatory fields
    #Create Name abbreviation and Update
    Given url readBaseUrl
    When path '/api/UpdateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    And set updateAbbreviationCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationName-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | entityId        | addNameAbbreviationResponse.header.entityId      |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateAbbreviationName"                         |
      | entityName      | "AbbreviationName"                               |
      | ttl             |                                                0 |
    And set updateAbbreviationNameCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | abbreviationType | "Name"                            |
      | translationType  | "shortcut"                        |
      | enteredData      | faker.getRandomShortDescription() |
      | fullTranslation  | faker.getCityCode()               |
      | isActive         | faker.getRandomBoolean()          |
    And set updateAbbreviationPayload
      | path   | [0]                                  |
      | header | updateAbbreviationCommandHeader[0]   |
      | body   | updateAbbreviationNameCommandBody[0] |
    And print updateAbbreviationNamePayload
    And request updateAbbreviationNamePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateNameAbbreviationsWithoutMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a Name abbreviation without Mandatory fields
    #Create Name abbreviation and Update
    Given url readBaseUrl
    When path '/api/UpdateAbbreviationName'
    And def result = call read('CreateAbbreviationName.feature@CreateNameAbbreviation')
    And def addNameAbbreviationResponse = result.response
    And print addNameAbbreviationResponse
    And set updateAbbreviationCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationName-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addNameAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addNameAbbreviationResponse.header.id            |
      | correlationId   | addNameAbbreviationResponse.header.correlationId |
      | entityId        | addNameAbbreviationResponse.header.entityId      |
      | commandUserId   | addNameAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateAbbreviationName"                         |
      | entityName      | "AbbreviationName"                               |
      | ttl             |                                                0 |
    And set updateAbbreviationNameCommandBody
      | path             |                   0 |
      | id               | entityIdData        |
      | abbreviationType | "Name"              |
      | translationType  | "Shortcuts"         |
      | fullTranslation  | faker.getCityCode() |
    And set updateAbbreviationPayload
      | path   | [0]                                  |
      | header | updateAbbreviationCommandHeader[0]   |
      | body   | updateAbbreviationNameCommandBody[0] |
    And print updateAbbreviationNamePayload
    And request updateAbbreviationNamePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

