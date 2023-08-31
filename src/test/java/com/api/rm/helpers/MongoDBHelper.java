package com.api.rm.helpers;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;
import org.bson.Document;

public class MongoDBHelper {

	public static MongoClient mongoClient;
	public static MongoDatabase database;
	public static MongoCollection<Document> collection;
	public static String ConnectionString = "mongodb://AvenuRecordsAdmin:yesB4RqpVlBqPUBL@avenurecords-dev-shard-00-00.lpza0.mongodb.net:27017,avenurecords-dev-shard-00-01.lpza0.mongodb.net:27017,avenurecords-dev-shard-00-02.lpza0.mongodb.net:27017/?ssl=true&replicaSet=atlas-bawz8t-shard-0&authSource=admin&retryWrites=true&w=majority";
	//UAT Connection String 
	//public static String ConnectionString = "mongodb+srv://AvenuRecordsAdmin:yesB4RqpVlBqPUBL@cluster0.lpza0.mongodb.net/?retryWrites=true&w=majority";

	public static String MongoDBReader(String DatabaseName, String collectionName, String entityId) {

		mongoClient = MongoClients.create(ConnectionString);
		database = mongoClient.getDatabase(DatabaseName);
		collection = database.getCollection(collectionName);

		FindIterable<Document> documents = collection.find();
	     List<String> idsList = new ArrayList<>();

         for (Document document : documents) {
             Set<Entry<String, Object>> dataFetch = document.entrySet();

             boolean found = dataFetch.stream()
                     .filter(data -> data.getKey().equals("_id") || data.getKey().equals("id"))
                     .anyMatch(data -> String.valueOf(data.getValue()).equals(entityId));

             if (found) {
                 String value = String.valueOf(document.get("_id"));
                 idsList.add(value);
             }
         }

         return idsList.isEmpty() ? null : idsList.get(0);
     }


	public static double MongoDBHelperToReadFields(String DatabaseName, String collectionName, String fieldName) {

		double defaultValue = 1.0;
		mongoClient = MongoClients.create(ConnectionString);
		database = mongoClient.getDatabase(DatabaseName);
		collection = database.getCollection(collectionName);

		FindIterable<Document> documents = collection.find();
		List<Document> documentList = new ArrayList<Document>();
		Iterator<Document> it = documents.iterator();
		while (it.hasNext()) {
			Document document = (Document) it.next();
			documentList.add(document);
		}
		for (Document de : documentList) {
			Set<Entry<String, Object>> dataFetch = de.entrySet();
			for (Entry<String, Object> data : dataFetch) {
				if (data.getKey().equals("body")) {
					String bodyDocumentData = String.valueOf(data.getValue());
					String[] bodyDataSplit = bodyDocumentData.split(",");
					for (String bodyFieldNames : bodyDataSplit) {
						if (bodyFieldNames.contains(fieldName)) {
							String[] fieldNames = bodyFieldNames.split("=");
							defaultValue = defaultValue + Double.parseDouble(fieldNames[1]);
							defaultValue++;
						}
					}

				}
			}
		}

		return defaultValue;

	}

	public MongoCollection<Document> getCollection() {
		return collection;
	}

	public void close() {
		mongoClient.close();
	}
}
