package egovframework.got.com.util;

import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * Class Name : DateUtil.java<br/> Description : 날짜와 관련된 메서드를 정의한 공통 Util
 * Class.<br/><br/> 본 DateUtil에서는 기본 Date타입을 java.util.Date를 사용함<br>
 * Modification Information<br/>
 *
 * <pre>
 *    수정일         수정자                        수정내용
 *   -------      --------    --------------------------------------------------
 *   2008.10.07   인프라       최초 생성
 * </pre>
 *
 * @since 2008.10.07
 * @version 1.0
 * @author hmkwon <br/><br/> Copyright (C) 2008 by SDS All right reserved.
 */

public abstract class DateUtil {
	/** Logger for this class */
	private static final Logger logger = Logger.getLogger(DateUtil.class);

	/** 년도 포맷 yyyy(4자리) */
	public static final String YEAR_FORMAT = "yyyy";

	/** 월 포맷 MM(2자리) */
	public static final String MONTH_FORMAT = "MM";

	/** 날짜 포맷 dd(2자리) */
	public static final String DATE_FORMAT = "dd";

	/** 년월 포맷 yyyyMM(6자리) */
	public static final String YEAR_MONTH_FORMAT = "yyyyMM";

	/** 년월일 포맷 yyyyMMdd(8자리) */
	public static final String DEFAULT_DATE_FORMAT = "yyyyMMdd";

	/** 년월 포맷 yyyy.MM(6자리 콤마) */
	public static final String DOT_MONTH_FORMAT = "yyyy.MM";

	/** 년월일 포맷 yyyy.MM.dd(8자리 콤마) */
	public static final String DOT_DATE_FORMAT = "yyyy.MM.dd";

	/** 년월일 포맷 yyyy-MM-dd(8자리 대쉬) */
	public static final String DASH_DATE_FORMAT = "yyyy-MM-dd";

	/** 년월일시분초밀리초 yyyyMMddHHmmssSSS(17자리) */
	public static final String DEFAULT_DATETIME_FORMAT = "yyyyMMddHHmmssSSS";

	/** 년월일시분초 yyyyMMddHHmmss(14자리) */
	public static final String DEFAULT_TIMESTAMP_FORMAT = "yyyyMMddHHmmss";

	/** 년월일시분 yyyy.MM.dd HH:mm */
	public static final String DOT_DATETIME_FORMAT = "yyyy.MM.dd HH:mm";

	/** 년월일시 yyyy-MM-dd HH:mm */
	public static final String DASH_DATETIME_FORMAT = "yyyy-MM-dd HH:mm";

	/** 년월일시 yyyy.MM.dd HH:mm:ss */
	public static final String DOT_TIMESTAMP_FORMAT = "yyyy.MM.dd HH:mm:ss";

	/** 년월일시 yyyy-MM-dd HH:mm:ss */
	public static final String DASH_TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss";

	/** 시분초 HHmmss(6자리) */
	public static final String DEFAULT_TIME_FORMAT = "HHmmss";

	/** 시분초 HH:mm:ss */
	public static final String COLONE_TIME_FORMAT = "HH:mm:ss";

	/** 시분초밀리초 HHmmssSSS */
	public static final String DEFAULT_TIME_MILLS_FORMAT = "HHmmssSSS";

	/** 시분초밀리초 HH:mm:ss.SSS */
	public static final String COLONE_TIME_MILLS_FORMAT = "HH:mm:ss.SSS";

	/** yyyy년 */
	public static final String KO_YEAR_FORMAT = "yyyy년";

	/** MM월 */
	public static final String KO_MONTH_FORMAT = "MM월";

	/** yyyy년 MM월 */
	public static final String KO_YEAR_MONTH_FORMAT = "yyyy년 MM월";

	/** ''yy QUOTATION */
	public static final String QUOTATION_YEAR_FORMAT = "''yy";

	/** ''yy.MM QUOTATION */
	public static final String QUOTATION_YEAR_MONTH_FORMAT = "''yy.MM";

	/** 이월 (예산 집행 시 다음년도에 집행된 예산 집행에 대한 표준 년월의 월을 표현) */
	public static final String CARRY_OVER_MONTH = "13";

	/** 이전 날짜 플래그 */
	public static final int BEFORE_DATE_FLAG = 0;

	/** 이후 날짜 플래그 */
	public static final int AFTER_DATE_FLAG = 1;

	/** 1일을 밀리초로 환산한 값 */
	public static final long ONE_DAY_MS = 24 * 60 * 60 * 1000;

	/**
	 * <p>
	 * 입력으로 들어온 연도(4자리)의 이전 연도를 리턴
	 * </p>
	 *
	 * <pre>
	 * String year = &quot;1999&quot;; (4자리)
	 * String lastYear = DateUtil.getLastYear(year);
	 * lastYear는 1998
	 * </pre>
	 *
	 * @return String
	 */
	public static String getLastYear(String year) {
		int intYear = Integer.parseInt(year);
		return Integer.toString(intYear - 1);
	}

	/**
	 * <p>
	 * 입력으로 들어온 일자에 대해 입력한 개월수 만큼 이전 일자로 변환
	 * </p>
	 *
	 * <pre>
	 * String strDate = null;
	 * String format = null;
	 * int month ;
	 * String beforeMonth = DateUtil.getBeforeMonth(strDate, format, month);
	 * String beforeMonth = DateUtil.getBeforeMonth(&quot;2008-10-07&quot;, DateUtil.DASH_DATE_FORMAT, 5);
	 * beforeMonth = 2008-05-07
	 * strDate와 format는 같은 패턴이어야 한다.
	 * </pre>
	 *
	 * @return String
	 */
	public static String getBeforeMonth(String strDate, String format, int month) {
		SimpleDateFormat fmt = new SimpleDateFormat(format);
		Calendar calendar = Calendar.getInstance();
		try {
			calendar.setTime(fmt.parse(strDate));
		} catch (Exception e) {
			return null;
		}
		// 2000-02-29의 한달 이전을 던지면 2000-01-31일이 아닌 2000-01-29일이 나옴.
		// 기준일이 2월 말일때 문제 발생.이러한 문제를 해결하기 위해 마지막 날인지 점검.
		if (calendar.get(Calendar.DATE) == calendar
				.getActualMaximum(Calendar.DATE)) {
			calendar.add(Calendar.MONTH, -1 * month);
			calendar.set(Calendar.DATE, calendar
					.getActualMaximum(Calendar.DAY_OF_MONTH));
		} else {
			calendar.add(Calendar.MONTH, -1 * month);
		}

		return dateToString(calendar.getTime(), format);
	}

	/**
	 * <p>
	 * 현재 일자 (yyyyMMdd)를 리턴한다.
	 * </p>
	 *
	 * <pre>
	 * String curDate = DateUtil.getCurrentDate();
	 * </pre>
	 *
	 * @return String
	 */
	public static String getCurrentDate() {
		SimpleDateFormat df = new SimpleDateFormat(DEFAULT_DATE_FORMAT);
		return df.format(new Date());
	}

	/**
	 * <p>
	 * 현재 일자를 원하는 Format으로 리턴한다.
	 * </p>
	 *
	 * <pre>
	 * String format = null;
	 * String curDate = DateUtil.getCurrentDate(format);
	 * </pre>
	 *
	 * @return String
	 */
	public static String getCurrentDate(String format) {
		SimpleDateFormat df = new SimpleDateFormat(format);
		return df.format(new Date());
	}

	/**
	 * <p>
	 * 현재 시간을 "yyyyMMddHHmmss" 형태로 반환한다.
	 * </p>
	 *
	 * <pre>
	 * String curDateTime = DateUtil.getCurrentDateTime();
	 * </pre>
	 *
	 * @return String
	 */
	public static String getCurrentDateTime() {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat(
				DEFAULT_TIMESTAMP_FORMAT);
		return formatter.format(calendar.getTime());
	}

	/**
	 * <p>
	 * 현재일자
	 * </p>
	 *
	 * <pre>
	 * java.sql.Date curSqlDate = DateUtil.getCurrentSqlDate();
	 * curSqlDate = 2008-10-07
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date getCurrentSqlDate() {
		return new java.sql.Date(convertStringToDate(getCurrentDate(),
				DEFAULT_DATE_FORMAT).getTime());
	}

	/**
	 *
	 * <p>
	 * 현재시각
	 * </p>
	 *
	 * <pre>
	 * java.sql.Time curSqlTime = DateUtil.getCurrentSqlTime();
	 * curSqlTime = 15:00:44
	 * </pre>
	 *
	 * @return java.sql.Time
	 */
	public static java.sql.Time getCurrentSqlTime() {
		return new java.sql.Time(System.currentTimeMillis());
	}

	/**
	 *
	 * <p>
	 * 시작일시와 종료일시의 날짜 차이를 일수로 계산 (날짜 갯수 리턴)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date startDate = null;
	 * java.util.Date endDate = null;
	 *
	 * Calendar calendar = Calendar.getInstance();
	 * 	Date startDate = calendar.getTime();
	 * 	calendar.set(2009,1,20); //2009년 2월 20일(월은 0 부터 시작임)
	 * 	Date endDate = calendar.getTime();
	 *
	 * int betweenDays = DateUtil.getBetweenDays(startDate,endDate); 2008년 10월 9일 &tilde; 2009년 2월 20일까지 =&gt; 134
	 * </pre>
	 *
	 * @return 종료일 - 시작일
	 */
	public static int getBetweenDays(Date startDate, Date endDate) {
		if (startDate == null || endDate == null) {
			throw new IllegalArgumentException("시작일자, 종료일자는 null이 아니어야합니다.");
		}

		long startTime = startDate.getTime();
		long endTime = endDate.getTime();

		// 1일을 밀리세컨으로 환산
		// 3600000 = 24*60*60*1000;
		long msSecondPerDay = 86400000;

		int days = (int) (endTime / msSecondPerDay)
				- (int) (startTime / msSecondPerDay);

		return days;
	}

	/**
	 *
	 * <p>
	 * 시스템에서 사용하는 최종일자를 반환한다. '9999-12-31'
	 * </p>
	 *
	 * <pre>
	 * java.util.Date maxDate = DateUtil.getMaximumDate();
	 * getMaximumDate=Fri Dec 31 00:00:00 KST 9999
	 * </pre>
	 *
	 * @return Date
	 */
	public static Date getMaximumDate() {
		return convertStringToDate("99991231", DEFAULT_DATE_FORMAT);
	}

	/**
	 * <p>
	 * 시스템에서 사용하는 최종일자를 반환한다. '9999-12-31'
	 * </p>
	 *
	 * <pre>
	 * java.sql.Date maxDate = DateUtil.getMaximumSqlDate();
	 * getMaximumSqlDate=9999-12-31
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date getMaximumSqlDate() {
		return new java.sql.Date(convertStringToDate("99991231",
				DEFAULT_DATE_FORMAT).getTime());
	}

	/**
	 * <p>
	 * 기준일을 받아서 기준일 전후 날짜를 구한다
	 * </p>
	 *
	 * <pre>
	 * Date baseDate = calendar.getTime(); // 2008, 10, 09 인 경우
	 * java.sql.Date[] beforeAfterSqlDates = DateUtil.getBeforeAfterSqlDates(baseDate);
	 * date[0]=2008-10-08, date[1]=2008-10-10
	 * </pre>
	 *
	 * @return java.sql.Date[0] 기준일 ? 1일, java.sql.Date[1] 기준일 + 1일
	 */
	public static java.sql.Date[] getBeforeAfterSqlDates(Date baseDate) {
		java.sql.Date[] generatedDates = new java.sql.Date[2];
		long baseTime = baseDate.getTime();
		generatedDates[BEFORE_DATE_FLAG] = new java.sql.Date(baseTime
				- ONE_DAY_MS);
		generatedDates[AFTER_DATE_FLAG] = new java.sql.Date(baseTime
				+ ONE_DAY_MS);

		return generatedDates;
	}

	/**
	 * <p>
	 * 현재 날짜를 기준으로 전월 말일을 구한다
	 * </p>
	 *
	 * <pre>
	 * java.sql.Date lastDateOfPrevMont = DateUtil.getLastDateOfPrevMonth();
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date getLastDateOfPrevMonth() {
		return getLastDateOfPrevMonth(null);
	}

	/**
	 * <p>
	 * 시간을 원하는 Format으로 반환한다.
	 * </p>
	 *
	 * <pre>
	 * long time = calendar.getTimeInMillis(); // 현재 날짜 long형으로 가져옴
	 * String format = DateUtil.DASH_DATE_FORMAT // YYYY-MM-DD 형태
	 * String convertTimeToString = DateUtil.convertTimeToString(time,format); convertDate=2008-10-09 (YYYY-MM-DD)
	 * </pre>
	 *
	 * @return String
	 */
	public static String convertTimeToString(long time, String format) {
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		return formatter.format(new Date(time));
	}

	/**
	 * <p>
	 * 해당 문자열을 시간 객체로 반환한다.
	 * </p>
	 *
	 * <pre>
	 *  String time = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD 형태
	 * java.sql.Time convertStringToTime = DateUtil.convertStringToTime(time,format); convertStringToTime
	 * </pre>
	 *
	 * @return Time
	 */
	public static Time convertStringToTime(String time, String format) {
		Date date = convertStringToDate(time, format);
		logger.info("date=" + date.toString());
		return new Time(date.getTime());
	}

	/**
	 * <p>
	 * Timestamp를 원하는 Format으로 반환한다.
	 * </p>
	 *
	 * <pre>
	 * Timestamp time = new Timestamp(calendar.getTimeInMillis()) ;
	 * String format = DateUtil.DASH_DATE_FORMAT // YYYY-MM-DD 형태
	 * String convertTimestampToString = DateUtil.convertTimestampToString(time,format); convertTimestampToString=2008-10-09 (YYYY-MM-DD)
	 * </pre>
	 *
	 * @return String
	 */
	public static String convertTimestampToString(Timestamp time, String format) {
		if (time == null) return null;
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		return formatter.format(time);
	}

	/**
	 * <p>
	 * beforeFormat인 String인 데이타를 afterFormat에 맞게 변환
	 * </p>
	 *
	 * <pre>
	 * String strDate = &quot;2008-10-09&quot;
	 * String beforeFormat = DateUtil.DASH_DATE_FORMAT; // dash format
	 * String afterFormat = DateUtil.DOT_DATE_FORMAT; // doc format
	 * String convertStringToString = DateUtil.convertStringToString(strDate,beforeFormat,afterFormat);
	 * convertStringToString = &quot;2008.10.09&quot;
	 * </pre>
	 *
	 * @return String
	 */
	public static String convertStringToString(String strDate,
			String beforeFormat, String afterFormat) {
		if (strDate == null || strDate.length() == 0) {
			return null;
		}
		if (strDate.length() != beforeFormat.length()) {
			logger.error("DateUtil.convertStringToTimestamp : "
					+ "사이즈가 다름");
			return null;
		}

		String addFormat = ""; // 추가적인 포맷데이타
		// 새로운 포맷에 연 데이타가 필요하다면
		if ((beforeFormat.indexOf("y") < 0 && beforeFormat.indexOf("Y") < 0)
				&& (afterFormat.indexOf("y") >= 0 || afterFormat.indexOf("Y") >= 0)) {
			addFormat = YEAR_FORMAT;
		}
		// 새로운 포맷에 월 데이타가 필요하다면
		if (beforeFormat.indexOf("M") < 0 && afterFormat.indexOf("M") >= 0) {
			addFormat = addFormat + MONTH_FORMAT;
		}
		// 새로운 포맷에 일 데이타가 필요하다면
		if ((beforeFormat.indexOf("d") < 0 && beforeFormat.indexOf("D") < 0)
				&& (afterFormat.indexOf("d") >= 0 || afterFormat.indexOf("D") >= 0)) {
			addFormat = addFormat + DATE_FORMAT;
		}
		// 추가적인 년월일 데이타가 필요하다면 현재 일자를 기준으로 구하여 기존 데이타에 추가한다.
		if (addFormat.length() > 0) {
			String addDate = getCurrentDate(addFormat);
			strDate = addDate + strDate;
			beforeFormat = addFormat + beforeFormat;
		}

		java.util.Date date = convertStringToDate(strDate, beforeFormat);
		return convertDateToString(date, afterFormat);
	}

	/**
	 * <p>
	 * format형태인 String데이타를 java.util.Date로 변환 (첫번째 파라미터와 두 번재 파라미터 포맷이 같아야 함)
	 * </p>
	 *
	 * <pre>
	 * String strDate = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD 형태
	 * java.util.Date convertStringToDate = DateUtil.convertStringToDate(strDate,
	 * 		format);
	 * </pre>
	 *
	 * @return Date
	 */
	public static Date convertStringToDate(String strDate, String format) {


		if (strDate == null || strDate.length() == 0) {
			return null;
		}
		if (strDate.length() != format.length()) {
			return null;
		}
		if ( ! isValidDate(strDate , format) ) {
			logger.error("InValid date String  [" +strDate + "]");
			return null;
		}
		try {
			SimpleDateFormat fmt = new SimpleDateFormat(format);
			return fmt.parse(strDate, new ParsePosition(0));
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * <p>
	 * format형태인 String데이타를 java.util.Date로 변환 (첫번째 파라미터와 두 번재 파라미터 포맷이 같아야 함)
	 * </p>
	 *
	 * <pre>
	 * String strDate = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD 형태
	 * java.sql.Date convertStringToSqlDate = DateUtil.convertStringToSqlDate(strDate,
	 * 		format);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date convertStringToSqlDate(String strDate,
			String format) {
		return new java.sql.Date(convertStringToDate(strDate, format).getTime());
	}

	/**
	 * <p>
	 * java.util.Date인 데이타를 format에 맞게 String으로 변환
	 * </p>
	 *
	 * <pre>
	 * java.util.Date date = calendar.getTime();
	 * String format = DateUtil.DOT_DATE_FORMAT;
	 * String convertDateToString = DateUtil.convertDateToString(date,format);
	 * convertDateToString = 2008.10.09
	 * </pre>
	 *
	 * @return String
	 */
	public static String convertDateToString(Date date, String format) {
		if (date == null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	/**
	 * <p>
	 * 동일한 년도인지 판별한다
	 * </p>
	 *
	 * <pre>
	 * String compareDate1 = &quot;2008-10-09&quot;
	 * String compareDate2 = &quot;2008-01-09&quot;
	 * String dateFormat = DateUtil.DASH_DATE_FORMAT //위의 문자가 해당 포맷으로 되어 있어야 함.
	 * boolean isSameYear = DateUtil.isSameYear(compareDate1,compareDate2,dateFormat); //true
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isSameYear(String compareDate1, String compareDate2,
			String dateFormat) {
		String date1 = convertStringToString(compareDate1, dateFormat,
				YEAR_FORMAT);
		String date2 = convertStringToString(compareDate2, dateFormat,
				YEAR_FORMAT);

		return date1.equals(date2);
	}

	/**
	 * <p>
	 * 첫번째 년도가 두번째와 세번째 사이의 년도인지 판별
	 * </p>
	 *
	 * <pre>
	 * int comDate = 2011;
	 * String compareDate1 = &quot;2010-10-09&quot; // compareDate2 보다 작은 수 이어야 함.
	 * String compareDate2 = &quot;2014-01-20&quot;
	 * String dateFormat = DateUtil.DASH_DATE_FORMAT; //위의 문자열이 해당 포맷을 유지 해야
	 * boolean isBetweenYear = DateUtil.isBetweenYear(comDate,compareDate1,compareDate2,dateFormat); //true
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isBetweenYear(int comDate, String compareDate1,
			String compareDate2, String dateFormat) {

		int date1 = Integer.parseInt(convertStringToString(compareDate1,
				dateFormat, YEAR_FORMAT));
		int date2 = Integer.parseInt(convertStringToString(compareDate2,
				dateFormat, YEAR_FORMAT));
		if (comDate >= date1 && comDate <= date2) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * <p>
	 * 입력한 날짜가 오늘날짜 기준 이전날짜인지 여부 (오늘날짜 포함 안함)
	 * </p>
	 *
	 * <pre>
	 * int comDate;
	 * java.util.Date date = null;
	 * boolean isBeforeDate = DateUtil.isBeforeDate(date);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isBeforeDate(Date date) {
		String currentDate = getCurrentDate(DEFAULT_DATE_FORMAT);
		String compareDate = dateToString(date, DEFAULT_DATE_FORMAT);
		int compare = currentDate.compareTo(compareDate);
		if (compare > 0)
			return true;
		return false;
	}

	/**
	 * <p>
	 * 기준일자를 기준으로 비교대상일자가 이전 일자인지 여부 (오늘날짜 포함 안함)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null; // 기준날짜
	 * java.util.Date compareDate = null; //비교여부 날짜
	 * boolean isBeforeDate = DateUtil.isBeforeDate(baseDate, compareDate);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isBeforeDate(Date baseDate, Date compareDate) {
		int compareResult = compareDate(baseDate, compareDate);

		return compareResult > 0 ? true : false;
	}

	/**
	 * <p>
	 * 입력한 날짜가 오늘날짜 기준 이후 날짜인지 여부 (오늘날짜 포함 안함)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date date = null;
	 * boolean isAfterDate = DateUtil.isAfterDate(date);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isAfterDate(Date date) {
		String currentDate = getCurrentDate(DEFAULT_DATE_FORMAT);
		String compareDate = dateToString(date, DEFAULT_DATE_FORMAT);
		int compare = currentDate.compareTo(compareDate);
		if (compare < 0)
			return true;
		return false;
	}

	/**
	 * <p>
	 * 기준일자를 기준으로 비교대상일자가 이후 일자인지 여부 (오늘날짜 포함 안함)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null; // 기준날짜
	 * java.util.Date compareDate = null; // 비교대상 날
	 * boolean isAfterDate = DateUtil.isAfterDate(baseDate, compareDate);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isAfterDate(Date baseDate, Date compareDate) {
		int compareResult = compareDate(baseDate, compareDate);

		return compareResult < 0 ? true : false;
	}

	/**
	 * <p>
	 * 동일한 년월일인지 판별한다.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date compareDate1 = null;
	 * java.util.Date compareDate2 = null;
	 * boolean isSameDate = DateUtil.isSameDate(compareDate1, compareDate2);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isSameDate(Date compareDate1, Date compareDate2) {
		return isSame(compareDate1, compareDate2, 3);
	}

	/**
	 * <p>
	 * 동일한 년월인지 판별한다.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date compareDate1 = null;
	 * java.util.Date compareDate2 = null;
	 * boolean isSameMonth = DateUtil.isSameMonth(compareDate1, compareDate2);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isSameMonth(Date compareDate1, Date compareDate2) {
		return isSame(compareDate1, compareDate2, 2);
	}

	/**
	 * <p>
	 * 동일한 년도인지 판별한다.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date compareDate1 = null;
	 * java.util.Date compareDate2 = null;
	 * boolean isSameYear = DateUtil.isSameYear(compareDate1, compareDate2);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isSameYear(Date compareDate1, Date compareDate2) {
		return isSame(compareDate1, compareDate2, 1);
	}

	/**
	 * <p>
	 * 동일한지 여부 확인
	 * </p>
	 *
	 * <pre>
	 * java.util.Date compareDate1 = null; // 비교대상 1
	 * java.util.Date compareDate2 = null; // 비교대상 2
	 * int compareType // 타입 여부(1: 년도, 2:년월, 3:년월일)
	 * boolean isSameYear = DateUtil.isSameYear(compareDate1,compareDate2);
	 * </pre>
	 *
	 * @return boolean
	 */
	private static boolean isSame(Date compareDate1, Date compareDate2,
			int compareType) {
		String format = null;
		switch (compareType) {
		case 1:
			format = YEAR_FORMAT;
			break;
		case 2:
			format = YEAR_MONTH_FORMAT;
			break;
		case 3:
			format = DEFAULT_DATE_FORMAT;
			break;
		}
		String date1 = dateToString(compareDate1, format);
		String date2 = dateToString(compareDate2, format);
		return date1.equals(date2);
	}

	/**
	 * <p>
	 * 두 일자를 비교한다.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null;
	 * java.util.Date compareDate = null;
	 * boolean isSameYear = DateUtil.isSameYear(compareDate1, compareDate2);
	 * </pre>
	 *
	 * @return 동일 : 0, 비교날짜가 이전이면 1, 비교날짜기 이후이면 -1
	 */
	public static int compareDate(Date baseDate, Date compareDate) {
		String standard = dateToString(baseDate, DEFAULT_DATE_FORMAT);
		String compare = dateToString(compareDate, DEFAULT_DATE_FORMAT);
		return standard.compareTo(compare);
	}

	/**
	 * <p>
	 * 현재 시간이 기준시간 영역에 속하는지 확인함
	 * </p>
	 *
	 * <pre>
	 * java.sql.Time startTime = null;
	 * java.sql.Time endTime = null;
	 * java.sql.Time baseTime = null;
	 * boolean isInTimeRange = DateUtil.isInTimeRange(startTime, endTime, baseTime);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isInTimeRange(Time startTime, Time endTime,
			Time baseTime) {
		if (startTime != null && endTime != null && baseTime != null) {
			if (startTime.getTime() >= endTime.getTime()) {
				endTime.setTime(endTime.getTime() + (ONE_DAY_MS));
			}

			if (baseTime.getTime() < startTime.getTime()) {
				baseTime.setTime(baseTime.getTime() + (ONE_DAY_MS));
			}

			return (startTime.getTime() <= baseTime.getTime())
					&& (endTime.getTime() >= baseTime.getTime());
		} else {
			logger
					.error("입력 데이터를 확인해 주십시요.[startTime/endTime/baseTime은 널이 올수 없습니다.]");
			return false;
		}
	}

	/**
	 * <p>
	 * java.util.Date를 java.sql.Date로 변경함
	 * </p>
	 *
	 * <pre>
	 * java.util.Date date = calendar.getTime();
	 * java.sql.Date isInTimeRange = DateUtil.toSqlDate(date);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date toSqlDate(java.util.Date date) {
		return new java.sql.Date(date.getTime());
	}

	/**
	 * <p>
	 * 기준일자로부터 일자를 더한 만큼의 날짜를 리턴. 마이너스(-)는 이전을 뜻함.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null;
	 * int addDay;
	 * java.sql.Date addDD = DateUtil.addDay(baseDate, addDay);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date addDay(java.sql.Date baseDate, int addDay) {
		return addDate(baseDate, addDay, 3);
	}

	/**
	 * <p>
	 * 기준일자로부터 월을 더한 만큼의 날짜를 리턴. 마이너스(-)는 이전을 뜻함.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null;
	 * int addMonth;
	 * java.sql.Date addMM = DateUtil.addMonth(baseDate, addMonth);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date addMonth(java.sql.Date baseDate, int addMonth) {
		return addDate(baseDate, addMonth, 2);
	}

	/**
	 * <p>
	 * 기준일자로부터 년을 더한 만큼의 날짜를 리턴. 마이너스(-)는 이전을 뜻함.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null;
	 * int addYear;
	 * java.sql.Date addYY = DateUtil.addMonth(baseDate, addYear);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date addYear(java.sql.Date baseDate, int addYear) {
		return addDate(baseDate, addYear, 1);
	}

	private static java.sql.Date addDate(java.sql.Date baseDate, int addDate,
			int dateType) {
		Calendar calendar = Calendar.getInstance();

		if (baseDate != null) {
			calendar.setTime(baseDate);
		}

		switch (dateType) {
		case 1:
			calendar.add(Calendar.YEAR, addDate);
			break;
		case 2:
			calendar.add(Calendar.MONTH, addDate);
			break;
		case 3:
			calendar.add(Calendar.DATE, addDate);
			break;
		}

		java.sql.Date addResult = new java.sql.Date(calendar.getTimeInMillis());

		return addResult;
	}

	// 이해가 안되는 메소드

	/**
	 * <p>
	 * 검색 기준 전월 말일을 구한다.
	 * </p>
	 *
	 * <pre>
	 * java.sql.Date baseDate = null;
	 * java.sql.Date lastDateOfPrevMonth = DateUtil.baseDate(baseDate);
	 * </pre>
	 *
	 * @return java.sql.Date
	 */
	public static java.sql.Date getLastDateOfPrevMonth(java.sql.Date baseDate) {
		Calendar calendar = Calendar.getInstance();
		if (baseDate != null) {
			calendar.setTime(baseDate);
		}
		// calendar.add(Calendar.MONTH, -1);
		// calendar.set(Calendar.DATE,
		// calendar.getActualMaximum(Calendar.DATE));
		// 아래의 코드와 같은 의미임.
		calendar.add(Calendar.DATE, (-1) * calendar.get(Calendar.DATE));

		java.sql.Date lastDateOfLastMonth = new java.sql.Date(calendar
				.getTimeInMillis());

		return lastDateOfLastMonth;
	}

	/**
	 * <p>
	 * 해당 문자열을 Timestamp로 반환한다.
	 * </p>
	 *
	 * <pre>
	 * String time = null;
	 * String format = null;
	 * java.sql.Timestamp convertStringToTimestamp = DateUtil
	 * 		.convertStringToTimestamp(time, format);
	 * </pre>
	 *
	 * @return Timestamp
	 */
	public static Timestamp convertStringToTimestamp(String time, String format) {

		 if(time == null || "".equals(time))
	        {
			 	return null;

	        } else {
				Date date = convertStringToDate(time, format);
				return new Timestamp(date.getTime());
	        }
	}

	/**
	 * <p>
	 * 특정 일자를 원하는 포맷형식으로 반환한다.
	 *
	 * <pre>
	 * java.util.Date date = null;
	 * String format = null;
	 * String dateToString = DateUtil.dateToString(date, format);
	 * </pre>
	 *
	 * @return String
	 */
	public static String dateToString(Date date, String format) {
		SimpleDateFormat df = new SimpleDateFormat(format);
		return df.format(date);
	}

	/**
	 * <p>
	 * date 형식을 체크한다.
	 *
	 * <pre>
	 * String date = "2008/09/40";
	 * String format = "yyyy/MM/dd";
	 * boolean isValidDate = DateUtil.isValidDate(date, format);
	 * </pre>
	 *
	 * @return boolean
	 */
	public static boolean isValidDate(String date, String format) {
		// set date format, this can be changed to whatever format
		// you want, MM-dd-yyyy, MM.dd.yyyy, dd.MM.yyyy etc.
		// you can read more about it here:
		// http://java.sun.com/j2se/1.4.2/docs/api/index.html

		SimpleDateFormat sdf = new SimpleDateFormat(format);

		// declare and initialize testDate variable, this is what will hold
		// our converted string

		Date testDate = null;

		// we will now try to parse the string into date form
		try {
			testDate = sdf.parse(date);
		}

		// if the format of the string provided doesn't match the format we
		// declared in SimpleDateFormat() we will get an exception

		catch (ParseException e) {

			return false;
		}

		// dateformat.parse will accept any date as long as it's in the format
		// you defined, it simply rolls dates over, for example, december 32
		// becomes jan 1 and december 0 becomes november 30
		// This statement will make sure that once the string
		// has been checked for proper formatting that the date is still the
		// date that was entered, if it's not, we assume that the date is
		// invalid

		if (!sdf.format(testDate).equals(date)) {
			// errorMessage = "The date that you provided is invalid.";
			return false;
		}

		// if we make it to here without getting an error it is assumed that
		// the date was a valid one and that it's in the proper format

		return true;

	} // end isValidDate

}