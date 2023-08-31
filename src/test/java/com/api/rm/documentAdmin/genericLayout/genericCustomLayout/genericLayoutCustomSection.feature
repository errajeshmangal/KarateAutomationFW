@GenericLayoutCustomSection
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateGenericLayoutCustomSection_'
    And def genericLayoutNameCollectionNameRead = 'GenericLayoutCustomSectionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutCustomSection','UpdateGenericLayoutCustomSection']
    And def entityName = ['GenericLayoutCustomSection']
    And def layoutType = ['Section']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]

  @CreateGenericLayoutCustomSectionMarriageLicence
  Scenario Outline: Create a custom generic layout code with marriage licence custom section
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | true                              |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionMarriageApplication
  Scenario Outline: Create a custom generic layout code with marriage application custom section
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[1]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionDeathCertificate
  Scenario Outline: Create a custom generic layout code with death certificate custom section with all the fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[2]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionBirthCertificate
  Scenario Outline: Create a custom generic layout code with birth certificate custom section with all the fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[3]               |
      | layoutCode        | faker.getUserId()                 |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 3

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionMarriageLicenceWithMandatoryDetails
  Scenario Outline: Create a custom generic layout code with marriage licence custom section with mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                        0 |
      | id                | entityIdData             |
      | layoutType        | layoutType[0]            |
      | fieldsCollection  | fieldsCollection[0]      |
      | layoutCode        | faker.getUserId()        |
      | layoutDescription | faker.getDescription()   |
      | sectionType       | sectionType[0]           |
      | isActive          | faker.getRandomBoolean() |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 0

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionMarriageApplicationWithMandatoryDetails
  Scenario Outline: Create a custom generic layout code with marriage application custom section with mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                        0 |
      | id                | entityIdData             |
      | layoutType        | layoutType[0]            |
      | fieldsCollection  | fieldsCollection[1]      |
      | layoutCode        | faker.getUserId()        |
      | layoutDescription | faker.getDescription()   |
      | sectionType       | sectionType[0]           |
      | isActive          | faker.getRandomBoolean() |
    And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionDeathCertificateWithMandatoryDetails
  Scenario Outline: Create a custom generic layout code with death certificate custom section with mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                        0 |
      | id                | entityIdData             |
      | layoutType        | layoutType[0]            |
      | fieldsCollection  | fieldsCollection[2]      |
      | layoutCode        | faker.getUserId()        |
      | layoutDescription | faker.getDescription()   |
      | sectionType       | sectionType[0]           |
      | isActive          | faker.getRandomBoolean() |
     And set dataCommandsBody
      | path             |                                   0 |
      | id               | entityIdData                        |
      | sequence         | faker.getRandomInteger(0,1)         |
      | commandName      | 'test1'                  |
      | commandType      |'Create'                     |
      | description      |'test1'                   |
      | targetType       |'Topic'                   |
      | targetTopic.id   | entityIdData                        |
      | targetTopic.code | 'test1'                             |
      | targetTopic.name | 'test'                              |
      | targetUrl        | "http://oakmiweb.avenuinsights.com" |
      | isActive         | true                                |
    And set createGenericLayoutCustomSectionPayload
      | path                 | [0]                                              |
      | header               | createGenericLayoutCustomSectionCommandHeader[0] |
      | body                 | createGenericLayoutCustomSectionCommandBody[0]   |
      | body.dataCommands[0] | dataCommandsBody[0]                              |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionBirthCertificateWithMandatoryDetails
  Scenario Outline: Create a custom generic layout code with birth certificate custom section with mandatory fields
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                        0 |
      | id                | entityIdData             |
      | layoutType        | layoutType[0]            |
      | fieldsCollection  | fieldsCollection[3]      |
      | layoutCode        | faker.getUserId()        |
      | layoutDescription | faker.getDescription()   |
      | sectionType       | sectionType[0]           |
      | isActive          | faker.getRandomBoolean() |
    And set createGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | createGenericLayoutCustomSectionCommandHeader[0] |
      | body   | createGenericLayoutCustomSectionCommandBody[0]   |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createGenericLayoutCustomSectionResponse.body.id
    And match createGenericLayoutCustomSectionResponse.body.isActive == createGenericLayoutCustomSectionPayload.body.isActive
    And match createGenericLayoutCustomSectionResponse.body.layoutCode == createGenericLayoutCustomSectionPayload.body.layoutCode
    And match createGenericLayoutCustomSectionResponse.body.layoutDescription == createGenericLayoutCustomSectionPayload.body.layoutDescription
    And match createGenericLayoutCustomSectionResponse.body.id == createGenericLayoutCustomSectionPayload.body.id
    And match createGenericLayoutCustomSectionResponse.body.fieldsCollection == 3

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionMarriageLicencewithAllDetails
  Scenario Outline: Update Generic Layout custom section for Marriage licence with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Marriage Licence Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionMarriageApplicationwithAllDetails
  Scenario Outline: Update Generic Layout custom section for Marriage application with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Marriage Application Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageApplication')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[1]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionDeathCertificatewithAllDetails
  Scenario Outline: Update Generic Layout custom section for Death Certificate with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[2]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionBirthCertificatewithAllDetails
  Scenario Outline: Update Generic Layout custom section for Birth Certificate with all the fields
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Birth certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[3]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | longDescription   | faker.getRandomShortDescription()                        |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionMarriageLicencewithMandatoryDetails
  Scenario Outline: Update Generic Layout custom section for Marriage licence with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[0]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionMarriageApplicationwithMandatoryDetails
  Scenario Outline: Update Generic Layout custom section for Marriage application with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageApplication')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[1]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionDeathCertificatewithMandatoryDetails
  Scenario Outline: Update Generic Layout custom section for Death Cerificate with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[2]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutCustomSectionBirthCertificatewithMandatoryDetails
  Scenario Outline: Update Generic Layout custom section for Birth Certificate with mandatory details
    Given url commandBaseGenericLayout
    And path '/api/UpdateGenericLayoutCustomSection'
    # Create Generic Layout Death certificate Custom Section
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificate')
    And def createGenericLayoutCustomSectionResponse = result.response
    And print createGenericLayoutCustomSectionResponse
    And set updateGenericLayoutCustomSectionCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/UpdateGenericLayoutCustomSection-v1.001.json"     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | version         | "1.001"                                                       |
      | sourceId        | createGenericLayoutCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                    |
      | id              | createGenericLayoutCustomSectionResponse.header.id            |
      | correlationId   | createGenericLayoutCustomSectionResponse.header.correlationId |
      | entityId        | createGenericLayoutCustomSectionResponse.header.entityId      |
      | commandUserId   | createGenericLayoutCustomSectionResponse.header.commandUserId |
      | entityVersion   |                                                             1 |
      | tags            | []                                                            |
      | commandType     | commandType[1]                                                |
      | entityName      | createGenericLayoutCustomSectionResponse.header.entityName    |
      | ttl             |                                                             0 |
    And set updateGenericLayoutCustomSectionBody
      | path              |                                                        0 |
      | id                | createGenericLayoutCustomSectionResponse.header.entityId |
      | layoutType        | createGenericLayoutCustomSectionResponse.body.layoutType |
      | fieldsCollection  | fieldsCollection[3]                                      |
      | layoutCode        | createGenericLayoutCustomSectionResponse.body.layoutCode |
      | layoutDescription | faker.getDescription()                                   |
      | sectionType       | sectionType[0]                                           |
      | isActive          | faker.getRandomBoolean()                                 |
    And set updateGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | updateGenericLayoutCustomSectionCommandHeader[0] |
      | body   | updateGenericLayoutCustomSectionBody[0]          |
    And print updateGenericLayoutCustomSectionPayload
    And request updateGenericLayoutCustomSectionPayload
    When method POST
    Then status 201
    And def updateGenericLayoutCustomSectionResponse = response
    And print updateGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,updateGenericLayoutCustomSectionResponse.header.entityId)
    And print mongoResult
    And match mongoResult == updateGenericLayoutCustomSectionPayload.body.id
    And match  updateGenericLayoutCustomSectionPayload.body.layoutCode == updateGenericLayoutCustomSectionResponse.body.layoutCode
    And match  updateGenericLayoutCustomSectionPayload.body.layoutType == updateGenericLayoutCustomSectionResponse.body.layoutType
    And match  updateGenericLayoutCustomSectionPayload.body.isActive == updateGenericLayoutCustomSectionResponse.body.isActive
    And match  updateGenericLayoutCustomSectionPayload.body.id == updateGenericLayoutCustomSectionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutCustomSectionWithDuplicateData
  Scenario Outline: Create a custom generic layout code having duplicate data
    Given url commandBaseGenericLayout
    And path '/api/CreateGenericLayoutCustomSection'
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def duplicateResponse = result.response.body.id
    And print duplicateResponse
    And def result1 = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/getgenericCustomSection.feature@GetGenericLayoutCustomSectionMasterInfo') {genericCustomSectionid:'#(duplicateResponse)'}
    And def duplicateLayoutCode = result1.response.layoutCode
    #getting the generic layout master id
    And def entityIdData = dataGenerator.entityID()
    And set createGenericLayoutCustomSectionCommandHeader
      | path            |                                                         0 |
      | schemaUri       | schemaUri+"/CreateGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                   |
      | version         | "1.001"                                                   |
      | sourceId        | dataGenerator.SourceID()                                  |
      | tenantId        | <tenantid>                                                |
      | id              | dataGenerator.Id()                                        |
      | correlationId   | dataGenerator.correlationId()                             |
      | entityId        | entityIdData                                              |
      | commandUserId   | commandUserId                                             |
      | entityVersion   |                                                         1 |
      | tags            | []                                                        |
      | commandType     | commandType[0]                                            |
      | entityName      | entityName[0]                                             |
      | ttl             |                                                         0 |
    And set createGenericLayoutCustomSectionCommandBody
      | path              |                                 0 |
      | id                | entityIdData                      |
      | layoutType        | layoutType[0]                     |
      | fieldsCollection  | fieldsCollection[0]               |
      | layoutCode        | duplicateLayoutCode               |
      | layoutDescription | faker.getDescription()            |
      | longDescription   | faker.getRandomShortDescription() |
      | sectionType       | sectionType[0]                    |
      | isActive          | faker.getRandomBoolean()          |
    And set createGenericLayoutCustomSectionPayload
      | path   | [0]                                              |
      | header | createGenericLayoutCustomSectionCommandHeader[0] |
      | body   | createGenericLayoutCustomSectionCommandBody[0]   |
    And print createGenericLayoutCustomSectionPayload
    And request createGenericLayoutCustomSectionPayload
    When method POST
    Then status 400
    And def createGenericLayoutCustomSectionResponse = response
    And print createGenericLayoutCustomSectionResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
