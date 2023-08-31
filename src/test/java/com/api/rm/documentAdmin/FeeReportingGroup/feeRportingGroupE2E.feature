@FeeReportingGroup
Feature: Fee ReportingGroup - Add , Edit , View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeReportingGroupcollectionname = 'CreateFeeReportingGroup_'
    And def feeReportingGroupCollectionNameRead = 'FeeReportingGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateReportingGroupAndGetTheDetail
  Scenario Outline: Validate Create fee ReportingGroup information with all the fields
    And def result = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse = result.response
    And print addfeeReportingGroupResponse
    And def entityIdData = dataGenerator.entityID()
    #getFeeReportingGrps
    Given url readBaseUrl
    And def result = call read('feeReportingGroup.feature@CreateReportingGroupAndGetTheDetail')
    And def getfeeReportingGroupResponse = result.response
    And print getfeeReportingGroupResponse
    And path '/api/GetFeeReportingGroups'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeReportingGroups-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | getType         | "Array"                                        |
      | commandUserId   | dataGenerator.commandUserId()                  |
      | tags            | []                                             |
      | commandType     | "GetFeeReportingGroups"                        |
      | ttl             |                                              0 |
    And set getCommandBody
      | path                       |                    0 |
      | request.isActive           | true                 |
      | paginationSort.currentPage |                    1 |
      | paginationSort.pageSize    |                 5000 |
      | paginationSort.sortBy      | "reportingGroupCode" |
      | paginationSort.isAscending | true                 |
    And set getFeeReportingGrpsPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getFeeReportingGrpsPayload
    And request getFeeReportingGrpsPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getFeeReportingGroupsAPIResponse = response
    And print getFeeReportingGroupsAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,addfeeReportingGroupResponse.body.id)
    And print mongoResult
    And def getFeeReportingGroupsResponseCount = karate.sizeOf(getFeeReportingGroupsAPIResponse.results)
    And print getFeeReportingGroupsResponseCount
    And match getFeeReportingGroupsResponseCount == getFeeReportingGroupsAPIResponse.totalRecordCount
    And match each getFeeReportingGroupsAPIResponse.results[*].active == true
    #GetFeeReportingGrp
    Given url readBaseUrl
    And path '/api/GetFeeReportingGroup'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetFeeReportingGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addfeeReportingGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addfeeReportingGroupResponse.header.id            |
      | correlationId   | addfeeReportingGroupResponse.header.correlationId |
      | getType         | "One"                                             |
      | commandUserId   | addfeeReportingGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetFeeReportingGroup"                            |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path       |                                    0 |
      | request.id | addfeeReportingGroupResponse.body.id |
    And set getFeeReportingGrpPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getFeeReportingGrpPayload
    And request getFeeReportingGrpPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getFeeReportingGroupAPIResponse = response
    And print getFeeReportingGroupAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,getFeeReportingGroupAPIResponse.id)
    And print mongoResult
    And match mongoResult == getFeeReportingGroupAPIResponse.id
    And match getFeeReportingGroupAPIResponse.id == addfeeReportingGroupResponse.body.id
    And match getFeeReportingGroupAPIResponse.reportingGroupCode == addfeeReportingGroupResponse.body.reportingGroupCode
    #Adding the comment
    And def entityName = "FeeReportingGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addfeeReportingGroupResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "FeeReportingGroup"
    And def entityIdData = addfeeReportingGroupResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "FeeReportingGroupCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,addfeeReportingGroupResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeReportingGroupAPIResponse.id
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

  @CreateFeeReprtingWithoutMandatoryFieldsAndGetTheDetails
  Scenario Outline: Validate a Fee Reporting Group information Without mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateFeeReportingGroup'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "CreateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                        0 |
      | id                 | entityIdData             |
      | reportingGroupCode | faker.getFirstName()     |
      | isActive           | faker.getRandomBoolean() |
    And set addFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print addFeeReportingGrpPayload
    And request addFeeReportingGrpPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateFeeReporting @validateUpdateFeeReprting
  Scenario Outline: Update a Fee Reporting Group and Validate the updated details
    Given url commandBaseUrl
    And path '/api/UpdateFeeReportingGroup'
    And def result = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse = result.response
    And print addfeeReportingGroupResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | addfeeReportingGroupResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                                    0 |
      | id                 | addfeeReportingGroupResponse.body.id |
      | reportingGroupCode | faker.getCity()                      |
      | shortDescription   | faker.getDescription()               |
      | isActive           | faker.getRandomBoolean()             |
    And set updateFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateFeeReportingGrpPayload
    And request updateFeeReportingGrpPayload
    When method POST
    Then status 201
    And def updateFeeReportingGrpAPIResponse = response
    And print updateFeeReportingGrpAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeReportingGroupcollectionname+<tenantid>,addfeeReportingGroupResponse.body.id)
    And print mongoResult
    And match mongoResult == updateFeeReportingGrpAPIResponse.body.id
    And match updateFeeReportingGrpAPIResponse.body.reportingGroupCode == updateFeeReportingGrpPayload.body.reportingGroupCode
    #getFeeReportingGrps
    Given url readBaseUrl
    And def result = call read('feeReportingGroup.feature@CreateReportingGroupAndGetTheDetail')
    And def getfeeReportingGroupResponse = result.response
    And print getfeeReportingGroupResponse
    And path '/api/GetFeeReportingGroups'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeReportingGroups-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | getType         | "Array"                                        |
      | commandUserId   | dataGenerator.commandUserId()                  |
      | tags            | []                                             |
      | commandType     | "GetFeeReportingGroups"                        |
      | ttl             |                                              0 |
    And set getCommandBody
      | path                       |                    0 |
      | request.isActive           | true                 |
      | paginationSort.currentPage |                    1 |
      | paginationSort.pageSize    |                 5000 |
      | paginationSort.sortBy      | "reportingGroupCode" |
      | paginationSort.isAscending | true                 |
    And set getFeeReportingGrpsPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getFeeReportingGrpsPayload
    And request getFeeReportingGrpsPayload
    When method POST
    Then status 200
    And def getFeeReportingGroupsAPIResponse = response
    And print getFeeReportingGroupsAPIResponse
    And match  getFeeReportingGroupsAPIResponse.results[*].reportingGroupCode contains updateFeeReportingGrpAPIResponse.body.reportingGroupCode
    And def getFeeReportingGroupsResponseCount = karate.sizeOf(getFeeReportingGroupsAPIResponse.results)
    And print getFeeReportingGroupsResponseCount
    And match getFeeReportingGroupsResponseCount == getFeeReportingGroupsAPIResponse.totalRecordCount
    And match each getFeeReportingGroupsAPIResponse.results[*].active == true
    #GetFeeReportingGrp
    Given url readBaseUrl
    And path '/api/GetFeeReportingGroup'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetFeeReportingGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addfeeReportingGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addfeeReportingGroupResponse.header.id            |
      | correlationId   | addfeeReportingGroupResponse.header.correlationId |
      | getType         | "One"                                             |
      | commandUserId   | addfeeReportingGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetFeeReportingGroup"                            |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path       |                                    0 |
      | request.id | addfeeReportingGroupResponse.body.id |
    And set getFeeReportingGrpPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getFeeReportingGrpPayload
    And request getFeeReportingGrpPayload
    When method POST
    Then status 200
    And def getFeeReportingGroupAPIResponse = response
    And print getFeeReportingGroupAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,getFeeReportingGroupAPIResponse.id)
    And print mongoResult
    And match mongoResult == getFeeReportingGroupAPIResponse.id
    And match getFeeReportingGroupAPIResponse.id == addfeeReportingGroupResponse.body.id
    #Validating Updated reporting grp code should be fetched with get
    And match getFeeReportingGroupAPIResponse.reportingGroupCode == updateFeeReportingGrpAPIResponse.body.reportingGroupCode
    #Adding the comment
    And def entityName = "FeeReportingGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addfeeReportingGroupResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #Adding the 2nd comment
    And def entityComment = faker.getRandomNumber()
    And def commentSecondResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createSecondCommentResponse = commentSecondResult.response
    And print createSecondCommentResponse
    And match createSecondCommentResponse.body.comment == entityComment
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
    And def evnentType = "FeeReportingGroup"
    And def entityIdData = addfeeReportingGroupResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "FeeReportingGroupUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,addfeeReportingGroupResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeeReportingGroupAPIResponse.id
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

  @updateFeeReportingNegativeCase
  Scenario Outline: validate Update Fee Reporting Group without mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateFeeReportingGroup'
    And def result = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse = result.response
    And print addfeeReportingGroupResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | addfeeReportingGroupResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                                    0 |
      | id                 | addfeeReportingGroupResponse.body.id |
      | reportingGroupCode | firstName                            |
      | isActive           | faker.getRandomBoolean()             |
    And set updateFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateFeeReportingGrpPayload
    And request updateFeeReportingGrpPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @ValidateCreateDuplicateFeeReportGroupCreation
  Scenario Outline: Validate Create Fee reporting group with duplicate ID
    Given url commandBaseUrl
    #Create Fee reporting group code and Update
    And def result = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse = result.response
    And print addfeeReportingGroupResponse
    And path '/api/CreateFeeReportingGroup'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | [  "PII"]                                        |
      | commandType     | "CreateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                                                    0 |
      | id                 | entityIdData                                         |
      | reportingGroupCode | addfeeReportingGroupResponse.body.reportingGroupCode |
      | shortDescription   | faker.getDescription()                               |
      | isActive           | faker.getRandomBoolean()                             |
    And set addFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print addFeeReportingGrpPayload
    And request addFeeReportingGrpPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:FeeReportingGroup cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @ValidateUpdateDuplicateFeeReportGroup
  Scenario Outline: Validate update Fee reporting group with duplicate ID
    Given url commandBaseUrl
    And path '/api/UpdateFeeReportingGroup
    #Create Fee reporting group code and Update
    And def result = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse = result.response
    And print addfeeReportingGroupResponse
    #Creating another Fee reporting group code
    And def result1 = call read('feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def addfeeReportingGroupResponse1 = result1.response
    And print addfeeReportingGroupResponse1
    And def firstName = faker.getFirstName()
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | addfeeReportingGroupResponse.body.id             |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                                                     0 |
      | id                 | addfeeReportingGroupResponse.body.id                  |
      | reportingGroupCode | addfeeReportingGroupResponse1.body.reportingGroupCode |
      | shortDescription   | faker.getDescription()                                |
      | isActive           | faker.getRandomBoolean()                              |
    And set updateFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateFeeReportingGrpPayload
    And request updateFeeReportingGrpPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
