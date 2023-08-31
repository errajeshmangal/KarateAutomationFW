@AddDocumentTypeScenarios
Feature: Add Document Type Groups

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeCollectionName = 'CreateDocumentTypeMasterInfo_'
    And def DocumentTypeCollectionNameRead = 'DocumentTypeMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateDocumentTypeMasterInfo","UpdateDocumentTypeMasterInfo","GetDocumentTypeMasterInfo","GetDocumentTypeMasterInfos","UpdateDocumentTypeOtherInfo","CreateDocumentTypeOtherInfo"]
    And def entityName = ["DocumentTypeMasterInfo"]
    And def documentAttachmentCategory = ["Recorded","Filed","NonRecordable","Miscellaneous","RelatedDocument"]

  @CreateDocumentTypewithAllFields
  Scenario Outline: Create Document Type Master Info with all Details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #calling the document type label
    And def resultLabelType = call read('DocumentTypeDropdown.feature@RetrieveLabelTypes')
    And def activelabelType = resultLabelType.response
    And print activelabelType
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set commandBody
      | path                       |                                 0 |
      | id                         | entityIdData                      |
      | documentTypeCode           | faker.getUserId()              |
      | documentTypeDescription    | faker.getFirstName()              |
      | description                | faker.getRandomShortDescription() |
      | isActive                   | faker.getRandomBoolean()          |
      | isExcludeFromCashiering    | faker.getRandomBoolean()          |
      | isExcludeFromIndexing      | faker.getRandomBoolean()          |
      | documentAttachmentCategory | documentAttachmentCategory[0]     |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDocumentTypeGroup
      | path |                                                                0 |
      | id   | activeDocumentTypeGroupResponse.results[0].id                    |
      | name | activeDocumentTypeGroupResponse.results[0].documentTypeGroupName |
      | code | activeDocumentTypeGroupResponse.results[0].documentTypeGroupID   |
    And set commandLabelType
      | path |                               0 |
      | id   | activelabelType.results[0].id   |
      | name | activelabelType.results[0].name |
      | code | activelabelType.results[0].code |
    And set commandLabelType
      | path |                               1 |
      | id   | activelabelType.results[1].id   |
      | name | activelabelType.results[1].name |
      | code | activelabelType.results[1].code |
    And set createDocumentTypePayload
      | path                   | [0]                         |
      | header                 | commandHeader[0]            |
      | body                   | commandBody[0]              |
      | body.department        | commandDepartment[0]        |
      | body.area              | commandArea[0]              |
      | body.documentClass     | commandDocumentClass[0]     |
      | body.documentTypeGroup | commandDocumentTypeGroup[0] |
      | body.labelType         | commandLabelType            |
    And print   createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 201
    And def createDocumentTypeResponse = response
    And print createDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeCollectionName+<tenantid>,createDocumentTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match createDocumentTypePayload.body.id == createDocumentTypeResponse.body.id
    And match createDocumentTypePayload.body.documentTypeCode == createDocumentTypeResponse.body.documentTypeCode
    And match createDocumentTypePayload.body.documentTypeDescription == createDocumentTypeResponse.body.documentTypeDescription
    And match createDocumentTypePayload.body.description == createDocumentTypeResponse.body.description
    And match createDocumentTypePayload.body.isActive == createDocumentTypeResponse.body.isActive
    And match createDocumentTypePayload.body.isExcludeFromCashiering == createDocumentTypeResponse.body.isExcludeFromCashiering
    And match createDocumentTypePayload.body.isExcludeFromIndexing == createDocumentTypeResponse.body.isExcludeFromIndexing
    And match createDocumentTypePayload.body.area.name == createDocumentTypeResponse.body.area.name
    And match createDocumentTypePayload.body.department.name == createDocumentTypeResponse.body.department.name
    And match createDocumentTypePayload.body.documentClass.name == createDocumentTypeResponse.body.documentClass.name
    And match createDocumentTypePayload.body.documentTypeGroup.name == createDocumentTypeResponse.body.documentTypeGroup.name
    And match createDocumentTypePayload.body.labelType[0].name == createDocumentTypeResponse.body.labelType[0].name
    And match createDocumentTypePayload.body.labelType[1].name == createDocumentTypeResponse.body.labelType[1].name
    And match createDocumentTypePayload.body.labelType[0].id == createDocumentTypeResponse.body.labelType[0].id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypeMasterInfowithMandateFields
  Scenario Outline: Create Document Type Master Info with Mandate Details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set commandBody
      | path                       |                             0 |
      | id                         | entityIdData                  |
      | documentTypeCode           | faker.getFirstName()          |
      | documentTypeDescription    | faker.getFirstName()          |
      | documentAttachmentCategory | documentAttachmentCategory[0] |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set createDocumentTypePayload
      | path               | [0]                     |
      | header             | commandHeader[0]        |
      | body               | commandBody[0]          |
      | body.department    | commandDepartment[0]    |
      | body.area          | commandArea[0]          |
      | body.documentClass | commandDocumentClass[0] |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 201
    And def createDocumentTypeResponse = response
    And print createDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeCollectionName+<tenantid>,createDocumentTypeResponse.body.id)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match createDocumentTypePayload.body.id == createDocumentTypeResponse.body.id
    And match createDocumentTypePayload.body.documentTypeCode == createDocumentTypeResponse.body.documentTypeCode
    And match createDocumentTypePayload.body.documentTypeDescription == createDocumentTypeResponse.body.documentTypeDescription
    And match createDocumentTypePayload.body.area.name == createDocumentTypeResponse.body.area.name
    And match createDocumentTypePayload.body.department.name == createDocumentTypeResponse.body.department.name
    And match createDocumentTypePayload.body.documentClass.name == createDocumentTypeResponse.body.documentClass.name

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypewithAllFieldsinvaliddata
  Scenario Outline: Create Document Type Master Info with all Details and invalid data
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #calling the document type label
    And def resultLabelType = call read('DocumentTypeDropdown.feature@RetrieveLabelTypes')
    And def activelabelType = resultLabelType.response
    And print activelabelType
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set commandBody
      | path                       |                             0 |
      | id                         | entityIdData                  |
      | documentTypeCode           | ""                            |
      | documentTypeDescription    | faker.getRandom1Digit()       |
      | description                | " "                           |
      | isActive                   | faker.getRandomBoolean()      |
      | isExcludeFromCashiering    | faker.getRandomBoolean()      |
      | isExcludeFromIndexing      | faker.getRandomBoolean()      |
      | documentAttachmentCategory | documentAttachmentCategory[0] |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDocumentTypeGroup
      | path |                                                                0 |
      | id   | activeDocumentTypeGroupResponse.results[0].id                    |
      | name | activeDocumentTypeGroupResponse.results[0].documentTypeGroupName |
      | code | activeDocumentTypeGroupResponse.results[0].documentTypeGroupID   |
    And set commandLabelType
      | path |                               0 |
      | id   | activelabelType.results[0].id   |
      | name | activelabelType.results[0].name |
      | code | activelabelType.results[0].code |
    And set commandLabelType
      | path |                               1 |
      | id   | activelabelType.results[1].id   |
      | name | activelabelType.results[1].name |
      | code | activelabelType.results[1].code |
    And set createDocumentTypePayload
      | path                   | [0]                         |
      | header                 | commandHeader[0]            |
      | body                   | commandBody[0]              |
      | body.department        | commandDepartment[0]        |
      | body.area              | commandArea[0]              |
      | body.documentClass     | commandDocumentClass[0]     |
      | body.documentTypeGroup | commandDocumentTypeGroup[0] |
      | body.labelType         | commandLabelType            |
    And print   createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 400

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetDocumentTypewithallfields
  Scenario Outline: get a Document Type Master Info with all the fields
  # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    #get the details
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | createDocumentTypeResponse.body.id |
    And set getDocumentTypePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getDocumentTypePayload
    And request getDocumentTypePayload
    When method POST
    Then status 200
    And def getDocumentTypeResponse = response
    And print getDocumentTypeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateDocumentTypewithDuplicateFields
  Scenario Outline: Create Document Type Master Info with duplicate fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
     #Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    And def docId = createDocumentTypeResponse.body.id
    #Get the document type response
    And def getDocumentTypeResponseResult = call read('classpath:com/api/rm/documentAdmin/documentType/CreateDocumentType.feature@GetDocumentTypewithallfields'){docId:'#(docId)'}
    And def getDocumentTypeResult = getDocumentTypeResponseResult.response
		And print getDocumentTypeResult
		 #calling department API to get active departments data
    And def result = call read('DocumentTypeDropdown.feature@CountyDepatmentsBasedOnFlag')
    And def activeDepartmentResponse = result.response
    And print activeDepartmentResponse
    And def departmentId = activeDepartmentResponse.results[0].id
    And def departmentName = activeDepartmentResponse.results[0].name
    And def departmentCode = activeDepartmentResponse.results[0].code
    #calling the document type label
    And def resultLabelType = call read('DocumentTypeDropdown.feature@RetrieveLabelTypes')
    And def activelabelType = resultLabelType.response
    And print activelabelType
    #Call the Create County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@CreateCountyAreaWithRunTimeDepartmentValues'){departmentId : '#(departmentId)'}{departmentCode : '#(departmentCode)'}{departmentName : '#(departmentName)'}}
    And def createAreaDropdownResponse = resultArea.response
    And print createAreaDropdownResponse
    And def areaCodeId = createAreaDropdownResponse.body.id
    #Call the Get County Area with department response
    And def resultArea = call read('DocumentTypeDropdown.feature@RetrieveCountyAreaBasedOnDepartment'){departmentId : '#(departmentId)'}{areaCodeId : '#(areaCodeId)'}{departmentName : '#(departmentName)'}}
    And def activeAreaDropdownResponse = resultArea.response
    And print activeAreaDropdownResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    #calling getDocumentTypeGroup
    And def resultDocumentTypeGroup = call read('DocumentTypeDropdown.feature@RetrieveDocumentTypeGroup')
    And def activeDocumentTypeGroupResponse = resultDocumentTypeGroup.response
    And print activeDocumentTypeGroupResponse
    #calling getDocumentClassBasedOnAreaApi
    And def resultDocumentClass = call read('DocumentTypeDropdown.feature@RetrieveDocumentClassBasedOnSelectedArea'){areaId : '#(areaId)'}
    And def activeDocumentClassResponse = resultDocumentClass.response
    And print activeDocumentClassResponse
    And def areaId = activeAreaDropdownResponse.results[0].id
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[0]                              |
      | entityName      | entityName[0]                               |
      | ttl             |                                           0 |
    And set commandBody
      | path                       |                                                0 |
      | id                         | entityIdData                                     |
      | documentTypeCode           | getDocumentTypeResult.documentTypeCode |
      | documentTypeDescription    | faker.getFirstName()                             |
      | description                | faker.getRandomShortDescription()                |
      | isActive                   | faker.getRandomBoolean()                         |
      | isExcludeFromCashiering    | faker.getRandomBoolean()                         |
      | isExcludeFromIndexing      | faker.getRandomBoolean()                         |
      | documentAttachmentCategory | documentAttachmentCategory[0]                    |
    And set commandDepartment
      | path |                                        0 |
      | id   | activeDepartmentResponse.results[0].id   |
      | name | activeDepartmentResponse.results[0].name |
      | code | activeDepartmentResponse.results[0].code |
    And set commandArea
      | path |                                          0 |
      | id   | activeAreaDropdownResponse.results[0].id   |
      | name | activeAreaDropdownResponse.results[0].name |
      | code | activeAreaDropdownResponse.results[0].code |
    And set commandDocumentClass
      | path |                                           0 |
      | id   | activeDocumentClassResponse.results[0].id   |
      | name | activeDocumentClassResponse.results[0].name |
      | code | activeDocumentClassResponse.results[0].code |
    And set commandDocumentTypeGroup
      | path |                                                                0 |
      | id   | activeDocumentTypeGroupResponse.results[0].id                    |
      | name | activeDocumentTypeGroupResponse.results[0].documentTypeGroupName |
      | code | activeDocumentTypeGroupResponse.results[0].documentTypeGroupID   |
    And set commandLabelType
      | path |                               0 |
      | id   | activelabelType.results[0].id   |
      | name | activelabelType.results[0].name |
      | code | activelabelType.results[0].code |
    And set commandLabelType
      | path |                               1 |
      | id   | activelabelType.results[1].id   |
      | name | activelabelType.results[1].name |
      | code | activelabelType.results[1].code |
    And set createDocumentTypePayload
      | path                   | [0]                         |
      | header                 | commandHeader[0]            |
      | body                   | commandBody[0]              |
      | body.department        | commandDepartment[0]        |
      | body.area              | commandArea[0]              |
      | body.documentClass     | commandDocumentClass[0]     |
      | body.documentTypeGroup | commandDocumentTypeGroup[0] |
      | body.labelType         | commandLabelType            |
    And print   createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 400
    And print response
    And match response contains 'DuplicateKey:DocumentTypeMasterInfo cannot be created'

    Examples: 
      | tenantid    |
      | tenantID[0] |
