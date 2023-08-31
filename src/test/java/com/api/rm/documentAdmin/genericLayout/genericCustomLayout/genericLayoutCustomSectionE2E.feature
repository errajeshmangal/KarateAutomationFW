@GenericLayoutDesignCustomSectionE2E
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateGenericLayoutCustomSection_'
    And def genericLayoutNameCollectionNameRead = 'GenericLayoutCustomSectionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutCustomSection','UpdateGenericLayoutCustomSection', 'GetGenericLayoutCustomSection','GetGenericLayouts']
    And def entityName = ['GenericLayoutCustomSection']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['GenericLayoutCustomSection']

  @CreateandGetGenericLayoutCustomSectionMarriageLicencewithallfields
  Scenario Outline: Create a generic layout custom section Marriage licence with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |             5000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionMarriageApplicationwithallfields
  Scenario Outline: Create a generic layout custom section Marriage Application with all the fields and get the data
    # Create Generic Layout design for Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageApplication')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               5000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionDeathCertificatewithallfields
  Scenario Outline: Create a generic layout custom section Death certificate with all the fields and get the data
    # Create Generic Layout Death Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      #| entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionBirthCertificatewithallfields
  Scenario Outline: Create a generic layout custom section Birth certificate with all the fields and get the data
    # Create Generic Layout Birth Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificate')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      # | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionMarriageLicencewithMandatoryDetails
  Scenario Outline: Create a generic layout custom section Marriage Licence with all mandatory fields and get the data
    # Create Generic Layout Marriage licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicenceWithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionMarriageApplicationwithMandatoryDetails
  Scenario Outline: Create a generic layout custom section Marriage Application with all mandatory fields and get the data
    # Create Generic Layout Marriage Application
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageApplicationWithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      #  | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionDeathCertificatewithMandatoryDetails
  Scenario Outline: Create a generic layout custom section Death Certificate with all mandatory fields and get the data
    # Create Generic Layout Death Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificateWithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      #   | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionBirthCertificatewithMandatoryDetails
  Scenario Outline: Create a generic layout custom section Birth Certificate with all mandatory fields and get the data
    # Create Generic Layout Birth Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificateWithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionMarriageLicencewithallfields @344
  Scenario Outline: update a generic layout design custom section Marriage licence with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionMarriageLicencewithAllDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #get All Generic Layout Property Type Layout Design
    Given url readBaseGenericLayout
    When path '/api/'+commandType[3]
    And set getGenericLayoutsCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | addGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | getType         | "Array"                                                    |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[3]                                             |
      | ttl             |                                                          0 |
    And set getGenericLayoutsCommandRequest
      | path              |                                             0 |
      | id                | addGenericLayoutCustomSectionResponse.body.id |
      | layoutCode        |                                               |
      | layoutDescription |                                               |
      | layoutType        |                                               |
      | workFlowType      |                                               |
      | isActive          |                                               |
      | lastUpdatedDate   |                                               |
    And set getGenericLayoutsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              11000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutsCommandPayload
      | path                | [0]                                   |
      | header              | getGenericLayoutsCommandHeader[0]     |
      | body.request        | getGenericLayoutsCommandRequest[0]    |
      | body.paginationSort | getGenericLayoutsCommandPagination[0] |
    And print getGenericLayoutsCommandPayload
    And request getGenericLayoutsCommandPayload
    When method POST
    Then status 200
    And def getGenericLayoutsResponse = response
    And print getGenericLayoutsResponse
    And match getGenericLayoutsResponse.results[*].id contains addGenericLayoutCustomSectionResponse.body.id
    And match getGenericLayoutsResponse.results[*].layoutType contains addGenericLayoutCustomSectionResponse.body.layoutType
    And match getGenericLayoutsResponse.results[*].isActive contains addGenericLayoutCustomSectionResponse.body.isActive
    And def getGenericLayoutsResponseCount = karate.sizeOf(getGenericLayoutsResponse.results)
    And print getGenericLayoutsResponseCount
    And match getGenericLayoutsResponseCount == getGenericLayoutsResponse.totalRecordCount
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionMarriageApplicationwithallfields @344
  Scenario Outline: update a generic layout custom section Marriage Application with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionMarriageApplicationwithAllDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionDeathCertificatewithallfields @344
  Scenario Outline: Update a generic layout custom section Death Certificate with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionDeathCertificatewithAllDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionBirthCertificatewithallfields @344
  Scenario Outline: Update a generic layout custom section Birth Certificate with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionBirthCertificatewithAllDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  #+++++++++++++++++++++++Update with Mandatory Fields++++++++++++++++++++++++++++
  @UpdateandGetGenericLayoutCustomSectionMarriageLicencewithMandatoryDetails @344
  Scenario Outline: Update and get a generic layout custom section Marriage licence with mandatory details
    # Update and get Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionMarriageLicencewithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionMarriageApplicationwithMandatoryDetails @344
  Scenario Outline: Update and get generic layout custom section Marriage Application with all mandatory fields and get the data
    # Update and get Generic Layout Marriage Application
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionMarriageApplicationwithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionDeathCertificatewithMandatoryDetails @344
  Scenario Outline: Update and get generic layout custom section Death Certificate with mandatory details
    # Update and get Generic Layout Death certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionDeathCertificatewithMandatoryDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId =  getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionBirthCertificatewithMandatoryDetails @344
  Scenario Outline: Update and get generic layout custom section Birth Certificate with mandatory fields
    # Update and get Generic Birth certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateGenericLayoutCustomSectionBirthCertificatewithAllDetails')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | addGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | addGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | addGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | addGenericLayoutCustomSectionResponse.header.commandUserId |
      | tags            | []                                                         |
      | commandType     | commandType[2]                                             |
      | getType         | "One"                                                      |
      | ttl             |                                                          0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                                             0 |
      | id   | addGenericLayoutCustomSectionResponse.body.id |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addGenericLayoutCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.id == addGenericLayoutCustomSectionResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
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
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
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
      | tenantid    |
      | tenantID[0] |

  #++++++++++++++++++++++++++ Negative Cases +++++++++++++++++++++
  @CreateCustomSectionMarriageLicencewithOutMandatoryfields
  Scenario Outline: Create a generic layout custom section Marriage licence without Mandatory fields and Validate the data
    # Create Generic Layout Marriage Licence
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      #| fieldsCollection  | fieldsCollection[0]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | createGenericLayoutCustomSectionCommandHeader[0] |
      | body   | createGenericLayoutCustomSectionCommandBody[0]   |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCustomeSectionwithInvalidfields
  Scenario Outline: Create a generic layout custom section Marriage licence with invalid fields and Validate the data
    # Create Generic Layout Marriage Licence
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | "Marriage"                        |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | createGenericLayoutCustomSectionCommandHeader[0] |
      | body   | createGenericLayoutCustomSectionCommandBody[0]   |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionWithoutMandatoryDetails
  Scenario Outline: Update Generic Layout custom section for Death Certificate with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[2]                                      |
      #| layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionWithInvalidDetails
  Scenario Outline: Update Generic Layout custom section for Death Certificate with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | "Marriage"                                               |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateCustomeSectionLayoutID
  Scenario Outline: Create a generic layout custom section Layout ID for Marriage licence and Validate
    # Create Generic Layout Marriage Licence Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    # Create Generic Layout Marriage Licence 2
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                                        0 |
      | id                | entityIdData                                             |
      | layoutType        | layoutType[0]                                            |
      | fieldsCollection  | fieldsCollection[0]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set createGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | createGenericLayoutCustomSectionCommandHeader[0] |
      | body   | createGenericLayoutCustomSectionCommandBody[0]   |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionWithDuplicateLayOutID
  Scenario Outline: Update Generic Layout custom section for Death Certificate with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse2 = result.response
    And print createGenericLayoutCustomSectionResponse2
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                         0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId  |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType  |
      | fieldsCollection  | fieldsCollection[2]                                       |
      | layoutCode        | createGenericLayoutCustomSectionResponse2.body.layoutCode |
      | layoutDescription | faker.getDescription()                                    |
      | longDescription   | faker.getRandomShortDescription()                         |
      | sectionType       | sectionType[0]                                            |
      | isActive          | faker.getRandomBoolean()                                  |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
