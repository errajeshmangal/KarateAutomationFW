@WorkFlowConfigurationMasterInfoE2EFeature
Feature: WorkFlow Configuration Master Info - Create,Edit,Get,GetAll,Duplicate

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createWorkFlowConfigCollectionName = 'CreateWorkflowConfiguration_'
    And def createWorkFlowConfigCollectionNameRead = 'WorkflowConfigurationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateWorkflowConfiguration','GetWorkflowConfiguration','GetWorkflowConfigurations','UpdateWorkflowConfiguration']
    And def entityName = 'WorkflowConfiguration'
    And def workFlowType = ['Cashiering','Indexing']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateWorkFlowConfigurationWithAllDetailsAndGetTheDetails
  Scenario Outline: Create a workflow configurations with all the fields and get the details
    Given url readBaseWorkFlowUrl
    When path '/api/GetWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    And match getWorkflowConfigurationResponse.documentTypes[0].name == createWorkflowConfigurationResponse.body.documentTypes[0].name
    #Get All workflow configurations
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      | 0 |
      | id                        |   |
      | workflowConfigurationCode |   |
      | workflowConfigurationName |   |
      | effectiveDate             |   |
      | documentClass             |   |
      | documentType              |   |
      | source                    |   |
      | isActive                  |   |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                           |
      | header              | getWorkflowConfigurationsCommandHeader[0]     |
      | body.request        | {}                                            |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0] |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And def getWorkflowConfigurationsResponseCount = karate.sizeOf(getWorkflowConfigurationsResponse.results)
    And print getWorkflowConfigurationsResponseCount
    And match getWorkflowConfigurationsResponseCount == getWorkflowConfigurationsResponse.totalRecordCount
    And assert getWorkflowConfigurationsResponseCount > 0
    #Get All workflow configurations
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                              0 |
      | id                        |                                                                |
      | workflowConfigurationCode |                                                                |
      | workflowConfigurationName |                                                                |
      | effectiveDate             |                                                                |
      | documentClass             | createWorkflowConfigurationResponse.body.documentClass.name    |
      | documentType              | createWorkflowConfigurationResponse.body.documentTypes[0].name |
      | source                    | createWorkflowConfigurationResponse.body.source[0].name        |
      | isActive                  |                                                                |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    #Get All workflow configurations
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                                  0 |
      | id                        |                                                                    |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName |                                                                    |
      | effectiveDate             |                                                                    |
      | documentClass             |                                                                    |
      | documentType              |                                                                    |
      | source                    |                                                                    |
      | isActive                  | createWorkflowConfigurationResponse.body.isActive                  |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And match getWorkflowConfigurationsResponse.results[*].isActive contains createWorkflowConfigurationResponse.body.isActive
    And match getWorkflowConfigurationsResponse.results[*].documentTypes[0].name contains createWorkflowConfigurationResponse.body.documentTypes[0].name
    And match getWorkflowConfigurationsResponse.results[*].source[1].name contains createWorkflowConfigurationResponse.body.source[1].name
    And match getWorkflowConfigurationsResponse.results[*].id contains createWorkflowConfigurationResponse.body.id
    And def getWorkflowConfigurationsResponseCount = karate.sizeOf(getWorkflowConfigurationsResponse.results)
    And print getWorkflowConfigurationsResponseCount
    And match getWorkflowConfigurationsResponseCount == getWorkflowConfigurationsResponse.totalRecordCount
    And assert getWorkflowConfigurationsResponseCount > 0
    #History Validation for Record Created
    And def entityIdData = createWorkflowConfigurationResponse.body.id
    And def parentEntityId = createWorkflowConfigurationResponse.body.id
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
    And match getHistoryResponseCount == 1
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createWorkflowConfigurationResponse.body.id
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
    And def entityIdData = createWorkflowConfigurationResponse.body.id
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

  @CreateWorkFlowConfigurationWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a workflow configurations with mandatory fields and get the details
    Given url readBaseWorkFlowUrl
    When path '/api/GetWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    #Get All workflow configurations
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                                  0 |
      | id                        |                                                                    |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | createWorkflowConfigurationResponse.body.workflowConfigurationName |
      | effectiveDate             |                                                                    |
      | documentClass             | createWorkflowConfigurationResponse.body.documentClass.name        |
      | documentType              |                                                                    |
      | source                    |                                                                    |
      | isActive                  |                                                                    |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And match getWorkflowConfigurationsResponse.results[*].isActive contains createWorkflowConfigurationResponse.body.isActive
    And match getWorkflowConfigurationsResponse.results[*].documentClass.id contains createWorkflowConfigurationResponse.body.documentClass.id
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationCode contains createWorkflowConfigurationResponse.body.workflowConfigurationCode
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationName contains createWorkflowConfigurationResponse.body.workflowConfigurationName
    And def getWorkflowConfigurationsResponseCount = karate.sizeOf(getWorkflowConfigurationsResponse.results)
    And print getWorkflowConfigurationsResponseCount
    And match getWorkflowConfigurationsResponseCount == getWorkflowConfigurationsResponse.totalRecordCount
    And assert getWorkflowConfigurationsResponseCount > 0
    #grid filter based on effective date
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                      0 |
      | id                        |                                                        |
      | workflowConfigurationCode |                                                        |
      | workflowConfigurationName |                                                        |
      | effectiveDate             | createWorkflowConfigurationResponse.body.effectiveDate |
      | documentClass             |                                                        |
      | documentType              |                                                        |
      | source                    |                                                        |
      | isActive                  |                                                        |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And match getWorkflowConfigurationsResponse.results[0].workflowConfigurationCode == createWorkflowConfigurationResponse.body.workflowConfigurationCode
    And match getWorkflowConfigurationsResponse.results[0].effectiveDate == createWorkflowConfigurationResponse.body.effectiveDate
    And match getWorkflowConfigurationsResponse.results[0].id == createWorkflowConfigurationResponse.body.id
    #History Validation for Record Created
    And def entityIdData = createWorkflowConfigurationResponse.body.id
    And def parentEntityId = createWorkflowConfigurationResponse.body.id
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
    And match getHistoryResponseCount == 1
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createWorkflowConfigurationResponse.body.id
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
    And def entityIdData = createWorkflowConfigurationResponse.body.id
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

  @CreateWorKflowWithDocTypeDeleteWhileUpdateAndAgainCreateWithSameDocType
  Scenario Outline: Create a workflow with document type while updating remove that and agai create another with same doc type
    Given url commandBaseWorkFlowUrl
    And path '/api/UpdateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | entityName      | entityName                                               |
      | ttl             |                                                        0 |
    And set updateWorkflowConfigurationDocumentClass
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set updateWorkflowConfigurationSource
      | path |                                                       0 |
      | id   | createWorkflowConfigurationResponse.body.source[0].id   |
      | code | createWorkflowConfigurationResponse.body.source[0].code |
      | name | createWorkflowConfigurationResponse.body.source[0].name |
    And set updateWorkflowConfigurationCommandBody
      | path                      |                                                                  0 |
      | id                        | createWorkflowConfigurationResponse.body.id                        |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | faker.getFirstName()                                               |
      | effectiveDate             | faker.getRandomDate()                                              |
      | workflowType              | workFlowType[0]                                                    |
      | isActive                  | faker.getRandomBooleanValue()                                      |
      | documentClass             | updateWorkflowConfigurationDocumentClass[0]                        |
      | source                    | updateWorkflowConfigurationSource                                  |
    And set updateWorkflowConfigurationPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationCommandBody[0]   |
    And print updateWorkflowConfigurationPayload
    And request updateWorkflowConfigurationPayload
    When method POST
    Then status 201
    And def updateWorkflowConfigurationResponse = response
    And print updateWorkflowConfigurationResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,updateWorkflowConfigurationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateWorkflowConfigurationResponse.body.id
    And match updateWorkflowConfigurationResponse.body.documentClass.id == updateWorkflowConfigurationPayload.body.documentClass.id
    #get the details
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfiguration'
    And set getWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"              |
      | version         | "1.001"                                                  |
      | sourceId        | updateWorkflowConfigurationResponse.header.sourceId      |
      | id              | updateWorkflowConfigurationResponse.header.id            |
      | correlationId   | updateWorkflowConfigurationResponse.header.correlationId |
      | tenantId        | <tenantid>                                               |
      | ttl             |                                                        0 |
      | commandType     | commandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | tags            | []                                                       |
      | commandUserId   | updateWorkflowConfigurationResponse.header.commandUserId |
      | getType         | "One"                                                    |
    And set getWorkflowConfigurationCommandBody
      | path |                                           0 |
      | id   | updateWorkflowConfigurationResponse.body.id |
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    #Create a new workflow config with same document types
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse1 = result.response
    And print createWorkflowConfigurationResponse1
    #get the details
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfiguration'
    And set getWorkflowConfigurationCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"               |
      | version         | "1.001"                                                   |
      | sourceId        | createWorkflowConfigurationResponse1.header.sourceId      |
      | id              | createWorkflowConfigurationResponse1.header.id            |
      | correlationId   | createWorkflowConfigurationResponse1.header.correlationId |
      | tenantId        | <tenantid>                                                |
      | ttl             |                                                         0 |
      | commandType     | commandType[1]                                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | tags            | []                                                        |
      | commandUserId   | createWorkflowConfigurationResponse1.header.commandUserId |
      | getType         | "One"                                                     |
    And set getWorkflowConfigurationCommandBody
      | path |                                            0 |
      | id   | createWorkflowConfigurationResponse1.body.id |
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    And match createWorkflowConfigurationResponse1.body.documentTypes[0].id == createWorkflowConfigurationResponse.body.documentTypes[0].id
    And match createWorkflowConfigurationResponse1.body.documentTypes[0].code == createWorkflowConfigurationResponse.body.documentTypes[0].code
    And match createWorkflowConfigurationResponse1.body.documentTypes[0].name == createWorkflowConfigurationResponse.body.documentTypes[0].name
    And match createWorkflowConfigurationResponse1.body.documentTypes[1].id == createWorkflowConfigurationResponse.body.documentTypes[1].id
    And match createWorkflowConfigurationResponse1.body.documentTypes[1].name == createWorkflowConfigurationResponse.body.documentTypes[1].name
    #History Validation for Record created
    And def entityIdData = createWorkflowConfigurationResponse1.body.id
    And def parentEntityId = createWorkflowConfigurationResponse1.body.id
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
    And match getHistoryResponseCount == 1
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createWorkflowConfigurationResponse1.body.id
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
    And def entityIdData = createWorkflowConfigurationResponse1.body.id
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

  @CreateWorkFlowConfigurationWithInvalidDataToMandatoryDetails
  Scenario Outline: Create a workflow configurations with invalid data to mandatory field
    Given url commandBaseWorkFlowUrl
    And path '/api/CreateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
    And def getDocumentClassResponse = result.response
    And print getDocumentClassResponse
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
    And set createWorkflowConfigurationSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | faker.getRandomNumber()                     |
      | workflowConfigurationCode | faker.getFirstName()                        |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | faker.getRandomDate()                       |
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
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowConfigurationWithMissingMandatoryDetails
  Scenario Outline: Create a workflow configurations with missing mandatory field
    Given url commandBaseWorkFlowUrl
    And path '/api/CreateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@GetDocumentClassBasedOnSelectedArea')
    And def getDocumentClassResponse = result.response
    And print getDocumentClassResponse
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
    #workflowconfiguration code,source is missing
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | entityIdData                                |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | faker.getRandomDate()                       |
      | workflowType              | faker.getRandomWorkFlowType()               |
      | isActive                  | faker.getRandomBooleanValue()               |
      | documentClass             | createWorkflowConfigurationDocumentClass[0] |
    And set createWorkflowConfigurationPayload
      | path   | [0]                                  |
      | header | createWorkflowConfigurationHeader[0] |
      | body   | createWorkflowConfigurationBody[0]   |
    And print createWorkflowConfigurationPayload
    And request createWorkflowConfigurationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowConfigurationWithAllDetailsAndGetTheDetails
  Scenario Outline: Update a workflow configurations with all the fields and get the details
    Given url commandBaseWorkFlowUrl
    And path '/api/UpdateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
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
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | entityName      | entityName                                               |
      | ttl             |                                                        0 |
    And set updateWorkflowConfigurationDocumentClass
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set updateWorkflowConfigurationDocumentTypes
      | path |                                                           0 |
      | id   | getDocumentTypesResponse.results[2].id                      |
      | code | getDocumentTypesResponse.results[2].documentTypeCode        |
      | name | getDocumentTypesResponse.results[2].documentTypeDescription |
    And set updateWorkflowConfigurationDocumentTypes
      | path |                                                           1 |
      | id   | getDocumentTypesResponse.results[3].id                      |
      | code | getDocumentTypesResponse.results[3].documentTypeCode        |
      | name | getDocumentTypesResponse.results[3].documentTypeDescription |
    And set updateWorkflowConfigurationSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[2].id   |
      | code | getElectronicRecordingSourceResponse.results[2].code |
      | name | getElectronicRecordingSourceResponse.results[2].name |
    And set updateWorkflowConfigurationSource
      | path |                                                    1 |
      | id   | getElectronicRecordingSourceResponse.results[3].id   |
      | code | getElectronicRecordingSourceResponse.results[3].code |
      | name | getElectronicRecordingSourceResponse.results[3].name |
    And set updateWorkflowConfigurationCommandBody
      | path                      |                                                                  0 |
      | id                        | createWorkflowConfigurationResponse.body.id                        |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | faker.getFirstName()                                               |
      | effectiveDate             | faker.getRandomDate()                                              |
      | workflowType              | faker.getRandomWorkFlowType()                                      |
      | isActive                  | faker.getRandomBooleanValue()                                      |
      | documentClass             | updateWorkflowConfigurationDocumentClass[0]                        |
      | documentTypes             | updateWorkflowConfigurationDocumentTypes                           |
      | source                    | updateWorkflowConfigurationSource                                  |
    And set updateWorkflowConfigurationPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationCommandBody[0]   |
    And print updateWorkflowConfigurationPayload
    And request updateWorkflowConfigurationPayload
    When method POST
    Then status 201
    And def updateWorkflowConfigurationResponse = response
    And print updateWorkflowConfigurationResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,updateWorkflowConfigurationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateWorkflowConfigurationResponse.body.id
    And match updateWorkflowConfigurationResponse.body.documentClass.id == updateWorkflowConfigurationPayload.body.documentClass.id
    And match updateWorkflowConfigurationResponse.body.documentTypes[0].id == updateWorkflowConfigurationPayload.body.documentTypes[0].id
    And match updateWorkflowConfigurationResponse.body.documentTypes[1].id == updateWorkflowConfigurationPayload.body.documentTypes[1].id
    And match updateWorkflowConfigurationResponse.body.source[0].id == updateWorkflowConfigurationPayload.body.source[0].id
    And match updateWorkflowConfigurationResponse.body.source[1].id == updateWorkflowConfigurationPayload.body.source[1].id
    #get the details
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfiguration'
    And set getWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"              |
      | version         | "1.001"                                                  |
      | sourceId        | updateWorkflowConfigurationResponse.header.sourceId      |
      | id              | updateWorkflowConfigurationResponse.header.id            |
      | correlationId   | updateWorkflowConfigurationResponse.header.correlationId |
      | tenantId        | <tenantid>                                               |
      | ttl             |                                                        0 |
      | commandType     | commandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | tags            | []                                                       |
      | commandUserId   | updateWorkflowConfigurationResponse.header.commandUserId |
      | getType         | "One"                                                    |
    And set getWorkflowConfigurationCommandBody
      | path |                                           0 |
      | id   | updateWorkflowConfigurationResponse.body.id |
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    #Get All workflow configurations
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                              0 |
      | id                        |                                                                |
      | workflowConfigurationCode |                                                                |
      | workflowConfigurationName |                                                                |
      | effectiveDate             | updateWorkflowConfigurationResponse.body.effectiveDate         |
      | documentClass             |                                                                |
      | documentType              | updateWorkflowConfigurationResponse.body.documentTypes[0].name |
      | source                    | updateWorkflowConfigurationResponse.body.source[1].name        |
      | isActive                  | updateWorkflowConfigurationResponse.body.isActive              |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And match getWorkflowConfigurationsResponse.results[*].isActive contains updateWorkflowConfigurationResponse.body.isActive
    And match getWorkflowConfigurationsResponse.results[*].documentTypes[*].code contains updateWorkflowConfigurationResponse.body.documentTypes[0].code
    And match getWorkflowConfigurationsResponse.results[*].source[*].code contains updateWorkflowConfigurationResponse.body.source[1].code
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationName contains updateWorkflowConfigurationResponse.body.workflowConfigurationName
    And match getWorkflowConfigurationsResponse.results[*].id contains updateWorkflowConfigurationResponse.body.id
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationCode contains updateWorkflowConfigurationResponse.body.workflowConfigurationCode
    And def getWorkflowConfigurationsResponseCount = karate.sizeOf(getWorkflowConfigurationsResponse.results)
    And print getWorkflowConfigurationsResponseCount
    And match getWorkflowConfigurationsResponseCount == getWorkflowConfigurationsResponse.totalRecordCount
    And assert getWorkflowConfigurationsResponseCount > 0
    #History Validation for Record Updated
    And def entityIdData = updateWorkflowConfigurationResponse.body.id
    And def parentEntityId = updateWorkflowConfigurationResponse.body.id
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
    And match getHistoryResponseCount == 2
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateWorkflowConfigurationResponse.body.id
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
    And def entityIdData = updateWorkflowConfigurationResponse.body.id
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

  @UpdateWorkFlowConfigurationWithMandatoryDetailsAndGetTheDetails
  Scenario Outline: Update a workflow configurations with mandatory fields and get the details
    Given url commandBaseWorkFlowUrl
    And path '/api/UpdateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | entityName      | entityName                                               |
      | ttl             |                                                        0 |
    And set updateWorkflowConfigurationDocumentClass
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set updateWorkflowConfigurationSource
      | path |                                                       0 |
      | id   | createWorkflowConfigurationResponse.body.source[0].id   |
      | code | createWorkflowConfigurationResponse.body.source[0].code |
      | name | createWorkflowConfigurationResponse.body.source[0].name |
    And set updateWorkflowConfigurationCommandBody
      | path                      |                                                                  0 |
      | id                        | createWorkflowConfigurationResponse.body.id                        |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | faker.getFirstName()                                               |
      | effectiveDate             | dataGenerator.generateCurrentDateTime()                            |
      | workflowType              | workFlowType[0]                                                    |
      | isActive                  | faker.getRandomBooleanValue()                                      |
      | documentClass             | updateWorkflowConfigurationDocumentClass[0]                        |
      | source                    | updateWorkflowConfigurationSource                                  |
    And set updateWorkflowConfigurationPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationCommandBody[0]   |
    And print updateWorkflowConfigurationPayload
    And request updateWorkflowConfigurationPayload
    When method POST
    Then status 201
    And def updateWorkflowConfigurationResponse = response
    And print updateWorkflowConfigurationResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,updateWorkflowConfigurationResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateWorkflowConfigurationResponse.body.id
    And match updateWorkflowConfigurationResponse.body.id == updateWorkflowConfigurationPayload.body.id
    And match updateWorkflowConfigurationResponse.body.documentClass.id == updateWorkflowConfigurationPayload.body.documentClass.id 
    And match updateWorkflowConfigurationResponse.body.workflowConfigurationCode == updateWorkflowConfigurationPayload.body.workflowConfigurationCode
    And match updateWorkflowConfigurationResponse.body.workflowConfigurationName == updateWorkflowConfigurationPayload.body.workflowConfigurationName
    And match updateWorkflowConfigurationResponse.body.source[0].code == updateWorkflowConfigurationPayload.body.source[0].code
    #get the details
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfiguration'
    And set getWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"              |
      | version         | "1.001"                                                  |
      | sourceId        | updateWorkflowConfigurationResponse.header.sourceId      |
      | id              | updateWorkflowConfigurationResponse.header.id            |
      | correlationId   | updateWorkflowConfigurationResponse.header.correlationId |
      | tenantId        | <tenantid>                                               |
      | ttl             |                                                        0 |
      | commandType     | commandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | tags            | []                                                       |
      | commandUserId   | updateWorkflowConfigurationResponse.header.commandUserId |
      | getType         | "One"                                                    |
    And set getWorkflowConfigurationCommandBody
      | path |                                           0 |
      | id   | updateWorkflowConfigurationResponse.body.id |
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
    And print getWorkflowConfigurationResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlowRead,createWorkFlowConfigCollectionNameRead+<tenantid>,getWorkflowConfigurationResponse.id)
    And print mongoResult
    And match mongoResult == getWorkflowConfigurationResponse.id
    And match updateWorkflowConfigurationResponse.body.id == getWorkflowConfigurationResponse.id
    And match updateWorkflowConfigurationResponse.body.workflowConfigurationCode == getWorkflowConfigurationResponse.workflowConfigurationCode
    And match updateWorkflowConfigurationResponse.body.workflowConfigurationName == getWorkflowConfigurationResponse.workflowConfigurationName
    And match updateWorkflowConfigurationResponse.body.source[0].code == getWorkflowConfigurationResponse.source[0].code
    And match updateWorkflowConfigurationResponse.body.documentClass.code == getWorkflowConfigurationResponse.documentClass.code
    #Get All workflow configurations 
    Given url readBaseWorkFlowUrl
    And path '/api/GetWorkflowConfigurations'
    And set getWorkflowConfigurationsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getWorkflowConfigurationsCommandBodyRequest
      | path                      |                                                                  0 |
      | id                        |                                                                    |
      | workflowConfigurationCode | updateWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | updateWorkflowConfigurationResponse.body.workflowConfigurationName |
      | effectiveDate             |                                                                    |
      | documentClass             |                                                                    |
      | documentType              |                                                                    |
      | source                    |                                                                    |
      | isActive                  |                                                                    |
    And set getWorkflowConfigurationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getWorkflowConfigurationsPayload
      | path                | [0]                                            |
      | header              | getWorkflowConfigurationsCommandHeader[0]      |
      | body.request        | getWorkflowConfigurationsCommandBodyRequest[0] |
      | body.paginationSort | getWorkflowConfigurationsCommandPagination[0]  |
    And print getWorkflowConfigurationsPayload
    And request getWorkflowConfigurationsPayload
    When method POST
    Then status 200
    And def getWorkflowConfigurationsResponse = response
    And print getWorkflowConfigurationsResponse
    And match getWorkflowConfigurationsResponse.results[*].isActive contains updateWorkflowConfigurationResponse.body.isActive
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationName contains updateWorkflowConfigurationResponse.body.workflowConfigurationName
    And match getWorkflowConfigurationsResponse.results[*].id contains updateWorkflowConfigurationResponse.body.id
    And match getWorkflowConfigurationsResponse.results[*].workflowConfigurationCode contains updateWorkflowConfigurationResponse.body.workflowConfigurationCode
    And match getWorkflowConfigurationsResponse.results[*].source[*].code contains updateWorkflowConfigurationResponse.body.source[0].code
    And match getWorkflowConfigurationsResponse.results[*].source[*].id contains updateWorkflowConfigurationResponse.body.source[0].id
    And match getWorkflowConfigurationsResponse.results[*].documentClass[*].id contains updateWorkflowConfigurationResponse.body.documentClass.id
    And def getWorkflowConfigurationsResponseCount = karate.sizeOf(getWorkflowConfigurationsResponse.results)
    And print getWorkflowConfigurationsResponseCount
    And match getWorkflowConfigurationsResponseCount == getWorkflowConfigurationsResponse.totalRecordCount
    And assert getWorkflowConfigurationsResponseCount > 0
    #History Validation for Record Updated
    And def entityIdData = updateWorkflowConfigurationResponse.body.id
    And def parentEntityId = updateWorkflowConfigurationResponse.body.id
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
    And match getHistoryResponseCount == 2
    #Adding the comment
    And def entityName = entityName
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateWorkflowConfigurationResponse.body.id
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
    And def entityIdData = updateWorkflowConfigurationResponse.body.id
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

  @UpdateWorkFlowConfigurationWithInvalidDataToMandatoryDetails
  Scenario Outline: Update WorkFlowConfiguration with invalid data to mandatory fields
    Given url commandBaseWorkFlowUrl
    And path '/api/UpdateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | entityName      | entityName                                               |
      | ttl             |                                                        0 |
    And set updateWorkflowConfigurationDocumentClass
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set updateWorkflowConfigurationSource
      | path |                                                       0 |
      | id   | createWorkflowConfigurationResponse.body.source[0].id   |
      | code | createWorkflowConfigurationResponse.body.source[0].code |
      | name | createWorkflowConfigurationResponse.body.source[0].name |
    And set updateWorkflowConfigurationCommandBody
      | path                      |                                                                  0 |
      | id                        | faker.getRandomNumber()                                            |
      | workflowConfigurationCode | createWorkflowConfigurationResponse.body.workflowConfigurationCode |
      | workflowConfigurationName | faker.getFirstName()                                               |
      | effectiveDate             | faker.getRandomDate()                                              |
      | workflowType              | workFlowType[0]                                                    |
      | isActive                  | faker.getRandomBooleanValue()                                      |
      | documentClass             | updateWorkflowConfigurationDocumentClass[0]                        |
      | source                    | updateWorkflowConfigurationSource                                  |
    And set updateWorkflowConfigurationPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationCommandBody[0]   |
    And print updateWorkflowConfigurationPayload
    And request updateWorkflowConfigurationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateWorkFlowConfigurationWithMissingMandatoryDetails
  Scenario Outline: Update WorkFlowConfiguration with missing mandatory field
    Given url commandBaseWorkFlowUrl
    And path '/api/UpdateWorkflowConfiguration'
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And set updateWorkflowConfigurationCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createWorkflowConfigurationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createWorkflowConfigurationResponse.header.id            |
      | correlationId   | createWorkflowConfigurationResponse.header.correlationId |
      | entityId        | createWorkflowConfigurationResponse.header.entityId      |
      | commandUserId   | createWorkflowConfigurationResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[3]                                           |
      | entityName      | entityName                                               |
      | ttl             |                                                        0 |
    And set updateWorkflowConfigurationDocumentClass
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set updateWorkflowConfigurationCommandBody
      | path                      |                                           0 |
      | id                        | createWorkflowConfigurationResponse.body.id |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | faker.getRandomDate()                       |
      | workflowType              | workFlowType[0]                             |
      | isActive                  | faker.getRandomBooleanValue()               |
      | documentClass             | updateWorkflowConfigurationDocumentClass[0] |
    And set updateWorkflowConfigurationPayload
      | path   | [0]                                         |
      | header | updateWorkflowConfigurationCommandHeader[0] |
      | body   | updateWorkflowConfigurationCommandBody[0]   |
    And print updateWorkflowConfigurationPayload
    And request updateWorkflowConfigurationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DuplicateScenarioes @CreateWorkFlowConfigurationHavingDuplicateDetails
  Scenario Outline: Create a WorkFlow Configuration having duplicate document class, document type,effective date, source and workflow type
    Given url commandBaseWorkFlowUrl
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
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
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set createWorkflowConfigurationDocumentTypes
      | path |                                                              0 |
      | id   | createWorkflowConfigurationResponse.body.documentTypes[0].id   |
      | code | createWorkflowConfigurationResponse.body.documentTypes[0].code |
      | name | createWorkflowConfigurationResponse.body.documentTypes[0].name |
    And set createWorkflowConfigurationSource
      | path |                                                       0 |
      | id   | createWorkflowConfigurationResponse.body.source[0].id   |
      | code | createWorkflowConfigurationResponse.body.source[0].code |
      | name | createWorkflowConfigurationResponse.body.source[0].name |
    And set createWorkflowConfigurationBody
      | path                      |                                                      0 |
      | id                        | entityIdData                                           |
      | workflowConfigurationCode | faker.getUserId()                                      |
      | workflowConfigurationName | faker.getFirstName()                                   |
      | effectiveDate             | createWorkflowConfigurationResponse.body.effectiveDate |
      | workflowType              | createWorkflowConfigurationResponse.body.workflowType  |
      | isActive                  | createWorkflowConfigurationResponse.body.isActive      |
      | documentClass             | createWorkflowConfigurationDocumentClass[0]            |
      | documentTypes             | createWorkflowConfigurationDocumentTypes               |
      | source                    | createWorkflowConfigurationSource                      |
    And set createWorkflowConfigurationPayload
      | path   | [0]                                  |
      | header | createWorkflowConfigurationHeader[0] |
      | body   | createWorkflowConfigurationBody[0]   |
    And print createWorkflowConfigurationPayload
    And request createWorkflowConfigurationPayload
    When method POST
    Then status 400
    And match response contains "The combination of Document class, Document Type, Source, effective date, workflow type, and isActive are existing."

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowConfigurationHavingDuplicateWorkFlowsWithoutDocType
  Scenario Outline: Create a WorkFlow Configuration without document type and  having duplicate document class,source,effective date,and workflow type
    Given url commandBaseWorkFlowUrl
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithMandatoryFields')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
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
      | path |                                                           0 |
      | id   | createWorkflowConfigurationResponse.body.documentClass.id   |
      | code | createWorkflowConfigurationResponse.body.documentClass.code |
      | name | createWorkflowConfigurationResponse.body.documentClass.name |
    And set createWorkflowConfigurationSource
      | path |                                                       0 |
      | id   | createWorkflowConfigurationResponse.body.source[0].id   |
      | code | createWorkflowConfigurationResponse.body.source[0].code |
      | name | createWorkflowConfigurationResponse.body.source[0].name |
    And set createWorkflowConfigurationBody
      | path                      |                                                      0 |
      | id                        | entityIdData                                           |
      | workflowConfigurationCode | faker.getUserId()                                      |
      | workflowConfigurationName | faker.getFirstName()                                   |
      | effectiveDate             | createWorkflowConfigurationResponse.body.effectiveDate |
      | workflowType              | createWorkflowConfigurationResponse.body.workflowType  |
      | isActive                  | createWorkflowConfigurationResponse.body.isActive      |
      | documentClass             | createWorkflowConfigurationDocumentClass[0]            |
      | source                    | createWorkflowConfigurationSource                      |
    And set createWorkflowConfigurationPayload
      | path   | [0]                                  |
      | header | createWorkflowConfigurationHeader[0] |
      | body   | createWorkflowConfigurationBody[0]   |
    And print createWorkflowConfigurationPayload
    And request createWorkflowConfigurationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateWorkFlowConfigurationSceanriosHavingDuplicateWorkFlowConfigID
  Scenario Outline: Create a workflow configurations master info having duplicate workflow config ID
    Given url commandBaseWorkFlowUrl
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
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
      | path |                   0 |
      | id   | <documentClassId>   |
      | code | <documentClassCode> |
      | name | <documentClassName> |
    And set createWorkflowConfigurationDocumentTypes
      | path |                   0 |
      | id   | <documentTypesId>   |
      | code | <documentTypesCode> |
      | name | <documentTypesName> |
    And set createWorkflowConfigurationSource
      | path |            0 |
      | id   | <sourceID>   |
      | code | <sourceCode> |
      | name | <sourceName> |
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | entityIdData                                |
      | workflowConfigurationCode | <workflowConfigCode>                        |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | <effectiveDate>                             |
      | workflowType              | <workflowType>                              |
      | isActive                  | <isActive>                                  |
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
    Then status <status>
    And def createWorkflowConfigurationResponse = response
    And match createWorkflowConfigurationResponse contains ""

    Examples: 
      | tenantid    | workflowConfigCode                                                 | documentClassId                                           | documentClassCode                                           | documentClassName                                           | documentTypesId                                              | documentTypesCode                                              | documentTypesName                                              | sourceID                                              | sourceCode                                              | sourceName                                              | effectiveDate                                          | workflowType                                          | isActive                                          | status |
      | tenantID[0] | createWorkflowConfigurationResponse.body.workflowConfigurationCode | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | createWorkflowConfigurationResponse.body.effectiveDate | createWorkflowConfigurationResponse.body.workflowType | createWorkflowConfigurationResponse.body.isActive |    400 |
      | tenantID[0] | createWorkflowConfigurationResponse.body.workflowConfigurationCode | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | getDocumentTypesResponse.results[3].id                       | getDocumentTypesResponse.results[3].documentTypeCode           | getDocumentTypesResponse.results[3].documentTypeDescription    | getElectronicRecordingSourceResponse.results[3].id    | getElectronicRecordingSourceResponse.results[3].code    | getElectronicRecordingSourceResponse.results[3].name    | dataGenerator.generateCurrentDateTime()                | faker.getRandomWorkFlowType()                         | faker.getRandomBooleanValue()                     |    400 |

  #@CreateWorkFlowConfigToCheckPriorityAndDuplicateWorkFlow
  #Scenario Outline: Create a WorkFlow Configuration having duplicate document type,
  #Given url commandBaseWorkFlowUrl
  #And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationToCheckPriority')
  #And def createWorkflowConfigurationResponse = result.response
  #And print createWorkflowConfigurationResponse
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
  #| path |                                                                                 0 |
  #| id   | createWorkflowConfigurationResponse.body.documentTypes[0].id                      |
  #| code | createWorkflowConfigurationResponse.body.documentTypes[0].documentTypeCode        |
  #| name | createWorkflowConfigurationResponse.body.documentTypes[0].documentTypeDescription |
  #And set createWorkflowConfigurationSource
  #| path |                                                       0 |
  #| id   | createWorkflowConfigurationResponse.body.source[0].id   |
  #| code | createWorkflowConfigurationResponse.body.source[0].code |
  #| name | createWorkflowConfigurationResponse.body.source[0].name |
  #And set createWorkflowConfigurationBody
  #| path                      |                                                      0 |
  #| id                        | entityIdData                                           |
  #| workflowConfigurationCode | faker.getFirstName()                                   |
  #| workflowConfigurationName | faker.getFirstName()                                   |
  #| effectiveDate             | createWorkflowConfigurationResponse.body.effectiveDate |
  #| workflowType              | createWorkflowConfigurationResponse.body.workflowType  |
  #| isActive                  | createWorkflowConfigurationResponse.body.isActive      |
  #| documentClass             | createWorkflowConfigurationDocumentClass[0]            |
  #| documentTypes             | createWorkflowConfigurationDocumentTypes               |
  #| source                    | createWorkflowConfigurationSource                      |
  #And set createWorkflowConfigurationPayload
  #| path   | [0]                                  |
  #| header | createWorkflowConfigurationHeader[0] |
  #| body   | createWorkflowConfigurationBody[0]   |
  #And print createWorkflowConfigurationPayload
  #And request createWorkflowConfigurationPayload
  #When method POST
  #Then status 400
  #
  #Examples:
  #| tenantid    |
  #| tenantID[0] |
  @CreateWorkFlowConfigurationWithCombinationData
  Scenario Outline: Create a workflow configurations master info with combination data to all fields
    Given url commandBaseWorkFlowUrl
    And def result = call read('CreateWorkFlow.feature@CreateWorkFlowConfigurationWithAllDetails')
    And def createWorkflowConfigurationResponse = result.response
    And print createWorkflowConfigurationResponse
    And sleep(10000)
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
      | path |                   0 |
      | id   | <documentClassId>   |
      | code | <documentClassCode> |
      | name | <documentClassName> |
    And set createWorkflowConfigurationDocumentTypes
      | path |                   0 |
      | id   | <documentTypesId>   |
      | code | <documentTypesCode> |
      | name | <documentTypesName> |
    And set createWorkflowConfigurationSource
      | path |            0 |
      | id   | <sourceID>   |
      | code | <sourceCode> |
      | name | <sourceName> |
    And set createWorkflowConfigurationBody
      | path                      |                                           0 |
      | id                        | entityIdData                                |
      | workflowConfigurationCode | faker.getUserId()                           |
      | workflowConfigurationName | faker.getFirstName()                        |
      | effectiveDate             | <effectiveDate>                             |
      | workflowType              | <workflowType>                              |
      | isActive                  | <isActive>                                  |
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
    Then status <status>
    And def createWorkflowConfigurationResponse = response
    And print createWorkflowConfigurationResponse

    #And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,createWorkFlowConfigCollectionName+<tenantid>,entityIdData)
    #And print mongoResult
    #And match mongoResult == createWorkflowConfigurationResponse.body.id
    #And match createWorkflowConfigurationResponse.body.id == createWorkflowConfigurationPayload.body.id
    # only have single document class as of now
    #|tenantID[0] | getDocumentClassResponse.results[0].id | getDocumentClassResponse.results[0].code | getDocumentClassResponse.results[0].name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | createWorkflowConfigurationResponse.body.effectiveDate | createWorkflowConfigurationResponse.body.workflowType | createWorkflowConfigurationResponse.body.isActive |    400 |
    Examples: 
      | tenantid    | documentClassId                                           | documentClassCode                                           | documentClassName                                           | documentTypesId                                              | documentTypesCode                                              | documentTypesName                                              | sourceID                                              | sourceCode                                              | sourceName                                              | effectiveDate                                          | workflowType                                          | isActive                                          | status |
      | tenantID[0] | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | getDocumentTypesResponse.results[3].id                       | getDocumentTypesResponse.results[3].documentTypeCode           | getDocumentTypesResponse.results[3].documentTypeDescription    | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | createWorkflowConfigurationResponse.body.effectiveDate | createWorkflowConfigurationResponse.body.workflowType | createWorkflowConfigurationResponse.body.isActive |    201 |
      | tenantID[0] | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | getElectronicRecordingSourceResponse.results[3].id    | getElectronicRecordingSourceResponse.results[3].code    | getElectronicRecordingSourceResponse.results[3].name    | createWorkflowConfigurationResponse.body.effectiveDate | createWorkflowConfigurationResponse.body.workflowType | createWorkflowConfigurationResponse.body.isActive |    201 |
      | tenantID[0] | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | dataGenerator.generateCurrentDateTime()                | createWorkflowConfigurationResponse.body.workflowType | createWorkflowConfigurationResponse.body.isActive |    201 |
      | tenantID[0] | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | createWorkflowConfigurationResponse.body.effectiveDate | faker.getRandomWorkFlowType()                         | createWorkflowConfigurationResponse.body.isActive |    201 |
      | tenantID[0] | createWorkflowConfigurationResponse.body.documentClass.id | createWorkflowConfigurationResponse.body.documentClass.code | createWorkflowConfigurationResponse.body.documentClass.name | createWorkflowConfigurationResponse.body.documentTypes[0].id | createWorkflowConfigurationResponse.body.documentTypes[0].code | createWorkflowConfigurationResponse.body.documentTypes[0].name | createWorkflowConfigurationResponse.body.source[0].id | createWorkflowConfigurationResponse.body.source[0].code | createWorkflowConfigurationResponse.body.source[0].name | createWorkflowConfigurationResponse.body.effectiveDate | createWorkflowConfigurationResponse.body.workflowType | faker.getRandomBooleanValue()                     |    201 |
