@DeleteOrderItemFeature
Feature: Delete order Item

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def orderItemAdditionalFeesCollectionName = 'CreateOrderItemFeeInfo_'
    And def orderItemAdditionalFeesCollectionNameRead = 'OrderItemFeeInfoDetailViewModel_'
    And def orderItemCollectionNameRead = 'OrderItemDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['CreateOrderItemFeeInfo','UpdateOrderItemFeeInfo', 'GetOrderItemFeeInfo','DeleteOrderItem']
    And def entityName = ['OrderItemFeeInfo']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def eventTypes = ['OrderItemFeeInfo']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @DeleteAndGetAdditionalFeesWithAllFilelds
  Scenario Outline: Delete  Open Status order item type and validate
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
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemResponse.header.entityId         |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                 0 |
      | id      | addOrderItemResponse.body.id      |
      | orderId | addOrderItemResponse.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 201
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
    #To validate Record is deleted
    # Get OrderItemType
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getOrderItemCommandBody
      | path |                            0 |
      | id   | addOrderItemResponse.body.id |
    And set getOrderItemPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
   And match mongoResult == null

    Examples: 
      | tenantid    |
      | tenantID[0] |


 @DeleteProcessedOrderItem
  Scenario Outline: Delete order Processed Order item types and validate
    Given url commandBaseWorkWithOrder
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    And def id = activeItemTypeResponse[0].id
    And def code = activeItemTypeResponse[0].code
    And def name = activeItemTypeResponse[0].shortDescription
    #calling Restricted Order Items type Order
    And def result  = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateOrderItemwithProcessedStatus') {id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}
    And def addOrderItemResponse = result.response
    And print addOrderItemResponse
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemResponse.header.entityId         |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                 0 |
      | id      | addOrderItemResponse.body.id      |
      | orderId | addOrderItemResponse.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 201
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
    #To validate Record is deleted
    # Get OrderItemType
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getOrderItemCommandBody
      | path |                            0 |
      | id   | addOrderItemResponse.body.id |
    And set getOrderItemPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
    And match mongoResult == null
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
       @DeleteHeldOrderItem
  Scenario Outline: Delete order item types and validate
    Given url commandBaseWorkWithOrder
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    And def id = activeItemTypeResponse[0].id
    And def code = activeItemTypeResponse[0].code
    And def name = activeItemTypeResponse[0].shortDescription
    #calling Restricted Order Items type Order
    And def result  = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateOrderItemwithHeldStatus') {id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}
    And def addOrderItemResponse = result.response
    And print addOrderItemResponse
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemResponse.header.entityId         |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                 0 |
      | id      | addOrderItemResponse.body.id      |
      | orderId | addOrderItemResponse.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 201
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
    #To validate Record is deleted
    # Get OrderItemType
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getOrderItemCommandBody
      | path |                            0 |
      | id   | addOrderItemResponse.body.id |
    And set getOrderItemPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
   And match mongoResult == null

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
       @DeletePaidOrderItem
  Scenario Outline: Delete order item types and validate
    Given url commandBaseWorkWithOrder
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    And def id = activeItemTypeResponse[0].id
    And def code = activeItemTypeResponse[0].code
    And def name = activeItemTypeResponse[0].shortDescription
    #calling Restricted Order Items type Order
    And def result  = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateOrderItemwithPaidStatus') {id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}
    And def addOrderItemResponse = result.response
    And print addOrderItemResponse
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemResponse.header.entityId         |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                 0 |
      | id      | addOrderItemResponse.body.id      |
      | orderId | addOrderItemResponse.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 201
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
    #To validate Record is deleted
    # Get OrderItemType
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getOrderItemCommandBody
      | path |                            0 |
      | id   | addOrderItemResponse.body.id |
    And set getOrderItemPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addOrderItemResponse.body.id)
    And print mongoResult
   And match mongoResult == null

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
  @DeleteAndGetTotalAmount
  Scenario Outline: Delete order item types and validate
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
    And def orderItemId = addOrderItemResponse.body.id
    And def orderId = addOrderItemResponse.body.orderId
    And def  orderNumber =  addOrderItemResponse.body.orderNumber
    And def  orderItemStatus = addOrderItemResponse.body.orderItemStatus
    And def sourceId =  addOrderItemResponse.body.source.id
    And def  sourceName = addOrderItemResponse.body.source.name
    And def sourceCode =  addOrderItemResponse.body.source.code
    #calling get order Item
    And def getOrderItem = call read('classpath:com/api/rm//workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature@GetOrderItemwithAllDetails') {orderItemId: '#(orderItemId)'}
    And def getOrderItemResponse = getOrderItem.response
    And print  getOrderItemResponse
    #calling Updation order item   /workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature
    And def updateOrderItem = call read('classpath:com/api/rm//workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature@UpdateOrderItemRecording'){orderId : '#(orderId)'}{orderNumber : '#(orderNumber)'} {orderItemStatus : '#(orderItemStatus)'} {sourceName : '#(sourceName)'}{sourceId : '#(sourceId)'} {sourceCode : '#(sourceCode)'}{id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}{orderItemId: '#(orderItemId)'}
    And def updateOrderItemResponse = updateOrderItem.response
    And print updateOrderItemResponse
    #Creating second order item with status open
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrderItem'
    #calling ItemType API to get active recordable data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
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
      | path            |                                     0 |
      | id              | entityIdData                          |
      | orderNumber     | addOrderItemResponse.body.orderNumber |
      | orderId         | addOrderItemResponse.body.orderId     |
      | orderItemStatus | 'Open'                                |
      | totalAmount     |                                   500 |
      | isRecordable    | true                                  |
    And set commandItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set commandSource
      | path |                                     0 |
      | id   | addOrderItemResponse.body.source.id   |
      | code | addOrderItemResponse.body.source.code |
      | name | addOrderItemResponse.body.source.name |
    And set orderItemTypePayload
      | path            | [0]                      |
      | header          | createOrderItemHeader[0] |
      | body            | orderItemCommandBody[0]  |
      | body.itemTypeId | commandItemType[0]       |
      | body.source     | commandSource[0]         |
    And print orderItemTypePayload
    And request orderItemTypePayload
    When method POST
    Then status 201
    And def orderItemTypeResponse1 = response
    And print orderItemTypeResponse1
    And def orderItemId = orderItemTypeResponse1.body.id
    And def orderId = orderItemTypeResponse1.body.orderId
    And def  orderNumber =  orderItemTypeResponse1.body.orderNumber
    And def  orderItemStatus = orderItemTypeResponse1.body.orderItemStatus
    And def sourceId =  orderItemTypeResponse1.body.source.id
    And def  sourceName = orderItemTypeResponse1.body.source.name
    And def sourceCode =  orderItemTypeResponse1.body.source.code
    #calling get order Item
    And def getOrderItem = call read('classpath:com/api/rm//workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature@GetOrderItemwithAllDetails') {orderItemId: '#(orderItemId)'}
    And def getOrderItemResponse = getOrderItem.response
    And print  getOrderItemResponse
    #calling Updation order item   /workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature
    And def updateOrderItem = call read('classpath:com/api/rm//workflowOrder/workWithOrders/orderItems/additionalFees/deleteOrderItem.feature@UpdateOrderItemRecording'){orderId : '#(orderId)'}{orderNumber : '#(orderNumber)'} {orderItemStatus : '#(orderItemStatus)'} {sourceName : '#(sourceName)'}{sourceId : '#(sourceId)'} {sourceCode : '#(sourceCode)'}{id:  '#(id)'}{code: '#(code)'}{name: '#(name)'}{orderItemId: '#(orderItemId)'}
    And def updateOrderItemResponse = updateOrderItem.response
    And print updateOrderItemResponse
    #@GetOrderwithAllDetails
    Given url readBaseWorkWithOrder
    And path '/api/GetOrder'
    And set getOrderHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrder-v1.001.json"       |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrder'                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getBodyRequest
      | path |                                 0 |
      | id   | addOrderItemResponse.body.orderId |
    And set getOrderPayload
      | path         | [0]               |
      | header       | getOrderHeader[0] |
      | body.request | getBodyRequest[0] |
    And print getOrderPayload
    And request getOrderPayload
    When method POST
    Then status 200
    And def getOrderResponse = response
    And print getOrderResponse
    # Delete Order item
    Given url commandBaseWorkWithOrder
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | orderItemTypeResponse1.header.entityId       |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                   0 |
      | id      | orderItemTypeResponse1.body.id      |
      | orderId | orderItemTypeResponse1.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 201
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,orderItemTypeResponse1.body.id)
    And print mongoResult
    And match mongoResult == null
    #To validate Record is deleted
    # Get OrderItemType
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And def entityIdData = dataGenerator.entityID()
    And set getOrderItemCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getOrderItemCommandBody
      | path |                              0 |
      | id   | orderItemTypeResponse1.body.id |
    And set getOrderItemPayload
      | path         | [0]                          |
      | header       | getOrderItemCommandHeader[0] |
      | body.request | getOrderItemCommandBody[0]   |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,orderItemTypeResponse1.body.id)
    And print mongoResult
    And match mongoResult == null
    #@GetOrderwithAllDetails
    Given url readBaseWorkWithOrder
    And path '/api/GetOrder'
    And set getOrderHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrder-v1.001.json"       |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrder'                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getBodyRequest
      | path |                                   0 |
      | id   | orderItemTypeResponse1.body.orderId |
    And set getOrderPayload
      | path         | [0]               |
      | header       | getOrderHeader[0] |
      | body.request | getBodyRequest[0] |
    And print getOrderPayload
    And request getOrderPayload
    When method POST
    Then status 200
    And def getOrderResponse = response
    And print getOrderResponse
   And match mongoResult == null
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateOrderItemRecording
  Scenario Outline: Update item type with category document class
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrderItem'
    And set updateOrderItemHeader
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
      | entityId        | orderItemId                              |
      | commandUserId   | dataGenerator.commandUserId()            |
      | entityName      | 'OrderItem'                              |
    And set updateOrderItemCommandBody
      | path            |               0 |
      | id              | orderItemId     |
      | orderNumber     | orderNumber     |
      | orderId         | orderId         |
      | orderItemStatus | orderItemStatus |
      | totalAmount     |            30.0 |
    And set updateOrderItemType
      | path |    0 |
      | id   | id   |
      | code | code |
      | name | name |
    And set updateOrderItemSourceId
      | path |          0 |
      | id   | sourceId   |
      | code | sourceCode |
      | name | sourceName |
    And set updateItemTypePayload
      | path            | [0]                           |
      | header          | updateOrderItemHeader[0]      |
      | body            | updateOrderItemCommandBody[0] |
      | body.itemTypeId | updateOrderItemType[0]        |
      | body.source     | updateOrderItemSourceId[0]    |
    And print updateItemTypePayload
    And request updateItemTypePayload
    When method POST
    And sleep(15000)
    Then status 201
    And def updateItemTypeResponse = response
    And print updateItemTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,updateItemTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == updateItemTypeResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DeleteOpenOrderItems
  Scenario Outline: Delete open order item types and validate
    Given url commandBaseWorkWithOrder
    And path '/api/'+commandTypes[3]
    And def entityIdData = dataGenerator.entityID()
    And set deleteItemTypeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemResponse.header.entityId         |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[3]                              |
      | entityName      | 'OrderItem'                                  |
      | ttl             |                                            0 |
    And set deleteOrderItemCommandBody
      | path    |                                 0 |
      | id      | addOrderItemResponse.body.id      |
      | orderId | addOrderItemResponse.body.orderId |
    And set deleteOrderItemPayload
      | path   | [0]                            |
      | header | deleteItemTypeCommandHeader[0] |
      | body   | deleteOrderItemCommandBody[0]  |
    And print deleteOrderItemPayload
    And request deleteOrderItemPayload
    When method POST
    Then status 200
    And def deleteOrderItemResponse = response
    And print deleteOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addAdditionalFeesResponse.body.id)
    And print mongoResult
    And match mongoResult == deleteOrderItemResponse.id
    And match getFeesResponse.orderNumber == addAdditionalFeesResponse.body.orderNumber
    And match getFeesResponse.id == addAdditionalFeesResponse.body.id
    #To validate Record is delted
    # Get ItemType
    And path '/api/'+commandTypes[2]
    And def entityIdData = dataGenerator.entityID()
    And set getAdditionalFeesCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[2]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | "One"                                        |
    And set getFeesCommandBody
      | path        |                                          0 |
      | orderItemId | addAdditionalFeesResponse.body.orderItemId |
    And set getAdditionalFeesInfoPayload
      | path         | [0]                               |
      | header       | getAdditionalFeesCommandHeader[0] |
      | body.request | getFeesCommandBody[0]             |
    And print getAdditionalFeesInfoPayload
    And request getAdditionalFeesInfoPayload
    When method POST
    Then status 200
    And def getFeesResponse = response
    And print getFeesResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,addAdditionalFeesResponse.body.id)
    And print mongoResult
    And match mongoResult == null

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetOrderItemwithAllDetails
  Scenario Outline: Get a order item information with all the fields
    Given url readBaseWorkWithOrder
    And path '/api/GetOrderItem'
    And set getOrderItemHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetOrderItem-v1.001.json"   |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'GetOrderItem'                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | commandUserId   | dataGenerator.commandUserId()           |
      | getType         | "One"                                   |
    And set getBodyItemRequest
      | path |           0 |
      | id   | orderItemId |
    And set getOrderItemPayload
      | path         | [0]                   |
      | header       | getOrderItemHeader[0] |
      | body.request | getBodyItemRequest[0] |
    And print getOrderItemPayload
    And request getOrderItemPayload
    When method POST
    Then status 200
    And def getOrderItemResponse = response
    And print getOrderItemResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemCollectionNameRead+<tenantid>,orderItemId)
    And print mongoResult
    And match mongoResult == getOrderItemResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
