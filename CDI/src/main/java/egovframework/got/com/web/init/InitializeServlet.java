
package egovframework.got.com.web.init;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import egovframework.got.com.map.EntityMap;
import egovframework.got.com.web.init.svc.InitializeSVC;

@Controller
public class InitializeServlet extends HttpServlet  {
	protected static final Log log = LogFactory.getLog(InitializeServlet.class);
    
	private static final long serialVersionUID = -6595503537161135361L;

	public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        initialize();
    }

    private void initialize() throws ServletException {
        try {
        	
        	WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
        	
        	Ehcache cache = ((Ehcache)wac.getBean("ehcache")).getCacheManager().getCache("codeList");        	
        
        	EntityMap hm = new EntityMap();
        	hm.put("1", "한글");
        	hm.put("3", "3");
        	hm.put("2", "2");
        	hm.put("4", "4");
        	hm.put("7", "7");
        	hm.put("6", "6");
        	hm.put("9", "9");
        	hm.put("8", "8");
        	cache.put(new Element("test",hm));
        	hm.put("9", "9");
        	
        	
        	LinkedHashMap tmpMap = (LinkedHashMap)cache.get("test").getObjectValue();
        	tmpMap.put("10", "10");
        	tmpMap.put("11", "111");
        	tmpMap.put("12", "1212");
        	//cache.put(new Element("test",hm));
//        	Set s = hm.keySet();
//        	
//        	Iterator t = s.iterator();
//        	//Iterator t = hm.values().iterator();
//        	while(t.hasNext()){
//        		log.debug(t.next());
//        	}
//        	
//        	InitializeSVC initializeSVC = ((InitializeSVC)wac.getBean("initializeSVC")); 
//        	EntityMap search_map = new EntityMap();
//        	search_map.put("TBL_NAM","UFL_KPIP_LS");
//        	search_map.put("ATT_NAM", "MOP_CDE");
//        	List ItemMap = initializeSVC.selectCodeItemList(search_map);
//        	Iterator table_i = ItemMap.iterator();
//        	LinkedHashMap tmp = new LinkedHashMap();
//        	Map t = null;
//        	while(table_i.hasNext()){
//        		t = ((Map)table_i.next());
//        		tmp.put(t.get("ALL_CDE"),t.get("CDE_NAM"));
//        	}
//        	log.debug(tmp);
//        	LinkedHashMap tableMap = new LinkedHashMap(initializeSVC.selectCodeTableMap(hm));
//        	
//        	Set table_s = tableMap.keySet();
//        	Iterator table_i = table_s.iterator();
//        	EntityMap search_map = new EntityMap();
//        	while(table_i.hasNext()){
//        		search_map.put("TBL_NAM", table_i.next());        		
//        		LinkedHashMap groupMap = new LinkedHashMap(initializeSVC.selectCodeGroupMap(search_map));
//        		
//            	Set group_s = groupMap.keySet();
//            	Iterator group_i = group_s.iterator();
//            	
//            	while(group_i.hasNext()){
//            		search_map.put("ATT_NAM", group_i.next());
//            		
//            		log.debug(ItemMap);
//            	}
//        	}        	
        }
        catch (Exception e) {
        	log.fatal(e);
            
            throw new ServletException( e );
        }
    }
}
