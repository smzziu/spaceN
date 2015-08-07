package egovframework.got.com.util;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class SpringBeanUtil {
    
    private static SpringBeanUtil  bean = new SpringBeanUtil();
  
    private ApplicationContext ctx;
   
    public static SpringBeanUtil  getInstance() {
        return bean;
    }

    private SpringBeanUtil () {
    	init();
    }
    
    public Object getBean(String beanName) {
        
        return ctx.getBean(beanName);
    }
    
    private void init() {


        ctx = new ClassPathXmlApplicationContext(getContextPaths());
    }


    private String[] getContextPaths() {


        String dir = "egovframework/spring/";
        String[] paths = { dir + "*.xml" };


        return paths;
    }
}
