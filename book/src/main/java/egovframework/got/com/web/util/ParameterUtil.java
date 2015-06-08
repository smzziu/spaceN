package egovframework.got.com.web.util;

import java.util.Enumeration;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;

import egovframework.got.com.map.EntityMap;

@Component("egovframework.got.com.web.util.ParameterUtil")
public class ParameterUtil {

	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;
	
	public Map getParameterToMap(HttpServletRequest request)  throws Exception{
		
		Enumeration enumeration = request.getParameterNames();
		EntityMap params = new EntityMap();        
        String param = null;
        String[] values = null;

        while (enumeration.hasMoreElements()) {

            param = (String)enumeration.nextElement();
            values = request.getParameterValues(param);
            if (values.length == 1) {
            	if (values[0] != null){
            		params.put(param, values[0]);
            	}
            }else {
            	params.put(param, values);
            }
        }
        
        params.put("__remoteAddr__", request.getRemoteAddr());
        
        if(isRequestMultipart(request)){
        	//params.put("__fileList__",EgovFileUploadUtil.uploadFiles(request, "/home/", 104857600L));
        	params.put("__fileList__",fileUtil.parseFileInf(request));
        }
        request.setAttribute("rMap",params);
        return params;
	}
	
    /**
     * HTTP 요청이 멀티파트(multipart)인지 판단한다.
     *
     * @param request 요청 객체
     * @return multipart이면 <code>true</code>.
     */
    public boolean isRequestMultipart(HttpServletRequest request) {
        String type = request.getHeader("Content-Type");
        if ((type == null) || !type.startsWith("multipart/form-data")) {
            return false;
        }
        return true;
    }		
}
