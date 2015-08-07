package egovframework.got.vmap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.got.vmap.model.pagingVO;
import egovframework.got.vmap.spacenSearch;
import egovframework.got.vmap.dTranCoord;
import egovframework.got.vmap.spaceNdata;

@Controller
public class vMapController {

	@Autowired
	protected EgovPropertyService propertiesService;
	
	
	/**
	 * 브이월드 메인
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/vMap.do")  
	protected String vMapClient(ModelMap model) throws Exception {		
		
		/**
		 * 브이월드 apikey 호출
		 */
		String vMapKey = propertiesService.getString("vMapKey");			
		model.addAttribute("vMapKey", vMapKey);
		
		String dMapkey = propertiesService.getString("dMapkey");
		model.addAttribute("dMapkey", dMapkey);
		System.out.println("dMapkey == "+dMapkey);
		return "/map/vMap"; 
	}
	
	/**
	 * 검색 API 화면 호출
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/vSearch.do")  
	protected String vSearch(Map<String, Object> commandMap, ModelMap model) throws Exception {		
		
		String vUrl = (String)commandMap.get("vKind");
		
		if(vUrl.equals("Poi")){
			return "/west/vPoiSearch";
		}else if(vUrl.equals("Jibun")){
			return "/west/vJibunSearch";
		}else{
			return "/west/vJusoSearch";
		}
		 
	}
	
	
	/**
	 * 검색API 검색결과
	 * @param request
	 * @param response
	 * @param commandMap
	 * @param model
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/vSearchL.do")  
	protected String vPoiSearchL(HttpServletRequest request, HttpServletResponse response, Map<String, Object> commandMap, ModelMap model,
			pagingVO vo) throws Exception {		
		/**
		 * 페이징 셋팅
		 */
		vo.setPageUnit(propertiesService.getInt("pageUnit"));
		vo.setPageSize(propertiesService.getInt("pageSize"));
    	
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(vo.getPageIndex());
		paginationInfo.setRecordCountPerPage(vo.getPageUnit());
		paginationInfo.setPageSize(vo.getPageSize());
		
		
		vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
		vo.setLastIndex(paginationInfo.getLastRecordIndex());
		vo.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		int start;
		if(commandMap.get("pageIndex") != null){
			start = Integer.parseInt((String)commandMap.get("pageIndex"));
		}else{
			start = paginationInfo.getFirstRecordIndex()+1;
		}
		
		/**
		 * 브이월드 api명/키/페이징시작
		 */
		String vMapKey = propertiesService.getString("vMapKey");
		String category = (String)commandMap.get("category");
		
		spacenSearch ss = new spacenSearch(category, vMapKey, start);
		
		/**
		 * 검색어생성
		 */
		String preSear = "";
		String searValue = (String)commandMap.get("vNm");	
		model.addAttribute("searValue", searValue);
		
		searValue = preSear+searValue;
		ArrayList list = ss.doSearch(searValue);
		
		Map m = new HashMap();
		
		m.put("LIST", list);
		model.addAttribute("resultMAP", m);
		
		/**
		 * 총갯수
		 */
		int totCnt = 0;
		for(int i=0; i<list.size(); i++){
			model.addAttribute("no"+i, i);
			m = (HashMap)list.get(i);
		    if(i==list.size()-1){
		    	totCnt = Integer.parseInt((String) m.get("totCnt"));
		    }
		 }
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("totCnt", totCnt);
		
		if(list.size() == 1){
			model.addAttribute("endCnt", "0");
		}else{
			model.addAttribute("endCnt", list.size()-2);
		}
		
        model.addAttribute("paginationInfo", paginationInfo);
		
        if(category.equals("Poi")){
        	return "/west/vPoiSearchL";
        }else if(category.equals("Jibun")){
        	return "/west/vJibunSearchL";
        }else{
        	return "/west/vJusoSearchL";
        }
	}
	
	
	
	@RequestMapping(value="/vData.do")  
	protected String vData(Map<String, Object> commandMap, ModelMap model) throws Exception {		
		
		int pageIndex = Integer.parseInt((String)commandMap.get("pageIndex"));
		int pageUnit = Integer.parseInt((String)commandMap.get("pageUnit"));
		
		String apiKey = (String)commandMap.get("apiKey");
		String output = (String)commandMap.get("output");
		String domain = (String)commandMap.get("domain");
		String srsName = (String)commandMap.get("srsName");
		String geometry = (String)commandMap.get("geometry");
		String layerUrl = (String)commandMap.get("layerUrl");
		
		spaceNdata spacendata = new spaceNdata(apiKey, pageIndex, pageUnit, 
				output, domain, srsName);
		
		List list = spacendata.doSearch(geometry, layerUrl);
		
		model.addAttribute("resultList", list);
		
		return "/map/vData";
	}
	
	
	@RequestMapping(value="/dRoadView.do")  
	protected String dRoadView(HttpServletRequest request, HttpServletResponse response, ModelMap model, 
			Map<String, Object> commandMap) throws Exception {		
		
		String dMapkey = propertiesService.getString("dMapkey");
		
		model.addAttribute("dMapkey", dMapkey);
		model.addAttribute("dY", commandMap.get("transY"));
		model.addAttribute("dX", commandMap.get("transX"));
		model.addAttribute("dTw", commandMap.get("dTw"));
		model.addAttribute("dTh", commandMap.get("dTh"));
		
		return "/map/dRoadView"; 
	}
	
}
