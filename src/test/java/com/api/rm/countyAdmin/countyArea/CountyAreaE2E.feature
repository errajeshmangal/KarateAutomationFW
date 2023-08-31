@CountyAreas
Feature: County Area - Add , Edit

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyAreaCollectionName = 'CreateCountyArea_'
    And def countyAreaCollectionNameRead = 'CountyAreaDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyAreaAndGetTheDetails
  Scenario Outline: Create a county Area information with all the fields and Get the details
    #Create and getALlcountyareas
    Given url readBaseUrl
    When path '/api/GetCountyAreas'
    And sleep(15000)
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithAllDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set getAreasCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyAreas-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetCountyAreas"                           |
      | getType         | "Array"                                    |
    And set getAreasCommandBodyRequest
      | path                |                                   0 |
      | code                |                                     |
      | name                |                                     |
      | isActive            | addCountyAreaResponse.body.isActive |
      | glCode              |                                     |
      | lastUpdatedDateTime |                                     |
    And set getAreasCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasPayload
      | path                | [0]                           |
      | header              | getAreasCommandHeader[0]      |
      | body.request        | getAreasCommandBodyRequest[0] |
      | body.paginationSort | getAreasCommandPagination[0]  |
    And print getAreasPayload
    And request getAreasPayload
    When method POST
    Then status 200
    And def getAreasResponse = response
    And print getAreasResponse
    And match getAreasResponse.results[*].id contains addCountyAreaResponse.body.id
    And match getAreasResponse.results[*].name contains addCountyAreaResponse.body.name
    And def getAreasResponseCount = karate.sizeOf(getAreasResponse.results)
    And print getAreasResponseCount
    And match getAreasResponseCount == getAreasResponse.totalRecordCount
    #Get the County Area
    Given url readBaseUrl
    And path '/api/GetCountyArea'
    And set getCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyArea-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "GetCountyArea"                            |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getCommandBody
      | path |                             0 |
      | id   | addCountyAreaResponse.body.id |
    And set getCountyAreaPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyAreaPayload
    And request getCountyAreaPayload
    When method POST
    Then status 200
    And def getCountyAreaResponse = response
    And print getCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyAreaCollectionNameRead+<tenantid>,getCountyAreaResponse.id)
    And print mongoResult
    And match mongoResult == getCountyAreaResponse.id
    And match getCountyAreaResponse.name == addCountyAreaResponse.body.name
    And sleep(15000)
    # History Validation
    And def eventName = "CountyAreaCreated"
    And def evnentType = "Areas"
    And def entityIdData = addCountyAreaResponse.body.id
    And def commandUserid = commandUserId
    And def parentEntityId = addCountyAreaResponse.body.id
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
    #Adding the comment
    And def entityName = "CountyArea"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCountyAreaResponse.body.id
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
    #view the comments before delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments before delete
    And def evnentType = "CountyArea"
    And def entityIdData = addCountyAreaResponse.body.id
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

  @CreateCountyAreaWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a county Area information with Mandatory fields and Get the details
    #Create and getcountyareas
    Given url readBaseUrl
    When path '/api/GetCountyAreas'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithMandatoryDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set getAreasCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyAreas-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetCountyAreas"                           |
      | getType         | "Array"                                    |
    And set getAreasCommandBodyRequest
      | path                |      0 |
      | code                |        |
      | name                | "Test" |
      | isActive            |        |
      | glCode              |        |
      | lastUpdatedDateTime |        |
    And set getAreasCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasPayload
      | path                | [0]                           |
      | header              | getAreasCommandHeader[0]      |
      | body.request        | getAreasCommandBodyRequest[0] |
      | body.paginationSort | getAreasCommandPagination[0]  |
    And print getAreasPayload
    And request getAreasPayload
    When method POST
    Then status 200
    And def getAreasResponse = response
    And print getAreasResponse
    And match getAreasResponse.results[*].id contains addCountyAreaResponse.body.id
    And match each getAreasResponse.results[*].name contains "Test"
    And def getAreasResponseCount = karate.sizeOf(getAreasResponse.results)
    And print getAreasResponseCount
    And match getAreasResponseCount == getAreasResponse.totalRecordCount
    #Get the County Area
    Given url readBaseUrl
    And path '/api/GetCountyArea'
    And set getCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyArea-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "GetCountyArea"                            |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getCommandBody
      | path |                             0 |
      | id   | addCountyAreaResponse.body.id |
    And set getCountyAreaPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyAreaPayload
    And request getCountyAreaPayload
    When method POST
    Then status 200
    And def getCountyAreaResponse = response
    And print getCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyAreaCollectionNameRead+<tenantid>,getCountyAreaResponse.id)
    And print mongoResult
    And match mongoResult == getCountyAreaResponse.id
    And match getCountyAreaResponse.name == addCountyAreaResponse.body.name
    And sleep(15000)
    # History Validation
    And def eventName = "CountyAreaCreated"
    And def evnentType = "Areas"
    And def entityIdData = addCountyAreaResponse.body.id
    And def commandUserid = commandUserId
    And def parentEntityId = addCountyAreaResponse.body.id
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
    #Adding the comment
    And def entityName = "CountyArea"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCountyAreaResponse.body.id
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
    # Get all the comments
    And def evnentType = "CountyArea"
    And def entityIdData = addCountyAreaResponse.body.id
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

  @UpdateCountyAreaWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a county Area information with Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCountyArea'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithMandatoryDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/UpdateCountyArea-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | entityId        | addCountyAreaResponse.header.entityId      |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          2 |
      | tags            | []                                         |
      | commandType     | "UpdateCountyArea"                         |
      | entityName      | "CountyArea"                               |
      | ttl             |                                          0 |
    And set commandBody
      | path     |                                     0 |
      | id       | addCountyAreaResponse.header.entityId |
      | code     | faker.getUserId()                     |
      | name     | faker.getFirstName()                  |
      | comments | faker.getRandomNumber()               |
      | active   | faker.getRandomBoolean()              |
    And set commandDepartment
      | path |                                          0 |
      | id   | addCountyAreaResponse.body.department.id   |
      | code | addCountyAreaResponse.body.department.code |
      | name | addCountyAreaResponse.body.department.name |
    And set updateCountyAreaPayload
      | path            | [0]                  |
      | header          | commandHeader[0]     |
      | body            | commandBody[0]       |
      | body.department | commandDepartment[0] |
    And print updateCountyAreaPayload
    And request updateCountyAreaPayload
    When method POST
    Then status 201
    And def updateCountyAreaResponse = response
    And print updateCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,addCountyAreaResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCountyAreaResponse.body.id
    And match updateCountyAreaResponse.body.name == updateCountyAreaPayload.body.name
    And sleep(10000)
    #getcountyareas
    Given url readBaseUrl
    When path '/api/GetCountyAreas'
    And set getAreasCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyAreas-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetCountyAreas"                           |
      | getType         | "Array"                                    |
    And set getAreasCommandBodyRequest
      | path                |    0 |
      | code                |      |
      | name                |      |
      | isActive            | true |
      | glCode              |      |
      | lastUpdatedDateTime |      |
    And set getAreasCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasPayload
      | path                | [0]                           |
      | header              | getAreasCommandHeader[0]      |
      | body.request        | getAreasCommandBodyRequest[0] |
      | body.paginationSort | getAreasCommandPagination[0]  |
    And print getAreasPayload
    And request getAreasPayload
    When method POST
    Then status 200
    And def getAreasResponse = response
    And print getAreasResponse
    And match each getAreasResponse.results[*].active == true
    And def getAreasResponseCount = karate.sizeOf(getAreasResponse.results)
    And print getAreasResponseCount
    And match getAreasResponseCount == getAreasResponse.totalRecordCount
    #GetCountyArea
    Given url readBaseUrl
    And path '/api/GetCountyArea'
    And set getCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetCountyArea-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | updateCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | updateCountyAreaResponse.header.id            |
      | correlationId   | updateCountyAreaResponse.header.correlationId |
      | commandUserId   | updateCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "GetCountyArea"                               |
      | getType         | "One"                                         |
      | ttl             |                                             0 |
    And set getCommandBody
      | path |                                0 |
      | id   | updateCountyAreaResponse.body.id |
    And set getCountyAreaPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyAreaPayload
    And request getCountyAreaPayload
    When method POST
    Then status 200
    And def getCountyAreaResponse = response
    And print getCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyAreaCollectionNameRead+<tenantid>,updateCountyAreaResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaResponse.id
    And match getCountyAreaResponse.name == updateCountyAreaResponse.body.name
    # History Validation
    And def eventName = "CountyAreaUpdated"
    And def evnentType = "Areas"
    And def entityIdData = getCountyAreaResponse.id
    And def commandUserid = commandUserId
    And def parentEntityId = getCountyAreaResponse.id
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
    #Adding the comment
    And def entityName = "CountyArea"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateCountyAreaResponse.body.id
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
    And def evnentType = "CountyArea"
    And def entityIdData = updateCountyAreaResponse.body.id
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

  @UpdateCountyAreaWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a county Area information with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCountyArea'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithAllDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def result1 = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartment')
    And def crateCountyDepartmentResponse1 = result1.response
    And print crateCountyDepartmentResponse1
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/UpdateCountyArea-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | entityId        | addCountyAreaResponse.header.entityId      |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "UpdateCountyArea"                         |
      | entityName      | "CountyArea"                               |
      | ttl             |                                          0 |
    And set commandBody
      | path     |                                     0 |
      | id       | addCountyAreaResponse.header.entityId |
      | code     | faker.getUserId()                     |
      | name     | faker.getFirstName()                  |
      | comments | faker.getRandomNumber()               |
      | active   | faker.getRandomBoolean()              |
    And set commandDepartment
      | path |                                        0 |
      | id   | crateCountyDepartmentResponse1.body.id   |
      | code | crateCountyDepartmentResponse1.body.code |
      | name | crateCountyDepartmentResponse1.body.name |
    And set commandAreaGLCode
      | path |                                      0 |
      | id   | addCountyAreaResponse.body.glCode.id   |
      | name | addCountyAreaResponse.body.glCode.name |
      | code | addCountyAreaResponse.body.glCode.code |
    And set updateCountyAreaPayload
      | path            | [0]                  |
      | header          | commandHeader[0]     |
      | body            | commandBody[0]       |
      | body.department | commandDepartment[0] |
      | body.glCode     | commandAreaGLCode[0] |
    And print updateCountyAreaPayload
    And request updateCountyAreaPayload
    When method POST
    Then status 201
    And def updateCountyAreaResponse = response
    And print updateCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,addCountyAreaResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCountyAreaResponse.body.id
    And match updateCountyAreaResponse.body.name == updateCountyAreaPayload.body.name
    And sleep(10000)
    #getcountyareas
    Given url readBaseUrl
    When path '/api/GetCountyAreas'
    And set getAreasCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyAreas-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetCountyAreas"                           |
      | getType         | "Array"                                    |
    And set getAreasCommandBodyRequest
      | path                |      0 |
      | code                |        |
      | name                |        |
      | isActive            |        |
      | glCode              | "Test" |
      | lastUpdatedDateTime |        |
    And set getAreasCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasPayload
      | path                | [0]                           |
      | header              | getAreasCommandHeader[0]      |
      | body.request        | getAreasCommandBodyRequest[0] |
      | body.paginationSort | getAreasCommandPagination[0]  |
    And print getAreasPayload
    And request getAreasPayload
    When method POST
    Then status 200
    And def getAreasResponse = response
    And print getAreasResponse
    And match each getAreasResponse.results[*].glCode.code contains "Test"
    And def getAreasResponseCount = karate.sizeOf(getAreasResponse.results)
    And print getAreasResponseCount
    And match getAreasResponseCount == getAreasResponse.totalRecordCount
    #GetCountyArea
    Given url readBaseUrl
    And path '/api/GetCountyArea'
    And set getCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetCountyArea-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "GetCountyArea"                            |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getCommandBody
      | path |                             0 |
      | id   | addCountyAreaResponse.body.id |
    And set getCountyAreaPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyAreaPayload
    And request getCountyAreaPayload
    When method POST
    Then status 200
    And def getCountyAreaResponse = response
    And print getCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyAreaCollectionNameRead+<tenantid>,addCountyAreaResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaResponse.id
    And match getCountyAreaResponse.name == updateCountyAreaResponse.body.name
    # History Validation
    And def eventName = "CountyAreaUpdated"
    And def evnentType = "Areas"
    And def entityIdData = getCountyAreaResponse.id
    And def commandUserid = commandUserId
    And def parentEntityId = getCountyAreaResponse.id
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
    #Adding the comment
    And def entityName = "CountyArea"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateCountyAreaResponse.body.id
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
    And def evnentType = "CountyArea"
    And def entityIdData = updateCountyAreaResponse.body.id
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
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def entityIdData = updateCountyAreaResponse.body.id
    And def viewAllCommentResultAfterDelete = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewAllCommentsResultAfterDelete = viewAllCommentResultAfterDelete.response
    And print viewAllCommentsResultAfterDelete
    And def viewAllCommentsResultAfterDeleteCount = karate.sizeOf(viewAllCommentsResultAfterDelete.results)
    And print viewAllCommentsResultAfterDeleteCount
    And match viewAllCommentsResultAfterDeleteCount == viewAllCommentsResultAfterDelete.totalRecordCount
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

  @CountyAreaWithDuplicateEntity
  Scenario Outline: Create a county Area information with duplicate entity
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithMandatoryDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                               0 |
      | id       | entityIdData                    |
      | code     | addCountyAreaResponse.body.code |
      | name     | faker.getFirstName()            |
      | active   | faker.getRandomBoolean()        |
      | comments | faker.getRandomNumber()         |
    And set commandAreaDepartment
      | path |                                       0 |
      | id   | addCountyAreaResponse.body.department.id   |
      | code | addCountyAreaResponse.body.department.code |
      | name | addCountyAreaResponse.body.department.name |
    And set addCountyAreaPayload
      | path            | [0]                      |
      | header          | commandAreaHeader[0]     |
      | body            | commandAreaBody[0]       |
      | body.department | commandAreaDepartment[0] |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CountyArea cannot be created.'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyAreaWithInvalidDataToMandatoryFields
  Scenario Outline: Create a county Area information by passing invalid data to Mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartment')
    And def crateCountyDepartmentResponse = result.response
    And print crateCountyDepartmentResponse
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                        0 |
      | id       | entityIdData             |
      | code     | faker.getUserId()        |
      | name     | faker.getFirstName()     |
      | active   | faker.getRandomBoolean() |
      | comments | faker.getRandomNumber()  |
    And set commandAreaDepartment
      | path |                                       0 |
      | id   | faker.getUserId()                       |
      | code | crateCountyDepartmentResponse.body.code |
      | name | crateCountyDepartmentResponse.body.name |
    And set commandAreaGLCode
      | path |                                              0 |
      | id   | crateCountyDepartmentResponse.body.glCode.id   |
      | name | crateCountyDepartmentResponse.body.glCode.name |
      | code | crateCountyDepartmentResponse.body.glCode.code |
    And set addCountyAreaPayload
      | path            | [0]                      |
      | header          | commandAreaHeader[0]     |
      | body            | commandAreaBody[0]       |
      | body.department | commandAreaDepartment[0] |
      | body.glCode     | commandAreaGLCode[0]     |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyAreaWithMissingMandatoryFields
  Scenario Outline: Create a county Area information with missing Mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartment')
    And def crateCountyDepartmentResponse = result.response
    And print crateCountyDepartmentResponse
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                        0 |
      | id       | entityIdData             |
      | code     | faker.getUserId()        |
      | name     | faker.getFirstName()     |
      | active   | faker.getRandomBoolean() |
      | comments | faker.getRandomNumber()  |
    And set commandAreaGLCode
      | path |                                              0 |
      | id   | crateCountyDepartmentResponse.body.glCode.id   |
      | name | crateCountyDepartmentResponse.body.glCode.name |
      | code | crateCountyDepartmentResponse.body.glCode.code |
    And set addCountyAreaPayload
      | path        | [0]                  |
      | header      | commandAreaHeader[0] |
      | body        | commandAreaBody[0]   |
      | body.glCode | commandAreaGLCode[0] |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyAreaWithMissingMandatoryfields
  Scenario Outline: Update a county Area information with missing Mandatory Fields
    Given url commandBaseUrl
    And path '/api/UpdateCountyArea'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithMandatoryDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def result1 = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartmentWithMandatoryFields')
    And def crateCountyDepartmentResponse1 = result1.response
    And print crateCountyDepartmentResponse1
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/UpdateCountyArea-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | entityId        | addCountyAreaResponse.header.entityId      |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "UpdateCountyArea"                         |
      | entityName      | "CountyArea"                               |
      | ttl             |                                          0 |
    And set commandBody
      | path     |                                     0 |
      | id       | addCountyAreaResponse.header.entityId |
      | code     | faker.getUserId()                     |
      | name     | faker.getFirstName()                  |
      | comments | faker.getRandomNumber()               |
      | active   | faker.getRandomBoolean()              |
    And set updateCountyAreaPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateCountyAreaPayload
    And request updateCountyAreaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyAreaWithInvalidDataTomandatoryFields
  Scenario Outline: Update a county Area information with Invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateCountyArea'
    And def result = call read('CreateCountyArea.feature@CreateCountyAreaWithMandatoryDetails')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def result1 = call read('classpath:com/api/rm/countyAdmin/DepartmentFeature/CreateCountyDepartment.feature@CreateCountyDepartmentWithMandatoryFields')
    And def crateCountyDepartmentResponse1 = result1.response
    And print crateCountyDepartmentResponse1
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/UpdateCountyArea-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | addCountyAreaResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | addCountyAreaResponse.header.id            |
      | correlationId   | addCountyAreaResponse.header.correlationId |
      | entityId        | addCountyAreaResponse.header.entityId      |
      | commandUserId   | addCountyAreaResponse.header.commandUserId |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "UpdateCountyArea"                         |
      | entityName      | "CountyArea"                               |
      | ttl             |                                          0 |
    And set commandBody
      | path     |                                     0 |
      | id       | addCountyAreaResponse.header.entityId |
      | code     | faker.getUserId()                     |
      | name     | faker.getFirstName()                  |
      | comments | faker.getRandomNumber()               |
      | active   | faker.getRandomBoolean()              |
    And set commandAreaDepartment
      | path |                               0 |
      | id   | faker.getUserId()               |
      | code | addCountyAreaResponse.body.code |
      | name | addCountyAreaResponse.body.name |
    And set updateCountyAreaPayload
      | path            | [0]                      |
      | header          | commandHeader[0]         |
      | body            | commandBody[0]           |
      | body.department | commandAreaDepartment[0] |
    And print updateCountyAreaPayload
    And request updateCountyAreaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
