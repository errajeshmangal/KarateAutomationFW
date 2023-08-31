@FeeCodeFeeDistribution @FEECODEE2E
Feature: FeeCodeFeeDistribution - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeCodeDistributionCollection = 'CreateFeeCodeFeeDistribution_'
    And def feeCodeDistributionCollectionRead = 'FeeCodeFeeDistributionDetailViewModel_'
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def distributionParam = ["CreateFeeCodeFeeDistribution","FeeCodeFeeDistribution","UpdateFeeCodeAccountDistribution","GetFeeCodes","GetFeeCodeFeeDistribution","GetFeeCodeAccountDistribution","UpdateFeeCodeFeeDistribution"]

  @createFeeDistributionWithAllFieldsAndGetTheDetails  
  Scenario Outline: Create a FeeDistribution with all the fields and Get the details
    #Create Fee Code Distribution and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/CreateDistibution.feature@CreateFeeDistribution')
    And def addFeeCodeDistributionResponse = result.response
    And print addFeeCodeDistributionResponse
    #GetFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeDistribution'
    And set getFeeCodeDistributionCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeDistribution-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.id            |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | distributionParam[4]                                |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getFeeCodeDistributionCommandBody
      | path |                                      0 |
      | id   | addFeeCodeDistributionResponse.body.id |
    And set getFeeCodeDistributionPayload
      | path         | [0]                                    |
      | header       | getFeeCodeDistributionCommandHeader[0] |
      | body.request | getFeeCodeDistributionCommandBody[0]   |
    And print getFeeCodeDistributionPayload
    And request getFeeCodeDistributionPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionResponse = response
    And print getFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeDistributionCollectionRead+<tenantid>,addFeeCodeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeDistributionResponse.id
    And match getFeeCodeDistributionResponse.feeCodeName == addFeeCodeDistributionResponse.body.feeCodeName
    And match getFeeCodeDistributionResponse.effectiveDate == addFeeCodeDistributionResponse.body.effectiveDate
    #GetFeeCode Distribution with account 
      Given url readBaseUrl
    And path '/api/GetFeeCodeAccountDistribution'
    And set getFeeCodeAccountDistributionCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeAccountDistribution-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeDistributionResponse.header.id            |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     |  distributionParam[5]                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeAccountDistributionCommandBody
      | path |                                 0 |
      | feeCodeId   | addFeeCodeDistributionResponse.body.feeCodeId |
    And set getFeeCodeAccountDistributionPayload
      | path         | [0]                               |
      | header       | getFeeCodeAccountDistributionCommandHeader[0] |
      | body.request | getFeeCodeAccountDistributionCommandBody[0]   |
    And print getFeeCodeAccountDistributionPayload
    And request getFeeCodeAccountDistributionPayload
    When method POST
    Then status 200
    And def getFeeCodeAccountDistributionResponse = response
    And print getFeeCodeAccountDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeDistributionCollectionRead+<tenantid>,addFeeCodeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeAccountDistributionResponse.id
    And match getFeeCodeAccountDistributionResponse.feeCodeName == addFeeCodeDistributionResponse.body.feeCodeName
     And match getFeeCodeAccountDistributionResponse.accountDistribution[0].accountNumber.id == addFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.id
    #getAllFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeDistributionAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.entityId      |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | distributionParam[3]                                |
      | getType         | "Array"                                             |
    And set getFeeCodeDistributionCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBooleanValue() |
    And set getFeeCodeDistributionCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeDistributionAllPayload
      | path                | [0]                                         |
      | header              | getFeeCodeDistributionAllCommandHeader[0]   |
      | body.request        | getFeeCodeDistributionCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeDistributionCommandPagination[0]  |
    And print getFeeCodeDistributionAllPayload
    And request getFeeCodeDistributionAllPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionAllResponse = response
    And print getFeeCodeDistributionAllResponse
    And match each getFeeCodeDistributionAllResponse.results[*].Active == true
    And def getFeeCodeDistributionAllResponseCount = karate.sizeOf(getFeeCodeDistributionAllResponse.results)
    And print getFeeCodeDistributionAllResponseCount
    And match getFeeCodeDistributionAllResponseCount == getFeeCodeDistributionAllResponse.totalRecordCount
    # History Validation
    #And def eventName = "FeeCodeFeeDistributionCreated"
    #And def evnentType = distributionParam[1]
    #And def entityIdData = addFeeCodeDistributionResponse.body.id
     #And def parentEntityId  = null
    #And def commandUserid = commandUserId
      #And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    #And def historyResponse = historyResult.response
    #And print historyResponse
    #And match historyResponse.results[*].entityId contains entityIdData
    #And match historyResponse.results[*].eventName contains eventName
    #And def entity = historyResponse.results[0].id
    #And def mongoResult = mongoData.MongoDBReader(dbnameGet,historyCollectionNameRead+<tenantid>,entity)
    #And print mongoResult
    #And match mongoResult == entity
    #And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    #And print getHistoryResponseCount
    #And match getHistoryResponseCount == 1
        #Adding the comment
    #And def entityName = distributionParam[1]
    #And def entityComment = faker.getRandomNumber()
    #And def eventEntityID = addFeeCodeDistributionResponse.body.id
    #And def commandUserid = commandUserId
    #And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    #And def createCommentResponse = commentResult.response
    #And print createCommentResponse
    #And match createCommentResponse.body.comment == entityComment
    #updating the comments
    #And def updatedEntityComment = faker.getRandomNumber()
    #And def commentEntityID = createCommentResponse.body.id
    #And def updateCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    #And def updatedCommentResponse = updateCommentResult.response
    #And print updatedCommentResponse
    #And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    #And def viewCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentResponse = viewCommentResult.response
    #And print viewCommentResponse
    #And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    #And def evnentType = distributionParam[1]
    #And def entityIdData = addFeeCodeDistributionResponse.body.id
    #And def viewAllCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentsResponse = viewAllCommentResult.response
    #And print viewCommentsResponse
    #And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    #And print viewCommentsResponseCount
    #And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    #And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def deleteCommentsResponse = deleteCommentResult.response
    #And print deleteCommentsResponse
    # view the comment after delete
    #And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentResponse = viewCommentResult.response
    #And print viewCommentResponse
    #And match viewCommentResponse == 'null'
    #Get all the comments after delete
    #And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    #And def viewCommentsResponse = viewAllCommentResult.response
    #And print viewCommentsResponse
    #And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createFeeCodeDistributionWithMandatoryFieldsAndGetTheDetails  
  Scenario Outline: Create a Fee Code Distribution with mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@createFeeCodeFeeInfoWithMandatoryFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | tenantId        | <tenantid>                                            |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | entityId        | entityIdData                                          |
      | commandUserId   | commandUserId                                         |
      | entityVersion   |                                                     1 |
      | tags            | []                                                    |
      | commandType     | distributionParam[0]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set createFeeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | entityIdData                                      |
      | feeCodeId                                  | addFeeCodeFeeInfoResponse.body.feeCodeId          |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set createFeeDistributionPayload
      | path   | [0]                                   |
      | header | createFeeDistributionCommandHeader[0] |
      | body   | createFeeDistributionCommandBody[0]   |
    And print createFeeDistributionPayload
    And request createFeeDistributionPayload
    When method POST
    Then status 201
    And def createFeeDistributionResponse = response
    And print createFeeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeDistributionCollection+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeeDistributionResponse.body.id
    And match createFeeDistributionResponse.body.accountDistribution[0].distributionAmount == createFeeDistributionPayload.body.accountDistribution[0].distributionAmount
    And match createFeeDistributionResponse.body.accountDistribution[0].accountNumber.id == createFeeDistributionPayload.body.accountDistribution[0].accountNumber.id
    #getAllFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeDistributionAllCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"               |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | createFeeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | createFeeDistributionResponse.header.entityId      |
      | correlationId   | createFeeDistributionResponse.header.correlationId |
      | commandUserId   | createFeeDistributionResponse.header.commandUserId |
      | ttl             |                                                  0 |
      | tags            | []                                                 |
      | commandType     | distributionParam[3]                               |
      | getType         | "Array"                                            |
    And set getFeeCodeDistributionCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeDistributionCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeDistributionAllPayload
      | path                | [0]                                         |
      | header              | getFeeCodeDistributionAllCommandHeader[0]   |
      | body.request        | getFeeCodeDistributionCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeDistributionCommandPagination[0]  |
    And print getFeeCodeDistributionAllPayload
    And request getFeeCodeDistributionAllPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionAllResponse = response
    And print getFeeCodeDistributionAllResponse
    And match each getFeeCodeDistributionAllResponse.results[*].Active == true
    And def getFeeCodeDistributionAllResponseCount = karate.sizeOf(getFeeCodeDistributionAllResponse.results)
    And print getFeeCodeDistributionAllResponseCount
    And match getFeeCodeDistributionAllResponseCount == getFeeCodeDistributionAllResponse.totalRecordCount
    #GetFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeAccountDistribution'
    And set getFeeCodeDistributionCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetFeeCodeAccountDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | createFeeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                         |
      | id              | createFeeDistributionResponse.header.id            |
      | correlationId   | createFeeDistributionResponse.header.correlationId |
      | commandUserId   | createFeeDistributionResponse.header.commandUserId |
      | entityVersion   |                                                  1 |
      | tags            | []                                                 |
      | commandType     | distributionParam[5]                               |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getFeeCodeDistributionCommandBody
      | path |                                     0 |
      | feeCodeId   | createFeeDistributionResponse.body.feeCodeId |
    And set getFeeCodeDistributionPayload
      | path         | [0]                                    |
      | header       | getFeeCodeDistributionCommandHeader[0] |
      | body.request | getFeeCodeDistributionCommandBody[0]   |
    And print getFeeCodeDistributionPayload
    And request getFeeCodeDistributionPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionResponse = response
    And print getFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeDistributionCollectionRead+<tenantid>,createFeeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeDistributionResponse.id
    And match getFeeCodeDistributionResponse.feeCodeId == createFeeDistributionResponse.body.feeCodeId
    # History Validation
    And def eventName = "FeeCodeFeeDistributionCreated"
    And def evnentType = distributionParam[1]
    And def entityIdData = createFeeDistributionResponse.body.id
     And def parentEntityId  = null
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
      #Adding the comment
    And def entityName = distributionParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFeeDistributionResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType =  distributionParam[1]
    And def entityIdData = createFeeDistributionResponse.body.id
    And def viewAllCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeCodeDistributionWithAllFieldsAndGetTheDetails @testinh
  Scenario Outline: Update a Fee Code Distribution with all the fields and Get the details
    #Create Fee Code Distribution and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeDistribution'
    #Create Fee Code Distribution and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/CreateDistibution.feature@CreateFeeDistribution')
    And def addFeeCodeDistributionResponse = result.response
    And print addFeeCodeDistributionResponse
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And set updateFeeCodeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                            |
      | id              | DataGenerator.Id()              |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId   |
      | entityId        | addFeeCodeDistributionResponse.header.entityId        |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId   |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | distributionParam[6]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set updateFeeCodeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | addFeeCodeDistributionResponse.body.id            |
      | feeCodeId                                  | addFeeCodeDistributionResponse.body.feeCodeId     |
      | feeCode                                    | addFeeCodeDistributionResponse.body.feeCode            |
      | feeCodeName                                | addFeeCodeDistributionResponse.body.feeCodeName   |
      | effectiveDate                              | addFeeCodeDistributionResponse.body.effectiveDate |
      | descriptionAmount                          |  addFeeCodeDistributionResponse.body.descriptionAmount |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set updateFeeCodeDistributionPayload
      | path   | [0]                                       |
      | header | updateFeeCodeDistributionCommandHeader[0] |
      | body   | updateFeeCodeDistributionCommandBody[0]   |
    And print updateFeeCodeDistributionPayload
    And request updateFeeCodeDistributionPayload
    When method POST
    Then status 201
    And def updateFeeCodeDistributionResponse = response
    And print updateFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeDistributionCollection+<tenantid>,addFeeCodeDistributionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeDistributionResponse.body.id
    And match updateFeeCodeDistributionResponse.body.feeCodeName == updateFeeCodeDistributionPayload.body.feeCodeName
    And match updateFeeCodeDistributionResponse.body.accountDistribution[0].distributionAmount == updateFeeCodeDistributionPayload.body.accountDistribution[0].distributionAmount
   And match updateFeeCodeDistributionResponse.body.accountDistribution[0].distributionPercent == updateFeeCodeDistributionPayload.body.accountDistribution[0].distributionPercent
    And sleep(10000)
    #getAllFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeDistributionAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.entityId      |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | distributionParam[3]                                |
      | getType         | "Array"                                             |
    And set getFeeCodeDistributionCommandBodyRequest
      | path        |                                                 0 |
      | feeCode | updateFeeCodeDistributionPayload.body.feeCode |
    And set getFeeCodeDistributionCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeDistributionAllPayload
      | path                | [0]                                         |
      | header              | getFeeCodeDistributionAllCommandHeader[0]   |
      | body.request        | getFeeCodeDistributionCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeDistributionCommandPagination[0]  |
    And print getFeeCodeDistributionAllPayload
    And request getFeeCodeDistributionAllPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionAllResponse = response
    And print getFeeCodeDistributionAllResponse
    And match getFeeCodeDistributionAllResponse.results[0].feeCodeId == updateFeeCodeDistributionResponse.body.feeCodeId
    And match getFeeCodeDistributionAllResponse.results[0].feeCode == updateFeeCodeDistributionResponse.body.feeCode
    And match getFeeCodeDistributionAllResponse.results[0].effectiveDate == updateFeeCodeDistributionResponse.body.effectiveDate
    And def getFeeCodeDistributionAllResponseCount = karate.sizeOf(getFeeCodeDistributionAllResponse.results)
    And print getFeeCodeDistributionAllResponseCount
    And match getFeeCodeDistributionAllResponseCount == getFeeCodeDistributionAllResponse.totalRecordCount
    #GetFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeDistribution'
    And set getFeeCodeDistributionCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeDistribution-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.id            |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | distributionParam[4]                                |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getFeeCodeDistributionCommandBody
      | path |                                      0 |
      | id   | updateFeeCodeDistributionResponse.body.id |
    And set getFeeCodeDistributionPayload
      | path         | [0]                                    |
      | header       | getFeeCodeDistributionCommandHeader[0] |
      | body.request | getFeeCodeDistributionCommandBody[0]   |
    And print getFeeCodeDistributionPayload
    And request getFeeCodeDistributionPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionResponse = response
    And print getFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeDistributionCollectionRead+<tenantid>,addFeeCodeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeDistributionResponse.id
    And match getFeeCodeDistributionResponse.feeCodeId == updateFeeCodeDistributionResponse.body.feeCodeId
    And match getFeeCodeDistributionResponse.feeCodeName == updateFeeCodeDistributionResponse.body.feeCodeName
    And match getFeeCodeDistributionResponse.descriptionAmount == updateFeeCodeDistributionResponse.body.descriptionAmount
    And match getFeeCodeDistributionResponse.accountDistribution[0].accountNumber.id == updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.id
    And match getFeeCodeDistributionResponse.accountDistribution[0].accountNumber.code == updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.code
    # History Validation
    And def eventName = "FeeCodeDistributionUpdated"
    And def evnentType =distributionParam[1]
    And def entityIdData = addFeeCodeDistributionResponse.body.id
     And def parentEntityId  = null
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
       #Adding the comment
    And def entityName = distributionParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeDistributionResponse.body.id
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
    And def evnentType = "FeeCodeDistribution"
    And def entityIdData = addFeeCodeDistributionResponse.body.id
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
    And sleep(10000)
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeCodeDistributionWithMandatoryFieldsAndGetTheDetails @testinh
  Scenario Outline: Update a Fee Code Distribution with Mandatory fields and Get the details
    #Create Fee Code Distribution and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create a Account Code 2
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse1 = result.response
    And print createAccountCodeResponse1
    #Create Fee Code Distribution and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/CreateDistibution.feature@CreateFeeDistribution')
    And def addFeeCodeDistributionResponse = result.response
    And print addFeeCodeDistributionResponse
    And set updateFeeCodeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                            |
      | id              | DataGenerator.Id()              |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId   |
      | entityId        | addFeeCodeDistributionResponse.header.entityId        |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId   |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | distributionParam[6]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set updateFeeCodeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | addFeeCodeDistributionResponse.body.id            |
      | feeCodeId                                  | addFeeCodeDistributionResponse.body.feeCodeId     |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[1].accountNumber.id    | createAccountCodeResponse1.body.fundCode.id       |
      | accountDistribution[1].accountNumber.code  | createAccountCodeResponse1.body.fundCode.code     |
      | accountDistribution[1].accountNumber.name  | createAccountCodeResponse1.body.fundCode.name     |
      | accountDistribution[1].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[1].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set updateFeeCodeDistributionPayload
      | path   | [0]                                       |
      | header | updateFeeCodeDistributionCommandHeader[0] |
      | body   | updateFeeCodeDistributionCommandBody[0]   |
    And print updateFeeCodeDistributionPayload
    And request updateFeeCodeDistributionPayload
    When method POST
    Then status 201
    And def updateFeeCodeDistributionResponse = response
    And print updateFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeDistributionCollection+<tenantid>,addFeeCodeDistributionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeDistributionResponse.body.id
    And match updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.code == updateFeeCodeDistributionPayload.body.accountDistribution[0].accountNumber.code
    And match updateFeeCodeDistributionResponse.body.accountDistribution[0].distributionAmount == updateFeeCodeDistributionPayload.body.accountDistribution[0].distributionAmount
    And match updateFeeCodeDistributionResponse.body.accountDistribution[1].accountNumber.code == updateFeeCodeDistributionPayload.body.accountDistribution[1].accountNumber.code
    And match updateFeeCodeDistributionResponse.body.accountDistribution[1].distributionAmount == updateFeeCodeDistributionPayload.body.accountDistribution[1].distributionAmount
    And sleep(10000)
    #getAllFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeDistributionAllCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"                |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.entityId      |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | ttl             |                                                   0 |
      | tags            | []                                                  |
      | commandType     | distributionParam[3]                                |
      | getType         | "Array"                                             |
    And set getFeeCodeDistributionCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeDistributionCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeDistributionAllPayload
      | path                | [0]                                         |
      | header              | getFeeCodeDistributionAllCommandHeader[0]   |
      | body.request        | getFeeCodeDistributionCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeDistributionCommandPagination[0]  |
    And print getFeeCodeDistributionAllPayload
    And request getFeeCodeDistributionAllPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionAllResponse = response
    And print getFeeCodeDistributionAllResponse
    And match each getFeeCodeDistributionAllResponse.results[*].Active == true
    And def getFeeCodeDistributionAllResponseCount = karate.sizeOf(getFeeCodeDistributionAllResponse.results)
    And print getFeeCodeDistributionAllResponseCount
    And match getFeeCodeDistributionAllResponseCount == getFeeCodeDistributionAllResponse.totalRecordCount
    #GetFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeDistribution'
    And set getFeeCodeDistributionCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeDistribution-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | addFeeCodeDistributionResponse.header.id            |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId |
      | entityVersion   |                                                   1 |
      | tags            | []                                                  |
      | commandType     | distributionParam[4]                                |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getFeeCodeDistributionCommandBody
      | path |                                      0 |
      | id   | addFeeCodeDistributionResponse.body.id |
    And set getFeeCodeDistributionPayload
      | path         | [0]                                    |
      | header       | getFeeCodeDistributionCommandHeader[0] |
      | body.request | getFeeCodeDistributionCommandBody[0]   |
    And print getFeeCodeDistributionPayload
    And request getFeeCodeDistributionPayload
    When method POST
    Then status 200
    And def getFeeCodeDistributionResponse = response
    And print getFeeCodeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeDistributionCollectionRead+<tenantid>,addFeeCodeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeDistributionResponse.id
    And match getFeeCodeDistributionResponse.feeCodeId == updateFeeCodeDistributionResponse.body.feeCodeId
    And match getFeeCodeDistributionResponse.accountDistribution[0].accountNumber.id == updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.id
    And match getFeeCodeDistributionResponse.accountDistribution[0].accountNumber.code == updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.code
    And match getFeeCodeDistributionResponse.accountDistribution[0].accountNumber.name == updateFeeCodeDistributionResponse.body.accountDistribution[0].accountNumber.name
    # History Validation
    And def eventName = "FeeCodeDistributionUpdated"
    And def evnentType = distributionParam[1]
    And def entityIdData = addFeeCodeDistributionResponse.body.id
     And def parentEntityId  = null
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
      #Adding the comment
    And def entityName = distributionParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeDistributionResponse.body.id
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
    And def evnentType = "feecodeDistribution"
    And def entityIdData = addFeeCodeDistributionResponse.body.id
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
    And sleep(10000)
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeDistributionsWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Fee Code Distribution with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId              |
      | tenantId        | <tenantid>                                            |
      | id              | addFeeCodeHeaderResponse.header.id                    |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId         |
      | entityId        | addFeeCodeHeaderResponse.header.entityId              |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId         |
      | entityVersion   |                                                     1 |
      | tags            | []                                                    |
      | commandType     | distributionParam[0]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set createFeeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | addFeeCodeHeaderResponse.body.id                  |
      | feeCodeId                                  | addFeeCodeHeaderResponse.body.feeCodeId           |
      | feeCodeName                                | addFeeCodeHeaderResponse.body.feeCodeName         |
      | effectiveDate                              | dataGenerator.generateCurrentDateTime()           |
      | descriptionAmount                          | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      # invalid value
      | accountDistribution[0].distributionAmount  | dataGenerator.generateCurrentDateTime()           |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set createFeeDistributionPayload
      | path   | [0]                                   |
      | header | createFeeDistributionCommandHeader[0] |
      | body   | createFeeDistributionCommandBody[0]   |
    And print createFeeDistributionPayload
    And request createFeeDistributionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCOdeDistributionWithMissingMandatoryField @testinh
  Scenario Outline: Create a Fee Code Distribution with missing mandatory fields and Validate
   Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@CreateFeeCodeInfoAllFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | tenantId        | <tenantid>                                            |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | entityId        | entityIdData                                          |
      | commandUserId   | commandUserId                                         |
      | entityVersion   |                                                     1 |
      | tags            | []                                                    |
      | commandType     | distributionParam[0]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set createFeeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | entityIdData                                      |
      | feeCodeId                                  | addFeeCodeFeeInfoResponse.body.feeCodeId          |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      #| accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set createFeeDistributionPayload
      | path   | [0]                                   |
      | header | createFeeDistributionCommandHeader[0] |
      | body   | createFeeDistributionCommandBody[0]   |
    And print createFeeDistributionPayload
    And request createFeeDistributionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeDistributionWithInvaliDataToMandatoryFields
  Scenario Outline: Update a FeeCode Distribution with invalid data to mandatory fields
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
     #Create Fee Code Distribution and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/CreateDistibution.feature@CreateFeeDistribution')
    And def addFeeCodeDistributionResponse = result.response
    And print addFeeCodeDistributionResponse
    And set updateFeeCodeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                            |
      | id              | DataGenerator.Id()                |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId   |
      | entityId        | addFeeCodeDistributionResponse.header.entityId        |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId   |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | distributionParam[6]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set updateFeeCodeDistributionCommandBody
      | path                                       |                                             0 |
      | id                                         | addFeeCodeDistributionResponse.body.id        |
      | feeCodeId                                  | addFeeCodeDistributionResponse.body.feeCodeId |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id    |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code  |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name  |
      | accountDistribution[0].distributionAmount  | createAccountCodeResponse.body.fundCode.name  |
      | accountDistribution[0].distributionPercent | faker.getRandomBoolean()                      |
    And set updateFeeCodeDistributionPayload
      | path   | [0]                                       |
      | header | updateFeeCodeDistributionCommandHeader[0] |
      | body   | updateFeeCodeDistributionCommandBody[0]   |
    And print updateFeeCodeDistributionPayload
    And request updateFeeCodeDistributionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeDistributionWithMissingMandatoryFields
  Scenario Outline: Update Fee Code Distribution with missing mandatory fields
    #CreateFeeCode Distribution and Update with mandatory Fields
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create Fee Code Distribution and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/CreateDistibution.feature@CreateFeeDistribution')
    And def addFeeCodeDistributionResponse = result.response
    And print addFeeCodeDistributionResponse
    And set updateFeeCodeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addFeeCodeDistributionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                            |
      | id              |DataGenerator.Id()              |
      | correlationId   | addFeeCodeDistributionResponse.header.correlationId   |
      | entityId        | addFeeCodeDistributionResponse.header.entityId        |
      | commandUserId   | addFeeCodeDistributionResponse.header.commandUserId   |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | distributionParam[6]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set updateFeeCodeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | addFeeCodeDistributionResponse.body.id            |
      | feeCodeId                                  | addFeeCodeDistributionResponse.body.id            |
      #| accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set updateFeeCodeDistributionPayload
      | path   | [0]                                       |
      | header | updateFeeCodeDistributionCommandHeader[0] |
      | body   | updateFeeCodeDistributionCommandBody[0]   |
    And print updateFeeCodeDistributionPayload
    And request updateFeeCodeDistributionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
