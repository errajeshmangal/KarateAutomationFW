@AddAdditionalFeesFeature
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def orderItemAdditionalFeesCollectionName = 'CreateOrderItemFeeInfo_'
    And def orderItemAdditionalFeesCollectionNameRead = 'OrderItemFeeInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateOrderItemFeeInfo','UpdateOrderItemFeeInfo', 'GetOrderItemFeeInfo']
    And def entityName = ['OrderItemFeeInfo']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateAdditionalFeesWithAllFilelds
  Scenario Outline: create Additional Fees for order item types and validate
    Given url commandBaseWorkWithOrder
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    And def id = activeItemTypeResponse[0].id
    And def code = activeItemTypeResponse[0].code
    And def name = activeItemTypeResponse[0].shortDescription
    #calling Restricted Order Items type Order
    And def result  = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateOrderItemRestrictedCategory') {id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}
    And def addOrderItemResponse = result.response
    And print addOrderItemResponse
    #Getting fee codes for the inherited fee groups using below api
    And def feeGrpID =  activeItemTypeResponse[0].feeGroup.id
    And def inheritedFeeCodeResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodesBasedOnFeeGroup'){feeGroupId : '#(feeGrpID)'}
    And def inheritedFeeCodeResponse = inheritedFeeCodeResult.response
    And print inheritedFeeCodeResponse
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set createFeesCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | entityName[0]                                |
      | ttl             |                                            0 |
    And set createFeesCommandBody
      | path        |                                     0 |
      | id          | entityIdData                          |
      | orderNumber | addOrderItemResponse.body.orderNumber |
      | orderId     | addOrderItemResponse.body.orderId     |
      | orderItemId | addOrderItemResponse.body.id          |
    And set orderItemAdditionalFees
      | path        |                                                          0 |
      | feeCode     | inheritedFeeCodeResponse.results[0].feeCode[0].feeCodeId   |
      | description | inheritedFeeCodeResponse.results[0].feeCode[0].feeCodeName |
      | quantity    | faker.getRandomInteger(0,5)                                |
      | amount      |                                                      10.55 |
      | city.id     | dataGenerator.randomeID()                                  |
      | city.name   | faker.getFirstName()                                       |
      | city.code   | faker.getCityCode()                                        |
      | extension   | faker.getRandomInteger(0,5)                                |
      | override    | faker.getRandomBooleanValue()                              |
      | totalAmount | faker.getRandomInteger(0,5)                                |
    And set createFeesInfoPayload
      | path                            | [0]                        |
      | header                          | createFeesCommandHeader[0] |
      | body                            | createFeesCommandBody[0]   |
      | body.orderItemAdditionalFees[0] | orderItemAdditionalFees[0] |
    And print createFeesInfoPayload
    And request createFeesInfoPayload
    When method POST
    Then status 201
    And def createFeesResponse = response
    And print createFeesResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,orderItemAdditionalFeesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeesResponse.body.id
    And match createFeesResponse.body.orderNumber == createFeesInfoPayload.body.orderNumber
    And match createFeesResponse.body.id == createFeesInfoPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAdditionalFeesWithMandatoryFields
  Scenario Outline: create Additional Fees for order item types with Mandatory fields and validate
    Given url commandBaseWorkWithOrder
    #calling getOrders
    And def GetOrders = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@GetOrderwithAllDetails')
    And def GetOrdersResponse = GetOrders.response
    And print GetOrdersResponse
    And path '/api/'+commandTypes[0]
    And def entityIdData = dataGenerator.entityID()
    And set createFeesCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | ["PII"]                                      |
      | commandType     | commandTypes[0]                              |
      | entityName      | entityName[0]                                |
      | ttl             |                                            0 |
    And set createFeesCommandBody
      | path        |                             0 |
      | id          | entityIdData                  |
      | orderNumber | GetOrdersResponse.orderNumber |
      | orderId     | GetOrdersResponse.id          |
      | orderItemId | dataGenerator.randomeID()     |
    And set createFeesInfoPayload
      | path   | [0]                        |
      | header | createFeesCommandHeader[0] |
      | body   | createFeesCommandBody[0]   |
    And print createFeesInfoPayload
    And request createFeesInfoPayload
    When method POST
    Then status 201
    And def createFeesResponse = response
    And print createFeesResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,orderItemAdditionalFeesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeesResponse.body.id
    And match createFeesResponse.body.orderNumber == createFeesInfoPayload.body.orderNumber
    And match createFeesResponse.body.id == createFeesInfoPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @GetItemTypeWithCategoryDocumentClass
  Scenario Outline: Get item types with category Document class
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | getType         | "Array"                                         |
      | commandUserId   | dataGenerator.commandUserId()                   |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |    0 |
      | code                |      |
      | shortDescription    |      |
      | displaySequence     |      |
      | isActive            | true |
      | lastUpdatedDateTime |      |
    And set getMasterItemTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And def filteredResponse = getMasterItemTypesResponse.results
    And print filteredResponse
    And def ItemTypesCount = karate.sizeOf(filteredResponse)
    And print ItemTypesCount
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.category == 1)]")
    And print filteredObject
    And def ItemTypeRecordingCount = karate.sizeOf(filteredObject)
    And print ItemTypeRecordingCount
    And match each filteredObject[*].category == 1
    And match each getMasterItemTypesResponse[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetItemTypeWithCategoryRestrictedFeeGrp
  Scenario Outline: Get item types with category Restricted Fee Grp
    Given url readBaseUrl
    When path '/api/GetItemTypeMasterInfos'
    And set getMasterItemTypesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetItemTypeMasterInfos-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | getType         | "Array"                                         |
      | commandUserId   | dataGenerator.commandUserId()                   |
      | tags            | []                                              |
      | commandType     | "GetItemTypeMasterInfos"                        |
      | ttl             |                                               0 |
    And set getMasterItemTypesCommandBodyRequest
      | path                |    0 |
      | code                |      |
      | shortDescription    |      |
      | displaySequence     |      |
      | isActive            | true |
      | lastUpdatedDateTime |      |
    And set getMasterItemTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getMasterItemTypesCommandPayload
      | path                | [0]                                     |
      | header              | getMasterItemTypesCommandHeader[0]      |
      | body.request        | getMasterItemTypesCommandBodyRequest[0] |
      | body.paginationSort | getMasterItemTypesCommandPagination[0]  |
    And print getMasterItemTypesCommandPayload
    And request getMasterItemTypesCommandPayload
    When method POST
    Then status 200
    And def getMasterItemTypesResponse = response
    And def filteredResponse = getMasterItemTypesResponse.results
    And print filteredResponse
    And def ItemTypesCount = karate.sizeOf(filteredResponse)
    And print ItemTypesCount
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.category == 3)]")
    And print filteredObject
    And def ItemTypeRecordingCount = karate.sizeOf(filteredObject)
    And print ItemTypeRecordingCount
    And match each filteredObject[*].category == 3
    And match each getMasterItemTypesResponse[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderItemRestrictedCategory
  Scenario Outline: Create a item type with Open Status for Restricted Category
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrderItem'
    #calling ItemType API to get active recordable data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #calling getOrders
    And def GetOrders = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithMandatoryDetails')
    And def GetOrdersResponse = GetOrders.response
    And print GetOrdersResponse
    And def RestrictedFeeGrpTypeId = activeItemTypeResponse[0].feeGroup.id
    And def RestrictedFeeGrpCode = activeItemTypeResponse[0].feeGroup.code
    And def RestrictedFeeGrpName = activeItemTypeResponse[0].feeGroup.name
    And def entityIdData = dataGenerator.entityID()
    And set createOrderItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'CreateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | entityIdData                             |
      | commandUserId   | dataGenerator.commandUserId()            |
      | entityName      | 'OrderItem'                              |
    And set orderItemCommandBody
      | path            |                                  0 |
      | id              | entityIdData                       |
      | orderNumber     | GetOrdersResponse.body.orderNumber |
      | orderId         | GetOrdersResponse.body.id          |
      | orderItemStatus | 'Open'                             |
      | totalAmount     |                                300 |
      | isRecordable    | true                               |
    And set commandItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set commandSource
      | path |                                  0 |
      | id   | GetOrdersResponse.body.source.id   |
      | code | GetOrdersResponse.body.source.code |
      | name | GetOrdersResponse.body.source.name |
    And set orderItemTypePayload
      | path            | [0]                      |
      | header          | createOrderItemHeader[0] |
      | body            | orderItemCommandBody[0]  |
      | body.itemTypeId | commandItemType[0]       |
      | body.source     | commandSource[0]         |
    And print orderItemTypePayload
    And request orderItemTypePayload
    When method POST
    And sleep(15000)
    Then status 201
    And def orderItemTypeResponse = response
    And print orderItemTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderItemwithProcessedStatus
  Scenario Outline: Create a item type with Prcoessed Status for Restricted Category
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrderItem'
    #calling ItemType API to get active recordable data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #calling getOrders
    And def GetOrders = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails')
    And def GetOrdersResponse = GetOrders.response
    And print GetOrdersResponse
    And def RestrictedFeeGrpTypeId = activeItemTypeResponse[0].feeGroup.id
    And def RestrictedFeeGrpCode = activeItemTypeResponse[0].feeGroup.code
    And def RestrictedFeeGrpName = activeItemTypeResponse[0].feeGroup.name
    And def entityIdData = dataGenerator.entityID()
    And set createOrderItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'CreateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | entityIdData                             |
      | commandUserId   | dataGenerator.commandUserId()            |
      | entityName      | 'OrderItem'                              |
    And set orderItemCommandBody
      | path            |                                  0 |
      | id              | entityIdData                       |
      | orderNumber     | GetOrdersResponse.body.orderNumber |
      | orderId         | GetOrdersResponse.body.id          |
      | orderItemStatus | 'Processed'                        |
      | totalAmount     |                                300 |
      | isRecordable    | true                               |
    And set commandItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set commandSource
      | path |                                  0 |
      | id   | GetOrdersResponse.body.source.id   |
      | code | GetOrdersResponse.body.source.code |
      | name | GetOrdersResponse.body.source.name |
    And set orderItemTypePayload
      | path            | [0]                      |
      | header          | createOrderItemHeader[0] |
      | body            | orderItemCommandBody[0]  |
      | body.itemTypeId | commandItemType[0]       |
      | body.source     | commandSource[0]         |
    And print orderItemTypePayload
    And request orderItemTypePayload
    When method POST
    And sleep(15000)
    Then status 201
    And def orderItemTypeResponse = response
    And print orderItemTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderItemwithPaidStatus
  Scenario Outline: Create a item type with Paid Status for Restricted Category
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrderItem'
    #calling ItemType API to get active recordable data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #calling getOrders
    And def GetOrders = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails')
    And def GetOrdersResponse = GetOrders.response
    And print GetOrdersResponse
    And def RestrictedFeeGrpTypeId = activeItemTypeResponse[0].feeGroup.id
    And def RestrictedFeeGrpCode = activeItemTypeResponse[0].feeGroup.code
    And def RestrictedFeeGrpName = activeItemTypeResponse[0].feeGroup.name
    And def entityIdData = dataGenerator.entityID()
    And set createOrderItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'CreateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | entityIdData                             |
      | commandUserId   | dataGenerator.commandUserId()            |
      | entityName      | 'OrderItem'                              |
    And set orderItemCommandBody
      | path            |                                  0 |
      | id              | entityIdData                       |
      | orderNumber     | GetOrdersResponse.body.orderNumber |
      | orderId         | GetOrdersResponse.body.id          |
      | orderItemStatus | 'Paid'                             |
      | totalAmount     |                                300 |
      | isRecordable    | true                               |
    And set commandItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set commandSource
      | path |                                  0 |
      | id   | GetOrdersResponse.body.source.id   |
      | code | GetOrdersResponse.body.source.code |
      | name | GetOrdersResponse.body.source.name |
    And set orderItemTypePayload
      | path            | [0]                      |
      | header          | createOrderItemHeader[0] |
      | body            | orderItemCommandBody[0]  |
      | body.itemTypeId | commandItemType[0]       |
      | body.source     | commandSource[0]         |
    And print orderItemTypePayload
    And request orderItemTypePayload
    When method POST
    And sleep(15000)
    Then status 201
    And def orderItemTypeResponse = response
    And print orderItemTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderItemwithHeldStatus
  Scenario Outline: Create a item type with Held Status for Restricted Category
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrderItem'
    #calling ItemType API to get active recordable data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #calling getOrders
    And def GetOrders = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails')
    And def GetOrdersResponse = GetOrders.response
    And print GetOrdersResponse
    And def RestrictedFeeGrpTypeId = activeItemTypeResponse[0].feeGroup.id
    And def RestrictedFeeGrpCode = activeItemTypeResponse[0].feeGroup.code
    And def RestrictedFeeGrpName = activeItemTypeResponse[0].feeGroup.name
    And def entityIdData = dataGenerator.entityID()
    And set createOrderItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/CreateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'CreateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | entityIdData                             |
      | commandUserId   | dataGenerator.commandUserId()            |
      | entityName      | 'OrderItem'                              |
    And set orderItemCommandBody
      | path            |                                  0 |
      | id              | entityIdData                       |
      | orderNumber     | GetOrdersResponse.body.orderNumber |
      | orderId         | GetOrdersResponse.body.id          |
      | orderItemStatus | 'Held'                             |
      | totalAmount     |                                300 |
      | isRecordable    | true                               |
    And set commandItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set commandSource
      | path |                                  0 |
      | id   | GetOrdersResponse.body.source.id   |
      | code | GetOrdersResponse.body.source.code |
      | name | GetOrdersResponse.body.source.name |
    And set orderItemTypePayload
      | path            | [0]                      |
      | header          | createOrderItemHeader[0] |
      | body            | orderItemCommandBody[0]  |
      | body.itemTypeId | commandItemType[0]       |
      | body.source     | commandSource[0]         |
    And print orderItemTypePayload
    And request orderItemTypePayload
    When method POST
    And sleep(15000)
    Then status 201
    And def orderItemTypeResponse = response
    And print orderItemTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetFeeCodeByFeeGroupIdDetails
  Scenario Outline: Get FeeCode by Fee GroupID with all the fields and Validate
    Given url readBaseUrl
    And path '/api/GetFeeCodeByFeeGroupId'
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse = result.response
    And print getAllFeeCodeResponse
    And set getFeeCodesCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/GetFeeCodeByFeeGroupId-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | id              | entityIdData                                    |
      | tenantId        | <tenantid>                                      |
      | correlationId   | dataGenerator.correlationId()                   |
      | commandUserId   | commandUserId                                   |
      | tags            | []                                              |
      | commandType     | 'GetFeeCodeByFeeGroupId'                        |
      | getType         | "Array"                                         |
    And set getFeeGroupsCommandBodyRequest
      | path      |                                          0 |
      | feeCodeId | getAllFeeCodeResponse.results[0].feeCodeId |
    And set getFeeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeGroupsAllPayload
      | path                | [0]                               |
      | header              | getFeeCodesCommandHeader[0]       |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsAllPayload
    And request getFeeGroupsAllPayload
    When method POST
    Then status 200
    And def getFeeGroupsAllResponse = response
    And print getFeeGroupsAllResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetOpenOrders
  Scenario Outline: Get Open Orders all the fields and Validate
    #GetTheOrdersDetails
    Given url readBaseWorkWithOrder
    And path '/api/GetOrders'
    And set getOrdersHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrders-v1.001.json"      |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrders'                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | 'Array'                                 |
    And set getOrdersBodyRequest
      | path        |      0 |
      | orderStatus | 'Open' |
      | isActive    | true   |
    And set getordersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getOrdersPayload
      | path                | [0]                           |
      | header              | getOrdersHeader[0]            |
      | body.request        | getOrdersBodyRequest[0]       |
      | body.paginationSort | getordersCommandPagination[0] |
    And print getOrdersPayload
    And request getOrdersPayload
    When method POST
    Then status 200
    And def getOrdersResponse = response
    And print getOrdersResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #+++++++++++++++++++++++++++++++++++++++
  @GetDocumentClassMasterInfos
  Scenario Outline: Get Document Class MatserInfos and Validate
    #GetDocumentClassMasterInfo
     #Get document class by county area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def addDocumentClassResponse = result.response
    And print addDocumentClassResponse
    Given url readBaseWorkWithOrder
    And path '/api/GetDocumentClassMasterInfos'
    And set getOrdersHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentClassMasterInfos-v1.001.json" |
      | version         | "1.001"                                              |
      | sourceId        | dataGenerator.SourceID()                             |
      | id              | dataGenerator.Id()                                   |
      | correlationId   | dataGenerator.correlationId()                        |
      | tenantId        | <tenantid>                                           |
      | ttl             |                                                    0 |
      | commandType     | 'GetDocumentClassMasterInfos'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | tags            | []                                                   |
      | commandUserId   | dataGenerator.commandUserId()                        |
      | getType         | 'Array'                                              |
    And set getOrdersBodyRequest
      | path                    |      0 |
      | documentTypeCode        | 'Open' |
      | documentTypeDescription | 'Open' |
      | department              | 'Open' |
      | area                    | 'Open' |
      | isActive                | true   |
    And set getordersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getOrdersPayload
      | path                | [0]                           |
      | header              | getOrdersHeader[0]            |
      | body.request        | getOrdersBodyRequest[0]       |
      | body.paginationSort | getordersCommandPagination[0] |
    And print getOrdersPayload
    And request getOrdersPayload
    When method POST
    Then status 200
    And def getOrdersResponse = response
    And print getOrdersResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
