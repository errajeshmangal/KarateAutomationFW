@CustomerTypeFeature
Feature: Customer Type - Add , Update

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def customerTypeCollectionname = 'CreateCustomerType_'
    And def customerTypeCollectionNameRead = 'CustomerTypeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCustomerTypeWithAllDetails
  Scenario Outline: Create a customer type code with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateCustomerType'
    And def entityIdData = dataGenerator.entityID()
    And set commandCustomerTypeHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/CreateCustomerType-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | "CreateCustomerType"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | "CustomerType"                              |
    And set commandCustomerTypeBody
      | path           |                        0 |
      | id             | entityIdData             |
      | customerTypeId | faker.getUserId()        |
      | description    | faker.getFirstName()     |
      | isActive       | faker.getRandomBoolean() |
    And set commandCustomerTypeChargeAccountOverride
      | path |                             0 |
      | id   | dataGenerator.correlationId() |
      | code | faker.getUserId()             |
    And set addCustomerTypePayload
      | path                       | [0]                                         |
      | header                     | commandCustomerTypeHeader[0]                |
      | body                       | commandCustomerTypeBody[0]                  |
      | body.chargeAccountOverride | commandCustomerTypeChargeAccountOverride[0] |
    And print addCustomerTypePayload
    And request addCustomerTypePayload
    When method POST
    Then status 201
    And sleep(15000)
    And def addCustomerTypeResponse = response
    And print addCustomerTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,customerTypeCollectionNameRead+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCustomerTypeResponse.body.id
    And match addCustomerTypeResponse.body.customerTypeId == addCustomerTypePayload.body.customerTypeId

    Examples: 
      | tenantid    |
      | tenantID[0] |
