# This feature file created to use the response of these scenarios in the E2E Process Queue feature
Feature: Create Process Queue - create

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
    And def targetTypeList = ['Topic','Url']
    And def commandTypes = ['CreateProcessQueueConfiguration']
    And def eventTypes = ['ProcessQueueConfiguration']

  @CreateProcessQueue
  Scenario Outline: Create a Process  queue with all the fields and Validate
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createProcessQueuecommandHeader
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
    And set createProcessQueueCommandToProcess
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          2 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createProcessQueueCommandToProcess
      | path        |                                 1 |
      | id          | dataGenerator.Id()                |
      | sequence    |                                 1 |
      | commandName | faker.getFirstName()              |
      | commandType | commandTypeList[1]                |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | targetType  | targetTypeList[1]                 |
      | targetUrl   | faker.getUserId()                 |
    And set createProcessQueueCommandBody
      | path             |                                  0 |
      | id               | entityIdData                       |
      | type             | queueType                          |
      | queueCode        | faker.getUserId()                  |
      | queueName        | faker.getFirstName()               |
      | description      | faker.getRandomShortDescription()  |
      | isActive         | faker.getRandomBooleanValue()      |
      | commandToProcess | createProcessQueueCommandToProcess |
    And set createProcessQueuePayload
      | path   | [0]                                |
      | header | createProcessQueuecommandHeader[0] |
      | body   | createProcessQueueCommandBody[0]   |
    And print createProcessQueuePayload
    And request createProcessQueuePayload
    When method POST
    Then status 201
    And def createProcessQueueResponse = response
    And print createProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,processQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createProcessQueueResponse.body.id
    And match createProcessQueueResponse.body.queueName == createProcessQueuePayload.body.queueName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateProcessQueueWithMandatoryFields
  Scenario Outline: Create a Process  queue with all the Mandatory fields and Validate
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    And def entityIdData = dataGenerator.entityID()
    And set createProcessQueuecommandHeader
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
    Then status 201
    And def createProcessQueueResponse = response
    And print createProcessQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,processQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createProcessQueueResponse.body.id
    And match createProcessQueueResponse.body.queueName == createProcessQueuePayload.body.queueName
    And match createProcessQueueResponse.body.commandToProcess[0].targetTopic.code == createProcessQueuePayload.body.commandToProcess[0].targetTopic.code

    Examples: 
      | tenantid    |
      | tenantID[0] |
