# This feature file created to use the response of these scenarios in the E2E Decision Queue feature
Feature: Create Decision Queue - create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def queueType = 'DecisionPoint'
    And def getDecisionQueue = ['GetDecisionPointQueueConfiguration','GetQueueConfigurations']
    And def commandTypes = ['CreateDecisionPointQueueConfiguration']
    And def eventTypes = ['DecisionPointQueueConfiguration']
    And def historyAndComments = ['Created','Updated']
    And def decisionPointQueueCollectionName = 'CreateDecisionPointQueueConfiguration_'
    And def decisionPointQueueCollectionNameRead = 'DecisionPointQueueConfigurationDetailViewModel_'

  @CreateDecisionPointQueue
  Scenario Outline: Create a decision point queue with all the fields and Validate
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
      | path          |                                        0 |
      | inputCommand  | createDecisionPointQueueInputCommand[0]  |
      | inputResponse | createDecisionPointQueueInputResponse[0] |
    And set createDecisionPointQueueCommandBody
      | path                          |                                       0 |
      | id                            | entityIdData                            |
      | type                          | queueType                               |
      | queueCode                     | faker.getUserId()                       |
      | queueName                     | faker.getFirstName()                    |
      | description                   | faker.getLastName()                     |
      | isActive                      | faker.getRandomBoolean()                |
      | inputRequest                  | createDecisionPointQueueInputRequest[0] |
      | inputRequest.loop             | faker.getRandomBooleanValue()           |
      | inputRequest.filterExpression | "Age>18"                                |
      | inputRequest.id               | dataGenerator.Id()                      |
    And set createDecisionPointQueuePayload
      | path   | [0]                                      |
      | header | createDecisionPointQueuecommandHeader[0] |
      | body   | createDecisionPointQueueCommandBody[0]   |
    And print createDecisionPointQueuePayload
    And request createDecisionPointQueuePayload
    When method POST
    Then status 201
    And def createDecisionPointQueueResponse = response
    And print createDecisionPointQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,decisionPointQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createDecisionPointQueueResponse.body.id
    And match createDecisionPointQueueResponse.body.queueName == createDecisionPointQueuePayload.body.queueName
    And match createDecisionPointQueueResponse.body.inputRequest.inputCommand.name == createDecisionPointQueuePayload.body.inputRequest.inputCommand.name
    And match createDecisionPointQueueResponse.body.inputRequest.inputResponse.name == createDecisionPointQueuePayload.body.inputRequest.inputResponse.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDecisionPointQueueWithMandatoryFields
  Scenario Outline: Create a decision point queue with mandatory fields and Validate
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
      | id                            | entityIdData                            |
      | type                          | queueType                               |
      | queueCode                     | faker.getUserId()                       |
      | queueName                     | faker.getFirstName()                    |
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
    Then status 201
    And def createDecisionPointQueueResponse = response
    And print createDecisionPointQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,decisionPointQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createDecisionPointQueueResponse.body.id
    And match createDecisionPointQueueResponse.body.queueName == createDecisionPointQueuePayload.body.queueName
    And match createDecisionPointQueueResponse.body.inputRequest.inputCommand.code == createDecisionPointQueuePayload.body.inputRequest.inputCommand.code

    Examples: 
      | tenantid    |
      | tenantID[0] |
