@CreateCompatibleType
Feature: CompatiblePaymentType, Create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatCompatibleCollectionName = 'CreateCompatibleType_'
    And def createCompatibleCollectionNameRead = 'CompatibleTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def usage = ['Primary','Secondary']
    And def pullDownSeq = 'pullDownSequence'

  @CreateCompatiblePaymentType
  Scenario Outline: Create a compatible payment Type with all fields
    Given url commandBaseUrl
    And path '/api/CreateCompatibleType'
    And def entityIdData = dataGenerator.entityID()
    #CreatePaymentType
    And def createPaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@CreatePrimaryPayment')
    And def createPaymentResponse = createPaymentResponseResult.response
    And print createPaymentResponse
    And def paymentTypeId = createPaymentResponse.body.id
    #Getting Compatible Payment Types
    And def getCompatiblePaymentResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/GetCompatiblePaymentTypes.feature@getCompatiblePaymentTypes'){paymentTypeId:'#(paymentTypeId)'}
    And def getCompatiblePaymentResponse = getCompatiblePaymentResult.response
    And print getCompatiblePaymentResponse
    And match each getCompatiblePaymentResponse.compatibleTypes[*].isActive == true
    #PulldownSequence
    And def pullDownSeqData = mongoData.MongoDBHelperToReadFields(dbname,creatCompatibleCollectionName+<tenantid>,pullDownSeq)
    And print pullDownSeqData
    And set createCompatibleTypeCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCompatibleType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "CreateCompatibleType"                        |
      | entityName      | "CompatibleType"                              |
      | ttl             |                                             0 |
    And set createCompatibleTypeCommandBody
      | path          |                             0 |
      | id            | entityIdData                  |
      | paymentTypeId | createPaymentResponse.body.id |
    And set createCompatibleTypes
      | path                  |                                                           0 |
      | id                    | getCompatiblePaymentResponse.compatibleTypes[0].id          |
      | paymentType           | getCompatiblePaymentResponse.compatibleTypes[0].paymentType |
      | pullDownSequence      | pullDownSeqData                                             |
      | overPaymentCondition  | faker.getPaymentCondition()                                 |
      | underPaymentCondition | faker.getPaymentCondition()                                 |
      | isActive              | getCompatiblePaymentResponse.compatibleTypes[0].isActive    |
      | selected              | true                                                        |
    And set createCompatibleTypes
      | path                  |                                                           1 |
      | id                    | getCompatiblePaymentResponse.compatibleTypes[1].id          |
      | paymentType           | getCompatiblePaymentResponse.compatibleTypes[1].paymentType |
      | pullDownSequence      | pullDownSeqData+1                                           |
      | overPaymentCondition  | faker.getPaymentCondition()                                 |
      | underPaymentCondition | faker.getPaymentCondition()                                 |
      | isActive              | getCompatiblePaymentResponse.compatibleTypes[1].isActive    |
      | selected              | true                                                        |
    And set createCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | createCompatibleTypeCommandHeader[0] |
      | body                 | createCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | createCompatibleTypes                |
    And print createCompatibleTypePayload
    And request createCompatibleTypePayload
    When method POST
    Then status 201
    And print response
    And def createCompatibleTypeResponse = response
    And print createCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatCompatibleCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCompatibleTypeResponse.body.id
    And match createCompatibleTypeResponse.body.compatibleTypes[0].paymentType == createCompatibleTypePayload.body.compatibleTypes[0].paymentType

    #  And match createCompatibleTypeResponse.body.compatibleTypes[1].overPaymentCondition == createCompatibleTypePayload.body.compatibleTypes[1].overPaymentCondition
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCompatiblePaymentTypeWithMandatoryFields
  Scenario Outline: Create a compatible payment Type with all fields
    Given url commandBaseUrl
    And path '/api/CreateCompatibleType'
    And def entityIdData = dataGenerator.entityID()
    #CreatePaymentType
    And def createPaymentResponseResult = call read('classpath:com/api/rm/documentAdmin/payments/paymentType/CreatePayment.feature@CreatePrimaryPaymentWithMandatoryFields')
    And def createPaymentResponse = createPaymentResponseResult.response
    And print createPaymentResponse
    And def paymentTypeId = createPaymentResponse.body.id
    #Getting Compatible Payment Types
    And def getCompatiblePaymentResult = call read('classpath:com/api/rm/documentAdmin/payments/compatibleType/GetCompatiblePaymentTypes.feature@getCompatiblePaymentTypes'){paymentTypeId:'#(paymentTypeId)'}
    And def getCompatiblePaymentResponse = getCompatiblePaymentResult.response
    And print getCompatiblePaymentResponse
    And match each getCompatiblePaymentResponse.compatibleTypes[*].isActive == true
    #PulldownSequence
    And def pullDownSeqData = mongoData.MongoDBHelperToReadFields(dbname,creatCompatibleCollectionName+<tenantid>,pullDownSeq)
    And print pullDownSeqData
    And set createCompatibleTypeCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCompatibleType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | "CreateCompatibleType"                        |
      | entityName      | "CompatibleType"                              |
      | ttl             |                                             0 |
    And set createCompatibleTypeCommandBody
      | path          |                             0 |
      | id            | entityIdData                  |
      | paymentTypeId | createPaymentResponse.body.id |
    And set createCompatibleTypes
      | path             |                                                           0 |
      | id               | getCompatiblePaymentResponse.compatibleTypes[0].id          |
      | paymentType      | getCompatiblePaymentResponse.compatibleTypes[0].paymentType |
      | pullDownSequence | pullDownSeqData                                             |
      | isActive         | getCompatiblePaymentResponse.compatibleTypes[0].isActive    |
      | selected         | true                                                        |
    And set createCompatibleTypes
      | path             |                                                           1 |
      | id               | getCompatiblePaymentResponse.compatibleTypes[1].id          |
      | paymentType      | getCompatiblePaymentResponse.compatibleTypes[1].paymentType |
      | pullDownSequence | pullDownSeqData+1                                           |
      | isActive         | getCompatiblePaymentResponse.compatibleTypes[1].isActive    |
      | selected         | true                                                        |
    And set createCompatibleTypePayload
      | path                 | [0]                                  |
      | header               | createCompatibleTypeCommandHeader[0] |
      | body                 | createCompatibleTypeCommandBody[0]   |
      | body.compatibleTypes | createCompatibleTypes                |
    And print createCompatibleTypePayload
    And request createCompatibleTypePayload
    When method POST
    Then status 201
    And print response
    And def createCompatibleTypeResponse = response
    And print createCompatibleTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatCompatibleCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCompatibleTypeResponse.body.id
    And match createCompatibleTypeResponse.body.compatibleTypes[0].paymentType == createCompatibleTypePayload.body.compatibleTypes[0].paymentType

    Examples: 
      | tenantid    |
      | tenantID[0] |
