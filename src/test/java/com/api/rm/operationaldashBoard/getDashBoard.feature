@getDashobaord
Feature: Get Operationa DashBoard

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def OrderCollectionName = 'CreateOrder_'
    And def dashBoardCollectionNameRead = 'CashieringDashboardDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = 'CreateOrder'
    And def entityName = 'Order'
    And def getType = 'One'

  @GetCashieringByDocumentType
  Scenario Outline: Get a Cashiering By DocumentType with all the fields
    Given url readDashboard
    And path '/api/GetCashieringByDocumentType'
    And set getCashieringHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetCashieringByDocumentType-v1.001.json" |
      | version         | "1.001"                                              |
      | sourceId        | dataGenerator.SourceID()                             |
      | id              | dataGenerator.Id()                                   |
      | correlationId   | dataGenerator.correlationId()                        |
      | tenantId        | <tenantid>                                           |
      | ttl             |                                                    0 |
      | commandType     | 'GetCashieringByDocumentType'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | tags            | []                                                   |
      | commandUserId   | dataGenerator.commandUserId()                        |
      | getType         | getType                                              |
    And set getCashieringBodyRequest
      | path   |                             0 |
      | source | 'GetCashieringByDocumentType' |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.source == getCashieringPayload.body.request.source
    And match getCashieringResponse.documentTypes[0].documentType == '#notnull'
    And match getCashieringResponse.documentTypes[0].openCount == '#notnull'
    And match getCashieringResponse.documentTypes  == '#array'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetCashieringByStatus
  Scenario Outline: Get a Cashiering By Status with all the fields
    Given url readDashboard
    And path '/api/GetCashieringByStatus'
    And set getCashieringHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetCashieringByStatus-v1.001.json" |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | tenantId        | <tenantid>                                     |
      | ttl             |                                              0 |
      | commandType     | 'GetCashieringByStatus'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | tags            | []                                             |
      | commandUserId   | dataGenerator.commandUserId()                  |
      | getType         | 'One'                                          |
    And set getCashieringBodyRequest
      | path   |                       0 |
      | source | 'GetCashieringByStatus' |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.source == getCashieringPayload.body.request.source
    And match getCashieringResponse.byStatus.openDocument.total == '#notnull'
    And match getCashieringResponse.byStatus.openDocument.olderADay == '#notnull'
    And match getCashieringResponse.byStatus.openDocument.openToday == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.today == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.yesterday == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.thisWeek == '#notnull'
    And match getCashieringResponse.byStatus.inProgressDocument.documents == '#notnull'
    And match getCashieringResponse.byStatus.inProgressDocument.persons == '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetCashieringByDocumentByDates
  Scenario Outline: Get a Cashiering  Documents By Dates with all the fields
    Given url readDashboard
    And path '/api/GetCashieringDocumentByDates'
    And set getCashieringHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/GetCashieringDocumentByDates-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | 'GetCashieringDocumentByDates'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | getType         | 'Array'                                               |
    And set getCashieringBodyRequest
      | path   |                                0 |
      | source | 'GetCashieringByDocumentByDates' |
    And set getCashieringPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCashieringPayload
      | path                | [0]                         |
      | header              | getCashieringHeader[0]      |
      | body.request        | getCashieringBodyRequest[0] |
      | body.paginationSort | getCashieringPagination[0]  |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.results[0].source == getCashieringPayload.body.request.source
    And match getCashieringResponse.results[0].documentByDates[0].documentDate == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].documents == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].daysPending == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].documents == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].documents == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].documents == '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetCashieringDocumentByRange
  Scenario Outline: Get a Cashiering  Documents By Range with all the fields
    Given url readDashboard
    And path '/api/GetCashieringDocumentByRange'
    And set getCashieringHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/GetCashieringDocumentByRange-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | 'GetCashieringDocumentByRange'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | getType         | getType                                               |
    And set getCashieringBodyRequest
      | path   |                              0 |
      | source | 'GetCashieringDocumentByRange' |
      | range  | 'Day'                          |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.source == getCashieringPayload.body.request.source
    And match getCashieringResponse.documentCountByRange.statusCount[0].openCount == '#notnull'
    And match getCashieringResponse.documentCountByRange.statusCount[0].completedCount == '#notnull'
    And match getCashieringResponse.documentCountByRange.statusCount[1].openCount == '#notnull'
    And match getCashieringResponse.documentCountByRange.statusCount[1].completedCount == '#notnull'
    And match getCashieringResponse.documentCountByRange.statusCount[2].openCount == '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetIndexingByStatus
  Scenario Outline: Get Index Status with all the fields
    Given url readDashboard
    And path '/api/GetIndexingByStatus'
    And set getCashieringHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetIndexingByStatus-v1.001.json" |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | ttl             |                                            0 |
      | commandType     | 'GetIndexingByStatus'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | tags            | []                                           |
      | commandUserId   | dataGenerator.commandUserId()                |
      | getType         | getType                                      |
    And set getCashieringBodyRequest
      | path      |      0 |
      | queueName | 'test' |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.queueName == getCashieringPayload.body.request.queueName
    And match getCashieringResponse.byStatus.openDocument.total == '#notnull'
    And match getCashieringResponse.byStatus.openDocument.olderADay == '#notnull'
    And match getCashieringResponse.byStatus.openDocument.openToday == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.today == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.yesterday == '#notnull'
    And match getCashieringResponse.byStatus.completedDocument.thisWeek == '#notnull'
    And match getCashieringResponse.byStatus.inProgressDocument.documents == '#notnull'
    And match getCashieringResponse.byStatus.inProgressDocument.persons == '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetIndexingByDocumentType
  Scenario Outline: Get a Indexing By Document Type with all the fields
    Given url readDashboard
    And path '/api/GetIndexingByDocumentType'
    And set getCashieringHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetIndexingByDocumentType-v1.001.json" |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | tenantId        | <tenantid>                                         |
      | ttl             |                                                  0 |
      | commandType     | 'GetIndexingByDocumentType'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | tags            | []                                                 |
      | commandUserId   | dataGenerator.commandUserId()                      |
      | getType         | getType                                            |
    And set getCashieringBodyRequest
      | path      |      0 |
      | queueName | 'test' |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.queueName ==  getCashieringPayload.body.request.queueName
    And match getCashieringResponse.documentTypes[0].documentType == '#notnull'
    And match getCashieringResponse.documentTypes[0].openCount ==  '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetIndexingDocumentByDates
  Scenario Outline: Get a Indexing By Document Dates with all the fields
    Given url readDashboard
    And path '/api/GetIndexingDocumentByDates'
    And set getCashieringHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetIndexingDocumentByDates-v1.001.json" |
      | version         | "1.001"                                             |
      | sourceId        | dataGenerator.SourceID()                            |
      | id              | dataGenerator.Id()                                  |
      | correlationId   | dataGenerator.correlationId()                       |
      | tenantId        | <tenantid>                                          |
      | ttl             |                                                   0 |
      | commandType     | 'GetIndexingDocumentByDates'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | tags            | []                                                  |
      | commandUserId   | dataGenerator.commandUserId()                       |
      | getType         | 'Array'                                             |
    And set getCashieringBodyRequest
      | path      |      0 |
      | queueName | 'test' |
    And set getCashieringPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCashieringPayload
      | path                | [0]                         |
      | header              | getCashieringHeader[0]      |
      | body.request        | getCashieringBodyRequest[0] |
      | body.paginationSort | getCashieringPagination[0]  |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.results[0].queueName ==  getCashieringPayload.body.request.queueName
    And match getCashieringResponse.results[0].documentByDates[0].documentDate == '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].documents ==  '#notnull'
    And match getCashieringResponse.results[0].documentByDates[0].daysPending ==  '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetIndexingDocumentByRange
  Scenario Outline: Get a Indexing By Document Range with all the fields
    Given url readDashboard
    And path '/api/GetIndexingDocumentByRange'
    And set getCashieringHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetIndexingDocumentByRange-v1.001.json" |
      | version         | "1.001"                                             |
      | sourceId        | dataGenerator.SourceID()                            |
      | id              | dataGenerator.Id()                                  |
      | correlationId   | dataGenerator.correlationId()                       |
      | tenantId        | <tenantid>                                          |
      | ttl             |                                                   0 |
      | commandType     | 'GetIndexingDocumentByRange'                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | tags            | []                                                  |
      | commandUserId   | dataGenerator.commandUserId()                       |
      | getType         | getType                                             |
    And set getCashieringBodyRequest
      | path      |      0 |
      | queueName | 'test' |
      | range     | 'day'  |
    And set getCashieringPayload
      | path         | [0]                         |
      | header       | getCashieringHeader[0]      |
      | body.request | getCashieringBodyRequest[0] |
    And print getCashieringPayload
    And request getCashieringPayload
    When method POST
    Then status 200
    And def getCashieringResponse = response
    And print getCashieringResponse
    And match getCashieringResponse.queueName ==  getCashieringPayload.body.request.queueName
    And match getCashieringResponse.documentCountByRange.statusCount[0].openCount == '#notnull'
    And match getCashieringResponse.documentCountByRange.statusCount[0].completedCount ==  '#notnull'

    Examples: 
      | tenantid    |
      | tenantID[0] |
