<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String vMapKey = (String)request.getAttribute("vMapKey");
	String dMapkey = (String)request.getAttribute("dMapkey");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>로드뷰 활용</title>
<link rel="stylesheet" href="/css/ui/button.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/gis.css" type="text/css"/> 
<link rel="stylesheet" href="/css/ui/layer.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/map_skin1.css" type="text/css"/> 
<link rel="stylesheet" href="/css/ui/paginate.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/header.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/left_search.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/css/ui/footer.css" type="text/css"/>
<link rel="stylesheet" href="/css/popup.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/css/ui/footer-rightbox.css" type="text/css"/>
<link rel="stylesheet" href="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.css" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script src="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=<%=dMapkey %>"></script>
<script type="text/javascript">
var apiMap;
var roadWidth;
var roadHeight;
var rClickControl;
$(document).ready(function() {
	
	
	roadWidth = $('#innerLayout').width();
	
	myLayout = $('body').layout({
		applyDemoStyles : true
		,   north__size:		"auto"
	 	,	north__initClosed:	false
	 	,	north__initHidden:	false
 		,	east__size:			roadWidth/2
 		,	east__initClosed:	true
 		,	east__initHidden:	false
 		,  center:{
	    	onresize : resizeCenter
	    }
	});
	
	vworld.showMode = true; 
	vworld.init("vMap", "earth-first", 
		function() {        
			apiMap = this.vmap; 
			
			//기능버튼 추가
			apiMap.addVWORLDControl("zoomBar");
			apiMap.addVWORLDControl("indexMap");
			apiMap.addVWORLDControl("layerSwitch");					
			apiMap.setIndexMapPosition("right-bottom");
			
			//화면중심점과 레벨로 이동
			apiMap.setCenterAndZoom(14137025.510094, 4411241.3503068, 8); 
			
			roadHeight = $('#innerLayout').height();
		}
		,function (obj){
			apiMap3D = obj;
			mapView = apiMap3D.getView();	
		}
		,function (msg){alert('oh my god');}
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

var chkEvt = true;
function roadViewStart(){
	if(vworld.getMode() == 2){
		if(chkEvt == true){
			window.sop.earth.addEventListener(apiMap3D, "lmouseup", roadMapclick);
			chkEvt = false;
		}else{
			myLayout.hide('east');
			chkEvt = true;
		}
	}else{
		if(chkEvt == true){
			apiMap.initAll();
			var pointOptions = {persist:true};
			if (rClickControl == null) {
				rClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
				rClickControl.events.on({"measure": roadMapclick});
				apiMap.addControl(rClickControl);
			}        
			apiMap.init();
			rClickControl.activate();
			chkEvt = false;
		 }else{
			 apiMap.initAll();
			 rClickControl.deactivate();
			 myLayout.hide('east');
			 chkEvt = true;
		 }
	}
	
	 
}

function roadMapclick(evt){
	
	myLayout.toggle('east');
	
	var params;
	
	if(vworld.getMode() == 2){
		mapView.mapReset();
		window.sop.earth.removeEventListener(apiMap3D, "lmouseup", roadMapclick);
		var clickPoint = evt.getMapCoordinate();
		var mTw = roadWidth/2;
		var mTh = roadHeight;
		params="transX="+clickPoint.Longitude+"&transY="+clickPoint.Latitude+"&dTw="+mTw+"&dTh="+mTh;
	}else{
		apiMap.init();
		var temp = evt.geometry;	
		var pos = new OpenLayers.LonLat(temp.x, temp.y);
		
		var epsg900913 = new OpenLayers.Projection('EPSG:900913');
		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
		
		var transCod = new OpenLayers.Geometry.Point(pos.lon, pos.lat).transform(epsg900913,epsg4326);
		var transY = transCod.y;
		var transX = transCod.x;
		
		var mTw = roadWidth/2;
		var mTh = roadHeight;
		params="transX="+transX+"&transY="+transY+"&dTw="+mTw+"&dTh="+mTh;  
	}
	
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/dRoadView_example02.do",
	    data : params,
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	$('#dRoadview').html(response);   
	    },
	    beforeSend: function() {
	    	$('#ajax_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#ajax_indicator').fadeOut();
	    }
	});
}

function rvMove(dRvX, dRvY, dRvPoint){
	
	if(vworld.getMode() == 2){
		apiMap3D.getViewCamera().moveLonLatAlt(dRvX,dRvY,150);
		if(dRvPoint == 360){
			dRvPoint == 359;
		}
		apiMap3D.getViewCamera().setDirect(dRvPoint);
		apiMap3D.getViewCamera().setTilt(20);
	}else{
		apiMap.initAll();
		
		var epsg900913 = new OpenLayers.Projection('EPSG:900913');
	    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	    
	    /**
	     * 로드뷰가 이동시에 반환되는 좌표값을 구글좌표로 변환
	     */
	    var transCod = new OpenLayers.Geometry.Point(dRvX, dRvY).transform(epsg4326, epsg900913);
	    /**
	     * 변환한 좌표를 지도화면에 반영
	     */
	    apiMap.setCenter(new OpenLayers.LonLat(transCod.x, transCod.y),19);
	    
		marker = new vworld.Marker(transCod.x, transCod.y, null, "");
		
		// 마커 아이콘 이미지 파일명 설정합니다.
		marker.setIconImage("http://localhost:8080/images/roadview.png");
		
		// 마커의 z-Index 설정
		marker.setZindex(3);
		
		apiMap.addMarker(marker);
		
		//마커이미지 이벤트 id
		var rotate = marker.events.element.id.toString();
		
		//마커이미지 이벤트 id + _innerImage = 마커이미지 아이디
		rotate = rotate + '_innerImage';
		
		var markerImg = document.getElementById(rotate);
		markerImg.style.width = "50px";
		markerImg.style.height = "60px";
		
		var browser = navigator.userAgent.toLowerCase();
		
		//마커 회전
		if(dRvPoint != ""){
			if(browser.indexOf("msie 7") != -1 || browser.indexOf("msie 8") != -1){
				try{
					var deg2rad = Math.PI * 2 / 360;
					var rad = dRvPoint * deg2rad;
					var costheta = Math.cos(rad);
					var sintheta = Math.sin(rad);
					markerImg.style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11='1.0', sizingmethod='auto expand')alpha(opacity=100);";
					markerImg.filters.item(0).M11 = costheta;
					markerImg.filters.item(0).M12 = -sintheta;
					markerImg.filters.item(0).M21 = sintheta;
					markerImg.filters.item(0).M22 = costheta;
				}catch(e){	
					
					markerImg.style.MozTransform    = 'rotate(' + dRvPoint + 'deg)';
					markerImg.style.WebkitTransform = 'rotate(' + dRvPoint + 'deg)';
					markerImg.style.OTransform      = 'rotate(' + dRvPoint + 'deg)';
					markerImg.style.MsTransform     = 'rotate(' + dRvPoint + 'deg)';
					markerImg.style.transform       = 'rotate(' + dRvPoint + 'deg)';
				}
			}else{
				markerImg.style.MozTransform    = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.WebkitTransform = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.OTransform      = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.MsTransform     = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.transform       = 'rotate(' + dRvPoint + 'deg)';
			}
		}
	}
}
</script>
</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="vMap" style="width:100%;height:100%"></div>
</div>
<div id="dRoadview" class="ui-layout-east">
</div>
<div class="ui-layout-north">
	<div class="header_wrapper">
		<h1><img src="/images/title.png" border="0" class="title_img" /></h1>
		<ul class="top_btn_right">
			<li><a href="#" onClick="roadViewStart();" class="two_btn"></a></li>
		</ul>
	</div>	
</div>
</body>
</html>