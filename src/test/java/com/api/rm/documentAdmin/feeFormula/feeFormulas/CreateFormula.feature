@CreateFeeFormulas
Feature: Fee Formulas, Create

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def creatFeeFormulaCollectionName = 'CreateFeeFormula_'
    And def createFeeFormulaCollectionNameRead = 'FeeFormulaDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def feeFormulaParams = ["CreateFeeFormula" , "FeeFormula" ,"GetFeeFormula","GetFeeFormulas"]

  @CreateFeeFormula
  Scenario Outline: Create a Fee Formula with all fields
    Given url commandBaseUrl
    And path '/api/CreateFeeFormula'
    And def entityIdData = dataGenerator.entityID()
    And set createFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[0]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
    And set createFeeFormulaCommandBody
      | path               |                                 0 |
      | id                 | entityIdData                      |
      | feeFormulaName     |  "BaseAmount"            |
      | formulaDescription |"BaseAmount"|
      | feeFormula1         | "FeeBaseAmount*FeeAdditionalAmount)"           |
    #  | isActive           | faker.getRandomBooleanValue()     |
       | isActive           | true     |
    And set createFeeFormulaPayload
      | path   | [0]                              |
      | header | createFeeFormulaCommandHeader[0] |
      | body   | createFeeFormulaCommandBody[0]   |
    And print createFeeFormulaPayload
    And request createFeeFormulaPayload
    When method POST
    Then status 201
    And print response
    And def createFeeFormulaResponse = response
    And print createFeeFormulaResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,creatFeeFormulaCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createFeeFormulaResponse.body.id
    And match createFeeFormulaResponse.body.feeFormula1 == createFeeFormulaPayload.body.feeFormula1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  #| tenantID[0] | "Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-3)*FeeAdditionalAmount),MaximunNumber)"              |
  #| tenantID[0] | "Min((QuantityEntered*FeeBaseAmount*NumberOfPagesEntered),number*QuantityEntered)"                                             |
  #| tenantID[0] | "RoundUp(DeedAmount/number)+MinimumQuantity"                                                                                   |
  #| tenantID[0] | "Round((RoundUp(DeedAmount/number))*(RoundDown(MaximumQuantity+MaximumQuantity)))/(Round(Max((FeeBaseAmount),MaximunNumber)))" |
  #| tenantID[0] | "Min(MinimumNumber,QuantityEntered*FeeBaseAmount)+Max(MaximumNumber,QuantityEntered-number*FeeAdditionalAmount)"               |
  #| tenantID[0] | "Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-3)*FeeAdditionalAmount),MaximunNumber)"              |
  # | tenantID[0]| "Round((RoundUp(DeedAmount/number))*RoundDown(MaximumQuantity+MaximumQuantity)/Round(Max(FeeBaseAmount,MaximunNumber)))"|
  
  @getFormula
  Scenario Outline: Get the fee formula using entity id
    Given url readBaseUrl
    And path '/api/'+feeFormulaParams[2]
    And set getFeeFormulaCommandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/"+feeFormulaParams[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | commandUserId   | commandUserId                                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | feeFormulaParams[2]                              |
      | entityName      | feeFormulaParams[1]                              |
      | ttl             |                                                0 |
      | getType         | "One"                                            |
    And set getFeeFormulaCommandBody
      | path |                              0 |
      | id   | formulaEntityId |
    And set getFeeFormulaPayload
      | path         | [0]                           |
      | header       | getFeeFormulaCommandHeader[0] |
      | body.request | getFeeFormulaCommandBody[0]   |
    And print getFeeFormulaPayload
    And request getFeeFormulaPayload
    When method POST
    Then status 200
    And sleep(15000)
    And print response
    And def getFeeFormulaResponse = response
    And print getFeeFormulaResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeFormulaCollectionNameRead+<tenantid>,getFeeFormulaResponse.id)
    And print mongoResult
    And match mongoResult == getFeeFormulaResponse.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
