Feature: Retrieve Fee codes

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeCodeGroupCollectionName = 'CreateFeeCodeGroup_'
    And def createFeeCodeGroupCollectionNameRead = 'FeeGroupDetailsViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And def commandType = ['GetFeeCodeFeeGroups','GetFeeCodeByFeeGroupId']
    And def restricted = [true,false]
    And def inherited = ['Y','N']
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @RetrieveAllFeeCodes
  Scenario Outline: Get all the feed codes
    Given url readBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set getFeeCodeFeeGroupsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFeeCodeFeeGroupsCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getFeeCodeFeeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeGroupsPayload
      | path                | [0]                                      |
      | header              | getFeeCodeFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeCodeFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeGroupsCommandPagination[0]  |
    And print getFeeCodeFeeGroupsPayload
    And request getFeeCodeFeeGroupsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getFeeCodeFeeGroupsResponse = response
    And print getFeeCodeFeeGroupsResponse
    And match each getFeeCodeFeeGroupsResponse.results[*].isActive == getFeeCodeFeeGroupsPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @RetrieveAllFeeCodesBasedOnFeeGroup
  Scenario Outline: Get all the fee codes for inherited fee group
    Given url readBaseUrl
    And path '/api/'+commandType[1]
    And def entityIDData = dataGenerator.entityID()
    And set getFeeCodeFeeGroupsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[1]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getFeeCodeFeeGroupsCommandBodyRequest
      | path             |          0 |
      | feeGroupId       | feeGroupId |
      #| isInheritedGroup | true       |
    And set getFeeCodeFeeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getFeeCodeFeeGroupsPayload
      | path                | [0]                                      |
      | header              | getFeeCodeFeeGroupsCommandHeader[0]      |
      | body.request        | getFeeCodeFeeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getFeeCodeFeeGroupsCommandPagination[0]  |
    And print getFeeCodeFeeGroupsPayload
    And request getFeeCodeFeeGroupsPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getFeeCodeFeeGroupsResponse = response
    And print getFeeCodeFeeGroupsResponse
    And match each getFeeCodeFeeGroupsResponse.results[*].feeGroupId contains feeGroupId

    Examples: 
      | tenantid    |
      | tenantID[0] |
