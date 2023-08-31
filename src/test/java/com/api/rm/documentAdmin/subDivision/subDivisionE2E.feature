@SubDivisionInformation
Feature: SubDivision - Add , Update ,get , getall

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def SDcollectionname = 'CreateSubdivisionInformation_'
    And def SDcollectionNameRead = 'SubdivisionInformationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateSubDivisionWithGetDetails
  Scenario Outline: Create SubDivision Code with all the fields and Get the details
    Given url readBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addsubDivisionResponse = result.response
    And print addsubDivisionResponse
    Given url readBaseUrl
    #GetSubDivision
    And path '/api/GetSubdivisionInformation'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | addsubDivisionResponse.header.sourceId             |
      | tenantId        | <tenantid>                                         |
      | id              | addsubDivisionResponse.header.id                   |
      | correlationId   | addsubDivisionResponse.header.correlationId        |
      | commandUserId   | addsubDivisionResponse.header.commandUserId        |
      | tags            | []                                                 |
      | commandType     | "GetSubdivisionInformation"                        |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path       |                              0 |
      | request.id | addsubDivisionResponse.body.id |
    And set getSubDivisionPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getSubDivisionPayload
    And sleep(15000)
    And request getSubDivisionPayload
    When method POST
    Then status 200
    And def getSubDivisionAPIResponse = response
    And print getSubDivisionAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addsubDivisionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.code == addsubDivisionResponse.body.code
    #Get All SubDivision code Info
    Given url readBaseUrl
    And path '/api/GetSubdivisionInformations'
    And set getSubDivisonsCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addsubDivisionResponse.header.sourceId              |
      | tenantId        | <tenantid>                                          |
      | id              | addsubDivisionResponse.header.id                    |
      | correlationId   | addsubDivisionResponse.header.correlationId         |
      | commandUserId   | addsubDivisionResponse.header.commandUserId         |
      | tags            | []                                                  |
      | commandType     | "GetSubdivisionInformations"                        |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getSubDivisonsCommandBodyRequest
      | path             |    0 |
      | request.isActive | true |
    And set getSubDivisonsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getSubDivisionsPayload
      | path                | [0]                                 |
      | header              | getSubDivisonsCommandHeader[0]      |
      | body                | getSubDivisonsCommandBodyRequest[0] |
      | body.paginationSort | getSubDivisonsCommandPagination[0]  |
    And print getSubDivisionsPayload
    And request getSubDivisionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getSubDivisionsResponse = response
    And print getSubDivisionsResponse
    And match each getSubDivisionsResponse.results[*].isActive == getSubDivisionsPayload.body.request.isActive
    And def getSubDivisionsResponseCount = karate.sizeOf(getSubDivisionsResponse.results)
    And print getSubDivisionsResponseCount
    And match getSubDivisionsResponseCount == getSubDivisionsResponse.totalRecordCount
    #Adding the comment
    And def entityName = "SubdivisionInformation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addsubDivisionResponse.body.id
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
    And def evnentType = "SubdivisionInformation"
    And def entityIdData = addsubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "SubdivisionInformationCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addsubDivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.id == addsubDivisionResponse.body.id
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

  @CreateSubDivisionWithMandatoryDetails @Sanity
  Scenario Outline: Create a SubDivision info  with Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And set commandSubDivisionHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateSubdivisionInformation-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | "CreateSubdivisionInformation"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | entityVersion   |                                                     1 |
      | entityId        | entityIdData                                          |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | entityName      | "SubdivisionInformation"                              |
    And set commandSubdivisionBody
      | path          |                                              0 |
      | id            | entityIdData                                   |
      | code          | faker.getRandomNumber()                        |
      | description   | faker.getDescription()                         |
      | areaCode.id   | createAreaMaintenanceResponse.body.id          |
      | areaCode.name | createAreaMaintenanceResponse.body.description |
      | areaCode.code | createAreaMaintenanceResponse.body.areaCode    |
    And set addSubivisionPayload
      | path   | [0]                         |
      | header | commandSubDivisionHeader[0] |
      | body   | commandSubdivisionBody[0]   |
    And print addSubivisionPayload
    And request addSubivisionPayload
    When method POST
    Then status 201
    And def addsubDivisionResponse = response
    And print addsubDivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,SDcollectionname+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addsubDivisionResponse.body.id
    And match addsubDivisionResponse.body.code == addsubDivisionResponse.body.code
    #Get All SubDivision code Info
    Given url readBaseUrl
    And path '/api/GetSubdivisionInformations'
    And set getSubDivisonsCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addsubDivisionResponse.header.sourceId              |
      | tenantId        | <tenantid>                                          |
      | id              | addsubDivisionResponse.header.id                    |
      | correlationId   | addsubDivisionResponse.header.correlationId         |
      | commandUserId   | addsubDivisionResponse.header.commandUserId         |
      | tags            | []                                                  |
      | commandType     | "GetSubdivisionInformations"                        |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getSubDivisonsCommandBodyRequest
      | path             |    0 |
      | request.isActive | true |
    And set getSubDivisonsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getSubDivisionsPayload
      | path                | [0]                                 |
      | header              | getSubDivisonsCommandHeader[0]      |
      | body                | getSubDivisonsCommandBodyRequest[0] |
      | body.paginationSort | getSubDivisonsCommandPagination[0]  |
    And print getSubDivisionsPayload
    And request getSubDivisionsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getSubDivisionsResponse = response
    And print getSubDivisionsResponse
    And match each getSubDivisionsResponse.results[*].isActive == getSubDivisionsPayload.body.request.isActive
    And def getSubDivisionsResponseCount = karate.sizeOf(getSubDivisionsResponse.results)
    And print getSubDivisionsResponseCount
    And match getSubDivisionsResponseCount == getSubDivisionsResponse.totalRecordCount
    #GetSubDivision
    And path '/api/GetSubdivisionInformation'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | addsubDivisionResponse.header.sourceId             |
      | tenantId        | <tenantid>                                         |
      | id              | addsubDivisionResponse.header.id                   |
      | correlationId   | addsubDivisionResponse.header.correlationId        |
      | commandUserId   | addsubDivisionResponse.header.commandUserId        |
      | tags            | []                                                 |
      | commandType     | "GetSubdivisionInformation"                        |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path       |                              0 |
      | request.id | addsubDivisionResponse.body.id |
    And set getSubDivisionPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getSubDivisionPayload
    And sleep(15000)
    And request getSubDivisionPayload
    When method POST
    Then status 200
    And def getSubDivisionAPIResponse = response
    And print getSubDivisionAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addsubDivisionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.code == addsubDivisionResponse.body.code
    #Adding the comment
    And def entityName = "SubdivisionInformation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addsubDivisionResponse.body.id
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
    And def evnentType = "SubdivisionInformation"
    And def entityIdData = addsubDivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "SubdivisionInformationCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addsubDivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.id == addsubDivisionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateSubDivisionWithMandatoryDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a SubDivision with Mandatory the fields and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print  addSubdivisionResponse
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And path '/api/UpdateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateSubdivisionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addSubdivisionResponse.header.sourceId                |
      | tenantId        | <tenantid>                                            |
      | id              | addSubdivisionResponse.header.id                      |
      | correlationId   | addSubdivisionResponse.header.correlationId           |
      | entityId        | addSubdivisionResponse.header.entityId                |
      | commandUserId   | addSubdivisionResponse.header.commandUserId           |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | "UpdateSubdivisionInformation"                        |
      | entityName      | "SubdivisionInformation"                              |
      | ttl             |                                                     0 |
    And set commandSubdivisionBody
      | path          |                                              0 |
      | id            | addSubdivisionResponse.body.id                 |
      | code          | faker.getRandomNumber()                        |
      | description   | faker.getDescription()                         |
      | areaCode.id   | createAreaMaintenanceResponse.body.id          |
      | areaCode.name | createAreaMaintenanceResponse.body.description |
      | areaCode.code | createAreaMaintenanceResponse.body.areaCode    |
      | isActive      | true                                           |
    And set updateSubdivisionPayload
      | path   | [0]                               |
      | header | UpdateSubdivisionCommandHeader[0] |
      | body   | commandSubdivisionBody[0]         |
    And print updateSubdivisionPayload
    And request updateSubdivisionPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubdivisionResponse = response
    And print updateSubdivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addSubdivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateSubdivisionResponse.body.id
    And match updateSubdivisionResponse.body.areaCode.code == updateSubdivisionPayload.body.areaCode.code
    #Get All SubDivision code Info
    Given url readBaseUrl
    And path '/api/GetSubdivisionInformations'
    And set getSubDivisonsCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addSubdivisionResponse.header.sourceId              |
      | tenantId        | <tenantid>                                          |
      | id              | addSubdivisionResponse.header.id                    |
      | correlationId   | addSubdivisionResponse.header.correlationId         |
      | commandUserId   | addSubdivisionResponse.header.commandUserId         |
      | tags            | []                                                  |
      | commandType     | "GetSubdivisionInformations"                        |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getSubDivisonsCommandBodyRequest
      | path                  |                                            0 |
      | request.areaCode.code | updateSubdivisionResponse.body.areaCode.code |
    And set getSubDivisonsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getSubDivisionsPayload
      | path                | [0]                                 |
      | header              | getSubDivisonsCommandHeader[0]      |
      | body                | getSubDivisonsCommandBodyRequest[0] |
      | body.paginationSort | getSubDivisonsCommandPagination[0]  |
    And print getSubDivisionsPayload
    And request getSubDivisionsPayload
    When method POST
    Then status 200
    And sleep(20000)
    And def getSubDivisionsResponse = response
    And print getSubDivisionsResponse
    And match  getSubDivisionsResponse.results[0].areaCode.code == updateSubdivisionResponse.body.areaCode.code
    And def getSubDivisionsResponseCount = karate.sizeOf(getSubDivisionsResponse.results)
    And print getSubDivisionsResponseCount
    And match getSubDivisionsResponseCount == getSubDivisionsResponse.totalRecordCount
    #GetSubDivision
    And path '/api/GetSubdivisionInformation'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | addSubdivisionResponse.header.sourceId             |
      | tenantId        | <tenantid>                                         |
      | id              | addSubdivisionResponse.header.id                   |
      | correlationId   | addSubdivisionResponse.header.correlationId        |
      | commandUserId   | addSubdivisionResponse.header.commandUserId        |
      | tags            | []                                                 |
      | commandType     | "GetSubdivisionInformation"                        |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path       |                              0 |
      | request.id | addSubdivisionResponse.body.id |
    And set getSubDivisionPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getSubDivisionPayload
    And sleep(15000)
    And request getSubDivisionPayload
    When method POST
    Then status 200
    And def getSubDivisionAPIResponse = response
    And print getSubDivisionAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addSubdivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.code == addSubdivisionResponse.body.code
    #Adding the comment
    And def entityName = "SubdivisionInformation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addSubdivisionResponse.body.id
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
    And def evnentType = "SubdivisionInformation"
    And def entityIdData = addSubdivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "SubdivisionInformationUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatesubDivisionWithoutMandatoryFields
  Scenario Outline: Create a SubDIvision information without mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And set commandSubDivisionHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateSubdivisionInformation-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | "CreateSubdivisionInformation"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | entityVersion   |                                                     1 |
      | entityId        | entityIdData                                          |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | entityName      | "SubdivisionInformation"                              |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | entityIdData                                   |
      #| code           | faker.getRandomNumber()  |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | faker.getDirection()                           |
      | range          | faker.getRandomNumber()                        |
      | rangeDirection | faker.getDirection()                           |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      | isActive       | faker.getRandomBoolean()                       |
    And set addSubivisionPayload
      | path   | [0]                         |
      | header | commandSubDivisionHeader[0] |
      | body   | commandSubdivisionBody[0]   |
    And print addSubivisionPayload
    And request addSubivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateSubDivisionWithAllDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a SubDivision with all the fields and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print  addSubdivisionResponse
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And path '/api/UpdateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateSubdivisionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addSubdivisionResponse.header.sourceId                |
      | tenantId        | <tenantid>                                            |
      | id              | addSubdivisionResponse.header.id                      |
      | correlationId   | addSubdivisionResponse.header.correlationId           |
      | entityId        | addSubdivisionResponse.header.entityId                |
      | commandUserId   | addSubdivisionResponse.header.commandUserId           |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | "UpdateSubdivisionInformation"                        |
      | entityName      | "SubdivisionInformation"                              |
      | ttl             |                                                     0 |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | addSubdivisionResponse.body.id                 |
      | code           | faker.getRandomNumber()                        |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | faker.getDirection()                           |
      | range          | faker.getRandomNumber()                        |
      | rangeDirection | faker.getDirection()                           |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      | isActive       | faker.getRandomBoolean()                       |
    And set updateSubdivisionPayload
      | path   | [0]                               |
      | header | UpdateSubdivisionCommandHeader[0] |
      | body   | commandSubdivisionBody[0]         |
    And print updateSubdivisionPayload
    And request updateSubdivisionPayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateSubdivisionResponse = response
    And print updateSubdivisionResponse
    And print addSubdivisionResponse.body.id
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addSubdivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateSubdivisionResponse.body.id
    And match updateSubdivisionResponse.body.rangeDirection == updateSubdivisionPayload.body.rangeDirection
    And match updateSubdivisionResponse.body.areaCode.code == updateSubdivisionPayload.body.areaCode.code
    And sleep(10000)
    #Get All SubDivision code Info
    Given url readBaseUrl
    And path '/api/GetSubdivisionInformations'
    And set getSubDivisonsCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformations-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | addSubdivisionResponse.header.sourceId              |
      | tenantId        | <tenantid>                                          |
      | id              | addSubdivisionResponse.header.id                    |
      | correlationId   | addSubdivisionResponse.header.correlationId         |
      | commandUserId   | addSubdivisionResponse.header.commandUserId         |
      | tags            | []                                                  |
      | commandType     | "GetSubdivisionInformations"                        |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getSubDivisonsCommandBodyRequest
      | path             |    0 |
      | request.isActive | true |
    And set getSubDivisonsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getSubDivisionsPayload
      | path                | [0]                                 |
      | header              | getSubDivisonsCommandHeader[0]      |
      | body                | getSubDivisonsCommandBodyRequest[0] |
      | body.paginationSort | getSubDivisonsCommandPagination[0]  |
    And print getSubDivisionsPayload
    And request getSubDivisionsPayload
    When method POST
    Then status 200
    And sleep(25000)
    And def getSubDivisionsResponse = response
    And print getSubDivisionsResponse
    And match    getSubDivisionsResponse.results[0].code contains updateSubdivisionResponse.body.code
    And match   getSubDivisionsResponse.results[0].isActive == updateSubdivisionResponse.body.isActive
    And def getSubDivisionsResponseCount = karate.sizeOf(getSubDivisionsResponse.results)
    And print getSubDivisionsResponseCount
    And match getSubDivisionsResponseCount == getSubDivisionsResponse.totalRecordCount
    #GetSubDivision
    And path '/api/GetSubdivisionInformation'
    And set getCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | addSubdivisionResponse.header.sourceId             |
      | tenantId        | <tenantid>                                         |
      | id              | addSubdivisionResponse.header.id                   |
      | correlationId   | addSubdivisionResponse.header.correlationId        |
      | commandUserId   | addSubdivisionResponse.header.commandUserId        |
      | tags            | []                                                 |
      | commandType     | "GetSubdivisionInformation"                        |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getCommandBody
      | path       |                              0 |
      | request.id | addSubdivisionResponse.body.id |
    And set getSubDivisionPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getSubDivisionPayload
    And sleep(15000)
    And request getSubDivisionPayload
    When method POST
    Then status 200
    And def getSubDivisionAPIResponse = response
    And print getSubDivisionAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addSubdivisionResponse.body.id)
    And print mongoResult
    And match mongoResult == getSubDivisionAPIResponse.id
    And match getSubDivisionAPIResponse.id == addSubdivisionResponse.body.id
    And match getSubDivisionAPIResponse.code == addSubdivisionResponse.body.code
    #Adding the comment
    And def entityName = "SubdivisionInformation"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = addSubdivisionResponse.body.id
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
    And def evnentType = "SubdivisionInformation"
    And def entityIdData = addSubdivisionResponse.body.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "SubdivisionInformationUpdated"
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

  @UpdateSubDivisionInformationWithMissingMandatoryFields
  Scenario Outline: Update a SubDivision Info with missing mandatory fields
    Given url commandBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print  addSubdivisionResponse
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And path '/api/UpdateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateSubdivisionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addSubdivisionResponse.header.sourceId                |
      | tenantId        | <tenantid>                                            |
      | id              | addSubdivisionResponse.header.id                      |
      | correlationId   | addSubdivisionResponse.header.correlationId           |
      | entityId        | addSubdivisionResponse.header.entityId                |
      | commandUserId   | addSubdivisionResponse.header.commandUserId           |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | "UpdateSubdivisionInformation"                        |
      | entityName      | "SubdivisionInformation"                              |
      | ttl             |                                                     0 |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | addSubdivisionResponse.body.id                 |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | faker.getDirection()                           |
      | range          | faker.getRandomNumber()                        |
      | rangeDirection | faker.getDirection()                           |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      | isActive       | faker.getRandomBoolean()                       |
    And set updateSubdivisionPayload
      | path   | [0]                               |
      | header | UpdateSubdivisionCommandHeader[0] |
      | body   | commandSubdivisionBody[0]         |
    And print updateSubdivisionPayload
    And request updateSubdivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateSubDivisionInformationWithInvalidData
  Scenario Outline: Update a SubDivision with invalid data to mandatory fields
    Given url commandBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print  addSubdivisionResponse
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And path '/api/UpdateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateSubdivisionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addSubdivisionResponse.header.sourceId                |
      | tenantId        | <tenantid>                                            |
      | id              | addSubdivisionResponse.header.id                      |
      | correlationId   | addSubdivisionResponse.header.correlationId           |
      | entityId        | addSubdivisionResponse.header.entityId                |
      | commandUserId   | addSubdivisionResponse.header.commandUserId           |
      | entityVersion   |                                                     2 |
      | tags            | []                                                    |
      | commandType     | "UpdateSubdivisionInformation"                        |
      | entityName      | "SubdivisionInformation"                              |
      | ttl             |                                                     0 |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | addSubdivisionResponse.body.id                 |
      | code           | faker.getRandomNumber()                        |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | faker.getDirection()                           |
      | range          | faker.getRandomNumber()                        |
      | rangeDirection | faker.getDirection()                           |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      # should be boolean
      | isActive       | faker.getRandomNumber()                        |
    And set updateSubdivisionPayload
      | path   | [0]                               |
      | header | UpdateSubdivisionCommandHeader[0] |
      | body   | commandSubdivisionBody[0]         |
    And print updateSubdivisionPayload
    And request updateSubdivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubDivisionWithInvalidDataToMandatoryFields
  Scenario Outline: Create a Sub Division info with Invalid Data to mandatory fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And set commandSubDivisionHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateSubdivisionInformation-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | "CreateSubdivisionInformation"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | entityVersion   |                                                     1 |
      | entityId        | entityIdData                                          |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | entityName      | "SubdivisionInformation"                              |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | entityIdData                                   |
      | code           | faker.getRandomNumber()                        |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | faker.getDirection()                           |
      | range          | faker.getRandomNumber()                        |
      | rangeDirection | faker.getDirection()                           |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      | isActive       | faker.getRandomNumber()                        |
    And set addSubivisionPayload
      | path   | [0]                         |
      | header | commandSubDivisionHeader[0] |
      | body   | commandSubdivisionBody[0]   |
    And print addSubivisionPayload
    And request addSubivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDuplicateSubDivisioN
  Scenario Outline: Update a SubDivision with with Duplicate subDivision Code
    #Create SubDivision code and Update
    Given url commandBaseUrl
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print addSubdivisionResponse
    #Creating another SubDivision code
    And def result1 = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse1 = result1.response
    And print addSubdivisionResponse1
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And path '/api/UpdateSubdivisionInformation'
    And set updateSubdivisionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/UpdateSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | addSubdivisionResponse.header.sourceId                |
      | tenantId        | <tenantid>                                            |
      | id              | addSubdivisionResponse.header.id                      |
      | correlationId   | addSubdivisionResponse.header.correlationId           |
      | entityId        | addSubdivisionResponse.header.entityId                |
      | commandUserId   | addSubdivisionResponse.header.commandUserId           |
      | entityVersion   |                                                     1 |
      | tags            | []                                                    |
      | commandType     | "UpdateSubdivisionInformation"                        |
      | entityName      | "SubdivisionInformation"                              |
      | ttl             |                                                     0 |
    And set updateSubdivisionCommandBody
      | path        |                                      0 |
      | id          | addSubdivisionResponse.header.entityId |
      | code        | addSubdivisionResponse1.body.code      |
      | description | faker.getRandomNumber()                |
    And set updateSubdivisionCommandAreaCode
      | path |                                         0 |
      | id   | addSubdivisionResponse.body.areaCode.id   |
      | code | addSubdivisionResponse.body.areaCode.code |
      | name | addSubdivisionResponse.body.areaCode.name |
    And set updateSubdivisionPayload
      | path          | [0]                                 |
      | header        | updateSubdivisionCommandHeader[0]   |
      | body          | updateSubdivisionCommandBody[0]     |
      | body.areaCode | updateSubdivisionCommandAreaCode[0] |
    And print updateSubdivisionPayload
    And request updateSubdivisionPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @ValidateCreateSubDivisionWithDuplicateCode
  Scenario Outline: Create a SubDIvision information with Duplicate Code
    #Create SubDivision code
    Given url commandBaseUrl
    And path '/api/CreateSubdivisionInformation'
    And def result = call read('subDivision.feature@CreateSubDivisionWithAllDetails')
    And def addSubdivisionResponse = result.response
    And print addSubdivisionResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandSubDivisionHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateSubdivisionInformation-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | "CreateSubdivisionInformation"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | entityVersion   |                                                     1 |
      | entityId        | entityIdData                                          |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | entityName      | "SubdivisionInformation"                              |
    And set commandSubdivisionBody
      | path           |                                         0 |
      | id             | entityIdData                              |
      | code           | addSubdivisionResponse.body.code          |
      | description    | faker.getDescription()                    |
      | phase          | faker.getDescription()                    |
      | areaCode.id    | addSubdivisionResponse.body.areaCode.id   |
      | areaCode.name  | addSubdivisionResponse.body.areaCode.name |
      | areaCode.code  | addSubdivisionResponse.body.areaCode.code |
      | townCode       | faker.getZip()                            |
      | townDirection  | faker.getDirection()                      |
      | range          | faker.getRandomNumber()                   |
      | rangeDirection | faker.getDirection()                      |
      | liber          | faker.getRandomNumber()                   |
      | page           | faker.getRandomNumber()                   |
      | isActive       | faker.getRandomBoolean()                  |
    And set addSubivisionPayload
      | path   | [0]                         |
      | header | commandSubDivisionHeader[0] |
      | body   | commandSubdivisionBody[0]   |
    And print addSubivisionPayload
    And request addSubivisionPayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:SubdivisionInformation cannot be created.'

    Examples: 
      | tenantid    |
      | tenantID[0] |