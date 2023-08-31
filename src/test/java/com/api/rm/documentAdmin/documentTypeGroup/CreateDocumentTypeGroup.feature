@AddDocumentTypeGroupScenarios
Feature: Add Document Type Groups

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeGroupCollectionName = 'CreateDocumentTypeGroup_'
    And def DocumentTypeGroupCollectionNameRead = 'DocumentTypeGroupDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateDocumentTypeGroupswithAllFields
  Scenario Outline: Create Document Type Group with all Details
    Given url commandBaseUrl
    And path '/api/CreateDocumentTypeGroup'
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    #calling getAreaBasedOnDepartmentApi
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    #calling getDocumentTypeBasedOnDocumentClassApi
    And def resultDocumentType = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDefaultDocumentTypeBasedOnDocumentClasses')
    And def activeDocumentTypeResponse = resultDocumentType.response
    And print activeDocumentTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateDocumentTypeGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "CreateDocumentTypeGroup"                        |
      | entityName      | "DocumentTypeGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path                  |                                 0 |
      | id                    | entityIdData                      |
      | documentTypeGroupID   | faker.getRandom5DigitNumber()     |
      | documentTypeGroupName | faker.getFirstName()              |
      | isActive              | faker.getRandomBoolean()          |
      | description           | faker.getRandomShortDescription() |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDefaultDocumentType
      | path |                                          0 |
      | id   | activeDocumentTypeResponse.results[0].id   |
      | name | activeDocumentTypeResponse.results[0].name |
      | code | activeDocumentTypeResponse.results[0].code |
    And set createDocumentTypeGroupPayload
      | path                     | [0]                           |
      | header                   | commandHeader[0]              |
      | body                     | commandBody[0]                |
      | body.department          | commandDepartment[0]          |
      | body.area                | commandArea[0]                |
      | body.documentClass       | commandDocumentClass[0]       |
      | body.defaultDocumentType | commandDefaultDocumentType[0] |
    And print createDocumentTypeGroupPayload
    And request createDocumentTypeGroupPayload
    When method POST
    Then status 201
    And print response
    And def createDocumentTypeGroupResponse = response
    And print createDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeGroupCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createDocumentTypeGroupResponse.body.id
    And match createDocumentTypeGroupPayload.body.documentTypeGroupName == createDocumentTypeGroupResponse.body.documentTypeGroupName
    And match createDocumentTypeGroupPayload.body.description == createDocumentTypeGroupResponse.body.description
    And match createDocumentTypeGroupPayload.body.isActive == createDocumentTypeGroupResponse.body.isActive
    And match createDocumentTypeGroupPayload.body.area.id == createDocumentTypeGroupResponse.body.area.id
    And match createDocumentTypeGroupPayload.body.department.id == createDocumentTypeGroupResponse.body.department.id
    And match   createDocumentTypeGroupPayload.body.documentClass.id == createDocumentTypeGroupResponse.body.documentClass.id
    And match createDocumentTypeGroupPayload.body.defaultDocumentType.id == createDocumentTypeGroupResponse.body.defaultDocumentType.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypeGroupsWithMandatoryFields
  Scenario Outline: Create Document Type Group with mandatory fields
    Given url commandBaseUrl
    And path '/api/CreateDocumentTypeGroup'
    #calling department API to get active departments data
    And def result = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    #calling getAreaBasedOnDepartmentApi
    And def resultArea = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@CreateActiveAreaBasedOnActiveDepartmentAndGetArea')
    And def activeAreaResponse = resultArea.response
    And print activeAreaResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDocumentClassBasedOnSelectedArea')
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    #calling getDocumentTypeBasedOnDocumentClassApi
    And def resultDocumentType = call read('classpath:com/api/rm/documentAdmin/documentTypeGroup/DepartmentAndArea.feature@GetDefaultDocumentTypeBasedOnDocumentClasses')
    And def activeDocumentTypeResponse = resultDocumentType.response
    And print activeDocumentTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                0 |
      | schemaUri       | schemaUri+"/CreateDocumentTypeGroup-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()          |
      | version         | "1.001"                                          |
      | sourceId        | dataGenerator.SourceID()                         |
      | tenantId        | <tenantid>                                       |
      | id              | dataGenerator.Id()                               |
      | correlationId   | dataGenerator.correlationId()                    |
      | entityId        | entityIdData                                     |
      | commandUserId   | dataGenerator.commandUserId()                    |
      | entityVersion   |                                                1 |
      | tags            | []                                               |
      | commandType     | "CreateDocumentTypeGroup"                        |
      | entityName      | "DocumentTypeGroup"                              |
      | ttl             |                                                0 |
    And set commandBody
      | path                  |                             0 |
      | id                    | entityIdData                  |
      | documentTypeGroupID   | faker.getRandom5DigitNumber() |
      | documentTypeGroupName | faker.getFirstName()          |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                  0 |
      | id   | activeAreaResponse.results[0].id   |
      | name | activeAreaResponse.results[0].name |
      | code | activeAreaResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDefaultDocumentType
      | path |                                          0 |
      | id   | activeDocumentTypeResponse.results[0].id   |
      | name | activeDocumentTypeResponse.results[0].name |
      | code | activeDocumentTypeResponse.results[0].code |
    And set createDocumentTypeGroupPayload
      | path                     | [0]                           |
      | header                   | commandHeader[0]              |
      | body                     | commandBody[0]                |
      | body.department          | commandDepartment[0]          |
      | body.area                | commandArea[0]                |
      | body.documentClass       | commandDocumentClass[0]       |
      | body.defaultDocumentType | commandDefaultDocumentType[0] |
    And print createDocumentTypeGroupPayload
    And request createDocumentTypeGroupPayload
    When method POST
    Then status 201
    And print response
    And def createDocumentTypeGroupResponse = response
    And print createDocumentTypeGroupResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeGroupCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createDocumentTypeGroupResponse.body.id
    And match createDocumentTypeGroupPayload.body.documentTypeGroupName == createDocumentTypeGroupResponse.body.documentTypeGroupName
    And match createDocumentTypeGroupPayload.body.area.id == createDocumentTypeGroupResponse.body.area.id
    And match createDocumentTypeGroupPayload.body.department.id == createDocumentTypeGroupResponse.body.department.id
    And match   createDocumentTypeGroupPayload.body.documentClass.id == createDocumentTypeGroupResponse.body.documentClass.id
    And match createDocumentTypeGroupPayload.body.defaultDocumentType.id == createDocumentTypeGroupResponse.body.defaultDocumentType.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
