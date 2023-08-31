@GenericLayoutPropertyTypeE2EFeature
Feature: Property Type-Add ,Edit,View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateGenericLayoutPropertyType_'
    And def genericLayoutNameCollectionNameRead = 'GenericLayoutPropertyTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutPropertyType','GetGenericLayoutPropertyType','UpdateGenericLayoutPropertyType']
    And def propertyCategory = [ "Condo","Subdivision","SectionLandAcreage","Land"]
    And def entityName = ['GenericLayoutPropertyType']
    And def fieldsCollection = ["Legal Description"]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['GenericLayoutPropertyType']
    
  @CreateandGetGenericLayoutCondoPropertyTypewithallfields
  Scenario Outline: Create a generic layout condo property type with all the fields and get the data
    # Create Generic Layout Condo Property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithallfields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get Generic Layout Condo Property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id   
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutSubdivisionPropertyTypewithallfields
  Scenario Outline: Create a generic layout Subdivision property type with all the fields and get the data
    # Create Generic Layout Subdivision Property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithallfields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get Generic Layout Subdivision Property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyDocumentTypeGroupPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyDocumentTypeGroupPayload
    And request getGenericLayoutPropertyDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
         
     #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutSectionPropertyTypewithallfields
  Scenario Outline: Create a generic layout Section property type with all the fields and get the data
    # Create Generic Layout Section Property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSectionPropertyTypewithallfields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get Generic Layout Section Property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyDocumentTypeGroupPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyDocumentTypeGroupPayload
    And request getGenericLayoutPropertyDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutLandPropertyTypewithallfields
  Scenario Outline: Create a generic layout Land property type with all the fields and get the data
    # Create Generic Layout Land Property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutLandPropertyTypewithallfields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get Generic Layout Land Property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyDocumentTypeGroupPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyDocumentTypeGroupPayload
    And request getGenericLayoutPropertyDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetGenericLayoutLandPropertyTypewithMandatoryFields
  Scenario Outline: Create a Generic Layout Land Property Type with  mandatory fields and Get the details
    #Create Generic Layout Land property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutLandPropertyTypewithMandatoryFields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get the Generic Layout Land property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyDocumentTypeGroupPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyDocumentTypeGroupPayload
    And request getGenericLayoutPropertyDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetGenericLayoutSectionPropertyTypewithMandatoryFields
  Scenario Outline: Create a Generic Layout Section Property Type with  mandatory fields and Get the details
    #Create Generic Layout Section property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSectionPropertyTypewithMandatoryFields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get the Generic Layout Section property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
   #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetGenericLayoutSubdivisionPropertyTypewithMandatoryFields
  Scenario Outline: Create a Generic Layout Subdivision Property Type with  mandatory fields and Get the details
    #Create Generic Layout Subdivision property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithMandatoryFields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get the Generic Layout Subdivision property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == addGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == addGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
   #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetGenericLayoutCondoPropertyTypewithMandatoryFields
  Scenario Outline: Create a Generic Layout Condo Property Type with  mandatory fields and Get the details
    #Create Generic Layout Condo property Type
    And def result = call read('classpath:com/api/rm//documentAdmin/genericLayout/propertyType/CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithMandatoryFields')
    And def addGenericLayoutPropertyResponse = result.response
    And print addGenericLayoutPropertyResponse
    #Get the Generic Layout Condo property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                            |
      | id              | addGenericLayoutPropertyResponse.header.id            |
      | correlationId   | addGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | addGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                    |
      | commandType     | commandType[1]                                        |
      | getType         | "One"                                                 |
      | ttl             |                                                     0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                        0 |
      | id   | addGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == addGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == addGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.propertyCategory == addGenericLayoutPropertyResponse.body.propertyCategory
    And match getGenericLayoutPropertyResponse.isActive == addGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetGenericLayoutCondoPropertyTypewithAllDetails
  Scenario Outline: Update Generic Layout condo property type with all the fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Condo Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithallfields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Condo Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | longDescription   | faker.getRandomShortDescription()                   |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    #And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Condo property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.propertyCategory == updateGenericLayoutPropertyResponse.body.propertyCategory
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetGenericLayoutSubdivisionPropertyTypewithAllDetails
  Scenario Outline: Update Generic Layout Subdivision property type with all the fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Subdivision Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithallfields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Subdivision Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | longDescription   | faker.getRandomShortDescription()                   |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Subdivision property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetGenericLayoutSectionPropertyTypewithAllDetails
  Scenario Outline: Update Generic Layout Section property type with all the fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Section Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSectionPropertyTypewithallfields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Section Property Type
   
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType      |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode      |
      | layoutDescription | faker.getDescription()                              |
      | longDescription   | faker.getRandomShortDescription()                   |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Section property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetGenericLayoutLandPropertyTypewithAllDetails
  Scenario Outline: Update Generic Layout Land property type with all the fields and Get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Land Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutLandPropertyTypewithallfields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Land Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | longDescription   | faker.getRandomShortDescription()                   |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Land property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
   #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1


    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateGenericLayoutCondoPropertyTypeWithMandatoryFields
  Scenario Outline: Update generic layout condo property  Type Group with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Condo Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Condo Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Condo property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1


    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateGenericLayoutSubdivisionPropertyTypeWithMandatoryFields
  Scenario Outline: Update generic layout Subdivision property  Type Group with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Subdivision Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Subdivision Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Subdivision property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1


    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateGenericLayoutSectionPropertyTypeWithMandatoryFields
    Scenario Outline: Update generic layout Section property  Type Group with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Subdivision Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Subdivision Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Subdivision property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1


    Examples: 
      | tenantid    |
      | tenantID[0] |
  
  @updateGenericLayoutLandPropertyTypeWithMandatoryFields
  Scenario Outline: Update generic layout Land property  Type Group with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Land Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutLandPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Land Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[3]                                 |
      | layoutCode        | createGenericLayoutPropertyResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                              |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyResponse = response
    And print updateGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyPayload.body.id
    And match  updateGenericLayoutPropertyPayload.body.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match  updateGenericLayoutPropertyPayload.body.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match  updateGenericLayoutPropertyPayload.body.isActive == updateGenericLayoutPropertyResponse.body.isActive
    And match  updateGenericLayoutPropertyPayload.body.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match  updateGenericLayoutPropertyPayload.body.id == updateGenericLayoutPropertyResponse.body.id
    And sleep(10000)
    #Get the Generic Layout Land property Type
    Given url readBaseGenericLayout
    And path '/api/'+commandType[1]
    And set getGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateGenericLayoutPropertyResponse.header.id            |
      | correlationId   | updateGenericLayoutPropertyResponse.header.correlationId |
      | commandUserId   | updateGenericLayoutPropertyResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getGenericLayoutPropertyCommandBody
      | path |                                           0 |
      | id   | updateGenericLayoutPropertyResponse.body.id |
    And set getGenericLayoutPropertyPayload
      | path         | [0]                                      |
      | header       | getGenericLayoutPropertyCommandHeader[0] |
      | body.request | getGenericLayoutPropertyCommandBody[0]   |
    And print getGenericLayoutPropertyPayload
    And request getGenericLayoutPropertyPayload
    When method POST
    Then status 200
    And def getGenericLayoutPropertyResponse = response
    And print getGenericLayoutPropertyResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,genericLayoutNameCollectionNameRead+<tenantid>,updateGenericLayoutPropertyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutPropertyResponse.id
    And match getGenericLayoutPropertyResponse.layoutCode == updateGenericLayoutPropertyResponse.body.layoutCode
    And match getGenericLayoutPropertyResponse.layoutType == updateGenericLayoutPropertyResponse.body.layoutType
    And match getGenericLayoutPropertyResponse.layoutDescription == updateGenericLayoutPropertyResponse.body.layoutDescription
    And match getGenericLayoutPropertyResponse.id == updateGenericLayoutPropertyResponse.body.id
    And match getGenericLayoutPropertyResponse.isActive == updateGenericLayoutPropertyResponse.body.isActive
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def entityIdData = getGenericLayoutPropertyResponse.id
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRad,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1


    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateGenericLayoutSubdivisionPropertyTypeWithMandatoryFieldsLayoutCodeMissing
  Scenario Outline: Update generic layout Section property  Type Group with mandatory details missing
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Section Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutSubdivisionPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Section Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path              |                                                   0 |
      | id                | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType        | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                 |
      | propertyCategory  | propertyCategory[1]                                 |
      #| layoutCode        | createGenericLayoutPropertyResponse.layoutCode       |
      | layoutDescription | faker.getDescription()                              |
      | isActive          | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateGenericLayoutCondoPropertyTypeWithMandatoryFieldsLayoutDescriptionMissing
  Scenario Outline: Update generic layout Condo property  Type Group with mandatory details missing
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    # Create Generic Layout Condo Property Type
    And def result = call read('CreateGenericLayoutPropertyType.feature@CreateGenericLayoutCondoPropertyTypewithMandatoryFields')
    And def createGenericLayoutPropertyResponse = result.response
    And print createGenericLayoutPropertyResponse
    #Update Generic Layout Condo Property Type
    And set updateGenericLayoutPropertyCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createGenericLayoutPropertyResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createGenericLayoutPropertyResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[2]                                           |
      | entityName      | "GenericLayoutPropertyType"                              |
      | ttl             |                                                        0 |
    And set updateGenericLayoutPropertyBody
      | path             |                                                   0 |
      | id               | createGenericLayoutPropertyResponse.header.entityId |
      | layoutType       | createGenericLayoutPropertyResponse.body.layoutType |
      | fieldsCollection | fieldsCollection[0]                                 |
      | propertyCategory | propertyCategory[1]                                 |
      | layoutCode       | createGenericLayoutPropertyResponse.body.layoutCode |
      #| layoutDescription | faker.getDescription()                               |
      | isActive         | faker.getRandomBoolean()                            |
    And set updateGenericLayoutPropertyPayload
      | path   | [0]                                         |
      | header | updateGenericLayoutPropertyCommandHeader[0] |
      | body   | updateGenericLayoutPropertyBody[0]          |
    And print updateGenericLayoutPropertyPayload
    And request updateGenericLayoutPropertyPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
