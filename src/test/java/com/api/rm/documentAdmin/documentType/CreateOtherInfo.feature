@AddDocumentTypeOtherInfoScenarios
Feature: Add Document Type Groups

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeOtherInfoCollectionName = 'CreateDocumentTypeOtherInfo_'
    And def DocumentTypeOtherInfoCollectionNameRead = 'DocumentTypeOtherInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateDocumentTypeOtherInfo","GetDocumentTypeMasterInfos","UpdateDocumentTypeOtherInfo","GetDocumentTypeOtherInfo"]
    And def entityName = ["DocumentTypeOtherInfo"]
    And def documentAttachmentCategory = ["Recorded","Filed","NonRecordable","Miscellaneous","RelatedDocument"]
		And def defaultDocumentSecurity = ["Use Default","Normal","Confidential","Secure"]
		
		@CreateDocumentTypeOtherInfowithAllFields
		Scenario Outline: Create  the Document Type Other Info with all Details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    
    # Create Document Type Other Info
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And def entityIdData = dataGenerator.entityID()
    And print createDocumentTypeResponse
     #calling the document type Book Pages
    And def resultBookPages = call read('DocumentTypeDropdown.feature@GetDocumentTypeBookPages')
    And def activeBookPages = resultBookPages.response
    And print activeBookPages
   #calling the document type Primary Numbering Scheme
    And def resultPrimaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypePrimaryNumberingSchemes')
    And def activePrimaryNumberingScheme = resultPrimaryNumberingScheme.response
    And print activePrimaryNumberingScheme
   #calling the document type Secondary Numbering Scheme
    And def resultSecondaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypeSecondaryNumberingSchemes')
    And def activeSecondaryNumberingScheme = resultSecondaryNumberingScheme.response
    And print activeSecondaryNumberingScheme
    #calling the document type Storage Area
    And def resultStorageArea = call read('DocumentTypeDropdown.feature@GetDocumentTypeStorageAreas')
    And def activeStorageArea = resultStorageArea.response
    And print activeStorageArea    
    
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
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
    And set createCommandBody
      | path                           |                                  0 |
      | id                             | entityIdData                       |
      | documentTypeId                 | createDocumentTypeResponse.body.id |
      | nonRecordableERSeq             | faker.getRandom5DigitNumber()      |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]         |
      | isRedact                       | faker.getRandomBoolean()           |
      | redactionStartDate             | faker.getUTCTime()              |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean()           |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean()           |
      | isAllowProofOfPublication      | faker.getRandomBoolean()           |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean()           |
    And set createCommandPrimaryNumberingScheme
      | path |                                                           0 |
      | id   | activePrimaryNumberingScheme.results[0].id   |
      | name | activePrimaryNumberingScheme.results[0].name |
      | code | activePrimaryNumberingScheme.results[0].code |
    And set createCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | activeSecondaryNumberingScheme.results[0].id   |
      | name | activeSecondaryNumberingScheme.results[0].name |
      | code | activeSecondaryNumberingScheme.results[0].code |
    And set createCommandBookPageNumberingScheme
      | path |                                                            0 |
      | id   | activeBookPages.results[0].id   |
      | name | activeBookPages.results [0].name |
      | code | activeBookPages.results [0].code |
    And set createCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandStorageArea
      | path |                    0 |
      | id   |activeStorageArea.results[0].id   |
      | name | activeStorageArea.results[0].name |
      | code | activeStorageArea.results[0].code |
    And set createDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | createCommandHeader[0]                   |
      | body                          | createCommandBody[0]                     |
      | body.primaryNumberingScheme   | createCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | createCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | createCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | createCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | createCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | createCommandStorageArea[0]              |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 201
    And def createDocumentTypeResponse = response
    And print createDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeOtherInfoCollectionName+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match mongoResult == createDocumentTypeResponse.body.id
    
		Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @CreateandGetDocumentTypeOtherInfowithAllFields
  Scenario Outline: Create and get the Document Type Other Info with all Details
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    # Create Document Type Other Info
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And def entityIdData = dataGenerator.entityID()
    And print createDocumentTypeResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
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
    And set createCommandBody
      | path                           |                                  0 |
      | id                             | entityIdData                       |
      | documentTypeId                   | createDocumentTypeResponse.body.id |
      | nonRecordableERSeq             | faker.getRandom5DigitNumber()      |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]         |
      | isRedact                       | faker.getRandomBoolean()           |
      | redactionStartDate             | faker.getRandomDate()              |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean()           |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean()           |
      | isAllowProofOfPublication      | faker.getRandomBoolean()           |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean()           |
    And set createCommandPrimaryNumberingScheme
      | path |                                                           0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandBookPageNumberingScheme
      | path |                                                            0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandStorageArea
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | createCommandHeader[0]                   |
      | body                          | createCommandBody[0]                     |
      | body.primaryNumberingScheme   | createCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | createCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | createCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | createCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | createCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | createCommandStorageArea[0]              |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 201
    And def createDocumentTypeResponse = response
    And print createDocumentTypeResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,DocumentTypeOtherInfoCollectionName+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And match mongoResult == createDocumentTypeResponse.body.id
    
    #Get the Document Type Other Info
    Given url readBaseUrl
    And path '/api/'+commandType[3]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[3]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[3]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | documentTypeId   | createDocumentTypeResponse.body.documentTypeId |
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeOtherInfoCollectionNameRead+<tenantid>,getDocumentTypeResponse.id)
    And print mongoResult
    And match mongoResult == getDocumentTypeResponse.id
    And match getDocumentTypeResponse.redactionStartDate == createDocumentTypeResponse.body.redactionStartDate
    And sleep(15000)

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @CreateDocumentTypeOtherInfowithInvalidData
		Scenario Outline: Create  the Document Type Other Info with Invalid Data
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    
    # Create Document Type Other Info
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And def entityIdData = dataGenerator.entityID()
    And print createDocumentTypeResponse
     #calling the document type Book Pages
    And def resultBookPages = call read('DocumentTypeDropdown.feature@GetDocumentTypeBookPages')
    And def activeBookPages = resultBookPages.response
    And print activeBookPages
   #calling the document type Primary Numbering Scheme
    And def resultPrimaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypePrimaryNumberingSchemes')
    And def activePrimaryNumberingScheme = resultPrimaryNumberingScheme.response
    And print activePrimaryNumberingScheme
   #calling the document type Secondary Numbering Scheme
    And def resultSecondaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypeSecondaryNumberingSchemes')
    And def activeSecondaryNumberingScheme = resultSecondaryNumberingScheme.response
    And print activeSecondaryNumberingScheme
    #calling the document type Storage Area
    And def resultStorageArea = call read('DocumentTypeDropdown.feature@GetDocumentTypeStorageAreas')
    And def activeStorageArea = resultStorageArea.response
    And print activeStorageArea
    
    
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
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
    And set createCommandBody
      | path                           |                                  0 |
      | id                             | entityIdData                       |
      | documentTypeId                 | createDocumentTypeResponse.body.id |
      | nonRecordableERSeq             | faker.getFirstName()      |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]         |
      | isRedact                       | faker.getRandomBoolean()           |
      | redactionStartDate             | faker.getUTCTime()              |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean()           |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean()           |
      | isAllowProofOfPublication      | faker.getRandomBoolean()           |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean()           |
    And set createCommandPrimaryNumberingScheme
      | path |                                                           0 |
      | id   | activePrimaryNumberingScheme.results[0].id   |
      | name | activePrimaryNumberingScheme.results[0].name |
      | code | activePrimaryNumberingScheme.results[0].code |
    And set createCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | activeSecondaryNumberingScheme.results[0].id   |
      | name | activeSecondaryNumberingScheme.results[0].name |
      | code | activeSecondaryNumberingScheme.results[0].code |
    And set createCommandBookPageNumberingScheme
      | path |                                                            0 |
      | id   | activeBookPages.results[0].id   |
      | name | activeBookPages.results [0].name |
      | code | activeBookPages.results [0].code |
    And set createCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandStorageArea
      | path |                    0 |
      | id   |activeStorageArea.results[0].id   |
      | name | activeStorageArea.results[0].name |
      | code | activeStorageArea.results[0].code |
    And set createDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | createCommandHeader[0]                   |
      | body                          | createCommandBody[0]                     |
      | body.primaryNumberingScheme   | createCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | createCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | createCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | createCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | createCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | createCommandStorageArea[0]              |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 400
        		Examples: 
      | tenantid    |
      | tenantID[0] |
      
         @CreateDocumentTypeOtherInfowithMinimumFields
		Scenario Outline: Create  the Document Type Other Info with Minimum fields
    Given url commandBaseUrl
    And path '/api/'+commandType[0]
    
    # Create Document Type Other Info
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And def entityIdData = dataGenerator.entityID()
    And print createDocumentTypeResponse
     #calling the document type Book Pages
    And def resultBookPages = call read('DocumentTypeDropdown.feature@GetDocumentTypeBookPages')
    And def activeBookPages = resultBookPages.response
    And print activeBookPages
   #calling the document type Primary Numbering Scheme
    And def resultPrimaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypePrimaryNumberingSchemes')
    And def activePrimaryNumberingScheme = resultPrimaryNumberingScheme.response
    And print activePrimaryNumberingScheme
   #calling the document type Secondary Numbering Scheme
    And def resultSecondaryNumberingScheme = call read('DocumentTypeDropdown.feature@GetDocumentTypeSecondaryNumberingSchemes')
    And def activeSecondaryNumberingScheme = resultSecondaryNumberingScheme.response
    And print activeSecondaryNumberingScheme
    #calling the document type Storage Area
    And def resultStorageArea = call read('DocumentTypeDropdown.feature@GetDocumentTypeStorageAreas')
    And def activeStorageArea = resultStorageArea.response
    And print activeStorageArea
    
    
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
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
    And set createCommandBody
      | path                           |                                  0 |
      | id                             | entityIdData                       |
      | documentTypeId                 | createDocumentTypeResponse.body.id |
      | nonRecordableERSeq             | faker.getFirstName()      |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]         |
      | isRedact                       | faker.getRandomBoolean()           |
      | redactionStartDate             | faker.getUTCTime()              |
      
    And set createCommandPrimaryNumberingScheme
      | path |                                                           0 |
      | id   | activePrimaryNumberingScheme.results[0].id   |
      | name | activePrimaryNumberingScheme.results[0].name |
      | code | activePrimaryNumberingScheme.results[0].code |
    And set createCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | activeSecondaryNumberingScheme.results[0].id   |
      | name | activeSecondaryNumberingScheme.results[0].name |
      | code | activeSecondaryNumberingScheme.results[0].code |
    And set createCommandBookPageNumberingScheme
      | path |                                                            0 |
      | id   | activeBookPages.results[0].id   |
      | name | activeBookPages.results [0].name |
      | code | activeBookPages.results [0].code |
    And set createCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set createCommandStorageArea
      | path |                    0 |
      | id   |activeStorageArea.results[0].id   |
      | name | activeStorageArea.results[0].name |
      | code | activeStorageArea.results[0].code |
    And set createDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | createCommandHeader[0]                   |
      | body                          | createCommandBody[0]                     |
      | body.primaryNumberingScheme   | createCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | createCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | createCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | createCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | createCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | createCommandStorageArea[0]              |
    And print createDocumentTypePayload
    And request createDocumentTypePayload
    When method POST
    Then status 400
        		Examples: 
      | tenantid    |
      | tenantID[0] |
      
