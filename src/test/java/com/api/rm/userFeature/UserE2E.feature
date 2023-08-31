@createFeature
Feature: Create a New User , Edit User

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def userCollectionName = 'CreateUser_'
    And def userCollectionNameRead = 'UserDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('../helpers/Wait.feature@wait')

  @createAndGetUserWithAllFields
  Scenario Outline: Scenario to create the new user and get the same user
    Given url readBaseUrl
    When path '/api/GetUsers'
    And def createUserResult = call read('CreateUser.feature@createUserWithAllFields')
    And def addUserResponse = createUserResult.response
    And print addUserResponse
    #HistoryValidation
    And def eventName = "UserCreated"
    And def evnentType = "User"
    And def entityIdData = addUserResponse.header.entityId
    And def commandUserid = commandUserId
    And def result = call read('../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    And sleep(20000)
    And set getUsersCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUsers-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | commandUserId   | commandUserId                           |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUsers"                              |
      | getType         | "Array"                                 |
    And set getUsersCommandBodyRequest
      | path |                0 |
      | id   | applicationID[0] |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getUsersPayload
      | path                | [0]                           |
      | header              | getUsersCommandHeader[0]      |
      | body.request        | getUsersCommandBodyRequest[0] |
      | body.paginationSort | getUsersCommandPagination[0]  |
    And print getUsersPayload
    And request getUsersPayload
    When method POST
    Then status 200
    And def getUsersResponse = response
    And print getUsersResponse
    And match getUsersResponse.results[*].id contains addUserResponse.body.id
    Given url readBaseUrl
    When path '/api/GetUser'
    And sleep(15000)
    And set getCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUser-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | commandUserId   | commandUserId                           |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUser"                               |
      | getType         | "One"                                   |
    And set getCommandRequest
      | path |                       0 |
      | id   | addUserResponse.body.id |
    And set getUserPayload
      | path         | [0]                  |
      | header       | getCommandHeader[0]  |
      | body.request | getCommandRequest[0] |
    And print getUserPayload
    And request getUserPayload
    When method POST
    Then status 200
    And def getUserResponse = response
    And print getUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,userCollectionNameRead+<tenantid>,addUserResponse.body.id)
    And print mongoResult
    And match mongoResult == getUserResponse.id
    And match getUserResponse.firstName == addUserResponse.body.firstName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createAndGetUserWithMandatoryFields
  Scenario Outline: Scenario to create the new user with only mandatory fields and get the same user
    Given url readBaseUrl
    When path '/api/GetUsers'
    And def createUserResult = call read('CreateUser.feature@createUserWithMandatoryFields')
    And def addUserResponse = createUserResult.response
    And print addUserResponse
    #HistoryValidation
    And def eventName = "UserCreated"
    And def evnentType = "User"
    And def entityIdData = addUserResponse.header.entityId
    And def commandUserid = commandUserId
    And def result = call read('../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    And sleep(20000)
    And set getUsersCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUsers-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | commandUserId   | commandUserId                           |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUsers"                              |
      | getType         | "Array"                                 |
    And set getUsersCommandBodyRequest
      | path |                0 |
      | id   | applicationID[0] |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getUsersPayload
      | path                | [0]                           |
      | header              | getUsersCommandHeader[0]      |
      | body.request        | getUsersCommandBodyRequest[0] |
      | body.paginationSort | getUsersCommandPagination[0]  |
    And print getUsersPayload
    And request getUsersPayload
    When method POST
    Then status 200
    And def getUsersResponse = response
    And print getUsersResponse
    And match getUsersResponse.results[*].id contains addUserResponse.body.id
    And match getUsersResponse.results[*].userId contains addUserResponse.body.userId
    Given url readBaseUrl
    When path '/api/GetUser'
    And sleep(20000)
    And set getUserCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUser-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | commandUserId   | commandUserId                           |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUser"                               |
      | getType         | "One"                                   |
    And set getUserCommandRequest
      | path |                       0 |
      | id   | addUserResponse.body.id |
    And set getUserPayload
      | path         | [0]                      |
      | header       | getUserCommandHeader[0]  |
      | body.request | getUserCommandRequest[0] |
    And print getUserPayload
    And request getUserPayload
    When method POST
    Then status 200
    And def getUserResponse = response
    And print getUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,userCollectionNameRead+<tenantid>,addUserResponse.body.id)
    And print mongoResult
    And match mongoResult == getUserResponse.id
    And match getUserResponse.userId == addUserResponse.body.userId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateUpdateAndGetUser
  Scenario Outline: Update the existing users Firstname and LastName and Retrieve the updated details
    Given url commandBaseUrl
    And path '/api/UpdateUser'
    And def createUserResult = call read('CreateUser.feature@createUserWithAllFields')
    And def addUserResponse = createUserResult.response
    And print addUserResponse
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | entityId        | addUserResponse.header.entityId         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | ["PII"]                                 |
      | commandType     | "UpdateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path      |                               0 |
      | id        | addUserResponse.header.entityId |
      | firstName | firstname                       |
      | lastName  | faker.getLastName()             |
      | userId    | faker.getEmail()                |
      | isActive  | true                            |
    And set updateUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print updateUserPayload
    And request updateUserPayload
    When method POST
    Then status 201
    And def updateUserResponse = response
    And print updateUserResponse
    And sleep(5000)
    And def updatemongoResult = mongoData.MongoDBReader(dbname,userCollectionName+<tenantid>,updateUserResponse.body.id )
    And print updatemongoResult
    And match updatemongoResult == updateUserResponse.body.id
    And match updateUserResponse.body.firstName == firstname
    #HistoryValidation
    And def eventName = "UserUpdated"
    And def entityIdData = updateUserResponse.body.id
    And def evnentType = "User"
    And def entityIdData = addUserResponse.header.entityId
    And def commandUserid = updateUserResponse.header.commandUserId
    And def result = call read('../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    And sleep(20000)
    Given url readBaseUrl
    When path '/api/GetUsers'
    And set getUsersCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUsers-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | updateUserResponse.header.sourceId      |
      | tenantId        | <tenantid>                              |
      | id              | updateUserResponse.header.id            |
      | correlationId   | updateUserResponse.header.correlationId |
      | commandUserId   | updateUserResponse.header.commandUserId |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUsers"                              |
      | getType         | "Array"                                 |
    And set getUsersCommandBodyRequest
      | path |                0 |
      | id   | applicationID[0] |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getUsersPayload
      | path                | [0]                           |
      | header              | getUsersCommandHeader[0]      |
      | body.request        | getUsersCommandBodyRequest[0] |
      | body.paginationSort | getUsersCommandPagination[0]  |
    And print getUsersPayload
    And request getUsersPayload
    When method POST
    Then status 200
    And def getUsersResponse = response
    And print getUsersResponse
    And match getUsersResponse.results[*].id contains updateUserResponse.body.id
    And match getUsersResponse.results[*].firstName contains updateUserResponse.body.firstName
    Given url readBaseUrl
    When path '/api/GetUser'
    And sleep(10000)
    And set getUserCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUser-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | updateUserResponse.header.sourceId      |
      | tenantId        | <tenantid>                              |
      | id              | updateUserResponse.header.id            |
      | correlationId   | updateUserResponse.header.correlationId |
      | commandUserId   | updateUserResponse.header.commandUserId |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUser"                               |
      | getType         | "One"                                   |
    And set getUserCommandRequest
      | path |                                  0 |
      | id   | updateUserResponse.header.entityId |
    And set getUserPayload
      | path         | [0]                      |
      | header       | getUserCommandHeader[0]  |
      | body.request | getUserCommandRequest[0] |
    And print getUserPayload
    And request getUserPayload
    When method POST
    Then status 200
    And def getUpdatedUserResponse = response
    And print getUpdatedUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,userCollectionNameRead+<tenantid>,getUpdatedUserResponse.id)
    And print mongoResult
    And match mongoResult == getUpdatedUserResponse.id
    And match getUpdatedUserResponse.firstName == updateUserResponse.body.firstName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateUpdateWithMandatoryfieldsAndGetUser
  Scenario Outline: Update the existing users mandatory fields and Retrieve the updated details
    Given url commandBaseUrl
    And path '/api/UpdateUser'
    And def createUserResult = call read('CreateUser.feature@createUserWithMandatoryFields')
    And def addUserResponse = createUserResult.response
    And def userEmail = faker.getEmail()
    And print addUserResponse
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | entityId        | addUserResponse.header.entityId         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | ["PII"]                                 |
      | commandType     | "UpdateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path   |                               0 |
      | id     | addUserResponse.header.entityId |
      | userId | userEmail                       |
    And set updateUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print updateUserPayload
    And request updateUserPayload
    When method POST
    Then status 201
    And def updateUserResponse = response
    And print updateUserResponse
    And sleep(5000)
    And def updatemongoResult = mongoData.MongoDBReader(dbname,userCollectionName+<tenantid>,updateUserResponse.header.entityId )
    And print updatemongoResult
    And match updatemongoResult == updateUserResponse.body.id
    And match updateUserResponse.body.userId == userEmail
    #HistoryValidation
    And def eventName = "UserUpdated"
    And def entityIdData = updateUserResponse.body.id
    And def evnentType = "User"
    And def commandUserid = updateUserResponse.header.commandUserId
    And def entityIdData = addUserResponse.header.entityId
    And def result = call read('../countyAdmin/HistoryComments/History.feature@GetEntityHistoryWithAllFields') {sourceid : '#(sourceid)'}{entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)' {commandUserid : '#(commandUserid)'}
    And sleep(20000)
    Given url readBaseUrl
    When path '/api/GetUsers'
    And set getUsersCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUsers-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | updateUserResponse.header.sourceId      |
      | tenantId        | <tenantid>                              |
      | id              | updateUserResponse.header.id            |
      | correlationId   | updateUserResponse.header.correlationId |
      | commandUserId   | updateUserResponse.header.commandUserId |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUsers"                              |
      | getType         | "Array"                                 |
    And set getUsersCommandBodyRequest
      | path |                0 |
      | id   | applicationID[0] |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getUsersPayload
      | path                | [0]                           |
      | header              | getUsersCommandHeader[0]      |
      | body.request        | getUsersCommandBodyRequest[0] |
      | body.paginationSort | getUsersCommandPagination[0]  |
    And print getUsersPayload
    And request getUsersPayload
    When method POST
    Then status 200
    And def getUsersResponse = response
    And print getUsersResponse
    And match getUsersResponse.results[*].id contains updateUserResponse.body.id
    And match getUsersResponse.results[*].userId contains updateUserResponse.body.userId
    Given url readBaseUrl
    When path '/api/GetUser'
    And sleep(10000)
    And set getUserCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetUser-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | updateUserResponse.header.sourceId      |
      | tenantId        | <tenantid>                              |
      | id              | updateUserResponse.header.id            |
      | correlationId   | updateUserResponse.header.correlationId |
      | commandUserId   | updateUserResponse.header.commandUserId |
      | ttl             |                                       0 |
      | tags            | []                                      |
      | commandType     | "GetUser"                               |
      | getType         | "One"                                   |
    And set getUserCommandRequest
      | path |                                  0 |
      | id   | updateUserResponse.header.entityId |
    And set getUserPayload
      | path         | [0]                      |
      | header       | getUserCommandHeader[0]  |
      | body.request | getUserCommandRequest[0] |
    And print getUserPayload
    And request getUserPayload
    When method POST
    Then status 200
    And def getUpdatedUserResponse = response
    And print getUpdatedUserResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,userCollectionNameRead+<tenantid>,getUpdatedUserResponse.id)
    And print mongoResult
    And match mongoResult == getUpdatedUserResponse.id
    And match getUpdatedUserResponse.userId == updateUserResponse.body.userId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createUserWithMissingField
  Scenario Outline: Scenario to create a single user with missing field
    Given url commandBaseUrl
    And path '/api/CreateUser'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | ["PII"]                                 |
      | commandType     | "CreateUser"                            |
      | entityName      | "User"                                  |
      | entityId        | entityIdData                            |
    And set commandBody
      | path |            0 |
      | id   | entityIdData |
    And set createUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print createUserPayload
    And request createUserPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createuserWithInvalidData
  Scenario Outline: Scenario to create a single user with invalid data to required fields
    Given url commandBaseUrl
    And path '/api/CreateUser'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | entityIdData                            |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | ["PII"]                                 |
      | commandType     | "CreateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path      |                       0 |
      | id        | faker.getRandomNumber() |
      | firstName | faker.getFirstName()    |
      | lastName  | faker.getLastName()     |
      | userId    | faker.getEmail()        |
      | isActive  | true                    |
    And set createUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print createUserPayload
    And request createUserPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createuserWithDuplicateEntityId
  Scenario Outline: Creating the new user with the existing entity id
    Given url commandBaseUrl
    And path '/api/CreateUser'
    And def result = call read('CreateUser.feature@createUserWithAllFields')
    And def getUserResponse = result.response
    And print getUserResponse
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | entityId        | getUserResponse.id                      |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       1 |
      | tags            | ["PII"]                                 |
      | commandType     | "CreateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path      |                   0 |
      | id        | getUserResponse.id  |
      | firstName | firstname           |
      | lastName  | faker.getLastName() |
      | userId    | faker.getEmail()    |
      | isActive  | true                |
    And set createUserPayload
      | path                | [0]              |
      | header              | commandHeader[0] |
      | body                | commandBody[0]   |
      | body.applicationIds | applicationID    |
    And print createUserPayload
    And request createUserPayload
    When method POST
    Then status 500
    And print response
    And match response.detail contains 'EntityAlreadyExistsException'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateuserWithInvalidDataToMandatoryFields
  Scenario Outline: Update the existing user with invalid details
    Given url commandBaseUrl
    And path '/api/UpdateUser'
    And def createUserResult = call read('CreateUser.feature@createUserWithMandatoryFields')
    And def addUserResponse = createUserResult.response
    And def userEmail = faker.getEmail()
    And print addUserResponse
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | entityId        | addUserResponse.header.entityId         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | ["PII"]                                 |
      | commandType     | "UpdateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path           |                              0 |
      | id             | faker.getRandomNumber()        |
      | userId         | userEmail                      |
      | applicationIds | addUserResponse.applicationIds |
    And set updateUserPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateUserPayload
    And request updateUserPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateUserWithMissingMandatoryField
  Scenario Outline: Update the existing user with missing mandatory fields
    Given url commandBaseUrl
    And path '/api/UpdateUser'
    And def createUserResult = call read('CreateUser.feature@createUserWithMandatoryFields')
    And def addUserResponse = createUserResult.response
    And def userEmail = faker.getEmail()
    And print addUserResponse
    And set commandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/UpdateUser-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | addUserResponse.header.sourceId         |
      | tenantId        | <tenantid>                              |
      | id              | addUserResponse.header.id               |
      | correlationId   | addUserResponse.header.correlationId    |
      | entityId        | addUserResponse.header.entityId         |
      | commandUserId   | commandUserId                           |
      | entityVersion   |                                       2 |
      | tags            | ["PII"]                                 |
      | commandType     | "UpdateUser"                            |
      | entityName      | "User"                                  |
    And set commandBody
      | path           |                               0 |
      | id             | addUserResponse.header.entityId |
      | applicationIds | addUserResponse.applicationIds  |
    And set updateUserPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print updateUserPayload
    And request updateUserPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |
