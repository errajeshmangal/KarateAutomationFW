# This feature file created to use the response of these scenarios in the E2E WorkWith Queue feature
@WorkWithQueue
Feature: Create Work With Queue - create

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
    And def commandTypes = ['CreateWorkWithQueueConfiguration']
    And def eventTypes = ['WorkWithQueueConfiguration']
    And def historyAndComments = ['Created','Updated']
    And def actions = ['Reject','Accept','Save']

  @CreateWorkWithQueueCashiering
  Scenario Outline: Create a WorkWith queue with all the fields - WorkFlow Type (Cashiering)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
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
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | actions[0]       | actions[0]                                 |
    And set createWorkWithQueueCommandToProcess
      | path        |                                 1 |
      | id          | dataGenerator.Id()                |
      | sequence    |                                 1 |
      | commandName | faker.getFirstName()              |
      | commandType | commandTypeList[1]                |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | targetType  | targetTypeList[1]                 |
      | targetUrl   | faker.getFirstName()              |
      | actions[0]  | actions[1]                        |
    And set createWorkWithQueueCommandBody
      | path               |                                   0 |
      | id                 | entityIdData                        |
      | type               | queueType                           |
      | queueCode          | faker.getUserId()                   |
      | queueName          | faker.getFirstName()                |
      | workflowType       | workFlowType[0]                     |
      | genericLayout.id   | dataGenerator.Id()                  |
      | genericLayout.code | faker.getUserId()                   |
      | genericLayout.name | faker.getFirstName()                |
      | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | description        | faker.getLastName()                 |
      | isActive           | faker.getRandomBooleanValue()       |
      | commandToProcess   | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 201
    And def createWorkWithQueueResponse = response
    And print createWorkWithQueueResponse
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkWithQueueResponse.body.id
    And match createWorkWithQueueResponse.body.queueName == createWorkWithQueuePayload.body.queueName
    And match createWorkWithQueueResponse.body.queueCode == createWorkWithQueuePayload.body.queueCode
    And match createWorkWithQueueResponse.body.forms.code == createWorkWithQueuePayload.body.forms.code
    #And match createWorkWithQueueResponse.body.commandToProcess[0].actions[0] == notnull
    And match createWorkWithQueueResponse.body.workflowType == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueCasheringMandatoryFields
  Scenario Outline: Create a WorkWith queue with Mandatory fields - WorkFlow Type (Cashiering)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
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
      | actions[0]       | actions[1]                                 |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path               |                                   0 |
      | id                 | entityIdData                        |
      | type               | queueType                           |
      | queueCode          | faker.getUserId()                   |
      | queueName          | faker.getFirstName()                |
      | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | workflowType       | workFlowType[0]                     |
      | genericLayout.id   | dataGenerator.Id()                  |
      | genericLayout.code | faker.getUserId()                   |
      | genericLayout.name | faker.getFirstName()                |
      | isActive           | faker.getRandomBooleanValue()       |
      | commandToProcess   | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 201
    And def createWorkWithQueueResponse = response
    And print createWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkWithQueueResponse.body.id
    And match createWorkWithQueueResponse.body.queueName == createWorkWithQueuePayload.body.queueName
    And match createWorkWithQueueResponse.body.workflowType == 0
    And match createWorkWithQueueResponse.body.genericLayout.code == createWorkWithQueuePayload.body.genericLayout.code

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueIndexing
  Scenario Outline: Create a WorkWith queue with all the fields - WorkFlow Type (Indexing)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
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
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path               |                                   0 |
      | id                 | entityIdData                        |
      | type               | queueType                           |
      | queueCode          | faker.getUserId()                   |
      | queueName          | faker.getFirstName()                |
      | workflowType       | workFlowType[1]                     |
      | genericLayout.id   | dataGenerator.Id()                  |
      | genericLayout.code | faker.getUserId()                   |
      | genericLayout.name | faker.getFirstName()                |
      | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | description        | faker.getLastName()                 |
      | isActive           | faker.getRandomBooleanValue()       |
      | commandToProcess   | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 201
    And def createWorkWithQueueResponse = response
    And print createWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkWithQueueResponse.body.id
    And match createWorkWithQueueResponse.body.queueName == createWorkWithQueuePayload.body.queueName
    And match createWorkWithQueueResponse.body.workflowType == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkWithQueueIndexingMandatoryFields
  Scenario Outline: Create a WorkWith queue with Mandatory fields - WorkFlow Type (Cashiering)
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandTypes[0]
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
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[0]                         |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[0]                          |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandToProcess
      | path             |                                          1 |
      | id               | dataGenerator.Id()                         |
      | sequence         |                                          1 |
      | commandName      | faker.getFirstName()                       |
      | actions[0]       | actions[1]                                 |
      | commandType      | commandTypeList[1]                         |
      | isActive         | faker.getRandomBooleanValue()              |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
    And set createWorkWithQueueCommandBody
      | path               |                                   0 |
      | id                 | entityIdData                        |
      | type               | queueType                           |
      | queueCode          | faker.getUserId()                   |
      | queueName          | faker.getFirstName()                |
      | forms.id           | id                                  |
      | forms.code         | code                                |
      | forms.name         | name                                |
      | workflowType       | workFlowType[1]                     |
      | genericLayout.id   | dataGenerator.Id()                  |
      | genericLayout.code | faker.getUserId()                   |
      | genericLayout.name | faker.getFirstName()                |
      | isActive           | faker.getRandomBooleanValue()       |
      | commandToProcess   | createWorkWithQueueCommandToProcess |
    And set createWorkWithQueuePayload
      | path   | [0]                                 |
      | header | createWorkWithQueueCommandHeader[0] |
      | body   | createWorkWithQueueCommandBody[0]   |
    And print createWorkWithQueuePayload
    And request createWorkWithQueuePayload
    When method POST
    Then status 201
    And def createWorkWithQueueResponse = response
    And print createWorkWithQueueResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,workWithQueueCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkWithQueueResponse.body.id
    And match createWorkWithQueueResponse.body.queueName == createWorkWithQueuePayload.body.queueName
    And match createWorkWithQueueResponse.body.workflowType == 1
    And match createWorkWithQueueResponse.body.genericLayout.code == createWorkWithQueuePayload.body.genericLayout.code

    Examples: 
      | tenantid    |
      | tenantID[0] |
