@FeeCodeGroupFeatureE2E
Feature: Create a fee code group E2E

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeCodeGroupCollectionName = 'CreateFeeGroupDetails_'
    And def createFeeCodeGroupCollectionNameRead = 'FeeGroupDetailsViewModel_'
    And def createFeeGroupCollectionName = 'CreateFeeGroup_'
    And def createFeeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateFeeGroupDetails','FeeGroupDetails','CreateFeeGroup','GetFeeGroupDetail','UpdateFeeGroupDetails','GetFeeGroupDetails']
    And def entityName = ['FeeGroupDetails','FeeCodeGroup','FeeGroup','GetFeeGroupDetail']
    And def restricted = [true,false]
    And def inherited = ['Y','N']
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['FeeGroupDetails']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateFeeCodeGroupWithRestrictedAndGetss
  Scenario Outline: Create a fee code group restricted and Get the details
    Given url readBaseUrl
    And path '/api/'+commandType[4]
    #Calling create fee code Group
    And def feeCodeGroupResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/CreateFeeCodeGroup.feature@CreateFeeCodeGroupWithRestricted')
    And def  feeCodeGroupResultResponse = feeCodeGroupResult.response
    And print feeCodeGroupResultResponse
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | commandUserId   | feeCodeGroupResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[5]                                  |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getCommandBody
      | path       |                                          0 |
      | feeGroupId | feeCodeGroupResultResponse.body.feeGroupId |
    And set getFeeCodeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeCodeGroupPayload
      | path                | [0]                                  |
      | header              | getCommandHeader[0]                  |
      | body.request        | getCommandBody[0]                    |
      | body.paginationSort | getFeeCodeGroupsCommandPagination[0] |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getFeeCodeGroupResponse = response
    And print getFeeCodeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getFeeCodeGroupResponse.results[0].id)
    And print mongoResult
    And match mongoResult == getFeeCodeGroupResponse.results[0].id
    #HistoryValidation
    And def entityIdData = getFeeCodeGroupResponse.results[0].id
    And def parentEntityId = feeCodeGroupResultResponse.body.feeGroupId
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
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
    And def eventEntityID = getFeeCodeGroupResponse.results[0].id
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
    And def evnentType = eventTypes[0]
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

  @UpdateFeeCodeGroupWithRestricted
  Scenario Outline: Update a fee code group restricted and Get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #Calling create fee code Group
    And def feeCodeGroupResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/CreateFeeCodeGroup.feature@CreateFeeCodeGroupWithRestricted')
    And def  feeCodeGroupResultResponse = feeCodeGroupResult.response
    And print feeCodeGroupResultResponse
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    And sleep(10000)
    And set updateFeeCodeGroupCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | tenantId        | <tenantid>                                      |
      | ttl             |                                               0 |
      | commandType     | commandType[4]                                  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | tags            | []                                              |
      | entityVersion   |                                               1 |
      | entityId        | feeCodeGroupResultResponse.header.entityId      |
      | commandUserId   | commandUserId                                   |
      | entityName      | entityName[0]                                   |
    # pass the fee group response value
    And set updateFeeCodeGroupCommandBody
      | path         |                                            0 |
      | id           | feeCodeGroupResultResponse.body.id           |
      | feeGroupId   | feeCodeGroupResultResponse.body.feeGroupId   |
      | feeGroupCode | feeCodeGroupResultResponse.body.feeGroupCode |
      | description  | feeCodeGroupResultResponse.body.description  |
    # pass the fee code API response particular list index value
    And set updatefeeCodeGroupCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set updatefeeCodeGroupCommandBody
      | path           |                                                      0 |
      | id             | feeCodeGroupResultResponse.body.feeCode.id             |
      | feeCodeId      | feeCodeGroupResultResponse.body.feeCode.feeCodeId      |
      | feeCodeName    | feeCodeGroupResultResponse.body.feeCode.feeCodeName    |
      | feeDescription | feeCodeGroupResultResponse.body.feeCode.feeDescription |
      | feeType        | feeCodeGroupResultResponse.body.feeCode.feeType        |
      | isActive       | feeCodeGroupResultResponse.body.feeCode.isActive       |
      | inherited      | feeCodeGroupResultResponse.body.feeCode.inherited      |
      | optional       | feeCodeGroupResultResponse.body.feeCode.optional       |
      | allowRemoval   | feeCodeGroupResultResponse.body.feeCode.allowRemoval   |
    And set updateeFeeCodeGroupPayload
      | path         | [0]                                |
      | header       | updateFeeCodeGroupCommandHeader[0] |
      | body         | updateFeeCodeGroupCommandBody[0]   |
      | body.feeCode | updatefeeCodeGroupCommandBody      |
    And print updateeFeeCodeGroupPayload
    And request updateeFeeCodeGroupPayload
    When method POST
    Then status 201
    And def updateFeeCodeGroupResponse = response
    And print updateFeeCodeGroupResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeCodeGroupCollectionName+<tenantid>,updateFeeCodeGroupResponse.body.id)
    And print mongoResult
    And match mongoResult == updateFeeCodeGroupResponse.body.id
    And match updateeFeeCodeGroupPayload.body.feeGroupId == updateFeeCodeGroupResponse.body.feeGroupId
    And match updateeFeeCodeGroupPayload.body.feeCode[0].feeCodeId == updateFeeCodeGroupResponse.body.feeCode[0].feeCodeId
    #Get the updated fee code
    Given url readBaseUrl
    And path '/api/'+commandType[5]
     And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | commandUserId   | feeCodeGroupResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[5]                                  |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getCommandBody
      | path       |                                          0 |
      | feeGroupId | feeCodeGroupResultResponse.body.feeGroupId |
    And set getFeeCodeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeCodeGroupPayload
      | path                | [0]                                  |
      | header              | getCommandHeader[0]                  |
      | body.request        | getCommandBody[0]                    |
      | body.paginationSort | getFeeCodeGroupsCommandPagination[0] |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getUpdatedFeeGroupResponse = response
    And print getUpdatedFeeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getUpdatedFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == getUpdatedFeeGroupResponse.id
    And match getUpdatedFeeGroupResponse.feeGroupId == updateFeeCodeGroupResponse.body.feeGroupId
    And match getUpdatedFeeGroupResponse.feeCode[0].feeCodeId == updateFeeCodeGroupResponse.body.feeCode[0].feeCodeId
    #HistoryValidation
    And def entityIdData = getUpdatedFeeGroupResponse.id
    And def parentEntityId = feeCodeGroupResultResponse.body.feeGroupId
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
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
    And def eventEntityID = getUpdatedFeeGroupResponse.id
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
    And def evnentType = eventTypes[0]
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

  @FeeCodeGroupWithInheritedGroupsAndGet
  Scenario Outline: Create a fee code group with inherited fee group and Get the details
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    #Calling create fee code Group
    And def feeCodeGroupResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/CreateFeeCodeGroup.feature@CreateFeeCodeGroupWithInheritedFeeGroup')
    And def  feeCodeGroupResultResponse = feeCodeGroupResult.response
    And print feeCodeGroupResultResponse
    And set getFeeCodeGroupCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | commandUserId   | feeCodeGroupResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[3]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getFeeCodeGroupCommandBody
      | path |                                  0 |
      | id   | feeCodeGroupResultResponse.body.id |
    And set getFeeCodeGroupPayload
      | path         | [0]                             |
      | header       | getFeeCodeGroupCommandHeader[0] |
      | body.request | getFeeCodeGroupCommandBody[0]   |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getFeeCodeGroupResponse = response
    And print getFeeCodeGroupResponse
    And print dbnameGet+createFeeCodeGroupCollectionNameRead+getFeeCodeGroupResponse.id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getFeeCodeGroupResponse.id)
    And print mongoResult
    And match mongoResult == getFeeCodeGroupResponse.id
    And match getFeeCodeGroupResponse.feeCode[0].feeCodeId == feeCodeGroupResultResponse.body.feeCode[0].feeCodeId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeCodeGroupWithInheritedGroupAndGet
  Scenario Outline: Update a fee code group with inherited Group and Get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #Calling create fee code Group
    And def feeCodeGroupResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/CreateFeeCodeGroup.feature@CreateFeeCodeGroupWithInheritedFeeGroup')
    And def  feeCodeGroupResultResponse = feeCodeGroupResult.response
    And print feeCodeGroupResultResponse
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    And sleep(10000)
    And set updateFeeCodeGroupCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | tenantId        | <tenantid>                                      |
      | ttl             |                                               0 |
      | commandType     | commandType[4]                                  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | tags            | []                                              |
      | entityVersion   |                                               1 |
      | entityId        | feeCodeGroupResultResponse.header.entityId      |
      | commandUserId   | commandUserId                                   |
      | entityName      | entityName[0]                                   |
    # pass the fee group response value
    And set updateFeeCodeGroupCommandBody
      | path         |                                            0 |
      | id           | feeCodeGroupResultResponse.body.id           |
      | feeGroupId   | feeCodeGroupResultResponse.body.feeGroupId   |
      | feeGroupCode | feeCodeGroupResultResponse.body.feeGroupCode |
      | description  | feeCodeGroupResultResponse.body.description  |
    # pass the fee code API response particular list index value
    And set updatefeeCodeGroupCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set updatefeeCodeGroupCommandBody
      | path           |                                                         1 |
      | id             | feeCodeGroupResultResponse.body.feeCode[0].id             |
      | feeCodeId      | feeCodeGroupResultResponse.body.feeCode[0].feeCodeId      |
      | feeCodeName    | feeCodeGroupResultResponse.body.feeCode[0].feeCodeName    |
      | feeDescription | feeCodeGroupResultResponse.body.feeCode[0].feeDescription |
      | feeType        | feeCodeGroupResultResponse.body.feeCode[0].feeType        |
      | isActive       | feeCodeGroupResultResponse.body.feeCode[0].isActive       |
      | inherited      | feeCodeGroupResultResponse.body.feeCode[0].inherited      |
      | optional       | feeCodeGroupResultResponse.body.feeCode[0].optional       |
      | allowRemoval   | feeCodeGroupResultResponse.body.feeCode[0].allowRemoval   |
    And set updateeFeeCodeGroupPayload
      | path                      | [0]                                                  |
      | header                    | updateFeeCodeGroupCommandHeader[0]                   |
      | body                      | updateFeeCodeGroupCommandBody[0]                     |
      | body.feeCode              | updatefeeCodeGroupCommandBody                        |
      | body.inheritFeeGroup.id   | feeCodeGroupResultResponse.body.inheritFeeGroup.id   |
      | body.inheritFeeGroup.code | feeCodeGroupResultResponse.body.inheritFeeGroup.code |
      | body.inheritFeeGroup.name | feeCodeGroupResultResponse.body.inheritFeeGroup.name |
    And print updateeFeeCodeGroupPayload
    And request updateeFeeCodeGroupPayload
    When method POST
    Then status 201
    And def updateFeeCodeGroupResponse = response
    And print updateFeeCodeGroupResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeCodeGroupCollectionName+<tenantid>,updateFeeCodeGroupResponse.body.id)
    And print mongoResult
    And match mongoResult == updateFeeCodeGroupResponse.body.id
    And match updateeFeeCodeGroupPayload.body.feeGroupId == updateFeeCodeGroupResponse.body.feeGroupId
    And match updateeFeeCodeGroupPayload.body.feeCode[0].feeDescription == updateFeeCodeGroupResponse.body.feeCode[0].feeDescription
    #Calling get fee code Group
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getFeeCodeGroupCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateFeeCodeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateFeeCodeGroupResponse.header.id            |
      | correlationId   | updateFeeCodeGroupResponse.header.correlationId |
      | commandUserId   | updateFeeCodeGroupResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[3]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getFeeCodeGroupCommandBody
      | path |                                  0 |
      | id   | updateFeeCodeGroupResponse.body.id |
    And set getFeeCodeGroupPayload
      | path         | [0]                             |
      | header       | getFeeCodeGroupCommandHeader[0] |
      | body.request | getFeeCodeGroupCommandBody[0]   |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getFeeCodeGroupResponse = response
    And print getFeeCodeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getFeeCodeGroupResponse.id)
    And print mongoResult
    And match mongoResult == getFeeCodeGroupResponse.id
    And match getFeeCodeGroupResponse.feeCode[0].feeCodeId == updateFeeCodeGroupResponse.body.feeCode[0].feeCodeId
    And match getFeeCodeGroupResponse.feeCode[1].feeType  == feeCodeGroupResultResponse.body.feeCode[0].feeType
    #HistoryValidation
    And def entityIdData = getFeeCodeGroupResponse.id
    And def parentEntityId = feeCodeGroupResultResponse.body.feeGroupId
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
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
    And def eventEntityID = getUpdatedFeeGroupResponse.id
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
    And def evnentType = eventTypes[0]
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
