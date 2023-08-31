Feature: Decision Queue E2E

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def queueType = 'DecisionPoint'
    And def getDecisionQueue = ['GetDecisionPointQueueConfiguration','GetQueueConfigurations']
    And def commandTypes = ['CreateDecisionPointQueueConfiguration','UpdateDecisionPointQueueConfiguration']
    And def eventTypes = ['DecisionPointQueueConfiguration']
    And def historyAndComments = ['Created','Updated']
    And def decisionPointQueueCollectionName = 'CreateDecisionPointQueueConfiguration_'
    And def decisionPointQueueCollectionNameRead = 'DecisionPointQueueConfigurationDetailViewModel_'
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateDecisionQueueWithGet
  Scenario Outline: Create a Decision  queue with all the fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[0]
    #Call the create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Get decision Queue
    And set getDecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[0]                              |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getDecisionQueueCommandBody
      | path |                                   0 |
      | id   | decisionQueueResultResponse.body.id |
    And set getDecisionQueuePayload
      | path         | [0]                              |
      | header       | getDecisionQueueCommandHeader[0] |
      | body.request | getDecisionQueueCommandBody[0]   |
    And print getDecisionQueuePayload
    And request getDecisionQueuePayload
    When method POST
    Then status 200
    And def getDecisionQueueResponse = response
    And print getDecisionQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,decisionPointQueueCollectionNameRead+<tenantid>,getDecisionQueueResponse.id)
    And print mongoResult
    And match mongoResult == getDecisionQueueResponse.id
    And match getDecisionQueueResponse.queueName == decisionQueueResultResponse.body.queueName
    And match getDecisionQueueResponse.inputRequest.inputCommand.name == decisionQueueResultResponse.body.inputRequest.inputCommand.name
    And match getDecisionQueueResponse.inputRequest.inputResponse.name == decisionQueueResultResponse.body.inputRequest.inputResponse.name
    #Get All decision Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[1]
    And set getDecisionQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[1]                              |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDecisionQueuesCommandBody
      | path |         0 |
      | type | queueType |
    And set getDecisionQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionQueuesPayload
      | path                | [0]                                   |
      | header              | getDecisionQueuesCommandHeader[0]     |
      | body.request        | getDecisionQueuesCommandBody[0]       |
      | body.paginationSort | getDecisionQueuesCommandPagination[0] |
    And print getDecisionQueuesPayload
    And request getDecisionQueuesPayload
    When method POST
    Then status 200
    And def getDecisionQueuesResponse = response
    And print getDecisionQueuesResponse
    And match each getDecisionQueuesResponse.results[*].type contains queueType
    And match getDecisionQueuesResponse.results[*].id contains getDecisionQueueResponse.id
    And def getDecisionQueuesResponseCount = karate.sizeOf(getDecisionQueuesResponse.results)
    And print getDecisionQueuesResponseCount
    And match getDecisionQueuesResponseCount == getDecisionQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getDecisionQueueResponse.id
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
    And def eventEntityID = getDecisionQueueResponse.id
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

  @CreateDecisionQueueWithMandatoryFieldsGet
  Scenario Outline: Create a Decision queue with mandatory fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[0]
    #Call the create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueueWithMandatoryFields')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Get decision Queue
    And set getDecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[0]                              |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getDecisionQueueCommandBody
      | path |                                   0 |
      | id   | decisionQueueResultResponse.body.id |
    And set getDecisionQueuePayload
      | path         | [0]                              |
      | header       | getDecisionQueueCommandHeader[0] |
      | body.request | getDecisionQueueCommandBody[0]   |
    And print getDecisionQueuePayload
    And request getDecisionQueuePayload
    When method POST
    Then status 200
    And def getDecisionQueueResponse = response
    And print getDecisionQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,decisionPointQueueCollectionNameRead+<tenantid>,getDecisionQueueResponse.id)
    And print mongoResult
    And match mongoResult == getDecisionQueueResponse.id
    And match getDecisionQueueResponse.queueName == decisionQueueResultResponse.body.queueName
    And match getDecisionQueueResponse.inputRequest.inputCommand.name == decisionQueueResultResponse.body.inputRequest.inputCommand.name
    #Get All decision Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[1]
    And set getDecisionQueuesCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[1]                              |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDecisionQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getDecisionQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionQueuesPayload
      | path                | [0]                                   |
      | header              | getDecisionQueuesCommandHeader[0]     |
      | body.request        | getDecisionQueuesCommandBody[0]       |
      | body.paginationSort | getDecisionQueuesCommandPagination[0] |
    And set getDecisionQueuesPayload
      | path         | [0]                               |
      | header       | getDecisionQueuesCommandHeader[0] |
      | body.request | getDecisionQueuesCommandBody[0]   |
    And print getDecisionQueuesPayload
    And request getDecisionQueuesPayload
    When method POST
    Then status 200
    And def getDecisionQueuesResponse = response
    And print getDecisionQueuesResponse
    And match each getDecisionQueuesResponse.results[*].queueName contains "Test"
    And match getDecisionQueuesResponse.results[*].id contains getDecisionQueueResponse.id
    And def getDecisionQueuesResponseCount = karate.sizeOf(getDecisionQueuesResponse.results)
    And print getDecisionQueuesResponseCount
    And match getDecisionQueuesResponseCount == getDecisionQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getDecisionQueueResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDecisionQueueResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
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

  @CreateDecisionPointQueueWithIvalidDataToMandatoryFields
  Scenario Outline: Create a decision point queue with mandatory fields and Validate - Invalid entityid
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Creating decision point queue
    And def entityIdData = dataGenerator.entityID()
    And set createDecisionPointQueuecommandHeader
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
    And set createDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[0].id   |
      | code | inputCommandResultResponse.results[0].code |
      | name | inputCommandResultResponse.results[0].name |
    And set createDecisionPointQueueInputResponse
      | path |                                           0 |
      | id   | inputResponseResultResponse.results[0].id   |
      | code | inputResponseResultResponse.results[0].code |
      | name | inputResponseResultResponse.results[0].name |
    And set createDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | createDecisionPointQueueInputCommand[0] |
    And set createDecisionPointQueueCommandBody
      | path                          |                                       0 |
      | id                            | dataGenerator.Id()                      |
      | type                          | queueType                               |
      | queueCode                     | faker.getUserId()                       |
      | queueName                     | ""                                      |
      | inputRequest                  | createDecisionPointQueueInputRequest[0] |
      | inputRequest.filterExpression | "Age>18"                                |
      | inputRequest.id               | dataGenerator.Id()                      |
    And set createDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | createDecisionPointQueuecommandHeader[0] |
      | body   | createDecisionPointQueueCommandBody[0]   |
    And print createDecisionPointQueuePayload
    And request createDecisionPointQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDecisionPointQueueWithMissingMandatoryFields
  Scenario Outline: Create a decision point queue with missing mandatory fields - Queue Name missing
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Creating decision point queue
    And def entityIdData = dataGenerator.entityID()
    And set createDecisionPointQueuecommandHeader
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
      | commandType     | +commandTypes[0]                             |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[0].id   |
      | code | inputCommandResultResponse.results[0].code |
      | name | inputCommandResultResponse.results[0].name |
    And set createDecisionPointQueueInputResponse
      | path |                                           0 |
      | id   | inputResponseResultResponse.results[0].id   |
      | code | inputResponseResultResponse.results[0].code |
      | name | inputResponseResultResponse.results[0].name |
    And set createDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | createDecisionPointQueueInputCommand[0] |
    And set createDecisionPointQueueCommandBody
      | path                          |                                       0 |
      | id                            | entityIdData                            |
      | type                          | queueType                               |
      | queueCode                     | faker.getUserId()                       |
      | inputRequest                  | createDecisionPointQueueInputRequest[0] |
      | inputRequest.filterExpression | "Age>18"                                |
    And set createDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | createDecisionPointQueuecommandHeader[0] |
      | body   | createDecisionPointQueueCommandBody[0]   |
    And print createDecisionPointQueuePayload
    And request createDecisionPointQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDecisionPointQueueWithDuplicateQueueCode
  Scenario Outline: Create a decision point queue with duplicate queue code
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Calling create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Creating decision point queue
    And def entityIdData = dataGenerator.entityID()
    And set createDecisionPointQueuecommandHeader
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
      | commandType     | +commandTypes[0]                             |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[0].id   |
      | code | inputCommandResultResponse.results[0].code |
      | name | inputCommandResultResponse.results[0].name |
    And set createDecisionPointQueueInputResponse
      | path |                                           0 |
      | id   | inputResponseResultResponse.results[0].id   |
      | code | inputResponseResultResponse.results[0].code |
      | name | inputResponseResultResponse.results[0].name |
    And set createDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | createDecisionPointQueueInputCommand[0] |
    And set createDecisionPointQueueCommandBody
      | path                          |                                          0 |
      | id                            | entityIdData                               |
      | type                          | queueType                                  |
      | queueCode                     | decisionQueueResultResponse.body.queueCode |
      | inputRequest                  | createDecisionPointQueueInputRequest[0]    |
      | inputRequest.filterExpression | "Age>18"                                   |
    And set createDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | createDecisionPointQueuecommandHeader[0] |
      | body   | createDecisionPointQueueCommandBody[0]   |
    And print createDecisionPointQueuePayload
    And request createDecisionPointQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateDecisionPointQueueConfigWithAllDetails
  Scenario Outline: Update a Decision Point queue with all the fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Calling create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Update the decision Queue
    And set updateDecisionPointQueuecommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | entityId        | decisionQueueResultResponse.header.entityId      |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[1]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[0].id   |
      | code | inputCommandResultResponse.results[0].code |
      | name | inputCommandResultResponse.results[0].name |
    And set updateDecisionPointQueueInputResponse
      | path |                                           0 |
      | id   | inputResponseResultResponse.results[0].id   |
      | code | inputResponseResultResponse.results[0].code |
      | name | inputResponseResultResponse.results[0].name |
    And set updateDecisionPointQueueInputRequest
      | path          |                                        0 |
      | inputCommand  | updateDecisionPointQueueInputCommand[0]  |
      | inputResponse | updateDecisionPointQueueInputResponse[0] |
    And set updateDecisionPointQueueCommandBody
      | path         |                                             0 |
      | id           | decisionQueueResultResponse.body.id           |
      | type         | queueType                                     |
      | queueCode    | faker.getUserId()                             |
      | queueName    | faker.getFirstName()                          |
      | description  | faker.getLastName()                           |
      | isActive     | faker.getRandomBoolean()                      |
      | inputRequest | decisionQueueResultResponse.body.inputRequest |
    And set updateDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | updateDecisionPointQueuecommandHeader[0] |
      | body   | updateDecisionPointQueueCommandBody[0]   |
    And print updateDecisionPointQueuePayload
    And request updateDecisionPointQueuePayload
    When method POST
    Then status 201
    And def updateDecisionPointQueueResponse = response
    And print updateDecisionPointQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,decisionPointQueueCollectionName+<tenantid>,updateDecisionPointQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDecisionPointQueueResponse.body.id
    And match updateDecisionPointQueueResponse.body.queueName == updateDecisionPointQueuePayload.body.queueName
    And match updateDecisionPointQueueResponse.body.inputRequest.inputCommand.name == updateDecisionPointQueuePayload.body.inputRequest.inputCommand.name
    And match updateDecisionPointQueueResponse.body.inputRequest.inputResponse.name == updateDecisionPointQueuePayload.body.inputRequest.inputResponse.name
    #Get decision Queue
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[0]
    And set getDecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[0]                              |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getDecisionQueueCommandBody
      | path |                                   0 |
      | id   | decisionQueueResultResponse.body.id |
    And set getDecisionQueuePayload
      | path         | [0]                              |
      | header       | getDecisionQueueCommandHeader[0] |
      | body.request | getDecisionQueueCommandBody[0]   |
    And print getDecisionQueuePayload
    And request getDecisionQueuePayload
    When method POST
    Then status 200
    And def getDecisionQueueResponse = response
    And print getDecisionQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,decisionPointQueueCollectionNameRead+<tenantid>,updateDecisionPointQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == getDecisionQueueResponse.id
    And match getDecisionQueueResponse.queueName == updateDecisionPointQueueResponse.body.queueName
    And match getDecisionQueueResponse.inputRequest.inputCommand.name == updateDecisionPointQueueResponse.body.inputRequest.inputCommand.name
    And match getDecisionQueueResponse.inputRequest.inputResponse.name == updateDecisionPointQueueResponse.body.inputRequest.inputResponse.name
    #Get All decision Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[1]
    And set getDecisionQueuesCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | updateDecisionPointQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | updateDecisionPointQueueResponse.header.id            |
      | correlationId   | updateDecisionPointQueueResponse.header.correlationId |
      | commandUserId   | updateDecisionPointQueueResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | getDecisionQueue[1]                                   |
      | getType         | "Array"                                               |
      | ttl             |                                                     0 |
    And set getDecisionQueuesCommandBody
      | path        |      0 |
      | description | "Test" |
    And set getDecisionQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionQueuesPayload
      | path                | [0]                                   |
      | header              | getDecisionQueuesCommandHeader[0]     |
      | body.request        | getDecisionQueuesCommandBody[0]       |
      | body.paginationSort | getDecisionQueuesCommandPagination[0] |
    And print getDecisionQueuesPayload
    And request getDecisionQueuesPayload
    When method POST
    Then status 200
    And def getDecisionQueuesResponse = response
    And print getDecisionQueuesResponse
    And match each getDecisionQueuesResponse.results[*].description contains "Test"
    And match getDecisionQueuesResponse.results[*].id contains getDecisionQueueResponse.id
    And def getDecisionQueuesResponseCount = karate.sizeOf(getDecisionQueuesResponse.results)
    And print getDecisionQueuesResponseCount
    And match getDecisionQueuesResponseCount == getDecisionQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getDecisionQueueResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDecisionQueueResponse.id
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

  @updateDecisionPointQueueConfigWithMandatoryDetails
  Scenario Outline: Update a Decision Point queue with Mandatory fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Calling create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Update the decision Queue
    And set updateDecisionPointQueuecommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | entityId        | decisionQueueResultResponse.header.entityId      |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[1]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[0].id   |
      | code | inputCommandResultResponse.results[0].code |
      | name | inputCommandResultResponse.results[0].name |
    And set updateDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | updateDecisionPointQueueInputCommand[0] |
    And set updateDecisionPointQueueCommandBody
      | path                          |                                                0 |
      | id                            | decisionQueueResultResponse.body.id              |
      | type                          | queueType                                        |
      | queueCode                     | faker.getUserId()                                |
      | queueName                     | faker.getFirstName()                             |
      | inputRequest                  | updateDecisionPointQueueInputRequest[0]          |
      | inputRequest.loop             | faker.getRandomBooleanValue()                    |
      | inputRequest.filterExpression | "Age>18"                                         |
      | inputRequest.id               | decisionQueueResultResponse.body.inputRequest.id |
    And set updateDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | updateDecisionPointQueuecommandHeader[0] |
      | body   | updateDecisionPointQueueCommandBody[0]   |
    And print updateDecisionPointQueuePayload
    And request updateDecisionPointQueuePayload
    When method POST
    Then status 201
    And def updateDecisionPointQueueResponse = response
    And print updateDecisionPointQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,decisionPointQueueCollectionName+<tenantid>,updateDecisionPointQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDecisionPointQueueResponse.body.id
    And match updateDecisionPointQueueResponse.body.queueName == updateDecisionPointQueuePayload.body.queueName
    And match updateDecisionPointQueueResponse.body.inputRequest.inputCommand.name == updateDecisionPointQueuePayload.body.inputRequest.inputCommand.name
    #Get decision Queue
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[0]
    And set getDecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | getDecisionQueue[0]                              |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getDecisionQueueCommandBody
      | path |                                   0 |
      | id   | decisionQueueResultResponse.body.id |
    And set getDecisionQueuePayload
      | path         | [0]                              |
      | header       | getDecisionQueueCommandHeader[0] |
      | body.request | getDecisionQueueCommandBody[0]   |
    And print getDecisionQueuePayload
    And request getDecisionQueuePayload
    When method POST
    Then status 200
    And def getDecisionQueueResponse = response
    And print getDecisionQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,decisionPointQueueCollectionNameRead+<tenantid>,updateDecisionPointQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == getDecisionQueueResponse.id
    And match getDecisionQueueResponse.queueName == updateDecisionPointQueueResponse.body.queueName
    And match getDecisionQueueResponse.inputRequest.inputCommand.name == updateDecisionPointQueueResponse.body.inputRequest.inputCommand.name
    #Get All decision Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getDecisionQueue[1]
    And set getDecisionQueuesCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+getDecisionQueue[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | updateDecisionPointQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | updateDecisionPointQueueResponse.header.id            |
      | correlationId   | updateDecisionPointQueueResponse.header.correlationId |
      | commandUserId   | updateDecisionPointQueueResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | getDecisionQueue[1]                                   |
      | getType         | "Array"                                               |
      | ttl             |                                                     0 |
    And set getDecisionQueuesCommandBody
      | path     |                                              0 |
      | isActive | updateDecisionPointQueueResponse.body.isActive |
    And set getDecisionQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionQueuesPayload
      | path                | [0]                                   |
      | header              | getDecisionQueuesCommandHeader[0]     |
      | body.request        | getDecisionQueuesCommandBody[0]       |
      | body.paginationSort | getDecisionQueuesCommandPagination[0] |
    And print getDecisionQueuesPayload
    And request getDecisionQueuesPayload
    When method POST
    Then status 200
    And def getDecisionQueuesResponse = response
    And print getDecisionQueuesResponse
    And match each getDecisionQueuesResponse.results[*].isActive == updateDecisionPointQueueResponse.body.isActive
    And match getDecisionQueuesResponse.results[*].id contains getDecisionQueueResponse.id
    And def getDecisionQueuesResponseCount = karate.sizeOf(getDecisionQueuesResponse.results)
    And print getDecisionQueuesResponseCount
    And match getDecisionQueuesResponseCount == getDecisionQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getDecisionQueueResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDecisionQueueResponse.id
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

  @updateDecisionPointQueueConfigWithInvalidDataToMandatoryDetails
  Scenario Outline: Update a Decision Point queue with Invalid Data to Mandatory fields (Invalid filter expression)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Calling create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Update the decision Queue
    And set updatedecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | entityId        | decisionQueueResultResponse.header.entityId      |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[1]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[1].id   |
      | code | inputCommandResultResponse.results[1].code |
      | name | inputCommandResultResponse.results[1].name |
    And set updateDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | updateDecisionPointQueueInputCommand[0] |
    And set updateDecisionPointQueueCommandBody
      | path                          |                                       0 |
      | id                            | entityIdData                            |
      | type                          | queueType                               |
      | queueCode                     | faker.getUserId()                       |
      | queueName                     | faker.getFirstName()                    |
      | inputRequest                  | updateDecisionPointQueueInputRequest[0] |
      | inputRequest.loop             | faker.getRandomBooleanValue()           |
      | inputRequest.filterExpression | faker.getRandomBooleanValue()           |
    And set updateDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | updateDecisionPointQueuecommandHeader[0] |
      | body   | updateDecisionPointQueueCommandBody[0]   |
    And print updateDecisionPointQueuePayload
    And request updateDecisionPointQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateDecisionPointQueueConfigWithMissingMandatoryDetails
  Scenario Outline: Update a Decision Point queue with Missing Mandatory fields (Input request is missing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retriving the Input Command
    And def inputCommandResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputCommands')
    And def inputCommandResultResponse = inputCommandResult.response
    And print inputCommandResultResponse
    #Retriving the Input Response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    #Calling create decision queue
    And def decisionQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/CreateDecisionQueue.feature@CreateDecisionPointQueue')
    And def decisionQueueResultResponse = decisionQueueResult.response
    And print decisionQueueResultResponse
    #Update the decision Queue
    And set updatedecisionQueueCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | decisionQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | decisionQueueResultResponse.header.id            |
      | correlationId   | decisionQueueResultResponse.header.correlationId |
      | entityId        | decisionQueueResultResponse.header.entityId      |
      | commandUserId   | decisionQueueResultResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandTypes[1]                                  |
      | entityName      | eventTypes[0]                                    |
      | ttl             |                                                0 |
    And set updateDecisionPointQueueInputCommand
      | path |                                          0 |
      | id   | inputCommandResultResponse.results[1].id   |
      | code | inputCommandResultResponse.results[1].code |
      | name | inputCommandResultResponse.results[1].name |
    And set updateDecisionPointQueueInputRequest
      | path         |                                       0 |
      | inputCommand | updateDecisionPointQueueInputCommand[0] |
    And set updateDecisionPointQueueCommandBody
      | path                          |                             0 |
      | id                            | entityIdData                  |
      | type                          | queueType                     |
      | queueCode                     | faker.getUserId()             |
      | queueName                     | faker.getFirstName()          |
      # | inputRequest                  | updateDecisionPointQueueInputRequest[0] |
      | inputRequest.loop             | faker.getRandomBooleanValue() |
      | inputRequest.filterExpression | "Age>15"                      |
    And set updateDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | updateDecisionPointQueuecommandHeader[0] |
      | body   | updateDecisionPointQueueCommandBody[0]   |
    And print updateDecisionPointQueuePayload
    And request updateDecisionPointQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
