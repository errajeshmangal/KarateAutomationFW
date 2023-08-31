@GetMenuDefinitionAndMenuStructure
Feature: GetMenuDefinitionAndMenuStructure

  Background: 
        And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def MenuDefintionCollectionName = 'CreateMenuDefinition_'
    And def MenuDefintionCollectionNameRead = 'MenuDefinitionDetailViewModel_'
    And def MenuDefintionStructureCollectionName = 'CreateMenuDefinitionStructure_'
    And def MenuDefintionStructureCollectionNameRead = 'MenuDefinitionStructureViewModel_'
     And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateMenuDefinition","UpdateMenuDefinition","GetMenuDefinition","GetMenuDefinitions","CreateMenuDefinitionStructure","UpdateMenuDefinitionStructure","GetMenuDefinitionStructure","GetMenuDefinitionStructures"]
    And def entityName = ["MenuDefinition","MenuDefinitionStructure"]
    And def itemType = ["Category","Page"]
    And def eventTypes = ['MenuDefinition','MenuDefinitionStructure']
    And def historyAndComments = ['Created','Updated']

  @GetMenuDefinitionWithAllDetails
  Scenario Outline: Get a Menu Definition with all the fields
    Given url readBaseUrl
    And path '/api/'+commandType[2]
    And set getCommandHeader
      | path            |                                                 0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()           |
      | version         | "1.001"                                           |
      | sourceId        | createMenuDefinitionResponse.header.sourceId      |
      | tenantId        | <tenantid>                                        |
      | id              | createMenuDefinitionResponse.header.id            |
      | correlationId   | createMenuDefinitionResponse.header.correlationId |
      | commandUserId   | createMenuDefinitionResponse.header.commandUserId |
      | tags            | []                                                |
      | commandType     | commandType[2]                                    |
      | getType         | "One"                                             |
      | ttl             |                                                 0 |
    And set getCommandBody
      | path |                                            0 |
      | id   | entityId |
    And set getMenuDefinitionPayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuDefinitionPayload
    And request getMenuDefinitionPayload
    When method POST
    And sleep(15000)
    Then status 200
    And def getMenuDefinitionResponse = response
    And print getMenuDefinitionResponse
     Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @GetSubMenuItemWithItemTypeCategory
  Scenario Outline: Get menu structure with one subMenu item and one item
    #Get the menudefStructure
    Given url readBaseUrl
    And path '/api/'+commandType[6]
    And set getCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[6]+"-v1.001.json" |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | tenantId        | <tenantid>                                  |
      | ttl             |                                           0 |
      | commandType     | commandType[6]                              |
      | getType         | "One"                                       |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | tags            | []                                          |
      | commandUserId   | dataGenerator.commandUserId()               |
    And set getCommandBody
      | path             |                                                 0 |
      | menuDefinitionId | menuDefinitionID |
    And set getMenuStructurePayload
      | path         | [0]                 |
      | header       | getCommandHeader[0] |
      | body.request | getCommandBody[0]   |
    And print getMenuStructurePayload
    And request getMenuStructurePayload
    When method POST
    Then status 200
    And sleep(15000)
    And def getMenuStructureResponse = response
    And print getMenuStructureResponse
         Examples: 
      | tenantid    |
      | tenantID[0] |