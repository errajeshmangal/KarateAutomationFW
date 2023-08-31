@FeeCodeHeaderE2E @FEECODEE2E
Feature: FeeCOdeHeader - Add, Edit, View, GridView

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeCodeHeaderCollection = 'CreateFeeCodeHeader_'
    And def feeCodeHeaderCollectionRead = 'FeeCodeHeaderDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def feeCodeParam = ["CreateFeeCodeHeader","FeeCodeHeader","UpdateFeeCodeHeader","GetFeeCodes","GetFeeCodeHeader"]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @createFeeHeaderCodeWithAllFieldsAndGetTheDetails
  Scenario Outline: Create a Fee Code Header with all the fields and Get the details
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #GetFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeHeader'
    And set getFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodeHeader-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.id            |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[4]                               |
      | getType         | "One"                                         |
      | ttl             |                                             0 |
    And set getFeeCodeHeaderCommandBody
      | path |                                0 |
      | id   | addFeeCodeHeaderResponse.body.id |
    And set getFeeCodeHeaderPayload
      | path         | [0]                              |
      | header       | getFeeCodeHeaderCommandHeader[0] |
      | body.request | getFeeCodeHeaderCommandBody[0]   |
    And print getFeeCodeHeaderPayload
    And request getFeeCodeHeaderPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderResponse = response
    And print getFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeHeaderCollectionRead+<tenantid>,addFeeCodeHeaderResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeHeaderResponse.id
    And match getFeeCodeHeaderResponse.feeCodeName == addFeeCodeHeaderResponse.body.feeCodeName
    #getAllFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeHeaderAllCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.entityId      |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | ttl             |                                             0 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[3]                               |
      | getType         | "Array"                                       |
    And set getFeeCodeHeaderCommandBodyRequest
      | path    |                                     0 |
      | feeCode | addFeeCodeHeaderResponse.body.feeCode |
    And set getFeeCodeHeaderCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeHeaderAllPayload
      | path                | [0]                                   |
      | header              | getFeeCodeHeaderAllCommandHeader[0]   |
      | body.request        | getFeeCodeHeaderCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeHeaderCommandPagination[0]  |
    And print getFeeCodeHeaderAllPayload
    And request getFeeCodeHeaderAllPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderAllResponse = response
    And print getFeeCodeHeaderAllResponse
    And match each getFeeCodeHeaderAllResponse.results[*].Active == true
    And def getFeeCodeHeaderAllResponseCount = karate.sizeOf(getFeeCodeHeaderAllResponse.results)
    And print getFeeCodeHeaderAllResponseCount
    And match getFeeCodeHeaderAllResponseCount == getFeeCodeHeaderAllResponse.totalRecordCount
    And match getFeeCodeHeaderAllResponse.results[0].feeCode == addFeeCodeHeaderResponse.body.feeCode
    # History Validation
    And def eventName = "FeeCodeHeaderCreated"
    And def evnentType = feeCodeParam[1]
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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
    And def entityName = feeCodeParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeHeaderResponse.body.id
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
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = feeCodeParam[1]
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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

  @createFeeCodeHeaderWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a Fee Code Header with mandatory fields and Get the details
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeHeaderWIthMandatoryFields')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #getAllFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeHeaderAllCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.entityId      |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | ttl             |                                             0 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[3]                               |
      | getType         | "Array"                                       |
    And set getFeeCodeHeaderCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeHeaderCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeHeaderAllPayload
      | path                | [0]                                   |
      | header              | getFeeCodeHeaderAllCommandHeader[0]   |
      | body.request        | getFeeCodeHeaderCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeHeaderCommandPagination[0]  |
    And print getFeeCodeHeaderAllPayload
    And request getFeeCodeHeaderAllPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderAllResponse = response
    And print getFeeCodeHeaderAllResponse
    And match each getFeeCodeHeaderAllResponse.results[*].Active == true
    And def getFeeCodeHeaderAllResponseCount = karate.sizeOf(getFeeCodeHeaderAllResponse.results)
    And print getFeeCodeHeaderAllResponseCount
    And match getFeeCodeHeaderAllResponseCount == getFeeCodeHeaderAllResponse.totalRecordCount
    #GetFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeHeader'
    And set getFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodeHeader-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.id            |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[4]                               |
      | getType         | "One"                                         |
      | ttl             |                                             0 |
    And set getFeeCodeHeaderCommandBody
      | path |                                0 |
      | id   | addFeeCodeHeaderResponse.body.id |
    And set getFeeCodeHeaderPayload
      | path         | [0]                              |
      | header       | getFeeCodeHeaderCommandHeader[0] |
      | body.request | getFeeCodeHeaderCommandBody[0]   |
    And print getFeeCodeHeaderPayload
    And request getFeeCodeHeaderPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderResponse = response
    And print getFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeHeaderCollectionRead+<tenantid>,addFeeCodeHeaderResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeHeaderResponse.id
    And match getFeeCodeHeaderResponse.feeCodeName == addFeeCodeHeaderResponse.body.feeCodeName
    And match getFeeCodeHeaderResponse.description == addFeeCodeHeaderResponse.body.description
    # History Validation
    And def eventName = "FeeCodeHeaderCreated"
    And def evnentType = feeCodeParam[1]
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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
    And def entityName = feeCodeParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeHeaderResponse.body.id
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
    And def evnentType =  feeCodeParam[1]
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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

  @UpdateFeeCodeHeaderWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a Fee Code Header with all the fields and Get the details
    #Create Fee Code Header and Update
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeHeader'
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get document class by county area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def addDocumentClassResponse = result.response
    And print addDocumentClassResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    #Get  Serial Number assigned Dummy API
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@GetAllSerialNumberAssigned')
    And def getSerialNumberResponse = result.response
    And print getSerialNumberResponse
    #Get  FeeCode Fee Grps API
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@RetrieveAllFeeCodesFeeGrps')
    And def getFeeCodeFeeGrpsResponse = result.response
    And print getFeeCodeFeeGrpsResponse
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    And set updateFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeHeader-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              |DataGenerator.Id()             |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | entityId        | addFeeCodeHeaderResponse.header.entityId      |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             2 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[2]                               |
      | entityName      | feeCodeParam[1]                               |
      | ttl             |                                             0 |
    And set updateFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | addFeeCodeHeaderResponse.body.id                   |
      | feeCode                       | addFeeCodeHeaderResponse.body.feeCode              |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | description                   | faker.getRandomShortDescription()                  |
      | feeType                       | faker.getFeeType()                                 |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | feeOutputCategory             | faker.FeeOutPutCategoryEnum()                      |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | documentClass.code            | addDocumentClassResponse.results[0].code           |
      | documentClass.id              | addDocumentClassResponse.results[0].id             |
      | documentClass.description     | addDocumentClassResponse.results[0].name           |
      | documentClass.isActive        | addDocumentClassResponse.results[0].isActive       |
      | serialNumberAssigned.id       | getSerialNumberResponse.results[0].id              |
      | serialNumberAssigned.code     | getSerialNumberResponse.results[0].code            |
      | serialNumberAssigned.isActive | getSerialNumberResponse.results[0].isActive        |
      | feeEditRule                   | "Test Fee Edit Rule"                               |
      | maxAmountPerOrder             | dataGenerator.generateSingleOrDoubleDigitNumber()  |
      | notAllowedWithTaxes           | faker.getRandomBoolean()                           |
      | warningOrError                | "Warning"                                          |
      | uniqueProcessingFlag          | "Certified Copy"                                   |
      | allowAdjustment               | faker.getRandomBoolean()                           |
      | cityCode                      | faker.getRandomBoolean()                           |
      | restrictedFeeUsage            | faker.getRandomBoolean()                           |
      | taxable                       | faker.getRandomBoolean()                           |
      | allowDuplicateFeeCodeEntry    | faker.getRandomBoolean()                           |
      | includeInOverrideDropdown     | faker.getRandomBoolean()                           |
      | shouldBeFeeCode.id            | getFeeCodeFeeGrpsResponse.results[0].id            |
      | shouldBeFeeCode.code          | getFeeCodeFeeGrpsResponse.results[0].code          |
      | shouldBeFeeCode.name          | getFeeCodeFeeGrpsResponse.results[0].name          |
      | shouldBeFeeCode.isActive      | getFeeCodeFeeGrpsResponse.results[0].isActive      |
      | isActive                      | faker.getRandomBoolean()                           |
    And set updateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | updateFeeCodeHeaderCommandHeader[0] |
      | body   | updateFeeCodeHeaderCommandBody[0]   |
    And print updateFeeCodeHeaderPayload
    And request updateFeeCodeHeaderPayload
    When method POST
    Then status 201
    And def updateFeeCodeHeaderResponse = response
    And print updateFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeHeaderCollection+<tenantid>,addFeeCodeHeaderResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeHeaderResponse.body.id
    And match updateFeeCodeHeaderResponse.body.description == updateFeeCodeHeaderPayload.body.description
    And match updateFeeCodeHeaderResponse.body.feeCodeName == updateFeeCodeHeaderPayload.body.feeCodeName
    And match updateFeeCodeHeaderResponse.body.feeReportingGroup.code == updateFeeCodeHeaderPayload.body.feeReportingGroup.code
    And sleep(10000)
    #GetFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeHeader'
    And set getFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodeHeader-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.entityId      |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[4]                               |
      | getType         | "One"                                         |
      | ttl             |                                             0 |
    And set getFeeCodeHeaderCommandBody
      | path |                                0 |
      | id   | addFeeCodeHeaderResponse.body.id |
    And set getFeeCodeHeaderPayload
      | path         | [0]                              |
      | header       | getFeeCodeHeaderCommandHeader[0] |
      | body.request | getFeeCodeHeaderCommandBody[0]   |
    And print getFeeCodeHeaderPayload
    And request getFeeCodeHeaderPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderResponse = response
    And print getFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeHeaderCollectionRead+<tenantid>,addFeeCodeHeaderResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeHeaderResponse.id
    And match getFeeCodeHeaderResponse.feeCode == updateFeeCodeHeaderResponse.body.feeCode
    #getAllFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeHeaderAllCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.entityId      |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | ttl             |                                             0 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[3]                               |
      | getType         | "Array"                                       |
    And set getFeeCodeHeaderCommandBodyRequest
      | path    |                                       0 |
      | feeCode | updateFeeCodeHeaderPayload.body.feeCode |
    And set getFeeCodeHeaderCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeHeaderAllPayload
      | path                | [0]                                   |
      | header              | getFeeCodeHeaderAllCommandHeader[0]   |
      | body.request        | getFeeCodeHeaderCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeHeaderCommandPagination[0]  |
    And print getFeeCodeHeaderAllPayload
    And request getFeeCodeHeaderAllPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderAllResponse = response
    And print getFeeCodeHeaderAllResponse
    And match getFeeCodeHeaderAllResponse.results[0].feeCode == updateFeeCodeHeaderResponse.body.feeCode
    And def getFeeCodeHeaderAllResponseCount = karate.sizeOf(getFeeCodeHeaderAllResponse.results)
    And print getFeeCodeHeaderAllResponseCount
    And match getFeeCodeHeaderAllResponseCount == getFeeCodeHeaderAllResponse.totalRecordCount
    # History Validation
    And def eventName = "FeeCodeHeaderUpdated"
    And def evnentType =
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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
    And def entityName = feeCodeParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeHeaderResponse.body.id
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
    And def evnentType = "FeeCodeHeader"
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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

  @UpdateFeeCodeHeaderWithMandatoryFieldsAndGetTheDetails  
  Scenario Outline: Update a Fee Code Header with Mandatory fields and Get the details
    #CreateFeeCode Header and Update with mandatory Fields
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeHeader'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set updateFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeHeader-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | DataGenerator.Id()        |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | entityId        | addFeeCodeHeaderResponse.header.entityId      |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             2 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[2]                               |
      | entityName      | feeCodeParam[1]                               |
      | ttl             |                                             0 |
    And set updateFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | addFeeCodeHeaderResponse.body.id                   |
      | feeCode                       | addFeeCodeHeaderResponse.body.feeCode              |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | description                   | faker.getRandomShortDescription()                  |
      | feeType                       | faker.getFeeType()                                 |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | isActive                      | faker.getRandomBooleanValue()                      |
    And set updateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | updateFeeCodeHeaderCommandHeader[0] |
      | body   | updateFeeCodeHeaderCommandBody[0]   |
    And print updateFeeCodeHeaderPayload
    And request updateFeeCodeHeaderPayload
    When method POST
    Then status 201
    And def updateFeeCodeHeaderResponse = response
    And print updateFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeHeaderCollection+<tenantid>,addFeeCodeHeaderResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeCodeHeaderResponse.body.id
    And match updateFeeCodeHeaderResponse.body.description == updateFeeCodeHeaderPayload.body.description
    And match updateFeeCodeHeaderResponse.body.feeCodeName == updateFeeCodeHeaderPayload.body.feeCodeName
    And sleep(10000)
    #getAllFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And set getFeeCodeHeaderAllCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.entityId      |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | ttl             |                                             0 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[3]                               |
      | getType         | "Array"                                       |
    And set getFeeCodeHeaderCommandBodyRequest
      | path     |                        0 |
      | isActive | faker.getRandomBoolean() |
    And set getFeeCodeHeaderCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeHeaderAllPayload
      | path                | [0]                                   |
      | header              | getFeeCodeHeaderAllCommandHeader[0]   |
      | body.request        | getFeeCodeHeaderCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeHeaderCommandPagination[0]  |
    And print getFeeCodeHeaderAllPayload
    And request getFeeCodeHeaderAllPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderAllResponse = response
    And print getFeeCodeHeaderAllResponse
    And match each getFeeCodeHeaderAllResponse.results[*].Active == true
    And def getFeeCodeHeaderAllResponseCount = karate.sizeOf(getFeeCodeHeaderAllResponse.results)
    And print getFeeCodeHeaderAllResponseCount
    And match getFeeCodeHeaderAllResponseCount == getFeeCodeHeaderAllResponse.totalRecordCount
    #GetFeeCodeHeaderInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodeHeader'
    And set getFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/GetFeeCodeHeader-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              | addFeeCodeHeaderResponse.header.id            |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[4]                               |
      | getType         | "One"                                         |
      | ttl             |                                             0 |
    And set getFeeCodeHeaderCommandBody
      | path |                                0 |
      | id   | addFeeCodeHeaderResponse.body.id |
    And set getFeeCodeHeaderPayload
      | path         | [0]                              |
      | header       | getFeeCodeHeaderCommandHeader[0] |
      | body.request | getFeeCodeHeaderCommandBody[0]   |
    And print getFeeCodeHeaderPayload
    And request getFeeCodeHeaderPayload
    When method POST
    Then status 200
    And def getFeeCodeHeaderResponse = response
    And print getFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeCodeHeaderCollectionRead+<tenantid>,addFeeCodeHeaderResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeCodeHeaderResponse.id
    And match getFeeCodeHeaderResponse.feeCodeName == updateFeeCodeHeaderResponse.body.feeCodeName
    And match getFeeCodeHeaderResponse.feeCode == updateFeeCodeHeaderResponse.body.feeCode
    # History Validation
    And def eventName = "FeeCodeHeaderUpdated"
    And def evnentType =
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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
    And def entityName = feeCodeParam[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addFeeCodeHeaderResponse.body.id
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
    And def evnentType = "feecodeHeader"
    And def entityIdData = addFeeCodeHeaderResponse.body.id
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

  @CreateFeeCodeHeadersWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Fee Code Header with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeHeader'
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeHeaderCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeHeader-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | feeCodeParam[0]                              |
      | entityName      | feeCodeParam[1]                              |
      | ttl             |                                            0 |
    And set createFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | entityIdData                                       |
      | feeCode                       | faker.getRandomNumber()                            |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | feeType                       | faker.getFeeType()                                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | isActive                      | faker.getRandomBoolean()                           |
    And set CreateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | createFeeCodeHeaderCommandHeader[0] |
      | body   | createFeeCodeHeaderCommandBody[0]   |
    And print CreateFeeCodeHeaderPayload
    And request CreateFeeCodeHeaderPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCOdeHeaderWithMissingMandatoryField
  Scenario Outline: Create a Fee Code Header with missing mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeHeader'
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeHeaderCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeHeader-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | feeCodeParam[0]                              |
      | entityName      | feeCodeParam[1]                              |
      | ttl             |                                            0 |
    And set createFeeCodeHeaderCommandBody
      | path                          |                                                0 |
      | id                            | entityIdData                                     |
      | feeCode                       | faker.getRandomNumber()                          |
      | feeCodeName                   | faker.getRandomNumber()                          |
      | feeType                       | faker.getFeeType()                               |
      #	  | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive         |
      | feeOutputCategory.code        | faker.feeOutputCategory()                        |
      | feeOutputCategory.name        | faker.feeOutputCategory()                        |
      | feeOutputCategory.isActive    | faker.getRandomBoolean()                         |
      | department.id                 | addCountyDepartmentResponse.results[0].id        |
      | department.name               | addCountyDepartmentResponse.results[0].name      |
      | department.code               | addCountyDepartmentResponse.results[0].code      |
      | area.id                       | addCountyAreaResponse.results[0].id              |
      | area.name                     | addCountyAreaResponse.results[0].name            |
      | area.code                     | addCountyAreaResponse.results[0].code            |
      | isActive                      | faker.getRandomBoolean()                         |
    And set CreateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | createFeeCodeHeaderCommandHeader[0] |
      | body   | createFeeCodeHeaderCommandBody[0]   |
    And print CreateFeeCodeHeaderPayload
    And request CreateFeeCodeHeaderPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeHeaderWithDuplicatefeeCodeName  
  Scenario Outline: Create  duplicate feeCode ID  and Validate
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse = result.response
    And print getAllFeeCodeResponse
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeHeader'
    And set createFeeCodeHeaderCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeHeader-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | feeCodeParam[0]                              |
      | entityName      | feeCodeParam[1]                              |
      | ttl             |                                            0 |
    And set createFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | entityIdData                                       |
      | feeCode                       | getAllFeeCodeResponse.results[0].feeCode           |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | feeType                       | faker.getFeeType()                                 |
      | description                   | faker.getRandomShortDescription()                  |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | isActive                      | faker.getRandomBoolean()                           |
    And set CreateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | createFeeCodeHeaderCommandHeader[0] |
      | body   | createFeeCodeHeaderCommandBody[0]   |
    And print CreateFeeCodeHeaderPayload
    And request CreateFeeCodeHeaderPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeFeeHeaderWithDuplicateFeeCodeName  
  Scenario Outline: Update a FeeCodeFeeHeader with Duplicate Feecode ID
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse = result.response
    And print getAllFeeCodeResponse
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse1 = result.response
    And print getAllFeeCodeResponse1
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeHeaderWIthMandatoryFields')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeHeader'
    And set updateFeeCodeFeeInfoCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeHeader-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              |DataGenerator.Id()          |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | entityId        | addFeeCodeHeaderResponse.header.entityId      |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             2 |
      | tags            | []                                            |
      | commandType     | 'UpdateFeeCodeHeader'                         |
      | entityName      | 'FeeCodeHeader'                               |
      | ttl             |                                             0 |
    And set updateFeeCodeFeeInfoCommandBody
      | path                          |                                                  0 |
      | id                            | addFeeCodeHeaderResponse.body.id                   |
      | feeCode                       | getAllFeeCodeResponse.results[0].feeCode           |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | description                   | faker.getRandomShortDescription()                  |
      | feeType                       | faker.getFeeType()                                 |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | isActive                      | faker.getRandomBooleanValue()                      |
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

  @updateFeeCodeHeaderWithInvaliDataToMandatoryFields  
  Scenario Outline: Update a FeeCode Header with invalid data to mandatory fields
    #CreateFeeCode Header and Update with mandatory Fields
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeHeader'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set updateFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeHeader-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              |DataGenerator.Id()            |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | entityId        | addFeeCodeHeaderResponse.header.entityId      |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             2 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[2]                               |
      | entityName      | feeCodeParam[1]                               |
      | ttl             |                                             0 |
    And set updateFeeCodeHeaderCommandBody
      | path                          |                                           0 |
      | id                            | addFeeCodeHeaderResponse.body.id            |
      | feeCode                       | faker.getRandomNumber()                     |
      | feeCodeName                   | faker.getRandomBooleanValue()               |
      | feeType                       | faker.getFeeType()                          |
      | feeReportingGroup.code        | faker.getRandomBooleanValue()               |
      | feeReportingGroup.description | getFeeReportingGrpResponse.shortDescription |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.isActive         |
      | department.id                 | addCountyDepartmentResponse.results[0].id   |
      | department.name               | addCountyDepartmentResponse.results[0].name |
      | department.code               | addCountyDepartmentResponse.results[0].code |
      | area.id                       | addCountyAreaResponse.results[0].id         |
      | area.name                     | addCountyAreaResponse.results[0].name       |
      | area.code                     | addCountyAreaResponse.results[0].code       |
      | isActive                      | faker.getRandomBooleanValue()               |
    And set updateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | updateFeeCodeHeaderCommandHeader[0] |
      | body   | updateFeeCodeHeaderCommandBody[0]   |
    And print updateFeeCodeHeaderPayload
    And request updateFeeCodeHeaderPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeCodeHeaderWithMissingMandatoryFields 
  Scenario Outline: Update Fee Code Header with missing mandatory fields
    #CreateFeeCode Header and Update with mandatory Fields
    Given url commandBaseUrl
    When path '/api/UpdateFeeCodeHeader'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And set updateFeeCodeHeaderCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/UpdateFeeCodeHeader-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | addFeeCodeHeaderResponse.header.sourceId      |
      | tenantId        | <tenantid>                                    |
      | id              |DataGenerator.Id()           |
      | correlationId   | addFeeCodeHeaderResponse.header.correlationId |
      | entityId        | addFeeCodeHeaderResponse.header.entityId      |
      | commandUserId   | addFeeCodeHeaderResponse.header.commandUserId |
      | entityVersion   |                                             2 |
      | tags            | []                                            |
      | commandType     | feeCodeParam[2]                               |
      | entityName      | feeCodeParam[1]                               |
      | ttl             |                                             0 |
    And set updateFeeCodeHeaderCommandBody
      | path                          |                                           0 |
      | id                            | addFeeCodeHeaderResponse.body.id            |
      | feeCode                       | faker.getRandomNumber()                     |
      #| feeCodeName                   | faker.getRandomNumber()                     |
      | feeType                       | faker.getFeeType()                          |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.code             |
      | feeReportingGroup.description | getFeeReportingGrpResponse.shortDescription |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.isActive         |
      | department.id                 | addCountyDepartmentResponse.results[0].id   |
      | department.name               | addCountyDepartmentResponse.results[0].name |
      | department.code               | addCountyDepartmentResponse.results[0].code |
      | area.id                       | addCountyAreaResponse.results[0].id         |
      | area.name                     | addCountyAreaResponse.results[0].name       |
      | area.code                     | addCountyAreaResponse.results[0].code       |
      | isActive                      | faker.getRandomBooleanValue()               |
    And set updateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | updateFeeCodeHeaderCommandHeader[0] |
      | body   | updateFeeCodeHeaderCommandBody[0]   |
    And print updateFeeCodeHeaderPayload
    And request updateFeeCodeHeaderPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
