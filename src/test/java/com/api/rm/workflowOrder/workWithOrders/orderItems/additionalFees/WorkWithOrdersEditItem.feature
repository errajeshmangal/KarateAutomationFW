@AddAdditionalFeesFeatureE2E
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def CreateorderItemCollectionName = 'CreateOrderItem_'
    And def orderItemCollectionNameRead = 'OrderItemDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateOrderItem','GetOrderItem', 'UpdateOrderItem','DeleteOrderItem']
    And def entityName = ['OrderItemFeeInfo']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def eventTypes = ['OrderItemFeeInfo']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def status = ["Open","Rejected","Processed","Paid","NoService","Recorded","Complete"]
    And def processedFlag = ["Open","Accepted","Corrected","Rejected"]

 
  @UpdateItemwithArunDetailsWithProcessedStatus
  Scenario Outline: Update Order item with Processed Status and Validate
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    #And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[2]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "none"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[1]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,CreateorderItemCollectionName+<tenantid>,createOrderItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderItemResponse.body.id
    And match updateOrderItemResponse.body.id == updateOrderItemPayload.body.id
    And match updateOrderItemResponse.body.orderNumber == updateOrderItemPayload.body.orderNumber
    And match updateOrderItemResponse.body.orderItemNumber == updateOrderItemPayload.body.orderItemNumber
    And match updateOrderItemResponse.body.isRecordable == updateOrderItemPayload.body.isRecordable
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateItemwithArunDetailsWithRejectedStatus
   Scenario Outline: Update Order item with Rejected Status and Validate
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[1]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "none"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[1]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 400
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse
 
    Examples: 
      | tenantid    |
      | tenantID[0] |


  @UpdateItemwithArunDetailsWithPaidStatus
  Scenario Outline: Update Order item from open to  Paid Status and Validate error
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[3]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "none"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[1]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 400
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 

    Examples: 
      | tenantid    |
      | tenantID[0] |


  @UpdateItemwithArunDetailsWithPaidToOpenStatus
  Scenario Outline: Update Order item from Processed to Paid and Paid to Open Status and Validate error
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[2]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                       |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[1]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
  #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[3]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                       |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[0]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
      #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[0]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                       |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[0]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 400
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
      
  @UpdateItemwithArunDetailsWithProcessedStatusAcceptedFlag
  Scenario Outline: Update Order Item with Processed flag as accepeted .
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    #createAndGetOrderItemWithOpen
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/recording/itemNumberGeneration/ItemTypeApi.feature@CreateOrderItemRecordingWithStatusOpenFlagOpen')
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    And def createItemTypeResponseId = createOrderItemResponse.body.id
    #GetOrderItemWithOpen
    And def result1 = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/recording/itemNumberGeneration/ItemTypeApi.feature@GetOrderItemRecordingk'){'createItemTypeResponseId': '#(createItemTypeResponseId)'}
    And def getOrderItemResponse = result1.response
    And print getOrderItemResponse
    And set updateItemHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json"     |
      | version         | "1.001"                                      |
      | sourceId        | createOrderItemResponse.header.sourceId      |
      | id              | createOrderItemResponse.header.id            |
      | correlationId   | createOrderItemResponse.header.correlationId |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | 'UpdateOrderItem'                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | entityVersion   |                                            1 |
      | entityId        | getOrderItemResponse.id                      |
      | commandUserId   | createOrderItemResponse.header.commandUserId |
      | entityName      | 'OrderItem'                                  |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                    0 |
      | id              | getOrderItemResponse.id              |
      | orderNumber     | getOrderItemResponse.orderNumber     |
      | orderItemNumber | getOrderItemResponse.orderItemNumber |
      | orderItemStatus | status[2]                            |
      | isRecordable    | true                                 |
      | orderId         | getOrderItemResponse.orderId         |
      | processedFlag   | processedFlag[1]                     |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,createOrderItemCollection+<tenantid>,createOrderItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderItemResponse.body.id
    And match updateOrderItemResponse.body.id == updateOrderItemPayload.body.id
    And match updateOrderItemResponse.body.orderNumber == updateOrderItemPayload.body.orderNumber
    And match updateOrderItemResponse.body.orderItemNumber == updateOrderItemPayload.body.orderItemNumber
    And match updateOrderItemResponse.body.isRecordable == updateOrderItemPayload.body.isRecordable
    And match updateOrderItemResponse.body.orderId == updateOrderItemPayload.body.orderId
    And match updateOrderItemResponse.body.itemTypeId.id == updateOrderItemPayload.body.itemTypeId.id
    And match updateOrderItemResponse.body.itemTypeId.code == updateOrderItemPayload.body.itemTypeId.code
    And match updateOrderItemResponse.body.itemTypeId.name == updateOrderItemPayload.body.itemTypeId.name
    And match updateOrderItemResponse.body.source.id == updateOrderItemPayload.body.source.id
    And match updateOrderItemResponse.body.source.code == updateOrderItemPayload.body.source.code
    And match updateOrderItemResponse.body.source.name == updateOrderItemPayload.body.source.name
    And def createItemTypeResponseId = updateOrderItemResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |


 @UpdateOrderItemwithOpenToRejectedStatus
  Scenario Outline: Update Order Item with Reject Status
    Given url commandBaseWorkWithOrder
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[1]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[3]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,createOrderItemCollection+<tenantid>,createOrderItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderItemResponse.body.id
    And match updateOrderItemResponse.body.id == updateOrderItemPayload.body.id
    And match updateOrderItemResponse.body.orderNumber == updateOrderItemPayload.body.orderNumber
    And match updateOrderItemResponse.body.orderItemNumber == updateOrderItemPayload.body.orderItemNumber
    And match updateOrderItemResponse.body.isRecordable == updateOrderItemPayload.body.isRecordable
    And match updateOrderItemResponse.body.orderId == updateOrderItemPayload.body.orderId
    And match updateOrderItemResponse.body.itemTypeId.id == updateOrderItemPayload.body.itemTypeId.id
    And match updateOrderItemResponse.body.itemTypeId.code == updateOrderItemPayload.body.itemTypeId.code
    And match updateOrderItemResponse.body.itemTypeId.name == updateOrderItemPayload.body.itemTypeId.name
    And match updateOrderItemResponse.body.source.id == updateOrderItemPayload.body.source.id
    And match updateOrderItemResponse.body.source.code == updateOrderItemPayload.body.source.code
    And match updateOrderItemResponse.body.source.name == updateOrderItemPayload.body.source.name
    And def createItemTypeResponseId = updateOrderItemResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @UpdateOrderItemwithRejectedStatus
  Scenario Outline: Update Order Item with Reject Status
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[1]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[1]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,createOrderItemCollection+<tenantid>,createOrderItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderItemResponse.body.id
    And match updateOrderItemResponse.body.id == updateOrderItemPayload.body.id
    And match updateOrderItemResponse.body.orderNumber == updateOrderItemPayload.body.orderNumber
    And match updateOrderItemResponse.body.orderItemNumber == updateOrderItemPayload.body.orderItemNumber
    And match updateOrderItemResponse.body.isRecordable == updateOrderItemPayload.body.isRecordable
    And match updateOrderItemResponse.body.orderId == updateOrderItemPayload.body.orderId
    And match updateOrderItemResponse.body.itemTypeId.id == updateOrderItemPayload.body.itemTypeId.id
    And match updateOrderItemResponse.body.itemTypeId.code == updateOrderItemPayload.body.itemTypeId.code
    And match updateOrderItemResponse.body.itemTypeId.name == updateOrderItemPayload.body.itemTypeId.name
    And match updateOrderItemResponse.body.source.id == updateOrderItemPayload.body.source.id
    And match updateOrderItemResponse.body.source.code == updateOrderItemPayload.body.source.code
    And match updateOrderItemResponse.body.source.name == updateOrderItemPayload.body.source.name
    And def createItemTypeResponseId = updateOrderItemResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @UpdateOrderItemwithRejectedStatus1 @test1
  Scenario Outline: Update Order Item with Reject Status
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    #And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[1]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[3]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 201
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
     And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,CreateorderItemCollectionName+<tenantid>,createOrderItemResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderItemResponse.body.id
    And match updateOrderItemResponse.body.id == updateOrderItemPayload.body.id
    And match updateOrderItemResponse.body.orderNumber == updateOrderItemPayload.body.orderNumber
    And match updateOrderItemResponse.body.isRecordable == updateOrderItemPayload.body.isRecordable

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
         @UpdateOrderItemwithRejectedStatusButOpenFlag @test1
  Scenario Outline: Update Order Item with Reject Status and Open Flag
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
    And def createOrderItemResponse = result.response
    And print createOrderItemResponse
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[1]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getOrderItemCommandBody
      | path |                               0 |
      | id   | createOrderItemResponse.body.id |
    And set getOrderItemInfoPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemInfoPayload
    And request getOrderItemInfoPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,createOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id
    And match getOrderItemResponse.orderNumber == createOrderItemResponse.body.orderNumber
    And match getOrderItemResponse.id == createOrderItemResponse.body.id
    #UpdateOrderItem
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set updateItemHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrderItem-v1.001.json" |
      | version         | "1.001"                                  |
      | sourceId        | dataGenerator.SourceID()                 |
      | id              | dataGenerator.Id()                       |
      | correlationId   | dataGenerator.correlationId()            |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrderItem'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderItemResponse.id                  |
      | commandUserId   | dataGenerator.correlationId()            |
      | entityName      | 'OrderItem'                              |
    And set updateItemTypeId
      | path |                                    0 |
      | id   | getOrderItemResponse.itemTypeId.id   |
      | code | getOrderItemResponse.itemTypeId.code |
      | name | getOrderItemResponse.itemTypeId.name |
    And set updateOrderItemSource
      | path |                                0 |
      | id   | getOrderItemResponse.source.id   |
      | code | getOrderItemResponse.source.code |
      | name | getOrderItemResponse.source.name |
    And set updateItemBody
      | path            |                                0 |
      | id              | getOrderItemResponse.id          |
      | orderNumber     | getOrderItemResponse.orderNumber |
      | orderItemStatus | status[1]                        |
      | totalAmount     |                               45 |
      | sequenceNumber  |                                4 |
      | orderItemFlag   | "Open"                           |
      | deedAmount      |                                5 |
      | orderId         | getOrderItemResponse.orderId     |
      | fillIns         | "test"                           |
      | processedFlag   | processedFlag[0]                 |
    And set updateOrderItemPayload
      | path            | [0]                      |
      | header          | updateItemHeader[0]      |
      | body            | updateItemBody[0]        |
      | body.itemTypeId | updateItemTypeId[0]      |
      | body.source     | updateOrderItemSource[0] |
    And print updateOrderItemPayload
    And request updateOrderItemPayload
    When method POST
    Then status 400
    And def updateOrderItemResponse = response
    And print updateOrderItemResponse 
    Examples: 
      | tenantid    |
      | tenantID[0] | 
          