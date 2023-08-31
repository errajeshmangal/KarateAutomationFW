Feature: Active Department,active area,Document Class,Default Document Type

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyAreaCollectionName = 'CreateCountyArea_'
    And def countyAreaCollectionNameRead = 'CountyAreaDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def documentClassId = 'ff20384f-f076-46bc-a008-f0d7bb6a2881'
    And def countyAreaId = '5fc622be-6ecb-4eef-ad98-a0bf33722e37'

  @CountyDepatmentsBasedOnFlag
  Scenario Outline: Validate the county Departments are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetCountyDepartmentsIdCodeName'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/GetCountyDepartmentsIdCodeName-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | commandUserId   | dataGenerator.commandUserId()                           |
      | tags            | []                                                      |
      | commandType     | "GetCountyDepartmentsIdCodeName"                        |
      | getType         | "Array"                                                 |
      | ttl             |                                                       0 |
    And set commandBodyRequest
      | path     |    0 |
      | code     |      |
      | isActive | true |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCountyDepartmentsIdCodeNamePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getCountyDepartmentsIdCodeNamePayload
    And request getCountyDepartmentsIdCodeNamePayload
    When method POST
    Then status 200
    And def getCountyDepartmentsIdCodeNameResponse = response
    And print getCountyDepartmentsIdCodeNameResponse
    And match each getCountyDepartmentsIdCodeNameResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #Create the new active County Area using the selected active department and get area
  @CreateActiveAreaBasedOnActiveDepartmentAndGetArea
  Scenario Outline: Create Active Area for Selected active department
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandAreaHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/CreateCountyArea-v1.001.json" |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | tenantId        | <tenantid>                                |
      | ttl             |                                         0 |
      | commandType     | "CreateCountyArea"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | tags            | []                                        |
      | entityVersion   |                                         1 |
      | entityId        | entityIdData                              |
      | commandUserId   | dataGenerator.commandUserId()             |
      | entityName      | "CountyArea"                              |
    And set commandAreaBody
      | path     |                       0 |
      | id       | entityIdData            |
      | code     | faker.getUserId()       |
      | name     | faker.getFirstName()    |
      | isActive | true                    |
      | comments | faker.getRandomNumber() |
    And set commandAreaDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | code | activeDepartmentResponse.results[0].code |
      | name | activeDepartmentResponse.results[0].name |
    And set commandAreaGLCode
      | path |                                                      0 |
      | id   | createCountyAccountCodeResponse.body.id                |
      | name | createCountyAccountCodeResponse.body.shortAccountCode2 |
      | code | createCountyAccountCodeResponse.body.accountCode2      |
    And set addCountyAreaPayload
      | path            | [0]                      |
      | header          | commandAreaHeader[0]     |
      | body            | commandAreaBody[0]       |
      | body.department | commandAreaDepartment[0] |
      | body.glCode     | commandAreaGLCode[0]     |
    And print addCountyAreaPayload
    And request addCountyAreaPayload
    When method POST
    Then status 201
    And def addCountyAreaResponse = response
    And print addCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyAreaResponse.body.id
    And match addCountyAreaResponse.body.name == addCountyAreaPayload.body.name
    # Get the active county Area based on selected active Department
    Given url readBaseUrl
    And path '/api/GetCountyAreasByDepartment'
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And set getCommandHeader
      | path            |                                                   0 |
      | schemaUri       | schemaUri+"/GetCountyAreasByDepartment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()             |
      | version         | "1.001"                                             |
      | sourceId        | dataGenerator.SourceID()                            |
      | tenantId        | <tenantid>                                          |
      | id              | dataGenerator.Id()                                  |
      | correlationId   | dataGenerator.correlationId()                       |
      | commandUserId   | dataGenerator.commandUserId()                       |
      | tags            | []                                                  |
      | commandType     | "GetCountyAreasByDepartment"                        |
      | getType         | "Array"                                             |
      | ttl             |                                                   0 |
    And set getCommandBody
      | path         |                                      0 |
      # | code         | activeDepartmentResponse.results[0].code |
      | isActive     | true                                   |
      | departmentId | activeDepartmentResponse.results[0].id |
    And set getCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getCountyAreaPayload
      | path                | [0]                     |
      | header              | getCommandHeader[0]     |
      | body.request        | getCommandBody[0]       |
      | body.paginationSort | getCommandPagination[0] |
    And print getCountyAreaPayload
    And request getCountyAreaPayload
    When method POST
    Then status 200
    And def getCountyAreaResponse = response
    And print getCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,countyAreaCollectionNameRead+<tenantid>,getCountyAreaResponse.results[0].id)
    And print mongoResult
    And match mongoResult == getCountyAreaResponse.results[0].id
    And match each getCountyAreaResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #Get the Document Classes are displayed based on Selected Active Area
  @GetDocumentClassBasedOnSelectedArea
  Scenario Outline: Get Document class for Selected active Area
    Given url readBaseUrl
    And path '/api/GetDocumentClassesByCountyArea'
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def getCountyAreaResponse = result.response
    And print getCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/GetDocumentClassesByCountyArea-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | commandUserId   | dataGenerator.commandUserId()                           |
      | tags            | []                                                      |
      | commandType     | "GetDocumentClassesByCountyArea"                        |
      | getType         | "Array"                                                 |
      | ttl             |                                                       0 |
    And set commandBodyRequest
      | path         |            0 |
      # | code         | getCountyAreaResponse.results[0].code |
      | isActive     | true         |
      | countyAreaId | countyAreaId |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentClassesPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getDocumentClassesPayload
    And request getDocumentClassesPayload
    When method POST
    Then status 200
    And def getDocumentClassesResponse = response
    And print getDocumentClassesResponse
    And match each getDocumentClassesResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #Get the Default Document Type are displayed based on Selected Active Document Classes
  @GetDefaultDocumentTypeBasedOnDocumentClasses
  Scenario Outline: Get the Default Document Type are displayed based on Selected Active Document Classes
    Given url readBaseUrl
    And path '/api/GetDefaultDocumentTypesByDocumentClass'
    And def entityIdData = dataGenerator.entityID()
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def getDocumentClassesResponse = result.response
    And set commandHeader
      | path            |                                                               0 |
      | schemaUri       | schemaUri+"/GetDefaultDocumentTypesByDocumentClass-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                         |
      | version         | "1.001"                                                         |
      | sourceId        | dataGenerator.SourceID()                                        |
      | tenantId        | <tenantid>                                                      |
      | id              | dataGenerator.Id()                                              |
      | correlationId   | dataGenerator.correlationId()                                   |
      | commandUserId   | dataGenerator.commandUserId()                                   |
      | tags            | []                                                              |
      | commandType     | "GetDefaultDocumentTypesByDocumentClass"                        |
      | getType         | "Array"                                                         |
      | ttl             |                                                               0 |
    And set commandBodyRequest
      | path            |               0 |
      #| code            | getDocumentClassesResponse.results[0].code |
      | isActive        | true            |
      | documentClassId | documentClassId |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDefaultDocumentTypePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getDefaultDocumentTypePayload
    And request getDefaultDocumentTypePayload
    When method POST
    Then status 200
    And def getDefaultDocumentTypeResponse = response
    And print getDefaultDocumentTypeResponse
    And match each getDefaultDocumentTypeResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
