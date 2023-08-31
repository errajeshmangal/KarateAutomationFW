@AreaMaintenance
Feature: Area Maintenance - Add, Edit , View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def areaMaintenanceCollectionName = 'CreateAreaMaintenance_'
    And def areaMaintenanceCollectionNameRead = 'AreaMaintenanceDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @createAreaMaintenaceWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a county Area information with all the fields and Get the details
    #Create County Area Maintenance and Get the Area Maintenance
    Given url readBaseUrl
    When path '/api/GetAreaMaintenances'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenance')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And sleep(10000)
    #getAreaMaintenances
    And set getAreasMaintenacesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | ttl             |                                               0 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenances"                           |
      | getType         | "Array"                                         |
    And set getAreasMaintenacesCommandBodyRequest
      | path  |      0 |
      | range | "Test" |
    And set getAreasMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasMaintenacesPayload
      | path                | [0]                                      |
      | header              | getAreasMaintenacesCommandHeader[0]      |
      | body.request        | getAreasMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getAreasMaintenacesCommandPagination[0]  |
    And print getAreasMaintenacesPayload
    And request getAreasMaintenacesPayload
    When method POST
    Then status 200
    And def getAreasMaintenacesResponse = response
    And print getAreasMaintenacesResponse
    And match each getAreasMaintenacesResponse.results[*].range contains "Test"
    #GetCountyAreaMaintenance
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenance"                            |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |                                  0 |
      | id   | addAreaMaintenanceResponse.body.id |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,addAreaMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaMaintenanceResponse.id
    And match getCountyAreaMaintenanceResponse.areaCode == addAreaMaintenanceResponse.body.areaCode
    # History Validation
    And def entityIdData = getCountyAreaMaintenanceResponse.id
    And def parentEntityId = null
    And def eventName = 'AreaMaintenanceCreated'
    And def evnentType = 'AreaMaintenance'
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
    #Adding the comment
    And def entityName = "AreaMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAreaMaintenanceResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "AreaMaintenance"
    And def entityIdData = addAreaMaintenanceResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @createAreaMaintenaceWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a county Area information with mandatory fields and Get the details
    #Create County Area Maintenance and Get the Area Maintenance
    Given url readBaseUrl
    When path '/api/GetAreaMaintenances'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And sleep(10000)
    #getAreaMaintenances
    And set getAreasMaintenacesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | ttl             |                                               0 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenances"                           |
      | getType         | "Array"                                         |
    And set getAreasMaintenacesCommandBodyRequest
      | path     |      0 |
      | townCode | "Test" |
    And set getAreasMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasMaintenacesPayload
      | path                | [0]                                      |
      | header              | getAreasMaintenacesCommandHeader[0]      |
      | body.request        | getAreasMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getAreasMaintenacesCommandPagination[0]  |
    And print getAreasMaintenacesPayload
    And request getAreasMaintenacesPayload
    When method POST
    Then status 200
    And def getAreasMaintenacesResponse = response
    And print getAreasMaintenacesResponse
    And match each getAreasMaintenacesResponse.results[*].townCode contains "Test"
    #GetCountyAreaMaintenance
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenance"                            |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |                                  0 |
      | id   | addAreaMaintenanceResponse.body.id |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,addAreaMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaMaintenanceResponse.id
    And match getCountyAreaMaintenanceResponse.areaCode == addAreaMaintenanceResponse.body.areaCode
    # History Validation
    And def entityIdData = getCountyAreaMaintenanceResponse.id
    And def parentEntityId = null
    And def eventName = 'AreaMaintenanceCreated'
    And def evnentType = 'AreaMaintenance'
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
    #Adding the comment
    And def entityName = "AreaMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addAreaMaintenanceResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "AreaMaintenance"
    And def entityIdData = addAreaMaintenanceResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @updateAreaMaintenaceWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a county Area information with all the fields and Get the details
    #Create CountyArea Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateAreaMaintenance'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenance')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And set updateAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/UpdateAreaMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | entityId        | addAreaMaintenanceResponse.header.entityId      |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "UpdateAreaMaintenance"                         |
      | entityName      | "AreaMaintenance"                               |
      | ttl             |                                               0 |
    And set updateAreaMaintenanceCommandBody
      | path           |                                           0 |
      | id             | addAreaMaintenanceResponse.header.entityId  |
      | areaCode       | faker.getUserId()                           |
      | description    | addAreaMaintenanceResponse.body.description |
      | townCode       | faker.getUserId()                           |
      | townDirection  | faker.getDirection()                        |
      | range          | faker.getUserId()                           |
      | rangeDirection | faker.getDirection()                        |
      | isActive       | faker.getRandomBoolean()                    |
    And set updateAreaMaintenancePayload
      | path   | [0]                                   |
      | header | updateAreaMaintenanceCommandHeader[0] |
      | body   | updateAreaMaintenanceCommandBody[0]   |
    And print updateAreaMaintenancePayload
    And request updateAreaMaintenancePayload
    When method POST
    Then status 201
    And def updateAreaMaintenanceResponse = response
    And print updateAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,areaMaintenanceCollectionName+<tenantid>,addAreaMaintenanceResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAreaMaintenanceResponse.body.id
    And match updateAreaMaintenanceResponse.body.townCode == updateAreaMaintenancePayload.body.townCode
    And match updateAreaMaintenanceResponse.body.description == addAreaMaintenanceResponse.body.description
    And sleep(10000)
    #getAreaMaintenances
    Given url readBaseUrl
    When path '/api/GetAreaMaintenances'
    And set getAreasMaintenacesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | ttl             |                                               0 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenances"                           |
      | getType         | "Array"                                         |
    And set getAreasMaintenacesCommandBodyRequest
      | path          |                                                0 |
      | townDirection | updateAreaMaintenanceResponse.body.townDirection |
    And set getAreasMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasMaintenacesPayload
      | path                | [0]                                      |
      | header              | getAreasMaintenacesCommandHeader[0]      |
      | body.request        | getAreasMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getAreasMaintenacesCommandPagination[0]  |
    And print getAreasMaintenacesPayload
    And request getAreasMaintenacesPayload
    When method POST
    Then status 200
    And def getAreasMaintenacesResponse = response
    And print getAreasMaintenacesResponse
    And match each getAreasMaintenacesResponse.results[*].townDirection contains updateAreaMaintenanceResponse.body.townDirection
    #GetCountyArea
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenance"                            |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |                                  0 |
      | id   | addAreaMaintenanceResponse.body.id |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,addAreaMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaMaintenanceResponse.id
    And match getCountyAreaMaintenanceResponse.areaCode == updateAreaMaintenanceResponse.body.areaCode
    And match getCountyAreaMaintenanceResponse.townCode == updateAreaMaintenanceResponse.body.townCode
    # History Validation
    And def entityIdData = getCountyAreaMaintenanceResponse.id
    And def parentEntityId = null
    And def eventName = 'AreaMaintenanceUpdated'
    And def evnentType = 'AreaMaintenance'
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
    #Adding the comment
    And def entityName = "AreaMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateAreaMaintenanceResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "AreaMaintenance"
    And def entityIdData = updateAreaMaintenanceResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @updateAreaMaintenaceWithMandatoryDetailsAndGetTheDetails
  Scenario Outline: Update a county Area information with Mandatory details and Get the details
    #Create CountyArea Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateAreaMaintenance'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And set updateAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/UpdateAreaMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | entityId        | addAreaMaintenanceResponse.header.entityId      |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "UpdateAreaMaintenance"                         |
      | entityName      | "AreaMaintenance"                               |
      | ttl             |                                               0 |
    And set updateAreaMaintenanceCommandBody
      | path        |                                          0 |
      | id          | addAreaMaintenanceResponse.header.entityId |
      | areaCode    | faker.getUserId()                          |
      | description | faker.getRandomLongDescription()           |
    And set updateAreaMaintenancePayload
      | path   | [0]                                   |
      | header | updateAreaMaintenanceCommandHeader[0] |
      | body   | updateAreaMaintenanceCommandBody[0]   |
    And print updateAreaMaintenancePayload
    And request updateAreaMaintenancePayload
    When method POST
    Then status 201
    And def updateAreaMaintenanceResponse = response
    And print updateAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,areaMaintenanceCollectionName+<tenantid>,addAreaMaintenanceResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAreaMaintenanceResponse.body.id
    And match updateAreaMaintenanceResponse.body.areaCode == updateAreaMaintenancePayload.body.areaCode
    And match updateAreaMaintenanceResponse.body.description == updateAreaMaintenancePayload.body.description
    And sleep(10000)
    #getAreaMaintenances
    Given url readBaseUrl
    When path '/api/GetAreaMaintenances'
    And set getAreasMaintenacesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | ttl             |                                               0 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenances"                           |
      | getType         | "Array"                                         |
    And set getAreasMaintenacesCommandBodyRequest
      | path     |      0 |
      | areaCode | "Test" |
    And set getAreasMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAreasMaintenacesPayload
      | path                | [0]                                      |
      | header              | getAreasMaintenacesCommandHeader[0]      |
      | body.request        | getAreasMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getAreasMaintenacesCommandPagination[0]  |
    And print getAreasMaintenacesPayload
    And request getAreasMaintenacesPayload
    When method POST
    Then status 200
    And def getAreasMaintenacesResponse = response
    And print getAreasMaintenacesResponse
    And match each getAreasMaintenacesResponse.results[*].areaCode contains "Test"
    #GetCountyArea
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "GetAreaMaintenance"                            |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |                                  0 |
      | id   | addAreaMaintenanceResponse.body.id |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,addAreaMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyAreaMaintenanceResponse.id
    And match getCountyAreaMaintenanceResponse.areaCode == updateAreaMaintenanceResponse.body.areaCode
    # History Validation
    And def entityIdData = getCountyAreaMaintenanceResponse.id
    And def parentEntityId = null
    And def eventName = 'AreaMaintenanceUpdated'
    And def evnentType = 'AreaMaintenance'
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
    #Adding the comment
    And def entityName = "AreaMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateAreaMaintenanceResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
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
    And def evnentType = "AreaMaintenance"
    And def entityIdData = updateAreaMaintenanceResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreateAreaMaintenanceWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Area Maintenance with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateAreaMaintenance'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createAreaMaintenanceCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "CreateAreaMaintenance"                        |
      | entityName      | "AreaMaintenance"                              |
      | ttl             |                                              0 |
    And set createAreaMaintenanceCommandBody
      | path        |                       0 |
      | id          | faker.getUserId()       |
      | areaCode    | faker.getUserId()       |
      | description | faker.getRandomNumber() |
    And set createAreaMaintenancePayload
      | path   | [0]                                   |
      | header | createAreaMaintenanceCommandHeader[0] |
      | body   | createAreaMaintenanceCommandBody[0]   |
    And print createAreaMaintenancePayload
    And request createAreaMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAreaMaintenanceWithMissingMandatoryField
  Scenario Outline: Create a Area Maintenance with missing mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateAreaMaintenance'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createAreaMaintenanceCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "CreateAreaMaintenance"                        |
      | entityName      | "AreaMaintenance"                              |
      | ttl             |                                              0 |
    And set createAreaMaintenanceCommandBody
      | path     |                 0 |
      | id       | entityIdData      |
      | areaCode | faker.getUserId() |
    And set createAreaMaintenancePayload
      | path   | [0]                                   |
      | header | createAreaMaintenanceCommandHeader[0] |
      | body   | createAreaMaintenanceCommandBody[0]   |
    And print createAreaMaintenancePayload
    And request createAreaMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAreaMaintenanceWithDuplicateAreaCode
  Scenario Outline: Create a Area Maintenance with duplicate area code and Validate
    Given url commandBaseUrl
    And path '/api/CreateAreaMaintenance'
    And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def createAreaResponse = result.response
    And print createAreaResponse
    And def areaId = createAreaResponse.body.id
    #Get the Area response
    And def result1 = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@GetAreaMaintenace'){areaId:'#(areaId)'}
    And def getAreaResponse = result1.response
    And print getAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set createAreaMaintenanceCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "CreateAreaMaintenance"                        |
      | entityName      | "AreaMaintenance"                              |
      | ttl             |                                              0 |
    And set createAreaMaintenanceCommandBody
      | path        |                        0 |
      | id          | entityIdData             |
      | areaCode    | getAreaResponse.areaCode |
      | description | faker.getRandomNumber()  |
    And set createAreaMaintenancePayload
      | path   | [0]                                   |
      | header | createAreaMaintenanceCommandHeader[0] |
      | body   | createAreaMaintenanceCommandBody[0]   |
    And print createAreaMaintenancePayload
    And request createAreaMaintenancePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:AreaMaintenance cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAreaMaintenaceWithInvaliDataToMandatoryFields
  Scenario Outline: Update a county Area information with invalid data to mandatory fields
    #Create CountyArea Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateAreaMaintenance'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And set updateAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/UpdateAreaMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | entityId        | addAreaMaintenanceResponse.header.entityId      |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "UpdateAreaMaintenance"                         |
      | entityName      | "AreaMaintenance"                               |
      | ttl             |                                               0 |
    And set updateAreaMaintenanceCommandBody
      | path        |                                0 |
      | id          | faker.getUserId()                |
      | areaCode    | faker.getUserId()                |
      | description | faker.getRandomLongDescription() |
    And set updateAreaMaintenancePayload
      | path   | [0]                                   |
      | header | updateAreaMaintenanceCommandHeader[0] |
      | body   | updateAreaMaintenanceCommandBody[0]   |
    And print updateAreaMaintenancePayload
    And request updateAreaMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAreaMaintenaceWithMissingMandatoryFields
  Scenario Outline: Update a county Area information with missing mandatory fields
    #Create CountyArea Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateAreaMaintenance'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    And set updateAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/UpdateAreaMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | entityId        | addAreaMaintenanceResponse.header.entityId      |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "UpdateAreaMaintenance"                         |
      | entityName      | "AreaMaintenance"                               |
      | ttl             |                                               0 |
    And set updateAreaMaintenanceCommandBody
      | path     |                                          0 |
      | id       | addAreaMaintenanceResponse.header.entityId |
      | areaCode | faker.getUserId()                          |
    And set updateAreaMaintenancePayload
      | path   | [0]                                   |
      | header | updateAreaMaintenanceCommandHeader[0] |
      | body   | updateAreaMaintenanceCommandBody[0]   |
    And print updateAreaMaintenancePayload
    And request updateAreaMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAreaMaintenaceWithDuplicateAreaCode
  Scenario Outline: Update a county Area information with duplicate areacode
    #Create CountyArea Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateAreaMaintenance'
    And def result = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse = result.response
    And print addAreaMaintenanceResponse
    #Creating another Area Maintenance code
    And def result1 = call read('CreateAreaMaintenance.feature@CreateAreaMaintenanceWithMandatoryFields')
    And def addAreaMaintenanceResponse1 = result1.response
    And print addAreaMaintenanceResponse1
    And set updateAreaMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/UpdateAreaMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addAreaMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addAreaMaintenanceResponse.header.id            |
      | correlationId   | addAreaMaintenanceResponse.header.correlationId |
      | entityId        | addAreaMaintenanceResponse.header.entityId      |
      | commandUserId   | addAreaMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "UpdateAreaMaintenance"                         |
      | entityName      | "AreaMaintenance"                               |
      | ttl             |                                               0 |
    And set updateAreaMaintenanceCommandBody
      | path        |                                          0 |
      | id          | addAreaMaintenanceResponse.header.entityId |
      | areaCode    | addAreaMaintenanceResponse1.body.areaCode  |
      | description | faker.getRandomNumber()                    |
    And set updateAreaMaintenancePayload
      | path   | [0]                                   |
      | header | updateAreaMaintenanceCommandHeader[0] |
      | body   | updateAreaMaintenanceCommandBody[0]   |
    And print updateAreaMaintenancePayload
    And request updateAreaMaintenancePayload
    When method POST
    Then status 400
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |
