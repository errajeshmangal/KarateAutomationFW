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
    And def commandType = ['CreateGenericLayoutCustomSection','UpdateGenericLayoutCustomSection', 'GetGenericLayoutCustomSection']
    And def entityName = ['GenericLayoutCustomSection']
    And def layoutType = ['CustomSection']
    And def fieldsCollection = ["MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @GetGenericLayoutCustomSectionMasterInfo
  Scenario Outline: Get generic layout custom section Marriage licence with all the fields and get the data
    # Get Generic Layout Marriage Licence
    Given url readBaseGenericLayout
    And path '/api/GetGenericLayoutCustomSection'
    And set getGenericLayoutCustomSectionCommandHeader
      | path            |                                                      0 |
      | schemaUri       | schemaUri+"/GetGenericLayoutCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                |
      | version         | "1.001"                                                |
      | sourceId        | dataGenerator.Id()                                     |
      | tenantId        | <tenantid>                                             |
      | id              | dataGenerator.Id()                                     |
      | correlationId   | dataGenerator.Id()                                     |
      | commandUserId   | dataGenerator.Id()                                     |
      | tags            | []                                                     |
      | commandType     | commandType[2]                                         |
      | getType         | "One"                                                  |
      | ttl             |                                                      0 |
    And set getGenericLayoutCustomSectionCommandBody
      | path |                  0 |
      | id   | dataGenerator.Id() |
    And set getGenericLayoutCustomSectionPayload
      | path         | [0]                                           |
      | header       | getGenericLayoutCustomSectionCommandHeader[0] |
      | body.request | getGenericLayoutCustomSectionCommandBody[0]   |
    And print getGenericLayoutCustomSectionPayload
    And request getGenericLayoutCustomSectionPayload
    When method POST
    Then status 200

    Examples: 
      | tenantid    |
      | tenantID[0] |
