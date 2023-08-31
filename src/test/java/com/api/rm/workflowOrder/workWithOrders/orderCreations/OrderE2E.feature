@WorkWithOrderCreateUpdateGet
Feature: Update & Get the order

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def OrderCollectionName = 'CreateOrder_'
    And def OrderCollectionNameRead = 'OrderDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    # And def orderPriorityTypes = ["High","Medium","Low"]
    # And def orderCategory = [ "Counter", "ElectronicG2G", "PublicKiosk", "Mail-Priority", "Mail-Regular", "Subsscription" ]
    # And def status = ["Paid","Processed","Held","Open"]
    And def entityName = 'Order'

  @CreateOrderwithAllDetails&GetTheDetails
  Scenario Outline: Create a order with all the fields
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrder'
    And def entityIdData = dataGenerator.entityID()
    #generatingOrderNumber
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/numberGeneration/SequenceNumberGeneration.feature')
    And def orderNumber = result.response.formattedResultNumber
    And print orderNumber
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set createOrderHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateOrder-v1.001.json"    |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'CreateOrder'                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | 'Order'                                 |
    And set createOrderCustomerId
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | code | faker.getUserId()    |
      | name | faker.getFirstName() |
    And set createOrderSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[1].id   |
      | code | getElectronicRecordingSourceResponse.results[1].code |
      | name | getElectronicRecordingSourceResponse.results[1].name |
    And set createOrderBody
      | path                |                                       0 |
      | id                  | entityIdData                            |
      | orderNumber         | orderNumber                             |
      | orderStatus         | faker.getstatus()                       |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | isActive            | faker.getRandomBooleanValue()           |
      | orderPriority       | faker.getOrderPriorityTypes()           |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           | faker.getRandom5DigitNumber             |
      | orderTotal          | faker.getRandomInteger(2,3)             |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
      | lastName            | faker.getLastName()                     |
      | firstName           | faker.getFirstName()                    |
      | addressLine1        | faker.getAddressLine()                  |
      | addressLine2        | faker.getAddressLine2()                 |
      | city                | faker.getCity()                         |
      | state               | faker.getState()                        |
      | zip                 | faker.getZip()                          |
      | telephone           | '222-222-2435'                          |
      | emailAddress        | faker.getEmail()                        |
      | extension           | '21'                                    |
      | international       | faker.getRandomNumber()                 |
      | country             | faker.getCountry()                      |
    And set createOrderPayload
      | path            | [0]                      |
      | header          | createOrderHeader[0]     |
      | body            | createOrderBody[0]       |
      | body.customerId | createOrderCustomerId[0] |
      | body.source     | createOrderSource[0]     |
    And print createOrderPayload
    And request createOrderPayload
    When method POST
    Then status 201
    And def createOrderResponse = response
    And print createOrderResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,OrderCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createOrderResponse.body.id
    And match createOrderResponse.body.id == createOrderPayload.body.id
    And match createOrderResponse.body.orderNumber == createOrderPayload.body.orderNumber
    And match createOrderResponse.body.firstName == createOrderPayload.body.firstName
    And def createOrderResponseId = createOrderResponse.body.id
    #GetTheOrderDetails
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
      | getType         | 'One'                                   |
    And set getBodyRequest
      | path |                     0 |
      | id   | createOrderResponseId |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    # And match getOrderResponse.body.request.id == getOrderResponse.body.request.id
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderwithMandatoryDetails&GetTheDetails
  Scenario Outline: Create a order with all the mandatory fields
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrder'
    And def entityIdData = dataGenerator.entityID()
    #generatingOrderNumber
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/numberGeneration/SequenceNumberGeneration.feature')
    And def orderNumber = result.response.formattedResultNumber
    And print orderNumber
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set createOrderHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateOrder-v1.001.json"    |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | 'CreateOrder'                           |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | 'Order'                                 |
    And set createOrderCustomerId
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | code | faker.getUserId()    |
      | name | faker.getFirstName() |
    And set createOrderSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[1].id   |
      | code | getElectronicRecordingSourceResponse.results[1].code |
      | name | getElectronicRecordingSourceResponse.results[1].name |
    And set createOrderBody
      | path        |                             0 |
      | id          | entityIdData                  |
      | orderNumber | orderNumber                   |
      | isActive    | faker.getRandomBooleanValue() |
      | lastName    | faker.getLastName()           |
    And set createOrderPayload
      | path            | [0]                      |
      | header          | createOrderHeader[0]     |
      | body            | createOrderBody[0]       |
      | body.customerId | createOrderCustomerId[0] |
      | body.source     | createOrderSource[0]     |
    And print createOrderPayload
    And request createOrderPayload
    When method POST
    Then status 201
    And def createOrderResponse = response
    And print createOrderResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,OrderCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createOrderResponse.body.id
    And match createOrderResponse.body.id == createOrderPayload.body.id
    And match createOrderResponse.body.lastName == createOrderPayload.body.lastName
    And match createOrderResponse.body.orderNumber == createOrderPayload.body.orderNumber
    And def createOrderResponseId = createOrderResponse.body.id
    #GetTheOrderDetails
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
      | getType         | 'One'                                   |
    And set getBodyRequest
      | path |                     0 |
      | id   | createOrderResponseId |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateOrderwithAllDetails&GetOrder
  Scenario Outline: Update a order information with all the fields
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrder'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails')
    And def createOrderResponse = result.response
    And def createOrderResponseId = createOrderResponse.body.id
    And def result1 = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@GetOrderwithAllDetails'){'createOrderResponseId': '#(createOrderResponseId)'}
    And def getOrderResponse = result1.response
    And print getOrderResponse
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set updateOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrder-v1.001.json"     |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrder'                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderResponse.id                      |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | entityName      | entityName                               |
    And set updateOrderCustomerId
      | path |                              0 |
      | id   | getOrderResponse.customerId.id |
      | code | faker.getUserId()              |
      | name | faker.getFirstName()           |
    And set updateOrderSource
      | path |                            0 |
      | id   | getOrderResponse.source.id   |
      | code | getOrderResponse.source.code |
      | name | getOrderResponse.source.name |
    And set updateOrderBody
      | path                |                                       0 |
      | id                  | getOrderResponse.id                     |
      | orderNumber         | getOrderResponse.orderNumber            |
      | orderStatus         | 'open'                                  |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | isActive            | faker.getRandomBooleanValue()           |
      | orderPriority       | faker.getOrderPriorityTypes()           |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           | faker.getRandom5DigitNumber             |
      | orderTotal          | faker.getRandomInteger(2,3)             |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
      | lastName            | faker.getLastName()                     |
      | firstName           | faker.getFirstName()                    |
      | addressLine1        | faker.getAddressLine()                  |
      | addressLine2        | faker.getAddressLine2()                 |
      | city                | faker.getCity()                         |
      | state               | faker.getState()                        |
      | zip                 | faker.getZip()                          |
      | telephone           | '222-222-2435'                          |
      | emailAddress        | faker.getEmail()                        |
      | extension           | '21'                                    |
      | international       | faker.getRandomNumber()                 |
      | country             | faker.getCountry()                      |
    And set updateOrderPayload
      | path            | [0]                      |
      | header          | updateOrderHeader[0]     |
      | body            | updateOrderBody[0]       |
      | body.customerId | updateOrderCustomerId[0] |
      | body.source     | updateOrderSource[0]     |
    And print updateOrderPayload
    And request updateOrderPayload
    When method POST
    Then status 201
    And def updateOrderResponse = response
    And print updateOrderResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,OrderCollectionName+<tenantid>,createOrderResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderResponse.body.id
    And match updateOrderResponse.body.id == updateOrderPayload.body.id
    And match updateOrderResponse.body.orderNumber == updateOrderPayload.body.orderNumber
    And match updateOrderResponse.body.firstName == updateOrderPayload.body.firstName
    And match updateOrderResponse.body.customerId.name == updateOrderPayload.body.customerId.name
    And match updateOrderResponse.body.customerId.code == updateOrderPayload.body.customerId.code
    And match updateOrderResponse.body.source.code == updateOrderPayload.body.source.code
    And match updateOrderResponse.body.source.name == updateOrderPayload.body.source.name
    #GettheUpdateOrder
    Given url readBaseWorkWithOrder
    And path '/api/GetOrder'
    And set getOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetOrder-v1.001.json"        |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'GetOrder'                               |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | getType         | 'One'                                    |
    And set getBodyRequest
      | path |                     0 |
      | id   | createOrderResponseId |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    # And match getOrderResponse.body.request.id == getOrderResponse.body.request.id
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateOrderwithMandatoryFields&GetTheDetails
  Scenario Outline: Update a order information with Mandatory fields
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrder'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails@CreateOrderwithMandatoryDetails')
    And def createOrderResponse = result.response
    And def createOrderResponseId = createOrderResponse.body.id
    And def result1 = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@GetOrderwithAllDetails'){'createOrderResponseId': '#(createOrderResponseId)'}
    And def getOrderResponse = result1.response
    And print getOrderResponse
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set updateOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrder-v1.001.json"     |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrder'                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderResponse.id                      |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | entityName      | entityName                               |
    And set updateOrderCustomerId
      | path |                              0 |
      | id   | getOrderResponse.customerId.id |
      | code | faker.getUserId()              |
      | name | faker.getFirstName()           |
    And set updateOrderSource
      | path |                            0 |
      | id   | getOrderResponse.source.id   |
      | code | getOrderResponse.source.code |
      | name | getOrderResponse.source.name |
    And set updateOrderBody
      | path           |                             0 |
      | id             | getOrderResponse.id           |
      | orderNumber    | getOrderResponse.orderNumber  |
      | orderItemCount | faker.getRandomInteger(0,1)   |
      | isActive       | faker.getRandomBooleanValue() |
      | lastName       | faker.getLastName()           |
    And set updateOrderPayload
      | path            | [0]                      |
      | header          | updateOrderHeader[0]     |
      | body            | updateOrderBody[0]       |
      | body.customerId | updateOrderCustomerId[0] |
      | body.source     | updateOrderSource[0]     |
    And print updateOrderPayload
    And request updateOrderPayload
    When method POST
    Then status 201
    And def updateOrderResponse = response
    And print updateOrderResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrder,OrderCollectionName+<tenantid>,createOrderResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateOrderResponse.body.id
    And match updateOrderResponse.body.id == updateOrderPayload.body.id
    And match updateOrderResponse.body.orderNumber == updateOrderPayload.body.orderNumber
    And match updateOrderResponse.body.lastName == updateOrderPayload.body.lastName
    And match updateOrderResponse.body.customerId.name == updateOrderPayload.body.customerId.name
    And match updateOrderResponse.body.customerId.code == updateOrderPayload.body.customerId.code
    And match updateOrderResponse.body.source.code == updateOrderPayload.body.source.code
    And match updateOrderResponse.body.source.name == updateOrderPayload.body.source.name
    #GettheUpdateOrder
    Given url readBaseWorkWithOrder
    And path '/api/GetOrder'
    And set getOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/GetOrder-v1.001.json"        |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'GetOrder'                               |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | getType         | 'One'                                    |
    And set getBodyRequest
      | path |                     0 |
      | id   | createOrderResponseId |
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
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,OrderCollectionNameRead+<tenantid>,getOrderResponse.id)
    And print mongoResult
    And match mongoResult == getOrderResponse.id

    # And match getOrderResponse.body.request.id == getOrderResponse.body.request.id
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateOrderwithMissingRequiredFieldWithOrderStatusProcessed
  Scenario Outline: Update a order information with Missing Required Field
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrder'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderMissingRequiredDetails')
    And def createOrderResponse = result.response
    And def createOrderResponseId = createOrderResponse.body.id
    And def result1 = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@GetOrderwithAllDetails'){'createOrderResponseId': '#(createOrderResponseId)'}
    And def getOrderResponse = result1.response
    And print getOrderResponse
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set updateOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrder-v1.001.json"     |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrder'                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderResponse.id                      |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | entityName      | entityName                               |
    And set updateOrderCustomerId
      | path |                              0 |
      | id   | getOrderResponse.customerId.id |
      | code | faker.getUserId()              |
      | name | faker.getFirstName()           |
    And set updateOrderBody
      | path                |                                       0 |
      | id                  | getOrderResponse.id                     |
      | orderNumber         | getOrderResponse.orderNumber            |
      | orderStatus         | 'processed'                             |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | orderPriority       | faker.getOrderPriorityTypes()           |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           | faker.getRandom5DigitNumber             |
      | orderTotal          | faker.getRandomInteger(2,3)             |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
    And set updateOrderPayload
      | path            | [0]                      |
      | header          | updateOrderHeader[0]     |
      | body            | updateOrderBody[0]       |
      | body.customerId | updateOrderCustomerId[0] |
    And print updateOrderPayload
    And request updateOrderPayload
    When method POST
    Then status 400
    And def updateOrderResponse = response
    And print updateOrderResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateOrderwithInvalidRequiredField
  Scenario Outline: Update a order information with invalid Required fields
    Given url commandBaseWorkWithOrder
    And path '/api/UpdateOrder'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@@CreateOrderwithInvalidRequiredField')
    And def createOrderResponse = result.response
    And def createOrderResponseId = createOrderResponse.body.id
    And def result1 = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@GetOrderwithAllDetails'){'createOrderResponseId': '#(createOrderResponseId)'}
    And def getOrderResponse = result1.response
    And print getOrderResponse
    #generatingSource
    And def result1 = call read('classpath:com/api/rm/workflowAdministration/WorkFlowConfiguration/CreateWorkFlow.feature@CreateElectronicRecordingSourceWithAllDetailsAndGetTheDetails')
    And def getElectronicRecordingSourceResponse = result1.response
    And print getElectronicRecordingSourceResponse
    And set updateOrderHeader
      | path            |                                        0 |
      | schemaUri       | schemaUri+"/UpdateOrder-v1.001.json"     |
      | version         | "1.001"                                  |
      | sourceId        | createOrderResponse.header.sourceId      |
      | id              | createOrderResponse.header.id            |
      | correlationId   | createOrderResponse.header.correlationId |
      | tenantId        | <tenantid>                               |
      | ttl             |                                        0 |
      | commandType     | 'UpdateOrder'                            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()  |
      | tags            | []                                       |
      | entityVersion   |                                        1 |
      | entityId        | getOrderResponse.id                      |
      | commandUserId   | createOrderResponse.header.commandUserId |
      | entityName      | entityName                               |
    And set updateOrderCustomerId
      | path |                              0 |
      | id   | getOrderResponse.customerId.id |
      | code | faker.getUserId()              |
      | name | faker.getFirstName()           |
    And set updateOrderSource
      | path |                            0 |
      | id   | getOrderResponse.source.id   |
      | name | getOrderResponse.source.name |
      | code | getOrderResponse.source.code |
    And set updateOrderBody
      | path                |                                       0 |
      | id                  | getOrderResponse.id                     |
      | orderNumber         | getOrderResponse.orderNumber            |
      | orderStatus         | 'open'                                  |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | isActive            | faker.getRandomBooleanValue()           |
      | orderPriority       | faker.getOrderPriorityTypes()           |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           | faker.getRandom5DigitNumber             |
      | orderTotal          | faker.getFirstName()                    |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
      | lastName            | faker.getLastName()                     |
    And set updateOrderPayload
      | path            | [0]                      |
      | header          | updateOrderHeader[0]     |
      | body            | updateOrderBody[0]       |
      | body.customerId | updateOrderCustomerId[0] |
      | body.source     | updateOrderSource[0]     |
    And print updateOrderPayload
    And request updateOrderPayload
    When method POST
    Then status 400
    And def updateOrderResponse = response
    And print updateOrderResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
