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
    And def commandTypes = ['GetCashieringWorkflowTransactionHeader', 'GetCashieringOrderItemWorkflowTransactionHeader','GetOrderItemWorkflowTransactionStep','GetWorkflowTransactionSteps']
    And def entityName = ['CashieringWorkflowTransactionHeader']
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def eventTypes = ['OrderItemFeeInfo']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def status = ["Open","Rejected","Processed","Paid","NoService","Recorded","Complete"]
    And def processedFlag = ["Open","Accepted","Corrected","Rejected"]


@GetCashieringWorkflowTransactionHeader
   Scenario Outline: Get Cashiering WorkFLow Transaction Header for order item types and validate
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
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[0]                              |
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

    Examples: 
      | tenantid    |
      | tenantID[0] |
  
  
  @GetCashieringOrderItemWorkflowTransactionHeader
   Scenario Outline: Get Cashiering WorkFLow Transaction Header for order item types and validate
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

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @GetOrderItemWorkflowTransactionStep
   Scenario Outline: Get Cashiering WorkFLow Transaction Step for order item types and validate
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

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @GeteWorkflowTransactionStep
   Scenario Outline: Get Cashiering WorkFLow Transaction Step for order item types and validate
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
      | schemaUri       | schemaUri+"/"+commandTypes[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[3]                              |
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

    Examples: 
      | tenantid    |
      | tenantID[0] |
      