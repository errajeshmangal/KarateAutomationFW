@GenericLayoutForms
Feature: Generic Layout Forms - Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutFormCollectionName = 'CreateGenericLayoutForm_'
    And def genericLayoutFormCollectionNameRead = 'GenericLayoutFormDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutForm','UpdateGenericLayoutForm','GetGenericLayoutForms']
    And def entityName = ['GenericLayoutForm']
    And def commandTypeList = ['Create','Update']
    And def actions = ['Reject','Accept']
    And def formType = ['Cashiering', 'Indexing']
    
  @CreateGenericLayoutFormWithAllDetails
  Scenario Outline: Create a Generic Layout Form with all the fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set CreateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[0]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set CreateGLFormCommandBody
      | path        |                                 0 |
      | id          | entityIdData                      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                      |
    And set CreateGLFormPayload
      | path            | [0]                          |
      | header          | CreateGLFormCommandHeader[0] |
      | body            | CreateGLFormCommandBody[0]   |
      | body.actions[0] | actions[0]               |
    And print CreateGLFormPayload
    And request CreateGLFormPayload
    When method POST
    Then status 201
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateGLFormResponse.body.id
    And match CreateGLFormResponse.body.code == CreateGLFormPayload.body.code
    And match CreateGLFormResponse.body.name == CreateGLFormPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
       @CreateGenericLayoutFormWithIndexing
  Scenario Outline: Create a Generic Layout Form with Indexing
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set CreateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[0]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set CreateGLFormCommandBody
      | path        |                                 0 |
      | id          | entityIdData                      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[1]                      |
    And set CreateGLFormPayload
      | path            | [0]                          |
      | header          | CreateGLFormCommandHeader[0] |
      | body            | CreateGLFormCommandBody[0]   |
      | body.actions[0] | actions[0]               |
    And print CreateGLFormPayload
    And request CreateGLFormPayload
    When method POST
    Then status 201
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateGLFormResponse.body.id
    And match CreateGLFormResponse.body.code == CreateGLFormPayload.body.code
    And match CreateGLFormResponse.body.name == CreateGLFormPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
 @CreateGenericLayoutFormWithMandatoryDetails
  Scenario Outline: Create a Generic Layout Form with mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set CreateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[0]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set CreateGLFormCommandBody
      | path        |                                 0 |
      | id          | entityIdData                      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                      |
    And set CreateGLFormPayload
      | path            | [0]                          |
      | header          | CreateGLFormCommandHeader[0] |
      | body            | CreateGLFormCommandBody[0]   |
      | body.actions[0] | actions[0]               |
    And print CreateGLFormPayload
    And request CreateGLFormPayload
    When method POST
    Then status 201
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateGLFormResponse.body.id
    And match CreateGLFormResponse.body.code == CreateGLFormPayload.body.code
    And match CreateGLFormResponse.body.name == CreateGLFormPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
      @CreateGenericLayoutFormWithMandatoryDetailsForIndexing
  Scenario Outline: Create a Generic Layout Form with mandatory fields for Indexing
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set CreateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[0]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set CreateGLFormCommandBody
      | path        |                                 0 |
      | id          | entityIdData                      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[1]                      |
    And set CreateGLFormPayload
      | path            | [0]                          |
      | header          | CreateGLFormCommandHeader[0] |
      | body            | CreateGLFormCommandBody[0]   |
      | body.actions[0] | actions[0]               |
    And print CreateGLFormPayload
    And request CreateGLFormPayload
    When method POST
    Then status 201
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateGLFormResponse.body.id
    And match CreateGLFormResponse.body.code == CreateGLFormPayload.body.code
    And match CreateGLFormResponse.body.name == CreateGLFormPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
        
      @GetActiveFormsforGenericLayout
     Scenario Outline: Get All Active Generic Layout Form  
         #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()           |
      | tenantId        | <tenantid>                                     |
      | id              |dataGenerator.Id()                 |
      | correlationId   | dataGenerator.correlationId()      |
      | commandUserId   | dataGenerator.commandUserId()      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     |   |
      | name     |                                |
      | isActive |           true                     |
      | formType |                                |
    And set paginationSortBody
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |              5000 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGLGetAllFormPayload
      | path                | [0]                           |
      | header              | getAllGLFormCommandHeader[0]  |
      | body.request        | getGLGetAllFormCommandBody[0] |
      | body.paginationSort | paginationSortBody[0]         |
    And print getGLGetAllFormPayload
    And request getGLGetAllFormPayload
    When method POST
    Then status 200
    And def getGLFormAllResponse = response
    And print getGLFormAllResponse
   Examples: 
      | tenantid    |
      | tenantID[0] |
      