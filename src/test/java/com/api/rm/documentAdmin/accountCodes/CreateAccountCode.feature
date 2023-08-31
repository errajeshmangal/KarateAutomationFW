Feature: Account Codes, Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def accountCodesCollectionName = 'CreateAccountCode_'
    And def accountCodesCollectionNameRead = 'AccountCodeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateAccountCodes
  Scenario Outline: Create a account code with all the details
    Given url commandBaseUrl
    And path '/api/CreateAccountCode'
    #Create Fund Code
    And def fundCodeResult = call read('classpath:com/api/rm/documentAdmin/fundCodes/CreateFundCodes.feature@CreateFundCodes')
    And def fundCodeResponse = fundCodeResult.response
    And print fundCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/CreateAccountCode-v1.001.json" |
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
      | commandType     | "CreateAccountCode"                        |
      | entityName      | "AccountCode"                              |
      | ttl             |                                          0 |
    And set commandBody
      | path                 |                             0 |
      | id                   | entityIdData                  |
      | accountCode2         |faker.getUserId()        |
      | shortAccountCode2    | faker.getUserId()             |
      | isActive             | true                          |
      | revenueAccount       | faker.getRandomBoolean()      |
      | longDescription      | faker.getLastName()           |
      | alternateDescription | faker.getRandomNumber()       |
      | budgetAmount         | faker.getRandom5DigitNumber() |
    And set commandFundCode
      | path |                                     0 |
      | id   | fundCodeResponse.body.id              |
      | name | fundCodeResponse.body.longDescription |
      | code | fundCodeResponse.body.fundCode1        |
    And set createAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print createAccountCodePayload
    And request createAccountCodePayload
    When method POST
    Then status 201
    And print response
    And def createAccountCodeResponse = response
    And print createAccountCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,accountCodesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createAccountCodeResponse.body.id
    And match createAccountCodeResponse.body.budgetAmount == createAccountCodePayload.body.budgetAmount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAccountCodesWithMandatoryFields
  Scenario Outline: Create a account code with only mandatory details
    Given url commandBaseUrl
    And path '/api/CreateAccountCode'
    #Create Fund Code
    And def fundCodeResult = call read('classpath:com/api/rm/documentAdmin/fundCodes/CreateFundCodes.feature@CreateFundCodesWithMandatoryFields')
    And def fundCodeResponse = fundCodeResult.response
    And print fundCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/CreateAccountCode-v1.001.json" |
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
      | commandType     | "CreateAccountCode"                        |
      | entityName      | "AccountCode"                              |
      | ttl             |                                          0 |
    And set commandBody
      | path              |                    0 |
      | id                | entityIdData         |
      | accountCode2      | faker.getFirstName() |
      | shortAccountCode2 | faker.getUserId()    |
      | longDescription   | faker.getLastName()  |
    And set commandFundCode
      | path |                                     0 |
      | id   | fundCodeResponse.body.id              |
      | name | fundCodeResponse.body.longDescription |
      | code | fundCodeResponse.body.fundCode        |
    And set createAccountCodePayload
      | path          | [0]                |
      | header        | commandHeader[0]   |
      | body          | commandBody[0]     |
      | body.fundCode | commandFundCode[0] |
    And print createAccountCodePayload
    And request createAccountCodePayload
    When method POST
    Then status 201
    And print response
    And def createAccountCodeResponse = response
    And print createAccountCodeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,accountCodesCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createAccountCodeResponse.body.id
    And match createAccountCodeResponse.body.longDescription == createAccountCodePayload.body.longDescription

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @AccountCodesBasedOnFlag
  Scenario Outline: Validate the Account codes are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetAccountCodesNameDescriptions'
    And def entityIdData = dataGenerator.entityID()
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    And set commandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/GetAccountCodesNameDescriptions-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | commandUserId   | commandUserId                                            |
      | tags            | []                                                       |
      | commandType     | "GetAccountCodesNameDescriptions"                        |
      | getType         | "Array"                                                  |
      | ttl             |                                                        0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getUsersCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAccountCodesNameDescriptionsPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getAccountCodesNameDescriptionsPayload
    And request getAccountCodesNameDescriptionsPayload
    When method POST
    Then status 200
    And def getAccountCodesNameDescriptionsResponse = response
    And print getAccountCodesNameDescriptionsResponse
    And match each getAccountCodesNameDescriptionsResponse.results[*].isActive == true
    And match getAccountCodesNameDescriptionsResponse.results[*].id contains createAccountCodeResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
