@CountyDepartments
Feature: County Departments - Add , Edit , View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyDepartmentCollectionName = 'CreateCountyDepartment_'
    And def countyDepartmentCollectionNameRead = 'CountyDepartmentDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyDepartmentAndGetDetails
  Scenario Outline: Create a county department information with all the fields and Validate
    #Create and Get the Department
    Given url readBaseUrl
    And path '/api/GetCountyDepartment'
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    And sleep(10000)
    And set getCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartment-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartment"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | addCountyDepartmentResponse.header.entityId |
    And set getCountyDepartmentPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyDepartmentPayload
    And request getCountyDepartmentPayload
    When method POST
    Then status 200
    And def getCountyDepartmentAPIResponse = response
    And print getCountyDepartmentAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyDepartmentCollectionNameRead+<tenantid>,getCountyDepartmentAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyDepartmentAPIResponse.id
    And match getCountyDepartmentAPIResponse.name == addCountyDepartmentResponse.body.name
    And match getCountyDepartmentAPIResponse.locations[1].name == addCountyDepartmentResponse.body.locations[1].name
    #Adding the comment
    And def entityName = "CountyDepartment"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCountyDepartmentAPIResponse.id
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
    And def evnentType = "CountyDepartment"
    And def entityIdData = getCountyDepartmentAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Get the County Departments
    Given url readBaseUrl
    And path '/api/GetCountyDepartments'
    And sleep(8000)
    And set getDepartmentsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartments-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartments"                           |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDepatmentsCommandBodyRequest
      | path     |                                         0 |
      | isActive | addCountyDepartmentResponse.body.isActive |
    And set getDepatmentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyDepartmentsPayload
      | path                | [0]                                |
      | header              | getDepartmentsCommandHeader[0]     |
      | body.request        | getDepatmentsCommandBodyRequest[0] |
      | body.paginationSort | getDepatmentsCommandPagination[0]  |
    And print getCountyDepartmentsPayload
    And request getCountyDepartmentsPayload
    When method POST
    Then status 200
    And def getCountyDepartmentsResponse = response
    And print getCountyDepartmentsResponse
    And match getCountyDepartmentsResponse.results[*].id contains addCountyDepartmentResponse.body.id
    And match each getCountyDepartmentsResponse.results[*].isActive == addCountyDepartmentResponse.body.isActive
    And def getCountyDepartmentsResponseCount = karate.sizeOf(getCountyDepartmentsResponse.results)
    And print getCountyDepartmentsResponseCount
    And match getCountyDepartmentsResponseCount == getCountyDepartmentsResponse.totalRecordCount
    # History Validation
    And def eventName = "CountyDepartmentCreated"
    And def evnentType = "Departments"
    And def entityIdData = getCountyDepartmentAPIResponse.id
    And def parentEntityId = getCountyDepartmentAPIResponse.id
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
    And def evnentType = "CountyDepartment"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyDepartmentWithMandatoryDetailsAndGetDetails
  Scenario Outline: Create a county department information with only mandatory fields and Validate
    #Get the Created Department
    Given url readBaseUrl
    And path '/api/GetCountyDepartment'
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartmentWithMandatoryFields')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    And sleep(10000)
    And set getCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartment-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartment"                            |
      | getType         | "One"                                            |
      | ttl             |                                                0 |
    And set getCommandBody
      | path |                                           0 |
      | id   | addCountyDepartmentResponse.header.entityId |
    And set getCountyDepartmentPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyDepartmentPayload
    And request getCountyDepartmentPayload
    When method POST
    Then status 200
    And def getCountyDepartmentAPIResponse = response
    And print getCountyDepartmentAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyDepartmentCollectionNameRead+<tenantid>,getCountyDepartmentAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyDepartmentAPIResponse.id
    And match getCountyDepartmentAPIResponse.name == addCountyDepartmentResponse.body.name
    # Get the County Departments
    Given url readBaseUrl
    And path '/api/GetCountyDepartments'
    And sleep(8000)
    And set getDepartmentsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartments-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartments"                           |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDepatmentsCommandBodyRequest
      | path           |      0 |
      | code           | null   |
      | name           | null   |
      | officialsTitle | "Test" |
      | glCode         | null   |
      | isActive       | null   |
    And set getDepatmentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyDepartmentsPayload
      | path                | [0]                                |
      | header              | getDepartmentsCommandHeader[0]     |
      | body.request        | getDepatmentsCommandBodyRequest[0] |
      | body.paginationSort | getDepatmentsCommandPagination[0]  |
    And print getCountyDepartmentsPayload
    And request getCountyDepartmentsPayload
    When method POST
    Then status 200
    And def getCountyDepartmentsResponse = response
    And print getCountyDepartmentsResponse
    And match getCountyDepartmentsResponse.results[*].id contains addCountyDepartmentResponse.body.id
    And match each getCountyDepartmentsResponse.results[*].officialsTitle contains "Test"
    And def getCountyDepartmentsResponseCount = karate.sizeOf(getCountyDepartmentsResponse.results)
    And print getCountyDepartmentsResponseCount
    And match getCountyDepartmentsResponseCount == getCountyDepartmentsResponse.totalRecordCount
    #Adding the comments
    And def entityName = "CountyDepartment"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCountyDepartmentAPIResponse.id
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
    And def evnentType = "CountyDepartment"
    And def entityIdData = getCountyDepartmentAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #History Validation
    And def eventName = "CountyDepartmentCreated"
    And def evnentType = "Departments"
    And def entityIdData = getCountyDepartmentAPIResponse.id
    And def parentEntityId = getCountyDepartmentAPIResponse.id
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
    And def evnentType = "CountyDepartment"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyDepartmentWithInvalidDataMandatoryDetails
  Scenario Outline: Create a county department information with invalid data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def result = call read('classpath:com/api/rm/countyAdmin/Location/CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                        0 |
      | id             | entityIdData             |
      | name           | firstname                |
      | code           | faker.getUserId()        |
      | officialsName  | faker.getFirstName()     |
      | officialsTitle | faker.getLastName()      |
      | isActive       | faker.getRandomBoolean() |
    And set commandLocations
      | path |                                   0 |
      | id   | faker.getUserId()                   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set addCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyDepartmentWithMissingMandatoryDetails
  Scenario Outline: Create a county department information with missing mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                        0 |
      | id             | entityIdData             |
      | name           | firstname                |
      | code           | faker.getUserId()        |
      | officialsName  | faker.getFirstName()     |
      | officialsTitle | faker.getLastName()      |
      | isActive       | faker.getRandomBoolean() |
    And set addCountyDepartmentPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

    @CreateCountyDepartmentWithDuplicate
  Scenario Outline: Create a county department information with the duplicate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def entityIdData = dataGenerator.entityID()
    #CreatingDepartment
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                                     0 |
      | id             | entityIdData                          |
      | name           | faker.getFirstName()                  |
      | code           | addCountyDepartmentResponse.body.code |
      | officialsName  | faker.getFirstName()                  |
      | officialsTitle | faker.getLastName()                   |
      | isActive       | faker.getRandomBoolean()              |
    And set commandLocations
      | path |                                                  0 |
      | id   | addCountyDepartmentResponse.body.locations[0].id   |
      | name | addCountyDepartmentResponse.body.locations[0].name |
      | code | addCountyDepartmentResponse.body.locations[0].code |
    And set addCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CountyDepartment cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDepartmentInformationWithAllDetailsAndGetDetails
  Scenario Outline: Update a County Department with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCountyDepartment'
    #Creating Depatment to update
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #GetAccountCodesToUpdate
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentCodes/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #Creating another county location and adding to existing department
    And def countyLocationResult = call read('classpath:com/api/rm/countyAdmin/Location/CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = countyLocationResult.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCountyDepartment-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | entityId        | addCountyDepartmentResponse.header.entityId      |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateCountyDepartment"                         |
      | entityName      | "CountyDepartment"                               |
      | ttl             |                                                0 |
    And set commandBody
      | path           |                                           0 |
      | id             | addCountyDepartmentResponse.header.entityId |
      | name           | firstName                                   |
      | code           | faker.getUserId()                           |
      | officialsName  | faker.getFirstName()                        |
      | officialsTitle | faker.getLastName()                         |
      | isActive       | faker.getRandomBoolean()                    |
    And set commandGlCode
      | path |                                                      0 |
      | id   | createCountyAccountCodeResponse.body.id                |
      | name | createCountyAccountCodeResponse.body.shortAccountCode2 |
      | code | createCountyAccountCodeResponse.body.accountCode2      |
    And set commandLocations
      | path |                                   0 |
      | id   | addCountyLocationResponse.body.id   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set commandLocations
      | path |                                                  1 |
      | id   | addCountyDepartmentResponse.body.locations[0].id   |
      | name | addCountyDepartmentResponse.body.locations[0].name |
      | code | addCountyDepartmentResponse.body.locations[0].code |
    And set updateCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
      | body.glCode    | commandGlCode[0] |
    And print updateCountyDepartmentPayload
    And request updateCountyDepartmentPayload
    When method POST
    Then status 201
    And def updateCountyDepartmentResponse = response
    And print updateCountyDepartmentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyDepartmentCollectionName+<tenantid>,addCountyDepartmentResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCountyDepartmentResponse.body.id
    And match updateCountyDepartmentResponse.body.name == firstName
    And match updateCountyDepartmentResponse.body.locations[0].name == addCountyLocationResponse.body.name
    And match updateCountyDepartmentResponse.body.locations[1].name == addCountyDepartmentResponse.body.locations[0].name
    And match updateCountyDepartmentResponse.body.glCode.name == createCountyAccountCodeResponse.body.shortAccountCode2
    #Adding the comments
    And def entityName = "CountyDepartment"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateCountyDepartmentResponse.body.id
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
    And def evnentType = "CountyDepartment"
    And def entityIdData = updateCountyDepartmentResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #History Validations
    And def eventName = "CountyDepartmentUpdated"
    And def evnentType = "Departments"
    And def entityIdData = updateCountyDepartmentResponse.body.id
    And def parentEntityId = getCountyDepartmentAPIResponse.id
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
    #Get the County Department
    Given url readBaseUrl
    And path '/api/GetCountyDepartment'
    And sleep(12000)
    And set getCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetCountyDepartment-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | updateCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | updateCountyDepartmentResponse.header.id            |
      | correlationId   | updateCountyDepartmentResponse.header.correlationId |
      | commandUserId   | updateCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                                  |
      | commandType     | "GetCountyDepartment"                               |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getCommandBody
      | path |                                              0 |
      | id   | updateCountyDepartmentResponse.header.entityId |
    And set getCountyDepartmentPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyDepartmentPayload
    And request getCountyDepartmentPayload
    When method POST
    Then status 200
    And def getCountyDepartmentAPIResponse = response
    And print getCountyDepartmentAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyDepartmentCollectionNameRead+<tenantid>,getCountyDepartmentAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyDepartmentAPIResponse.id
    And match getCountyDepartmentAPIResponse.name == updateCountyDepartmentResponse.body.name
    #Get the County Departments
    Given url readBaseUrl
    And path '/api/GetCountyDepartments'
    And sleep(8000)
    And set getDepartmentsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartments-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartments"                           |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDepatmentsCommandBodyRequest
      | path           |      0 |
      | code           | null   |
      | name           | null   |
      | officialsTitle | null   |
      | glCode         | "Test" |
      | isActive       | null   |
    And set getDepatmentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyDepartmentsPayload
      | path                | [0]                                |
      | header              | getDepartmentsCommandHeader[0]     |
      | body.request        | getDepatmentsCommandBodyRequest[0] |
      | body.paginationSort | getDepatmentsCommandPagination[0]  |
    And print getCountyDepartmentsPayload
    And request getCountyDepartmentsPayload
    When method POST
    Then status 200
    And def getCountyDepartmentsResponse = response
    And print getCountyDepartmentsResponse
    And match getCountyDepartmentsResponse.results[*].id contains addCountyDepartmentResponse.body.id
    And match each getCountyDepartmentsResponse.results[*].glCode.code contains "Test"
    And def getCountyDepartmentsResponseCount = karate.sizeOf(getCountyDepartmentsResponse.results)
    And print getCountyDepartmentsResponseCount
    And match getCountyDepartmentsResponseCount == getCountyDepartmentsResponse.totalRecordCount
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
    And def evnentType = "CountyDepartment"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDepartmentInformationWithOnlyMandatoryFields
  Scenario Outline: Update a County Department with mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCountyDepartment'
    #Creating Depatment to update
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartmentWithMandatoryFields')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Creating another county location and replacing old location
    And def countyLocationResult = call read('classpath:com/api/rm/countyAdmin/Location/CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = countyLocationResult.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCountyDepartment-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | entityId        | addCountyDepartmentResponse.header.entityId      |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateCountyDepartment"                         |
      | entityName      | "CountyDepartment"                               |
      | ttl             |                                                0 |
    And set commandBody
      | path           |                                           0 |
      | id             | addCountyDepartmentResponse.header.entityId |
      | name           | firstName                                   |
      | code           | faker.getUserId()                           |
      | officialsName  | faker.getFirstName()                        |
      | officialsTitle | faker.getLastName()                         |
      | isActive       | faker.getRandomBoolean()                    |
    And set commandLocations
      | path |                                   0 |
      | id   | addCountyLocationResponse.body.id   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set commandLocations
      | path |                                                  1 |
      | id   | addCountyDepartmentResponse.body.locations[0].id   |
      | name | addCountyDepartmentResponse.body.locations[0].name |
      | code | addCountyDepartmentResponse.body.locations[0].code |
    And set updateCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print updateCountyDepartmentPayload
    And request updateCountyDepartmentPayload
    When method POST
    Then status 201
    And def updateCountyDepartmentResponse = response
    And print updateCountyDepartmentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyDepartmentCollectionName+<tenantid>,addCountyDepartmentResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateCountyDepartmentResponse.body.id
    And match updateCountyDepartmentResponse.body.name == firstName
    And match updateCountyDepartmentResponse.body.locations[0].name == addCountyLocationResponse.body.name
    #History Validations
    And def eventName = "CountyDepartmentUpdated"
    And def evnentType = "Departments"
    And def entityIdData = updateCountyDepartmentResponse.body.id
    And def parentEntityId = updateCountyDepartmentResponse.body.id
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
    And def entityName = "CountyDepartment"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateCountyDepartmentResponse.body.id
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
    And def evnentType = "CountyDepartment"
    And def entityIdData = updateCountyDepartmentResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount
    #Get the County Department
    Given url readBaseUrl
    And path '/api/GetCountyDepartment'
    And sleep(12000)
    And set getCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetCountyDepartment-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | updateCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | updateCountyDepartmentResponse.header.id            |
      | correlationId   | updateCountyDepartmentResponse.header.correlationId |
      | commandUserId   | updateCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                                  |
      | commandType     | "GetCountyDepartment"                               |
      | getType         | "One"                                               |
      | ttl             |                                                   0 |
    And set getCommandBody
      | path |                                              0 |
      | id   | updateCountyDepartmentResponse.header.entityId |
    And set getCountyDepartmentPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyDepartmentPayload
    And request getCountyDepartmentPayload
    When method POST
    Then status 200
    And def getCountyDepartmentAPIResponse = response
    And print getCountyDepartmentAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyDepartmentCollectionNameRead+<tenantid>,getCountyDepartmentAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyDepartmentAPIResponse.id
    And match getCountyDepartmentAPIResponse.name == updateCountyDepartmentResponse.body.name
    #Get the County Departments
    Given url readBaseUrl
    And path '/api/GetCountyDepartments'
    And sleep(8000)
    And set getDepartmentsCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetCountyDepartments-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | updateCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                          |
      | id              | updateCountyDepartmentResponse.header.id            |
      | correlationId   | updateCountyDepartmentResponse.header.correlationId |
      | commandUserId   | updateCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                                  |
      | commandType     | "GetCountyDepartments"                              |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getDepatmentsCommandBodyRequest
      | path           |      0 |
      | code           | null   |
      | name           | "Test" |
      | officialsTitle | null   |
      | glCode         | null   |
      | isActive       | null   |
    And set getDepatmentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyDepartmentsPayload
      | path                | [0]                                |
      | header              | getDepartmentsCommandHeader[0]     |
      | body.request        | getDepatmentsCommandBodyRequest[0] |
      | body.paginationSort | getDepatmentsCommandPagination[0]  |
    And print getCountyDepartmentsPayload
    And request getCountyDepartmentsPayload
    When method POST
    Then status 200
    And def getCountyDepartmentsResponse = response
    And print getCountyDepartmentsResponse
    And match getCountyDepartmentsResponse.results[*].id contains updateCountyDepartmentResponse.body.id
    And match each getCountyDepartmentsResponse.results[*].name contains "Test"
    And def getCountyDepartmentsResponseCount = karate.sizeOf(getCountyDepartmentsResponse.results)
    And print getCountyDepartmentsResponseCount
    And match getCountyDepartmentsResponseCount == getCountyDepartmentsResponse.totalRecordCount
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
    And def evnentType = "CountyDepartment"
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDepartmentInformationWithInvalidDataToMandatoryfields
  Scenario Outline: Update a County Department with invalid data to Mandatory field and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateCountyDepartment'
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateDepartment-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | entityId        | addCountyDepartmentResponse.header.entityId      |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateDepartment"                               |
      | entityName      | "Department"                                     |
      | ttl             |                                                0 |
    And set commandBody
      | path           |                                           0 |
      | id             | addCountyDepartmentResponse.header.entityId |
      | name           | firstName                                   |
      | code           | faker.getUserId()                           |
      | officialsName  | faker.getFirstName()                        |
      | officialsTitle | faker.getLastName()                         |
      | isActive       | faker.getRandomBoolean()                    |
    And set commandLocations
      | path |                                                  0 |
      | id   | firstName                                          |
      | name | addCountyDepartmentResponse.body.locations[0].name |
      | code | addCountyDepartmentResponse.body.locations[0].code |
    And set updateCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print updateCountyDepartmentPayload
    And request updateCountyDepartmentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDepartmentInformationWithMissingMandatoryfields
  Scenario Outline: Update a County Department with missing Mandatory field
    Given url commandBaseUrl
    And path '/api/UpdateCountyDepartment'
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateDepartment-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | entityId        | addCountyDepartmentResponse.header.entityId      |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "UpdateDepartment"                               |
      | entityName      | "Department"                                     |
      | ttl             |                                                0 |
    And set commandBody
      | path           |                                           0 |
      | id             | addCountyDepartmentResponse.header.entityId |
      | name           | firstName                                   |
      | code           | faker.getUserId()                           |
      | officialsName  | faker.getFirstName()                        |
      | officialsTitle | faker.getLastName()                         |
      | isActive       | faker.getRandomBoolean()                    |
    And set updateCountyDepartmentPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateCountyDepartmentPayload
    And request updateCountyDepartmentPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDepartmentInformationWithDuplicateEntity
  Scenario Outline: Update a County Department with duplicate entity
    And def result = call read('CreateCountyDepartment.feature@CreateCountyDepartment')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get the County Departments
    Given url readBaseUrl
    And path '/api/GetCountyDepartments'
    And sleep(8000)
    And set getDepartmentsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetCountyDepartments-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | tags            | []                                               |
      | commandType     | "GetCountyDepartments"                           |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getDepatmentsCommandBodyRequest
      | path           |      0 |
      | code           | null   |
      | name           | "Test" |
      | officialsTitle | null   |
      | glCode         | null   |
      | isActive       | null   |
    And set getDepatmentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyDepartmentsPayload
      | path                | [0]                                |
      | header              | getDepartmentsCommandHeader[0]     |
      | body.request        | getDepatmentsCommandBodyRequest[0] |
      | body.paginationSort | getDepatmentsCommandPagination[0]  |
    And print getCountyDepartmentsPayload
    And request getCountyDepartmentsPayload
    When method POST
    Then status 200
    And def getCountyDepartmentsResponse = response
    And print getCountyDepartmentsResponse
    Given url commandBaseUrl
    And path '/api/UpdateCountyDepartment'
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateCountyDepartment-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | addCountyDepartmentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                       |
      | id              | addCountyDepartmentResponse.header.id            |
      | correlationId   | addCountyDepartmentResponse.header.correlationId |
      | entityId        | addCountyDepartmentResponse.header.entityId      |
      | commandUserId   | addCountyDepartmentResponse.header.commandUserId |
      | entityVersion   |                                                2 |
      | tags            | []                                               |
      | commandType     | "UpdateCountyDepartment"                         |
      | entityName      | "CountyDepartment"                               |
      | ttl             |                                                0 |
    And set commandBody
      | path           |                                            0 |
      | id             | addCountyDepartmentResponse.header.entityId  |
      | name           | firstName                                    |
      | code           | getCountyDepartmentsResponse.results[1].code |
      | officialsName  | faker.getFirstName()                         |
      | officialsTitle | faker.getLastName()                          |
      | isActive       | faker.getRandomBoolean()                     |
    And set commandLocations
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | name | faker.getFirstName()          |
      | code | faker.getUserId()             |
    And set updateCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
    And print updateCountyDepartmentPayload
    And request updateCountyDepartmentPayload
    When method POST
    Then status 500
    And print response
    And match response.detail contains 'EntityAlreadyExistsException'

    Examples: 
      | tenantid    |
      | tenantID[0] |
