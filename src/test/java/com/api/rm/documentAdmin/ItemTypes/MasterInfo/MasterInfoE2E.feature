@MasterItemTypesFeature
Feature: Item Types-Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def masterInfoItemTypeCollectionName = 'CreateItemTypeMasterInfo_'
    And def masterInfoItemTypeCollectionNameRead = 'ItemTypeMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateMasterInfoItemTypeswithAllFields   
  Scenario Outline: Create MasterInfo Item type for CopyRequest category  with all Details
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CopyRequest')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfo"                         |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | addMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,addMasterItemTypesResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getMasterItemTypesResponse.id
    And match getMasterItemTypesResponse.code == addMasterItemTypesResponse.body.code
    And match getMasterItemTypesResponse.shortDescription == addMasterItemTypesResponse.body.shortDescription
    And match getMasterItemTypesResponse.longDescription == addMasterItemTypesResponse.body.longDescription
    And match getMasterItemTypesResponse.documentClass.id == addMasterItemTypesResponse.body.documentClass.id
    And match getMasterItemTypesResponse.documentClass.name == addMasterItemTypesResponse.body.documentClass.name
    And match getMasterItemTypesResponse.effectiveDate == addMasterItemTypesResponse.body.effectiveDate
    And match getMasterItemTypesResponse.expirationDate == addMasterItemTypesResponse.body.expirationDate
    And match getMasterItemTypesResponse.additionalInfoTab == addMasterItemTypesResponse.body.additionalInfoTab
    And match getMasterItemTypesResponse.isActive == addMasterItemTypesResponse.body.isActive
    And sleep(15000)
    # Get all item Types with is active status of created one's
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                        0 |
      | code                |                                          |
      | shortDescription    |                                          |
      | displaySequence     |                                          |
      | isActive            | addMasterItemTypesResponse.body.isActive |
      | category            |                                          |
      | lastUpdatedDateTime |                                          |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And print getMasterItemTypeAllResponse = response
    And print getMasterItemTypeAllResponse
    And match each getMasterItemTypeAllResponse.results[*].isActive == getMasterItemTypesResponse.isActive
    And def getMasterItemTypeAllResponseCount = karate.sizeOf(getMasterItemTypeAllResponse.results)
    And print getMasterItemTypeAllResponseCount
    And match getMasterItemTypeAllResponseCount == getMasterItemTypeAllResponse.totalRecordCount
    #    Get all item Types
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                                0 |
      | code                |                                                  |
      | shortDescription    | addMasterItemTypesResponse.body.shortDescription |
      | displaySequence     |                                                  |
      | isActive            |       |
      | category            |                                                  |
      | lastUpdatedDateTime |                                                  |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                    |
      | header              | getMasterItemTypesCommandHeader[0]     |
      | body.request        |getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0] |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMasterItemTypeAllResponse = response
    And print getMasterItemTypeAllResponse
    And match getMasterItemTypeAllResponse.results[*].shortDescription contains addMasterItemTypesResponse.body.shortDescription
    And def getMasterItemTypeAllResponseCount = karate.sizeOf(getMasterItemTypeAllResponse.results)
    And print getMasterItemTypeAllResponseCount
    And match getMasterItemTypeAllResponseCount == getMasterItemTypeAllResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoCreated"
    And def evnentType = "ItemTypeMasterInfo"
   And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @CreateMasterInfoItemTypeswithAllFields  
  Scenario Outline: Create MasterInfo Item type for  Document Class Category for  all Details
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@DocumentClassCategory')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfo"                         |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | addMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,addMasterItemTypesResponse.header.entityId)
    And print mongoResult
    And match mongoResult == addMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.shortDescription == addMasterItemTypesResponse.body.shortDescription
    And match getMasterItemTypesResponse.longDescription == addMasterItemTypesResponse.body.longDescription
    And match getMasterItemTypesResponse.isActive == addMasterItemTypesResponse.body.isActive
    And sleep(15000)
    #    Get all item Types with is active status of created one's
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                                0 |
      | code                |                                                  |
      | shortDescription    | addMasterItemTypesResponse.body.shortDescription |
      | displaySequence     |                                                  |
      | isActive            |        |
      | category            |                                                  |
      | lastUpdatedDateTime |                                                  |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And print getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].shortDescription contains addMasterItemTypesResponse.body.shortDescription
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoCreated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @CreateMasterInfoItemTypeswithAllFields
  Scenario Outline: Create MasterInfo Item type with  MiscellaneousFees Category for  all Details
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@MiscellaneousFeesCategory')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfo"                         |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | addMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,addMasterItemTypesResponse.header.entityId)
    And print mongoResult
    And match mongoResult == addMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.shortDescription == addMasterItemTypesResponse.body.shortDescription
    And match getMasterItemTypesResponse.longDescription == addMasterItemTypesResponse.body.longDescription
    And match getMasterItemTypesResponse.isActive == addMasterItemTypesResponse.body.isActive
    And sleep(15000)
    #    Get all item Types with is active status of created one's
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                                0 |
      | code                |                                                   |
      | shortDescription    |  |
      | displaySequence     |                                                  |
      | isActive            |        |
      | category            |                                                  |
      | lastUpdatedDateTime |                                                  |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And getMasterItemTypesResponse= response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].code contains addMasterItemTypesResponse.body.code
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoCreated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @CreateMasterInfoItemTypeswithAllFields @RestrictedFeesGroupFeesCategory  
  Scenario Outline: Create MasterInfo Item type with  Restricted Fees Group  Category for  all Details
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@RestrictedFeesGroupFeesCategory')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfo"                         |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | addMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,addMasterItemTypesResponse.header.entityId)
    And print mongoResult
    And match mongoResult == addMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.shortDescription == addMasterItemTypesResponse.body.shortDescription
    And match getMasterItemTypesResponse.longDescription == addMasterItemTypesResponse.body.longDescription
    And match getMasterItemTypesResponse.effectiveDate == addMasterItemTypesResponse.body.effectiveDate
    And match getMasterItemTypesResponse.expirationDate == addMasterItemTypesResponse.body.expirationDate
    And match getMasterItemTypesResponse.additionalInfoTab == addMasterItemTypesResponse.body.additionalInfoTab
    And match getMasterItemTypesResponse.isActive == addMasterItemTypesResponse.body.isActive
    And sleep(15000)
    #    Get all item Types with is active status of created one's
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                                0 |
      | code                |                                                  |
      | shortDescription    | addMasterItemTypesResponse.body.shortDescription |
      | displaySequence     |                                                  |
      | isActive            |            |
      | category            |                                                  |
      | lastUpdatedDateTime |                                                  |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And getMasterItemTypesResponse= response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].shortDescription contains addMasterItemTypesResponse.body.shortDescription
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoCreated"
    And def evnentType = "ItemTypeMasterInfo"
     And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @CreateAndGetMasterItemTypeswithMandatoryFields 
  Scenario Outline: Create a item Types with CopyRequest categroy for mandatory fields and Get the details
    #Create MasterItemTypes
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path             |                                       0 |
      | id               | entityIdData                            |
      | code             | faker.getRandomNumber()                 |
      | shortDescription | faker.getRandomShortDescription()       |
      | isActive         | faker.getRandomBooleanValue()           |
      | category         | "CopyRequest"                           |
      | effectiveDate    | dataGenerator.generateCurrentDateTime() |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def addMasterItemTypesResponse = response
    And print addMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addMasterItemTypesResponse.body.id
    And match addMasterItemTypesResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive
    And match addMasterItemTypesResponse.body.effectiveDate == createMasterInfoItemTypePayload.body.effectiveDate
    And sleep(15000)
    #    Get all item Types with is active status of created one's
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                         |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                        0 |
      | code                |                                          |
      | shortDescription    |                                          |
      | displaySequence     |                                          |
      | isActive            | addMasterItemTypesResponse.body.isActive |
      | category            |                                          |
      | lastUpdatedDateTime |                                          |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And print getMasterItemTypesResponse= response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].id contains addMasterItemTypesResponse.body.id
    And match each getMasterItemTypesResponse.results[*].isActive == addMasterItemTypesResponse.body.isActive
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #    Get the item Type
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfo'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | addMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | addMasterItemTypesResponse.header.id            |
      | correlationId   | addMasterItemTypesResponse.header.correlationId |
      | getType         | "One"                                           |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfo"                         |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path |                                  0 |
      | id   | addMasterItemTypesResponse.body.id |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.id contains addMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.documentClass.id  contains addMasterItemTypesResponse.body.documentClass.id
    And match getMasterItemTypesResponse.isActive == addMasterItemTypesResponse.body.isActive
    #HistoryValidation
    And def entityIdData = addMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoCreated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @CreateMasterItemTypeswithInvalidFields
  Scenario Outline: Create item Types with invalid fields
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getRandomNumber()                           |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "CopyRequest"                                     |
      | effectiveDate     | faker.getRandomShortDescription()                 |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypeGroupswithMissingMandatoryField
  Scenario Outline: Create item Types with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | code             | faker.getRandomNumber()           |
      | shortDescription | faker.getRandomShortDescription() |
      | isActive         | faker.getRandomBooleanValue()     |
      | category         | "CopyRequest"                     |
      | effectiveDate    | faker.getRandomBooleanValue()     |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateMasterItemTypes
  Scenario Outline: Create Duplicate item Types with all Details
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@DocumentClassCategory')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getRandomNumber()                           |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "CopyRequest"                                     |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
       | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetMasterItemTypeswithAllDetails 
  Scenario Outline: Update item Types with category as CopyRequest and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path              |                                                 0 |
      | id                | addMasterItemTypesResponse.header.entityId        |
      | code              | faker.getRandomNumber()                           |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "CopyRequest"                                     |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.documentClass | commandDocumentClass[0]               |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def updateMasterItemTypesResponse = response
    And print updateMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,addMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateMasterItemTypesResponse.body.id
    And match updateMasterItemTypesResponse.body.code == updateMasterInfoItemTypePayload.body.code
    And match updateMasterItemTypesResponse.body.documentClass.id == updateMasterInfoItemTypePayload.body.documentClass.id
    And match updateMasterItemTypesResponse.body.documentClass.name == updateMasterInfoItemTypePayload.body.documentClass.name
    And match updateMasterItemTypesResponse.body.isActive == updateMasterInfoItemTypePayload.body.isActive
    And match updateMasterItemTypesResponse.body.effectiveDate == updateMasterInfoItemTypePayload.body.effectiveDate
    And sleep(10000)
    #    Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfo"                            |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path |                                     0 |
      | id   | updateMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,updateMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateMasterItemTypesResponse.body.id
    And match updateMasterItemTypesResponse.body.documentClass.name == updateMasterInfoItemTypePayload.body.documentClass.name
    And match updateMasterItemTypesResponse.body.isActive == updateMasterInfoItemTypePayload.body.isActive
    And match updateMasterItemTypesResponse.body.effectiveDate == updateMasterInfoItemTypePayload.body.effectiveDate
    And sleep(15000)
    #    Get all item Types
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                            |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfos"                           |
      | ttl             |                                                  0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                        0 |
      | code                |                                          |
      | shortDescription    |                                          |
      | displaySequence     |                                          |
      | isActive            | updateMasterItemTypesResponse.body.isActive |
      | category            |                                          |
      | lastUpdatedDateTime |                                          |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].id contains updateMasterItemTypesResponse.body.id
    And match each getMasterItemTypesResponse.results[*].isActive == updateMasterItemTypesResponse.body.isActive
    And match getMasterItemTypesResponse.results[*].code contains updateMasterItemTypesResponse.body.code
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updateMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoUpdated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @updateMasterItemTypesMandatoryFields 
  Scenario Outline: Update a item Types with category as Document Class for  all details
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path             |                                          0 |
      | id               | addMasterItemTypesResponse.header.entityId |
       | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "DocumentClass"                                   |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.documentClass | commandDocumentClass[0]               |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def updateMasterItemTypesResponse = response
    And print updateMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,addMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateMasterItemTypesResponse.body.id
    And match updateMasterItemTypesResponse.body.category == updateMasterInfoItemTypePayload.body.category
     And match updateMasterItemTypesResponse.body.code == updateMasterInfoItemTypePayload.body.code
    And match updateMasterItemTypesResponse.body.documentClass.id == updateMasterInfoItemTypePayload.body.documentClass.id
    And match updateMasterItemTypesResponse.body.documentClass.name == updateMasterInfoItemTypePayload.body.documentClass.name
    And match updateMasterItemTypesResponse.body.isActive == updateMasterInfoItemTypePayload.body.isActive
    And match updateMasterItemTypesResponse.body.effectiveDate == updateMasterInfoItemTypePayload.body.effectiveDate
    And sleep(10000)
    #    Get the item Types
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfo"                            |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path |                                                0 |
      | id   | updateMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,updateMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.effectiveDate == updateMasterItemTypesResponse.body.effectiveDate
      And match getMasterItemTypesResponse.category == updateMasterItemTypesResponse.body.category
    And sleep(15000)
    #    Get all item Types
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                            |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfo"                            |
      | ttl             |                                                  0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                    0 |
      | code                | addMasterItemTypesResponse.body.code |
      | shortDescription    |                                      |
      | displaySequence     |                                      |
      | isActive            |                                      |
      | category            |                                      |
      | lastUpdatedDateTime |                                      |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                    |
      | header              | getMasterItemTypesCommandHeader[0]     |
      | body.request        | {}                                     |
      | body.paginationSort | getMasterItemTypesCommandPagination[0] |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].id contains updateMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.results[*].code contains updateMasterItemTypesResponse.body.code
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updateMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoUpdated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @updateMasterItemTypesMandatoryFields 
  Scenario Outline: Update a item Types with category as MiscellaneousFees for  all details
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    #calling getAreaBasedOnDepartmentApi
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    #calling getDocumentTypeBasedOnDocumentClassApi
    And def resultDocumentType = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDefaultDocumentTypeBasedOnDocumentClasses')
    And def activeDocumentTypeResponse = resultDocumentType.response
    And print activeDocumentTypeResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path             |                                          0 |
      | id               | addMasterItemTypesResponse.header.entityId |
     | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "MiscellaneousFees"                               |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set commandFeeCode
      | path |                    0 |
      | id   | faker.UUID()         |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.department    | commandDepartment[0]                  |
      | body.area          | commandArea[0]                        |
      | body.documentClass | commandDocumentClass[0]               |
      | body.feeCode       | commandFeeCode[0]                     |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def updateMasterItemTypesResponse = response
    And print updateMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,addMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateMasterItemTypesResponse.body.id
      And match updateMasterItemTypesResponse.body.category == updateMasterInfoItemTypePayload.body.category
    And match updateMasterItemTypesResponse.body.shortDescription == updateMasterInfoItemTypePayload.body.shortDescription
    And match updateMasterItemTypesResponse.body.isActive == updateMasterInfoItemTypePayload.body.isActive
    And match updateMasterItemTypesResponse.body.department.id == updateMasterInfoItemTypePayload.body.department.id
    And match updateMasterItemTypesResponse.body.department.name == updateMasterInfoItemTypePayload.body.department.name
    And match updateMasterItemTypesResponse.body.area.name == updateMasterInfoItemTypePayload.body.area.name
    And match updateMasterItemTypesResponse.body.documentClass.id == updateMasterInfoItemTypePayload.body.documentClass.id
    And match updateMasterItemTypesResponse.body.feeCode.id == updateMasterInfoItemTypePayload.body.feeCode.id
    And match updateMasterItemTypesResponse.body.feeCode.name == updateMasterInfoItemTypePayload.body.feeCode.name
    And sleep(10000)
    #    Get the item Type
    Given url readBaseUrl
    And path '/api/GetItemTypeMasterInfo'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfo"                            |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path |                                     0 |
      | id   | updateMasterItemTypesResponse.body.id |
    And set getMasterItemTypesPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMasterItemTypesPayload
    And request getMasterItemTypesPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,masterInfoItemTypeCollectionNameRead+<tenantid>,updateMasterItemTypesResponse.body.id)
    And print mongoResult
    And match mongoResult == getMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.shortDescription == updateMasterItemTypesResponse.body.shortDescription
    And match getMasterItemTypesResponse.isActive == updateMasterItemTypesResponse.body.isActive
    And match getMasterItemTypesResponse.department.id == updateMasterItemTypesResponse.body.department.id
    And match getMasterItemTypesResponse.department.name == updateMasterItemTypesResponse.body.department.name
    And match getMasterItemTypesResponse.area.name == updateMasterItemTypesResponse.body.area.name
    And match getMasterItemTypesResponse.documentClass.id == updateMasterItemTypesResponse.body.documentClass.id
    And match getMasterItemTypesResponse.feeCode.id == updateMasterItemTypesResponse.body.feeCode.id
    And match getMasterItemTypesResponse.feeCode.name == updateMasterItemTypesResponse.body.feeCode.name
    And match getMasterItemTypesResponse.feeCode.effectiveDate == updateMasterItemTypesResponse.body.effectiveDate
    And sleep(15000)
    #    Get all item Types
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | updateMasterItemTypesResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | updateMasterItemTypesResponse.header.id            |
      | correlationId   | updateMasterItemTypesResponse.header.correlationId |
      | getType         | "Array"                                            |
      | commandUserId   | updateMasterItemTypesResponse.header.commandUserId |
      | tags            | []                                                 |
      | commandType     | "GetItemTypeMasterInfo"                            |
      | ttl             |                                                  0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |                                    0 |
      | code                | addMasterItemTypesResponse.body.code |
      | shortDescription    |                                      |
      | displaySequence     |                                      |
      | isActive            |                                    |
      | category            |                                      |
      | lastUpdatedDateTime |                                      |
    And set getMasterItemTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                    |
      | header              | getMasterItemTypesCommandHeader[0]     |
      | body.request        | getMasterItemTypesCommandHeader[0]  |
      | body.paginationSort | getMasterItemTypesCommandPagination[0] |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And print getMasterItemTypesResponse
    And match getMasterItemTypesResponse.results[*].id contains updateMasterItemTypesResponse.body.id
    And match getMasterItemTypesResponse.results[*].code contains updateMasterItemTypesResponse.body.code
    And def getMasterItemTypesResponseCount = karate.sizeOf(getMasterItemTypesResponse.results)
    And print getMasterItemTypesResponseCount
    And match getMasterItemTypesResponseCount == getMasterItemTypesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updateMasterItemTypesResponse.body.id
    And def eventName = "ItemTypeMasterInfoUpdated"
    And def evnentType = "ItemTypeMasterInfo"
    And def parentEntityId = addMasterItemTypesResponse.body.id
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
    And def entityName = "ItemTypeMasterInfo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateMasterItemTypesResponse.body.id
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
    And def evnentType = "ItemTypeMasterInfo"
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

  @updateMasterItemTypesWithInvalidFields
  Scenario Outline: Update a item Types with invalid details
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path             |                                          0 |
      | id               | addMasterItemTypesResponse.header.entityId |
      | code             | faker.getRandomNumber()                    |
      | shortDescription | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | category         | "Copy Request"                             |
      | effectiveDate    | dataGenerator.generateCurrentDateTime()    |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.documentClass | commandDocumentClass[0]               |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateMasterItemTypesWithMissingMandatoryFields
  Scenario Outline: Update a item Types with missing mandatory details
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path             |                                          0 |
      | id               | addMasterItemTypesResponse.header.entityId |
      | code             | faker.getRandomNumber()                    |
      | shortDescription | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | category         | "CopyRequest"                              |
    #| effectiveDate    | faker.getRandomBooleanValue()    |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.documentClass | commandDocumentClass[0]               |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateMasterItemTypeswithDuplicateID
  Scenario Outline: Update item Types with Duplicate ID
    Given url commandBaseUrl
    And path '/api/UpdateItemTypeMasterInfo'
    # Create item Types
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse = result.response
    And print addMasterItemTypesResponse
    # Create item Types 1
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CreateMasterInfoItemTypeswithAllFields')
    And def addMasterItemTypesResponse1 = result.response
    And print addMasterItemTypesResponse1
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And set updateMasterItemTypesCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/UpdateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addMasterItemTypesResponse.header.sourceId        |
      | tenantId        | <tenantid>                                        |
      | id              | addMasterItemTypesResponse.header.id              |
      | correlationId   | addMasterItemTypesResponse.header.correlationId   |
      | entityId        | addMasterItemTypesResponse.header.entityId        |
      | commandUserId   | addMasterItemTypesResponse.header.commandUserId   |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "UpdateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set updateMasterItemTypesCommandBody
      | path             |                                          0 |
      | id               | addMasterItemTypesResponse.header.entityId |
      | code             | addMasterItemTypesResponse1.body.code      |
      | shortDescription | faker.getRandomShortDescription()          |
      | isActive         | faker.getRandomBooleanValue()              |
      | category         | "CopyRequest"                              |
      | effectiveDate    | dataGenerator.generateCurrentDateTime()    |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
        | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set updateMasterInfoItemTypePayload
      | path               | [0]                                   |
      | header             | updateMasterItemTypesCommandHeader[0] |
      | body               | updateMasterItemTypesCommandBody[0]   |
      | body.documentClass | commandDocumentClass[0]               |
    And print updateMasterInfoItemTypePayload
    And request updateMasterInfoItemTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
