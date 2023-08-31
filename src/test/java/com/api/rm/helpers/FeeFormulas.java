package com.api.rm.helpers;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.apache.commons.lang.RandomStringUtils;

import ch.qos.logback.core.util.SystemInfo;

public class FeeFormulas {

	public static void main(String[] args) {

//		formula1(23,12,12,3,9,0);
//		formula2(23,84,62,10,9);
//		roundUpValue(23,2,20,300);
//		allRoundsFormula(100,20,200,10,2,200,10);
		// roundUpValue(92871.0,95.0,22447.0);
		// formula5(97.0,79242.0,65227.0,18364.0,98.0,70839.0);

//		int i=Integer.parseInt(RandomStringUtils.random(3, false, true));
//		System.out.println(i*0.3);
		//allRoundsFormula(4197.0, 21, 82146, 59232, 95963);
//		roundUp(99.25, 2);
//		roundDown(99.25,2);
		
		
	}

	public static double maxNumber() {
		double d = Double.parseDouble(RandomStringUtils.random(5, false, true));
		return d;
	}

	public static double minNumber() {
		double d = Double.parseDouble(RandomStringUtils.random(2, false, true));
		return d;
	}

	public static double medNumber() {
		double d = Double.parseDouble(RandomStringUtils.random(4, false, true));
		return (d * 0.6);
	}

	public static double number() {
		double d = Double.parseDouble(RandomStringUtils.random(2, false, true));
		return d;
	}

	public static double parameterNumber() {
		double d = Double.parseDouble(RandomStringUtils.random(5, false, true));
		return d;
	}

	public static double roundUp(double number, int value) {
		BigDecimal bd = new BigDecimal(number);
		bd = bd.setScale(value, RoundingMode.UP);
		double d = bd.doubleValue();
		System.out.println("Roundup"+d);
		return d;

	}

	public static double roundDown(double number, int value) {
		BigDecimal bd = new BigDecimal(number);
		bd = bd.setScale(value, RoundingMode.DOWN);
		double d = bd.doubleValue();
		System.out.println("Rounddown"+d);
		return d;

	}

	public static double round(double number, int value) {
		BigDecimal bd = new BigDecimal(number);
		bd = bd.setScale(value, RoundingMode.HALF_UP);
		double d = bd.doubleValue();
		System.out.println(d);
		return d;

	}

	public static double minimum(double num1, double num2) {
		return Math.min(num1, num2);
	}

	public static double maximun(double num1, double num2) {
		return Math.max(num1, num2);
	}

	public static double formula1(double QuantityEntered, double FeeBaseAmount, int MinimumNumber, int number,
			double FeeAdditionalAmount, int MaximunNumber) {

		// 'Min((QuantityEntered*FeeBaseAmount),MinimumNumber)+Max(((QuantityEntered-3)*FeeAdditionalAmount),MaximunNumber)'

		double part1 = QuantityEntered * FeeBaseAmount;
		double part2 = ((QuantityEntered - number) * (FeeAdditionalAmount));

		double minValue = minimum(part1, MinimumNumber);
		double maxValue = maximun(part2, MaximunNumber);
		System.out.println(minValue + maxValue);
		return minValue + maxValue;

	}

	public static double formula2(double QuantityEntered, double FeeBaseAmount, double NumberOfPagesEntered,
			double FeeAdditionalAmount, double number) {

		// Min((QuantityEntered*FeeBaseAmount*NumberOfPagesEntered),number*QuantityEntered)
		double part1 = QuantityEntered * FeeBaseAmount * NumberOfPagesEntered;
		double part2 = number * QuantityEntered;

		double minValue = minimum(part1, part2);
		System.out.println(minValue);
		return minValue;

	}

	public static double roundUpValue(double deedAmount, double number, double taxRate) {

		// RoundUp(DeedAmount/number)+taxRate

		double roundValue = (deedAmount / number);
		double part1 = roundUp(roundValue, 2);
		double part2 = part1 + taxRate;
		return part2;
	}

	public static double allRoundsFormula(double deedAmount, int number, double MaximumQuantity, double FeeBaseAmount,
			int MaximunNumber) {

		// Round(((RoundUp(DeedAmount/number))*(RoundDown(MaximumQuantity+MaximumQuantity)))/(Round(Max(FeeBaseAmount,MaximunNumber)))

		// Round((RoundUp(DeedAmount/number))*RoundDown(MaximumQuantity+MaximumQuantity)/Round(Max(FeeBaseAmount,MaximunNumber)))
		double part1 = (deedAmount / number);
		double roundPart1 = roundUp(part1, 2);
		double part2 = (MaximumQuantity + MaximumQuantity);
		double roundPart2 = roundDown(part2, 2);
		double part1_total = roundPart1 * roundPart2;

		double part3 = maximun(FeeBaseAmount, MaximunNumber);
		double roundPart3 = round(part3, 2);
		double finalResult = round(part1_total / roundPart3, 2);
		System.out.println(finalResult + "line");
		return finalResult;
	}

	public static double formula5(double MinimumNumber, double QuantityEntered, double FeeBaseAmount,
			double MaximumNumber, double number, double FeeAdditionalAmount) {

		// Min(MinimumNumber,QuantityEntered*FeeBaseAmount)+Max(MaximumNumber,QuantityEntered-number*FeeAdditionalAmount)

		double part1 = (QuantityEntered * FeeBaseAmount);
		double minValue = minimum(MinimumNumber, part1);
		double part2 = number*FeeAdditionalAmount;
		double part3 = (QuantityEntered - part2);
		double maxValue = maximun(MaximumNumber, part3);
		double finalResult = minValue + maxValue;
		System.out.println(finalResult + "line");
		return finalResult;
	}

	public static double formula6(double quantityEntered, double feeBaseAmount, double feeAdditionalAmount,
			double MinimumNumber) {

		// (quantityEntered*feeBaseAmount)/(feeAdditionalAmount*MinimumNumber)

		double part1 = (quantityEntered * feeBaseAmount);
		double part2 = (feeAdditionalAmount * MinimumNumber);

		double part3 = part1 / part2;

		return part3;
	}

	// Round(Amount) + ( Amount * Tax)

	public static double formula7(int number, int taxRate) {

		// (quantityEntered*feeBaseAmount)/(feeAdditionalAmount*MinimumNumber)

		double part1 = (number * taxRate);
		double part2 = round(number, 2);

		double part3 = part1 + part2;

		return part3;
	}
	
	public static double simpleMultiplication(double NumberOfFilingCodesEntered, double FeeBaseAmount) {

		// NumberOfFilingCodesEntered*FeeBaseAmount

		double part1 = NumberOfFilingCodesEntered*FeeBaseAmount;
		return part1;
	}
	
	//(RoundUp((DeedAmount)+TaxBaseAmount

	public static double simpleRoundUp(double DeedAmount, double TaxBaseAmount) {

		// RoundUp(DeedAmount+TaxBaseAmount)

		double part1 = round(DeedAmount+TaxBaseAmount,2);
		return part1;
	}
	
	
	
	public static double simpleMin(double FeeBaseAmount, double NumberOfPagesEntered, double number, double MinimumNumber, double MaximumNumber  ) {

		//Min(FeeBaseAmount+(NumberOfPagesEntered-number)*MinimumNumber,MaximumNumber)

		double part1 = NumberOfPagesEntered-number;
		double part2 = part1*MinimumNumber;
		double part3 = FeeBaseAmount+part2;
		double part4 = minimum(part3,MaximumNumber);
		
		return part4;
		
		
	}

}
