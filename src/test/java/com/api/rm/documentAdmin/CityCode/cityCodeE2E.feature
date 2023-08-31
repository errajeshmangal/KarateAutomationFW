@cityCodeE2EFeature
Feature: City Code   - Add , Update ,get , GetAll

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def cityCodecollectionname = 'CreateCityCode_'
    And def cityCodecollectionNameRead = 'CityCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCityCodeWithAllDetail
  Scenario Outline: Create a city code with all the fields and Get the details
    Given url commandBaseUrl
    And def result = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse = result.response
    And print addCityCodeResponse
    And def entityIdData = dataGenerator.entityID()
    #GetCityCode
    Given url readBaseUrl
    And path '/api/GetCityCode'
    And set getCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetCityCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetCityCode"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getCommandBody
      | path       |                           0 |
      | request.id | addCityCodeResponse.body.id |
    And set getCityCodePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCityCodePayload
    And request getCityCodePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodeAPIResponse = response
    And print getCityCodeAPIResponse
    And print entityIdData
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.cityCode == addCityCodeResponse.body.cityCode
    #Get All CityCode
    Given url readBaseUrl
    And path '/api/GetCityCodes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetCityCodes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | getType         | "Array"                                 |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetCityCodes"                          |
      | ttl             |                                       0 |
    And set getCityCodesCommandBody
      | path                        |                               0 |
      | request.cityCode            | getCityCodeAPIResponse.cityCode |
      | request.distributionPercent |                              .5 |
      | paginationSort.currentPage  |                               1 |
      | paginationSort.pageSize     |                            1000 |
      | paginationSort.isAscending  | true                            |
      | paginationSort.sortBy       | "lastUpdatedDateTime"           |
    And set geCityCodesPayload
      | path   | [0]                        |
      | header | getCommandHeader[0]        |
      | body   | getCityCodesCommandBody[0] |
    And print geCityCodesPayload
    And request geCityCodesPayload
    When method POST
    Then status 200
    And def getCityCodesAPIResponse = response
    And print getCityCodesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id )
    And print mongoResult
    And def getCityCodesAPIResponseCount = karate.sizeOf(getCityCodesAPIResponse.results)
    And print getCityCodesAPIResponseCount
    And match getCityCodesAPIResponseCount == getCityCodesAPIResponse.totalRecordCount
    And match each getCityCodesAPIResponse.results[*].active == true
    And match   getCityCodesAPIResponse.results[*].cityCode == getCityCodeAPIResponse.cityCode
    #Adding the comment
    And def entityName = "CityCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCityCodeAPIResponse.id
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
    And def evnentType = "CityCode"
    And def entityIdData = getCityCodeAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CityCodeCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.description == addCityCodeResponse.body.description
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

  @CreateCityCodeWithMandatoryDetails
  Scenario Outline: Create a CityCode with Mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "CreateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                    |                             0 |
      | id                      | entityIdData                  |
      | cityCode                | faker.getCityCode()           |
      | description             | faker.getCity()               |
      | cityType                | faker.getCityType()           |
      | cityDistributionPercent | faker.getRandomInteger(0.5,1) |
      | isActive                | faker.getRandomBoolean()      |
    And set addCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print addCityCodePayload
    And request addCityCodePayload
    When method POST
    Then status 201
    And def addCityCodeResponse = response
    And print addCityCodeResponse
    #GetCityCode
    Given url readBaseUrl
    And path '/api/GetCityCode'
    And set getCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetCityCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetCityCode"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getCommandBody
      | path       |                           0 |
      | request.id | addCityCodeResponse.body.id |
    And set getCityCodePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCityCodePayload
    And request getCityCodePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodeAPIResponse = response
    And print getCityCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.cityCode == addCityCodeResponse.body.cityCode
    #Get All CityCode
    Given url readBaseUrl
    And path '/api/GetCityCodes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetCityCodes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | getType         | "Array"                                 |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetCityCodes"                          |
      | ttl             |                                       0 |
    And set getCommandBody
      | path                       |                     0 |
      | request.isActive           | true                  |
      | paginationSort.currentPage |                     1 |
      | paginationSort.pageSize    |                  1000 |
      | paginationSort.sortBy      | "lastUpdatedDateTime" |
      | paginationSort.isAscending | true                  |
    And set geCityCodesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print geCityCodesPayload
    And request geCityCodesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodesAPIResponse = response
    And print getCityCodesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,getCityCodeResponse.id )
    And print mongoResult
    And def getCityCodesAPIResponseCount = karate.sizeOf(getCityCodesAPIResponse.results)
    And print getCityCodesAPIResponseCount
    And match getCityCodesAPIResponseCount == getCityCodesAPIResponse.totalRecordCount
    And match each getCityCodesAPIResponse.results[*].active == true
    #Adding the comment
    And def entityName = "CityCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCityCodeAPIResponse.id
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
    And def evnentType = "CityCode"
    And def entityIdData = getCityCodeAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CityCodeCreated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.description == addCityCodeResponse.body.description

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCityCodeWithoutMandatoryFields
  Scenario Outline: Create a CityCode information without mandatory fields
    Given url  commandBaseUrl
    And path '/api/CreateCityCode'
    And def entityIdData = dataGenerator.entityID()
    When def accountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def accountCodeResponse = accountCodeResult.response
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "CreateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                         |                                   0 |
      | id                           | entityIdData                        |
      | description                  | faker.getCity()                     |
      | cityType                     | faker.getCityType()                 |
      | cityDistributionPercent      | faker.getRandomInteger(0.5,1)       |
      | cityDistributionAccount.id   | accountCodeResponse.results[0].id   |
      | cityDistributionAccount.code | accountCodeResponse.results[0].code |
      | parentCity.id                | faker.UUID()                        |
      | parentCity.code              | faker.getCityCode()                 |
      | isActive                     | faker.getRandomBoolean()            |
      | roundUpHalfCent              | faker.getRandomBoolean()            |
    And set addCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print addCityCodePayload
    And request addCityCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCityCodeWithInvalidDataToMandatoryFields
  Scenario Outline: Create a CityCode information with Invalid Data to Mandatory Fields
    Given url  commandBaseUrl
    And path '/api/CreateCityCode'
    And def entityIdData = dataGenerator.entityID()
    When def accountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def accountCodeResponse = accountCodeResult.response
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "CreateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                         |                                   0 |
      | id                           | entityIdData                        |
      | cityCode                     | faker.getCityCode()                 |
      | description                  | faker.getCity()                     |
      | cityType                     | faker.getCityType()                 |
      | cityDistributionPercent      | faker.getRandomInteger(0.5,1)       |
      | cityDistributionAccount.id   | accountCodeResponse.results[0].id   |
      | cityDistributionAccount.code | accountCodeResponse.results[0].code |
      | parentCity.id                | faker.UUID()                        |
      | parentCity.code              | faker.getCityCode()                 |
      # IsActive field should be boolean
      | isActive                     | faker.getRandomBoolean()            |
      | roundUpHalfCent              | faker.getRandomBoolean()            |
    And set addCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print addCityCodePayload
    And request addCityCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCityCodeWithAllDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a city code with all the fields and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse = result.response
    And print addCityCodeResponse
    And def accountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def accountCodeResponse = accountCodeResult.response
    And print accountCodeResponse
    And path '/api/UpdateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateCityCodeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateCityCode-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | entityId        | addCityCodeResponse.header.entityId      |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateCityCode"                         |
      | entityName      | "CityCode"                               |
      | ttl             |                                        0 |
    And set commandCityCodeBody
      | path                         |                                     0 |
      | id                           | addCityCodeResponse.body.id           |
      | cityCode                     | addCityCodeResponse.body.cityCode     |
      | description                  | faker.getCity()                       |
      | cityType                     | faker.getCityType()                   |
      | cityDistributionPercent      |                                   0.5 |
      | cityDistributionAccount.id   | accountCodeResponse.body.id           |
      | cityDistributionAccount.code | accountCodeResponse.body.accountCode2 |
      | parentCity.id                | faker.UUID()                          |
      | parentCity.code              | faker.getCityCode()                   |
      | isActive                     | faker.getRandomBoolean()              |
      | roundUpHalfCent              | faker.getRandomBoolean()              |
    And set updateCityCodePayload
      | path   | [0]                            |
      | header | UpdateCityCodeCommandHeader[0] |
      | body   | commandCityCodeBody[0]         |
    And print updateCityCodePayload
    And request updateCityCodePayload
    When method POST
    Then status 201
    And sleep(10000)
    And def updateCityCodeResponse = response
    And print updateCityCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateCityCodeResponse.body.id
    And match updateCityCodeResponse.body.cityCode == updateCityCodePayload.body.cityCode
    And match updateCityCodeResponse.body.description == updateCityCodePayload.body.description
    #Get All City Code Info
    Given url readBaseUrl
    And path '/api/GetCityCodes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetCityCodes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | getType         | "Array"                                 |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetCityCodes"                          |
      | ttl             |                                       0 |
    And set getCommandBody
      | path                       |                                       0 |
      | request.cityName           | updateCityCodeResponse.body.description |
      | paginationSort.currentPage |                                       1 |
      | paginationSort.pageSize    |                                    1000 |
      | paginationSort.sortBy      | "lastUpdatedDateTime"                   |
      | paginationSort.isAscending | true                                    |
    And set geCityCodesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print geCityCodesPayload
    And request geCityCodesPayload
    When method POST
    Then status 200
    And def getCityCodesAPIResponse = response
    And print getCityCodesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id )
    And print mongoResult
    And def getCityCodesAPIResponseCount = karate.sizeOf(getCityCodesAPIResponse.results)
    And print getCityCodesAPIResponseCount
    And match getCityCodesAPIResponseCount == getCityCodesAPIResponse.totalRecordCount
    And match getCityCodesAPIResponse.results[0].description ==  updateCityCodeResponse.body.description
    #GetCityCode
    Given url readBaseUrl
    And path '/api/GetCityCode'
    And set getCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetCityCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetCityCode"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getCommandBody
      | path       |                           0 |
      | request.id | addCityCodeResponse.body.id |
    And set getCityCodePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCityCodePayload
    And request getCityCodePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodeAPIResponse = response
    And print getCityCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.cityCode == addCityCodeResponse.body.cityCode
    #Adding the comment
    And def entityName = "CityCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCityCodeAPIResponse.id
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
    And def evnentType = "CityCode"
    And def entityIdData = getCityCodeAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CityCodeUpdated"
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

  @UpdateCityCodeWithMandatoryDetailsAndGetTheUpdatedDetails
  Scenario Outline: Update a city code with Mandatory fields and Validate the updated details
    Given url commandBaseUrl
    And def result = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse = result.response
    And print addCityCodeResponse
    When def accountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def accountCodeResponse = accountCodeResult.response
    And path '/api/UpdateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set UpdateCityCodeCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateCityCode-v1.001.json"  |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | entityId        | addCityCodeResponse.header.entityId      |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | entityVersion   |                                        2 |
      | tags            | []                                       |
      | commandType     | "UpdateCityCode"                         |
      | entityName      | "CityCode"                               |
      | ttl             |                                        0 |
    And set commandCityCodeBody
      | path                    |                                 0 |
      | id                      | addCityCodeResponse.body.id       |
      | cityCode                | addCityCodeResponse.body.cityCode |
      | description             | faker.getCity()                   |
      | cityType                | faker.getCityType()               |
      | cityDistributionPercent | faker.getRandomInteger(0.5,1)     |
    And set updateCityCodePayload
      | path   | [0]                            |
      | header | UpdateCityCodeCommandHeader[0] |
      | body   | commandCityCodeBody[0]         |
    And print updateCityCodePayload
    And request updateCityCodePayload
    When method POST
    Then status 201
    And sleep(15000)
    And def updateCityCodeResponse = response
    And print updateCityCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateCityCodeResponse.body.id
    And match updateCityCodeResponse.body.cityCode == updateCityCodePayload.body.cityCode
    And match updateCityCodeResponse.body.description == updateCityCodePayload.body.description
    #Get All City Code Info
    Given url readBaseUrl
    And path '/api/GetCityCodes'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetCityCodes-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | getType         | "Array"                                 |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetCityCodes"                          |
      | ttl             |                                       0 |
    And set getCommandBody
      | path                       |                     0 |
      | request.isActive           | true                  |
      | paginationSort.currentPage |                     1 |
      | paginationSort.pageSize    |                  1000 |
      | paginationSort.sortBy      | "lastUpdatedDateTime" |
      | paginationSort.isAscending | true                  |
    And set geCityCodesPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print geCityCodesPayload
    And request geCityCodesPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodesAPIResponse = response
    And print getCityCodesAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id )
    And print mongoResult
    And def getCityCodesAPIResponseCount = karate.sizeOf(getCityCodesAPIResponse.results)
    And print getCityCodesAPIResponseCount
    And match getCityCodesAPIResponseCount == getCityCodesAPIResponse.totalRecordCount
    And match each getCityCodesAPIResponse.results[*].active == true
    #GetCityCode
    Given url readBaseUrl
    And path '/api/GetCityCode'
    And set getCommandHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetCityCode-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | tenantId        | <tenantid>                               |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | tags            | []                                       |
      | commandType     | "GetCityCode"                            |
      | getType         | "One"                                    |
      | ttl             |                                        0 |
    And set getCommandBody
      | path       |                           0 |
      | request.id | addCityCodeResponse.body.id |
    And set getCityCodePayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getCityCodePayload
    And request getCityCodePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCityCodeAPIResponse = response
    And print getCityCodeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id )
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.cityCode == updateCityCodePayload.body.cityCode
    #Adding the comment
    And def entityName = "CityCode"
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getCityCodeAPIResponse.id
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
    And def evnentType = "CityCode"
    And def entityIdData = getCityCodeAPIResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/Comments.feature@GetTheEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    # History Validation
    And def eventName = "CityCodeUpdated"
    And def commandUserid = commandUserId
    And def result = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,cityCodecollectionNameRead+<tenantid>,addCityCodeResponse.body.id)
    And print mongoResult
    And match mongoResult == getCityCodeAPIResponse.id
    And match getCityCodeAPIResponse.cityCode == addCityCodeResponse.body.cityCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCityCodeWithMissingMandatoryFields @negative
  Scenario Outline: Update a City Code with missing mandatory fields
    Given url commandBaseUrl
    And def result = call read('cityCodeE2E.feature@CreateCityCodeWithAllDetail')
    And def getCityCodeResponse = result.response
    And print getCityCodeResponse
    And path '/api/UpdateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "UpdateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | getCityCodeResponse.id                  |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                         |                                                0 |
      | id                           | getCityCodeResponse.id                           |
      | cityCode                     | faker.getCityCode()                              |
      | description                  | getCityCodeResponse.description                  |
      | cityType                     | getCityCodeResponse.cityType                     |
      | cityDistributionAccount.id   | getCityCodeResponse.cityDistributionAccount.id   |
      | cityDistributionAccount.code | getCityCodeResponse.cityDistributionAccount.code |
      | parentCity.id                | getCityCodeResponse.parentCity.id                |
      | parentCity.code              | getCityCodeResponse.parentCity.code              |
      | roundUpHalfCent              | faker.getRandomBoolean()                         |
      | isActive                     | faker.getRandomBoolean()                         |
    And set updateCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print updateCityCodePayload
    And request updateCityCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCityCodeWithInvalidData @negative
  Scenario Outline: Update a City code details with invalid data to mandatory fields
    Given url commandBaseUrl
    And def result = call read('cityCodeE2E.feature@CreateCityCodeWithAllDetail')
    And def getCityCodeResponse = result.response
    And print getCityCodeResponse
    And path '/api/UpdateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "UpdateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | getCityCodeResponse.id                  |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                         |                                                0 |
      | id                           | getCityCodeResponse.id                           |
      | cityCode                     | faker.getCityCode()                              |
      | description                  | getCityCodeResponse.description                  |
      | cityType                     | getCityCodeResponse.cityType                     |
      #Distribution percent is invalid with boolean
      | cityDistributionPercent      | faker.getRandomBoolean()                         |
      | cityDistributionAccount.id   | getCityCodeResponse.cityDistributionAccount.id   |
      | cityDistributionAccount.code | getCityCodeResponse.cityDistributionAccount.code |
      | parentCity.id                | getCityCodeResponse.parentCity.id                |
      | parentCity.code              | getCityCodeResponse.parentCity.code              |
      | roundUpHalfCent              | faker.getRandomBoolean()                         |
      | isActive                     | faker.getRandomBoolean()                         |
    And set updateCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print updateCityCodePayload
    And request updateCityCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDuplicateCityCodeValidation
  Scenario Outline: Create a City Code with Duplicate City Code
    Given url commandBaseUrl
    #Create CityCode and Update
    Given url commandBaseUrl
    And def result = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse = result.response
    And print addCityCodeResponse
    And path '/api/CreateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandCityCodeHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateCityCode-v1.001.json"  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | "CreateCityCode"                         |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | entityIdData                             |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | entityName      | "CityCode"                               |
    And set commandCityCodeBody
      | path                         |                                                     0 |
      | id                           | entityIdData                                          |
      | cityCode                     | addCityCodeResponse.body.cityCode                     |
      | description                  | addCityCodeResponse.body.description                  |
      | cityType                     | addCityCodeResponse.body.cityType                     |
      | cityDistributionPercent      | addCityCodeResponse.body.cityDistributionPercent      |
      | cityDistributionAccount.id   | addCityCodeResponse.body.cityDistributionAccount.id   |
      | cityDistributionAccount.code | addCityCodeResponse.body.cityDistributionAccount.code |
      | parentCity.id                | addCityCodeResponse.body.parentCity.id                |
      | parentCity.code              | addCityCodeResponse.body.parentCity.code              |
      | roundUpHalfCent              | faker.getRandomBoolean()                              |
      | isActive                     | faker.getRandomBoolean()                              |
    And set duplicateCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print duplicateCityCodePayload
    And request duplicateCityCodePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:CityCode cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDuplicateCityCodes @negative
  Scenario Outline: Update a City Code with Duplicate City Code
    Given url commandBaseUrl
    #Create CityCode and Update
    Given url commandBaseUrl
    And def result = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse = result.response
    And print addCityCodeResponse
    #Create CityCode2 and Update
    And def result1 = call read('cityCode.feature@CreateCityCodeWithAllDetails')
    And def addCityCodeResponse1 = result1.response
    And print addCityCodeResponse1
    And path '/api/UpdateCityCode'
    And def entityIdData = dataGenerator.entityID()
    And set commandCityCodeHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateCityCode-v1.001.json"  |
      | version         | "1.001"                                  |
      | sourceId        | addCityCodeResponse.header.sourceId      |
      | id              | addCityCodeResponse.header.id            |
      | correlationId   | addCityCodeResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | "UpdateCityCode"                         |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | addCityCodeResponse.body.id              |
      | commandUserId   | addCityCodeResponse.header.commandUserId |
      | entityName      | "CityCode"                               |
    And set commandCityCodeBody
      | path                         |                                                     0 |
      | id                           | addCityCodeResponse.body.id                           |
      | cityCode                     | addCityCodeResponse1.body.cityCode                    |
      | description                  | addCityCodeResponse.body.description                  |
      | cityType                     | addCityCodeResponse.body.cityType                     |
      | cityDistributionPercent      | addCityCodeResponse.body.cityDistributionPercent      |
      | cityDistributionAccount.id   | addCityCodeResponse.body.cityDistributionAccount.id   |
      | cityDistributionAccount.code | addCityCodeResponse.body.cityDistributionAccount.code |
      | parentCity.id                | addCityCodeResponse.body.parentCity.id                |
      | parentCity.code              | addCityCodeResponse.body.parentCity.code              |
      | roundUpHalfCent              | faker.getRandomBoolean()                              |
      | isActive                     | faker.getRandomBoolean()                              |
    And set updateCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print updateCityCodePayload
    And request updateCityCodePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CountyCitiesBasedOnFlag
  Scenario Outline: Validate the county Cities are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetParentCitysIdCodeName'
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetParentCitysIdCodeName-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetParentCitysIdCodeName"                        |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set commandBodyRequest
      | path     |    0 |
      | code     |      |
      | isActive | true |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCountyCitiesIdCodeNamePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getCountyCitiesIdCodeNamePayload
    And request getCountyCitiesIdCodeNamePayload
    When method POST
    Then status 200
    And def getCountyCitiesIdCodeNameResponse = response
    And print getCountyCitiesIdCodeNameResponse
    And match each getCountyCitiesIdCodeNameResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
