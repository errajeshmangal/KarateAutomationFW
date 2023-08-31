@DocumentTypeE2E
Feature: Add ,Edit,View, Grid view

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeCollectionName = 'CreateDocumentTypeMasterInfo_'
    And def DocumentTypeCollectionNameRead = 'DocumentTypeMasterInfoDetailViewModel_'
    And def DocumentTypeOtherInfoCollectionName = 'CreateDocumentTypeOtherInfo_'
    And def DocumentTypeOtherInfoCollectionNameRead = 'DocumentTypeOtherInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateDocumentTypeMasterInfo","UpdateDocumentTypeMasterInfo","GetDocumentTypeMasterInfo","GetDocumentTypeMasterInfos","UpdateDocumentTypeOtherInfo","GetDocumentTypeOtherInfo","CreateDocumentTypeOtherInfo"]
    And def entityName = ["DocumentTypeMasterInfo"]
    And def documentAttachmentCategory = ["Recorded","Filed","NonRecordable","Miscellaneous","RelatedDocument"]
    And def defaultDocumentSecurity = ["Use Default","Normal","Confidential","Secure"]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['DocumentTypeMasterInfo','DocumentTypeOtherInfo']

  @CreateAndGetDocumentTypewithAllDetails
  Scenario Outline: Create a Document Type Master Info with all the fields and Get the details
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #Get the Document Type Master Info
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | createDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.id == createDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.documentTypeCode == createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.documentTypeDescription == createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.description == createDocumentTypeResponse.body.description
   	And match getDocumentTypeResponse.isActive == createDocumentTypeResponse.body.isActive
    And match getDocumentTypeResponse.isExcludeFromCashiering == createDocumentTypeResponse.body.isExcludeFromCashiering
    And match getDocumentTypeResponse.isExcludeFromIndexing == createDocumentTypeResponse.body.isExcludeFromIndexing
    And match getDocumentTypeResponse.documentAttachmentCategory == createDocumentTypeResponse.body.documentAttachmentCategory
    And match getDocumentTypeResponse.area.name == createDocumentTypeResponse.body.area.name
    And match getDocumentTypeResponse.department.name == createDocumentTypeResponse.body.department.name
    And match getDocumentTypeResponse.documentClass.name == createDocumentTypeResponse.body.documentClass.name
    And match getDocumentTypeResponse.documentTypeGroup.name == createDocumentTypeResponse.body.documentTypeGroup.name
    And match getDocumentTypeResponse.labelType[0].name == createDocumentTypeResponse.body.labelType[0].name
    And match getDocumentTypeResponse.labelType[1].name == createDocumentTypeResponse.body.labelType[1].name
    
    
    And match mongoResult == getDocumentTypeResponse.id
    And match getDocumentTypeResponse.id == createDocumentTypeResponse.body.id
    
     #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDocumentTypeResponse.id
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
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getDocumentTypeResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
     #HistoryValidation
    And def entityIdData = getDocumentTypeResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
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
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 1
    
    # Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                        0 |
      | documentTypeId          |                                          |
      | documentTypeDescription |                                          |
      | department              |                                          |
      | area                    |                                          |
      | isActive                | createDocumentTypeResponse.body.isActive |
      | lastUpdatedDateTime     |                                          |
    And set getDocumentTypeCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains createDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains createDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains createDocumentTypeResponse.body.area
    And match each getDocumentTypesResponse.results[*].isActive == createDocumentTypeResponse.body.isActive
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount
    # Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                         0 |
      | documentTypeId          |                                           |
      | documentTypeDescription |                                           |
      | department              |                                           |
      | area                    | createDocumentTypeResponse.body.area.name |
      | isActive                |                                           |
      | lastUpdatedDateTime     |                                           |
    And set getDocumentTypeCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDocumentTypeCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains createDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains createDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains createDocumentTypeResponse.body.area
    And match getDocumentTypesResponse.results[*].isActive contains createDocumentTypeResponse.body.isActive
    And match each getDocumentTypesResponse.results[*].isActive == createDocumentTypeResponse.body.isActive
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount
  
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetDocumentTypeMasterInfowithMandateDetails
  Scenario Outline: Create a Master Info Document Type with mandate fields and Get the details
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypeMasterInfowithMandateFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | createDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.id == createDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.documentTypeCode == createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.documentTypeDescription == createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.documentAttachmentCategory == createDocumentTypeResponse.body.documentAttachmentCategory
    And match getDocumentTypeResponse.area.name == createDocumentTypeResponse.body.area.name
    And match getDocumentTypeResponse.department.name == createDocumentTypeResponse.body.department.name
    And match getDocumentTypeResponse.documentClass.name == createDocumentTypeResponse.body.documentClass.name
    And sleep(15000)
    #    Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                               0 |
      | documentTypeId          |                                                 |
      | documentTypeDescription |                                                 |
      | department              | createDocumentTypeResponse.body.department.name |
      | area                    |                                                 |
      | isActive                |                                                 |
      | lastUpdatedDateTime     |                                                 |
    And set getDocumentTypeCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDocumentTypeCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypeCommandPayload
    And request getDocumentTypeCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains createDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains createDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains createDocumentTypeResponse.body.area
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount
    #    Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                         0 |
      | documentTypeId          |                                           |
      | documentTypeDescription |                                           |
      | department              |                                           |
      | area                    | createDocumentTypeResponse.body.area.name |
      | isActive                |                                           |
      | lastUpdatedDateTime     |                                           |
    And set getDocumentTypeCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains createDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains createDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains createDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains createDocumentTypeResponse.body.area
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypeMasterInfowithMissingMandatoryField
  Scenario Outline: Create Document Type  with all Details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set commandBody
      | path                       |                                 0 |
      | id                         | entityIdData                      |
      | documentTypeCode           | faker.getFirstName()              |
      | documentTypeDescription    | faker.getFirstName()              |
      | description                | faker.getRandomShortDescription() |
      | isActive                   | faker.getRandomBoolean()          |
      | isExcludeFromCashiering    | faker.getRandomBoolean()          |
      | isExcludeFromIndexing      | faker.getRandomBoolean()          |
      | documentAttachmentCategory | documentAttachmentCategory[0]     |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commanddocumentTypeGroup
      | path |                                               0 |
      | id   | activeDocumentTypeGroupResponse.results[0].id   |
      | name | activeDocumentTypeGroupResponse.results[0].name |
      | code | activeDocumentTypeGroupResponse.results[0].code |
    And set commandLabelType
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set commandLabelType
      | path |                    1 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createDocumentTypePayload
      | path                   | [0]                         |
      | header                 | commandHeader[0]            |
      | body                   | commandBody[0]              |
      | body.department        | commandDepartment[0]        |
      | body.area              | commandArea[0]              |
      #| body.documentClass           | commandDocumentClass[0]           |
      | body.documentTypeGroup | commanddocumentTypeGroup[0] |
      | body.labelType         | commandLabelType            |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 400
      Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypewithAllFieldsMasterInfo
  Scenario Outline: Create Document Type  with all Details and get the details
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[1].id
    And def departmentName = activeDepartmentResponse.results[1].name
    And def departmentCode = activeDepartmentResponse.results[1].code
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[1]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                       |                                                0 |
      | id                         | createDocumentTypeResponse.body.id               |
      | documentTypeCode           | createDocumentTypeResponse.body.documentTypeCode |
      | documentTypeDescription    | faker.getFirstName()                             |
      | description                | faker.getRandomShortDescription()                |
      | isActive                   | faker.getRandomBoolean()                         |
      | isExcludeFromCashiering    | faker.getRandomBoolean()                         |
      | isExcludeFromIndexing      | faker.getRandomBoolean()                         |
      | documentAttachmentCategory | documentAttachmentCategory[1]                    |
    And set updateCommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[1].id   |
      | name | activeDepartmentResponse.results[1].name |
      | code | activeDepartmentResponse.results[1].code |
    And set updateCommandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set updateCommandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set updateCommanddocumentTypeGroup
      | path |                                               0 |
      | id   | activeDocumentTypeGroupResponse.results[1].id   |
      | name | activeDocumentTypeGroupResponse.results[1].name |
      | code | activeDocumentTypeGroupResponse.results[1].code |
    And set updateCommandLabelType
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandLabelType
      | path |                    1 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypePayload
      | path                   | [0]                               |
      | header                 | updateCommandHeader[0]            |
      | body                   | updateCommandBody[0]              |
      | body.department        | updateCommandDepartment[0]        |
      | body.area              | updateCommandArea[0]              |
      | body.documentClass     | updateCommandDocumentClass[0]     |
      | body.documentTypeGroup | updateCommanddocumentTypeGroup[0] |
      | body.labelType         | updateCommandLabelType            |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeCollectionName+<tenantid>,updateDocumentTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match updateDocumentTypePayload.body.id == updateDocumentTypeResponse.body.id
    And match updateDocumentTypePayload.body.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match updateDocumentTypePayload.body.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match updateDocumentTypePayload.body.description == updateDocumentTypeResponse.body.description
    And match updateDocumentTypePayload.body.isActive == updateDocumentTypeResponse.body.isActive
    And match updateDocumentTypePayload.body.isExcludeFromCashiering == updateDocumentTypeResponse.body.isExcludeFromCashiering
    And match updateDocumentTypePayload.body.isExcludeFromIndexing == updateDocumentTypeResponse.body.isExcludeFromIndexing
    And match updateDocumentTypePayload.body.area.name == updateDocumentTypeResponse.body.area.name
    And match updateDocumentTypePayload.body.department.name == updateDocumentTypeResponse.body.department.name
    And match updateDocumentTypePayload.body.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    And match updateDocumentTypePayload.body.documentTypeGroup.id == updateDocumentTypeResponse.body.documentTypeGroup.id
    And match updateDocumentTypePayload.body.labelType[0].name == updateDocumentTypeResponse.body.labelType[0].name
    And match updateDocumentTypePayload.body.labelType[1].name == updateDocumentTypeResponse.body.labelType[1].name
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,updateDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.id == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.description == updateDocumentTypeResponse.body.description
    And match getDocumentTypeResponse.isActive == updateDocumentTypeResponse.body.isActive
    And match getDocumentTypeResponse.isExcludeFromCashiering == updateDocumentTypeResponse.body.isExcludeFromCashiering
    And match getDocumentTypeResponse.isExcludeFromIndexing == updateDocumentTypeResponse.body.isExcludeFromIndexing
    And match getDocumentTypeResponse.documentAttachmentCategory == updateDocumentTypeResponse.body.documentAttachmentCategory
    And match getDocumentTypeResponse.area.name == updateDocumentTypeResponse.body.area.name
    And match getDocumentTypeResponse.department.name == updateDocumentTypeResponse.body.department.name
    And match getDocumentTypeResponse.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    And match getDocumentTypeResponse.documentTypeGroup.id == updateDocumentTypeResponse.body.documentTypeGroup.id
    And match getDocumentTypeResponse.labelType[0].name == updateDocumentTypeResponse.body.labelType[0].name
    And match getDocumentTypeResponse.labelType[1].name == updateDocumentTypeResponse.body.labelType[1].name
    #Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                                       0 |
      | documentTypeCode        |                                                         |
      | documentTypeDescription | updateDocumentTypeResponse.body.documentTypeDescription |
      | department              |                                                         |
      | area                    |                                                         |
      | isActive                |                                                         |
      | lastUpdatedDateTime     |                                                         |
    And set getDocumentTypeCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypeCommandPayload
    And request getDocumentTypeCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And match getDocumentTypeResponse.results[*].id contains updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.results[*].documentTypeCode contains updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.results[*].documentTypeDescription contains updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.results[*].department contains updateDocumentTypeResponse.body.department
    And match getDocumentTypeResponse.results[*].area contains updateDocumentTypeResponse.body.area
    And match getDocumentTypeResponse.results[*].isActive contains updateDocumentTypeResponse.body.isActive
    And match each getDocumentTypeResponse.results[*].isActive == updateDocumentTypeResponse.body.isActive
    And def getDocumentTypeResponseCount = karate.sizeOf(getDocumentTypeResponse.results)
    And print getDocumentTypeResponseCount
    And match getDocumentTypeResponseCount == getDocumentTypeResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypewithMandateFieldsMasterInfo
  Scenario Outline: update Document Type Master Info with mandate fields
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypeMasterInfowithMandateFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[2].id
    And def departmentName = activeDepartmentResponse.results[2].name
    And def departmentCode = activeDepartmentResponse.results[2].code
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    And def entityIdData = dataGenerator.entityID()
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[1]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                       |                                                0 |
      | id                         | createDocumentTypeResponse.body.id               |
      | documentTypeCode           | createDocumentTypeResponse.body.documentTypeCode |
      | documentTypeDescription    | faker.getFirstName()                             |
      | documentAttachmentCategory | documentAttachmentCategory[1]                    |
    And set updateCommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[1].id   |
      | name | activeDepartmentResponse.results[1].name |
      | code | activeDepartmentResponse.results[1].code |
    And set updateCommandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set updateCommandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set updateDocumentTypePayload
      | path               | [0]                           |
      | header             | updateCommandHeader[0]        |
      | body               | updateCommandBody[0]          |
      | body.department    | updateCommandDepartment[0]    |
      | body.area          | updateCommandArea[0]          |
      | body.documentClass | updateCommandDocumentClass[0] |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeCollectionName+<tenantid>,updateDocumentTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match   updateDocumentTypePayload.body.id == updateDocumentTypeResponse.body.id
    And match updateDocumentTypePayload.body.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match updateDocumentTypePayload.body.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match updateDocumentTypePayload.body.area.name == updateDocumentTypeResponse.body.area.name
    And match updateDocumentTypePayload.body.department.name == updateDocumentTypeResponse.body.department.name
    And match   updateDocumentTypePayload.body.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,updateDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.id == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.documentAttachmentCategory == updateDocumentTypeResponse.body.documentAttachmentCategory
    And match getDocumentTypeResponse.area.name == updateDocumentTypeResponse.body.area.name
    And match getDocumentTypeResponse.department.name == updateDocumentTypeResponse.body.department.name
    And match getDocumentTypeResponse.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    #  Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                                0 |
      | documentTypeCode        | createDocumentTypeResponse.body.documentTypeCode |
      | documentTypeDescription |                                                  |
      | department              |                                                  |
      | area                    |                                                  |
      | isActive                |                                                  |
      | lastUpdatedDateTime     |                                                  |
    And set getDocumentTypeCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains updateDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains updateDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains updateDocumentTypeResponse.body.area
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypewithMandatoryFieldsandOtherMissingDetailsMasterInfo
  Scenario Outline: update Document Type Master Info with existing mandatory fields and add all other missing fields
    Given url commandBaseUrl
    And path '/api/'+commandType[1]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypeMasterInfowithMandateFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[2].id
    And def departmentName = activeDepartmentResponse.results[2].name
    And def departmentCode = activeDepartmentResponse.results[2].code
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    And def areaId = activeAreaResponse.results[0].id
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[1]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                       |                                                0 |
      | id                         | createDocumentTypeResponse.body.id               |
      | documentTypeCode           | createDocumentTypeResponse.body.documentTypeCode |
      | documentTypeDescription    | faker.getFirstName()                             |
      | description                | faker.getRandomShortDescription()                |
      | isActive                   | faker.getRandomBoolean()                         |
      | isExcludeFromCashiering    | faker.getRandomBoolean()                         |
      | isExcludeFromIndexing      | faker.getRandomBoolean()                         |
      | documentAttachmentCategory | documentAttachmentCategory[1]                    |
    And set updateCommandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set updateCommandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set updateCommandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set updateCommanddocumentTypeGroup
      | path |                                               0 |
      | id   | activeDocumentTypeGroupResponse.results[0].id   |
      | name | activeDocumentTypeGroupResponse.results[0].name |
      | code | activeDocumentTypeGroupResponse.results[0].code |
    And set updateCommandLabelType
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandLabelType
      | path |                    1 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypePayload
      | path                   | [0]                               |
      | header                 | updateCommandHeader[0]            |
      | body                   | updateCommandBody[0]              |
      | body.department        | updateCommandDepartment[0]        |
      | body.area              | updateCommandArea[0]              |
      | body.documentClass     | updateCommandDocumentClass[0]     |
      | body.documentTypeGroup | updateCommanddocumentTypeGroup[0] |
      | body.labelType         | updateCommandLabelType            |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeCollectionName+<tenantid>,updateDocumentTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match updateDocumentTypePayload.body.id == updateDocumentTypeResponse.body.id
    And match updateDocumentTypePayload.body.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match updateDocumentTypePayload.body.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match updateDocumentTypePayload.body.description == updateDocumentTypeResponse.body.description
    And match updateDocumentTypePayload.body.isActive == updateDocumentTypeResponse.body.isActive
    And match updateDocumentTypePayload.body.isExcludeFromCashiering == updateDocumentTypeResponse.body.isExcludeFromCashiering
    And match updateDocumentTypePayload.body.isExcludeFromIndexing == updateDocumentTypeResponse.body.isExcludeFromIndexing
    And match updateDocumentTypePayload.body.area.name == updateDocumentTypeResponse.body.area.name
    And match updateDocumentTypePayload.body.department.name == updateDocumentTypeResponse.body.department.name
    And match updateDocumentTypePayload.body.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    And match updateDocumentTypePayload.body.documentTypeGroup.id == updateDocumentTypeResponse.body.documentTypeGroup.id
    And match updateDocumentTypePayload.body.labelType[0].name == updateDocumentTypeResponse.body.labelType[0].name
    And match updateDocumentTypePayload.body.labelType[1].name == updateDocumentTypeResponse.body.labelType[1].name
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,updateDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.id == updateDocumentTypeResponse.body.id
    And match getDocumentTypeResponse.documentTypeCode == updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypeResponse.documentTypeDescription == updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypeResponse.description == updateDocumentTypeResponse.body.description
    And match getDocumentTypeResponse.documentAttachmentCategory == updateDocumentTypeResponse.body.documentAttachmentCategory
    And match getDocumentTypeResponse.area.name == updateDocumentTypeResponse.body.area.name
    And match getDocumentTypeResponse.department.name == updateDocumentTypeResponse.body.department.name
    And match getDocumentTypeResponse.documentClass.name == updateDocumentTypeResponse.body.documentClass.name
    And match getDocumentTypeResponse.documentTypeGroup.id == updateDocumentTypeResponse.body.documentTypeGroup.id
    And match getDocumentTypeResponse.labelType[0].name == updateDocumentTypeResponse.body.labelType[0].name
    And match getDocumentTypeResponse.labelType[1].name == updateDocumentTypeResponse.body.labelType[1].name
    
    
    And match mongoResult == getDocumentTypeResponse.id
    And match getDocumentTypeResponse.id == updateDocumentTypeResponse.body.id
    
     #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDocumentTypeResponse.id
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
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getDocumentTypeResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
     #HistoryValidation
    And def entityIdData = getDocumentTypeResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
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
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 2
      
    #Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[3]
    And set getDocumentTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[3]                              |
      | ttl             |                                           0 |
    And set getDocumentTypeCommandBodyRequest
      | path                    |                                               0 |
      | documentTypeCode        |                                                 |
      | documentTypeDescription |                                                 |
      | department              | createDocumentTypeResponse.body.department.name |
      | area                    |                                                 |
      | isActive                |                                                 |
      | lastUpdatedDateTime     |                                                 |
    And set getDocumentTypeCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains updateDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeCode contains updateDocumentTypeResponse.body.documentTypeCode
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains updateDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains updateDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains updateDocumentTypeResponse.body.area
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount
    
        Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypewithAllFieldsOtherInfo
  Scenario Outline: Update Document Type Other info with all fields
    Given url commandBaseUrl
    And path '/api/'+commandType[6]
    # Create Document Type
    And def result = call read('CreateOtherInfo.feature@CreateDocumentTypeOtherInfowithAllFields')
    And def createDocumentTypeOtherInfoResponse = result.response
    And def entityIdData = dataGenerator.entityID()
    And print createDocumentTypeOtherInfoResponse
    And set updateOtherInfoCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | createDocumentTypeOtherInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | createDocumentTypeOtherInfoResponse.header.id            |
      | correlationId   | createDocumentTypeOtherInfoResponse.header.correlationId |
      | entityId        | createDocumentTypeOtherInfoResponse.body.id              |
      | commandUserId   | createDocumentTypeOtherInfoResponse.header.commandUserId |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[6]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateOtherInfoCommandBody
      | path                           |                                                       0 |
      | id                             | createDocumentTypeOtherInfoResponse.body.id             |
      | documentTypeId                 | createDocumentTypeOtherInfoResponse.body.documentTypeId |
      | nonRecordableERSeq             | faker.getRandom5DigitNumber()                           |
      | defaultDocumentSecurity        | defaultDocumentSecurity[2]                              |
      | isRedact                       | faker.getRandomBoolean()                                |
      | redactionStartDate             | faker.getRandomDate()                                   |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean()                                |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean()                                |
      | isAllowProofOfPublication      | faker.getRandomBoolean()                                |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean()                                |
    And set updateCommandPrimaryNumberingScheme
      | path |                                                                    0 |
      | id   | createDocumentTypeOtherInfoResponse.body.primaryNumberingScheme.id   |
      | name | createDocumentTypeOtherInfoResponse.body.primaryNumberingScheme.name |
      | code | createDocumentTypeOtherInfoResponse.body.primaryNumberingScheme.code |
    And set updateCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandBookPageNumberingScheme
      | path |                                                                     0 |
      | id   | createDocumentTypeOtherInfoResponse.body.bookpageNumberingScheme.id   |
      | name | createDocumentTypeOtherInfoResponse.body.bookpageNumberingScheme.name |
      | code | createDocumentTypeOtherInfoResponse.body.bookpageNumberingScheme.code |
    And set updateCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandStorageArea
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypeOtherInfoPayload
      | path                          | [0]                                      |
      | header                        | updateOtherInfoCommandHeader[0]          |
      | body                          | updateOtherInfoCommandBody[0]            |
      | body.primaryNumberingScheme   | updateCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | updateCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | updateCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | updateCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | updateCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | updateCommandStorageArea[0]              |
    And print updateDocumentTypeOtherInfoPayload
    And request updateDocumentTypeOtherInfoPayload
    When method POST
    Then status 201
    And def updateDocumentTypeOtherInfoResponse = response
    And print updateDocumentTypeOtherInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeOtherInfoCollectionName+<tenantid>,updateDocumentTypeOtherInfoResponse.body.id)
    And print mongoResult
    And match mongoResult == updateDocumentTypeOtherInfoResponse.body.id
    And match updateDocumentTypeOtherInfoPayload.body.id == updateDocumentTypeOtherInfoResponse.body.id
    And match updateDocumentTypeOtherInfoPayload.body.documentTypeId == updateDocumentTypeOtherInfoResponse.body.documentTypeId
    And match updateDocumentTypeOtherInfoPayload.body.nonRecordableERSeq == updateDocumentTypeOtherInfoResponse.body.nonRecordableERSeq
    And match updateDocumentTypeOtherInfoPayload.body.secondaryFeeAssignment.name == updateDocumentTypeOtherInfoResponse.body.secondaryFeeAssignment.name
    And match updateDocumentTypeOtherInfoPayload.body.storageArea.id == updateDocumentTypeOtherInfoResponse.body.storageArea.id
    And match updateDocumentTypeOtherInfoPayload.body.primaryNumberingScheme.name == updateDocumentTypeOtherInfoResponse.body.primaryNumberingScheme.name
    #Get the Document Type Other Info
    Given url readBaseUrl
    And path '/api/'+commandType[5]
    And set getOtherInfoCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[5]+"-v1.001.json"              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | updateDocumentTypeOtherInfoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                               |
      | id              | updateDocumentTypeOtherInfoResponse.header.id            |
      | correlationId   | updateDocumentTypeOtherInfoResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeOtherInfoResponse.header.commandUserId |
      | tags            | []                                                       |
      | commandType     | commandType[5]                                           |
      | getType         | "One"                                                    |
      | ttl             |                                                        0 |
    And set getOtherInfoCommandBody
      | path           |                                                       0 |
      | documentTypeId | updateDocumentTypeOtherInfoResponse.body.documentTypeId |
    And set getDocumentTypeOtherInfoPayload
      | path         | [0]                          |
      | header       | getOtherInfoCommandHeader[0] |
      | body.request | getOtherInfoCommandBody[0]   |
    And print getDocumentTypeOtherInfoPayload
    And request getDocumentTypeOtherInfoPayload
    When method POST
    Then status 200
    And def getDocumentTypeOtherInfoResponse = response
    And print getDocumentTypeOtherInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeOtherInfoCollectionNameRead+<tenantid>,updateDocumentTypeOtherInfoResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateDocumentTypeOtherInfoResponse.body.id
    And match getDocumentTypeOtherInfoResponse.id == updateDocumentTypeOtherInfoResponse.body.id
    And match getDocumentTypeOtherInfoResponse.documentTypeId == updateDocumentTypeOtherInfoResponse.body.documentTypeId
    And match getDocumentTypeOtherInfoResponse.bookpageNumberingScheme.code == updateDocumentTypeOtherInfoResponse.body.bookpageNumberingScheme.code
    And match getDocumentTypeOtherInfoResponse.primaryNumberingScheme.name == updateDocumentTypeOtherInfoResponse.body.primaryNumberingScheme.name
    And sleep(15000)
       And match mongoResult == getDocumentTypeOtherInfoResponse.id
    And match getDocumentTypeOtherInfoResponse.id == updateDocumentTypeOtherInfoResponse.body.id
    
     #Adding the comment
    And def entityName = eventTypes[1]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getDocumentTypeOtherInfoResponse.id
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
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[1]
    And def entityIdData = getDocumentTypeOtherInfoResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
     #HistoryValidation
    And def entityIdData = getDocumentTypeOtherInfoResponse.id
    And def parentEntityId = null
    And def eventName = "DocumentTypeOtherInfoCreated"
    And def evnentType = eventTypes[1]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
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
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetAllTheEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
   
    Examples: 
      | tenantid    |
      | tenantID[0] |
    