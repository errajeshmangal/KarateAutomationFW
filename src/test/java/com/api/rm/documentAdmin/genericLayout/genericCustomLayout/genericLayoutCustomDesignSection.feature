@GenericLayoutCustomSection
Feature: Generic Layout Custom Section- Add , Update, get

  Background: 
    And def mongoData = Java.type('com.api.rm.helpers.MongoDBHelper')
    And def dataGenerator = Java.type('com.api.rm.helpers.DataGenerator')
    And def faker = Java.type('com.api.rm.helpers.faker')
    And def applicationID = ['f2429dcf-ebfa-435a-a9be-20913d142739']
    And def genericLayoutNameCollectionName = 'CreateLayoutDesignCustomSection_'
    And def genericLayoutNameCollectionNameRead = 'GenericLayoutCustomSectionDetailViewModel_'
    And def headers = {Accept: 'application/json', Content-Type: 'application/json'}
    And call read('classpath:com/api/rm/helpers/Wait.feature@wait')
    And def commandType = ['CreateLayoutDesignCustomSection','UpdateLayoutDesignCustomSection']
    And def entityName = ['LayoutDesignCustomSection']
    And def layoutType = ['Section']
    And def fieldsCollection = ["MarriageLicence","DeathCertificate","BirthCertificate"]
    And def sectionType = ["Custom","Prebuilt"]
    And def MarriageLicence = ["DocumentNumber","DocumentType","RecordedDateTime","PageCount","RecordingFee","BookCode", "BookNumber" ,"Page#","Description","DateMarried","DateReturned","FirstName","MiddleName","LastName","Suffix","SurnameatBirth","DateofBirth","Age","EvidenceofAge" ,"Gender", "AddressLine1","AddressLine2","City","State","Zipcode","County","ByProxy","BirthPlace","NumberofthisMarriage","SocialSecurityNumber","RelationshiptoApplicantTwo","ReasonLastMarriageended","DateEnded","Notpresentlymarried","Notrelatedtoother","Activemilitary","Divorced>30Days" ,"ChildSupportnotDelinquent","Otherpartynotmarried","Ethnicity","EducationlevelGrades1-12","Collegeandabove","Parent1firstname" ,"Parent1middleName","Parent1LastName","Parent1Suffix","Parent1Surname","Parent1Birthplace","Parent2firstname","Parent2middleName","Parent2LastName","Parent2Suffix","Parent2Surname","Parent2Birthplace","CeremonyAddress","CeremonyCity","CeremonyState","CeremonyZip","CeremonyCounty","OfficiantTitle","OfficiantName","OfficiantPhoneNumber","OfficiantAddress","OfficiantCity","OfficiantState","OfficiantZip","OfficiantCounty","Witness1Name","Witness1Address","Witness1City","Witness1State","Witness1Zip","Witness2Name","Witness2Address","Witness2City","Witness2State","Witness2Zip"]
    And def DeathCertificate = ["DeceasedDate","DeceasedStateNo","FirstName","MiddleName","LastName","Suffix"]
    And def BirthCertificate = ["DocumentNumber","DocumentType","RecordedDateTime","PageCount","RecordingFee","BookCode","BookNumber","Description","FirstName","MiddleName","LastName","Suffix","DateOfBirth","SexofChild"]
    And def fieldType = ["TextInput","DropDown","DatePicker","TextArea","CheckBox","RadioOptions","InputWithSearch"]
		And def commandTypeList = ['Create','Update']
    And def targetTypeList = ['Topic','Url']
    
  @CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithAllDetails
  Scenario Outline: Create a custom generic layout Design code with marriage licence custom section with all the fields
    # Call Generic Layout Custom Section API for marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicence')
    And def customSectionResponse = result.response
    And print customSectionResponse
    # Call Generic Layout Design Field collection API
    And def fieldCollectionName = fieldsCollection[0]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[12]+"')]")
    And print filteredObject13
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |


@CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithMandatoryFields
  Scenario Outline: Create a custom generic layout Design code with marriage licence custom section with Mandatory FIelds
    # Call Generic Layout Custom Section API for marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageLicenceWithMandatoryDetails')
    And def customSectionResponse = result.response
    And print customSectionResponse
    # Call Generic Layout Design Field collection API
    And def fieldCollectionName = fieldsCollection[0]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[12]+"')]")
    And print filteredObject13
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateGenericLayoutDesignCustomSectionFieldsMarriageApplicationWithAllDetails
  Scenario Outline: Create a custom generic layout code with marriage Application custom section with all the fields
    # Create Generic Layout Marriage Application
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionMarriageApplication')
    And def addGenericLayoutCustomSectionResponse = result.response
    And print addGenericLayoutCustomSectionResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    # Call Generic Layout Field collection API
    And def fieldCollectionName = fieldsCollection[0]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+MarriageLicence[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                                             0 |
      | id        | entityIdData                                  |
      | sectionId | addGenericLayoutCustomSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithAllDetails
  Scenario Outline: Update a custom generic layout code with marriage licence custom section with all the fields
      # Call  Create Layout Custom Design Section API for marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithAllDetails')
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+MarriageLicence[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+MarriageLicence[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+MarriageLicence[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+MarriageLicence[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+MarriageLicence[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+MarriageLicence[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[6], "$[?(@.fieldCode == '"+MarriageLicence[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[7], "$[?(@.fieldCode == '"+MarriageLicence[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[8], "$[?(@.fieldCode == '"+MarriageLicence[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[9], "$[?(@.fieldCode == '"+MarriageLicence[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[10], "$[?(@.fieldCode == '"+MarriageLicence[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[11], "$[?(@.fieldCode == '"+MarriageLicence[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[12], "$[?(@.fieldCode == '"+MarriageLicence[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
      And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | BirthCertificate[10]                                    |
      | fieldName                            | BirthCertificate[11]                                    |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @UpdateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithMandatoryDetails
  Scenario Outline: Update a custom generic layout code with marriage licence custom section with Mandatory fields
      # Call  Create Layout Custom Design Section API for marriage Licence
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateGenericLayoutDesignCustomSectionFieldsMarriageLicenceWithMandatoryFields')
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+MarriageLicence[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+MarriageLicence[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+MarriageLicence[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+MarriageLicence[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+MarriageLicence[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+MarriageLicence[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[6], "$[?(@.fieldCode == '"+MarriageLicence[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[7], "$[?(@.fieldCode == '"+MarriageLicence[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[8], "$[?(@.fieldCode == '"+MarriageLicence[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[9], "$[?(@.fieldCode == '"+MarriageLicence[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[10], "$[?(@.fieldCode == '"+MarriageLicence[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[11], "$[?(@.fieldCode == '"+MarriageLicence[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[12], "$[?(@.fieldCode == '"+MarriageLicence[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
      And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | BirthCertificate[10]                                    |
      | fieldName                            | BirthCertificate[11]                                    |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @CreateCustomLayoutDesignSectionFieldsDeathCertificateWithAllDetails
  Scenario Outline: Create a custom Layout Design code with DeathCertificate for all the fields
    # Call Generic Layout Custom Section API for   DeathCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificate')
    And def customSectionResponse = result.response
    And print customSectionResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    # Call Generic Layout Field collection API
    And def fieldCollectionName = fieldsCollection[1]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[5]+"')]")
    And print filteredObject6
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
 @CreateCustomLayoutDesignSectionFieldsDeathCertificateWithMandatoryFields
  Scenario Outline: Create a custom Layout Design code with DeathCertificate With Mandatory Fields
    # Call Generic Layout Custom Section API for   DeathCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionDeathCertificateWithMandatoryDetails')
    And def customSectionResponse = result.response
    And print customSectionResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    # Call Generic Layout Field collection API
    And def fieldCollectionName = fieldsCollection[1]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+DeathCertificate[5]+"')]")
    And print filteredObject6
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCustomSectionDesignFieldsDeathCertificateWithAllDetails
  Scenario Outline: Update a custom Layout Design with Death Certificate for all the fields
      # Call Generic Layout Custom Section API for Death Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomLayoutDesignSectionFieldsDeathCertificateWithAllDetails')
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+DeathCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+DeathCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+DeathCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+DeathCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+DeathCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+DeathCertificate[5]+"')]")
    And print filteredObject6
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
  And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | BirthCertificate[10]                                    |
      | fieldName                            | BirthCertificate[11]                                    |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |


 @UpdateCustomSectionDesignFieldsDeathCertificateWithMandatoryDetails
  Scenario Outline: Update a custom Layout Design with Death Certificate Mandatory Fields
      # Call Generic Layout Custom Section API for Death Certificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomLayoutDesignSectionFieldsDeathCertificateWithMandatoryFields')
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+DeathCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+DeathCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+DeathCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+DeathCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+DeathCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+DeathCertificate[5]+"')]")
    And print filteredObject6
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
  And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | BirthCertificate[10]                                    |
      | fieldName                            | BirthCertificate[11]                                    |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
  @CreateCustomSectionFieldsBirthCertificateWithAllDetails
  Scenario Outline: Create a custom Layout Design code with BirthCertificate for all the fields
    # Call Generic Layout Custom Section API for  BirthCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificate')
    And def customSectionResponse = result.response
    And print customSectionResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    # Call Generic Layout Field collection API
    And def fieldCollectionName = fieldsCollection[2]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |
      
      @CreateCustomDesignSectionFieldsBirthCertificateWithMandaotryFields
  Scenario Outline: Create a custom Layout Design code with BirthCertificate for Mandatory Fields
    # Call Generic Layout Custom Section API for  BirthCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomSection.feature@CreateGenericLayoutCustomSectionBirthCertificateWithMandatoryDetails')
    And def customSectionResponse = result.response
    And print customSectionResponse
    #Retrieve the Target Topics List
    And def targetTopicsResult = call read('classpath:com/api/rm/workflowAdministration/QueuesConfigurations/processQueue/TargetTopic/TargetTopic.feature@GetTargetTopics')
    And def targetTopicsResultResponse = targetTopicsResult.response
    And print targetTopicsResultResponse
    # Call Generic Layout Field collection API
    And def fieldCollectionName = fieldsCollection[2]
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/fieldsAndSections/FieldsAndSections.feature@getFieldCollections'){fieldCollectionName : '#(fieldCollectionName)'}
    And def getGenericLayoutResponse = result.response
    And def filteredResponse = getGenericLayoutResponse.fields
    And print filteredResponse
    And def filteredObject1 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject6 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(filteredResponse, "$[?(@.fieldCode == '"+BirthCertificate[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/CreateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set CreateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/CreateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | dataGenerator.SourceID()                                 |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | dataGenerator.correlationId()                            |
      | entityId        | entityIdData                                             |
      | commandUserId   | commandUserId                                            |
      | entityVersion   |                                                        1 |
      | tags            | []                                                       |
      | commandType     | commandType[0]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set CreateLayoutDesignCustomSectionCommandBody
      | path      |                             0 |
      | id        | entityIdData                  |
      | sectionId | customSectionResponse.body.id |
      And set CreateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[0]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[0]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | targetTopicsResultResponse.results[0].id   |
      | targetTopic.code | targetTopicsResultResponse.results[0].code |
      | targetTopic.name | targetTopicsResultResponse.results[0].name |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | filteredObject1[0].fieldCode                            |
      | fieldName                            | filteredObject1[0].fieldName                            |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[2]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set CreateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | CreateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | CreateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | CreateLayoutDesignCustomSectiondataCommands |
    And print CreateLayoutDesignCustomSectionPayload
    And request CreateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def CreateLayoutDesignCustomSectionResponse = response
    And print CreateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,entityIdData)
    And print mongoResult
    And match mongoResult == CreateLayoutDesignCustomSectionResponse.body.id
    And match CreateLayoutDesignCustomSectionResponse.body.sectionId == CreateLayoutDesignCustomSectionPayload.body.sectionId
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match CreateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == CreateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match CreateLayoutDesignCustomSectionResponse.body.id == CreateLayoutDesignCustomSectionPayload.body.id

    Examples: 
      | tenantid    |
      | tenantID[0] |

  @UpdateCustomDesinSectionFieldsBirthCertificateWithAllDetails
  Scenario Outline: Update a custom Layout Design code with BirthCertificate for all the fields
     # Call Generic Layout Custom Section API for  BirthCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomSectionFieldsBirthCertificateWithAllDetails')
    And def customDesignFieldsSectionResponse = result.response
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+BirthCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+BirthCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+BirthCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+BirthCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+BirthCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[6], "$[?(@.fieldCode == '"+BirthCertificate[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[7], "$[?(@.fieldCode == '"+BirthCertificate[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[8], "$[?(@.fieldCode == '"+BirthCertificate[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[9], "$[?(@.fieldCode == '"+BirthCertificate[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[10], "$[?(@.fieldCode == '"+BirthCertificate[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[11], "$[?(@.fieldCode == '"+BirthCertificate[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[12], "$[?(@.fieldCode == '"+BirthCertificate[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
     And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | DeathCertificate[0]                                     |
      | fieldName                            | DeathCertificate[1]                                     |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

     Examples: 
      | tenantid    |
      | tenantID[0] |
      
        @UpdateCustomDesinSectionFieldsBirthCertificateWithMandatory
  Scenario Outline: Update a custom Layout Design code with BirthCertificate for Mandatory fields
     # Call Generic Layout Custom Section API for  BirthCertificate
    And def result = call read('classpath:com/api/rm/documentAdmin/genericLayout/genericCustomLayout/genericLayoutCustomDesignSection.feature@CreateCustomDesignSectionFieldsBirthCertificateWithMandaotryFields')
    And def customDesignFieldsSectionResponse = result.response
    And def customDesignFieldsSectionResponse = result.response
    And print customDesignFieldsSectionResponse
    And def filteredObject1 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[0], "$[?(@.fieldCode == '"+BirthCertificate[0]+"')]")
    And print filteredObject1
    And def filteredObject2 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[1], "$[?(@.fieldCode == '"+BirthCertificate[1]+"')]")
    And print filteredObject2
    And def filteredObject3 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[2], "$[?(@.fieldCode == '"+BirthCertificate[2]+"')]")
    And print filteredObject3
    And def filteredObject4 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[3], "$[?(@.fieldCode == '"+BirthCertificate[3]+"')]")
    And print filteredObject4
    And def filteredObject5 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[4], "$[?(@.fieldCode == '"+BirthCertificate[4]+"')]")
    And print filteredObject5
    And def filteredObject6 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[5], "$[?(@.fieldCode == '"+BirthCertificate[5]+"')]")
    And print filteredObject6
    And def filteredObject7 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[6], "$[?(@.fieldCode == '"+BirthCertificate[6]+"')]")
    And print filteredObject7
    And def filteredObject8 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[7], "$[?(@.fieldCode == '"+BirthCertificate[7]+"')]")
    And print filteredObject8
    And def filteredObject9 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[8], "$[?(@.fieldCode == '"+BirthCertificate[8]+"')]")
    And print filteredObject9
    And def filteredObject10 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[9], "$[?(@.fieldCode == '"+BirthCertificate[9]+"')]")
    And print filteredObject10
    And def filteredObject11 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[10], "$[?(@.fieldCode == '"+BirthCertificate[10]+"')]")
    And print filteredObject11
    And def filteredObject12 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[11], "$[?(@.fieldCode == '"+BirthCertificate[11]+"')]")
    And print filteredObject12
    And def filteredObject13 = karate.jsonPath(customDesignFieldsSectionResponse.body.fields[12], "$[?(@.fieldCode == '"+BirthCertificate[12]+"')]")
    And print filteredObject13
    Given url commandBaseGenericLayout
    And path '/api/UpdateLayoutDesignCustomSection'
    And def entityIdData = dataGenerator.entityID()
    And set updateLayoutDesignCustomSectionCommandHeader
      | path            |                                                        0 |
      | schemaUri       | schemaUri+"/UpdateLayoutDesignCustomSection-v1.001.json" |
      | commandDateTime | dataGenerator.generateCurrentDateTime()                  |
      | version         | "1.001"                                                  |
      | sourceId        | customDesignFieldsSectionResponse.header.sourceId        |
      | tenantId        | <tenantid>                                               |
      | id              | dataGenerator.Id()                                       |
      | correlationId   | customDesignFieldsSectionResponse.header.correlationId   |
      | entityId        | customDesignFieldsSectionResponse.header.entityId        |
      | commandUserId   | customDesignFieldsSectionResponse.header.commandUserId   |
      | entityVersion   |                                                        2 |
      | tags            | []                                                       |
      | commandType     | commandType[1]                                           |
      | entityName      | entityName[0]                                            |
      | ttl             |                                                        0 |
    And set updateLayoutDesignCustomSectionCommandBody
      | path      |                                                0 |
      | id        | customDesignFieldsSectionResponse.body.id        |
      | sectionId | customDesignFieldsSectionResponse.body.sectionId |
     And set updateLayoutDesignCustomSectiondataCommands
      | path             |                                          0 |
      | id               | entityIdData                               |
      | sequence         |                                          0 |
      | commandName      | faker.getFirstName()                       |
      | commandType      | commandTypeList[1]                         |
      | description      | faker.getRandomShortDescription()          |
      | targetType       | targetTypeList[1]                          |
      | targetUrl        | faker.getFirstName()                       |
      | targetTopic.id   | dataGenerator.Id()   |
      | targetTopic.code | faker.getUserId() |
      | targetTopic.name | faker.getFirstName()  |
      | isActive         | faker.getRandomBooleanValue()              |
    And set commandfields
      | path                                 |                                                       0 |
      | fieldId                              | filteredObject1[0].fieldId                              |
      | fieldCode                            | DeathCertificate[0]                                     |
      | fieldName                            | DeathCertificate[1]                                     |
      | fieldLabel                           | filteredObject1[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject1[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject1[0].placeholderText                      |
      | isRequiredField                      | filteredObject1[0].isRequiredField                      |
      | helpText                             | filteredObject1[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject1[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject1[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject1[0].row                                  |
      | columnNumber                         | filteredObject1[0].columnNumber                         |
      | size                                 | filteredObject1[0].size                                 |
      | dataCommand                          | filteredObject1[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       1 |
      | fieldId                              | filteredObject2[0].fieldId                              |
      | fieldCode                            | filteredObject2[0].fieldCode                            |
      | fieldName                            | filteredObject2[0].fieldName                            |
      | fieldLabel                           | filteredObject2[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject2[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject2[0].placeholderText                      |
      | isRequiredField                      | filteredObject2[0].isRequiredField                      |
      | helpText                             | filteredObject2[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject2[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject2[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject2[0].row                                  |
      | columnNumber                         | filteredObject2[0].columnNumber                         |
      | size                                 | filteredObject2[0].size                                 |
      | dataCommand                          | filteredObject2[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       2 |
      | fieldId                              | filteredObject3[0].fieldId                              |
      | fieldCode                            | filteredObject3[0].fieldCode                            |
      | fieldName                            | filteredObject3[0].fieldName                            |
      | fieldLabel                           | filteredObject3[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject3[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject3[0].placeholderText                      |
      | isRequiredField                      | filteredObject3[0].isRequiredField                      |
      | helpText                             | filteredObject3[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject3[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject3[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject3[0].row                                  |
      | columnNumber                         | filteredObject3[0].columnNumber                         |
      | size                                 | filteredObject3[0].size                                 |
      | dataCommand                          | filteredObject3[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       3 |
      | fieldId                              | filteredObject4[0].fieldId                              |
      | fieldCode                            | filteredObject4[0].fieldCode                            |
      | fieldName                            | filteredObject4[0].fieldName                            |
      | fieldLabel                           | filteredObject4[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject4[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject4[0].placeholderText                      |
      | isRequiredField                      | filteredObject4[0].isRequiredField                      |
      | helpText                             | filteredObject4[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject4[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject4[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject4[0].row                                  |
      | columnNumber                         | filteredObject4[0].columnNumber                         |
      | size                                 | filteredObject4[0].size                                 |
      | dataCommand                          | filteredObject4[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       4 |
      | fieldId                              | filteredObject5[0].fieldId                              |
      | fieldCode                            | filteredObject5[0].fieldCode                            |
      | fieldName                            | filteredObject5[0].fieldName                            |
      | fieldLabel                           | filteredObject5[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject5[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject5[0].placeholderText                      |
      | isRequiredField                      | filteredObject5[0].isRequiredField                      |
      | helpText                             | filteredObject5[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject5[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject5[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject5[0].row                                  |
      | columnNumber                         | filteredObject5[0].columnNumber                         |
      | size                                 | filteredObject5[0].size                                 |
      | dataCommand                          | filteredObject5[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       5 |
      | fieldId                              | filteredObject6[0].fieldId                              |
      | fieldCode                            | filteredObject6[0].fieldCode                            |
      | fieldName                            | filteredObject6[0].fieldName                            |
      | fieldLabel                           | filteredObject6[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject6[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject6[0].placeholderText                      |
      | isRequiredField                      | filteredObject6[0].isRequiredField                      |
      | helpText                             | filteredObject6[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject6[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject6[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject6[0].row                                  |
      | columnNumber                         | filteredObject6[0].columnNumber                         |
      | size                                 | filteredObject6[0].size                                 |
      | dataCommand                          | filteredObject6[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       6 |
      | fieldId                              | filteredObject7[0].fieldId                              |
      | fieldCode                            | filteredObject7[0].fieldCode                            |
      | fieldName                            | filteredObject7[0].fieldName                            |
      | fieldLabel                           | filteredObject7[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject7[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject7[0].placeholderText                      |
      | isRequiredField                      | filteredObject7[0].isRequiredField                      |
      | helpText                             | filteredObject7[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject7[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject7[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject7[0].row                                  |
      | columnNumber                         | filteredObject7[0].columnNumber                         |
      | size                                 | filteredObject7[0].size                                 |
      | dataCommand                          | filteredObject7[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       7 |
      | fieldId                              | filteredObject8[0].fieldId                              |
      | fieldCode                            | filteredObject8[0].fieldCode                            |
      | fieldName                            | filteredObject8[0].fieldName                            |
      | fieldLabel                           | filteredObject8[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject8[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject8[0].placeholderText                      |
      | isRequiredField                      | filteredObject8[0].isRequiredField                      |
      | helpText                             | filteredObject8[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject8[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject8[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject8[0].row                                  |
      | columnNumber                         | filteredObject8[0].columnNumber                         |
      | size                                 | filteredObject8[0].size                                 |
      | dataCommand                          | filteredObject8[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       8 |
      | fieldId                              | filteredObject9[0].fieldId                              |
      | fieldCode                            | filteredObject9[0].fieldCode                            |
      | fieldName                            | filteredObject9[0].fieldName                            |
      | fieldLabel                           | filteredObject9[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                            |
      | ovveriddenLabelText                  | filteredObject9[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject9[0].placeholderText                      |
      | isRequiredField                      | filteredObject9[0].isRequiredField                      |
      | helpText                             | filteredObject9[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject9[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject9[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject9[0].row                                  |
      | columnNumber                         | filteredObject9[0].columnNumber                         |
      | size                                 | filteredObject9[0].size                                 |
      | dataCommand                          | filteredObject9[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                        9 |
      | fieldId                              | filteredObject10[0].fieldId                              |
      | fieldCode                            | filteredObject10[0].fieldCode                            |
      | fieldName                            | filteredObject10[0].fieldName                            |
      | fieldLabel                           | filteredObject10[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject10[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject10[0].placeholderText                      |
      | isRequiredField                      | filteredObject10[0].isRequiredField                      |
      | helpText                             | filteredObject10[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject10[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject10[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject10[0].row                                  |
      | columnNumber                         | filteredObject10[0].columnNumber                         |
      | size                                 | filteredObject10[0].size                                 |
      | dataCommand                          | filteredObject10[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       10 |
      | fieldId                              | filteredObject11[0].fieldId                              |
      | fieldCode                            | filteredObject11[0].fieldCode                            |
      | fieldName                            | filteredObject11[0].fieldName                            |
      | fieldLabel                           | filteredObject11[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject11[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject11[0].placeholderText                      |
      | isRequiredField                      | filteredObject11[0].isRequiredField                      |
      | helpText                             | filteredObject11[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject11[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject11[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject11[0].row                                  |
      | columnNumber                         | filteredObject11[0].columnNumber                         |
      | size                                 | filteredObject11[0].size                                 |
      | dataCommand                          | filteredObject11[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       11 |
      | fieldId                              | filteredObject12[0].fieldId                              |
      | fieldCode                            | filteredObject12[0].fieldCode                            |
      | fieldName                            | filteredObject12[0].fieldName                            |
      | fieldLabel                           | filteredObject12[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject12[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject12[0].placeholderText                      |
      | isRequiredField                      | filteredObject12[0].isRequiredField                      |
      | helpText                             | filteredObject12[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject12[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject12[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject12[0].row                                  |
      | columnNumber                         | filteredObject12[0].columnNumber                         |
      | size                                 | filteredObject12[0].size                                 |
      | dataCommand                          | filteredObject12[0].dataCommand                          |
    And set commandfields
      | path                                 |                                                       12 |
      | fieldId                              | filteredObject13[0].fieldId                              |
      | fieldCode                            | filteredObject13[0].fieldCode                            |
      | fieldName                            | filteredObject13[0].fieldName                            |
      | fieldLabel                           | filteredObject13[0].fieldLabel                           |
      | fieldType                            | fieldType[0]                                             |
      | ovveriddenLabelText                  | filteredObject13[0].ovveriddenLabelText                  |
      | placeholderText                      | filteredObject13[0].placeholderText                      |
      | isRequiredField                      | filteredObject13[0].isRequiredField                      |
      | helpText                             | filteredObject13[0].helpText                             |
      | errorAndValidation[0].validationType | filteredObject13[0].errorAndValidation[0].validationType |
      | errorAndValidation[0].errorMessage   | filteredObject13[0].errorAndValidation[0].errorMessage   |
      | row                                  | filteredObject13[0].row                                  |
      | columnNumber                         | filteredObject13[0].columnNumber                         |
      | size                                 | filteredObject13[0].size                                 |
      | dataCommand                          | filteredObject13[0].dataCommand                          |
    And set updateLayoutDesignCustomSectionPayload
      | path        | [0]                                             |
      | header      | updateLayoutDesignCustomSectionCommandHeader[0] |
      | body        | updateLayoutDesignCustomSectionCommandBody[0]   |
      | body.fields | commandfields                                   |
      | body.dataCommands  | updateLayoutDesignCustomSectiondataCommands |
    And print updateLayoutDesignCustomSectionPayload
    And request updateLayoutDesignCustomSectionPayload
    When method POST
    Then status 201
    And def updateLayoutDesignCustomSectionResponse = response
    And print updateLayoutDesignCustomSectionResponse
    And def mongoResult = mongoData.MongoDBReader(dbNameGenericLayout,genericLayoutNameCollectionName+<tenantid>,customDesignFieldsSectionResponse.body.id)
    And print mongoResult
    And match mongoResult == updateLayoutDesignCustomSectionResponse.body.id
    And match updateLayoutDesignCustomSectionResponse.body.sectionId == updateLayoutDesignCustomSectionPayload.body.sectionId
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldCode == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldCode
    And match updateLayoutDesignCustomSectionResponse.body.fields[0].fieldName == updateLayoutDesignCustomSectionPayload.body.fields[0].fieldName
    And match updateLayoutDesignCustomSectionResponse.body.id == updateLayoutDesignCustomSectionPayload.body.id

     Examples: 
      | tenantid    |
      | tenantID[0] |
