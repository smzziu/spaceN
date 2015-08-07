package egovframework.got.com.web.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;


public class XSSTag extends TagSupport
{
  private static final long serialVersionUID = 1L;
  private String dataString;


	
  public String getDataString()
  {
    return this.dataString;
  }

  public void setDataString(String dataString) {
    this.dataString = dataString;
  }

  public int doStartTag() throws JspException {
    try {
      JspWriter out = this.pageContext.getOut();
      out.write(filterReplace(this.dataString));
    }
    catch (Exception ex) {
      throw new JspTagException(ex.getMessage());
    }
    return 0;
  }
  
  public String filterReplace(String strString){
  	String strNew = "";
  	
  	try{
  		StringBuffer strTxt = new StringBuffer("");
  		
  		char chrBuff;
  		int len = strString.length();
  		
  		for(int i = 0 ; i < len ; i++){
  			chrBuff = (char)strString.charAt(i);
  			
  			switch(chrBuff){
  				case '<':
  					strTxt.append("&lt;");
  					break;
  				case '>':
  					strTxt.append("&gt;");
  					break;
  				case '"':
  					strTxt.append("&quot;");
  					break;	
  				case '\'':
  					strTxt.append("&apos;");
  					break;	
  				case '&':
  					strTxt.append("&amp;");
  					break;	
  				case '(':
  					strTxt.append("&#40;");
  					break;	
  				case ')':
  					strTxt.append("&#41;");
  					break;	
  				case '#':
  					strTxt.append("&#35;");
  					break;	
  				case '%':
  					strTxt.append("&#37;");
  					break;
  				case ';':
  					strTxt.append("&#59;");
  					break;
  				case '+':
  					strTxt.append("&#43;");
  					break;	
  				case '-':
  					strTxt.append("&#45;");
  					break;
  				default:
  					strTxt.append(chrBuff);
  			}
  		}
  		strNew = strTxt.toString();
  		strNew = strNew.replaceAll("\r\n", "<br />");
  	}catch (Exception ex){
  		return "";
  	}
  	return strNew;
  }
}