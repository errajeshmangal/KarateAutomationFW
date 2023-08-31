Feature: Get the history of entities

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  Scenario Outline: Generate the history of entities
    Given url readBaseUrl
    And path '/api/GetEntityHistory'
    And set commandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityHistory-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityHistory"                        |
      | getType         | "Array"                                   |
    And set commandRequestBody
      | path     |              0 |
      | id       | entityIdData   |
      | parentId | parentEntityId |
    And set commandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |                10 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityHistoryPayload
      | path                | [0]                   |
      | header              | commandHeader[0]      |
      | body.request        | commandRequestBody[0] |
      | body.paginationSort | commandPagination[0]  |
    And print getEntityHistoryPayload
    And request getEntityHistoryPayload
    When method POST
    Then status 200

    @GetEntityHistoryWithAllFields @tenant1
    Examples: 
      | tenantid    |
      | tenantID[0] |

  Scenario Outline: Generate the history for work flow entities
    Given url readBaseWorkFlowUrl
    And path '/api/GetEntityHistory'
    And print entityIdData
    And set commandWorkFlowHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityHistory-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityHistory"                        |
      | getType         | "Array"                                   |
    And set commandWorkFlowRequestBody
      | path     |              0 |
      | id       | entityIdData   |
      | parentId | parentEntityId |
    And set commandWorkFlowPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |                10 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityHistoryWorkFlowPayload
      | path                | [0]                           |
      | header              | commandWorkFlowHeader[0]      |
      | body.request        | commandWorkFlowRequestBody[0] |
      | body.paginationSort | commandWorkFlowPagination[0]  |
    And print getEntityHistoryWorkFlowPayload
    And request getEntityHistoryWorkFlowPayload
    When method POST
    Then status 200
    And print response

    @GetWorkFlowEntityHistoryWithAllFields @tenant1
    Examples: 
      | tenantid    |
      | tenantID[0] |

  Scenario Outline: Generate the history for genericLayout entities
    Given url readBaseGenericLayout
    And path '/api/GetEntityHistory'
    And print entityIdData
    And set commandWorkFlowHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityHistory-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityHistory"                        |
      | getType         | "Array"                                   |
    And set commandWorkFlowRequestBody
      | path     |              0 |
      | id       | entityIdData   |
      | parentId | parentEntityId |
    And set commandWorkFlowPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |                10 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityHistoryWorkFlowPayload
      | path                | [0]                           |
      | header              | commandWorkFlowHeader[0]      |
      | body.request        | commandWorkFlowRequestBody[0] |
      | body.paginationSort | commandWorkFlowPagination[0]  |
    And print getEntityHistoryWorkFlowPayload
    And request getEntityHistoryWorkFlowPayload
    When method POST
    Then status 200
    And print response

    @GetGenericLaytoutEntityHistoryWithAllFields @tenant1
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
       @GetOrderItemInfoEntityHistoryWithAllFields @tenant1
      Scenario Outline: Generate the history for Order item Info entities
    Given url readBaseWorkWithOrder
    And path '/api/GetEntityHistory'
    And print entityIdData
    And set commandWorkFlowHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityHistory-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityHistory"                        |
      | getType         | "Array"                                   |
    And set commandWorkFlowRequestBody
      | path     |              0 |
      | id       | entityIdData   |
      | parentId | parentEntityId |
    And set commandWorkFlowPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |                10 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityHistoryWorkFlowPayload
      | path                | [0]                           |
      | header              | commandWorkFlowHeader[0]      |
      | body.request        | commandWorkFlowRequestBody[0] |
      | body.paginationSort | commandWorkFlowPagination[0]  |
    And print getEntityHistoryWorkFlowPayload
    And request getEntityHistoryWorkFlowPayload
    When method POST
    Then status 200
    And print response

   
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
