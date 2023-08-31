@AddItemTypesBehaviourScenarios
Feature: Add Item Type- Master Info

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def behaviourItemTypeCollectionName = 'CreateItemTypeBehaviour_'
    And def behaviourItemTypeCollectionNameRead = 'ItemTypeBehaviourDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateBehaviourItemTypeswithAllFields @SearchProfile
  Scenario Outline: Create Behaviour Item type with Search Profile
    Given url commandBaseUrl
    And path '/api/CreateItemTypeBehaviour'
    #calling MasterInfo Item Type ID
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CopyRequest')
    And def masterInfoItemTypeResponse = resultItemType.response
    And print masterInfoItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllDocumentClassesBySearchProfile')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
     #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDefaultDocumentTypesByDocumentClass')
    And def getAllDocumentTypesResponse = resultItemType.response
    And print getAllDocumentTypesResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandBehaiourHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateItemTypeBehaviour-v1.001.json" |
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
      | commandType     | "CreateItemTypeBehaviour"                        |
      | entityName      | "ItemTypeBehaviour"                              |
      | ttl             |                                                0 |
    And set commandBehaviourBody
      | path                         |                                                0 |
      | id                           | entityIdData                                     |
      | itemTypeId                   | masterInfoItemTypeResponse.body.id               |
      | isEnableNotInSystemButton    | faker.getRandomBooleanValue()                    |
      | documentType[0].id           | getAllDocumentTypesResponse.results[0].id             |
      | documentType[0].name         | getAllDocumentTypesResponse.results[0].name    |
      | documentType[0].code         |  getAllDocumentTypesResponse.results[0].code    |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[0].id         |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[0].name       |
      | searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                             |
      | isAllowWithOtherItemTypes    | faker.getRandomBooleanValue()                    |
      | isAllowMultiplesOnOrder      | faker.getRandomBooleanValue()                    |
      | maxItemCopiesAllowed         | faker.getRandom5DigitNumber()                    |
      | isAutoPromptForVariables     | faker.getRandomBooleanValue()                    |
      | actionAfterRecordingItem     | faker.actionAfterRecordingItem()                 |
      | actionAfterCompletingItem    | faker.actionAfterCompletingItem()                |
      | actionAfterCashieringItem    | faker.actionAfterCashieringItem()                |
    And set createBehaviourItemTypePayload
      | path   | [0]                      |
      | header | commandBehaiourHeader[0] |
      | body   | commandBehaviourBody[0]  |
    And print createBehaviourItemTypePayload
    And request createBehaviourItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createBehaviourItemTypeResponse = response
    And print createBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,behaviourItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createBehaviourItemTypeResponse.body.id
    #And match createBehaviourItemTypeResponse.body.actionAfterCompletingItem == createBehaviourItemTypePayload.body.actionAfterCompletingItem
    And match createBehaviourItemTypeResponse.body.isSearch  == createBehaviourItemTypePayload.body.isSearch
    And match createBehaviourItemTypeResponse.body.searchProfile.name == createBehaviourItemTypePayload.body.searchProfile.name
    And match createBehaviourItemTypeResponse.body.searchableDocumentClass.id == createBehaviourItemTypePayload.body.searchableDocumentClass.id
    And match createBehaviourItemTypeResponse.body.documentType[0].name == createBehaviourItemTypePayload.body.documentType[0].name
    And match createBehaviourItemTypeResponse.body.itemTypeId == masterInfoItemTypeResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

 
 @CreateBehaviourItemTypeswithMandatoryFields  
  Scenario Outline: Create Behaviour Item type with mandatory FIelds
    Given url commandBaseUrl
    And path '/api/CreateItemTypeBehaviour'
    #calling MasterInfo Item Type ID
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CopyRequest')
    And def masterInfoItemTypeResponse = resultItemType.response
    And print masterInfoItemTypeResponse
    #calling Document classes
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetDocumentClasses')
    And def getDocumentClassesResponse = resultItemType.response
    And print getDocumentClassesResponse
    #calling Profiles foe item type
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesForItemTypeResponse = resultItemType.response
    And print getAllProfilesForItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandBehaiourHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateItemTypeBehaviour-v1.001.json" |
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
      | commandType     | "CreateItemTypeBehaviour"                        |
      | entityName      | "ItemTypeBehaviour"                              |
      | ttl             |                                                0 |
    And set commandBehaviourBody
      | path                         |                                                0 |
      | id                           | entityIdData                                     |
      | itemTypeId                   | masterInfoItemTypeResponse.body.id               |
      | searchableDocumentClass.id   | getDocumentClassesResponse.results[0].id         |
      | searchableDocumentClass.code | getDocumentClassesResponse.results[0].code       |
      | searchableDocumentClass.name | getDocumentClassesResponse.results[0].name       |
      | searchProfile.id             | getAllProfilesForItemTypeResponse.results[0].id   |
      | searchProfile.name           | getAllProfilesForItemTypeResponse.results[0].name |
      | searchProfile.code           | getAllProfilesForItemTypeResponse.results[0].code |
      | isSearch                     | true                                             |
    And set createBehaviourItemTypePayload
      | path   | [0]                      |
      | header | commandBehaiourHeader[0] |
      | body   | commandBehaviourBody[0]  |
    And print createBehaviourItemTypePayload
    And request createBehaviourItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createBehaviourItemTypeResponse = response
    And print createBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,behaviourItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createBehaviourItemTypeResponse.body.id
    And match createBehaviourItemTypeResponse.body.isSearch  == createBehaviourItemTypePayload.body.isSearch
    And match createBehaviourItemTypeResponse.body.searchProfile.name == createBehaviourItemTypePayload.body.searchProfile.name
    And match createBehaviourItemTypeResponse.body.searchableDocumentClass.id == createBehaviourItemTypePayload.body.searchableDocumentClass.id
    And match createBehaviourItemTypeResponse.body.itemTypeId == masterInfoItemTypeResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
  @CreateBehaviourItemTypeswithAllFields @WithoutSearchProfile
  Scenario Outline: Create Behaviour Item type without Search Profile
    Given url commandBaseUrl
    And path '/api/CreateItemTypeBehaviour'
    #calling MasterInfo Item Type ID
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@CopyRequest')
    And def masterInfoItemTypeResponse = resultItemType.response
    And print masterInfoItemTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandBehaiourHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateItemTypeBehaviour-v1.001.json" |
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
      | commandType     | "CreateItemTypeBehaviour"                        |
      | entityName      | "ItemTypeBehaviour"                              |
      | ttl             |                                                0 |
    And set commandBehaviourBody
      | path                         |                                      0 |
      | id                           | entityIdData                           |
      | itemTypeId                   | masterInfoItemTypeResponse.body.id     |
      | isEnableNotInSystemButton    | faker.getRandomBooleanValue()          |
      | documentType.id              | dataGenerator.commandUserId()          |
      | documentType.name            | "County Recorder Department Test Name" |
      | documentType.code            | "County Recorder Department Test code" |
      | searchableDocumentClass.id   | dataGenerator.commandUserId()          |
      | searchableDocumentClass.name | "County Recorder Department Test Name" |
      | searchProfile.id             | dataGenerator.commandUserId()          |
      | searchProfile.name           | "County Recorder Department Test Name" |
      | searchProfile.code           | "County Recorder Department Test code" |
      | isSearch                     | false                                  |
    And set createBehaviourItemTypePayload
      | path   | [0]                      |
      | header | commandBehaiourHeader[0] |
      | body   | commandBehaviourBody[0]  |
    And print createBehaviourItemTypePayload
    And request createBehaviourItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createBehaviourItemTypeResponse = response
    And print createBehaviourItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,behaviourItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createBehaviourItemTypeResponse.body.id
    And match createBehaviourItemTypeResponse.body.itemTypeId == masterInfoItemTypeResponse.body.id
    #And match createBehaviourItemTypeResponse.body.actionAfterCompletingItem == createBehaviourItemTypePayload.body.actionAfterCompletingItem
    And match createBehaviourItemTypeResponse.body.isSearch  == createBehaviourItemTypePayload.body.isSearch

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetAllProfilesForItemType
  Scenario Outline: Get all the Profiles
    Given url readBaseUrl
    And path '/api/GetSearchProfilesNameDescriptions'
    And def entityIDData = dataGenerator.entityID()
    And set getAllProfileCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetSearchProfilesNameDescriptions-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | dataGenerator.SourceID()                                   |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | dataGenerator.correlationId()                              |
      | commandUserId   | dataGenerator.commandUserId()                              |
      | tags            | []                                                         |
      | commandType     | "GetSearchProfilesNameDescriptions"                        |
      | getType         | "Array"                                                    |
      | ttl             |                                                          0 |
    And set getAllProfileCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getAllProfileCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getAllProfilesPayload
      | path                | [0]                                |
      | header              | getAllProfileCommandHeader[0]      |
      | body.request        | getAllProfileCommandBodyRequest[0] |
      | body.paginationSort | getAllProfileCommandPagination[0]  |
    And print getAllProfilesPayload
    And request getAllProfilesPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getAllProfilesResponse = response
    And print getAllProfilesResponse
    And match each getAllProfilesResponse.results[*].isActive == getAllProfilesPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetAllDocumentClassesBySearchProfile
  Scenario Outline: Get all the DocumentClasses By SearchProfile
    Given url readBaseUrl
    And path '/api/GetDocumentClassesBySearchProfile'
    #getting all profile by default
    And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllProfilesForItemType')
    And def getAllProfilesResponse = resultItemType.response
    And print getAllProfilesResponse
    And def entityIDData = dataGenerator.entityID()
    And set getDocumentClassesCommandHeader
      | path            |                                                          0 |
      | schemaUri       | schemaUri+"/GetDocumentClassesBySearchProfile-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                    |
      | version         | "1.001"                                                    |
      | sourceId        | dataGenerator.SourceID()                                   |
      | tenantId        | <tenantid>                                                 |
      | id              | dataGenerator.Id()                                         |
      | correlationId   | dataGenerator.correlationId()                              |
      | commandUserId   | dataGenerator.commandUserId()                              |
      | tags            | []                                                         |
      | commandType     | "GetDocumentClassesBySearchProfile"                        |
      | getType         | "Array"                                                    |
      | ttl             |                                                          0 |
    And set getDocumentClassesCommandBodyRequest
      | path            |                                    0 |
      | isActive        | true                                 |
      | searchProfileId | getAllProfilesResponse.results[0].id |
    And set getDocumentClassesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentClassesPayload
      | path                | [0]                                     |
      | header              | getDocumentClassesCommandHeader[0]      |
      | body.request        | getDocumentClassesCommandBodyRequest[0] |
      | body.paginationSort | getDocumentClassesCommandPagination[0]  |
    And print getDocumentClassesPayload
    And request getDocumentClassesPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getDocumentClassesResponse = response
    And print getDocumentClassesResponse
    And match each getDocumentClassesResponse.results[*].isActive == getDocumentClassesPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @GetDefaultDocumentTypesByDocumentClass
  Scenario Outline: Get all Default documentTypes by Document Class with Active flag
    Given url readBaseUrl
     And path '/api/GetDefaultDocumentTypesByDocumentClass'
     And def resultItemType = call read('classpath:com/api/rm/documentAdmin/ItemTypes/Behaviour/CreateBehaviour.feature@GetAllDocumentClassesBySearchProfile')
    And def getAllDocumentClassesResponse = resultItemType.response
    And print getAllDocumentClassesResponse
    And def entityIDData = dataGenerator.entityID()
    And set getDocumenTypesCommandHeader
      | path            |                                                               0 |
      | schemaUri       | schemaUri+"/GetDefaultDocumentTypesByDocumentClass-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                         |
      | version         | "1.001"                                                         |
      | sourceId        | dataGenerator.SourceID()                                        |
      | tenantId        | <tenantid>                                                      |
      | id              | dataGenerator.Id()                                              |
      | correlationId   | dataGenerator.correlationId()                                   |
      | commandUserId   | dataGenerator.commandUserId()                                   |
      | tags            | []                                                              |
      | commandType     | "GetDefaultDocumentTypesByDocumentClass"                        |
      | getType         | "Array"                                                         |
      | ttl             |                                                               0 |
    And set getDocumenTypesCommandBodyRequest
      | path     |    0 |
      | isActive | true |
      | documentClassId | getAllDocumentClassesResponse.results[0].id |
    And set getDocumenTypesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumenTypesPayload
      | path                | [0]                                     |
      | header              | getDocumenTypesCommandHeader[0]     |
      | body.request        | getDocumenTypesCommandBodyRequest[0] |
      | body.paginationSort | getDocumenTypesCommandPagination[0] |
    And print getDocumenTypesPayload
    And request getDocumenTypesPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getDocumenTypesResponse = response
    And print getDocumenTypesResponse
    And match each getDocumenTypesResponse.results[*].isActive == getDocumenTypesPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
