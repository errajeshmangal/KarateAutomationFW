@FeeReportingGroup
Feature: Fee ReportingGroup - Add , Edit , View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeReportingGroupCollectionname = 'CreateFeeReportingGroup_'
    And def feeReportingGroupCollectionNameRead = 'FeeReportingGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateFeeReportingGroupAndGetTheDetail
  Scenario Outline: Validate Create fee ReportingGroup information with all the fields
    Given url commandBaseUrl
    And path '/api/CreateFeeReportingGroup'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateFeeReportingGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | [  "PII"]                                        |
      | commandType     | "CreateFeeReportingGroup"                        |
      | entityName      | "FeeReportingGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path               |                        0 |
      | id                 | entityIdData             |
      | reportingGroupCode | faker.getUserId()      |
      | shortDescription   | faker.getDescription()   |
      | isActive           | faker.getRandomBoolean() |
    And set addFeeReportingGrpPayload
      | path   | [0]              |
      | header | commandHeader[0] |
      | body   | commandBody[0]   |
    And print addFeeReportingGrpPayload
    And request addFeeReportingGrpPayload
    When method POST
    Then status 201
    And def addFeeReportingGrpResponse = response
    And print addFeeReportingGrpResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,feeReportingGroupCollectionNameRead+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addFeeReportingGrpResponse.body.id
    And match addFeeReportingGrpPayload.body.reportingGroupCode == addFeeReportingGrpResponse.body.reportingGroupCode
    And match addFeeReportingGrpPayload.body.shortDescription == addFeeReportingGrpResponse.body.shortDescription

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
      @GetAllFeeReportingGroupWithActiveFlag
  Scenario Outline: Validate get fee ReportingGroup information with Active Flag
    #getFeeReportingGrps
    Given url readBaseUrl
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateReportingGroupAndGetTheDetail')
    And def getfeeReportingGroupResponse = result.response
    And print getfeeReportingGroupResponse
    And path '/api/GetFeeReportingGroups'
    And def entityIdData = dataGenerator.entityID()
    And set getCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetFeeReportingGroups-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | getType         | "Array"                                        |
      | commandUserId   | dataGenerator.commandUserId()                  |
      | tags            | []                                             |
      | commandType     | "GetFeeReportingGroups"                        |
      | ttl             |                                              0 |
    And set getCommandBody
      | path                       |                    0 |
      | request.isActive           | true                 |
      | paginationSort.currentPage |                    1 |
      | paginationSort.pageSize    |                 5000 |
      | paginationSort.sortBy      | "reportingGroupCode" |
      | paginationSort.isAscending | true                 |
    And set getFeeReportingGrpsPayload
      | path   | [0]                 |
      | header | getCommandHeader[0] |
      | body   | getCommandBody[0]   |
    And print getFeeReportingGrpsPayload
    And request getFeeReportingGrpsPayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getFeeReportingGroupsAPIResponse = response
    And print getFeeReportingGroupsAPIResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
