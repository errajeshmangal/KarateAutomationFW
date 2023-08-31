@FeeGroupFeature
Feature: FeeGroup-Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeGroupCollectionName = 'CreateFeeGroup_'
    And def createFeeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateFeeGroup','UpdateFeeGroup','GetFeeGroup','GetFeeGroups']
    And def entityName = ['FeeGroup','FeeCodeGroup']
    And def restricted = [true,false]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateAndGetFeeGroupwithAllDetailsestricted
  Scenario Outline: Create a Fee Group with restricted true and Get the details
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCommandBody
      | path |                              0 |
      | id   | createFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == createFeeGroupResponse.body.id
    And match getFeeGroupResponse.feeGroupCode == createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == createFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == createFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.isActive == createFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFeeGroupsCommandBodyRequest
      | path         |      0 |
      | feeGroupCode |        |
      | description  | "Test" |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains createFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupsResponse.results[*].description contains createFeeGroupResponse.body.description
    And match each  getFeeGroupsResponse.results[*].description contains "Test"
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupCreated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetFeeGroupwithMissingMandatoryFields-Restrictedtrue
  Scenario Outline: Create a Fee Group with restricted true and Missing mandatory fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set createRestrictedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createRestrictedFeeGroupCommandBody
      | path         |                             0 |
      | id           | entityIDData                  |
      | feeGroupCode | faker.getFirstName()          |
      | restricted   | restricted[0]                 |
      | isActive     | faker.getRandomBooleanValue() |
    And set createRestrictedFeeGroupCommandPayload
      | path   | [0]                                      |
      | header | createRestrictedFeeGroupCommandHeader[0] |
      | body   | createRestrictedFeeGroupCommandBody[0]   |
    And print createRestrictedFeeGroupCommandPayload
    And request createRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetFeeGroupwithAllDetailsNonRestricted
  Scenario Outline: Create a Fee Group with all the fields and Get the details
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCommandBody
      | path |                              0 |
      | id   | createFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == createFeeGroupResponse.body.id
    And match getFeeGroupResponse.includeInOverridedropdown == createFeeGroupResponse.body.includeInOverridedropdown
    And match getFeeGroupResponse.feeGroupCode == createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == createFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == createFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.departmentId.id == createFeeGroupResponse.body.departmentId.id
    And match getFeeGroupResponse.areaId.id == createFeeGroupResponse.body.areaId.id
    And match getFeeGroupResponse.inheritFeeGroup.id == createFeeGroupResponse.body.inheritFeeGroup.id
    And match getFeeGroupResponse.shouldBeFeeGroup.id == createFeeGroupResponse.body.shouldBeFeeGroup.id
    And match getFeeGroupResponse.isActive == createFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFeeGroupsCommandBodyRequest
      | path         |      0 |
      | feeGroupCode | "Test" |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains createFeeGroupResponse.body.id
    And match each getFeeGroupsResponse.results[*].feeGroupCode contains "Test"
    And match getFeeGroupsResponse.results[*].description contains createFeeGroupResponse.body.description
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupCreated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetFeeGroupwithMandatoryDetailsNonRestricted
  Scenario Outline: Create a Fee Group with mandatory fields and Get the details
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithMandateDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCommandBody
      | path |                              0 |
      | id   | createFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == createFeeGroupResponse.body.id
    And match getFeeGroupResponse.feeGroupCode == createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == createFeeGroupResponse.body.description
    And match getFeeGroupResponse.departmentId.id == createFeeGroupResponse.body.departmentId.id
    And match getFeeGroupResponse.areaId.id == createFeeGroupResponse.body.areaId.id
    And match getFeeGroupResponse.isActive == createFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFeeGroupsCommandBodyRequest
      | path            | 0 |
      | feeGroupCode    |   |
      | description     |   |
      | isActive        |   |
      | lastModDateTime |   |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                              |
      | header              | getFeeGroupsCommandHeader[0]     |
      | body.request        | {}                               |
      | body.paginationSort | getFeeGroupsCommandPagination[0] |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains createFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupsResponse.results[*].description contains createFeeGroupResponse.body.description
    And match   getFeeGroupsResponse.results[*].isActive contains createFeeGroupResponse.body.isActive
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupCreated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateNonRestrictedFeeGroupWithMissingMandatoryDetails
  Scenario Outline: Create non restricted fee group with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@CountyAreaWithRunTimeDepatmentArea'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path                      |                             0 |
      | id                        | entityIDData                  |
      | feeGroupCode              | faker.getFirstName()          |
      | description               | faker.getFirstName()          |
      | restricted                | restricted[1]                 |
      | includeInOverridedropdown | faker.getRandomBooleanValue() |
      | isActive                  | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set areaCommandBody
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set inheritFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set shouldBeFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                                         |
      | header                | createNonRestrictedFeeGroupCommandHeader[0] |
      | body                  | createNonRestrictedFeeGroupCommandBody[0]   |
      #| body.department       | departmentCommandBody[0]                    |
      | body.areaId           | areaCommandBody[0]                          |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]               |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0]              |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateNonRestrictedFeeGroupWithInvalidDataToMandateDetails
  Scenario Outline: Create non restricted fee group with invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@CountyAreaWithRunTimeDepatmentArea'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path         |                    0 |
      | id           | faker.getFirstName() |
      | feeGroupCode | faker.getFirstName() |
      | description  | faker.getFirstName() |
    And set departmentCommandBody
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set areaCommandBody
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
      | body.areaId       | areaCommandBody[0]                          |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateNonRestrictedFeeGroupWithAllDetails
  Scenario Outline: Create duplicate non restricted fee group with all the fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path                      |                                        0 |
      | id                        | entityIDData                             |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode |
      | description               | faker.getFirstName()                     |
      | restricted                | restricted[1]                            |
      | includeInOverridedropdown | faker.getRandomBooleanValue()            |
      | isActive                  | faker.getRandomBooleanValue()            |
    And set departmentCommandBody
      | path |                                             0 |
      | id   | createFeeGroupResponse.body.departmentId.id   |
      | name | createFeeGroupResponse.body.departmentId.name |
      | code | createFeeGroupResponse.body.departmentId.code |
    And set areaCommandBody
      | path |                                       0 |
      | id   | createFeeGroupResponse.body.areaId.id   |
      | name | createFeeGroupResponse.body.areaId.name |
      | code | createFeeGroupResponse.body.areaId.code |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
      | body.areaId       | areaCommandBody[0]                          |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:FeeGroup cannot be created.'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateRestrictedFeeGroupWithAllDetails
  Scenario Outline: Create duplicate restricted fee group with all the fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path                      |                                        0 |
      | id                        | entityIDData                             |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode |
      | description               | faker.getFirstName()                     |
      | restricted                | restricted[0]                            |
      | includeInOverridedropdown | faker.getRandomBooleanValue()            |
      | isActive                  | faker.getRandomBooleanValue()            |
    And set createNonRestrictedFeeGroupCommandPayload
      | path   | [0]                                         |
      | header | createNonRestrictedFeeGroupCommandHeader[0] |
      | body   | createNonRestrictedFeeGroupCommandBody[0]   |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:FeeGroup cannot be created.'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetFeeGroupwithAllDetailsNonRestricted
  Scenario Outline: Update a Fee Group with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #calling the NonRestrictedFeeGroupWithMandateFieldScenarios
    And def nonRestrictedFeeGroupResultResponse = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithMandateDetails')
    And def nonRestrictedFeeGroupResponse = nonRestrictedFeeGroupResultResponse.response
    And print nonRestrictedFeeGroupResponse
    And def areaCodeId = nonRestrictedFeeGroupResponse.body.areaId.id
    And def areaCode = nonRestrictedFeeGroupResponse.body.areaId.code
    And def areaCodeName = nonRestrictedFeeGroupResponse.body.areaId.name
    And def isActiveFlag = nonRestrictedFeeGroupResponse.body.isActive
    #Calling inheritedFeeGroupAPi
    And def inheritedFeeGroupresult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveInheritedFeeGroups'){areaCodeId : '#(areaCodeId)'}{isActiveFlag : '#(isActiveFlag)'}{areaCodeName : '#(areaCodeName)'}}
    And def inheritedFeeGroupResponse = inheritedFeeGroupresult.response
    And print inheritedFeeGroupResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path                      |                                        0 |
      | id                        | createFeeGroupResponse.body.id           |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode |
      | description               | faker.getFirstName()                     |
      | restricted                | restricted[1]                            |
      | includeInOverridedropdown | faker.getRandomBoolean()                 |
      | isActive                  | faker.getRandomBoolean()                 |
    And set departmentCommandBody
      | path |                                                    0 |
      | id   | nonRestrictedFeeGroupResponse.body.departmentId.id   |
      | name | nonRestrictedFeeGroupResponse.body.departmentId.name |
      | code | nonRestrictedFeeGroupResponse.body.departmentId.code |
    And set areaCommandBody
      | path |            0 |
      | id   | areaCodeId   |
      | name | areaCode     |
      | code | areaCodeName |
    And set inheritFeeGroupCommandBody
      | path |                                         0 |
      | id   | inheritedFeeGroupResponse.results[0].id   |
      | name | inheritedFeeGroupResponse.results[0].name |
      | code | inheritedFeeGroupResponse.results[0].code |
    And set shouldBeFeeGroupCommandBody
      | path |                                                 0 |
      | id   | createFeeGroupResponse.body.shouldBeFeeGroup.id   |
      | name | createFeeGroupResponse.body.shouldBeFeeGroup.name |
      | code | createFeeGroupResponse.body.shouldBeFeeGroup.code |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                            |
      | header                | updateFeeGroupCommandHeader[0] |
      | body                  | updateFeeGroupCommandBody[0]   |
      | body.departmentId     | departmentCommandBody[0]       |
      | body.areaId           | areaCommandBody[0]             |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]  |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0] |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def updateNonRestrictedFeeGroupResponse = response
    And print updateNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match updateNonRestrictedFeeGroupCommandPayload.body.id == updateNonRestrictedFeeGroupResponse.body.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match updateNonRestrictedFeeGroupCommandPayload.body.description == updateNonRestrictedFeeGroupResponse.body.description
    And match updateNonRestrictedFeeGroupCommandPayload.body.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match updateNonRestrictedFeeGroupCommandPayload.body.departmentId.id == updateNonRestrictedFeeGroupResponse.body.departmentId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.areaId.id == updateNonRestrictedFeeGroupResponse.body.areaId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.inheritFeeGroup.id == updateNonRestrictedFeeGroupResponse.body.inheritFeeGroup.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.includeInOverridedropdown == updateNonRestrictedFeeGroupResponse.body.includeInOverridedropdown
    And match updateNonRestrictedFeeGroupCommandPayload.body.shouldBeFeeGroup == updateNonRestrictedFeeGroupResponse.body.shouldBeFeeGroup
    And match updateNonRestrictedFeeGroupCommandPayload.body.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,updateNonRestrictedFeeGroupCommandPayload.body.id)
    And print mongoResult
    And match mongoResult == updateNonRestrictedFeeGroupResponse.body.id
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | updateNonRestrictedFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupResponse.includeInOverridedropdown == updateNonRestrictedFeeGroupResponse.body.includeInOverridedropdown
    And match getFeeGroupResponse.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == updateNonRestrictedFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.departmentId.id == updateNonRestrictedFeeGroupResponse.body.departmentId.id
    And match getFeeGroupResponse.areaId.id == updateNonRestrictedFeeGroupResponse.body.areaId.id
    And match getFeeGroupResponse.inheritFeeGroup.id == updateNonRestrictedFeeGroupResponse.body.inheritFeeGroup.id
    And match getFeeGroupResponse.shouldBeFeeGroup.id == updateNonRestrictedFeeGroupResponse.body.shouldBeFeeGroup.id
    And match getFeeGroupResponse.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | getType         | "Array"                                                  |
      | ttl             |                                                        0 |
    And set getFeeGroupsCommandBodyRequest
      | path            |      0 |
      | feeGroupCode    |        |
      | description     | "Test" |
      | isActive        |        |
      | lastModDateTime |        |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match each getFeeGroupsResponse.results[*].description contains "Test"
    And match getFeeGroupsResponse.results[*].isActive contains updateNonRestrictedFeeGroupResponse.body.isActive
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupUpdated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetFeeGroupwithMandatoryDetailsNonRestricted
  Scenario Outline: Update a Fee Group with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path         |                                        0 |
      | id           | createFeeGroupResponse.body.id           |
      | feeGroupCode | createFeeGroupResponse.body.feeGroupCode |
      | description  | faker.getFirstName()                     |
      | restricted   | restricted[1]                            |
      | isActive     | faker.getRandomBoolean()                 |
    And set departmentCommandBody
      | path |                                             0 |
      | id   | createFeeGroupResponse.body.departmentId.id   |
      | name | createFeeGroupResponse.body.departmentId.name |
      | code | createFeeGroupResponse.body.departmentId.code |
    And set areaCommandBody
      | path |                                       0 |
      | id   | createFeeGroupResponse.body.areaId.id   |
      | name | createFeeGroupResponse.body.areaId.name |
      | code | createFeeGroupResponse.body.areaId.code |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path              | [0]                            |
      | header            | updateFeeGroupCommandHeader[0] |
      | body              | updateFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]       |
      | body.areaId       | areaCommandBody[0]             |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def updateNonRestrictedFeeGroupResponse = response
    And print updateNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match updateNonRestrictedFeeGroupCommandPayload.body.id == updateNonRestrictedFeeGroupResponse.body.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match updateNonRestrictedFeeGroupCommandPayload.body.description == updateNonRestrictedFeeGroupResponse.body.description
    And match updateNonRestrictedFeeGroupCommandPayload.body.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match updateNonRestrictedFeeGroupCommandPayload.body.departmentId.id == updateNonRestrictedFeeGroupResponse.body.departmentId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.areaId.id == updateNonRestrictedFeeGroupResponse.body.areaId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,updateNonRestrictedFeeGroupCommandPayload.body.id)
    And print mongoResult
    And match mongoResult == updateNonRestrictedFeeGroupResponse.body.id
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | updateNonRestrictedFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupResponse.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == updateNonRestrictedFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.departmentId.id == updateNonRestrictedFeeGroupResponse.body.departmentId.id
    And match getFeeGroupResponse.areaId.id == updateNonRestrictedFeeGroupResponse.body.areaId.id
    And match getFeeGroupResponse.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | getType         | "Array"                                                  |
      | ttl             |                                                        0 |
    And set getFeeGroupsCommandBodyRequest
      | path            |      0 |
      | feeGroupCode    |        |
      | description     | "Test" |
      | isActive        |        |
      | lastModDateTime |        |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match each getFeeGroupsResponse.results[*].description contains "Test"
    And match getFeeGroupsResponse.results[*].isActive contains updateNonRestrictedFeeGroupResponse.body.isActive
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupUpdated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetFeeGroupwithMissingMandatoryDetailsNonRestricted
  Scenario Outline: Update a Fee Group with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path                      |                                        0 |
      | id                        | createFeeGroupResponse.body.id           |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode |
      | description               | faker.getFirstName()                     |
      | restricted                | restricted[1]                            |
      | includeInOverridedropdown | faker.getRandomBoolean()                 |
      | isActive                  | faker.getRandomBoolean()                 |
    And set areaCommandBody
      | path |                                       0 |
      | id   | createFeeGroupResponse.body.areaId.id   |
      | name | createFeeGroupResponse.body.areaId.name |
      | code | createFeeGroupResponse.body.areaId.code |
    And set inheritFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set shouldBeFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                            |
      | header                | updateFeeGroupCommandHeader[0] |
      | body                  | updateFeeGroupCommandBody[0]   |
      # | body.department       | departmentCommandBody[0]       |
      | body.areaId           | areaCommandBody[0]             |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]  |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0] |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeGroupwithDuplicateIdNonRestricted
  Scenario Outline: Update a Fee Group with duplicate feeGroupCode
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse1 = result.response
    And print createFeeGroupResponse1
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    #calling getAreaBasedOnDepartmentApi
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetAreaBasedOnSelectedDepartmentForUpdateScenario')
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path                      |                                         0 |
      | id                        | createFeeGroupResponse.body.id            |
      | feeGroupCode              | createFeeGroupResponse1.body.feeGroupCode |
      | description               | faker.getFirstName()                      |
      | restricted                | restricted[1]                             |
      | includeInOverridedropdown | faker.getRandomBoolean()                  |
      | isActive                  | faker.getRandomBoolean()                  |
    And set departmentCommandBody
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[1].id   |
      | name | activeDepartmentResponse.results[1].name |
      | code | activeDepartmentResponse.results[1].code |
    And set areaCommandBody
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set inheritFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set shouldBeFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                            |
      | header                | updateFeeGroupCommandHeader[0] |
      | body                  | updateFeeGroupCommandBody[0]   |
      | body.departmentId     | departmentCommandBody[0]       |
      | body.areaId           | areaCommandBody[0]             |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]  |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0] |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetFeeGroupwithInvalidDetailsNonRestricted
  Scenario Outline: Update a Fee Group with invalid details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path                      |                                        0 |
      | id                        | "67812"                                  |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode |
      | description               | faker.getFirstName()                     |
      | restricted                | restricted[1]                            |
      | includeInOverridedropdown | faker.getRandomBoolean()                 |
      | isActive                  | faker.getRandomBoolean()                 |
    And set departmentCommandBody
      | path |                                             0 |
      | id   | createFeeGroupResponse.body.departmentId.id   |
      | name | createFeeGroupResponse.body.departmentId.name |
      | code | createFeeGroupResponse.body.departmentId.code |
    And set areaCommandBody
      | path |                                       0 |
      | id   | createFeeGroupResponse.body.areaId.id   |
      | name | createFeeGroupResponse.body.areaId.name |
      | code | createFeeGroupResponse.body.areaId.code |
    And set inheritFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set shouldBeFeeGroupCommandBody
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                            |
      | header                | updateFeeGroupCommandHeader[0] |
      | body                  | updateFeeGroupCommandBody[0]   |
      | body.departmentId     | departmentCommandBody[0]       |
      | body.areaId           | areaCommandBody[0]             |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]  |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0] |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetFeeGroupwithAllDetailsRestricted
  Scenario Outline: Update a Fee Group with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create Fee Group
    And def result = call read('CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #calling the NonRestrictedFeeGroupWithMandateFieldScenarios
    And def nonRestrictedFeeGroupResultResponse = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithMandateDetails')
    And def nonRestrictedFeeGroupResponse = nonRestrictedFeeGroupResultResponse.response
    And print nonRestrictedFeeGroupResponse
    And def areaCodeId = nonRestrictedFeeGroupResponse.body.areaId.id
    And def areaCode = nonRestrictedFeeGroupResponse.body.areaId.code
    And def areaCodeName = nonRestrictedFeeGroupResponse.body.areaId.name
    And def isActiveFlag = nonRestrictedFeeGroupResponse.body.isActive
    #Calling inheritedFeeGroupAPi
    And def inheritedFeeGroupresult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveInheritedFeeGroups'){areaCodeId : '#(areaCodeId)'}{isActiveFlag : '#(isActiveFlag)'}{areaCodeName : '#(areaCodeName)'}}
    And def inheritedFeeGroupResponse = inheritedFeeGroupresult.response
    And print inheritedFeeGroupResponse
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.header.entityId      |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path         |                                        0 |
      | id           | createFeeGroupResponse.body.id           |
      | feeGroupCode | createFeeGroupResponse.body.feeGroupCode |
      | description  | faker.getFirstName()                     |
      | restricted   | restricted[0]                            |
      | isActive     | faker.getRandomBoolean()                 |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path   | [0]                            |
      | header | updateFeeGroupCommandHeader[0] |
      | body   | updateFeeGroupCommandBody[0]   |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def updateNonRestrictedFeeGroupResponse = response
    And print updateNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match updateNonRestrictedFeeGroupCommandPayload.body.id == updateNonRestrictedFeeGroupResponse.body.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match updateNonRestrictedFeeGroupCommandPayload.body.description == updateNonRestrictedFeeGroupResponse.body.description
    And match updateNonRestrictedFeeGroupCommandPayload.body.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match updateNonRestrictedFeeGroupCommandPayload.body.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,updateNonRestrictedFeeGroupCommandPayload.body.id)
    And print mongoResult
    And match mongoResult == updateNonRestrictedFeeGroupResponse.body.id
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | updateNonRestrictedFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupResponse.includeInOverridedropdown == updateNonRestrictedFeeGroupResponse.body.includeInOverridedropdown
    And match getFeeGroupResponse.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == updateNonRestrictedFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | getType         | "Array"                                                  |
      | ttl             |                                                        0 |
    And set getFeeGroupsCommandBodyRequest
      | path            |      0 |
      | feeGroupCode    |        |
      | description     | "Test" |
      | isActive        |        |
      | lastModDateTime |        |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match each getFeeGroupsResponse.results[*].description contains "Test"
    And match getFeeGroupsResponse.results[*].isActive contains updateNonRestrictedFeeGroupResponse.body.isActive
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupUpdated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateInheritedFeeGroupRunTime
  Scenario Outline: Update non restricted fee group with all fields and validate
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a fee group with Inherited group
    And def result = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    #Create another fee group for same department area
    And def departmentId = createFeeGroupResponse.body.departmentId.id
    And def departmentCode = createFeeGroupResponse.body.departmentId.code
    And def departmentName = createFeeGroupResponse.body.departmentId.name
    And def areaId = createFeeGroupResponse.body.areaId.id
    And def areaCode = createFeeGroupResponse.body.areaId.code
    And def areaName = createFeeGroupResponse.body.areaId.name
    And def result1 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateFeeGroupWithAreaAndDepartmentRunTime'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}{areaId : '#(areaId)'}{areaCode : '#(areaCode)'}{areaName : '#(areaName)'}}
    And def createFeeGroupResponse1 = result1.response
    And print createFeeGroupResponse1
    #update the inherited Fee Group
    And set updateFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | createFeeGroupResponse.body.id              |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    And set updateFeeGroupCommandBody
      | path                      |                                                     0 |
      | id                        | createFeeGroupResponse.body.id                        |
      | feeGroupCode              | createFeeGroupResponse.body.feeGroupCode              |
      | description               | createFeeGroupResponse.body.description               |
      | restricted                | restricted[1]                                         |
      | includeInOverridedropdown | createFeeGroupResponse.body.includeInOverridedropdown |
      | isActive                  | createFeeGroupResponse.body.isActive                  |
    And set departmentCommandBody
      | path |              0 |
      | id   | departmentId   |
      | name | departmentName |
      | code | departmentCode |
    And set areaCommandBody
      | path |        0 |
      | id   | areaId   |
      | name | areaName |
      | code | areaCode |
    And set inheritFeeGroupCommandBody
      | path |                                         0 |
      | id   | createFeeGroupResponse1.body.id           |
      | name | createFeeGroupResponse1.body.description  |
      | code | createFeeGroupResponse1.body.feeGroupCode |
    And set shouldBeFeeGroupCommandBody
      | path |                                                 0 |
      | id   | createFeeGroupResponse.body.shouldBeFeeGroup.id   |
      | name | createFeeGroupResponse.body.shouldBeFeeGroup.name |
      | code | createFeeGroupResponse.body.shouldBeFeeGroup.code |
    And set updateNonRestrictedFeeGroupCommandPayload
      | path                  | [0]                            |
      | header                | updateFeeGroupCommandHeader[0] |
      | body                  | updateFeeGroupCommandBody[0]   |
      | body.departmentId     | departmentCommandBody[0]       |
      | body.areaId           | areaCommandBody[0]             |
      | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]  |
      | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0] |
    And print updateNonRestrictedFeeGroupCommandPayload
    And request updateNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def updateNonRestrictedFeeGroupResponse = response
    And print updateNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match updateNonRestrictedFeeGroupCommandPayload.body.id == updateNonRestrictedFeeGroupResponse.body.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match updateNonRestrictedFeeGroupCommandPayload.body.description == updateNonRestrictedFeeGroupResponse.body.description
    And match updateNonRestrictedFeeGroupCommandPayload.body.restricted == updateNonRestrictedFeeGroupResponse.body.restricted
    And match updateNonRestrictedFeeGroupCommandPayload.body.departmentId.id == updateNonRestrictedFeeGroupResponse.body.departmentId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.areaId.id == updateNonRestrictedFeeGroupResponse.body.areaId.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.inheritFeeGroup.id == updateNonRestrictedFeeGroupResponse.body.inheritFeeGroup.id
    And match updateNonRestrictedFeeGroupCommandPayload.body.includeInOverridedropdown == updateNonRestrictedFeeGroupResponse.body.includeInOverridedropdown
    And match updateNonRestrictedFeeGroupCommandPayload.body.shouldBeFeeGroup == updateNonRestrictedFeeGroupResponse.body.shouldBeFeeGroup
    And match updateNonRestrictedFeeGroupCommandPayload.body.isActive == updateNonRestrictedFeeGroupResponse.body.isActive
    #Get the Update Fee Group info
    #Get the Fee Group
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | updateNonRestrictedFeeGroupResponse.body.id |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupResponse.inheritFeeGroup.id == updateNonRestrictedFeeGroupResponse.body.inheritFeeGroup.id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id
    #Get the Fee Groups
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeGroupsCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateNonRestrictedFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateNonRestrictedFeeGroupResponse.header.id            |
      | correlationId   | updateNonRestrictedFeeGroupResponse.header.correlationId |
      | commandUserId   | updateNonRestrictedFeeGroupResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | getType         | "Array"                                                  |
      | ttl             |                                                        0 |
    And set getFeeGroupsCommandBodyRequest
      | path            |      0 |
      | feeGroupCode    |        |
      | description     | "Test" |
      | isActive        |        |
      | lastModDateTime |        |
    And set getFeeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeGroupsPayload
      | path                | [0]                               |
      | header              | getFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsPayload
    And request getFeeGroupsPayload
    When method POST
    Then status 200
    And def getFeeGroupsResponse = response
    And print getFeeGroupsResponse
    And match getFeeGroupsResponse.results[*].id contains updateNonRestrictedFeeGroupResponse.body.id
    And match getFeeGroupsResponse.results[*].feeGroupCode contains updateNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match each getFeeGroupsResponse.results[*].description contains "Test"
    And match getFeeGroupsResponse.results[*].isActive contains updateNonRestrictedFeeGroupResponse.body.isActive
    And def getFeeGroupsResponseCount = karate.sizeOf(getFeeGroupsResponse.results)
    And print getFeeGroupsResponseCount
    And match getFeeGroupsResponseCount == getFeeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeGroupResponse.id
    And def parentEntityId = null
    And def eventName = "FeeGroupUpdated"
    And def evnentType = "FeeGroup"
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
    And def entityName = "FeeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeGroupResponse.body.id
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
    And def evnentType = "FeeGroup"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |
