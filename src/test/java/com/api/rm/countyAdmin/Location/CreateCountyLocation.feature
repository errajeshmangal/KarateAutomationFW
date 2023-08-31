# This feature file created to use the response of these scenarios in the E2E County Location feature
Feature: County Location - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyLocationCollectionName = 'CreateCountyLocation_'
    And def countyLocationCollectionNameRead = 'CountyLocationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateCountyLocation
  Scenario Outline: Create a county location information with all the fields
    Given url commandBaseUrl
    And path '/api/CreateCountyLocation'
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    #GetCountyCode
    And call read('classpath:com/api/rm/countyAdmin/countyFeature/CountyE2E.feature@CreateCountyWithAllFields')
    And def getCountyCodeResponse = result1.response
    And print getCountyCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCountyLocationCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCountyLocation-v1.001.json" |
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
      | commandType     | "CreateCountyLocation"                        |
      | entityName      | "CountyLocation"                              |
      | ttl             |                                             0 |
    And set createCountyLocationCommandBody
      | path              |                                   0 |
      | id                | entityIdData                        |
      | name              | faker.getFirstName()                |
      | code              | faker.getUserId()                   |
      | displaySequence   |                                   1 |
      | isDefaultLocation | faker.getRandomBoolean()            |
      | isActive          | faker.getRandomBoolean()            |
      | countyId          | getCountyCodeResponse.results[0].id |
    And set createCountyLocationCommandGlCode
      | path |                                                      0 |
      | id   | createCountyAccountCodeResponse.body.id                |
      | name | createCountyAccountCodeResponse.body.shortAccountCode2 |
      | code | createCountyAccountCodeResponse.body.accountCode2      |
    And set createCountyLocationCommandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set addCountyLocationPayload
      | path         | [0]                                   |
      | header       | createCountyLocationCommandHeader[0]  |
      | body         | createCountyLocationCommandBody[0]    |
      | body.address | createCountyLocationCommandAddress[0] |
      | body.glCode  | createCountyLocationCommandGlCode[0]  |
    And print addCountyLocationPayload
    And request addCountyLocationPayload
    When method POST
    Then status 201
    And def addCountyLocationResponse = response
    And print addCountyLocationResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyLocationCollectionName+<tenantid>,addCountyLocationResponse.body.id)
    And print mongoResult
    And match mongoResult == addCountyLocationResponse.body.id
    And match addCountyLocationPayload.body.address.zipCode == addCountyLocationResponse.body.address.zipCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCountyLocationWithMandatoryFields
  Scenario Outline: Create a county location information with only mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateCountyLocation'
    #GetCountyCode
    And def countyCodeResult = call read('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@getCountyDetails')
    And def getCountyCodeResponse = countyCodeResult.response
    And print getCountyCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateCountyLocation-v1.001.json" |
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
      | commandType     | "CreateCountyLocation"                        |
      | entityName      | "CountyLocation"                              |
      | ttl             |                                             0 |
    And set commandBody
      | path              |                                   0 |
      | id                | entityIdData                        |
      | name              | faker.getFirstName()                |
      | code              | faker.getUserId()                   |
      | displaySequence   |                                   1 |
      | isDefaultLocation | faker.getRandomBoolean()            |
      | isActive          | faker.getRandomBoolean()            |
      | countyId          | getCountyCodeResponse.results[0].id |
    And set commandAddress
      | path         |                      0 |
      | addressLine1 | faker.getAddressLine() |
      | addressLine2 | faker.getAddressLine() |
      | city         | faker.getCity()        |
      | state        | faker.getState()       |
      | zipCode      | faker.getZip()         |
    And set addCountyLocationPayload
      | path         | [0]               |
      | header       | commandHeader[0]  |
      | body         | commandBody[0]    |
      | body.address | commandAddress[0] |
    And print addCountyLocationPayload
    And request addCountyLocationPayload
    When method POST
    Then status 201
    And def addCountyLocationResponse = response
    And print addCountyLocationResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyLocationCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyLocationResponse.body.id
    And match addCountyLocationPayload.body.address.state == addCountyLocationResponse.body.address.state

    Examples: 
      | tenantid    |
      | tenantID[0] |
