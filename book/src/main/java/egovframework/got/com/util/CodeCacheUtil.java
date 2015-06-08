package egovframework.got.com.util;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;

import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import egovframework.got.com.map.EntityMap;
import egovframework.got.com.svc.CodeSVC;

public class CodeCacheUtil {
	
	protected static final Log log = LogFactory.getLog(CodeCacheUtil.class);
	
	/**
	 * 
	 * @param tblNam
	 * @param useNam
	 * @return
	 */
	public static LinkedHashMap getNameToMap(String tblNam, String useNam){
		
		LinkedHashMap tblMap = null;
		LinkedHashMap groupMap = null;
	    try {
	        
	        Ehcache cache = ((Ehcache)SpringBeanUtil.getInstance().getBean("ehcache")).getCacheManager().getCache("codeList");
			
	        Element obj = cache.get(tblNam);
	        
	        if(obj == null){
	        	tblMap = new LinkedHashMap();
	        	cache.put(new Element(tblNam,tblMap));
	        }else{
	        	tblMap = (LinkedHashMap)obj.getObjectValue(); 
	        }

        	groupMap = (LinkedHashMap)tblMap.get(useNam);
        	
        	if(groupMap == null){
        		groupMap = new LinkedHashMap();
        		if("CMT_ADAR_MA".equals(tblNam)){
        			getNameToMapAdarMa(tblMap,groupMap,tblNam,useNam);
        		}else if("CMT_FTRC_MA".equals(tblNam)){
        			getNameToMapFtrcMa(tblMap,groupMap,tblNam,useNam);
        		}else if("CMT_LGAR_MA".equals(tblNam)){
        			getNameToMapLgarMa(tblMap,groupMap,tblNam,useNam);
        		}else if("CMT_MNGR_MA".equals(tblNam)){
        			getNameToMapMngrMa(tblMap,groupMap,tblNam,useNam);
        		}else{
        			getNameToMapCodeMa(tblMap,groupMap,tblNam,useNam);
        		}
        	}
	    }
	    catch (Exception ex) {
	    	ex.printStackTrace();
	    	groupMap = new LinkedHashMap();
	    }
	    return groupMap;		
	}
	/**
	 * 
	 * @param tblMap
	 * @param groupMap
	 * @param tblNam
	 * @param useNam
	 * @throws Exception
	 */
	
	public static void getNameToMapCodeMa(LinkedHashMap tblMap, LinkedHashMap groupMap, String tblNam, String useNam)throws Exception{
		CodeSVC codeSVC = ((CodeSVC)SpringBeanUtil.getInstance().getBean("codeSVC"));
		EntityMap search_map = new EntityMap();
		search_map.put("TBL_NAM", tblNam);
		search_map.put("USE_NAM", useNam);
		List list = codeSVC.selectCodeItemList(search_map);
		if(!list.isEmpty()){
			Iterator table_i = list.iterator();
			Map t = null;
			while(table_i.hasNext()){
				t = ((Map)table_i.next());
				groupMap.put(t.get("ALL_CDE"),t.get("CDE_NAM"));
			}
			tblMap.put(useNam, groupMap);
		}		
	}
	/**
	 * 
	 * @param tblMap
	 * @param groupMap
	 * @param tblNam
	 * @param useNam
	 * @throws Exception
	 */
	public static void getNameToMapFtrcMa(LinkedHashMap tblMap, LinkedHashMap groupMap, String tblNam, String useNam)throws Exception{
		CodeSVC codeSVC = ((CodeSVC)SpringBeanUtil.getInstance().getBean("codeSVC"));
		EntityMap search_map = new EntityMap();
		List list = codeSVC.selectFtrCdeItemList(search_map);
		if(!list.isEmpty()){
			Iterator table_i = list.iterator();
			Map t = null;
			while(table_i.hasNext()){
				t = ((Map)table_i.next());
				groupMap.put(t.get("FTR_CDE"),t.get("FTR_NAM"));
			}
			tblMap.put(useNam, groupMap);
		}		
	}	
	
	/**
	 * 
	 * @param tblMap
	 * @param groupMap
	 * @param tblNam
	 * @param useNam
	 * @throws Exception
	 */
	public static void getNameToMapAdarMa(LinkedHashMap tblMap, LinkedHashMap groupMap, String tblNam, String useNam)throws Exception{
		CodeSVC codeSVC = ((CodeSVC)SpringBeanUtil.getInstance().getBean("codeSVC"));
		EntityMap search_map = new EntityMap();
		List list = codeSVC.selectAdarMaItemList(search_map);
		if(!list.isEmpty()){
			Iterator table_i = list.iterator();
			Map t = null;
			while(table_i.hasNext()){
				t = ((Map)table_i.next());
				groupMap.put(t.get("HJD_CDE"),t.get(useNam));
			}
			tblMap.put(useNam, groupMap);
		}		
	}

	/**
	 * 
	 * @param tblMap
	 * @param groupMap
	 * @param tblNam
	 * @param useNam
	 * @throws Exception
	 */
	public static void getNameToMapLgarMa(LinkedHashMap tblMap, LinkedHashMap groupMap, String tblNam, String useNam)throws Exception{
		CodeSVC codeSVC = ((CodeSVC)SpringBeanUtil.getInstance().getBean("codeSVC"));
		EntityMap search_map = new EntityMap();
		List list = codeSVC.selectLgarMaItemList(search_map);
		if(!list.isEmpty()){
			Iterator table_i = list.iterator();
			Map t = null;
			while(table_i.hasNext()){
				t = ((Map)table_i.next());
				groupMap.put(t.get("BJD_CDE"),t.get(useNam));
			}
			tblMap.put(useNam, groupMap);
		}		
	}
	
	/**
	 * 
	 * @param tblMap
	 * @param groupMap
	 * @param tblNam
	 * @param useNam
	 * @throws Exception
	 */
	public static void getNameToMapMngrMa(LinkedHashMap tblMap, LinkedHashMap groupMap, String tblNam, String useNam)throws Exception{
		CodeSVC codeSVC = ((CodeSVC)SpringBeanUtil.getInstance().getBean("codeSVC"));
		EntityMap search_map = new EntityMap();
		List list = codeSVC.selectMngrMaItemList(search_map);
		if(!list.isEmpty()){
			Iterator table_i = list.iterator();
			Map t = null;
			while(table_i.hasNext()){
				t = ((Map)table_i.next());
				groupMap.put(t.get("MNG_CDE"),t.get(useNam));
			}
			tblMap.put(useNam, groupMap);
		}		
	}	
}
