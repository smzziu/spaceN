<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"	%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="geotwo" uri="http://www.o2mapweb.com/tlds"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%

	Object cnt = application.getAttribute("count");
	
	boolean isnew =session.isNew();
	
	
	if(isnew == true){	//세션 생성 하는 경우 진입
	
		if(cnt != null) {	// cnt 값이 null이 아닌 경우 진입
			int counter= (Integer)cnt;
			counter++;
			application.setAttribute("count", counter);
			
		}else {
			System.out.println("new session임");
			application.setAttribute("count", 1);
		}
		
		int cnt2= (Integer)application.getAttribute("count");
		    
		String id = session.getId();
	}else{
		String id = session.getId();
		session.setMaxInactiveInterval(2);
	}

	int today = (Integer)application.getAttribute("count");
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아산시 생활지리정보시스템</title>
<script type="text/javascript">
function init(){
	location.href = "o2mapTopSw";
}

</script>


</head>
<frameset rows="0%,100%" border="0">
	<frame name="top">
	<%-- <frame src="/main.do?today=<%= today%>&isnew=<%= isnew%>" name="main" marginwidth="0" marginheight="0" noresize> --%>
	<frame src="/o2mapClient.do" name="main" marginwidth="0" marginheight="0" noresize>
</frameset>
<noframes>
<body onload="init();">
11
</body>
</noframes>
</html>