Feature: Generate the order number

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def getNumberingScheme = ['GetAndIncrementNumberingScheme','GetNumberingScheme']

  @OrderNumberGeneration
  Scenario Outline: Generate the order number using the numbering scheme id
    Given url commandBaseNumberingSchemeUrl
    And path '/api/'+getNumberingScheme[0]
    And set getNumberingSchemeCommandHeader
      | path            |                                                  0 |
      | schemaUri       | schemaUri+"/"+getNumberingScheme[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()            |
      | version         | "1.001"                                            |
      | sourceId        | dataGenerator.Id()                                 |
      | tenantId        | <tenantid>                                         |
      | id              | dataGenerator.Id()                                 |
      | correlationId   | dataGenerator.Id()                                 |
      | commandUserId   | commandUserId                                      |
      | tags            | []                                                 |
      | commandType     | getNumberingScheme[1]                              |
      | getType         | "One"                                              |
      | ttl             |                                                  0 |
    And set getNumberingSchemeCommandBody
      | path |                0 |
      | id   | numberigSchemeId |
      | code | '7061p'          |
    And set getNumberingSchemePayload
      | path         | [0]                                |
      | header       | getNumberingSchemeCommandHeader[0] |
      | body.request | getNumberingSchemeCommandBody[0]   |
    And print getNumberingSchemePayload
    And request getNumberingSchemePayload
    When method POST
    Then status 200
    And def getNumberingSchemeResponse = response
    And print getNumberingSchemeResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |
