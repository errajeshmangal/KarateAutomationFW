@CreateCompatibleTypeE2E
Feature: CompatiblePaymentType, Update, Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatCompatibleCollectionName = 'CreateCompatibleType_'
    And def createCompatibleCollectionNameRead = 'CompatibleTypeDetailViewModel_'
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def usage = ['Primary','Secondary']
    And def pullDownSeq = 'pullDownSequence'

  @CreateCompatiblePaymentTypeAndGet
  Scenario Outline: Create a compatible payment Type with all fields and Get the details
    Given url readBaseUrl
    And path '/api/GetCompatiblePaymentType'
    #CreateCompatiblePaymentType
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentType')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    And set getCompatibleTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetCompatiblePaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetCompatiblePaymentType"                        |
      | entityName      | "CompatibleType"                                  |
      | ttl             |                                                 0 |
      | getType         | "One"                                             |
    And set getCompatibleTypeCommandBody
      | path          |                                                  0 |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set getCompatibleTypePayload
      | path         | [0]                               |
      | header       | getCompatibleTypeCommandHeader[0] |
      | body.request | getCompatibleTypeCommandBody[0]   |
    And print getCompatibleTypePayload
    And request getCompatibleTypePayload
    When method POST
    Then status 200
    And print response
    And def getCompatibleTypeResponse = response
    And print getCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createCompatibleCollectionNameRead+<tenantid>,CreateCompatiblePaymentResponse.body.id)
    And print mongoResult
    And match mongoResult == getCompatibleTypeResponse.id
    And match getCompatibleTypeResponse.compatibleTypes[1].selected == true
    And match each getCompatibleTypeResponse.compatibleTypes[*].isActive == true
    #HistoryValidation
    And def entityIdData = getCompatibleTypeResponse.id
    And def parentEntityId = getCompatibleTypeResponse.paymentTypeId
    And def eventName = "CompatibleTypeCreated"
    And def evnentType = "CompatibleType"
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
    And def entityName = "CompatibleType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCompatibleTypeResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "CompatibleType"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCompatiblePaymentTypeWithMandatoryDetailsAndGet
  Scenario Outline: Create a compatible payment Type with Mandatory fields and Get the details
    Given url readBaseUrl
    And path '/api/GetCompatiblePaymentType'
    #CreateCompatiblePaymentType
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentTypeWithMandatoryFields')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    And set getCompatibleTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetCompatiblePaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetCompatiblePaymentType"                        |
      | entityName      | "CompatibleType"                                  |
      | ttl             |                                                 0 |
      | getType         | "One"                                             |
    And set getCompatibleTypeCommandBody
      | path          |                                                  0 |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set getCompatibleTypePayload
      | path         | [0]                               |
      | header       | getCompatibleTypeCommandHeader[0] |
      | body.request | getCompatibleTypeCommandBody[0]   |
    And print getCompatibleTypePayload
    And request getCompatibleTypePayload
    When method POST
    Then status 200
    And print response
    And def getCompatibleTypeResponse = response
    And print getCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createCompatibleCollectionNameRead+<tenantid>,CreateCompatiblePaymentResponse.body.id)
    And print mongoResult
    And match mongoResult == getCompatibleTypeResponse.id
    And match getCompatibleTypeResponse.compatibleTypes[1].selected == true
    And match each getCompatibleTypeResponse.compatibleTypes[*].isActive == true
    #HistoryValidation
    And def entityIdData = getCompatibleTypeResponse.id
    And def parentEntityId = getCompatibleTypeResponse.paymentTypeId
    And def eventName = "CompatibleTypeCreated"
    And def evnentType = "CompatibleType"
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
    And def entityName = "CompatibleType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCompatibleTypeResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "CompatibleType"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCompatiblePaymentTypeWithMissingMandatoryFields
  Scenario Outline: Create a compatible payment Type with Missing Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateCompatibleType'
    And def entityIdData = dataGenerator.entityID()
    #CreatePaymentType
    And def createPaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = createPaymentResponseResult.response
    And print createPaymentResponse
    #PulldownSequence
    And def pullDownSeqData = mongoData.MongoDBHelperToReadFields(dbname,creatCompatibleCollectionName+<tenantid>,pullDownSeq)
    And print pullDownSeqData
    And set createCompatibleTypeCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCompatibleType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "CreateCompatibleType"                        |
      | entityName      | "CompatibleType"                              |
      | ttl             |                                             0 |
    And set createCompatibleTypeCommandBody
      | path          |                             0 |
      | id            | entityIdData                  |
      | paymentTypeId | createPaymentResponse.body.id |
    And set createCompatibleTypes
      | path             |                                      0 |
      | id               | dataGenerator.Id()                     |
      | paymentType      | createPaymentResponse.body.paymentType |
      | pullDownSequence | pullDownSeqData                        |
      | isActive         | faker.getRandomBoolean()               |
    And set createCompatibleTypes
      | path        |                                      1 |
      | id          | dataGenerator.Id()                     |
      | paymentType | createPaymentResponse.body.paymentType |
      | isActive    | faker.getRandomBoolean()               |
    And set createCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | createCompatibleTypeCommandHeader[0] |
      | body                 | createCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | createCompatibleTypes                |
    And print createCompatibleTypePayload
    And request createCompatibleTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCompatiblePaymentTypeWithInvalidDataToMandatoryFields
  Scenario Outline: Create a compatible payment Type with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateCompatibleType'
    And def entityIdData = dataGenerator.entityID()
    #CreatePaymentType
    And def createPaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = createPaymentResponseResult.response
    And print createPaymentResponse
    #PulldownSequence
    And def pullDownSeqData = mongoData.MongoDBHelperToReadFields(dbname,creatCompatibleCollectionName+<tenantid>,pullDownSeq)
    And print pullDownSeqData
    And set createCompatibleTypeCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCompatibleType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "CreateCompatibleType"                        |
      | entityName      | "CompatibleType"                              |
      | ttl             |                                             0 |
    And set createCompatibleTypeCommandBody
      | path          |                             0 |
      | id            | entityIdData                  |
      | paymentTypeId | createPaymentResponse.body.id |
    And set createCompatibleTypes
      | path             |                                      0 |
      | id               | dataGenerator.Id()                     |
      | paymentType      | createPaymentResponse.body.paymentType |
      | pullDownSequence | pullDownSeqData                        |
      | isActive         | faker.getRandomBoolean()               |
    And set createCompatibleTypes
      | path             |                                      1 |
      | id               | dataGenerator.Id()                     |
      | paymentType      | createPaymentResponse.body.paymentType |
      | pullDownSequence | faker.getRandomBoolean()               |
      | isActive         | faker.getRandomBoolean()               |
    And set createCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | createCompatibleTypeCommandHeader[0] |
      | body                 | createCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | createCompatibleTypes                |
    And print createCompatibleTypePayload
    And request createCompatibleTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCompatiblePaymentTypeWithDuplicatePullDownSeq
  Scenario Outline: Create a compatible payment Type with duplicate pulldown seq
    Given url commandBaseUrl
    And path '/api/CreateCompatibleType'
    And def entityIdData = dataGenerator.entityID()
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentType')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    And def paymentTypeId = createPaymentResponse.body.id
    #Getting Compatible Payment Types
    And def getCompatiblePaymentResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/GetCompatiblePaymentTypes.feature@getCompatiblePaymentTypes'){paymentTypeId:'#(paymentTypeId)'}
    And def getCompatiblePaymentResponse = getCompatiblePaymentResult.response
    And print getCompatiblePaymentResponse
    And def pullDownSeqData = getCompatiblePaymentResponse.compatibleTypes[0].pullDownSequence
    And print pullDownSeqData
    And set createCompatibleTypeCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCompatibleType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "CreateCompatibleType"                        |
      | entityName      | "CompatibleType"                              |
      | ttl             |                                             0 |
    And set createCompatibleTypeCommandBody
      | path          |                                       0 |
      | id            | entityIdData                            |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.id |
    And set createCompatibleTypes
      | path             |                                                                   0 |
      | id               | dataGenerator.Id()                                                  |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType |
      | pullDownSequence | pullDownSeqData                                                     |
      | isActive         | faker.getRandomBoolean()                                            |
    And set createCompatibleTypes
      | path             |                                                                   1 |
      | id               | dataGenerator.Id()                                                  |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[1].paymentType |
      | pullDownSequence | pullDownSeqData+1                                                   |
      | isActive         | faker.getRandomBoolean()                                            |
    And set createCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | createCompatibleTypeCommandHeader[0] |
      | body                 | createCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | createCompatibleTypes                |
    And print createCompatibleTypePayload
    And request createCompatibleTypePayload
    When method POST
    Then status 400
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCompatiblePaymentTypeWithAllFields
  Scenario Outline: Update a compatible payment type with all the details
    Given url commandBaseUrl
    And path '/api/UpdateCompatibleType'
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentType')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    #Updating pulldown sequence
    And def pullDownSeqData = CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence+1
    #Update Compatible Payment Type
    And set updateCompatibleTypeCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateCompatibleType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | CreateCompatiblePaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | CreateCompatiblePaymentResponse.header.id            |
      | correlationId   | CreateCompatiblePaymentResponse.header.correlationId |
      | entityId        | CreateCompatiblePaymentResponse.header.entityId      |
      | commandUserId   | commandUserId                                        |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateCompatibleType"                               |
      | entityName      | "CompatibleType"                                     |
      | ttl             |                                                    0 |
    And set updateCompatibleTypeCommandBody
      | path          |                                                  0 |
      | id            | CreateCompatiblePaymentResponse.header.entityId    |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set updateCompatibleTypes
      | path                  |                                                                        0 |
      | id                    | CreateCompatiblePaymentResponse.body.compatibleTypes[0].id               |
      | paymentType           | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType      |
      | pullDownSequence      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence |
      | overPaymentCondition  | faker.getPaymentCondition()                                              |
      | underPaymentCondition | faker.getPaymentCondition()                                              |
      | isActive              | CreateCompatiblePaymentResponse.body.compatibleTypes[0].isActive         |
      | selected              | false                                                                    |
    And set updateCompatibleTypes
      | path                  |                                                                        1 |
      | id                    | CreateCompatiblePaymentResponse.body.compatibleTypes[1].id               |
      | paymentType           | CreateCompatiblePaymentResponse.body.compatibleTypes[1].paymentType      |
      | pullDownSequence      | CreateCompatiblePaymentResponse.body.compatibleTypes[1].pullDownSequence |
      | overPaymentCondition  | faker.getPaymentCondition()                                              |
      | underPaymentCondition | faker.getPaymentCondition()                                              |
      | isActive              | CreateCompatiblePaymentResponse.body.compatibleTypes[1].isActive         |
      | selected              | false                                                                    |
    And set updateCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | updateCompatibleTypeCommandHeader[0] |
      | body                 | updateCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | updateCompatibleTypes                |
    And print updateCompatibleTypePayload
    And request updateCompatibleTypePayload
    When method POST
    Then status 201
    And print response
    And def updateCompatibleTypeResponse = response
    And print updateCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatCompatibleCollectionName+<tenantid>,updateCompatibleTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == CreateCompatiblePaymentResponse.body.id
    And match updateCompatibleTypeResponse.body.compatibleTypes[0].pullDownSequence == updateCompatibleTypePayload.body.compatibleTypes[0].pullDownSequence
    # And match updateCompatibleTypeResponse.body.compatibleTypes[1].overPaymentCondition == updateCompatibleTypePayload.body.compatibleTypes[1].overPaymentCondition
    #Get Updated Compatible Type
    Given url readBaseUrl
    And path '/api/GetCompatiblePaymentType'
    And set getCompatibleTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetCompatiblePaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetCompatiblePaymentType"                        |
      | entityName      | "CompatibleType"                                  |
      | ttl             |                                                 0 |
      | getType         | "One"                                             |
    And set getCompatibleTypeCommandBody
      | path          |                                                  0 |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set getCompatibleTypePayload
      | path         | [0]                               |
      | header       | getCompatibleTypeCommandHeader[0] |
      | body.request | getCompatibleTypeCommandBody[0]   |
    And print getCompatibleTypePayload
    And request getCompatibleTypePayload
    When method POST
    Then status 200
    And print response
    And def getCompatibleTypeResponse = response
    And print getCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createCompatibleCollectionNameRead+<tenantid>,CreateCompatiblePaymentResponse.body.id)
    And print mongoResult
    And match mongoResult == getCompatibleTypeResponse.id
    And match each getCompatibleTypeResponse.compatibleTypes[*].selected == false
    And match each getCompatibleTypeResponse.compatibleTypes[*].isActive == true
    #HistoryValidation
    And def entityIdData = getCompatibleTypeResponse.id
    And def parentEntityId = getCompatibleTypeResponse.paymentTypeId
    And def eventName = "CompatibleTypeUpdated"
    And def evnentType = "CompatibleType"
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
    And def entityName = "CompatibleType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCompatibleTypeResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "CompatibleType"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCompatiblePaymentTypeWithMandatoryFields
  Scenario Outline: Update a compatible payment type with Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCompatibleType'
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentTypeWithMandatoryFields')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    #Updating pulldown sequence
    And def pullDownSeqData = CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence+2
    #Update Compatible Payment Type
    And set updateCompatibleTypeCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateCompatibleType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | CreateCompatiblePaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | CreateCompatiblePaymentResponse.header.id            |
      | correlationId   | CreateCompatiblePaymentResponse.header.correlationId |
      | entityId        | CreateCompatiblePaymentResponse.header.entityId      |
      | commandUserId   | commandUserId                                        |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateCompatibleType"                               |
      | entityName      | "CompatibleType"                                     |
      | ttl             |                                                    0 |
    And set updateCompatibleTypeCommandBody
      | path          |                                                  0 |
      | id            | CreateCompatiblePaymentResponse.header.entityId    |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set updateCompatibleTypes
      | path             |                                                                        0 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[0].id               |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType      |
      | pullDownSequence | CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence |
      | isActive         | CreateCompatiblePaymentResponse.body.compatibleTypes[0].isActive         |
      | selected         | false                                                                    |
    And set updateCompatibleTypes
      | path             |                                                                        1 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[1].id               |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[1].paymentType      |
      | pullDownSequence | CreateCompatiblePaymentResponse.body.compatibleTypes[1].pullDownSequence |
      | isActive         | CreateCompatiblePaymentResponse.body.compatibleTypes[1].isActive         |
      | selected         | CreateCompatiblePaymentResponse.body.compatibleTypes[1].selected         |
    And set updateCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | updateCompatibleTypeCommandHeader[0] |
      | body                 | updateCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | updateCompatibleTypes                |
    And print updateCompatibleTypePayload
    And request updateCompatibleTypePayload
    When method POST
    Then status 201
    And print response
    And def updateCompatibleTypeResponse = response
    And print updateCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatCompatibleCollectionName+<tenantid>,updateCompatibleTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == CreateCompatiblePaymentResponse.body.id
    And match updateCompatibleTypeResponse.body.compatibleTypes[0].pullDownSequence == updateCompatibleTypePayload.body.compatibleTypes[0].pullDownSequence
    # And match updateCompatibleTypeResponse.body.compatibleTypes[1].overPaymentCondition == updateCompatibleTypePayload.body.compatibleTypes[1].overPaymentCondition
    #Get Updated Compatible Type
    Given url readBaseUrl
    And path '/api/GetCompatiblePaymentType'
    And set getCompatibleTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetCompatiblePaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetCompatiblePaymentType"                        |
      | entityName      | "CompatibleType"                                  |
      | ttl             |                                                 0 |
      | getType         | "One"                                             |
    And set getCompatibleTypeCommandBody
      | path          |                                                  0 |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.paymentTypeId |
    And set getCompatibleTypePayload
      | path         | [0]                               |
      | header       | getCompatibleTypeCommandHeader[0] |
      | body.request | getCompatibleTypeCommandBody[0]   |
    And print getCompatibleTypePayload
    And request getCompatibleTypePayload
    When method POST
    Then status 200
    And print response
    And def getCompatibleTypeResponse = response
    And print getCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createCompatibleCollectionNameRead+<tenantid>,CreateCompatiblePaymentResponse.body.id)
    And print mongoResult
    And match mongoResult == getCompatibleTypeResponse.id
    And match each getCompatibleTypeResponse.compatibleTypes[1].selected == true
    And match each getCompatibleTypeResponse.compatibleTypes[*].isActive == true
    #HistoryValidation
    And def entityIdData = getCompatibleTypeResponse.id
    And def parentEntityId = getCompatibleTypeResponse.paymentTypeId
    And def eventName = "CompatibleTypeUpdated"
    And def evnentType = "CompatibleType"
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
    And def entityName = "CompatibleType"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCompatibleTypeResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "CompatibleType"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    # Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # View the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    # Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCompatiblePaymentTypeWithMissingMandatoryFields
  Scenario Outline: Update a compatible payment type with Missing Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCompatibleType'
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentTypeWithMandatoryFields')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    #Updating pulldown sequence
    And def pullDownSeqData = CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence+1
    #Update Compatible Payment Type
    And set updateCompatibleTypeCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateCompatibleType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | CreateCompatiblePaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | CreateCompatiblePaymentResponse.header.id            |
      | correlationId   | CreateCompatiblePaymentResponse.header.correlationId |
      | entityId        | CreateCompatiblePaymentResponse.header.entityId      |
      | commandUserId   | commandUserId                                        |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateCompatibleType"                               |
      | entityName      | "CompatibleType"                                     |
      | ttl             |                                                    0 |
    And set updateCompatibleTypeCommandBody
      | path          |                                               0 |
      | id            | CreateCompatiblePaymentResponse.header.entityId |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.id         |
    And set updateCompatibleTypes
      | path             |                                                                   0 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[0].id          |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType |
      | pullDownSequence | pullDownSeqData                                                     |
      | isActive         | faker.getRandomBoolean()                                            |
    And set updateCompatibleTypes
      | path             |                                                                        1 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[1].id               |
      | pullDownSequence | CreateCompatiblePaymentResponse.body.compatibleTypes[1].pullDownSequence |
      | isActive         | faker.getRandomBoolean()                                                 |
    And set updateCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | updateCompatibleTypeCommandHeader[0] |
      | body                 | updateCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | updateCompatibleTypes                |
    And print updateCompatibleTypePayload
    And request updateCompatibleTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCompatiblePaymentTypeWithInvalidDataToMandatoryFields
  Scenario Outline: Update a compatible payment type with Missing Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCompatibleType'
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentTypeWithMandatoryFields')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    #Updating pulldown sequence
    And def pullDownSeqData = CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence+1
    #Update Compatible Payment Type
    And set updateCompatibleTypeCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateCompatibleType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | CreateCompatiblePaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | CreateCompatiblePaymentResponse.header.id            |
      | correlationId   | CreateCompatiblePaymentResponse.header.correlationId |
      | entityId        | CreateCompatiblePaymentResponse.header.entityId      |
      | commandUserId   | commandUserId                                        |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateCompatibleType"                               |
      | entityName      | "CompatibleType"                                     |
      | ttl             |                                                    0 |
    And set updateCompatibleTypeCommandBody
      | path          |                                               0 |
      | id            | CreateCompatiblePaymentResponse.header.entityId |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.id         |
    And set updateCompatibleTypes
      | path             |                                                                   0 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[0].id          |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType |
      | pullDownSequence | pullDownSeqData                                                     |
      | isActive         | faker.getRandomBoolean()                                            |
    And set updateCompatibleTypes
      | path             |                                                                   1 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[1].id          |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[1].paymentType |
      | pullDownSequence | faker.getRandomBoolean()                                            |
      | isActive         | faker.getRandomBoolean()                                            |
    And set updateCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | updateCompatibleTypeCommandHeader[0] |
      | body                 | updateCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | updateCompatibleTypes                |
    And print updateCompatibleTypePayload
    And request updateCompatibleTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCompatiblePaymentTypeWithDuplicatePullDownSeq
  Scenario Outline: Update a compatible payment type with Duplicate PullDown Seq
    Given url commandBaseUrl
    And path '/api/UpdateCompatibleType'
    #Create a Compatible payment
    And def CreateCompatiblePaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/CreateCompatibleType.feature@CreateCompatiblePaymentTypeWithMandatoryFields')
    And def CreateCompatiblePaymentResponse = CreateCompatiblePaymentResponseResult.response
    And print CreateCompatiblePaymentResponse
    #Updating pulldown sequence
    And def pullDownSeqData = CreateCompatiblePaymentResponse.body.compatibleTypes[0].pullDownSequence
    #Update Compatible Payment Type
    And set updateCompatibleTypeCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateCompatibleType-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | CreateCompatiblePaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | CreateCompatiblePaymentResponse.header.id            |
      | correlationId   | CreateCompatiblePaymentResponse.header.correlationId |
      | entityId        | CreateCompatiblePaymentResponse.header.entityId      |
      | commandUserId   | commandUserId                                        |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateCompatibleType"                               |
      | entityName      | "CompatibleType"                                     |
      | ttl             |                                                    0 |
    And set updateCompatibleTypeCommandBody
      | path          |                                               0 |
      | id            | CreateCompatiblePaymentResponse.header.entityId |
      | paymentTypeId | CreateCompatiblePaymentResponse.body.id         |
    And set updateCompatibleTypes
      | path             |                                                                   0 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[0].id          |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[0].paymentType |
      | pullDownSequence | pullDownSeqData-1                                                   |
      | isActive         | faker.getRandomBoolean()                                            |
    And set updateCompatibleTypes
      | path             |                                                                   1 |
      | id               | CreateCompatiblePaymentResponse.body.compatibleTypes[1].id          |
      | paymentType      | CreateCompatiblePaymentResponse.body.compatibleTypes[1].paymentType |
      | pullDownSequence | pullDownSeqData                                                     |
      | isActive         | faker.getRandomBoolean()                                            |
    And set updateCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | updateCompatibleTypeCommandHeader[0] |
      | body                 | updateCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | updateCompatibleTypes                |
    And print updateCompatibleTypePayload
    And request updateCompatibleTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
