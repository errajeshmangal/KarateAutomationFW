@GenericLayoutPropertyTypeE2EDesignLayoutFeature
Feature: Property Type Layout Design-Add ,Edit,View

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericPropertyTypeDesignLayoutNameCollectionName = 'CreateGenericLayoutPropertyTypeLayoutDesign_'
    And def genericPropertyTypeDesignLayoutCollectionNameRead = 'GenericLayoutPropertyTypeLayoutDesignDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateGenericLayoutPropertyTypeLayoutDesign','GetGenericLayoutPropertyTypeLayoutDesign','UpdateGenericLayoutPropertyTypeLayoutDesign']
    And def entityName = ['GenericLayoutPropertyTypeLayoutDesign']
    And def fieldType = ["TextInput","DropDown","DatePicker","TextArea","CheckBox","RadioOptions","InputWithSearch"]
    And def propertyCategory = [ "Condo","Subdivision","SectionLandAcreage","Land"]
    And def fieldsCollection = ["LegalDescription","MarriageLicence","MarriageApplication","DeathCertificate","BirthCertificate"]
    And def condoFields = ["PropertyType","PinNumber","CondoCode","CondoDescription","Building","LowUnit","HighUnit","Phase","LowGarage","HighGarage","Split","PartFlag","NotInSidwell","Notes"]
    And def subdivisionFields = ["PropertyType","PinNumber","SubdivsionCode","SubdivsionDescription","Phase","Town","Range","Area","Block","LowLot","HighLot","City","Partial","NotInSidwell","Notes"]
    And def sectionLandAcreageFields = ["PropertyType","PinNumber","Acreage","AcreageDescription","Section","Township","TownshipRange","Range","RangeDirection","Lot","Part","Acres","Area","Half","Quarter","NotInSidwell","Notes "]
    And def landFields = ["PropertyType","LandCorners","LandCornersDescription","Section","Town","TownDirection","Range","RangeDirection","CornerLetter","CornerNumber","Notes"]
    And def historyCollectionNameRead = 'EntityHistoryDetailViewModel_'
    And def historyAndComments = ['Created','Updated']
    And def eventTypes = ['GenericLayoutPropertyType']

  @CreateandGetGenericLayoutPropertyTypeDesignLayoutwithallfieldsSubdivision
  Scenario Outline: Create a generic layout Subdivision property type with all the fields and get the data
    # Create Generic Layout design with Subdivision Property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSubdivision')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def getpropertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    #Call the get API GenericLayout Property Type Layout Design details
    And def getGenericLayoutPropertyTypeDesignLayoutResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@getGenericLayoutPropertyTypeLayoutDesign'){'getpropertyTypeId': '#(getpropertyTypeId)'}
    And def getGenericLayoutPropertyTypeDesignLayoutResponse = getGenericLayoutPropertyTypeDesignLayoutResult.response
    And print getGenericLayoutPropertyTypeDesignLayoutResponse
    And match getGenericLayoutPropertyTypeDesignLayoutResponse.id == createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def parentEntityId = null
    And def eventName = "GenericLayoutPropertyTypeLayoutDesignCreated"
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutPropertyTypeDesignLayoutwithallfieldsCondo
  Scenario Outline: Create a generic layout Subdivision property type with all the fields and get the data
    # Create Generic Layout design with Condo Property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsCondo')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def getpropertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    #Call the get API GenericLayout Property Type Layout Design details
    And def getGenericLayoutPropertyTypeDesignLayoutResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@getGenericLayoutPropertyTypeLayoutDesign'){'getpropertyTypeId': '#(getpropertyTypeId)'}
    And def getGenericLayoutPropertyTypeDesignLayoutResponse = getGenericLayoutPropertyTypeDesignLayoutResult.response
    And print getGenericLayoutPropertyTypeDesignLayoutResponse
    And match getGenericLayoutPropertyTypeDesignLayoutResponse.id == createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def parentEntityId = null
    And def eventName = "GenericLayoutPropertyTypeLayoutDesignCreated"
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutPropertyTypeDesignLayoutwithallfieldsSectionLandAcreage
  Scenario Outline: Create a generic layout Subdivision property type with all the fields and get the data
    # Create Generic Layout design with Section Land Acreage Property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSectionLandAcreage')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def getpropertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    #Call the get API GenericLayout Property Type Layout Design details
    And def getGenericLayoutPropertyTypeDesignLayoutResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@getGenericLayoutPropertyTypeLayoutDesign'){'getpropertyTypeId': '#(getpropertyTypeId)'}
    And def getGenericLayoutPropertyTypeDesignLayoutResponse = getGenericLayoutPropertyTypeDesignLayoutResult.response
    And print getGenericLayoutPropertyTypeDesignLayoutResponse
    And match getGenericLayoutPropertyTypeDesignLayoutResponse.id == createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def parentEntityId = null
    And def eventName = "GenericLayoutPropertyTypeLayoutDesignCreated"
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateandGetGenericLayoutPropertyTypeDesignLayoutwithallfieldsLand
  Scenario Outline: Create a generic layout Subdivision property type with all the fields and get the data
    # Create Generic Layout design with Land Property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsLand')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def getpropertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    #Call the get API GenericLayout Property Type Layout Design details
    And def getGenericLayoutPropertyTypeDesignLayoutResult = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@getGenericLayoutPropertyTypeLayoutDesign'){'getpropertyTypeId': '#(getpropertyTypeId)'}
    And def getGenericLayoutPropertyTypeDesignLayoutResponse = getGenericLayoutPropertyTypeDesignLayoutResult.response
    And print getGenericLayoutPropertyTypeDesignLayoutResponse
    And match getGenericLayoutPropertyTypeDesignLayoutResponse.id == createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    #Adding the comment
    And def entityName = eventTypes[0]
    And def entityComment = faker.getRandomNumber()
    And def eventEntityID = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def commandUserid = commandUserId
    And def commentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@CreateGenericLayoutEntityComment') {entityComment : '#(entityComment)'}{eventEntityID : '#(eventEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def createCommentResponse = commentResult.response
    And print createCommentResponse
    And match createCommentResponse.body.comment == entityComment
    #updating the comments
    And def updatedEntityComment = faker.getRandomNumber()
    And def commentEntityID = createCommentResponse.body.id
    And def updateCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@UpdateGenericLayoutEntityComment') {updatedEntityComment : '#(updatedEntityComment)'}{commentEntityID : '#(commentEntityID)'} {entityName : '#(entityName)'}{commandUserid : '#(commandUserid)'}
    And def updatedCommentResponse = updateCommentResult.response
    And print updatedCommentResponse
    And match updatedCommentResponse.body.comment == updatedEntityComment
    And sleep(15000)
    #view the comments
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse.comment == updatedEntityComment
    #Get all the comments
    And def evnentType = eventTypes[0]
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetTheGenericLayoutEntityComments') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.results[0].comment == updatedEntityComment
    #Delete The comment
    And def deleteCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@DeleteGenericLayoutEntityComment') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def deleteCommentsResponse = deleteCommentResult.response
    And print deleteCommentsResponse
    # view the comment after delete
    And def viewCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@ValidateGenericLayoutDeleteEntityComment') {commentEntityID : '#(commentEntityID)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentResponse = viewCommentResult.response
    And print viewCommentResponse
    And match viewCommentResponse == 'null'
    #Get all the comments after delete
    And def viewAllCommentResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/genericLayoutComments.feature@GetAllTheGenericLayoutEntityCommentsAfterDelete') {entityIdData : '#(entityIdData)'}{commentEntityID : '#(commentEntityID)'}{evnentType : '#(evnentType)'}{commandUserid : '#(commandUserid)'}
    And def viewCommentsResponse = viewAllCommentResult.response
    And print viewCommentsResponse
    And match viewCommentsResponse.totalRecordCount == 0
    #HistoryValidation
    And def entityIdData = getGenericLayoutPropertyTypeDesignLayoutResponse.id
    And def parentEntityId = null
    And def eventName = "GenericLayoutPropertyTypeLayoutDesignCreated"
    And def evnentType = eventTypes[0]
    And def commandUserid = commandUserId
    And def historyResult = call read('classpath:com/api/rm/countyAdmin/HistoryComments/History.feature@GetGenericLaytoutEntityHistoryWithAllFields'){entityIdData : '#(entityIdData)'} {eventName : '#(eventName)'}{evnentType : '#(evnentType)'} {commandUserid : '#(commandUserid)'}
    And def historyResponse = historyResult.response
    And print historyResponse
    And match historyResponse.results[*].entityId contains entityIdData
    And match historyResponse.results[*].eventName contains eventName
    And def entity = historyResponse.results[0].id
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayoutRead,historyCollectionNameRead+<tenantid>,entity)
    And print mongoResult
    And match mongoResult == entity
    And def getHistoryResponseCount = karate.sizeOf(historyResponse.results)
    And print getHistoryResponseCount

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutPropertyTypeLayoutDesignwithallfieldsSubdivision
  Scenario Outline: Update generic layout property type Layout design  with all Details and get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    #Create Generic Layout  property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSubdivision')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def propertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[13]+"')]")
    And print filteredObject13
    And def filteredObject14 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[14]+"')]")
    And print filteredObject14
    And def entityIdData = dataGenerator.entityID()
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader
      | path            |                                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                  |
      | version         | "1.001"                                                                  |
      | sourceId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                               |
      | id              | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.commandUserId |
      | entityVersion   |                                                                        1 |
      | tags            | []                                                                       |
      | commandType     | commandType[2]                                                           |
      | entityName      | entityName[0]                                                            |
      | ttl             |                                                                        0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody
      | path           |                                                           0 |
      | id             | createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id |
      | propertyTypeId | propertyTypeId                                              |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutPayload
      | path        | [0]                                                                 |
      | header      | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader[0] |
      | body        | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody[0]   |
      | body.fields | commandfields                                                       |
    And print updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    And request updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyTypeDeisgnLayoutResponse = response
    And print updateGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id
    And match updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id == updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    And def filterResult = updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.fields[2]
    And print filterResult
    And match filterResult.fieldCode contains condoFields[2]
    And match updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.fields[3].fieldName == filteredObject3[0].fieldName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutPropertyTypeLayoutDesignwithallfieldsCondo
  Scenario Outline: Update generic layout property type Layout design  with all Details and get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    #Create Generic Layout  property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsCondo')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def propertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+condoFields[13]+"')]")
    And print filteredObject13
    And def entityIdData = dataGenerator.entityID()
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader
      | path            |                                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                  |
      | version         | "1.001"                                                                  |
      | sourceId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                               |
      | id              | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.commandUserId |
      | entityVersion   |                                                                        1 |
      | tags            | []                                                                       |
      | commandType     | commandType[2]                                                           |
      | entityName      | entityName[0]                                                            |
      | ttl             |                                                                        0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[3]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject3[0].placeHolderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[4]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject4[0].placeHolderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[5]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject5[0].placeHolderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody
      | path           |                                                           0 |
      | id             | createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id |
      | propertyTypeId | propertyTypeId                                              |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutPayload
      | path        | [0]                                                                 |
      | header      | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader[0] |
      | body        | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody[0]   |
      | body.fields | commandfields                                                       |
    And print updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    And request updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyTypeDeisgnLayoutResponse = response
    And print updateGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id
    And match updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id == updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    And def filterResult = updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.fields[2]
    And print filterResult
    And match filterResult.fieldCode contains sectionLandAcreageFields[2]
    And match updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.fields[5].fieldName == filteredObject5[0].fieldName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutPropertyTypeLayoutDesignwithallfieldsSectionLandAcreage
  Scenario Outline: Update generic layout property type Layout design  with all Details and get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    #Create Generic Layout  property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsSectionLandAcreage')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def propertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[10]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[11]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[12]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[13]+"')]")
    And print filteredObject13
    And def filteredObject14 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[14]+"')]")
    And print filteredObject14
    And def filteredObject15 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[15]+"')]")
    And print filteredObject15
    And def filteredObject16 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+sectionLandAcreageFields[16]+"')]")
    And print filteredObject16
    #update property type design layout
    And def entityIdData = dataGenerator.entityID()
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader
      | path            |                                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                  |
      | version         | "1.001"                                                                  |
      | sourceId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                               |
      | id              | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.commandUserId |
      | entityVersion   |                                                                        1 |
      | tags            | []                                                                       |
      | commandType     | commandType[2]                                                           |
      | entityName      | entityName[0]                                                            |
      | ttl             |                                                                        0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody
      | path           |                                                           0 |
      | id             | createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id |
      | propertyTypeId | propertyTypeId                                              |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutPayload
      | path        | [0]                                                                 |
      | header      | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader[0] |
      | body        | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody[0]   |
      | body.fields | commandfields                                                       |
    And print updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    And request updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyTypeDeisgnLayoutResponse = response
    And print updateGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id
    And match updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id == updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    And def filterResult = updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.fields[1]
    And print filterResult
    And match filterResult.fieldCode contains landFields[1]
    And match updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.fields[1].fieldName == filteredObject1[0].fieldName

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateandGetGenericLayoutPropertyTypeLayoutDesignwithallfieldsLand
  Scenario Outline: Update generic layout property type Layout design  with all Details and get the details
    Given url commandBaseGenericLayout
    And path '/api/'+commandType[2]
    #Create Generic Layout  property Type
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/propertyType/layoutDesign/CreateGenericLayoutPropertyTypeDesignLayout.feature@CreateGenericLayoutPropertyTypeDesignLayoutwithallfieldsLand')
    And def createGenericLayoutPropertyTypeDeisgnLayoutResponse = result.response
    And print createGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def propertyTypeId = createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.propertyTypeId
    # Call Generic Layout Field collection API
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections')
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[0]+"')]")
    And print filteredObject
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[1]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+subdivisionFields[2]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[3]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[4]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[5]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[6]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[7]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[8]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[9]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+landFields[10]+"')]")
    And print filteredObject10
    #update property type design layout
    And def entityIdData = dataGenerator.entityID()
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader
      | path            |                                                                        0 |
      | schemaUri       | schemaUri+"/"+commandType[2]+"-v1.001.json"                              |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                                  |
      | version         | "1.001"                                                                  |
      | sourceId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.sourceId      |
      | tenantId        | <tenantid>                                                               |
      | id              | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.id            |
      | correlationId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.correlationId |
      | entityId        | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.entityId      |
      | commandUserId   | createGenericLayoutPropertyTypeDeisgnLayoutResponse.header.commandUserId |
      | entityVersion   |                                                                        1 |
      | tags            | []                                                                       |
      | commandType     | commandType[2]                                                           |
      | entityName      | entityName[0]                                                            |
      | ttl             |                                                                        0 |
    And set commandfields
      | path                                 |                                                      0 |
      | fieldId                              | filteredObject[0].fieldId                              |
      | fieldCode                            | filteredObject[0].fieldCode                            |
      | fieldName                            | filteredObject[0].fieldName                            |
      | fieldLabel                           | filteredObject[0].fieldLabel                           |
      | fieldType                            | "TextInput"                                            |
      | ovveriddenLabelText                  | filteredObject[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject[0].placeHolderText                      |
      | isRequiredField                      | filteredObject[0].isRequiredField                      |
      | helpText                             | filteredObject[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject[0].row                                  |
      | columnNumber                         | filteredObject[0].columnNumber                         |
      | size                                 | filteredObject[0].size                                 |
      | dataCommand                          | filteredObject[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject1[0].placeHolderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[1]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeHolderText                      | filteredObject2[0].placeHolderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody
      | path           |                                                           0 |
      | id             | createGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id |
      | propertyTypeId | propertyTypeId                                              |
    And set updateGenericLayoutPropertyTypeDeisgnLayoutPayload
      | path        | [0]                                                                 |
      | header      | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandHeader[0] |
      | body        | updateGenericLayoutPropertyTypeDeisgnLayoutResponseCommandBody[0]   |
      | body.fields | commandfields                                                       |
    And print updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    And request updateGenericLayoutPropertyTypeDeisgnLayoutPayload
    When method POST
    Then status 201
    And def updateGenericLayoutPropertyTypeDeisgnLayoutResponse = response
    And print updateGenericLayoutPropertyTypeDeisgnLayoutResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericPropertyTypeDesignLayoutNameCollectionName+<tenantid>,updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id)
    And print mongoResult
    And match mongoResult == updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id
    And match updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.id == updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.id
    And def filterResult = updateGenericLayoutPropertyTypeDeisgnLayoutPayload.body.fields[2]
    And print filterResult
    And match filterResult.fieldCode contains subdivisionFields[2]
    And match updateGenericLayoutPropertyTypeDeisgnLayoutResponse.body.fields[2].fieldName == filteredObject2[0].fieldName

    Examples: 
      | tenantid    |
      | tenantID[0] |
