<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String vMapKey = (String)request.getAttribute("vMapKey");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>교통정보 표시하기</title>
<link rel="stylesheet" href="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.css" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script src="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript">
var roadWidth;
var roadHeight;
$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true
 		,	east__size:			300
 		,	east__initClosed:	false
 		,	east__initHidden:	false
 		/*,	center__size:		"auto"*/
 		,  center:{
	    	onresize : resizeCenter
	    }
	});
	
	vworld.showMode = false; 
	vworld.init("vMap", "raster-first", 
		function() {        
			apiMap = this.vmap; 
			
			//기능버튼 추가
			apiMap.addVWORLDControl("zoomBar");
			apiMap.addVWORLDControl("indexMap");
			apiMap.addVWORLDControl("layerSwitch");					
			apiMap.setIndexMapPosition("right-bottom");
			
			//화면중심점과 레벨로 이동
			apiMap.setCenterAndZoom(14137025.510094, 4411241.3503068, 8);  
		}
	);
	
	$("#tree").treeview({
		collapsed: true,
		animated: "medium",
		persist: "location"
	});
}); 

function resizeCenter(){
	apiMap.updateSize();
}

function reloadLayers(layerName,isCheck){
	if(isCheck){
		var GeoServerAddr = 'http://61.43.91.75:8088/MLTMServlet';
		 
		var matrixIds = new Array(21);
		for (var i=0; i<21; ++i) {
			matrixIds[i] = "EPSG:900913:" + i;
		}
     
		NTrafficInfo = new OpenLayers.Layer.WMTS({
			name: 'NTrafficInfo',
			url: GeoServerAddr+"/wmts",
			layer: 'STD_LINK',
			style: '_null',
			matrixSet: 'EPSG:900913',
			matrixIds: matrixIds,
			format: 'image/gif',
			isBaseLayer: false
		});
		apiMap.addLayer(NTrafficInfo);
	}else{
		apiMap.removeLayer(NTrafficInfo);
	}
}
</script>
</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="vMap" style="width:100%;height:100%"></div>
</div>
<div class="ui-layout-east">
	<ul id="tree">
		<li>
			<strong>트리매뉴1</strong>
			<ul>
				<li>&nbsp;
					<input type="checkbox" unchecked id="NTrafficInfo" value="NTrafficInfo" onclick="reloadLayers(this.value,this.checked)">
					소통정보
				</li>
				<li>소메뉴2</li>
				<li>소메뉴3</li>
			</ul>
		</li>
		<li>
			<strong>트리매뉴2</strong>
			<ul>
				<li>소메뉴1</li>
				<li>소메뉴2</li>
				<li>소메뉴3</li>
				<li>소메뉴4</li>
			</ul>
		</li>
	</ul>
</div>
</body>
</html>