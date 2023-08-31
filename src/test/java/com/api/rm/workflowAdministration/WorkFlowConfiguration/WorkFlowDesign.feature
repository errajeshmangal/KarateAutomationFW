@WorkFlowConfigurationDesign
Feature: WorkFlow Configuration design - Create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createWorkFlowConfigStepCollectionName = 'CreateWorkflowConfigurationSteps_'
    And def createWorkFlowConfigStepCollectionNameRead = 'WorkflowConfigurationStepsDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateWorkflowConfigurationSteps','GetQueueConfigurations','GetWorkflowConfigurationSteps','UpdateWorkflowConfigurationSteps']
    And def entityName = 'WorkflowConfigurationSteps'
    And def historyAndComments = ['Created','Updated']
    And def queueType = ['DecisionPoint','Process','WorkWith']
    And def parentId = dataGenerator.generateUUIDs(3)
    And print parentId
    And def nextStepId = dataGenerator.generateUUIDs(1)
    And def nextStepId1 = dataGenerator.generateUUIDs(1)
    And def nextStepId2 = dataGenerator.generateUUIDs(1)
    And def nextStepId3 = dataGenerator.generateUUIDs(1)
    And def sequence = [1,2,3,4,3.1,3.2]

  @CreateWorkFlowDesignWithAllDetails
  Scenario Outline: Create a workflow design
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def type2 = queueType[2]
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
    And set createWorkFlowSteps
      | path       |                                                   2 |
      | id         | nextStepId1[0]                                      |
      | sequence   | sequence[2]                                         |
      | queueId    | getWorkWithQueueConfigurations.results[2].id        |
      | queueName  | getWorkWithQueueConfigurations.results[2].queueName |
      | queueType  | getWorkWithQueueConfigurations.results[2].type      |
      | parentId   | nextStepId[0]                                       |
      | nextStepId | nextStepId2                                         |
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
    Then status 201
    And def createWorkflowConfigurationStepsResponse = response
    And print createWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigStepCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkflowConfigurationStepsResponse.body.id
    And match createWorkflowConfigurationStepsResponse.body.id == createWorkflowConfigurationStepsPayload.body.id
    And match createWorkflowConfigurationStepsResponse.body.workflowConfigurationId == createWorkflowConfigurationStepsPayload.body.workflowConfigurationId
    And match createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName == createWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueName
    And match createWorkflowConfigurationStepsResponse.body.isActive == createWorkflowConfigurationStepsPayload.body.isActive
    And match createWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId == createWorkflowConfigurationStepsPayload.body.workflowSteps[1].parentId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignWithSingleQueue
  Scenario Outline: Create a workflow design with only single queue
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
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
    Then status 201
    And def createWorkflowConfigurationStepsResponse = response
    And print createWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigStepCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkflowConfigurationStepsResponse.body.id
    And match createWorkflowConfigurationStepsResponse.body.id == createWorkflowConfigurationStepsPayload.body.id
    And match createWorkflowConfigurationStepsResponse.body.workflowConfigurationId == createWorkflowConfigurationStepsPayload.body.workflowConfigurationId
    And match createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName == createWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueName
    And match createWorkflowConfigurationStepsResponse.body.isActive == createWorkflowConfigurationStepsPayload.body.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowDesignWithParallelProcessing
  Scenario Outline: Create a workflow design with parallel processing
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
    And def type = queueType[0]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type)'}
    And def getDecisionPointQueueConfigurations = result.response
    And print getDecisionPointQueueConfigurations
    And sleep(10000)
    And def type1 = queueType[1]
    And def result = call read('WorkFlowDesign.feature@GetQueueConfigurations'){type : '#(type1)'}
    And def getProcessQueueConfigurations = result.response
    And print getProcessQueueConfigurations
    And sleep(10000)
    And def type2 = queueType[2]
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
    # for sequence 1
    And set createWorkFlowSteps
      | path       |                                                  0 |
      | id         | parentId[0]                                        |
      | sequence   | sequence[0]                                        |
      | queueId    | getProcessQueueConfigurations.results[1].id        |
      | queueName  | getProcessQueueConfigurations.results[1].queueName |
      | queueType  | getProcessQueueConfigurations.results[1].type      |
      | nextStepId | nextStepId                                         |
    # for sequence 2
    And set createWorkFlowSteps
      | path       |                                                        1 |
      | id         | nextStepId[0]                                            |
      | sequence   | sequence[1]                                              |
      | queueId    | getDecisionPointQueueConfigurations.results[0].id        |
      | queueName  | getDecisionPointQueueConfigurations.results[0].queueName |
      | queueType  | getDecisionPointQueueConfigurations.results[0].type      |
      | parentId   | parentId[0]                                              |
      | nextStepId | nextStepId1                                              |
    #for sequence 3.1 //Yes (Parallel processing)
    And set createWorkFlowSteps
      | path       |                                                   2 |
      | id         | nextStepId1[0]                                      |
      | sequence   | sequence[4]                                         |
      | queueId    | getWorkWithQueueConfigurations.results[2].id        |
      | queueName  | getWorkWithQueueConfigurations.results[2].queueName |
      | queueType  | getWorkWithQueueConfigurations.results[2].type      |
      | parentId   | nextStepId[0]                                       |
      | nextStepId | nextStepId2                                         |
    #for sequence 3.2 //No (Parallel processing)
    And set createWorkFlowSteps
      | path       |                                                   3 |
      | id         | nextStepId1[0]                                      |
      | sequence   | sequence[5]                                         |
      | queueId    | getWorkWithQueueConfigurations.results[2].id        |
      | queueName  | getWorkWithQueueConfigurations.results[2].queueName |
      | queueType  | getWorkWithQueueConfigurations.results[2].type      |
      | parentId   | nextStepId[0]                                       |
      | nextStepId | nextStepId3                                         |
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
    Then status 201
    And def createWorkflowConfigurationStepsResponse = response
    And print createWorkflowConfigurationStepsResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigStepCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkflowConfigurationStepsResponse.body.id
    And match createWorkflowConfigurationStepsResponse.body.id == createWorkflowConfigurationStepsPayload.body.id
    And match createWorkflowConfigurationStepsResponse.body.workflowConfigurationId == createWorkflowConfigurationStepsPayload.body.workflowConfigurationId
    And match createWorkflowConfigurationStepsResponse.body.workflowSteps[0].queueName == createWorkflowConfigurationStepsPayload.body.workflowSteps[0].queueName
    And match createWorkflowConfigurationStepsResponse.body.isActive == createWorkflowConfigurationStepsPayload.body.isActive
    And match createWorkflowConfigurationStepsResponse.body.workflowSteps[1].parentId == createWorkflowConfigurationStepsPayload.body.workflowSteps[1].parentId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetWorkFlowDesign
  Scenario Outline: Get WorkFlow Design
    Given url readBaseWorkFlowUrl
    And def createWorkflowConfigurationStepsResponse = createWorkflowConfigurationStepsResponse
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetQueueConfigurations
  Scenario Outline: Get the Queue Configurations
    Given url readBaseWorkFlowUrl
    And path '/api/'+commandType[1]
    And set getQueueConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[1]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getQueueConfigurationsCommandBody
      | path     |    0 |
      | type     | type |
      | isActive | true |
    And set getQueueConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getQueueConfigurationsPayload
      | path                | [0]                                        |
      | header              | getQueueConfigurationsCommandHeader[0]     |
      | body.request        | getQueueConfigurationsCommandBody[0]       |
      | body.paginationSort | getQueueConfigurationsCommandPagination[0] |
    And print getQueueConfigurationsPayload
    And request getQueueConfigurationsPayload
    When method POST
    Then status 200
    And def getQueueConfigurationsResponse = response
    And print getQueueConfigurationsResponse
    And match each getQueueConfigurationsResponse.results[*].type contains type
    And match each getQueueConfigurationsResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
