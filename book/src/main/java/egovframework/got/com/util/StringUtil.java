package egovframework.got.com.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

/**
 *  Class Name  : StringUtil.java<br/>
 *  Description : String 관련 공통 클래스<br/><br/>
 *
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

public abstract class StringUtil {
    /**
     * 확장할 수 있는 패딩상수 최대크기
     */
    private static final int PAD_LIMIT = 8192;

    /**
     * <p>	문자열 좌측의 공백을 제거하는 메소드
     * </p><pre>
     * String str = null;
     * String leftTrim = StringUtil.leftTrim(str);</pre>
     * @return	trimed string with white space removed from the front
     */
    public static String leftTrim(String str) {
        int len = str.length();
        int idx = 0;

        while ((idx < len) && (str.charAt(idx) <= ' ')) {
            idx++;
        }

        return str.substring(idx, len);
    }

    /**
     * <p>	문자열 우측의 공백을 제거하는 메소드
     * </p><pre>
     * String str = null;
     * String rightTrim = StringUtil.rightTrim(str);</pre>
     * @return	trimed string with white space removed from the end.
     */
    public static String rightTrim(String str) {
        int len = str.length();

        while ((0 < len) && (str.charAt(len - 1) <= ' ')) {
            len--;
        }

        return str.substring(0, len);
    }


    /**
     * 지정된 크기만큼 문자열 앞부분을 분리하는 메소드<br>
     * 입력 str이 null이면 빈 문자열("")을 반환한다.
     *
     * <p>	지정된 크기만큼 문자열 앞부분을 분리하는 메소드
     * </p><pre>
     * String str = ""abcdefghijk;
     * int size = 3;
     * String splitHead = StringUtil.splitHead(str,size); //splitHead = "abc"</pre>
     * @return	splitted string from the source string.
     */
    public static String splitHead(String str, int size) {
        if (str == null) {
            return "";
        }

        if (str.length() > size) {
            //str = str.substring(0, size) + "...";
        	str = str.substring(0, size);
        }

        return str;
    }

    /**
     * 지정된 크기만큼 문자열 뒷부분을 분리하는 메소드<br>
     * 입력 str이 null이면 빈 문자열("")을 반환한다.
     *
     * <p>	지정된 크기만큼 문자열 뒷부분을 분리하는 메소드
     * </p><pre>
     * String str = "abcdefgh";
     * int size = 3 ;
     * String splitTail = StringUtil.splitTail(str,size); //splitHead = "fgh"</pre>
     * @return	splitted string from the source string.
     */
    public static String splitTail(String str, int size) {
        if (str == null) {
            return "";
        }

        if (str.length() > size) {
            str = "..."+str.substring(str.length() - size);
            str = str.substring(str.length() - size);
        }

        return str;
    }

    /**
     * 문자열에서 char문자를 제거하는 메소드<br>
     * 입력 str이 null이면 빈 문자열("")을 반환한다.
     *
     * <p>	문자열에서 char문자를 제거하는 메소드
     * </p><pre>
     * String str = "abcdefgh";
     * char ch = 'c';
     * String removeChar = StringUtil.removeChar(str,ch); // removeChar = "abdefgh"</pre>
     * @return	String
     */
    public static String removeChar(String str, char ch) {
        if (str == null || str.trim().length() == 0) {
            return "";
        }

        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < str.length(); i++) {
            if (str.charAt(i) == ch) {
                continue;
            }
            sb.append(str.charAt(i));
        }

        return sb.toString();
    }

    /**
     * 문자열에서 '/', '-', ':', ',', '.', '%'의 char문자와 공백를 제거하는 메소드
     *
     * <p>	char문자와 공백를 제거하는 메소드
     * </p><pre>
     * String str = null;
     * String removeCharAll = StringUtil.removeCharAll(str);</pre>
     * @return	String
     */
    public static String removeCharAll(String str) {
        String value = null;
        value = removeChar(str, '/'); // '/' 제거
        value = removeChar(value, '-'); // '-' 제거
        value = removeChar(value, ':'); // ':' 제거
        value = removeChar(value, ','); // ',' 제거
        value = removeChar(value, '.'); // '.' 제거
        value = removeChar(value, '%'); // '%' 제거
        value = value.trim(); // 문자열 앞뒤 공백제거

        return value;
    }

    /**
     * <p>	해당 소스 문자열 내에서 대상 목록의 문자를 삭제한다.
     * </p><pre>
     * String source = "abcdefghabcedfeeee";
     * char[] targetChars = = {'c','d','e'};
     * String removeCharAll = StringUtil.removeCharAll(source, targetChars); // abfghabf</pre>
     * @param source 원본 문자열
     * @param targetChars 삭제 대상 문자 목록
     * @return	String
     */
    public static String removeCharAll(String source, char[] targetChars) {
        String value = source;
        for (int i = 0; i < targetChars.length; i++) {
            value = removeChar(value, targetChars[i]);
        }

        return value.trim();
    }

    /**
     * <p>	원하는 길이만큼 스페이스를 붙인다.
     * </p><pre>
     * String str = null;
     * int i ;
     * String addSpace = StringUtil.addSpace(str,i);</pre>
     * @return	String
     */
    public static String addSpace(String str, int i) {
        StringBuilder sb = null;

        if (str != null) {
            sb = new StringBuilder(str.length() + i);
            sb.append(str);
        }
        else {
            if (i != 0) {
                sb = new StringBuilder(i);
            }
            else {
                return "";
            }
        }

        for (int j = 0; j < i; j++) {
            sb.append(' ');
        }
        return sb.toString();
    }

    /**
     * <p>	입력된 문자열의 값이 null이면 빈 문자열을 반환함
     * </p><pre>
     * String str = null;
     * String nullToSpace = StringUtil.nullToSpace(str);</pre>
     * @return	String
     */
    public static String nullToSpace(String str) {
        if (str == null || str.length() <= 0) {
            return "";
        }
        else {
            return str;
        }
    }

    /**
     * <p>	문장에서 특정 문자를 찾아 다른 문자로 대체
     * </p><pre>
     * String str = null;
     * String searchChars = null;
     * String replaceChars = null
     * String replaceChars = StringUtil.replaceChars(str,searchChars,replaceChars);</pre>
     * @param str 원본 문자열
     * @param searchChars 교체될 문자열
     * @param replaceChars 교체할 문자열
     * @return	String
     */
    public static String replaceChars(String str, String searchChars, String replaceChars) {
        if (isEmpty(str) || isEmpty(searchChars)) {
            return str;
        }
        if (replaceChars == null) {
            replaceChars = "";
        }
        boolean modified = false;
        StringBuffer buf = new StringBuffer(str.length());
        for (int i = 0; i < str.length(); i++) {
            char ch = str.charAt(i);
            int index = searchChars.indexOf(ch);
            if (index >= 0) {
                modified = true;
                if (index < replaceChars.length()) {
                    buf.append(replaceChars.charAt(index));
                }
            }
            else {
                buf.append(ch);
            }
        }
        if (modified) {
            return buf.toString();
        }
        else {
            return str;
        }
    }

    /**
     * <p>	문자열 검사 : null,''검사
     * </p><pre>
     * String str = null;
     * boolean isEmpty = StringUtil.isEmpty(str);</pre>
     * @return	boolean
     */
//    public static boolean isEmpty(String str) {
//        if (str != null) {
//            String trimCheck = str.trim();
//            if (trimCheck.length() == 0) {
//                return true;
//            }
//        }
//        else {
//            return true;
//        }
//
//        return false;
//    }

    /**
     * <p>	문자열 검사 : null,''검사
     * </p><pre>
     * String str = null;
     * boolean isEmpty = StringUtil.isEmpty(str);</pre>
     * @return	boolean
     */
    public static boolean isEmpty(String str) {
        return str == null || str.length() == 0;
    }

    /**
     * <p>	공백없애고 문자열이 같은지 비교함.
     * </p><pre>
     * String baseStr = null;
     * String targetStr = null;
     * boolean trimEquals = StringUtil.trimEquals(str);</pre>
     * @return	boolean
     */
    public static boolean trimEquals(String baseStr, String targetStr) {
        String trimBaseStr = baseStr.trim();
        String trimTargetStr = targetStr.trim();

        return trimBaseStr.equals(trimTargetStr);
    }

    /**
     * 지정된 문자가 제공된 길이만큼 반복된 문자열을 반환한다.
     * <p>
     *
     * <pre>
     *          StringUtil.padding(0, 'e')  = &quot;&quot;
     *          StringUtil.padding(3, 'e')  = &quot;eee&quot;
     *          StringUtil.padding(-2, 'e') = IndexOutOfBoundsException
     * </pre>
     *
     * <p>	지정된 문자가 제공된 길이만큼 반복된 문자열을 반환한다.
     * </p><pre>
     * int repeat ;
     * char padChar = null;
     * String padding = StringUtil.padding(repeat,padChar);</pre>
     * @param repeat 지정된 문자가 반복될 수
     * @param padChar 반복될 문자
     * @return 지정된 문자가 제공된 길이만큼 반복된 문자열
     * @throws IndexOutOfBoundsException if <code>repeat &lt; 0</code>
     */
    private static String padding(int repeat, char padChar) {
        // 패딩에 사용될 문자열의 배열
        // 효율적인 공간 패딩에 사용되며 각 문자열의 길이는 필요한 만큼 확장된다.
        String[] PADDING = new String[Character.MAX_VALUE];
        // be careful of synchronization in this method
        // we are assuming that get and set from an array index is atomic
        String pad = PADDING[padChar];
        if (pad == null) {
            pad = String.valueOf(padChar);
        }
        while (pad.length() < repeat) {
            pad = pad.concat(pad);
        }
        PADDING[padChar] = pad;
        return pad.substring(0, repeat);
    }

    /**
     * 지정된 문자로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     *
     * <pre>
     *          StringUtil.leftPad(null, *, *)     = null
     *          StringUtil.leftPad(&quot;&quot;, 3, 'z')     = &quot;zzz&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 3, 'z')  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 5, 'z')  = &quot;zzbat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 1, 'z')  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, -1, 'z') = &quot;bat&quot;
     * </pre>
     *
     * <p>	지정된 문자로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int size ;
     * char padChar = null;
     * String leftPad = StringUtil.leftPad(str,size,padChar);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param size 패딩할 사이즈
     * @param padChar 패딩에 사용될 문자
     * @return 왼쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String leftPad(String str, int size, char padChar) {
        if (str == null) {
            return null;
        }
        int pads = size - str.length();
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (pads > PAD_LIMIT) {
            return leftPad(str, String.valueOf(padChar), size);
        }
        return padding(pads, padChar).concat(str);
    }

    /**
     * 지정된 문자열로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     *
     * <pre>
     *          StringUtil.leftPad(null, *, *)      = null
     *          StringUtil.leftPad(&quot;&quot;, 3, &quot;z&quot;)      = &quot;zzz&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 3, &quot;yz&quot;)  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 5, &quot;yz&quot;)  = &quot;yzbat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 8, &quot;yz&quot;)  = &quot;yzyzybat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 1, &quot;yz&quot;)  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, -1, &quot;yz&quot;) = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 5, null)  = &quot;  bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 5, &quot;&quot;)    = &quot;  bat&quot;
     * </pre>
     *
     * <p>	지정된 문자열로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int size ;
     * String addStr = null;
     * String leftPad = StringUtil.leftPad(str,addStr,size);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param addStr 패딩에 사용될 문자열
     * @param size 패딩할 사이즈
     * @return 왼쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String leftPad(String str, String addStr, int size) {
        if (str == null) {
            return null;
        }
        if (addStr == null || addStr.length() == 0) {
            addStr = " ";
        }
        int padLen = addStr.length();
        int strLen = str.length();
        int pads = size - strLen;
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (padLen == 1 && pads <= PAD_LIMIT) {
            return leftPad(str, size, addStr.charAt(0));
        }

        if (pads == padLen) {
            return addStr.concat(str);
        }
        else if (pads < padLen) {
            return addStr.substring(0, pads).concat(str);
        }
        else {
            char[] padding = new char[pads];
            char[] padChars = addStr.toCharArray();
            for (int i = 0; i < pads; i++) {
                padding[i] = padChars[i % padLen];
            }
            return new String(padding).concat(str);
        }

        // if (str == null) {
        // return "";
        // }
        //
        // StringBuffer sb = new StringBuffer();
        // for (int i = str.length(); i < count; i++) {
        // sb.append(addStr);
        // }
        // sb.append(str);
        //
        // return sb.toString();
    }

    /**
     * 공백문자(' ')로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     * <p>
     *
     * <pre>
     *          StringUtil.leftPad(null, *)   = null
     *          StringUtil.leftPad(&quot;&quot;, 3)     = &quot;   &quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 3)  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 5)  = &quot;  bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, 1)  = &quot;bat&quot;
     *          StringUtil.leftPad(&quot;bat&quot;, -1) = &quot;bat&quot;
     * </pre>
     *
     * <p>	공백문자(' ')로 입력된 사이즈만큼 왼쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int size ;
     * String leftPad = StringUtil.leftPad(str,size);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param size 패딩할 사이즈
     * @return 왼쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String leftPad(String str, int size) {
        return leftPad(str, size, ' ');
    }

    /**
     * 지정된 문자로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * <p>
     *
     * <pre>
     *          StringUtil.rightPad(null, *, *)     = null
     *          StringUtil.rightPad(&quot;&quot;, 3, 'z')     = &quot;zzz&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 3, 'z')  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 5, 'z')  = &quot;batzz&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 1, 'z')  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, -1, 'z') = &quot;bat&quot;
     * </pre>
     *
     * <p>	지정된 문자로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int size ;
     * char padChar = null;
     * String rightPad = StringUtil.rightPad(str,size,padChar);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param size 패딩할 사이즈
     * @param padChar 패딩에 사용될 문자
     * @return 오른쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String rightPad(String str, int size, char padChar) {
        if (str == null) {
            return null;
        }
        int pads = size - str.length();
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (pads > PAD_LIMIT) {
            return rightPad(str, String.valueOf(padChar), size);
        }
        return str.concat(padding(pads, padChar));
    }

    /**
     * 지정된 문자열로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * <p>
     *
     * <pre>
     *          StringUtil.rightPad(null, *, *)      = null
     *          StringUtil.rightPad(&quot;&quot;, 3, &quot;z&quot;)      = &quot;zzz&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 3, &quot;yz&quot;)  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 5, &quot;yz&quot;)  = &quot;batyz&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 8, &quot;yz&quot;)  = &quot;batyzyzy&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 1, &quot;yz&quot;)  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, -1, &quot;yz&quot;) = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 5, null)  = &quot;bat  &quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 5, &quot;&quot;)    = &quot;bat  &quot;
     * </pre>
     *
     * <p>	지정된 문자열로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int count ;
     * String addStr = null;
     * String rightPad = StringUtil.rightPad(str,addStr,count);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param addStr 패딩에 사용될 문자열
     * @param count 사이즈
     * @return 오른쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String rightPad(String str, String addStr, int count) {
        if (str == null) {
            return null;
        }
        if (addStr == null || addStr.length() == 0) {
            addStr = " ";
        }
        int padLen = addStr.length();
        int strLen = str.length();
        int pads = count - strLen;
        if (pads <= 0) {
            return str; // returns original String when possible
        }
        if (padLen == 1 && pads <= PAD_LIMIT) {
            return rightPad(str, count, addStr.charAt(0));
        }

        if (pads == padLen) {
            return str.concat(addStr);
        }
        else if (pads < padLen) {
            return str.concat(addStr.substring(0, pads));
        }
        else {
            char[] padding = new char[pads];
            char[] padChars = addStr.toCharArray();
            for (int i = 0; i < pads; i++) {
                padding[i] = padChars[i % padLen];
            }
            return str.concat(new String(padding));
        }
        // if (str == null) {
        // return "";
        // }
        //
        // StringBuffer sb = new StringBuffer();
        // sb.append(str);
        // for (int i = str.length(); i < count; i++) {
        // sb.append(addStr);
        // }
        //
        // return sb.toString();
    }

    /**
     * 공백문자(' ')로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * <p>
     *
     * <pre>
     *          StringUtil.rightPad(null, *)   = null
     *          StringUtil.rightPad(&quot;&quot;, 3)     = &quot;   &quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 3)  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 5)  = &quot;bat  &quot;
     *          StringUtil.rightPad(&quot;bat&quot;, 1)  = &quot;bat&quot;
     *          StringUtil.rightPad(&quot;bat&quot;, -1) = &quot;bat&quot;
     * </pre>
     *
     * <p>	공백문자(' ')로 입력된 사이즈만큼 오른쪽에 패딩된 문자열을 반환한다.
     * </p><pre>
     * String str = null;
     * int size ;
     * String rightPad = StringUtil.rightPad(str,size);</pre>
     * @param str 패딩될 문자열(널이 입력될 수 있다.)
     * @param size 패딩할 사이즈
     * @return 오른쪽에 패딩된 문자열 또는 패딩할 필요가 없다면 원래의 문자열 또는 입력된 문자열이 널이면 널을 반환.
     */
    public static String rightPad(String str, int size) {
        return rightPad(str, size, ' ');
    }

    /**
     * SQL Injection을 막기 위해 특수문자를 대체한다. 특수문자들 - '";)%<>(&+ 바꿀 수 없는 문자들 - ";)%
     * 업무에 따라 대체 가능한 문자들 - <>'(&+
     *
     * <p>	SQL Injection을 막기 위해 특수문자를 대체한다
     * </p><pre>
     * String str = null;
     * String includeCharters = null ;
     * String replaceSQLString = StringUtil.replaceSQLString(str,includeCharters);</pre>
     * @param str 원본 문자열
     * @param includeCharters 대체할 특수문자중에서 업무적으로 허용할 문자열
     * @return 허용할 문자열을 제외한 나머지 특수문자를 대체하여 원본 문자열을 리턴
     */
    public static String replaceSQLString(String str, String includeCharters) {
        char[] mustExclude = { '"', ';', ')', '%' };
        char[] optionalExclude = { '\'', '<', '>', '(', '&', '+' };
        char[] include = {};

        if (includeCharters != null && includeCharters.length() > 0) {
            include = includeCharters.toCharArray();
        }

        int optionalSize = optionalExclude.length;
        int includeSize = include.length;

        int[] mustIdx = new int[optionalSize];
        int totalCheckCount = 0;

        for (int i = 0; i < optionalSize; i++) {
            boolean isContain = false;
            for (int j = 0; j < includeSize; j++) {
                if (optionalExclude[i] == include[j]) {
                    isContain = true;
                    break;
                }
            }
            if (!isContain) {
                mustIdx[totalCheckCount++] = i;
            }
        }

        // 특수문자 변환
        int mustSize = mustExclude.length;
        for (int k = 0; k < mustSize; k++) {
            str = str.replace(mustExclude[k], '_');
        }

        // 허용할 문자열이 빠진 변환할 문자로 특수문자 변환
        for (int k = 0; k < totalCheckCount; k++) {
            str = str.replace(optionalExclude[mustIdx[k]], '_');
        }

        return str;
    }

    /**
     * SQL Injection을 막기 위해 특수문자를 대체한다. 특수문자들 - '";)%<>(&+ 바꿀 수 없는 문자들 - ";)%
     * 업무에 따라 대체 가능한 문자들 - <>'(&+
     *
     * <p>	SQL Injection을 막기 위해 특수문자를 대체한다
     * </p><pre>
     * String str = null;
     * String replaceSQLString = StringUtil.replaceSQLString(str);</pre>
     * @param str 원본 문자열
     * @return 특수문자를 대체하여 원본 문자열을 리턴
     */
    public static String replaceSQLString(String str) {
        return replaceSQLString(str, "");
    }

    /**
     * <p>문자열에서 정의된 모든 공백문자를 제거한다.</p>
     *
     * <pre>
     * StringUtil.trim(null)         = null
     * StringUtil.trim("")           = ""
     * StringUtil.trim("abc")        = "abc"
     * StringUtil.trim("   ab  c  ") = "abc"
     * </pre>
     *
     * @param str  the String to delete whitespace from, may be null
     * @return the String without whitespaces, <code>null</code> if null String input
     */
    public static String trim(String str) {
        if (isEmpty(str)) {
            return str;
        }
        int sz = str.length();
        char[] chs = new char[sz];
        int count = 0;
        for (int i = 0; i < sz; i++) {
            if (!Character.isWhitespace(str.charAt(i))) {
                chs[count++] = str.charAt(i);
            }
        }
        if (count == sz) {
            return str;
        }
        return new String(chs, 0, count);
    }

    /**
     * <p>문자열에서 정의된 모든 공백문자를 제거한다.</p>
     *
     * <pre>
     * StringUtil.trim(null)         = null
     * StringUtil.trim("")           = ""
     * StringUtil.trim("abc")        = "abc"
     * StringUtil.trim("   ab  c  ") = "abc"
     * </pre>
     *
     * @param str  the String to delete whitespace from, may be null
     * @return the String without whitespaces, <code>null</code> if null String input
     */
    public static boolean isWhitespace(String str) {
        int sz = str.length();
        for (int i = 0; i < sz; i++) {
            if (!Character.isWhitespace(str.charAt(i))) {
                return false;
            }
        }

        return true;
    }


    /**

     * 전달된 문자가  null이거나 빈 문자열인지 체크
     *  <pre>
     * StringUtil.isEmptyStr(null)		= true
     * StringUtil.isEmptyStr("")			= true
     * StringUtil.isEmptyStr("abc")   = false
     * </pre>
     *
     * @name_ko Null 또는 빈 문자열 체크
     * @param inStr 입력된문자열
     * @return boolean 입력된 문자가 Null 또는 빈 문자열인 경우 true, 아니면 false
     */

    public static final boolean isEmptyStr(String inStr) {

        if (inStr == null || StringUtil.isWhitespace(inStr))

            return true;

        else

            return false;

    }



    /**

     * 전달된 ArrayList가  null이거나 size()가 0인지 체크
     *
     * @name_ko Null 또는 빈 배열 체크
     * @param inArr 입력된 ArrayList
     * @return boolean 입력된  ArrayList가  null이거나 size()가 0인 경우 true, 아니면 false

     */

    public static final boolean isEmptyArr(ArrayList inArr) {

        if (inArr == null || inArr.size() == 0)
            return true;
        else
            return false;
    }

    /**

     * 전달된 Map 을 String Array 로 변환 BVC 에서 사용됨
     *
     * @name_ko 전달된 Map 을 String Array 로 변환
     * @param map 입력된 map
     * @return String[]

     */

    public static final String[] convertMapToStringArray(Map map) {

        if (map == null ) return null;

        int length = map.size();
        int i = 0;
        String[] returnStringArray = new String[length];
        Iterator it = map.entrySet().iterator();
        while (it.hasNext()) {
        	Map.Entry entry = (Map.Entry) it.next();
        	returnStringArray[i++] = entry.getValue().toString();
		}
        return returnStringArray;
    }

    public static String nullToSpace(Object obj) {
    	String str = null;
    	try{
    		str = (String)obj;
    	}catch(Exception e){}
        if (str == null || str.length() <= 0) {
            return "";
        }
        else {
            return str;
        }
    }

    public static String nvl(Object obj,String var) {
    	String str = null;
    	try{
    		str = (String)obj;
    	}catch(Exception e){}
    	
        if(isEmptyStr(str)){
        	return var;
        }else{
        	return str;
        }
    }
    
    public static String urlencode(String original)
    {
        try
        {
            //return URLEncoder.encode(original, "utf-8");
            //fixed: to comply with RFC-3986
            return URLEncoder.encode(original, "utf-8").replace("+", "%20").replace("*", "%2A").replace("%7E", "~");
        }
        catch(UnsupportedEncodingException e)
        {
            //Log.e(LogHelper.where(), e.toString());
        }
        return null;
    }


}
