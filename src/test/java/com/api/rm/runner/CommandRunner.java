package com.api.rm.runner;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

 class CommandRunner {
  @Test
   public void testParallel() {

	   Results results = Runner.builder().outputCucumberJson(true).path("classpath:com/api/rm").tags("@UpdateFeeCodeFeeInfoWithAllFieldsAndGetTheDetails").parallel(20);

       generateReport(results.getReportDir());
       assertEquals(0, results.getFailCount(), results.getErrorMessages());
   }

public static void generateReport(String karateOutputPath) {
	
       Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
       final List<String> jsonPaths = new ArrayList<String>(jsonFiles.size());
       jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
       Configuration config = new Configuration(new File("target"), "featurefiles");
       ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
       reportBuilder.generateReports();
   }
}
 
 
 // To run from command prompt user - mvn test "-Dtest=ParallerRunner" -Dkarate.env=dev
 
 
 
 
 
 
 
 
 
 
 
 