@AccountCodes
Feature: Account Codes, Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def accountCodesCollectionName = 'CreateAccountCode_'
    And def accountCodesCollectionNameRead = 'AccountCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('../../helpers/Wait.feature@wait')

  @CreateAccountCodesWithAllDetails
  Scenario Outline: Create a account code with all the details
    #Create a Account Code
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #  Get the Account code
    Given url readBaseUrl
    And path '/api/GetAccountCode'
    And sleep(12000)
    And set getAccountCodeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetAccountCode"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getAccountCodeCommandBody
      | path |                                         0 |
      | id   | createAccountCodeResponse.header.entityId |
    And set getAccountCodePayload
      | path         | [0]                            |
      | header       | getAccountCodeCommandHeader[0] |
      | body.request | getAccountCodeCommandBody[0]   |
    And print getAccountCodePayload
    And request getAccountCodePayload
    When method POST
    Then status 200
    And def getAccountCodeAPIResponse = response
    And print getAccountCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,accountCodesCollectionNameRead+<tenantid>,getAccountCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getAccountCodeAPIResponse.id
    And match getAccountCodeAPIResponse.budgetAmount == createAccountCodeResponse.body.budgetAmount
    #Get All Account Codes
    Given url readBaseUrl
    And path '/api/GetAccountCodes'
    And set getAccountCodesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetAccountCodes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getAccountCodesCommandBodyRequest
      | path              |      0 |
      | accountCode2      | null   |
      | shortAccountCode2 | "Test" |
      | isActive          | null   |
      | lastUpdatedDate   | null   |
    And set getAccountCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAccountCodesPayload
      | path                | [0]                                  |
      | header              | getAccountCodesCommandHeader[0]      |
      | body.request        | getAccountCodesCommandBodyRequest[0] |
      | body.paginationSort | getAccountCodesCommandPagination[0]  |
    And print getAccountCodesPayload
    And request getAccountCodesPayload
    When method POST
    Then status 200
    And def getAccountCodesResponse = response
    And print getAccountCodesResponse
    And match getAccountCodesResponse.results[*].id contains createAccountCodeResponse.body.id
    And match each getAccountCodesResponse.results[*].shortAccountCode2 contains "Test"
    And def getAccountCodesResponseCount = karate.sizeOf(getAccountCodesResponse.results)
    And print getAccountCodesResponseCount
    And match getAccountCodesResponseCount == getAccountCodesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = createAccountCodeResponse.body.id
    And def eventName = "AccountCodeCreated"
    And def evnentType = "AccountCode"
    And def commandUserid = commandUserId
    And def result = call read('../../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "AccountCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createAccountCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "AccountCode"
    And def viewAllCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAccountCodesWithMandatoryFieldsAndGet
  Scenario Outline: Create a account code with only mandatory details and Validate
    #Create a Account Code With MandatoryFields
    And def result = call read('CreateAccountCode.feature@CreateAccountCodesWithMandatoryFields')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Get the Account code
    Given url readBaseUrl
    And path '/api/GetAccountCode'
    And sleep(12000)
    And set getAccountCodeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetAccountCode"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getAccountCodeCommandBody
      | path |                                         0 |
      | id   | createAccountCodeResponse.header.entityId |
    And set getAccountCodePayload
      | path         | [0]                            |
      | header       | getAccountCodeCommandHeader[0] |
      | body.request | getAccountCodeCommandBody[0]   |
    And print getAccountCodePayload
    And request getAccountCodePayload
    When method POST
    Then status 200
    And def getAccountCodeAPIResponse = response
    And print getAccountCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,accountCodesCollectionNameRead+<tenantid>,getAccountCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getAccountCodeAPIResponse.id
    And match getAccountCodeAPIResponse.shortAccountCode2 == createAccountCodeResponse.body.shortAccountCode2
    #Get All Account Codes
    Given url readBaseUrl
    And path '/api/GetAccountCodes'
    And set getAccountCodesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetAccountCodes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getAccountCodesCommandBodyRequest
      | path              |                                       0 |
      | accountCode2      | null                                    |
      | shortAccountCode2 | null                                    |
      | isActive          | createAccountCodeResponse.body.isActive |
      | lastUpdatedDate   | null                                    |
    And set getAccountCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAccountCodesPayload
      | path                | [0]                                  |
      | header              | getAccountCodesCommandHeader[0]      |
      | body.request        | getAccountCodesCommandBodyRequest[0] |
      | body.paginationSort | getAccountCodesCommandPagination[0]  |
    And print getAccountCodesPayload
    And request getAccountCodesPayload
    When method POST
    Then status 200
    And def getAccountCodesResponse = response
    And print getAccountCodesResponse
    And match getAccountCodesResponse.results[*].id contains createAccountCodeResponse.body.id
    And match each getAccountCodesResponse.results[*].isActive == createAccountCodeResponse.body.isActive
    And def getAccountCodesResponseCount = karate.sizeOf(getAccountCodesResponse.results)
    And print getAccountCodesResponseCount
    And match getAccountCodesResponseCount == getAccountCodesResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = createAccountCodeResponse.body.id
    And def eventName = "AccountCodeCreated"
    And def evnentType = "AccountCode"
    And def commandUserid = commandUserId
    And def result = call read('../../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "AccountCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createAccountCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "AccountCode"
    And def entityIdData = createAccountCodeResponse.body.id
    And def viewAllCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('../.HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('../HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('../HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAccountCodesWithInvalidDataToMandatoryFields
  Scenario Outline: Create a account code with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateAccountCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/CreateAccountCode-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreateAccountCode"                        |
      | entityName      | "AccountCode"                              |
      | ttl             |                                          0 |
    And set commandBody
      | path                 |                             0 |
      | id                   | entityIdData                  |
      | accountCode2         | faker.getFirstName()          |
      | shortAccountCode2    | faker.getUserId()             |
      | isActive             | faker.getRandomBoolean()      |
      | revenueAccount       | faker.getRandomBoolean()      |
      | longDescription      | faker.getLastName()           |
      | alternateDescription | faker.getRandomNumber()       |
      | budgetAmount         | faker.getRandom5DigitNumber() |
    And set commandFundCode
      | path |                       0 |
      | id   | faker.getRandomNumber() |
      | name | faker.getAddressLine()  |
      | code | faker.getCity()         |
    And set createAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print createAccountCodePayload
    And request createAccountCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAccountCodesWithMissingMandatoryFields
  Scenario Outline: Create a account code with missing mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateAccountCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/CreateAccountCode-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreateAccountCode"                        |
      | entityName      | "AccountCode"                              |
      | ttl             |                                          0 |
    And set commandBody
      | path                 |                             0 |
      | id                   | entityIdData                  |
      | accountCode2         | faker.getFirstName()          |
      | isActive             | faker.getRandomBoolean()      |
      | revenueAccount       | faker.getRandomBoolean()      |
      | longDescription      | faker.getLastName()           |
      | alternateDescription | faker.getRandomNumber()       |
      | budgetAmount         | faker.getRandom5DigitNumber() |
    And set commandFundCode
      | path |                       0 |
      | id   | faker.getRandomNumber() |
      | name | faker.getAddressLine()  |
      | code | faker.getCity()         |
    And set createAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print createAccountCodePayload
    And request createAccountCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAccountCodesWithAllFields
  Scenario Outline: Update a account code with all the details
    Given url commandBaseUrl
    And path '/api/UpdateAccountCode'
    #Create a Account Code
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | createAccountCodeResponse.header.entityId      |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path                 |                                         0 |
      | id                   | createAccountCodeResponse.header.entityId |
      | accountCode2         | faker.getFirstName()                      |
      | shortAccountCode2    | faker.getUserId()                         |
      | isActive             | faker.getRandomBoolean()                  |
      | revenueAccount       | faker.getRandomBoolean()                  |
      | longDescription      | faker.getRandomLongDescription()          |
      | alternateDescription | faker.getRandomNumber()                   |
      | budgetAmount         | faker.getRandom5DigitNumber()             |
    And set commandFundCode
      | path |                                            0 |
      | id   | createAccountCodeResponse.body.fundCode.id   |
      | name | createAccountCodeResponse.body.fundCode.name |
      | code | createAccountCodeResponse.body.fundCode.code |
    And set updateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print updateAccountCodePayload
    And request updateAccountCodePayload
    When method POST
    Then status 201
    And def updateAccountCodeResponse = response
    And print updateAccountCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,accountCodesCollectionName+<tenantid>,updateAccountCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAccountCodeResponse.body.id
    And match updateAccountCodeResponse.body.fundCode.name == updateAccountCodePayload.body.fundCode.name
    #Get the Account code
    Given url readBaseUrl
    And path '/api/GetAccountCode'
    And sleep(12000)
    And set getAccountCodeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updateAccountCodeResponse.header.id            |
      | correlationId   | updateAccountCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetAccountCode"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getAccountCodeCommandBody
      | path |                                         0 |
      | id   | updateAccountCodeResponse.header.entityId |
    And set getAccountCodePayload
      | path         | [0]                            |
      | header       | getAccountCodeCommandHeader[0] |
      | body.request | getAccountCodeCommandBody[0]   |
    And print getAccountCodePayload
    And request getAccountCodePayload
    When method POST
    Then status 200
    And def getAccountCodeAPIResponse = response
    And print getAccountCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,accountCodesCollectionNameRead+<tenantid>,getAccountCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getAccountCodeAPIResponse.id
    And match getAccountCodeAPIResponse.shortAccountCode2 == updateAccountCodeResponse.body.shortAccountCode2
    #Get All Account Codes
    Given url readBaseUrl
    And path '/api/GetAccountCodes'
    And set getAccountCodesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updateAccountCodeResponse.header.id            |
      | correlationId   | updateAccountCodeResponse.header.correlationId |
      | commandUserId   | updateAccountCodeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetAccountCodes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getAccountCodesCommandBodyRequest
      | path              |      0 |
      | accountCode2      | "Test" |
      | shortAccountCode2 | null   |
      | isActive          | null   |
      | lastUpdatedDate   | null   |
    And set getAccountCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAccountCodesPayload
      | path                | [0]                                  |
      | header              | getAccountCodesCommandHeader[0]      |
      | body.request        | getAccountCodesCommandBodyRequest[0] |
      | body.paginationSort | getAccountCodesCommandPagination[0]  |
    And print getAccountCodesPayload
    And request getAccountCodesPayload
    When method POST
    Then status 200
    And def getAccountCodesResponse = response
    And print getAccountCodesResponse
    And match getAccountCodesResponse.results[*].id contains createAccountCodeResponse.body.id
    And match each getAccountCodesResponse.results[*].accountCode2 contains "Test"
    And def getAccountCodesResponseCount = karate.sizeOf(getAccountCodesResponse.results)
    And print getAccountCodesResponseCount
    And match getAccountCodesResponseCount == getAccountCodesResponse.totalRecordCount
    #HistoryValidation
    And def eventName = "AccountCodeUpdated"
    And def evnentType = "AccountCode"
    And def commandUserid = commandUserId
    And def entityIdData = updateAccountCodeResponse.body.id
    And def result = call read('../../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "AccountCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateAccountCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "AccountCode"
    And def entityIdData = updateAccountCodeResponse.body.id
    And def viewAllCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Delete The comment
    And def deleteCommentResult = call read('../HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('../HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('../HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAccountCodesWithMandatoryFields
  Scenario Outline: Update a account code with only mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateAccountCode'
    #Create a Account Code With MandatoryFields
    And def result = call read('CreateAccountCode.feature@CreateAccountCodesWithMandatoryFields')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | createAccountCodeResponse.header.entityId      |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path              |                                         0 |
      | id                | createAccountCodeResponse.header.entityId |
      | accountCode2      | faker.getFirstName()                      |
      | shortAccountCode2 | faker.getUserId()                         |
      | longDescription   | faker.getLastName()                       |
    And set commandFundCode
      | path |                                          0 |
      | id   | createAccountCodeResponse.body.fundCode.id |
      | name | faker.getUserId()                          |
      | code | faker.getLastName()                        |
    And set updateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print updateAccountCodePayload
    And request updateAccountCodePayload
    When method POST
    Then status 201
    And def updateAccountCodeResponse = response
    And print updateAccountCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,accountCodesCollectionName+<tenantid>,updateAccountCodeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateAccountCodeResponse.body.id
    And match updateAccountCodeResponse.body.shortAccountCode2 == updateAccountCodePayload.body.shortAccountCode2
    #Get the Account code
    Given url readBaseUrl
    And path '/api/GetAccountCode'
    And sleep(12000)
    And set getAccountCodeCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCode-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updateAccountCodeResponse.header.id            |
      | correlationId   | updateAccountCodeResponse.header.correlationId |
      | commandUserId   | commandUserId                                  |
      | tags            | []                                             |
      | commandType     | "GetAccountCode"                               |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getAccountCodeCommandBody
      | path |                                         0 |
      | id   | updateAccountCodeResponse.header.entityId |
    And set getAccountCodePayload
      | path         | [0]                            |
      | header       | getAccountCodeCommandHeader[0] |
      | body.request | getAccountCodeCommandBody[0]   |
    And print getAccountCodePayload
    And request getAccountCodePayload
    When method POST
    Then status 200
    And def getAccountCodeAPIResponse = response
    And print getAccountCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,accountCodesCollectionNameRead+<tenantid>,getAccountCodeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getAccountCodeAPIResponse.id
    And match getAccountCodeAPIResponse.shortAccountCode2 == updateAccountCodeResponse.body.shortAccountCode2
    And match getAccountCodeAPIResponse.fundCode.code == updateAccountCodeResponse.body.fundCode.code
    #Get All Account Codes
    Given url readBaseUrl
    And path '/api/GetAccountCodes'
    And set getAccountCodesCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetAccountCodes-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | updateAccountCodeResponse.header.id            |
      | correlationId   | updateAccountCodeResponse.header.correlationId |
      | commandUserId   | updateAccountCodeResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetAccountCodes"                              |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getAccountCodesCommandBodyRequest
      | path              |    0 |
      | accountCode2      | null |
      | shortAccountCode2 | null |
      | isActive          | null |
      | lastUpdatedDate   | null |
    And set getAccountCodesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAccountCodesPayload
      | path                | [0]                                 |
      | header              | getAccountCodesCommandHeader[0]     |
      | body.request        | {}                                  |
      | body.paginationSort | getAccountCodesCommandPagination[0] |
    And print getAccountCodesPayload
    And request getAccountCodesPayload
    When method POST
    Then status 200
    And def getAccountCodesResponse = response
    And print getAccountCodesResponse
    And match getAccountCodesResponse.results[*].id contains createAccountCodeResponse.body.id
    And def getAccountCodesResponseCount = karate.sizeOf(getAccountCodesResponse.results)
    And print getAccountCodesResponseCount
    And match getAccountCodesResponseCount == getAccountCodesResponse.totalRecordCount
    #Adding the comments
    And def entityName = "AccountCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createAccountCodeResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #view the comments
    And def viewCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = "AccountCode"
    And def entityIdData = createAccountCodeResponse.body.id
    And def viewAllCommentResult = call read('../../countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #HistoryValidation
    And def eventName = "AccountCodeUpdated"
    And def evnentType = "AccountCode"
    And def commandUserid = commandUserId
    And def result = call read('../../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Delete The comment
    And def deleteCommentResult = call read('../HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('../HistoryComments/Comments.feature@ValidateDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('../HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAccountCodesWithMissingMandatoyDetails
  Scenario Outline: Update a account code with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateAccountCode'
    #Creating AccountCode to update
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | createAccountCodeResponse.header.entityId      |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path                 |                                         0 |
      | id                   | createAccountCodeResponse.header.entityId |
      | shortAccountCode2    | faker.getUserId()                         |
      | isActive             | faker.getRandomBoolean()                  |
      | revenueAccount       | faker.getRandomBoolean()                  |
      | longDescription      | faker.getLastName()                       |
      | alternateDescription | faker.getRandomNumber()                   |
      | budgetAmount         | faker.getRandom5DigitNumber()             |
    And set commandFundCode
      | path |                                            0 |
      | id   | createAccountCodeResponse.body.fundCode.id   |
      | name | createAccountCodeResponse.body.fundCode.name |
      | code | createAccountCodeResponse.body.fundCode.code |
    And set updateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print updateAccountCodePayload
    And request updateAccountCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAccountCodesWithInvalidDataToMandatoyDetails
  Scenario Outline: Update a account code with Invalid Data to Mandatory Fields
    Given url commandBaseUrl
    And path '/api/UpdateAccountCode'
    #Creating AccountCode to update
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | createAccountCodeResponse.header.entityId      |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path                 |                                         0 |
      | id                   | createAccountCodeResponse.header.entityId |
      | accountCode2         | faker.getFirstName()                      |
      | shortAccountCode2    | faker.getUserId()                         |
      | isActive             | faker.getRandomBoolean()                  |
      | revenueAccount       | faker.getRandomBoolean()                  |
      | longDescription      | faker.getLastName()                       |
      | alternateDescription | faker.getRandomNumber()                   |
      | budgetAmount         | faker.getLastName()                       |
    And set commandFundCode
      | path |                                            0 |
      | id   | createAccountCodeResponse.body.fundCode.id   |
      | name | createAccountCodeResponse.body.fundCode.name |
      | code | createAccountCodeResponse.body.fundCode.code |
    And set updateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print updateAccountCodePayload
    And request updateAccountCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateAccountCode
  Scenario Outline: Create a duplicate account code
    Given url commandBaseUrl
    And path '/api/CreateAccountCode'
    #Creating AccountCode to update
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And def entityId = dataGenerator.Id()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | entityId                                       |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "CreateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path                 |                                           0 |
      | id                   | entityId                                    |
      | accountCode2         | createAccountCodeResponse.body.accountCode2 |
      | shortAccountCode2    | faker.getUserId()                           |
      | isActive             | faker.getRandomBoolean()                    |
      | revenueAccount       | faker.getRandomBoolean()                    |
      | longDescription      | faker.getLastName()                         |
      | alternateDescription | faker.getRandomNumber()                     |
    And set commandFundCode
      | path |                                            0 |
      | id   | createAccountCodeResponse.body.fundCode.id   |
      | name | createAccountCodeResponse.body.fundCode.name |
      | code | createAccountCodeResponse.body.fundCode.code |
    And set duplicateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print duplicateAccountCodePayload
    And request duplicateAccountCodePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:AccountCode cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateAccountCodesWithDuplicateEntity
  Scenario Outline: Update a account code with duplicate account code
    Given url commandBaseUrl
    And path '/api/UpdateAccountCode'
    #Creating Account Code
    And def result = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Creating another Account code
    And def result1 = call read('CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse1 = result1.response
    And print createAccountCodeResponse1
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateAccountCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | createAccountCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | createAccountCodeResponse.header.id            |
      | correlationId   | createAccountCodeResponse.header.correlationId |
      | entityId        | createAccountCodeResponse.header.entityId      |
      | commandUserId   | createAccountCodeResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateAccountCode"                            |
      | entityName      | "AccountCode"                                  |
      | ttl             |                                              0 |
    And set commandBody
      | path                 |                                            0 |
      | id                   | createAccountCodeResponse.header.entityId    |
      | accountCode2         | createAccountCodeResponse1.body.accountCode2 |
      | shortAccountCode2    | faker.getUserId()                            |
      | isActive             | faker.getRandomBoolean()                     |
      | revenueAccount       | faker.getRandomBoolean()                     |
      | longDescription      | faker.getLastName()                          |
      | alternateDescription | faker.getRandomNumber()                      |
      | budgetAmount         | faker.getRandom5DigitNumber()                |
    And set commandFundCode
      | path |                                            0 |
      | id   | createAccountCodeResponse.body.fundCode.id   |
      | name | createAccountCodeResponse.body.fundCode.name |
      | code | createAccountCodeResponse.body.fundCode.code |
    And set updateAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print updateAccountCodePayload
    And request updateAccountCodePayload
    When method POST
    Then status 500

    Examples: 
      | tenantid    |
      | tenantID[0] |
