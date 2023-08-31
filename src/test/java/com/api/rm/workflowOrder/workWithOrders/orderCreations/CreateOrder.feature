@WorkWithOrderCreate&Get
Feature: Create New Order & update the order

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def OrderCollectionName = 'CreateOrder_'
    And def OrderCollectionNameRead = 'OrderDetailViewModel_'
    And def getOrderCollectionName = 'GetOrder_'
    And def getOrderCollectionNameRead = 'OrderDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    # And def orderPriorityTypes = ["High","Medium","Low"]
    # And def orderCategory = [ "Counter", "ElectronicG2G", "PublicKiosk", "Mail-Priority", "Mail-Regular", "Subsscription" ]
    # And def status = ["Paid","Processed","Held","Open"]
    And def commandType = 'CreateOrder'
    And def entityName = 'Order'
    And def getType = 'One'

  @CreateOrderwithAllDetails
  Scenario Outline: Create a order with all the fields
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrder'
    And def entityIdData = dataGenerator.entityID()
    #generatingOrderNumber
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/numberGeneration/SequenceNumberGeneration.feature')
    And def orderNumber = result.response[0].formattedResultNumber
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
      | commandType     | commandType                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | entityName                              |
    And set createOrderCustomerId
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | code | faker.getUserId()    |
      | name | faker.getFirstName() |
    And set createOrderSource
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set locationBody
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set itemtypeBody
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set overrideWorkstationBody
      | path |                                                    0 |
      | id   | getElectronicRecordingSourceResponse.results[0].id   |
      | code | getElectronicRecordingSourceResponse.results[0].code |
      | name | getElectronicRecordingSourceResponse.results[0].name |
    And set createOrderBody
      | path                |                                       0 |
      | id                  | entityIdData                            |
      | orderNumber         | orderNumber                             |
      | orderStatus         | "Open"                                  |
      | orderCategory       | "Counter"                               |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | isActive            | faker.getRandomBooleanValue()           |
      | orderPriority       | "Medium"                                |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           |faker.getZip()           |
      | orderTotal          | faker.getRandomInteger(2,3)             |
      | assignedTo          | faker.getFirstName()                    |
      #| overrideOrderDate   | dataGeneratortor.generateCurrentDateTime() |
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
      | extension           | 21                                   |
      | international       | faker.getRandomNumber()                 |
      | country             | faker.getCountry()                      |
      | userCode            | faker.getCountry()                      |
      | processed           |     1                  |
      | customerName        | faker.getCountry()                      |
      | documentRange       | faker.getCountry()                      |
      | mailTracking        | faker.getCountry()                      |
      | createdDate         | dataGenerator.generateCurrentDateTime() |
    And set createOrderPayload
      | path                     | [0]                        |
      | header                   | createOrderHeader[0]       |
      | body                     | createOrderBody[0]         |
      | body.customerId          | createOrderCustomerId[0]   |
      | body.locationId          | createOrderSource[0]       |
      | body.source              | locationBody[0]            |
      | body.itemType            | itemtypeBody[0]            |
      | body.overrideWorkstation | overrideWorkstationBody[0] |
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderwithMandatoryDetails
  Scenario Outline: Create a order with all the mandatory fields
    Given url commandBaseWorkWithOrder
    And path '/api/CreateOrder'
    And def entityIdData = dataGenerator.entityID()
    #generatingOrderNumber
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/numberGeneration/SequenceNumberGeneration.feature')
    And def orderNumber = result.response[0].formattedResultNumber
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
      | commandType     | commandType                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | entityName                              |
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
      | orderStatus | "Open"                        |
      | assignedTo  | faker.getFirstName()          |
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

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderMissingRequiredDetails
  Scenario Outline: Create order with Missing Required fields
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
      | commandType     | commandType                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | entityName                              |
    And set createOrderCustomerId
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | code | faker.getUserId()    |
      | name | faker.getFirstName() |
    And set createOrderBody
      | path                |                                       0 |
      | id                  | entityIdData                            |
      | orderStatus         | faker.getstatus()                       |
      | orderItemCount      | faker.getRandomInteger(0,1)             |
      | orderPriority       | faker.getOrderPriorityTypes()           |
      | isLocked            | faker.getRandomBooleanValue()           |
      | receiptNo           | faker.getRandom5DigitNumber             |
      #| orderTotal          | faker.getRandomInteger(2,3)             |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
    And set createOrderPayload
      | path            | [0]                      |
      | header          | createOrderHeader[0]     |
      | body            | createOrderBody[0]       |
      | body.customerId | createOrderCustomerId[0] |
    And print createOrderPayload
    And request createOrderPayload
    When method POST
    Then status 400
    And def createOrderResponse = response
    And print createOrderResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderwithInvalidRequiredField
  Scenario Outline: Create order with invalid required fields
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
      | commandType     | commandType                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | entityName                              |
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
      | orderTotal          | faker.getFirstName()                    |
      | assignedTo          | faker.getFirstName()                    |
      | overrideOrderDate   | dataGenerator.generateCurrentDateTime() |
      | requestingPartyName | faker.getFirstName()                    |
      | assignedDateTime    | dataGenerator.generateCurrentDateTime() |
      | lastName            | faker.getRandomBooleanValue()           |
    And set createOrderPayload
      | path            | [0]                      |
      | header          | createOrderHeader[0]     |
      | body            | createOrderBody[0]       |
      | body.customerId | createOrderCustomerId[0] |
      | body.source     | createOrderSource[0]     |
    And print createOrderPayload
    And request createOrderPayload
    When method POST
    Then status 400
    And def createOrderResponse = response
    And print createOrderResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetOrderwithAllDetails
  Scenario Outline: Get a order information with all the fields
    Given url readBaseWorkWithOrder
    #calling CreateOrder
    And def CreateOrder = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithMandatoryDetails')
    And def CreateOrderResponse = CreateOrder.response
    And print CreateOrderResponse
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
      | getType         | getType                                 |
    And set getBodyRequest
      | path |                           0 |
      | id   | CreateOrderResponse.body.id |
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

  @GetOrderwithAllDetails1
  Scenario Outline: Get a order information with all the fields
    Given url readBaseWorkWithOrder
    And path '/api/GetOrder'
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderCreations/CreateOrder.feature@CreateOrderwithAllDetails')
    And def createOrderResponse = result.response
    And def createOrderResponseId = createOrderResponse.body.id
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
      | getType         | getType                                 |
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
