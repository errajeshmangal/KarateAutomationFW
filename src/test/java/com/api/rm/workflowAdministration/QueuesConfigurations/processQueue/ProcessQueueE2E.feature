# This feature file created for E2E scenarios
Feature: Create Process Queue - E2E

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def processQueueCollectionName = 'CreateProcessQueueConfiguration_'
    And def processQueueCollectionNameRead = 'ProcessQueueConfigurationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def queueType = 'Process'
    And def commandTypeList = ['Create','Update']
    And def targetTypeList = ['Topic','URL']
    And def getProcess = ['GetProcessQueueConfiguration','GetQueueConfigurations']
    And def commandTypes = ['UpdateProcessQueueConfiguration','CreateProcessQueueConfiguration']
    And def eventTypes = ['ProcessQueueConfiguration']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateProcessQueueWithGet
  Scenario Outline: Create a Process  queue with all the fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[0]
    #Call the create process queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueue')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Get process Queue
    And set getProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[0]                                   |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getProcessQueueCommandBody
      | path |                                  0 |
      | id   | processQueueResultResponse.body.id |
    And set getProcessQueuePayload
      | path         | [0]                             |
      | header       | getProcessQueueCommandHeader[0] |
      | body.request | getProcessQueueCommandBody[0]   |
    And print getProcessQueuePayload
    And request getProcessQueuePayload
    When method POST
    Then status 200
    And def getProcessQueueResponse = response
    And print getProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,processQueueCollectionNameRead+<tenantid>,getProcessQueueResponse.id)
    And print mongoResult
    And match mongoResult == getProcessQueueResponse.id
    And match getProcessQueueResponse.commandToProcess[0].targetTopic.name == processQueueResultResponse.body.commandToProcess[0].targetTopic.name
    #Get All process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[1]
    And set getProcessQueuesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[1]                                   |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getProcessQueuesCommandBody
      | path |         0 |
      | type | queueType |
    And set getProcessQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getProcessQueuesPayload
      | path                | [0]                                  |
      | header              | getProcessQueuesCommandHeader[0]     |
      | body.request        | getProcessQueuesCommandBody[0]       |
      | body.paginationSort | getProcessQueuesCommandPagination[0] |
    And print getProcessQueuesPayload
    And request getProcessQueuesPayload
    When method POST
    Then status 200
    And def getProcessQueuesResponse = response
    And print getProcessQueuesResponse
    And match each getProcessQueuesResponse.results[*].type contains queueType
    And match getProcessQueuesResponse.results[*].id contains getProcessQueueResponse.id
    And def getProcessQueuesResponseCount = karate.sizeOf(getProcessQueuesResponse.results)
    And print getProcessQueuesResponseCount
    And match getProcessQueuesResponseCount == getProcessQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getProcessQueueResponse.id
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
    And def eventEntityID = getProcessQueuesResponse.id
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

  @CreateProcessQueueWithMandatoryfieldsGet
  Scenario Outline: Create a Process queue with mandatory fields and Get the details
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[0]
    #Call the create process queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueueWithMandatoryFields')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Get the process queue
    And set getProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[0]                                   |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getProcessQueueCommandBody
      | path |                                  0 |
      | id   | processQueueResultResponse.body.id |
    And set getProcessQueuePayload
      | path         | [0]                             |
      | header       | getProcessQueueCommandHeader[0] |
      | body.request | getProcessQueueCommandBody[0]   |
    And print getProcessQueuePayload
    And request getProcessQueuePayload
    When method POST
    Then status 200
    And def getProcessQueueResponse = response
    And print getProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,processQueueCollectionNameRead+<tenantid>,getProcessQueueResponse.id)
    And print mongoResult
    And match mongoResult == getProcessQueueResponse.id
    And match getProcessQueueResponse.commandToProcess[0].targetTopic.code == processQueueResultResponse.body.commandToProcess[0].targetTopic.code
    #Get All process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[1]
    And set getProcessQueuesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[1]                                   |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getProcessQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getProcessQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getProcessQueuesPayload
      | path                | [0]                                  |
      | header              | getProcessQueuesCommandHeader[0]     |
      | body.request        | getProcessQueuesCommandBody[0]       |
      | body.paginationSort | getProcessQueuesCommandPagination[0] |
    And print getProcessQueuesPayload
    And request getProcessQueuesPayload
    When method POST
    Then status 200
    And def getProcessQueuesResponse = response
    And print getProcessQueuesResponse
    And match each getProcessQueuesResponse.results[*].queueName contains 'Test'
    And match getProcessQueuesResponse.results[*].id contains getProcessQueueResponse.id
    And def getProcessQueuesResponseCount = karate.sizeOf(getProcessQueuesResponse.results)
    And print getProcessQueuesResponseCount
    And match getProcessQueuesResponseCount == getProcessQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getProcessQueueResponse.id
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
    And def eventEntityID = getProcessQueuesResponse.id
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

  @CreateProcessQueueWithMissingMandatoryFields
  Scenario Outline: Create a Process queue with Missing Mandatory fields and Validate (Seq is missing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createProcessQueuecommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
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
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createProcessQueueCommandToProcess
      | path |                  0 |
      | id   | dataGenerator.Id() |
    #      | commandName      | faker.getFirstName()                       |
    #| commandType      | commandTypeList[0]                         |
    #| targetType       | targetTypeList[0]                          |
    #| targetTopic.id   | targetTopicsResultResponse.results[0].id   |
    #| targetTopic.code | targetTopicsResultResponse.results[0].code |
    #| targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createProcessQueueCommandBody
      | path             |                                  0 |
      | id               | entityIdData                       |
      | type             | queueType                          |
      | queueCode        | faker.getUserId()                  |
      | queueName        | faker.getFirstName()               |
      | isActive         | faker.getRandomBooleanValue()      |
      | commandToProcess | createProcessQueueCommandToProcess |
    And set createProcessQueuePayload
      | path   | [0]                                |
      | header | createProcessQueuecommandHeader[0] |
      | body   | createProcessQueueCommandBody[0]   |
    And print createProcessQueuePayload
    And request createProcessQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateProcessQueueWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Process queue with Invalid Data To Mandatory fields - Seq number with String
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createProcessQueuecommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
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
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createProcessQueueCommandToProcess
      | path             |                                          0 |
      | id               | dataGenerator.Id()                         |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createProcessQueueCommandBody
      | path             |                                  0 |
      | id               | entityIdData                       |
      | sequence         | faker.getUserId()                  |
      | type             | queueType                          |
      | queueCode        | faker.getUserId()                  |
      | queueName        | faker.getFirstName()               |
      | isActive         | faker.getRandomBooleanValue()      |
      | commandToProcess | createProcessQueueCommandToProcess |
    And set createProcessQueuePayload
      | path   | [0]                                |
      | header | createProcessQueuecommandHeader[0] |
      | body   | createProcessQueueCommandBody[0]   |
    And print createProcessQueuePayload
    And request createProcessQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateProcessQueueWithAllDetailsAndGet
  Scenario Outline: Update a Process queue with all the fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create Process Queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueue')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Update the process Queue
    And set updateProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | entityId        | processQueueResultResponse.header.entityId      |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandTypes[0]                                 |
      | entityName      | eventTypes[0]                                   |
      | ttl             |                                               0 |
    And set updateProcessQueueCommandToProcess
      | path             |                                                                    0 |
      | id               | processQueueResultResponse.body.commandToProcess[0].id               |
      | sequence         | processQueueResultResponse.body.commandToProcess[0].sequence         |
      | commandName      | faker.getFirstName()                                                 |
      | commandType      | commandTypeList[0]                                                   |
      | description      | faker.getFirstName()                                                 |
      | isActive         | true                                                                 |
      | targetType       | targetTypeList[0]                                                    |
      | targetTopic.id   | processQueueResultResponse.body.commandToProcess[0].targetTopic.id   |
      | targetTopic.code | processQueueResultResponse.body.commandToProcess[0].targetTopic.code |
      | targetTopic.name | processQueueResultResponse.body.commandToProcess[0].targetTopic.name |
    And set updateProcessQueueCommandBody
      | path             |                                         0 |
      | id               | processQueueResultResponse.body.id        |
      | type             | queueType                                 |
      | queueCode        | processQueueResultResponse.body.queueCode |
      | queueName        | processQueueResultResponse.body.queueName |
      | description      | faker.getLastName()                       |
      | isActive         | processQueueResultResponse.body.isActive  |
      | commandToProcess | updateProcessQueueCommandToProcess        |
    And set updateProcessQueuePayload
      | path   | [0]                                |
      | header | updateProcessQueueCommandHeader[0] |
      | body   | updateProcessQueueCommandBody[0]   |
    And print updateProcessQueuePayload
    And request updateProcessQueuePayload
    When method POST
    Then status 201
    And def updateProcessQueueResponse = response
    And print updateProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,processQueueCollectionName+<tenantid>,updateProcessQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateProcessQueueResponse.body.id
    And match updateProcessQueueResponse.body.queueName == updateProcessQueuePayload.body.queueName
    And match updateProcessQueueResponse.body.commandToProcess[0].commandType == 0
    #Get the updated process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[0]
    And set getProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateProcessQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateProcessQueueResponse.header.id            |
      | correlationId   | updateProcessQueueResponse.header.correlationId |
      | commandUserId   | updateProcessQueueResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[0]                                   |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getProcessQueueCommandBody
      | path |                                  0 |
      | id   | updateProcessQueueResponse.body.id |
    And set getProcessQueuePayload
      | path         | [0]                             |
      | header       | getProcessQueueCommandHeader[0] |
      | body.request | getProcessQueueCommandBody[0]   |
    And print getProcessQueuePayload
    And request getProcessQueuePayload
    When method POST
    Then status 200
    And def getProcessQueueResponse = response
    And print getProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,processQueueCollectionNameRead+<tenantid>,getProcessQueueResponse.id)
    And print mongoResult
    And match mongoResult == getProcessQueueResponse.id
    And match getProcessQueueResponse.commandToProcess[0].targetTopic.name == updateProcessQueueResponse.body.commandToProcess[0].targetTopic.name
    And match getProcessQueueResponse.type == updateProcessQueueResponse.body.type
    And match getProcessQueueResponse.commandToProcess[0].commandName == updateProcessQueueResponse.body.commandToProcess[0].commandName
    #Get All process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[1]
    And set getProcessQueuesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateProcessQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateProcessQueueResponse.header.id            |
      | correlationId   | updateProcessQueueResponse.header.correlationId |
      | commandUserId   | updateProcessQueueResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[1]                                   |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getProcessQueuesCommandBody
      | path        |      0 |
      | description | "Test" |
    And set getProcessQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getProcessQueuesPayload
      | path                | [0]                                  |
      | header              | getProcessQueuesCommandHeader[0]     |
      | body.request        | getProcessQueuesCommandBody[0]       |
      | body.paginationSort | getProcessQueuesCommandPagination[0] |
    And print getProcessQueuesPayload
    And request getProcessQueuesPayload
    When method POST
    Then status 200
    And def getProcessQueuesResponse = response
    And print getProcessQueuesResponse
    And match each getProcessQueuesResponse.results[*].description contains "Test"
    And match getProcessQueuesResponse.results[*].id contains getProcessQueueResponse.id
    And def getProcessQueuesResponseCount = karate.sizeOf(getProcessQueuesResponse.results)
    And print getProcessQueuesResponseCount
    And match getProcessQueuesResponseCount == getProcessQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getProcessQueueResponse.id
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
    And def eventEntityID = getProcessQueuesResponse.id
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

  @UpdateProcessQueueWithMandatoryDetailsAndGet
  Scenario Outline: Update a Process queue with Mandatory fields and Get the Details
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create Process Queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueueWithMandatoryFields')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Update the process Queue
    And set updateProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | entityId        | processQueueResultResponse.header.entityId      |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandTypes[0]                                 |
      | entityName      | eventTypes[0]                                   |
      | ttl             |                                               0 |
    And set updateProcessQueueCommandToProcess
      | path        |                                                            0 |
      | id          | processQueueResultResponse.body.commandToProcess[0].id       |
      | sequence    | processQueueResultResponse.body.commandToProcess[0].sequence |
      | commandName | faker.getFirstName()                                         |
      | commandType | commandTypeList[0]                                           |
      | targetType  | targetTypeList[1]                                            |
      | targetUrl   | faker.getFirstName()                                         |
    And set updateProcessQueueCommandBody
      | path             |                                         0 |
      | id               | processQueueResultResponse.body.id        |
      | type             | queueType                                 |
      | queueCode        | processQueueResultResponse.body.queueCode |
      | queueName        | processQueueResultResponse.body.queueName |
      | isActive         | processQueueResultResponse.body.isActive  |
      | commandToProcess | updateProcessQueueCommandToProcess        |
    And set updateProcessQueuePayload
      | path   | [0]                                |
      | header | updateProcessQueueCommandHeader[0] |
      | body   | updateProcessQueueCommandBody[0]   |
    And print updateProcessQueuePayload
    And request updateProcessQueuePayload
    When method POST
    Then status 201
    And def updateProcessQueueResponse = response
    And print updateProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,processQueueCollectionName+<tenantid>,updateProcessQueueResponse.body.id)
    And print mongoResult
    And match mongoResult == updateProcessQueueResponse.body.id
    And match updateProcessQueueResponse.body.queueName == updateProcessQueuePayload.body.queueName
    And match updateProcessQueueResponse.body.commandToProcess[0].targetType == 1
    And match updateProcessQueueResponse.body.commandToProcess[0].targetUrl == updateProcessQueuePayload.body.commandToProcess[0].targetUrl
    #Get the updated process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[0]
    And set getProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[0]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateProcessQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateProcessQueueResponse.header.id            |
      | correlationId   | updateProcessQueueResponse.header.correlationId |
      | commandUserId   | updateProcessQueueResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[0]                                   |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getProcessQueueCommandBody
      | path |                                  0 |
      | id   | updateProcessQueueResponse.body.id |
    And set getProcessQueuePayload
      | path         | [0]                             |
      | header       | getProcessQueueCommandHeader[0] |
      | body.request | getProcessQueueCommandBody[0]   |
    And print getProcessQueuePayload
    And request getProcessQueuePayload
    When method POST
    Then status 200
    And def getProcessQueueResponse = response
    And print getProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,processQueueCollectionNameRead+<tenantid>,getProcessQueueResponse.id)
    And print mongoResult
    And match mongoResult == getProcessQueueResponse.id
    And match getProcessQueueResponse.commandToProcess[0].targetUrl == updateProcessQueueResponse.body.commandToProcess[0].targetUrl
    And match getProcessQueueResponse.type == updateProcessQueueResponse.body.type
    And match getProcessQueueResponse.commandToProcess[0].commandName == updateProcessQueueResponse.body.commandToProcess[0].commandName
    #Get All process Queues
    Given url readBaseWorkFlowUrl
    And path '/api/'+getProcess[1]
    And set getProcessQueuesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+getProcess[1]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateProcessQueueResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateProcessQueueResponse.header.id            |
      | correlationId   | updateProcessQueueResponse.header.correlationId |
      | commandUserId   | updateProcessQueueResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | getProcess[1]                                   |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getProcessQueuesCommandBody
      | path      |      0 |
      | queueName | "Test" |
    And set getProcessQueuesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getProcessQueuesPayload
      | path                | [0]                                  |
      | header              | getProcessQueuesCommandHeader[0]     |
      | body.request        | getProcessQueuesCommandBody[0]       |
      | body.paginationSort | getProcessQueuesCommandPagination[0] |
    And print getProcessQueuesPayload
    And request getProcessQueuesPayload
    When method POST
    Then status 200
    And def getProcessQueuesResponse = response
    And print getProcessQueuesResponse
    And match each getProcessQueuesResponse.results[*].description contains "Test"
    And match getProcessQueuesResponse.results[*].id contains getProcessQueueResponse.id
    And def getProcessQueuesResponseCount = karate.sizeOf(getProcessQueuesResponse.results)
    And print getProcessQueuesResponseCount
    And match getProcessQueuesResponseCount == getProcessQueuesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getProcessQueueResponse.id
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
    And def eventEntityID = getProcessQueuesResponse.id
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

  @UpdateProcessQueueWithInvalidDataToMandatoryDetails
  Scenario Outline: Update a Process queue with Invalid Data to Mandatory fields - target Type random value
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create Process Queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueueWithMandatoryFields')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Update the process Queue
    And set updateProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | entityId        | processQueueResultResponse.header.entityId      |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandTypes[0]                                 |
      | entityName      | eventTypes[0]                                   |
      | ttl             |                                               0 |
    And set updateProcessQueueCommandToProcess
      | path             |                                                                    0 |
      | id               | processQueueResultResponse.body.commandToProcess[0].id               |
      | sequence         | processQueueResultResponse.body.commandToProcess[0].sequence         |
      | commandName      | faker.getFirstName()                                                 |
      | commandType      | commandTypeList[0]                                                   |
      | isActive         | true                                                                 |
      | targetType       | faker.getFirstName()                                                 |
      | targetTopic.id   | processQueueResultResponse.body.commandToProcess[0].targetTopic.id   |
      | targetTopic.code | processQueueResultResponse.body.commandToProcess[0].targetTopic.code |
      | targetTopic.name | processQueueResultResponse.body.commandToProcess[0].targetTopic.name |
    And set updateProcessQueueCommandBody
      | path             |                                         0 |
      | id               | processQueueResultResponse.body.id        |
      | type             | queueType                                 |
      | queueCode        | processQueueResultResponse.body.queueCode |
      | queueName        | processQueueResultResponse.body.queueName |
      | isActive         | processQueueResultResponse.body.isActive  |
      | commandToProcess | updateProcessQueueCommandToProcess        |
    And set updateProcessQueuePayload
      | path   | [0]                                |
      | header | updateProcessQueueCommandHeader[0] |
      | body   | updateProcessQueueCommandBody[0]   |
    And print updateProcessQueuePayload
    And request updateProcessQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateProcessQueueWithMissingMandatoryDetails
  Scenario Outline: Update a Process queue with Missing Mandatory fields (Queue name)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Call the create Process Queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueueWithMandatoryFields')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Update the process Queue
    And set updateProcessQueueCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | processQueueResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | processQueueResultResponse.header.id            |
      | correlationId   | processQueueResultResponse.header.correlationId |
      | entityId        | processQueueResultResponse.header.entityId      |
      | commandUserId   | processQueueResultResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandTypes[0]                                 |
      | entityName      | eventTypes[0]                                   |
      | ttl             |                                               0 |
    And set updateProcessQueueCommandToProcess
      | path             |                                                               0 |
      | id               | processQueueResultResponse.commandToProcess[1].id               |
      | sequence         | processQueueResultResponse.commandToProcess[1].sequence         |
      | commandName      | faker.getFirstName()                                            |
      | commandType      | commandTypeList[0]                                              |
      | isActive         | true                                                            |
      | targetType       | targetTypeList[0]                                               |
      | targetTopic.id   | processQueueResultResponse.commandToProcess[1].targetTopic.id   |
      | targetTopic.code | faker.getUserId()                                               |
      | targetTopic.name | processQueueResultResponse.commandToProcess[1].targetTopic.name |
    And set updateProcessQueueCommandBody
      | path             |                                         0 |
      | id               | processQueueResultResponse.body.id        |
      | type             | queueType                                 |
      | queueCode        | processQueueResultResponse.body.queueCode |
      | isActive         | processQueueResultResponse.body.isActive  |
      | commandToProcess | updateProcessQueueCommandToProcess        |
    And set updateProcessQueuePayload
      | path   | [0]                                |
      | header | updateProcessQueueCommandHeader[0] |
      | body   | updateProcessQueueCommandBody[0]   |
    And print updateProcessQueuePayload
    And request updateProcessQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateProcessQueueDuplicate
  Scenario Outline: Create a Process queue with duplicate queue
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[1]
    #Call the create Process Queue
    And def processQueueResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/CreateProcessQueue.feature@CreateProcessQueueWithMandatoryFields')
    And def processQueueResultResponse = processQueueResult.response
    And print processQueueResultResponse
    #Retrieve the target Topic list
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    #Creating another process Queue
    And def entityIdData = dataGenerator.entityID()
    And set createProcessQueuecommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
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
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set createProcessQueueCommandToProcess
      | path             |                                          0 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createProcessQueueCommandBody
      | path             |                                         0 |
      | id               | entityIdData                              |
      | type             | queueType                                 |
      | queueCode        | processQueueResultResponse.body.queueCode |
      | queueName        | faker.getFirstName()                      |
      | isActive         | faker.getRandomBooleanValue()             |
      | commandToProcess | createProcessQueueCommandToProcess        |
    And set createProcessQueuePayload
      | path   | [0]                                |
      | header | createProcessQueuecommandHeader[0] |
      | body   | createProcessQueueCommandBody[0]   |
    And print createProcessQueuePayload
    And request createProcessQueuePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
