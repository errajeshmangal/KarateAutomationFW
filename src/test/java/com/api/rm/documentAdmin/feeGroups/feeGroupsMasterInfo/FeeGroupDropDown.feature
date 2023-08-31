Feature: Create a fee group dropdowns

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeGroupCollectionName = 'CreateFeeGroup_'
    And def createFeeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['GetFeeGroupsByAreaId']
    And def entityName = ['FeeGroup','FeeCodeGroup','GetFeeGroups']
    And def restricted = [true,false]
    And def countyAreaCollectionName = 'CreateCountyArea_'
    And def countyAreaCollectionNameRead = 'CountyAreaDetailViewModel_'

  @RetrieveInheritedFeeGroups
  Scenario Outline: Get the Inherited Fee Groups based on the selected Area
    Given url readBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set inheritedFeeGroupCommandHeader
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
    And set inheritedFeeGroupCommandBodyRequest
      | path     |            0 |
      | areaId   | areaCodeId   |
      | isActive | isActiveFlag |
    And set inheritedFeeGroupCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getInheritedFeeGroupePayload
      | path                | [0]                                    |
      | header              | inheritedFeeGroupCommandHeader[0]      |
      | body.request        | inheritedFeeGroupCommandBodyRequest[0] |
      | body.paginationSort | inheritedFeeGroupCommandPagination[0]  |
    And print getInheritedFeeGroupePayload
    And request getInheritedFeeGroupePayload
    When method POST
    Then status 200
    And def getInheritedFeeGroupeResponse = response
    And print getInheritedFeeGroupeResponse
    And match each getInheritedFeeGroupeResponse.results[*].isActive == isActiveFlag
    And def getInheritedFeeGroupeResponseCount = karate.sizeOf(getInheritedFeeGroupeResponse.results)
    And print getInheritedFeeGroupeResponseCount
    And match getInheritedFeeGroupeResponseCount == getInheritedFeeGroupeResponse.totalRecordCount

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

  @GetFeeGroups
  Scenario Outline: Get all the fee groups -Grid View
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And def entityIDData = dataGenerator.entityID()
    And set inheritedFeeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set feeGroupCommandBodyRequest
      | path     |                             0 |
      | isActive | faker.getRandomBooleanValue() |
    And set feeGroupCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getInheritedFeeGroupPayload
      | path                | [0]                           |
      | header              | commandHeader[0]              |
      | body.request        | feeGroupCommandBodyRequest[0] |
      | body.paginationSort | feeGroupCommandPagination[0]  |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match each getFeeGroupResponse.results[*].isActive == getFeeGroupPayload.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @AllFeeGroups
  Scenario Outline: Get the Inherited Fee Groups based on the selected Area
    Given url readBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set inheritedFeeGroupCommandHeader
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
    And set inheritedFeeGroupCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set inheritedFeeGroupCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getInheritedFeeGroupePayload
      | path                | [0]                                    |
      | header              | inheritedFeeGroupCommandHeader[0]      |
      | body.request        | inheritedFeeGroupCommandBodyRequest[0] |
      | body.paginationSort | inheritedFeeGroupCommandPagination[0]  |
    And print getInheritedFeeGroupePayload
    And request getInheritedFeeGroupePayload
    When method POST
    And sleep(30000)
    Then status 200
    And sleep(15000)
    And def getInheritedFeeGroupeResponse = response
    And print getInheritedFeeGroupeResponse
    And match each getInheritedFeeGroupeResponse.results[*].isActive == getInheritedFeeGroupePayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CountyAreaWithRunTimeDepatmentArea
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
