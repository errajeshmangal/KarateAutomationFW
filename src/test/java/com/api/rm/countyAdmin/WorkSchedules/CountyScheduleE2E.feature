Feature: E2E test WorkSchedule for county

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def workScheduleCollectionName = 'CreateCountyMasterWorkSchedule_'
    And def workScheduleCollectionNameRead = 'CountyMasterWorkScheduleDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @createCountyWorkScheduleAndGetTheDetails
  Scenario Outline: Create a county WorkSchedules with all the fields and Get the details
    #Create County Workschedule and Get the details
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@createCountyWorkSchedule')
    And def addCountyScheduleResponse = result.response
    And print addCountyScheduleResponse
    #GetcountySchedule
    Given url readBaseUrl
    And path '/api/GetCountyMasterWorkSchedule'
    And set getSchedulesCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | addCountyScheduleResponse.header.sourceId            |
      | tenantId        | <tenantid>                                           |
      | id              | addCountyScheduleResponse.header.id                  |
      | correlationId   | addCountyScheduleResponse.header.correlationId       |
      | commandUserId   | addCountyScheduleResponse.header.commandUserId       |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | 'GetCountyMasterWorkSchedule'                        |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getSchedulesCommandBody
      | path |                                 0 |
      | id   | addCountyScheduleResponse.body.id |
    And set getSchedulesPayload
      | path         | [0]                          |
      | header       | getSchedulesCommandHeader[0] |
      | body.request | getSchedulesCommandBody[0]   |
    And print getSchedulesPayload
    And request getSchedulesPayload
    When method POST
    Then status 200
    And def getSchedulesResponse = response
    And print getSchedulesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,workScheduleCollectionNameRead+<tenantid>,addCountyScheduleResponse.body.id)
    And print mongoResult
    And match mongoResult == getSchedulesResponse.id
    And match getSchedulesResponse.countyMasterId == addCountyScheduleResponse.body.countyMasterId
    And match getSchedulesResponse.workSchedule[0].scheduleStartTime == addCountyScheduleResponse.body.workSchedule[0].scheduleStartTime
    And match getSchedulesResponse.workSchedule[0].scheduleEndTime == addCountyScheduleResponse.body.workSchedule[0].scheduleEndTime
    And match getSchedulesResponse.workSchedule[0].isActive == addCountyScheduleResponse.body.workSchedule[0].isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCountyWorkScheduleAndGetTheDetails
  Scenario Outline: Update a county WorkSchedules with all the fields and Get the details
    #Update County Workschedule and Get the details
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@updateCountyWorkSchedule')
    And def UpdateCountyScheduleResponse = result.response
    And print UpdateCountyScheduleResponse
    #GetcountySchedule
    Given url readBaseUrl
    And path '/api/GetCountyMasterWorkSchedule'
    And set getSchedulesCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | UpdateCountyScheduleResponse.header.sourceId         |
      | tenantId        | <tenantid>                                           |
      | id              | UpdateCountyScheduleResponse.header.id               |
      | correlationId   | UpdateCountyScheduleResponse.header.correlationId    |
      | commandUserId   | UpdateCountyScheduleResponse.header.commandUserId    |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | 'GetCountyMasterWorkSchedule'                        |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getSchedulesCommandBody
      | path |                                    0 |
      | id   | UpdateCountyScheduleResponse.body.id |
    And set getSchedulesPayload
      | path         | [0]                          |
      | header       | getSchedulesCommandHeader[0] |
      | body.request | getSchedulesCommandBody[0]   |
    And print getSchedulesPayload
    And request getSchedulesPayload
    When method POST
    Then status 200
    And def getSchedulesResponse = response
    And print getSchedulesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,workScheduleCollectionNameRead+<tenantid>,UpdateCountyScheduleResponse.body.id)
    And print mongoResult
    And match mongoResult == getSchedulesResponse.id
    And match getSchedulesResponse.countyMasterId == UpdateCountyScheduleResponse.body.countyMasterId
    And match getSchedulesResponse.workSchedule[0].scheduleStartTime == UpdateCountyScheduleResponse.body.workSchedule[0].scheduleStartTime
    And match getSchedulesResponse.workSchedule[0].scheduleEndTime == UpdateCountyScheduleResponse.body.workSchedule[0].scheduleEndTime
    And match getSchedulesResponse.workSchedule[0].isActive == UpdateCountyScheduleResponse.body.workSchedule[0].isActive

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @updateCountyWorkSchedulewithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Update a county WorkSchedules with Mandatory fields and Get the details
    #Update County Workschedule and Get the details
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@updateCountyWorkSchedule')
    And def UpdateCountyScheduleResponse = result.response
    And print UpdateCountyScheduleResponse
    #GetcountySchedule
    Given url readBaseUrl
    And path '/api/GetCountyMasterWorkSchedule'
    And set getSchedulesCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | UpdateCountyScheduleResponse.header.sourceId         |
      | tenantId        | <tenantid>                                           |
      | id              | UpdateCountyScheduleResponse.header.id               |
      | correlationId   | UpdateCountyScheduleResponse.header.correlationId    |
      | commandUserId   | UpdateCountyScheduleResponse.header.commandUserId    |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | 'GetCountyMasterWorkSchedule'                        |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getSchedulesCommandBody
      | path |                                    0 |
      | id   | UpdateCountyScheduleResponse.body.id |
    And set getSchedulesPayload
      | path         | [0]                          |
      | header       | getSchedulesCommandHeader[0] |
      | body.request | getSchedulesCommandBody[0]   |
    And print getSchedulesPayload
    And request getSchedulesPayload
    When method POST
    Then status 200
    And def getSchedulesResponse = response
    And print getSchedulesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,workScheduleCollectionNameRead+<tenantid>,UpdateCountyScheduleResponse.body.id)
    And print mongoResult
    And match mongoResult == getSchedulesResponse.id
    And match getSchedulesResponse.countyMasterId == UpdateCountyScheduleResponse.body.countyMasterId
    And match getSchedulesResponse.holidayList[0].holidayName == UpdateCountyScheduleResponse.body.holidayList[0].holidayName
    And match getSchedulesResponse.holidayList[0].startDate == UpdateCountyScheduleResponse.body.holidayList[0].startDate
    And match getSchedulesResponse.holidayList[0].endDate == UpdateCountyScheduleResponse.body.holidayList[0].endDate
    And match getSchedulesResponse.holidayList[0].noOfDays == UpdateCountyScheduleResponse.body.holidayList[0].noOfDays

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @createCountyWorkScheduleWithMandatoryFieldsAndGetTheDetails
  Scenario Outline: Create a county WorkSchedules with Mandatory the fields and Get the details
    #Create County Workschedule and Get the details
    And def result = call read('classpath:com/api/rm/countyAdmin/WorkSchedules/CreateWorkSchedule.feature@createCountyWorkSchedulewithMandatoryFields')
    And def addCountyScheduleResponse = result.response
    And print addCountyScheduleResponse
    #GetcountySchedule
    Given url readBaseUrl
    And path '/api/GetCountyMasterWorkSchedule'
    And set getSchedulesCommandHeader
      | path            |                                                    0 |
      | schemaUri       | schemaUri+"/GetCountyMasterWorkSchedule-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()              |
      | version         | "1.001"                                              |
      | sourceId        | addCountyScheduleResponse.header.sourceId            |
      | tenantId        | <tenantid>                                           |
      | id              | addCountyScheduleResponse.header.id                  |
      | correlationId   | addCountyScheduleResponse.header.correlationId       |
      | commandUserId   | addCountyScheduleResponse.header.commandUserId       |
      | entityVersion   |                                                    1 |
      | tags            | []                                                   |
      | commandType     | 'GetCountyMasterWorkSchedule'                        |
      | getType         | "One"                                                |
      | ttl             |                                                    0 |
    And set getSchedulesCommandBody
      | path |                                 0 |
      | id   | addCountyScheduleResponse.body.id |
    And set getSchedulesPayload
      | path         | [0]                          |
      | header       | getSchedulesCommandHeader[0] |
      | body.request | getSchedulesCommandBody[0]   |
    And print getSchedulesPayload
    And request getSchedulesPayload
    When method POST
    Then status 200
    And def getSchedulesResponse = response
    And print getSchedulesResponse
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,workScheduleCollectionNameRead+<tenantid>,addCountyScheduleResponse.body.id)
    And print mongoResult
    And match mongoResult == getSchedulesResponse.id
    And match getSchedulesResponse.countyMasterId == addCountyScheduleResponse.body.countyMasterId
    And match getSchedulesResponse.holidayList[0].holidayName == addCountyScheduleResponse.body.holidayList[0].holidayName
    And match getSchedulesResponse.holidayList[0].startDate == addCountyScheduleResponse.body.holidayList[0].startDate
    And match getSchedulesResponse.holidayList[0].endDate == addCountyScheduleResponse.body.holidayList[0].endDate
    And match getSchedulesResponse.holidayList[0].noOfDays == addCountyScheduleResponse.body.holidayList[0].noOfDays

    Examples: 
      | tenantid    |
      | tenantID[0] |

      
       @createCountyWorkScheduleWithInvalidDetails
  Scenario Outline: Create a county WorkSchedules with all the fields and Get the details
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
      | countyMasterId |masterCountyResponse.id |
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
    Then status 400
    And def getSchedulesResponse = response
    And print getSchedulesResponse
        Examples: 
      | tenantid    |
      | tenantID[0] |