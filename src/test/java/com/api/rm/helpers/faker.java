package com.api.rm.helpers;

import java.time.LocalTime;
import java.text.SimpleDateFormat;
import java.time.Month;
import java.time.ZoneOffset;
import java.time.format.TextStyle;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.OptionalInt;
import java.util.Random;
import java.util.TimeZone;

import org.apache.commons.lang.RandomStringUtils;
import java.util.UUID; 
import com.github.javafaker.Faker;

public class faker {

	static Faker fakers = new Faker();

	static String dummy = "Test124";

	public static String getEmail() {
		return fakers.internet().emailAddress();
	}

	public static String getFirstName() {
		return fakers.name().firstName().concat(dummy);
	}

	public static String getLastName() {
		return fakers.name().lastName().concat(dummy);
	}

	public static String getUsermobileNumber() {
		return fakers.phoneNumber().phoneNumber();
	}

	public static String getUserId() {
		 String testdummy = getRandomNumber();
	     return fakers.name().lastName().concat(testdummy).concat(dummy);
	}

	public static String getAddressLine() {
		return fakers.address().streetAddress();
	}
	
	public static String getAddressLine2() {
		return fakers.address().streetName();
	}
	public static String getCity() {
		return fakers.address().city().concat(dummy);

	}

	public static String getState() {
		return fakers.address().state().concat(dummy);
	}

	public static String getZip() {
		return fakers.address().zipCode();
	}

	public static String getCountry() {
		return fakers.address().country().concat(dummy);
	}

	public static String getRandomMonth() {
		Random random = new Random();
		OptionalInt randomNumberMonth = random.ints(1, 12).findFirst();
		return Month.of(randomNumberMonth.getAsInt()).getDisplayName(TextStyle.FULL, Locale.US);
	}

	public static boolean getRandomBoolean() {
		return new Random().nextBoolean();
	}

	public static String getRandomLongDescription() {
		return RandomStringUtils.random(996, true, true).concat(dummy);
	}

	public static String getRandomShortDescription() {
		return RandomStringUtils.random(50, true, true);
	}

	public static String getRandomNumber() {
		return RandomStringUtils.random(10, true, true);
	}
	public static int getRandom5DigitNumber() {
		return Integer.parseInt(RandomStringUtils.random(5, false, true));
	}
	public static int getRandom1Digit() {
		return Integer.parseInt(RandomStringUtils.random(1, false, true)); 
	}
	
	public static int get3Number() {
		
  Random random = new Random();
//
//	        // Generate a random integer between 1 and 3
	        int randomNumber = random.nextInt(3) + 1;
			return randomNumber;
	        
	       
	}
	
	public static String getDescription() {

		String[] list = { "Lien Notice", "Officials Other Fees", "Regular Marr Licenses", "Confidential Marr Licenses",
				"Transfer Taxes" };
		Random r = new Random();
		String Description = list[r.nextInt(list.length)];

		return Description;
	}
	
	public static boolean getRandomBooleanValue() {

		List<Boolean> booleans = Arrays.asList(true,false);

		return booleans.get(new Random().nextInt(booleans.size()));

		}
	
	public static String getRandomDate() {
		Random rand = new Random();
		int rand_int1 = rand.nextInt(30);
	    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
	    sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
	    Calendar c = Calendar.getInstance();
	    c.setTime(new Date()); // Use today date
	    c.add(Calendar.DATE, rand_int1); 
	    String output = sdf.format(c.getTime());
	    return output ;
	}
	public static String getRandomWorkFlowType() {
		List<String> listWorkFlowType = Arrays.asList("Cashiering","Indexing");
		return listWorkFlowType.get(new Random().nextInt(listWorkFlowType.size()));
	}
	public static String getRandomPropertyInformationStatus() {
		List<String> listPropertyInfoStatus = Arrays.asList("Active", "Retired", "Pending");
		return listPropertyInfoStatus.get(new Random().nextInt(listPropertyInfoStatus.size()));
	}
	
	public static String getRandomPin(String typeOfParam)
	{
		String regex = "";
		if(typeOfParam.equalsIgnoreCase("Lot"))
		{
			regex = "[0-9]+(-[0-9]+)";
		}
		else
		{
			regex = "[0-9]{2}(-[0-9]{2})(-[0-9]{3})(-[0-9]{3})";
		}
		Xeger generator = new Xeger(regex);
		regex = generator.generate();
		return regex;
	}
	public static String getUTCTime()
	{
        Random random = new Random();
        
        // Generate random hour, minute, and second values
        int hour = random.nextInt(24);
        int minute = random.nextInt(60);
        int second = random.nextInt(60);
        
        // Create a LocalTime object with the random values
        LocalTime time = LocalTime.of(hour, minute, second);
        
        // Get the time in UTC format
        String utcTime = time.atOffset(ZoneOffset.UTC).toString();
                
        return utcTime;
	}
	
	public static String getFormulaName() {
		return fakers.name().firstName().concat("Formula");
	}
	
	
	public static String feeOutputCategory() {

		String[] list = { "RecordingFees", "SB2Fee", "AllTaxesExceptSB2", "Copies","Remon","OtherTax" ,"Auto","TransferTaxes" };
		Random r = new Random();
		String Category = list[r.nextInt(list.length)];

		return Category;
	}
	
	public static String getCityType() {

		String[] list = { "Incorporated", "Conveyance", "UnIncorporated" };
		Random r = new Random();
		String CityType = list[r.nextInt(list.length)];

		return CityType;
	}

	public static String getCityCode() {

		String[] list = { "AL", "AK", "AZ", "AR", "CO", "CA", "CT", "FL", "HI", "IL", "IA", "KS", "KY", "LA", "MD",
				"MA", "MI", "MS", "MT", "UT" };
		Random r = new Random();
		String code = list[r.nextInt(list.length)];

		return code;
	}

	public static String getRandomFundType() {
		List<String> listFundTypes = Arrays.asList("CountyFund", "GeneralFund", "StateFund", "ThirdPartFund");
		return listFundTypes.get(new Random().nextInt(listFundTypes.size()));
	}

	public static String getDirection() {
		List<String> listDirection = Arrays.asList("N", "W", "S", "E", "NE", "SW", "NW", "SE");
		return listDirection.get(new Random().nextInt(listDirection.size()));
	}
	
  
	public   static String UUID() {
		//generates random UUID.
		UUID uuid=UUID.randomUUID();
		String uuidAsString = uuid.toString();  
		return  uuidAsString ;
	}
	
	public static int getRandomInteger(int min, int max) {
	    Random random = new Random();
	    return random.nextInt((max - min) + 1) + min;
	}
	
	public static String getFeeType() {
		List<String> FeeType = Arrays.asList("CopyFees", "Miscellaneous", "RecordingFee", "SearchFees", "TaxFee" );
		return FeeType.get(new Random().nextInt(FeeType.size()));
		}
	 
	public static String getProcessingFlag() {
		List<String> ProcessingFlag = Arrays.asList("Certified Copy", "Conformed Copy", "Lien Notification Required");
		return ProcessingFlag.get(new Random().nextInt(ProcessingFlag.size()));
		}
	
	
	public static String actionAfterCompletingItem() {
		List<String> ProcessingFlag = Arrays.asList("Auto-RepeatthisItemType", "Closetheform", "Stayontheitemjustprocessed");
		return ProcessingFlag.get(new Random().nextInt(ProcessingFlag.size()));
}
	
	public static String actionAfterRecordingItem() {
		List<String> ProcessingFlag = Arrays.asList("Closetheform", "Stayontheitemjustprocessed");
		return ProcessingFlag.get(new Random().nextInt(ProcessingFlag.size()));
		}
	
	public static String getFinanicialExportDepsoit() {
		List<String> financialExportDeposit = Arrays.asList("Cash/Check",
                "Credit Card",
                "ACH Payment",
                "Over/Short",
                "CreditCardOverage");	
		return financialExportDeposit.get(new Random().nextInt(financialExportDeposit.size()));
	}
	 
	public static String actionAfterCashieringItem() {
		List<String> ProcessingFlag = Arrays.asList("Closetheform", "Stayontheitemjustprocessed");
		return ProcessingFlag.get(new Random().nextInt(ProcessingFlag.size()));
		}
	
	public static String FeeOutPutCategoryEnum() {
		List<String> OutputCateGoryENUM = Arrays.asList("RecordingFees", "SB2Fee","AllTaxesExceptSB2", "Copies",  "OTHERTest", "Remon", "Auto", "TransferTax");
		return OutputCateGoryENUM.get(new Random().nextInt(OutputCateGoryENUM.size()));
	}
	
	public static String getorderCategory() {

        String[] list = { "Counter", "ElectronicG2G", "PublicKiosk", "Mail-Priority", "Mail-Regular", "Subsscription" };
        Random r = new Random();
        String source = list[r.nextInt(list.length)];
        return source;
    }
 
    public static String getstatus() {
        String[] list = {"Paid","Processed","Held","Open"};
        Random r = new Random();
        String status = list[r.nextInt(list.length)];
        return status;
    }
     
    // create Priority for Work with Orders
    public static String getOrderPriorityTypes() {
        String[] list = { "Medium", "High", "Low" };
        Random r = new Random();
        String priority = list[r.nextInt(list.length)];
        return priority;

    }
    
	public static String getWorkDay() {

        String[] list = { "Monday", "TuesDay", "Wednesday", "Thursday", "Friday", "Saturday" ,"Sunday"};
        Random r = new Random();
        String source = list[r.nextInt(list.length)];
        return source;
    }
	
	public static String getHoliday() {

        String[] list = { "RAMNAVMI", "GURUNANAKJAYNTI", "DIWALI", "HOLI", "NANAKJAYNTI"};
        Random r = new Random();
        String source = list[r.nextInt(list.length)];
        return source;
    }
}

