@CreateWorkFlowMasterInfoFeature
Feature: Create a WorkFlow Master Info tab

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createWorkFlowConfigCollectionName = 'CreateWorkflowConfiguration_'
    And def createWorkFlowConfigCollectionNameRead = 'WorkflowConfigurationDetailViewModel_'
    And def createERXSourceCollectionName = 'ElectronicRecordingSourceCreated_'
    And def createERXSourceCollectionNameRead = 'ElectronicRecordingSourceDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateWorkflowConfiguration','GetWorkflowConfiguration','GetWorkflowConfigurations','UpdateWorkflowConfiguration']
    And def entityName = 'WorkflowConfiguration'
    And def workFlowType = ['Cashiering','Indexing']

  @CreateWorkFlowConfigurationWithAllDetails
  Scenario Outline: Create a workflow configurations master info with all the fields
    Given url commandBaseWorkFlowUrl
    And path '/api/CreateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
    And def getDocumentClassResponse = result.response
    And print getDocumentClassResponse
    And sleep(10000)
    And def result = call read('CreateWorkFlow.feature@GetDocumentTypewithAllDetails')
    And def getDocumentTypesResponse = result.response
    And print getDocumentTypesResponse
    And sleep(10000)
    And def result = call read('CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result.response
    And print getElectronicRecordingSourceResponse
    And sleep(10000)
    And def entityIdData = dataGenerator.entityID()
    And set createWorkflowConfigurationHeader
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
    And set createWorkflowConfigurationDocumentClass
      | path |                                        0 |
      | id   | getDocumentClassResponse.results[0].id   |
      | code | getDocumentClassResponse.results[0].code |
      | name | getDocumentClassResponse.results[0].name |
    And set createWorkflowConfigurationDocumentTypes
      | path |                                                           0 |
      | id   | getDocumentTypesResponse.results[0].id                      |
      | code | getDocumentTypesResponse.results[0].documentTypeCode        |
      | name | getDocumentTypesResponse.results[0].documentTypeDescription |
    And set createWorkflowConfigurationDocumentTypes
      | path |                                                           1 |
      | id   | getDocumentTypesResponse.results[1].id                      |
      | code | getDocumentTypesResponse.results[1].documentTypeCode        |
      | name | getDocumentTypesResponse.results[1].documentTypeDescription |
    And set createWorkflowConfigurationSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set createWorkflowConfigurationSource
      | path |                                                    1 |
      | id   | getElectronicRecordingSourceResponse.results[1].id   |
      | code | getElectronicRecordingSourceResponse.results[1].code |
      | name | getElectronicRecordingSourceResponse.results[1].name |
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | entityIdData                                |
      | workflowConfigurationCode | faker.getUserId()                           |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | dataGenerator.generateCurrentDateTime()     |
      | workflowType              | faker.getRandomWorkFlowType()               |
      | isActive                  | faker.getRandomBooleanValue()               |
      | documentClass             | createWorkflowConfigurationDocumentClass[0] |
      | documentTypes             | createWorkflowConfigurationDocumentTypes    |
      | source                    | createWorkflowConfigurationSource           |
    And set createWorkflowConfigurationPayload
      | path   | [0]                                  |
      | header | createWorkflowConfigurationHeader[0] |
      | body   | createWorkflowConfigurationBody[0]   |
    And print createWorkflowConfigurationPayload
    And request createWorkflowConfigurationPayload
    When method POST
    Then status 201
    And def createWorkflowConfigurationResponse = response
    And print createWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkflowConfigurationResponse.body.id
    And match createWorkflowConfigurationResponse.body.workflowConfigurationCode == createWorkflowConfigurationPayload.body.workflowConfigurationCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowConfigurationWithMandatoryFields
  Scenario Outline: Create a workflow configurations master info with mandatory fields and Validate
    Given url commandBaseWorkFlowUrl
    And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
    And def getDocumentClassResponse = result.response
    And print getDocumentClassResponse
    And sleep(10000)
    And def result = call read('CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result.response
    And print getElectronicRecordingSourceResponse
    And sleep(10000)
    And path '/api/CreateWorkflowConfiguration'
    And def entityIdData = dataGenerator.entityID()
    And set createWorkflowConfigurationHeader
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
    And set createWorkflowConfigurationDocumentClass
      | path |                                        0 |
      | id   | getDocumentClassResponse.results[0].id   |
      | code | getDocumentClassResponse.results[0].code |
      | name | getDocumentClassResponse.results[0].name |
    And set createWorkflowConfigurationSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set createWorkflowConfigurationSource
      | path |                                                    1 |
      | id   | getElectronicRecordingSourceResponse.results[1].id   |
      | code | getElectronicRecordingSourceResponse.results[1].code |
      | name | getElectronicRecordingSourceResponse.results[1].name |
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | entityIdData                                |
      | workflowConfigurationCode | faker.getUserId()                           |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | dataGenerator.generateCurrentDateTime()     |
      #| effectiveDate             | faker.getRandomDate()                       |
      | workflowType              | faker.getRandomWorkFlowType()               |
      | isActive                  | faker.getRandomBooleanValue()               |
      | documentClass             | createWorkflowConfigurationDocumentClass[0] |
      | source                    | createWorkflowConfigurationSource           |
    And set createWorkflowConfigurationPayload
      | path   | [0]                                  |
      | header | createWorkflowConfigurationHeader[0] |
      | body   | createWorkflowConfigurationBody[0]   |
    And print createWorkflowConfigurationPayload
    And request createWorkflowConfigurationPayload
    When method POST
    Then status 201
    And def createWorkflowConfigurationResponse = response
    And print createWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createWorkflowConfigurationResponse.body.id
    And match createWorkflowConfigurationResponse.body.documentClass.name == createWorkflowConfigurationPayload.body.documentClass.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #@CreateWorkFlowConfigurationToCheckPriority
  #Scenario Outline: Create a WorkFlow Configuration to check if a specific document type is selected that document will be taken precedence and it will override the existing workflow with all document types
    #Given url commandBaseWorkFlowUrl
    #And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    #And def createWorkflowConfigurationResponse = result.response
    #And print createWorkflowConfigurationResponse
    #And def idToBeMatched = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,createWorkflowConfigurationResponse.body.id)
    #And print idToBeMatched
    #And def result = call read('CreateWorkFlow.feature@GetDocumentTypewithAllDetails')
    #And def getDocumentTypesResponse = result.response
    #And print getDocumentTypesResponse
    #And sleep(10000)
    #And path '/api/CreateWorkflowConfiguration'
    #And def entityIdData = dataGenerator.entityID()
    #And set createWorkflowConfigurationHeader
      #| path            |                                           0 |
      #| schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      #| version         | "1.001"                                     |
      #| sourceId        | dataGenerator.SourceID()                    |
      #| id              | dataGenerator.Id()                          |
      #| correlationId   | dataGenerator.correlationId()               |
      #| tenantId        | <tenantid>                                  |
      #| ttl             |                                           0 |
      #| commandType     | commandType[0]                              |
      #| commandDateTime | dataGenerator.generateCurrentDateTime()     |
      #| tags            | []                                          |
      #| entityVersion   |                                           1 |
      #| entityId        | entityIdData                                |
      #| commandUserId   | commandUserId                               |
      #| entityName      | entityName                                  |
    #And set createWorkflowConfigurationDocumentClass
      #| path |                                                           0 |
      #| id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      #| code | createWorkflowConfigurationResponse.body.documentClass.code |
      #| name | createWorkflowConfigurationResponse.body.documentClass.name |
    #And set createWorkflowConfigurationDocumentTypes
      #| path |                                                           0 |
      #| id   | getDocumentTypesResponse.results[0].id                      |
      #| code | getDocumentTypesResponse.results[0].documentTypeCode        |
      #| name | getDocumentTypesResponse.results[0].documentTypeDescription |
    #And set createWorkflowConfigurationSource
      #| path |                                                       0 |
      #| id   | createWorkflowConfigurationResponse.body.source[0].id   |
      #| code | createWorkflowConfigurationResponse.body.source[0].code |
      #| name | createWorkflowConfigurationResponse.body.source[0].name |
    #And set createWorkflowConfigurationBody
      #| path                      |                                                                  0 |
      #| id                        | entityIdData                                                       |
      #| workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      #| workflowConfigurationName | faker.getFirstName()                                               |
      #| effectiveDate             | createWorkflowConfigurationResponse.body.effectiveDate             |
      #| workflowType              | createWorkflowConfigurationResponse.body.workflowType              |
      #| isActive                  | createWorkflowConfigurationResponse.body.isActive                  |
      #| documentClass             | createWorkflowConfigurationDocumentClass[0]                        |
      #| documentTypes             | createWorkflowConfigurationDocumentTypes                           |
      #| source                    | createWorkflowConfigurationSource                                  |
    #And set createWorkflowConfigurationPayload
      #| path   | [0]                                  |
      #| header | createWorkflowConfigurationHeader[0] |
      #| body   | createWorkflowConfigurationBody[0]   |
    #And print createWorkflowConfigurationPayload
    #And request createWorkflowConfigurationPayload
    #When method POST
    #Then status 201
    #And def createWorkflowConfigurationResponse1 = response
    #And print createWorkflowConfigurationResponse1
    #verify that the first created workflow is deleted
    #And match mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,idToBeMatched)!contains idToBeMatched
    #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
    #And match mongoResult == createWorkflowConfigurationResponse.body.id
    #And print mongoResult
#
    #Examples: 
      #| tenantid    |
      #| tenantID[0] |

  @GetWorkFlowConfiguration
  Scenario Outline: Get a workflow configuration
    Given url readBaseWorkFlowUrl
    When path '/api/GetWorkflowConfiguration'
    And def createWorkflowConfigurationResponse =
    And set getWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"              |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | tenantId        | <tenantid>                                               |
      | ttl             |                                                        0 |
      | commandType     | commandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | tags            | []                                                       |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | getType         | "One"                                                    |
    And set getWorkflowConfigurationCommandBody
      | path |                                           0 |
      | id   | createWorkflowConfigurationResponse.body.id |
    And set getWorkflowConfigurationPayload
      | path         | [0]                                      |
      | header       | getWorkflowConfigurationCommandHeader[0] |
      | body.request | getWorkflowConfigurationCommandBody[0]   |
    And print getWorkflowConfigurationPayload
    And request getWorkflowConfigurationPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getWorkflowConfigurationResponse = response
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    And match getWorkflowConfigurationResponse.documentTypes[0].name == createWorkflowConfigurationResponse.body.documentTypes[0].name
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
  @CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails
  Scenario Outline: Create a Electronic Recording Source with all the fields
    #Given url commandBaseWorkFlowUrl
    #And path '/api/CreateElectronicRecordingSource'
    #And def entityIdData = dataGenerator.entityID()
    #And set createElectronicRecordingSourceHeader
    #| path            |                                                        0 |
    #| schemaUri       | schemaUri+"/CreateElectronicRecordingSource-v1.001.json" |
    #| version         | "1.001"                                                  |
    #| sourceId        | dataGenerator.SourceID()                                 |
    #| id              | dataGenerator.Id()                                       |
    #| correlationId   | dataGenerator.correlationId()                            |
    #| tenantId        | <tenantid>                                               |
    #| ttl             |                                                        0 |
    #| commandType     | "CreateElectronicRecordingSource"                        |
    #| commandDateTime | dataGenerator.generateCurrentDateTime()                  |
    #| tags            | []                                                       |
    #| entityVersion   |                                                        1 |
    #| entityId        | entityIdData                                             |
    #| commandUserId   | commandUserId                                            |
    #| entityName      | "ElectronicRecordingSource"                              |
    #And set createElectronicRecordingSourceBody
    #| path        |                             0 |
    #| id          | entityIdData                  |
    #| code        | faker.getFirstName()          |
    #| name        | faker.getFirstName()          |
    #| description | faker.getFirstName()          |
    #| isActive    | faker.getRandomBooleanValue() |
    #And set createElectronicRecordingSourcePayload
    #| path   | [0]                                      |
    #| header | createElectronicRecordingSourceHeader[0] |
    #| body   | createElectronicRecordingSourceBody[0]   |
    #And print createElectronicRecordingSourcePayload
    #And request createElectronicRecordingSourcePayload
    #When method POST
    #Then status 201
    #And def createElectronicRecordingSourceResponse = response
    #And print createElectronicRecordingSourceResponse
    #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createERXSourceCollectionName+<tenantid>,entityIdData)
    #And print mongoResult
    Given url readBaseWorkFlowUrl
    When path '/api/GetElectronicRecordingSources'
    And sleep(10000)
    And set getElectronicRecordingSourcesCommandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/GetElectronicRecordingSources-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantId        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | "GetElectronicRecordingSources"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | commandUserId   | dataGenerator.commandUserId()                          |
      | getType         | "Array"                                                |
    And set getElectronicRecordingSourcesCommandBody
      | path     |    0 |
      | id       |      |
      | code     |      |
      | name     |      |
      | isActive | true |
    And set getElectronicRecordingSourcesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | true              |
    And set getElectronicRecordingSourcesPayload
      | path                | [0]                                               |
      | header              | getElectronicRecordingSourcesCommandHeader[0]     |
      | body.request        | getElectronicRecordingSourcesCommandBody[0]       |
      | body.paginationSort | getElectronicRecordingSourcesCommandPagination[0] |
    And print getElectronicRecordingSourcesPayload
    And request getElectronicRecordingSourcesPayload
    When method POST
    Then status 200
    And sleep(20000)
    And def getElectronicRecordingSourcesResponse = response
    And print getElectronicRecordingSourcesResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createERXSourceCollectionNameRead+<tenantid>,getElectronicRecordingSourcesResponse.id)
    And print mongoResult

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypewithAllDetails
  Scenario Outline: Get the document types master info details
    Given url readBaseUrl
    When path '/api/GetDocumentTypeMasterInfos'
    And set getDocumentTypeCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | dataGenerator.SourceID()                            |
      | tenantId        | <tenantid>                                          |
      | id              | dataGenerator.Id()                                  |
      | correlationId   | dataGenerator.correlationId()                       |
      | getType         | "Array"                                             |
      | commandUserId   | dataGenerator.commandUserId()                       |
      | tags            | []                                                  |
      | commandType     | "GetDocumentTypeMasterInfos"                        |
      | ttl             |                                                   0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |    0 |
      | documentTypeId          |      |
      | documentTypeDescription |      |
      | department              |      |
      | area                    |      |
      | isActive                | true |
      | lastUpdatedDateTime     |      |
    And set getDocumentTypeCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And sleep(20000)
    And def getDocumentTypesCommandResponse = response
    And print getDocumentTypesCommandResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #Get the Document Classes are displayed based on Selected Active Area
  @GetDocumentClassBasedOnSelectedArea
  Scenario Outline: Get Document class for Selected active Area
    Given url readBaseUrl
    And path '/api/GetDocumentClassesByCountyArea'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/GetDocumentClassesByCountyArea-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | commandUserId   | dataGenerator.commandUserId()                           |
      | tags            | []                                                      |
      | commandType     | "GetDocumentClassesByCountyArea"                        |
      | getType         | "Array"                                                 |
      | ttl             |                                                       0 |
    And set commandBodyRequest
      | path         |            0 |
      | code         |              |
      | isActive     | true         |
      | countyAreaId | countyAreaId |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentClassesPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getDocumentClassesPayload
    And request getDocumentClassesPayload
    When method POST
    Then status 200
    And sleep(20000)

    Examples: 
      | tenantid    |
      | tenantID[0] |
  #@CreateIndexingWorkFlowConfigurationWithAllDetails
  #Scenario Outline: Create a Indexing workflow configurations master info with all the fields
  #Given url commandBaseWorkFlowUrl
  #And path '/api/CreateWorkflowConfiguration'
  #And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
  #And def getDocumentClassResponse = result.response
  #And print getDocumentClassResponse
  #And sleep(10000)
  #And def result = call read('CreateWorkFlow.feature@GetDocumentTypewithAllDetails')
  #And def getDocumentTypesResponse = result.response
  #And print getDocumentTypesResponse
  #And sleep(10000)
  #And def result = call read('CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
  #And def getElectronicRecordingSourceResponse = result.response
  #And print getElectronicRecordingSourceResponse
  #And sleep(10000)
  #And def entityIdData = dataGenerator.entityID()
  #And set createIndexingWorkflowConfigurationHeader
  #| path            |                                           0 |
  #| schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
  #| version         | "1.001"                                     |
  #| sourceId        | dataGenerator.SourceID()                    |
  #| id              | dataGenerator.Id()                          |
  #| correlationId   | dataGenerator.correlationId()               |
  #| tenantId        | <tenantid>                                  |
  #| ttl             |                                           0 |
  #| commandType     | commandType[0]                              |
  #| commandDateTime | dataGenerator.generateCurrentDateTime()     |
  #| tags            | []                                          |
  #| entityVersion   |                                           1 |
  #| entityId        | entityIdData                                |
  #| commandUserId   | commandUserId                               |
  #| entityName      | entityName                                  |
  #And set createIndexingWorkflowConfigurationDocumentClass
  #| path |                                        0 |
  #| id   | getDocumentClassResponse.results[0].id   |
  #| code | getDocumentClassResponse.results[0].code |
  #| name | getDocumentClassResponse.results[0].name |
  #And set createIndexingWorkflowConfigurationDocumentTypes
  #| path |                                                           0 |
  #| id   | getDocumentTypesResponse.results[0].id                      |
  #| code | getDocumentTypesResponse.results[0].documentTypeCode        |
  #| name | getDocumentTypesResponse.results[0].documentTypeDescription |
  #And set createIndexingWorkflowConfigurationDocumentTypes
  #| path |                                                           1 |
  #| id   | getDocumentTypesResponse.results[1].id                      |
  #| code | getDocumentTypesResponse.results[1].documentTypeCode        |
  #| name | getDocumentTypesResponse.results[1].documentTypeDescription |
  #And set createIndexingWorkflowConfigurationSource
  #| path |                                                    0 |
  #| id   | getElectronicRecordingSourceResponse.results[0].id   |
  #| code | getElectronicRecordingSourceResponse.results[0].code |
  #| name | getElectronicRecordingSourceResponse.results[0].name |
  #And set createIndexingWorkflowConfigurationSource
  #| path |                                                    1 |
  #| id   | getElectronicRecordingSourceResponse.results[1].id   |
  #| code | getElectronicRecordingSourceResponse.results[1].code |
  #| name | getElectronicRecordingSourceResponse.results[1].name |
  #And set createIndexingWorkflowConfigurationBody
  #| path                      |                                                   0 |
  #| id                        | entityIdData                                        |
  #| workflowConfigurationCode | faker.getFirstName()                                |
  #| workflowConfigurationName | faker.getFirstName()                                |
  #| effectiveDate             | faker.getRandomDate()                               |
  #| workflowType              | workFlowType[1]                                     |
  #| isActive                  | faker.getRandomBooleanValue()                       |
  #| documentClass             | createIndexingWorkflowConfigurationDocumentClass[0] |
  #| documentTypes             | createIndexingWorkflowConfigurationDocumentTypes    |
  #| source                    | createIndexingWorkflowConfigurationSource           |
  #And set createIndexingWorkflowConfigurationPayload
  #| path   | [0]                                          |
  #| header | createIndexingWorkflowConfigurationHeader[0] |
  #| body   | createIndexingWorkflowConfigurationBody[0]   |
  #And print createIndexingWorkflowConfigurationPayload
  #And request createIndexingWorkflowConfigurationPayload
  #When method POST
  #Then status 201
  #And def createIndexingWorkflowConfigurationResponse = response
  #And print createIndexingWorkflowConfigurationResponse
  #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
  #And print mongoResult
  #And match mongoResult == createIndexingWorkflowConfigurationResponse.body.id
  #And match createIndexingWorkflowConfigurationResponse.body.documentTypes[0].id == createIndexingWorkflowConfigurationPayload.body.documentTypes[0].id
  #
  #Examples:
  #| tenantid    |
  #| tenantID[0] |
  #
  #@CreateIndexingWorkFlowConfigurationWithMandatoryFields
  #Scenario Outline: Create a indexing workflow configurations master info with mandatory fields and Validate
  #Given url commandBaseWorkFlowUrl
  #And path '/api/CreateWorkflowConfiguration'
  #And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
  #And def getDocumentClassResponse = result.response
  #And print getDocumentClassResponse
  #And sleep(10000)
  #And def result = call read('CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
  #And def getElectronicRecordingSourceResponse = result.response
  #And print getElectronicRecordingSourceResponse
  #And sleep(10000)
  #And def entityIdData = dataGenerator.entityID()
  #And set createIndexingWorkflowConfigurationHeader
  #| path            |                                           0 |
  #| schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
  #| version         | "1.001"                                     |
  #| sourceId        | dataGenerator.SourceID()                    |
  #| id              | dataGenerator.Id()                          |
  #| correlationId   | dataGenerator.correlationId()               |
  #| tenantId        | <tenantid>                                  |
  #| ttl             |                                           0 |
  #| commandType     | commandType[0]                              |
  #| commandDateTime | dataGenerator.generateCurrentDateTime()     |
  #| tags            | []                                          |
  #| entityVersion   |                                           1 |
  #| entityId        | entityIdData                                |
  #| commandUserId   | commandUserId                               |
  #| entityName      | entityName                                  |
  #And set createIndexingWorkflowConfigurationDocumentClass
  #| path |                                        0 |
  #| id   | getDocumentClassResponse.results[0].id   |
  #| code | getDocumentClassResponse.results[0].code |
  #| name | getDocumentClassResponse.results[0].name |
  #And set createIndexingWorkflowConfigurationSource
  #| path |                                                    0 |
  #| id   | getElectronicRecordingSourceResponse.results[0].id   |
  #| code | getElectronicRecordingSourceResponse.results[0].code |
  #| name | getElectronicRecordingSourceResponse.results[0].name |
  #And set createIndexingWorkflowConfigurationSource
  #| path |                                                    1 |
  #| id   | getElectronicRecordingSourceResponse.results[1].id   |
  #| code | getElectronicRecordingSourceResponse.results[1].code |
  #| name | getElectronicRecordingSourceResponse.results[1].name |
  #And set createIndexingWorkflowConfigurationBody
  #| path                      |                                                   0 |
  #| id                        | entityIdData                                        |
  #| workflowConfigurationCode | faker.getFirstName()                                |
  #| workflowConfigurationName | faker.getFirstName()                                |
  #| effectiveDate             | faker.getRandomDate()                               |
  #| workflowType              | workFlowType[1]                                     |
  #| isActive                  | faker.getRandomBooleanValue()                       |
  #| documentClass             | createIndexingWorkflowConfigurationDocumentClass[0] |
  #| source                    | createIndexingWorkflowConfigurationSource           |
  #And set createIndexingWorkflowConfigurationPayload
  #| path   | [0]                                          |
  #| header | createIndexingWorkflowConfigurationHeader[0] |
  #| body   | createIndexingWorkflowConfigurationBody[0]   |
  #And print createIndexingWorkflowConfigurationPayload
  #And request createIndexingWorkflowConfigurationPayload
  #When method POST
  #Then status 201
  #And def createIndexingWorkflowConfigurationResponse = response
  #And print createIndexingWorkflowConfigurationResponse
  #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
  #And print mongoResult
  #And match mongoResult == createIndexingWorkflowConfigurationResponse.body.id
  #And match createIndexingWorkflowConfigurationResponse.body.documentClass.code == createIndexingWorkflowConfigurationPayload.body.documentClass.code
  #
  #Examples:
  #| tenantid    |
  #| tenantID[0] |
