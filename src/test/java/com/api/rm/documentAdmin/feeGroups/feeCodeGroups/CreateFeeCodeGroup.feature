@FeeCodeGroupFeature
Feature: Create a fee code group

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeCodeGroupCollectionName = 'CreateFeeGroupDetails_'
    And def createFeeCodeGroupCollectionNameRead = 'FeeGroupDetailsViewModel_'
    And def createFeeGroupCollectionName = 'CreateFeeGroup_'
    And def createFeeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateFeeGroupDetails','FeeGroupDetails','CreateFeeGroup','GetFeeGroupDetail','GetFeeGroupDetails']
    And def entityName = ['FeeGroupDetails','FeeCodeGroup','FeeGroup']
    And def restricted = [true,false]
    And def inherited = ['Y','N']

  @CreateFeeCodeGroupWithRestricted
  Scenario Outline: Create fee code group having restricted fee group
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def result = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def feeGroupId = createFeeGroupResponse.body.id
    #get the fee code
    And def result1 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@GetFeeGroup'){'feeGroupId':'#(feeGroupId)'}
    And def getFeeGroupResponse = result1.response
    And print getFeeGroupResponse
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    And sleep(10000)
    And def entityIDData = dataGenerator.entityID()
    And set createFeeCodeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    # pass the fee group response value
    And set createFeeCodeGroupCommandBody
      | path         |                                0 |
      | id           | entityIDData                     |
      | feeGroupId   | getFeeGroupResponse.id           |
      | feeGroupCode | getFeeGroupResponse.feeGroupCode |
      | description  | getFeeGroupResponse.description  |
      | isActive     | getFeeGroupResponse.isActive     |
    # pass the fee code API response particular list index value
    And set createfeeCodeCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set createFeeCodeGroupCommandPayload
      | path         | [0]                                |
      | header       | createFeeCodeGroupCommandHeader[0] |
      | body         | createFeeCodeGroupCommandBody[0]   |
      | body.feeCode | createfeeCodeCommandBody           |
    And print createFeeCodeGroupCommandPayload
    And request createFeeCodeGroupCommandPayload
    When method POST
    Then status 201
    And def createFeeCodeGroupResponse = response
    And print createFeeCodeGroupResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeCodeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createFeeCodeGroupResponse.body.id
    And match createFeeCodeGroupResponse.body.feeGroupCode == createFeeCodeGroupCommandPayload.body.feeGroupCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeGroupWithMandatoryWithNoRestriction
  Scenario Outline: Create fee code group having restricted fee group
    Given url commandBaseUrl
    And def result = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithMandateDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def feeGroupId = createFeeGroupResponse.body.id
    #get the fee code
    And def result1 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@GetFeeGroup'){'feeGroupId':'#(feeGroupId)'}
    And def getFeeGroupResponse = result1.response
    And print getFeeGroupResponse
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    #call the API which gives the fee codes independent of department,area and fee groups
    And sleep(10000)
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set createFeeCodeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    # pass the fee group response value
    And set createFeeCodeGroupCommandBody
      | path         |                                0 |
      | id           | entityIDData                     |
      | feeGroupId   | getFeeGroupResponse.id           |
      | feeGroupCode | getFeeGroupResponse.feeGroupCode |
      | description  | getFeeGroupResponse.description  |
    # pass the fee code API response particular list index value
    And set createfeeCodeCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set createFeeCodeGroupCommandPayload
      | path         | [0]                                |
      | header       | createFeeCodeGroupCommandHeader[0] |
      | body         | createFeeCodeGroupCommandBody[0]   |
      | body.feeCode | createfeeCodeCommandBody           |
    And print createFeeCodeGroupCommandPayload
    And request createFeeCodeGroupCommandPayload
    When method POST
    Then status 201
    And def createFeeCodeGroupResponse = response
    And print createFeeCodeGroupResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeCodeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createFeeCodeGroupResponse.body.id
    And match createFeeCodeGroupResponse.body.feeGroupId == createFeeCodeGroupCommandPayload.body.feeGroupId
    #Get Fee Code Group
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createFeeCodeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createFeeCodeGroupResponse.header.id            |
      | correlationId   | createFeeCodeGroupResponse.header.correlationId |
      | commandUserId   | createFeeCodeGroupResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[3]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | createFeeCodeGroupResponse.body.id |
    And set getFeeCodeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getFeeCodeGroupResponse = response
    And print getFeeCodeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getFeeCodeGroupResponse.id)
    And print mongoResult
    And match mongoResult == getFeeCodeGroupResponse.id
    And match createFeeCodeGroupResponse.body.feeGroupId == getFeeCodeGroupResponse.feeGroupId

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeGroupWithInheritedFeeGroup
  Scenario Outline: Create fee code group with Inherited Fee Group
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def result = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def feeGroupId = createFeeGroupResponse.body.id
    #get the fee code
    And def result1 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@GetFeeGroup'){'feeGroupId':'#(feeGroupId)'}
    And def getFeeGroupResponse = result1.response
    And print getFeeGroupResponse
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    And sleep(10000)
    And def entityIDData = dataGenerator.entityID()
    And set createFeeCodeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    # pass the fee group response value
    And set createFeeCodeGroupCommandBody
      | path         |                                0 |
      | id           | entityIDData                     |
      | feeGroupId   | getFeeGroupResponse.id           |
      | feeGroupCode | getFeeGroupResponse.feeGroupCode |
      | description  | getFeeGroupResponse.description  |
    # pass the fee code API response particular list index value
    And set createfeeCodeCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set createFeeCodeGroupCommandPayload
      | path                      | [0]                                              |
      | header                    | createFeeCodeGroupCommandHeader[0]               |
      | body                      | createFeeCodeGroupCommandBody[0]                 |
      | body.feeCode              | createfeeCodeCommandBody                         |
      | body.inheritFeeGroup.id   | createFeeGroupResponse.body.inheritFeeGroup.id   |
      | body.inheritFeeGroup.code | createFeeGroupResponse.body.inheritFeeGroup.code |
      | body.inheritFeeGroup.name | createFeeGroupResponse.body.inheritFeeGroup.name |
    And print createFeeCodeGroupCommandPayload
    And request createFeeCodeGroupCommandPayload
    When method POST
    Then status 201
    And def createFeeCodeGroupResponse = response
    And print createFeeCodeGroupResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeCodeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createFeeCodeGroupResponse.body.id
    And match createFeeCodeGroupResponse.body.feeGroupCode == createFeeCodeGroupCommandPayload.body.feeGroupCode
    And match createFeeCodeGroupResponse.body.inheritFeeGroup.code == createFeeCodeGroupCommandPayload.body.inheritFeeGroup.code

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeGroupWithRunTime
  Scenario Outline: Create fee code group with Run Time
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling all fee codes
    And def allFeeCodesResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodes')
    And def allFeeCodesResultResponse = allFeeCodesResult.response
    And print allFeeCodesResultResponse
    And sleep(10000)
    And def entityIDData = dataGenerator.entityID()
    And set createFeeCodeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    # pass the fee group response value
    And set createFeeCodeGroupCommandBody
      | path         |            0 |
      | id           | entityIDData |
      | feeGroupId   | feeGroupId   |
      | feeGroupCode | feeGroupCode |
      | description  | description  |
    # pass the fee code API response particular list index value
    And set createfeeCodeCommandBody
      | path           |                                                   0 |
      | id             | allFeeCodesResultResponse.results[0].id             |
      | feeCodeId      | allFeeCodesResultResponse.results[0].feeCodeId      |
      | feeCodeName    | allFeeCodesResultResponse.results[0].feeCodeName    |
      | feeDescription | allFeeCodesResultResponse.results[0].feeDescription |
      | feeType        | allFeeCodesResultResponse.results[0].feeType        |
      | isActive       | allFeeCodesResultResponse.results[0].isActive       |
      | inherited      | allFeeCodesResultResponse.results[0].inherited      |
      | optional       | allFeeCodesResultResponse.results[0].optional       |
      | allowRemoval   | allFeeCodesResultResponse.results[0].allowRemoval   |
    And set createFeeCodeGroupCommandPayload
      | path                      | [0]                                              |
      | header                    | createFeeCodeGroupCommandHeader[0]               |
      | body                      | createFeeCodeGroupCommandBody[0]                 |
      | body.feeCode              | createfeeCodeCommandBody                         |
      | body.inheritFeeGroup.id   | createFeeGroupResponse.body.inheritFeeGroup.id   |
      | body.inheritFeeGroup.code | createFeeGroupResponse.body.inheritFeeGroup.code |
      | body.inheritFeeGroup.name | createFeeGroupResponse.body.inheritFeeGroup.name |
    And print createFeeCodeGroupCommandPayload
    And request createFeeCodeGroupCommandPayload
    When method POST
    Then status 201

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeCodeGroupWithInheritedFeeGroupE2EMain
  Scenario Outline: Create fee code group with Inherited and checking Inherited "Yes" flag
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #Create a inherited fee Group
    And def result = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithAllDetails')
    And def createFeeGroupResponse = result.response
    And print createFeeGroupResponse
    And def feeGroupId = createFeeGroupResponse.body.id
    #get the fee code
    And def result1 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@GetFeeGroup'){'feeGroupId':'#(feeGroupId)'}
    And def getFeeGroupResponse = result1.response
    And print getFeeGroupResponse
    And def feeGroupId = getFeeGroupResponse.id
    And def feeGroupCode = getFeeGroupResponse.feeGroupCode
    And def description = getFeeGroupResponse.description
    And def departmentId = getFeeGroupResponse.departmentId.id
    And def departmentCode = getFeeGroupResponse.departmentId.code
    And def departmentName = getFeeGroupResponse.departmentId.name
    And def areaId = getFeeGroupResponse.areaId.id
    And def areaCode = getFeeGroupResponse.areaId.code
    And def areaName = getFeeGroupResponse.areaId.name
    #Create a fee code group with above fee group
    And def feeCodeGroupResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/CreateFeeCodeGroup.feature@CreateFeeCodeGroupWithRunTime'){feeGroupId : '#(feeGroupId)'}{feeGroupCode : '#(feeGroupCode)'} {description : '#(description)'} {departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}{areaId : '#(areaId)'}{areaCode : '#(areaCode)'}{areaName : '#(areaName)'}
    And def  feeCodeGroupResultResponse = feeCodeGroupResult.response
    And print feeCodeGroupResultResponse
    #Create another inherited fee Group and use same department , area and fee group
    And def result2 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateFeeGroupWithAreaAndDepartmentAndFeeGroupRunTime'){feeGroupId : '#(feeGroupId)'}{feeGroupCode : '#(feeGroupCode)'} {description : '#(description)'} {departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}{areaId : '#(areaId)'}{areaCode : '#(areaCode)'}{areaName : '#(areaName)'}
    And def createFeeGroupResponse1 = result2.response
    And print createFeeGroupResponse1
    And def newFeeGroupId = createFeeGroupResponse.body.id
    #get the new fee code
    And def result3 = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@GetFeeGroup'){'feeGroupId':'#(newFeeGroupId)'}
    And def getFeeGroupResponse1 = result3.response
    And print getFeeGroupResponse1
    And def newfeeGroup = getFeeGroupResponse1.inheritFeeGroup.id
    And def newfeeGroupCode = getFeeGroupResponse1.feeGroupCode
    And def newdescription = getFeeGroupResponse1.description
    #Getting fee codes for the inherited fee groups using below api
    And def inheritedFeeCodeResult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeCodeGroups/FeeGroupCodeDropdown.feature@RetrieveAllFeeCodesBasedOnFeeGroup'){feeGroupId : '#(newfeeGroup)'}
    And def inheritedFeeCodeResponse = inheritedFeeCodeResult.response
    And print inheritedFeeCodeResponse
    #Create another fee code group with inherited fee group and see fee code inherited or not
    And def entityIDData = dataGenerator.entityID()
    And set createFeeCodeGroupCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[0]                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | entityVersion   |                                           1 |
      | entityId        | entityIDData                                |
      | commandUserId   | commandUserId                               |
      | entityName      | entityName[0]                               |
    # pass the fee group response value
    And set createFeeCodeGroupCommandBody
      | path         |               0 |
      | id           | entityIDData    |
      | feeGroupId   | newfeeGroup     |
      | feeGroupCode | newfeeGroupCode |
      | description  | newdescription  |
    # pass the fee code API response particular list index value
    And set createfeeCodeCommandBody
      | path           |                                                             0 |
      | id             | inheritedFeeCodeResponse.results[0].feeCode[0].id             |
      | feeCodeId      | inheritedFeeCodeResponse.results[0].feeCode[0].feeCodeId      |
      | feeCodeName    | inheritedFeeCodeResponse.results[0].feeCode[0].feeCodeName    |
      | feeDescription | inheritedFeeCodeResponse.results[0].feeCode[0].feeDescription |
      | feeType        | inheritedFeeCodeResponse.results[0].feeCode[0].feeType        |
      | isActive       | inheritedFeeCodeResponse.results[0].feeCode[0].isActive       |
      | inherited      | inheritedFeeCodeResponse.results[0].feeCode[0].inherited      |
      | optional       | inheritedFeeCodeResponse.results[0].feeCode[0].optional       |
      | allowRemoval   | inheritedFeeCodeResponse.results[0].feeCode[0].allowRemoval   |
    And set createFeeCodeGroupCommandPayload
      | path                      | [0]                                              |
      | header                    | createFeeCodeGroupCommandHeader[0]               |
      | body                      | createFeeCodeGroupCommandBody[0]                 |
      | body.feeCode              | createfeeCodeCommandBody                         |
      | body.inheritFeeGroup.id   | createFeeGroupResponse.body.inheritFeeGroup.id   |
      | body.inheritFeeGroup.code | createFeeGroupResponse.body.inheritFeeGroup.code |
      | body.inheritFeeGroup.name | createFeeGroupResponse.body.inheritFeeGroup.name |
    And print createFeeCodeGroupCommandPayload
    And request createFeeCodeGroupCommandPayload
    When method POST
    Then status 201
    And def createFeeCodeGroupCommandResponse = response
    And print createFeeCodeGroupCommandResponse
    And match createFeeCodeGroupCommandResponse.body.feeCode[0].inherited == true
    #Get the fee code details
    Given url readBaseUrl
    And path '/api/'+commandType[4]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | feeCodeGroupResultResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | feeCodeGroupResultResponse.header.id            |
      | correlationId   | feeCodeGroupResultResponse.header.correlationId |
      | commandUserId   | feeCodeGroupResultResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[4]                                  |
      | getType         | "Array"                                         |
      | ttl             |                                               0 |
    And set getCommandBody
      | path       |           0 |
      | feeGroupId | newfeeGroup |
    And set getFeeCodeGroupsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getFeeCodeGroupPayload
      | path                | [0]                                  |
      | header              | getCommandHeader[0]                  |
      | body.request        | getCommandBody[0]                    |
      | body.paginationSort | getFeeCodeGroupsCommandPagination[0] |
    And print getFeeCodeGroupPayload
    And request getFeeCodeGroupPayload
    When method POST
    Then status 200
    And def getFeeCodeGroupResponse = response
    And print getFeeCodeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeCodeGroupCollectionNameRead+<tenantid>,getFeeCodeGroupResponse.results[0].id)
    And print mongoResult
    And match mongoResult == getFeeCodeGroupResponse.id
    And match getFeeCodeGroupResponse.results[0].feeCode[0].inherited == true

    Examples: 
      | tenantid    |
      | tenantID[0] |
