@AbbreviationAddressE2E
Feature: Abbreviation Address - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def abbreviationCollectionAddress = 'CreateAbbreviationAddress_'
    And def abbreviationCollectionAddressRead = 'AbbreviationAddressDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @createAbbreviationNameWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a Address Abbreviation with all the fields and Get the details
    #CreateAddress Abbreviation and Get the details
    Given url readBaseUrl
    When path '/api/GetAbbreviationName'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    #getAllAbbreviationAddressAll
    And set  getAbbreviationAddressAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "Array"                                             |
    And set getAbbreviationAddressAllCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getAbbreviationAddressAllCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationAddressAllPayload
      | path                | [0]                                            |
      | header              | getAbbreviationAddressAllCommandHeader[0]      |
      | body.request        | getAbbreviationAddressAllCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationAddressAllCommandPagination[0]  |
    And print getAbbreviationAddressAllPayload
    And request getAbbreviationAddressAllPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressAllResponse = response
    And print getAbbreviationAddressAllResponse
    And match each getAbbreviationAddressAllResponse.results[*].Active == true
    And def getAbbreviationAddressAllResponseCount = karate.sizeOf(getAbbreviationAddressAllResponse.results)
    And print getAbbreviationAddressAllResponseCount
    And match getAbbreviationAddressAllResponseCount == getAbbreviationAddressAllResponse.totalRecordCount
    #GetAbbreviationAddress
    Given url readBaseUrl
    And path '/api/GetAbbreviationAddress'
    And set getAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getAbbreviationAddressCommandBody
      | path |                                      0 |
      | id   | addAddressAbbreviationResponse.body.id |
    And set getAbbreviationAddressPayload
      | path         | [0]                                    |
      | header       | getAbbreviationAddressCommandHeader[0] |
      | body.request | getAbbreviationAddressCommandBody[0]   |
    And print getAbbreviationAddressPayload
    And request getAbbreviationAddressPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressResponse = response
    And print getAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationCollectionAddressRead+<tenantid>,addAddressAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationAddressResponse.id
    And match getAbbreviationAddressResponse.abbreviationType == addAddressAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationAddressCreated"
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationAddress"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAddressAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
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

  @createAbbreviationNameWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a Address Abbreviation with mandatory fields and Get the details
    #CreateAddress Abbreviation and Get the details
    Given url commandBaseUrl
    And path '/api/CreateAbbreviationAddress'
    And def entityIdData = dataGenerator.entityID()
    And set createAbbreviationCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/CreateAbbreviationAddress-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | tenantId        | <tenantid>                                         |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | entityId        | entityIdData                                       |
      | commandUserId   | commandUserId                                      |
      | entityVersion   |                                                  1 |
      | tags            | []                                                 |
      | commandType     | "CreateAbbreviationAddress"                        |
      | entityName      | "AbbreviationAddress"                              |
      | ttl             |                                                  0 |
    And set createAbbreviationCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | abbreviationType | "Address"                         |
      | translationType  | "Shortcuts"                       |
      | enteredData      | faker.getRandomShortDescription() |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 201
    And def addAddressAbbreviationResponse = response
    And print addAddressAbbreviationResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationCollectionAddress+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addAddressAbbreviationResponse.body.id
    And match addAddressAbbreviationResponse.body.enteredData == createAbbreviationPayload.body.
    And match addAddressAbbreviationResponse.body.fullTranslation == createAbbreviationPayload.body.fullTranslation
    #getAllAbbreviationAddressAll
    And set  getAbbreviationAddressAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "Array"                                             |
    And set getAbbreviationAddressAllCommandBodyRequest
      | path        |                                               0 |
      | enteredData | addAddressAbbreviationResponse.body.enteredData |
    And set getAbbreviationAddressAllCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationAddressAllPayload
      | path                | [0]                                            |
      | header              | getAbbreviationAddressAllCommandHeader[0]      |
      | body.request        | getAbbreviationAddressAllCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationAddressAllCommandPagination[0]  |
    And print getAbbreviationAddressAllPayload
    And request getAbbreviationAddressAllPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressAllResponse = response
    And print getAbbreviationAddressAllResponse
    And match  getAbbreviationAddressAllResponse.results[0].enteredData ==   addAddressAbbreviationResponse.body.enteredData
    And def getAbbreviationAddressAllResponseCount = karate.sizeOf(getAbbreviationAddressAllResponse.results)
    And print getAbbreviationAddressAllResponseCount
    And match getAbbreviationAddressAllResponseCount == getAbbreviationAddressAllResponse.totalRecordCount
    #GetAbbreviationAddress
    Given url readBaseUrl
    And path '/api/GetAbbreviationAddress'
    And set getAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getAbbreviationAddressCommandBody
      | path |                                      0 |
      | id   | addAddressAbbreviationResponse.body.id |
    And set getAbbreviationAddressPayload
      | path         | [0]                                    |
      | header       | getAbbreviationAddressCommandHeader[0] |
      | body.request | getAbbreviationAddressCommandBody[0]   |
    And print getAbbreviationAddressPayload
    And request getAbbreviationAddressPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressResponse = response
    And print getAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationCollectionAddressRead+<tenantid>,addAddressAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationAddressResponse.id
    And match getAbbreviationAddressResponse.abbreviationType == addAddressAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationAddressCreated"
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationAddress"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAddressAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
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

  @UpdateAddressAbbreviationsWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a Address abbreviation with all the fields and Get the details
    #Create Address abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationAddress'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And set updateAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | addAddressAbbreviationResponse.header.entityId      |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   2 |
      | tags            | []                                                  |
      | commandType     | "UpdateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set updateAbbreviationAddressCommandBody
      | path                 |                                              0 |
      | id                   | addAddressAbbreviationResponse.header.entityId |
      | abbreviationType     | "Address"                                      |
      | translationType      | "Shortcuts"                                    |
      | enteredData          | faker.getRandomNumber()                        |
      | name                 | faker.getRandomShortDescription()              |
      | address.addressLine1 | faker.getAddressLine()                         |
      | address.addressLine2 | faker.getAddressLine2()                        |
      | address.city         | faker.getCity()                                |
      | address.state        | faker.getState()                               |
      | address.zipCode      | faker.getZip()                                 |
      | isActive             | faker.getRandomBoolean()                       |
    And set updateAbbreviationAddressPayload
      | path   | [0]                                       |
      | header | updateAbbreviationAddressCommandHeader[0] |
      | body   | updateAbbreviationAddressCommandBody[0]   |
    And print updateAbbreviationAddressPayload
    And request updateAbbreviationAddressPayload
    When method POST
    Then status 201
    And def updateAbbreviationAddressResponse = response
    And print updateAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,abbreviationCollectionAddress+<tenantid>,addAddressAbbreviationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAbbreviationAddressResponse.body.id
    And match updateAbbreviationAddressResponse.body.enteredData == updateAbbreviationAddressPayload.body.enteredData
    And match updateAbbreviationAddressResponse.body.address.addressLine1 == updateAbbreviationAddressPayload.body.address.addressLine1
    And sleep(10000)
    #getAllAbbreviationAddress
    And set  getAbbreviationAddressAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationName"                               |
      | getType         | "Array"                                             |
    And set getAbbreviationAddressAllCommandBodyRequest
      | path |                                               0 |
      | code | addAddressAbbreviationResponse.body.enteredData |
    And set getAbbreviationAddressAllCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationAddressAllPayload
      | path                | [0]                                            |
      | header              | getAbbreviationAddressAllCommandHeader[0]      |
      | body.request        | getAbbreviationAddressAllCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationAddressAllCommandPagination[0]  |
    And print getAbbreviationAddressAllPayload
    And request getAbbreviationAddressAllPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressAllResponse = response
    And print getAbbreviationAddressAllResponse
    And match getAbbreviationAddressAllResponse.results[0].enteredData == addAddressAbbreviationResponse.body.enteredData
    And def getAbbreviationAddressAllResponseCount = karate.sizeOf(getAbbreviationAddressAllResponse.results)
    And print getAbbreviationAddressAllResponseCount
    And match getAbbreviationAddressAllResponseCount == getAbbreviationAddressAllResponse.totalRecordCount
    #GetAbbreviationAddress
    Given url readBaseUrl
    And path '/api/GetAbbreviationAddress'
    And set getAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getAbbreviationAddressCommandBody
      | path |                                      0 |
      | id   | addAddressAbbreviationResponse.body.id |
    And set getAbbreviationAddressPayload
      | path         | [0]                                    |
      | header       | getAbbreviationAddressCommandHeader[0] |
      | body.request | getAbbreviationAddressCommandBody[0]   |
    And print getAbbreviationAddressPayload
    And request getAbbreviationAddressPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressResponse = response
    And print getAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationCollectionAddressRead+<tenantid>,addAddressAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationAddressResponse.id
    And match getAbbreviationAddressResponse.abbreviationType == addAddressAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationAddressUpdated"
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationAddress"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAddressAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
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

  @UpdateAddressAbbreviationsWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a Address abbreviation with Mandatory fields and Get the details
    #Create Address abbreviation and Update with mandatory Fields
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationAddress'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And set updateAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | addAddressAbbreviationResponse.header.entityId      |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   2 |
      | tags            | []                                                  |
      | commandType     | "UpdateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set updateAbbreviationAddressCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | abbreviationType | "Address"                         |
      | translationType  | "Shortcuts"                       |
      | enteredData      | faker.getRandomShortDescription() |
    And set updateAbbreviationAddressPayload
      | path   | [0]                                       |
      | header | updateAbbreviationAddressCommandHeader[0] |
      | body   | updateAbbreviationAddressCommandBody[0]   |
    And print updateAbbreviationAddressPayload
    And request updateAbbreviationAddressPayload
    When method POST
    Then status 201
    And def updateAbbreviationAddressResponse = response
    And print updateAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationCollectionAddressRead+<tenantid>,addAddressAbbreviationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAbbreviationAddressResponse.body.id
    And match updateAbbreviationAddressResponse.body.enteredData == updateAbbreviationAddressPayload.body.enteredData
    And match updateAbbreviationAddressResponse.body.address.addressLine1 == updateAbbreviationAddressPayload.body.address.addressLine1
    And match updateAbbreviationAddressResponse.body.address.addressLine1 == addAddressAbbreviationResponse.body.address.addressLine1
    And sleep(10000)
    #getAllAbbreviationAddress
    And set  getAbbreviationAddressAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationName"                               |
      | getType         | "Array"                                             |
    And set getAbbreviationAddressAllCommandBodyRequest
      | path            |                                                   0 |
      | translationType | addAddressAbbreviationResponse.body.translationType |
    And set getAbbreviationAddressAllCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAbbreviationAddressAllPayload
      | path                | [0]                                            |
      | header              | getAbbreviationAddressAllCommandHeader[0]      |
      | body.request        | getAbbreviationAddressAllCommandBodyRequest[0] |
      | body.paginationSort | getAbbreviationAddressAllCommandPagination[0]  |
    And print getAbbreviationAddressAllPayload
    And request getAbbreviationAddressAllPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressAllResponse = response
    And print getAbbreviationAddressAllResponse
    And match getAbbreviationAddressAllResponse.results[0].translationType == addAddressAbbreviationResponse.body.translationType
    And def getAbbreviationAddressAllResponseCount = karate.sizeOf(getAbbreviationAddressAllResponse.results)
    And print getAbbreviationAddressAllResponseCount
    And match getAbbreviationAddressAllResponseCount == getAbbreviationAddressAllResponse.totalRecordCount
    #GetAbbreviationAddress
    Given url readBaseUrl
    And path '/api/GetAbbreviationAddress'
    And set getAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetAbbreviationAddress-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | "GetAbbreviationAddress"                            |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getAbbreviationAddressCommandBody
      | path |                                      0 |
      | id   | addAddressAbbreviationResponse.body.id |
    And set getAbbreviationAddressPayload
      | path         | [0]                                    |
      | header       | getAbbreviationAddressCommandHeader[0] |
      | body.request | getAbbreviationAddressCommandBody[0]   |
    And print getAbbreviationAddressPayload
    And request getAbbreviationAddressPayload
    When method POST
    Then status 200
    And def getAbbreviationAddressResponse = response
    And print getAbbreviationAddressResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,abbreviationCollectionAddressRead+<tenantid>,addAddressAbbreviationResponse.body.id)
    And print mongoResult
    And match mongoResult == getAbbreviationAddressResponse.id
    And match getAbbreviationAddressResponse.abbreviationType == addAddressAbbreviationResponse.body.abbreviationType
    # History Validation
    And def eventName = "AbbreviationAddressUpdated"
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    #Adding the comment
    And def entityName = "AbbreviationAddress"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAddressAbbreviationResponse.body.id
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
    And def evnentType = "AbbreviationAddress"
    And def entityIdData = addAddressAbbreviationResponse.body.id
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
    And path '/api/CreateAbbreviationAddress'
    And def entityIdData = dataGenerator.entityID()
    And set createAbbreviationCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/CreateAbbreviationAddress-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | tenantId        | <tenantid>                                         |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | entityId        | entityIdData                                       |
      | commandUserId   | commandUserId                                      |
      | entityVersion   |                                                  1 |
      | tags            | []                                                 |
      | commandType     | "CreateAbbreviationAddress"                        |
      | entityName      | "AbbreviationAddress"                              |
      | ttl             |                                                  0 |
    And set createAbbreviationCommandBody
      | path                 |                                 0 |
      | id                   | entityIdData                      |
      | abbreviationType     | "Address"                         |
      | translationType      | "Sho"                             |
      | enteredData          | faker.getRandomShortDescription() |
      | name                 | faker.getRandomNumber()           |
      | address.addressLine1 | faker.getAddressLine()            |
      | address.addressLine2 | faker.getAddressLine2()           |
      | address.city         | faker.getCity()                   |
      | address.state        | faker.getState()                  |
      | address.zipCode      | faker.getZip()                    |
      | isActive             | faker.getRandomBoolean()          |
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
    And path '/api/CreateAbbreviationAddress'
    And def entityIdData = dataGenerator.entityID()
    And set createAbbreviationCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/CreateAbbreviationAddress-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | tenantId        | <tenantid>                                         |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | entityId        | entityIdData                                       |
      | commandUserId   | commandUserId                                      |
      | entityVersion   |                                                  1 |
      | tags            | []                                                 |
      | commandType     | "CreateAbbreviationAddress"                        |
      | entityName      | "AbbreviationAddress"                              |
      | ttl             |                                                  0 |
    And set createAbbreviationCommandBody
      | path                 |                        0 |
      | id                   | entityIdData             |
      | abbreviationType     | "Address"                |
      | translationType      | "Shortcuts"              |
      #| enteredData          | faker.getRandomShortDescription() |
      | name                 | faker.getRandomNumber()  |
      | address.addressLine1 | faker.getAddressLine()   |
      | address.addressLine2 | faker.getAddressLine2()  |
      | address.city         | faker.getCity()          |
      | address.state        | faker.getState()         |
      | address.zipCode      | faker.getZip()           |
      | isActive             | faker.getRandomBoolean() |
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

  @CreateAbbreiationWithDuplicateEnteredAddress
  Scenario Outline: Create a duplicate Abbreviation type  and Validate
    #Create Address abbreviation and Update
    Given url commandBaseUrl
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And def firstname = faker.getFirstName()
    And path '/api/CreateAbbreviationAddress'
    And def entityIdData = dataGenerator.entityID()
    And set createAbbreviationCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/CreateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | entityIdData                                        |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | "CreateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set createAbbreviationCommandBody
      | path                 |                                 0 |
      | id                   | entityIdData                      |
      | abbreviationType     | "Address"                         |
      | translationType      | faker.getAddressLine()            |
      | enteredData          | addAddressAbbreviationResponse.body.enteredData |
      | name                 | faker.getRandomNumber()           |
      | address.addressLine1 | faker.getAddressLine()            |
      | address.addressLine2 | faker.getAddressLine2()           |
      | address.city         | faker.getCity()                   |
      | address.state        | faker.getState()                  |
      | address.zipCode      | faker.getZip()                    |
      | isActive             | faker.getRandomBoolean()          |
    And set createAbbreviationPayload
      | path   | [0]                                |
      | header | createAbbreviationCommandHeader[0] |
      | body   | createAbbreviationCommandBody[0]   |
    And print createAbbreviationPayload
    And request createAbbreviationPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:AbbreviationAddress cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAbbreviationAddressWithDuplicateAddressType
  Scenario Outline: Update a Abbdreviation Address with Duplicate Description
    #Create Address abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationAddress'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse1 = result.response
    And print addAddressAbbreviationResponse1
    And set updateAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | addAddressAbbreviationResponse.header.entityId      |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   2 |
      | tags            | []                                                  |
      | commandType     | "UpdateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set updateAbbreviationAddressCommandBody
      | path                 |                                                0 |
      | path                 |                                                0 |
      | id                   | entityIdData                                     |
      | abbreviationType     | "Name"                                           |
      | translationType      | "Shortcuts"                                      |
      | enteredData          | addAddressAbbreviationResponse1.body.enteredData |
      | name                 | faker.getRandomNumber()                          |
      | address.addressLine1 | faker.getAddressLine()                           |
      | address.addressLine2 | faker.getAddressLine2()                          |
      | address.city         | faker.getCity()                                  |
      | address.state        | faker.getState()                                 |
      | address.zipCode      | faker.getZip()                                   |
      | isActive             | faker.getRandomBoolean()                         |
    And set updateAbbreviationAddressPayload
      | path   | [0]                                       |
      | header | updateAbbreviationAddressCommandHeader[0] |
      | body   | updateAbbreviationAddressCommandBody[0]   |
    And print updateAbbreviationAddressPayload
    And request updateAbbreviationAddressPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAbbreviationAddressWithInvaliDataToMandatoryFields
  Scenario Outline: Update a Abbdreviation Address with invalid data to mandatory fields
    #Create Address abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationAddress'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And set updateAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | addAddressAbbreviationResponse.header.entityId      |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   2 |
      | tags            | []                                                  |
      | commandType     | "UpdateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set updateAbbreviationAddressCommandBody
      | path                 |                                 0 |
      | path                 |                                 0 |
      | id                   | entityIdData                      |
      | abbreviationType     | "Name"                            |
      | translationType      | "Shortcuts"                       |
      | enteredData          | faker.getRandomShortDescription() |
      | name                 | faker.getRandomNumber()           |
      | address.addressLine1 | faker.getAddressLine()            |
      | address.addressLine2 | faker.getAddressLine2()           |
      | address.city         | faker.getCity()                   |
      | address.state        | faker.getState()                  |
      | address.zipCode      | faker.getZip()                    |
      | isActive             | faker.getRandomBoolean()          |
    And set updateAbbreviationAddressPayload
      | path   | [0]                                       |
      | header | updateAbbreviationAddressCommandHeader[0] |
      | body   | updateAbbreviationAddressCommandBody[0]   |
    And print updateAbbreviationAddressPayload
    And request updateAbbreviationAddressPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAbbreviationAddressWithMissingMandatoryFields
  Scenario Outline: Update an Address Abbreviation information with missing mandatory fields
    #Create Address abbreviation and Update
    Given url commandBaseUrl
    When path '/api/UpdateAbbreviationAddress'
    And def result = call read('CreateAbbreviationAddress.feature@CreateAddressAbbreviation')
    And def addAddressAbbreviationResponse = result.response
    And print addAddressAbbreviationResponse
    And set updateAbbreviationAddressCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/UpdateAbbreviationAddress-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addAddressAbbreviationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addAddressAbbreviationResponse.header.id            |
      | correlationId   | addAddressAbbreviationResponse.header.correlationId |
      | entityId        | addAddressAbbreviationResponse.header.entityId      |
      | commandUserId   | addAddressAbbreviationResponse.header.commandUserId |
      | entityVersion   |                                                   2 |
      | tags            | []                                                  |
      | commandType     | "UpdateAbbreviationAddress"                         |
      | entityName      | "AbbreviationAddress"                               |
      | ttl             |                                                   0 |
    And set updateAbbreviationAddressCommandBody
      | path                 |                        0 |
      | path                 |                        0 |
      | id                   | entityIdData             |
      | abbreviationType     | "Address"                |
      | translationType      | "Shortcuts"              |
      #| enteredData          | faker.getRandomShortDescription() |
      | name                 | faker.getRandomNumber()  |
      | address.addressLine1 | faker.getAddressLine()   |
      | address.addressLine2 | faker.getAddressLine2()  |
      | address.city         | faker.getCity()          |
      | address.state        | faker.getState()         |
      | address.zipCode      | faker.getZip()           |
      | isActive             | faker.getRandomBoolean() |
    And set updateAbbreviationAddressPayload
      | path   | [0]                                       |
      | header | updateAbbreviationAddressCommandHeader[0] |
      | body   | updateAbbreviationAddressCommandBody[0]   |
    And print updateAbbreviationAddressPayload
    And request updateAbbreviationAddressPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

