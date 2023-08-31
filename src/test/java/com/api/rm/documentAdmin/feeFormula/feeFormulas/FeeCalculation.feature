Feature: To calculate the fee formula using fee parameters

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
    And def formulaCalculation = Java.type('com.api.rm.helpers.FeeFormulas')

  @FeeCalculation
  Scenario Outline: 1-Calculate the fee formula using fee parameters
    Given url commandBaseUrl
    And path 'api/FeeFormulaValidation'
    And header Content-Type = 'application/json'
    And header accept = '*/*'
    And def AmountEntered = formulaCalculation.parameterNumber()
    And def DeedAmount = formulaCalculation.parameterNumber()
    And def FeeAdditionalAmount = formulaCalculation.parameterNumber()
    And def FeeBaseAmount = formulaCalculation.parameterNumber()
    And def NumberOfFilingCodesEntered = formulaCalculation.parameterNumber()
    And def NumberOfPagesEntered = formulaCalculation.parameterNumber()
    And def QuantityEntered = formulaCalculation.parameterNumber()
    And def TaxRangeFrom = formulaCalculation.parameterNumber()
    And def TaxRangeThru = formulaCalculation.parameterNumber()
    And def TaxBaseAmount = formulaCalculation.parameterNumber()
    And def TaxRate = formulaCalculation.parameterNumber()
    And def TaxRangeFrom = formulaCalculation.parameterNumber()
    And def APNRowCount = formulaCalculation.parameterNumber()
    And def APNRowEntered = formulaCalculation.parameterNumber()
    And def number = formulaCalculation.number()
    And def MinimumNumber = formulaCalculation.minNumber()
    And def MaximumNumber = formulaCalculation.maxNumber()
    And def MaximumQuantity = formulaCalculation.maxNumber()
    And set commandfeeFormulaParameter
      | path                       |                          0 |
      | AmountEntered              | AmountEntered              |
      | DeedAmount                 | DeedAmount                 |
      | FeeAdditionalAmount        | FeeAdditionalAmount        |
      | FeeBaseAmount              | FeeBaseAmount              |
      | NumberOfFilingCodesEntered | NumberOfFilingCodesEntered |
      | NumberOfPagesEntered       | NumberOfPagesEntered       |
      | QuantityEntered            | QuantityEntered            |
      | TaxRangeFrom               | TaxRangeFrom               |
      | TaxRangeThru               | TaxRangeThru               |
      | TaxBaseAmount              | TaxBaseAmount              |
      | TaxRate                    | TaxRate                    |
      | APNRowCount                | APNRowCount                |
      | APNRowEntered              | APNRowEntered              |
      | number                     | number                     |
      | MinimumNumber              | MinimumNumber              |
      | MaximumNumber              | MaximumNumber              |
      | MaximumQuantity            | MaximumQuantity            |
    And set CommandPayload
      | path             | [0]                           |
      | feeFormula       | <formulaName>                 |
      | formulaParameter | commandfeeFormulaParameter[0] |
    And print CommandPayload
    And def value = <FormulaValue>
    And print value
    And request CommandPayload
    When method POST
    Then status 200
    And print response
    And def createFormulaResponse = response
    And print createFormulaResponse
    And match createFormulaResponse.output == value

    Examples: 
      | formulaName                                                                                                                    | FormulaValue                                                                                                      |
      | "Min(MinimumNumber,QuantityEntered*FeeBaseAmount)+Max(MaximumNumber,QuantityEntered-number*FeeAdditionalAmount)"               | formulaCalculation.formula5(MinimumNumber,QuantityEntered,FeeBaseAmount,MaximumNumber,number,FeeAdditionalAmount) |
      | "(QuantityEntered*FeeBaseAmount)/(FeeAdditionalAmount*MinimumNumber)"                                                          | formulaCalculation.formula6(QuantityEntered,FeeBaseAmount,FeeAdditionalAmount,MinimumNumber)                      |
      | "Round((RoundUp(DeedAmount/number))*RoundDown(MaximumQuantity+MaximumQuantity)/Round(Max(FeeBaseAmount,MaximumNumber)))"       | formulaCalculation.allRoundsFormula(DeedAmount,number,MaximumQuantity,FeeBaseAmount,MaximumNumber)                |
      | "Round(((RoundUp(DeedAmount/number))*(RoundDown(MaximumQuantity+MaximumQuantity)))/(Round(Max(FeeBaseAmount,MaximumNumber))))" | formulaCalculation.allRoundsFormula(DeedAmount,number,MaximumQuantity,FeeBaseAmount,MaximumNumber)                |
      | "Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-number)*FeeAdditionalAmount),MaximumNumber)"         | formulaCalculation.formula1(QuantityEntered,FeeBaseAmount,MinimumNumber,number,FeeAdditionalAmount,MaximumNumber) |
      | "Round(number) + ( number * TaxRate)"                                                                                          | formulaCalculation.formula7(number,TaxRate)                                                                       |
      | "RoundUp(DeedAmount+TaxBaseAmount)"                                                                                            | formulaCalculation.simpleRoundUp(DeedAmount,TaxBaseAmount)                                                        |
      | "NumberOfFilingCodesEntered*FeeBaseAmount"                                                                                     | formulaCalculation.simpleMultiplication(NumberOfFilingCodesEntered,FeeBaseAmount)                                 |
      | "Min(FeeBaseAmount+(NumberOfPagesEntered-number)*MinimumNumber,MaximumNumber)"                                                 | formulaCalculation.simpleMin(FeeBaseAmount,NumberOfPagesEntered,number,MinimumNumber,MaximumNumber)               |
