Feature: Create a fee group

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createFeeGroupCollectionName = 'CreateFeeGroup_'
    And def createFeeGroupCollectionNameRead = 'FeeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateFeeGroup','UpdateFeeGroup','GetFeeGroup','GetFeeGroups']
    And def entityName = ['FeeGroup','FeeCodeGroup']
    And def restricted = [true,false]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateRestrictedFeeGroupWithAllDetails
  Scenario Outline: Create restricted fee group with all details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set createRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createRestrictedFeeGroupCommandBody
      | path         |                             0 |
      | id           | entityIDData                  |
      | feeGroupCode | faker. getUserId()            |
      | description  | faker.getFirstName()          |
      | restricted   | restricted[0]                 |
      | isActive     | faker.getRandomBooleanValue() |
    And set createRestrictedFeeGroupCommandPayload
      | path   | [0]                                      |
      | header | createRestrictedFeeGroupCommandHeader[0] |
      | body   | createRestrictedFeeGroupCommandBody[0]   |
    And print createRestrictedFeeGroupCommandPayload
    And request createRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def createRestrictedFeeGroupResponse = response
    And print createRestrictedFeeGroupResponse
    And sleep(5000)
    And match createRestrictedFeeGroupResponse.body.feeGroupCode == createRestrictedFeeGroupCommandPayload.body.feeGroupCode
    And match createRestrictedFeeGroupResponse.body.description == createRestrictedFeeGroupCommandPayload.body.description
    And match createRestrictedFeeGroupResponse.body.restricted == createRestrictedFeeGroupCommandPayload.body.restricted
    And match createRestrictedFeeGroupResponse.body.isActive == createRestrictedFeeGroupCommandPayload.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createRestrictedFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateNonRestrictedFeeGroupWithAllDetails
  Scenario Outline: Create non restricted fee group with all the fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling the NonRestrictedFeeGroupWithMandateFieldScenarios
    And def nonRestrictedFeeGroupResultResponse = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/CreateFeeGroup.feature@CreateNonRestrictedFeeGroupWithMandateDetails')
    And def nonRestrictedFeeGroupResponse = nonRestrictedFeeGroupResultResponse.response
    And print nonRestrictedFeeGroupResponse
    And def areaCodeId = nonRestrictedFeeGroupResponse.body.areaId.id
    And def areaCode = nonRestrictedFeeGroupResponse.body.areaId.code
    And def areaCodeName = nonRestrictedFeeGroupResponse.body.areaId.name
    And def isActiveFlag = nonRestrictedFeeGroupResponse.body.isActive
    And sleep(30000)
    #Calling inheritedFeeGroupAPi
    And def inheritedFeeGroupresult = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveInheritedFeeGroups'){isActiveFlag : '#(isActiveFlag)'}{areaCodeId : '#(areaCodeId)'}{areaCode : '#(areaCode)'}{areaCodeName : '#(areaCodeName)'}}
    And def inheritedFeeGroupResponse = inheritedFeeGroupresult.response
    And print inheritedFeeGroupResponse
    #Retrieving should be fee groups
    And def getAllFeeGroupsResults = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@AllFeeGroups')
    And def getAllFeeGroupsResponse = getAllFeeGroupsResults.response
    And print getAllFeeGroupsResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path                      |                             0 |
      | id                        | entityIDData                  |
      | feeGroupCode              | faker.getFirstName()          |
      | description               | faker.getFirstName()          |
      | restricted                | restricted[1]                 |
      | includeInOverridedropdown | faker.getRandomBooleanValue() |
      | isActive                  | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |                                                    0 |
      | id   | nonRestrictedFeeGroupResponse.body.departmentId.id   |
      | name | nonRestrictedFeeGroupResponse.body.departmentId.name |
      | code | nonRestrictedFeeGroupResponse.body.departmentId.code |
    And set areaCommandBody
      | path |                                              0 |
      | id   | nonRestrictedFeeGroupResponse.body.areaId.id   |
      | name | nonRestrictedFeeGroupResponse.body.areaId.name |
      | code | nonRestrictedFeeGroupResponse.body.areaId.code |
    And set inheritFeeGroupCommandBody
      | path |                                         0 |
      | id   | inheritedFeeGroupResponse.results[0].id   |
      | name | inheritedFeeGroupResponse.results[0].name |
      | code | inheritedFeeGroupResponse.results[0].code |
    And set shouldBeFeeGroupCommandBody
      | path |                                       0 |
      | id   | getAllFeeGroupsResponse.results[0].id   |
      | name | getAllFeeGroupsResponse.results[0].name |
      | code | getAllFeeGroupsResponse.results[0].code |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
      | body.areaId       | areaCommandBody[0]                          |
    #   | body.inheritFeeGroup  | inheritFeeGroupCommandBody[0]               |
    #    | body.shouldBeFeeGroup | shouldBeFeeGroupCommandBody[0]              |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def createNonRestrictedFeeGroupResponse = response
    And print createNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match createNonRestrictedFeeGroupCommandPayload.body.id == createNonRestrictedFeeGroupResponse.body.id
    And match createNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == createNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match createNonRestrictedFeeGroupCommandPayload.body.description == createNonRestrictedFeeGroupResponse.body.description
    And match createNonRestrictedFeeGroupCommandPayload.body.restricted == createNonRestrictedFeeGroupResponse.body.restricted
    And match createNonRestrictedFeeGroupCommandPayload.body.departmentId.id == createNonRestrictedFeeGroupResponse.body.departmentId.id
    And match createNonRestrictedFeeGroupCommandPayload.body.areaId.id == createNonRestrictedFeeGroupResponse.body.areaId.id
    And match createNonRestrictedFeeGroupCommandPayload.body.inheritFeeGroup.id == createNonRestrictedFeeGroupResponse.body.inheritFeeGroup.id
    And match createNonRestrictedFeeGroupCommandPayload.body.includeInOverridedropdown == createNonRestrictedFeeGroupResponse.body.includeInOverridedropdown
    And match createNonRestrictedFeeGroupCommandPayload.body.shouldBeFeeGroup == createNonRestrictedFeeGroupResponse.body.shouldBeFeeGroup
    And match createNonRestrictedFeeGroupCommandPayload.body.isActive == createNonRestrictedFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createNonRestrictedFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateNonRestrictedFeeGroupWithMandateDetails
  Scenario Outline: Create non restricted fee group with required fields and validate
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@CountyAreaWithRunTimeDepatmentArea'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Create County Area with department response
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/feeGroups/feeGroupsMasterInfo/FeeGroupDropDown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path         |                    0 |
      | id           | entityIDData         |
      | feeGroupCode | faker.getFirstName() |
      | description  | faker.getFirstName() |
    #    | isActive     | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set areaCommandBody
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
      | body.areaId       | areaCommandBody[0]                          |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def createNonRestrictedFeeGroupResponse = response
    And print createNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match createNonRestrictedFeeGroupCommandPayload.body.id == createNonRestrictedFeeGroupResponse.body.id
    And match createNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == createNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match createNonRestrictedFeeGroupCommandPayload.body.departmentId.id == createNonRestrictedFeeGroupResponse.body.departmentId.id
    And match createNonRestrictedFeeGroupCommandPayload.body.areaId.id == createNonRestrictedFeeGroupResponse.body.areaId.id
    And match createNonRestrictedFeeGroupResponse.body.restricted == false
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createNonRestrictedFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeGroupWithAreaAndDepartmentRunTime
  Scenario Outline: Create non restricted fee group with required fields and validate
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path         |                             0 |
      | id           | entityIDData                  |
      | feeGroupCode | faker.getFirstName()          |
      | description  | faker.getFirstName()          |
      | isActive     | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |              0 |
      | id   | departmentId   |
      | name | departmentName |
      | code | departmentCode |
    And set areaCommandBody
      | path |        0 |
      | id   | areaId   |
      | name | areaName |
      | code | areaCode |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
      | body.areaId       | areaCommandBody[0]                          |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def createNonRestrictedFeeGroupResponse = response
    And print createNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match createNonRestrictedFeeGroupCommandPayload.body.id == createNonRestrictedFeeGroupResponse.body.id
    And match createNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == createNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match createNonRestrictedFeeGroupCommandPayload.body.departmentId.id == createNonRestrictedFeeGroupResponse.body.departmentId.id
    And match createNonRestrictedFeeGroupCommandPayload.body.areaId.id == createNonRestrictedFeeGroupResponse.body.areaId.id
    #   And match createNonRestrictedFeeGroupCommandPayload.body.restricted == false
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createNonRestrictedFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateFeeGroupWithAreaAndDepartmentAndFeeGroupRunTime
  Scenario Outline: Create non restricted fee group with required fields and validate
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path         |                             0 |
      | id           | entityIDData                  |
      | feeGroupCode | faker.getFirstName()          |
      | description  | faker.getFirstName()          |
      | isActive     | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |              0 |
      | id   | departmentId   |
      | name | departmentName |
      | code | departmentCode |
    And set areaCommandBody
      | path |        0 |
      | id   | areaId   |
      | name | areaName |
      | code | areaCode |
    And set inheritFeeGroupCommandBody
      | path |            0 |
      | id   | feeGroupId   |
      | name | feeGroupCode |
      | code | description  |
    And set createNonRestrictedFeeGroupCommandPayload
      | path                 | [0]                                         |
      | header               | createNonRestrictedFeeGroupCommandHeader[0] |
      | body                 | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId    | departmentCommandBody[0]                    |
      | body.areaId          | areaCommandBody[0]                          |
      | body.inheritFeeGroup | inheritFeeGroupCommandBody[0]               |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 201
    And def createNonRestrictedFeeGroupResponse = response
    And print createNonRestrictedFeeGroupResponse
    And sleep(5000)
    And match createNonRestrictedFeeGroupCommandPayload.body.id == createNonRestrictedFeeGroupResponse.body.id
    And match createNonRestrictedFeeGroupCommandPayload.body.feeGroupCode == createNonRestrictedFeeGroupResponse.body.feeGroupCode
    And match createNonRestrictedFeeGroupCommandPayload.body.departmentId.id == createNonRestrictedFeeGroupResponse.body.departmentId.id
    And match createNonRestrictedFeeGroupCommandPayload.body.areaId.id == createNonRestrictedFeeGroupResponse.body.areaId.id
    #   And match createNonRestrictedFeeGroupCommandPayload.body.restricted == false
    And def mongoResult = mongoData.MongoDBReader(dbname,createFeeGroupCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == createNonRestrictedFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateNonRestrictedFeeGroupWithMandateDetailsWithOutArea
  Scenario Outline: Create non restricted fee group with required fields and validate
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    And def entityIDData = dataGenerator.entityID()
    And set createNonRestrictedFeeGroupCommandHeader
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
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityName      | entityName[0]                               |
    And set createNonRestrictedFeeGroupCommandBody
      | path         |                    0 |
      | id           | entityIDData         |
      | feeGroupCode | faker.getFirstName() |
      | description  | faker.getFirstName() |
    #  | isActive     | faker.getRandomBooleanValue() |
    And set departmentCommandBody
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set createNonRestrictedFeeGroupCommandPayload
      | path              | [0]                                         |
      | header            | createNonRestrictedFeeGroupCommandHeader[0] |
      | body              | createNonRestrictedFeeGroupCommandBody[0]   |
      | body.departmentId | departmentCommandBody[0]                    |
    And print createNonRestrictedFeeGroupCommandPayload
    And request createNonRestrictedFeeGroupCommandPayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetFeeGroup
  Scenario Outline: Get the fee group details
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | createFeeGroupResponse.header.sourceId      |
      | tenantId        | <tenantid>                                  |
      | id              | createFeeGroupResponse.header.id            |
      | correlationId   | createFeeGroupResponse.header.correlationId |
      | commandUserId   | createFeeGroupResponse.header.commandUserId |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCommandBody
      | path |          0 |
      | id   | feeGroupId |
    And set getFeeGroupPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getFeeGroupPayload
    And request getFeeGroupPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getFeeGroupResponse = response
    And print getFeeGroupResponse
    And match getFeeGroupResponse.id == createFeeGroupResponse.body.id
    And match getFeeGroupResponse.feeGroupCode == createFeeGroupResponse.body.feeGroupCode
    And match getFeeGroupResponse.description == createFeeGroupResponse.body.description
    And match getFeeGroupResponse.restricted == createFeeGroupResponse.body.restricted
    And match getFeeGroupResponse.isActive == createFeeGroupResponse.body.isActive
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,createFeeGroupCollectionNameRead+<tenantid>,getFeeGroupResponse.id)
    And print mongoResult
    And match mongoResult == createFeeGroupResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
