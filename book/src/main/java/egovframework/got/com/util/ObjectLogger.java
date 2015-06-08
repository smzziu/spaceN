package egovframework.got.com.util;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public abstract class ObjectLogger {

	public static String toStringForList(String key, List arr) {
		StringBuffer values = new StringBuffer();
		if (arr != null) {
			for (int i = 0; i < arr.size(); i++) {
				if (arr.get(i) instanceof Map) {
					values.append("\n{" + key + "} ");
					values.append("[" + i + "th row] ");
					values.append(toStringForMap((Map) arr.get(i)));
				}
				if (i >= 30) {
					values.append("\n. . . no display more rows .  total : ")
							.append(arr.size());
					break;
				}
			}
		}
		return values.toString();
	}

	public static String toStringForMap(Map input) {
		StringBuffer values = new StringBuffer();
		Iterator keySet = input.keySet().iterator();
		while (keySet.hasNext()) {
			String key = (String) keySet.next();

			if (input.get(key) instanceof String) {
				// values.append( MessageFormat.format(mask, new Object[] { key,
				// (String)input.get(key) }));
				values.append(key).append(" : ")
						.append((String) input.get(key)).append(", ");
			} else if (input.get(key) instanceof List) {
				// !!!
				values.append(toStringForList(key, (List) input.get(key)));
				values.append("\n");
			} else if (input.get(key) instanceof Map) {
				// !!!
				values.append("\n{" + key + "} ");
				values.append(toStringForMap((Map) input.get(key)));
			} else if (input.get(key) == null) {
				// values.append(MessageFormat.format(mask, new Object[] { key,
				// "null"}));
				values.append(key).append(" : ").append("null").append(", ");
			} else {
				// values.append(MessageFormat.format(mask, new Object[] { key,
				// input.get(key).toString() }));
				values.append(key).append(" : ").append(
						input.get(key).toString()).append(", ");
			}
		}

		return values.toString();
	}

	public static String toStringForVO(Object vo) {
		StringBuffer values = new StringBuffer();

		if (vo == null)
			return values.toString();

		Class cls = vo.getClass();
		Field[] fields = cls.getDeclaredFields();
		for (int i = 0; i < fields.length; i++) {
			String fieldName = fields[i].getName().substring(0, 1)
					.toUpperCase()
					+ fields[i].getName().substring(1,
							fields[i].getName().length());
			String get = "get";

			try {
				Method method = cls.getMethod(get + fieldName, new Class[] {});
				Object obj = method.invoke(vo, new Object[] {});
				// values.append(MessageFormat.format(mask, new String[] {
				// fields[i].getName(), String.valueOf(obj) }));
				values.append(fields[i].getName()).append(" : ").append(
						String.valueOf(obj)).append(", ");
			} catch (Exception e) {
			}
		}

		return values.toString();
	}

	/*
	 * public static String toStringForHashMap(HashMap input) { StringBuffer
	 * values = new StringBuffer(); Iterator keySet = input.keySet().iterator();
	 * while (keySet.hasNext()){ String key = (String)keySet.next(); //leeyh add
	 * if (input.get(key) instanceof String) {
	 * values.append(MessageFormat.format(mask, new String[] { key,
	 * (String)input.get(key) })); }else if(input.get(key) instanceof ArrayList)
	 * { values.append(toStringForArrayList((ArrayList)input.get(key))); }else
	 * if(input.get(key) instanceof HashMap) {
	 * values.append(toStringForHashMap((HashMap)input.get(key))); }else{
	 * values.append(toStringForVO(input.get(key))); } }
	 * 
	 * return values.toString(); }
	 * 
	 * 
	 * 
	 * public static String toStringForArrayList(ArrayList arr) { StringBuffer
	 * values = new StringBuffer(); if(arr!=null){ for(int
	 * i=0;i<arr.size();i++){ values.append("["+i+"th row]\n"); if (arr.get(i)
	 * instanceof HashMap) { values.append(toStringForHashMap
	 * ((HashMap)arr.get(i))); }else{ values.append(toStringForVO (arr.get(i)));
	 * } } } return values.toString(); }
	 * 
	 * 
	 * public static String toStringForObject(Object obj){
	 * 
	 * StringBuffer values = new StringBuffer();
	 * 
	 * if (obj instanceof HashMap) { values.append(toStringForHashMap
	 * ((HashMap)obj)); }else if(obj instanceof ArrayList){
	 * values.append(toStringForArrayList ((ArrayList)obj)); }else if(obj
	 * instanceof String){ values.append(MessageFormat.format(mask, new String[]
	 * { "message", (String)obj })); }else{ values.append(toStringForVO (obj));
	 * }
	 * 
	 * return values.toString(); }
	 */

}
