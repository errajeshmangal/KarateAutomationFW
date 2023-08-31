@DocumentTypeGroupFeature
Feature: Document Type Group-Add ,Edit,View,Grid

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeGroupCollectionName = 'CreateDocumentTypeGroup_'
    And def DocumentTypeGroupCollectionNameRead = 'DocumentTypeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateAndGetDocumentTypeGroupwithAllDetails
  Scenario Outline: Create a Document Type Group with all the fields and Get the details
    # Create Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def addDocumentTypeGroupResponse = result.response
    And print addDocumentTypeGroupResponse
    #Get the Document Type Group
    Given url readBaseUrl
    And path '/api/GetDocumentTypeGroup'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addDocumentTypeGroupResponse.header.id            |
      | correlationId   | addDocumentTypeGroupResponse.header.correlationId |
      | commandUserId   | addDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeGroup"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                    0 |
      | id   | addDocumentTypeGroupResponse.body.id |
    And set getDocumentTypeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypeGroupPayload
    And request getDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupResponse = response
    And print getDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeGroupCollectionNameRead+<tenantid>,addDocumentTypeGroupResponse.header.entityId)
    And print mongoResult
    And match mongoResult == addDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupResponse.documentTypeGroupID == addDocumentTypeGroupResponse.body.documentTypeGroupID
    And match getDocumentTypeGroupResponse.documentTypeGroupName == addDocumentTypeGroupResponse.body.documentTypeGroupName
    And match getDocumentTypeGroupResponse.description == addDocumentTypeGroupResponse.body.description
    And match getDocumentTypeGroupResponse.department.id == addDocumentTypeGroupResponse.body.department.id
    And match getDocumentTypeGroupResponse.area.id == addDocumentTypeGroupResponse.body.area.id
    And match getDocumentTypeGroupResponse.documentClass.id == addDocumentTypeGroupResponse.body.documentClass.id
    And match getDocumentTypeGroupResponse.defaultDocumentType.id == addDocumentTypeGroupResponse.body.defaultDocumentType.id
    And match getDocumentTypeGroupResponse.isActive == addDocumentTypeGroupResponse.body.isActive
    And sleep(15000)
    #    Get all Document Type Groups with isactive status of created one's
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addDocumentTypeGroupResponse.header.id            |
      | correlationId   | addDocumentTypeGroupResponse.header.correlationId |
      | getType         | "Array"                                           |
      | commandUserId   | addDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeGroups"                           |
      | ttl             |                                                 0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  |                                          0 |
      | documentTypeGroupID   |                                            |
      | documentTypeGroupName |                                            |
      | defaultDocumentType   |                                            |
      | isActive              | addDocumentTypeGroupResponse.body.isActive |
      | lastUpdatedDateTime   |                                            |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                        |
      | header              | getDocumentTypeGroupsCommandHeader[0]      |
      | body.request        | getDocumentTypeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0]  |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match getDocumentTypeGroupsResponse.results[*].id contains addDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupsResponse.results[*].documentTypeGroupName contains addDocumentTypeGroupResponse.body.documentTypeGroupName
    And match each getDocumentTypeGroupsResponse.results[*].isActive == addDocumentTypeGroupResponse.body.isActive
    And def getDocumentTypeGroupsResponseCount = karate.sizeOf(getDocumentTypeGroupsResponse.results)
    And print getDocumentTypeGroupsResponseCount
    And match getDocumentTypeGroupsResponseCount == getDocumentTypeGroupsResponse.totalRecordCount
    #    Get all Document Type Groups
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addDocumentTypeGroupResponse.header.id            |
      | correlationId   | addDocumentTypeGroupResponse.header.correlationId |
      | getType         | "Array"                                           |
      | commandUserId   | addDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeGroups"                           |
      | ttl             |                                                 0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  | 0 |
      | documentTypeGroupID   |   |
      | documentTypeGroupName |   |
      | defaultDocumentType   |   |
      | isActive              |   |
      | lastUpdatedDateTime   |   |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                       |
      | header              | getDocumentTypeGroupsCommandHeader[0]     |
      | body.request        | {}                                        |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0] |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match getDocumentTypeGroupsResponse.results[*].id contains addDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupsResponse.results[*].documentTypeGroupName contains addDocumentTypeGroupResponse.body.documentTypeGroupName
    And def getDocumentTypeGroupsResponseCount = karate.sizeOf(getDocumentTypeGroupsResponse.results)
    And print getDocumentTypeGroupsResponseCount
    And match getDocumentTypeGroupsResponseCount == getDocumentTypeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addDocumentTypeGroupResponse.body.id
    And def eventName = "DocumentTypeGroupCreated"
    And def evnentType = "DocumentTypeGroup"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "DocumentTypeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addDocumentTypeGroupResponse.body.id
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
    And def evnentType = "DocumentTypeGroup"
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

  @CreateAndGetDocumentTypeGroupwithMandatoryFields
  Scenario Outline: Create a Document Type Group with  mandatory fields and Get the details
    #Create DocumentTypeGroup
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupsWithMandatoryFields')
    And def addDocumentTypeGroupResponse = result.response
    And print addDocumentTypeGroupResponse
    #Get the Document Type Group
    Given url readBaseUrl
    And path '/api/GetDocumentTypeGroup'
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addDocumentTypeGroupResponse.header.id            |
      | correlationId   | addDocumentTypeGroupResponse.header.correlationId |
      | commandUserId   | addDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeGroup"                            |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                    0 |
      | id   | addDocumentTypeGroupResponse.body.id |
    And set getDocumentTypeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypeGroupPayload
    And request getDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupResponse = response
    And print getDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeGroupCollectionNameRead+<tenantid>,addDocumentTypeGroupResponse.header.entityId)
    And print mongoResult
    And match mongoResult == addDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupResponse.documentTypeGroupID == addDocumentTypeGroupResponse.body.documentTypeGroupID
    And match getDocumentTypeGroupResponse.documentTypeGroupName == addDocumentTypeGroupResponse.body.documentTypeGroupName
    And match getDocumentTypeGroupResponse.department.id == addDocumentTypeGroupResponse.body.department.id
    And match getDocumentTypeGroupResponse.area.id == addDocumentTypeGroupResponse.body.area.id
    And match getDocumentTypeGroupResponse.documentClass.id == addDocumentTypeGroupResponse.body.documentClass.id
    And match getDocumentTypeGroupResponse.defaultDocumentType.id == addDocumentTypeGroupResponse.body.defaultDocumentType.id
    And match getDocumentTypeGroupResponse.isActive == addDocumentTypeGroupResponse.body.isActive
    And sleep(15000)
    #    Get the Document Type Groups
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | addDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | addDocumentTypeGroupResponse.header.id            |
      | correlationId   | addDocumentTypeGroupResponse.header.correlationId |
      | getType         | "Array"                                           |
      | commandUserId   | addDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeGroups"                           |
      | ttl             |                                                 0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  |                                          0 |
      | documentTypeGroupID   |                                            |
      | documentTypeGroupName |                                            |
      | defaultDocumentType   |                                            |
      | isActive              | addDocumentTypeGroupResponse.body.isActive |
      | lastUpdatedDateTime   |                                            |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                        |
      | header              | getDocumentTypeGroupsCommandHeader[0]      |
      | body.request        | getDocumentTypeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0]  |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match getDocumentTypeGroupsResponse.results[*].id contains addDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupsResponse.results[*].documentTypeGroupName contains addDocumentTypeGroupResponse.body.documentTypeGroupName
    And match each getDocumentTypeGroupsResponse.results[*].isActive == addDocumentTypeGroupResponse.body.isActive
    And def getDocumentTypeGroupsResponseCount = karate.sizeOf(getDocumentTypeGroupsResponse.results)
    And print getDocumentTypeGroupsResponseCount
    And match getDocumentTypeGroupsResponseCount == getDocumentTypeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = addDocumentTypeGroupResponse.body.id
    And def eventName = "DocumentTypeGroupCreated"
    And def evnentType = "DocumentTypeGroup"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "DocumentTypeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addDocumentTypeGroupResponse.body.id
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
    And def evnentType = "DocumentTypeGroup"
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

  @CreateDocumentTypeGroupswithInvalidFields
  Scenario Outline: Create Document Type Group with invalid fields
    Given url commandBaseUrl
    And path '/api/CreateDocumentTypeGroup'
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
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateDocumentTypeGroup-v1.001.json" |
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
      | commandType     | "CreateDocumentTypeGroup"                        |
      | entityName      | "DocumentTypeGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path                  |                             0 |
      | id                    | entityIdData                  |
      | documentTypeGroupID   | faker.getFirstName()          |
      | documentTypeGroupName | faker.getRandom5DigitNumber() |
      | isActive              | faker.getRandomBoolean()      |
      | Description           | faker.getRandom5DigitNumber() |
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
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDefaultDocumentType
      | path |                                          0 |
      | id   | activeDocumentTypeResponse.results[0].id   |
      | name | activeDocumentTypeResponse.results[0].name |
      | code | activeDocumentTypeResponse.results[0].code |
    And set createDocumentTypeGroupPayload
      | path                     | [0]                           |
      | header                   | commandHeader[0]              |
      | body                     | commandBody[0]                |
      | body.department          | commandDepartment[0]          |
      | body.area                | commandArea[0]                |
      | body.documentClass       | commandDocumentClass[0]       |
      | body.defaultDocumentType | commandDefaultDocumentType[0] |
    And print createDocumentTypeGroupPayload
    And request createDocumentTypeGroupPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypeGroupswithMissingMandatoryField
  Scenario Outline: Create Document Type Group with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateDocumentTypeGroup'
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
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateDocumentTypeGroup-v1.001.json" |
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
      | commandType     | "CreateDocumentTypeGroup"                        |
      | entityName      | "DocumentTypeGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path                  |                                 0 |
      | id                    | entityIdData                      |
      | documentTypeGroupName | faker.getFirstName()              |
      | isActive              | faker.getRandomBoolean()          |
      | Description           | faker.getRandomShortDescription() |
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
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDefaultDocumentType
      | path |                                          0 |
      | id   | activeDocumentTypeResponse.results[0].id   |
      | name | activeDocumentTypeResponse.results[0].name |
      | code | activeDocumentTypeResponse.results[0].code |
    And set createDocumentTypeGroupPayload
      | path                     | [0]                           |
      | header                   | commandHeader[0]              |
      | body                     | commandBody[0]                |
      | body.department          | commandDepartment[0]          |
      | body.area                | commandArea[0]                |
      | body.documentClass       | commandDocumentClass[0]       |
      | body.defaultDocumentType | commandDefaultDocumentType[0] |
    And print createDocumentTypeGroupPayload
    And request createDocumentTypeGroupPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateDocumentGroupType
  Scenario Outline: Create Duplicate Document Type Group with all Details
    Given url commandBaseUrl
    And path '/api/CreateDocumentTypeGroup'
    #Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
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
    And def entityIdData = dataGenerator.entityID()
    And set DuplicateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/CreateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | entityIdData                                         |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "CreateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set DuplicateDocumentTypeGroupCommandBody
      | path                  |                                                        0 |
      | id                    | entityIdData                                             |
      | documentTypeGroupID   | createDocumentTypeGroupResponse.body.documentTypeGroupID |
      | documentTypeGroupName | faker.getFirstName()                                     |
      | isActive              | faker.getRandomBoolean()                                 |
      | Description           | faker.getRandomShortDescription()                        |
    And set DuplicatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set DuplicatecommandArea
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set DuplicatecommandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set DuplicatecommandDefaultDocumentType
      | path |                                          0 |
      | id   | activeDocumentTypeResponse.results[0].id   |
      | name | activeDocumentTypeResponse.results[0].name |
      | code | activeDocumentTypeResponse.results[0].code |
    And set DuplicateDocumentTypeGroupPayload
      | path                     | [0]                                        |
      | header                   | DuplicateDocumentTypeGroupCommandHeader[0] |
      | body                     | DuplicateDocumentTypeGroupCommandBody[0]   |
      | body.department          | DuplicatecommandDepartment[0]              |
      | body.area                | DuplicatecommandArea[0]                    |
      | body.documentClass       | DuplicatecommandDocumentClass[0]           |
      | body.defaultDocumentType | DuplicatecommandDefaultDocumentType[0]     |
    And print DuplicateDocumentTypeGroupPayload
    And request DuplicateDocumentTypeGroupPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:DocumentTypeGroup cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAndGetDocumentTypeGroupwithAllDetails
  Scenario Outline: Update Document Type Group with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/UpdateDocumentTypeGroup'
    #    Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
    #    calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And set updateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | createDocumentTypeGroupResponse.header.entityId      |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set updateDocumentTypeGroupCommandBody
      | path                  |                                                        0 |
      | id                    | createDocumentTypeGroupResponse.header.entityId          |
      | documentTypeGroupID   | createDocumentTypeGroupResponse.body.documentTypeGroupID |
      | documentTypeGroupName | faker.getFirstName()                                     |
      | isActive              | faker.getRandomBoolean()                                 |
      | description           | faker.getRandomShortDescription()                        |
    And set updatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[1].id   |
      | name | activeDepartmentResponse.results[1].name |
      | code | activeDepartmentResponse.results[1].code |
    And set updatecommandArea
      | path |                                              0 |
      | id   | createDocumentTypeGroupResponse.body.area.id   |
      | name | createDocumentTypeGroupResponse.body.area.name |
      | code | createDocumentTypeGroupResponse.body.area.code |
    And set updatecommandDocumentClass
      | path |                                                       0 |
      | id   | createDocumentTypeGroupResponse.body.documentClass.id   |
      | name | createDocumentTypeGroupResponse.body.documentClass.name |
      | code | createDocumentTypeGroupResponse.body.documentClass.code |
    And set updatecommandDefaultDocumentType
      | path |                                                             0 |
      | id   | createDocumentTypeGroupResponse.body.defaultDocumentType.id   |
      | name | createDocumentTypeGroupResponse.body.defaultDocumentType.name |
      | code | createDocumentTypeGroupResponse.body.defaultDocumentType.code |
    And set updateDocumentTypeGroupPayload
      | path                     | [0]                                     |
      | header                   | updateDocumentTypeGroupCommandHeader[0] |
      | body                     | updateDocumentTypeGroupCommandBody[0]   |
      | body.department          | updatecommandDepartment[0]              |
      | body.area                | updatecommandArea[0]                    |
      | body.documentClass       | updatecommandDocumentClass[0]           |
      | body.defaultDocumentType | updatecommandDefaultDocumentType[0]     |
    And print updateDocumentTypeGroupPayload
    And request updateDocumentTypeGroupPayload
    When method POST
    Then status 201
    And def updateDocumentTypeGroupResponse = response
    And print updateDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeGroupCollectionName+<tenantid>,updateDocumentTypeGroupResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeGroupPayload.body.id
    And match  updateDocumentTypeGroupPayload.body.documentTypeGroupID == updateDocumentTypeGroupResponse.body.documentTypeGroupID
    And match  updateDocumentTypeGroupPayload.body.documentTypeGroupName == updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And match  updateDocumentTypeGroupPayload.body.isActive == updateDocumentTypeGroupResponse.body.isActive
    And match  updateDocumentTypeGroupPayload.body.description == updateDocumentTypeGroupResponse.body.description
    And match  updateDocumentTypeGroupPayload.body.department.id == updateDocumentTypeGroupResponse.body.department.id
    And match  updateDocumentTypeGroupPayload.body.area.id == updateDocumentTypeGroupResponse.body.area.id
    And match  updateDocumentTypeGroupPayload.body.documentClass.id == updateDocumentTypeGroupResponse.body.documentClass.id
    And match  updateDocumentTypeGroupPayload.body.defaultDocumentType.id == updateDocumentTypeGroupResponse.body.defaultDocumentType.id
    And sleep(10000)
    #    Get the Document Type Group
    Given url readBaseUrl
    And path '/api/GetDocumentTypeGroup'
    And set getCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroup-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | updateDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | updateDocumentTypeGroupResponse.header.id            |
      | correlationId   | updateDocumentTypeGroupResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                   |
      | commandType     | "GetDocumentTypeGroup"                               |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getCommandBody
      | path |                                       0 |
      | id   | updateDocumentTypeGroupResponse.body.id |
    And set getDocumentTypeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypeGroupPayload
    And request getDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupResponse = response
    And print getDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeGroupCollectionNameRead+<tenantid>,getDocumentTypeGroupResponse.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupResponse.documentTypeGroupID == updateDocumentTypeGroupResponse.body.documentTypeGroupID
    And match getDocumentTypeGroupResponse.documentTypeGroupName == updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And match  getDocumentTypeGroupResponse.isActive == updateDocumentTypeGroupResponse.body.isActive
    And match  getDocumentTypeGroupResponse.description == updateDocumentTypeGroupResponse.body.description
    And match  getDocumentTypeGroupResponse.department.id == updateDocumentTypeGroupResponse.body.department.id
    And match  getDocumentTypeGroupResponse.area.id == updateDocumentTypeGroupResponse.body.area.id
    And match  getDocumentTypeGroupResponse.documentClass.id == updateDocumentTypeGroupResponse.body.documentClass.id
    And match  getDocumentTypeGroupResponse.defaultDocumentType.id == updateDocumentTypeGroupResponse.body.defaultDocumentType.id
    And sleep(15000)
    #    Get all Document Type Groups
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | getType         | "Array"                                              |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                   |
      | commandType     | "GetDocumentTypeGroups"                              |
      | ttl             |                                                    0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  |                                             0 |
      | documentTypeGroupID   |                                               |
      | documentTypeGroupName |                                               |
      | defaultDocumentType   |                                               |
      | isActive              | updateDocumentTypeGroupResponse.body.isActive |
      | lastUpdatedDateTime   |                                               |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                        |
      | header              | getDocumentTypeGroupsCommandHeader[0]      |
      | body.request        | getDocumentTypeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0]  |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match getDocumentTypeGroupsResponse.results[*].id contains updateDocumentTypeGroupResponse.body.id
    And match each getDocumentTypeGroupsResponse.results[*].isActive == updateDocumentTypeGroupResponse.body.isActive
    And match getDocumentTypeGroupsResponse.results[*].documentTypeGroupName contains updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And def getDocumentTypeGroupsResponseCount = karate.sizeOf(getDocumentTypeGroupsResponse.results)
    And print getDocumentTypeGroupsResponseCount
    And match getDocumentTypeGroupsResponseCount == getDocumentTypeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updateDocumentTypeGroupResponse.body.id
    And def eventName = "DocumentTypeGroupUpdated"
    And def evnentType = "DocumentTypeGroup"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "DocumentTypeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateDocumentTypeGroupResponse.body.id
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
    And def evnentType = "DocumentTypeGroup"
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

  @updateDocumentTypeGroupWithMandatoryFields
  Scenario Outline: Update a Document Type Group with mandatory details
    Given url commandBaseUrl
    And path '/api/UpdateDocumentTypeGroup'
    #    Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupsWithMandatoryFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
    #    calling department API to get active departments data
    And def Departmentresult = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = Departmentresult.response
    And print activeDepartmentResponse
    And set updateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | createDocumentTypeGroupResponse.header.entityId      |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set updateDocumentTypeGroupCommandBody
      | path                  |                                                        0 |
      | id                    | createDocumentTypeGroupResponse.header.entityId          |
      | documentTypeGroupID   | createDocumentTypeGroupResponse.body.documentTypeGroupID |
      | documentTypeGroupName | faker.getFirstName()                                     |
    And set updatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[2].id   |
      | name | activeDepartmentResponse.results[2].name |
      | code | activeDepartmentResponse.results[2].code |
    And set updatecommandArea
      | path |                                              0 |
      | id   | createDocumentTypeGroupResponse.body.area.id   |
      | name | createDocumentTypeGroupResponse.body.area.name |
      | code | createDocumentTypeGroupResponse.body.area.code |
    And set updatecommandDocumentClass
      | path |                                                       0 |
      | id   | createDocumentTypeGroupResponse.body.documentClass.id   |
      | name | createDocumentTypeGroupResponse.body.documentClass.name |
      | code | createDocumentTypeGroupResponse.body.documentClass.code |
    And set updatecommandDefaultDocumentType
      | path |                                                             0 |
      | id   | createDocumentTypeGroupResponse.body.defaultDocumentType.id   |
      | name | createDocumentTypeGroupResponse.body.defaultDocumentType.name |
      | code | createDocumentTypeGroupResponse.body.defaultDocumentType.code |
    And set updateDocumentTypeGroupPayload
      | path                     | [0]                                     |
      | header                   | updateDocumentTypeGroupCommandHeader[0] |
      | body                     | updateDocumentTypeGroupCommandBody[0]   |
      | body.department          | updatecommandDepartment[0]              |
      | body.area                | updatecommandArea[0]                    |
      | body.documentClass       | updatecommandDocumentClass[0]           |
      | body.defaultDocumentType | updatecommandDefaultDocumentType[0]     |
    And print updateDocumentTypeGroupPayload
    And request updateDocumentTypeGroupPayload
    When method POST
    Then status 201
    And def updateDocumentTypeGroupResponse = response
    And print updateDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeGroupCollectionName+<tenantid>,updateDocumentTypeGroupResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeGroupPayload.body.id
    And match  updateDocumentTypeGroupPayload.body.documentTypeGroupID == updateDocumentTypeGroupResponse.body.documentTypeGroupID
    And match  updateDocumentTypeGroupPayload.body.documentTypeGroupName == updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And match  updateDocumentTypeGroupPayload.body.department.id == updateDocumentTypeGroupResponse.body.department.id
    And match  updateDocumentTypeGroupPayload.body.area.id == updateDocumentTypeGroupResponse.body.area.id
    And match  updateDocumentTypeGroupPayload.body.documentClass.id == updateDocumentTypeGroupResponse.body.documentClass.id
    And match  updateDocumentTypeGroupPayload.body.defaultDocumentType.id == updateDocumentTypeGroupResponse.body.defaultDocumentType.id
    And sleep(10000)
    #    Get the Document Type Group
    Given url readBaseUrl
    And path '/api/GetDocumentTypeGroup'
    And set getCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroup-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | updateDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | updateDocumentTypeGroupResponse.header.id            |
      | correlationId   | updateDocumentTypeGroupResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                   |
      | commandType     | "GetDocumentTypeGroup"                               |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getCommandBody
      | path |                                       0 |
      | id   | updateDocumentTypeGroupResponse.body.id |
    And set getDocumentTypeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypeGroupPayload
    And request getDocumentTypeGroupPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupResponse = response
    And print getDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeGroupCollectionNameRead+<tenantid>,getDocumentTypeGroupResponse.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupResponse.documentTypeGroupID == updateDocumentTypeGroupResponse.body.documentTypeGroupID
    And match getDocumentTypeGroupResponse.documentTypeGroupName == updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And match  getDocumentTypeGroupResponse.isActive == updateDocumentTypeGroupResponse.body.isActive
    And match  getDocumentTypeGroupResponse.department.id == updateDocumentTypeGroupResponse.body.department.id
    And match  getDocumentTypeGroupResponse.area.id == updateDocumentTypeGroupResponse.body.area.id
    And match  getDocumentTypeGroupResponse.documentClass.id == updateDocumentTypeGroupResponse.body.documentClass.id
    And match  getDocumentTypeGroupResponse.defaultDocumentType.id == updateDocumentTypeGroupResponse.body.defaultDocumentType.id
    And sleep(15000)
    #    Get all Document Type Groups
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | getType         | "Array"                                              |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | tags            | []                                                   |
      | commandType     | "GetDocumentTypeGroups"                              |
      | ttl             |                                                    0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  | 0 |
      | documentTypeGroupID   |   |
      | documentTypeGroupName |   |
      | defaultDocumentType   |   |
      | isActive              |   |
      | lastUpdatedDateTime   |   |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                       |
      | header              | getDocumentTypeGroupsCommandHeader[0]     |
      | body.request        | {}                                        |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0] |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match getDocumentTypeGroupsResponse.results[*].id contains updateDocumentTypeGroupResponse.body.id
    And match getDocumentTypeGroupsResponse.results[*].documentTypeGroupName contains updateDocumentTypeGroupResponse.body.documentTypeGroupName
    And def getDocumentTypeGroupsResponseCount = karate.sizeOf(getDocumentTypeGroupsResponse.results)
    And print getDocumentTypeGroupsResponseCount
    And match getDocumentTypeGroupsResponseCount == getDocumentTypeGroupsResponse.totalRecordCount
    #HistoryValidation
    And def entityIdData = updateDocumentTypeGroupResponse.body.id
    And def eventName = "DocumentTypeGroupUpdated"
    And def evnentType = "DocumentTypeGroup"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "DocumentTypeGroup"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateDocumentTypeGroupResponse.body.id
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
    And def evnentType = "DocumentTypeGroup"
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

  @updateDocumentTypeGroupWithInvalidFields
  Scenario Outline: Update a Document Type Group with invalid details
    Given url commandBaseUrl
    And path '/api/UpdateDocumentTypeGroup'
    #    Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
    #    calling department API to get active departments data
    And def Departmentresult = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = Departmentresult.response
    And print activeDepartmentResponse
    And set updateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | createDocumentTypeGroupResponse.header.entityId      |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set updateDocumentTypeGroupCommandBody
      | path                  |                                               0 |
      | id                    | createDocumentTypeGroupResponse.header.entityId |
      | documentTypeGroupID   | faker.getFirstName()                            |
      | documentTypeGroupName | faker.getRandom5DigitNumber()                   |
      | isActive              | faker.getRandomBoolean()                        |
      | Description           | faker.getRandom5DigitNumber()                   |
    And set updatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set updatecommandArea
      | path |                                              0 |
      | id   | createDocumentTypeGroupResponse.body.area.id   |
      | name | createDocumentTypeGroupResponse.body.area.name |
      | code | createDocumentTypeGroupResponse.body.area.code |
    And set updatecommandDocumentClass
      | path |                                                       0 |
      | id   | createDocumentTypeGroupResponse.body.documentClass.id   |
      | name | createDocumentTypeGroupResponse.body.documentClass.name |
      | code | createDocumentTypeGroupResponse.body.documentClass.code |
    And set updatecommandDefaultDocumentType
      | path |                                                             0 |
      | id   | createDocumentTypeGroupResponse.body.defaultDocumentType.id   |
      | name | createDocumentTypeGroupResponse.body.defaultDocumentType.name |
      | code | createDocumentTypeGroupResponse.body.defaultDocumentType.code |
    And set updateDocumentTypeGroupPayload
      | path                     | [0]                                     |
      | header                   | updateDocumentTypeGroupCommandHeader[0] |
      | body                     | updateDocumentTypeGroupCommandBody[0]   |
      | body.department          | updatecommandDepartment[0]              |
      | body.area                | updatecommandArea[0]                    |
      | body.documentClass       | updatecommandDocumentClass[0]           |
      | body.defaultDocumentType | updatecommandDefaultDocumentType[0]     |
    And print updateDocumentTypeGroupPayload
    And request updateDocumentTypeGroupPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateDocumentTypeGroupWithMissingMandatoryFields
  Scenario Outline: Update a Document Type Group with missing mandatory details
    Given url commandBaseUrl
    And path '/api/UpdateDocumentTypeGroup'
    #    Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
    #    calling department API to get active departments data
    And def Departmentresult = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = Departmentresult.response
    And print activeDepartmentResponse
    And set updateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | createDocumentTypeGroupResponse.header.entityId      |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set updateDocumentTypeGroupCommandBody
      | path                  |                                               0 |
      | id                    | createDocumentTypeGroupResponse.header.entityId |
      | documentTypeGroupName | faker.getFirstName()                            |
      | isActive              | faker.getRandomBoolean()                        |
    And set updatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set updatecommandArea
      | path |                                              0 |
      | id   | createDocumentTypeGroupResponse.body.area.id   |
      | name | createDocumentTypeGroupResponse.body.area.name |
      | code | createDocumentTypeGroupResponse.body.area.code |
    And set updatecommandDocumentClass
      | path |                                                       0 |
      | id   | createDocumentTypeGroupResponse.body.documentClass.id   |
      | name | createDocumentTypeGroupResponse.body.documentClass.name |
      | code | createDocumentTypeGroupResponse.body.documentClass.code |
    And set updatecommandDefaultDocumentType
      | path |                                                             0 |
      | id   | createDocumentTypeGroupResponse.body.defaultDocumentType.id   |
      | name | createDocumentTypeGroupResponse.body.defaultDocumentType.name |
      | code | createDocumentTypeGroupResponse.body.defaultDocumentType.code |
    And set updateDocumentTypeGroupPayload
      | path                     | [0]                                     |
      | header                   | updateDocumentTypeGroupCommandHeader[0] |
      | body                     | updateDocumentTypeGroupCommandBody[0]   |
      | body.department          | updatecommandDepartment[0]              |
      | body.area                | updatecommandArea[0]                    |
      | body.documentClass       | updatecommandDocumentClass[0]           |
      | body.defaultDocumentType | updatecommandDefaultDocumentType[0]     |
    And print updateDocumentTypeGroupPayload
    And request updateDocumentTypeGroupPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypeGroupwithDuplicateID
  Scenario Outline: Update Document Type Group with Duplicate ID
    Given url commandBaseUrl
    And path '/api/UpdateDocumentTypeGroup'
    #    Create a Document Type Group
    And def result = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse = result.response
    And print createDocumentTypeGroupResponse
    #    Create a Document Type Group
    And def result1 = call read('CreateDocumentTypeGroup.feature@CreateDocumentTypeGroupswithAllFields')
    And def createDocumentTypeGroupResponse1 = result1.response
    And print createDocumentTypeGroupResponse1
    #    calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And set updateDocumentTypeGroupCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/UpdateDocumentTypeGroup-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | createDocumentTypeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                           |
      | id              | createDocumentTypeGroupResponse.header.id            |
      | correlationId   | createDocumentTypeGroupResponse.header.correlationId |
      | entityId        | createDocumentTypeGroupResponse.header.entityId      |
      | commandUserId   | createDocumentTypeGroupResponse.header.commandUserId |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | "UpdateDocumentTypeGroup"                            |
      | entityName      | "DocumentTypeGroup"                                  |
      | ttl             |                                                    0 |
    And set updateDocumentTypeGroupCommandBody
      | path                  |                                                         0 |
      | id                    | createDocumentTypeGroupResponse.header.entityId           |
      | documentTypeGroupID   | createDocumentTypeGroupResponse1.body.documentTypeGroupID |
      | documentTypeGroupName | faker.getFirstName()                                      |
      | isActive              | faker.getRandomBoolean()                                  |
      | description           | faker.getRandomShortDescription()                         |
    And set updatecommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[1].id   |
      | name | activeDepartmentResponse.results[1].name |
      | code | activeDepartmentResponse.results[1].code |
    And set updatecommandArea
      | path |                                              0 |
      | id   | createDocumentTypeGroupResponse.body.area.id   |
      | name | createDocumentTypeGroupResponse.body.area.name |
      | code | createDocumentTypeGroupResponse.body.area.code |
    And set updatecommandDocumentClass
      | path |                                                       0 |
      | id   | createDocumentTypeGroupResponse.body.documentClass.id   |
      | name | createDocumentTypeGroupResponse.body.documentClass.name |
      | code | createDocumentTypeGroupResponse.body.documentClass.code |
    And set updatecommandDefaultDocumentType
      | path |                                                             0 |
      | id   | createDocumentTypeGroupResponse.body.defaultDocumentType.id   |
      | name | createDocumentTypeGroupResponse.body.defaultDocumentType.name |
      | code | createDocumentTypeGroupResponse.body.defaultDocumentType.code |
    And set updateDocumentTypeGroupPayload
      | path                     | [0]                                     |
      | header                   | updateDocumentTypeGroupCommandHeader[0] |
      | body                     | updateDocumentTypeGroupCommandBody[0]   |
      | body.department          | updatecommandDepartment[0]              |
      | body.area                | updatecommandArea[0]                    |
      | body.documentClass       | updatecommandDocumentClass[0]           |
      | body.defaultDocumentType | updatecommandDefaultDocumentType[0]     |
    And print updateDocumentTypeGroupPayload
    And request updateDocumentTypeGroupPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
