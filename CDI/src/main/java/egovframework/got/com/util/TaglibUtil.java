package egovframework.got.com.util;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TaglibUtil {
	
	protected static final Log log = LogFactory.getLog(TaglibUtil.class);
	
	/**
	 * 
	 * @param tblNam
	 * @param useNam
	 * @return
	 */
	public static LinkedHashMap getNameToMap(String tblNam, String useNam){
		
	    return CodeCacheUtil.getNameToMap(tblNam, useNam);
	}
	
	/**
	 * 
	 * @param tblNam
	 * @param useNam
	 * @param allCde
	 * @param dfValue
	 * @return
	 */
	public static String getCodeToValue(String tblNam, String useNam, String allCde,  String dfValue){
		LinkedHashMap codeMap = TaglibUtil.getNameToMap(tblNam, useNam);
		
		return StringUtil.nvl(codeMap.get(allCde), dfValue);
	}
	
	/**
	 * 
	 * @param tblNam
	 * @param useNam
	 * @param allCde
	 * @param dfValue
	 * @return
	 */
	public static String getCodeToSelect(String tblNam, String useNam, String allCde,  String dfValue){
		StringBuffer sb = new StringBuffer();
		LinkedHashMap codeMap = TaglibUtil.getNameToMap(tblNam, useNam);
    	Set s = codeMap.keySet();
    	Iterator t = s.iterator();
    	String keyTmp = "";
    	while(t.hasNext()){
    		keyTmp = String.valueOf(t.next());
    		sb.append("<option value='").append(keyTmp).append("'");
    		if(keyTmp.equals(allCde)){
    			sb.append(" selected");	
    		}
    		sb.append(">");
    		sb.append(codeMap.get(keyTmp)).append("</option> \n");	
    	}
		
		return sb.toString();
	}
	
	/**
	 * 
	 * @param tblNam
	 * @param useNam
	 * @param allCde
	 * @param dfValue
	 * @return
	 */
	public static String getCodeToSelect2(String tblNam, String useNam, String allCde,  String dfValue){
		StringBuffer sb = new StringBuffer();
		LinkedHashMap codeMap = TaglibUtil.getNameToMap(tblNam, useNam);
    	Set s = codeMap.keySet();
    	Iterator t = s.iterator();
    	String keyTmp = "";
    	while(t.hasNext()){
    		keyTmp = String.valueOf(t.next());
    		sb.append("<option value='").append(keyTmp).append("'");
    		if(keyTmp.equals(allCde)){
    			sb.append(" selected");	
    		}
    		sb.append(">");
    		
    		sb.append(codeMap.get(keyTmp)).append("</option> \n");
    		
    	}
		
		return sb.toString();
	}	
}
