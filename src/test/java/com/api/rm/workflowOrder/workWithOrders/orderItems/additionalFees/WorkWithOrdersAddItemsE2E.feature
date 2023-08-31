@AddAdditionalFeesFeatureE2E
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
    And def commandTypes = ['CreateOrderItemFeeInfo','UpdateOrderItemFeeInfo', 'GetOrderItemFeeInfo','DeleteOrderItem']
    And def entityName = ['OrderItemFeeInfo']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def eventTypes = ['OrderItemFeeInfo']
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'

  @CreateAndGetAdditionalFeesWithAllFilelds
  Scenario Outline: create and get Additional Fees for order item types and validate
    Given url readBaseWorkWithOrder
    #calling Create Work With Order
    And def addAdditionalFees = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateAdditionalFeesWithAllFilelds')
    And def addAdditionalFeesResponse = addAdditionalFees.response
    And print addAdditionalFeesResponse
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
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemAdditionalFeesCollectionNameRead+<tenantid>,addAdditionalFeesResponse.body.id)
    And print mongoResult
    And match mongoResult == getFeesResponse.id
    And match getFeesResponse.orderNumber == addAdditionalFeesResponse.body.orderNumber
    And match getFeesResponse.id == addAdditionalFeesResponse.body.id

    #HistoryValidation
    And def entityIdData = getFeesResponse.id
    And def parentEntityId = null
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetOrderItemInfoEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemAdditionalFeesCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAdditionalFeesWithAllFilelds
  Scenario Outline: update Additional Fees for order item types and validate
    Given url commandBaseWorkWithOrder
    #calling getOrders
    And def addOrderItemFees = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateAdditionalFeesWithAllFilelds')
    And def addOrderItemFeesResponse = addOrderItemFees.response
    And print addOrderItemFeesResponse
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #Getting fee codes for the inherited fee groups using below api
    And def feeGrpID =  activeItemTypeResponse[0].feeGroup.id
    And def inheritedFeeCodeResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodesBasedOnFeeGroup'){feeGroupId : '#(feeGrpID)'}
    And def inheritedFeeCodeResponse = inheritedFeeCodeResult.response
    And print inheritedFeeCodeResponse
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set updateOrderFeeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemFeesResponse.header.entityId     |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateOrderFeeCommandBody
      | path        |                                         0 |
      | id          | addOrderItemFeesResponse.body.id          |
      | orderNumber | addOrderItemFeesResponse.body.orderNumber |
      | orderId     | addOrderItemFeesResponse.body.orderId     |
      | orderItemId | addOrderItemFeesResponse.body.orderItemId |
    And set orderItemAdditionalFees
      | path        |                                                          0 |
      | feeCode     | inheritedFeeCodeResponse.results[0].feeCode[1].feeCodeId   |
      | description | inheritedFeeCodeResponse.results[0].feeCode[1].feeCodeName |
      | quantity    | faker.getRandomInteger(0,5)                                |
      | amount      | faker.getRandomInteger(0,5)                                |
      | city.id     | dataGenerator.randomeID()                                  |
      | city.name   | faker.getFirstName()                                       |
      | city.code   | faker.getCityCode()                                        |
      | extension   | faker.getRandomInteger(0,5)                                |
      | override    | faker.getRandomBooleanValue()                              |
      | totalAmount | faker.getRandomInteger(0,5)                                |
    And set orderItemAdditionalFees
      | path        |                                                          1 |
      | feeCode     | inheritedFeeCodeResponse.results[0].feeCode[2].feeCodeId   |
      | description | inheritedFeeCodeResponse.results[0].feeCode[2].feeCodeName |
      | quantity    | faker.getRandomInteger(0,5)                                |
      | amount      | faker.getRandomInteger(0,5)                                |
      | city.id     | dataGenerator.randomeID()                                  |
      | city.name   | faker.getFirstName()                                       |
      | city.code   | faker.getCityCode()                                        |
      | extension   | faker.getRandomInteger(0,5)                                |
      | override    | faker.getRandomBooleanValue()                              |
      | totalAmount | faker.getRandomInteger(0,5)                                |
    And set updateFeesInfoPayload
      | path                            | [0]                            |
      | header                          | updateOrderFeeCommandHeader[0] |
      | body                            | updateOrderFeeCommandBody[0]   |
      | body.orderItemAdditionalFees[0] | orderItemAdditionalFees[0]     |
      | body.orderItemAdditionalFees[1] | orderItemAdditionalFees[1]     |
    And print updateFeesInfoPayload
    And request updateFeesInfoPayload
    When method POST
    Then status 201
    And def updateFeesResponse = response
    And print updateFeesResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemAdditionalFeesCollectionNameRead+<tenantid>,addOrderItemFeesResponse.body.id)
    And print mongoResult
    And match mongoResult == updateFeesResponse.body.id
    And match updateFeesResponse.body.orderNumber == updateFeesInfoPayload.body.orderNumber
    And match updateFeesResponse.body.id == updateFeesInfoPayload.body.id
    And match updateFeesResponse.body.orderItemAdditionalFees[0].feeCode == updateFeesInfoPayload.body.orderItemAdditionalFees[0].feeCode
    And match updateFeesResponse.body.orderItemAdditionalFees[1].feeCode == updateFeesInfoPayload.body.orderItemAdditionalFees[1].feeCode
    #get the details
    Given url readBaseWorkWithOrder
    And path '/api/'+commandTypes[2]
    And set getOrderItemFeeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[2]+"-v1.001.json" |
      | version         | "1.001"                                      |
      | sourceId        | updateFeesResponse.header.sourceId           |
      | id              | updateFeesResponse.header.id                 |
      | correlationId   | updateFeesResponse.header.correlationId      |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | commandTypes[2]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | updateFeesResponse.header.commandUserId      |
      | getType         | "One"                                        |
    And set getOrderItemFeesCommandBody
      | path        |                                   0 |
      | orderItemId | updateFeesResponse.body.orderItemId |
    And set getOrderItemFeePayload
      | path         | [0]                             |
      | header       | getOrderItemFeeCommandHeader[0] |
      | body.request | getOrderItemFeesCommandBody[0]  |
    And print getOrderItemFeePayload
    And request getOrderItemFeePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def  getOrderItemFeeResponse = response
    And print getOrderItemFeeResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkWithOrderRead,orderItemAdditionalFeesCollectionNameRead+<tenantid>,addOrderItemFeesResponse.body.id)
    And print mongoResult
    And match mongoResult == getOrderItemFeeResponse.id
    And match getOrderItemFeeResponse.orderNumber == updateFeesResponse.body.orderNumber
    And match getOrderItemFeeResponse.orderId == updateFeesResponse.body.orderId
    And match getOrderItemFeeResponse.orderItemId == updateFeesResponse.body.orderItemId
    And match getOrderItemFeeResponse.id == updateFeesResponse.body.id
    And match getOrderItemFeeResponse.orderItemAdditionalFees[0].feeCode == updateFeesInfoPayload.body.orderItemAdditionalFees[0].feeCode
    And match getOrderItemFeeResponse.orderItemAdditionalFees[1].feeCode == updateFeesInfoPayload.body.orderItemAdditionalFees[1].feeCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateOrderItemwithoutMadatoryFIelds
  Scenario Outline: create  Additional Fees without mandatory fields order item types and validate
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
    #| orderItemId     | addOrderItemResponse.body.id          |
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
    Then status 400
    And def createFeesResponse = response
    And print createFeesResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateAdditionalFeesWithoutMandatoryFields
  Scenario Outline: update Additional Fees without mandatory fields for order item types and validate
    Given url commandBaseWorkWithOrder
    #calling getOrders
    And def addOrderItemFees = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@CreateAdditionalFeesWithAllFilelds')
    And def addOrderItemFeesResponse = addOrderItemFees.response
    And print addOrderItemFeesResponse
    #calling ItemType API to get active Restricted Recorded Data
    And def result = call read('classpath:com/api/rm/workflowOrder/workWithOrders/orderItems/additionalFees/WorkWithOrdersAddItems.feature@GetItemTypeWithCategoryRestrictedFeeGrp')
    And def activeItemTypeResponse = result.filteredObject
    And print activeItemTypeResponse
    #Getting fee codes for the inherited fee groups using below api
    And def feeGrpID =  activeItemTypeResponse[0].feeGroup.id
    And def inheritedFeeCodeResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodesBasedOnFeeGroup'){feeGroupId : '#(feeGrpID)'}
    And def inheritedFeeCodeResponse = inheritedFeeCodeResult.response
    And print inheritedFeeCodeResponse
    And path '/api/'+commandTypes[1]
    And def entityIdData = dataGenerator.entityID()
    And set updateOrderFeeCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | entityId        | addOrderItemFeesResponse.header.entityId     |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | commandTypes[1]                              |
      | entityName      | eventTypes[0]                                |
      | ttl             |                                            0 |
    And set updateOrderFeeCommandBody
      | path        |                                         0 |
      | id          | addOrderItemFeesResponse.body.id          |
      | orderNumber | addOrderItemFeesResponse.body.orderNumber |
      | orderId     | addOrderItemFeesResponse.body.orderId     |
    #| orderItemId | addOrderItemFeesResponse.body.orderItemId |
    And set orderItemAdditionalFees
      | path        |                                                          0 |
      | feeCode     | inheritedFeeCodeResponse.results[0].feeCode[1].feeCodeId   |
      | description | inheritedFeeCodeResponse.results[0].feeCode[1].feeCodeName |
      | quantity    | faker.getRandomInteger(0,5)                                |
      | amount      | faker.getRandomInteger(0,5)                                |
      | city.id     | dataGenerator.randomeID()                                  |
      | city.name   | faker.getFirstName()                                       |
      | city.code   | faker.getCityCode()                                        |
      | extension   | faker.getRandomInteger(0,5)                                |
      | override    | faker.getRandomBooleanValue()                              |
      | totalAmount | faker.getRandomInteger(0,5)                                |
    And set orderItemAdditionalFees
      | path        |                                                          1 |
      | feeCode     | inheritedFeeCodeResponse.results[0].feeCode[2].feeCodeId   |
      | description | inheritedFeeCodeResponse.results[0].feeCode[2].feeCodeName |
      | quantity    | faker.getRandomInteger(0,5)                                |
      | amount      | faker.getRandomInteger(0,5)                                |
      | city.id     | dataGenerator.randomeID()                                  |
      | city.name   | faker.getFirstName()                                       |
      | city.code   | faker.getCityCode()                                        |
      | extension   | faker.getRandomInteger(0,5)                                |
      | override    | faker.getRandomBooleanValue()                              |
      | totalAmount | faker.getRandomInteger(0,5)                                |
    And set updateFeesInfoPayload
      | path                            | [0]                            |
      | header                          | updateOrderFeeCommandHeader[0] |
      | body                            | updateOrderFeeCommandBody[0]   |
      | body.orderItemAdditionalFees[0] | orderItemAdditionalFees[0]     |
      | body.orderItemAdditionalFees[1] | orderItemAdditionalFees[1]     |
    And print updateFeesInfoPayload
    And request updateFeesInfoPayload
    When method POST
    Then status 400
    And def updateFeesResponse = response
    And print updateFeesResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
