@CustomerTypeFeature
Feature: Customer Type - Add , Update

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def customerTypeCollectionname  = 'CreateCustomerType_'
    And def customerTypeCollectionNameRead = 'CustomerTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCustomerTypeWithAllDetails
  Scenario Outline: Create a customer type code with all the fields and Get the details
    Given url readBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print addCustomerTypeResponse
    #GetCustomerTypes
    And path '/api/GetCustomerTypes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetCustomerTypes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | getType         | "Array"                                   |
      | commandUserId   | dataGenerator.commandUserId()             |
      | tags            | []                                        |
      | commandType     | "GetCustomerTypes"                        |
      | ttl             |                                         0 |
    And set getCommandBody
      | path                        |              0 |
      | request.isActive            | true           |
      | request.lastUpdatedDateTime | null           |
      | paginationSort.currentPage  |              1 |
      | paginationSort.pageSize     |            500 |
      | paginationSort.sortBy       | "customerType" |
      | paginationSort.isAscending  | true           |
    And set getCustomerTypesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypesPayload
    And request getCustomerTypesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCustomerTypesAPIResponse = response
    And print getCustomerTypesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id )
    And print mongoResult
    And match each getCustomerTypesAPIResponse.results[*].active == true
    And def getCustomerTypesResponseCount = karate.sizeOf(getCustomerTypesAPIResponse.results)
    And print getCustomerTypesResponseCount
    And match getCustomerTypesResponseCount == getCustomerTypesAPIResponse.totalRecordCount
    #GetCutomerType
    Given url readBaseUrl
    And path '/api/GetCustomerType'
    And set getCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCustomerType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | addCustomerTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                   |
      | id              | addCustomerTypeResponse.header.id            |
      | correlationId   | addCustomerTypeResponse.header.correlationId |
      | commandUserId   | addCustomerTypeResponse.header.commandUserId |
      | tags            | []                                           |
      | commandType     | "GetCustomerType"                            |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCommandBody
      | path       |                               0 |
      | request.id | addCustomerTypeResponse.body.id |
    And set getCustomerTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypePayload
    And sleep(15000)
    And request getCustomerTypePayload
    When method POST
    Then status 200
    And def getCustomerTypeAPIResponse = response
    And print getCustomerTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id
    And match getCustomerTypeAPIResponse.customerTypeId == addCustomerTypeResponse.body.customerTypeId
    #Adding the comment
    And def entityName = "CustomerType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCustomerTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "CustomerType"
    And def entityIdData = addCustomerTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CustomerTypeCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
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

  @CreateCustomerTypeWithMandatoryDetails
  Scenario Outline: Create a customer type code with Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/CreateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "CreateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                        0 |
      | id             | entityIdData             |
      | customerTypeId | faker.getUserId()        |
      | description    | faker.getFirstName()     |
      | isActive       | faker.getRandomBoolean() |
    And set addCustomerTypePayload
      | path   | [0]                          |
      | header | commandCustomerTypeHeader[0] |
      | body   | commandCustomerTypeBody[0]   |
    And print addCustomerTypePayload
    And request addCustomerTypePayload
    When method POST
    Then status 201
    And sleep(15000)
    And def addCustomerTypeResponse = response
    And print addCustomerTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypePayload.header.entityId)
    And print mongoResult
    And match mongoResult == addCustomerTypeResponse.body.id
    And match addCustomerTypeResponse.body.customerTypeId == addCustomerTypePayload.body.customerTypeId
    #GetCustomerTypes
    Given url readBaseUrl
    And path '/api/GetCustomerTypes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetCustomerTypes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | getType         | "Array"                                   |
      | commandUserId   | dataGenerator.commandUserId()             |
      | tags            | []                                        |
      | commandType     | "GetCustomerTypes"                        |
      | ttl             |                                         0 |
    And set getCommandBody
      | path                        |                                           0 |
      | request.customerTypeId      | addCustomerTypeResponse.body.customerTypeId |
      | request.lastUpdatedDateTime | null                                        |
      | paginationSort.currentPage  |                                           1 |
      | paginationSort.pageSize     |                                         500 |
      | paginationSort.sortBy       | "customerType"                              |
      | paginationSort.isAscending  | true                                        |
    And set getCustomerTypesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypesPayload
    And request getCustomerTypesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCustomerTypesAPIResponse = response
    And print getCustomerTypesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id )
    And print mongoResult
    And match   getCustomerTypesAPIResponse.results[0].customerTypeId == addCustomerTypeResponse.body.customerTypeId
    And def getCustomerTypesResponseCount = karate.sizeOf(getCustomerTypesAPIResponse.results)
    And print getCustomerTypesResponseCount
    And match getCustomerTypesResponseCount == getCustomerTypesAPIResponse.totalRecordCount
    #GetCutomerType
    Given url readBaseUrl
    And path '/api/GetCustomerType'
    And set getCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCustomerType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | addCustomerTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                   |
      | id              | addCustomerTypeResponse.header.id            |
      | correlationId   | addCustomerTypeResponse.header.correlationId |
      | commandUserId   | addCustomerTypeResponse.header.commandUserId |
      | tags            | []                                           |
      | commandType     | "GetCustomerType"                            |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCommandBody
      | path       |                               0 |
      | request.id | addCustomerTypeResponse.body.id |
    And set getCustomerTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypePayload
    And sleep(15000)
    And request getCustomerTypePayload
    When method POST
    Then status 200
    And def getCustomerTypeAPIResponse = response
    And print getCustomerTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id
    And match getCustomerTypeAPIResponse.customerTypeId == addCustomerTypeResponse.body.customerTypeId
    #Adding the comment
    And def entityName = "CustomerType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCustomerTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "CustomerType"
    And def entityIdData = addCustomerTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CustomerTypeCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCustomerTypeWithoutMandatoryFields
  Scenario Outline: Create a CustomerType information without mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/CreateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "CreateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path        |                        0 |
      | id          | entityIdData             |
      | description | faker.getFirstName()     |
      | isActive    | faker.getRandomBoolean() |
    And set addCustomerTypePayload
      | path   | [0]                          |
      | header | commandCustomerTypeHeader[0] |
      | body   | commandCustomerTypeBody[0]   |
    And print addCustomerTypePayload
    And request addCustomerTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCustomerTypeWithInvalidDetails
  Scenario Outline: Create a CustomerType information with invalid fields
    Given url commandBaseUrl
    And path '/api/CreateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
    And set commandCustomerTypeBody
      | path           |                        0 |
      | id             | entityIdData             |
      | customerTypeId | faker.getUserId()        |
      | description    | faker.getFirstName()     |
      | isActive       | faker.getRandomBoolean() |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getRandomBoolean()      |
    And set addCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print addCustomerTypePayload
    And request addCustomerTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyLocationWithAllDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a customerType with all the fields and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    And path '/api/UpdateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "UpdateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | addCustomerTypeResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                               0 |
      | id             | addCustomerTypeResponse.body.id |
      | customerTypeId | faker.getUserId()               |
      | description    | faker.getFirstName()            |
      | isActive       | faker.getRandomBoolean()        |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set updateCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print updateCustomerTypePayload
    And request updateCustomerTypePayload
    When method POST
    Then status 201
    And def updateCustomerTypeResponse = response
    And print updateCustomerTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCustomerTypeResponse.body.id
    And match updateCustomerTypeResponse.body.customerTypeId == updateCustomerTypePayload.body.customerTypeId
    #GetCustomerTypes
    Given url readBaseUrl
    And path '/api/GetCustomerTypes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetCustomerTypes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | getType         | "Array"                                   |
      | commandUserId   | dataGenerator.commandUserId()             |
      | tags            | []                                        |
      | commandType     | "GetCustomerTypes"                        |
      | ttl             |                                         0 |
    And set getCommandBody
      | path                        |              0 |
      | request.isActive            | true           |
      | request.lastUpdatedDateTime | null           |
      | paginationSort.currentPage  |              1 |
      | paginationSort.pageSize     |            500 |
      | paginationSort.sortBy       | "customerType" |
      | paginationSort.isAscending  | true           |
    And set getCustomerTypesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypesPayload
    And request getCustomerTypesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCustomerTypesAPIResponse = response
    And print getCustomerTypesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id )
    And print mongoResult
    And match each getCustomerTypesAPIResponse.results[*].active == true
    And def getCustomerTypesResponseCount = karate.sizeOf(getCustomerTypesAPIResponse.results)
    And print getCustomerTypesResponseCount
    And match getCustomerTypesResponseCount == getCustomerTypesAPIResponse.totalRecordCount
    #GetCutomerType
    Given url readBaseUrl
    And path '/api/GetCustomerType'
    And set getCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCustomerType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | addCustomerTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                   |
      | id              | addCustomerTypeResponse.header.id            |
      | correlationId   | addCustomerTypeResponse.header.correlationId |
      | commandUserId   | addCustomerTypeResponse.header.commandUserId |
      | tags            | []                                           |
      | commandType     | "GetCustomerType"                            |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCommandBody
      | path       |                               0 |
      | request.id | addCustomerTypeResponse.body.id |
    And set getCustomerTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypePayload
    And sleep(15000)
    And request getCustomerTypePayload
    When method POST
    Then status 200
    And def getCustomerTypeAPIResponse = response
    And print getCustomerTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id
    And match getCustomerTypeAPIResponse.customerTypeId == updateCustomerTypeResponse.body.customerTypeId
    #Adding the comment
    And def entityName = "CustomerType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCustomerTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "CustomerType"
    And def entityIdData = addCustomerTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CustomerTypeUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id
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

  @UpdateCustomerTypeWithMandatoryDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a customerType with Mandatory Details and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    And path '/api/UpdateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "UpdateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | addCustomerTypeResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                               0 |
      | id             | addCustomerTypeResponse.body.id |
      | customerTypeId | faker.getUserId()               |
      | description    | faker.getFirstName()            |
      | isActive       | faker.getRandomBoolean()        |
    And set updateCustomerTypePayload
      | path   | [0]                          |
      | header | commandCustomerTypeHeader[0] |
      | body   | commandCustomerTypeBody[0]   |
    And print updateCustomerTypePayload
    And request updateCustomerTypePayload
    When method POST
    Then status 201
    And def updateCustomerTypeResponse = response
    And print updateCustomerTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCustomerTypeResponse.body.id
    And match updateCustomerTypeResponse.body.customerTypeId == updateCustomerTypePayload.body.customerTypeId
    #GetCustomerTypes
    Given url readBaseUrl
    And path '/api/GetCustomerTypes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetCustomerTypes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | getType         | "Array"                                   |
      | commandUserId   | dataGenerator.commandUserId()             |
      | tags            | []                                        |
      | commandType     | "GetCustomerTypes"                        |
      | ttl             |                                         0 |
    And set getCommandBody
      | path                        |                                           0 |
      | request.description         | updateCustomerTypeResponse.body.description |
      | request.lastUpdatedDateTime | null                                        |
      | paginationSort.currentPage  |                                           1 |
      | paginationSort.pageSize     |                                         500 |
      | paginationSort.sortBy       | "customerType"                              |
      | paginationSort.isAscending  | true                                        |
    And set getCustomerTypesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypesPayload
    And request getCustomerTypesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCustomerTypesAPIResponse = response
    And print getCustomerTypesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id )
    And print mongoResult
    And match  getCustomerTypesAPIResponse.results[0].description = updateCustomerTypeResponse.body.description
    And def getCustomerTypesResponseCount = karate.sizeOf(getCustomerTypesAPIResponse.results)
    And print getCustomerTypesResponseCount
    And match getCustomerTypesResponseCount == getCustomerTypesAPIResponse.totalRecordCount
    #GetCutomerType
    Given url readBaseUrl
    And path '/api/GetCustomerType'
    And set getCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCustomerType-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | addCustomerTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                   |
      | id              | addCustomerTypeResponse.header.id            |
      | correlationId   | addCustomerTypeResponse.header.correlationId |
      | commandUserId   | addCustomerTypeResponse.header.commandUserId |
      | tags            | []                                           |
      | commandType     | "GetCustomerType"                            |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCommandBody
      | path       |                               0 |
      | request.id | addCustomerTypeResponse.body.id |
    And set getCustomerTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCustomerTypePayload
    And sleep(15000)
    And request getCustomerTypePayload
    When method POST
    Then status 200
    And def getCustomerTypeAPIResponse = response
    And print getCustomerTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id
    And match getCustomerTypeAPIResponse.customerTypeId == updateCustomerTypeResponse.body.customerTypeId
    #Adding the comment
    And def entityName = "CustomerType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCustomerTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "CustomerType"
    And def entityIdData = addCustomerTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CustomerTypeUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,addCustomerTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCustomerTypeAPIResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCustomerTypeInformationWithMissingMandatoryFields
  Scenario Outline: Update a Customer Type with missing mandatory fields
    Given url commandBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    And path '/api/UpdateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "UpdateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | addCustomerTypeResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path        |                               0 |
      | id          | addCustomerTypeResponse.body.id |
      | description | faker.getFirstName()            |
      | isActive    | faker.getRandomBoolean()        |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set updateCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print updateCustomerTypePayload
    And request updateCustomerTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCustomerTypeInformationWithInvalidData
  Scenario Outline: Update a customerType with invalid data to mandatory fields
    Given url commandBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    And path '/api/UpdateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "UpdateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | addCustomerTypeResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                               0 |
      | id             | addCustomerTypeResponse.body.id |
      | customerTypeId | faker.getUserId()               |
      | description    | faker.getFirstName()            |
      | isActive       | faker.getFirstName()            |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set updateCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print updateCustomerTypePayload
    And request updateCustomerTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateCustomerTypeID
  Scenario Outline: Create a Customer type with existing customer type ID
    Given url commandBaseUrl
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    And path '/api/CreateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/CreateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "CreateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                                           0 |
      | id             | entityIdData                                |
      | customerTypeId | addCustomerTypeResponse.body.customerTypeId |
      | description    | faker.getFirstName()                        |
      | isActive       | true                                        |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set createCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print createCustomerTypePayload
    And request createCustomerTypePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CustomerType cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCustomerTypeWithDuplicateCustomerID
  Scenario Outline: Update a Customer Type information with duplicate Customer ID
    #Create Customer Type  and Update
    Given url commandBaseUrl
    And path '/api/UpdateCustomerType'
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse = result.response
    And print  addCustomerTypeResponse
    #Creating another Customer Type
    And def result = call read('customerType.feature@CreateCustomerTypeWithAllDetails')
    And def addCustomerTypeResponse1 = result.response
    And print  addCustomerTypeResponse1
    And set updateCustomerTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/UpdateCustomerType-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | addCustomerTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                   |
      | id              | addCustomerTypeResponse.header.id            |
      | correlationId   | addCustomerTypeResponse.header.correlationId |
      | entityId        | addCustomerTypeResponse.header.entityId      |
      | commandUserId   | addCustomerTypeResponse.header.commandUserId |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | "UpdateCustomerType"                         |
      | entityName      | "CustomerType"                               |
      | ttl             |                                            0 |
    And set commandUpdateCustomerTypeBody
      | path           |                                           0 |
      | id             | addCustomerTypeResponse1.body.id            |
      | customerTypeId | addCustomerTypeResponse.body.customerTypeId |
      | description    | addCustomerTypeResponse.body.description    |
      | isActive       | faker.getRandomBoolean()                    |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set updateCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandUpdateCustomerTypeBody[0]            |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print updateCustomerTypePayload
    And request updateCustomerTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
