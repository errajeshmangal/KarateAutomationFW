@PropertyInformationFeatureE2E
Feature: Property Information -Add,Edit,Get,History,Comment,GetAll,Duplicate

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createPropertyInfoSubCollectionName = 'CreatePropertyInformationSubdivision_'
    And def createPropertyInfoCondoCollectionName = 'CreatePropertyInformationCondo_'
    And def createPropertyInfoLandCollectionName = 'CreatePropertyInformationLand_'
    And def createPropertyInfoSubCollectionNameRead = 'PropertyInformationSubdivisionDetailViewModel_'
    And def createPropertyInfoCondoCollectionNameRead = 'PropertyInformationCondoDetailViewModel_'
    And def createPropertyInfoLandCollectionNameRead = 'PropertyInformationLandDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def propertyType = ['Subdivision', 'Condo','Land']
    And def createCommandType = ['CreatePropertyInformationSubdivision','CreatePropertyInformationCondo','CreatePropertyInformationLand']
    And def updateCommandType = ['UpdatePropertyInformationSubdivision','UpdatePropertyInformationCondo','UpdatePropertyInformationLand']
    And def getCommandType = ['GetPropertyInformationSubdivision','GetPropertyInformationCondo','GetPropertyInformationLand','GetSubdivisionInformationsIdCodeName','GetCondoMaintenancesIdCodeName','GetAreaMaintenancesIdCodeName']
    And def getAllCommandType = 'GetPropertyInformations'
    And def entityName = ['PropertyInformationSubdivision','PropertyInformationCondo','PropertyInformationLand']
    And def SDcollectionNameRead = 'SubdivisionInformationDetailViewModel_'
    And def condoMaintenanceCollectionNameRead = 'CondoMaintenanceDetailViewModel_'
    And def areaMaintenanceCollectionNameRead = 'AreaMaintenanceDetailViewModel_'
    And def createPropertyInfosCollectionNameRead = 'PropertyInformationsDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreatePropertyInformationSubWithAllFieldsAndGetTheDetails
  Scenario Outline: Create property information subdivision with  all the fields and get the details
    Given url readBaseUrl
    When path '/api/GetPropertyInformationSubDivision'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And sleep(10000)
    And set getPropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationSubDivision-v1.001.json"        |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | tenantId        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | getCommandType[0]                                                 |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | getType         | "One"                                                             |
    And set getPropertyInformationSubDivisionCommandBody
      | path |                                                    0 |
      | id   | createPropertyInformationSubDivisionResponse.body.id |
    And set getPropertyInformationSubDivisionPayload
      | path         | [0]                                               |
      | header       | getPropertyInformationSubDivisionCommandHeader[0] |
      | body.request | getPropertyInformationSubDivisionCommandBody[0]   |
    And print getPropertyInformationSubDivisionPayload
    And request getPropertyInformationSubDivisionPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationSubDivisionResponse = response
    And print getPropertyInformationSubDivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoSubCollectionNameRead+<tenantid>,getPropertyInformationSubDivisionResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationSubDivisionResponse.id
    And match getPropertyInformationSubDivisionResponse.part == createPropertyInformationSubDivisionResponse.body.part
    #Get All the Property Information subdivisions
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | getAllCommandType                                |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                          0 |
      | id              |                                                            |
      | propertyType    | propertyType[0]                                            |
      | name            |                                                            |
      | pin             |                                                            |
      | pinToBeAssigned |                                                            |
      | range           |                                                            |
      | block           |                                                            |
      | lot             |                                                            |
      | part            |                                                            |
      | townHomeAddress |                                                            |
      | building        |                                                            |
      | buildingUnit    |                                                            |
      | part1           |                                                            |
      | part2           |                                                            |
      | half            |                                                            |
      | thirdQtr        |                                                            |
      | secondQtr       |                                                            |
      | firstQtr        |                                                            |
      | numofAcreage    |                                                            |
      | section         |                                                            |
      | isActive        | createPropertyInformationSubDivisionResponse.body.isActive |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationSubDivisionResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].propertyType == createPropertyInformationSubDivisionResponse.body.propertyType
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfosCollectionNameRead+<tenantid>,getPropertyInformationSubDivisionResponse.id)
    And print mongoResult
    #History Validation for Record Created
    And def entityIdData = createPropertyInformationSubDivisionResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[0]+historyAndComments[0]
    And def evnentType = entityName[0]
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
    And def entityName = "PropertyInformationSubdivision"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationSubDivisionResponse.body.id
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
    And def evnentType = "PropertyInformationSubdivision"
    And def entityIdData = createPropertyInformationSubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@DeleteEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    #view the comment after delete
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

  @CreatePropertyInformationSubWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create property information subdivision with only mandatory details and Validate
    Given url readBaseUrl
    When path '/api/GetPropertyInformationSubDivision'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubdivisonWithMandatoryDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And sleep(10000)
    And set getPropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationSubDivision-v1.001.json"        |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | getCommandType[0]                                                 |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | getType         | "One"                                                             |
    And set getPropertyInformationSubDivisionCommandBody
      | path       |                                                    0 |
      | request.id | createPropertyInformationSubDivisionResponse.body.id |
    And set getPropertyInformationSubDivisionPayload
      | path   | [0]                                               |
      | header | getPropertyInformationSubDivisionCommandHeader[0] |
      | body   | getPropertyInformationSubDivisionCommandBody[0]   |
    And print getPropertyInformationSubDivisionPayload
    And request getPropertyInformationSubDivisionPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationSubDivisionResponse = response
    And print getPropertyInformationSubDivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoSubCollectionNameRead+<tenantid>,getPropertyInformationSubDivisionResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationSubDivisionResponse.id
    And match getPropertyInformationSubDivisionResponse.block == createPropertyInformationSubDivisionResponse.body.block
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                                 0 |
      | id              |                                                                   |
      | propertyType    | propertyType[0]                                                   |
      | name            | createPropertyInformationSubDivisionResponse.body.name.code       |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin             |
      | pinToBeAssigned | createPropertyInformationSubDivisionResponse.body.pinToBeAssigned |
      | range           | createPropertyInformationSubDivisionResponse.body.range           |
      | block           | createPropertyInformationSubDivisionResponse.body.block           |
      | lot             | createPropertyInformationSubDivisionResponse.body.lot             |
      | part            |                                                                   |
      | townHomeAddress |                                                                   |
      | building        |                                                                   |
      | buildingUnit    |                                                                   |
      | part1           |                                                                   |
      | part2           |                                                                   |
      | thirdQtr        |                                                                   |
      | secondQtr       |                                                                   |
      | firstQtr        |                                                                   |
      | half            |                                                                   |
      | numofAcreage    |                                                                   |
      | section         |                                                                   |
      | isActive        |                                                                   |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationSubDivisionResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].pin == createPropertyInformationSubDivisionResponse.body.pin
    And match each getPropertyInformationsResponse.results[*].lot == createPropertyInformationSubDivisionResponse.body.lot
    And match each getPropertyInformationsResponse.results[*].block == createPropertyInformationSubDivisionResponse.body.block
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
     #History Validation for Record Created
    And def entityIdData = createPropertyInformationSubDivisionResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[0]+historyAndComments[0]
    And def evnentType = entityName[0]
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
    And def entityName = "PropertyInformationSubdivision"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationSubDivisionResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationSubdivision"
    And def entityIdData = createPropertyInformationSubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreatePropertyInfoSubdivisionWithInvalidDataToMandatoryDetails
  Scenario Outline: Create property information subdivision with invalid data to mandatory field
    Given url commandBaseUrl
    And path '/api/CreatePropertyInformationSubdivision'
    #creating a new subdivision info then validating the created id is present in GetSubdivisionInformationsIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchSubDivisionInformation')
    And def getSearchSubDivisionInformantionResponse = result.response
    And print getSearchSubDivisionInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetSubDivisionInformation')
    And def getSubDivisionInformantionResponse = result.response
    And print getSubDivisionInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And print entityIDData
    And set commandPropertyInformationSubDivisionHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationSubdivision-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | createCommandType[0]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | entityVersion   |                                                             1 |
      | entityId        | entityIDData                                                  |
      | commandUserId   | commandUserId                                                 |
      | entityName      | entityName[0]                                                 |
    And set commandPropertyInformationSubDivisionBody
      | path            |                                                 0 |
      | id              | faker.getRandomNumber()                           |
      | propertyType    | propertyType[0]                                   |
      | status          | faker.getRandomPropertyInformationStatus()        |
      | pin             | faker.getRandomPin("Pin")                         |
      | pinToBeAssigned | faker.getRandomBoolean()                          |
      | block           | faker.getFirstName()                              |
      | areaCode        | getSubDivisionInformantionResponse.areaCode.code  |
      | townCode        | getSubDivisionInformantionResponse.townCode       |
      | range           | getSubDivisionInformantionResponse.range          |
      | rangeDirection  | getSubDivisionInformantionResponse.rangeDirection |
      | lot             | faker.getRandomPin("Lot")                         |
      | isActive        | faker.getRandomBoolean()                          |
    And set commandPropertyInformationSubDivisionName
      | path |                                                        0 |
      | id   | getSearchSubDivisionInformantionResponse.results[0].id   |
      | code | getSearchSubDivisionInformantionResponse.results[0].code |
      | name | getSearchSubDivisionInformantionResponse.results[0].name |
    And set addPropertyInformationSubDivisionPayload
      | path      | [0]                                            |
      | header    | commandPropertyInformationSubDivisionHeader[0] |
      | body      | commandPropertyInformationSubDivisionBody[0]   |
      | body.name | commandPropertyInformationSubDivisionName[0]   |
    And print addPropertyInformationSubDivisionPayload
    And request addPropertyInformationSubDivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationSDWithMissingMandatoryDetails
  Scenario Outline: Create property information subdivision with missing mandatory field
    Given url commandBaseUrl
    And path '/api/CreatePropertyInformationSubdivision'
    #creating a new subdivision info then validating the created id is present in GetSubdivisionInformationsIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchSubDivisionInformation')
    And def getSearchSubDivisionInformantionResponse = result.response
    And print getSearchSubDivisionInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetSubDivisionInformation')
    And def getSubDivisionInformantionResponse = result.response
    And print getSubDivisionInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationSubDivisionHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationSubdivision-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantID        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | createCommandType[0]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | entityVersion   |                                                             1 |
      | entityID        | entityIDData                                                  |
      | commandUserId   | commandUserId                                                 |
      | entityName      | entityName[0]                                                 |
    # lot mandate field is not passed
    And set commandPropertyInformationSubDivisionBody
      | path            |                                                 0 |
      | id              | entityIDData                                      |
      | propertyType    | propertyType[0]                                   |
      | status          | faker.getRandomPropertyInformationStatus()        |
      | pin             | faker.getRandomPin("Pin")                         |
      | pinToBeAssigned | faker.getRandomBoolean()                          |
      | block           | faker.getFirstName()                              |
      | areaCode        | getSubDivisionInformantionResponse.areaCode.code  |
      | townCode        | getSubDivisionInformantionResponse.townCode       |
      | range           | getSubDivisionInformantionResponse.range          |
      | rangeDirection  | getSubDivisionInformantionResponse.rangeDirection |
      | isActive        | faker.getRandomBoolean()                          |
    And set commandPropertyInformationSubDivisionName
      | path      | [0]                                            |
      | header    | commandPropertyInformationSubDivisionHeader[0] |
      | body      | commandPropertyInformationSubDivisionBody[0]   |
      | body.name | commandPropertyInformationSubDivisionName[0]   |
    And set addPropertyInformationSubDivisionPayload
      | path      | [0]                                            |
      | header    | commandPropertyInformationSubDivisionHeader[0] |
      | body      | commandPropertyInformationSubDivisionBody[0]   |
      | body.name | commandPropertyInformationSubDivisionName[0]   |
    And print addPropertyInformationSubDivisionPayload
    And request addPropertyInformationSubDivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoWithAllFieldsAndGetTheDetails
  Scenario Outline: Create property information Condo with  all the fields and get the details
    Given url readBaseUrl
    When path '/api/GetPropertyInformationCondo'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And sleep(10000)
    And set getPropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationCondo-v1.001.json"        |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | getCommandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | entityVersion   |                                                           1 |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | getType         | "One"                                                       |
    And set getPropertyInformationCondoCommandBody
      | path       |                                              0 |
      | request.id | createPropertyInformationCondoResponse.body.id |
    And set getPropertyInformationCondoPayload
      | path   | [0]                                         |
      | header | getPropertyInformationCondoCommandHeader[0] |
      | body   | getPropertyInformationCondoCommandBody[0]   |
    And print getPropertyInformationCondoPayload
    And request getPropertyInformationCondoPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationCondoResponse = response
    And print getPropertyInformationCondoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoCondoCollectionNameRead+<tenantid>,getPropertyInformationCondoResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationCondoResponse.id
    And match getPropertyInformationCondoResponse.notInSidwell == createPropertyInformationCondoResponse.body.notInSidwell
    #Get All the Property Information Condos
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                    0 |
      | id              |                                                      |
      | propertyType    | propertyType[1]                                      |
      | name            |                                                      |
      | pin             |                                                      |
      | pinToBeAssigned |                                                      |
      | range           |                                                      |
      | block           |                                                      |
      | lot             |                                                      |
      | part            |                                                      |
      | townHomeAddress |                                                      |
      | building        |                                                      |
      | buildingUnit    |                                                      |
      | part1           |                                                      |
      | part2           |                                                      |
      | half            |                                                      |
      | thirdQtr        |                                                      |
      | secondQtr       |                                                      |
      | firstQtr        |                                                      |
      | numofAcreage    |                                                      |
      | section         |                                                      |
      | isActive        | createPropertyInformationCondoResponse.body.isActive |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationCondoResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].propertyType == createPropertyInformationCondoResponse.body.propertyType
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #History Validation for Record Created
    And def entityIdData = createPropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[1]+historyAndComments[0]
    And def evnentType = entityName[1]
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
    And def entityName = "PropertyInformationCondo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationCondoResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationCondo"
    And def entityIdData = createPropertyInformationCondoResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreatePropertyInformationCondoWithMandateFieldsAndGetTheDetails
  Scenario Outline: Create property information Condo with only mandatory details and Validate
    Given url readBaseUrl
    When path '/api/GetPropertyInformationCondo'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithMandatoryDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And sleep(10000)
    And set getPropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationCondo-v1.001.json"        |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | getCommandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | getType         | "One"                                                       |
    And set getPropertyInformationCondoCommandBody
      | path       |                                              0 |
      | request.id | createPropertyInformationCondoResponse.body.id |
    And set getPropertyInformationCondoPayload
      | path   | [0]                                         |
      | header | getPropertyInformationCondoCommandHeader[0] |
      | body   | getPropertyInformationCondoCommandBody[0]   |
    And print getPropertyInformationCondoPayload
    And request getPropertyInformationCondoPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationCondoResponse = response
    And print getPropertyInformationCondoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoCondoCollectionNameRead+<tenantid>,getPropertyInformationCondoResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationCondoResponse.id
    And match getPropertyInformationCondoResponse.building == createPropertyInformationCondoResponse.body.building
    #Get All the Property Information Condos
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                        0 |
      | id              |                                                          |
      | propertyType    | propertyType[1]                                          |
      | name            |                                                          |
      | pin             |                                                          |
      | pinToBeAssigned |                                                          |
      | range           |                                                          |
      | block           |                                                          |
      | lot             |                                                          |
      | part            |                                                          |
      | townHomeAddress |                                                          |
      | building        | createPropertyInformationCondoResponse.body.building     |
      | buildingUnit    | createPropertyInformationCondoResponse.body.buildingUnit |
      | part1           |                                                          |
      | part2           |                                                          |
      | thirdQtr        |                                                          |
      | secondQtr       |                                                          |
      | firstQtr        |                                                          |
      | half            |                                                          |
      | numofAcreage    |                                                          |
      | section         |                                                          |
      | isActive        | createPropertyInformationCondoResponse.body.isActive     |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationCondoResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].building == createPropertyInformationCondoResponse.body.building
    And match each getPropertyInformationsResponse.results[*].buildingUnit == createPropertyInformationCondoResponse.body.buildingUnit
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #History Validation for Record Created
    And def entityIdData = createPropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[1]+historyAndComments[0]
    And def evnentType = entityName[1]
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
    And def entityName = "PropertyInformationCondo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationCondoResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationCondo"
    And def entityIdData = createPropertyInformationCondoResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreatePropertyInfoCondoWithInvalidDataToMandatoryDetails
  Scenario Outline: Create property information condo  with invalid data to mandatory field
    Given url commandBaseUrl
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And path '/api/CreatePropertyInformationCondo'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationCondoHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    And set commandPropertyInformationCondoBody
      | path            |                                           0 |
      | id              | faker.getRandomNumber()                     |
      | propertyType    | propertyType[1]                             |
      | status          | faker.getRandomPropertyInformationStatus()  |
      | areaCode        | getCondoInformantionResponse.areaCode.code  |
      | townCode        | getCondoInformantionResponse.townCode       |
      | range           | getCondoInformantionResponse.townCode       |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection |
      | pin             | faker.getRandomPin("Pin")                   |
      | pinToBeAssigned | faker.getRandomBoolean()                    |
      | building        | faker.getFirstName()                        |
      | buildingUnit    | faker.getRandomPin("Lot")                   |
      | isActive        | faker.getRandomBoolean()                    |
    And set commandPropertyInformationCondoName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set addPropertyInformationCondoPayload
      | path      | [0]                                      |
      | header    | commandPropertyInformationCondoHeader[0] |
      | body      | commandPropertyInformationCondoBody[0]   |
      | body.name | commandPropertyInformationCondoName[0]   |
    And print addPropertyInformationCondoPayload
    And request addPropertyInformationCondoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoWithMissingMandatoryDetails
  Scenario Outline: Create property information condo with missing mandatory field
    Given url commandBaseUrl
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And path '/api/CreatePropertyInformationCondo'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationCondoHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    # not passing buildingUnit
    And set commandPropertyInformationCondoBody
      | path            |                                           0 |
      | id              | entityIDData                                |
      | propertyType    | propertyType[1]                             |
      | status          | faker.getRandomPropertyInformationStatus()  |
      | pin             | faker.getRandomPin("Pin")                   |
      | pinToBeAssigned | faker.getRandomBoolean()                    |
      | building        | faker.getFirstName()                        |
      | areaCode        | getCondoInformantionResponse.areaCode.code  |
      | townCode        | getCondoInformantionResponse.townCode       |
      | range           | getCondoInformantionResponse.range          |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection |
      | isActive        | faker.getRandomBoolean()                    |
    And set commandPropertyInformationCondoName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set addPropertyInformationCondoPayload
      | path      | [0]                                      |
      | header    | commandPropertyInformationCondoHeader[0] |
      | body      | commandPropertyInformationCondoBody[0]   |
      | body.name | commandPropertyInformationCondoName[0]   |
    And print addPropertyInformationCondoPayload
    And request addPropertyInformationCondoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationLandWithAllFieldsAndGetTheDetails
  Scenario Outline: Create property information Land with  all the fields and get the details
    Given url readBaseUrl
    When path '/api/GetPropertyInformationLand'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And sleep(10000)
    And set getPropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationLand-v1.001.json"        |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | tenantId        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | getCommandType[2]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | getType         | "One"                                                      |
    And set getPropertyInformationLandCommandBody
      | path       |                                             0 |
      | request.id | createPropertyInformationLandResponse.body.id |
    And set getPropertyInformationLandPayload
      | path   | [0]                                        |
      | header | getPropertyInformationLandCommandHeader[0] |
      | body   | getPropertyInformationLandCommandBody[0]   |
    And print getPropertyInformationLandPayload
    And request getPropertyInformationLandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationLandResponse = response
    And print getPropertyInformationLandResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoLandCollectionNameRead+<tenantid>,getPropertyInformationLandResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationLandResponse.id
    And match getPropertyInformationLandResponse.quarters == createPropertyInformationLandResponse.body.quarters
    #Get All the Property Information Lands
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                   0 |
      | id              |                                                     |
      | propertyType    | propertyType[2]                                     |
      | name            |                                                     |
      | pin             |                                                     |
      | pinToBeAssigned |                                                     |
      | range           |                                                     |
      | block           |                                                     |
      | lot             |                                                     |
      | part            |                                                     |
      | townHomeAddress |                                                     |
      | building        |                                                     |
      | buildingUnit    |                                                     |
      | part1           |                                                     |
      | part2           |                                                     |
      | thirdQtr        |                                                     |
      | secondQtr       |                                                     |
      | half            |                                                     |
      | firstQtr        |                                                     |
      | numofAcreage    |                                                     |
      | section         |                                                     |
      | isActive        | createPropertyInformationLandResponse.body.isActive |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationLandResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].propertyType == createPropertyInformationLandResponse.body.propertyType
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #History Validation for Record Created
    And def entityIdData = createPropertyInformationLandResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[2]+historyAndComments[0]
    And def evnentType = entityName[2]
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
    And def entityName = "PropertyInformationLand"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationLandResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationLand"
    And def entityIdData = createPropertyInformationLandResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreatePropertyInformationLandWithMandateFieldsAndGetTheDetails
  Scenario Outline: Create property information Land with only mandatory details and Validate
    Given url readBaseUrl
    When path '/api/GetPropertyInformationLand'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithMandatoryDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And sleep(10000)
    And set getPropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationLand-v1.001.json"        |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | getCommandType[2]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | getType         | "One"                                                      |
    And set getPropertyInformationLandCommandBody
      | path       |                                             0 |
      | request.id | createPropertyInformationLandResponse.body.id |
    And set getPropertyInformationLandPayload
      | path   | [0]                                        |
      | header | getPropertyInformationLandCommandHeader[0] |
      | body   | getPropertyInformationLandCommandBody[0]   |
    And print getPropertyInformationLandPayload
    And request getPropertyInformationLandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationLandResponse = response
    And print getPropertyInformationLandResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoLandCollectionNameRead+<tenantid>,getPropertyInformationLandResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationLandResponse.id
    And match getPropertyInformationLandResponse.part1 == createPropertyInformationLandResponse.body.part1
    #Get All the Property Information Lands
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                0 |
      | id              |                                                  |
      | propertyType    | propertyType[2]                                  |
      | name            |                                                  |
      | pin             | createPropertyInformationLandResponse.body.pin   |
      | pinToBeAssigned |                                                  |
      | range           |                                                  |
      | block           |                                                  |
      | lot             |                                                  |
      | part            |                                                  |
      | townHomeAddress |                                                  |
      | building        |                                                  |
      | buildingUnit    |                                                  |
      | part1           | createPropertyInformationLandResponse.body.part1 |
      | part2           | createPropertyInformationLandResponse.body.part2 |
      | half            |                                                  |
      | thirdQtr        |                                                  |
      | secondQtr       |                                                  |
      | firstQtr        |                                                  |
      | numofAcreage    |                                                  |
      | section         |                                                  |
      | isActive        |                                                  |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == createPropertyInformationLandResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].part1 == createPropertyInformationLandResponse.body.part1
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #History Validation for Record Created
    And def entityIdData = createPropertyInformationLandResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[2]+historyAndComments[0]
    And def evnentType = entityName[2]
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
    And def entityName = "PropertyInformationLand"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = createPropertyInformationLandResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationLand"
    And def entityIdData = createPropertyInformationLandResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @CreatePropertyInfoLandWithInvalidDataToMandatoryDetails
  Scenario Outline: Create property information land with invalid data to mandatory field
    Given url commandBaseUrl
    #creating a new Land info then validating the created id
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchLandInformation')
    And def getSearchLandInformantionResponse = result.response
    And print getSearchLandInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCountyMaintenance')
    And def getLandInformantionResponse = result.response
    And print getLandInformantionResponse
    And path '/api/CreatePropertyInformationLand'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationLandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationLand-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantID        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | createCommandType[2]                                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | entityVersion   |                                                      1 |
      | entityID        | entityIDData                                           |
      | commandUserId   | commandUserId                                          |
      | entityName      | entityName[2]                                          |
    And set commandPropertyInformationLandBody
      | path            |                                          0 |
      | id              | faker.getRandomNumber()                    |
      | propertyType    | propertyType[2]                            |
      | status          | faker.getRandomPropertyInformationStatus() |
      | areaCode        | getLandInformantionResponse.areaCode       |
      | townCode        | getLandInformantionResponse.townCode       |
      | range           | getLandInformantionResponse.range          |
      | rangeDirection  | getLandInformantionResponse.rangeDirection |
      | pin             | faker.getRandomPin("Pin")                  |
      | pinToBeAssigned | faker.getRandomBoolean()                   |
      | part1           | faker.getFirstName()                       |
      | part2           | faker.getFirstName()                       |
      | isActive        | faker.getRandomBoolean()                   |
    And set commandPropertyInformationLandName
      | path |                                                 0 |
      | id   | getSearchLandInformantionResponse.results[0].id   |
      | code | getSearchLandInformantionResponse.results[0].code |
      | name | getSearchLandInformantionResponse.results[0].name |
    And set addPropertyInformationLandPayload
      | path      | [0]                                     |
      | header    | commandPropertyInformationLandHeader[0] |
      | body      | commandPropertyInformationLandBody[0]   |
      | body.name | commandPropertyInformationLandName[0]   |
    And print addPropertyInformationLandPayload
    And request addPropertyInformationLandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationLandWithMissingMandatoryDetails
  Scenario Outline: Create property information Land with missing mandatory field
    Given url commandBaseUrl
    #creating a new Land info then validating the created id
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchLandInformation')
    And def getSearchLandInformantionResponse = result.response
    And print getSearchLandInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCountyMaintenance')
    And def getLandInformantionResponse = result.response
    And print getLandInformantionResponse
    And path '/api/CreatePropertyInformationLand'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationLandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationLand-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantID        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | createCommandType[2]                                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | entityVersion   |                                                      1 |
      | entityID        | entityIDData                                           |
      | commandUserId   | commandUserId                                          |
      | entityName      | entityName[2]                                          |
    # part2 field is missing
    And set commandPropertyInformationLandBody
      | path            |                                          0 |
      | id              | entityIDData                               |
      | propertyType    | propertyType[2]                            |
      | status          | faker.getRandomPropertyInformationStatus() |
      | pin             | faker.getRandomPin("Pin")                  |
      | pinToBeAssigned | faker.getRandomBoolean()                   |
      | part1           | faker.getFirstName()                       |
      | isActive        | faker.getRandomBoolean()                   |
    And set commandPropertyInformationLandName
      | path |                                                 0 |
      | id   | getSearchLandInformantionResponse.results[0].id   |
      | code | getSearchLandInformantionResponse.results[0].code |
      | name | getSearchLandInformantionResponse.results[0].name |
    And set addPropertyInformationLandPayload
      | path      | [0]                                     |
      | header    | commandPropertyInformationLandHeader[0] |
      | body      | commandPropertyInformationLandBody[0]   |
      | body.name | commandPropertyInformationLandName[0]   |
    And print addPropertyInformationLandPayload
    And request addPropertyInformationLandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationSubdivisionWithAllFields
  Scenario Outline: Update a property information subdivision with all the details
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationSubdivision'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And set updatePropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationSubdivision-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                        |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | entityId        | createPropertyInformationSubDivisionResponse.header.entityId      |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | entityVersion   |                                                                 1 |
      | tags            | []                                                                |
      | commandType     | updateCommandType[0]                                              |
      | entityName      | entityName[0]                                                     |
      | ttl             |                                                                 0 |
    And set updatePropertyInformationSubDivisionCommandBody
      | path            |                                                                0 |
      | id              | createPropertyInformationSubDivisionResponse.header.entityId     |
      | propertyType    | createPropertyInformationSubDivisionResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                       |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin            |
      | pinToBeAssigned | faker.getRandomBoolean()                                         |
      | areaCode        | createPropertyInformationSubDivisionResponse.body.areaCode       |
      | townCode        | createPropertyInformationSubDivisionResponse.body.townCode       |
      | range           | createPropertyInformationSubDivisionResponse.body.range          |
      | rangeDirection  | createPropertyInformationSubDivisionResponse.body.rangeDirection |
      | block           | faker.getFirstName()                                             |
      | lot             | faker.getRandomPin("Lot")                                        |
      | part            | faker.getFirstName()                                             |
      | townHomeAddress | faker.getFirstName()                                             |
      | notInSidwell    | faker.getFirstName()                                             |
      | isActive        | faker.getRandomBoolean()                                         |
    And set updatePropertyInformationSubDivisionCommandName
      | path |                                                           0 |
      | id   | createPropertyInformationSubDivisionResponse.body.name.id   |
      | code | createPropertyInformationSubDivisionResponse.body.name.code |
      | name | createPropertyInformationSubDivisionResponse.body.name.name |
    And set updatePropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | updatePropertyInformationSubDivisionCommandHeader[0] |
      | body      | updatePropertyInformationSubDivisionCommandBody[0]   |
      | body.name | updatePropertyInformationSubDivisionCommandName[0]   |
    And print updatePropertyInformationSubDivisionPayload
    And request updatePropertyInformationSubDivisionPayload
    When method POST
    Then status 201
    And def updatePropertyInformationSubDivisionResponse = response
    And print updatePropertyInformationSubDivisionResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoSubCollectionName+<tenantid>,updatePropertyInformationSubDivisionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationSubDivisionResponse.body.id
    And match updatePropertyInformationSubDivisionResponse.body.block == updatePropertyInformationSubDivisionPayload.body.block
    #get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationSubdivision'
    And set getPropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationSubdivision-v1.001.json"        |
      | version         | "1.001"                                                           |
      | sourceId        | updatePropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | updatePropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | updatePropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | getCommandType[0]                                                 |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | commandUserId   | updatePropertyInformationSubDivisionResponse.header.commandUserId |
      | getType         | "One"                                                             |
    And set getPropertyInformationSubDivisionCommandBody
      | path       |                                                    0 |
      | request.id | updatePropertyInformationSubDivisionResponse.body.id |
    And set getPropertyInformationSubDivisionPayload
      | path   | [0]                                               |
      | header | getPropertyInformationSubDivisionCommandHeader[0] |
      | body   | getPropertyInformationSubDivisionCommandBody[0]   |
    And print getPropertyInformationSubDivisionPayload
    And request getPropertyInformationSubDivisionPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationSubDivisionResponse = response
    And print getPropertyInformationSubDivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoSubCollectionNameRead+<tenantid>,getPropertyInformationSubDivisionResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationSubDivisionResponse.id
    And match getPropertyInformationSubDivisionResponse.lot == updatePropertyInformationSubDivisionResponse.body.lot
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                       0 |
      | id              |                                                         |
      | propertyType    | propertyType[0]                                         |
      | name            |                                                         |
      | pin             |                                                         |
      | pinToBeAssigned |                                                         |
      | range           | updatePropertyInformationSubDivisionResponse.body.range |
      | block           |                                                         |
      | lot             |                                                         |
      | part            | updatePropertyInformationSubDivisionResponse.body.part  |
      | townHomeAddress |                                                         |
      | building        |                                                         |
      | buildingUnit    |                                                         |
      | part1           |                                                         |
      | part2           |                                                         |
      | thirdQtr        |                                                         |
      | secondQtr       |                                                         |
      | half            |                                                         |
      | firstQtr        |                                                         |
      | numofAcreage    |                                                         |
      | section         |                                                         |
      | isActive        |                                                         |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationSubDivisionResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].part == updatePropertyInformationSubDivisionResponse.body.part
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
  
    #HistoryValidation
    And def entityIdData = updatePropertyInformationSubDivisionResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[0]+historyAndComments[1]
    And def evnentType = entityName[0]
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
    #Adding the comment
    And def entityName = "PropertyInformationSubdivision"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationSubDivisionResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationSubdivision"
    And def entityIdData = updatePropertyInformationSubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInfoSubdivisionWithMandatoryDetails
  Scenario Outline: Update property information subdivision with mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationSubdivision'
    #Create a property information having property type as Subdivision
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubdivisonWithMandatoryDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And set updatePropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationSubdivision-v1.001.json"     |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | updateCommandType[0]                                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | entityVersion   |                                                                 1 |
      | entityID        | createPropertyInformationSubDivisionResponse.header.entityId      |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | entityName      | entityName[0]                                                     |
    And set updatePropertyInformationSubDivisionCommandBody
      | path            |                                                              0 |
      | id              | createPropertyInformationSubDivisionResponse.header.entityId   |
      | propertyType    | createPropertyInformationSubDivisionResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()                     |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                       |
      | block           | faker.getFirstName()                                           |
      | lot             | faker.getRandomPin("Lot")                                      |
      | isActive        | faker.getRandomBoolean()                                       |
    And set updatePropertyInformationSubDivisionCommandName
      | path |                                                           0 |
      | id   | createPropertyInformationSubDivisionResponse.body.name.id   |
      | code | createPropertyInformationSubDivisionResponse.body.name.code |
      | name | createPropertyInformationSubDivisionResponse.body.name.name |
    And set updatePropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | updatePropertyInformationSubDivisionCommandHeader[0] |
      | body      | updatePropertyInformationSubDivisionCommandBody[0]   |
      | body.name | updatePropertyInformationSubDivisionCommandName[0]   |
    And print updatePropertyInformationSubDivisionPayload
    And request updatePropertyInformationSubDivisionPayload
    When method POST
    Then status 201
    And def updatePropertyInformationSubDivisionResponse = response
    And print updatePropertyInformationSubDivisionResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoSubCollectionName+<tenantid>,updatePropertyInformationSubDivisionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationSubDivisionResponse.body.id
    # get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationSubdivision'
    And set getPropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationSubdivision-v1.001.json"        |
      | version         | "1.001"                                                           |
      | sourceId        | updatePropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | updatePropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | updatePropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | getCommandType[0]                                                 |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | commandUserId   | updatePropertyInformationSubDivisionResponse.header.commandUserId |
      | getType         | "One"                                                             |
    And set getPropertyInformationSubDivisionCommandBody
      | path       |                                                    0 |
      | request.id | updatePropertyInformationSubDivisionResponse.body.id |
    And set getPropertyInformationSubDivisionPayload
      | path   | [0]                                               |
      | header | getPropertyInformationSubDivisionCommandHeader[0] |
      | body   | getPropertyInformationSubDivisionCommandBody[0]   |
    And print getPropertyInformationSubDivisionPayload
    And request getPropertyInformationSubDivisionPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationSubDivisionResponse = response
    And print getPropertyInformationSubDivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoSubCollectionNameRead+<tenantid>,getPropertyInformationSubDivisionResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationSubDivisionResponse.id
    And match getPropertyInformationSubDivisionResponse.block == updatePropertyInformationSubDivisionResponse.body.block
    #Get All the Property Information subdivisions
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                          0 |
      | id              |                                                            |
      | propertyType    | propertyType[0]                                            |
      | name            |                                                            |
      | pin             |                                                            |
      | pinToBeAssigned |                                                            |
      | range           |                                                            |
      | block           | updatePropertyInformationSubDivisionResponse.body.block    |
      | lot             | updatePropertyInformationSubDivisionResponse.body.lot      |
      | part            |                                                            |
      | townHomeAddress |                                                            |
      | building        |                                                            |
      | buildingUnit    |                                                            |
      | part1           |                                                            |
      | part2           |                                                            |
      | thirdQtr        |                                                            |
      | secondQtr       |                                                            |
      | half            |                                                            |
      | firstQtr        |                                                            |
      | numofAcreage    |                                                            |
      | section         |                                                            |
      | isActive        | updatePropertyInformationSubDivisionResponse.body.isActive |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationSubDivisionResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].block == updatePropertyInformationSubDivisionResponse.body.block
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #HistoryValidation
    And def entityIdData = updatePropertyInformationSubDivisionResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[0]+historyAndComments[1]
    And def evnentType = entityName[0]
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
    #Adding the comment
    And def entityName = "PropertyInformationSubdivision"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationSubDivisionResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationSubdivision"
    And def entityIdData = updatePropertyInformationSubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInfoSubDivisionWithInvalidDataToMandatoryDetails
  Scenario Outline: Update property information subdivision with invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationSubdivision'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And set updatePropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationSubdivision-v1.001.json"     |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | updateCommandType[0]                                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | entityVersion   |                                                                 1 |
      | entityID        | createPropertyInformationSubDivisionResponse.header.entityId      |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | entityName      | entityName[0]                                                     |
    And set updatePropertyInformationSubDivisionCommandBody
      | path            |                                                              0 |
      | id              | faker.getRandomNumber()                                        |
      | propertyType    | createPropertyInformationSubDivisionResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()                     |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                       |
      | block           | faker.getFirstName()                                           |
      | lot             | faker.getRandomPin("Lot")                                      |
      | isActive        | faker.getRandomBoolean()                                       |
    And set updatePropertyInformationSubDivisionCommandName
      | path |                                                           0 |
      | id   | createPropertyInformationSubDivisionResponse.body.name.id   |
      | code | createPropertyInformationSubDivisionResponse.body.name.code |
      | name | createPropertyInformationSubDivisionResponse.body.name.name |
    And set updatePropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | updatePropertyInformationSubDivisionCommandHeader[0] |
      | body      | updatePropertyInformationSubDivisionCommandBody[0]   |
      | body.name | updatePropertyInformationSubDivisionCommandName[0]   |
    And print updatePropertyInformationSubDivisionPayload
    And request updatePropertyInformationSubDivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationSubDivisionWithMissingMandatoryDetails
  Scenario Outline: Update property information subdivision with missing mandatory field
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationSubdivision'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    And sleep(10000)
    And set updatePropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationSubdivision-v1.001.json"     |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | tenantID        | <tenantid>                                                        |
      | ttl             |                                                                 0 |
      | commandType     | updateCommandType[0]                                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | tags            | []                                                                |
      | entityVersion   |                                                                 1 |
      | entityID        | createPropertyInformationSubDivisionResponse.header.entityId      |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | entityName      | entityName[0]                                                     |
    # lot is missing
    And set updatePropertyInformationSubDivisionCommandBody
      | path            |                                                              0 |
      | id              | createPropertyInformationSubDivisionResponse.header.entityId   |
      | propertyType    | createPropertyInformationSubDivisionResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()                     |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                       |
      | block           | faker.getFirstName()                                           |
      | isActive        | faker.getRandomBoolean()                                       |
    And set updatePropertyInformationSubDivisionCommandName
      | path |                                                           0 |
      | id   | createPropertyInformationSubDivisionResponse.body.name.id   |
      | code | createPropertyInformationSubDivisionResponse.body.name.code |
      | name | createPropertyInformationSubDivisionResponse.body.name.name |
    And set updatePropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | updatePropertyInformationSubDivisionCommandHeader[0] |
      | body      | updatePropertyInformationSubDivisionCommandBody[0]   |
      | body.name | updatePropertyInformationSubDivisionCommandName[0]   |
    And print updatePropertyInformationSubDivisionPayload
    And request updatePropertyInformationSubDivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationCondoWithAllFields
  Scenario Outline: Update a property information condo with all the details
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationCondo'
    #Create a property information having property type as Condo
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And set updatePropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationCondo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                  |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | entityId        | createPropertyInformationCondoResponse.header.entityId      |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | entityVersion   |                                                           1 |
      | tags            | []                                                          |
      | commandType     | updateCommandType[1]                                        |
      | entityName      | entityName[1]                                               |
      | ttl             |                                                           0 |
    And set updatePropertyInformationCondoCommandBody
      | path            |                                                          0 |
      | id              | createPropertyInformationCondoResponse.header.entityId     |
      | propertyType    | createPropertyInformationCondoResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                 |
      | pin             | createPropertyInformationCondoResponse.body.pin            |
      | pinToBeAssigned | faker.getRandomBoolean()                                   |
      | areaCode        | createPropertyInformationCondoResponse.body.areaCode       |
      | townCode        | createPropertyInformationCondoResponse.body.townCode       |
      | range           | createPropertyInformationCondoResponse.body.range          |
      | rangeDirection  | createPropertyInformationCondoResponse.body.rangeDirection |
      | building        | faker.getFirstName()                                       |
      | buildingUnit    | faker.getRandomPin("Lot")                                  |
      | phase           | faker.getFirstName()                                       |
      | garage          | faker.getRandomPin("Lot")                                  |
      | notInSidwell    | faker.getFirstName()                                       |
      | isActive        | faker.getRandomBoolean()                                   |
    And set updatePropertyInformationCondoCommandName
      | path |                                                     0 |
      | id   | createPropertyInformationCondoResponse.body.name.id   |
      | code | createPropertyInformationCondoResponse.body.name.code |
      | name | createPropertyInformationCondoResponse.body.name.name |
    And set updatePropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | updatePropertyInformationCondoCommandHeader[0] |
      | body      | updatePropertyInformationCondoCommandBody[0]   |
      | body.name | updatePropertyInformationCondoCommandName[0]   |
    And print updatePropertyInformationCondoPayload
    And request updatePropertyInformationCondoPayload
    When method POST
    Then status 201
    And def updatePropertyInformationCondoResponse = response
    And print updatePropertyInformationCondoResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoCondoCollectionName+<tenantid>,updatePropertyInformationCondoResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationCondoResponse.body.id
    And match updatePropertyInformationCondoResponse.body.building == updatePropertyInformationCondoPayload.body.building
    # get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationCondo'
    And set getPropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationCondo-v1.001.json"        |
      | version         | "1.001"                                                     |
      | sourceId        | updatePropertyInformationCondoResponse.header.sourceId      |
      | id              | updatePropertyInformationCondoResponse.header.id            |
      | correlationId   | updatePropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | getCommandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | commandUserId   | updatePropertyInformationCondoResponse.header.commandUserId |
      | getType         | "One"                                                       |
    And set getPropertyInformationCondoCommandBody
      | path       |                                              0 |
      | request.id | updatePropertyInformationCondoResponse.body.id |
    And set getPropertyInformationCondoPayload
      | path   | [0]                                         |
      | header | getPropertyInformationCondoCommandHeader[0] |
      | body   | getPropertyInformationCondoCommandBody[0]   |
    And print getPropertyInformationCondoPayload
    And request getPropertyInformationCondoPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationCondoResponse = response
    And print getPropertyInformationCondoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoCondoCollectionNameRead+<tenantid>,getPropertyInformationCondoResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationCondoResponse.id
    And match getPropertyInformationCondoResponse.buildingUnit == updatePropertyInformationCondoResponse.body.buildingUnit
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                    0 |
      | id              |                                                      |
      | propertyType    | propertyType[1]                                      |
      | name            |                                                      |
      | pin             |                                                      |
      | pinToBeAssigned |                                                      |
      | range           |                                                      |
      | block           |                                                      |
      | lot             |                                                      |
      | part            |                                                      |
      | townHomeAddress |                                                      |
      | building        | updatePropertyInformationCondoResponse.body.building |
      | buildingUnit    |                                                      |
      | part1           |                                                      |
      | part2           |                                                      |
      | thirdQtr        |                                                      |
      | half            |                                                      |
      | secondQtr       |                                                      |
      | firstQtr        |                                                      |
      | numofAcreage    |                                                      |
      | section         |                                                      |
      | isActive        | updatePropertyInformationCondoResponse.body.isActive |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationCondoResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].building == updatePropertyInformationCondoResponse.body.building
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #HistoryValidation
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[1]+historyAndComments[1]
    And def evnentType = entityName[1]
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
    #Adding the comment
    And def entityName = "PropertyInformationCondo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationCondoResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationCondo"
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInformationCondoWithMandatoryDetails
  Scenario Outline: Update property information condo with mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationCondo'
    #Create a property information having property type as Condo
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithMandatoryDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And set updatePropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationCondo-v1.001.json"     |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | updateCommandType[1]                                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | entityVersion   |                                                           1 |
      | entityID        | createPropertyInformationCondoResponse.header.entityId      |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | entityName      | entityName[1]                                               |
    And set updatePropertyInformationCondoCommandBody
      | path            |                                                        0 |
      | id              | createPropertyInformationCondoResponse.header.entityId   |
      | propertyType    | createPropertyInformationCondoResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()               |
      | pin             | createPropertyInformationCondoResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                 |
      | building        | faker.getFirstName()                                     |
      | buildingUnit    | faker.getRandomPin("Lot")                                |
      | isActive        | faker.getRandomBoolean()                                 |
    And set updatePropertyInformationCondoCommandName
      | path |                                                     0 |
      | id   | createPropertyInformationCondoResponse.body.name.id   |
      | code | createPropertyInformationCondoResponse.body.name.code |
      | name | createPropertyInformationCondoResponse.body.name.name |
    And set updatePropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | updatePropertyInformationCondoCommandHeader[0] |
      | body      | updatePropertyInformationCondoCommandBody[0]   |
      | body.name | updatePropertyInformationCondoCommandName[0]   |
    And print updatePropertyInformationCondoPayload
    And request updatePropertyInformationCondoPayload
    When method POST
    Then status 201
    And def updatePropertyInformationCondoResponse = response
    And print updatePropertyInformationCondoResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoCondoCollectionName+<tenantid>,updatePropertyInformationCondoResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationCondoResponse.body.id
    And match updatePropertyInformationCondoResponse.body.buildingUnit == updatePropertyInformationCondoPayload.body.buildingUnit
    # get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationCondo'
    And set getPropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationCondo-v1.001.json"        |
      | version         | "1.001"                                                     |
      | sourceId        | updatePropertyInformationCondoResponse.header.sourceId      |
      | id              | updatePropertyInformationCondoResponse.header.id            |
      | correlationId   | updatePropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | getCommandType[1]                                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | commandUserId   | updatePropertyInformationCondoResponse.header.commandUserId |
      | getType         | "One"                                                       |
    And set getPropertyInformationCondoCommandBody
      | path       |                                              0 |
      | request.id | updatePropertyInformationCondoResponse.body.id |
    And set getPropertyInformationCondoPayload
      | path   | [0]                                         |
      | header | getPropertyInformationCondoCommandHeader[0] |
      | body   | getPropertyInformationCondoCommandBody[0]   |
    And print getPropertyInformationCondoPayload
    And request getPropertyInformationCondoPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationCondoResponse = response
    And print getPropertyInformationCondoResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoCondoCollectionNameRead+<tenantid>,getPropertyInformationCondoResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationCondoResponse.id
    And match getPropertyInformationCondoResponse.pinToBeAssigned == updatePropertyInformationCondoResponse.body.pinToBeAssigned
    And match getPropertyInformationCondoResponse.building == updatePropertyInformationCondoResponse.body.building
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                        0 |
      | id              |                                                          |
      | propertyType    | propertyType[1]                                          |
      | name            |                                                          |
      | pin             |                                                          |
      | pinToBeAssigned |                                                          |
      | range           |                                                          |
      | block           |                                                          |
      | lot             |                                                          |
      | part            |                                                          |
      | townHomeAddress |                                                          |
      | building        |                                                          |
      | buildingUnit    | updatePropertyInformationCondoResponse.body.buildingUnit |
      | part1           |                                                          |
      | part2           |                                                          |
      | thirdQtr        |                                                          |
      | secondQtr       |                                                          |
      | firstQtr        |                                                          |
      | half            |                                                          |
      | numofAcreage    |                                                          |
      | section         |                                                          |
      | isActive        | updatePropertyInformationCondoResponse.body.isActive     |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationCondoResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].buildingUnit == updatePropertyInformationCondoResponse.body.buildingUnit
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
   #HistoryValidation
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[1]+historyAndComments[1]
    And def evnentType = entityName[1]
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
    #Adding the comment
    And def entityName = "PropertyInformationCondo"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationCondoResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationCondo"
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInformationCondoWithMissingMandatoryDetails
  Scenario Outline: Update property information subdivision with missing mandatory field
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationCondo'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And set updatePropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationCondo-v1.001.json"     |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | updateCommandType[1]                                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | entityVersion   |                                                           1 |
      | entityID        | createPropertyInformationCondoResponse.header.entityId      |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | entityName      | entityName[1]                                               |
    #builiding is missing
    And set updatePropertyInformationCondoCommandBody
      | path            |                                                        0 |
      | id              | createPropertyInformationCondoResponse.header.entityId   |
      | propertyType    | createPropertyInformationCondoResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()               |
      | pin             | createPropertyInformationCondoResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                 |
      | buildingUnit    | faker.getRandomPin("Lot")                                |
      | isActive        | faker.getRandomBoolean()                                 |
    And set updatePropertyInformationCondoCommandHeader
      | path |                                                     0 |
      | id   | createPropertyInformationCondoResponse.body.name.id   |
      | code | createPropertyInformationCondoResponse.body.name.code |
      | name | createPropertyInformationCondoResponse.body.name.name |
    And set updatePropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | updatePropertyInformationCondoCommandHeader[0] |
      | body      | updatePropertyInformationCondoCommandBody[0]   |
      | body.name | updatePropertyInformationCondoCommandHeader[0] |
    And print updatePropertyInformationCondoPayload
    And request updatePropertyInformationCondoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInfoCondoWithInvalidDataToMandatoryDetails
  Scenario Outline: Update property information condo with invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationCondo'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    And sleep(500)
    And set updatePropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationCondo-v1.001.json"     |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | tenantID        | <tenantid>                                                  |
      | ttl             |                                                           0 |
      | commandType     | updateCommandType[1]                                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | tags            | []                                                          |
      | entityVersion   |                                                           1 |
      | entityID        | createPropertyInformationCondoResponse.header.entityId      |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | entityName      | entityName[1]                                               |
    And set updatePropertyInformationCondoCommandBody
      | path            |                                                        0 |
      | id              | faker.getRandomNumber()                                  |
      | propertyType    | createPropertyInformationCondoResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()               |
      | pin             | createPropertyInformationCondoResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                 |
      | building        | faker.getFirstName()                                     |
      | buildingUnit    | faker.getRandomPin("Lot")                                |
      | isActive        | faker.getRandomBoolean()                                 |
    And set updatePropertyInformationCondoCommandName
      | path |                                                     0 |
      | id   | createPropertyInformationCondoResponse.body.name.id   |
      | code | createPropertyInformationCondoResponse.body.name.code |
      | name | createPropertyInformationCondoResponse.body.name.name |
    And set updatePropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | updatePropertyInformationCondoCommandHeader[0] |
      | body      | updatePropertyInformationCondoCommandBody[0]   |
      | body.name | updatePropertyInformationCondoCommandName[0]   |
    And print updatePropertyInformationCondoPayload
    And request updatePropertyInformationCondoPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationLandWithAllFields
  Scenario Outline: Update a property information land with all the details
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationLand'
    #Create a property information having property type as Land
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And set updatePropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationLand-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | entityId        | createPropertyInformationLandResponse.header.entityId      |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | entityVersion   |                                                          1 |
      | tags            | []                                                         |
      | commandType     | updateCommandType[2]                                       |
      | entityName      | entityName[2]                                              |
      | ttl             |                                                          0 |
    And set updatePropertyInformationLandCommandBody
      | path            |                                                         0 |
      | id              | createPropertyInformationLandResponse.header.entityId     |
      | propertyType    | createPropertyInformationLandResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                |
      | pin             | createPropertyInformationLandResponse.body.pin            |
      | pinToBeAssigned | faker.getRandomBoolean()                                  |
      | areaCode        | createPropertyInformationLandResponse.body.areaCode       |
      | townCode        | createPropertyInformationLandResponse.body.townCode       |
      | range           | createPropertyInformationLandResponse.body.range          |
      | rangeDirection  | createPropertyInformationLandResponse.body.rangeDirection |
      | part1           | faker.getFirstName()                                      |
      | part2           | faker.getFirstName()                                      |
      | thirdQtr        | faker.getFirstName()                                      |
      | secondQtr       | faker.getFirstName()                                      |
      | firstQtr        | faker.getFirstName()                                      |
      | numofAcreage    | faker.getRandomNumber()                                   |
      | section         | faker.getFirstName()                                      |
      | half            | faker.getFirstName()                                      |
      | quarters        | faker.getFirstName()                                      |
      | notInSidwell    | faker.getFirstName()                                      |
      | isActive        | faker.getRandomBoolean()                                  |
    And set updatePropertyInformationLandCommandName
      | path |                                                    0 |
      | id   | createPropertyInformationLandResponse.body.name.id   |
      | code | createPropertyInformationLandResponse.body.name.code |
      | name | createPropertyInformationLandResponse.body.name.name |
    And set updatePropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | updatePropertyInformationLandCommandHeader[0] |
      | body      | updatePropertyInformationLandCommandBody[0]   |
      | body.name | updatePropertyInformationLandCommandName[0]   |
    And print updatePropertyInformationLandPayload
    And request updatePropertyInformationLandPayload
    When method POST
    Then status 201
    And def updatePropertyInformationLandResponse = response
    And print updatePropertyInformationLandResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoLandCollectionName+<tenantid>,updatePropertyInformationLandResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationLandResponse.body.id
    And match updatePropertyInformationLandResponse.body.numofAcreage == updatePropertyInformationLandPayload.body.numofAcreage
    # get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationLand'
    And set getPropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationLand-v1.001.json"        |
      | version         | "1.001"                                                    |
      | sourceId        | updatePropertyInformationLandResponse.header.sourceId      |
      | id              | updatePropertyInformationLandResponse.header.id            |
      | correlationId   | updatePropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | getCommandType[2]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | commandUserId   | updatePropertyInformationLandResponse.header.commandUserId |
      | getType         | "One"                                                      |
    And set getPropertyInformationLandCommandBody
      | path       |                                             0 |
      | request.id | updatePropertyInformationLandResponse.body.id |
    And set getPropertyInformationLandPayload
      | path   | [0]                                        |
      | header | getPropertyInformationLandCommandHeader[0] |
      | body   | getPropertyInformationLandCommandBody[0]   |
    And print getPropertyInformationLandPayload
    And request getPropertyInformationLandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationLandResponse = response
    And print getPropertyInformationLandResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoLandCollectionNameRead+<tenantid>,getPropertyInformationLandResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationLandResponse.id
    And match getPropertyInformationLandResponse.section == updatePropertyInformationLandResponse.body.section
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                       0 |
      | id              |                                                         |
      | propertyType    | propertyType[2]                                         |
      | name            |                                                         |
      | pin             |                                                         |
      | pinToBeAssigned |                                                         |
      | range           |                                                         |
      | block           |                                                         |
      | lot             |                                                         |
      | part            |                                                         |
      | townHomeAddress |                                                         |
      | building        |                                                         |
      | buildingUnit    |                                                         |
      | part1           |                                                         |
      | half            | updatePropertyInformationLandResponse.body.half         |
      | part2           |                                                         |
      | thirdQtr        | updatePropertyInformationLandResponse.body.thirdQtr     |
      | secondQtr       | updatePropertyInformationLandResponse.body.secondQtr    |
      | firstQtr        | updatePropertyInformationLandResponse.body.firstQtr     |
      | numofAcreage    | updatePropertyInformationLandResponse.body.numofAcreage |
      | section         | updatePropertyInformationLandResponse.body.section      |
      | isActive        | updatePropertyInformationLandResponse.body.isActive     |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationLandResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].thirdQtr == updatePropertyInformationLandResponse.body.thirdQtr
    And match each getPropertyInformationsResponse.results[*].numofAcreage == updatePropertyInformationLandResponse.body.numofAcreage
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #HistoryValidation
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[2]+historyAndComments[1]
    And def evnentType = entityName[2]
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
    #Adding the comment
    And def entityName = "PropertyInformationLand"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationLandResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationLand"
    And def entityIdData = updatePropertyInformationLandResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInformationLandWithMandatoryDetails
  Scenario Outline: Create property information Land  with  mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationLand'
    #Create a property information having property type as Land
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithMandatoryDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And set updatePropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationLand-v1.001.json"     |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | updateCommandType[2]                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | entityVersion   |                                                          1 |
      | entityID        | createPropertyInformationLandResponse.header.entityId      |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | entityName      | entityName[2]                                              |
    And set updatePropertyInformationLandCommandBody
      | path            |                                                       0 |
      | id              | createPropertyInformationLandResponse.header.entityId   |
      | propertyType    | createPropertyInformationLandResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()              |
      | pin             | createPropertyInformationLandResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                |
      | part1           | faker.getFirstName()                                    |
      | part2           | faker.getFirstName()                                    |
      | isActive        | faker.getRandomBoolean()                                |
    And set updatePropertyInformationLandCommandName
      | path |                        0 |
      | id   | dataGenerator.SourceID() |
      | code | faker.getUserId()        |
      | name | faker.getFirstName()     |
    And set updatePropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | updatePropertyInformationLandCommandHeader[0] |
      | body      | updatePropertyInformationLandCommandBody[0]   |
      | body.name | updatePropertyInformationLandCommandName[0]   |
    And print updatePropertyInformationLandPayload
    And request updatePropertyInformationLandPayload
    When method POST
    Then status 201
    And def updatePropertyInformationLandResponse = response
    And print updatePropertyInformationLandResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoLandCollectionName+<tenantid>,updatePropertyInformationLandResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updatePropertyInformationLandResponse.body.id
    And match updatePropertyInformationLandPayload.body.part1 == updatePropertyInformationLandResponse.body.part1
    # get the details
    Given url readBaseUrl
    And path '/api/GetPropertyInformationLand'
    And set getPropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetPropertyInformationLand-v1.001.json"        |
      | version         | "1.001"                                                    |
      | sourceId        | updatePropertyInformationLandResponse.header.sourceId      |
      | id              | updatePropertyInformationLandResponse.header.id            |
      | correlationId   | updatePropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | getCommandType[2]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | commandUserId   | updatePropertyInformationLandResponse.header.commandUserId |
      | getType         | "One"                                                      |
    And set getPropertyInformationLandCommandBody
      | path       |                                             0 |
      | request.id | updatePropertyInformationLandResponse.body.id |
    And set getPropertyInformationLandPayload
      | path   | [0]                                        |
      | header | getPropertyInformationLandCommandHeader[0] |
      | body   | getPropertyInformationLandCommandBody[0]   |
    And print getPropertyInformationLandPayload
    And request getPropertyInformationLandPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getPropertyInformationLandResponse = response
    And print getPropertyInformationLandResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createPropertyInfoLandCollectionNameRead+<tenantid>,getPropertyInformationLandResponse.id)
    And print mongoResult
    And match mongoResult == getPropertyInformationLandResponse.id
    And match getPropertyInformationLandResponse.part2 == updatePropertyInformationLandResponse.body.part2
    #Get All the Property Information
    Given url readBaseUrl
    And path '/api/GetPropertyInformations'
    And set getPropertyInformationsCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetPropertyInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | tenantId        | <tenantid>                                       |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | "GetPropertyInformations"                        |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getPropertyInformationsCommandBodyRequest
      | path            |                                                0 |
      | id              |                                                  |
      | propertyType    | propertyType[2]                                  |
      | name            |                                                  |
      | pin             |                                                  |
      | pinToBeAssigned |                                                  |
      | range           |                                                  |
      | block           |                                                  |
      | lot             |                                                  |
      | part            |                                                  |
      | half            |                                                  |
      | townHomeAddress |                                                  |
      | building        |                                                  |
      | buildingUnit    |                                                  |
      | part1           | updatePropertyInformationLandResponse.body.part1 |
      | part2           | updatePropertyInformationLandResponse.body.part2 |
      | thirdQtr        |                                                  |
      | secondQtr       |                                                  |
      | firstQtr        |                                                  |
      | numofAcreage    |                                                  |
      | section         |                                                  |
      | isActive        |                                                  |
    And set getPropertyInformationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getPropertyInformationsPayload
      | path                | [0]                                          |
      | header              | getPropertyInformationsCommandHeader[0]      |
      | body.request        | getPropertyInformationsCommandBodyRequest[0] |
      | body.paginationSort | getPropertyInformationsCommandPagination[0]  |
    And print getPropertyInformationsPayload
    And request getPropertyInformationsPayload
    When method POST
    Then status 200
    And def getPropertyInformationsResponse = response
    And print getPropertyInformationsResponse
    And match each getPropertyInformationsResponse.results[*].isActive == updatePropertyInformationLandResponse.body.isActive
    And match each getPropertyInformationsResponse.results[*].part1 == updatePropertyInformationLandResponse.body.part1
    And match each getPropertyInformationsResponse.results[*].part2 == updatePropertyInformationLandResponse.body.part2
    And def getPropertyInformationsResponseCount = karate.sizeOf(getPropertyInformationsResponse.results)
    And print getPropertyInformationsResponseCount
    And match getPropertyInformationsResponseCount == getPropertyInformationsResponse.totalRecordCount
    And assert getPropertyInformationsResponseCount > 0
    #HistoryValidation
    And def entityIdData = updatePropertyInformationCondoResponse.body.id
    And def parentEntityId = null
    And def eventName = entityName[2]+historyAndComments[1]
    And def evnentType = entityName[2]
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
    #Adding the comment
    And def entityName = "PropertyInformationLand"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updatePropertyInformationLandResponse.body.id
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
    # view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    # Get all the comments
    And def evnentType = "PropertyInformationLand"
    And def entityIdData = updatePropertyInformationLandResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
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

  @UpdatePropertyInfoLandWithInvalidDataToMandatoryDetails
  Scenario Outline: Update property information Land with invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationLand'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And set updatePropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationLand-v1.001.json"     |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | updateCommandType[2]                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | entityVersion   |                                                          1 |
      | entityID        | createPropertyInformationLandResponse.header.entityId      |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | entityName      | entityName[2]                                              |
    And set updatePropertyInformationLandCommandBody
      | path            |                                                       0 |
      | id              | faker.getRandomNumber()                                 |
      | propertyType    | createPropertyInformationLandResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()              |
      | pin             | createPropertyInformationLandResponse.body.pin          |
      | pinToBeAssigned | faker.getRandomBoolean()                                |
      | part1           | faker.getFirstName()                                    |
      | part2           | faker.getFirstName()                                    |
      | isActive        | faker.getRandomBoolean()                                |
    And set updatePropertyInformationLandCommandName
      | path |                                                    0 |
      | id   | createPropertyInformationLandResponse.body.name.id   |
      | code | createPropertyInformationLandResponse.body.name.code |
      | name | createPropertyInformationLandResponse.body.name.name |
    And set updatePropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | updatePropertyInformationLandCommandHeader[0] |
      | body      | updatePropertyInformationLandCommandBody[0]   |
      | body.name | updatePropertyInformationLandCommandName[0]   |
    And print updatePropertyInformationLandPayload
    And request updatePropertyInformationLandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationLandWithMissingMandatoryDetails
  Scenario Outline: Update property information Land with missing mandatory field
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationLand'
    #Create a property information
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    And set updatePropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationLand-v1.001.json"     |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | tenantID        | <tenantid>                                                 |
      | ttl             |                                                          0 |
      | commandType     | updateCommandType[2]                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | tags            | []                                                         |
      | entityVersion   |                                                          1 |
      | entityID        | createPropertyInformationLandResponse.header.entityId      |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | entityName      | entityName[2]                                              |
    #pin is missing
    And set updatePropertyInformationLandCommandBody
      | path            |                                                       0 |
      | id              | createPropertyInformationLandResponse.header.entityId   |
      | propertyType    | createPropertyInformationLandResponse.body.propertyType |
      | status          | faker.getRandomPropertyInformationStatus()              |
      | pinToBeAssigned | faker.getRandomBoolean()                                |
      | part1           | faker.getFirstName()                                    |
      | part2           | faker.getFirstName()                                    |
      | isActive        | faker.getRandomBoolean()                                |
    And set updatePropertyInformationLandCommandName
      | path |                                                    0 |
      | id   | createPropertyInformationLandResponse.body.name.id   |
      | code | createPropertyInformationLandResponse.body.name.code |
      | name | createPropertyInformationLandResponse.body.name.name |
    And set updatePropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | updatePropertyInformationLandCommandHeader[0] |
      | body      | updatePropertyInformationLandCommandBody[0]   |
      | body.name | updatePropertyInformationLandCommandName[0]   |
    And print updatePropertyInformationLandPayload
    And request updatePropertyInformationLandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoHavingDuplicatePinFromSD
  Scenario Outline: Create a propertyInformation condo having duplicate pin which exists in property information subdivision
    Given url commandBaseUrl
    When path '/api/CreatePropertyInformationCondo'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And sleep(10000)
    And set createPropertyInformationCondoCommandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    And set createPropertyInformationCondoCommandBody
      | path            |                                                     0 |
      | id              | entityIDData                                          |
      | propertyType    | propertyType[1]                                       |
      | status          | faker.getRandomPropertyInformationStatus()            |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin |
      | pinToBeAssigned | faker.getRandomBoolean()                              |
      | areaCode        | getCondoInformantionResponse.areaCode.code            |
      | townCode        | getCondoInformantionResponse.townCode                 |
      | range           | getCondoInformantionResponse.range                    |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection           |
      | building        | faker.getFirstName()                                  |
      | buildingUnit    | faker.getRandomPin("Lot")                             |
      | phase           | faker.getFirstName()                                  |
      | garage          | faker.getRandomPin("Lot")                             |
      | notInSidwell    | faker.getFirstName()                                  |
      | isActive        | faker.getRandomBoolean()                              |
    And set createPropertyInformationCondoCommandName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set createPropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | createPropertyInformationCondoCommandHeader[0] |
      | body      | createPropertyInformationCondoCommandBody[0]   |
      | body.name | createPropertyInformationCondoCommandName[0]   |
    And print createPropertyInformationCondoPayload
    And request createPropertyInformationCondoPayload
    When method POST
    Then status 400
    And print response
    And match response contains "DuplicateKey:PIN/APN exists in PropertyInformationCondo/PropertyInformationLand/PropertyInformationSubDivision and cannot be created"

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationSubdivisionHavingDuplicatePin
  Scenario Outline: Create a propertyInformation Subdivision having duplicate pin
    Given url commandBaseUrl
    When path '/api/CreatePropertyInformationSubDivision'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    #creating a new subdivision info then validating the created id is present in GetSubdivisionInformationsIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchSubDivisionInformation')
    And def getSearchSubDivisionInformantionResponse = result.response
    And print getSearchSubDivisionInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetSubDivisionInformation')
    And def getSubDivisionInformantionResponse = result.response
    And print getSubDivisionInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And sleep(10000)
    And set createPropertyInformationSubDivisionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationSubdivision-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantID        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | createCommandType[0]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | entityVersion   |                                                             1 |
      | entityID        | entityIDData                                                  |
      | commandUserId   | commandUserId                                                 |
      | entityName      | entityName[0]                                                 |
    And set createPropertyInformationSubDivisionCommandBody
      | path            |                                                     0 |
      | id              | entityIDData                                          |
      | propertyType    | propertyType[0]                                       |
      | status          | faker.getRandomPropertyInformationStatus()            |
      | pin             | createPropertyInformationSubDivisionResponse.body.pin |
      | pinToBeAssigned | faker.getRandomBoolean()                              |
      | areaCode        | getSubDivisionInformantionResponse.areaCode.code      |
      | townCode        | getSubDivisionInformantionResponse.townCode           |
      | range           | getSubDivisionInformantionResponse.range              |
      | rangeDirection  | getSubDivisionInformantionResponse.rangeDirection     |
      | block           | faker.getFirstName()                                  |
      | lot             | faker.getRandomPin("Lot")                             |
      | part            | faker.getFirstName()                                  |
      | townHomeAddress | faker.getFirstName()                                  |
      | notInSidwell    | faker.getFirstName()                                  |
      | isActive        | faker.getRandomBoolean()                              |
    And set createPropertyInformationSubDivisionCommandName
      | path |                                                        0 |
      | id   | getSearchSubDivisionInformantionResponse.results[0].id   |
      | code | getSearchSubDivisionInformantionResponse.results[0].code |
      | name | getSearchSubDivisionInformantionResponse.results[0].name |
    And set createPropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | createPropertyInformationSubDivisionCommandHeader[0] |
      | body      | createPropertyInformationSubDivisionCommandBody[0]   |
      | body.name | createPropertyInformationSubDivisionCommandName[0]   |
    And print createPropertyInformationSubDivisionPayload
    And request createPropertyInformationSubDivisionPayload
    When method POST
    Then status 400
    And match response contains "DuplicateKey:PIN/APN exists in PropertyInformationCondo/PropertyInformationLand/PropertyInformationSubDivision and cannot be created"

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationSubdivisionWithDuplicatePin
  Scenario Outline: Update a property information subdivision with duplicate pin
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationSubdivision'
    #Create a property information having property type as Subdivision
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse = result.response
    And print createPropertyInformationSubDivisionResponse
    #Creating another property information subdivision
    And def result1 = call read('CreatePropertyInformation.feature@CreatePropertyInformationSubDivisionWithAllDetails')
    And def createPropertyInformationSubDivisionResponse1 = result.response
    And print createPropertyInformationSubDivisionResponse1
    And set updatePropertyInformationSubDivisionCommandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationSubdivision-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | version         | "1.001"                                                           |
      | sourceId        | createPropertyInformationSubDivisionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                        |
      | id              | createPropertyInformationSubDivisionResponse.header.id            |
      | correlationId   | createPropertyInformationSubDivisionResponse.header.correlationId |
      | entityId        | createPropertyInformationSubDivisionResponse.header.entityId      |
      | commandUserId   | createPropertyInformationSubDivisionResponse.header.commandUserId |
      | entityVersion   |                                                                 1 |
      | tags            | []                                                                |
      | commandType     | updateCommandType[0]                                              |
      | entityName      | entityName[0]                                                     |
      | ttl             |                                                                 0 |
    And set updatePropertyInformationSubDivisionCommandBody
      | path            |                                                                0 |
      | id              | createPropertyInformationSubDivisionResponse.header.entityId     |
      | propertyType    | createPropertyInformationSubDivisionResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                       |
      | pin             | createPropertyInformationSubDivisionResponse1.body.pin           |
      | pinToBeAssigned | faker.getRandomBoolean()                                         |
      | areaCode        | createPropertyInformationSubDivisionResponse.body.areaCode       |
      | townCode        | createPropertyInformationSubDivisionResponse.body.townCode       |
      | range           | createPropertyInformationSubDivisionResponse.body.range          |
      | rangeDirection  | createPropertyInformationSubDivisionResponse.body.rangeDirection |
      | block           | faker.getFirstName()                                             |
      | lot             | faker.getRandomPin("Lot")                                        |
      | part            | faker.getFirstName()                                             |
      | townHomeAddress | faker.getFirstName()                                             |
      | notInSidwell    | faker.getFirstName()                                             |
      | isActive        | faker.getRandomBoolean()                                         |
    And set updatePropertyInformationSubDivisionCommandName
      | path |                                                           0 |
      | id   | createPropertyInformationSubDivisionResponse.body.name.id   |
      | code | createPropertyInformationSubDivisionResponse.body.name.code |
      | name | createPropertyInformationSubDivisionResponse.body.name.name |
    And set updatePropertyInformationSubDivisionPayload
      | path      | [0]                                                  |
      | header    | updatePropertyInformationSubDivisionCommandHeader[0] |
      | body      | updatePropertyInformationSubDivisionCommandBody[0]   |
      | body.name | updatePropertyInformationSubDivisionCommandName[0]   |
    And print updatePropertyInformationSubDivisionPayload
    And request updatePropertyInformationSubDivisionPayload
    When method POST
    Then status 201

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoHavingDuplicatePin
  Scenario Outline: Create a propertyInformation Condo having duplicate pin
    Given url commandBaseUrl
    When path '/api/CreatePropertyInformationCondo'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And sleep(10000)
    And set createPropertyInformationCondoCommandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    And set createPropertyInformationCondoCommandBody
      | path            |                                               0 |
      | id              | entityIDData                                    |
      | propertyType    | propertyType[1]                                 |
      | status          | faker.getRandomPropertyInformationStatus()      |
      | pin             | createPropertyInformationCondoResponse.body.pin |
      | pinToBeAssigned | faker.getRandomBoolean()                        |
      | areaCode        | getCondoInformantionResponse.areaCode.code      |
      | townCode        | getCondoInformantionResponse.townCode           |
      | range           | getCondoInformantionResponse.range              |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection     |
      | building        | faker.getFirstName()                            |
      | buildingUnit    | faker.getRandomPin("Lot")                       |
      | phase           | faker.getFirstName()                            |
      | garage          | faker.getRandomPin("Lot")                       |
      | notInSidwell    | faker.getFirstName()                            |
      | isActive        | faker.getRandomBoolean()                        |
    And set createPropertyInformationCondoCommandName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set createPropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | createPropertyInformationCondoCommandHeader[0] |
      | body      | createPropertyInformationCondoCommandBody[0]   |
      | body.name | createPropertyInformationCondoCommandName[0]   |
    And print createPropertyInformationCondoPayload
    And request createPropertyInformationCondoPayload
    When method POST
    Then status 400
    And match response contains "DuplicateKey:PIN/APN exists in PropertyInformationCondo/PropertyInformationLand/PropertyInformationSubDivision and cannot be created"

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationCondoWithDuplicatePin
  Scenario Outline: Update a property information condo with duplicate pin
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationCondo'
    #Create a property information having property type as Condo
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse = result.response
    And print createPropertyInformationCondoResponse
    #Creating another property information having property type as Condo
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationCondoWithAllDetails')
    And def createPropertyInformationCondoResponse1 = result.response
    And print createPropertyInformationCondoResponse1
    And set updatePropertyInformationCondoCommandHeader
      | path            |                                                           0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationCondo-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                     |
      | version         | "1.001"                                                     |
      | sourceId        | createPropertyInformationCondoResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                  |
      | id              | createPropertyInformationCondoResponse.header.id            |
      | correlationId   | createPropertyInformationCondoResponse.header.correlationId |
      | entityId        | createPropertyInformationCondoResponse.header.entityId      |
      | commandUserId   | createPropertyInformationCondoResponse.header.commandUserId |
      | entityVersion   |                                                           1 |
      | tags            | []                                                          |
      | commandType     | updateCommandType[1]                                        |
      | entityName      | entityName[1]                                               |
      | ttl             |                                                           0 |
    And set updatePropertyInformationCondoCommandBody
      | path            |                                                          0 |
      | id              | createPropertyInformationCondoResponse.header.entityId     |
      | propertyType    | createPropertyInformationCondoResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                 |
      | pin             | createPropertyInformationCondoResponse1.body.pin           |
      | pinToBeAssigned | faker.getRandomBoolean()                                   |
      | areaCode        | createPropertyInformationCondoResponse.body.areaCode       |
      | townCode        | createPropertyInformationCondoResponse.body.townCode       |
      | range           | createPropertyInformationCondoResponse.body.range          |
      | rangeDirection  | createPropertyInformationCondoResponse.body.rangeDirection |
      | building        | faker.getFirstName()                                       |
      | buildingUnit    | faker.getRandomPin("Lot")                                  |
      | phase           | faker.getFirstName()                                       |
      | garage          | faker.getRandomPin("Lot")                                  |
      | notInSidwell    | faker.getFirstName()                                       |
      | isActive        | faker.getRandomBoolean()                                   |
    And set updatePropertyInformationCondoCommandName
      | path |                                                     0 |
      | id   | createPropertyInformationCondoResponse.body.name.id   |
      | code | createPropertyInformationCondoResponse.body.name.code |
      | name | createPropertyInformationCondoResponse.body.name.name |
    And set updatePropertyInformationCondoPayload
      | path      | [0]                                            |
      | header    | updatePropertyInformationCondoCommandHeader[0] |
      | body      | updatePropertyInformationCondoCommandBody[0]   |
      | body.name | updatePropertyInformationCondoCommandName[0]   |
    And print updatePropertyInformationCondoPayload
    And request updatePropertyInformationCondoPayload
    When method POST
    Then status 201

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationLandHavingDuplicatePin
  Scenario Outline: Create a propertyInformation Land having duplicate pin
    Given url commandBaseUrl
    When path '/api/CreatePropertyInformationLand'
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    #creating a new Land info then validating the created id is present in GetAreaMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchLandInformation')
    And def getSearchLandInformantionResponse = result.response
    And print getSearchLandInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCountyMaintenance')
    And def getLandInformantionResponse = result.response
    And print getLandInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And sleep(10000)
    And set createPropertyInformationLandCommandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationLand-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantID        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | createCommandType[2]                                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | entityVersion   |                                                      1 |
      | entityID        | entityIDData                                           |
      | commandUserId   | commandUserId                                          |
      | entityName      | entityName[2]                                          |
    And set createPropertyInformationLandCommandBody
      | path            |                                              0 |
      | id              | entityIDData                                   |
      | propertyType    | propertyType[2]                                |
      | status          | faker.getRandomPropertyInformationStatus()     |
      | pin             | createPropertyInformationLandResponse.body.pin |
      | pinToBeAssigned | faker.getRandomBoolean()                       |
      | areaCode        | getLandInformantionResponse.areaCode           |
      | townCode        | getLandInformantionResponse.townCode           |
      | range           | getLandInformantionResponse.range              |
      | rangeDirection  | getLandInformantionResponse.rangeDirection     |
      | part1           | faker.getFirstName()                           |
      | part2           | faker.getFirstName()                           |
      | thirdQtr        | faker.getFirstName()                           |
      | secondQtr       | faker.getFirstName()                           |
      | firstQtr        | faker.getFirstName()                           |
      | numofAcreage    | faker.getRandomNumber()                        |
      | section         | faker.getFirstName()                           |
      | half            | faker.getFirstName()                           |
      | quarters        | faker.getFirstName()                           |
      | notInSidwell    | faker.getFirstName()                           |
      | isActive        | faker.getRandomBoolean()                       |
    And set createPropertyInformationLandCommandName
      | path |                                                 0 |
      | id   | getSearchLandInformantionResponse.results[0].id   |
      | code | getSearchLandInformantionResponse.results[0].code |
      | name | getSearchLandInformantionResponse.results[0].name |
    And set createPropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | createPropertyInformationLandCommandHeader[0] |
      | body      | createPropertyInformationLandCommandBody[0]   |
      | body.name | createPropertyInformationLandCommandName[0]   |
    And print createPropertyInformationLandPayload
    And request createPropertyInformationLandPayload
    When method POST
    Then status 400
    And match response contains "DuplicateKey:PIN/APN exists in PropertyInformationCondo/PropertyInformationLand/PropertyInformationSubDivision and cannot be created"

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdatePropertyInformationLandWithDuplicatePin
  Scenario Outline: Update a property information Land with duplicate pin
    Given url commandBaseUrl
    And path '/api/UpdatePropertyInformationLand'
    #Create a property information having property type as Land
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse = result.response
    And print createPropertyInformationLandResponse
    #Creating another property information having property type as Land
    And def result = call read('CreatePropertyInformation.feature@CreatePropertyInformationLandWithAllDetails')
    And def createPropertyInformationLandResponse1 = result.response
    And print createPropertyInformationLandResponse1
    And set updatePropertyInformationLandCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/UpdatePropertyInformationLand-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | createPropertyInformationLandResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                 |
      | id              | createPropertyInformationLandResponse.header.id            |
      | correlationId   | createPropertyInformationLandResponse.header.correlationId |
      | entityId        | createPropertyInformationLandResponse.header.entityId      |
      | commandUserId   | createPropertyInformationLandResponse.header.commandUserId |
      | entityVersion   |                                                          1 |
      | tags            | []                                                         |
      | commandType     | updateCommandType[2]                                       |
      | entityName      | entityName[2]                                              |
      | ttl             |                                                          0 |
    And set updatePropertyInformationLandCommandBody
      | path            |                                                         0 |
      | id              | createPropertyInformationLandResponse.header.entityId     |
      | propertyType    | createPropertyInformationLandResponse.body.propertyType   |
      | status          | faker.getRandomPropertyInformationStatus()                |
      | pin             | createPropertyInformationLandResponse1.body.pin           |
      | pinToBeAssigned | faker.getRandomBoolean()                                  |
      | areaCode        | createPropertyInformationLandResponse.body.areaCode       |
      | townCode        | createPropertyInformationLandResponse.body.townCode       |
      | range           | createPropertyInformationLandResponse.body.range          |
      | rangeDirection  | createPropertyInformationLandResponse.body.rangeDirection |
      | part1           | faker.getFirstName()                                      |
      | part2           | faker.getFirstName()                                      |
      | thirdQtr        | faker.getFirstName()                                      |
      | secondQtr       | faker.getFirstName()                                      |
      | firstQtr        | faker.getFirstName()                                      |
      | numofAcreage    | faker.getRandomNumber()                                   |
      | section         | faker.getFirstName()                                      |
      | half            | faker.getFirstName()                                      |
      | quarters        | faker.getFirstName()                                      |
      | notInSidwell    | faker.getFirstName()                                      |
      | isActive        | faker.getRandomBoolean()                                  |
    And set updatePropertyInformationLandCommandName
      | path |                                                    0 |
      | id   | createPropertyInformationLandResponse.body.name.id   |
      | code | createPropertyInformationLandResponse.body.name.code |
      | name | createPropertyInformationLandResponse.body.name.name |
    And set updatePropertyInformationLandPayload
      | path      | [0]                                           |
      | header    | updatePropertyInformationLandCommandHeader[0] |
      | body      | updatePropertyInformationLandCommandBody[0]   |
      | body.name | updatePropertyInformationLandCommandName[0]   |
    And print updatePropertyInformationLandPayload
    And request updatePropertyInformationLandPayload
    When method POST
    Then status 201

    Examples: 
      | tenantid    |
      | tenantID[0] |
