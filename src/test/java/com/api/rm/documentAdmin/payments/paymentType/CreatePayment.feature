@CreatePayments
Feature: PaymentTypes, Create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatPaymentCollectionName = 'CreatePaymentType_'
    And def createPaymentCollectionNameRead = 'PaymentTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def usage = ['Primary','Secondary']
    And def displayField = 'displaySequence'

  @CreatePrimaryPayment
  Scenario Outline: Create a payment Type with all fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #Fetching dynamic display sequence
    And def displaySequenceData = mongoData.MongoDBHelperToReadFields(dbname,creatPaymentCollectionName+<tenantid>,displayField)
    And print displaySequenceData
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path                       |                                  0 |
      | id                         | entityIdData                       |
      | paymentType                | faker.getUserId()                  |
      | description                | faker.getRandomShortDescription()  |
      #  | usage                      | usage[0]                           |
      | displaySequence            | displaySequenceData                |
      | referencesNumberRequired   | faker.getRandomBoolean()           |
      | reverseSign                | faker.getRandomBoolean()           |
      | includeInCashGroup         | faker.getRandomBoolean()           |
      | includeInDepositTotals     | faker.getRandomBoolean()           |
      | impactsAR                  | faker.getRandomBoolean()           |
      | autoOpenCashDrawer         | faker.getRandomBoolean()           |
      | nameOnCheckRequired        | faker.getRandomBoolean()           |
      | financialExportDepositType | faker.getFinanicialExportDepsoit() |
      | allowDuplicateEntry        | faker.getRandomBoolean()           |
      | isActive                   | faker.getRandomBoolean()           |
      | showCreditCardType         | faker.getRandomBoolean()           |
    And set createPaymentCommandAllowedUi
      | path       |                        0 |
      | cashiering | true                     |
      | ar         | faker.getRandomBoolean() |
      | adjustment | faker.getRandomBoolean() |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path             | [0]                              |
      | header           | createPaymentCommandHeader[0]    |
      | body             | createPaymentCommandBody[0]      |
      | body.allowedInUi | createPaymentCommandAllowedUi[0] |
      | body.glAccount   | createPaymentCommandGlCode[0]    |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 201
    And print response
    And def createPaymentResponse = response
    And print createPaymentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatPaymentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createPaymentResponse.body.id
    And match createPaymentResponse.body.allowedInUi.cashiering == createPaymentPayload.body.allowedInUi.cashiering

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePrimaryPaymentWithMandatoryFields
  Scenario Outline: Create a payment Type with mandatory fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #Fetching dynamic display sequence
    And def displaySequenceData = mongoData.MongoDBHelperToReadFields(dbname,creatPaymentCollectionName+<tenantid>,displayField)
    And print displaySequenceData
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path            |                        0 |
      | id              | entityIdData             |
      | paymentType     | faker.getUserId()        |
      | usage           | usage[0]                 |
      | displaySequence | displaySequenceData      |
      | isActive        | faker.getRandomBoolean() |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 201
    And print response
    And def createPaymentResponse = response
    And print createPaymentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatPaymentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createPaymentResponse.body.id
    And match createPaymentResponse.body.displaySequence == createPaymentPayload.body.displaySequence

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSecondaryPayment
  Scenario Outline: Create a payment Type with all fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path                       |                                  0 |
      | id                         | entityIdData                       |
      | paymentType                | faker.getUserId()                  |
      | description                | faker.getRandomShortDescription()  |
      | usage                      | usage[1]                           |
      | reverseSign                | faker.getRandomBoolean()           |
      | includeInCashGroup         | faker.getRandomBoolean()           |
      | includeInDepositTotals     | faker.getRandomBoolean()           |
      | impactsAR                  | faker.getRandomBoolean()           |
      | autoOpenCashDrawer         | faker.getRandomBoolean()           |
      | nameOnCheckRequired        | faker.getRandomBoolean()           |
      | financialExportDepositType | faker.getFinanicialExportDepsoit() |
      | allowDuplicateEntry        | faker.getRandomBoolean()           |
      | isActive                   | faker.getRandomBoolean()           |
      | showCreditCardType         | faker.getRandomBoolean()           |
    And set createPaymentCommandAllowedUi
      | path       |                        0 |
      | cashiering | true                     |
      | ar         | faker.getRandomBoolean() |
      | adjustment | faker.getRandomBoolean() |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path             | [0]                              |
      | header           | createPaymentCommandHeader[0]    |
      | body             | createPaymentCommandBody[0]      |
      | body.allowedInUi | createPaymentCommandAllowedUi[0] |
      | body.glAccount   | createPaymentCommandGlCode[0]    |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 201
    And print response
    And def createPaymentResponse = response
    And print createPaymentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatPaymentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createPaymentResponse.body.id
    And match createPaymentResponse.body.paymentType == createPaymentPayload.body.paymentType

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSecondaryPaymentWithMandatoryFields
  Scenario Outline: Create a payment Type with mandatory fields
    Given url commandBaseUrl
    And path '/api/CreatePaymentType'
    And def entityIdData = dataGenerator.entityID()
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@AccountCodesBasedOnFlag')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    And set createPaymentCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/createPaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | entityId        | entityIdData                               |
      | commandUserId   | commandUserId                              |
      | entityVersion   |                                          1 |
      | tags            | []                                         |
      | commandType     | "CreatePaymentType"                        |
      | entityName      | "PaymentType"                              |
      | ttl             |                                          0 |
    And set createPaymentCommandBody
      | path            |                        0 |
      | id              | entityIdData             |
      | paymentType     | faker.getUserId()        |
      | usage           | usage[1]                 |
      | displaySequence |                        1 |
      | isActive        | faker.getRandomBoolean() |
    And set createPaymentCommandGlCode
      | path |                                               0 |
      | id   | createCountyAccountCodeResponse.results[0].id   |
      | name | createCountyAccountCodeResponse.results[0].name |
      | code | createCountyAccountCodeResponse.results[0].code |
    And set createPaymentPayload
      | path           | [0]                           |
      | header         | createPaymentCommandHeader[0] |
      | body           | createPaymentCommandBody[0]   |
      | body.glAccount | createPaymentCommandGlCode[0] |
    And print createPaymentPayload
    And request createPaymentPayload
    When method POST
    Then status 201
    And print response
    And def createPaymentResponse = response
    And print createPaymentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatPaymentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createPaymentResponse.body.id
    And match createPaymentResponse.body.usage == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetPaymentWithDetails
  Scenario Outline: Get a payment Type with mandatory fields
    Given url readBaseUrl
    And path '/api/GetPaymentType'
    And sleep(12000)
    And set getPaymentTypeCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetPaymentType-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | createPaymentResponse.header.sourceId      |
      | tenantId        | <tenantid>                                 |
      | id              | createPaymentResponse.header.id            |
      | correlationId   | createPaymentResponse.header.correlationId |
      | commandUserId   | commandUserId                              |
      | tags            | []                                         |
      | commandType     | "GetPaymentType"                           |
      | getType         | "One"                                      |
      | ttl             |                                          0 |
    And set getPaymentTypeCommandBody
      | path |               0 |
      | id   | paymentEntityId |
    And set getPaymentTypePayload
      | path         | [0]                            |
      | header       | getPaymentTypeCommandHeader[0] |
      | body.request | getPaymentTypeCommandBody[0]   |
    And print getPaymentTypePayload
    And request getPaymentTypePayload
    When method POST
    Then status 200
    And def getPaymentTypeAPIResponse = response
    And print getPaymentTypeAPIResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,PaymentTypesCollectionNameRead+<tenantid>,getPaymentTypeAPIResponse.id)
    And print mongoResult
    And match mongoResult == getPaymentTypeAPIResponse.id
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
