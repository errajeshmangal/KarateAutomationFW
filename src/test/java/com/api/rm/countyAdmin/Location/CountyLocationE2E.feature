@CountyLocations
Feature: County Location - Add , Edit , View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyLocationCollectionname = 'CreateCountyLocation_'
    And def countyLocationCollectionNameRead = 'CountyLocationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyLocationAndGetTheDetails
  Scenario Outline: Create a county location information with all the fields
    #getCountyLocation
    Given url readBaseUrl
    And path '/api/GetCountyLocation'
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocation-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetCountyLocation"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getCommandBody
      | path |                                 0 |
      | id   | addCountyLocationResponse.body.id |
    And set getCountyLocationPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyLocationPayload
    And request getCountyLocationPayload
    When method POST
    Then status 200
    And def getCountyLocationAPIResponse = response
    And print getCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyLocationAPIResponse.id
    And match getCountyLocationAPIResponse.address.zipCode == addCountyLocationResponse.body.address.zipCode
    #GetCountyLocations
    Given url readBaseUrl
    When path '/api/GetCountyLocations'
    And set getLocationsCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocations-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | "GetCountyLocations"                           |
      | getType         | "Array"                                        |
    And set getLocationsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getLocationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getLocationsPayload
      | path                | [0]                               |
      | header              | getLocationsCommandHeader[0]      |
      | body.request        | getLocationsCommandBodyRequest[0] |
      | body.paginationSort | getLocationsCommandPagination[0]  |
    And print getLocationsPayload
    And request getLocationsPayload
    When method POST
    Then status 200
    And def getLocationsResponse = response
    And print getLocationsResponse
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And def getLocationsResponseCount = karate.sizeOf(getLocationsResponse.results)
    And print getLocationsResponseCount
    And match getLocationsResponseCount == getLocationsResponse.totalRecordCount
    And match each getLocationsResponse.results[*].active == true
    #HistoryValidation
    And def entityIdData = addCountyLocationResponse.body.id
    And def eventName = "CountyLocationCreated"
    And def evnentType = "CountyLocation"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    #Adding the comments
    And def entityName = "CountyLocation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCountyLocationResponse.body.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    # updating the comments
    And def updatedEntityComment = faker.getRandomLongDescription()
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
    #Get all the comments
    And def evnentType = "CountyLocation"
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

  @CreateCountyLocationWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a county location information with only mandatory fields
    Given url readBaseUrl
    And path '/api/GetCountyLocation'
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    #GetCountyLocation
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocation-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetCountyLocation"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getCommandBody
      | path |                                 0 |
      | id   | addCountyLocationResponse.body.id |
    And set getCountyLocationPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getCountyLocationPayload
    And request getCountyLocationPayload
    When method POST
    Then status 200
    And def getCountyLocationAPIResponse = response
    And print getCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And match mongoResult == getCountyLocationAPIResponse.id
    And match getCountyLocationAPIResponse.address.zipCode == addCountyLocationResponse.body.address.zipCode
    #GetCountyLocations
    Given url readBaseUrl
    When path '/api/GetCountyLocations'
    And set getLocationsCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocations-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | "GetCountyLocations"                           |
      | getType         | "Array"                                        |
    And set getLocationsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getLocationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getLocationsPayload
      | path                | [0]                               |
      | header              | getLocationsCommandHeader[0]      |
      | body.request        | getLocationsCommandBodyRequest[0] |
      | body.paginationSort | getLocationsCommandPagination[0]  |
    And print getLocationsPayload
    And request getLocationsPayload
    When method POST
    Then status 200
    And def getLocationsResponse = response
    And print getLocationsResponse
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And def getLocationsResponseCount = karate.sizeOf(getLocationsResponse.results)
    And print getLocationsResponseCount
    And match getLocationsResponseCount == getLocationsResponse.totalRecordCount
    And match each getLocationsResponse.results[*].active == true
    #Adding the comment
    And def entityName = "CountyLocation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCountyLocationResponse.body.id
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
    And def evnentType = "CountyLocation"
    And def entityIdData = addCountyLocationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CountyLocationCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
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

  @CreateCountyLocationWithInvalidDetailsToMandatoryFields
  Scenario Outline: Create a county location information with invalid data to mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyLocation'
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #GetCountyCode
    And call read('classpath:com/api/rm/countyAdmin/countyFeature/CountyE2E.feature@CreateCountyWithAllFields')
    And def getCountyCodeResponse = result1.response
    And print getCountyCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCountyLocationCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCountyLocation-v1.001.json" |
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
      | commandType     | "CreateCountyLocation"                        |
      | entityName      | "CountyLocation"                              |
      | ttl             |                                             0 |
    And set createCountyLocationCommandBody
      | path              |                                   0 |
      | id                | entityIdData                        |
      | name              | faker.getFirstName()                |
      | code              | faker.getUserId()                   |
      | displaySequence   |                                   1 |
      | isDefaultLocation | faker.getRandomBoolean()            |
      | isActive          | faker.getRandomBoolean()            |
      | countyId          | getCountyCodeResponse.results[0].id |
    And set createCountyLocationCommandGlCode
      | path |                                                      0 |
      | id   | createCountyAccountCodeResponse.body.id                |
      | name | createCountyAccountCodeResponse.body.shortAccountCode2 |
      | code | createCountyAccountCodeResponse.body.accountCode2      |
    And set createCountyLocationCommandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      #Invalid string
      | zipCode      | faker.getAddressLine() |
    And set addCountyLocationPayload
      | path         | [0]                                   |
      | header       | createCountyLocationCommandHeader[0]  |
      | body         | createCountyLocationCommandBody[0]    |
      | body.address | createCountyLocationCommandAddress[0] |
      | body.glCode  | createCountyLocationCommandGlCode[0]  |
    And print addCountyLocationPayload
    And request addCountyLocationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyLocationWithMissingMandatoryFields
  Scenario Outline: Create a county location information with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyLocation'
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #GetCountyCode
    And call read('classpath:com/api/rm/countyAdmin/countyFeature/CountyE2E.feature@CreateCountyWithAllFields')
    And def getCountyCodeResponse = result1.response
    And print getCountyCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCountyLocationCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCountyLocation-v1.001.json" |
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
      | commandType     | "CreateCountyLocation"                        |
      | entityName      | "CountyLocation"                              |
      | ttl             |                                             0 |
    And set createCountyLocationCommandBody
      | path              |                                   0 |
      | id                | entityIdData                        |
      #| name              | faker.getFirstName()                |
      | code              | faker.getUserId()                   |
      | displaySequence   |                                   1 |
      | isDefaultLocation | faker.getRandomBoolean()            |
      | isActive          | faker.getRandomBoolean()            |
      | countyId          | getCountyCodeResponse.results[0].id |
    And set createCountyLocationCommandGlCode
      | path |                                                      0 |
      | id   | createCountyAccountCodeResponse.body.id                |
      | name | createCountyAccountCodeResponse.body.shortAccountCode2 |
      | code | createCountyAccountCodeResponse.body.accountCode2      |
    And set createCountyLocationCommandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      #Invalid string
      | zipCode      | faker.getAddressLine() |
    And set addCountyLocationPayload
      | path         | [0]                                   |
      | header       | createCountyLocationCommandHeader[0]  |
      | body         | createCountyLocationCommandBody[0]    |
      | body.address | createCountyLocationCommandAddress[0] |
      | body.glCode  | createCountyLocationCommandGlCode[0]  |
    And print addCountyLocationPayload
    And request addCountyLocationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyLocationWithAllDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a County Location with all the fields and Validate the updated details
    Given url commandBaseUrl
    And path '/api/UpdateCountyLocation'
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateCountyLocation-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | entityId        | addCountyLocationResponse.header.entityId      |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateCountyLocation"                         |
      | entityName      | "CountyLocation"                               |
      | ttl             |                                              0 |
    And set commandBody
      | path              |                                         0 |
      | id                | addCountyLocationResponse.header.entityId |
      | name              | firstName                                 |
      | code              | faker.getUserId()                         |
      | displaySequence   |                                         1 |
      | isDefaultLocation | faker.getRandomBoolean()                  |
      | isActive          | faker.getRandomBoolean()                  |
      | countyId          | addCountyLocationResponse.body.countyId   |
    And set commandGlCode
      | path |                                                       0 |
      | id   | addCountyLocationResponse.body.glCode.id                |
      | name | addCountyLocationResponse.body.glCode.accountCode2      |
      | code | addCountyLocationResponse.body.glCode.shortAccountCode2 |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipcode      | faker.getZip()         |
    And set updateCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyLocationPayload
    And request updateCountyLocationPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateCountyLocationAPIResponse = response
    And print updateCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And match mongoResult == response.body.id
    And match updateCountyLocationAPIResponse.body.name == firstName
    #GetCountyLocaion
    Given url readBaseUrl
    And path '/api/GetCountyLocation'
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocation-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetCountyLocation"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getCommandBody
      | path       |                                 0 |
      | request.id | addCountyLocationResponse.body.id |
    And set getCountyLocationPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCountyLocationPayload
    And request getCountyLocationPayload
    When method POST
    Then status 200
    And def getCountyLocationAPIResponse = response
    And print getCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,getCountyLocationAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyLocationAPIResponse.id
    And match getCountyLocationAPIResponse.address.zipCode == updateCountyLocationAPIResponse.body.address.zipCode
    And match updateCountyLocationAPIResponse.body.name  == getCountyLocationAPIResponse.name
    #GetCountyLocations
    Given url readBaseUrl
    When path '/api/GetCountyLocations'
    And set getLocationsCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocations-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | "GetCountyLocations"                           |
      | getType         | "Array"                                        |
    And set getLocationsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getLocationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getLocationsPayload
      | path                | [0]                               |
      | header              | getLocationsCommandHeader[0]      |
      | body.request        | getLocationsCommandBodyRequest[0] |
      | body.paginationSort | getLocationsCommandPagination[0]  |
    And print getLocationsPayload
    And request getLocationsPayload
    When method POST
    Then status 200
    And def getLocationsResponse = response
    And print getLocationsResponse
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And def getLocationsResponseCount = karate.sizeOf(getLocationsResponse.results)
    And print getLocationsResponseCount
    And match getLocationsResponseCount == getLocationsResponse.totalRecordCount
    And match each getLocationsResponse.results[*].active == true
    #Adding the comment
    And def entityName = "CountyLocation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = updateCountyLocationAPIResponse.body.id
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
    And def evnentType = "CountyLocation"
    And def entityIdData = updateCountyLocationAPIResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CountyLocationUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @Sanity
  Scenario Outline: Update a County Location with mandatory fields and Validate the updated details
    Given url commandBaseUrl
    And path '/api/UpdateCountyLocation'
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateCountyLocation-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | entityId        | addCountyLocationResponse.header.entityId      |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateCountyLocation"                         |
      | entityName      | "CountyLocation"                               |
      | ttl             |                                              0 |
    And set commandBody
      | path     |                                         0 |
      | id       | addCountyLocationResponse.header.entityId |
      | name     | firstName                                 |
      | code     | faker.getUserId()                         |
      | countyId | addCountyLocationResponse.body.countyId   |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set updateCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyLocationPayload
    And request updateCountyLocationPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateCountyLocationAPIResponse = response
    And print updateCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == response.body.id
    And match updateCountyLocationAPIResponse.body.name == firstName
    #GetCountyLocaion
    Given url readBaseUrl
    And path '/api/GetCountyLocation'
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocation-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | tags            | []                                             |
      | commandType     | "GetCountyLocation"                            |
      | getType         | "One"                                          |
      | ttl             |                                              0 |
    And set getCommandBody
      | path       |                                 0 |
      | request.id | addCountyLocationResponse.body.id |
    And set getCountyLocationPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCountyLocationPayload
    And request getCountyLocationPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCountyLocationAPIResponse = response
    And print getCountyLocationAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,getCountyLocationAPIResponse.id)
    And print mongoResult
    And match mongoResult == getCountyLocationAPIResponse.id
    And match getCountyLocationAPIResponse.address.zipcode == updateCountyLocationAPIResponse.body.address.zipcode
    #GetCountyLocations
    Given url readBaseUrl
    When path '/api/GetCountyLocations'
    And set getLocationsCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCountyLocations-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | ttl             |                                              0 |
      | tags            | []                                             |
      | commandType     | "GetCountyLocations"                           |
      | getType         | "Array"                                        |
    And set getLocationsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getLocationsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              1000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getLocationsPayload
      | path                | [0]                               |
      | header              | getLocationsCommandHeader[0]      |
      | body.request        | getLocationsCommandBodyRequest[0] |
      | body.paginationSort | getLocationsCommandPagination[0]  |
    And print getLocationsPayload
    And request getLocationsPayload
    When method POST
    Then status 200
    And def getLocationsResponse = response
    And print getLocationsResponse
    And sleep(15000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyLocationCollectionNameRead+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And def getLocationsResponseCount = karate.sizeOf(getLocationsResponse.results)
    And print getLocationsResponseCount
    And match getLocationsResponseCount == getLocationsResponse.totalRecordCount
    And match each getLocationsResponse.results[*].name contains  firstName
    And match each getLocationsResponse.results[*].active == true
    #Adding the comment
    And def entityName = "CountyLocation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addCountyLocationResponse.body.id
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
    And def evnentType = "CountyLocation"
    And def entityIdData = addCountyLocationResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CountyLocationCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CoutyLocationWithMissingMandatoryFields
  Scenario Outline: Update a County Location with invalid data to mandatory fields and validate
    Given url commandBaseUrl
    And path '/api/UpdateCountyLocation'
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateCountyLocation-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | entityId        | addCountyLocationResponse.header.entityId      |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateCountyLocation"                         |
      | entityName      | "CountyLocation"                               |
      | ttl             |                                              0 |
    And set commandBody
      | path              |                                         0 |
      | id                | addCountyLocationResponse.header.entityId |
      | name              | firstName                                 |
      | code              | faker.getUserId()                         |
      | displaySequence   |                                         1 |
      | isDefaultLocation | faker.getRandomBoolean()                  |
      | isActive          | faker.getRandomBoolean()                  |
      | countyId          | getCountyLocationResponse.body.countyId   |
    And set commandAddress
      | path         |                        0 |
      | addressLine1 | faker.getAddressLine()   |
      | addressLine2 | faker.getAddressLine()   |
      | city         | faker.getCity()          |
      | state        | faker.getState()         |
      #invalid
      | zipCode      | faker.getRandomBoolean() |
    And set addCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyLocationPayload
    And request updateCountyLocationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @NegativeCase @UpdateWithoutMandatoryFields
  Scenario Outline: Update a County Location with missing mandatory fields and validate
    Given url commandBaseUrl
    And path '/api/UpdateCountyLocation'
    #GetCountyLocationResponse
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateCountyLocation-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | entityId        | addCountyLocationResponse.header.entityId      |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateCountyLocation"                         |
      | entityName      | "CountyLocation"                               |
      | ttl             |                                              0 |
    And set commandBody
      | path              |                                         0 |
      | id                | addCountyLocationResponse.header.entityId |
      #| name              | firstName                                 |
      | code              | faker.getUserId()                         |
      | displaySequence   |                                         1 |
      | glCode            | faker.getUserId()                         |
      | isDefaultLocation | faker.getRandomBoolean()                  |
      | isActive          | faker.getRandomBoolean()                  |
      | countyId          | addCountyLocationResponse.body.countyId   |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
    And set updateCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyLocationPayload
    And request updateCountyLocationPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

   @CountyLocationDuplicate
  Scenario Outline: Create a duplicate County Location with and validate
    Given url commandBaseUrl
    And path '/api/CreateCountyLocation'
    #GetCountyLocationResponse
    And def result = call read('CreateCountyLocation.feature@CreateCountyLocationWithMandatoryFields')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def entityIdData = dataGenerator.entityID()
    And def firstName = faker.getFirstName()
    And set commandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/CreateCountyLocation-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | addCountyLocationResponse.header.sourceId      |
      | tenantId        | <tenantid>                                     |
      | id              | addCountyLocationResponse.header.id            |
      | correlationId   | addCountyLocationResponse.header.correlationId |
      | entityId        | entityIdData                                   |
      | commandUserId   | addCountyLocationResponse.header.commandUserId |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "CreateCountyLocation"                         |
      | entityName      | "CountyLocation"                               |
      | ttl             |                                              0 |
    And set commandBody
      | path              |                                       0 |
      | id                | entityIdData                            |
      | name              | firstName                               |
      | code              | addCountyLocationResponse.body.code     |
      | displaySequence   |                                       1 |
      | isDefaultLocation | faker.getRandomBoolean()                |
      | isActive          | faker.getRandomBoolean()                |
      | countyId          | addCountyLocationResponse.body.countyId |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set addCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print addCountyLocationPayload
    And request addCountyLocationPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CountyLocation cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |