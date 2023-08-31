@CondoMaintenance
Feature: Condo Maintenance - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def condoMaintenanceCollectionName = 'CreateCondoMaintenance_'
    And def condoMaintenanceCollectionNameRead = 'CondoMaintenanceDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @createCondoMaintenaceWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a county Condo information with all the fields and Get the details
    #Create County Condo Maintenance and Get the Condo Maintenance
    Given url readBaseUrl
    When path '/api/GetCondoMaintenances'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenance')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    And sleep(10000)
    #getCondoMaintenances
    And set getCondosMaintenacesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenances"                           |
      | getType         | "Array"                                          |
    And set getCondosMaintenacesCommandBodyRequest
      | path |      0 |
      | code | "Test" |
    And set getCondosMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCondosMaintenacesPayload
      | path                | [0]                                       |
      | header              | getCondosMaintenacesCommandHeader[0]      |
      | body.request        | getCondosMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getCondosMaintenacesCommandPagination[0]  |
    And print getCondosMaintenacesPayload
    And request getCondosMaintenacesPayload
    When method POST
    Then status 200
    And def getCondosMaintenacesResponse = response
    And print getCondosMaintenacesResponse
    And match each getCondosMaintenacesResponse.results[*].code contains "Test"
    And def getCondosMaintenacesResponseCount = karate.sizeOf(getCondosMaintenacesResponse.results)
    And print getCondosMaintenacesResponseCount
    And match getCondosMaintenacesResponseCount == getCondosMaintenacesResponse.totalRecordCount
    #GetCountyCondoMaintenance
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenance"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |                                   0 |
      | id   | addCondoMaintenanceResponse.body.id |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,addCondoMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyCondoMaintenanceResponse.id
    And match getCountyCondoMaintenanceResponse.page == addCondoMaintenanceResponse.body.page
    # History Validation
    And def eventName = "CondoMaintenanceCreated"
    And def evnentType = "CondoMaintenances"
    And def entityIdData = addCondoMaintenanceResponse.body.id
    And def parentEntityId = null
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
    And def entityName = "CondoMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCondoMaintenanceResponse.body.id
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
    And def evnentType = "CondoMaintenance"
    And def entityIdData = addCondoMaintenanceResponse.body.id
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

  @createCondoMaintenaceWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a county Condo information with mandatory fields and Get the details
    #Create County Condo Maintenance and Get the Condo Maintenance
    Given url readBaseUrl
    When path '/api/GetCondoMaintenances'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    And sleep(10000)
    #getCondoMaintenances
    And set getCondosMaintenacesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenances"                           |
      | getType         | "Array"                                          |
    And set getCondosMaintenacesCommandBodyRequest
      | path        |      0 |
      | description | "Test" |
    And set getCondosMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCondosMaintenacesPayload
      | path                | [0]                                       |
      | header              | getCondosMaintenacesCommandHeader[0]      |
      | body.request        | getCondosMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getCondosMaintenacesCommandPagination[0]  |
    And print getCondosMaintenacesPayload
    And request getCondosMaintenacesPayload
    When method POST
    Then status 200
    And def getCondosMaintenacesResponse = response
    And print getCondosMaintenacesResponse
    And match each getCondosMaintenacesResponse.results[*].description contains "Test"
    And def getCondosMaintenacesResponseCount = karate.sizeOf(getCondosMaintenacesResponse.results)
    And print getCondosMaintenacesResponseCount
    And match getCondosMaintenacesResponseCount == getCondosMaintenacesResponse.totalRecordCount
    #GetCountyCondoMaintenance
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenance"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |                                   0 |
      | id   | addCondoMaintenanceResponse.body.id |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,addCondoMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyCondoMaintenanceResponse.id
    And match getCountyCondoMaintenanceResponse.areaCode == addCondoMaintenanceResponse.body.areaCode
    # History Validation
    And def eventName = "CondoMaintenanceCreated"
    And def evnentType = "CondoMaintenances"
    And def entityIdData = addCondoMaintenanceResponse.body.id
    And def commandUserid = commandUserId
    And def parentEntityId = null
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
    And def entityName = "CondoMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCondoMaintenanceResponse.body.id
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
    And def evnentType = "CondoMaintenance"
    And def entityIdData = addCondoMaintenanceResponse.body.id
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

  @updateCondoMaintenaceWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a county Condo information with all the fields and Get the details
    #Create CountyCondo Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenance')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    And set updateCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCondoMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | entityId        | addCondoMaintenanceResponse.header.entityId      |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateCondoMaintenance"                         |
      | entityName      | "CondoMaintenance"                               |
      | ttl             |                                                0 |
    And set updateCondoMaintenanceCommandBody
      | path           |                                           0 |
      | id             | addCondoMaintenanceResponse.header.entityId |
      | code           | faker.getUserId()                           |
      | description    | faker.getRandomNumber()                     |
      | townCode       | faker.getUserId()                           |
      | townDirection  | faker.getDirection()                        |
      | range          | faker.getUserId()                           |
      | rangeDirection | faker.getDirection()                        |
      | isActive       | faker.getRandomBoolean()                    |
      | liber          | faker.getRandomShortDescription()           |
      | page           | faker.getRandomShortDescription()           |
      | phase          | faker.getRandomNumber()                     |
    And set updateCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | addCondoMaintenanceResponse.body.areaCode.id   |
      | code | addCondoMaintenanceResponse.body.areaCode.code |
      | name | addCondoMaintenanceResponse.body.areaCode.name |
    And set updateCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | updateCondoMaintenanceCommandHeader[0]   |
      | body          | updateCondoMaintenanceCommandBody[0]     |
      | body.areaCode | updateCondoMaintenanceCommandAreaCode[0] |
    And print updateCondoMaintenancePayload
    And request updateCondoMaintenancePayload
    When method POST
    Then status 201
    And def updateCondoMaintenanceResponse = response
    And print updateCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,condoMaintenanceCollectionName+<tenantid>,addCondoMaintenanceResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCondoMaintenanceResponse.body.id
    And match updateCondoMaintenanceResponse.body.rangeDirection == updateCondoMaintenancePayload.body.rangeDirection
    And match updateCondoMaintenanceResponse.body.areaCode.code == addCondoMaintenanceResponse.body.areaCode.code
    And sleep(10000)
    #getCondoMaintenances
    Given url readBaseUrl
    When path '/api/GetCondoMaintenances'
    And set getCondosMaintenacesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenances"                           |
      | getType         | "Array"                                          |
    And set getCondosMaintenacesCommandBodyRequest
      | path     |                                                 0 |
      | areaCode | updateCondoMaintenanceResponse.body.areaCode.code |
    And set getCondosMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCondosMaintenacesPayload
      | path                | [0]                                       |
      | header              | getCondosMaintenacesCommandHeader[0]      |
      | body.request        | getCondosMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getCondosMaintenacesCommandPagination[0]  |
    And print getCondosMaintenacesPayload
    And request getCondosMaintenacesPayload
    When method POST
    Then status 200
    And def getCondosMaintenacesResponse = response
    And print getCondosMaintenacesResponse
    And match each getCondosMaintenacesResponse.results[*].areaCode == updateCondoMaintenanceResponse.body.areaCode
    And def getCondosMaintenacesResponseCount = karate.sizeOf(getCondosMaintenacesResponse.results)
    And print getCondosMaintenacesResponseCount
    And match getCondosMaintenacesResponseCount == getCondosMaintenacesResponse.totalRecordCount
    #GetCountyCondo
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenance"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |                                   0 |
      | id   | addCondoMaintenanceResponse.body.id |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,addCondoMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyCondoMaintenanceResponse.id
    And match getCountyCondoMaintenanceResponse.areaCode.name == updateCondoMaintenanceResponse.body.areaCode.name
    # History Validation
    And def eventName = "CondoMaintenanceUpdated"
    And def evnentType = "CondoMaintenances"
    And def entityIdData = getCountyCondoMaintenanceResponse.id
    And def commandUserid = commandUserId
    And def parentEntityId = null
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
    And def entityName = "CondoMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCondoMaintenanceResponse.body.id
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
    And def evnentType = "CondoMaintenance"
    And def entityIdData = addCondoMaintenanceResponse.body.id
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

  @updateCondoMaintenaceWithMandatoryDetailsAndGetTheDetails
  Scenario Outline: Update a county Condo information with Mandatory details and Get the details
    #Create CountyCondo Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    #Create Area Maintenace to update Area code
    And def result1 = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse1 = result1.response
    And print createAreaMaintenanceResponse1
    And set updateCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCondoMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | entityId        | addCondoMaintenanceResponse.header.entityId      |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateCondoMaintenance"                         |
      | entityName      | "CondoMaintenance"                               |
      | ttl             |                                                0 |
    And set updateCondoMaintenanceCommandBody
      | path        |                                           0 |
      | id          | addCondoMaintenanceResponse.header.entityId |
      | code        | faker.getUserId()                           |
      | description | faker.getRandomLongDescription()            |
    And set updateCondoMaintenanceCommandAreaCode
      | path |                                               0 |
      | id   | createAreaMaintenanceResponse1.body.id          |
      | code | createAreaMaintenanceResponse1.body.areaCode    |
      | name | createAreaMaintenanceResponse1.body.description |
    And set updateCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | updateCondoMaintenanceCommandHeader[0]   |
      | body          | updateCondoMaintenanceCommandBody[0]     |
      | body.areaCode | updateCondoMaintenanceCommandAreaCode[0] |
    And print updateCondoMaintenancePayload
    And request updateCondoMaintenancePayload
    When method POST
    Then status 201
    And def updateCondoMaintenanceResponse = response
    And print updateCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,condoMaintenanceCollectionName+<tenantid>,addCondoMaintenanceResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCondoMaintenanceResponse.body.id
    And match updateCondoMaintenanceResponse.body.code == updateCondoMaintenancePayload.body.code
    And match updateCondoMaintenanceResponse.body.areaCode.code == createAreaMaintenanceResponse1.body.areaCode
    And sleep(10000)
    #getCondoMaintenances
    Given url readBaseUrl
    When path '/api/GetCondoMaintenances'
    And set getCondosMaintenacesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenances-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | ttl             |                                                0 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenances"                           |
      | getType         | "Array"                                          |
    And set getCondosMaintenacesCommandBodyRequest
      | path  |      0 |
      | phase | "Test" |
    And set getCondosMaintenacesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCondosMaintenacesPayload
      | path                | [0]                                       |
      | header              | getCondosMaintenacesCommandHeader[0]      |
      | body.request        | getCondosMaintenacesCommandBodyRequest[0] |
      | body.paginationSort | getCondosMaintenacesCommandPagination[0]  |
    And print getCondosMaintenacesPayload
    And request getCondosMaintenacesPayload
    When method POST
    Then status 200
    And def getCondosMaintenacesResponse = response
    And print getCondosMaintenacesResponse
    And match each getCondosMaintenacesResponse.results[*].phase contains "Test"
    And def getCondosMaintenacesResponseCount = karate.sizeOf(getCondosMaintenacesResponse.results)
    And print getCondosMaintenacesResponseCount
    And match getCondosMaintenacesResponseCount == getCondosMaintenacesResponse.totalRecordCount
    #GetCountyCondo
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "GetCondoMaintenance"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |                                   0 |
      | id   | addCondoMaintenanceResponse.body.id |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,addCondoMaintenanceResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyCondoMaintenanceResponse.id
    And match getCountyCondoMaintenanceResponse.areaCode.code == updateCondoMaintenanceResponse.body.areaCode.code
    # History Validation
    And def eventName = "CondoMaintenanceUpdated"
    And def evnentType = "CondoMaintenances"
    And def entityIdData = getCountyCondoMaintenanceResponse.id
    And def commandUserid = commandUserId
    And def parentEntityId = null
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
    And def entityName = "CondoMaintenance"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCondoMaintenanceResponse.body.id
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
    And def evnentType = "CondoMaintenance"
    And def entityIdData = addCondoMaintenanceResponse.body.id
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

  @CreateCondoMaintenanceWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Condo Maintenance with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCondoMaintenance'
    #Create Area Maintenance
    And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = result.response
    And print createAreaMaintenanceResponse
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createCondoMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCondoMaintenance-v1.001.json" |
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
      | commandType     | "CreateCondoMaintenance"                        |
      | entityName      | "CondoMaintenance"                              |
      | ttl             |                                               0 |
    And set createCondoMaintenanceCommandBody
      | path        |                       0 |
      | id          | faker.getUserId()       |
      | code        | faker.getUserId()       |
      | description | faker.getRandomNumber() |
    And set createCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | createAreaMaintenanceResponse.body.id          |
      | code | createAreaMaintenanceResponse.body.areaCode    |
      | name | createAreaMaintenanceResponse.body.description |
    And set createCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | createCondoMaintenanceCommandHeader[0]   |
      | body          | createCondoMaintenanceCommandBody[0]     |
      | body.areaCode | createCondoMaintenanceCommandAreaCode[0] |
    And print createCondoMaintenancePayload
    And request createCondoMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCondoMaintenanceWithMissingMandatoryField
  Scenario Outline: Create a Condo Maintenance with missing mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCondoMaintenance'
    #Create Area Maintenance
    And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = result.response
    And print createAreaMaintenanceResponse
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set createCondoMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCondoMaintenance-v1.001.json" |
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
      | commandType     | "CreateCondoMaintenance"                        |
      | entityName      | "CondoMaintenance"                              |
      | ttl             |                                               0 |
    And set createCondoMaintenanceCommandBody
      | path |                 0 |
      | id   | entityIdData      |
      | code | faker.getUserId() |
    And set createCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | createAreaMaintenanceResponse.body.id          |
      | code | createAreaMaintenanceResponse.body.areaCode    |
      | name | createAreaMaintenanceResponse.body.description |
    And set createCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | createCondoMaintenanceCommandHeader[0]   |
      | body          | createCondoMaintenanceCommandBody[0]     |
      | body.areaCode | createCondoMaintenanceCommandAreaCode[0] |
    And print createCondoMaintenancePayload
    And request createCondoMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCondoMaintenanceWithDuplicateCondoCode
  Scenario Outline: Create a Condo Maintenance with duplicate area code and Validate
    Given url commandBaseUrl
    And path '/api/CreateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def createCondoResponse = result.response
    And print createCondoResponse
    And def condoEntityId = createCondoResponse.body.id
    #get Condo Response
    And def result1 = call read('classpath:com/api/rm/documentAdmin/condoMaintenance/CreateCondoMaintenance.feature@getCondoMaintenance'){condoEntityId:'#(condoEntityId)'}
    And def getCondoResponse = result1.response
    And print getCondoResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCondoMaintenanceCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCondoMaintenance-v1.001.json" |
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
      | commandType     | "CreateCondoMaintenance"                        |
      | entityName      | "CondoMaintenance"                              |
      | ttl             |                                               0 |
    And set createCondoMaintenanceCommandBody
      | path        |                       0 |
      | id          | entityIdData            |
      | code        | getCondoResponse.code   |
      | description | faker.getRandomNumber() |
    And set createCondoMaintenanceCommandAreaCode
      | path |                                      0 |
      | id   | createCondoResponse.body.areaCode.id   |
      | code | createCondoResponse.body.areaCode.code |
      | name | createCondoResponse.body.areaCode.name |
    And set createCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | createCondoMaintenanceCommandHeader[0]   |
      | body          | createCondoMaintenanceCommandBody[0]     |
      | body.areaCode | createCondoMaintenanceCommandAreaCode[0] |
    And print createCondoMaintenancePayload
    And print createCondoMaintenancePayload
    And request createCondoMaintenancePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CondoMaintenance cannot be created.'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCondoMaintenaceWithInvaliDataToMandatoryFields
  Scenario Outline: Update a county Condo information with invalid data to mandatory fields
    #Create Condo Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    And set updateCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCondoMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | entityId        | addCondoMaintenanceResponse.header.entityId      |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateCondoMaintenance"                         |
      | entityName      | "CondoMaintenance"                               |
      | ttl             |                                                0 |
    And set updateCondoMaintenanceCommandBody
      | path        |                       0 |
      | id          | faker.getUserId()       |
      | code        | faker.getUserId()       |
      | description | faker.getRandomNumber() |
    And set updateCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | addCondoMaintenanceResponse.body.areaCode.id   |
      | code | addCondoMaintenanceResponse.body.areaCode.code |
      | name | addCondoMaintenanceResponse.body.areaCode.name |
    And set updateCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | updateCondoMaintenanceCommandHeader[0]   |
      | body          | updateCondoMaintenanceCommandBody[0]     |
      | body.areaCode | updateCondoMaintenanceCommandAreaCode[0] |
    And print updateCondoMaintenancePayload
    And request updateCondoMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCondoMaintenaceWithMissingMandatoryFields
  Scenario Outline: Update a county Condo information with missing mandatory fields
    #Create CountyCondo Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    And set updateCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCondoMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | entityId        | addCondoMaintenanceResponse.header.entityId      |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateCondoMaintenance"                         |
      | entityName      | "CondoMaintenance"                               |
      | ttl             |                                                0 |
    And set updateCondoMaintenanceCommandBody
      | path        |                                           0 |
      | id          | addCondoMaintenanceResponse.header.entityId |
      | code        | faker.getUserId()                           |
      | description | faker.getRandomNumber()                     |
    And set updateCondoMaintenancePayload
      | path   | [0]                                    |
      | header | updateCondoMaintenanceCommandHeader[0] |
      | body   | updateCondoMaintenanceCommandBody[0]   |
    And print updateCondoMaintenancePayload
    And request updateCondoMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCondoMaintenaceWithDuplicateCondoCode
  Scenario Outline: Update a county Condo information with duplicate areacode
    #Create CountyCondo Maintenance and Update
    Given url commandBaseUrl
    And path '/api/UpdateCondoMaintenance'
    And def result = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse = result.response
    And print addCondoMaintenanceResponse
    #Creating another Condo Maintenance code
    And def result1 = call read('CreateCondoMaintenance.feature@CreateCondoMaintenanceWithMandatoryFields')
    And def addCondoMaintenanceResponse1 = result1.response
    And print addCondoMaintenanceResponse1
    And set updateCondoMaintenanceCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCondoMaintenance-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCondoMaintenanceResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCondoMaintenanceResponse.header.id            |
      | correlationId   | addCondoMaintenanceResponse.header.correlationId |
      | entityId        | addCondoMaintenanceResponse.header.entityId      |
      | commandUserId   | addCondoMaintenanceResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateCondoMaintenance"                         |
      | entityName      | "CondoMaintenance"                               |
      | ttl             |                                                0 |
    And set updateCondoMaintenanceCommandBody
      | path        |                                           0 |
      | id          | addCondoMaintenanceResponse.header.entityId |
      | code        | addCondoMaintenanceResponse1.body.code      |
      | description | faker.getRandomNumber()                     |
    And set updateCondoMaintenanceCommandAreaCode
      | path |                                              0 |
      | id   | addCondoMaintenanceResponse.body.areaCode.id   |
      | code | addCondoMaintenanceResponse.body.areaCode.code |
      | name | addCondoMaintenanceResponse.body.areaCode.name |
    And set updateCondoMaintenancePayload
      | path          | [0]                                      |
      | header        | updateCondoMaintenanceCommandHeader[0]   |
      | body          | updateCondoMaintenanceCommandBody[0]     |
      | body.areaCode | updateCondoMaintenanceCommandAreaCode[0] |
    And set updateCondoMaintenancePayload
      | path   | [0]                                    |
      | header | updateCondoMaintenanceCommandHeader[0] |
      | body   | updateCondoMaintenanceCommandBody[0]   |
    And print updateCondoMaintenancePayload
    And request updateCondoMaintenancePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
