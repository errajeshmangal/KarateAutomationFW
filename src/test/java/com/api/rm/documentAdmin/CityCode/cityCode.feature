@cityCodeFeature
Feature: City Code   - Add , Update ,get , GetAll

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def collectionname = 'CreateCityCode_'
    And def collectionNameRead = 'CityCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCityCodeWithAllDetails
  Scenario Outline: Create a CityCode with all the fields
    Given url commandBaseUrl
    And path '/api/CreateCityCode'
    And def entityIdData = dataGenerator.entityID()
    When def accountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def accountCodeResponse = accountCodeResult.response
    And set commandCityCodeHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/CreateCityCode-v1.001.json" |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | tenantId        | <tenantid>                              |
      | ttl             |                                       0 |
      | commandType     | "CreateCityCode"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | tags            | []                                      |
      | entityVersion   |                                       1 |
      | entityId        | entityIdData                            |
      | commandUserId   | dataGenerator.commandUserId()           |
      | entityName      | "CityCode"                              |
    And set commandCityCodeBody
      | path                         |                             0 |
      | id                           | entityIdData                  |
      | cityCode                     | faker.getCityCode()           |
      | description                  | faker.getCity()               |
      | cityType                     | faker.getCityType()           |
      | cityDistributionPercent      |                           0.5 |
      | cityDistributionAccount.id   | accountCodeResponse.body.id   |
      | cityDistributionAccount.code | accountCodeResponse.body.code |
      | parentCity.id                | faker.UUID()                  |
      | parentCity.code              | faker.getCityCode()           |
      | isActive                     | true                          |
      | roundUpHalfCent              | faker.getRandomBoolean()      |
    And set addCityCodePayload
      | path   | [0]                      |
      | header | commandCityCodeHeader[0] |
      | body   | commandCityCodeBody[0]   |
    And print addCityCodePayload
    And request addCityCodePayload
    When method POST
    Then status 201
    And def addCityCodeResponse = response
    And print addCityCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,collectionname+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCityCodeResponse.body.id
    And match addCityCodeResponse.body.cityCode == addCityCodePayload.body.cityCode

    Examples: 
      | tenantid    |
      | tenantID[0] |
