# This feature file created to use the response of these scenarios in the E2E Master County feature
@e2e
Feature: Create the County functionality

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def workScheduleCollectionName = 'CreateCountyMasterWorkSchedule_'
    And def workScheduleCollectionNameRead = 'CountyMasterWorkScheduleDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
 

  @createCountyWorkSchedule
  Scenario Outline: Create a County Work Schedule with all the fields and validate the details
    Given url commandBaseUrl
       #Get County master 
    And def result = call read('classpath:com/api/rm/countyAdmin/countyFeature/CreateCounty.feature@getCountyDetails')
    And def  masterCountyResponse = result.response
    And print masterCountyResponse
    And path '/api/CreateCountyMasterWorkSchedule'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreateCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | entityId        | entityIdData                                            |
      | commandUserId   | commandUserId                                           |
      | entityVersion   |                                                       1 |
      | tags            | []                                                      |
      | commandType     | "CreateCountyMasterWorkSchedule"                        |
      | entityName      | "CountyMasterWorkSchedule"                              |
      | ttl             |                                                       0 |
    And set commandBody
      | path           |                  0 |
      | id             | entityIdData       |
      | countyMasterId |masterCountyResponse.results[0].id |
    And set workSchedule
      | path              |                                       0 |
      | workDay           | faker.getWorkDay()                      |
      | scheduleStartTime | dataGenerator.generateCurrentDateTime() |
      | scheduleEndTime   | dataGenerator.generateCurrentDateTime() |
      | isActive          | faker.getRandomBooleanValue()           |
    And set workSchedule
      | path              |                                       1 |
      | workDay           | faker.getWorkDay()                      |
      | scheduleStartTime | dataGenerator.generateCurrentDateTime() |
      | scheduleEndTime   | dataGenerator.generateCurrentDateTime() |
      | isActive          | faker.getRandomBooleanValue()           |
    And set holidayList
      | path        |                                       0 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set holidayList
      | path        |                                       1 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set createCountyPayload
      | path                 | [0]              |
      | header               | commandHeader[0] |
      | body                 | commandBody[0]   |
      | body.holidayList[0]  | holidayList[0]   |
      | body.holidayList[1]  | holidayList[1]   |
      | body.workSchedule[0] | workSchedule[0]  |
      | body.workSchedule[1] | workSchedule[1]  |
    And print createCountyPayload
    And request createCountyPayload
    When method POST
    Then status 201
    And print response
    And def createCountyResponse = response
    And print createCountyResponse
    And print dbname+workScheduleCollectionName+<tenantid>+entityIdData
    And def mongoResult = mongoData.MongoDBReader(dbname,workScheduleCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCountyResponse.body.id
    And match createCountyResponse.body.id == createCountyPayload.body.id
    And match createCountyResponse.body.countyMasterId == createCountyPayload.body.countyMasterId
    And match createCountyResponse.body.holidayList[0].holidayName == createCountyPayload.body.holidayList[0].holidayName
     And match createCountyResponse.body.holidayList[1].holidayName == createCountyPayload.body.holidayList[1].holidayName
     And match createCountyResponse.body.workSchedule[0].scheduleStartTime == createCountyPayload.body.workSchedule[0].scheduleStartTime
     And match createCountyResponse.body.workSchedule[1].scheduleStartTime == createCountyPayload.body.workSchedule[1].scheduleStartTime
    Examples: 
      | tenantid    |
      | tenantID[0] |

   @updateCountyWorkSchedule
  Scenario Outline: Update a County Work Schedule with all the fields and validate the details
    Given url commandBaseUrl
      #Create County Workschedule and Get the details  countyAdmin/WorkSchedules/CreateWorkSchedule.feature
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@createCountyWorkSchedule')
    And def addCountyScheduleResponse = result.response
    And print addCountyScheduleResponse
    And path '/api/UpdateCountyMasterWorkSchedule'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/UpdateCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | entityId        | addCountyScheduleResponse.body.id                                             |
      | commandUserId   | commandUserId                                           |
      | entityVersion   |                                                       1 |
      | tags            | []                                                      |
      | commandType     | "UpdateCountyMasterWorkSchedule"                        |
      | entityName      | "CountyMasterWorkSchedule"                              |
      | ttl             |                                                       0 |
    And set commandBody
      | path           |                  0 |
      | id             |addCountyScheduleResponse.body.id         |
      | countyMasterId | dataGenerator.Id() |
    And set workSchedule
      | path              |                                       0 |
      | workDay           | faker.getWorkDay()                      |
      | scheduleStartTime | dataGenerator.generateCurrentDateTime() |
      | scheduleEndTime   | dataGenerator.generateCurrentDateTime() |
      | isActive          | faker.getRandomBooleanValue()           |
    And set workSchedule
      | path              |                                       1 |
      | workDay           | faker.getWorkDay()                      |
      | scheduleStartTime | dataGenerator.generateCurrentDateTime() |
      | scheduleEndTime   | dataGenerator.generateCurrentDateTime() |
      | isActive          | faker.getRandomBooleanValue()           |
    And set holidayList
      | path        |                                       0 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set holidayList
      | path        |                                       1 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set updateCountyPayload
      | path                 | [0]              |
      | header               | commandHeader[0] |
      | body                 | commandBody[0]   |
      | body.holidayList[0]  | holidayList[0]   |
      | body.holidayList[1]  | holidayList[1]   |
      | body.workSchedule[0] | workSchedule[0]  |
      | body.workSchedule[1] | workSchedule[1]  |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 201
    And print response
    And def updateCountyResponse = response
    And print updateCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,workScheduleCollectionName+<tenantid>,addCountyScheduleResponse.body.id )
    And print mongoResult
    And match mongoResult == updateCountyResponse.body.id
    And match updateCountyResponse.body.id == updateCountyPayload.body.id
    And match updateCountyResponse.body.countyMasterId == updateCountyPayload.body.countyMasterId
    And match updateCountyResponse.body.holidayList[0].holidayName == updateCountyPayload.body.holidayList[0].holidayName
     And match updateCountyResponse.body.holidayList[1].holidayName == updateCountyPayload.body.holidayList[1].holidayName
     And match updateCountyResponse.body.workSchedule[0].scheduleStartTime == updateCountyPayload.body.workSchedule[0].scheduleStartTime
     And match updateCountyResponse.body.workSchedule[1].scheduleStartTime == updateCountyPayload.body.workSchedule[1].scheduleStartTime
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      
         @updateCountyWorkSchedulewithMandatory
  Scenario Outline: Update a County Work Schedule with Mandatory fields and validate the details
    Given url commandBaseUrl
      #Create County Workschedule and Get the details
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@createCountyWorkSchedulewithMandatoryFields')
    And def addCountyScheduleResponse = result.response
    And print addCountyScheduleResponse
    And path '/api/UpdateCountyMasterWorkSchedule'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/UpdateCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | entityId        | addCountyScheduleResponse.body.id                                             |
      | commandUserId   | commandUserId                                           |
      | entityVersion   |                                                       1 |
      | tags            | []                                                      |
      | commandType     | "UpdateCountyMasterWorkSchedule"                        |
      | entityName      | "CountyMasterWorkSchedule"                              |
      | ttl             |                                                       0 |
    And set commandBody
      | path           |                  0 |
      | id             |  addCountyScheduleResponse.body.id       |
      | countyMasterId | dataGenerator.Id() |
    And set holidayList
      | path        |                                       0 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set holidayList
      | path        |                                       1 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set updateCountyPayload
      | path                 | [0]              |
      | header               | commandHeader[0] |
      | body                 | commandBody[0]   |
      | body.holidayList[0]  | holidayList[0]   |
      | body.holidayList[1]  | holidayList[1]   |
    And print updateCountyPayload
    And request updateCountyPayload
    When method POST
    Then status 201
    And print response
    And def updateCountyResponse = response
    And print updateCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,workScheduleCollectionName+<tenantid>, addCountyScheduleResponse.body.id)
    And print mongoResult
    And match mongoResult == updateCountyResponse.body.id
    And match updateCountyResponse.body.id == updateCountyPayload.body.id
    And match updateCountyResponse.body.countyMasterId == updateCountyPayload.body.countyMasterId
    And match updateCountyResponse.body.holidayList[0].holidayName == updateCountyPayload.body.holidayList[0].holidayName
     And match updateCountyResponse.body.holidayList[1].holidayName == updateCountyPayload.body.holidayList[1].holidayName
     
    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @createCountyWorkSchedulewithMandatoryFields
  Scenario Outline: Create a County Work Schedule with mandatory fields and validate the details
    Given url commandBaseUrl
    And path '/api/CreateCountyMasterWorkSchedule'
    And def entityIdData = dataGenerator.entityID()
    And set commandHeader
      | path            |                                                       0 |
      | schemaUri       | schemaUri+"/CreateCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                 |
      | version         | "1.001"                                                 |
      | sourceId        | dataGenerator.SourceID()                                |
      | tenantId        | <tenantid>                                              |
      | id              | dataGenerator.Id()                                      |
      | correlationId   | dataGenerator.correlationId()                           |
      | entityId        | entityIdData                                            |
      | commandUserId   | commandUserId                                           |
      | entityVersion   |                                                       1 |
      | tags            | []                                                      |
      | commandType     | "CreateCountyMasterWorkSchedule"                        |
      | entityName      | "CountyMasterWorkSchedule"                              |
      | ttl             |                                                       0 |
    And set commandBody
      | path           |                  0 |
      | id             | entityIdData       |
      | countyMasterId | dataGenerator.Id() |
    And set holidayList
      | path        |                                       0 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set holidayList
      | path        |                                       1 |
      | holidayName | faker.getHoliday()                      |
      | startDate   | dataGenerator.generateCurrentDateTime() |
      | endDate     | dataGenerator.generateCurrentDateTime() |
      | noOfDays    | faker.get3Number()                 |
    And set createCountyPayload
      | path                 | [0]              |
      | header               | commandHeader[0] |
      | body                 | commandBody[0]   |
      | body.holidayList[0]  | holidayList[0]   |
      | body.holidayList[1]  | holidayList[1]   |
    And print createCountyPayload
    And request createCountyPayload
    When method POST
    Then status 201
    And print response
    And def createCountyResponse = response
    And print createCountyResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,workScheduleCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createCountyResponse.body.id
    And match createCountyResponse.body.id == createCountyPayload.body.id
    And match createCountyResponse.body.countyMasterId == createCountyPayload.body.countyMasterId
    And match createCountyResponse.body.holidayList[0].holidayName == createCountyPayload.body.holidayList[0].holidayName
     And match createCountyResponse.body.holidayList[1].holidayName == createCountyPayload.body.holidayList[1].holidayName
    
    Examples: 
      | tenantid    |
      | tenantID[0] |
