<%--
    프로그렴명 : 횡단면도 분석 팝업창
    설 명 : 횡단면도 분석 이미지 + 레이어 아이콘을 화면에 보여준다.
    작성자 : 김대용
    작성일 : 2010. 10. 04
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%

	String ACSSUrl = request.getParameter("ACSSUrl");
	String Service = request.getParameter("Service");
	String Version = request.getParameter("Version");
	String Request = request.getParameter("Request");
	String Layers = request.getParameter("Layers");
	String SearchPoint = request.getParameter("SearchPoint");
	String CRS = request.getParameter("CRS");
	String Width = request.getParameter("Width");
	String Height = request.getParameter("Height");
	String Format = request.getParameter("Format");
	//String crossAreaRequest = request.getParameter("ACSSUrl");
	//System.out.println("crossAreaRequest = "+crossAreaRequest);
	String crossAreaRequest = ACSSUrl + "&Service=" + Service + "&Version=" + Version + "&Request=" + Request + "&Layers=" + Layers + "&SearchPoint=" + SearchPoint + "&CRS=" + CRS + "&Width=" + Width + "&Height=" + Height + "&Format=" + Format;
	
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>횡단면도 분석</title>
</head>
<script type="text/javascript">
alert("<%=crossAreaRequest%>");
</script>
<body>
<h1><%=crossAreaRequest%></h1>
	<table width="817" height="400">
  <tr>
			<th  width="600" height="400">
       	  <img src="<%=crossAreaRequest%>"></th>
		   	<th width="217" height="400"><img src="img/symbol.png" width="217" height="400" alt="symbol"></th>
	  </tr>
	</table>
	<p>&nbsp;</p>
</body>
</html>