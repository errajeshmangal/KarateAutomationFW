Feature: feeCodeDistribution - Add

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def  DistributionCollectionAddress = 'CreateFeeCodeFeeDistribution_'
    And def  DistributionCollectionAddressRead = 'FeeCodeFeeDistributionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm//helpers/Wait.feature@wait')
    And def distributionParam = ["CreateFeeCodeFeeDistribution","FeeCodeFeeDistribution"]

  @CreateFeeDistribution
  Scenario Outline: Create a FeeCode FeeDistribution with all the fields and Validate
    Given url commandBaseUrl
    And path '/api/CreateFeeCodeFeeDistribution'
    #Create a Account Code
    And def result = call read('classpath:com/api/rm/documentAdmin/accountCodes/CreateAccountCode.feature@CreateAccountCodes')
    And def createAccountCodeResponse = result.response
    And print createAccountCodeResponse
    #Create FeeCodeFeeInfo and Get the details
    And def result = call read('classpath:com/api/rm/documentAdmin/feeCodes/feeInfo/CreateFeeInfo.feature@CreateFeeCodeInfoAllFields')
    And def addFeeCodeFeeInfoResponse = result.response
    And print addFeeCodeFeeInfoResponse
    And def entityIdData = dataGenerator.entityID()
    And set createFeeDistributionCommandHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateFeeCodeFeeDistribution-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | tenantId        | <tenantid>                                            |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | entityId        | entityIdData                                          |
      | commandUserId   | commandUserId                                         |
      | entityVersion   |                                                     1 |
      | tags            | []                                                    |
      | commandType     | distributionParam[0]                                  |
      | entityName      | distributionParam[1]                                  |
      | ttl             |                                                     0 |
    And set createFeeDistributionCommandBody
      | path                                       |                                                 0 |
      | id                                         | entityIdData                                      |
      | feeCodeId                                  | addFeeCodeFeeInfoResponse.body.feeCodeId          |
      | feeCode                                    | addFeeCodeFeeInfoResponse.body.feeCode            |
      | feeCodeName                                | addFeeCodeFeeInfoResponse.body.feeCodeName        |
      | effectiveDate                              | addFeeCodeFeeInfoResponse.body.effectiveDate      |
      | descriptionAmount                          | addFeeCodeFeeInfoResponse.body.feeBaseAmount      |
      | accountDistribution[0].accountNumber.id    | createAccountCodeResponse.body.fundCode.id        |
      | accountDistribution[0].accountNumber.code  | createAccountCodeResponse.body.fundCode.code      |
      | accountDistribution[0].accountNumber.name  | createAccountCodeResponse.body.fundCode.name      |
      | accountDistribution[0].distributionAmount  | dataGenerator.generateSingleOrDoubleDigitNumber() |
      | accountDistribution[0].distributionPercent | dataGenerator.generateSingleOrDoubleDigitNumber() |
    And set createFeeDistributionPayload
      | path   | [0]                                   |
      | header | createFeeDistributionCommandHeader[0] |
      | body   | createFeeDistributionCommandBody[0]   |
    And print createFeeDistributionPayload
    And request createFeeDistributionPayload
    When method POST
    Then status 201
    And def createFeeDistributionResponse = response
    And print createFeeDistributionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DistributionCollectionAddress+<tenantid>,createFeeDistributionResponse.body.id)
    And print mongoResult
    And match mongoResult == createFeeDistributionResponse.body.id
    And match createFeeDistributionResponse.body.feeCodeId == createFeeDistributionPayload.body.feeCodeId
    And match createFeeDistributionResponse.body.feeCodeName == createFeeDistributionPayload.body.feeCodeName
	And match createFeeDistributionResponse.body.effectiveDate == createFeeDistributionPayload.body.effectiveDate
    Examples: 
      | tenantid    |
      | tenantID[0] |
