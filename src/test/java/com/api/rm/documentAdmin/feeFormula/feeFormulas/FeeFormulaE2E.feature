@CreateFeeFormulasE2E
Feature: Fee Formulas, Update, Get and Get All

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatFeeFormulaCollectionName = 'CreateFeeFormula_'
    And def createFeeFormulaCollectionNameRead = 'FeeFormulaDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def feeFormulaParams = ["CreateFeeFormula" , "FeeFormula" ,"GetFeeFormula","GetFeeFormulas","UpdateFeeFormula"]
		And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
		
  @CreateFeeFormulaWithGet
  Scenario Outline: Create a Fee formula with all details and Get
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[2]
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    And set getFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[2]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
      | getType         | "One"                                            |
    And set getFeeFormulaCommandBody
      | path |                              0 |
      | id   | createFeeFormulaResult.body.id |
    And set getFeeFormulaPayload
      | path         | [0]                           |
      | header       | getFeeFormulaCommandHeader[0] |
      | body.request | getFeeFormulaCommandBody[0]   |
    And print getFeeFormulaPayload
    And request getFeeFormulaPayload
    When method POST
    Then status 200
    And sleep(15000)
    And print response
    And def getFeeFormulaResponse = response
    And print getFeeFormulaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeFormulaCollectionNameRead+<tenantid>,getFeeFormulaResponse.id)
    And print mongoResult
    And match mongoResult == getFeeFormulaResponse.id
    And match getFeeFormulaResponse.feeFormulaName == createFeeFormulaResult.body.feeFormulaName
    #Get All Fee Formulas
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[3]
    And set getFeeFormulasCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | commandUserId   | createFeeFormulaResult.header.commandUserId      |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[3]                              |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getFeeFormulasCommandBodyRequest
      | path           |         0 |
      | feeFormulaName | "Formula" |
    And set getFeeFormulasCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeFormulasPayload
      | path                | [0]                                 |
      | header              | getFeeFormulasCommandHeader[0]      |
      | body.request        | getFeeFormulasCommandBodyRequest[0] |
      | body.paginationSort | getFeeFormulasCommandPagination[0]  |
    And print getFeeFormulasPayload
    And request getFeeFormulasPayload
    When method POST
    Then status 200
    And sleep(10000)
    And def getFeeFormulasResponse = response
    And print getFeeFormulasResponse
    And match getFeeFormulasResponse.results[*].id contains createFeeFormulaResult.body.id
    And match each getFeeFormulasResponse.results[*].feeFormulaName contains "Formula"
    And def getFeeFormulasResponseCount = karate.sizeOf(getFeeFormulasResponse.results)
    And print getFeeFormulasResponseCount
    And match getFeeFormulasResponseCount == getFeeFormulasResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeFormulaResponse.id
    And def parentEntityId = null
    And def eventName = "FeeFormulaCreated"
    And def evnentType = "FeeFormula"
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
    #Adding the comments
    And def entityName = "FeeFormula"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getFeeFormulaResponse.id
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
    And def evnentType = "FeeFormula"
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

  @CreateFeeFormulaWithMissingMandatoryFields
  Scenario Outline: Create a Fee Formula with Missing Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateFeeFormula'
    And def entityIdData = dataGenerator.entityID()
    And set createFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[0]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set createFeeFormulaCommandBody
      | path               |                                 0 |
      | id                 | entityIdData                      |
      | formulaDescription | faker.getRandomShortDescription() |
      | feeFormula         | faker.getFirstName()              |
      | isActive           | faker.getRandomBoolean()          |
    And set createFeeFormulaPayload
      | path   | [0]                              |
      | header | createFeeFormulaCommandHeader[0] |
      | body   | createFeeFormulaCommandBody[0]   |
    And print createFeeFormulaPayload
    And request createFeeFormulaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeFormulaWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Fee Formula with InvalidData Mandatory Fields
    Given url commandBaseUrl
    And path '/api/CreateFeeFormula'
    And def entityIdData = dataGenerator.entityID()
    And set createFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[0]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set createFeeFormulaCommandBody
      | path               |                                 0 |
      | id                 | faker.getFormulaName()            |
      | feeFormulaName     | faker.getFormulaName()            |
      | formulaDescription | faker.getRandomShortDescription() |
      | feeFormula         | faker.getFirstName()              |
      | isActive           | faker.getRandomBoolean()          |
    And set createFeeFormulaPayload
      | path   | [0]                              |
      | header | createFeeFormulaCommandHeader[0] |
      | body   | createFeeFormulaCommandBody[0]   |
    And print createFeeFormulaPayload
    And request createFeeFormulaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeFormulaWithGet
  Scenario Outline: Update a Fee formula with all details and Get
    Given url commandBaseUrl
    And path '/api/'+feeFormulaParams[4]
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    #UpdateFeeFormula
    And set updateFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | entityId        | createFeeFormulaResult.header.entityId           |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[4]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set updateFeeFormulaCommandBody
      | path               |                                      0 |
      | id                 | createFeeFormulaResult.header.entityId |
      | feeFormulaName     | faker.getFormulaName()                 |
      | formulaDescription | faker.getRandomShortDescription()      |
      | feeFormula         | createFeeFormulaResult.body.feeFormula |
      | isActive           | faker.getRandomBooleanValue()          |
    And set updateFeeFormulaPayload
      | path   | [0]                              |
      | header | updateFeeFormulaCommandHeader[0] |
      | body   | updateFeeFormulaCommandBody[0]   |
    And print updateFeeFormulaPayload
    And request updateFeeFormulaPayload
    When method POST
    Then status 201
    And print response
    And def updateFeeFormulaResponse = response
    And print updateFeeFormulaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatFeeFormulaCollectionName+<tenantid>,createFeeFormulaResult.header.entityId)
    And print mongoResult
    And match mongoResult == updateFeeFormulaResponse.body.id
    And match updateFeeFormulaResponse.body.feeFormula == updateFeeFormulaPayload.body.feeFormula
    #GetFeeFormula
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[2]
    And set getFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[2]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
      | getType         | "One"                                            |
    And set getFeeFormulaCommandBody
      | path |                                0 |
      | id   | updateFeeFormulaResponse.body.id |
    And set getFeeFormulaPayload
      | path         | [0]                           |
      | header       | getFeeFormulaCommandHeader[0] |
      | body.request | getFeeFormulaCommandBody[0]   |
    And print getFeeFormulaPayload
    And request getFeeFormulaPayload
    When method POST
    Then status 200
    And sleep(15000)
    And print response
    And def getFeeFormulaResponse = response
    And print getFeeFormulaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeFormulaCollectionNameRead+<tenantid>,getFeeFormulaResponse.id)
    And print mongoResult
    And match mongoResult == getFeeFormulaResponse.id
    And match getFeeFormulaResponse.feeFormulaName == updateFeeFormulaResponse.body.feeFormulaName
    #Get All Fee Formulas
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[3]
    And set getFeeFormulasCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | commandUserId   | createFeeFormulaResult.header.commandUserId      |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[3]                              |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getFeeFormulasCommanBodyRequest
      | path     |                                      0 |
      | isActive | updateFeeFormulaResponse.body.isActive |
    And set getFeeFormulasCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeFormulasPayload
      | path                | [0]                                |
      | header              | getFeeFormulasCommandHeader[0]     |
      | body.request        | getFeeFormulasCommanBodyRequest[0] |
      | body.paginationSort | getFeeFormulasCommandPagination[0] |
    And print getFeeFormulasPayload
    And request getFeeFormulasPayload
    When method POST
    Then status 200
    And sleep(10000)
    And def getFeeFormulasResponse = response
    And print getFeeFormulasResponse
    And match getFeeFormulasResponse.results[*].id contains updateFeeFormulaResponse.body.id
    And match each getFeeFormulasResponse.results[*].isActive == updateFeeFormulaResponse.body.isActive
    And def getFeeFormulasResultCount = karate.sizeOf(getFeeFormulasResponse.results)
    And print getFeeFormulasResponse
    And match getFeeFormulasResultCount == getFeeFormulasResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = getFeeFormulaResponse.id
    And def parentEntityId = null
    And def eventName = "FeeFormulaUpdated"
    And def evnentType = "FeeFormula"
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
    And def entityName = "FeeFormula"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getFeeFormulaResponse.id
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
    And def evnentType = "FeeFormula"
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

  @UpdateFeeFormulaWithMissingMandatoryFields
  Scenario Outline: Update a Fee formula with Missing Mandatory fields
    Given url commandBaseUrl
    And path '/api/'+feeFormulaParams[4]
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    #UpdateFeeFormula
    And set updateFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | entityId        | createFeeFormulaResult.header.entityId           |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[4]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set updateFeeFormulaCommandBody
      | path           |                                      0 |
      | id             | createFeeFormulaResult.header.entityId |
      | feeFormulaName | faker.getFormulaName()                 |
      | feeFormula     | createFeeFormulaResult.body.feeFormula |
      | isActive       | faker.getRandomBooleanValue()          |
    And set updateFeeFormulaPayload
      | path   | [0]                              |
      | header | updateFeeFormulaCommandHeader[0] |
      | body   | updateFeeFormulaCommandBody[0]   |
    And print updateFeeFormulaPayload
    And request updateFeeFormulaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeFormulaWithInvalidDataMandatoryFields
  Scenario Outline: Update a Fee formula with Invalid Data to Mandatory fields
    Given url commandBaseUrl
    And path '/api/'+feeFormulaParams[4]
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    #UpdateFeeFormula
    And set updateFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | entityId        | createFeeFormulaResult.header.entityId           |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[4]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set updateFeeFormulaCommandBody
      | path               |                                      0 |
      | id                 | faker.getFormulaName()                 |
      | feeFormulaName     | faker.getFormulaName()                 |
      | formulaDescription | faker.getRandomShortDescription()      |
      | feeFormula         | createFeeFormulaResult.body.feeFormula |
      | isActive           | faker.getRandomBooleanValue()          |
    And set updateFeeFormulaPayload
      | path   | [0]                              |
      | header | updateFeeFormulaCommandHeader[0] |
      | body   | updateFeeFormulaCommandBody[0]   |
    And print updateFeeFormulaPayload
    And request updateFeeFormulaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateFeeFormulaWithDuplicateFormula
  Scenario Outline: Update a Fee formula with duplicate formula id
    Given url commandBaseUrl
    And path '/api/'+feeFormulaParams[4]
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    #CreateFeeFormula
    And def createFeeFormulaResponseResult1 = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult1 = createFeeFormulaResponseResult1.response
    And print createFeeFormulaResult1
    #UpdateFeeFormula
    And set updateFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | createFeeFormulaResult.header.sourceId           |
      | tenantId        | <tenantid>                                       |
      | id              | createFeeFormulaResult.header.id                 |
      | correlationId   | createFeeFormulaResult.header.correlationId      |
      | entityId        | createFeeFormulaResult.header.entityId           |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[4]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set updateFeeFormulaCommandBody
      | path               |                                           0 |
      | id                 | createFeeFormulaResult.body.id              |
      | feeFormulaName     | createFeeFormulaResult1.body.feeFormulaName |
      | formulaDescription | faker.getRandomShortDescription()           |
      | feeFormula         | createFeeFormulaResult.body.feeFormula      |
      | isActive           | faker.getRandomBooleanValue()               |
    And set updateFeeFormulaPayload
      | path   | [0]                              |
      | header | updateFeeFormulaCommandHeader[0] |
      | body   | updateFeeFormulaCommandBody[0]   |
    And print updateFeeFormulaPayload
    And request updateFeeFormulaPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeFormulaWithDuplicateFormulaName
  Scenario Outline: Create a Fee Formula with duplicate formula name
    Given url commandBaseUrl
    And path '/api/CreateFeeFormula'
    #CreateFeeFormula
    And def createFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@CreateFeeFormula')
    And def createFeeFormulaResult = createFeeFormulaResponseResult.response
    And print createFeeFormulaResult
    And def formulaEntityId = createFeeFormulaResult.body.id
    #GetFeeFormula
    And def getFeeFormulaResponseResult = call read('classpath:com/api/rm/documentAdmin/feeFormula/feeFormulas/CreateFormula.feature@getFormula'){formulaEntityId:'#(formulaEntityId)'}
    And def getFeeFormulaResult = getFeeFormulaResponseResult.response
    And print getFeeFormulaResult
    And def entityIdData = dataGenerator.entityID()
    And set createFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[0]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set createFeeFormulaCommandBody
      | path               |                                          0 |
      | id                 | entityIdData                               |
      | feeFormulaName     | getFeeFormulaResult.feeFormulaName |
      | formulaDescription | faker.getRandomShortDescription()          |
      | feeFormula         | faker.getFirstName()                       |
      | isActive           | faker.getRandomBoolean()                   |
    And set createFeeFormulaPayload
      | path   | [0]                              |
      | header | createFeeFormulaCommandHeader[0] |
      | body   | createFeeFormulaCommandBody[0]   |
    And print createFeeFormulaPayload
    And request createFeeFormulaPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:FeeFormula cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |
