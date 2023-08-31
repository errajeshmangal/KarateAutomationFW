@CreateFeeParametersE2E
Feature: Fee parameters, Create, Update , Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatFeeParameterCollectionName = 'CreateFeeParameter_'
    And def createFeeParameterCollectionNameRead = 'FeeParameterDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def feeParams = ["CreateFeeParameter" , "FeeParameter" ,"GetFeeParameters"]

  @CreateFeeParameter
  Scenario Outline: Create a Fee Parameter with all fields
    Given url commandBaseUrl
    And path '/api/CreateFeeParameter'
    And def entityIdData = dataGenerator.entityID()
    And set createFeeParameterCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/"+feeParams[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | entityId        | entityIdData                              |
      | commandUserId   | commandUserId                             |
      | entityVersion   |                                         1 |
      | tags            | []                                        |
      | commandType     | feeParams[0]                              |
      | entityName      | feeParams[1]                              |
      | ttl             |                                         0 |
    And set createFeeParameterCommandBody
      | path            |                 0 |
      | id              | entityIdData      |
      | parameterName   | <ParameterName>   |
      | description     | <Description>     |
      | parameterSource | <ParameterSource> |
      | isActive        | true              |
    And set createFeeParameterPayload
      | path   | [0]                                |
      | header | createFeeParameterCommandHeader[0] |
      | body   | createFeeParameterCommandBody[0]   |
    And print createFeeParameterPayload
    And request createFeeParameterPayload
    When method POST
    Then status 201
    And print response
    And def createFeeParameterResponse = response
    And print createFeeParameterResponse

    And def mongoResult = mongoData.MongoDBReader(dbname,creatFeeParameterCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeeParameterResponse.body.id
    And match createFeeParameterResponse.body.parameterName == createFeeParameterPayload.body.parameterName
    Examples: 
      | tenantid    | ParameterName                | Description                                       | ParameterSource |
      | tenantID[0] | "AmountEntered"              | "Flat Dollar Amount"                              | "PS002"         |
      | tenantID[0] | "DeedAmount"                 | "Required for official record in Solano county."  | "PS002"         |
      | tenantID[0] | "FeeAdditionalAmount"        | "Additional Amount for a fee"                     | "PS001"         |
      | tenantID[0] | "FeeBaseAmount"              | "Base Amount for a Fee"                           | "PS001"         |
      | tenantID[0] | "NumberOfFilingCodesEntered" | "Number of Filing Codes entered by the clerk"     | "PS002"         |
      | tenantID[0] | "NumberOfPagesEntered"       | "Number of pages entered"                         | "PS002"         |
      | tenantID[0] | "QuantityEntered"            | "Quantity entered by the Clerk"                   | "PS002"         |
      | tenantID[0] | "TaxRangeFrom"               | "Tax Range From"                                  | "PS004"         |
      | tenantID[0] | "TaxRangeThru"               | "Tax Range Thru"                                  | "PS004"         |
      | tenantID[0] | "TaxBaseAmount"              | "Tax Base Amount"                                 | "PS004"         |
      | tenantID[0] | "TaxRate"                    | "Tax Rate"                                        | "PS004"         |
      | tenantID[0] | "APNRowCount"                | "Entered by Cashier as a number"                  | "PS001"         |
      | tenantID[0] | "APNRowEntered"              | "Entered by Cashier as a number"                  | "PS002"         |
      | tenantID[0] | "number"                     | "number to be entered"                            | "PS004"         |
      | tenantID[0] | "MaximumNumber"              | "Maximum number to be used in Max function"       | "PS001"         |
      | tenantID[0] | "MinimumNumber"              | "Minimum number to be used in Mini function"      | "PS002"         |

  @GetAllFeeParameters
  Scenario Outline: Get all Fee Parameters
    Given url readBaseUrl
    And path '/api/GetFeeParameters'
    And set getFeeParameterTypesCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/"+feeParams[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | commandUserId   | commandUserId                             |
      | tags            | []                                        |
      | commandType     | feeParams[2]                              |
      | getType         | "Array"                                   |
      | ttl             |                                         0 |
    And set getFeeParameterTypesCommandBodyRequest
      | path     |    0 |
      | isActive | true |
    And set getFeeParameterTypesCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeParameterTypesPayload
      | path                | [0]                                       |
      | header              | getFeeParameterTypesCommandHeader[0]      |
      | body.request        | getFeeParameterTypesCommandBodyRequest[0] |
      | body.paginationSort | getFeeParameterTypesCommandPagination[0]  |
    And print getFeeParameterTypesPayload
    And request getFeeParameterTypesPayload
    When method POST
    Then status 200
    And def getFeeParameterTypesResponse = response
    And print getFeeParameterTypesResponse
    And match each getFeeParameterTypesResponse.results[*].isActive == getFeeParameterTypesPayload.body.request.isActive
    And def getFeeParameterTypesResponseCount = karate.sizeOf(getFeeParameterTypesResponse.results)
    And print getFeeParameterTypesResponseCount
    And match getFeeParameterTypesResponseCount == getFeeParameterTypesResponse.totalRecordCount

    Examples: 
      | tenantid    |
      | tenantID[0] |
