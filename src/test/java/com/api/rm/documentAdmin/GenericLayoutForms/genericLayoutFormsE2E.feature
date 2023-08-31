@GenericLayoutFormsE2E
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
    And def eventTypes = ['GenericLayoutForm']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateAndGetGenericLayoutFormWithAllDetails
  Scenario Outline: Create a Generic Layout Form And Validate with all the fields
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithAllDetails')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | CreateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | CreateGLFormResponse.header.id                 |
      | correlationId   | CreateGLFormResponse.header.correlationId      |
      | commandUserId   | CreateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     | CreateGLFormResponse.body.code |
      | name     |                                |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == CreateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == CreateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == CreateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == CreateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].description  == CreateGLFormResponse.body.description
    And match getGLFormAllResponse.results[0].isActive  == CreateGLFormResponse.body.isActive
  
    #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutFormWithAllDetails
  Scenario Outline: Update a Generic Layout Form with all the fields
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithAllDetails')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      | body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 201
    And def updateGLFormResponse = response
    And print updateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,CreateGLFormResponse.body.id  )
    And print mongoResult
    And match mongoResult == updateGLFormResponse.body.id
    And match updateGLFormResponse.body.code == updateGLFormPayload.body.code
    And match updateGLFormResponse.body.name == updateGLFormPayload.body.name
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | updateGLFormResponse.header.id                 |
      | correlationId   | updateGLFormResponse.header.correlationId      |
      | commandUserId   | updateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     |                                |
      | name     | updateGLFormResponse.body.name |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == updateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == updateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == updateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == updateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].description  == updateGLFormResponse.body.description
    And match getGLFormAllResponse.results[0].isActive  == updateGLFormResponse.body.isActive
    
    #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
       @CreateAndGetGenericLayoutFormWithIndexing
  Scenario Outline: Create a Generic Layout Form with Indexing
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithIndexing')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | CreateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | CreateGLFormResponse.header.id                 |
      | correlationId   | CreateGLFormResponse.header.correlationId      |
      | commandUserId   | CreateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     | CreateGLFormResponse.body.code |
      | name     |                                |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == CreateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == CreateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == CreateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == CreateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].description  == CreateGLFormResponse.body.description
    And match getGLFormAllResponse.results[0].isActive  == CreateGLFormResponse.body.isActive
  
    #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutFormWithIndexing
  Scenario Outline: Update a Generic Layout Form with Indexing
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithIndexing')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | description | faker.getRandomShortDescription() |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[1]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      | body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 201
    And def updateGLFormResponse = response
    And print updateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,CreateGLFormResponse.body.id  )
    And print mongoResult
    And match mongoResult == updateGLFormResponse.body.id
    And match updateGLFormResponse.body.code == updateGLFormPayload.body.code
    And match updateGLFormResponse.body.name == updateGLFormPayload.body.name
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | updateGLFormResponse.header.id                 |
      | correlationId   | updateGLFormResponse.header.correlationId      |
      | commandUserId   | updateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     |                                |
      | name     | updateGLFormResponse.body.name |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == updateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == updateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == updateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == updateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].description  == updateGLFormResponse.body.description
    And match getGLFormAllResponse.results[0].isActive  == updateGLFormResponse.body.isActive
    
    #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @CreateAndGetGenericLayoutFormWithMandatoryDetails
  Scenario Outline: Create a Generic Layout Form And Validate with Mandatory fields
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetails')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | CreateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | CreateGLFormResponse.header.id                 |
      | correlationId   | CreateGLFormResponse.header.correlationId      |
      | commandUserId   | CreateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     | CreateGLFormResponse.body.code |
      | name     |                                |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == CreateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == CreateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == CreateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == CreateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].isActive  == CreateGLFormResponse.body.isActive
      #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @UpdateGenericLayoutFormWithMandatoryDetails
  Scenario Outline: Update a Generic Layout Form with Mandatory fields
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetails')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      | body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 201
    And def updateGLFormResponse = response
    And print updateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,CreateGLFormResponse.body.id  )
    And print mongoResult
    And match mongoResult == updateGLFormResponse.body.id
    And match updateGLFormResponse.body.code == updateGLFormPayload.body.code
    And match updateGLFormResponse.body.name == updateGLFormPayload.body.name
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | updateGLFormResponse.header.id                 |
      | correlationId   | updateGLFormResponse.header.correlationId      |
      | commandUserId   | updateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     |                                |
      | name     | updateGLFormResponse.body.name |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == updateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == updateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == updateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == updateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].isActive  == updateGLFormResponse.body.isActive
  #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
         @CreateGenericLayoutFormWithOutMandatoryFields
  Scenario Outline: Create a Generic Layout without Mandatory Data
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
    Then status 400
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
        @UpdateGenericLayoutFormWithOutMandatoryDetails
  Scenario Outline: Update a Generic Layout Form withOutMandatory fields
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetails')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      #| name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      | body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 400
    And def updateGLFormResponse = response
    And print updateGLFormResponse
         Examples: 
      | tenantid    |
      | tenantID[0] |
      
       @CreateAndGetGenericLayoutFormWithMandatoryDetailsForIndexing
  Scenario Outline: Create a Generic Layout Form And Validate with Mandatory fields For Indexing
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetailsForIndexing')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | CreateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | CreateGLFormResponse.header.id                 |
      | correlationId   | CreateGLFormResponse.header.correlationId      |
      | commandUserId   | CreateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     | |
      | name     |  CreateGLFormResponse.body.name                               |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == CreateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == CreateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == CreateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == CreateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].isActive  == CreateGLFormResponse.body.isActive
      #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @UpdateGenericLayoutFormWithMandatoryDetailsForIndexing
  Scenario Outline: Update a Generic Layout Form with Mandatory fields for Indexing
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetailsForIndexing')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[0]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      | body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 201
    And def updateGLFormResponse = response
    And print updateGLFormResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutFormCollectionName+<tenantid>,CreateGLFormResponse.body.id  )
    And print mongoResult
    And match mongoResult == updateGLFormResponse.body.id
    And match updateGLFormResponse.body.code == updateGLFormPayload.body.code
    And match updateGLFormResponse.body.name == updateGLFormPayload.body.name
    #GET GL Form with all details
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutForms'
    And set getAllGLFormCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutForms-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | updateGLFormResponse.header.sourceId           |
      | tenantId        | <tenantid>                                     |
      | id              | updateGLFormResponse.header.id                 |
      | correlationId   | updateGLFormResponse.header.correlationId      |
      | commandUserId   | updateGLFormResponse.header.commandUserId      |
      | tags            | []                                             |
      | commandType     | commandType[2]                                 |
      | getType         | "Array"                                        |
      | ttl             |                                              0 |
    And set getGLGetAllFormCommandBody
      | path     |                              0 |
      | code     |                                |
      | name     | updateGLFormResponse.body.name |
      | isActive |                                |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutFormCollectionNameRead+<tenantid>,CreateGLFormResponse.body.id)
    And print mongoResult
    And match mongoResult == getGLFormAllResponse.results[0].id
    And match getGLFormAllResponse.results[0].id == updateGLFormResponse.body.id
    And match getGLFormAllResponse.results[0].code  == updateGLFormResponse.body.code
    And match getGLFormAllResponse.results[0].name  == updateGLFormResponse.body.name
    And match getGLFormAllResponse.results[0].formType  == updateGLFormResponse.body.formType
    And match getGLFormAllResponse.results[0].isActive  == updateGLFormResponse.body.isActive
  #HistoryValidation
    And def entityIdData = getGLFormAllResponse.results[0].id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
         @CreateGenericLayoutFormWithOutMandatoryFieldsForIndexing
  Scenario Outline: Create a Generic Layout without Mandatory Data for Indexing
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
      #| body.actions[0] | actions[0]               |
    And print CreateGLFormPayload
    And request CreateGLFormPayload
    When method POST
    Then status 400
    And def CreateGLFormResponse = response
    And print CreateGLFormResponse
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
        @UpdateGenericLayoutFormWithOutMandatoryDetailsForIndexing
  Scenario Outline: Update a Generic Layout Form withOutMandatory fields For Indexing
    # calling create generic Layout Form  /Avenu.Records.Api.Integration.Tests/src/test/java/com/api/rm/
    And def result = call read('classpath:com/api/rm/documentAdmin/GenericLayoutForms/genericLayoutForms.feature@CreateGenericLayoutFormWithMandatoryDetailsForIndexing')
    And def CreateGLFormResponse = result.response
    And print CreateGLFormResponse
    #Update GL form
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutForm'
    And def entityIdData = dataGenerator.entityID()
    And set updateGLFormCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutForm-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | CreateGLFormResponse.header.entityId             |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | commandType[1]                                   |
      | entityName      | entityName[0]                                    |
      | ttl             |                                                0 |
    And set updateGLFormCommandBody
      | path        |                                 0 |
      | id          | CreateGLFormResponse.body.id      |
      | code        | faker.getUserId()                 |
      | name        | faker.getFirstName()              |
      | isActive    | faker.getRandomBooleanValue()     |
      | formType    | formType[1]                       |
    And set updateGLFormPayload
      | path            | [0]                          |
      | header          | updateGLFormCommandHeader[0] |
      | body            | updateGLFormCommandBody[0]   |
      #| body.actions[0] | actions[1]                   |
    And print updateGLFormPayload
    And request updateGLFormPayload
    When method POST
    Then status 400
    And def updateGLFormResponse = response
    And print updateGLFormResponse
         Examples: 
      | tenantid    |
      | tenantID[0] |