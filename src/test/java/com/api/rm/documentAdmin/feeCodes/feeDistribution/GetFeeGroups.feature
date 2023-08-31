Feature: FeeGroup- Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeCodeInfoCollection = 'CreateFeeCodeFeeInfo_'
    And def feeCodeInfoCollectionAddressRead = 'FeeCodeFeeInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def feeGrpParam = ["GetFeeGroupsByFeeCodeId"]

  @GetFeeGrpDetails
  Scenario Outline: Get FeeGroupsByFeeCodeId with all the fields and Validate
    Given url readBaseUrl
    And path '/api/GetFeeGroupsByFeeCodeId'
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse = result.response
    And print getAllFeeCodeResponse
    And set getFeeGroupsAllCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/GetFeeGroupsByFeeCodeId-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | id              | entityIdData                                     |
      | tenantId        | <tenantid>                                       |
      | correlationId   | dataGenerator.correlationId()                    |
      | commandUserId   | commandUserId                                    |
      | tags            | []                                               |
      | commandType     | feeGrpParam[0]                                   |
      | getType         | "Array"                                          |
    And set getFeeGroupsCommandBodyRequest
      | path      |                                             0 |
      | feeCodeId | getAllFeeCodeResponse.results[0].feeCodeId |
    And set getFeeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeGroupsAllPayload
      | path                | [0]                               |
      | header              | getFeeGroupsAllCommandHeader[0]   |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsAllPayload
    And request getFeeGroupsAllPayload
    When method POST
    Then status 200
    And def getFeeGroupsAllResponse = response
    And print getFeeGroupsAllResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetAllFeeCodes
  Scenario Outline: Get All Fee Codes with all the fields and Validate
    #getAllFeeCodeDistributionInfo
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And def entityIdData = dataGenerator.entityID()
    And set getFeecodeAllCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetFeeCodes-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | entityIdData                            |
      | tenantId        | <tenantid>                              |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | tags            | []                                      |
      | commandType     | "GetFeeCodes"                           |
      | getType         | "Array"                                 |
    And set getFeecodeAllCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getFeecodeAllCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeecodeAllPayload
      | path                | [0]                                |
      | header              | getFeecodeAllCommandHeader[0]      |
      | body.request        | getFeecodeAllCommandBodyRequest[0] |
      | body.paginationSort | getFeecodeAllCommandPagination[0]  |
    And print getFeecodeAllPayload
    And request getFeecodeAllPayload
    When method POST
    Then status 200
    And def  getFeecodeAllResponse = response
    And print getFeecodeAllResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetFeeGrpsDetails
  Scenario Outline: Get Fee Groups with all the fields and Validate
    Given url readBaseUrl
    And path '/api/GetFeeGroups'
    And def entityIdData = dataGenerator.entityID()
    And set getFeeGroupsAllCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetFeeGroups-v1.001.json"   |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | entityIdData                            |
      | tenantId        | <tenantid>                              |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | tags            | []                                      |
      | commandType     | "GetFeeGroups"                          |
      | getType         | "Array"                                 |
    And set getFeeGroupsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getFeeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeGroupsAllPayload
      | path                | [0]                               |
      | header              | getFeeGroupsAllCommandHeader[0]   |
      | body.request        | getFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeGroupsCommandPagination[0]  |
    And print getFeeGroupsAllPayload
    And request getFeeGroupsAllPayload
    When method POST
    Then status 200
    And def getFeeGroupsAllResponse = response
    And print getFeeGroupsAllResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeGroupDetails @dwd
  Scenario Outline: Add Feecode into FeeGroupDetails with feecode ID and Validate
    Given url commandBaseUrl
    And path '/api/UpdateFeeGroupDetails'
    #Get All fee codes  Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeDistribution/GetFeeGroups.feature@GetAllFeeCodes')
    And def getAllFeeCodeResponse = result.response
    And print getAllFeeCodeResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeDistributionCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/UpdateFeeGroupDetails-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | entityId        | entityIdData                                   |
      | commandUserId   | commandUserId                                  |
      | entityVersion   |                                              2 |
      | tags            | []                                             |
      | commandType     | "UpdateFeeGroupDetails"                        |
      | entityName      | "FeeGroupDetails"                              |
      | ttl             |                                              0 |
    And set createFeeDistributionCommandBody
      | path                      |                                                 0 |
      | id                        | entityIdData                                      |
      | feeGroupId                | getFeeGrpsDetailsResponse.results[0].id           |
      | feeGroupCode              | getFeeGrpsDetailsResponse.results[0].feeGroupCode |
      | description               | getFeeGrpsDetailsResponse.results[0].description  |
      | isActive                  | getFeeGrpsDetailsResponse.results[0].isActive     |
      | feeCode[0].id             | getAllFeeCodeResponse.results[0].id               |
      | feeCode[0].feeCodeId      | getAllFeeCodeResponse.results[0].feeCodeId        |
      | feeCode[0].feeCodeName    | getAllFeeCodeResponse.results[0].feeCode          |
      | feeCode[0].feeDescription | getAllFeeCodeResponse.results[0].description      |
      | feeCode[0].feeType        | getAllFeeCodeResponse.results[0].feeType          |
      | feeCode[0].isActive       | getAllFeeCodeResponse.results[0].isActive         |
      | feeCode[0].inherited      | false                                             |
      | feeCode[0].optional       | false                                             |
      | feeCode[0].allowRemoval   | false                                             |
    And set createFeeDistributionPayload
      | path   | [0]                                   |
      | header | createFeeDistributionCommandHeader[0] |
      | body   | createFeeDistributionCommandBody[0]   |
    And print createFeeDistributionPayload
    And request createFeeDistributionPayload
    When method POST
    Then status 201
    And def createFeeDistributionResponse = response
    And print createFeeDistributionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
