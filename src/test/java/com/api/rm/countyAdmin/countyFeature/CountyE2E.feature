@CountyMaster
Feature: Create , Edit County functionality

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyMasterCollectionName = 'CreateCounty_'
    And def countyMasterCollectionNameRead = 'CountyDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyWithAllFields
  Scenario Outline: Create a County with all the fields and validate the details
    #Get the county
    And def result = call read('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And def resultSize = karate.sizeOf(getCountyResponse.results) == 0 ? karate.call('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@createCounty') : karate.call ('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@getCountyDetails')
    And def result1 = call read('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@getCountyDetails')
    And print result1.response
    And match result1.response.totalRecordCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createDuplicateCounty
  Scenario Outline: Create a County with all the fields and validate the details
    #Get the county
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And if (karate.sizeOf(getCountyResponse.results) == 1) karate.call('CreateCounty.feature@create2ndCounty')

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyWithAllFieldsAndGetTheDetails
  Scenario Outline: Update a County with all the fields and validate the updated details
    Given url commandBaseUrl
    And path '/api/UpdateCounty'
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And def firstname = faker.getFirstName()
    And def addressline = faker.getAddressLine()
    And set updateCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/UpdateCounty-v1.001.json"      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | entityId        | getCountyResponse.results[0].id            |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | commandUserId   | commandUserId                              |
      | entityVersion   | getCountyResponse.results[0].entityVersion |
      | tags            | []                                         |
      | commandType     | "UpdateCounty"                             |
      | entityName      | "County"                                   |
    And set updateCommandBody
      | path              |                                              0 |
      | id                | getCountyResponse.results[0].id                |
      | name              | firstname                                      |
      | code              | getCountyResponse.results[0].code              |
      | isActive          | faker.getRandomBoolean()                       |
      | officialsName     | faker.getFirstName()                           |
      | officialsTitle    | faker.getLastName()                            |
      | startOfFiscalYear | getCountyResponse.results[0].startOfFiscalYear |
      | stateFipsCode     |                                            111 |
      | countyFipsCode    |                                            222 |
    And set updateCommandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set updateCountyPayload
      | path         | [0]                     |
      | header       | updateCommandHeader[0]  |
      | body         | updateCommandBody[0]    |
      | body.address | updateCommandAddress[0] |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 201
    And def updateCountyResponse = response
    And print updateCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyMasterCollectionName+<tenantid>,getCountyResponse.results[0].id )
    And print mongoResult
    And match mongoResult == getCountyResponse.results[0].id
    And match updateCountyResponse.body.name == firstname
    And match updateCountyPayload.body.address.addressLine2 == updateCountyResponse.body.address.addressLine2
    And sleep(10000)
    # Get the county information using GET event
    And def result1 = call read('CreateCounty.feature@getCountyDetails')
    And def getUpdatedCountyResponse = result1.response
    And print getUpdatedCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyMasterCollectionNameRead+<tenantid>,updateCountyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getUpdatedCountyResponse.results[0].id
    And match getUpdatedCountyResponse.results[0].address.addressLine1 == updateCountyResponse.body.address.addressLine1
    And sleep(15000)
    #History Validation
    And def eventName = "CountyUpdated"
    And def evnentType = "County"
    And def entityIdData = getUpdatedCountyResponse.results[0].id
    And def parentEntityId = getUpdatedCountyResponse.results[0].id
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
    And def entityName = "County"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getUpdatedCountyResponse.results[0].id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@CreateEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And print updatedEntityComment
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    #updating the comments 2nd time
    And def updatedEntityComment = faker.getFirstName()
    And print updatedEntityComment
    And def commentEntityID1 = updatedCommentResponse.body.id
    And def updateCommentResult1 = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID1 : '#(commentEntityID1)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse1 = updateCommentResult1.response
    And print updatedCommentResponse1
    And match updatedCommentResponse1.body.comment == updatedEntityComment
    #updating the comments 3rd time
    And def updatedEntityComment = faker.getFirstName()
    And print updatedEntityComment
    And def commentEntityID1 = updatedCommentResponse.body.id
    And def updateCommentResult2 = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@UpdateEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID1 : '#(commentEntityID1)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse2 = updateCommentResult2.response
    And match updatedCommentResponse2.body.comment == updatedEntityComment
    # view the comment before delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments before delete
    And def evnentType = "County"
    And def entityIdData = getUpdatedCountyResponse.results[0].id
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
    And def evnentType = "County"
    And def entityIdData = getUpdatedCountyResponse.results[0].id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a County with mandatory fields and validate the updated details
    Given url commandBaseUrl
    And path '/api/UpdateCounty'
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And def firstname = faker.getFirstName()
    And def addressline = faker.getAddressLine()
    And set updateCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateCounty-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | entityId        | getCountyResponse.results[0].id         |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | []                                      |
      | commandType     | "UpdateCounty"                          |
      | entityName      | "County"                                |
    And set updateCommandBody
      | path              |                               0 |
      | id                | getCountyResponse.results[0].id |
      | name              | firstname                       |
      | code              | faker.getUserId()               |
      | isActive          | faker.getRandomBoolean()        |
      | officialsName     | faker.getFirstName()            |
      | officialsTitle    | faker.getLastName()             |
      | startOfFiscalYear | faker.getRandomMonth()          |
      | stateFipsCode     |                             111 |
      | countyFipsCode    |                             222 |
    And set updateCommandAddress
      | path         |                      0 |
      | addressLine1 | addressline            |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set updateCountyPayload
      | path         | [0]                     |
      | header       | updateCommandHeader[0]  |
      | body         | updateCommandBody[0]    |
      | body.address | updateCommandAddress[0] |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 201
    And def updateCountyResponse = response
    And print updateCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyMasterCollectionName+<tenantid>,getCountyResponse.results[0].id )
    And print mongoResult
    And match mongoResult == getCountyResponse.results[0].id
    And match updateCountyResponse.body.name == firstname
    And match addressline == updateCountyResponse.body.address.addressLine1
    #Get the county information using GET event
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getUpdatedCountyResponse = result.response
    And print getUpdatedCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyMasterCollectionNameRead+<tenantid>,updateCountyResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getUpdatedCountyResponse.results[0].id
    And match getUpdatedCountyResponse.results[0].address.addressLine1 == updateCountyResponse.body.address.addressLine1
    And sleep(15000)
    # History Validation
    And def eventName = "CountyUpdated"
    And def evnentType = "County"
    And def entityIdData = getUpdatedCountyResponse.results[0].id
    And def parentEntityId = getUpdatedCountyResponse.results[0].id
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
    And def entityName = "County"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getUpdatedCountyResponse.results[0].id
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
    And def evnentType = "County"
    And def entityIdData = getUpdatedCountyResponse.results[0].id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    And def viewCommentsResponseCount = karate.sizeOf(viewCommentsResponse.results)
    And print viewCommentsResponseCount
    And match viewCommentsResponseCount == viewCommentsResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyWithInvalidData
  Scenario Outline: Update a County with invalid data for mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateCounty'
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And def firstname = faker.getFirstName()
    And def addressline = faker.getAddressLine()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateCounty-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | getCountyResponse.results[0].id         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | []                                      |
      | commandType     | "UpdateCounty"                          |
      | entityName      | "County"                                |
    And set commandBody
      | path              |                               0 |
      | id                | getCountyResponse.results[0].id |
      | name              | firstname                       |
      | code              | faker.getUserId()               |
      | isActive          | faker.getRandomBoolean()        |
      | officalsName      | faker.getRandomBoolean()        |
      | officalsTitle     | faker.getLastName()             |
      | startOffiscalYear | faker.getRandomMonth()          |
      | stateFipsCode     | faker.getRandomMonth()          |
      | countyFipsCode    |                             222 |
    And set commandAddress
      | path         |                0 |
      | addressLine1 | addressline      |
      | city         | faker.getCity()  |
      | state        | faker.getState() |
      | zipCode      | faker.getZip()   |
    And set updateCountyPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCountyWithMissingMandatoryFields
  Scenario Outline: Update a County with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateCounty'
    And def result = call read('CreateCounty.feature@getCountyDetails')
    And def getCountyResponse = result.response
    And print getCountyResponse
    And def firstname = faker.getFirstName()
    And def addressline = faker.getAddressLine()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateCounty-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | getCountyResponse.results[0].id         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | []                                      |
      | commandType     | "UpdateCounty"                          |
      | entityName      | "County"                                |
    And set commandBody
      | path              |                               0 |
      | id                | getCountyResponse.results[0].id |
      | name              | firstname                       |
      | code              | faker.getUserId()               |
      | isActive          | faker.getRandomBoolean()        |
      | officalsName      | faker.getRandomBoolean()        |
      | officalsTitle     | faker.getLastName()             |
      | startOffiscalYear | faker.getRandomMonth()          |
      | stateFipsCode     |                             111 |
    And set commandAddress
      | path         |                0 |
      | addressLine1 | addressline      |
      | city         | faker.getCity()  |
      | state        | faker.getState() |
      | zipCode      | faker.getZip()   |
    And set updateCountyPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
