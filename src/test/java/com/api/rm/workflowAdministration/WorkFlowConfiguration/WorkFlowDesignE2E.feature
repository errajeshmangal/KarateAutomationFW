@WorkFlowConfigurationDesignE2E
Feature: WorkFlow Configuration Design - Create,Update,View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createWorkFlowConfigStepCollectionName = 'CreateWorkflowConfigurationSteps_'
    And def workFlowConfigStepCollectionNameRead = 'WorkflowConfigurationStepsDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateWorkflowConfigurationSteps','GetQueueConfigurations','GetWorkflowConfigurationSteps','UpdateWorkflowConfigurationSteps']
    And def entityName = 'WorkflowConfigurationSteps'
    And def historyAndComments = ['Created','Updated']
    And def queueType = ['DecisionPoint','Process','WorkWith']
    And def parentId = dataGenerator.generateUUIDs(3)
    And def nextStepId = dataGenerator.generateUUIDs(1)
    And def nextStepId1 = dataGenerator.generateUUIDs(1)
    And def nextStepId2 = dataGenerator.generateUUIDs(1)
    And def nextStepId3 = dataGenerator.generateUUIDs(1)
    And def sequence = [1,2,3,4,3.1,3.2]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateWorkFlowDesignAndGetTheDetails
  Scenario Outline: Create a workflow design and get the details
    Given url readBaseWorkFlowUrl
    When path '/api/'+commandType[2]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithAllDetails')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And set getWorkflowConfigurationStepsCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | version         | "1.001"                                           |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | tenantId        | <tenantid>                                        |
      | ttl             |                                                 0 |
      | commandType     | commandType[2]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | tags            | []                                                |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | getType         | "One"                                             |
    And set getWorkflowConfigurationStepsCommandBody
      | path                    |                                                         0 |
      | workflowConfigurationId | createWorkflowConfigurationStepsResponse.body.workflowConfigurationId |
    And set getWorkflowConfigurationStepsPayload
      | path         | [0]                                           |
      | header       | getWorkflowConfigurationStepsCommandHeader[0] |
      | body.request | getWorkflowConfigurationStepsCommandBody[0]   |
    And print getWorkflowConfigurationStepsPayload
    And request getWorkflowConfigurationStepsPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getWorkflowConfigurationStepsResponse = response
    And print getWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workFlowConfigStepCollectionNameRead+<tenantid>,getWorkflowConfigurationStepsResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationStepsResponse.id
    And match getWorkflowConfigurationStepsResponse.id == createWorkflowConfigurationStepsResponse.body.id
    And match getWorkflowConfigurationStepsResponse.workflowConfigurationId == createWorkflowConfigurationStepsResponse.body.workflowConfigurationId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].id == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].id
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].nextStepId[0]
    And match getWorkflowConfigurationStepsResponse.isActive == createWorkflowConfigurationStepsResponse.body.isActive
    And match getWorkflowConfigurationStepsResponse.workflowSteps[1].parentId == createWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId
    #History Validation for Record Created
    #And def entityIdData = getWorkflowConfigurationStepsResponse.workflowConfigurationId
    #And def parentEntityId = getWorkflowConfigurationStepsResponse.workflowConfigurationId
    #And def eventName = entityName+historyAndComments[0]
    #And def evnentType = entityName
    #And def commandUserid = commandUserId
    #And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    #And def historyResponse = historyResult.response
    #And print historyResponse
    #And match historyResponse.results[*].entityId contains entityIdData
    #And match historyResponse.results[*].eventName contains eventName
    #And def entity = historyResponse.results[0].id
    #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    #And print mongoResult
    #And match mongoResult == entity
    #And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    #And print getHistoryResponseCount
    #And match getHistoryResponseCount == 2
    #Adding the comment
    #And def entityName = entityName
    #And def entityComment = faker.getRandomNumber()
    #And def eventEntityID = getWorkflowConfigurationStepsResponse.id
    #And def commandUserid = commandUserId
    #And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    #And def createCommentResponse = commentResult.response
    #And print createCommentResponse
    #And match createCommentResponse.body.comment == entityComment
    #updating the comments
    #And def updatedEntityComment = faker.getRandomNumber()
    #And def commentEntityID = createCommentResponse.body.id
    #And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    #And def updatedCommentResponse = updateCommentResult.response
    #And print updatedCommentResponse
    #And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    #And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentResponse = viewCommentResult.response
    #And print viewCommentResponse
    #And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    #And def evnentType = entityName
    #And def entityIdData = getWorkflowConfigurationStepsResponse.id
    #And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentsResponse = viewAllCommentResult.response
    #And print viewCommentsResponse
    #And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    #And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def deleteCommentsResponse = deleteCommentResult.response
    #And print deleteCommentsResponse
    #view the comment after delete
    #And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentResponse = viewCommentResult.response
    #And print viewCommentResponse
    #And match viewCommentResponse == 'null'
    #Get all the comments after delete
    #And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentsResponse = viewAllCommentResult.response
    #And print viewCommentsResponse
    #And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignHavingParallelProcessingAndGetTheDetails
  Scenario Outline: Create a workflow design having parallel processing and get the details
    Given url readBaseWorkFlowUrl
    When path '/api/'+commandType[2]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithParallelProcessing')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And set getWorkflowConfigurationStepsCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | version         | "1.001"                                           |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | tenantId        | <tenantid>                                        |
      | ttl             |                                                 0 |
      | commandType     | commandType[2]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | tags            | []                                                |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | getType         | "One"                                             |
    And set getWorkflowConfigurationStepsCommandBody
      | path                    |                                                         0 |
      | workflowConfigurationId | createWorkflowConfigurationStepsResponse.body.workflowConfigurationId |
    And set getWorkflowConfigurationStepsConfigurationPayload
      | path         | [0]                                           |
      | header       | getWorkflowConfigurationStepsCommandHeader[0] |
      | body.request | getWorkflowConfigurationStepsCommandBody[0]   |
    And print getWorkflowConfigurationStepsConfigurationPayload
    And request getWorkflowConfigurationStepsConfigurationPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getWorkflowConfigurationStepsResponse = response
    And print getWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workFlowConfigStepCollectionNameRead+<tenantid>,getWorkflowConfigurationStepsResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationStepsResponse.id
    And match getWorkflowConfigurationStepsResponse.id == createWorkflowConfigurationStepsResponse.body.id
    And match getWorkflowConfigurationStepsResponse.workflowConfigurationId == createWorkflowConfigurationStepsResponse.body.workflowConfigurationId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].id == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].id
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] == createWorkflowConfigurationStepsResponse.body.workflowSteps[0].nextStepId[0]
    And match getWorkflowConfigurationStepsResponse.isActive == createWorkflowConfigurationStepsResponse.body.isActive
    And match getWorkflowConfigurationStepsResponse.workflowSteps[1].parentId == createWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId
    
    #History Validation for Record Created
    And def entityIdData = getWorkflowConfigurationStepsResponse.workflowConfigurationId
    And def parentEntityId = getWorkflowConfigurationStepsResponse.id
    And def eventName = entityName+historyAndComments[0]
    And def evnentType = entityName
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
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkflowConfigurationStepsResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = entityName
    And def entityIdData = getWorkflowConfigurationStepsResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    #view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignWithInvalidDataToParentandId
  Scenario Outline: Create a workflow design with invalid data to id and parentId
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def  type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def  type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set createWorkflowConfigurationStepsHeader
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
      | entityId        | entityIdData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName                                  |
    And set createWorkFlowSteps
      | path       |                                                        0 |
      | id         | parentId[0]                                              |
      | sequence   | sequence[0]                                              |
      | queueId    | getDecisionPointQueueConfigurations.results[0].id        |
      | queueName  | getDecisionPointQueueConfigurations.results[0].queueName |
      | queueType  | getDecisionPointQueueConfigurations.results[0].type      |
      | nextStepId | nextStepId                                               |
    #passing the different id and parentId
    And set createWorkFlowSteps
      | path       |                                                  1 |
      | id         | nextStepId1[0]                                     |
      | sequence   | sequence[1]                                        |
      | queueId    | getProcessQueueConfigurations.results[1].id        |
      | queueName  | getProcessQueueConfigurations.results[1].queueName |
      | queueType  | getProcessQueueConfigurations.results[1].type      |
      | parentId   | parentId[1]                                        |
      | nextStepId | nextStepId2                                        |
    And set createWorkflowConfigurationStepsBody
      | path                    |                                           0 |
      | id                      | entityIdData                                |
      | workflowConfigurationId | createWorkflowConfigurationResponse.body.id |
      | workflowSteps           | createWorkFlowSteps                         |
      | isActive                | faker.getRandomBooleanValue()               |
    And set createWorkflowConfigurationStepsPayload
      | path   | [0]                                       |
      | header | createWorkflowConfigurationStepsHeader[0] |
      | body   | createWorkflowConfigurationStepsBody[0]   |
    And print createWorkflowConfigurationStepsPayload
    And request createWorkflowConfigurationStepsPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignWithInvalidData
  Scenario Outline: Create a workflow design with invalid data
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def  type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def  type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set createWorkflowConfigurationStepsHeader
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
      | entityId        | entityIdData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName                                  |
    # for sequence optional field instead of integer passing string format
    And set createWorkFlowSteps
      | path       |                                                        0 |
      | id         | parentId[0]                                              |
      | sequence   | ""                                                       |
      | queueId    | getDecisionPointQueueConfigurations.results[0].id        |
      | queueName  | getDecisionPointQueueConfigurations.results[0].queueName |
      | queueType  | getDecisionPointQueueConfigurations.results[0].type      |
      | nextStepId | nextStepId                                               |
    And set createWorkFlowSteps
      | path       |                                                  1 |
      | id         | nextStepId[0]                                      |
      | sequence   | sequence[1]                                        |
      | queueId    | getProcessQueueConfigurations.results[1].id        |
      | queueName  | getProcessQueueConfigurations.results[1].queueName |
      | queueType  | getProcessQueueConfigurations.results[1].type      |
      | parentId   | parentId[0]                                        |
      | nextStepId | nextStepId1                                        |
    And set createWorkflowConfigurationStepsBody
      | path                    |                                           0 |
      | id                      | entityIdData                                |
      | workflowConfigurationId | createWorkflowConfigurationResponse.body.id |
      | workflowSteps           | createWorkFlowSteps                         |
      | isActive                | faker.getRandomBooleanValue()               |
    And set createWorkflowConfigurationStepsPayload
      | path   | [0]                                       |
      | header | createWorkflowConfigurationStepsHeader[0] |
      | body   | createWorkflowConfigurationStepsBody[0]   |
    And print createWorkflowConfigurationStepsPayload
    And request createWorkflowConfigurationStepsPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignWithMissingData
  Scenario Outline: Create a workflow design with missing data
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def  type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def  type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def  type2 = queueType[2]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type2)'}
    And def getWorkWithQueueConfigurations = result.response
    And print getWorkWithQueueConfigurations
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set createWorkflowConfigurationStepsHeader
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
      | entityId        | entityIdData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName                                  |
    And set createWorkFlowSteps
      | path       |                                                        0 |
      | id         | parentId[0]                                              |
      | sequence   | sequence[0]                                              |
      | queueId    | getDecisionPointQueueConfigurations.results[0].id        |
      | queueName  | getDecisionPointQueueConfigurations.results[0].queueName |
      | queueType  | getDecisionPointQueueConfigurations.results[0].type      |
      | nextStepId | nextStepId                                               |
    And set createWorkFlowSteps
      | path       |                                                  1 |
      | id         | nextStepId[0]                                      |
      | sequence   | sequence[1]                                        |
      | queueId    | getProcessQueueConfigurations.results[1].id        |
      | queueName  | getProcessQueueConfigurations.results[1].queueName |
      | queueType  | getProcessQueueConfigurations.results[1].type      |
      | parentId   | parentId[0]                                        |
      | nextStepId | nextStepId1                                        |
    And set createWorkflowConfigurationStepsBody
      | path          |                             0 |
      | id            | entityIdData                  |
      #| workflowConfigurationId | createWorkflowConfigurationResponse.body.id |
      | workflowSteps | createWorkFlowSteps           |
      | isActive      | faker.getRandomBooleanValue() |
    And set createWorkflowConfigurationStepsPayload
      | path   | [0]                                       |
      | header | createWorkflowConfigurationStepsHeader[0] |
      | body   | createWorkflowConfigurationStepsBody[0]   |
    And print createWorkflowConfigurationStepsPayload
    And request createWorkflowConfigurationStepsPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowDesignWithAllDetailsAndGetTheDetails
  Scenario Outline: Update a workflow design with all details and get the details
    Given url commandBaseWorkFlowUrl
    When path '/api/'+commandType[3]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithAllDetails')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And def type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def result = call read('WorkFlowDesign.feature@GetWorkFlowDesign'){createWorkflowConfigurationStepsResponse : '#(createWorkflowConfigurationStepsResponse)'}
    And def getWorkflowConfigurationStepsResponse = result.response
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationStepsResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[3]                                                |
      | entityName      | entityName                                                    |
      | ttl             |                                                             0 |
    And set updateWorkFlowSteps
      | path       |                                                                 0 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].id         |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[0].sequence   |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId    |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName  |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueType  |
      | nextStepId | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId |
    And set updateWorkFlowSteps
      | path       |                                                                    1 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[1].sequence      |
      | queueId    | getProcessQueueConfigurations.results[2].id                          |
      | queueName  | getProcessQueueConfigurations.results[2].queueName                   |
      | queueType  | getProcessQueueConfigurations.results[2].type                        |
      | parentId   | getWorkflowConfigurationStepsResponse.workflowSteps[0].id            |
      | nextStepId | nextStepId1                                                          |
    And set updateWorkflowConfigurationStepsBody
      | path                    |                                                             0 |
      | id                      | getWorkflowConfigurationStepsResponse.id                      |
      | workflowConfigurationId | getWorkflowConfigurationStepsResponse.workflowConfigurationId |
      | workflowSteps           | updateWorkFlowSteps                                           |
      | isActive                | faker.getRandomBooleanValue()                                 |
    And set updateWorkflowConfigurationStepsPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationStepsBody[0]     |
    And print updateWorkflowConfigurationStepsPayload
    And request updateWorkflowConfigurationStepsPayload
    When method POST
    Then status 201
    And def updateWorkflowConfigurationStepsResponse = response
    And print updateWorkflowConfigurationStepsResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigStepCollectionName+<tenantid>,updateWorkflowConfigurationStepsResponse.body.id)
    And sleep(500)
    And print mongoResult
    And match mongoResult == updateWorkflowConfigurationStepsResponse.body.id
    And match updateWorkflowConfigurationStepsResponse.body.id == getWorkflowConfigurationStepsResponse.id
    And match updateWorkflowConfigurationStepsResponse.body.id == updateWorkflowConfigurationStepsPayload.body.id
    And match updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId == updateWorkflowConfigurationStepsPayload.body.workflowConfigurationId
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueName
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].id == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].id
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueId == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueId
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].nextStepId[0] == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].nextStepId[0]
    And match updateWorkflowConfigurationStepsResponse.body.isActive == updateWorkflowConfigurationStepsPayload.body.isActive
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId == updateWorkflowConfigurationStepsPayload.body.workflowSteps[1].parentId
    #get the details
    Given url readBaseWorkFlowUrl
    When path '/api/'+commandType[2]
    And set getWorkflowConfigurationStepsCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                   |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | commandType[2]                                                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | getType         | "One"                                                         |
    And set getWorkflowConfigurationStepsCommandBody
      | path                    |                                                                     0 |
      | workflowConfigurationId | updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId |
    And set getWorkflowConfigurationStepsConfigurationPayload
      | path         | [0]                                           |
      | header       | getWorkflowConfigurationStepsCommandHeader[0] |
      | body.request | getWorkflowConfigurationStepsCommandBody[0]   |
    And print getWorkflowConfigurationStepsConfigurationPayload
    And request getWorkflowConfigurationStepsConfigurationPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getWorkflowConfigurationStepsResponse = response
    And print getWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workFlowConfigStepCollectionNameRead+<tenantid>,getWorkflowConfigurationStepsResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationStepsResponse.id
    And match getWorkflowConfigurationStepsResponse.id == updateWorkflowConfigurationStepsResponse.body.id
    And match getWorkflowConfigurationStepsResponse.workflowConfigurationId == updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].id == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].id
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].nextStepId[0]
    And match getWorkflowConfigurationStepsResponse.isActive == updateWorkflowConfigurationStepsResponse.body.isActive
    And match getWorkflowConfigurationStepsResponse.workflowSteps[1].parentId == updateWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId
    
    #HistoryValidation for Record Updated
    #And def entityIdData = getWorkflowConfigurationStepsResponse.workflowConfigurationId
    #And def parentEntityId = getWorkflowConfigurationStepsResponse.id
    #And def eventName = entityName+historyAndComments[1]
    #And def evnentType = entityName
    #And def commandUserid = commandUserId
    #And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetWorkFlowEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    #And def historyResponse = historyResult.response
    #And print historyResponse
    #And match historyResponse.results[*].entityId contains entityIdData
    #And match historyResponse.results[*].eventName contains eventName
    #And def entity = historyResponse.results[0].id
    #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,historyCollectionNameRead+<tenantid>,entity)
    #And print mongoResult
    #And match mongoResult == entity
    #And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    #And print getHistoryResponseCount
    #And match getHistoryResponseCount == 3
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkflowConfigurationStepsResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = entityName
    And def entityIdData = getWorkflowConfigurationStepsResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    #view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowDesignWithSingleQueueAndGetTheDetails
  Scenario Outline: Update a workflow design with single queue and get the details
    Given url commandBaseWorkFlowUrl
    When path '/api/'+commandType[3]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithSingleQueue')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And def type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def result = call read('WorkFlowDesign.feature@GetWorkFlowDesign'){createWorkflowConfigurationStepsResponse : '#(createWorkflowConfigurationStepsResponse)'}
    And def getWorkflowConfigurationStepsResponse = result.response
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationStepsResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[3]                                                |
      | entityName      | entityName                                                    |
      | ttl             |                                                             0 |
    And set updateWorkFlowSteps
      | path       |                                                                 0 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].id         |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[0].sequence   |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId    |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName  |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueType  |
      | nextStepId | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId |
    And set updateWorkFlowSteps
      | path       |                                                                    1 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] |
      | sequence   | sequence[1]                                                          |
      | queueId    | getDecisionPointQueueConfigurations.results[0].id                    |
      | queueName  | getDecisionPointQueueConfigurations.results[0].queueName             |
      | queueType  | getDecisionPointQueueConfigurations.results[0].type                  |
      | parentId   | getWorkflowConfigurationStepsResponse.workflowSteps[0].id            |
      | nextStepId | nextStepId1                                                          |
    And set updateWorkflowConfigurationStepsBody
      | path                    |                                                             0 |
      | id                      | getWorkflowConfigurationStepsResponse.id                      |
      | workflowConfigurationId | getWorkflowConfigurationStepsResponse.workflowConfigurationId |
      | workflowSteps           | updateWorkFlowSteps                                           |
      | isActive                | faker.getRandomBooleanValue()                                 |
    And set updateWorkflowConfigurationStepsPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationStepsBody[0]     |
    And print updateWorkflowConfigurationStepsPayload
    And request updateWorkflowConfigurationStepsPayload
    When method POST
    Then status 201
    And def updateWorkflowConfigurationStepsResponse = response
    And print updateWorkflowConfigurationStepsResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigStepCollectionName+<tenantid>,updateWorkflowConfigurationStepsResponse.body.id)
    And print mongoResult
    And match mongoResult == updateWorkflowConfigurationStepsResponse.body.id
    And match updateWorkflowConfigurationStepsResponse.body.id == getWorkflowConfigurationStepsResponse.id
    And match updateWorkflowConfigurationStepsResponse.body.id == updateWorkflowConfigurationStepsPayload.body.id
    And match updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId == updateWorkflowConfigurationStepsPayload.body.workflowConfigurationId
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueName
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].id == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].id
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueId == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueId
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].nextStepId[0] == updateWorkflowConfigurationStepsPayload.body.workflowSteps[0].nextStepId[0]
    And match updateWorkflowConfigurationStepsResponse.body.isActive == updateWorkflowConfigurationStepsPayload.body.isActive
    And match updateWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId == updateWorkflowConfigurationStepsPayload.body.workflowSteps[1].parentId
    #get the details
    Given url readBaseWorkFlowUrl
    When path '/api/'+commandType[2]
    And set getWorkflowConfigurationStepsCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                   |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | commandType[2]                                                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | getType         | "One"                                                         |
    And set getWorkflowConfigurationStepsCommandBody
      | path                    |                                                                     0 |
      | workflowConfigurationId | updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId |
    And set getWorkflowConfigurationStepsConfigurationPayload
      | path         | [0]                                           |
      | header       | getWorkflowConfigurationStepsCommandHeader[0] |
      | body.request | getWorkflowConfigurationStepsCommandBody[0]   |
    And print getWorkflowConfigurationStepsConfigurationPayload
    And request getWorkflowConfigurationStepsConfigurationPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getWorkflowConfigurationStepsResponse = response
    And print getWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,workFlowConfigStepCollectionNameRead+<tenantid>,getWorkflowConfigurationStepsResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationStepsResponse.id
    And match updateWorkflowConfigurationStepsResponse.body.id == getWorkflowConfigurationStepsResponse.id
    And match getWorkflowConfigurationStepsResponse.workflowConfigurationId == updateWorkflowConfigurationStepsResponse.body.workflowConfigurationId
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName
    And match getWorkflowConfigurationStepsResponse.workflowSteps[0].id == updateWorkflowConfigurationStepsResponse.body.workflowSteps[0].id
    
    #HistoryValidation for Record Updated
    And def entityIdData = getWorkflowConfigurationStepsResponse.workflowConfigurationId
    And def parentEntityId = getWorkflowConfigurationStepsResponse.id
    And def eventName = entityName+historyAndComments[1]
    And def evnentType = entityName
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
    And match getHistoryResponseCount == 3
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getWorkflowConfigurationStepsResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = entityName
    And def entityIdData = getWorkflowConfigurationStepsResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    #view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/WorkFlowComments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowDesignWithInvalidDetails
  Scenario Outline: Update a workflow design and with invalid details
    Given url commandBaseWorkFlowUrl
    When path '/api/'+commandType[3]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithAllDetails')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And def result = call read('WorkFlowDesign.feature@GetWorkFlowDesign'){createWorkflowConfigurationStepsResponse : '#(createWorkflowConfigurationStepsResponse)'}
    And def getWorkflowConfigurationStepsResponse = result.response
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationStepsCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationStepsResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[3]                                                |
      | entityName      | entityName                                                    |
      | ttl             |                                                             0 |
    And set updateWorkFlowSteps
      | path       |                                                                 0 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].id         |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[0].sequence   |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId    |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName  |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueType  |
      | nextStepId | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId |
    And set updateWorkFlowSteps
      | path       |                                                                    1 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[1].sequence      |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueId       |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueName     |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueType     |
      | parentId   | getWorkflowConfigurationStepsResponse.workflowSteps[0].id            |
      | nextStepId | nextStepId1                                                          |
    And set updateWorkflowConfigurationStepsBody
      | path                    |                                                             0 |
      | id                      | faker.getRandomNumber()                                       |
      | workflowConfigurationId | getWorkflowConfigurationStepsResponse.workflowConfigurationId |
      | workflowSteps           | updateWorkFlowSteps                                           |
      | isActive                | faker.getRandomBooleanValue()                                 |
    And set updateWorkflowConfigurationStepsPayload
      | path   | [0]                                              |
      | header | updateWorkflowConfigurationStepsCommandHeader[0] |
      | body   | updateWorkflowConfigurationStepsBody[0]          |
    And print updateWorkflowConfigurationStepsPayload
    And request updateWorkflowConfigurationStepsPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowDesignWithMissingDetails
  Scenario Outline: Update a workflow design and with missing details
    Given url commandBaseWorkFlowUrl
    When path '/api/'+commandType[3]
    And def result = call read('WorkFlowDesign.feature@CreateWorkFlowDesignWithAllDetails')
    And def createWorkflowConfigurationStepsResponse = result.response
    And print createWorkflowConfigurationStepsResponse
    And sleep(10000)
    And def result = call read('WorkFlowDesign.feature@GetWorkFlowDesign'){createWorkflowConfigurationStepsResponse : '#(createWorkflowConfigurationStepsResponse)'}
    And def getWorkflowConfigurationStepsResponse = result.response
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationStepsCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createWorkflowConfigurationStepsResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createWorkflowConfigurationStepsResponse.header.id            |
      | correlationId   | createWorkflowConfigurationStepsResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationStepsResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationStepsResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[3]                                                |
      | entityName      | entityName                                                    |
      | ttl             |                                                             0 |
    And set updateWorkFlowSteps
      | path       |                                                                 0 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].id         |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[0].sequence   |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueId    |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueName  |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[0].queueType  |
      | nextStepId | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId |
    And set updateWorkFlowSteps
      | path       |                                                                    1 |
      | id         | getWorkflowConfigurationStepsResponse.workflowSteps[0].nextStepId[0] |
      | sequence   | getWorkflowConfigurationStepsResponse.workflowSteps[1].sequence      |
      | queueId    | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueId       |
      | queueName  | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueName     |
      | queueType  | getWorkflowConfigurationStepsResponse.workflowSteps[1].queueType     |
      | parentId   | getWorkflowConfigurationStepsResponse.workflowSteps[0].id            |
      | nextStepId | nextStepId1                                                          |
    And set updateWorkflowConfigurationStepsBody
      | path          |                             0 |
      | id            | faker.getRandomNumber()       |
      #| workflowConfigurationId | getWorkflowConfigurationStepsResponse.workflowConfigurationId |
      | workflowSteps | updateWorkFlowSteps           |
      | isActive      | faker.getRandomBooleanValue() |
    And set updateWorkflowConfigurationStepsPayload
      | path   | [0]                                              |
      | header | updateWorkflowConfigurationStepsCommandHeader[0] |
      | body   | updateWorkflowConfigurationStepsBody[0]          |
    And print updateWorkflowConfigurationStepsPayload
    And request updateWorkflowConfigurationStepsPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
