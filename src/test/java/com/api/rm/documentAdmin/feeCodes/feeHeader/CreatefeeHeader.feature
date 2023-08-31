@FeeCodeFeeHeader

Feature: feeCodeHeader  

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeCodeHeaderCollection = 'CreateFeeCodeHeader_'
    And def feeCodeHeaderCollectionRead = 'feeCodeHeadeDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def feeCodeParam = ["CreateFeeCodeHeader","FeeCodeHeader"]
    And def createFeeCodeGroupCollectionName = 'CreateFeeCodeGroup_'
    And def createFeeCodeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def commandType = ['GetFeeCodeFeeGroups','GetFeeCodeByFeeGroupId','GetFeeFormulas']
    And def restricted = [true,false]
    And def inherited = ['Y','N']
 And def feeFormulaParams = ["CreateFeeFormula" , "FeeFormula" ,"GetFeeFormula","GetFeeFormulas"]


  @CreateFeeCodeFeeHeader @testdf
  Scenario Outline: Create a Fee Code Header with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeHeader'
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    #Get document class by county area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def addDocumentClassResponse = result.response
    And print addDocumentClassResponse
    #Get  Serial Number assigned Dummy API
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@GetAllSerialNumberAssigned')
    And def getSerialNumberResponse = result.response
    And print getSerialNumberResponse
    #Get  FeeCode Fee Grps API
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@RetrieveAllFeeCodesFeeGrps')
    And def getFeeCodeFeeGrpsResponse = result.response
    And print getFeeCodeFeeGrpsResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeHeaderCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeHeader-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | feeCodeParam[0]                              |
      | entityName      | feeCodeParam[1]                              |
      | ttl             |                                            0 |
    And set createFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | entityIdData                                       |
      | feeCodeId                       | faker.getRandomShortDescription()                              |
      | feeCodeName                   |  faker.getRandomShortDescription()                            |
      | feeDescription                   | faker.getRandomShortDescription()                  |
      | isActive                      | faker.getRandomBoolean()                           |
      | feeType                       | faker.getFeeType()                                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | feeOutputCategory             |  faker.FeeOutPutCategoryEnum()                     |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | documentClass.code            | addDocumentClassResponse.results[0].code           |
      | documentClass.id              | addDocumentClassResponse.results[0].id             |
      | documentClass.description     | addDocumentClassResponse.results[0].name           |
      | documentClass.isActive        | addDocumentClassResponse.results[0].isActive       |
      | serialNumberAssigned.id       | getSerialNumberResponse.results[0].id              |
      | serialNumberAssigned.code     | getSerialNumberResponse.results[0].code            |
      | serialNumberAssigned.isActive | getSerialNumberResponse.results[0].isActive        |
      | feeEditRule                   | "Test Fee Edit Rule"                               |
      | maxAmountPerOrder             | dataGenerator.generateSingleOrDoubleDigitNumber()  |
      | notAllowedWithTaxes           | faker.getRandomBoolean()                           |
      | warningOrError                | "Warning"                                          |
      | uniqueProcessingFlag          | faker.getProcessingFlag()                          |
      | allowAdjustment               | faker.getRandomBoolean()                           |
      | cityCode                      | faker.getRandomBoolean()                           |
      | restrictedFeeUsage            | faker.getRandomBoolean()                           |
      | taxable                       | faker.getRandomBoolean()                           |
      | allowDuplicateFeeCodeEntry    | faker.getRandomBoolean()                           |
      | includeInOverrideDropdown     | faker.getRandomBoolean()                           |
      | shouldBeFeeCode.id            | getFeeCodeFeeGrpsResponse.results[0].id            |
      | shouldBeFeeCode.code          | getFeeCodeFeeGrpsResponse.results[0].code          |
      | shouldBeFeeCode.name          | getFeeCodeFeeGrpsResponse.results[0].name          |
      | shouldBeFeeCode.isActive      | getFeeCodeFeeGrpsResponse.results[0].isActive      |
    And set CreateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | createFeeCodeHeaderCommandHeader[0] |
      | body   | createFeeCodeHeaderCommandBody[0]   |
    And print CreateFeeCodeHeaderPayload
    And request CreateFeeCodeHeaderPayload
    When method POST
    Then status 201
    And def CreateFeeCodeHeaderResponse = response
    And print CreateFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeHeaderCollection+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateFeeCodeHeaderResponse.body.id
    And match CreateFeeCodeHeaderResponse.body.feeCodeId == CreateFeeCodeHeaderPayload.body.feeCodeId
    And match CreateFeeCodeHeaderResponse.body.feeCodeName == CreateFeeCodeHeaderPayload.body.feeCodeName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @RetrieveAllFeeCodes @reter
  Scenario Outline: Get all the fee codes
    Given url readBaseUrl
    And path '/api/GetFeeCodes'
    And def entityIDData = dataGenerator.entityID()
    And set getFeeCodeFeeGroupsCommandHeader
      | path            |                                       0 |
      | schemaUri       | schemaUri+"/GetFeeCodes+-v1.001.json"    |
      | commandDateTime | dataGenerator.generateCurrentDateTime() |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | tenantId        | <tenantid>                              |
      | id              | dataGenerator.Id()                      |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | dataGenerator.commandUserId()           |
      | tags            | []                                      |
      | commandType     | "GetFeeCodes"                           |
      | getType         | "Array"                                 |
      | ttl             |                                       0 |
    And set getFeeCodeFeeGroupsCommandBodyRequest
      | path     |                             0 |
      | isActive | faker.getRandomBooleanValue() |
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

  @CreateFeeCodeHeaderWIthMandatoryFields 
  Scenario Outline: Create a Fee Code Header with mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeHeader'
    #Get the FeeReportingGrp
    And def result = call read('classpath:com/api/rm/documentAdmin/FeeReportingGroup/feeReportingGroup.feature@CreateFeeReportingGroupAndGetTheDetail')
    And def getFeeReportingGrpResponse = result.response
    And print getFeeReportingGrpResponse
    #Get the county  Department
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def addCountyDepartmentResponse = result.response
    And print addCountyDepartmentResponse
    #Get County Area
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def addCountyAreaResponse = result.response
    And print addCountyAreaResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeHeaderCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeHeader-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | feeCodeParam[0]                              |
      | entityName      | feeCodeParam[1]                              |
      | ttl             |                                            0 |
    And set createFeeCodeHeaderCommandBody
      | path                          |                                                  0 |
      | id                            | entityIdData                                       |
      | feeCode                       | faker.getUserId()                                  |
      | feeCodeName                   | faker.getRandomNumber()                            |
      | feeType                       | faker.getFeeType()                                 |
      | description                   | faker.getRandomShortDescription()                  |
      | feeReportingGroup.id          | getFeeReportingGrpResponse.body.id                 |
      | feeReportingGroup.code        | getFeeReportingGrpResponse.body.reportingGroupCode |
      | feeReportingGroup.description | getFeeReportingGrpResponse.body.shortDescription   |
      | feeReportingGroup.isActive    | getFeeReportingGrpResponse.body.isActive           |
      | department.id                 | addCountyDepartmentResponse.results[0].id          |
      | department.name               | addCountyDepartmentResponse.results[0].name        |
      | department.code               | addCountyDepartmentResponse.results[0].code        |
      | area.id                       | addCountyAreaResponse.results[0].id                |
      | area.name                     | addCountyAreaResponse.results[0].name              |
      | area.code                     | addCountyAreaResponse.results[0].code              |
      | isActive                      | faker.getRandomBoolean()                           |
    And set CreateFeeCodeHeaderPayload
      | path   | [0]                                 |
      | header | createFeeCodeHeaderCommandHeader[0] |
      | body   | createFeeCodeHeaderCommandBody[0]   |
    And print CreateFeeCodeHeaderPayload
    And request CreateFeeCodeHeaderPayload
    When method POST
    Then status 201
    And def addFeeCodeHeaderResponse = response
    And print addFeeCodeHeaderResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeHeaderCollection+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addFeeCodeHeaderResponse.body.id
    And match addFeeCodeHeaderResponse.body.feeCodeName == CreateFeeCodeHeaderPayload.body.feeCodeName
    And match addFeeCodeHeaderResponse.body.feeCode == CreateFeeCodeHeaderPayload.body.feeCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

   #Get All Fee Formulas
  @GetAllFeeFormulas  
  Scenario Outline: Get all Fee Formulla with details
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[3]
     And def entityIdData = dataGenerator.entityID()
    And set getFeeFormulasCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[3]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                 |
      | sourceId        | dataGenerator.SourceID()                |
      | id              | entityIdData                            |
      | tenantId        | <tenantid>                              |
      | correlationId   | dataGenerator.correlationId()           |
      | commandUserId   | commandUserId                           |
      | tags            | []                                      |
      | commandType     | feeFormulaParams[3]                              |
      | getType         | "Array"                                          |
      | ttl             |                                                0 |
    And set getFeeFormulasCommanBodyRequest
      | path     |                                      0 |
      | isActive | true |
    And set getFeeFormulasCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeFormulasPayload
      | path                | [0]                                |
      | header              | getFeeFormulasCommandHeader[0]     |
      | body.request        | getFeeFormulasCommanBodyRequest[0] |
      | body.paginationSort | getFeeFormulasCommandPagination[0] |
    And print getFeeFormulasPayload
    And request getFeeFormulasPayload
    When method POST
    Then status 200
    And sleep(10000)
    And def getFeeFormulasResponse = response
    And print getFeeFormulasResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @GetAllSerialNumberAssigned
  Scenario Outline: Get all the Serial Number Assigned with Active flag
    Given url readBaseUrl
    And path '/api/GetDocumentTypePrimaryNumberingSchemes'
    And def entityIDData = dataGenerator.entityID()
    And set getNumberingSchemesCommandHeader
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
    And set getNumberingSchemeCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getNumberingSchemesCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   100 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getNumberingSchemesPayload
      | path                | [0]                                     |
      | header              | getNumberingSchemesCommandHeader[0]     |
      | body.request        | getNumberingSchemeCommandBodyRequest[0] |
      | body.paginationSort | getNumberingSchemesCommandPagination[0] |
    And print getNumberingSchemesPayload
    And request getNumberingSchemesPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getNumberingSchemesResponse = response
    And print getNumberingSchemesResponse
    And match each getNumberingSchemesResponse.results[*].isActive == getNumberingSchemesPayload.body.request.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @RetrieveAllFeeCodesFeeGrps
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
      | path     |                             0 |
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
