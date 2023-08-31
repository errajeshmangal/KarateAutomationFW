Feature: Validate the Comments

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def commentsCollectionName = 'CreateEntityComment_'
    And def commentsCollectionNameRead = 'EntityCommentDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
     And call read('classpath:com/api/rm/helpers/Wait.feature@wait')

  @CreateEntityComment
  Scenario Outline: Create the comment
    Given url commandBaseUrl
    And path '/api/CreateEntityComment'
    And def entityIdData = dataGenerator.entityID()
    And set createCommentCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/CreateEntityComment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | entityIdData                                 |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | "CreateEntityComment"                        |
      | entityName      | "EntityComment"                              |
      | ttl             |                                            0 |
    And set createCommentCommandBody
      | path       |             0 |
      | id         | entityIdData  |
      | entityName | entityName    |
      | comment    | entityComment |
      | entityId   | eventEntityID |
      | isActive   | true          |
    And set createCommentPayload
      | path   | [0]                           |
      | header | createCommentCommandHeader[0] |
      | body   | createCommentCommandBody[0]   |
    And print createCommentPayload
    And request createCommentPayload
    When method POST
    Then status 201
    And def mongoResult = mongoData.MongoDBReader(dbname,commentsCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == response.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateEntityComment
  Scenario Outline: Create the comment
    Given url commandBaseUrl
    And path '/api/UpdateEntityComment'
    And def entityIdData = dataGenerator.entityID()
    And set updateCommentCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/UpdateEntityComment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | commentEntityID                              |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | "UpdateEntityComment"                        |
      | entityName      | "EntityComment"                              |
      | ttl             |                                            0 |
    And set updateCommentCommandBody
      | path       |                    0 |
      | id         | commentEntityID      |
      | entityName | entityName           |
      | comment    | updatedEntityComment |
      | entityId   | eventEntityID        |
      | isActive   | true                 |
    And set updateCommentPayload
      | path   | [0]                           |
      | header | updateCommentCommandHeader[0] |
      | body   | updateCommentCommandBody[0]   |
    And print updateCommentPayload
    And request updateCommentPayload
    When method POST
    Then status 201
    And def mongoResult = mongoData.MongoDBReader(dbname,commentsCollectionName+<tenantid>,commentEntityID)
    And print mongoResult
    And match mongoResult == response.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetTheEntityComment
  Scenario Outline: View the entity comment
    Given url readBaseUrl
    And path '/api/GetEntityComment'
    And set getCommentCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityComment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | entityId        | eventEntityID                             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityComment"                        |
      | getType         | "One"                                     |
    And set getCommentCommandBody
      | path |               0 |
      | id   | commentEntityID |
    And set getEntityCommentPayload
      | path         | [0]                        |
      | header       | getCommentCommandHeader[0] |
      | body.request | getCommentCommandBody[0]   |
    And print getEntityCommentPayload
    And request getEntityCommentPayload
    When method POST
    Then status 200
    And print response
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,commentsCollectionNameRead+<tenantid>,commentEntityID)
    And print mongoResult
    And match mongoResult == response.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetTheEntityComments
  Scenario Outline: View all the entity comments
    Given url readBaseUrl
    And path '/api/GetEntityComments'
    And set getCommentsCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetEntityComments-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | commandUserId   | commandUserId                              |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetEntityComments"                        |
      | getType         | "Array"                                    |
    And set getCommentsCommandBodyRequest
      | path       |            0 |
      | entityId   | entityIdData |
      | entityName | evnentType   |
    And set getCommentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityCommentsPayload
      | path                | [0]                              |
      | header              | getCommentsCommandHeader[0]      |
      | body.request        | getCommentsCommandBodyRequest[0] |
      | body.paginationSort | getCommentsCommandPagination[0]  |
    And print getEntityCommentsPayload
    And request getEntityCommentsPayload
    When method POST
    Then status 200
    And print response
    And def mongoResult = mongoData.MongoDBReader(dbnameGet,commentsCollectionNameRead+<tenantid>,response.results[0].id)
    And print mongoResult
    And match mongoResult == response.results[0].id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @DeleteEntityComment
  Scenario Outline: Delete the comment
    Given url commandBaseUrl
    And path '/api/DeleteEntityComment'
    And set deleteCommentCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/DeleteEntityComment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.SourceID()                     |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.Id()                           |
      | correlationId   | dataGenerator.correlationId()                |
      | entityId        | commentEntityID                              |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            2 |
      | tags            | []                                           |
      | commandType     | "DeleteEntityComment"                        |
      | entityName      | "EntityComment"                              |
      | ttl             |                                            0 |
    And set deleteCommentCommandBody
      | path       |               0 |
      | id         | commentEntityID |
      | entityName | entityName      |
      | entityId   | eventEntityID   |
    And set deleteCommentPayload
      | path   | [0]                           |
      | header | deleteCommentCommandHeader[0] |
      | body   | deleteCommentCommandBody[0]   |
    And print deleteCommentPayload
    And request deleteCommentPayload
    When method POST
    Then status 201
    And print response
    Examples: 
      | tenantid    |
      | tenantID[0] |

  @ValidateDeleteEntityComment
  Scenario Outline: Validate the delete entity comment
    Given url readBaseUrl
    And path '/api/GetEntityComment'
    And set getCommentCommandHeader
      | path            |                                         0 |
      | schemaUri       | schemaUri+"/GetEntityComment-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()   |
      | version         | "1.001"                                   |
      | sourceId        | dataGenerator.SourceID()                  |
      | tenantId        | <tenantid>                                |
      | id              | dataGenerator.Id()                        |
      | correlationId   | dataGenerator.correlationId()             |
      | entityId        | eventEntityID                             |
      | commandUserId   | commandUserId                             |
      | ttl             |                                         0 |
      | tags            | []                                        |
      | commandType     | "GetEntityComment"                        |
      | getType         | "One"                                     |
    And set getCommentCommandBody
      | path |               0 |
      | id   | commentEntityID |
    And set getEntityCommentPayload
      | path         | [0]                        |
      | header       | getCommentCommandHeader[0] |
      | body.request | getCommentCommandBody[0]   |
    And print getEntityCommentPayload
    And request getEntityCommentPayload
    And sleep(15000)
    When method POST
    Then status 200
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @GetAllTheEntityCommentsAfterDelete
  Scenario Outline: View all the entity comments
    Given url readBaseUrl
    And path '/api/GetEntityComments'
    And set getCommentsCommandHeader
      | path            |                                          0 |
      | schemaUri       | schemaUri+"/GetEntityComments-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()    |
      | version         | "1.001"                                    |
      | sourceId        | dataGenerator.SourceID()                   |
      | tenantId        | <tenantid>                                 |
      | id              | dataGenerator.Id()                         |
      | correlationId   | dataGenerator.correlationId()              |
      | commandUserId   | commandUserId                              |
      | ttl             |                                          0 |
      | tags            | []                                         |
      | commandType     | "GetEntityComments"                        |
      | getType         | "Array"                                    |
    And set getCommentsCommandBodyRequest
      | path       |            0 |
      | entityId   | entityIdData |
      | entityName | evnentType   |
    And set getCommentsCommandPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               100 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getEntityCommentsPayload
      | path                | [0]                              |
      | header              | getCommentsCommandHeader[0]      |
      | body.request        | getCommentsCommandBodyRequest[0] |
      | body.paginationSort | getCommentsCommandPagination[0]  |
    And print getEntityCommentsPayload
    And request getEntityCommentsPayload
      And sleep(15000)
    When method POST
    Then status 200
    And print response

    Examples: 
      | tenantid    |
      | tenantID[0] |

