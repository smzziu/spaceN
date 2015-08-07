package egovframework.got.com.bean;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;

public abstract class AbstractController  {

	@Resource(name="messageSource")
	public MessageSource messageSource;

//	@Resource(name="egovframework.got.com.web.util.ParameterUtil")
//	public ParameterUtil parameterUtil;
/*
	@Qualifier("adminTilesViewResolver")
	@Autowired 
	public TilesUrlBasedViewResolver tilesUrlBasedViewResolver;
*/	
	protected Log log = LogFactory.getLog(this.getClass());

}
