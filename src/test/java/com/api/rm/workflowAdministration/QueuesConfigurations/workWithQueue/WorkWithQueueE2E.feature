# This feature file created for E2E scenarios
@E2EWWQ
Feature: Create Work With Queue - E2E

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def workWithQueueCollectionName = 'CreateWorkWithQueueConfiguration_'
    And def workWithQueueCollectionNameRead = 'WorkWithQueueConfigurationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def queueType = 'WorkWith'
    And def workFlowType = ['Cashiering','Indexing']
    And def commandTypeList = ['Create','Update']
    And def targetTypeList = ['Topic','Url']
    And def getWorkWith = ['GetWorkWithQueueConfiguration','GetQueueConfigurations']
    And def commandTypes = ['UpdateWorkWithQueueConfiguration','CreateWorkWithQueueConfiguration']
    And def eventTypes = ['WorkWithQueueConfiguration']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def actions = ['Reject','Accept','Save']

  @CreateWorkWithQueueWithGetCashiering
  Scenario Outline: Create a WorkWith queue with all the fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    #Call the create workWith queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueCashiering')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Get workWith Queue
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | workWithQueueResultResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == workWithQueueResultResponse.body.commandToProcess[0].targetTopic.name
    And match getWorkWithQueueResponse.workflowType == workWithQueueResultResponse.body.workflowType
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path |         0 |
      | type | queueType |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].type contains queueType
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And print dbnameGet+historyCollectionNameRead
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithMandatoryfieldsGetCashiering
  Scenario Outline: Create a WorkWith queue with mandatory fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    #Call the create workWith queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueCasheringMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Get the workWith queue
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | workWithQueueResultResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.code == workWithQueueResultResponse.body.commandToProcess[0].targetTopic.code
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].queueName contains 'Test'
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithGetIndexing
  Scenario Outline: Create a WorkWith queue with all the fields and Get the details - Indexing
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    #Call the create workWith queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexing')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Get workWith Queue
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | workWithQueueResultResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == workWithQueueResultResponse.body.commandToProcess[0].targetTopic.name
    And match getWorkWithQueueResponse.workflowType == workWithQueueResultResponse.body.workflowType
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path |         0 |
      | type | queueType |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].type contains queueType
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithMandatoryfieldsGet-Indexing
  Scenario Outline: Create a WorkWith queue with mandatory fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    #Call the create workWith queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Get the workWith queue
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | workWithQueueResultResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == workWithQueueResultResponse.body.commandToProcess[0].targetTopic.name
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | workWithQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | workWithQueueResultResponse.header.id            |
      | correlationId   | workWithQueueResultResponse.header.correlationId |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].queueName contains 'Test'
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithMissingMandatoryFields-Cashiering
  Scenario Outline: Create a  queue with Missing Mandatory fields - Cashiering (Command Name is missing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueueCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path        |                    1 |
      | id          | dataGenerator.Id()   |
      | sequence    |                    1 |
      | commandType | commandTypeList[1]   |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType  | targetTypeList[1]    |
      | targetUrl   | faker.getFirstName() |
    And set createWorkWithQueueCommandBody
      | path                    |                                   0 |
      | id                      | entityIdData                        |
      | type                    | queueType                           |
      | queueCode               | faker.getUserId()                   |
      | queueName               | faker.getFirstName()                |
      | workflowType            | workFlowType[0]                     |
      | body.genericLayout.id   | dataGenerator.Id()                  |
      | body.genericLayout.code | faker.getUserId()                   |
      | body.genericLayout.name | faker.getFirstName()                |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess        | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithMissingMandatoryFields-Indexing
  Scenario Outline: Create a WorkWith queue with Missing Mandatory fields - Indexing (Generic Layout is missing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueueCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path        |                    1 |
      | id          | dataGenerator.Id()   |
      | sequence    |                    1 |
      | commandName | faker.getFirstName() |
      | commandType | commandTypeList[1]   |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType  | targetTypeList[1]    |
      | targetUrl   | faker.getUserId()    |
    And set createWorkWithQueueCommandBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | type             | queueType                           |
      | queueCode        | faker.getUserId()                   |
      | queueName        | faker.getFirstName()                |
      | workflowType     | workFlowType[1]                     |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithInvalidDataToMandatoryFieldsCashiering
  Scenario Outline: Create a WorkWith queue with Invalid Data To Mandatory fields - Cashiering (Passing String to Seq number field)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueueCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path        |                    1 |
      | id          | dataGenerator.Id()   |
      | sequence    | faker.getUserId()    |
      | commandName | faker.getFirstName() |
      | commandType | commandTypeList[1]   |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType  | targetTypeList[1]    |
      | targetUrl   | faker.getUserId()    |
    And set createWorkWithQueueCommandBody
      | path                    |                                   0 |
      | id                      | entityIdData                        |
      | type                    | queueType                           |
      | queueCode               | faker.getUserId()                   |
      | queueName               | faker.getFirstName()                |
      | workflowType            | workFlowType[0]                     |
      | body.genericLayout.id   | dataGenerator.Id()                  |
      | body.genericLayout.code | faker.getUserId()                   |
      | body.genericLayout.name | faker.getFirstName()                |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess        | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueWithInvalidDataToMandatoryFieldsIndexing
  Scenario Outline: Create a WorkWith queue with Invalid Data To Mandatory fields - Indexing (Passing String to Seq number field)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueueCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         | faker.getUserId()                          |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path                    |                                   0 |
      | id                      | entityIdData                        |
      | type                    | queueType                           |
      | queueCode               | faker.getUserId()                   |
      | queueName               | faker.getFirstName()                |
      | workflowType            | workFlowType[1]                     |
      | body.genericLayout.id   | dataGenerator.Id()                  |
      | body.genericLayout.code | faker.getUserId()                   |
      | body.genericLayout.name | faker.getFirstName()                |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess        | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithAllDetailsAndGetCashiering
  Scenario Outline: Update a WorkWith queue with all the fields and Get the Details (Cashiering)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueCashiering')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path        |                                                             0 |
      | id          | workWithQueueResultResponse.body.commandToProcess[1].id       |
      | sequence    | workWithQueueResultResponse.body.commandToProcess[1].sequence |
      | commandName | faker.getFirstName()                                          |
      | actions[0]  | actions[1]                                                    |
      | commandType | commandTypeList[0]                                            |
      | description | faker.getFirstName()                                          |
      | isActive    | true                                                          |
      | targetType  | targetTypeList[1]                                             |
      | targetUrl   | faker.getFirstName()                                          |
    And set updateWorkWithQueueCommandBody
      | path               |                                                   0 |
      | id                 | workWithQueueResultResponse.body.id                 |
      | type               | queueType                                           |
      | queueCode          | workWithQueueResultResponse.body.queueCode          |
      | queueName          | workWithQueueResultResponse.body.queueName          |
      | description        | faker.getLastName()                                 |
      | isActive           | workWithQueueResultResponse.body.isActive           |
      | workflowType       | workFlowType[0]                                     |
      | forms.id           | id                                                  |
      | forms.code         | code                                                |
      | forms.name         | name                                                |
      | genericLayout.id   | workWithQueueResultResponse.body.genericLayout.id   |
      | genericLayout.code | workWithQueueResultResponse.body.genericLayout.code |
      | genericLayout.name | workWithQueueResultResponse.body.genericLayout.name |
      | commandToProcess   | updateWorkWithQueueCommandToProcess                 |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 201
    And def updateWorkWithQueueResponse = response
    And print updateWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,updateWorkWithQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateWorkWithQueueResponse.body.id
    And match updateWorkWithQueueResponse.body.queueName == updateWorkWithQueuePayload.body.queueName
    And match updateWorkWithQueueResponse.body.commandToProcess[0].commandType == 0
    And match updateWorkWithQueueResponse.body.description == updateWorkWithQueuePayload.body.description
    #Get the updated workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | updateWorkWithQueueResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetUrl == updateWorkWithQueueResponse.body.commandToProcess[0].targetUrl
    And match getWorkWithQueueResponse.type == updateWorkWithQueueResponse.body.type
    And match getWorkWithQueueResponse.commandToProcess[0].commandName == updateWorkWithQueueResponse.body.commandToProcess[0].commandName
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path        |      0 |
      | description | "Test" |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].description contains "Test"
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithMandatoryDetailsAndGetCashiering
  Scenario Outline: Update a WorkWith queue with Mandatory fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueCasheringMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                             0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                          |
      | commandType      | commandTypeList[0]                                            |
      | actions[0]       | actions[1]                                                    |
      | targetType       | targetTypeList[0]                                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                      |
      | targetTopic.code | targetTopicsResultResponse.results[0].code                    |
      | targetTopic.name | targetTopicsResultResponse.results[0].name                    |
    And set updateWorkWithQueueCommandToProcess
      | path        |                    1 |
      | id          | dataGenerator.Id()   |
      | sequence    |                    1 |
        | actions[0]       | actions[1]                                                    |
      | commandName | faker.getFirstName() |
      | commandType | commandTypeList[1]   |
      || targetType       | targetTypeList[0]                                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                      |
      | targetTopic.code | targetTopicsResultResponse.results[0].code                    |
      | targetTopic.name | targetTopicsResultResponse.results[0].name                    |
    And set updateWorkWithQueueCommandBody
      | path               |                                          0 |
      | id                 | workWithQueueResultResponse.body.id        |
      | type               | queueType                                  |
      | queueCode          | workWithQueueResultResponse.body.queueCode |
      | queueName          | workWithQueueResultResponse.body.queueName |
      | workflowType       | workFlowType[0]                            |
      | genericLayout.id   | dataGenerator.Id()                         |
      | genericLayout.code | faker.getUserId()                          |
      | genericLayout.name | faker.getFirstName()                       |
      | forms.id           | id                                         |
      | forms.code         | code                                       |
      | forms.name         | name                                       |
      | isActive           | workWithQueueResultResponse.body.isActive  |
      | commandToProcess   | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 201
    And def updateWorkWithQueueResponse = response
    And print updateWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,updateWorkWithQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateWorkWithQueueResponse.body.id
    And match updateWorkWithQueueResponse.body.queueName == updateWorkWithQueuePayload.body.queueName
    And match updateWorkWithQueueResponse.body.commandToProcess[0].commandType == 0
    And match updateWorkWithQueueResponse.body.commandToProcess[1].commandName == updateWorkWithQueuePayload.body.commandToProcess[1].commandName
    #Get the updated workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | updateWorkWithQueueResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == updateWorkWithQueueResponse.body.commandToProcess[0].targetTopic.name
    And match getWorkWithQueueResponse.type == updateWorkWithQueueResponse.body.type
    And match getWorkWithQueueResponse.commandToProcess[0].commandName == updateWorkWithQueueResponse.body.commandToProcess[0].commandName
    And match getWorkWithQueueResponse.genericLayout.name == updateWorkWithQueueResponse.body.genericLayout.name
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path |         0 |
      | type | queueType |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].type contains queueType
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithAllDetailsAndGetIndexing
  Scenario Outline: Update a WorkWith queue with all the fields and Get the Details (Cashiering)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexing')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
     #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
       | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                                     0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[1].id               |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[1].sequence         |
      | commandName      | faker.getFirstName()                                                  |
      | commandType      | commandTypeList[0]                                                    |
       | actions[0]       | actions[1]                                 |
      | description      | faker.getFirstName()                                                  |
      | isActive         | true                                                                  |
      | targetType       | targetTypeList[0]                                                     |
      | targetTopic.id   | workWithQueueResultResponse.body.commandToProcess[0].targetTopic.id   |
      | targetTopic.code | workWithQueueResultResponse.body.commandToProcess[0].targetTopic.code |
      | targetTopic.name | workWithQueueResultResponse.body.commandToProcess[0].targetTopic.name |
    And set updateWorkWithQueueCommandBody
      | path               |                                                   0 |
      | id                 | workWithQueueResultResponse.body.id                 |
      | type               | queueType                                           |
      | queueCode          | workWithQueueResultResponse.body.queueCode          |
      | queueName          | workWithQueueResultResponse.body.queueName          |
      | description        | faker.getLastName()                                 |
      | isActive           | workWithQueueResultResponse.body.isActive           |
      | workflowType       | workWithQueueResultResponse.body.workflowType       |
      | genericLayout.id   | workWithQueueResultResponse.body.genericLayout.id   |
      | genericLayout.code | workWithQueueResultResponse.body.genericLayout.code |
      | genericLayout.name | workWithQueueResultResponse.body.genericLayout.name |
         | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | commandToProcess   | updateWorkWithQueueCommandToProcess                 |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 201
    And def updateWorkWithQueueResponse = response
    And print updateWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,updateWorkWithQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateWorkWithQueueResponse.body.id
    And match updateWorkWithQueueResponse.body.queueName == updateWorkWithQueuePayload.body.queueName
    And match updateWorkWithQueueResponse.body.commandToProcess[0].commandType == 0
    And match updateWorkWithQueueResponse.body.description == updateWorkWithQueuePayload.body.description
    #Get the updated workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | updateWorkWithQueueResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == updateWorkWithQueueResponse.body.commandToProcess[0].targetTopic.name
    And match getWorkWithQueueResponse.type == updateWorkWithQueueResponse.body.type
    And match getWorkWithQueueResponse.commandToProcess[0].commandName == updateWorkWithQueueResponse.body.commandToProcess[0].commandName
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].queueName contains "Test"
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithMandatoryDetailsAndGet-Indexing
  Scenario Outline: Update a WorkWith queue with Mandatory fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
       | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                             0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                          |
      | commandType      | commandTypeList[1]                                            |
       | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[0]                                             |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                      |
      | targetTopic.code | targetTopicsResultResponse.results[0].code                    |
      | targetTopic.name | targetTopicsResultResponse.results[0].name                    |
      
    And set updateWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
       | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set updateWorkWithQueueCommandBody
      | path               |                                          0 |
      | id                 | workWithQueueResultResponse.body.id        |
      | type               | queueType                                  |
      | queueCode          | workWithQueueResultResponse.body.queueCode |
      | queueName          | workWithQueueResultResponse.body.queueName |
      | workflowType       | workFlowType[1]                            |
          | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | genericLayout.id   | dataGenerator.Id()                         |
      | genericLayout.code | faker.getUserId()                          |
      | genericLayout.name | faker.getFirstName()                       |
      | isActive           | workWithQueueResultResponse.body.isActive  |
      | commandToProcess   | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 201
    And def updateWorkWithQueueResponse = response
    And print updateWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,updateWorkWithQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateWorkWithQueueResponse.body.id
    And match updateWorkWithQueueResponse.body.queueName == updateWorkWithQueuePayload.body.queueName
    And match updateWorkWithQueueResponse.body.commandToProcess[0].commandType == 1
    And match updateWorkWithQueueResponse.body.commandToProcess[1].commandName == updateWorkWithQueuePayload.body.commandToProcess[1].commandName
    #Get the updated workWith Queue
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[0]
    And set getWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[0]                                   |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getWorkWithQueueCommandBody
      | path |                                   0 |
      | id   | updateWorkWithQueueResponse.body.id |
    And set getWorkWithQueuePayload
      | path         | [0]                              |
      | header       | getWorkWithQueueCommandHeader[0] |
      | body.request | getWorkWithQueueCommandBody[0]   |
    And print getWorkWithQueuePayload
    And request getWorkWithQueuePayload
    When method POST
    Then status 200
    And def getWorkWithQueueResponse = response
    And print getWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workWithQueueCollectionNameRead+<tenantid>,getWorkWithQueueResponse.id)
    And print mongoResult
    And match mongoResult == getWorkWithQueueResponse.id
    And match getWorkWithQueueResponse.commandToProcess[0].targetTopic.name == updateWorkWithQueueResponse.body.commandToProcess[0].targetTopic.name
    And match getWorkWithQueueResponse.type == updateWorkWithQueueResponse.body.type
    And match getWorkWithQueueResponse.commandToProcess[0].commandName == updateWorkWithQueueResponse.body.commandToProcess[0].commandName
    And match getWorkWithQueueResponse.genericLayout.name == updateWorkWithQueueResponse.body.genericLayout.name
    #Get All workWith Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getWorkWith[1]
    And set getWorkWithQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getWorkWith[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | updateWorkWithQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | updateWorkWithQueueResponse.header.id            |
      | correlationId   | updateWorkWithQueueResponse.header.correlationId |
      | commandUserId   | updateWorkWithQueueResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getWorkWith[1]                                   |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getWorkWithQueuesCommandBody
      | path      |      0 |
      | queueCode | "Test" |
    And set getWorkWithQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkWithQueuesPayload
      | path                | [0]                                   |
      | header              | getWorkWithQueuesCommandHeader[0]     |
      | body.request        | getWorkWithQueuesCommandBody[0]       |
      | body.paginationSort | getWorkWithQueuesCommandPagination[0] |
    And print getWorkWithQueuesPayload
    And request getWorkWithQueuesPayload
    When method POST
    Then status 200
    And def getWorkWithQueuesResponse = response
    And print getWorkWithQueuesResponse
    And match each getWorkWithQueuesResponse.results[*].queueCode contains "Test"
    And match getWorkWithQueuesResponse.results[*].id contains getWorkWithQueueResponse.id
    And def getWorkWithQueuesResponseCount = karate.sizeOf(getWorkWithQueuesResponse.results)
    And print getWorkWithQueuesResponseCount
    And match getWorkWithQueuesResponseCount == getWorkWithQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getWorkWithQueueResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkWithQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithInvalidDataToMandatoryDetailsIndexing
  Scenario Outline: Update a WorkWith queue with Invalid Data to Mandatory fields indexing - Command Type Type random value
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
      #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                        0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                     |
      | commandType      | commandTypeList[1]                                       |
      | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                                        |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                 |
      | targetTopic.code | targetTopicsResultResponse.results[0].code               |
      | targetTopic.name | targetTopicsResultResponse.results[0].name               |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | faker.getFirstName()                       |
      | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set updateWorkWithQueueCommandBody
      | path                    |                                          0 |
      | id                      | workWithQueueResultResponse.body.id        |
      | type                    | queueType                                  |
      | queueCode               | workWithQueueResultResponse.body.queueCode |
      | queueName               | workWithQueueResultResponse.body.queueName |
      | workflowType            | workFlowType[1]                            |
      | body.genericLayout.id   | dataGenerator.Id()                         |
      | body.genericLayout.code | faker.getUserId()                          |
      | body.genericLayout.name | faker.getFirstName()                       |
         | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | isActive                | workWithQueueResultResponse.body.isActive  |
      | commandToProcess        | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithMissingMandatoryDetailsIndexing
  Scenario Outline: Update a WorkWith queue with Missing Mandatory fields - Indexing (Generic Layout name)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
     #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
        | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                        0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                     |
      | commandType      | commandTypeList[1]                                       |
      | targetType       | targetTypeList[1]                                        |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                 |
      | targetTopic.code | targetTopicsResultResponse.results[0].code               |
      | targetTopic.name | targetTopicsResultResponse.results[0].name               |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set updateWorkWithQueueCommandBody
      | path             |                                          0 |
      | id               | workWithQueueResultResponse.body.id        |
      | type             | queueType                                  |
      | queueCode        | workWithQueueResultResponse.body.queueCode |
      | queueName        | workWithQueueResultResponse.body.queueName |
      | workflowType     | workFlowType[1]                            |
      | isActive         | workWithQueueResultResponse.body.isActive  |
      | commandToProcess | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithInvalidDataToMandatoryDetailsCasheiring
  Scenario Outline: Update a WorkWith queue with Invalid Data to Mandatory fields Casheiring - Invalid WorkFlow Type
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueCasheringMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
     #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
       | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                        0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                     |
      | commandType      | commandTypeList[1]                                       |
       | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                                        |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                 |
      | targetTopic.code | targetTopicsResultResponse.results[0].code               |
      | targetTopic.name | targetTopicsResultResponse.results[0].name               |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
       | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set updateWorkWithQueueCommandBody
      | path                    |                                          0 |
      | id                      | workWithQueueResultResponse.body.id        |
      | type                    | queueType                                  |
      | queueCode               | workWithQueueResultResponse.body.queueCode |
      | queueName               | workWithQueueResultResponse.body.queueName |
      | body.genericLayout.id   | dataGenerator.Id()                         |
      | body.genericLayout.code | faker.getUserId()                          |
      | body.genericLayout.name | faker.getFirstName()                       |
      | workflowType            | faker.getFirstName()                       |
       | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | isActive                | workWithQueueResultResponse.body.isActive  |
      | commandToProcess        | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkWithQueueWithMissingMandatoryDetails-Casheiring
  Scenario Outline: Update a WorkWith queue with Missing Mandatory fields - Indexing (Work Flow Missing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
        #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Update the workWith Queue
    And set updateWorkWithQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
       | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | workWithQueueResultResponse.header.entityId      |
      | commandUserId   | workWithQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[0]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                                        0 |
      | id               | workWithQueueResultResponse.body.commandToProcess[0].id       |
      | sequence         | workWithQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName      | faker.getFirstName()                                     |
      | commandType      | commandTypeList[1]                                       |
      | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                                        |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id                 |
      | targetTopic.code | targetTopicsResultResponse.results[0].code               |
      | targetTopic.name | targetTopicsResultResponse.results[0].name               |
    And set updateWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | actions[0]       | actions[1]                                 |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set updateWorkWithQueueCommandBody
      | path                    |                                          0 |
      | id                      | workWithQueueResultResponse.body.id        |
      | type                    | queueType                                  |
      | queueCode               | workWithQueueResultResponse.body.queueCode |
      | queueName               | workWithQueueResultResponse.body.queueName |
      | workflowType            | workFlowType[1]                            |
      | isActive                | workWithQueueResultResponse.body.isActive  |
      | body.genericLayout.id   | dataGenerator.Id()                         |
      | body.genericLayout.code | faker.getUserId()                          |
      | body.genericLayout.name | faker.getFirstName()                       |
       | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | commandToProcess        | updateWorkWithQueueCommandToProcess        |
    And set updateWorkWithQueuePayload
      | path   | [0]                                 |
      | header | updateWorkWithQueueCommandHeader[0] |
      | body   | updateWorkWithQueueCommandBody[0]   |
    And print updateWorkWithQueuePayload
    And request updateWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueDuplicate-Casheiring  
  Scenario Outline: Create a WorkWith queue with duplicate queue
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
      #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
      #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Creating another workWith Queue
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueuecommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | dataGenerator.Id()                         |
      | sequence         | faker.getUserId()                          |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | actions[0]       | actions[1]                                 |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         | faker.getUserId()                          |
      | commandName      | faker.getFirstName()                       |
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[1]                         |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path                    |                                          0 |
      | id                      | entityIdData                               |
      | type                    | queueType                                  |
      | queueCode               | workWithQueueResultResponse.body.queueCode |
      | queueName               | faker.getFirstName()                       |
      | workflowType            | workFlowType[0]                            |
      | body.genericLayout.id   | dataGenerator.Id()                         |
      | body.genericLayout.code | faker.getUserId()                          |
      | body.genericLayout.name | faker.getFirstName()                       |
        | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess        | createWorkWithQueueCommandToProcess        |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueuecommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueDuplicate-Indexing @test
  Scenario Outline: Create a WorkWith queue with duplicate - Indexing
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Call the create WorkWith Queue
    And def workWithQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/workWithQueue/CreateWorkWithQueue.feature@CreateWorkWithQueueIndexingMandatoryFields')
    And def workWithQueueResultResponse = workWithQueueResult.response
    And print workWithQueueResultResponse
      #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Retrieve the Active GL forms
    And def allForms = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@GetActiveFormsforGenericLayout')
    And def FormsResponse = allForms.response
    And print FormsResponse
    And def id = FormsResponse.results[0].id
    And def code = FormsResponse.results[0].code
    And def name = FormsResponse.results[0].name
    #Creating another workWith Queue
    And def entityIdData = dataGenerator.entityID()
    And set createWorkWithQueueCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          0 |
      | id               | dataGenerator.Id()                         |
      | sequence         | faker.getUserId()                          |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
       | actions[0]       | actions[1]                                 |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         | faker.getUserId()                          |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
       | actions[0]       | actions[1]                                 |
      # | description      | faker.getRandomShortDescription()          |
      # | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path                    |                                          0 |
      | id                      | entityIdData                               |
      | type                    | queueType                                  |
      | queueCode               | workWithQueueResultResponse.body.queueCode |
      | queueName               | faker.getFirstName()                       |
      | workflowType            | workFlowType[1]                            |
      | body.genericLayout.id   | dataGenerator.Id()                         |
      | body.genericLayout.code | faker.getUserId()                          |
      | body.genericLayout.name | faker.getFirstName()                       |
        | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      #   | description             | faker.getLastName()                  |
      #  | isActive                | faker.getRandomBooleanValue()        |
      | commandToProcess        | createWorkWithQueueCommandToProcess        |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
