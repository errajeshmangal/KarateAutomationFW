@CreatePaymentTypesE2E
Feature: PaymentTypes, Create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def PaymentTypesCollectionName = 'CreatePaymentType_'
    And def PaymentTypesCollectionNameRead = 'PaymentTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def usage = ['Primary','Secondary']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreatePrimaryPaymentAndGet
  Scenario Outline: Create a primary payment Type with all fields and Get the Details
    #Create a Payment Type
    And def result = call read('CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    # Get the Payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypesCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | commandUserId                              |
      | tags            | []                                         |
      | commandType     | "GetPaymentType"                           |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getPaymentTypesCommandBody
      | path |                                     0 |
      | id   | createPaymentResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                             |
      | header       | getPaymentTypesCommandHeader[0] |
      | body.request | getPaymentTypesCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.glAccount.name == createPaymentResponse.body.glAccount.name
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | createPaymentResponse.header.commandUserId |
      | tags            | []                                         |
      | commandType     | "GetPaymentTypes"                          |
      | getType         | "Array"                                    |
      | ttl             |                                          0 |
    And set getPaymentTypesCommandBodyRequest
      | path        |      0 |
      | description | "Test" |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains getPaymentTypeAPIResponse.id
    And match each getPaymentTypesResponse.results[*].description contains "Test"
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeCreated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPaymentResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @CreatePrimaryPaymentWithMandatoryDetailsAndGet
  Scenario Outline: Create a primary payment Type with mandatory fields and Get the Details
    #Create a Payment Type
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    # Get the Payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | commandUserId                              |
      | tags            | []                                         |
      | commandType     | "GetPaymentType"                           |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getPaymentTypeCommandBody
      | path |                                     0 |
      | id   | createPaymentResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.glAccount.name == createPaymentResponse.body.glAccount.name
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | createPaymentResponse.header.commandUserId |
      | tags            | []                                         |
      | commandType     | "GetPaymentTypes"                          |
      | getType         | "Array"                                    |
      | ttl             |                                          0 |
    And set getPaymentTypesCommandBodyRequest
      | path  |        0 |
      | usage | usage[0] |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains createPaymentResponse.body.id
    And match each getPaymentTypesResponse.results[*].usage == 0
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeCreated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPaymentResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @CreateSecondaryPaymentAndGet
  Scenario Outline: Create a Secondary payment Type with all fields and Get the Details
    #Create a Payment Type
    And def result = call read('CreatePayment.feature@CreateSecondaryPayment')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    # Get the Payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | commandUserId                              |
      | tags            | []                                         |
      | commandType     | "GetPaymentType"                           |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getPaymentTypeCommandBody
      | path |                                     0 |
      | id   | createPaymentResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.usage == createPaymentResponse.body.usage
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | createPaymentResponse.header.commandUserId |
      | tags            | []                                         |
      | commandType     | "GetPaymentTypes"                          |
      | getType         | "Array"                                    |
      | ttl             |                                          0 |
    And set getPaymentTypesCommandBodyRequest
      | path     |                                   0 |
      | isActive | createPaymentResponse.body.isActive |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains createPaymentResponse.body.id
    And match each getPaymentTypesResponse.results[*].isActive == createPaymentResponse.body.isActive
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeCreated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPaymentResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @CreateSecondaryPaymentWithMandatoryFieldsAndGet
  Scenario Outline: Create a secondary payment Type with mandatory fields and Get the Details
    #Create a Payment Type
    And def result = call read('CreatePayment.feature@CreateSecondaryPaymentWithMandatoryFields')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    # Get the Payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | commandUserId                              |
      | tags            | []                                         |
      | commandType     | "GetPaymentType"                           |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getPaymentTypeCommandBody
      | path |                                     0 |
      | id   | createPaymentResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.paymentType == createPaymentResponse.body.paymentType
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | createPaymentResponse.header.commandUserId |
      | tags            | []                                         |
      | commandType     | "GetPaymentTypes"                          |
      | getType         | "Array"                                    |
      | ttl             |                                          0 |
    And set getPaymentTypesCommandBodyRequest
      | path  |        0 |
      | usage | usage[1] |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains createPaymentResponse.body.id
    And match each getPaymentTypesResponse.results[*].usage == 1
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeCreated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPaymentResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @updatePrimaryPaymentTypeWithAllFields
  Scenario Outline: Update a primary payment type with all the details
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Updating display sequence
    And def displaySeq = createPaymentTypeResponse.body.displaySequence+1
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path                       |                                         0 |
      | id                         | createPaymentTypeResponse.header.entityId |
      | paymentType                | faker.getUserId()                         |
      | description                | faker.getRandomShortDescription()         |
      | usage                      | usage[0]                                  |
      | displaySequence            | displaySeq                                |
      | referencesNumberRequired   | faker.getRandomBoolean()                  |
      | reverseSign                | faker.getRandomBoolean()                  |
      | includeInCashGroup         | faker.getRandomBoolean()                  |
      | includeInDepositTotals     | faker.getRandomBoolean()                  |
      | impactsAR                  | faker.getRandomBoolean()                  |
      | autoOpenCashDrawer         | faker.getRandomBoolean()                  |
      | nameOnCheckRequired        | faker.getRandomBoolean()                  |
      | financialExportDepositType | faker.getFinanicialExportDepsoit()        |
      | allowDuplicateEntry        | faker.getRandomBoolean()                  |
      | isActive                   | faker.getRandomBoolean()                  |
      | showCreditCardType         | faker.getRandomBoolean()                  |
    And set updatePaymentCommandAllowedUi
      | path       |                                                     0 |
      | cashiering | createPaymentTypeResponse.body.allowedInUi.cashiering |
      | ar         | faker.getRandomBoolean()                              |
      | adjustment | faker.getRandomBoolean()                              |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path             | [0]                              |
      | header           | updatePaymentCommandHeader[0]    |
      | body             | updatePaymentCommandBody[0]      |
      | body.allowedInUi | updatePaymentCommandAllowedUi[0] |
      | body.glAccount   | updatePaymentCommandGlCode[0]    |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 201
    And def updatePaymentTypeResponse = response
    And print updatePaymentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,PaymentTypesCollectionName+<tenantid>,updatePaymentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePaymentTypeResponse.body.id
    And match updatePaymentTypeResponse.body.allowedInUi.cashiering == createPaymentTypeResponse.body.allowedInUi.cashiering
    And match updatePaymentTypeResponse.body.paymentType == updatePaymentTypePayload.body.paymentType
    #Get the payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetPaymentType"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getPaymentTypeCommandBody
      | path |                                         0 |
      | id   | updatePaymentTypeResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.description == updatePaymentTypeResponse.body.description
    And match getPaymentTypeAPIResponse.financialExportDepositType == updatePaymentTypeResponse.body.financialExportDepositType
    And match  getPaymentTypeAPIResponse.displaySequence == updatePaymentTypeResponse.body.displaySequence
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | updatePaymentTypeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetPaymentTypes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getPaymentTypesCommandBodyRequest
      | path     |                                       0 |
      | isActive | updatePaymentTypeResponse.body.isActive |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains updatePaymentTypeResponse.body.id
    And match each getPaymentTypesResponse.results[*].isActive == updatePaymentTypeResponse.body.isActive
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeUpdated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePaymentTypeResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @updateSecondaryPaymentTypeWithAllFields
  Scenario Outline: Update a Secondary Payment Type with all the details
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreateSecondaryPayment')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path                       |                                         0 |
      | id                         | createPaymentTypeResponse.header.entityId |
      | paymentType                | faker.getUserId()                         |
      | description                | faker.getRandomShortDescription()         |
      | usage                      | usage[1]                                  |
      | reverseSign                | faker.getRandomBoolean()                  |
      | includeInCashGroup         | faker.getRandomBoolean()                  |
      | includeInDepositTotals     | faker.getRandomBoolean()                  |
      | impactsAR                  | faker.getRandomBoolean()                  |
      | autoOpenCashDrawer         | faker.getRandomBoolean()                  |
      | nameOnCheckRequired        | faker.getRandomBoolean()                  |
      | financialExportDepositType | faker.getFinanicialExportDepsoit()        |
      | allowDuplicateEntry        | faker.getRandomBoolean()                  |
      | isActive                   | faker.getRandomBoolean()                  |
      | showCreditCardType         | faker.getRandomBoolean()                  |
    And set updatePaymentCommandAllowedUi
      | path       |                                                     0 |
      | cashiering | createPaymentTypeResponse.body.allowedInUi.cashiering |
      | ar         | faker.getRandomBoolean()                              |
      | adjustment | faker.getRandomBoolean()                              |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path             | [0]                              |
      | header           | updatePaymentCommandHeader[0]    |
      | body             | updatePaymentCommandBody[0]      |
      | body.allowedInUi | updatePaymentCommandAllowedUi[0] |
      | body.glAccount   | updatePaymentCommandGlCode[0]    |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 201
    And def updatePaymentTypeResponse = response
    And print updatePaymentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,PaymentTypesCollectionName+<tenantid>,updatePaymentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePaymentTypeResponse.body.id
    And match updatePaymentTypeResponse.body.allowedInUi.cashiering == createPaymentTypeResponse.body.allowedInUi.cashiering
    And match updatePaymentTypeResponse.body.paymentType == updatePaymentTypePayload.body.paymentType
    #Get the payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetPaymentType"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getPaymentTypeCommandBody
      | path |                                         0 |
      | id   | updatePaymentTypeResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.description == updatePaymentTypeResponse.body.description
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | updatePaymentTypeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetPaymentTypes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getPaymentTypesCommandBodyRequest
      | path        |      0 |
      | paymentType | "Test" |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains updatePaymentTypeResponse.body.id
    And match each getPaymentTypesResponse.results[*].paymentType contains "Test"
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getPaymentTypeAPIResponse.id
    And def parentEntityId = getPaymentTypeAPIResponse.id
    And def eventName = "PaymentTypeCreated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePaymentTypeResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @updateSecondaryPaymentTypeWithMandatoryFields
  Scenario Outline: Update a Secondary Payment with Mandatory details
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreateSecondaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #Update Secondary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path        |                                         0 |
      | id          | createPaymentTypeResponse.header.entityId |
      | paymentType | faker.getUserId()                         |
      | usage       | usage[1]                                  |
      | isActive    | faker.getRandomBoolean()                  |
    And set updatePaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 201
    And def updatePaymentTypeResponse = response
    And print updatePaymentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,PaymentTypesCollectionName+<tenantid>,updatePaymentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePaymentTypeResponse.body.id
    And match updatePaymentTypeResponse.body.paymentType == updatePaymentTypePayload.body.paymentType
    And match updatePaymentTypeResponse.body.glAccount.code == updatePaymentTypePayload.body.glAccount.code
    #Get the payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetPaymentType"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getPaymentTypeCommandBody
      | path |                                         0 |
      | id   | updatePaymentTypeResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.glAccount.code == updatePaymentTypeResponse.body.glAccount.code
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | updatePaymentTypeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetPaymentTypes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getPaymentTypesCommandBodyRequest
      | path        |      0 |
      | paymentType | "Test" |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains updatePaymentTypeResponse.body.id
    And match each getPaymentTypesResponse.results[*].paymentType contains "Test"
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updatePaymentTypeResponse.body.id
    And def parentEntityId = updatePaymentTypeResponse.body.id
    And def eventName = "PaymentTypeUpdated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePaymentTypeResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @updatePrimaryPaymentTypeWithMandatoryFields
  Scenario Outline: Update a primary payment Type with Mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path            |                                              0 |
      | id              | createPaymentTypeResponse.header.entityId      |
      | paymentType     | faker.getUserId()                              |
      | usage           | usage[1]                                       |
      | displaySequence | createPaymentTypeResponse.body.displaySequence |
      | isActive        | faker.getRandomBoolean()                       |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 201
    And def updatePaymentTypeResponse = response
    And print updatePaymentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,PaymentTypesCollectionName+<tenantid>,updatePaymentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePaymentTypeResponse.body.id
    And match updatePaymentTypeResponse.body.paymentType == updatePaymentTypePayload.body.paymentType
    #Get the payment Type
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetPaymentType"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getPaymentTypeCommandBody
      | path |                                         0 |
      | id   | updatePaymentTypeResponse.header.entityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    And match getPaymentTypeAPIResponse.usage == 1
    #Get All Payment Types
    Given url readBaseUrl
    And path '/api/GetPaymentTypes'
    And set getPaymentTypesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetPaymentTypes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updatePaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updatePaymentTypeResponse.header.id            |
      | correlationId   | updatePaymentTypeResponse.header.correlationId |
      | commandUserId   | updatePaymentTypeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetPaymentTypes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getPaymentTypesCommandBodyRequest
      | path     |                                       0 |
      | isActive | updatePaymentTypeResponse.body.isActive |
    And set getPaymentTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPaymentTypesPayload
      | path                | [0]                                  |
      | header              | getPaymentTypesCommandHeader[0]      |
      | body.request        | getPaymentTypesCommandBodyRequest[0] |
      | body.paginationSort | getPaymentTypesCommandPagination[0]  |
    And print getPaymentTypesPayload
    And request getPaymentTypesPayload
    When method POST
    Then status 200
    And def getPaymentTypesResponse = response
    And print getPaymentTypesResponse
    And match getPaymentTypesResponse.results[*].id contains updatePaymentTypeResponse.body.id
    And match each getPaymentTypesResponse.results[*].isActive == updatePaymentTypeResponse.body.isActive
    And def getPaymentTypesResponseCount = karate.sizeOf(getPaymentTypesResponse.results)
    And print getPaymentTypesResponseCount
    And match getPaymentTypesResponseCount == getPaymentTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updatePaymentTypeResponse.body.id
    And def parentEntityId = updatePaymentTypeResponse.body.id
    And def eventName = "PaymentTypeUpdated"
    And def evnentType = "PaymentType"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = "PaymentType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePaymentTypeResponse.body.id
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
    And def evnentType = "PaymentType"
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

  @CreatePrimaryPaymentWithMissingMandatoryFields
  Scenario Outline: Create a payment Type with Missing Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path     |                        0 |
      | id       | entityIdData             |
      | usage    | usage[0]                 |
      | isActive | faker.getRandomBoolean() |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePrimaryPaymentWithInvalidDataMandatoryFields
  Scenario Outline: Create a payment Type with Invalid data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path            |                                 0 |
      | id              | entityIdData                      |
      | paymentType     | faker.getUserId()                 |
      | usage           | usage[0]                          |
      | displaySequence | faker.getRandomShortDescription() |
      | isActive        | faker.getRandomBoolean()          |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updatePrimaryPaymentTypeWithMissingMandatoryFields
  Scenario Outline: Update a payment type with all missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path        |                                         0 |
      | id          | createPaymentTypeResponse.header.entityId |
      | paymentType | faker.getUserId()                         |
      | isActive    | faker.getRandomBoolean()                  |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updatePrimaryPaymentTypeWithInvalidDataToMandatoryFields
  Scenario Outline: Update a payment type with all missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path            |                                 0 |
      | id              | faker.getRandomShortDescription() |
      | paymentType     | faker.getUserId()                 |
      | usage           | usage[0]                          |
      | displaySequence |                                 1 |
      | isActive        | faker.getRandomBoolean()          |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updatePrimaryPaymentTypeWithDuplicatePaymentType
  Scenario Outline: Update a primary payment type with duplicate payment type
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Create a secondary payment
    And def result1 = call read('CreatePayment.feature@CreateSecondaryPaymentWithMandatoryFields')
    And def createSeondaryPaymentTypeResponse = result1.response
    And print createSeondaryPaymentTypeResponse
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path            |                                                  0 |
      | id              | createPaymentTypeResponse.header.entityId          |
      | paymentType     | createSeondaryPaymentTypeResponse.body.paymentType |
      | usage           | usage[0]                                           |
      | displaySequence | createPaymentTypeResponse.body.displaySequence     |
      | isActive        | faker.getRandomBoolean()                           |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePrimaryPaymentWithDuplicatePaymentType
  Scenario Outline: Create a primary Payment Type with duplicate payment type
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #Create a Payment Type
    And def result = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    And def paymentEntityId = createPaymentResponse.body.id
    #GetPaymentType
    And def result1 = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@GetPaymentWithDetails'){'paymentEntityId': '#(paymentEntityId)'}
    And def getPaymentResponse = result1.response
    And print getPaymentResponse
    And def displaySeq = getPaymentResponse.displaySequence
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path            |                                      0 |
      | id              | entityIdData                           |
      | paymentType     | createPaymentResponse.body.paymentType |
      | usage           | usage[0]                               |
      | displaySequence | displaySeq+1                           |
      | isActive        | faker.getRandomBoolean()               |
    And set createPaymentCommandGlCode
      | path |                                         0 |
      | id   | createPaymentResponse.body.glAccount.id   |
      | name | createPaymentResponse.body.glAccount.name |
      | code | createPaymentResponse.body.glAccount.code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 400
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePrimaryPaymentWithDuplicateSequenceNumber
  Scenario Outline: Create a Primay Payment Type with duplicae sequence Number
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #Create a Payment Type
    And def result = call read('CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = result.response
    And print createPaymentResponse
    And def paymentEntityId = createPaymentResponse.body.id
    #GetPaymentType
    And def result1 = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@GetPaymentWithDetails'){'paymentEntityId': '#(paymentEntityId)'}
    And def getPaymentResponse = result1.response
    And print getPaymentResponse
    And def displaySeq = getPaymentResponse.displaySequence
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path            |                                          0 |
      | id              | entityIdData                               |
      | paymentType     | faker.getFirstName()                       |
      | usage           | usage[0]                                   |
      | displaySequence | displaySeq |
      | isActive        | faker.getRandomBoolean()                   |
    And set createPaymentCommandGlCode
      | path |                                         0 |
      | id   | createPaymentResponse.body.glAccount.id   |
      | name | createPaymentResponse.body.glAccount.name |
      | code | createPaymentResponse.body.glAccount.code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 400
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updatePrimaryPaymentTypeWithDuplicateSequenceNumber
  Scenario Outline: Update a primary payment type with duplicate payment type
    Given url commandBaseUrl
    And path '/api/UpdatePaymentType'
    #Create a primary payment
    And def result = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse = result.response
    And print createPaymentTypeResponse
    #Create another primary payment
    And def result1 = call read('CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentTypeResponse1 = result1.response
    And print createPaymentTypeResponse1
    #Update Primary Payment Type
    And set updatePaymentCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdatePaymentType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createPaymentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createPaymentTypeResponse.header.id            |
      | correlationId   | createPaymentTypeResponse.header.correlationId |
      | entityId        | createPaymentTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "UpdatePaymentType"                            |
      | entityName      | "PaymentType"                                  |
      | ttl             |                                              0 |
    And set updatePaymentCommandBody
      | path            |                                               0 |
      | id              | createPaymentTypeResponse.header.entityId       |
      | paymentType     | createPaymentTypeResponse.body.paymentType      |
      | usage           | usage[0]                                        |
      | displaySequence | createPaymentTypeResponse1.body.displaySequence |
      | isActive        | faker.getRandomBoolean()                        |
    And set updatePaymentCommandGlCode
      | path |                                             0 |
      | id   | createPaymentTypeResponse.body.glAccount.id   |
      | name | createPaymentTypeResponse.body.glAccount.code |
      | code | createPaymentTypeResponse.body.glAccount.name |
    And set updatePaymentTypePayload
      | path           | [0]                           |
      | header         | updatePaymentCommandHeader[0] |
      | body           | updatePaymentCommandBody[0]   |
      | body.glAccount | updatePaymentCommandGlCode[0] |
    And print updatePaymentTypePayload
    And request updatePaymentTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
