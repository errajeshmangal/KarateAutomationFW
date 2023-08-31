package com.api.rm.helpers;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.Date;
import java.util.*;
import java.util.TimeZone;
import java.util.UUID;

public class DataGenerator {

	public static String randomeID() {

		return UUID.randomUUID().toString();
	}

	public static String SourceID() {

		return UUID.randomUUID().toString();
	}

	public static String correlationId() {

		return UUID.randomUUID().toString();
	}

	public static String userID() {

		return UUID.randomUUID().toString();
	}

	public static String entityID() {

		return UUID.randomUUID().toString();
	}

	public static String commandUserId() {

		return UUID.randomUUID().toString();
	}

	public static String Id() {

		return UUID.randomUUID().toString();
	}

	public static String tenantId() {

		return UUID.randomUUID().toString();
	}
	
	public static String eventUserId() {

		return UUID.randomUUID().toString();
	}
	
	

	public static String generateCurrentDateTime() {
		String format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
		Calendar c = Calendar.getInstance();
		Date currentDate=c.getTime();
		  SimpleDateFormat sdf = new SimpleDateFormat(format);
		  sdf.setTimeZone(TimeZone.getTimeZone("UTC"));  
	      return sdf.format(currentDate);
	}
	
	public static List<String> generateUUIDs(int count) {
		List<String> uuids = new ArrayList<>();
		for (int i = 0; i < count; i++) {
		uuids.add(UUID.randomUUID().toString());
		}
		return uuids;
		}
	
	public static String generateFutureDateTime() {	
		String format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";	
		Calendar c = Calendar.getInstance();	
			
		 LocalDate futureDate = LocalDate.now().plusMonths(2);	
		 	
		  SimpleDateFormat sdf = new SimpleDateFormat(format);	
		  sdf.setTimeZone(TimeZone.getTimeZone("UTC"));  	
	      return sdf.format(futureDate);	
	}	
	public static int generateSingleOrDoubleDigitNumber() {	
	    Random random = new Random();	
	    int number = random.nextInt(90) + 10; // Generates a random number between 10 and 99 (inclusive)	
	    return number;	
	}
}
