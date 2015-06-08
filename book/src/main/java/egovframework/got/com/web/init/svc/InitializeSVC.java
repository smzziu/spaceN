package egovframework.got.com.web.init.svc;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.got.com.bean.AbstractService;
import egovframework.got.com.bean.CommDAO;

@Service("initializeSVC")
public class InitializeSVC extends AbstractService {

    @Resource(name="commDAO")
	private CommDAO commDAO;
	
//	public List getCodeList(Map map) throws Exception {
//		return commDAO.list("sample.selectBoardList", map);
//	}
//
//	public Map selectCodeTableMap(Map map) throws Exception {
//		return commDAO.map("code.selectCodeTableMap", map,"TBL_NAM");
//	}
//	
//	public Map selectCodeGroupMap(Map map) throws Exception {
//		return commDAO.map("code.selectCodeGroupMap", map,"ATT_NAM");
//	}
	
	public List selectCodeItemList(Map map) throws Exception {
		return commDAO.list("code.selectCodeItemList", map);
	}		
}
