function fn() {



	var env = karate.env; // get java system property 'karate.env'



	karate.log('karate.env system property was:', env);



	if (!env) {

		env = 'devIntegrtaion'; // a custom 'intelligent' default

	}



	var config = { // base config JSON

		commandBaseUrl: 'https://recordsadmin-rm.azurewebsites.net',

		readBaseUrl: 'https://recordsreadstoreadmin-rm.azurewebsites.net',

		commandBaseWorkFlowUrl: 'https://recordsworkflow-rm.azurewebsites.net',

		readBaseWorkFlowUrl: 'https://recordsreadstoreworkflow-rm.azurewebsites.net',

		eventBaseUrl: 'https://eventstore-rm.azurewebsites.net',

		schemaUri: 'https://schemavault-rm.azurewebsites.net/schemas',

		dbnameGet: 'AvenuRecordsAdminReadStore',

		dbname: 'AvenuRecordsAdmin',

		dbNameWorkFlow: 'AvenuRecordsWorkflowAdmin',

		dbNameWorkFlowRead: 'AvenuRecordsWorkflowAdminReadStore',

		tenantID: ['b26cb140-2970-41d4-bf0e-f669e6f23ab0', '1266aa7a-6a29-4e89-a5f6-9980a59bc587'],

		commandUserId: '3014ae08-7070-4378-a89c-34c8abca3bec',

		commandBaseGenericLayout: 'https://genericlayout-rm-dev.azurewebsites.net',

		readBaseGenericLayout: 'https://readstoregenericlayout-rm-dev.azurewebsites.net',

		dbNameGenericLayout: 'AvenuRecordsGenericLayout',

		dbNameGenericLayoutRead: 'AvenuRecordGenericLayoutReadStore',

		commandBaseNumberingSchemeUrl: 'https://sequencegenerator-rm-dev.azurewebsites.net',

		readBaseNumberingSchemeUrl: 'https://readstoresequencegenerator-rm-dev.azurewebsites.net',

		dbNameNumberingScheme: 'AvenuRecordsSequenceGenerator',

		dbNameNumberingSchemeRead: 'AvenuRecordsSequenceGeneratorReadStore',

		dbNameWorkWithOrder: 'AvenuRecordsOrders',

		dbNameWorkWithOrderRead: 'AvenuRecordsOrdersReadStore',

		commandBaseWorkWithOrder: 'https://recordsorders-rm-dev.azurewebsites.net',

		readBaseWorkWithOrder: 'https://RecordsReadstoreOrders-RM-dev.azurewebsites.net',

		numberigSchemeId: '5afd721e-a520-4402-bc56-9fbd2750b3f0' ,

		dbNameOperationalDashBoardRead: 'AvenuRecordsDashboardReadStore'


	};





	if (env == 'qa') {



		config.commandBaseUrl = 'https://recordsadmin-rm-qa.azurewebsites.net',

			config.readBaseUrl = 'https://recordsreadstoreadmin-rm-qa.azurewebsites.net',

			config.schemaUri = 'https://schemavault-rm.azurewebsites.net/schemas',

			config.dbnameGet = 'AvenuRecordsAdminReadStore',

			config.dbname = 'AvenuRecordsAdmin',

			config.tenantID = ['acf78b8b-f798-4b41-8c18-b844e5e588d5'],

			config.commandUserId = 'eadfb97b-0ff8-4dcc-b07b-d31e319fa2f8',

			config.commandBaseWorkFlowUrl = 'https://recordsworkflow-rm-qa.azurewebsites.net',

			config.readBaseWorkFlowUrl = 'https://recordsreadstoreworkflow-rm-qa.azurewebsites.net',

			 
            config.dbNameWorkFlow = 'AvenuRecordsWorkflowAdmin',

			config.dbNameWorkFlowRead = 'AvenuRecordsWorkflowAdminReadStore',

		    config.commandBaseGenericLayout = 'https://genericlayout-rm-qa.azurewebsites.net',

			config.readBaseGenericLayout = 'https://readstoregenericlayout-rm-qa.azurewebsites.net',

			config.dbNameGenericLayout = 'AvenuRecordsGenericLayout',

			config.dbNameGenericLayoutRead = 'AvenuRecordGenericLayoutReadStore',

			config.commandBaseNumberingSchemeUrl = 'https://sequencegenerator-rm-qa.azurewebsites.net',

			config.readBaseNumberingSchemeUrl = 'https://readstoresequencegenerator-rm-qa.azurewebsites.net',

			config.dbNameNumberingScheme = 'AvenuRecordsSequenceGenerator',

			config.dbNameNumberingSchemeRead = 'AvenuRecordsSequenceGeneratorReadStore',

			config.dbNameWorkWithOrder = 'AvenuRecordsOrders',

			config.dbNameWorkWithOrderRead = 'AvenuRecordsOrdersReadStore',

			config.commandBaseWorkWithOrder = 'https://recordsorders-rm-qa.azurewebsites.net',

			config.readBaseWorkWithOrder = 'https://recordsReadstoreOrders-rm-qa.azurewebsites.net',

			config.numberigSchemeId = '976748e9-cc1f-4865-9cbf-d4671d87b6f1' ,
          
	        config.dbNameOperationalDashBoardRead = 'AvenuRecordsDashboardReadStore',
	        
             config.readDashboard  = 'https://recordsreadstoredashboard-rm-local.azurewebsites.net/'
             
          
	}



	else if (env == 'dev') {


   config.readDashboard  = 'https://recordsreadstoredashboard-rm-local.azurewebsites.net/'
		config.commandBaseUrl = 'https://recordsadmin-rm.azurewebsites.net',

			config.eventBaseUrl = 'https://eventstore-rm.azurewebsites.net',

			config.readBaseUrl = 'https://recordsreadstoreadmin-rm.azurewebsites.net',

			config.commandBaseWorkFlowUrl = 'https://recordsworkflow-rm.azurewebsites.net',

			config.readBaseWorkFlowUrl = 'https://recordsreadstoreworkflow-rm.azurewebsites.net',

			config.schemaUri = 'https://schemavault-rm.azurewebsites.net/schemas',

			config.dbnameGet = 'AvenuRecordsAdminReadStore',

			config.dbname = 'AvenuRecordsAdmin',

			config.tenantID = ['1266aa7a-6a29-4e89-a5f6-9980a59bc587', 'b26cb140-2970-41d4-bf0e-f669e6f23ab0'],

			config.commandUserId = '3014ae08-7070-4378-a89c-34c8abca3bec',

			config.dbNameWorkFlow = 'AvenuRecordsWorkFlowAdmin',

			config.dbNameWorkFlowRead = 'AvenuRecordsWorkflowAdminReadStore',

			config.commandBaseNumberingSchemeUrl = 'https://sequencegenerator-rm-dev.azurewebsites.net',

			config.readBaseNumberingSchemeUrl = 'https://readstoresequencegenerator-rm-dev.azurewebsites.net',

			config.dbNameNumberingScheme = 'AvenuRecordsSequenceGenerator',

			config.dbNameNumberingSchemeRead = 'AvenuRecordsSequenceGeneratorReadStore',

			config.dbNameWorkWithOrder = 'AvenuRecordsOrders',

			config.dbNameWorkWithOrderRead = 'AvenuRecordsOrdersReadStore',

			config.commandBaseWorkWithOrder = 'https://recordsorders-rm-dev.azurewebsites.net',

			config.readBaseWorkWithOrder = 'https://recordsReadstoreOrders-rm-dev.azurewebsites.net',
			
            config.dbNameOperationalDashBoardRead = 'AvenuRecordsDashboardReadStore'
	}





	else if (env == 'devIntegrtaion') {



		config.commandBaseUrl = 'https://recordsadmin-rm-dev.azurewebsites.net',

			config.readBaseUrl = 'https://recordsreadstoreadmin-rm-dev.azurewebsites.net',

			config.commandBaseWorkFlowUrl = 'https://recordsworkflow-rm-dev.azurewebsites.net',

			config.readBaseWorkFlowUrl = 'https://recordsreadstoreworkflow-rm-dev.azurewebsites.net',

			config.schemaUri = 'https://schemavault-rm.azurewebsites.net/schemas',

			config.dbnameGet = 'AvenuRecordsAdminReadStore',

			config.dbname = 'AvenuRecordsAdmin',

			config.tenantID = ['965f6d7b-0e5a-4943-a642-93cd0db85383'],

			config.commandUserId = '7f859fcf-0571-4cd2-b8e3-4d9f8a97cf7b',

			config.dbNameWorkFlow = 'AvenuRecordsWorkflowAdmin',

			config.dbNameWorkFlowRead = 'AvenuRecordsWorkflowAdminReadStore',

			config.commandBaseGenericLayout = 'https://genericlayout-rm-dev.azurewebsites.net',

			config.readBaseGenericLayout = 'https://readstoregenericlayout-rm-dev.azurewebsites.net',

			config.dbNameGenericLayout = 'AvenuRecordsGenericLayout',

			config.dbNameGenericLayoutRead = 'AvenuRecordGenericLayoutReadStore',

			 config.dbNameGenericLayoutRead = 'AvenuRecordGenericLayoutReadStore',

		    config.commandBaseNumberingSchemeUrl = 'https://sequencegenerator-rm-dev.azurewebsites.net',

		    config.readBaseNumberingSchemeUrl = 'https://readstoresequencegenerator-rm-dev.azurewebsites.net',

		    config.dbNameNumberingScheme = 'AvenuRecordsSequenceGenerator',

		    config.dbNameNumberingSchemeRead = 'AvenuRecordsSequenceGeneratorReadStore',

	        config.numberingSchemeCommandUserId = '1f2e381a-b08f-4aa7-ac28-720f3cdab11a',

            config.dbNameWorkWithOrder = 'AvenuRecordsOrders',

            config.dbNameWorkWithOrderRead = 'AvenuRecordsOrdersReadStore',

            config.commandBaseWorkWithOrder = 'https://recordsoders-rm-dev.azurewebsites.net',

            config.readBaseWorkWithOrder = 'https://recordsReadstoreOrders-rm-dev.azurewebsites.net',

            config.numberigSchemeId = '5afd721e-a520-4402-bc56-9fbd2750b3f0'

         

	}



	else if (env == 'uat') {



		config.commandBaseUrl = 'https://recordsadmin-rm-uat.azurewebsites.net',

			config.readBaseUrl = 'https://recordsreadstoreadmin-rm-uat.azurewebsites.net',

			config.schemaUri = 'https://schemavault-rm.azurewebsites.net/schemas',

			config.dbnameGet = 'AvenuRecordsAdminReadStore',

			config.dbname = 'AvenuRecordsAdmin',

			config.tenantID = ['58b78b24-6d8c-491f-8530-384f8814a90b'],

			config.commandUserId = '3014ae08-7070-4378-a89c-34c8abca3bec',

			config.countyAreaId = '5fc622be-6ecb-4eef-ad98-a0bf33722e37',

			config.documentClassId = '35b6a232-ad05-47c8-9083-cd6625984b32',

			config.commandBaseGenericLayout = 'https://genericlayout-rm-uat.azurewebsites.net',

			config.readBaseGenericLayout = 'https://readstoregenericlayout-rm-uat.azurewebsites.net',

			config.dbNameGenericLayout = 'AvenuRecordsGenericLayout',

			config.dbNameGenericLayoutRead = 'AvenuRecordGenericLayoutReadStore',

			config.commandBaseNumberingSchemeUrl = 'https://sequencegenerator-rm-dev.azurewebsites.net',

			config.readBaseNumberingSchemeUrl = 'https://readstoresequencegenerator-rm-dev.azurewebsites.net',

			config.dbNameNumberingScheme = 'AvenuRecordsSequenceGenerator',

			config.dbNameNumberingSchemeRead = 'AvenuRecordsSequenceGeneratorReadStore',

			config.dbNameWorkWithOrder = 'AvenuRecordsOrders',

			config.dbNameWorkWithOrderRead = 'AvenuRecordsOrdersReadStore',

			config.commandBaseWorkWithOrder = 'https://recordsorders-rm-uat.azurewebsites.net',

			config.readBaseWorkWithOrder = 'https://recordsReadstoreOrders-rm-uat.azurewebsites.net'



	}





	// don't waste time waiting for a connection or if servers don't respond within 5 seconds



	/* karate.configure('connectTimeout', 5000);
	
	karate.configure('readTimeout', 5000);*/

	return config;

}

