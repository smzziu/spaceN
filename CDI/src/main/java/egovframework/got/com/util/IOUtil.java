package egovframework.got.com.util;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public abstract class IOUtil {
	
	public static String setString(int i) {
		return String.valueOf(i);
	}
	
	public static String setString(Object obj) {
		String returnString = String.valueOf(obj);
		if ("null".equals(returnString)) return "";
		return returnString;
	}
	
	/*public static String getString(HashMap map, String key) {
		if ( map.get(key) == null)
			return "";
		else
			return map.get(key).toString();
	}*/
	public static String getString(Map map, String key) {
		if ( map.get(key) == null)
			return "";
		else
			return map.get(key).toString();
	}
	public static BigDecimal getBigDecimal(Map map, String key) {
		String wrkvar = null;
		if ( map.get(key) == null)
			return null;//wrkvar = "0";
		else if ( "".equals(map.get(key)) || "null".equals(map.get(key)))
			return null;//wrkvar = "0";
		else 
			wrkvar = map.get(key).toString().replaceAll(",", "");
		return new BigDecimal(wrkvar);
	}

	public static int getInt(Map map, String key) {
		String wrkvar = null;
		if ( map.get(key) == null)
			wrkvar = "0";
		else if ( map.get(key).toString().equals(""))
			wrkvar = "0";
		else
			wrkvar = map.get(key).toString().replaceAll(",", "");
		return Integer.parseInt(wrkvar);
	}
	
	public static Integer getInteger(Map map, String key) {
		String wrkvar = null;
		if ( map.get(key) == null)
			wrkvar = "0";
		else if ( map.get(key).toString().equals(""))
			wrkvar = "0";
		else
			wrkvar = map.get(key).toString().replaceAll(",", "");
		return new Integer(wrkvar);
	}

////////////////////////////////////////////////
// MVO 전문 처리 위한 메소스 들	
	public static BigDecimal getBigDecimal(String args) {
		String wrkvar = null;
		if ( args == null)
			wrkvar = "0";
		else if ( args.equals(""))
			wrkvar = "0";
		else 
			wrkvar = args.replaceAll(",", "");
		return new BigDecimal(wrkvar);
	}

	public static int getInt(String args) {
		String wrkvar = null;
		if ( args == null)
			wrkvar = "0";
		else if ( args.equals(""))
			wrkvar = "0";
		else
			wrkvar = args.replaceAll(",", "");
		return Integer.parseInt(wrkvar);
	}

	public static Integer getInteger(String args) {
		String wrkvar = null;
		if ( args == null)
			wrkvar = "0";
		else if ( args.equals(""))
			wrkvar = "0";
		else
			wrkvar = args.replaceAll(",", "");
		return new Integer(wrkvar);
	}

	//bytes, string, BigDecimal, int에 대한 rpad와 bytecopy 메소드 start	
	public static byte[] rpad(byte[] inbytes, int length, char pad) {
		int inlen  = inbytes.length;
		byte[] outbytes = new byte[length];
		if(inlen > length) {
			System.arraycopy(inbytes, 0, outbytes, 0, length);
		} else {
			System.arraycopy(inbytes, 0, outbytes, 0, inlen);
			for(int i=inlen; i<length; i++) {
				outbytes[i] = (byte)pad;
			}
		}
		return outbytes;
	}

	

	//charSet없는 String rpad
	public static byte[] rpad(String strval, int length, char pad) throws Exception {
		if (strval == null) {
			strval = "";
		}
		return rpad(strval.getBytes(), length, pad);
	}

	public static byte[] rpad(String strval, int length, char pad, String charSet) throws Exception {
		if (strval == null) {
			strval = "";
		}
		return rpad(strval.getBytes(charSet), length, pad);
	}
	
	public static void bytecopy(int intval, byte[] destBytes, int destPos, int length, char pad, String charSet)  {
		byte[] srcBytes = IOUtil.rpad(intval, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	public static void bytecopy(String strval, byte[] destBytes, int destPos, int length, char pad, String charSet) throws Exception {
		byte[] srcBytes = rpad(strval, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	public static void bytecopy(byte[] inbytes, int srcPos, byte[] destBytes, int destPos, int length, char pad) throws Exception {
		byte[] srcBytes = rpad(inbytes, length, pad);
		System.arraycopy(srcBytes, srcPos, destBytes, destPos, length);
	}
	public static void bytecopy(BigDecimal bd, byte[] destBytes, int destPos, int length, char pad, String charSet) throws Exception {
		byte[] srcBytes = rpad(bd, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	
	public static void leftBytecopy(int intval, byte[] destBytes, int destPos, int length, char pad, String charSet)  {
		byte[] srcBytes = IOUtil.lpad(intval, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	public static void leftBytecopy(String strval, byte[] destBytes, int destPos, int length, char pad, String charSet) throws Exception {
		byte[] srcBytes = lpad(strval, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	public static void leftBytecopy(byte[] inbytes, int srcPos, byte[] destBytes, int destPos, int length, char pad) throws Exception {
		byte[] srcBytes = lpad(inbytes, length, pad);
		System.arraycopy(srcBytes, srcPos, destBytes, destPos, length);
	}
	public static void leftBytecopy(BigDecimal bd, byte[] destBytes, int destPos, int length, char pad, String charSet) throws Exception {
		byte[] srcBytes = lpad(bd, length, pad, charSet);
		System.arraycopy(srcBytes, 0, destBytes, destPos, length);
	}
	
	//charSet없는 BigDecimal rpad
	public static byte[] rpad(BigDecimal bd, int length, char pad) throws Exception {
		byte[] bytes = null;
		if (bd == null) {
			bytes = "".getBytes();
		} else {
			bytes = String.valueOf(bd).getBytes();
		}
		return rpad(bytes, length, pad);
	}

	public static byte[] rpad(BigDecimal bd, int length, char pad, String charSet) throws Exception {
		byte[] bytes = null;
		if (bd == null) {
			bytes = "".getBytes();
		} else {
			bytes = String.valueOf(bd).getBytes();
		}
		return rpad(bytes, length, pad);
	}

	

	//charSet없는 int rpad
	public static byte[] rpad(int intval, int length, char pad) throws Exception {
		byte[] bytes = String.valueOf(intval).getBytes();
		return rpad(bytes, length, pad);
	}

	public static byte[] rpad(int intval, int length, char pad, String charSet)  {
		byte[] bytes = String.valueOf(intval).getBytes();
		return rpad(bytes, length, pad);
	}

	
	//bytes, string, BigDecimal, int에 대한 rpad와 bytecopy 메소드 end

	//charSet없는 substr
	public static String substr(byte[] bytes, int spos, int epos)  {
		int length = epos - spos;
		byte[] outbytes = new byte[length];
		System.arraycopy(bytes, spos, outbytes, 0, length);
		return new String(outbytes);
	}

	public static String substr(byte[] bytes, int spos, int epos, String charSet) throws UnsupportedEncodingException  {
		int length = epos - spos;
		byte[] outbytes = new byte[length];
		System.arraycopy(bytes, spos, outbytes, 0, length);
		return new String(outbytes, charSet);
	}

	public static byte[] subbyte(byte[] bytes, int spos, int epos)  {
		int length = epos - spos;
		byte[] outbytes = new byte[length];
		System.arraycopy(bytes, spos, outbytes, 0, length);
		return outbytes;
	}
	
	public static byte[] lpad(byte[] inbytes, int length, char pad) {
		int inlen  = inbytes.length;
		byte[] outbytes = new byte[length];
		if(inlen > length) {
			System.arraycopy(inbytes, inlen-length, outbytes, 0, length);
		} else {
			System.arraycopy(inbytes, 0, outbytes, length-inlen, inlen);
			for(int i=0; i<length-inlen; i++) {
				outbytes[i] = (byte)pad;
			}
		}
		return outbytes;
	}
	
	//charSet없는 String lpad
	public static byte[] lpad(String strval, int length, char pad) throws Exception {
		if (strval == null) {
			strval = "";
		}
		return lpad(strval.getBytes(), length, pad);
	}

	public static byte[] lpad(String strval, int length, char pad, String charSet) throws Exception {
		if (strval == null) {
			strval = "";
		}
		return lpad(strval.getBytes(charSet), length, pad);
	}

	//charSet없는 BigDecimal lpad
	public static byte[] lpad(BigDecimal bd, int length, char pad)  {
		byte[] bytes = null;
		if (bd == null) {
			bytes = "".getBytes();
		} else {
			bytes = String.valueOf(bd).getBytes();
		}
		return lpad(bytes, length, pad);
	}

	public static byte[] lpad(BigDecimal bd, int length, char pad, String charSet) throws Exception {
		byte[] bytes = null;
		if (bd == null) {
			bytes = "".getBytes();
		} else {
			bytes = String.valueOf(bd).getBytes();
		}
		return lpad(bytes, length, pad);
	}

	//charSet없는 int lpad
	public static byte[] lpad(int intval, int length, char pad) throws Exception {
		byte[] bytes = String.valueOf(intval).getBytes();
		return lpad(bytes, length, pad);
	}

	public static byte[] lpad(int intval, int length, char pad, String charSet)  {
		byte[] bytes = String.valueOf(intval).getBytes();
		return lpad(bytes, length, pad);
	}

	public static String getUrlData(String urlstr, int timeout) throws Exception {
		StringBuffer xml = new StringBuffer();
		URL url = new URL(urlstr);
		HttpURLConnection uc = (HttpURLConnection) url.openConnection();
		uc.setReadTimeout(timeout);
		BufferedReader bi = new BufferedReader( new InputStreamReader( uc.getInputStream()  ,"EUC-KR"));
		String s = "";
		while ( ( s = bi.readLine() ) !=null) {
			xml.append(s+"\n");
		}
		return xml.toString();
	}

	public static String getLocalData(String filePath) throws Exception {
		StringBuffer xml = new StringBuffer();
		BufferedReader bi = new BufferedReader( new InputStreamReader( new FileInputStream(filePath)  ,"UTF-8"));
		String s = "";
		while ( ( s = bi.readLine() ) !=null) {
			xml.append(s+"\n");
		}
		return xml.toString();
	}
}
