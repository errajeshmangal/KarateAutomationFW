
  @DocumentType
Feature: Add ,Edit,View, Grid view

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def DocumentTypeCollectionName = 'CreateFillingCodeMasterInfo_'
    And def DocumentTypeCollectionNameRead = 'FillingCodeMasterInfoDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateDocumentTypeMasterInfo","UpdateDocumentTypeMasterInfo","GetDocumentTypeMasterInfo","GetDocumentTypeMasterInfos","UpdateDocumentTypeOtherInfo"]
    And def entityName = ["DocumentTypeMasterInfo"]
    And def documentAttachmentCategory = ["Recorded","Filed","NonRecordable","Miscellaneous","RelatedDocument"]
    And def defaultDocumentSecurity = ["Use Default","Normal","Confidential","Secure"]
  
  
  @UpdateDocumentTypewithAllFieldsOtherInfo1
  Scenario Outline: Update Document Type  with Other info Details
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithAllFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[4]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                           |                                  0 |
      | id                             | dataGenerator.entityID()           |
      | masterInfoId                   | createDocumentTypeResponse.body.id |
      | nonRecordableERSeq             | faker.getRandom5DigitNumber()               |
      #| documentTypeDescription        | faker.getFirstName()               |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]         |
      | isRedact                       | faker.getRandomBoolean()      |
      | redactionStartDate             | faker.getRandomDate()              |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean()      |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean()      |
      | isAllowProofOfPublication      | faker.getRandomBoolean()      |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean()      |
    And set updateCommandPrimaryNumberingScheme
      | path |                                                           0 |
      | id   | createDocumentTypeResponse.body.primaryNumberingScheme.id   |
      | name | createDocumentTypeResponse.body.primaryNumberingScheme.name |
      | code | createDocumentTypeResponse.body.primaryNumberingScheme.code |
    And set updateCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandBookPageNumberingScheme
      | path |                                                            0 |
      | id   | createDocumentTypeResponse.body.bookpageNumberingScheme.id   |
      | name | createDocumentTypeResponse.body.bookpageNumberingScheme.name |
      | code | createDocumentTypeResponse.body.bookpageNumberingScheme.code |
    And set updateCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandStorageArea
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | updateCommandHeader[0]                   |
      | body                          | updateCommandBody[0]                     |
      | body.primaryNumberingScheme   | updateCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | updateCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | updateCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | updateCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | updateCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | updateCommandStorageArea[0]              |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And sleep(15000)

    #    Get all Document Types
    Given url readBaseUrl
    When path '/api/'+commandType[2]
    And set getDocTypeCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | getType         | "Array"                                     |
      | commandUserId   | dataGenerator.commandUserId()               |
      | tags            | []                                          |
      | commandType     | commandType[2]                              |
      | ttl             |                                           0 |
    And set getDocTypeCommandBodyRequest
      | path                    |                                        0 |
      | documentTypeId          |                                          |
      | documentTypeDescription |                                          |
      | department              |                                          |
      | area                    |                                          |
      | isActive                | createDocumentTypeResponse.body.isActive |
      | lastUpdatedDateTime     |                                          |
    And set getDocumentTypeCommandPagination
      | path        |                     0 |
      | currentPage |                     1 |
      | pageSize    |                   500 |
      | sortBy      | "lastUpdatedDateTime" |
      | isAscending | false                 |
    And set getDocumentTypesCommandPayload
      | path                | [0]                                  |
      | header              | getDocumentTypeCommandHeader[0]      |
      | body.request        | getDocumentTypeCommandBodyRequest[0] |
      | body.paginationSort | getDocumentTypeCommandPagination[0]  |
    And print getDocumentTypesCommandPayload
    And request getDocumentTypesCommandPayload
    When method POST
    Then status 200
    And def getDocumentTypesResponse = response
    And print getDocumentTypesResponse
    And match getDocumentTypesResponse.results[*].id contains createDocumentTypeResponse.body.id
    And match getDocumentTypesResponse.results[*].documentTypeId contains createDocumentTypeResponse.body.documentTypeId
    And match getDocumentTypesResponse.results[*].documentTypeDescription contains createDocumentTypeResponse.body.documentTypeDescription
    And match getDocumentTypesResponse.results[*].department contains createDocumentTypeResponse.body.department
    And match getDocumentTypesResponse.results[*].area contains createDocumentTypeResponse.body.area
    And match each getDocumentTypesResponse.results[*].isActive == createDocumentTypeResponse.body.isActive
    And def getDocumentTypesResponseCount = karate.sizeOf(getDocumentTypesResponse.results)
    And print getDocumentTypesResponseCount
    And match getDocumentTypesResponseCount == getDocumentTypesResponse.totalRecordCount
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @UpdateDocumentTypewithMandateFieldsOtherInfo1
  Scenario Outline: Update Document Type  with Other info Details
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithMandateFields')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[4]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                           |                             0 |
      | id                             |                               |
      | nonRecordableERSeq             | faker.getFirstName()          |
      | documentTypeDescription        | faker.getFirstName()          |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]    |
      | isRedact                       | faker.getRandomBoolean() |
      | redactionStartDate             |                               |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean() |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean() |
      | isAllowProofOfPublication      | faker.getRandomBoolean() |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean() |
    And set updateCommandPrimaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandBookPageNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandStorageArea
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | updateCommandHeader[0]                   |
      | body                          | updateCommandBody[0]                     |
      | body.primaryNumberingScheme   | updateCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | updateCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | updateCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | updateCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | updateCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | updateCommandStorageArea[0]              |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And sleep(15000)

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateDocumentTypewithMandateAndNumberAndBook/PageSchemeOtherInfo1
  Scenario Outline: Update Document Type  with Other info Details
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    # Create Document Type
    And def result = call read('CreateDocumentType.feature@CreateDocumentTypewithmandateAndNumberingSchemeBook/PageScheme')
    And def createDocumentTypeResponse = result.response
    And print createDocumentTypeResponse
    And set updateCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | createDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | createDocumentTypeResponse.header.id            |
      | correlationId   | createDocumentTypeResponse.header.correlationId |
      | entityId        | createDocumentTypeResponse.header.entityId      |
      | commandUserId   | createDocumentTypeResponse.header.commandUserId |
      | entityVersion   |                                               1 |
      | tags            | []                                              |
      | commandType     | commandType[4]                                  |
      | entityName      | entityName[0]                                   |
      | ttl             |                                               0 |
    And set updateCommandBody
      | path                           |                             0 |
      | id                             |                               |
      | nonRecordableERSeq             | faker.getFirstName()          |
      | documentTypeDescription        | faker.getFirstName()          |
      | defaultDocumentSecurity        | defaultDocumentSecurity[1]    |
      | isRedact                       | faker.getRandomBoolean() |
      | redactionStartDate             |                               |
      | isDayForwardRequireStaffReview | faker.getRandomBoolean() |
      | isBackFileRequireStaffReview   | faker.getRandomBoolean() |
      | isAllowProofOfPublication      | faker.getRandomBoolean() |
      | isAttorneyInFactOnBondEntry    | faker.getRandomBoolean() |
    And set updateCommandPrimaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandBookPageNumberingScheme
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandPrimaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandSecondaryFeeAssignment
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateCommandStorageArea
      | path |                    0 |
      | id   | dataGenerator.Id()   |
      | name | faker.getFirstName() |
      | code | faker.getFirstName() |
    And set updateDocumentTypePayload
      | path                          | [0]                                      |
      | header                        | updateCommandHeader[0]                   |
      | body                          | updateCommandBody[0]                     |
      | body.primaryNumberingScheme   | updateCommandPrimaryNumberingScheme[0]   |
      | body.secondaryNumberingScheme | updateCommandSecondaryNumberingScheme[0] |
      | body.bookpageNumberingScheme  | updateCommandBookPageNumberingScheme[0]  |
      | body.primaryFeeAssignment     | updateCommandPrimaryFeeAssignment[0]     |
      | body.secondaryFeeAssignment   | updateCommandSecondaryFeeAssignment[0]   |
      | body.storageArea              | updateCommandStorageArea[0]              |
    And print updateDocumentTypePayload
    And request updateDocumentTypePayload
    When method POST
    Then status 201
    And def updateDocumentTypeResponse = response
    And print updateDocumentTypeResponse
    #Get the Document Type
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                               0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()         |
      | version         | "1.001"                                         |
      | sourceId        | updateDocumentTypeResponse.header.sourceId      |
      | tenantId        | <tenantid>                                      |
      | id              | updateDocumentTypeResponse.header.id            |
      | correlationId   | updateDocumentTypeResponse.header.correlationId |
      | commandUserId   | updateDocumentTypeResponse.header.commandUserId |
      | tags            | []                                              |
      | commandType     | commandType[2]                                  |
      | getType         | "One"                                           |
      | ttl             |                                               0 |
    And set getCommandBody
      | path |                                  0 |
      | id   | updateDocumentTypeResponse.body.id |
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
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,DocumentTypeCollectionNameRead+<tenantid>,createDocumentTypeResponse.header.entityId)
    And print mongoResult
    And match mongoResult == createDocumentTypeResponse.body.id
    And sleep(15000)

    Examples: 
      | tenantid    |
      | tenantID[0] |