# This feature file created to use the response of these scenarios in the E2E Target Queue feature
Feature: Create Target Topic - Target Queue

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def targetTopicsCollectionName = 'CreateTargetTopics_'
    And def targetTopicsCollectionNameRead = 'TargetTopicsDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def queuesList = ['DecisionPoint','Target']
    And def commandTypeList = ['CreateTargetTopic','UpdateteTargetTopic','GetTargetTopic','GetTargetTopics']
    And def entityName = ['TargetTopic']

  @GetTargetTopics
  Scenario Outline: Get a Target  queue with all the fields and Validate
    Given url readBaseWorkFlowUrl
    And path '/api/'+commandTypeList[3]
    And set getTargetTopicsCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandTypeList[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | commandUserId   | commandUserId                                   |
      | tags            | []                                              |
      | commandType     | commandTypeList[3]                              |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getTargetTopicsCommandBody
      | path     |    0 |
      | isActive | true |
    And set getTargetTopicsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getTargetTopicsPayload
      | path                | [0]                                 |
      | header              | getTargetTopicsCommandHeader[0]     |
      | body.request        | getTargetTopicsCommandBody[0]       |
      | body.paginationSort | getTargetTopicsCommandPagination[0] |
    And print getTargetTopicsPayload
    And request getTargetTopicsPayload
    When method POST
    Then status 200
    And def getTargetTopicsResponse = response
    And print getTargetTopicsResponse
    And match each getTargetTopicsResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
