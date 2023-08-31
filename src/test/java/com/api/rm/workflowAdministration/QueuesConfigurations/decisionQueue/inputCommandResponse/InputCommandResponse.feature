Feature: Get Input Command/Response

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DecisionPointQueueInputCommandsCollectionNameRead = 'DecisionPointQueueInputCommandsDetailViewModel_'
    And def DecisionPointQueueInputCommandsCollectionName = 'CreateDecisionPointQueueInputResponse_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['GetDecisionPointQueueInputCommands','GetDecisionPointQueueInputResponses','DecisionPointValidation','CreateDecisionPointQueueInputCommand','CreateDecisionPointQueueInputResponse']

  @GetDecisionPointQueueInputCommands
  Scenario Outline: Get the decision point queue input command
    Given url readBaseWorkFlowUrl
    And path '/api/'+commandType[0]
    And set getDecisionPointQueueInputCommandsCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getDecisionPointQueueInputCommandsCommandBody
      | path     |    0 |
      | isActive | true |
    And set getDecisionPointQueueInputCommandsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionPointQueueInputCommandsPayload
      | path                | [0]                                                    |
      | header              | getDecisionPointQueueInputCommandsCommandHeader[0]     |
      | body.request        | getDecisionPointQueueInputCommandsCommandBody[0]       |
      | body.paginationSort | getDecisionPointQueueInputCommandsCommandPagination[0] |
    And print getDecisionPointQueueInputCommandsPayload
    And request getDecisionPointQueueInputCommandsPayload
    When method POST
    Then status 200
    And def getDecisionPointQueueInputCommandsResponse = response
    And print getDecisionPointQueueInputCommandsResponse
    And match each getDecisionPointQueueInputCommandsResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDecisionPointQueueInputResponse
  Scenario Outline: Get the decision point queue input response
    Given url readBaseWorkFlowUrl
    And path '/api/'+commandType[1]
    And set getDecisionPointQueueInputResponseCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | commandUserId   | commandUserId                               |
      | tags            | []                                          |
      | commandType     | commandType[1]                              |
      | getType         | "Array"                                     |
      | ttl             |                                           0 |
    And set getDecisionPointQueueInputResponseCommandBody
      | path     |    0 |
      | isActive | true |
    And set getDecisionPointQueueInputResponseCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getDecisionPointQueueInputResponsePayload
      | path                | [0]                                                    |
      | header              | getDecisionPointQueueInputResponseCommandHeader[0]     |
      | body.request        | getDecisionPointQueueInputResponseCommandBody[0]       |
      | body.paginationSort | getDecisionPointQueueInputResponseCommandPagination[0] |
    And print getDecisionPointQueueInputResponsePayload
    And request getDecisionPointQueueInputResponsePayload
    When method POST
    Then status 200
    And def getDecisionPointQueueInputResponse = response
    And print getDecisionPointQueueInputResponse
    And match each getDecisionPointQueueInputResponse.results[*].isActive == true

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateInputCommandResponse
  Scenario Outline: Create a Input Command Response
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[4]
    And def entityIdData = dataGenerator.entityID()
    And set createInputCommandResponseCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | commandUserId                               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | "DecisionPointQueueInputResponse"           |
      | ttl             |                                           0 |
    And set createInputCommandResponseCommandBody
      | path          |                                                                                              0 |
      | id            | entityIdData                                                                                   |
      | code          | faker.getUserId()                                                                              |
      | name          | faker.getUserId()                                                                              |
      | description   | faker.getFirstName()                                                                           |
      | schemaUrl     | "https://schemavault-rm.azurewebsites.net/schemas/AbbreviationNameDetailViewModel-v1.001.json" |
      | isActive      | true                                                                                           |
      | samplePayload | <samplePayload>                                                                                |
    And set createInputCommandResponsePayload
      | path   | [0]                                        |
      | header | createInputCommandResponseCommandHeader[0] |
      | body   | createInputCommandResponseCommandBody[0]   |
    And print createInputCommandResponsePayload
    And request createInputCommandResponsePayload
    When method POST
    Then status 201
    And def createInputCommandResponse = response
    And print createInputCommandResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameWorkFlow,DecisionPointQueueInputCommandsCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createInputCommandResponse.body.id

    Examples: 
      | tenantid    | samplePayload                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | tenantID[0] | "{\\"header\\":{\\"schemaUri\\":\\"http://schemas.avenu.com/schemas/CreateFeeCodeFeeInfo-v1.001.json\\",\\"version\\":\\"1.001\\",\\"sourceId\\":\\"8923ca63-2512-4dce-86f3-ec43f1e305c3\\",\\"id\\":\\"97085f5c-85f0-45b9-a521-9011e64d05a5\\",\\"correlationId\\":\\"2a10d2b6-7820-474d-b719-6dfd1da1518f\\",\\"tenantId\\":\\"b5fc16ba-564f-48a5-8164-abe9ade27474\\",\\"ttl\\":0,\\"commandType\\":\\"CreateFeeCodeFeeInfo\\",\\"commandDateTime\\":\\"2023-01-19T09:41:01.591Z\\",\\"tags\\":[],\\"entityVersion\\":1,\\"entityId\\":\\"a0f4f8a5-6e7c-4a31-bf2e-337c1b191a5c\\",\\"commandUserId\\":\\"a2ac19f0-c5da-4f55-83bd-1b2ac1db4a49\\",\\"entityName\\":\\"FeeCodeFeeInfo\\"},\\"body\\":{\\"id\\":\\"b0f4f8a5-6e7c-4a31-bf2e-337c1b191a5c\\",\\"feeCodeId\\":\\"a0f4f8a5-6e7c-4a31-bf2e-337c1b191a5c\\",\\"feeCode\\":\\"TestFeeCodeId\\",\\"feeCodeName\\":\\"TestFeeCodeName\\",\\"effectiveDate\\":\\"2023-05-10T09:41:01.591Z\\",\\"formulaId\\":{\\"id\\":\\"a0f4f8a5-6e7c-4a31-bf2e-337c1b191a5c\\",\\"code\\":\\"Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-number)*FeeAdditionalAmount),MaximunNumber)\\",\\"description\\":\\"ABItems\\",\\"isActive\\":true},\\"formulaDescription\\":\\"TestFormulaDescription\\",\\"feeBaseAmount\\":5,\\"taxInfo\\":[{\\"tierNumber\\":1,\\"fromRange\\":2,\\"thruRange\\":3,\\"taxBaseAmount\\":4,\\"taxRate\\":5},{\\"tierNumber\\":11,\\"fromRange\\":12,\\"thruRange\\":13,\\"taxBaseAmount\\":14,\\"taxRate\\":15}]}}" |

  @validateTheDecisionPointExpression
  Scenario Outline: Validate the expression for decision point
    Given url commandBaseWorkFlowUrl
    And path '/api/'+commandType[2]
    #Calling the input response
    And def inputResponseResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/decisionQueue/inputCommandResponse/inputCommandResponse.feature@GetDecisionPointQueueInputResponse')
    And def inputResponseResultResponse = inputResponseResult.response
    And print inputResponseResultResponse
    And set validateDecisionPointExpressionCommandPayload
      | path       | [0]          |
      | payload    | <payload>    |
      | expression | <expression> |
    And print validateDecisionPointExpressionCommandPayload
    And request validateDecisionPointExpressionCommandPayload
    When method POST
    Then status 200
    And def validateDecisionPointExpressionCommandResponse = response
    And print validateDecisionPointExpressionCommandResponse
    And match validateDecisionPointExpressionCommandResponse.isValid == true

    Examples: 
      | payload                                              | expression                                              |
       | inputResponseResultResponse.results[0].samplePayload | "@.body.formulaId.code == 'Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-number)*FeeAdditionalAmount),MaximunNumber)'" |
      | inputResponseResultResponse.results[2].samplePayload | "@.body.formulaId.code == 'ABItems'" |
      | inputResponseResultResponse.results[3].samplePayload | "@.abbreviationType == 'Name'" |
      | inputResponseResultResponse.results[2].samplePayload | "@.body.effectiveDate >= '2023-05-10 09:41:01.591'" |
      | inputResponseResultResponse.results[2].samplePayload | "@.body.effectiveDate > '2023-05-10 09:41:01.590'" |
      | inputResponseResultResponse.results[2].samplePayload | "@.body.effectiveDate < '2023-05-10 09:41:01.592'" |
      | inputResponseResultResponse.results[2].samplePayload | "@.body.effectiveDate == '2023-05-10 09:41:01.591'" |
      | inputResponseResultResponse.results[1].samplePayload | "@.body.effectiveDate == '2023-05-10'" |
      | inputResponseResultResponse.results[1].samplePayload | "@.header.commandDateTime == '2023-01-19 09:41'" |
      | inputResponseResultResponse.results[0].samplePayload | "$.header.commandDateTime <= '2023-01-19 09:41:01.590'" |
