@GenericLayoutMasterInfo
Feature: Generic Layout Master info - Add, Get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayOutMasterInfoCollectionName = 'CreateGenericLayoutMasterInfo_'
    And def genericLayOutMasterInfoCollectionNameRead = 'GenericLayoutFieldCollectionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandTypes = ['GetGenericLayoutFieldCollection' , 'GetGenericLayoutCustomSections' ,'GetGenericLayoutPreBuiltSections']
    And def eventTypes = ['GenericLayoutMasterInfo']
    And def layOutType = ['GenericLayout']
    And def fieldName = ['PropertyType','PinNumber', 'SubdivsionCode','SubdivsionDescription','Phase','Town','Range','RangeDirection','Area']
    And def masterInfoFields = ['SingleFilingCode','MultipleFilingCodes','CustomerOrder#']

  @getFieldCollections
  Scenario Outline: Get the generic Layout MasterInfo details
    Given url readBaseGenericLayout
    And path '/api/'+commandTypes[0]
    And set getGenericLayoutCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[0]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.commandUserId()                |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.commandUserId()                |
      | correlationId   | dataGenerator.commandUserId()                |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[0]                              |
      | getType         | "One"                                        |
      | ttl             |                                            0 |
    And set getGenericLayoutCommandBody
      | path                | 0 |
      | fieldCollectionName | fieldCollectionName  |
    And set getGenericLayoutPayload
      | path         | [0]                              |
      | header       | getGenericLayoutCommandHeader[0] |
      | body.request | getGenericLayoutCommandBody[0]   |
    And print getGenericLayoutPayload
    And request getGenericLayoutPayload
    When method POST
    Then status 200
    And def getGenericLayoutResponse = response
    And def getGenericLayoutResponseCount = karate.sizeOf(getGenericLayoutResponse.fields)
    And print getGenericLayoutResponseCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @getCustomSections
  Scenario Outline: Get the generic Layout custom sections
    Given url readBaseGenericLayout
    And path '/api/'+commandTypes[1]
    And set getGenericLayoutCusomSectionsCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[1]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.commandUserId()                |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.commandUserId()                |
      | correlationId   | dataGenerator.commandUserId()                |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[1]                              |
      | getType         | "Array"                                      |
      | ttl             |                                            0 |
    And set getGenericLayoutCusomSectionsCommandBody
      | path        |        0 |
      | sectionType | 'Custom' |
      | isActive    | true     |
    And set getGenericLayoutCustomSectionsPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutCusomSectionsPayload
      | path                | [0]                                           |
      | header              | getGenericLayoutCusomSectionsCommandHeader[0] |
      | body.request        | getGenericLayoutCusomSectionsCommandBody[0]   |
      | body.paginationSort | getGenericLayoutCustomSectionsPagination[0]   |
    And print getGenericLayoutCusomSectionsPayload
    And request getGenericLayoutCusomSectionsPayload
    When method POST
    Then status 200
    And def getGenericLayoutCusomSectionsResponse = response
    And print getGenericLayoutCusomSectionsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @getPreBuiltSections
  Scenario Outline: Get the generic Layout custom sections
    Given url readBaseGenericLayout
    And path '/api/'+commandTypes[2]
    And set getGenericLayoutCusomSectionsCommandHeader
      | path            |                                            0 |
      | schemaUri       | schemaUri+"/"+commandTypes[2]+"-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()      |
      | version         | "1.001"                                      |
      | sourceId        | dataGenerator.commandUserId()                |
      | tenantId        | <tenantid>                                   |
      | id              | dataGenerator.commandUserId()                |
      | correlationId   | dataGenerator.commandUserId()                |
      | commandUserId   | commandUserId                                |
      | entityVersion   |                                            1 |
      | tags            | []                                           |
      | commandType     | commandTypes[2]                              |
      | getType         | "Array"                                      |
      | ttl             |                                            0 |
    And set getGenericLayoutCusomSectionsCommandBody
      | path     |    0 |
      | isActive | true |
    And set getGenericLayoutCustomSectionsPagination
      | path        |                 0 |
      | currentPage |                 1 |
      | pageSize    |               500 |
      | sortBy      | "lastModDateTime" |
      | isAscending | false             |
    And set getGenericLayoutCusomSectionsPayload
      | path                | [0]                                           |
      | header              | getGenericLayoutCusomSectionsCommandHeader[0] |
      | body.request        | getGenericLayoutCusomSectionsCommandBody[0]   |
      | body.paginationSort | getGenericLayoutCustomSectionsPagination[0]   |
    And print getGenericLayoutCusomSectionsPayload
    And request getGenericLayoutCusomSectionsPayload
    When method POST
    Then status 200
    And def getGenericLayoutCusomSectionsResponse = response
    And print getGenericLayoutCusomSectionsResponse

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @testssa
  Scenario Outline: sample test
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){'fieldCollectionCode':'#(fieldCollectionCode)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    #And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[0]+"')]")
    #And print filteredObject
    #And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[1]+"')]")
    #And print filteredObject1
    #And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[2]+"')]")
    #And print filteredObject2
    #And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[3]+"')]")
    #And print filteredObject3
    #And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[4]+"')]")
    #And print filteredObject4
    #And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[5]+"')]")
    #And print filteredObject5
    #And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[6]+"')]")
    #And print filteredObject6
    #And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+fieldName[7]+"')]")
    #And print filteredObject7
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+masterInfoFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+masterInfoFields[1]+"')]")
    And print filteredObject1

    Examples: 
      | tenantid    |
      | tenantID[0] |
