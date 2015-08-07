/*
 * =========================================================
 * Author   Date          Description
 * ---------------------------------------------------------
 * 강동민   2008. 5. 23.      최초작성
 * ---------------------------------------------------------
 */
package egovframework.got.com.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Locale;

/**
 *  Class Name  : NumberUtil.java<br/>
 *  Description : 숫자포맷 변경 관련 유틸 클래스
 *  Modification Information<br/>
 *
 *  <pre>
 *    수정일         수정자                        수정내용
 *   -------      --------    --------------------------------------------------
 *   2008.10.07   인프라       최초 생성
 *  </pre>
 *
 *  @since 2008.10.07
 *  @version 1.0
 *  @author hmkwon
 *  <br/><br/>
 *  Copyright (C) 2008 by SDS  All right reserved.
 */


public abstract class NumberUtil {

	/**
     * 확장할 수 있는 패딩상수 최대크기
     */
    private static final BigDecimal ZERO = new BigDecimal(0);



    /**
     * <p>	입력 된 double값을 DecimalFormat클래스의 format형태 문자열로 변환한다.
     * </p><pre>
     * double originNumber = 123456789;
     * String format = "###,###,###";
     * String formatNumber = NumberUtil.formatNumber(originNumber,format); formatNumber = "123,456,789" </pre>
     * @return	String
     */
    public static String formatNumber(double originNumber, String format) {
    	DecimalFormat df = new DecimalFormat();
        df.applyPattern(format);
        return df.format(originNumber);
    }

    /**
     * <p>	입력 된 long값을 DecimalFormat클래스의 format형태 문자열로 변환한다.
     * </p><pre>
     * long originNumber  = 123456789L;
     * String format = "###,###,###";
     * String formatNumber = NumberUtil.formatNumber(originNumber,format);  formatNumber = "123,456,789" </pre>
     * @return	String
     */
    public static String formatNumber(long originNumber, String format) {
    	DecimalFormat df = new DecimalFormat();
        df.applyPattern(format);
        return df.format(originNumber);
    }

    /**
     * 숫자 문자열을 해당 DecimalFormat 포맷형식의 숫자 문자열로 변환함<br>
     * 화폐를 표시에 사용하는 ,와 소수점을 표시하는 .을 제외한 다른 문자가 포함되어 있으면 안됨<br>
     * <p>	숫자 문자열을 해당 DecimalFormat 포맷형식의 숫자 문자열로 변환
     * </p><pre>
     * String sourceStr = "123456789"
     * String targetFormat = "###,###,###";
     * String formatNumber = NumberUtil.formatNumber(sourceStr,targetFormat); </pre>
     * @return	String
     */
    public static String formatNumber(String sourceStr, String targetFormat) {
    	DecimalFormat df = new DecimalFormat();
        df.applyPattern(targetFormat);

        try {
            Number sourceNumber = df.parse(StringUtil.removeChar(sourceStr, ','));
            return df.format(sourceNumber);
        }
        catch (ParseException ex) {
            ex.printStackTrace();
        }

        return sourceStr;
    }

    /**
     * <p>	문자열을 Integer로 전환하는 메소드
     * </p><pre>
     * String sNumber = null ;
     * int getInteger = NumberUtil.getInteger(sNumber); </pre>
     * @return	int
     */
    public static int getInteger(String sNumber) {
        int iNumber = 0;

        try {
            iNumber = Integer.parseInt(sNumber.trim());
        }
        catch (NumberFormatException ex) {
            ex.printStackTrace();
        }

        return iNumber;
    }

    /**
     * <p>	제공된 숫자를 지정된 크기만큼 왼쪽으로 '0'이 패딩된 문자열을 반환한다.
     * 만약 제공된 숫자의 문자열이 패딩할 크기보다 크면 해당 숫자의 문자열을 반환한다.
     * </p><pre>
     * int number =100 ;
     * int size =4 ;
     * String numberToPad = NumberUtil.numberToPad(number,size); //numberToPad = "0100" </pre>
     * @param number 패딩될 숫자
     * @param size 패딩할 크기
     * @return 왼쪽으로 '0'이 패딩된 문자열.
     */
    public static String numberToPad(int number, int size) {
        return StringUtil.leftPad(String.valueOf(number), size, '0');
    }

    /**
     * <p>	exponent수 만큼의 제곱을 구하고 리턴한다.
     * </p><pre>
     * BigDecimal val =  new BigDecimal("55"); ;
     * int exponent = 2 ;
     * BigDecimal power = NumberUtil.power(val,exponent); // 55 * 55 = 3025 </pre>
     * @return	BigDecimal
     */
    public static BigDecimal power(BigDecimal val, int exponent) {
        if (exponent <= 1) {
            if (exponent == 0)
                return BigDecimal.valueOf(1);
            else return val;
        }

        return val.multiply(power(val, exponent - 1));
    }

	/**
	 * <p>
	 * 입력된 숫자문자열을 요청한 소수점 자리 형태로 포맷팅 한다.
	 * </p>
	 * <pre>
	 * dpoint	0		=>  "###,###,###.###" 				패턴
	 * dpoint	1		=>  "###,###,###,##0.0" 			패턴
	 * dpoint	2		=>  "###,###,###,##0.00" 			패턴
	 * dpoint	3		=>  "###,###,###,##0.000" 		패턴
	 * dpoint	4		=>  "###,###,###,##0.0000" 		패턴
	 * dpoint	5		=>  "###,###,###,##0.00000" 	패턴
	 * dpoint	그외	=>  "###,###,###.###" 				패턴
	 * </pre>
	 *
	 * @param inputValue 숫자 BigDecimal 객체
	 * @param dpoint 소숫점이하 자리수 ( 허용범위 : 0 ~ 5 )
	 * @return 포맷된 숫자 문자열
	 */
	public static String formatNumberByPoint(BigDecimal inputValue, int dpoint) {
	    String pattern = null;

	    switch (dpoint) {
	    case 0:
	    	pattern = "###,###,###.###";
	    	break;
	    case 1:
	    	pattern = "###,###,###,##0.0";
	    	break;
	    case 2:
	    	pattern = "###,###,###,##0.00";
	    	break;
	    case 3:
	    	pattern = "###,###,###,##0.000";
	    	break;
	    case 4:
	    	pattern = "###,###,###,##0.0000";
	    	break;
	    case 5:
	    	pattern = "###,###,###,##0.00000";
	    	break;
	    default:
	    	pattern = "###,###,###.###";
	    break;
	    }

	    String retValue = null;
	    if (inputValue == null) {
	        retValue = "0";
	    } else {
	        DecimalFormat df = new DecimalFormat(pattern);
	        retValue 		 = df.format(inputValue);
	    }

	    return retValue;
	}

	/**
	 * <p>
	 * 입력된 숫자를 입력 로케일 형태로 포맷팅 한다.
	 * </p>
	 * @param inputValue 숫자 문자열
	 * @param locale 소숫점이하 자리수 ( 허용범위 : 0 ~ 5 )
	 * @return 포맷된 숫자 문자열
	 */
	public static String formatNumberByLocale(BigDecimal inputValue, Locale locale) {
		NumberFormat nf = NumberFormat.getInstance(locale);
		return nf.format(inputValue);
	}

	/**
	 * <p>
	 * 입력된 숫자를 입력된 position에서 반올림 한다.
	 * </p>
	 * <pre>
	 * BigDecimal bd = new BigDecimal("2255661177");
	 * NumberUtil.round(b, 5) //2255700000
	 * </pre>
	 * @param bd 숫자 BigDecimal 객체
	 * @param position 반올림 위치
	 * @return 반올림 한 BigDecimal 객체
	 */
    public static BigDecimal round(BigDecimal bd, int position) {
        if(position < 0)
            bd = bd.setScale(-position, 4);
        else if(position > 0) {
            long posNum = (long)Math.pow(10D, position);
            double roundedNum = Math.round(bd.doubleValue() / (double)posNum) * posNum;
            bd = new BigDecimal(roundedNum);
        } else {
            double roundedNum = Math.round(bd.doubleValue());
            bd = new BigDecimal(roundedNum);
        }
        return bd;
    }

	/**
	 * <p>
	 * 입력된 숫자를 입력된 position에서 버림 한다. (뒤에서 읽어서 잘라냄)
	 * </p>
	 *
	 * <pre>
	 * BigDecimal bd = new BigDecimal("223337799");
	 * NumberUtil.floor(bd, 7) //220000000
	 * </pre>
	 *
	 * @param bd 숫자 BigDecimal 객체
	 * @param position 버림 위치
	 * @return 버림 한 BigDecimal 객체
	 */
    public static BigDecimal floor(BigDecimal bd, int position) {
        if(position < 0)
            bd = bd.setScale(-position, 3);
        else if(position > 0) {
            long posNum = (long)Math.pow(10D, position);
            double flooredNum = Math.floor(bd.doubleValue() / (double)posNum) * (double)posNum;
            bd = new BigDecimal(flooredNum);
        } else {
            double flooredNum = Math.floor(bd.doubleValue());
            bd = new BigDecimal(flooredNum);
        }
        return bd;
    }



/////////////////////////////////////////////////////////////////////////////////
    /**
     * 제공된 BigDecimal을 반올림자리수에서 반올림하고 버림자리수에서 버린 BigDecimal을 반환한다.
     * <p>
     * 처리순서
     * <pre>
     * 1. 만약 입력값이 null일경우 기준값을 0으로 한다.
     * 2. 반올림자리수와 버림자리수가 0보다 작을때 기준값을 반환한다.
     * 3. 기준값이 0일경우 버림자리수가 0이상이면 버림자리수를 아니면 반올림자리수를 scale로 설정하여 반환한다.
     * 4. 반올림자리수가 0이상이면 해당 자리수에서 반올림을 수행한다.
     * 5. 버림자리수가 0이상이면 해당 자리수에서 버림을 수행한다.
     * 6. 처리결과를 반환한다.
     * </pre>
     * <p>	제공된 BigDecimal을 반올림자리수에서 반올림하고 버림자리수에서 버린 BigDecimal을 반환한다.
     * </p><pre>
     * BigDecimal number ;
     * int halfUpPoint ;
     * int downPoint ;
     * BigDecimal roundingAt = NumberUtil.roundingAt(number,halfUpPoint,downPoint);  </pre>
     * @param number 라운딩할 숫자
     * @param halfUpPoint 반올림자리수
     * @param downPoint 버림자리수
     * @return 제공된 BigDecimal을 반올림자리수에서 반올림하고 버림자리수에서 버린 BigDecimal
     */
    public static BigDecimal roundingAt(final BigDecimal number, int halfUpPoint, int downPoint) {
        // 입력값이 널일경우 기준값을 설정
        BigDecimal baseNumber = ((number == null) ? BigDecimal.valueOf(0L) : number);

        // 반올림자리수와 버림자리수가 0보다 작을때 기준값을 반환
        if((halfUpPoint < 0) && (downPoint < 0)) {
            return baseNumber;
        }

        // 기준값이 0일경우 버림자리수가 0이상이면 버림자리수를 아니면 반올림자리수를 scale로 설정하여 반환
        if(baseNumber.signum() == 0) {
            return ((downPoint < 0) ? baseNumber.setScale(halfUpPoint) : baseNumber.setScale(downPoint));
        }

        // 반올림및 버림을 조건에 따라 수행한 결과를 반환
        if (halfUpPoint >= 0) {
            baseNumber = baseNumber.setScale(halfUpPoint, BigDecimal.ROUND_HALF_UP);
        }
        if(downPoint >= 0) {
            baseNumber = baseNumber.setScale(downPoint, BigDecimal.ROUND_DOWN);
        }

        return baseNumber;
    }

///////////////////////////////////////////////////////////////////////////////
	/**
	 * <p>
	 * 입력된 숫자문자열을 입력 로케일 형태로 포맷팅 한다.
	 *
	 * BigDecimal bd = new BigDecimal("35000");
	 * NumberUtil.formatNumberByLocaleCurrency(bd, Locale.getDefault()) // ￦ 35,000
	 * NumberUtil.formatNumberByLocaleCurrency(bd, Locale.JAPAN) // ￥ 35,000
	 * NumberUtil.formatNumberByLocaleCurrency(bd, Locale.US) $ 35,000
	 *
	 * </p>
	 * @param inputValue 숫자 문자열
	 * @param locale 로케일
	 * @return 포맷된 통화 숫자 문자열
	 */
	public static String formatNumberByLocaleCurrency(BigDecimal inputValue, Locale locale) {
		NumberFormat nf = NumberFormat.getInstance(locale);
		return nf.getCurrency().getSymbol(locale) + " " + nf.format(inputValue);
	}

	/**
	 * <p>
	 * 입력 로케일에 대한 통화코드를 구한다.
	 *
	 * NumberUtil.getCurrencyCodeByLocale(Locale.getDefault()) // KRW
	 * NumberUtil.getCurrencyCodeByLocale(Locale.JAPAN) //JPY
	 * NumberUtil.getCurrencyCodeByLocale(Locale.US) // USD
	 *
	 * </p>
	 * @param locale 로케일
	 * @return 포맷된 통화 코드
	 */
	public static String getCurrencyCodeByLocale(Locale locale) {
		NumberFormat nf = NumberFormat.getInstance(locale);
		return nf.getCurrency().getCurrencyCode();
	}

	/**
	 * <p>
	 * 통화코드목록을 리턴한다.
	 * </p>
	 * @return 통화코드 목록
	 */
	public static String[] getCurrencyCodes() {
		String[] currency = {"USD","KRW","JPY","GBP","DEM","CAD","FRF","ITL","CHF","HKD","SEK",
				     "AUD","DKK","BEF","ATS","NOK","NLG","SAR","KWD","BHD","AED",
				     "SGD","MYR","NZD","ESP","FIM","THB","IDR","EUR","CNY"
				    };
        return currency;

	}

	/**

     * 전달된 BigDecimal Type의 숫자가 Null이거나 0인지 체크
     * @name_ko Null 또는 0 체크
     * @param inNum 입력된 BigDecimal
     * @return boolean 입력된  BigDecimal Type의 숫자가 Null이거나 0인 경우 true, 아니면 false

     */

    public static final boolean isNullZero(BigDecimal inNum) {

        if (inNum == null || ZERO.equals(inNum))
            return true;
        else
            return false;
    }


    /**
	 * 입력된 숫자를 입력 position에서 반올림 한다.
	 * @param bd 숫자 BigDecimal 객체
	 * @param position 올림 위치
	 * @return 올림 한 BigDecimal 객체
	 */
    public static BigDecimal ceil(BigDecimal bd, int position) {
        if(position < 0)
            bd = bd.setScale(-position, 2);
        else if(position > 0) {
            long posNum = (long)Math.pow(10D, position);
            double ceiledNum = Math.ceil(bd.doubleValue() / (double)posNum) * (double)posNum;
            bd = new BigDecimal(ceiledNum);
        } else {
            double ceiledNum = Math.ceil(bd.doubleValue());
            bd = new BigDecimal(ceiledNum);
        }
        return bd;
    }

}
