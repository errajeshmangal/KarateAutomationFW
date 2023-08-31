@GenericLayoutMasterInfoE2E
Feature: Generic Layout Master info - Add, Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayOutMasterInfoCollectionName = 'CreateGenericLayoutMasterInfo_'
    And def genericLayOutMasterInfoCollectionNameRead = 'GenericLayoutMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateGenericLayoutMasterInfo','UpdateGenericLayoutMasterInfo']
    And def eventTypes = ['GenericLayoutMasterInfo']
    And def layOutType = ['Generic Layout']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['GenericLayoutMasterInfo']

  @CreateGenericLayoutMasterInfoAndGet-indexingStyle
  Scenario Outline: Create the Generic Layout master info and get the details - IndexingStyle
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyle'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    And match createGenericLayoutResponse.body.layoutCode == getGenericLayoutMasterInfoResponse.layoutCode
    And match createGenericLayoutResponse.body.workFlowType == getGenericLayoutMasterInfoResponse.workFlowType
    And match createGenericLayoutResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse.layoutDescription
    And match createGenericLayoutResponse.body.longDescription == getGenericLayoutMasterInfoResponse.longDescription
    And match createGenericLayoutResponse.body.indexingStyle == getGenericLayoutMasterInfoResponse.indexingStyle
    And match createGenericLayoutResponse.body.verificationStyle == getGenericLayoutMasterInfoResponse.verificationStyle
    And match createGenericLayoutResponse.body.verifyInSequence == getGenericLayoutMasterInfoResponse.verifyInSequence
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    @indexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |

    @indexWithFreeSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification |

    @indexWithSplitBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | BlindVerification |

    @indexWithSplitSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | SightVerification |

  @CreateGenericLayoutMasterInfoAndGet-FillingCashiering
  Scenario Outline: Create the Generic Layout master info and get the details - IndexingStyle
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashiering'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    And match createGenericLayoutResponse.body.layoutCode == getGenericLayoutMasterInfoResponse.layoutCode
    And match createGenericLayoutResponse.body.workFlowType == getGenericLayoutMasterInfoResponse.workFlowType
    And match createGenericLayoutResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse.layoutDescription
    And match createGenericLayoutResponse.body.isActive == getGenericLayoutMasterInfoResponse.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    @FillingCashieringFreeBlind
    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-FillingCashiering
  Scenario Outline: Update the Generic Layout Master info with all fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashiering'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path              |                                               0 |
      | id                | getGenericLayoutMasterInfoResponse.id           |
      | workFlowType      | getGenericLayoutMasterInfoResponse.workFlowType |
      | layoutCode        | faker.getUserId()                               |
      | layoutType        | getGenericLayoutMasterInfoResponse.layoutType   |
      | layoutDescription | faker.getRandomNumber()                         |
      | longDescription   | faker.getRandomLongDescription()                |
      | isActive          | faker.getRandomBooleanValue()                   |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 0
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == updateGenericLayOutMasterInfoPayload.body.longDescription
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.isActive == getGenericLayoutMasterInfoResponse1.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-indexingStyle
  Scenario Outline: Update the Generic Layout Master info with all fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyle'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path                  |                                     0 |
      | id                    | getGenericLayoutMasterInfoResponse.id |
      | layoutCode            | faker.getUserId()                     |
      | workFlowType          | workFlowType                          |
      | layoutType            | layOutType[0]                         |
      | layoutDescription     | faker.getRandomNumber()               |
      | longDescription       | faker.getRandomLongDescription()      |
      | isActive              | faker.getRandomBooleanValue()         |
      | indexingStyle         | indexingStyle                         |
      | showAutoIndexValues   | faker.getRandomBooleanValue()         |
      | verificationStyle     | verificationStyle                     |
      | verifyInSequence      | faker.getRandomBooleanValue()         |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()         |
      | showAutoIndex         | faker.getRandomBooleanValue()         |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.showAutoIndex == updateGenericLayOutMasterInfoPayload.body.showAutoIndex
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 1
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == updateGenericLayOutMasterInfoPayload.body.longDescription
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == getGenericLayoutMasterInfoResponse1.longDescription
    And match updateGenericLayOutMasterInfoResponse.body.indexingStyle == getGenericLayoutMasterInfoResponse1.indexingStyle
    And match updateGenericLayOutMasterInfoResponse.body.verificationStyle == getGenericLayoutMasterInfoResponse1.verificationStyle
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    @updateIndexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification |

    @updateIndexWithFreeSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | BlindVerification |

    @updateIndexWithSplitBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |

    @updateIndexWithSplitSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | SightVerification |

  @createGenericLayoutWithDuplicateLayoutCode
  Scenario Outline: Create the Generic Layout Master info with duplicate Layout code
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyle'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #create another Generic Layout Master Info
    And def entityIdData = dataGenerator.entityID()
    And set duplicateGenericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set duplicateGenericLayOutMasterInfoCommandBody
      | path                  |                                             0 |
      | id                    | entityIdData                                  |
      | layoutCode            | getGenericLayoutMasterInfoResponse.layoutCode |
      | workFlowType          | workFlowType                                  |
      | layoutType            | layOutType[0]                                 |
      | layoutDescription     | faker.getRandomNumber()                       |
      | longDescription       | faker.getRandomLongDescription()              |
      | isActive              | faker.getRandomBooleanValue()                 |
      | indexingStyle         | indexingStyle                                 |
      | showAutoIndexValues   | faker.getRandomBooleanValue()                 |
      | verificationStyle     | verificationStyle                             |
      | verifyInSequence      | faker.getRandomBooleanValue()                 |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()                 |
      | showAutoIndex         | faker.getRandomBooleanValue()                 |
    And set duplicateGenericLayOutMasterInfoPayload
      | path   | [0]                                              |
      | header | duplicateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | duplicateGenericLayOutMasterInfoCommandBody[0]   |
    And print duplicateGenericLayOutMasterInfoPayload
    And request duplicateGenericLayOutMasterInfoPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:LayoutCode cannot be created.'

    @duplicateIndexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |

    @duplicateIndexWithFreeSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification |

    @duplicateIndexWithSplitBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | BlindVerification |

    @duplicateIndexWithSplitSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | SightVerification |

  @createGenericLayoutWithDuplicateLayoutCode-FillingCashiering
  Scenario Outline: Create the Generic Layout Master info with duplicate Layout code-FillingCashiering
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashiering'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #create another Generic Layout Master Info
    And def entityIdData = dataGenerator.entityID()
    And set duplicateGenericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set duplicateGenericLayOutMasterInfoCommandBody
      | path              |                                             0 |
      | id                | entityIdData                                  |
      | layoutCode        | getGenericLayoutMasterInfoResponse.layoutCode |
      | workFlowType      | workFlowType                                  |
      | layoutType        | layOutType[0]                                 |
      | layoutDescription | faker.getRandomNumber()                       |
      | longDescription   | faker.getRandomLongDescription()              |
      | isActive          | faker.getRandomBooleanValue()                 |
    And set duplicateGenericLayOutMasterInfoPayload
      | path   | [0]                                              |
      | header | duplicateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | duplicateGenericLayOutMasterInfoCommandBody[0]   |
    And print duplicateGenericLayOutMasterInfoPayload
    And request duplicateGenericLayOutMasterInfoPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:LayoutCode cannot be created.'

    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-FillingCashieringFromIndex
  Scenario Outline: Update the Generic Layout Master info with all fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashiering'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path                  |                                     0 |
      | id                    | getGenericLayoutMasterInfoResponse.id |
      | layoutCode            | faker.getUserId()                     |
      | workFlowType          | workFlowType1                         |
      | layoutType            | layOutType[0]                         |
      | layoutDescription     | faker.getRandomNumber()               |
      | longDescription       | faker.getRandomLongDescription()      |
      | isActive              | faker.getRandomBooleanValue()         |
      | indexingStyle         | indexingStyle                         |
      | showAutoIndexValues   | faker.getRandomBooleanValue()         |
      | verificationStyle     | verificationStyle                     |
      | verifyInSequence      | faker.getRandomBooleanValue()         |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()         |
      | showAutoIndex         | faker.getRandomBooleanValue()         |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.showAutoIndex == updateGenericLayOutMasterInfoPayload.body.showAutoIndex
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 1
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == updateGenericLayOutMasterInfoPayload.body.longDescription
    #Get the updated data
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == getGenericLayoutMasterInfoResponse1.longDescription
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    @updateIndexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType1        | indexingStyle  | verificationStyle | workFlowType      |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-Index-FillingCashiering
  Scenario Outline: Update the Generic Layout Master info with all fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyle'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path              |                                             0 |
      | id                | getGenericLayoutMasterInfoResponse.id         |
      | workFlowType      | workFlowType1                                 |
      | layoutCode        | faker.getUserId()                             |
      | layoutType        | getGenericLayoutMasterInfoResponse.layoutType |
      | layoutDescription | faker.getRandomNumber()                       |
      | longDescription   | faker.getRandomLongDescription()              |
      | isActive          | faker.getRandomBooleanValue()                 |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 0
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == updateGenericLayOutMasterInfoPayload.body.longDescription
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.isActive == getGenericLayoutMasterInfoResponse1.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    @updateIndexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle | workFlowType1     |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification | FillingCashiering |

  @CreateGenericLayOutMasterInfoIndexingStyleWithInvalidDataToMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with Invalid data To Mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set genericLayOutMasterInfoCommandBody
      | path                  |                                0 |
      | id                    | entityIdData                     |
      | layoutCode            | faker.getUserId()                |
      | workFlowType          | workFlowType                     |
      | layoutType            | layOutType[0]                    |
      | layoutDescription     | ""                               |
      | longDescription       | faker.getRandomLongDescription() |
      | isActive              | faker.getRandomBooleanValue()    |
      | indexingStyle         | indexingStyle                    |
      | showAutoIndexValues   | faker.getRandomBooleanValue()    |
      | verificationStyle     | verificationStyle                |
      | verifyInSequence      | faker.getRandomBooleanValue()    |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()    |
      | showAutoIndex         | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle | workFlowType1     |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification | FillingCashiering |

  @CreateGenericLayOutMasterInfo-FillingCashieringInvalidDataToMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with invalidData to mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set genericLayOutMasterInfoCommandBody
      | path              |                                0 |
      | id                | entityIdData                     |
      | workFlowType      | workFlowType                     |
      | layoutCode        | ""                               |
      | layoutType        | layOutType[0]                    |
      | layoutDescription | faker.getRandomNumber()          |
      | longDescription   | faker.getRandomLongDescription() |
      | isActive          | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @CreateGenericLayOutMasterInfoIndexingStyleWithMissingMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with Missing Mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set genericLayOutMasterInfoCommandBody
      | path                  |                                0 |
      | id                    | entityIdData                     |
      | layoutCode            | faker.getUserId()                |
      | workFlowType          | workFlowType                     |
      | layoutType            | layOutType[0]                    |
      #    | layoutDescription     | faker.getRandomNumber()          |
      | longDescription       | faker.getRandomLongDescription() |
      | isActive              | faker.getRandomBooleanValue()    |
      | indexingStyle         | indexingStyle                    |
      | showAutoIndexValues   | faker.getRandomBooleanValue()    |
      | verificationStyle     | verificationStyle                |
      | verifyInSequence      | faker.getRandomBooleanValue()    |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()    |
      | showAutoIndex         | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle | workFlowType1     |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification | FillingCashiering |

  @CreateGenericLayOutMasterInfo-FillingCashieringMissingMandatoryFields
  Scenario Outline: Validate Create Generic Layout Master Info information with missing mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set genericLayOutMasterInfoCommandHeader
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
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set genericLayOutMasterInfoCommandBody
      | path            |                                0 |
      | id              | entityIdData                     |
      | workFlowType    | workFlowType                     |
      | layoutCode      | " "                              |
      | layoutType      | layOutType[0]                    |
      #   | layoutDescription | faker.getRandomNumber()          |
      | longDescription | faker.getRandomLongDescription() |
    #  | isActive          | faker.getRandomBooleanValue()    |
    And set genericLayOutMasterInfoPayload
      | path   | [0]                                     |
      | header | genericLayOutMasterInfoCommandHeader[0] |
      | body   | genericLayOutMasterInfoCommandBody[0]   |
    And print genericLayOutMasterInfoPayload
    And request genericLayOutMasterInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @CreateGenericLayoutMasterInfoAndGet-indexingStyleWithMandatoryFields
  Scenario Outline: Create the Generic Layout master info With MandatoryFields and get the details - IndexingStyle
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyleWithMandatoryFields'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    And match createGenericLayoutResponse.body.layoutCode == getGenericLayoutMasterInfoResponse.layoutCode
    And match createGenericLayoutResponse.body.workFlowType == getGenericLayoutMasterInfoResponse.workFlowType
    And match createGenericLayoutResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse.layoutDescription
    And match createGenericLayoutResponse.body.indexingStyle == getGenericLayoutMasterInfoResponse.indexingStyle
    And match createGenericLayoutResponse.body.verificationStyle == getGenericLayoutMasterInfoResponse.verificationStyle
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    @indexWithFreeBlindWithMandatoryFields
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |

    @indexWithFreeSightWithMandatoryFields
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification |

    @indexWithSplitBlindWithMandatoryFields
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | BlindVerification |

    @indexWithSplitSightWithMandatoryFields
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | SightVerification |

  @CreateGenericLayoutMasterInfoAndGet-FillingCashieringWithMandatoryFields
  Scenario Outline: Create the Generic Layout master info and get the details WithMandatoryFields - IndexingStyle
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashieringWithMandatoryFields'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    And match createGenericLayoutResponse.body.layoutCode == getGenericLayoutMasterInfoResponse.layoutCode
    And match createGenericLayoutResponse.body.workFlowType == getGenericLayoutMasterInfoResponse.workFlowType
    And match createGenericLayoutResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse.layoutDescription
    And match createGenericLayoutResponse.body.isActive == getGenericLayoutMasterInfoResponse.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    @FillingCashieringFreeBlind
    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-FillingCashiering
  Scenario Outline: Update the Generic Layout Master info with all fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-FillingCashieringWithMandatoryFields'){'workFlowType':<workFlowType>}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path              |                                               0 |
      | id                | getGenericLayoutMasterInfoResponse.id           |
      | workFlowType      | getGenericLayoutMasterInfoResponse.workFlowType |
      | layoutCode        | faker.getUserId()                               |
      | layoutType        | getGenericLayoutMasterInfoResponse.layoutType   |
      | layoutDescription | faker.getRandomNumber()                         |
      | longDescription   | faker.getRandomLongDescription()                |
      | isActive          | faker.getRandomBooleanValue()                   |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 0
    And match updateGenericLayOutMasterInfoResponse.body.longDescription == updateGenericLayOutMasterInfoPayload.body.longDescription
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.isActive == getGenericLayoutMasterInfoResponse1.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    | workFlowType      |
      | tenantID[0] | FillingCashiering |

  @updateGenericLayoutMasterInfoAndGet-indexingStyleWithMandatoryFields
  Scenario Outline: Update the Generic Layout Master info with Mandatory fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandTypes[1]
    #Call the create GenericLayout MasterInfo details API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@CreateGenericLayOutMasterInfo-IndexingStyleWithMandatoryFields'){'workFlowType':<workFlowType>}{'indexingStyle':<indexingStyle>'}{verificationStyle:'<verificationStyle>'}
    And def createGenericLayoutResponse = result.response
    And print createGenericLayoutResponse
    And def genericMasterInfoEntityId = createGenericLayoutResponse.body.id
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse = getGenericLayoutMasterInfoResult.response
    And print getGenericLayoutMasterInfoResponse
    #Update the Generic Layout details
    And set updateGenericLayOutMasterInfoCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | getGenericLayoutMasterInfoResponse.id        |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateGenericLayOutMasterInfoCommandBody
      | path                  |                                     0 |
      | id                    | getGenericLayoutMasterInfoResponse.id |
      | layoutCode            | faker.getUserId()                     |
      | workFlowType          | workFlowType                          |
      | layoutType            | layOutType[0]                         |
      | layoutDescription     | faker.getRandomNumber()               |
      | longDescription       | faker.getRandomLongDescription()      |
      | isActive              | faker.getRandomBooleanValue()         |
      | indexingStyle         | indexingStyle                         |
      | showAutoIndexValues   | faker.getRandomBooleanValue()         |
      | verificationStyle     | verificationStyle                     |
      | allowToVerifyOwnIndex | faker.getRandomBooleanValue()         |
    And set updateGenericLayOutMasterInfoPayload
      | path   | [0]                                           |
      | header | updateGenericLayOutMasterInfoCommandHeader[0] |
      | body   | updateGenericLayOutMasterInfoCommandBody[0]   |
    And print updateGenericLayOutMasterInfoPayload
    And request updateGenericLayOutMasterInfoPayload
    When method POST
    Then status 201
    And def updateGenericLayOutMasterInfoResponse = response
    And print updateGenericLayOutMasterInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayOutMasterInfoCollectionName+<tenantid>,updateGenericLayOutMasterInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayOutMasterInfoResponse.body.id
    And match updateGenericLayOutMasterInfoResponse.body.showAutoIndexValues == updateGenericLayOutMasterInfoPayload.body.showAutoIndexValues
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == updateGenericLayOutMasterInfoPayload.body.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == 1
    And match updateGenericLayOutMasterInfoResponse.body.allowToVerifyOwnIndex == updateGenericLayOutMasterInfoPayload.body.allowToVerifyOwnIndex
    #Call the get API GenericLayout MasterInfo details
    And def getGenericLayoutMasterInfoResult1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericLayouts/genericLayoutMasterInfo/CreateGenericLayoutMasterInfo.feature@getGenericLayoutMasterInfo'){'genericMasterInfoEntityId': '#(genericMasterInfoEntityId)'}
    And def getGenericLayoutMasterInfoResponse1 = getGenericLayoutMasterInfoResult1.response
    And print getGenericLayoutMasterInfoResponse1
    And match updateGenericLayOutMasterInfoResponse.body.layoutCode == getGenericLayoutMasterInfoResponse1.layoutCode
    And match updateGenericLayOutMasterInfoResponse.body.workFlowType == getGenericLayoutMasterInfoResponse1.workFlowType
    And match updateGenericLayOutMasterInfoResponse.body.layoutDescription == getGenericLayoutMasterInfoResponse1.layoutDescription
    And match updateGenericLayOutMasterInfoResponse.body.allowToVerifyOwnIndex == getGenericLayoutMasterInfoResponse1.allowToVerifyOwnIndex
    And match updateGenericLayOutMasterInfoResponse.body.indexingStyle == getGenericLayoutMasterInfoResponse1.indexingStyle
    And match updateGenericLayOutMasterInfoResponse.body.verificationStyle == getGenericLayoutMasterInfoResponse1.verificationStyle
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutMasterInfoResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutMasterInfoResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    @updateIndexWithFreeBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | SightVerification |

    @updateIndexWithFreeSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | BlindVerification |

    @updateIndexWithSplitBlind
    Examples: 
      | tenantid    | workFlowType         | indexingStyle  | verificationStyle |
      | tenantID[0] | IndexingVerification | FreeFormatName | BlindVerification |

    @updateIndexWithSplitSight
    Examples: 
      | tenantid    | workFlowType         | indexingStyle   | verificationStyle |
      | tenantID[0] | IndexingVerification | SplitFormatName | SightVerification |
