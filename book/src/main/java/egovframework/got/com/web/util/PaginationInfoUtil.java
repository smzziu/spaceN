package egovframework.got.com.web.util;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Component("paginationInfoUtil")
public class PaginationInfoUtil {

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
    
    public void setBoardParam(Map inputMap, String boardName){
    	
    }
    
    
	
	public PaginationInfo setPageParam(Map inputMap, int totalCount){
		
		if(!isNumber(inputMap.get("pageIndex"))){
			inputMap.put("pageIndex", propertyService.getInt("pageIndex"));
		}

		if(!isNumber(inputMap.get("pageSize"))){
			inputMap.put("pageSize", propertyService.getInt("pageSize"));
		}		
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(inputMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertyService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertyService.getInt("pageSize"));
		inputMap.put("firstIndex",paginationInfo.getFirstRecordIndex());
		inputMap.put("lastIndex",paginationInfo.getLastRecordIndex());
		inputMap.put("recordCountPerPage",paginationInfo.getRecordCountPerPage());		
		inputMap.put("lastIndex",paginationInfo.getLastRecordIndex());
		
		paginationInfo.setTotalRecordCount(totalCount);
		
		
		return paginationInfo;
		
	}
	
public PaginationInfo setPageParamFacility(Map inputMap, int totalCount){
		
		if(!isNumber(inputMap.get("pageIndex"))){
			inputMap.put("pageIndex", propertyService.getInt("pageIndex"));
		}

		if(!isNumber(inputMap.get("smPageSize"))){
			inputMap.put("pageSize", propertyService.getInt("pageSize"));
		}		
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(inputMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertyService.getInt("pageUnit"));
		paginationInfo.setPageSize(propertyService.getInt("pageSize"));
		inputMap.put("firstIndex",paginationInfo.getFirstRecordIndex());
		inputMap.put("lastIndex",paginationInfo.getLastRecordIndex());
		inputMap.put("recordCountPerPage",paginationInfo.getRecordCountPerPage());		
		inputMap.put("lastIndex",paginationInfo.getLastRecordIndex());
		
		paginationInfo.setTotalRecordCount(totalCount);
		
		
		return paginationInfo;
		
	}

	public PaginationInfo setPageParamSearch(Map inputMap, int totalCount){
		
		if(!isNumber(inputMap.get("pageIndex"))){
			inputMap.put("pageIndex", propertyService.getInt("pageIndex"));
		}

		if(!isNumber(inputMap.get("pageSize"))){
			inputMap.put("pageSize", propertyService.getInt("smPageSize"));
		}
		
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(Integer.parseInt(inputMap.get("pageIndex").toString()));
		paginationInfo.setRecordCountPerPage(propertyService.getInt("smPageUnit"));
		paginationInfo.setPageSize(propertyService.getInt("smPageSize"));
		
		paginationInfo.setTotalRecordCount(totalCount);
		
		if(paginationInfo.getTotalPageCount() < Integer.parseInt(inputMap.get("pageIndex").toString())){
			paginationInfo.setCurrentPageNo(paginationInfo.getTotalPageCount());
			inputMap.put("pageIndex",paginationInfo.getCurrentPageNo());
			inputMap.put("recordCountPerPage",paginationInfo.getRecordCountPerPage());
			inputMap.put("firstIndex",paginationInfo.getFirstRecordIndex());
		}
		
		return paginationInfo;
		
	}

	public boolean isNumber(Object number) {
		try {
			Integer.parseInt(number.toString());
		} catch (Exception e) {//NumberFormatException
			return false;
		}
		return true;
	}    
}
