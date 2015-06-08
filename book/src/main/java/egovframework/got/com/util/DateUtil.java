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
 * Class Name : DateUtil.java<br/> Description : ��¥�� ���õ� �޼��带 ������ ���� Util
 * Class.<br/><br/> �� DateUtil������ �⺻ DateŸ���� java.util.Date�� �����<br>
 * Modification Information<br/>
 *
 * <pre>
 *    ������         ������                        ��������
 *   -------      --------    --------------------------------------------------
 *   2008.10.07   ������       ���� ����
 * </pre>
 *
 * @since 2008.10.07
 * @version 1.0
 * @author hmkwon <br/><br/> Copyright (C) 2008 by SDS All right reserved.
 */

public abstract class DateUtil {
	/** Logger for this class */
	private static final Logger logger = Logger.getLogger(DateUtil.class);

	/** �⵵ ���� yyyy(4�ڸ�) */
	public static final String YEAR_FORMAT = "yyyy";

	/** �� ���� MM(2�ڸ�) */
	public static final String MONTH_FORMAT = "MM";

	/** ��¥ ���� dd(2�ڸ�) */
	public static final String DATE_FORMAT = "dd";

	/** ��� ���� yyyyMM(6�ڸ�) */
	public static final String YEAR_MONTH_FORMAT = "yyyyMM";

	/** ����� ���� yyyyMMdd(8�ڸ�) */
	public static final String DEFAULT_DATE_FORMAT = "yyyyMMdd";

	/** ��� ���� yyyy.MM(6�ڸ� �޸�) */
	public static final String DOT_MONTH_FORMAT = "yyyy.MM";

	/** ����� ���� yyyy.MM.dd(8�ڸ� �޸�) */
	public static final String DOT_DATE_FORMAT = "yyyy.MM.dd";

	/** ����� ���� yyyy-MM-dd(8�ڸ� �뽬) */
	public static final String DASH_DATE_FORMAT = "yyyy-MM-dd";

	/** ����Ͻú��ʹи��� yyyyMMddHHmmssSSS(17�ڸ�) */
	public static final String DEFAULT_DATETIME_FORMAT = "yyyyMMddHHmmssSSS";

	/** ����Ͻú��� yyyyMMddHHmmss(14�ڸ�) */
	public static final String DEFAULT_TIMESTAMP_FORMAT = "yyyyMMddHHmmss";

	/** ����Ͻú� yyyy.MM.dd HH:mm */
	public static final String DOT_DATETIME_FORMAT = "yyyy.MM.dd HH:mm";

	/** ����Ͻ� yyyy-MM-dd HH:mm */
	public static final String DASH_DATETIME_FORMAT = "yyyy-MM-dd HH:mm";

	/** ����Ͻ� yyyy.MM.dd HH:mm:ss */
	public static final String DOT_TIMESTAMP_FORMAT = "yyyy.MM.dd HH:mm:ss";

	/** ����Ͻ� yyyy-MM-dd HH:mm:ss */
	public static final String DASH_TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss";

	/** �ú��� HHmmss(6�ڸ�) */
	public static final String DEFAULT_TIME_FORMAT = "HHmmss";

	/** �ú��� HH:mm:ss */
	public static final String COLONE_TIME_FORMAT = "HH:mm:ss";

	/** �ú��ʹи��� HHmmssSSS */
	public static final String DEFAULT_TIME_MILLS_FORMAT = "HHmmssSSS";

	/** �ú��ʹи��� HH:mm:ss.SSS */
	public static final String COLONE_TIME_MILLS_FORMAT = "HH:mm:ss.SSS";

	/** yyyy�� */
	public static final String KO_YEAR_FORMAT = "yyyy��";

	/** MM�� */
	public static final String KO_MONTH_FORMAT = "MM��";

	/** yyyy�� MM�� */
	public static final String KO_YEAR_MONTH_FORMAT = "yyyy�� MM��";

	/** ''yy QUOTATION */
	public static final String QUOTATION_YEAR_FORMAT = "''yy";

	/** ''yy.MM QUOTATION */
	public static final String QUOTATION_YEAR_MONTH_FORMAT = "''yy.MM";

	/** �̿� (���� ���� �� �����⵵�� ����� ���� ���࿡ ���� ǥ�� ����� ���� ǥ��) */
	public static final String CARRY_OVER_MONTH = "13";

	/** ���� ��¥ �÷��� */
	public static final int BEFORE_DATE_FLAG = 0;

	/** ���� ��¥ �÷��� */
	public static final int AFTER_DATE_FLAG = 1;

	/** 1���� �и��ʷ� ȯ���� �� */
	public static final long ONE_DAY_MS = 24 * 60 * 60 * 1000;

	/**
	 * <p>
	 * �Է����� ���� ����(4�ڸ�)�� ���� ������ ����
	 * </p>
	 *
	 * <pre>
	 * String year = &quot;1999&quot;; (4�ڸ�)
	 * String lastYear = DateUtil.getLastYear(year);
	 * lastYear�� 1998
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
	 * �Է����� ���� ���ڿ� ���� �Է��� ������ ��ŭ ���� ���ڷ� ��ȯ
	 * </p>
	 *
	 * <pre>
	 * String strDate = null;
	 * String format = null;
	 * int month ;
	 * String beforeMonth = DateUtil.getBeforeMonth(strDate, format, month);
	 * String beforeMonth = DateUtil.getBeforeMonth(&quot;2008-10-07&quot;, DateUtil.DASH_DATE_FORMAT, 5);
	 * beforeMonth = 2008-05-07
	 * strDate�� format�� ���� �����̾�� �Ѵ�.
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
		// 2000-02-29�� �Ѵ� ������ ������ 2000-01-31���� �ƴ� 2000-01-29���� ����.
		// �������� 2�� ���϶� ���� �߻�.�̷��� ������ �ذ��ϱ� ���� ������ ������ ����.
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
	 * ���� ���� (yyyyMMdd)�� �����Ѵ�.
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
	 * ���� ���ڸ� ���ϴ� Format���� �����Ѵ�.
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
	 * ���� �ð��� "yyyyMMddHHmmss" ���·� ��ȯ�Ѵ�.
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
	 * ��������
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
	 * ����ð�
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
	 * �����Ͻÿ� �����Ͻ��� ��¥ ���̸� �ϼ��� ��� (��¥ ���� ����)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date startDate = null;
	 * java.util.Date endDate = null;
	 *
	 * Calendar calendar = Calendar.getInstance();
	 * 	Date startDate = calendar.getTime();
	 * 	calendar.set(2009,1,20); //2009�� 2�� 20��(���� 0 ���� ������)
	 * 	Date endDate = calendar.getTime();
	 *
	 * int betweenDays = DateUtil.getBetweenDays(startDate,endDate); 2008�� 10�� 9�� &tilde; 2009�� 2�� 20�ϱ��� =&gt; 134
	 * </pre>
	 *
	 * @return ������ - ������
	 */
	public static int getBetweenDays(Date startDate, Date endDate) {
		if (startDate == null || endDate == null) {
			throw new IllegalArgumentException("��������, �������ڴ� null�� �ƴϾ���մϴ�.");
		}

		long startTime = startDate.getTime();
		long endTime = endDate.getTime();

		// 1���� �и��������� ȯ��
		// 3600000 = 24*60*60*1000;
		long msSecondPerDay = 86400000;

		int days = (int) (endTime / msSecondPerDay)
				- (int) (startTime / msSecondPerDay);

		return days;
	}

	/**
	 *
	 * <p>
	 * �ý��ۿ��� ����ϴ� �������ڸ� ��ȯ�Ѵ�. '9999-12-31'
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
	 * �ý��ۿ��� ����ϴ� �������ڸ� ��ȯ�Ѵ�. '9999-12-31'
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
	 * �������� �޾Ƽ� ������ ���� ��¥�� ���Ѵ�
	 * </p>
	 *
	 * <pre>
	 * Date baseDate = calendar.getTime(); // 2008, 10, 09 �� ���
	 * java.sql.Date[] beforeAfterSqlDates = DateUtil.getBeforeAfterSqlDates(baseDate);
	 * date[0]=2008-10-08, date[1]=2008-10-10
	 * </pre>
	 *
	 * @return java.sql.Date[0] ������ ? 1��, java.sql.Date[1] ������ + 1��
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
	 * ���� ��¥�� �������� ���� ������ ���Ѵ�
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
	 * �ð��� ���ϴ� Format���� ��ȯ�Ѵ�.
	 * </p>
	 *
	 * <pre>
	 * long time = calendar.getTimeInMillis(); // ���� ��¥ long������ ������
	 * String format = DateUtil.DASH_DATE_FORMAT // YYYY-MM-DD ����
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
	 * �ش� ���ڿ��� �ð� ��ü�� ��ȯ�Ѵ�.
	 * </p>
	 *
	 * <pre>
	 *  String time = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD ����
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
	 * Timestamp�� ���ϴ� Format���� ��ȯ�Ѵ�.
	 * </p>
	 *
	 * <pre>
	 * Timestamp time = new Timestamp(calendar.getTimeInMillis()) ;
	 * String format = DateUtil.DASH_DATE_FORMAT // YYYY-MM-DD ����
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
	 * beforeFormat�� String�� ����Ÿ�� afterFormat�� �°� ��ȯ
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
					+ "����� �ٸ�");
			return null;
		}

		String addFormat = ""; // �߰����� ���˵���Ÿ
		// ���ο� ���˿� �� ����Ÿ�� �ʿ��ϴٸ�
		if ((beforeFormat.indexOf("y") < 0 && beforeFormat.indexOf("Y") < 0)
				&& (afterFormat.indexOf("y") >= 0 || afterFormat.indexOf("Y") >= 0)) {
			addFormat = YEAR_FORMAT;
		}
		// ���ο� ���˿� �� ����Ÿ�� �ʿ��ϴٸ�
		if (beforeFormat.indexOf("M") < 0 && afterFormat.indexOf("M") >= 0) {
			addFormat = addFormat + MONTH_FORMAT;
		}
		// ���ο� ���˿� �� ����Ÿ�� �ʿ��ϴٸ�
		if ((beforeFormat.indexOf("d") < 0 && beforeFormat.indexOf("D") < 0)
				&& (afterFormat.indexOf("d") >= 0 || afterFormat.indexOf("D") >= 0)) {
			addFormat = addFormat + DATE_FORMAT;
		}
		// �߰����� ����� ����Ÿ�� �ʿ��ϴٸ� ���� ���ڸ� �������� ���Ͽ� ���� ����Ÿ�� �߰��Ѵ�.
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
	 * format������ String����Ÿ�� java.util.Date�� ��ȯ (ù��° �Ķ���Ϳ� �� ���� �Ķ���� ������ ���ƾ� ��)
	 * </p>
	 *
	 * <pre>
	 * String strDate = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD ����
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
	 * format������ String����Ÿ�� java.util.Date�� ��ȯ (ù��° �Ķ���Ϳ� �� ���� �Ķ���� ������ ���ƾ� ��)
	 * </p>
	 *
	 * <pre>
	 * String strDate = &quot;2008-10-09&quot;;
	 * String format = DateUtil.DASH_DATE_FORMAT; // YYYY-MM-DD ����
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
	 * java.util.Date�� ����Ÿ�� format�� �°� String���� ��ȯ
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
	 * ������ �⵵���� �Ǻ��Ѵ�
	 * </p>
	 *
	 * <pre>
	 * String compareDate1 = &quot;2008-10-09&quot;
	 * String compareDate2 = &quot;2008-01-09&quot;
	 * String dateFormat = DateUtil.DASH_DATE_FORMAT //���� ���ڰ� �ش� �������� �Ǿ� �־�� ��.
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
	 * ù��° �⵵�� �ι�°�� ����° ������ �⵵���� �Ǻ�
	 * </p>
	 *
	 * <pre>
	 * int comDate = 2011;
	 * String compareDate1 = &quot;2010-10-09&quot; // compareDate2 ���� ���� �� �̾�� ��.
	 * String compareDate2 = &quot;2014-01-20&quot;
	 * String dateFormat = DateUtil.DASH_DATE_FORMAT; //���� ���ڿ��� �ش� ������ ���� �ؾ�
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
	 * �Է��� ��¥�� ���ó�¥ ���� ������¥���� ���� (���ó�¥ ���� ����)
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
	 * �������ڸ� �������� �񱳴�����ڰ� ���� �������� ���� (���ó�¥ ���� ����)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null; // ���س�¥
	 * java.util.Date compareDate = null; //�񱳿��� ��¥
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
	 * �Է��� ��¥�� ���ó�¥ ���� ���� ��¥���� ���� (���ó�¥ ���� ����)
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
	 * �������ڸ� �������� �񱳴�����ڰ� ���� �������� ���� (���ó�¥ ���� ����)
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null; // ���س�¥
	 * java.util.Date compareDate = null; // �񱳴�� ��
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
	 * ������ ��������� �Ǻ��Ѵ�.
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
	 * ������ ������� �Ǻ��Ѵ�.
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
	 * ������ �⵵���� �Ǻ��Ѵ�.
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
	 * �������� ���� Ȯ��
	 * </p>
	 *
	 * <pre>
	 * java.util.Date compareDate1 = null; // �񱳴�� 1
	 * java.util.Date compareDate2 = null; // �񱳴�� 2
	 * int compareType // Ÿ�� ����(1: �⵵, 2:���, 3:�����)
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
	 * �� ���ڸ� ���Ѵ�.
	 * </p>
	 *
	 * <pre>
	 * java.util.Date baseDate = null;
	 * java.util.Date compareDate = null;
	 * boolean isSameYear = DateUtil.isSameYear(compareDate1, compareDate2);
	 * </pre>
	 *
	 * @return ���� : 0, �񱳳�¥�� �����̸� 1, �񱳳�¥�� �����̸� -1
	 */
	public static int compareDate(Date baseDate, Date compareDate) {
		String standard = dateToString(baseDate, DEFAULT_DATE_FORMAT);
		String compare = dateToString(compareDate, DEFAULT_DATE_FORMAT);
		return standard.compareTo(compare);
	}

	/**
	 * <p>
	 * ���� �ð��� ���ؽð� ������ ���ϴ��� Ȯ����
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
					.error("�Է� �����͸� Ȯ���� �ֽʽÿ�.[startTime/endTime/baseTime�� ���� �ü� �����ϴ�.]");
			return false;
		}
	}

	/**
	 * <p>
	 * java.util.Date�� java.sql.Date�� ������
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
	 * �������ڷκ��� ���ڸ� ���� ��ŭ�� ��¥�� ����. ���̳ʽ�(-)�� ������ ����.
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
	 * �������ڷκ��� ���� ���� ��ŭ�� ��¥�� ����. ���̳ʽ�(-)�� ������ ����.
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
	 * �������ڷκ��� ���� ���� ��ŭ�� ��¥�� ����. ���̳ʽ�(-)�� ������ ����.
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

	// ���ذ� �ȵǴ� �޼ҵ�

	/**
	 * <p>
	 * �˻� ���� ���� ������ ���Ѵ�.
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
		// �Ʒ��� �ڵ�� ���� �ǹ���.
		calendar.add(Calendar.DATE, (-1) * calendar.get(Calendar.DATE));

		java.sql.Date lastDateOfLastMonth = new java.sql.Date(calendar
				.getTimeInMillis());

		return lastDateOfLastMonth;
	}

	/**
	 * <p>
	 * �ش� ���ڿ��� Timestamp�� ��ȯ�Ѵ�.
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
	 * Ư�� ���ڸ� ���ϴ� ������������ ��ȯ�Ѵ�.
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
	 * date ������ üũ�Ѵ�.
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