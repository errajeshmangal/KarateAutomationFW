@SubDivisionInformation
Feature: SubDivision - Add , Update ,get , getall

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def collectionname = 'CreateSubdivisionInformation_'
    And def collectionNameRead = 'SubdivisionInformationDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateSubDivisionWithAllDetails
  Scenario Outline: Create a SubDisivion info with all the fields and Get the details
    Given url commandBaseUrl
    And path '/api/CreateSubdivisionInformation'
    And def entityIdData = dataGenerator.entityID()
    #Create Area Maintenace to update Area code
    And def areaCodeResult = call read('classpath:com/api/rm/documentAdmin/areaMaintenance/CreateAreaMaintenance.feature@CreateAreaMaintenance')
    And def createAreaMaintenanceResponse = areaCodeResult.response
    And print createAreaMaintenanceResponse
    And set commandSubDivisionHeader
      | path            |                                                     0 |
      | schemaUri       | schemaUri+"/CreateSubdivisionInformation-v1.001.json" |
      | version         | "1.001"                                               |
      | sourceId        | dataGenerator.SourceID()                              |
      | id              | dataGenerator.Id()                                    |
      | correlationId   | dataGenerator.correlationId()                         |
      | tenantId        | <tenantid>                                            |
      | ttl             |                                                     0 |
      | commandType     | "CreateSubdivisionInformation"                        |
      | commandDateTime | dataGenerator.generateCurrentDateTime()               |
      | tags            | []                                                    |
      | entityVersion   |                                                     1 |
      | entityId        | entityIdData                                          |
      | commandUserId   | dataGenerator.commandUserId()                         |
      | entityName      | "SubdivisionInformation"                              |
    And set commandSubdivisionBody
      | path           |                                              0 |
      | id             | entityIdData                                   |
      | code           | faker.getRandomNumber()                        |
      | description    | faker.getDescription()                         |
      | phase          | faker.getDescription()                         |
      | areaCode.id    | createAreaMaintenanceResponse.body.id          |
      | areaCode.name  | createAreaMaintenanceResponse.body.description |
      | areaCode.code  | createAreaMaintenanceResponse.body.areaCode    |
      | townCode       | faker.getZip()                                 |
      | townDirection  | "E "                                           |
      | range          |                                             10 |
      | rangeDirection | "N"                                            |
      | liber          | faker.getRandomNumber()                        |
      | page           | faker.getRandomNumber()                        |
      | isActive       | faker.getRandomBoolean()                       |
    And set addSubivisionPayload
      | path   | [0]                         |
      | header | commandSubDivisionHeader[0] |
      | body   | commandSubdivisionBody[0]   |
    And print addSubivisionPayload
    And request addSubivisionPayload
    When method POST
    Then status 201
    And def addSubivisionResponse = response
    And print addSubivisionResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,collectionname+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == addSubivisionResponse.body.id
    And match addSubivisionResponse.body.code == addSubivisionPayload.body.code

    Examples: 
      | tenantid    |
      | tenantID[0] |
