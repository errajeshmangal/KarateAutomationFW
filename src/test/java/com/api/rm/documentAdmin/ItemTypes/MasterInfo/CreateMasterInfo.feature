@AddItemTypesScenarios
Feature: Add Item Type- Master Info

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def masterInfoItemTypeCollectionName = 'CreateItemTypeMasterInfo_'
    And def masterInfoItemTypeCollectionNameRead = 'ItemTypeMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateMasterInfoItemTypeswithAllFields @CopyRequest  
  Scenario Outline: Create MasterInfo Item type for CopyRequest category  with all Details
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | true                                              |
      | category          | "CopyRequest"                                     |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | code | activeDocumentClassResponse.results[0].code |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createMasterInfoItemTypeResponse = response
    And print createMasterInfoItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMasterInfoItemTypeResponse.body.id
    And match createMasterInfoItemTypeResponse.body.code == createMasterInfoItemTypePayload.body.code
    And match createMasterInfoItemTypeResponse.body.documentClass.id == createMasterInfoItemTypePayload.body.documentClass.id
    And match createMasterInfoItemTypeResponse.body.documentClass.name == createMasterInfoItemTypePayload.body.documentClass.name
    And match createMasterInfoItemTypeResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive

    #And match createMasterInfoItemTypeResponse.body.effectiveDate == createMasterInfoItemTypePayload.body.effectiveDate
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMasterInfoItemTypeswithAllFields @DocumentClassCategory  
  Scenario Outline: Create MasterInfo Item type with Document Class Category for  all Details
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "DocumentClass"                                   |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
    And set createMasterInfoItemTypePayload
      | path               | [0]                        |
      | header             | commandMasterInfoHeader[0] |
      | body               | commandMasterInfoBody[0]   |
      | body.documentClass | commandDocumentClass[0]    |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createMasterInfoItemTypeResponse = response
    And print createMasterInfoItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMasterInfoItemTypeResponse.body.id
    And match createMasterInfoItemTypeResponse.body.code == createMasterInfoItemTypePayload.body.code
    And match createMasterInfoItemTypeResponse.body.shortDescription == createMasterInfoItemTypePayload.body.shortDescription
    And match createMasterInfoItemTypeResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive
    And match createMasterInfoItemTypeResponse.body.documentClass.name == createMasterInfoItemTypePayload.body.documentClass.name
    And match createMasterInfoItemTypeResponse.body.documentClass.id == createMasterInfoItemTypePayload.body.documentClass.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMasterInfoItemTypeswithAllFields @MiscellaneousFeesCategory 
  Scenario Outline: Create MasterInfo Item type with MiscellaneousFees Category for  all Details
    Given url commandBaseUrl
    And path '/api/CreateItemTypeMasterInfo'
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    #calling getAreaBasedOnDepartmentApi
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    #calling getDocumentTypeBasedOnDocumentClassApi
    And def resultDocumentType = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDefaultDocumentTypeBasedOnDocumentClasses')
    And def activeDocumentTypeResponse = resultDocumentType.response
    And print activeDocumentTypeResponse
    #calling Get Fee grps
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@GetFeeGroups')
    And def activeFeeGrpsResponse = result.response
    And print activeFeeGrpsResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMiscMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "MiscellaneousFees"                               |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
    And set commandFeeCode
      | path |                    0 |
      | id   | faker.UUID()         |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set commandFeeGroup
      | path |                                     0 |
      | id   | activeFeeGrpsResponse.results[0].id   |
      | name | activeFeeGrpsResponse.results[0].name |
      | code | activeFeeGrpsResponse.results[0].code |
    And set createMasterInfoItemTypePayload
      | path               | [0]                          |
      | header             | commandMasterInfoHeader[0]   |
      | body               | commandMiscMasterInfoBody[0] |
      | body.department    | commandDepartment[0]         |
      | body.area          | commandArea[0]               |
      | body.documentClass | commandDocumentClass[0]      |
      | body.feeCode       | commandFeeCode[0]            |
      | body.feeGroup      | commandFeeGroup[0]           |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createMasterInfoItemTypeResponse = response
    And print createMasterInfoItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMasterInfoItemTypeResponse.body.id
    And match createMasterInfoItemTypeResponse.body.code == createMasterInfoItemTypePayload.body.code
    And match createMasterInfoItemTypeResponse.body.shortDescription == createMasterInfoItemTypePayload.body.shortDescription
    And match createMasterInfoItemTypeResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive
    And match createMasterInfoItemTypeResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive
    And match createMasterInfoItemTypeResponse.body.department.id == createMasterInfoItemTypePayload.body.department.id
    And match createMasterInfoItemTypeResponse.body.department.name == createMasterInfoItemTypePayload.body.department.name
    And match createMasterInfoItemTypeResponse.body.area.name == createMasterInfoItemTypePayload.body.area.name
    And match createMasterInfoItemTypeResponse.body.documentClass.id == createMasterInfoItemTypePayload.body.documentClass.id
    And match createMasterInfoItemTypeResponse.body.feeCode.id == createMasterInfoItemTypePayload.body.feeCode.id
    And match createMasterInfoItemTypeResponse.body.feeCode.name == createMasterInfoItemTypePayload.body.feeCode.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMasterInfoItemTypeswithAllFields @RestrictedFeesGroupFeesCategory  
  Scenario Outline: Create MasterInfo Item type with Restricted Fees Group  Category for  all Details
    Given url commandBaseUrl
    #calling Get Fee grps
    And def result = call read('classpath:com/api/rm/documentAdmin/ItemTypes/MasterInfo/CreateMasterInfo.feature@GetFeeGroups')
    And def activeFeeGrpsResponse = result.response
    And print activeFeeGrpsResponse
    And path '/api/CreateItemTypeMasterInfo'
    And def entityIdData = dataGenerator.entityID()
    And set commandMasterInfoHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/CreateItemTypeMasterInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | entityId        | entityIdData                                      |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | entityVersion   |                                                 1 |
      | tags            | []                                                |
      | commandType     | "CreateItemTypeMasterInfo"                        |
      | entityName      | "ItemTypeMasterInfo"                              |
      | ttl             |                                                 0 |
    And set commandMasterInfoBody
      | path              |                                                 0 |
      | id                | entityIdData                                      |
      | code              | faker.getUserId()                                 |
      | shortDescription  | faker.getRandomShortDescription()                 |
      | longDescription   | faker.getRandomLongDescription()                  |
      | displaySequence   | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | isActive          | faker.getRandomBooleanValue()                     |
      | category          | "RestrictedFeeGroup"                              |
      | effectiveDate     | dataGenerator.generateCurrentDateTime()           |
      | expirationDate    | dataGenerator.generateCurrentDateTime()           |
      | additionalInfoTab | faker.getRandomShortDescription()                 |
    And set commandFeeGroup
      | path |                                     0 |
      | id   | activeFeeGrpsResponse.results[0].id   |
      | name | activeFeeGrpsResponse.results[0].description |
      | code | activeFeeGrpsResponse.results[0].feeGroupCode |
    And set createMasterInfoItemTypePayload
      | path          | [0]                        |
      | header        | commandMasterInfoHeader[0] |
      | body          | commandMasterInfoBody[0]   |
      | body.feeGroup | commandFeeGroup[0]         |
    And print createMasterInfoItemTypePayload
    And request createMasterInfoItemTypePayload
    When method POST
    Then status 201
    And print response
    And def createMasterInfoItemTypeResponse = response
    And print createMasterInfoItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,masterInfoItemTypeCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMasterInfoItemTypeResponse.body.id
    And match createMasterInfoItemTypeResponse.body.code == createMasterInfoItemTypePayload.body.code
    And match createMasterInfoItemTypeResponse.body.shortDescription == createMasterInfoItemTypePayload.body.shortDescription
    And match createMasterInfoItemTypeResponse.body.isActive == createMasterInfoItemTypePayload.body.isActive
    And match createMasterInfoItemTypeResponse.body.feeGroup.code == createMasterInfoItemTypePayload.body.feeGroup.code
    And match createMasterInfoItemTypeResponse.body.feeGroup.id == createMasterInfoItemTypePayload.body.feeGroup.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetFeeGroups
  Scenario Outline: Get all the Fee groups
    Given url readBaseUrl
    And path '/api/GetFeeGroups'
    And def entityIDData = dataGenerator.entityID()
    And set getFeeGrpsCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetFeeGroups-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetFeeGroups"                          |
      | getType         | "Array"                                 |
      | ttl             |                                       0 |
    And set getFeeGrpsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getFeeGrpsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeGrpsPayload
      | path                | [0]                             |
      | header              | getFeeGrpsCommandHeader[0]      |
      | body.request        | getFeeGrpsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGrpsCommandPagination[0]  |
    And print getFeeGrpsPayload
    And request getFeeGrpsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getFeeGrpsResponse = response
    And print getFeeGrpsResponse
    And match each getFeeGrpsResponse.results[*].isActive == getFeeGrpsPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |
