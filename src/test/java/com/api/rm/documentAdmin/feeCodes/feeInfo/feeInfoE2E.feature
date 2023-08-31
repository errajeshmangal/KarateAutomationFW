@FeeCodeFeeInfo @FEECODEE2E
Feature: FeeCodeFeeInfo - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def FeeCodeFeeInfoCollection = 'CreateFeeCodeFeeInfo_'
    And def FeeCodeFeeInfoCollectionRead = 'FeeCodeFeeInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def feeCodeInfoParam = ["CreateFeeCodeFeeInfo","FeeCodeFeeInfo","UpdateFeeCodeFeeInfo","GetFeeCodes","GetFeeCodeFeeInfo"]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def feeCodeParam = ["CreateFeeCodeHeader","FeeCodeHeader"]

  @createFeeCodeFeeInfoWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a Fee Code FeeInfo with all the fields and Get the details
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@CreateFeeCodeInfoAllFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    #GetFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeInfo'
    And set getFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[4]                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeFeeInfoCommandBody
      | path |                                 0 |
      | id   | addFeeCodeFeeInfoResponse.body.id |
    And set getFeeCodeFeeInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeFeeInfoCommandHeader[0] |
      | body.request | getFeeCodeFeeInfoCommandBody[0]   |
    And print getFeeCodeFeeInfoPayload
    And request getFeeCodeFeeInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoResponse = response
    And print getFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeFeeInfoResponse.id
    And match getFeeCodeFeeInfoResponse.feeCodeName == addFeeCodeFeeInfoResponse.body.feeCodeName
    #GetFeeCodeFeeInfo for Tax
    Given url readBaseUrl
    And path '/api/GetFeeCodeTaxInfo'
    And set getFeeCodeTaxInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeTaxInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "GetFeeCodeTaxInfo"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeTaxInfoCommandBody
      | path      |                                        0 |
      | feeCodeId | addFeeCodeFeeInfoResponse.body.feeCodeId |
    And set getFeeCodeTaxInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeTaxInfoCommandHeader[0] |
      | body.request | getFeeCodeTaxInfoCommandBody[0]   |
    And print getFeeCodeTaxInfoPayload
    And request getFeeCodeTaxInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeTaxInfoResponse = response
    And print getFeeCodeTaxInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeTaxInfoResponse.id
    And match getFeeCodeTaxInfoResponse.feeCodeName == addFeeCodeFeeInfoResponse.body.feeCodeName
    And match getFeeCodeTaxInfoResponse.taxInfo[0].taxBaseAmount == addFeeCodeFeeInfoResponse.body.taxInfo[0].taxBaseAmount
    And match getFeeCodeTaxInfoResponse.taxInfo[0].taxRate == addFeeCodeFeeInfoResponse.body.taxInfo[0].taxRate
    #getAllFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeFeeInfoAllCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.entityId      |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[3]                            |
      | getType         | "Array"                                        |
    And set getFeeCodeFeeInfoCommandBodyRequest
      | path    |                                      0 |
      | feeCode | addFeeCodeFeeInfoResponse.body.feeCode |
    And set getFeeCodeFeeInfoCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeInfoAllPayload
      | path                | [0]                                    |
      | header              | getFeeCodeFeeInfoAllCommandHeader[0]   |
      | body.request        | getFeeCodeFeeInfoCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeInfoCommandPagination[0]  |
    And print getFeeCodeFeeInfoAllPayload
    And request getFeeCodeFeeInfoAllPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoAllResponse = response
    And print getFeeCodeFeeInfoAllResponse
    And def getFeeCodeFeeInfoAllResponseCount = karate.sizeOf(getFeeCodeFeeInfoAllResponse.results)
    And print getFeeCodeFeeInfoAllResponseCount
    And match getFeeCodeFeeInfoAllResponseCount == getFeeCodeFeeInfoAllResponse.totalRecordCount
    And match getFeeCodeFeeInfoAllResponse.results[0].feeCode == addFeeCodeFeeInfoResponse.body.feeCode
    # History Validation
    And def eventName = "FeeCodeFeeInfoCreated"
    And def evnentType = feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
    And def parentEntityId = null
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
    And def entityName = feeCodeInfoParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeFeeInfoResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
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
    And def evnentType = feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
    And def viewAllCommentResult = call read(' classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
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

  @createFeeCodeFeeInfoWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a FeeCodeFeeInfo with mandatory fields and Get the details
    #Create Fee Code info with mandatory fields and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@createFeeCodeFeeInfoWithMandatoryFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    #GetFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeInfo'
    And set getFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[4]                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeFeeInfoCommandBody
      | path |                                 0 |
      | id   | addFeeCodeFeeInfoResponse.body.id |
    And set getFeeCodeFeeInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeFeeInfoCommandHeader[0] |
      | body.request | getFeeCodeFeeInfoCommandBody[0]   |
    And print getFeeCodeFeeInfoPayload
    And request getFeeCodeFeeInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoResponse = response
    And print getFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeFeeInfoResponse.id
    And match getFeeCodeFeeInfoResponse.id == addFeeCodeFeeInfoResponse.body.id
    And match getFeeCodeFeeInfoResponse.feeCodeId == addFeeCodeFeeInfoResponse.body.feeCodeId
    And match getFeeCodeFeeInfoResponse.formulaId.code == addFeeCodeFeeInfoResponse.body.formulaId.code
    And match getFeeCodeFeeInfoResponse.effectiveDate == addFeeCodeFeeInfoResponse.body.effectiveDate
    #GetFeeCodeFeeInfofor Taxinfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeTaxInfo'
    And set getFeeCodeTaxInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeTaxInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | "GetFeeCodeTaxInfo"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeTaxInfoCommandBody
      | path      |                                        0 |
      | feeCodeId | addFeeCodeFeeInfoResponse.body.feeCodeId |
    And set getFeeCodeTaxInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeTaxInfoCommandHeader[0] |
      | body.request | getFeeCodeTaxInfoCommandBody[0]   |
    And print getFeeCodeTaxInfoPayload
    And request getFeeCodeTaxInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeTaxInfoResponse = response
    And print getFeeCodeTaxInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeTaxInfoResponse.id
    And match getFeeCodeTaxInfoResponse.feeCodeName == addFeeCodeFeeInfoResponse.body.feeCodeName
    And match getFeeCodeTaxInfoResponse.taxInfo[0].taxBaseAmount == addFeeCodeFeeInfoResponse.body.taxInfo[0].taxBaseAmount
    And match getFeeCodeTaxInfoResponse.taxInfo[0].taxRate == addFeeCodeFeeInfoResponse.body.taxInfo[0].taxRate
    #getAllFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeFeeInfoAllCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.entityId      |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[3]                            |
      | getType         | "Array"                                        |
    And set getFeeCodeFeeInfoCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeFeeInfoCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeInfoAllPayload
      | path                | [0]                                    |
      | header              | getFeeCodeFeeInfoAllCommandHeader[0]   |
      | body.request        | getFeeCodeFeeInfoCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeInfoCommandPagination[0]  |
    And print getFeeCodeFeeInfoAllPayload
    And request getFeeCodeFeeInfoAllPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoAllResponse = response
    And print getFeeCodeFeeInfoAllResponse
    And match each getFeeCodeFeeInfoAllResponse.results[*].Active == true
    And def getFeeCodeFeeInfoAllResponseCount = karate.sizeOf(getFeeCodeFeeInfoAllResponse.results)
    And print getFeeCodeFeeInfoAllResponseCount
    And match getFeeCodeFeeInfoAllResponseCount == getFeeCodeFeeInfoAllResponse.totalRecordCount
    # History Validation
    And def eventName = "FeeCodeFeeInfoCreated"
    And def evnentType = feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
    And def parentEntityId = null
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
    And def entityName = feeCodeInfoParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeFeeInfoResponse.body.id
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
    And def evnentType =  feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
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

  @UpdateFeeCodeFeeInfoWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a FeeCodeFeeInfo with all the fields and Get the details
    #Create FeeCodeFeeInfo and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeInfo'
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@CreateFeeCodeInfoAllFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | entityId        | addFeeCodeFeeInfoResponse.header.entityId      |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[2]                            |
      | entityName      | feeCodeInfoParam[1]                            |
      | ttl             |                                              0 |
    And set updateFeeCodeFeeInfoCommandBody
      | path                     |                                                       0 |
      | id                       | addFeeCodeFeeInfoResponse.body.id                       |
      | feeCode                  | addFeeCodeFeeInfoResponse.body.feeCode                  |
      | feeCodeId                | addFeeCodeFeeInfoResponse.body.feeCodeId                |
      | feeCodeName              | addFeeCodeFeeInfoResponse.body.feeCodeName              |
      | effectiveDate            | dataGenerator.generateCurrentDateTime()                 |
      | formulaId.id             | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code           | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description    | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive       | getAllFeeFormulasResponse.results[0].isActive           |
      | formulaDescription       | getAllFeeFormulasResponse.results[0].feeFormula1         |
      | feeBaseAmount            | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      | taxInfo[0].tierNumber    | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      | taxInfo[0].fromRange     | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      | taxInfo[0].thruRange     | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      | taxInfo[0].taxBaseAmount | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      | taxInfo[0].taxRate       | dataGenerator.generateSingleOrDoubleDigitNumber()       |
    And set updateFeeCodeFeeInfoPayload
      | path   | [0]                                  |
      | header | updateFeeCodeFeeInfoCommandHeader[0] |
      | body   | updateFeeCodeFeeInfoCommandBody[0]   |
    And print updateFeeCodeFeeInfoPayload
    And request updateFeeCodeFeeInfoPayload
    When method POST
    Then status 201
    And def updateFeeCodeFeeInfoResponse = response
    And print updateFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,FeeCodeFeeInfoCollection+<tenantid>,addFeeCodeFeeInfoResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeFeeInfoResponse.body.id
    And match updateFeeCodeFeeInfoResponse.body.formulaId.description == updateFeeCodeFeeInfoPayload.body.formulaId.description
    And match updateFeeCodeFeeInfoResponse.body.formulaId.isActive == updateFeeCodeFeeInfoPayload.body.formulaId.isActive
    And sleep(10000)
    #GetFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeInfo'
    And set getFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[4]                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeFeeInfoCommandBody
      | path |                                 0 |
      | id   | addFeeCodeFeeInfoResponse.body.id |
    And set getFeeCodeFeeInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeFeeInfoCommandHeader[0] |
      | body.request | getFeeCodeFeeInfoCommandBody[0]   |
    And print getFeeCodeFeeInfoPayload
    And request getFeeCodeFeeInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoResponse = response
    And print getFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeFeeInfoResponse.id
    And match getFeeCodeFeeInfoResponse.formulaId.description == updateFeeCodeFeeInfoResponse.body.formulaId.description
    #getAllFeeCodeFeeInfoInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeFeeInfoAllCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.entityId      |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[3]                            |
      | getType         | "Array"                                        |
    And set getFeeCodeFeeInfoCommandBodyRequest
      | path    |                                        0 |
      | feeCode | updateFeeCodeFeeInfoPayload.body.feeCode |
    And set getFeeCodeFeeInfoCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeInfoAllPayload
      | path                | [0]                                    |
      | header              | getFeeCodeFeeInfoAllCommandHeader[0]   |
      | body.request        | getFeeCodeFeeInfoCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeInfoCommandPagination[0]  |
    And print getFeeCodeFeeInfoAllPayload
    And request getFeeCodeFeeInfoAllPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoAllResponse = response
    And print getFeeCodeFeeInfoAllResponse
    And match each getFeeCodeFeeInfoAllResponse.results[*].Active == true
    And match getFeeCodeFeeInfoAllResponse.results[0].feeCode == updateFeeCodeFeeInfoResponse.body.feeCode
    And def getFeeCodeFeeInfoAllResponseCount = karate.sizeOf(getFeeCodeFeeInfoAllResponse.results)
    And print getFeeCodeFeeInfoAllResponseCount
    And match getFeeCodeFeeInfoAllResponseCount == getFeeCodeFeeInfoAllResponse.totalRecordCount
    # History Validation
    And def eventName = "FeeCodeFeeInfoUpdated"
    And def evnentType = feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
    And def parentEntityId = null
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
    #Adding the comment
    And def entityName = feeCodeInfoParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeFeeInfoResponse.body.id
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
    And def evnentType = "FeeCodeFeeInfo"
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
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

  @UpdateFeeCodeFeeInfoWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a FeeCodeFeeInfo with Mandatory fields and Get the details
    #Create FeeCodeFeeInfo and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeInfo'
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@createFeeCodeFeeInfoWithMandatoryFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And set updateFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | DataGenerator.Id()                             |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | entityId        | addFeeCodeFeeInfoResponse.header.entityId      |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[2]                            |
      | entityName      | feeCodeInfoParam[1]                            |
      | ttl             |                                              0 |
    And set updateFeeCodeFeeInfoCommandBody
      | path                  |                                                       0 |
      | id                    | addFeeCodeFeeInfoResponse.body.id                       |
      | feeCodeId             | addFeeCodeFeeInfoResponse.body.feeCodeId                |
      | effectiveDate         | dataGenerator.generateCurrentDateTime()                 |
      | formulaId.id          | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code        | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive    | getAllFeeFormulasResponse.results[0].isActive           |
    And set updateFeeCodeFeeInfoPayload
      | path   | [0]                                  |
      | header | updateFeeCodeFeeInfoCommandHeader[0] |
      | body   | updateFeeCodeFeeInfoCommandBody[0]   |
    And print updateFeeCodeFeeInfoPayload
    And request updateFeeCodeFeeInfoPayload
    When method POST
    Then status 201
    And def updateFeeCodeFeeInfoResponse = response
    And print updateFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,FeeCodeFeeInfoCollection+<tenantid>,addFeeCodeFeeInfoResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeFeeInfoResponse.body.id
    And match updateFeeCodeFeeInfoResponse.body.formulaId.description == updateFeeCodeFeeInfoPayload.body.formulaId.description
    And match updateFeeCodeFeeInfoResponse.body.formulaId.isActive == updateFeeCodeFeeInfoPayload.body.formulaId.isActive
    And sleep(10000)
    #GetFeeCodeFeeInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeFeeInfo'
    And set getFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodeFeeInfo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.id            |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              1 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[4]                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getFeeCodeFeeInfoCommandBody
      | path |                                 0 |
      | id   | addFeeCodeFeeInfoResponse.body.id |
    And set getFeeCodeFeeInfoPayload
      | path         | [0]                               |
      | header       | getFeeCodeFeeInfoCommandHeader[0] |
      | body.request | getFeeCodeFeeInfoCommandBody[0]   |
    And print getFeeCodeFeeInfoPayload
    And request getFeeCodeFeeInfoPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoResponse = response
    And print getFeeCodeFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,FeeCodeFeeInfoCollectionRead+<tenantid>,addFeeCodeFeeInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeFeeInfoResponse.id
    And match getFeeCodeFeeInfoResponse.formulaId.description == updateFeeCodeFeeInfoResponse.body.formulaId.description
    And sleep(10000)
    #getAllFeeCodeFeeInfoInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeFeeInfoAllCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addFeeCodeFeeInfoResponse.header.entityId      |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[3]                            |
      | getType         | "Array"                                        |
    And set getFeeCodeFeeInfoCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeFeeInfoCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeInfoAllPayload
      | path                | [0]                                    |
      | header              | getFeeCodeFeeInfoAllCommandHeader[0]   |
      | body.request        | getFeeCodeFeeInfoCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeInfoCommandPagination[0]  |
    And print getFeeCodeFeeInfoAllPayload
    And request getFeeCodeFeeInfoAllPayload
    When method POST
    Then status 200
    And def getFeeCodeFeeInfoAllResponse = response
    And print getFeeCodeFeeInfoAllResponse
    And match each getFeeCodeFeeInfoAllResponse.results[*].Active == true
    And def getFeeCodeFeeInfoAllResponseCount = karate.sizeOf(getFeeCodeFeeInfoAllResponse.results)
    And print getFeeCodeFeeInfoAllResponseCount
    And match getFeeCodeFeeInfoAllResponseCount == getFeeCodeFeeInfoAllResponse.totalRecordCount
    # History Validation
    And def eventName = "FeeCodeFeeInfoUpdated"
    And def evnentType = feeCodeInfoParam[1]
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
    And def parentEntityId = null
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
    #Adding the comment
    And def entityName = feeCodeInfoParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeFeeInfoResponse.body.id
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
    And def evnentType = "FeeCodeFeeInfo"
    And def entityIdData = addFeeCodeFeeInfoResponse.body.id
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

  @CreateFeeCodeFeeInfosWithInvalidDataToMandatoryFields
  Scenario Outline: Create a FeeCodeFeeInfo with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeInfo'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeInfoCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeInfo-v1.001.json" |
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
      | commandType     | feeCodeInfoParam[0]                           |
      | entityName      | feeCodeInfoParam[1]                           |
      | ttl             |                                             0 |
    And set createFeeCodeInfoCommandBody
      | path                  |                                                       0 |
      | id                    | entityIdData                                            |
      | feeCodeId             | addFeeCodeHeaderResponse.body.feeCodeId                 |
      | feeCodeName           | addFeeCodeHeaderResponse.body.feeCodeName               |
      | effectiveDate         | addFeeCodeHeaderResponse.body.feeCodeName               |
      | formulaId.id          | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code        | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive    | getAllFeeFormulasResponse.results[0].isActive           |
      | formulaDescription    | getAllFeeFormulasResponse.results[0].feeFormula         |
    And set createFeeInfoPayload
      | path   | [0]                               |
      | header | createFeeCodeInfoCommandHeader[0] |
      | body   | createFeeCodeInfoCommandBody[0]   |
    And print createFeeInfoPayload
    And request createFeeInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeFeeInfoWithMissingMandatoryField
  Scenario Outline: Create a FeeCodeFeeInfo with missing mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeInfo'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeInfoCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeInfo-v1.001.json" |
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
      | commandType     | feeCodeInfoParam[0]                           |
      | entityName      | feeCodeInfoParam[1]                           |
      | ttl             |                                             0 |
    And set createFeeCodeInfoCommandBody
      | path                  |                                         0 |
      | id                    | entityIdData                              |
      | feeCodeId             | addFeeCodeHeaderResponse.body.feeCodeId   |
      | feeCodeName           | addFeeCodeHeaderResponse.body.feeCodeName |
      #| effectiveDate         | addFeeCodeHeaderResponse.body.feeCodeName  |
      | formulaId.code        | faker.getRandomNumber()                   |
      | formulaId.description | faker.getRandomShortDescription()         |
      | formulaId.isActive    | faker.getRandomBoolean()                  |
      | formulaDescription    | faker.getRandomShortDescription()         |
    And set createFeeInfoPayload
      | path   | [0]                               |
      | header | createFeeCodeInfoCommandHeader[0] |
      | body   | createFeeCodeInfoCommandBody[0]   |
    And print createFeeInfoPayload
    And request createFeeInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeFeeInfoWithInvaliDataToMandatoryFields
  Scenario Outline: Update a FeeCode info with invalid data to mandatory fields
    #Create FeeCodeFeeInfo and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeInfo'
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@createFeeCodeFeeInfoWithMandatoryFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And set updateFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | DataGenerator.Id()                             |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | entityId        | addFeeCodeFeeInfoResponse.header.entityId      |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[2]                            |
      | entityName      | feeCodeInfoParam[1]                            |
      | ttl             |                                              0 |
    And set updateFeeCodeFeeInfoCommandBody
      | path                  |                                                       0 |
      | id                    | addFeeCodeFeeInfoResponse.body.id                       |
      | feeCodeId             | addFeeCodeFeeInfoResponse.body.feeCodeId                |
      | feeCodeName           | addFeeCodeFeeInfoResponse.body.feeCodeName              |
      | effectiveDate         | faker.getRandomShortDescription()                       |
      | formulaId.id          | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code        | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive    | getAllFeeFormulasResponse.results[0].isActive           |
    And set updateFeeCodeFeeInfoPayload
      | path   | [0]                                  |
      | header | updateFeeCodeFeeInfoCommandHeader[0] |
      | body   | updateFeeCodeFeeInfoCommandBody[0]   |
    And print updateFeeCodeFeeInfoPayload
    And request updateFeeCodeFeeInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeFeeInfoWithMissingMandatoryFields
  Scenario Outline: Update FeeCodeFeeInfo with missing mandatory fields
    #Create FeeCodeFeeInfo and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeFeeInfo'
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@createFeeCodeFeeInfoWithMandatoryFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    And set updateFeeCodeFeeInfoCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeFeeInfo-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addFeeCodeFeeInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | DataGenerator.Id()                             |
      | correlationId   | addFeeCodeFeeInfoResponse.header.correlationId |
      | entityId        | addFeeCodeFeeInfoResponse.header.entityId      |
      | commandUserId   | addFeeCodeFeeInfoResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | feeCodeInfoParam[2]                            |
      | entityName      | feeCodeInfoParam[1]                            |
      | ttl             |                                              0 |
    And set updateFeeCodeFeeInfoCommandBody
      | path                  |                                        0 |
      | id                    | addFeeCodeFeeInfoResponse.body.id        |
      | feeCodeId             | addFeeCodeFeeInfoResponse.body.feeCodeId |
      | effectiveDate         | ""                                       |
      | formulaId.code        | faker.getRandomNumber()                  |
      | formulaId.description | faker.getRandomNumber()                  |
      | formulaId.isActive    | faker.getRandomBoolean()                 |
    And set updateFeeCodeFeeInfoPayload
      | path   | [0]                                  |
      | header | updateFeeCodeFeeInfoCommandHeader[0] |
      | body   | updateFeeCodeFeeInfoCommandBody[0]   |
    And print updateFeeCodeFeeInfoPayload
    And request updateFeeCodeFeeInfoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
