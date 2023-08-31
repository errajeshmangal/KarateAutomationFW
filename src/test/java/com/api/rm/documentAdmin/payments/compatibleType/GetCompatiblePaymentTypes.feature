Feature: Get Compatible Payment Types

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

  @getCompatiblePaymentTypes
  Scenario Outline: Get the list of available Active Compatible payment Types
    Given url readBaseUrl
    And path '/api/GetCompatiblePaymentType'
    And set getCompatibleTypeCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetCompatiblePaymentType-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | commandUserId                                     |
      | tags            | []                                                |
      | commandType     | "GetCompatiblePaymentType"                        |
      | entityName      | "CompatibleType"                                  |
      | ttl             |                                                 0 |
      | getType         | "One"                                             |
    And set getCompatibleTypeCommandBody
      | path          |             0 |
      | paymentTypeId | paymentTypeId |
    And set getCompatibleTypePayload
      | path         | [0]                               |
      | header       | getCompatibleTypeCommandHeader[0] |
      | body.request | getCompatibleTypeCommandBody[0]   |
    And print getCompatibleTypePayload
    And request getCompatibleTypePayload
    When method POST
    Then status 200
    And print response
    And def getCompatibleTypeResponse = response
    And print getCompatibleTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
