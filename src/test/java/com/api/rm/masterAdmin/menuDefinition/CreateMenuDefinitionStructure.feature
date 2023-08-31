@CreateMenuDefinitionStructure
Feature: Create Menu Definition Structure

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def MenuDefintionCollectionName = 'CreateMenuDefinition_'
    And def MenuDefintionCollectionNameRead = 'MenuDefinitionDetailViewModel_'
    And def MenuDefintionStructureCollectionName = 'CreateMenuDefinitionStructure_'
    And def MenuDefintionStructureCollectionNameRead = 'MenuDefinitionStructureViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ["CreateMenuDefinition","UpdateMenuDefinition","GetMenuDefinition","GetMenuDefinitions","CreateMenuDefinitionStructure"]
    And def entityName = ["MenuDefinition","MenuDefinitionStructure"]
    And def itemType = ["Category","Page"]
    And def eventTypes = ['MenuDefinition']
    And def historyAndComments = ['Created','Updated']

  @CreateSubMenuItemWithItemTypeCategory
  Scenario Outline: Create one SubMenu Item with one item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    Then status 201
    And def createMenuStructureResponse = response
    And print createMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.id == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.menuDefinitionId == createMenuStructureResponse.body.menuDefinitionId
    And match createMenuStructurePayload.body.menuItems[0].id == createMenuStructureResponse.body.menuItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].itemTitle == createMenuStructureResponse.body.menuItems[0].itemTitle
    And match createMenuStructurePayload.body.menuItems[0].itemDescription == createMenuStructureResponse.body.menuItems[0].itemDescription
      #And match createMenuStructurePayload.body.menuItems[0].itemType == createMenuStructureResponse.body.menuItems[0].itemType
    And match createMenuStructurePayload.body.menuItems[0].menuItemSequence == createMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].id == createMenuStructureResponse.body.menuItems[0].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemSequence

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateMenuItemsWithItemTypePage
  Scenario Outline: Create items when Type is Page
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]                       |
      | itemUrl          | faker.getLastName()               |
      | menuItemSequence |                                 1 |
    And set menuItemsCommandBody
      | path             |                                 1 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]                       |
      | itemUrl          | faker.getLastName()               |
      | menuItemSequence |                                 2 |
    And set menuItemsCommandBody
      | path             |                                 2 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[1]                       |
      | itemUrl          | faker.getLastName()               |
      | menuItemSequence |                                 3 |
    And set createPageItemsPayload
      | path           | [0]                    |
      | header         | createCommandHeader[0] |
      | body           | createCommandBody[0]   |
      | body.menuItems | menuItemsCommandBody   |
    And print createPageItemsPayload
    And request createPageItemsPayload
    When method POST
    Then status 201
    And def createPageItemsResponse = response
    And print createPageItemsResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createPageItemsResponse.body.id
    And match createPageItemsPayload.body.id == createPageItemsResponse.body.id
    And match createPageItemsPayload.body.menuDefinitionId == createPageItemsResponse.body.menuDefinitionId
    And match createPageItemsPayload.body.menuItems[0].id == createPageItemsResponse.body.menuItems[0].id
    And match createPageItemsPayload.body.menuItems[0].itemTitle == createPageItemsResponse.body.menuItems[0].itemTitle
    And match createPageItemsPayload.body.menuItems[0].itemDescription == createPageItemsResponse.body.menuItems[0].itemDescription
    #And match createPageItemsPayload.body.menuItems[0].itemType == createPageItemsResponse.body.menuItems[0].itemType
    And match createPageItemsPayload.body.menuItems[0].itemUrl == createPageItemsResponse.body.menuItems[0].itemUrl
    And match createPageItemsPayload.body.menuItems[0].menuItemSequence == createPageItemsResponse.body.menuItems[0].menuItemSequence
    And match createPageItemsPayload.body.menuItems[1].id == createPageItemsResponse.body.menuItems[1].id
    And match createPageItemsPayload.body.menuItems[1].itemTitle == createPageItemsResponse.body.menuItems[1].itemTitle
    And match createPageItemsPayload.body.menuItems[1].itemDescription == createPageItemsResponse.body.menuItems[1].itemDescription
    #And match createPageItemsPayload.body.menuItems[1].itemType == createPageItemsResponse.body.menuItems[1].itemType
    And match createPageItemsPayload.body.menuItems[1].itemUrl == createPageItemsResponse.body.menuItems[1].itemUrl
    And match createPageItemsPayload.body.menuItems[1].menuItemSequence == createPageItemsResponse.body.menuItems[1].menuItemSequence
    And match createPageItemsPayload.body.menuItems[2].id == createPageItemsResponse.body.menuItems[2].id
    And match createPageItemsPayload.body.menuItems[2].itemTitle == createPageItemsResponse.body.menuItems[2].itemTitle
    And match createPageItemsPayload.body.menuItems[2].itemDescription == createPageItemsResponse.body.menuItems[2].itemDescription
    #And match createPageItemsPayload.body.menuItems[2].itemType == createPageItemsResponse.body.menuItems[2].itemType
    And match createPageItemsPayload.body.menuItems[2].itemUrl == createPageItemsResponse.body.menuItems[2].itemUrl
    And match createPageItemsPayload.body.menuItems[2].menuItemSequence == createPageItemsResponse.body.menuItems[2].menuItemSequence

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemsWithItemCategory
  Scenario Outline: Create SubMenu Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 1 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 2 |
    And set subMenuItemsCommandBody
      | path               |                                 2 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 3 |
    And set createMenuStructurePayload
      | path                       | [0]                     |
      | header                     | createCommandHeader[0]  |
      | body                       | createCommandBody[0]    |
      | body.menuItems             | menuItemsCommandBody    |
      | body.menuItems[0].subItems | subMenuItemsCommandBody |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    Then status 201
    And def createMenuStructureResponse = response
    And print createMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.id == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.menuDefinitionId == createMenuStructureResponse.body.menuDefinitionId
    And match createMenuStructurePayload.body.menuItems[0].id == createMenuStructureResponse.body.menuItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].itemTitle == createMenuStructureResponse.body.menuItems[0].itemTitle
    And match createMenuStructurePayload.body.menuItems[0].itemDescription == createMenuStructureResponse.body.menuItems[0].itemDescription
    #And match createMenuStructurePayload.body.menuItems[0].itemType == createMenuStructureResponse.body.menuItems[0].itemType
    And match createMenuStructurePayload.body.menuItems[0].menuItemSequence == createMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].id == createMenuStructureResponse.body.menuItems[0].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].id == createMenuStructureResponse.body.menuItems[0].subItems[1].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].id == createMenuStructureResponse.body.menuItems[0].subItems[2].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemSequence

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemWithMultipleItems
  Scenario Outline: Create SubMenu Item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set menuItemsCommandBody
      | path             |                                 1 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 2 |
    And set menuItemsCommandBody
      | path             |                                 2 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 3 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody1
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody2
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set createMenuStructurePayload
      | path                       | [0]                      |
      | header                     | createCommandHeader[0]   |
      | body                       | createCommandBody[0]     |
      | body.menuItems             | menuItemsCommandBody     |
      | body.menuItems[0].subItems | subMenuItemsCommandBody  |
      | body.menuItems[1].subItems | subMenuItemsCommandBody1 |
      | body.menuItems[2].subItems | subMenuItemsCommandBody2 |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    Then status 201
    And def createMenuStructureResponse = response
    And print createMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.id == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.menuDefinitionId == createMenuStructureResponse.body.menuDefinitionId
    And match createMenuStructurePayload.body.menuItems[0].id == createMenuStructureResponse.body.menuItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].itemTitle == createMenuStructureResponse.body.menuItems[0].itemTitle
    And match createMenuStructurePayload.body.menuItems[0].itemDescription == createMenuStructureResponse.body.menuItems[0].itemDescription
    #And match createMenuStructurePayload.body.menuItems[0].itemType == createMenuStructureResponse.body.menuItems[0].itemType
    And match createMenuStructurePayload.body.menuItems[0].menuItemSequence == createMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].id == createMenuStructureResponse.body.menuItems[0].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[1].id == createMenuStructureResponse.body.menuItems[1].id
    And match createMenuStructurePayload.body.menuItems[1].itemTitle == createMenuStructureResponse.body.menuItems[1].itemTitle
    And match createMenuStructurePayload.body.menuItems[1].itemDescription == createMenuStructureResponse.body.menuItems[1].itemDescription
    #And match createMenuStructurePayload.body.menuItems[1].itemType == createMenuStructureResponse.body.menuItems[1].itemType
    And match createMenuStructurePayload.body.menuItems[1].menuItemSequence == createMenuStructureResponse.body.menuItems[1].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].id == createMenuStructureResponse.body.menuItems[1].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[2].id == createMenuStructureResponse.body.menuItems[2].id
    And match createMenuStructurePayload.body.menuItems[2].itemTitle == createMenuStructureResponse.body.menuItems[2].itemTitle
    And match createMenuStructurePayload.body.menuItems[2].itemDescription == createMenuStructureResponse.body.menuItems[2].itemDescription
    #And match createMenuStructurePayload.body.menuItems[2].itemType == createMenuStructureResponse.body.menuItems[2].itemType
    And match createMenuStructurePayload.body.menuItems[2].menuItemSequence == createMenuStructureResponse.body.menuItems[2].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].id == createMenuStructureResponse.body.menuItems[2].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemSequence

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateSubMenuItemsWithMultipleItems
  Scenario Outline: Create three submenu items with each item when Type is Category
    Given url commandBaseUrl
    And path '/api/'+commandType[4]
    #calling create menu definition
    And def result = call read('CreateMenuDefinitionStep1.feature@CreateMenuDefinitionWithAllFields')
    And def createMenuDefinitionResponse = result.response
    And print createMenuDefinitionResponse
    And def entityIdData = dataGenerator.entityID()
    And set createCommandHeader
      | path            |                                           0 |
      | schemaUri       | schemaUri+"/"+commandType[4]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()     |
      | version         | "1.001"                                     |
      | sourceId        | dataGenerator.SourceID()                    |
      | tenantId        | <tenantid>                                  |
      | id              | dataGenerator.Id()                          |
      | correlationId   | dataGenerator.correlationId()               |
      | entityId        | entityIdData                                |
      | commandUserId   | dataGenerator.commandUserId()               |
      | entityVersion   |                                           1 |
      | tags            | []                                          |
      | commandType     | commandType[4]                              |
      | entityName      | entityName[1]                               |
      | ttl             |                                           0 |
    And set createCommandBody
      | path             |                                    0 |
      | id               | entityIdData                         |
      | menuDefinitionId | createMenuDefinitionResponse.body.id |
    And set menuItemsCommandBody
      | path             |                                 0 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 1 |
    And set menuItemsCommandBody
      | path             |                                 1 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 2 |
    And set menuItemsCommandBody
      | path             |                                 2 |
      | id               | dataGenerator.entityID()          |
      | itemTitle        | faker.getFirstName()              |
      | itemDescription  | faker.getRandomShortDescription() |
      | itemType         | itemType[0]                       |
      | menuItemSequence |                                 3 |
    And set subMenuItemsCommandBody
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody
      | path               |                                 1 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 2 |
    And set subMenuItemsCommandBody
      | path               |                                 2 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 3 |
    And set subMenuItemsCommandBody1
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody1
      | path               |                                 1 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 2 |
    And set subMenuItemsCommandBody1
      | path               |                                 2 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 3 |
    And set subMenuItemsCommandBody2
      | path               |                                 0 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 1 |
    And set subMenuItemsCommandBody2
      | path               |                                 1 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 2 |
    And set subMenuItemsCommandBody2
      | path               |                                 2 |
      | id                 | dataGenerator.entityID()          |
      | subItemTitle       | faker.getFirstName()              |
      | subItemDescription | faker.getRandomShortDescription() |
      | subItemUrl         | faker.getLastName()               |
      | subItemSequence    |                                 3 |
    And set createMenuStructurePayload
      | path                       | [0]                      |
      | header                     | createCommandHeader[0]   |
      | body                       | createCommandBody[0]     |
      | body.menuItems             | menuItemsCommandBody     |
      | body.menuItems[0].subItems | subMenuItemsCommandBody  |
      | body.menuItems[1].subItems | subMenuItemsCommandBody1 |
      | body.menuItems[2].subItems | subMenuItemsCommandBody2 |
    And print createMenuStructurePayload
    And request createMenuStructurePayload
    When method POST
    Then status 201
    And def createMenuStructureResponse = response
    And print createMenuStructureResponse
    And def mongoResult = mongoData.MongoDBReader(dbname,MenuDefintionStructureCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.id == createMenuStructureResponse.body.id
    And match createMenuStructurePayload.body.menuDefinitionId == createMenuStructureResponse.body.menuDefinitionId
    And match createMenuStructurePayload.body.menuItems[0].id == createMenuStructureResponse.body.menuItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].itemTitle == createMenuStructureResponse.body.menuItems[0].itemTitle
    And match createMenuStructurePayload.body.menuItems[0].itemDescription == createMenuStructureResponse.body.menuItems[0].itemDescription
    #And match createMenuStructurePayload.body.menuItems[0].itemType == createMenuStructureResponse.body.menuItems[0].itemType
    And match createMenuStructurePayload.body.menuItems[0].menuItemSequence == createMenuStructureResponse.body.menuItems[0].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].id == createMenuStructureResponse.body.menuItems[0].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].id == createMenuStructureResponse.body.menuItems[0].subItems[1].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[1].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[1].subItemSequence
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].id == createMenuStructureResponse.body.menuItems[0].subItems[2].id
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemTitle == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemTitle
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemDescription == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemDescription
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemUrl == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemUrl
    And match createMenuStructurePayload.body.menuItems[0].subItems[2].subItemSequence == createMenuStructureResponse.body.menuItems[0].subItems[2].subItemSequence
    And match createMenuStructurePayload.body.menuItems[1].id == createMenuStructureResponse.body.menuItems[1].id
    And match createMenuStructurePayload.body.menuItems[1].itemTitle == createMenuStructureResponse.body.menuItems[1].itemTitle
    And match createMenuStructurePayload.body.menuItems[1].itemDescription == createMenuStructureResponse.body.menuItems[1].itemDescription
    #And match createMenuStructurePayload.body.menuItems[1].itemType == createMenuStructureResponse.body.menuItems[1].itemType
    And match createMenuStructurePayload.body.menuItems[1].menuItemSequence == createMenuStructureResponse.body.menuItems[1].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].id == createMenuStructureResponse.body.menuItems[1].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[1].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[1].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[1].subItems[1].id == createMenuStructureResponse.body.menuItems[1].subItems[1].id
    And match createMenuStructurePayload.body.menuItems[1].subItems[1].subItemTitle == createMenuStructureResponse.body.menuItems[1].subItems[1].subItemTitle
    And match createMenuStructurePayload.body.menuItems[1].subItems[1].subItemDescription == createMenuStructureResponse.body.menuItems[1].subItems[1].subItemDescription
    And match createMenuStructurePayload.body.menuItems[1].subItems[1].subItemUrl == createMenuStructureResponse.body.menuItems[1].subItems[1].subItemUrl
    And match createMenuStructurePayload.body.menuItems[1].subItems[1].subItemSequence == createMenuStructureResponse.body.menuItems[1].subItems[1].subItemSequence
    And match createMenuStructurePayload.body.menuItems[1].subItems[2].id == createMenuStructureResponse.body.menuItems[1].subItems[2].id
    And match createMenuStructurePayload.body.menuItems[1].subItems[2].subItemTitle == createMenuStructureResponse.body.menuItems[1].subItems[2].subItemTitle
    And match createMenuStructurePayload.body.menuItems[1].subItems[2].subItemDescription == createMenuStructureResponse.body.menuItems[1].subItems[2].subItemDescription
    And match createMenuStructurePayload.body.menuItems[1].subItems[2].subItemUrl == createMenuStructureResponse.body.menuItems[1].subItems[2].subItemUrl
    And match createMenuStructurePayload.body.menuItems[1].subItems[2].subItemSequence == createMenuStructureResponse.body.menuItems[1].subItems[2].subItemSequence
    And match createMenuStructurePayload.body.menuItems[2].id == createMenuStructureResponse.body.menuItems[2].id
    And match createMenuStructurePayload.body.menuItems[2].itemTitle == createMenuStructureResponse.body.menuItems[2].itemTitle
    And match createMenuStructurePayload.body.menuItems[2].itemDescription == createMenuStructureResponse.body.menuItems[2].itemDescription
    #And match createMenuStructurePayload.body.menuItems[2].itemType == createMenuStructureResponse.body.menuItems[2].itemType
    And match createMenuStructurePayload.body.menuItems[2].menuItemSequence == createMenuStructureResponse.body.menuItems[2].menuItemSequence
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].id == createMenuStructureResponse.body.menuItems[2].subItems[0].id
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemTitle == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemTitle
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemDescription == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemDescription
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemUrl == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemUrl
    And match createMenuStructurePayload.body.menuItems[2].subItems[0].subItemSequence == createMenuStructureResponse.body.menuItems[2].subItems[0].subItemSequence
    And match createMenuStructurePayload.body.menuItems[2].subItems[1].id == createMenuStructureResponse.body.menuItems[2].subItems[1].id
    And match createMenuStructurePayload.body.menuItems[2].subItems[1].subItemTitle == createMenuStructureResponse.body.menuItems[2].subItems[1].subItemTitle
    And match createMenuStructurePayload.body.menuItems[2].subItems[1].subItemDescription == createMenuStructureResponse.body.menuItems[2].subItems[1].subItemDescription
    And match createMenuStructurePayload.body.menuItems[2].subItems[1].subItemUrl == createMenuStructureResponse.body.menuItems[2].subItems[1].subItemUrl
    And match createMenuStructurePayload.body.menuItems[2].subItems[1].subItemSequence == createMenuStructureResponse.body.menuItems[2].subItems[1].subItemSequence
    And match createMenuStructurePayload.body.menuItems[2].subItems[2].id == createMenuStructureResponse.body.menuItems[2].subItems[2].id
    And match createMenuStructurePayload.body.menuItems[2].subItems[2].subItemTitle == createMenuStructureResponse.body.menuItems[2].subItems[2].subItemTitle
    And match createMenuStructurePayload.body.menuItems[2].subItems[2].subItemDescription == createMenuStructureResponse.body.menuItems[2].subItems[2].subItemDescription
    And match createMenuStructurePayload.body.menuItems[2].subItems[2].subItemUrl == createMenuStructureResponse.body.menuItems[2].subItems[2].subItemUrl
    And match createMenuStructurePayload.body.menuItems[2].subItems[2].subItemSequence == createMenuStructureResponse.body.menuItems[2].subItems[2].subItemSequence

    Examples: 
      | tenantid    |
      | tenantID[0] |
