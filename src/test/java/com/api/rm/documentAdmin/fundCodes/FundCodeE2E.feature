@FundCodesFeature
Feature: Fund Codes, Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def fundCodesCollectionName = 'CreateFundCode_'
    And def fundCodesCollectionNameRead = 'FundCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateFundCodesWithAllDetails
  Scenario Outline: Create a account code with all the details
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodes')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    #Get the Fund code
    Given url readBaseUrl
    And path '/api/GetFundCode'
    And sleep(12000)
    And set getFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | "GetFundCode"                               |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getFundCodeCommandBody
      | path |                                      0 |
      | id   | createFundCodeResponse.header.entityId |
    And set getFundCodePayload
      | path         | [0]                         |
      | header       | getFundCodeCommandHeader[0] |
      | body.request | getFundCodeCommandBody[0]   |
    And print getFundCodePayload
    And request getFundCodePayload
    When method POST
    Then status 200
    And def getFundCodeAPIResponse = response
    And print getFundCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,fundCodesCollectionNameRead+<tenantid>,createFundCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getFundCodeAPIResponse.id
    And match getFundCodeAPIResponse.department == createFundCodeResponse.body.department
    #Get All Fund Codes
    Given url readBaseUrl
    And path '/api/GetFundCodes'
    And set getFundCodesCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | "GetFundCodes"                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFundCodesCommandBodyRequest
      | path            |      0 |
      | fundCode        | null   |
      | longDescription | "Test" |
      | isActive        | null   |
      | lastUpdatedDate | null   |
    And set getFundCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFundCodesPayload
      | path                | [0]                               |
      | header              | getFundCodesCommandHeader[0]      |
      | body.request        | getFundCodesCommandBodyRequest[0] |
      | body.paginationSort | getFundCodesCommandPagination[0]  |
    And print getFundCodesPayload
    And request getFundCodesPayload
    When method POST
    Then status 200
    And def getFundCodesResponse = response
    And print getFundCodesResponse
    And match getFundCodesResponse.results[*].id contains createFundCodeResponse.body.id
    And match each getFundCodesResponse.results[*].longDescription contains "Test"
    And def getFundCodesResponseCount = karate.sizeOf(getFundCodesResponse.results)
    And print getFundCodesResponseCount
    And match getFundCodesResponseCount == getFundCodesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = createFundCodeResponse.body.id
    And def eventName = "FundCodeCreated"
    And def evnentType = "FundCode"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "FundCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFundCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomLongDescription()
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
    And def evnentType = "FundCode"
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

  @CreateFundCodesWithMandatoryFieldsAndGet
  Scenario Outline: Create a Fund code with only mandatory details and Validate
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodesWithMandatoryFields')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    #Get the Fund code
    Given url readBaseUrl
    And path '/api/GetFundCode'
    And sleep(12000)
    And set getFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | "GetFundCode"                               |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getFundCodeCommandBody
      | path |                                      0 |
      | id   | createFundCodeResponse.header.entityId |
    And set getFundCodePayload
      | path         | [0]                         |
      | header       | getFundCodeCommandHeader[0] |
      | body.request | getFundCodeCommandBody[0]   |
    And print getFundCodePayload
    And request getFundCodePayload
    When method POST
    Then status 200
    And def getFundCodeAPIResponse = response
    And print getFundCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,fundCodesCollectionNameRead+<tenantid>,createFundCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getFundCodeAPIResponse.id
    And match getFundCodeAPIResponse.fundCode == createFundCodeResponse.body.fundCode
    #Get All Fund Codes
    Given url readBaseUrl
    And path '/api/GetFundCodes'
    And set getFundCodesCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | "GetFundCodes"                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFundCodesCommandBodyRequest
      | path            |                                    0 |
      | fundCode        | null                                 |
      | longDescription | null                                 |
      | isActive        | createFundCodeResponse.body.isActive |
      | lastUpdatedDate | null                                 |
    And set getFundCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFundCodesPayload
      | path                | [0]                               |
      | header              | getFundCodesCommandHeader[0]      |
      | body.request        | getFundCodesCommandBodyRequest[0] |
      | body.paginationSort | getFundCodesCommandPagination[0]  |
    And print getFundCodesPayload
    And request getFundCodesPayload
    When method POST
    Then status 200
    And def getFundCodesResponse = response
    And print getFundCodesResponse
    And match getFundCodesResponse.results[*].id contains createFundCodeResponse.body.id
    And match each getFundCodesResponse.results[*].isActive == createFundCodeResponse.body.isActive
    And def getFundCodesResponseCount = karate.sizeOf(getFundCodesResponse.results)
    And print getFundCodesResponseCount
    And match getFundCodesResponseCount == getFundCodesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = createFundCodeResponse.body.id
    And def eventName = "FundCodeCreated"
    And def evnentType = "FundCode"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "FundCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createFundCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomLongDescription()
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
    And def evnentType = "FundCode"
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

  @CreateFundCodesWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Fund code with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateFundCode'
    And def entityIdData = dataGenerator.entityID()
    And set createFundCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateFundCode-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | []                                      |
      | commandType     | "CreateFundCode"                        |
      | entityName      | "FundCode"                              |
      | ttl             |                                       0 |
    And set createFundCommandBody
      | path             |                                 0 |
      | id               | faker.getUserId()                 |
      | fundCode         | faker.getUserId()                 |
      | shortDescription | faker.getRandomShortDescription() |
      | longDescription  | faker.getRandomLongDescription()  |
      | isActive         | faker.getRandomBoolean()          |
      | fundType         | faker.getRandomFundType()         |
      | fund             | faker.getFirstName()              |
      | department       | faker.getRandom5DigitNumber()     |
      | authority        | faker.getLastName()               |
      | project          | faker.getUserId()                 |
      | activity         | faker.getRandomShortDescription() |
      | account          | faker.getRandom5DigitNumber()     |
    And set createFundPayload
      | path   | [0]                        |
      | header | createFundCommandHeader[0] |
      | body   | createFundCommandBody[0]   |
    And print createFundPayload
    And request createFundPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFundCodesWithMissingMandatoryFields
  Scenario Outline: Create a Fund code with missing mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateFundCode'
    And def entityIdData = dataGenerator.entityID()
    And set createFundCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateFundCode-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | []                                      |
      | commandType     | "CreateFundCode"                        |
      | entityName      | "FundCode"                              |
      | ttl             |                                       0 |
    And set createFundCommandBody
      | path             |                                 0 |
      | id               | entityIdData                      |
      | fundCode         | faker.getUserId()                 |
      | shortDescription | faker.getRandomShortDescription() |
      | longDescription  | faker.getRandomLongDescription()  |
      | fundType         | faker.getRandomFundType()         |
      | authority        | faker.getLastName()               |
      | activity         | faker.getRandomShortDescription() |
    And set createFundPayload
      | path   | [0]                        |
      | header | createFundCommandHeader[0] |
      | body   | createFundCommandBody[0]   |
    And print createFundPayload
    And request createFundPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFundCodesWithAllFields
  Scenario Outline: Update a Fund code with all the details
    Given url commandBaseUrl
    And path '/api/UpdateFundCode'
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodes')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    And def firstName = faker.getFirstName()
    And set updateFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | createFundCodeResponse.header.entityId      |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "UpdateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set updateFundCodeCommandBody
      | path             |                                            0 |
      | id               | createFundCodeResponse.header.entityId       |
      | fundCode         | faker.getUserId()                            |
      | shortDescription | createFundCodeResponse.body.shortDescription |
      | longDescription  | faker.getRandomLongDescription()             |
      | isActive         | faker.getRandomBoolean()                     |
      | fundType         | faker.getRandomFundType()                    |
      | fund             | faker.getFirstName()                         |
      | department       | faker.getFirstName()                         |
      | authority        | faker.getLastName()                          |
      | project          | faker.getUserId()                            |
      | activity         | faker.getRandomShortDescription()            |
      | account          | faker.getUserId()                            |
    And set updateFundCodePayload
      | path   | [0]                            |
      | header | updateFundCodeCommandHeader[0] |
      | body   | updateFundCodeCommandBody[0]   |
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    Then status 201
    And def updateFundCodeResponse = response
    And print updateFundCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,fundCodesCollectionName+<tenantid>,updateFundCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFundCodeResponse.body.id
    And match updateFundCodeResponse.body.fundCode == updateFundCodePayload.body.fundCode
    And match updateFundCodeResponse.body.shortDescription == createFundCodeResponse.body.shortDescription
    #Get the Fund code
    Given url readBaseUrl
    And path '/api/GetFundCode'
    And sleep(12000)
    And set getFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | updateFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | updateFundCodeResponse.header.id            |
      | correlationId   | updateFundCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | "GetFundCode"                               |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getFundCodeCommandBody
      | path |                                      0 |
      | id   | updateFundCodeResponse.header.entityId |
    And set getFundCodePayload
      | path         | [0]                         |
      | header       | getFundCodeCommandHeader[0] |
      | body.request | getFundCodeCommandBody[0]   |
    And print getFundCodePayload
    And request getFundCodePayload
    When method POST
    Then status 200
    And def getFundCodeAPIResponse = response
    And print getFundCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,fundCodesCollectionNameRead+<tenantid>,getFundCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getFundCodeAPIResponse.id
    And match getFundCodeAPIResponse.shortDescription == createFundCodeResponse.body.shortDescription
    And match getFundCodeAPIResponse.fundCode == updateFundCodeResponse.body.fundCode
    #Get All Fund Codes
    Given url readBaseUrl
    And path '/api/GetFundCodes'
    And set getFundCodesCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | "GetFundCodes"                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFundCodesCommandBodyRequest
      | path            |                                    0 |
      | fundCode        | updateFundCodeResponse.body.fundCode |
      | longDescription | null                                 |
      | isActive        | null                                 |
      | lastUpdatedDate | null                                 |
    And set getFundCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFundCodesPayload
      | path                | [0]                               |
      | header              | getFundCodesCommandHeader[0]      |
      | body.request        | getFundCodesCommandBodyRequest[0] |
      | body.paginationSort | getFundCodesCommandPagination[0]  |
    And print getFundCodesPayload
    And request getFundCodesPayload
    When method POST
    Then status 200
    And def getFundCodesResponse = response
    And print getFundCodesResponse
    And match getFundCodesResponse.results[*].id contains updateFundCodeResponse.body.id
    And match each getFundCodesResponse.results[*].fundCode == updateFundCodeResponse.body.fundCode
    And def getFundCodesResponseCount = karate.sizeOf(getFundCodesResponse.results)
    And print getFundCodesResponseCount
    And match getFundCodesResponseCount == getFundCodesResponse.totalRecordCount
    #HistoryValidation
    And def eventName = "FundCodeUpdated"
    And def evnentType = "FundCode"
    And def commandUserid = commandUserId
    And def entityIdData = updateFundCodeResponse.body.id
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "FundCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateFundCodeResponse.body.id
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
    And def evnentType = "FundCode"
    And def entityIdData = updateFundCodeResponse.body.id
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

  @updateFundCodesWithMandatoryFields
  Scenario Outline: Update a Fund code with only Mandatory details
    Given url commandBaseUrl
    And path '/api/UpdateFundCode'
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodesWithMandatoryFields')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    And def firstName = faker.getFirstName()
    And set updateFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | createFundCodeResponse.header.entityId      |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "UpdateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set updateFundCodeCommandBody
      | path             |                                      0 |
      | id               | createFundCodeResponse.header.entityId |
      | fundCode         | createFundCodeResponse.body.fundCode   |
      | shortDescription | faker.getRandomShortDescription()      |
      | longDescription  | faker.getRandomLongDescription()       |
      | fundType         | faker.getRandomFundType()              |
      | authority        | faker.getLastName()                    |
      | project          | faker.getUserId()                      |
      | activity         | faker.getRandomShortDescription()      |
    And set updateFundCodePayload
      | path   | [0]                            |
      | header | updateFundCodeCommandHeader[0] |
      | body   | updateFundCodeCommandBody[0]   |
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    Then status 201
    And def updateFundCodeResponse = response
    And print updateFundCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,fundCodesCollectionName+<tenantid>,updateFundCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateFundCodeResponse.body.id
    And match updateFundCodeResponse.body.shortDescription == updateFundCodePayload.body.shortDescription
    #Get the Fund code
    Given url readBaseUrl
    And path '/api/GetFundCode'
    And sleep(12000)
    And set getFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | updateFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | updateFundCodeResponse.header.id            |
      | correlationId   | updateFundCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | "GetFundCode"                               |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getFundCodeCommandBody
      | path |                                      0 |
      | id   | updateFundCodeResponse.header.entityId |
    And set getFundCodePayload
      | path         | [0]                         |
      | header       | getFundCodeCommandHeader[0] |
      | body.request | getFundCodeCommandBody[0]   |
    And print getFundCodePayload
    And request getFundCodePayload
    When method POST
    Then status 200
    And def getFundCodeAPIResponse = response
    And print getFundCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,fundCodesCollectionNameRead+<tenantid>,getFundCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getFundCodeAPIResponse.id
    And match getFundCodeAPIResponse.fundCode == updateFundCodeResponse.body.fundCode
    #Get All Fund Codes
    Given url readBaseUrl
    And path '/api/GetFundCodes'
    And set getFundCodesCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetFundCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | "GetFundCodes"                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFundCodesCommandBodyRequest
      | path            |    0 |
      | fundCode        | null |
      | longDescription | null |
      | isActive        | null |
      | lastUpdatedDate | null |
    And set getFundCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFundCodesPayload
      | path                | [0]                              |
      | header              | getFundCodesCommandHeader[0]     |
      | body.request        | {}                               |
      | body.paginationSort | getFundCodesCommandPagination[0] |
    And print getFundCodesPayload
    And request getFundCodesPayload
    When method POST
    Then status 200
    And def getFundCodesResponse = response
    And print getFundCodesResponse
    And match getFundCodesResponse.results[*].id contains updateFundCodeResponse.body.id
    And def getFundCodesResponseCount = karate.sizeOf(getFundCodesResponse.results)
    And print getFundCodesResponseCount
    And match getFundCodesResponseCount == getFundCodesResponse.totalRecordCount
    #HistoryValidation
    And def eventName = "FundCodeUpdated"
    And def evnentType = "FundCode"
    And def commandUserid = commandUserId
    And def entityIdData = updateFundCodeResponse.body.id
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "FundCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateFundCodeResponse.body.id
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
    And def evnentType = "FundCode"
    And def entityIdData = updateFundCodeResponse.body.id
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

  @updateFundCodesWithMissingMandatoyDetails
  Scenario Outline: Update a Fund code with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateFundCode'
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodesWithMandatoryFields')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    And def firstName = faker.getFirstName()
    And set updateFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | createFundCodeResponse.header.entityId      |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "UpdateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set updateFundCodeCommandBody
      | path             |                                      0 |
      | id               | createFundCodeResponse.header.entityId |
      | fundCode         | createFundCodeResponse.body.fundCode   |
      | shortDescription | faker.getRandomShortDescription()      |
      | longDescription  | faker.getRandomLongDescription()       |
      | fundType         | faker.getRandomFundType()              |
      | authority        | faker.getLastName()                    |
      | project          | faker.getUserId()                      |
    And set updateFundCodePayload
      | path   | [0]                            |
      | header | updateFundCodeCommandHeader[0] |
      | body   | updateFundCodeCommandBody[0]   |
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFundCodesWithInvalidDataToMandatoyDetails
  Scenario Outline: Update a account code with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/UpdateFundCode'
    #Create a Fund Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodesWithMandatoryFields')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    And def firstName = faker.getFirstName()
    And set updateFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | createFundCodeResponse.header.entityId      |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "UpdateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set updateFundCodeCommandBody
      | path             |                                    0 |
      | id               | faker.getLastName()                  |
      | fundCode         | createFundCodeResponse.body.fundCode |
      | shortDescription | faker.getRandomShortDescription()    |
      | longDescription  | faker.getRandomLongDescription()     |
      | fundType         | faker.getRandomFundType()            |
      | authority        | faker.getLastName()                  |
      | project          | faker.getUserId()                    |
      | activity         | faker.getRandomShortDescription()    |
    And set updateFundCodePayload
      | path   | [0]                            |
      | header | updateFundCodeCommandHeader[0] |
      | body   | updateFundCodeCommandBody[0]   |
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateFundCode
  Scenario Outline: Create a duplicate Fund code
    Given url commandBaseUrl
    And path '/api/CreateFundCode'
    # Creating FundCode to update
    And def result = call read('classpath:com/api/rm/documentAdmin/fundCodes/CreateFundCodes.feature@CreateFundCodes')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    And def entityId = dataGenerator.Id()
    And set createFundCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/CreateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | entityId                                    |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "CreateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set createFundCommandBody
      | path             |                                    0 |
      | id               | entityId                             |
      | fundCode         | createFundCodeResponse.body.fundCode |
      | shortDescription | faker.getRandomShortDescription()    |
      | longDescription  | faker.getRandomLongDescription()     |
      | isActive         | faker.getRandomBoolean()             |
      | fundType         | faker.getRandomFundType()            |
      | fund             | faker.getFirstName()                 |
      | department       | faker.getRandom5DigitNumber()        |
      | authority        | faker.getLastName()                  |
      | project          | faker.getUserId()                    |
      | activity         | faker.getRandomShortDescription()    |
      | account          | faker.getRandom5DigitNumber()        |
    And set createFundPayload
      | path   | [0]                        |
      | header | createFundCommandHeader[0] |
      | body   | createFundCommandBody[0]   |
    And print createFundPayload
    And request createFundPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:FundCode cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFundCodesWithDuplicateEntity
  Scenario Outline: Update a account code with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/UpdateFundCode'
    #Creating Account Code
    And def result = call read('CreateFundCodes.feature@CreateFundCodes')
    And def createFundCodeResponse = result.response
    And print createFundCodeResponse
    #Creating another Account code
    And def result1 = call read('CreateFundCodes.feature@CreateFundCodes')
    And def createFundCodeResponse1 = result1.response
    And print createFundCodeResponse1
    And def firstName = faker.getFirstName()
    And set updateFundCodeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/UpdateFundCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFundCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFundCodeResponse.header.id            |
      | correlationId   | createFundCodeResponse.header.correlationId |
      | entityId        | createFundCodeResponse.header.entityId      |
      | commandUserId   | createFundCodeResponse.header.commandUserId |
      | entityVersion   |                                           2 |
      | tags            | []                                          |
      | commandType     | "UpdateFundCode"                            |
      | entityName      | "FundCode"                                  |
      | ttl             |                                           0 |
    And set updateFundCodeCommandBody
      | path             |                                            0 |
      | id               | createFundCodeResponse.header.entityId       |
      | fundCode         | createFundCodeResponse1.body.fundCode        |
      | shortDescription | createFundCodeResponse.body.shortDescription |
      | longDescription  | faker.getRandomLongDescription()             |
      | isActive         | faker.getRandomBoolean()                     |
      | fundType         | faker.getRandomFundType()                    |
      | fund             | faker.getFirstName()                         |
      | department       | faker.getRandom5DigitNumber()                |
      | authority        | faker.getLastName()                          |
      | project          | faker.getUserId()                            |
      | activity         | faker.getRandomShortDescription()            |
      | account          | faker.getRandom5DigitNumber()                |
    And set updateFundCodePayload
      | path   | [0]                            |
      | header | updateFundCodeCommandHeader[0] |
      | body   | updateFundCodeCommandBody[0]   |
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    And print updateFundCodePayload
    And request updateFundCodePayload
    When method POST
    Then status 500

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @FundCodesBasedOnFlag
  Scenario Outline: Validate the fund codes are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetFundCodesNameDescriptions'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/GetFundCodesNameDescriptions-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | tenantId        | <tenantid>                                            |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | commandUserId   | commandUserId                                         |
      | tags            | []                                                    |
      | commandType     | "GetFundCodesNameDescriptions"                        |
      | getType         | "Array"                                               |
      | ttl             |                                                     0 |
    And set commandBodyRequest
      | path     |     0 |
      | isActive | false |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFundCodesNameDescriptionsPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getFundCodesNameDescriptionsPayload
    And request getFundCodesNameDescriptionsPayload
    When method POST
    Then status 200
    And def getFundCodesNameDescriptionsResponse = response
    And print getFundCodesNameDescriptionsResponse
    And match each getFundCodesNameDescriptionsResponse.results[*].isActive == false

    Examples: 
      | tenantid    |
      | tenantID[0] |
