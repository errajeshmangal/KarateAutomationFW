@PropertyInformationE2EFeature
Feature: Create a Property Information Subdivision/Condo/Land

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def createPropertyInfoSubCollectionName = 'CreatePropertyInformationSubdivision_'
    And def createPropertyInfoCondoCollectionName = 'CreatePropertyInformationCondo_'
    And def createPropertyInfoLandCollectionName = 'CreatePropertyInformationLand_'
    And def createPropertyInfoSubCollectionNameRead = 'PropertyInformationSubdivisionDetailViewModel_'
    And def createPropertyInfoCondoCollectionNameRead = 'PropertyInformationCondoDetailViewModel_'
    And def createPropertyInfoLandCollectionNameRead = 'PropertyInformationLandDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def propertyType = ['Subdivision', 'Condo','Land']
    And def createCommandType = ['CreatePropertyInformationSubdivision','CreatePropertyInformationCondo','CreatePropertyInformationLand']
    And def updateCommandType = ['UpdatePropertyInformationSubdivision','UpdatePropertyInformationCondo','UpdatePropertyInformationLand']
    And def getCommandType = ['GetPropertyInformationSubdivision','GetPropertyInformationCondo','GetPropertyInformationLand','GetSubdivisionInformationsIdCodeName','GetCondoMaintenancesIdCodeName','GetAreaMaintenancesIdCodeName']
    And def getAllCommandType = 'GetPropertyInformations'
    And def entityName = ['PropertyInformationSubdivision','PropertyInformationCondo','PropertyInformationLand']
    And def SDcollectionNameRead = 'SubdivisionInformationDetailViewModel_'
    And def condoMaintenanceCollectionNameRead = 'CondoMaintenanceDetailViewModel_'
    And def areaMaintenanceCollectionNameRead = 'AreaMaintenanceDetailViewModel_'
    And def createPropertyInfosCollectionNameRead = 'PropertyInformationsDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    
  @CreatePropertyInformationSubDivisionWithAllDetails
  Scenario Outline: Create property information subdivision with all the fields
    Given url commandBaseUrl
    And path '/api/CreatePropertyInformationSubdivision'
    #creating a new subdivision info then validating the created id is present in GetSubdivisionInformationsIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchSubDivisionInformation')
    And def getSearchSubDivisionInformantionResponse = result.response
    And print getSearchSubDivisionInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetSubDivisionInformation')
    And def getSubDivisionInformantionResponse = result.response
    And print getSubDivisionInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationSubDivisionHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationSubdivision-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | createCommandType[0]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | entityVersion   |                                                             1 |
      | entityId        | entityIDData                                                  |
      | commandUserId   | commandUserId                                                 |
      | entityName      | entityName[0]                                                 |
    And set commandPropertyInformationSubDivisionBody
      | path            |                                                 0 |
      | id              | entityIDData                                      |
      | propertyType    | propertyType[0]                                   |
      | status          | faker.getRandomPropertyInformationStatus()        |
      | pin             | faker.getRandomPin("Pin")                         |
      | pinToBeAssigned | faker.getRandomBoolean()                          |
      | areaCode        | getSubDivisionInformantionResponse.areaCode.code  |
      | townCode        | getSubDivisionInformantionResponse.townCode       |
      | range           | getSubDivisionInformantionResponse.range          |
      | rangeDirection  | getSubDivisionInformantionResponse.rangeDirection |
      | block           | faker.getFirstName()                              |
      | lot             | faker.getRandomPin("Lot")                         |
      | part            | faker.getFirstName()                              |
      | townHomeAddress | faker.getFirstName()                              |
      | notInSidwell    | faker.getFirstName()                              |
      | isActive        | faker.getRandomBoolean()                          |
    And set commandPropertyInformationSubDivisionName
      | path |                                                        0 |
      | id   | getSearchSubDivisionInformantionResponse.results[0].id   |
      | code | getSearchSubDivisionInformantionResponse.results[0].code |
      | name | getSearchSubDivisionInformantionResponse.results[0].name |
    And set addPropertyInformationSubDivisionPayload
      | path      | [0]                                            |
      | header    | commandPropertyInformationSubDivisionHeader[0] |
      | body      | commandPropertyInformationSubDivisionBody[0]   |
      | body.name | commandPropertyInformationSubDivisionName[0]   |
    And print addPropertyInformationSubDivisionPayload
    And request addPropertyInformationSubDivisionPayload
    When method POST
    Then status 201
    And def addPropertyInformationSubDivisionResponse = response
    And print addPropertyInformationSubDivisionResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoSubCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationSubDivisionResponse.body.id
    And match addPropertyInformationSubDivisionResponse.body.pin == addPropertyInformationSubDivisionPayload.body.pin

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationSubdivisonWithMandatoryDetails
  Scenario Outline: Create property information subdivision with mandatory fields
    Given url commandBaseUrl
    And path '/api/CreatePropertyInformationSubdivision'
    #creating a new subdivision info then validating the created id is present in GetSubdivisionInformationsIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchSubDivisionInformation')
    And def getSearchSubDivisionInformantionResponse = result.response
    And print getSearchSubDivisionInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetSubDivisionInformation')
    And def getSubDivisionInformantionResponse = result.response
    And print getSubDivisionInformantionResponse
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationSubdivisonHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationSubdivision-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | createCommandType[0]                                          |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | entityVersion   |                                                             1 |
      | entityId        | entityIDData                                                  |
      | commandUserId   | commandUserId                                                 |
      | entityName      | entityName[0]                                                 |
    And set commandPropertyInformationSubdivisonBody
      | path            |                                                 0 |
      | id              | entityIDData                                      |
      | propertyType    | propertyType[0]                                   |
      | status          | faker.getRandomPropertyInformationStatus()        |
      | pin             | faker.getRandomPin("Pin")                         |
      | pinToBeAssigned | faker.getRandomBoolean()                          |
      | areaCode        | getSubDivisionInformantionResponse.areaCode.code  |
      | townCode        | getSubDivisionInformantionResponse.townCode       |
      | range           | getSubDivisionInformantionResponse.range          |
      | rangeDirection  | getSubDivisionInformantionResponse.rangeDirection |
      | block           | faker.getFirstName()                              |
      | lot             | faker.getRandomPin("Lot")                         |
      | isActive        | faker.getRandomBoolean()                          |
    And set commandPropertyInformationSubdivisonName
      | path |                                                        0 |
      | id   | getSearchSubDivisionInformantionResponse.results[0].id   |
      | code | getSearchSubDivisionInformantionResponse.results[0].code |
      | name | getSearchSubDivisionInformantionResponse.results[0].name |
    And set addPropertyInformationSubdivisonPayload
      | path      | [0]                                           |
      | header    | commandPropertyInformationSubdivisonHeader[0] |
      | body      | commandPropertyInformationSubdivisonBody[0]   |
      | body.name | commandPropertyInformationSubdivisonName[0]   |
    And print addPropertyInformationSubdivisonPayload
    And request addPropertyInformationSubdivisonPayload
    When method POST
    Then status 201
    And def addPropertyInformationSubdivisonResponse = response
    And print addPropertyInformationSubdivisonResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoSubCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationSubdivisonResponse.body.id
    And match addPropertyInformationSubdivisonResponse.body.pin == addPropertyInformationSubdivisonPayload.body.pin

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoWithAllDetails
  Scenario Outline: Create property information condo with  all the fields and property type as Condo
    Given url commandBaseUrl
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And path '/api/CreatePropertyInformationCondo'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationCondoHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    And set commandPropertyInformationCondoBody
      | path            |                                           0 |
      | id              | entityIDData                                |
      | propertyType    | propertyType[1]                             |
      | status          | faker.getRandomPropertyInformationStatus()  |
      | pin             | faker.getRandomPin("Pin")                   |
      | pinToBeAssigned | faker.getRandomBoolean()                    |
      | areaCode        | getCondoInformantionResponse.areaCode.code  |
      | townCode        | getCondoInformantionResponse.townCode       |
      | range           | getCondoInformantionResponse.range          |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection |
      | building        | faker.getFirstName()                        |
      | buildingUnit    | faker.getRandomPin("Lot")                   |
      | phase           | faker.getFirstName()                        |
      | garage          | faker.getRandomPin("Lot")                   |
      | notInSidwell    | faker.getFirstName()                        |
      | isActive        | faker.getRandomBoolean()                    |
    And set commandPropertyInformationCondoName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set addPropertyInformationCondoPayload
      | path      | [0]                                      |
      | header    | commandPropertyInformationCondoHeader[0] |
      | body      | commandPropertyInformationCondoBody[0]   |
      | body.name | commandPropertyInformationCondoName[0]   |
    And print addPropertyInformationCondoPayload
    And request addPropertyInformationCondoPayload
    When method POST
    Then status 201
    And def addPropertyInformationCondoResponse = response
    And print addPropertyInformationCondoResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoCondoCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationCondoResponse.body.id
    And match addPropertyInformationCondoResponse.body.pin == addPropertyInformationCondoPayload.body.pin
    And match addPropertyInformationCondoResponse.body.isActive == addPropertyInformationCondoPayload.body.isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationCondoWithMandatoryDetails
  Scenario Outline: Create property information condo with mandatory fields
    Given url commandBaseUrl
    #creating a new condo info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndGetCondoInformation')
    And def getSearchCondoInformantionResponse = result.response
    And print getSearchCondoInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCondoMaintenance')
    And def getCondoInformantionResponse = result.response
    And print getCondoInformantionResponse
    And path '/api/CreatePropertyInformationCondo'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationCondoHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationCondo-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantID        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | createCommandType[1]                                    |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | entityVersion   |                                                       1 |
      | entityID        | entityIDData                                            |
      | commandUserId   | commandUserId                                           |
      | entityName      | entityName[1]                                           |
    And set commandPropertyInformationCondoBody
      | path            |                                           0 |
      | id              | entityIDData                                |
      | propertyType    | propertyType[1]                             |
      | status          | faker.getRandomPropertyInformationStatus()  |
      | pin             | faker.getRandomPin("Pin")                   |
      | pinToBeAssigned | faker.getRandomBoolean()                    |
      | areaCode        | getCondoInformantionResponse.areaCode.code  |
      | townCode        | getCondoInformantionResponse.townCode       |
      | range           | getCondoInformantionResponse.range          |
      | rangeDirection  | getCondoInformantionResponse.rangeDirection |
      | building        | faker.getFirstName()                        |
      | buildingUnit    | faker.getRandomPin("Lot")                   |
      | isActive        | faker.getRandomBoolean()                    |
    And set commandPropertyInformationCondoName
      | path |                                                  0 |
      | id   | getSearchCondoInformantionResponse.results[0].id   |
      | code | getSearchCondoInformantionResponse.results[0].code |
      | name | getSearchCondoInformantionResponse.results[0].name |
    And set addPropertyInformationCondoPayload
      | path      | [0]                                      |
      | header    | commandPropertyInformationCondoHeader[0] |
      | body      | commandPropertyInformationCondoBody[0]   |
      | body.name | commandPropertyInformationCondoName[0]   |
    And print addPropertyInformationCondoPayload
    And request addPropertyInformationCondoPayload
    When method POST
    Then status 201
    And def addPropertyInformationCondoResponse = response
    And print addPropertyInformationCondoResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoCondoCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationCondoResponse.body.id
    And match addPropertyInformationCondoResponse.body.pin == addPropertyInformationCondoPayload.body.pin

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationLandWithAllDetails
  Scenario Outline: Create property information Land with  all the fields and property type as Section/Land/Acreage
    Given url commandBaseUrl
    #creating a new Land info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchLandInformation')
    And def getSearchLandInformantionResponse = result.response
    And print getSearchLandInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCountyMaintenance')
    And def getLandInformantionResponse = result.response
    And print getLandInformantionResponse
    And path '/api/CreatePropertyInformationLand'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationLandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationLand-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantID        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | createCommandType[2]                                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | entityVersion   |                                                      1 |
      | entityID        | entityIDData                                           |
      | commandUserId   | commandUserId                                          |
      | entityName      | entityName[2]                                          |
    And set commandPropertyInformationLandBody
      | path            |                                          0 |
      | id              | entityIDData                               |
      | propertyType    | propertyType[2]                            |
      | status          | faker.getRandomPropertyInformationStatus() |
      | pin             | faker.getRandomPin("Pin")                  |
      | pinToBeAssigned | faker.getRandomBoolean()                   |
      | areaCode        | getLandInformantionResponse.areaCode       |
      | townCode        | getLandInformantionResponse.townCode       |
      | range           | getLandInformantionResponse.range          |
      | rangeDirection  | getLandInformantionResponse.rangeDirection |
      | part1           | faker.getFirstName()                       |
      | part2           | faker.getFirstName()                       |
      | thirdQtr        | faker.getFirstName()                       |
      | secondQtr       | faker.getFirstName()                       |
      | firstQtr        | faker.getFirstName()                       |
      | numofAcreage    | faker.getRandomNumber()                    |
      | section         | faker.getFirstName()                       |
      | half            | faker.getFirstName()                       |
      | quarters        | faker.getFirstName()                       |
      | notInSidwell    | faker.getFirstName()                       |
      | isActive        | faker.getRandomBoolean()                   |
    And set commandPropertyInformationLandName
      | path |                                                 0 |
      | id   | getSearchLandInformantionResponse.results[0].id   |
      | code | getSearchLandInformantionResponse.results[0].code |
      | name | getSearchLandInformantionResponse.results[0].name |
    And set addPropertyInformationLandPayload
      | path      | [0]                                     |
      | header    | commandPropertyInformationLandHeader[0] |
      | body      | commandPropertyInformationLandBody[0]   |
      | body.name | commandPropertyInformationLandName[0]   |
    And print addPropertyInformationLandPayload
    And request addPropertyInformationLandPayload
    When method POST
    Then status 201
    And def addPropertyInformationLandResponse = response
    And print addPropertyInformationLandResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoLandCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationLandResponse.body.id
    And match addPropertyInformationLandResponse.body.pin == addPropertyInformationLandPayload.body.pin
    And match addPropertyInformationLandResponse.body.thirdQtr == addPropertyInformationLandPayload.body.thirdQtr
    And match addPropertyInformationLandResponse.body.secondQtr == addPropertyInformationLandPayload.body.secondQtr
    And match addPropertyInformationLandResponse.body.firstQtr == addPropertyInformationLandPayload.body.firstQtr

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreatePropertyInformationLandWithMandatoryDetails
  Scenario Outline: Create property information Land with  mandatory fields
    Given url commandBaseUrl
    #creating a new Land info then validating the created id is present in GetCondoMaintenancesIdCodeName
    And def result = call read('CreatePropertyInformation.feature@CreateAndSearchLandInformation')
    And def getSearchLandInformantionResponse = result.response
    And print getSearchLandInformantionResponse
    #calling the single get API
    And def result = call read('CreatePropertyInformation.feature@GetCountyMaintenance')
    And def getLandInformantionResponse = result.response
    And print getLandInformantionResponse
    And path '/api/CreatePropertyInformationLand'
    And def entityIDData = dataGenerator.entityID()
    And set commandPropertyInformationLandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/CreatePropertyInformationLand-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantID        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | createCommandType[2]                                   |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | entityVersion   |                                                      1 |
      | entityID        | entityIDData                                           |
      | commandUserId   | commandUserId                                          |
      | entityName      | entityName[2]                                          |
    And set commandPropertyInformationLandBody
      | path            |                                          0 |
      | id              | entityIDData                               |
      | propertyType    | propertyType[2]                            |
      | status          | faker.getRandomPropertyInformationStatus() |
      | pin             | faker.getRandomPin("Pin")                  |
      | pinToBeAssigned | faker.getRandomBoolean()                   |
      | areaCode        | getLandInformantionResponse.areaCode       |
      | townCode        | getLandInformantionResponse.townCode       |
      | range           | getLandInformantionResponse.range          |
      | rangeDirection  | getLandInformantionResponse.rangeDirection |
      | part1           | faker.getFirstName()                       |
      | part2           | faker.getFirstName()                       |
      | isActive        | faker.getRandomBoolean()                   |
    And set commandPropertyInformationLandName
      | path |                                                 0 |
      | id   | getSearchLandInformantionResponse.results[0].id   |
      | code | getSearchLandInformantionResponse.results[0].code |
      | name | getSearchLandInformantionResponse.results[0].name |
    And set addPropertyInformationLandPayload
      | path      | [0]                                     |
      | header    | commandPropertyInformationLandHeader[0] |
      | body      | commandPropertyInformationLandBody[0]   |
      | body.name | commandPropertyInformationLandName[0]   |
    And print addPropertyInformationLandPayload
    And request addPropertyInformationLandPayload
    When method POST
    Then status 201
    And def addPropertyInformationLandResponse = response
    And print addPropertyInformationLandResponse
    And sleep(5000)
    And def mongoResult = mongoData.MongoDBReader(dbname,createPropertyInfoLandCollectionName+<tenantid>,entityIDData)
    And print mongoResult
    And match mongoResult == addPropertyInformationLandResponse.body.id
    And match addPropertyInformationLandResponse.body.pin == addPropertyInformationLandPayload.body.pin

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndSearchSubDivisionInformation
  Scenario Outline: Create a subdivision information and search
    Given url readBaseUrl
    #And def result = call read('classpath:com/api/rm/documentAdmin/subDivision/subDivision.feature@CreateSubDivisionWithAllDetails')
    #And def addsubDivisionResponse = result.response
    #And print addsubDivisionResponse
    When path '/api/GetSubdivisionInformationsIdCodeName'
    And sleep(10000)
    And set getSubdivisionInformationsIdCodeNameCommandHeader
      | path            |                                                             0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformationsIdCodeName-v1.001.json" |
      | version         | "1.001"                                                       |
      | sourceId        | dataGenerator.SourceID()                                      |
      | id              | dataGenerator.Id()                                            |
      | correlationId   | dataGenerator.correlationId()                                 |
      | tenantId        | <tenantid>                                                    |
      | ttl             |                                                             0 |
      | commandType     | getCommandType[3]                                             |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                       |
      | tags            | []                                                            |
      | commandUserId   | dataGenerator.commandUserId()                                 |
      | getType         | "Array"                                                       |
    And set getSubdivisionInformationsIdCodeNameCommandBody
      | path     |                                    0 |
      | isActive | true |
      #| isActive | addsubDivisionResponse.body.isActive |
    And set getSubdivisionInformationsIdCodeNameCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false              |
    And set getSubdivisionInformationsIdCodeNamePayload
      | path                | [0]                                                      |
      | header              | getSubdivisionInformationsIdCodeNameCommandHeader[0]     |
      | body.request        | getSubdivisionInformationsIdCodeNameCommandBody[0]       |
      | body.paginationSort | getSubdivisionInformationsIdCodeNameCommandPagination[0] |
    And print getSubdivisionInformationsIdCodeNamePayload
    And request getSubdivisionInformationsIdCodeNamePayload
    When method POST
    Then status 200
    And sleep(20000)
    And def getSubdivisionInformationsIdCodeNameResponse = response
    And print getSubdivisionInformationsIdCodeNameResponse
    #And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,addsubDivisionResponse.body.id)
    #And print mongoResult
    #And match each getSubdivisionInformationsIdCodeNameResponse.results[*].isActive == addsubDivisionResponse.body.isActive
    #And match getSubdivisionInformationsIdCodeNameResponse.results[*].id contains addsubDivisionResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetSubDivisionInformation
  Scenario Outline: Get the  subdivison information
    Given url readBaseUrl
    #GetSubDivision
    And path '/api/GetSubdivisionInformation'
    And set getSubdivisionInformationCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/GetSubdivisionInformation-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.SourceID()                           |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.correlationId()                      |
      | tenantId        | <tenantid>                                         |
      | commandUserId   | dataGenerator.commandUserId()                      |
      | tags            | []                                                 |
      | commandType     | "GetSubdivisionInformation"                        |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getSubdivisionInformationCommandBody
      | path       |                                                      0 |
      | request.id | getSearchSubDivisionInformantionResponse.results[0].id |
    And set getSubdivisionInformationPayload
      | path   | [0]                                       |
      | header | getSubdivisionInformationCommandHeader[0] |
      | body   | getSubdivisionInformationCommandBody[0]   |
    And print getSubdivisionInformationPayload
    And sleep(15000)
    And request getSubdivisionInformationPayload
    When method POST
    Then status 200
    And def getSubdivisionInformationResponse = response
    And print getSubdivisionInformationResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,SDcollectionNameRead+<tenantid>,getSearchSubDivisionInformantionResponse.results[0].id)
    And print mongoResult

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndGetCondoInformation
  Scenario Outline: Create a condo information and get the details
    Given url readBaseUrl
    #And def result = call read('classpath:com/api/rm/documentAdmin/condoMaintenance/CreateCondoMaintenance.feature@CreateCondoMaintenance')
    #And def addCondoResponse = result.response
    #And print addCondoResponse
    When path '/api/GetCondoMaintenancesIdCodeName'
    And sleep(10000)
    And set getCondoMaintenancesIdCodeNameCommandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenancesIdCodeName-v1.001.json" |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | tenantId        | <tenantid>                                              |
      | ttl             |                                                       0 |
      | commandType     | getCommandType[4]                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | tags            | []                                                      |
      | commandUserId   | dataGenerator.commandUserId()                           |
      | getType         | "Array"                                                 |
    And set getCondoMaintenancesIdCodeNameCommandBody
      | path     |                              0 |
      | isActive | true |
      #| isActive | addCondoResponse.body.isActive |
    And set getPropertyInformationCondoCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getCondoMaintenancesIdCodeNamePayload
      | path                | [0]                                             |
      | header              | getCondoMaintenancesIdCodeNameCommandHeader[0]  |
      | body.request        | getCondoMaintenancesIdCodeNameCommandBody[0]    |
      | body.paginationSort | getPropertyInformationCondoCommandPagination[0] |
    And print getCondoMaintenancesIdCodeNamePayload
    And request getCondoMaintenancesIdCodeNamePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getCondoMaintenancesIdCodeNameResponse = response
    And print getCondoMaintenancesIdCodeNameResponse
    #And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,addCondoResponse.body.id)
    #And print mongoResult
    #And match mongoResult == addCondoResponse.body.id
    #And match each getCondoMaintenancesIdCodeNameResponse.results[*].isActive == addCondoResponse.body.isActive
    #And match getCondoMaintenancesIdCodeNameResponse.results[*].id contains addCondoResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetCondoMaintenance
  Scenario Outline: Get the condo Maintenance
    Given url readBaseUrl
    And path '/api/GetCondoMaintenance'
    And set getCountyCondoMaintenanceCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/GetCondoMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | tenantId        | <tenantid>                                   |
      | commandUserId   | dataGenerator.commandUserId()                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | "GetCondoMaintenance"                        |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getCountyCondoMaintenanceCommandBody
      | path |                                                0 |
      | id   | getSearchCondoInformantionResponse.results[0].id |
    And set getCountyCondoMaintenancePayload
      | path         | [0]                                       |
      | header       | getCountyCondoMaintenanceCommandHeader[0] |
      | body.request | getCountyCondoMaintenanceCommandBody[0]   |
    And print getCountyCondoMaintenancePayload
    And request getCountyCondoMaintenancePayload
    When method POST
    Then status 200
    And def getCountyCondoMaintenanceResponse = response
    And print getCountyCondoMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,condoMaintenanceCollectionNameRead+<tenantid>,getSearchCondoInformantionResponse.results[0].id)
    And print mongoResult

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateAndSearchLandInformation
  Scenario Outline: Create a Land information and search
    Given url readBaseUrl
    #And def result = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@CreateAreaMaintenance')
    #And def addAreaMaintenanceResponse = result.response
    When path '/api/GetAreaMaintenancesIdCodeName'
    And sleep(10000)
    And set getAreaMaintenancesIdCodeNameCommandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenancesIdCodeName-v1.001.json" |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.SourceID()                               |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.correlationId()                          |
      | tenantId        | <tenantid>                                             |
      | ttl             |                                                      0 |
      | commandType     | getCommandType[5]                                      |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | tags            | []                                                     |
      | commandUserId   | dataGenerator.commandUserId()                          |
      | getType         | "Array"                                                |
    And set getAreaMaintenancesIdCodeNameCommandBody
      | path     |                                        0 |
      #| isActive | addAreaMaintenanceResponse.body.isActive |
      |isActive | true |
    And set getAreaMaintenancesIdCodeNameCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getAreaMaintenancesIdCodeNamePayload
      | path                | [0]                                               |
      | header              | getAreaMaintenancesIdCodeNameCommandHeader[0]     |
      | body.request        | getAreaMaintenancesIdCodeNameCommandBody[0]       |
      | body.paginationSort | getAreaMaintenancesIdCodeNameCommandPagination[0] |
    And print getAreaMaintenancesIdCodeNamePayload
    And request getAreaMaintenancesIdCodeNamePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getAreaMaintenancesIdCodeNameResponse = response
    And print getAreaMaintenancesIdCodeNameResponse
    #And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,addAreaMaintenanceResponse.body.id)
    #And print mongoResult
    #And match mongoResult == addAreaMaintenanceResponse.body.id
    #And match each getAreaMaintenancesIdCodeNameResponse.results[*].isActive == addAreaMaintenanceResponse.body.isActive
    #And match getAreaMaintenancesIdCodeNameResponse.results[*].id contains addAreaMaintenanceResponse.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetCountyMaintenance
  Scenario Outline: Get County Area Maintenance
    Given url readBaseUrl
    And path '/api/GetAreaMaintenance'
    And set getCountyAreaMaintenanceCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/GetAreaMaintenance-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | "GetAreaMaintenance"                        |
      | getType         | "One"                                       |
      | ttl             |                                           0 |
    And set getCountyAreaMaintenanceCommandBody
      | path |                                               0 |
      | id   | getSearchLandInformantionResponse.results[0].id |
    And set getCountyAreaMaintenancePayload
      | path         | [0]                                      |
      | header       | getCountyAreaMaintenanceCommandHeader[0] |
      | body.request | getCountyAreaMaintenanceCommandBody[0]   |
    And print getCountyAreaMaintenancePayload
    And request getCountyAreaMaintenancePayload
    When method POST
    Then status 200
    And def getCountyAreaMaintenanceResponse = response
    And print getCountyAreaMaintenanceResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,areaMaintenanceCollectionNameRead+<tenantid>,getSearchLandInformantionResponse.results[0].id)
    And print mongoResult

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
    # storing the name object values
    #And def foundAt = []
    #And def fun = function(x, i){ if (x.id ==  addsubDivisionResponse.body.id  ) karate.appendTo(foundAt, i) }
    #And eval karate.forEach(getSubdivisionInformationsIdCodeNameResponse.results, fun)
    #And print foundAt
    #And def searchId = getSubdivisionInformationsIdCodeNameResponse.results[foundAt].id
    #And def searchCode = getSubdivisionInformationsIdCodeNameResponse.results[foundAt].code
    #And def searchName = getSubdivisionInformationsIdCodeNameResponse.results[foundAt].name
    #And def val = dataGenerator.setValue(searchId,searchCode,searchName)
