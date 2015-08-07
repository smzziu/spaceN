<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String dMapkey = (String)request.getAttribute("dMapkey");
	String dY = (String)request.getAttribute("dY");
	String dX = (String)request.getAttribute("dX");
	String dTw = (String)request.getAttribute("dTw");
	String dTh = (String)request.getAttribute("dTh");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로드뷰</title> 
</head>

<script type="text/javascript">
var cenPo = "";
var dRv = "";
var dY = "<%=dY %>";
var dX = "<%=dX %>";
var panPoint = "";
var p;
var rc;
var rv;
roadInit();
function roadInit() {
	document.getElementById("roadview").style.width = <%=dTw %>+"px";
	document.getElementById("roadview").style.height = <%=dTh %>+"px";
	
	p = new daum.maps.LatLng(dY, dX);
	rc = new daum.maps.RoadviewClient();
	rv = new daum.maps.Roadview(document.getElementById("roadview"));
	
	
	rc.getNearestPanoId(p, 200, function(panoid) {
		rv.setPanoId(panoid, p);
		rv.setViewpoint({ pan: 70, tilt: -20, zoom: -3});
	});
	
	//센터값 알아오기
	daum.maps.event.addListener(rv,"position_changed",function() {		
		cenPo = rv.getPosition().toString();	
		cenPo = cenPo.replace("(","");
		cenPo = cenPo.replace(")","");	
		dRv = cenPo.split(",");	
		cenPoY = dRv[0];
		cenPoX = dRv[1];		
		document.getElementById("dRvY").value = cenPoY;
		document.getElementById("dRvX").value = cenPoX;
	});	
	
	//section 값 알아오기
	daum.maps.event.addListener(rv,"viewpoint_changed",function() {	
		panPoint = rv.getViewpoint().pan;
		document.getElementById("dRvPoint").value = panPoint;
	});	
	
	setTimeout(function(){
		roadMove();
	}, 4000);
	
}



//로드뷰 이동
function roadMove(){
	var dRvY = document.getElementById("dRvY").value;
	var dRvX = document.getElementById("dRvX").value;
	var dRvPoint = document.getElementById("dRvPoint").value;
	rvMove(dRvX, dRvY, dRvPoint);
}


 

</script>
<body>
<div id='roadview' onMousedown='roadMove();' onmouseup='roadMove();'></div>
<input type="hidden" id="dRvY" value="">
<input type="hidden" id="dRvX" value="">
<input type="hidden" id="dRvPoint" value="">

</body>
</html>

