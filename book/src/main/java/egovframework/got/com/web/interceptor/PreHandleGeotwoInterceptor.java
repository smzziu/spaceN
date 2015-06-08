package egovframework.got.com.web.interceptor;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.got.com.web.util.ParameterUtil;


public class PreHandleGeotwoInterceptor extends HandlerInterceptorAdapter {
	

	@Resource(name="egovframework.got.com.web.util.ParameterUtil")
	public ParameterUtil parameterUtil;
	
	/**
	 * 웹 로그정보를 생성한다.
	 * 
	 * @param HttpServletRequest request, HttpServletResponse response, Object handler 
	 * @return 
	 * @throws Exception 
	 */
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {	
		return true;
	}

    
	public Logger getBizLogger() {
		return Logger.getLogger(this.getClass().getName());
	}
}
