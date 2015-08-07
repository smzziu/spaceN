package egovframework.got.com.exception;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.JoinPoint;

public class ExceptionTransfer{

    protected Log log = LogFactory.getLog(this.getClass());

    /*
     * @Resource(name = "otherSSLMailSender") private SimpleSSLMail mailSender;
     */

    public void transfer(JoinPoint thisJoinPoint, Exception exception) throws Exception {
    	
    	exception.printStackTrace();

    }

}
