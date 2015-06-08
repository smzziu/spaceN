package egovframework.got.com.bean;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;

import egovframework.rte.fdl.property.EgovPropertyService;

public abstract class AbstractService  {
	
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Resource(name="messageSource")
	public MessageSource messageSource;
	
	protected Log log = LogFactory.getLog(this.getClass());
}
