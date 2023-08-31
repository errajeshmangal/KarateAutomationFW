@CreateMenuDefinition
Feature: Menu Definition-Add, Edit,View,Grid-View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def MenuDefintionCollectionName = 'CreateMenuDefinition_'
    And def MenuDefintionCollectionNameRead = 'MenuDefinitionDetailViewModel_'
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateMenuDefinition","UpdateMenuDefinition","GetMenuDefinition","GetMenuDefinitions"]
    And def entityName = ["MenuDefinition"]
    And def itemType = ["Category","Page"]
    And def isActive = [true]
    And def eventTypes = ['MenuDefinition','MenuDefinitionStructure']
    And def historyAndComments = ['Created','Updated']

  @CreateAndGetMenuDefinitionWithAllDetails
  Scenario Outline: Create a Menu Definition with all the fields and Get the details
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    #Get the menu definiton
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | createMenuDefinitionResponse.header.entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionCollectionNameRead+<tenantid>,createMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMenuDefinitionResponse.id
    And match getMenuDefinitionResponse.id == createMenuDefinitionResponse.body.id
    And match getMenuDefinitionResponse.menuName == createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionResponse.menuDescription == createMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionResponse.isActive == createMenuDefinitionResponse.body.isActive
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getCommandBody1
      | path            |                                          0 |
      | menuName        | createMenuDefinitionResponse.body.menuName |
      | menuDescription |                                            |
      | isActive        |                                            |
      | lastUpdatedDate |                                            |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody1[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains createMenuDefinitionResponse.body.id
    And match each getMenuDefinitionsResponse.results[*].menuName == createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains createMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionsResponse.results[*].isActive contains createMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getCommandBody2
      | path            |                                                 0 |
      | menuName        |                                                   |
      | menuDescription | createMenuDefinitionResponse.body.menuDescription |
      | isActive        |                                                   |
      | lastUpdatedDate |                                                   |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody2[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains createMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains createMenuDefinitionResponse.body.menuName
    And match each getMenuDefinitionsResponse.results[*].menuDescription == createMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionsResponse.results[*].isActive contains createMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getCommandBody3
      | path            |                                          0 |
      | menuName        |                                            |
      | menuDescription |                                            |
      | isActive        | createMenuDefinitionResponse.body.isActive |
      | lastUpdatedDate |                                            |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody3[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains createMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains createMenuDefinitionResponse.body.menuDescription
    And match each getMenuDefinitionsResponse.results[*].isActive == createMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getMenuDefinitionResponse.id
    And def parentEntityId = getMenuDefinitionResponse.id
    And def eventName = "MenuDefinitionCreated"
    And def evnentType = "MenuDefinition"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
    And def eventEntityID = createMenuDefinitionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    And sleep(15000)
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetMenuDefinitionWithMandateDetails
  Scenario Outline: Create a Menu Definition with mandate fields and Get the details
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithMandatoryFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    #Get the menu definiton
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | createMenuDefinitionResponse.header.entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    And sleep(1500)
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionCollectionNameRead+<tenantid>,createMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMenuDefinitionResponse.id
    And match getMenuDefinitionResponse.id == createMenuDefinitionResponse.body.id
    And match getMenuDefinitionResponse.menuName == createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionResponse.menuDescription == createMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionResponse.isActive == createMenuDefinitionResponse.body.isActive
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getCommandBody1
      | path            |                                                 0 |
      | menuName        |                                                   |
      | menuDescription | createMenuDefinitionResponse.body.menuDescription |
      | isActive        |                                                   |
      | lastUpdatedDate |                                                   |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody1[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains createMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains createMenuDefinitionResponse.body.menuDescription
    And match  getMenuDefinitionsResponse.results[*].isActive contains createMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getCommandBody
      | path            | 0 |
      | menuName        |   |
      | menuDescription |   |
      | isActive        |   |
      | lastUpdatedDate |   |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              5000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | {}                      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And sleep(15000)
    And match getMenuDefinitionsResponse.results[*].id contains createMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains createMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains createMenuDefinitionResponse.body.menuDescription
    And match  getMenuDefinitionsResponse.results[*].isActive contains createMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getMenuDefinitionResponse.id
    And def parentEntityId = getMenuDefinitionResponse.id
    And def eventName = "MenuDefinitionCreated"
    And def evnentType = "MenuDefinition"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
    And def eventEntityID = createMenuDefinitionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    And sleep(15000)
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithInvalidFields
  Scenario Outline: Create Menu Definition with invalid Field
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                             0 |
      | id              | entityIdData                  |
      | menuName        | faker.getFirstName()          |
      | menuDescription | faker.getRandom5DigitNumber() |
      | isActive        | faker.getRandomBooleanValue() |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then print response
    Then status 201

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithInvalidFields1
  Scenario Outline: Create Menu Definition with invalid Field
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                             0 |
      | id              | faker.getRandom5DigitNumber() |
      | menuName        | faker.getFirstName()          |
      | menuDescription | faker.getFirstName()          |
      | isActive        | faker.getRandomBooleanValue() |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithMissingMandatoryFields
  Scenario Outline: Create Menu Definition with missing Mandatory Field
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                             0 |
      | id              | entityIdData                  |
      | menuName        | faker.getFirstName()          |
      | menuDescription |                               |
      | isActive        | faker.getRandomBooleanValue() |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithMissingMandatoryFields1
  Scenario Outline: Create Menu Definition with missing Mandatory Field
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                                 0 |
      | id              | entityIdData                      |
      | menuName        |                                   |
      | menuDescription | faker.getRandomShortDescription() |
      | isActive        | faker.getRandomBooleanValue()     |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuDefinitionWithduplicateName
  Scenario Outline: Create Menu Definition with Duplicate Name
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #Create a menu definiton
    And def createResult = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = createResult.response
    And print createMenuDefinitionResponse
    And def entityId = createMenuDefinitionResponse.body.id
    #Get menu Definition
    And def getResult = call read('GetMenuDefinitionAndMenuStructure.feature@GetMenuDefinitionWithAllDetails'){entityId:'#(entityId)'}
    And def getMenuDefinitionResponse = getResult.response
    And print getMenuDefinitionResponse
    And def menuName = getMenuDefinitionResponse.menuName
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path            |                                 0 |
      | id              | entityIdData                      |
      | menuName        | menuName                          |
      | menuDescription | faker.getRandomShortDescription() |
      | isActive        | faker.getRandomBooleanValue()     |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:MenuDefinition cannot be created. The count has already been setup'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithAllDetails
  Scenario Outline: Update menu definition with all details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                            0 |
      | id              | createMenuDefinitionResponse.header.entityId |
      | menuName        | createMenuDefinitionResponse.body.menuName   |
      | menuDescription | faker.getRandomShortDescription()            |
      | isActive        | faker.getRandomBooleanValue()                |
    And set updateMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print updateMenuDefinitionPayload
    And request updateMenuDefinitionPayload
    When method POST
    Then status 201
    And def updateMenuDefinitionResponse = response
    And print updateMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionCollectionName+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateMenuDefinitionResponse.body.id
    And match updateMenuDefinitionPayload.body.menuName == updateMenuDefinitionResponse.body.menuName
    And match updateMenuDefinitionPayload.body.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match updateMenuDefinitionPayload.body.isActive == updateMenuDefinitionResponse.body.isActive
    #Get the menu definiton
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | updateMenuDefinitionResponse.header.entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionCollectionNameRead+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMenuDefinitionResponse.id
    And match getMenuDefinitionResponse.menuName == updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionResponse.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionResponse.isActive == updateMenuDefinitionResponse.body.isActive
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody1
      | path            |                                          0 |
      | menuName        | updateMenuDefinitionResponse.body.menuName |
      | menuDescription |                                            |
      | isActive        |                                            |
      | lastUpdatedDate |                                            |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody1[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And match each getMenuDefinitionsResponse.results[*].isActive == updateMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody2
      | path            |      0 |
      | menuName        | "Test" |
      | menuDescription |        |
      | isActive        |        |
      | lastUpdatedDate |        |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody2[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match each getMenuDefinitionsResponse.results[*].menuName contains "Test"
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getMenuDefinitionResponse.id
    And def parentEntityId = getMenuDefinitionResponse.id
    And def eventName = "MenuDefinitionUpdated"
    And def evnentType = "MenuDefinition"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
    And def eventEntityID = createMenuDefinitionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    And sleep(15000)
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithMandateDetails
  Scenario Outline: Update menu definition with mandate details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithMandatoryFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                            0 |
      | id              | createMenuDefinitionResponse.header.entityId |
      | menuName        | createMenuDefinitionResponse.body.menuName   |
      | menuDescription | faker.getRandomShortDescription()            |
      | isActive        | isActive[0]                                  |
    And set updateMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print updateMenuDefinitionPayload
    And request updateMenuDefinitionPayload
    When method POST
    Then status 201
    And def updateMenuDefinitionResponse = response
    And print updateMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionCollectionName+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateMenuDefinitionResponse.body.id
    And match updateMenuDefinitionPayload.body.menuName == updateMenuDefinitionResponse.body.menuName
    And match updateMenuDefinitionPayload.body.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match updateMenuDefinitionPayload.body.isActive == updateMenuDefinitionResponse.body.isActive
    #Get the menu definiton
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | updateMenuDefinitionResponse.header.entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionCollectionNameRead+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMenuDefinitionResponse.id
    And match getMenuDefinitionResponse.menuName == updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionResponse.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionResponse.isActive == updateMenuDefinitionResponse.body.isActive
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody1
      | path            |                                                 0 |
      | menuName        |                                                   |
      | menuDescription | updateMenuDefinitionResponse.body.menuDescription |
      | isActive        |                                                   |
      | lastUpdatedDate |                                                   |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody1[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And match  getMenuDefinitionsResponse.results[*].isActive contains updateMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path            | 0 |
      | menuName        |   |
      | menuDescription |   |
      | isActive        |   |
      | lastUpdatedDate |   |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | {}                      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionsResponse.results[*].isActive contains updateMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getMenuDefinitionResponse.id
    And def parentEntityId = getMenuDefinitionResponse.id
    And def eventName = "MenuDefinitionUpdated"
    And def evnentType = "MenuDefinition"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
    And def eventEntityID = createMenuDefinitionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    And sleep(15000)
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithChangingNames
  Scenario Outline: Update menu definition with name change
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                            0 |
      | id              | createMenuDefinitionResponse.header.entityId |
      | menuName        | faker.getFirstName()                         |
      | menuDescription | faker.getRandomShortDescription()            |
      | isActive        | faker.getRandomBooleanValue()                |
    And set updateMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print updateMenuDefinitionPayload
    And request updateMenuDefinitionPayload
    When method POST
    Then status 201
    And def updateMenuDefinitionResponse = response
    And print updateMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionCollectionName+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateMenuDefinitionResponse.body.id
    And match updateMenuDefinitionPayload.body.menuName == updateMenuDefinitionResponse.body.menuName
    And match updateMenuDefinitionPayload.body.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match updateMenuDefinitionPayload.body.isActive == updateMenuDefinitionResponse.body.isActive
    #Get the menu definiton
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | updateMenuDefinitionResponse.header.entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionCollectionNameRead+<tenantid>,updateMenuDefinitionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMenuDefinitionResponse.id
    And match getMenuDefinitionResponse.menuName == updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionResponse.menuDescription == updateMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionResponse.isActive == updateMenuDefinitionResponse.body.isActive
    And sleep(15000)
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody1
      | path            |                                          0 |
      | menuName        | updateMenuDefinitionResponse.body.menuName |
      | menuDescription |                                            |
      | isActive        |                                            |
      | lastUpdatedDate |                                            |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody1[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match getMenuDefinitionsResponse.results[*].menuName contains updateMenuDefinitionResponse.body.menuName
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And match getMenuDefinitionsResponse.results[*].isActive contains updateMenuDefinitionResponse.body.isActive
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #    Get all menu definitions
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | updateMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | updateMenuDefinitionResponse.header.id            |
      | correlationId   | updateMenuDefinitionResponse.header.correlationId |
      | commandUserId   | updateMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[3]                                    |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set getCommandBody2
      | path            |      0 |
      | menuName        | "Test" |
      | menuDescription |        |
      | isActive        |        |
      | lastUpdatedDate |        |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMenuDefinitionsPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody2[0]      |
      | body.paginationSort | getCommandPagination[0] |
    And print getMenuDefinitionsPayload
    And request getMenuDefinitionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionsResponse = response
    And print getMenuDefinitionsResponse
    And match getMenuDefinitionsResponse.results[*].id contains updateMenuDefinitionResponse.body.id
    And match each getMenuDefinitionsResponse.results[*].menuName contains "Test"
    And match getMenuDefinitionsResponse.results[*].menuDescription contains updateMenuDefinitionResponse.body.menuDescription
    And def getMenuDefinitionsResponseCount = karate.sizeOf(getMenuDefinitionsResponse.results)
    And print getMenuDefinitionsResponseCount
    And match getMenuDefinitionsResponseCount == getMenuDefinitionsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getMenuDefinitionResponse.id
    And def parentEntityId = getMenuDefinitionResponse.id
    And def eventName = "MenuDefinitionUpdated"
    And def evnentType = "MenuDefinition"
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
    And def eventEntityID = createMenuDefinitionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    And sleep(15000)
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithMissingMandatoryField
  Scenario Outline: Update menu definition with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                            0 |
      | id              | createMenuDefinitionResponse.header.entityId |
      | menuName        | createMenuDefinitionResponse.body.menuName   |
      | menuDescription |                                              |
      | isActive        | faker.getRandomBooleanValue()                |
    And set createMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print createMenuDefinitionPayload
    And request createMenuDefinitionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithInvalidField
  Scenario Outline: Update menu definition with invalid field
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                          0 |
      | id              | faker.getRandom5DigitNumber()              |
      | menuName        | createMenuDefinitionResponse.body.menuName |
      | menuDescription | faker.getRandom5DigitNumber()              |
      | isActive        | faker.getRandomBooleanValue()              |
    And set updateMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print updateMenuDefinitionPayload
    And request updateMenuDefinitionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMenuDefinitionWithDuplicateName
  Scenario Outline: Update menu definition with duplicate name
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    #Create a menu definiton
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    #Create a menu definiton
    And def result1 = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse1 = result1.response
    And print createMenuDefinitionResponse1
    And set updateCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | entityId        | createMenuDefinitionResponse.header.entityId      |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | commandType[1]                                    |
      | entityName      | entityName[0]                                     |
      | ttl             |                                                 0 |
    And set updateCommandBody
      | path            |                                            0 |
      | id              | createMenuDefinitionResponse.header.entityId |
      | menuName        | createMenuDefinitionResponse1.body.menuName  |
      | menuDescription | faker.getRandomShortDescription()            |
      | isActive        | faker.getRandomBooleanValue()                |
    And set updateMenuDefinitionPayload
      | path   | [0]                    |
      | header | updateCommandHeader[0] |
      | body   | updateCommandBody[0]   |
    And print updateMenuDefinitionPayload
    And request updateMenuDefinitionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
