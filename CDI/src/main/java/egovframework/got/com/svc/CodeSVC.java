package egovframework.got.com.svc;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.got.com.bean.AbstractService;
import egovframework.got.com.bean.CommDAO;

@Service("codeSVC")
public class CodeSVC extends AbstractService { 

    @Resource(name="commDAO")
	private CommDAO commDAO;
	
    /**
     * 
     * @param map
     * @return
     * @throws Exception
     */
	public List selectCodeItemList(Map map) throws Exception {
		return commDAO.list("code.selectCodeItemList", map);
	}		
	/**
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List selectFtrCdeItemList(Map map) throws Exception {
		return commDAO.list("code.selectFtrCdeItemList", map);
	}
	
	/**
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List selectAdarMaItemList(Map map) throws Exception {
		return commDAO.list("code.selectAdarMaItemList", map);
	}
	/**
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List selectLgarMaItemList(Map map) throws Exception {
		return commDAO.list("code.selectLgarMaItemList", map);
	}
	
	/**
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List selectMngrMaItemList(Map map) throws Exception {
		return commDAO.list("code.selectMngrMaItemList", map);
	}		
}
