@AddBehaviourItemTypesScenarios
Feature: Add Item Type- Master Info

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def behaviourItemTypeCollectionName = 'CreateItemTypeBehaviour_'
    And def behaviourItemTypeCollectionNameRead = 'ItemTypeBehaviourDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateBehaviourItemTypesWithAllFields
  Scenario Outline: Create Behaviour Item type with all Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@SearchProfile')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    Given url readBaseUrl
    #GetBehaviourItemType
    And path '/api/GetItemTypeBehaviour'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetItemTypeBehaviour-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | commandUserId   | addBehaviourItemTypeResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetItemTypeBehaviour"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path               |                                            0 |
      | request.itemTypeId | addBehaviourItemTypeResponse.body.itemTypeId |
    And set getBehaviourItemTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getBehaviourItemTypePayload
    And sleep(15000)
    And request getBehaviourItemTypePayload
    When method POST
    Then status 200
    And def getBehaviourItemTypeResponse = response
    And print getBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,addBehaviourItemTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getBehaviourItemTypeResponse.id
    And match getBehaviourItemTypeResponse.isSearch == addBehaviourItemTypeResponse.body.isSearch
    And match getBehaviourItemTypeResponse.searchableDocumentClass.name == addBehaviourItemTypeResponse.body.searchableDocumentClass.name
    And match getBehaviourItemTypeResponse.itemTypeId == addBehaviourItemTypeResponse.body.itemTypeId
    #Adding the comment
    And def entityName = "ItemTypeBehaviour"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addBehaviourItemTypeResponse.body.id
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
    And def evnentType = "ItemTypeBehaviour"
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    And sleep(15000)
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    # History Validation
    And def eventName = "ItemTypeBehaviourCreated"
    And def evnentType = "ItemTypeBehaviour"
    And def commandUserid = commandUserId
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def parentEntityId = addBehaviourItemTypeResponse.body.id
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateBehaviourItemTypesWithMandatoryFIelds
  Scenario Outline: Create Behaviour Item type with Mandatory Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@CreateBehaviourItemTypeswithMandatoryFields')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    Given url readBaseUrl
    #GetBehaviourItemType
    And path '/api/GetItemTypeBehaviour'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetItemTypeBehaviour-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | commandUserId   | addBehaviourItemTypeResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetItemTypeBehaviour"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path               |                                            0 |
      | request.itemTypeId | addBehaviourItemTypeResponse.body.itemTypeId |
    And set getBehaviourItemTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getBehaviourItemTypePayload
    And sleep(15000)
    And request getBehaviourItemTypePayload
    When method POST
    Then status 200
    And def getBehaviourItemTypeResponse = response
    And print getBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,addBehaviourItemTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getBehaviourItemTypeResponse.id
    And match getBehaviourItemTypeResponse.isSearch == addBehaviourItemTypeResponse.body.isSearch
    And match getBehaviourItemTypeResponse.searchableDocumentClass.name == addBehaviourItemTypeResponse.body.searchableDocumentClass.name
    And match getBehaviourItemTypeResponse.itemTypeId == addBehaviourItemTypeResponse.body.itemTypeId
    #Adding the comment
    And def entityName = "ItemTypeBehaviour"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addBehaviourItemTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "ItemTypeBehaviour"
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "ItemTypeBehaviourCreated"
    And def evnentType = "ItemTypeBehaviour"
    And def commandUserid = commandUserId
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def parentEntityId = addBehaviourItemTypeResponse.body.id
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
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

  @UpdateBehaviourItemTypesWithAllFields
  Scenario Outline: Update Behaviour Item type with all Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@SearchProfile')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    #Update item Type
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeBehaviour'
    And set updateBehaviourItemTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeBehaviour-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | entityId        | addBehaviourItemTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeBehaviour"                         |
      | entityName      | "ItemTypeBehaviour"                               |
      | ttl             |                                                 0 |
    And set updateCompatibleTypeCommandBody
      | path                         |                                                 0 |
      | id                           | addBehaviourItemTypeResponse.header.entityId      |
      | itemTypeId                   | addBehaviourItemTypeResponse.body.id              |
      | isEnableNotInSystemButton    | faker.getRandomBooleanValue()                     |
      | documentType[0].id           | dataGenerator.commandUserId()                     |
      | documentType[0].name         | "County Recorder Department Test Name"            |
      | documentType[0].code         | "County Recorder Department Test code"            |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[1].id          |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[1].name        |
      | searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                              |
      | isAllowWithOtherItemTypes    | faker.getRandomBooleanValue()                     |
      | isAllowMultiplesOnOrder      | faker.getRandomBooleanValue()                     |
      | maxItemCopiesAllowed         | faker.getRandom5DigitNumber()                     |
      | isAutoPromptForVariables     | faker.getRandomBooleanValue()                     |
      | actionAfterRecordingItem     | faker.actionAfterRecordingItem()                  |
      | actionAfterCompletingItem    | faker.actionAfterCompletingItem()                 |
      | actionAfterCashieringItem    | faker.actionAfterCashieringItem()                 |
    And set updateBehaviourItemTypePayload
      | path   | [0]                                     |
      | header | updateBehaviourItemTypeCommandHeader[0] |
      | body   | updateCompatibleTypeCommandBody[0]      |
    And print updateBehaviourItemTypePayload
    And request updateBehaviourItemTypePayload
    When method POST
    Then status 201
    And sleep(15000)
    And print response
    And def updateBehaviourItemTypeResponse = response
    And print updateBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,behaviourItemTypeCollectionName+<tenantid>,addBehaviourItemTypeResponse.header.entityId )
    And print mongoResult
    And match mongoResult == updateBehaviourItemTypeResponse.body.id
    And match updateBehaviourItemTypeResponse.body.isSearch  == updateBehaviourItemTypePayload.body.isSearch
    And match updateBehaviourItemTypeResponse.body.searchProfile.name == updateBehaviourItemTypePayload.body.searchProfile.name
    And match updateBehaviourItemTypeResponse.body.searchableDocumentClass.id == updateBehaviourItemTypePayload.body.searchableDocumentClass.id
    And match updateBehaviourItemTypeResponse.body.documentType[0].name == updateBehaviourItemTypePayload.body.documentType[0].name
    And match updateBehaviourItemTypeResponse.body.itemTypeId == addBehaviourItemTypeResponse.body.id
    #GetUpdatedBehaviourItemType
    Given url readBaseUrl
    And path '/api/GetItemTypeBehaviour'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetItemTypeBehaviour-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | commandUserId   | addBehaviourItemTypeResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetItemTypeBehaviour"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path               |                                               0 |
      | request.itemTypeId | updateBehaviourItemTypeResponse.body.itemTypeId |
    And set getBehaviourItemTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getBehaviourItemTypePayload
    And sleep(15000)
    And request getBehaviourItemTypePayload
    When method POST
    Then status 200
    And def getBehaviourItemTypeResponse = response
    And print getBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,addBehaviourItemTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getBehaviourItemTypeResponse.id
    And match getBehaviourItemTypeResponse.isSearch == updateBehaviourItemTypeResponse.body.isSearch
    And match getBehaviourItemTypeResponse.searchableDocumentClass.name == updateBehaviourItemTypeResponse.body.searchableDocumentClass.name
    And match getBehaviourItemTypeResponse.itemTypeId == updateBehaviourItemTypeResponse.body.itemTypeId
    #Adding the comment
    And def entityName = "ItemTypeBehaviour"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addBehaviourItemTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "ItemTypeBehaviour"
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
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
    # History Validation
    And def eventName = "ItemTypeBehaviourCreated"
    And def evnentType = "ItemTypeBehaviour"
    And def commandUserid = commandUserId
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def parentEntityId = addBehaviourItemTypeResponse.body.id
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBehaviourItemTypesWithmMandatoryFields
  Scenario Outline: Update Behaviour Item type with mandatory Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@SearchProfile')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    #Update item Type
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeBehaviour'
    And set updateBehaviourItemTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeBehaviour-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | entityId        | addBehaviourItemTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeBehaviour"                         |
      | entityName      | "ItemTypeBehaviour"                               |
      | ttl             |                                                 0 |
    And set updateCompatibleTypeCommandBody
      | path                         |                                                 0 |
      | id                           | addBehaviourItemTypeResponse.header.entityId      |
      | itemTypeId                   | addBehaviourItemTypeResponse.body.id              |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[1].id          |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[1].name        |
      | searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                              |
    And set updateBehaviourItemTypePayload
      | path   | [0]                                     |
      | header | updateBehaviourItemTypeCommandHeader[0] |
      | body   | updateCompatibleTypeCommandBody[0]      |
    And print updateBehaviourItemTypePayload
    And request updateBehaviourItemTypePayload
    When method POST
    Then status 201
    And print response
    And def updateBehaviourItemTypeResponse = response
    And print updateBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,behaviourItemTypeCollectionName+<tenantid>,addBehaviourItemTypeResponse.header.entityId )
    And print mongoResult
    And match mongoResult == updateBehaviourItemTypeResponse.body.id
    And match updateBehaviourItemTypeResponse.body.isSearch  == updateBehaviourItemTypePayload.body.isSearch
    And match updateBehaviourItemTypeResponse.body.searchProfile.name == updateBehaviourItemTypePayload.body.searchProfile.name
    And match updateBehaviourItemTypeResponse.body.searchableDocumentClass.id == updateBehaviourItemTypePayload.body.searchableDocumentClass.id
    And match updateBehaviourItemTypeResponse.body.itemTypeId == addBehaviourItemTypeResponse.body.id
    #GetUpdatedBehaviourItemType
    Given url readBaseUrl
    And path '/api/GetItemTypeBehaviour'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetItemTypeBehaviour-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | commandUserId   | addBehaviourItemTypeResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetItemTypeBehaviour"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path               |                                               0 |
      | request.itemTypeId | updateBehaviourItemTypeResponse.body.itemTypeId |
    And set getBehaviourItemTypePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getBehaviourItemTypePayload
    And sleep(15000)
    And request getBehaviourItemTypePayload
    When method POST
    Then status 200
    And def getBehaviourItemTypeResponse = response
    And print getBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,addBehaviourItemTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getBehaviourItemTypeResponse.id
    And match getBehaviourItemTypeResponse.isSearch == updateBehaviourItemTypeResponse.body.isSearch
    And match getBehaviourItemTypeResponse.searchableDocumentClass.name == updateBehaviourItemTypeResponse.body.searchableDocumentClass.name
    And match getBehaviourItemTypeResponse.itemTypeId == updateBehaviourItemTypeResponse.body.itemTypeId
    #Adding the comment
    And def entityName = "ItemTypeBehaviour"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addBehaviourItemTypeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "ItemTypeBehaviour"
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
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
    # History Validation
    And def eventName = "ItemTypeBehaviourCreated"
    And def evnentType = "ItemTypeBehaviour"
    And def commandUserid = commandUserId
    And def entityIdData = addBehaviourItemTypeResponse.body.id
    And def parentEntityId = addBehaviourItemTypeResponse.body.id
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,behaviourItemTypeCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateBehaviourItemTypeswithoutMandatoryFields @SearchProfile
  Scenario Outline: Create Behaviour Item type withoutMandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateItemTypeBehaviour'
    #calling MasterInfo Item Type ID
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CopyRequest')
    And def masterInfoItemTypeResponse = resultItemType.response
    And print masterInfoItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandBehaiourHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateItemTypeBehaviour-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "CreateItemTypeBehaviour"                        |
      | entityName      | "ItemTypeBehaviour"                              |
      | ttl             |                                                0 |
    And set commandBehaviourBody
      | path                         |                                          0 |
      | id                           | entityIdData                               |
      | itemTypeId                   | masterInfoItemTypeResponse.body.id         |
      | isEnableNotInSystemButton    | faker.getRandomBooleanValue()              |
      | documentType[0].id           | dataGenerator.commandUserId()              |
      | documentType[0].name         | "County Recorder Department Test Name"     |
      | documentType[0].code         | "County Recorder Department Test code"     |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[0].id   |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[0].name |
      #| searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      #| searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      #| searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                       |
      | isAllowWithOtherItemTypes    | faker.getRandomBooleanValue()              |
      | isAllowMultiplesOnOrder      | faker.getRandomBooleanValue()              |
      | maxItemCopiesAllowed         | faker.getRandom5DigitNumber()              |
      | isAutoPromptForVariables     | faker.getRandomBooleanValue()              |
      | actionAfterRecordingItem     | faker.actionAfterRecordingItem()           |
      | actionAfterCompletingItem    | faker.actionAfterCompletingItem()          |
      | actionAfterCashieringItem    | faker.actionAfterCashieringItem()          |
    And set createBehaviourItemTypePayload
      | path   | [0]                      |
      | header | commandBehaiourHeader[0] |
      | body   | commandBehaviourBody[0]  |
    And print createBehaviourItemTypePayload
    And request createBehaviourItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBehaviourItemTypesWithmMandatoryFields
  Scenario Outline: Update Behaviour Item type without mandatory Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@SearchProfile')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
   #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    #Update item Type
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeBehaviour'
    And set updateBehaviourItemTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeBehaviour-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | entityId        | addBehaviourItemTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeBehaviour"                         |
      | entityName      | "ItemTypeBehaviour"                               |
      | ttl             |                                                 0 |
    And set updateCompatibleTypeCommandBody
      | path                         |                                                 0 |
      | id                           | addBehaviourItemTypeResponse.header.entityId      |
      | itemTypeId                   | addBehaviourItemTypeResponse.body.id              |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[1].id          |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[1].name        |
      | searchableDocumentClass.code | getDocumentClassesResponse.results[1].code        |
      #| searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                              |
    And set updateBehaviourItemTypePayload
      | path   | [0]                                     |
      | header | updateBehaviourItemTypeCommandHeader[0] |
      | body   | updateCompatibleTypeCommandBody[0]      |
    And print updateBehaviourItemTypePayload
    And request updateBehaviourItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateBehaviourItemTypesWithmMandatoryFields
  Scenario Outline: Update Behaviour Item type with invalid Details and validate
    #calling Create Behaviour Item Type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@SearchProfile')
    And def addBehaviourItemTypeResponse = resultItemType.response
    And print addBehaviourItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    And def entityIdData = dataGenerator.entityID()
   #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    #Update item Type
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeBehaviour'
    And set updateBehaviourItemTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeBehaviour-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addBehaviourItemTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addBehaviourItemTypeResponse.header.id            |
      | correlationId   | addBehaviourItemTypeResponse.header.correlationId |
      | entityId        | addBehaviourItemTypeResponse.header.entityId      |
      | commandUserId   | commandUserId                                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeBehaviour"                         |
      | entityName      | "ItemTypeBehaviour"                               |
      | ttl             |                                                 0 |
    And set updateCompatibleTypeCommandBody
      | path                         |                                                 0 |
      | id                           | addBehaviourItemTypeResponse.header.entityId      |
      | itemTypeId                   | addBehaviourItemTypeResponse.body.id              |
      | isEnableNotInSystemButton    | getDocumentClassesResponse.results[1].name        |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[1].id          |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[1].name        |
      | searchableDocumentClass.code | getDocumentClassesResponse.results[1].code        |
      | searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                              |
    And set updateBehaviourItemTypePayload
      | path   | [0]                                     |
      | header | updateBehaviourItemTypeCommandHeader[0] |
      | body   | updateCompatibleTypeCommandBody[0]      |
    And print updateBehaviourItemTypePayload
    And request updateBehaviourItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
