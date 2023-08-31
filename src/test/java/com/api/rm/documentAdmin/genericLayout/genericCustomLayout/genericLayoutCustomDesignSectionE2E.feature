@GenericLayoutDesignCustomSectionE2E
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateLayoutDesignCustomSection_'
    And def genericLayoutNameCollectionNameRead = 'LayoutDesignCustomSectionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutCustomSection','UpdateGenericLayoutCustomSection', 'GetGenericLayoutCustomSection','GetLayoutDesignCustomSection']
    And def entityName = ['GenericLayoutCustomSection']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['LayoutDesignCustomSection','GenericLayoutCustomSection']

  @CreateandGetGenericLayoutCustomDesignSectionMarriageLicencewithAllfields
  Scenario Outline: Create a generic layout custom section Design Marriage licence with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithAllDetails')
    And def addgenericLayoutCustomDesignSectionResponse = result.response
    And print addgenericLayoutCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                                0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                          |
      | version         | "1.001"                                                          |
      | sourceId        | addgenericLayoutCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                       |
      | id              | addgenericLayoutCustomDesignSectionResponse.header.id            |
      | correlationId   | addgenericLayoutCustomDesignSectionResponse.header.correlationId |
      | commandUserId   | addgenericLayoutCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                               |
      | commandType     | commandType[3]                                                   |
      | getType         | "One"                                                            |
      | ttl             |                                                                0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                          0 |
      | sectionId | addgenericLayoutCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addgenericLayoutCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.sectionId == addgenericLayoutCustomDesignSectionResponse.body.sectionId
    And match getGenericLayoutCustomSectionResponse.fields[0].fieldCode == addgenericLayoutCustomDesignSectionResponse.body.fields[0].fieldCode
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And print evnentType
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomDesignSectionMarriageApplicationwithallfields
  Scenario Outline: Create a generic layout custom Design section Marriage Application with all the fields and get the data
    # Create Generic Layout design for Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateGenericLayoutDesignCustomSectionFieldsMarriageApplicationWithAllDetails')
    And def addgenericLayoutCustomDesignSectionResponse = result.response
    And print addgenericLayoutCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                                0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                          |
      | version         | "1.001"                                                          |
      | sourceId        | addgenericLayoutCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                       |
      | id              | addgenericLayoutCustomDesignSectionResponse.header.id            |
      | correlationId   | addgenericLayoutCustomDesignSectionResponse.header.correlationId |
      | commandUserId   | addgenericLayoutCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                               |
      | commandType     | commandType[3]                                                   |
      | getType         | "One"                                                            |
      | ttl             |                                                                0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                          0 |
      | sectionId | addgenericLayoutCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addgenericLayoutCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.sectionId == addgenericLayoutCustomDesignSectionResponse.body.sectionId
    And match getGenericLayoutCustomSectionResponse.fields[0].fieldCode == addgenericLayoutCustomDesignSectionResponse.body.fields[0].fieldCode
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId = getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutCustomSectionDeathCertificatewithallfields
  Scenario Outline: Create a generic layout custom section Death certificate with all the fields and get the data
    # Create Generic Layout Death Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomLayoutDesignSectionFieldsDeathCertificateWithAllDetails')
    And def addgenericLayoutCustomDesignSectionResponse = result.response
    And print addgenericLayoutCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api//GetLayoutDesignCustomSection'
    And set getgenericLayoutCustomDesignSectionCommandHeader
      | path            |                                                                0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                          |
      | version         | "1.001"                                                          |
      | sourceId        | addgenericLayoutCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                       |
      | id              | addgenericLayoutCustomDesignSectionResponse.header.id            |
      | correlationId   | addgenericLayoutCustomDesignSectionResponse.header.correlationId |
      | commandUserId   | addgenericLayoutCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                               |
      | commandType     | commandType[3]                                                   |
      | getType         | "One"                                                            |
      | ttl             |                                                                0 |
    And set getgenericLayoutCustomDesignSectionCommandBody
      | path      |                                                          0 |
      | sectionId | addgenericLayoutCustomDesignSectionResponse.body.sectionId |
    And set getgenericLayoutCustomDesignSectionPayload
      | path         | [0]                                                 |
      | header       | getgenericLayoutCustomDesignSectionCommandHeader[0] |
      | body.request | getgenericLayoutCustomDesignSectionCommandBody[0]   |
    And print getgenericLayoutCustomDesignSectionPayload
    And request getgenericLayoutCustomDesignSectionPayload
    When method POST
    Then status 200
    And def getgenericLayoutCustomDesignSectionResponse = response
    And print getgenericLayoutCustomDesignSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addgenericLayoutCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getgenericLayoutCustomDesignSectionResponse.id
    And match getgenericLayoutCustomDesignSectionResponse.sectionId == addgenericLayoutCustomDesignSectionResponse.body.sectionId
    And match getgenericLayoutCustomDesignSectionResponse.fields[0].fieldCode == addgenericLayoutCustomDesignSectionResponse.body.fields[0].fieldCode
    #HistoryValidation
    And def entityIdData = getgenericLayoutCustomDesignSectionResponse.id
    And def parentEntityId =  getgenericLayoutCustomDesignSectionResponse.sectionId
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetgenericLayoutCustomDesignSectionBirthCertificatewithallfields
  Scenario Outline: Create a generic layout custom section Birth certificate with all the fields and get the data
    # Create Generic Layout Birth Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomSectionFieldsBirthCertificateWithAllDetails')
    And def addgenericLayoutCustomDesignSectionResponse = result.response
    And print addgenericLayoutCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getgenericLayoutCustomDesignSectionCommandHeader
      | path            |                                                                0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                          |
      | version         | "1.001"                                                          |
      | sourceId        | addgenericLayoutCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                       |
      | id              | addgenericLayoutCustomDesignSectionResponse.header.id            |
      | correlationId   | addgenericLayoutCustomDesignSectionResponse.header.correlationId |
      | commandUserId   | addgenericLayoutCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                               |
      | commandType     | commandType[3]                                                   |
      | getType         | "One"                                                            |
      | ttl             |                                                                0 |
    And set getgenericLayoutCustomDesignSectionCommandBody
      | path      |                                                          0 |
      | sectionId | addgenericLayoutCustomDesignSectionResponse.body.sectionId |
    And set getgenericLayoutCustomDesignSectionPayload
      | path         | [0]                                                 |
      | header       | getgenericLayoutCustomDesignSectionCommandHeader[0] |
      | body.request | getgenericLayoutCustomDesignSectionCommandBody[0]   |
    And print getgenericLayoutCustomDesignSectionPayload
    And request getgenericLayoutCustomDesignSectionPayload
    When method POST
    Then status 200
    And def getgenericLayoutCustomDesignSectionResponse = response
    And print getgenericLayoutCustomDesignSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addgenericLayoutCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getgenericLayoutCustomDesignSectionResponse.id
    And match getgenericLayoutCustomDesignSectionResponse.sectionId == addgenericLayoutCustomDesignSectionResponse.body.sectionId
    And match getgenericLayoutCustomDesignSectionResponse.fields[0].fieldCode == addgenericLayoutCustomDesignSectionResponse.body.fields[0].fieldCode

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetgenericLayoutCustomDesignSectionMarriageLicencewithMandatoryDetails
  Scenario Outline: Create a generic layout custom design section Marriage Licence with all mandatory fields and get the data
    # Create Generic Layout Marriage Application
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithMandatoryFields')
    And def addgenericLayoutCustomDesignSectionResponse = result.response
    And print addgenericLayoutCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getgenericLayoutCustomDesignSectionCommandHeader
      | path            |                                                                0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"            |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                          |
      | version         | "1.001"                                                          |
      | sourceId        | addgenericLayoutCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                       |
      | id              | addgenericLayoutCustomDesignSectionResponse.header.id            |
      | correlationId   | addgenericLayoutCustomDesignSectionResponse.header.correlationId |
      | commandUserId   | addgenericLayoutCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                               |
      | commandType     | commandType[3]                                                   |
      | getType         | "One"                                                            |
      | ttl             |                                                                0 |
    And set getgenericLayoutCustomDesignSectionCommandBody
      | path      |                                                          0 |
      | sectionId | addgenericLayoutCustomDesignSectionResponse.body.sectionId |
    And set getgenericLayoutCustomDesignSectionPayload
      | path         | [0]                                                 |
      | header       | getgenericLayoutCustomDesignSectionCommandHeader[0] |
      | body.request | getgenericLayoutCustomDesignSectionCommandBody[0]   |
    And print getgenericLayoutCustomDesignSectionPayload
    And request getgenericLayoutCustomDesignSectionPayload
    When method POST
    Then status 200
    And def getgenericLayoutCustomDesignSectionResponse = response
    And print getgenericLayoutCustomDesignSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,addgenericLayoutCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == addgenericLayoutCustomDesignSectionResponse.body.id
    And match getgenericLayoutCustomDesignSectionResponse.sectionId == addgenericLayoutCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getgenericLayoutCustomDesignSectionResponse.id
    And def parentEntityId =  getgenericLayoutCustomDesignSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[0]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 1

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutDesignCustomSectionMarriageLicencewithallfields
  Scenario Outline: update a generic layout design custom section Marriage licence with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@UpdateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithAllDetails')
    And def updategenericLayoutDesignCustomDesignSectionResponse = result.response
    And print updategenericLayoutDesignCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getgenericLayoutCustomDesignSectionCommandHeader
      | path            |                                                                         0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"                     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                   |
      | version         | "1.001"                                                                   |
      | sourceId        | updategenericLayoutDesignCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                                |
      | id              | updategenericLayoutDesignCustomDesignSectionResponse.header.id            |
      | correlationId   | updategenericLayoutDesignCustomDesignSectionResponse.header.correlationId |
      | entityId        | updategenericLayoutDesignCustomDesignSectionResponse.header.entityId      |
      | commandUserId   | updategenericLayoutDesignCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                                        |
      | commandType     | commandType[3]                                                            |
      | getType         | "One"                                                                     |
      | ttl             |                                                                         0 |
    And set getgenericLayoutCustomDesignSectionCommandBody
      | path      |                                                                   0 |
      | sectionId | updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId |
    And set getgenericLayoutCustomDesignSectionPayload
      | path         | [0]                                                 |
      | header       | getgenericLayoutCustomDesignSectionCommandHeader[0] |
      | body.request | getgenericLayoutCustomDesignSectionCommandBody[0]   |
    And print getgenericLayoutCustomDesignSectionPayload
    And request getgenericLayoutCustomDesignSectionPayload
    When method POST
    Then status 200
    And def getgenericLayoutCustomDesignSectionResponse = response
    And print getgenericLayoutCustomDesignSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updategenericLayoutDesignCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updategenericLayoutDesignCustomDesignSectionResponse.body.id
    And match getgenericLayoutCustomDesignSectionResponse.sectionId == updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getgenericLayoutCustomDesignSectionResponse.id
    And def parentEntityId =  getgenericLayoutCustomDesignSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutDesignCustomSectionDeathCertificatewithallfields
  Scenario Outline: Update a generic layout custom section Death Certificate with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@UpdateCustomSectionDesignFieldsDeathCertificateWithAllDetails')
    And def updategenericLayoutDesignCustomDesignSectionResponse = result.response
    And print updategenericLayoutDesignCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                                         0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"                     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                   |
      | version         | "1.001"                                                                   |
      | sourceId        | updategenericLayoutDesignCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                                |
      | id              | updategenericLayoutDesignCustomDesignSectionResponse.header.id            |
      | correlationId   | updategenericLayoutDesignCustomDesignSectionResponse.header.correlationId |
      | entityId        | updategenericLayoutDesignCustomDesignSectionResponse.header.entityId      |
      | commandUserId   | updategenericLayoutDesignCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                                        |
      | commandType     | commandType[3]                                                            |
      | getType         | "One"                                                                     |
      | ttl             |                                                                         0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                                   0 |
      | sectionId | updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updategenericLayoutDesignCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.sectionId == updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId =  getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomDesignSectionBirthCertificatewithallfields
  Scenario Outline: Update a generic layout custom section Birth Certificate with all the fields and get the data
    # Create Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@UpdateCustomDesinSectionFieldsBirthCertificateWithAllDetails ')
    And def updateLayoutDesignCustomSectionResponse = result.response
    And print updateLayoutDesignCustomSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                            0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                      |
      | version         | "1.001"                                                      |
      | sourceId        | updateLayoutDesignCustomSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                   |
      | id              | updateLayoutDesignCustomSectionResponse.header.id            |
      | correlationId   | updateLayoutDesignCustomSectionResponse.header.correlationId |
      | entityId        | updateLayoutDesignCustomSectionResponse.header.entityId      |
      | commandUserId   | updateLayoutDesignCustomSectionResponse.header.commandUserId |
      | tags            | []                                                           |
      | commandType     | commandType[3]                                               |
      | getType         | "One"                                                        |
      | ttl             |                                                            0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                      0 |
      | sectionId | updateLayoutDesignCustomSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updateLayoutDesignCustomSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.sectionId == updateLayoutDesignCustomSectionResponse.body.id
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId =  getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomSectionMarriageLicencewithMandatoryDetails
  Scenario Outline: Update and get a generic layout custom section Marriage licence with mandatory details
    # Update and get Generic Layout Marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@UpdateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithMandatoryDetails')
    And def updategenericLayoutDesignCustomDesignSectionResponse = result.response
    And print updategenericLayoutDesignCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomDesignSectionCommandHeader
      | path            |                                                                         0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"                     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                   |
      | version         | "1.001"                                                                   |
      | sourceId        | updategenericLayoutDesignCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                                |
      | id              | updategenericLayoutDesignCustomDesignSectionResponse.header.id            |
      | correlationId   | updategenericLayoutDesignCustomDesignSectionResponse.header.correlationId |
      | entityId        | updategenericLayoutDesignCustomDesignSectionResponse.header.entityId      |
      | commandUserId   | updategenericLayoutDesignCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                                        |
      | commandType     | commandType[3]                                                            |
      | getType         | "One"                                                                     |
      | ttl             |                                                                         0 |
    And set getGenericLayoutCustomDesignSectionCommandBody
      | path      |                                                                   0 |
      | sectionId | updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomDesignSectionPayload
      | path         | [0]                                                 |
      | header       | getGenericLayoutCustomDesignSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomDesignSectionCommandBody[0]   |
    And print getGenericLayoutCustomDesignSectionPayload
    And request getGenericLayoutCustomDesignSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionDesignResponse = response
    And print getGenericLayoutCustomSectionDesignResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionDesignResponse.sectionId
    And match getGenericLayoutCustomSectionDesignResponse.sectionId == updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionDesignResponse.id
    And def parentEntityId =  getGenericLayoutCustomSectionDesignResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |


  @UpdateandGetGenericLayoutDesignCustomSectionDeathCertificatewithMandatoryDetails
  Scenario Outline: Update and get generic layout custom section Death Certificate with mandatory details
    # Update and get Generic Layout Death certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@UpdateCustomSectionDesignFieldsDeathCertificateWithMandatoryDetails')
    And def updategenericLayoutDesignCustomDesignSectionResponse = result.response
    And print updategenericLayoutDesignCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                                         0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"                     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                   |
      | version         | "1.001"                                                                   |
      | sourceId        | updategenericLayoutDesignCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                                |
      | id              | updategenericLayoutDesignCustomDesignSectionResponse.header.id            |
      | correlationId   | updategenericLayoutDesignCustomDesignSectionResponse.header.correlationId |
      | entityId        | updategenericLayoutDesignCustomDesignSectionResponse.header.entityId      |
      | commandUserId   | updategenericLayoutDesignCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                                        |
      | commandType     | commandType[3]                                                            |
      | getType         | "One"                                                                     |
      | ttl             |                                                                         0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                                   0 |
      | sectionId | updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomDesignSectionResponse = response
    And print getGenericLayoutCustomDesignSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updategenericLayoutDesignCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updategenericLayoutDesignCustomDesignSectionResponse.body.id
    And match getGenericLayoutCustomDesignSectionResponse.sectionId == updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomDesignSectionResponse.id
    And def parentEntityId = getGenericLayoutCustomDesignSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomDesignSectionResponse.id
    And def parentEntityId =  getGenericLayoutCustomDesignSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutCustomDesignSectionBirthCertificatewithMandatoryDetails
  Scenario Outline: Update and get generic layout custom section Birth Certificate with mandatory fields
    # Update and get Generic Birth certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@UpdateCustomDesinSectionFieldsBirthCertificateWithMandatory')
    And def updategenericLayoutDesignCustomDesignSectionResponse = result.response
    And print updategenericLayoutDesignCustomDesignSectionResponse
    Given url readBaseGenericLayout
    And path '/api/GetLayoutDesignCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                                         0 |
      | schemaUri       | schemaUri+"/GetLayoutDesignCustomSection-v1.001.json"                     |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                   |
      | version         | "1.001"                                                                   |
      | sourceId        | updategenericLayoutDesignCustomDesignSectionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                                |
      | id              | updategenericLayoutDesignCustomDesignSectionResponse.header.id            |
      | correlationId   | updategenericLayoutDesignCustomDesignSectionResponse.header.correlationId |
      | entityId        | updategenericLayoutDesignCustomDesignSectionResponse.header.entityId      |
      | commandUserId   | updategenericLayoutDesignCustomDesignSectionResponse.header.commandUserId |
      | tags            | []                                                                        |
      | commandType     | commandType[3]                                                            |
      | getType         | "One"                                                                     |
      | ttl             |                                                                         0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path      |                                                                   0 |
      | sectionId | updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200
    And def getGenericLayoutCustomSectionResponse = response
    And print getGenericLayoutCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,genericLayoutNameCollectionNameRead+<tenantid>,updategenericLayoutDesignCustomDesignSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == getGenericLayoutCustomSectionResponse.id
    And match getGenericLayoutCustomSectionResponse.sectionId == updategenericLayoutDesignCustomDesignSectionResponse.body.sectionId
    #HistoryValidation
    And def entityIdData = getGenericLayoutCustomSectionResponse.id
    And def parentEntityId =  getGenericLayoutCustomSectionResponse.id
    And def eventName = eventTypes[0]+historyAndComments[1]
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'} {parentEntityId : '#(parentEntityId)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount
    And match getHistoryResponseCount == 2

    Examples: 
      | tenantid    |
      | tenantID[0] |
