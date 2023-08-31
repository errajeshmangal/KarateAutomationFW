Feature: feeCodeInfo - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def feeCodeInfoCollection = 'CreateFeeCodeFeeInfo_'
    And def feeCodeInfoCollectionAddressRead = 'FeeCodeFeeInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def feeCodeInfoParam = ["CreateFeeCodeFeeInfo","FeeCodeFeeInfo","UpdatedFeeCodeFeeInfo","GetFeeCodeFeeInfos","GetFeeCodeFeeInfo"]
    And def feeFormulaParams = ["CreateFeeFormula" , "FeeFormula" ,"GetFeeFormula","GetFeeFormulas","UpdateFeeFormula"]

  @CreateFeeCodeInfoAllFields
  Scenario Outline: Create a Fee Code Info with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeInfo'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeFeeHeader')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
    #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeInfoCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeInfoParam[0]                           |
      | entityName      | feeCodeInfoParam[1]                           |
      | ttl             |                                             0 |
    And set createFeeCodeInfoCommandBody
      | path                     |                                                       0 |
      | id                       | entityIdData                                            |
      | feeCodeId                | addFeeCodeHeaderResponse.body.id                        |
      | feeCodeName              | addFeeCodeHeaderResponse.body.feeCodeName               |
      | feeCode                  | addFeeCodeHeaderResponse.body.feeCode                   |
      | effectiveDate            | dataGenerator.generateCurrentDateTime()                 |
      | formulaId.id             | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code           | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description    | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive       | getAllFeeFormulasResponse.results[0].isActive           |
      | formulaDescription       | getAllFeeFormulasResponse.results[0].feeFormula1         |
      | feeBaseAmount            | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      #| taxInfo[0].tierNumber    | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      #| taxInfo[0].fromRange     | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      #| taxInfo[0].thruRange     | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      #| taxInfo[0].taxBaseAmount | dataGenerator.generateSingleOrDoubleDigitNumber()       |
      #| taxInfo[0].taxRate       | dataGenerator.generateSingleOrDoubleDigitNumber()       |
    And set createFeeInfoPayload
      | path   | [0]                               |
      | header | createFeeCodeInfoCommandHeader[0] |
      | body   | createFeeCodeInfoCommandBody[0]   |
    And print createFeeInfoPayload
    And request createFeeInfoPayload
    When method POST
    Then status 201
    And def createFeeInfoResponse = response
    And print createFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeInfoCollection+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeeInfoResponse.body.id
    And match createFeeInfoResponse.body.feeCodeId == createFeeInfoPayload.body.feeCodeId
    And match createFeeInfoResponse.body.feeCodeName == createFeeInfoPayload.body.feeCodeName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createFeeCodeFeeInfoWithMandatoryFields
  Scenario Outline: Create a FeeCodeFeeInfo with mandatory fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeInfo'
    #Create Fee Code Header and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeHeader/CreatefeeHeader.feature@CreateFeeCodeHeaderWIthMandatoryFields')
    And def addFeeCodeHeaderResponse = result.response
    And print addFeeCodeHeaderResponse
      #GetAllFeeFormulas
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreatefeeInfo.feature@GetAllFeeFormulas')
    And def getAllFeeFormulasResponse = result.response
    And print getAllFeeFormulasResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeCodeInfoCommandHeader
      | path            |                                             0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeInfo-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()       |
      | version         | "1.001"                                       |
      | sourceId        | dataGenerator.SourceID()                      |
      | tenantId        | <tenantid>                                    |
      | id              | dataGenerator.Id()                            |
      | correlationId   | dataGenerator.correlationId()                 |
      | entityId        | entityIdData                                  |
      | commandUserId   | commandUserId                                 |
      | entityVersion   |                                             1 |
      | tags            | []                                            |
      | commandType     | feeCodeInfoParam[0]                           |
      | entityName      | feeCodeInfoParam[1]                           |
      | ttl             |                                             0 |
    And set createFeeCodeInfoCommandBody
      | path                  |                                       0 |
      | id                    | entityIdData                            |
      | feeCodeId             | addFeeCodeHeaderResponse.body.id        |
      | effectiveDate         | dataGenerator.generateCurrentDateTime() |
      | formulaId.id             | getAllFeeFormulasResponse.results[0].id                 |
      | formulaId.code           | getAllFeeFormulasResponse.results[0].feeFormulaName     |
      | formulaId.description    | getAllFeeFormulasResponse.results[0].formulaDescription |
      | formulaId.isActive       | getAllFeeFormulasResponse.results[0].isActive           |
    And set createFeeInfoPayload
      | path   | [0]                               |
      | header | createFeeCodeInfoCommandHeader[0] |
      | body   | createFeeCodeInfoCommandBody[0]   |
    And print createFeeInfoPayload
    And request createFeeInfoPayload
    When method POST
    Then status 201
    And def createFeeInfoResponse = response
    And print createFeeInfoResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,feeCodeInfoCollection+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeeInfoResponse.body.id
    And match createFeeInfoResponse.body.feeCodeId == createFeeInfoPayload.body.feeCodeId

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
