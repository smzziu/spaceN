package egovframework.got.com.web.tag;

import java.util.LinkedHashMap;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import egovframework.got.com.util.StringUtil;
import egovframework.got.com.util.TaglibUtil;


public class Code2ValueTag extends TagSupport{
	private static final long serialVersionUID = 1L;
	private String type;
	private String tblNam;
	private String useNam;
	private String allCde; 
	private String dfValue;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTblNam() {
		return tblNam;
	}
	public void setTblNam(String tblNam) {
		this.tblNam = tblNam;
	}  

	public String getUseNam() {
		return useNam;
	}
	public void setUseNam(String useNam) {
		this.useNam = useNam;
	}
	public String getAllCde() {
		return allCde;
	}
	public void setAllCde(String allCde) {
		this.allCde = allCde;
	}
	public String getDfValue() {
		return dfValue;
	}
	public void setDfValue(String dfValue) {
		this.dfValue = dfValue;
	}
	
	public int doStartTag() throws JspException {
	    try {
	    	JspWriter out = this.pageContext.getOut();		
	    	String tmp = "";
	    	if("value".equals(type)){
	    		tmp = TaglibUtil.getCodeToValue(tblNam, useNam, allCde,  dfValue);
	    	}else if("select".equals(type)){
	    		tmp = TaglibUtil.getCodeToSelect(tblNam, useNam, allCde,  dfValue);
	    	}
	        out.write(tmp);
	    }
	    catch (Exception ex) {
	      throw new JspTagException(ex.getMessage());
	    }
	    return 0;
	}

}