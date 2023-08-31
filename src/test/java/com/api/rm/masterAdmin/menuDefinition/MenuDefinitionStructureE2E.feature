@MenuDefinitionStructure
Feature: Menu Definition Structure -Add,Edit,View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def MenuDefintionCollectionName = 'CreateMenuDefinition_'
    And def MenuDefintionCollectionNameRead = 'MenuDefinitionDetailViewModel_'
    And def MenuDefintionStructureCollectionName = 'CreateMenuDefinitionStructure_'
    And def MenuDefintionStructureCollectionNameRead = 'MenuDefinitionStructureViewModel_'
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateMenuDefinition","UpdateMenuDefinition","GetMenuDefinition","GetMenuDefinitions","CreateMenuDefinitionStructure","UpdateMenuDefinitionStructure","GetMenuDefinitionStructure","GetMenuDefinitionStructures"]
    And def entityName = ["MenuDefinition","MenuDefinitionStructure"]
    And def itemType = ["Category","Page"]
    And def eventTypes = ['MenuDefinition','MenuDefinitionStructure']
    And def historyAndComments = ['Created','Updated']

  @CreateAndGetSubMenuItemWithItemTypeCategory
  Scenario Outline: Create one subMenu item with one item and get the details
    #calling CreateSubMenuItemWithItemTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithItemTypeCategory')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                 0 |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == CreateMenuStructureResponse.body.id
    And match getMenuStructureResponse.id == CreateMenuStructureResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == CreateMenuStructureResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == CreateMenuStructureResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == CreateMenuStructureResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == CreateMenuStructureResponse.body.menuItems[0].itemDescription
    And match getMenuStructureResponse.menuItems[0].itemType == CreateMenuStructureResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == CreateMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == CreateMenuStructureResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And def eventEntityID = getMenuStructureResponse.id
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

  @CreateAndGetSubMenuItemsWithItemCategory
  Scenario Outline: Create multiple subMenu Items with single menu item and get the details
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemsWithItemCategory')
    And def CreateSubMenuItemsWithOneItemResponse = result.response
    And print CreateSubMenuItemsWithOneItemResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                           0 |
      | menuDefinitionId | CreateSubMenuItemsWithOneItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == CreateSubMenuItemsWithOneItemResponse.body.id
    And match getMenuStructureResponse.id == CreateSubMenuItemsWithOneItemResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == CreateSubMenuItemsWithOneItemResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[1].id == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[1].id
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemTitle == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[1].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemDescription == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[1].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemUrl == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[1].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemSequence == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[1].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[2].id == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[2].id
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemTitle == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[2].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemDescription == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[2].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemUrl == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[2].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemSequence == CreateSubMenuItemsWithOneItemResponse.body.menuItems[0].subItems[2].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And def eventEntityID = getMenuStructureResponse.id
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

  @CreateAndGetSubMenuItemWithItemsCategory
  Scenario Outline: Create one subMenu items with multiple menu items
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithMultipleItems')
    And def CreateSubMenuItemWithMultipleItemsResponse = result.response
    And print CreateSubMenuItemWithMultipleItemsResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                                0 |
      | menuDefinitionId | CreateSubMenuItemWithMultipleItemsResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == CreateSubMenuItemWithMultipleItemsResponse.body.id
    And match getMenuStructureResponse.id == CreateSubMenuItemWithMultipleItemsResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == CreateSubMenuItemWithMultipleItemsResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[1].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[0].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].subItems[0].id
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemUrl == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[2].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[0].id == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].subItems[0].id
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemTitle == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemDescription == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemUrl == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemSequence == CreateSubMenuItemWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And def eventEntityID = getMenuStructureResponse.id
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

  @CreateAndGetSubMenuItemsWithMultipleItems
  Scenario Outline: Create multiple subMenu items with multiple menu items and get the details
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemsWithMultipleItems')
    And def CreateSubMenuItemsWithMultipleItemsResponse = result.response
    And print CreateSubMenuItemsWithMultipleItemsResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                                 0 |
      | menuDefinitionId | CreateSubMenuItemsWithMultipleItemsResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == CreateSubMenuItemsWithMultipleItemsResponse.body.id
    And match getMenuStructureResponse.id == CreateSubMenuItemsWithMultipleItemsResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == CreateSubMenuItemsWithMultipleItemsResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[1].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[1].id
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[1].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[1].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[1].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[1].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[2].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[2].id
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[2].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[2].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[2].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[0].subItems[2].subItemSequence
    And match getMenuStructureResponse.menuItems[1].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[0].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[0].id
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[1].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[1].id
    And match getMenuStructureResponse.menuItems[1].subItems[1].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[1].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[1].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[1].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[1].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[1].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[1].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[1].subItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[2].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[2].id
    And match getMenuStructureResponse.menuItems[1].subItems[2].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[2].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[2].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[2].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[2].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[2].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[2].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[1].subItems[2].subItemSequence
    And match getMenuStructureResponse.menuItems[2].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[0].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[0].id
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[1].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[1].id
    And match getMenuStructureResponse.menuItems[2].subItems[1].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[1].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[1].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[1].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[1].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[1].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[1].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[1].subItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[2].id == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[2].id
    And match getMenuStructureResponse.menuItems[2].subItems[2].subItemTitle == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[2].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[2].subItemDescription == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[2].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[2].subItemUrl == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[2].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[2].subItemSequence == CreateSubMenuItemsWithMultipleItemsResponse.body.menuItems[2].subItems[2].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetSubMenuItemWithTypeCategory
  Scenario Outline: update SubMenu item and menu item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithItemTypeCategory')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #update
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                                 0 |
      | id               | CreateMenuStructureResponse.body.id               |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                0 |
      | id               | CreateMenuStructureResponse.body.menuItems[0].id |
      | itemTitle        | faker.getFirstName()                             |
      | itemDescription  | faker.getRandomShortDescription()                |
      | itemType         | itemType[0]                                      |
      | menuItemSequence |                                                1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updateSubItemPayload
      | path                       | [0]                           |
      | header                     | updateCommandHeader[0]        |
      | body                       | updateCommandBody[0]          |
      | body.menuItems             | updatemenuItemsCommandBody    |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubItemResponse = response
    And print updateSubItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,updateSubItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.id == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match updateSubItemPayload.body.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match updateSubItemPayload.body.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match updateSubItemPayload.body.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #  And match updateSubItemPayload.body.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match updateSubItemPayload.body.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | updateSubItemResponse.header.sourceId       |
      | id              | updateSubItemResponse.header.id             |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | updateSubItemResponse.header.commandUserId  |
    And set getCommandBody
      | path             |                                           0 |
      | menuDefinitionId | updateSubItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match getMenuStructureResponse.id == updateSubItemResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #  And match getMenuStructureResponse.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetSubMenuItemsWithItemCategory
  Scenario Outline: update SubMenu Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemsWithItemCategory')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #update
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                                 0 |
      | id               | CreateMenuStructureResponse.body.id               |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                             0 |
      | id               | CreateMenuStructureResponse.body.menuItems[0].id              |
      | itemTitle        | CreateMenuStructureResponse.body.menuItems[0].itemTitle       |
      | itemDescription  | CreateMenuStructureResponse.body.menuItems[0].itemDescription |
      | itemType         | itemType[0]                                                   |
      | menuItemSequence |                                                             1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            1 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[1].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            2 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            2 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[2].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            3 |
    And set updateSubItemPayload
      | path                       | [0]                           |
      | header                     | updateCommandHeader[0]        |
      | body                       | updateCommandBody[0]          |
      | body.menuItems             | updatemenuItemsCommandBody    |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubItemResponse = response
    And print updateSubItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,updateSubItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.id == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match updateSubItemPayload.body.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match updateSubItemPayload.body.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match updateSubItemPayload.body.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match updateSubItemPayload.body.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match updateSubItemPayload.body.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[1].id == updateSubItemResponse.body.menuItems[0].subItems[1].id
    And match updateSubItemPayload.body.menuItems[0].subItems[1].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[1].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[1].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[1].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[1].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[1].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[1].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[1].subItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[2].id == updateSubItemResponse.body.menuItems[0].subItems[2].id
    And match updateSubItemPayload.body.menuItems[0].subItems[2].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[2].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[2].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[2].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[2].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[2].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[2].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[2].subItemSequence
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | updateSubItemResponse.header.sourceId       |
      | id              | updateSubItemResponse.header.id             |
      | correlationId   | updateSubItemResponse.header.correlationId  |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | updateSubItemResponse.header.commandUserId  |
    And set getCommandBody
      | path             |                                           0 |
      | menuDefinitionId | updateSubItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match getMenuStructureResponse.id == updateSubItemResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[1].id == updateSubItemResponse.body.menuItems[0].subItems[1].id
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[1].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[1].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[1].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[1].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[1].subItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[2].id == updateSubItemResponse.body.menuItems[0].subItems[2].id
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[2].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[2].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[2].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[2].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[2].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetSubMenuItemAssociatedWithMultipleItems
  Scenario Outline: update SubMenu Items when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithMultipleItems')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #update
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                                 0 |
      | id               | CreateMenuStructureResponse.body.id               |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                             0 |
      | id               | CreateMenuStructureResponse.body.menuItems[0].id              |
      | itemTitle        | CreateMenuStructureResponse.body.menuItems[0].itemTitle       |
      | itemDescription  | CreateMenuStructureResponse.body.menuItems[0].itemDescription |
      | itemType         | itemType[0]                                                   |
      | menuItemSequence |                                                             1 |
    And set updatemenuItemsCommandBody
      | path             |                                                             1 |
      | id               | CreateMenuStructureResponse.body.menuItems[1].id              |
      | itemTitle        | CreateMenuStructureResponse.body.menuItems[1].itemTitle       |
      | itemDescription  | CreateMenuStructureResponse.body.menuItems[1].itemDescription |
      | itemType         | itemType[0]                                                   |
      | menuItemSequence |                                                             2 |
    And set updatemenuItemsCommandBody
      | path             |                                                             2 |
      | id               | CreateMenuStructureResponse.body.menuItems[2].id              |
      | itemTitle        | CreateMenuStructureResponse.body.menuItems[2].itemTitle       |
      | itemDescription  | CreateMenuStructureResponse.body.menuItems[2].itemDescription |
      | itemType         | itemType[0]                                                   |
      | menuItemSequence |                                                             3 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updatesubMenuItemsCommandBody1
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[1].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updatesubMenuItemsCommandBody2
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[2].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updateSubItemPayload
      | path                       | [0]                            |
      | header                     | updateCommandHeader[0]         |
      | body                       | updateCommandBody[0]           |
      | body.menuItems             | updatemenuItemsCommandBody     |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody  |
      | body.menuItems[1].subItems | updatesubMenuItemsCommandBody1 |
      | body.menuItems[2].subItems | updatesubMenuItemsCommandBody2 |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubItemResponse = response
    And print updateSubItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,updateSubItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.id == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match updateSubItemPayload.body.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match updateSubItemPayload.body.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match updateSubItemPayload.body.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match updateSubItemPayload.body.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match updateSubItemPayload.body.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match updateSubItemPayload.body.menuItems[1].id == updateSubItemResponse.body.menuItems[1].id
    And match updateSubItemPayload.body.menuItems[1].itemTitle == updateSubItemResponse.body.menuItems[1].itemTitle
    And match updateSubItemPayload.body.menuItems[1].itemDescription == updateSubItemResponse.body.menuItems[1].itemDescription
    #And match updateSubItemPayload.body.menuItems[1].itemType == updateSubItemResponse.body.menuItems[1].itemType
    And match updateSubItemPayload.body.menuItems[1].menuItemSequence == updateSubItemResponse.body.menuItems[1].menuItemSequence
    And match updateSubItemPayload.body.menuItems[1].subItems[0].id == updateSubItemResponse.body.menuItems[1].subItems[0].id
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[1].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[1].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[1].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[1].subItems[0].subItemSequence
    And match updateSubItemPayload.body.menuItems[2].id == updateSubItemResponse.body.menuItems[2].id
    And match updateSubItemPayload.body.menuItems[2].itemTitle == updateSubItemResponse.body.menuItems[2].itemTitle
    And match updateSubItemPayload.body.menuItems[2].itemDescription == updateSubItemResponse.body.menuItems[2].itemDescription
    #And match updateSubItemPayload.body.menuItems[2].itemType == updateSubItemResponse.body.menuItems[2].itemType
    And match updateSubItemPayload.body.menuItems[2].menuItemSequence == updateSubItemResponse.body.menuItems[2].menuItemSequence
    And match updateSubItemPayload.body.menuItems[2].subItems[0].id == updateSubItemResponse.body.menuItems[2].subItems[0].id
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[2].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[2].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[2].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[2].subItems[0].subItemSequence
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | updateSubItemResponse.header.sourceId       |
      | id              | updateSubItemResponse.header.id             |
      | correlationId   | updateSubItemResponse.header.correlationId  |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | updateSubItemResponse.header.commandUserId  |
    And set getCommandBody
      | path             |                                           0 |
      | menuDefinitionId | updateSubItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match getMenuStructureResponse.id == updateSubItemResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[1].id == updateSubItemResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == updateSubItemResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == updateSubItemResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == updateSubItemResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == updateSubItemResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[0].id == updateSubItemResponse.body.menuItems[1].subItems[0].id
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[1].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[1].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[1].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[1].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[2].id == updateSubItemResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == updateSubItemResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == updateSubItemResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == updateSubItemResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == updateSubItemResponse.body.menuItems[2].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[0].id == updateSubItemResponse.body.menuItems[2].subItems[0].id
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[2].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[2].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[2].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[2].subItems[0].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetItemsAssociatedWithSubitem
  Scenario Outline: update Menu Items associated with submenuItem
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithMultipleItems')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #update
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                                 0 |
      | id               | CreateMenuStructureResponse.body.id               |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                0 |
      | id               | CreateMenuStructureResponse.body.menuItems[0].id |
      | itemTitle        | faker.getFirstName()                             |
      | itemDescription  | faker.getRandomShortDescription()                |
      | itemType         | itemType[0]                                      |
      | menuItemSequence |                                                1 |
    And set updatemenuItemsCommandBody
      | path             |                                                1 |
      | id               | CreateMenuStructureResponse.body.menuItems[1].id |
      | itemTitle        | faker.getFirstName()                             |
      | itemDescription  | faker.getRandomShortDescription()                |
      | itemType         | itemType[0]                                      |
      | menuItemSequence |                                                2 |
    And set updatemenuItemsCommandBody
      | path             |                                                2 |
      | id               | CreateMenuStructureResponse.body.menuItems[2].id |
      | itemTitle        | faker.getFirstName()                             |
      | itemDescription  | faker.getRandomShortDescription()                |
      | itemType         | itemType[0]                                      |
      | menuItemSequence |                                                2 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[0].id                 |
      | subItemTitle       | CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle       |
      | subItemDescription | CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription |
      | subItemUrl         | CreateMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl         |
      | subItemSequence    |                                                                            1 |
    And set updatesubMenuItemsCommandBody1
      | path               |                                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[1].subItems[0].id                 |
      | subItemTitle       | CreateMenuStructureResponse.body.menuItems[1].subItems[0].subItemTitle       |
      | subItemDescription | CreateMenuStructureResponse.body.menuItems[1].subItems[0].subItemDescription |
      | subItemUrl         | CreateMenuStructureResponse.body.menuItems[1].subItems[0].subItemUrl         |
      | subItemSequence    |                                                                            1 |
    And set updatesubMenuItemsCommandBody2
      | path               |                                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[2].subItems[0].id                 |
      | subItemTitle       | CreateMenuStructureResponse.body.menuItems[2].subItems[0].subItemTitle       |
      | subItemDescription | CreateMenuStructureResponse.body.menuItems[2].subItems[0].subItemDescription |
      | subItemUrl         | CreateMenuStructureResponse.body.menuItems[2].subItems[0].subItemUrl         |
      | subItemSequence    |                                                                            1 |
    And set updateSubItemPayload
      | path                       | [0]                            |
      | header                     | updateCommandHeader[0]         |
      | body                       | updateCommandBody[0]           |
      | body.menuItems             | updatemenuItemsCommandBody     |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody  |
      | body.menuItems[1].subItems | updatesubMenuItemsCommandBody1 |
      | body.menuItems[2].subItems | updatesubMenuItemsCommandBody2 |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubItemResponse = response
    And print updateSubItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,updateSubItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.id == updateSubItemResponse.body.id
    And match updateSubItemPayload.body.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match updateSubItemPayload.body.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match updateSubItemPayload.body.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match updateSubItemPayload.body.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match updateSubItemPayload.body.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match updateSubItemPayload.body.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match updateSubItemPayload.body.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match updateSubItemPayload.body.menuItems[1].id == updateSubItemResponse.body.menuItems[1].id
    And match updateSubItemPayload.body.menuItems[1].itemTitle == updateSubItemResponse.body.menuItems[1].itemTitle
    And match updateSubItemPayload.body.menuItems[1].itemDescription == updateSubItemResponse.body.menuItems[1].itemDescription
    #And match updateSubItemPayload.body.menuItems[1].itemType == updateSubItemResponse.body.menuItems[1].itemType
    And match updateSubItemPayload.body.menuItems[1].menuItemSequence == updateSubItemResponse.body.menuItems[1].menuItemSequence
    And match updateSubItemPayload.body.menuItems[1].subItems[0].id == updateSubItemResponse.body.menuItems[1].subItems[0].id
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[1].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[1].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[1].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[1].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[1].subItems[0].subItemSequence
    And match updateSubItemPayload.body.menuItems[2].id == updateSubItemResponse.body.menuItems[2].id
    And match updateSubItemPayload.body.menuItems[2].itemTitle == updateSubItemResponse.body.menuItems[2].itemTitle
    And match updateSubItemPayload.body.menuItems[2].itemDescription == updateSubItemResponse.body.menuItems[2].itemDescription
    #And match updateSubItemPayload.body.menuItems[2].itemType == updateSubItemResponse.body.menuItems[2].itemType
    And match updateSubItemPayload.body.menuItems[2].menuItemSequence == updateSubItemResponse.body.menuItems[2].menuItemSequence
    And match updateSubItemPayload.body.menuItems[2].subItems[0].id == updateSubItemResponse.body.menuItems[2].subItems[0].id
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[2].subItems[0].subItemTitle
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[2].subItems[0].subItemDescription
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[2].subItems[0].subItemUrl
    And match updateSubItemPayload.body.menuItems[2].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[2].subItems[0].subItemSequence
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                           0 |
      | menuDefinitionId | updateSubItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    And match getMenuStructureResponse.id == updateSubItemResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == updateSubItemResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == updateSubItemResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == updateSubItemResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == updateSubItemResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == updateSubItemResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == updateSubItemResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[0].subItems[0].id == updateSubItemResponse.body.menuItems[0].subItems[0].id
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[0].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[0].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[0].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[0].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[0].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[1].id == updateSubItemResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == updateSubItemResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == updateSubItemResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == updateSubItemResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == updateSubItemResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].subItems[0].id == updateSubItemResponse.body.menuItems[1].subItems[0].id
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[1].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[1].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[1].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[1].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[1].subItems[0].subItemSequence
    And match getMenuStructureResponse.menuItems[2].id == updateSubItemResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == updateSubItemResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == updateSubItemResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == updateSubItemResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == updateSubItemResponse.body.menuItems[2].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].subItems[0].id == updateSubItemResponse.body.menuItems[2].subItems[0].id
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemTitle == updateSubItemResponse.body.menuItems[2].subItems[0].subItemTitle
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemDescription == updateSubItemResponse.body.menuItems[2].subItems[0].subItemDescription
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemUrl == updateSubItemResponse.body.menuItems[2].subItems[0].subItemUrl
    And match getMenuStructureResponse.menuItems[2].subItems[0].subItemSequence == updateSubItemResponse.body.menuItems[2].subItems[0].subItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetSubMenuItemsWithMultipleItems
  Scenario Outline: update SubMenu Item and item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithItemTypeCategory')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #update
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                                 0 |
      | id               | CreateMenuStructureResponse.body.id               |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                0 |
      | id               | CreateMenuStructureResponse.body.menuItems[0].id |
      | itemTitle        | faker.getFirstName()                             |
      | itemDescription  | faker.getRandomShortDescription()                |
      | itemType         | itemType[0]                                      |
      | menuItemSequence |                                                1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                            0 |
      | id                 | CreateMenuStructureResponse.body.menuItems[0].subItems[0].id |
      | subItemTitle       | faker.getFirstName()                                         |
      | subItemDescription | faker.getRandomShortDescription()                            |
      | subItemUrl         | faker.getLastName()                                          |
      | subItemSequence    |                                                            1 |
    And set updateSubItemPayload
      | path                       | [0]                           |
      | header                     | updateCommandHeader[0]        |
      | body                       | updateCommandBody[0]          |
      | body.menuItems             | updatemenuItemsCommandBody    |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubItemResponse = response
    And print updateSubItemResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                           0 |
      | menuDefinitionId | updateSubItemResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updateSubItemResponse.body.id
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @CreateAndGetMenuItemWithItemTypePage
  Scenario Outline: Create menu items when item type is page and get the details
    #calling CreateSubMenuItemWithItemTypeCategory
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateMenuItemsWithItemTypePage')
    And def CreateMenuStructureResponse = result.response
    And print CreateMenuStructureResponse
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                 0 |
      | menuDefinitionId | CreateMenuStructureResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == CreateMenuStructureResponse.body.id
    And match getMenuStructureResponse.id == CreateMenuStructureResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == CreateMenuStructureResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == CreateMenuStructureResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == CreateMenuStructureResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == CreateMenuStructureResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == CreateMenuStructureResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].itemUrl == CreateMenuStructureResponse.body.menuItems[0].itemUrl
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == CreateMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].id == CreateMenuStructureResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == CreateMenuStructureResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == CreateMenuStructureResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == CreateMenuStructureResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].itemUrl == CreateMenuStructureResponse.body.menuItems[1].itemUrl
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == CreateMenuStructureResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].id == CreateMenuStructureResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == CreateMenuStructureResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == CreateMenuStructureResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == CreateMenuStructureResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].itemUrl == CreateMenuStructureResponse.body.menuItems[2].itemUrl
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == CreateMenuStructureResponse.body.menuItems[2].menuItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And def eventEntityID = getMenuStructureResponse.id
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

  @UpdateAndGetMenuItemsWithTypePage
  Scenario Outline: Update menu items when Type is Page and get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #calling CreateSubMenuItemWithTypePage
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateMenuItemsWithItemTypePage')
    And def CreateMenuItemWithTypePageResponse = result.response
    And print CreateMenuItemWithTypePageResponse
    #update
    And set updateCommandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"             |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | CreateMenuItemWithTypePageResponse.header.sourceId      |
      | tenantId        | <tenantid>                                              |
      | id              | CreateMenuItemWithTypePageResponse.header.id            |
      | correlationId   | CreateMenuItemWithTypePageResponse.header.correlationId |
      | entityId        | CreateMenuItemWithTypePageResponse.header.entityId      |
      | commandUserId   | CreateMenuItemWithTypePageResponse.header.commandUserId |
      | entityVersion   |                                                       1 |
      | tags            | []                                                      |
      | commandType     | commandType[5]                                          |
      | entityName      | entityName[1]                                           |
      | ttl             |                                                       0 |
    And set updateCommandBody
      | path             |                                                        0 |
      | id               | CreateMenuItemWithTypePageResponse.body.id               |
      | menuDefinitionId | CreateMenuItemWithTypePageResponse.body.menuDefinitionId |
    And set updatemenuItemsCommandBody
      | path             |                                                       0 |
      | id               | CreateMenuItemWithTypePageResponse.body.menuItems[0].id |
      | itemTitle        | faker.getFirstName()                                    |
      | itemDescription  | faker.getRandomShortDescription()                       |
      | itemType         | itemType[1]                                             |
      | itemUrl          | faker.getLastName()                                     |
      | menuItemSequence |                                                       1 |
    And set updatemenuItemsCommandBody
      | path             |                                                       1 |
      | id               | CreateMenuItemWithTypePageResponse.body.menuItems[1].id |
      | itemTitle        | faker.getFirstName()                                    |
      | itemDescription  | faker.getRandomShortDescription()                       |
      | itemType         | itemType[1]                                             |
      | itemUrl          | faker.getLastName()                                     |
      | menuItemSequence |                                                       2 |
    And set updatemenuItemsCommandBody
      | path             |                                                       2 |
      | id               | CreateMenuItemWithTypePageResponse.body.menuItems[2].id |
      | itemTitle        | faker.getFirstName()                                    |
      | itemDescription  | faker.getRandomShortDescription()                       |
      | itemType         | itemType[1]                                             |
      | itemUrl          | faker.getLastName()                                     |
      | menuItemSequence |                                                       3 |
    And set updatePageItemsPayload
      | path           | [0]                        |
      | header         | updateCommandHeader[0]     |
      | body           | updateCommandBody[0]       |
      | body.menuItems | updatemenuItemsCommandBody |
    And print updatePageItemsPayload
    And request updatePageItemsPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updatePageItemsResponse = response
    And print updatePageItemsResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,updatePageItemsResponse.body.id)
    And print mongoResult
    And match mongoResult == updatePageItemsResponse.body.id
    And match updatePageItemsPayload.body.id == updatePageItemsResponse.body.id
    And match updatePageItemsPayload.body.menuDefinitionId == updatePageItemsResponse.body.menuDefinitionId
    And match updatePageItemsPayload.body.menuItems[0].id == updatePageItemsResponse.body.menuItems[0].id
    And match updatePageItemsPayload.body.menuItems[0].itemTitle == updatePageItemsResponse.body.menuItems[0].itemTitle
    And match updatePageItemsPayload.body.menuItems[0].itemDescription == updatePageItemsResponse.body.menuItems[0].itemDescription
    #And match updatePageItemsPayload.body.menuItems[0].itemType == updatePageItemsResponse.body.menuItems[0].itemType
    And match updatePageItemsPayload.body.menuItems[0].itemUrl == updatePageItemsResponse.body.menuItems[0].itemUrl
    And match updatePageItemsPayload.body.menuItems[0].menuItemSequence == updatePageItemsResponse.body.menuItems[0].menuItemSequence
    And match updatePageItemsPayload.body.menuItems[1].id == updatePageItemsResponse.body.menuItems[1].id
    And match updatePageItemsPayload.body.menuItems[1].itemTitle == updatePageItemsResponse.body.menuItems[1].itemTitle
    And match updatePageItemsPayload.body.menuItems[1].itemDescription == updatePageItemsResponse.body.menuItems[1].itemDescription
    #And match updatePageItemsPayload.body.menuItems[1].itemType == updatePageItemsResponse.body.menuItems[1].itemType
    And match updatePageItemsPayload.body.menuItems[1].itemUrl == updatePageItemsResponse.body.menuItems[1].itemUrl
    And match updatePageItemsPayload.body.menuItems[1].menuItemSequence == updatePageItemsResponse.body.menuItems[1].menuItemSequence
    And match updatePageItemsPayload.body.menuItems[2].id == updatePageItemsResponse.body.menuItems[2].id
    And match updatePageItemsPayload.body.menuItems[2].itemTitle == updatePageItemsResponse.body.menuItems[2].itemTitle
    And match updatePageItemsPayload.body.menuItems[2].itemDescription == updatePageItemsResponse.body.menuItems[2].itemDescription
    #And match updatePageItemsPayload.body.menuItems[2].itemType == updatePageItemsResponse.body.menuItems[2].itemType
    And match updatePageItemsPayload.body.menuItems[2].itemUrl == updatePageItemsResponse.body.menuItems[2].itemUrl
    And match updatePageItemsPayload.body.menuItems[2].menuItemSequence == updatePageItemsResponse.body.menuItems[2].menuItemSequence
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                             0 |
      | menuDefinitionId | updatePageItemsResponse.body.menuDefinitionId |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,MenuDefintionStructureCollectionNameRead+<tenantid>,getMenuStructureResponse.id)
    And print mongoResult
    And match mongoResult == updatePageItemsResponse.body.id
    And match getMenuStructureResponse.id == updatePageItemsResponse.body.id
    And match getMenuStructureResponse.menuDefinitionId == updatePageItemsResponse.body.menuDefinitionId
    And match getMenuStructureResponse.menuItems[0].id == updatePageItemsResponse.body.menuItems[0].id
    And match getMenuStructureResponse.menuItems[0].itemTitle == updatePageItemsResponse.body.menuItems[0].itemTitle
    And match getMenuStructureResponse.menuItems[0].itemDescription == updatePageItemsResponse.body.menuItems[0].itemDescription
    #And match getMenuStructureResponse.menuItems[0].itemType == updatePageItemsResponse.body.menuItems[0].itemType
    And match getMenuStructureResponse.menuItems[0].itemUrl == updatePageItemsResponse.body.menuItems[0].itemUrl
    And match getMenuStructureResponse.menuItems[0].menuItemSequence == updatePageItemsResponse.body.menuItems[0].menuItemSequence
    And match getMenuStructureResponse.menuItems[1].id == updatePageItemsResponse.body.menuItems[1].id
    And match getMenuStructureResponse.menuItems[1].itemTitle == updatePageItemsResponse.body.menuItems[1].itemTitle
    And match getMenuStructureResponse.menuItems[1].itemDescription == updatePageItemsResponse.body.menuItems[1].itemDescription
    #And match getMenuStructureResponse.menuItems[1].itemType == updatePageItemsResponse.body.menuItems[1].itemType
    And match getMenuStructureResponse.menuItems[1].itemUrl == updatePageItemsResponse.body.menuItems[1].itemUrl
    And match getMenuStructureResponse.menuItems[1].menuItemSequence == updatePageItemsResponse.body.menuItems[1].menuItemSequence
    And match getMenuStructureResponse.menuItems[2].id == updatePageItemsResponse.body.menuItems[2].id
    And match getMenuStructureResponse.menuItems[2].itemTitle == updatePageItemsResponse.body.menuItems[2].itemTitle
    And match getMenuStructureResponse.menuItems[2].itemDescription == updatePageItemsResponse.body.menuItems[2].itemDescription
    #And match getMenuStructureResponse.menuItems[2].itemType == updatePageItemsResponse.body.menuItems[2].itemType
    And match getMenuStructureResponse.menuItems[2].itemUrl == updatePageItemsResponse.body.menuItems[2].itemUrl
    And match getMenuStructureResponse.menuItems[2].menuItemSequence == updatePageItemsResponse.body.menuItems[2].menuItemSequence
    #HistoryValidation
    And def entityIdData = getMenuStructureResponse.id
    And def parentEntityId = getMenuStructureResponse.menuDefinitionId
    And def eventName = "MenuDefinitionStructureCreated"
    And def evnentType = "MenuDefinitionStructure"
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
    And match getHistoryResponseCount == 3
    #Adding the comments
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getMenuStructureResponse.id
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

  @CreateSubMenuItemWithItemTypeCategoryWithMissingItemAndSubItem
  Scenario Outline: Create menu structure  with missing items and subitems
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                        0 |
      | id               | dataGenerator.entityID() |
      | itemTitle        | faker.getFirstName()     |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]              |
      | menuItemSequence |                        1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path   | [0]                    |
      | header | createCommandHeader[0] |
      | body   | createCommandBody[0]   |
    #| body.menuItems             | menuItemsCommandBody    |
    #| body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithItemTypeCategoryWithMissingMandateFieldOfItem1
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      #| itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithItemTypeCategoryWithMissingMandateFieldOfItem2
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                        0 |
      | id               | dataGenerator.entityID() |
      | itemTitle        | faker.getFirstName()     |
      #| itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]              |
      | menuItemSequence |                        1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithItemTypeCategoryWithMissingMandateFieldOfSubMenu1
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      #| subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithItemTypeCategoryWithMissingMandateFieldOfSubMenu2
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path            |                        0 |
      | id              | dataGenerator.entityID() |
      | subItemTitle    | faker.getFirstName()     |
      #| subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl      | faker.getLastName()      |
      | subItemSequence |                        1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithItemTypeCategoryWithMissingMandateFieldOfSubMenu3
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      #| subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuItemsWithItemTypePageWithMissingMandateField1
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And def menuItemId = dataGenerator.entityID()
    And def subMenuId = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      #| itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]                       |
      | itemUrl          | faker.getLastName()               |
      | menuItemSequence |                                 1 |
    And set createPageItemsPayload
      | path           | [0]                    |
      | header         | createCommandHeader[0] |
      | body           | createCommandBody[0]   |
      | body.menuItems | menuItemsCommandBody   |
    And print createPageItemsPayload
    And request createPageItemsPayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuItemsWithItemTypePageWithMissingMandateField2
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And def menuItemId = dataGenerator.entityID()
    And def subMenuId = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                        0 |
      | id               | dataGenerator.entityID() |
      | itemTitle        | faker.getFirstName()     |
      #| itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]              |
      | itemUrl          | faker.getLastName()      |
      | menuItemSequence |                        1 |
    And set createPageItemsPayload
      | path           | [0]                    |
      | header         | createCommandHeader[0] |
      | body           | createCommandBody[0]   |
      | body.menuItems | menuItemsCommandBody   |
    And print createPageItemsPayload
    And request createPageItemsPayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuItemsWithItemTypePageWithMissingMandateField3
  Scenario Outline: Create menu structure with missing mandatory field
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And def menuItemId = dataGenerator.entityID()
    And def subMenuId = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]                       |
      #| itemUrl          | faker.getLastName()               |
      | menuItemSequence |                                 1 |
    And set createPageItemsPayload
      | path           | [0]                    |
      | header         | createCommandHeader[0] |
      | body           | createCommandBody[0]   |
      | body.menuItems | menuItemsCommandBody   |
    And print createPageItemsPayload
    And request createPageItemsPayload
    When method POST
    And print response
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DuplicateItemWithTypeCategory
  Scenario Outline: Create duplicate Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #Create menu structure
    And def createResult = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithItemTypeCategory')
    And def CreateMenuStructureResponse = createResult.response
    And print CreateMenuStructureResponse
    And def menuDefinitionID = CreateMenuStructureResponse.body.menuDefinitionId
    #Get menu Definition
    And def getResult = call read('GetMenuDefinitionAndMenuStructure.feature@GetSubMenuItemWithItemTypeCategory'){menuDefinitionID:'#(menuDefinitionID)'}
    And def getMenuDefinitionStructureResponse = getResult.response
    And print getMenuDefinitionStructureResponse
    And def itemTitleValue = getMenuDefinitionStructureResponse.menuItems[0].itemTitle
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                0 |
      | id               | entityIdData     |
      | menuDefinitionId | menuDefinitionID |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | itemTitleValue                    |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    And print response
    Then status 400
    And print response
    And match response contains 'DuplicateKey:MenuItem cannot be created. The count has already been setup'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DuplicateSubitemwithItemTypeCategory
  Scenario Outline: Create duplicate SubMenu Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 1 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | "duplicateSubitemTest"            |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 2 |
    And set subMenuItemsCommandBody
      | path               |                                 2 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | "duplicateSubitemTest"            |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 3 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:MenuItem cannot be created. The count has already been setup'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DuplicateSubitemwithItemTypeCategoryUpdate
  Scenario Outline: Create duplicate SubMenu Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[5]
    #Create menu structure
    And def createResult = call read('CreateMenuDefinitionStructure.feature@CreateSubMenuItemWithItemTypeCategory')
    And def CreateMenuStructureResponse = createResult.response
    And print CreateMenuStructureResponse
    And def menuDefinitionID = CreateMenuStructureResponse.body.menuDefinitionId
    #Get menu Definition
    And def getResult = call read('GetMenuDefinitionAndMenuStructure.feature@GetSubMenuItemWithItemTypeCategory'){menuDefinitionID:'#(menuDefinitionID)'}
    And def getMenuDefinitionStructureResponse = getResult.response
    And print getMenuDefinitionStructureResponse
    And def itemTitleValue = getMenuDefinitionStructureResponse.menuItems[0].itemTitle
    And def entityIdData = dataGenerator.entityID()
    And set updateCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | CreateMenuStructureResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | CreateMenuStructureResponse.header.id            |
      | correlationId   | CreateMenuStructureResponse.header.correlationId |
      | entityId        | CreateMenuStructureResponse.header.entityId      |
      | commandUserId   | CreateMenuStructureResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[5]                                   |
      | entityName      | entityName[1]                                    |
      | ttl             |                                                0 |
    And set updateCommandBody
      | path             |                                     0 |
      | id               | getMenuDefinitionStructureResponse.id |
      | menuDefinitionId | menuDefinitionID                      |
    And set updatemenuItemsCommandBody
      | path             |                                                               0 |
      | id               | getMenuDefinitionStructureResponse.menuItems[0].id              |
      | itemTitle        | getMenuDefinitionStructureResponse.menuItems[0].itemTitle       |
      | itemDescription  | getMenuDefinitionStructureResponse.menuItems[0].itemDescription |
      | itemType         | itemType[0]                                                     |
      | menuItemSequence |                                                               1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                                              0 |
      | id                 | getMenuDefinitionStructureResponse.menuItems[0].subItems[0].id                 |
      | subItemTitle       | getMenuDefinitionStructureResponse.menuItems[0].subItems[0].subItemTitle       |
      | subItemDescription | getMenuDefinitionStructureResponse.menuItems[0].subItems[0].subItemDescription |
      | subItemUrl         | getMenuDefinitionStructureResponse.menuItems[0].subItems[0].subItemUrl         |
      | subItemSequence    |                                                                              1 |
    And set updatesubMenuItemsCommandBody
      | path               |                                                                        1 |
      | id                 | dataGenerator.entityID()                                                 |
      | subItemTitle       | getMenuDefinitionStructureResponse.menuItems[0].subItems[0].subItemTitle |
      | subItemDescription | faker.getRandomShortDescription()                                        |
      | subItemUrl         | faker.getLastName()                                                      |
      | subItemSequence    |                                                                        2 |
    And set updateSubItemPayload
      | path                       | [0]                           |
      | header                     | updateCommandHeader[0]        |
      | body                       | updateCommandBody[0]          |
      | body.menuItems             | updatemenuItemsCommandBody    |
      | body.menuItems[0].subItems | updatesubMenuItemsCommandBody |
    And print updateSubItemPayload
    And request updateSubItemPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:SubMenuItem cannot be created. The count has already been setup'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateMenuItemWithTypePage
  Scenario Outline: Create duplicate Item when Type is Page
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling CreateMenuItemWithTypePage
    And def result = call read('CreateMenuDefinitionStructure.feature@CreateMenuItemsWithItemTypePage')
    And def CreateMenuItemWithTypePageResponse = result.response
    And print CreateMenuItemWithTypePageResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
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
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                                        0 |
      | id               | entityIdData                                             |
      | menuDefinitionId | CreateMenuItemWithTypePageResponse.body.menuDefinitionId |
    And set menuItemsCommandBody
      | path             |                                                              0 |
      | id               | dataGenerator.entityID()                                       |
      | itemTitle        | CreateMenuItemWithTypePageResponse.body.menuItems[0].itemTitle |
      | itemDescription  | faker.getRandomShortDescription()                              |
      | itemType         | itemType[1]                                                    |
      | itemUrl          | faker.getLastName()                                            |
      | menuItemSequence |                                                              1 |
    And set createPageItemsPayload
      | path           | [0]                    |
      | header         | createCommandHeader[0] |
      | body           | createCommandBody[0]   |
      | body.menuItems | menuItemsCommandBody   |
    And print createPageItemsPayload
    And request createPageItemsPayload
    When method POST
    And print response
    Then status 400
    And print response
    And match response contains 'DuplicateKey:MenuItem cannot be created. The count has already been setup'

    Examples: 
      | tenantid    |
      | tenantID[0] |
