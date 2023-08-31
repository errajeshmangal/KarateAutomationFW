@DepartmentAreaDocumentClasDropdown
Feature: DocumentType dropdowns

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def countyAreaCollectionName = 'CreateCountyArea_'
    And def countyAreaCollectionNameRead = 'CountyAreaDetailViewModel_'
    And def countyDepartmentCollectionName = 'CreateCountyDepartment_'
    And def countyDepartmentCollectionNameRead = 'CountyDepartmentDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def isActive = [true]
    And def documentClassId = 'ff20384f-f076-46bc-a008-f0d7bb6a2881'
		And def countyAreaId = '5fc622be-6ecb-4eef-ad98-a0bf33722e37'

  @CreateCountyDepartment
  Scenario Outline: Create a county department information with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateCountyDepartment'
    And def result = call read('classpath:com/api/rm/countyAdmin/Location/CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse = result.response
    And print addCountyLocationResponse
    And def result1 = call read('classpath:com/api/rm/countyAdmin/Location/CreateCountyLocation.feature@CreateCountyLocation')
    And def addCountyLocationResponse1 = result1.response
    And print addCountyLocationResponse1
    And def entityIdData = dataGenerator.entityID()
    And def firstname = faker.getFirstName()
    And set commandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/CreateCountyDepartment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | dataGenerator.SourceID()                        |
      | tenantId        | <tenantid>                                      |
      | id              | dataGenerator.Id()                              |
      | correlationId   | dataGenerator.correlationId()                   |
      | entityId        | entityIdData                                    |
      | commandUserId   | commandUserId                                   |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | "CreateCountyDepartment"                        |
      | entityName      | "CountyDepartment"                              |
      | ttl             |                                               0 |
    And set commandBody
      | path           |                    0 |
      | id             | entityIdData         |
      | name           | firstname            |
      | code           | faker.getUserId()    |
      | officialsName  | faker.getFirstName() |
      | officialsTitle | faker.getLastName()  |
      | isActive       | isActive[0]          |
    And set commandLocations
      | path |                                   0 |
      | id   | addCountyLocationResponse.body.id   |
      | name | addCountyLocationResponse.body.name |
      | code | addCountyLocationResponse.body.code |
    And set commandLocations
      | path |                                    1 |
      | id   | addCountyLocationResponse1.body.id   |
      | name | addCountyLocationResponse1.body.name |
      | code | addCountyLocationResponse1.body.code |
    And set commandGlCode
      | path |                                          0 |
      | id   | addCountyLocationResponse.body.glCode.id   |
      | name | addCountyLocationResponse.body.glCode.name |
      | code | addCountyLocationResponse.body.glCode.code |
    And set addCountyDepartmentPayload
      | path           | [0]              |
      | header         | commandHeader[0] |
      | body           | commandBody[0]   |
      | body.locations | commandLocations |
      | body.glCode    | commandGlCode[0] |
    And print addCountyDepartmentPayload
    And request addCountyDepartmentPayload
    When method POST
    Then status 201
    And def addCountyDepartmentResponse = response
    And print addCountyDepartmentResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyDepartmentCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyDepartmentResponse.body.id
    And match addCountyDepartmentResponse.body.name == firstname
    And match addCountyDepartmentResponse.body.locations[0].name == addCountyLocationResponse.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CountyDepatmentsBasedOnFlag
  Scenario Outline: Validate the county Departments are displayed based on Active flag
    Given url readBaseUrl
    And path '/api/GetCountyDepartmentsIdCodeName'
    #CreateCountyDepartment
    And def result = call read('DocumentTypeDropdown.feature@CreateCountyDepartment')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
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

  @CreateCountyAreaWithRunTimeDepartmentValues
  Scenario Outline: Create a county Area with run time parameters of Department
    Given url commandBaseUrl
    And path '/api/CreateCountyArea'
    #GetAccountCodes
    And def countyAccountCodeResult = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createCountyAccountCodeResponse = countyAccountCodeResult.response
    And print createCountyAccountCodeResponse
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
      | path |              0 |
      | id   | departmentId   |
      | code | departmentCode |
      | name | departmentName |
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
    And sleep(15000)
    Then status 201
    And def addCountyAreaResponse = response
    And print addCountyAreaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,countyAreaCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addCountyAreaResponse.body.id
    And match addCountyAreaResponse.body.name == addCountyAreaPayload.body.name

    Examples: 
      | tenantid    |
      | tenantID[0] |
      

  @RetrieveCountyAreaBasedOnDepartment
  Scenario Outline: Get the County Area based on County Department
    Given url readBaseUrl
    And path '/api/GetCountyAreasByDepartment'
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
      | path         |            0 |
      | isActive     | true         |
      | departmentId | departmentId |
    And set getCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
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
    And match getCountyAreaResponse.results[*].id contains areaCodeId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @RetrieveDocumentClassBasedOnSelectedArea
  Scenario Outline: Get Document class for Selected active Area
    Given url readBaseUrl
    And path '/api/GetDocumentClassesByCountyArea'
    #And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    #And def getCountyAreaResponse = result.response
    #And print getCountyAreaResponse
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

  @RetrieveDocumentTypeGroup
  Scenario Outline: Get Document type group
    Given url readBaseUrl
    When path '/api/GetDocumentTypeGroups'
    And set getDocumentTypeGroupsCommandHeader
      | path            |                                              0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeGroups-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()        |
      | version         | "1.001"                                        |
      | sourceId        | dataGenerator.SourceID()                       |
      | tenantId        | <tenantid>                                     |
      | id              | dataGenerator.Id()                             |
      | correlationId   | dataGenerator.correlationId()                  |
      | getType         | "Array"                                        |
      | commandUserId   | dataGenerator.commandUserId()                  |
      | tags            | []                                             |
      | commandType     | "GetDocumentTypeGroups"                        |
      | ttl             |                                              0 |
    And set getDocumentTypeGroupsCommandBodyRequest
      | path                  |    0 |
      | documentTypeGroupID   |      |
      | documentTypeGroupName |      |
      | defaultDocumentType   |      |
      | isActive              | false |
      | lastUpdatedDateTime   |      |
    And set getDocumentTypeGroupsCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false                 |
    And set getDocumentTypeGroupsCommandPayload
      | path                | [0]                                        |
      | header              | getDocumentTypeGroupsCommandHeader[0]      |
      | body.request        | getDocumentTypeGroupsCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeGroupsCommandPagination[0]  |
    And print getDocumentTypeGroupsCommandPayload
    And request getDocumentTypeGroupsCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypeGroupsResponse = response
    And print getDocumentTypeGroupsResponse
    And match each getDocumentTypeGroupsResponse.results[*].isActive == false

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @RetrieveLabelTypes
  Scenario Outline: Get LabelTypes
    Given url readBaseUrl
    And path '/api/GetDocumentTypeLabelTypes'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeLabelTypes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | tenantId        | <tenantid>                                         |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | commandUserId   | dataGenerator.commandUserId()                      |
      | tags            | []                                                 |
      | commandType     | "GetDocumentTypeLabelTypes"                        |
      | getType         | "Array"                                            |
      | ttl             |                                                  0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    #| id | 'ff20384f-f076-46bc-a008-f0d7bb6a2881' |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getLabelTypePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getLabelTypePayload
    And request getLabelTypePayload
    When method POST
    Then status 200
    And def getLabelTypesResponse = response
    And print getLabelTypesResponse
    And match each getLabelTypesResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypeBookPages
  Scenario Outline: Get DocumentTypeBookPages
    Given url readBaseUrl
    And path '/api/GetDocumentTypeBookPages'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeBookPages-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | dataGenerator.SourceID()                          |
      | tenantId        | <tenantid>                                        |
      | id              | dataGenerator.Id()                                |
      | correlationId   | dataGenerator.correlationId()                     |
      | commandUserId   | dataGenerator.commandUserId()                     |
      | tags            | []                                                |
      | commandType     | "GetDocumentTypeBookPages"                        |
      | getType         | "Array"                                           |
      | ttl             |                                                 0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    #| id |  |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getBookPagesPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getBookPagesPayload
    And request getBookPagesPayload
    When method POST
    Then status 200
    And def getBookPagesResponse = response
    And print getBookPagesResponse
    And match each getBookPagesResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypePrimaryNumberingSchemes
  Scenario Outline: Get DocumentTypePrimaryNumberingSchemes
    Given url readBaseUrl
    And path '/api/GetDocumentTypePrimaryNumberingSchemes'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                               0 |
      | schemaUri       | schemaUri+"/GetDocumentTypePrimaryNumberingSchemes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                         |
      | version         | "1.001"                                                         |
      | sourceId        | dataGenerator.SourceID()                                        |
      | tenantId        | <tenantid>                                                      |
      | id              | dataGenerator.Id()                                              |
      | correlationId   | dataGenerator.correlationId()                                   |
      | commandUserId   | dataGenerator.commandUserId()                                   |
      | tags            | []                                                              |
      | commandType     | "GetDocumentTypePrimaryNumberingSchemes"                        |
      | getType         | "Array"                                                         |
      | ttl             |                                                               0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    #| id |  |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getprimaryNumberingSchemePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getprimaryNumberingSchemePayload
    And request getprimaryNumberingSchemePayload
    When method POST@GetDocumentTypeSecondaryNumberingSchemes
    Then status 200
    And def getprimaryNumberingSchemesResponse = response
    And print getprimaryNumberingSchemesResponse
    And match each getprimaryNumberingSchemesResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypeSecondaryNumberingSchemes
  Scenario Outline: Get DocumentTypeSecondaryNumberingSchemes
    Given url readBaseUrl
    And path '/api/GetDocumentTypeSecondaryNumberingSchemes'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                                 0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeSecondaryNumberingSchemes-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                           |
      | version         | "1.001"                                                           |
      | sourceId        | dataGenerator.SourceID()                                          |
      | tenantId        | <tenantid>                                                        |
      | id              | dataGenerator.Id()                                                |
      | correlationId   | dataGenerator.correlationId()                                     |
      | commandUserId   | dataGenerator.commandUserId()                                     |
      | tags            | []                                                                |
      | commandType     | "GetDocumentTypeSecondaryNumberingSchemes"                        |
      | getType         | "Array"                                                           |
      | ttl             |                                                                 0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    #| id | |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getsecondaryNumberingSchemePayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getsecondaryNumberingSchemePayload
    And request getsecondaryNumberingSchemePayload
    When method POST
    Then status 200
    And def getsecondaryNumberingSchemesResponse = response
    And print getsecondaryNumberingSchemesResponse
    And match each getsecondaryNumberingSchemesResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypeStorageAreas
  Scenario Outline: Get DocumentTypeStorageAreas
    Given url readBaseUrl
    And path '/api/GetDocumentTypeStorageAreas'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetDocumentTypeStorageAreas-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | dataGenerator.SourceID()                             |
      | tenantId        | <tenantid>                                           |
      | id              | dataGenerator.Id()                                   |
      | correlationId   | dataGenerator.correlationId()                        |
      | commandUserId   | dataGenerator.commandUserId()                        |
      | tags            | []                                                   |
      | commandType     | "GetDocumentTypeStorageAreas"                        |
      | getType         | "Array"                                              |
      | ttl             |                                                    0 |
    And set commandBodyRequest
      | path     |    0 |
      | isActive | true |
    #| id |  |
    And set getUsersCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getstorageAreaPayload
      | path                | [0]                          |
      | header              | commandHeader[0]             |
      | body.request        | commandBodyRequest[0]        |
      | body.paginationSort | getUsersCommandPagination[0] |
    And print getstorageAreaPayload
    And request getstorageAreaPayload
    When method POST
    Then status 200
    And def getstorageAreasResponse = response
    And print getstorageAreasResponse
    And match each getstorageAreasResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
 
