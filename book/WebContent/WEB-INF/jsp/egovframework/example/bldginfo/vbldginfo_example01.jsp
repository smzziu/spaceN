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
<title>국가 공간정보 활용</title>
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
<script type="text/javascript">
var apiMap;
var roadHeight;
var pClickControl;
var getWfsPoints;
var apiMap3D;
var mapView;
var map3DEventLast;
$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true
		,   north__size:		"auto"
	 	,	north__initClosed:	false
	 	,	north__initHidden:	false
 		,	east__size:			300
 		,	east__initClosed:	false
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

function reloadLayers(layerName,isCheck){
	if(isCheck){
		apiMap.showThemeLayer(layerName, {layers:layerName});	
	}else{
		apiMap.hideThemeLayer(layerName);	
	}
}

function getWfsFindLayer(wfsFindLayer){
  	findLayerName = wfsFindLayer;
}

function getWfsValue(control){
	dataControl = control;
	if(vworld.getMode() == 2){
		window.sop.earth.addEventListener(apiMap3D, "lmouseup", bldgCall);
	}else{
		apiMap.init();
		pClickControl = null;
		
		var pointOptions = {persist:true};
		if (pClickControl == null) {
			pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
			pClickControl.events.on({"measure": getWfsclick});
	    	apiMap.addControl(pClickControl);
		} 
		      
		pClickControl.activate();
	}
}

function bldgCall(evt){
	if(mapView.getWorkMode() == 1){
		
		map3DEventLast = evt;
		if(map3DEventLast != null){
			setSetSelectObject(map3DEventLast);
		} 			    			    	
		if(map3DEventLast.getTargetLayer().getName() == "facility_build"){
			
			var paramStr = "uid="+map3DEventLast.getTarget().getId();	
			window.open("http://map.vworld.kr/v2map_po_buildMetaInfo.do?"+paramStr,'bldgCall',"width=500, height=520");
			
			map3DEventLast = null;
			window.sop.earth.removeEventListener(apiMap3D, "lmouseup", bldgCall);
		}
	}
}

function setSetSelectObject(map3DEventLast){
	if(map3DEventLast.getTargetLayer().getName() != "UserLayer"){
		var col=apiMap3D.createColor();
		col.setARGB(125, 255, 255, 0);
		mapView.setSelectColor(col);
		mapView.setSelectObject(map3DEventLast.getTarget());
	}		
}

function getWfsclick(evt){
	getWfsPoints = evt;
	
	var lonLatPosition = new OpenLayers.LonLat(getWfsPoints.geometry.x, getWfsPoints.geometry.y);
	var px = apiMap.getPixelFromLonLat(lonLatPosition);
	var pixel = new OpenLayers.Pixel(px.x - 4, px.y + 4);
    var min = thisMap.getLonLatFromPixel(pixel);
    var pixel = new OpenLayers.Pixel(px.x + 4, px.y - 4);
    var max = thisMap.getLonLatFromPixel(pixel);
    var MinX = Math.abs(min.lon);
    var MinY = Math.abs(min.lat);
    var MaxX = Math.abs(max.lon);
    var MaxY = Math.abs(max.lat);
    
    var SearchPoint = MinX + "," + MinY + "," + MaxX + "," + MaxY;
    var filterText = "BBOX=" + SearchPoint;
    var params = "TYPENAME=LT_C_BLDGMETA";
    params += "&" + filterText;
    params += "&propertyname=(GEOIDN,UID,PNU,ag_geom),&MAXFEATURES=1";
    params += "&SERVICE=WFS";
    params += "&REQUEST=GetFeature";
    params += "&SRSNAME=EPSG:900913";
    params += "&OUTPUT=text/xml;subType=gml/3.1.1/profiles/gmlsf/1.0.0/0";
    params += "&VERSION=1.1.0";
    params += "&EXCEPTIONS=text/xml";
    params += "&apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17";
    
    var reqConfig = OpenLayers.Util.extend({
        url: "/proxy/proxy.jsp?url=http://2d.vworld.kr:8895/2DCache/gis/map/WFS?",
        data: params,
        headers: {
            "Content-Type": "text/plain"
        },
        success: bldgList,
        failure: bldgErr,
        scope: this
    }, {
        method: "POST"
    });
    OpenLayers.Request.issue(reqConfig);
	
}

function bldgList(response){
    var g = new OpenLayers.Format.GML();
    var features = g.read(response.responseText);
    apiMap.vectorLayer.addFeatures(features);
    var geoidn;
	if (features != null && features.length > 0) {
		for(var i=0;i<features.length;i++) {
			for (var j in features[i].attributes) {
				if(j.toUpperCase() == "GEOIDN"){
					geoidn = features[i].attributes[j];
					var paramStr = "geoidn="+geoidn;	
					window.open("http://map.vworld.kr/v2map_po_buildMetaInfo.do?"+paramStr,'bldgList',"width=500, height=520");
				}
			}
		}
	}
}

function bldgErr(e){
	alert(e);
}

function closeLayout(){
	myInnerLayout.hide('south');
	
	apiMap.updateSize();
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
			<strong>국가공간정보</strong>
			<ul>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_C_SPBD" value="LT_C_SPBD" onclick="reloadLayers(this.value,this.checked)">새주소건물
				<input type="radio" name="order" value="spbd" onclick="getWfsFindLayer(this.value)" /></li>
			</ul>
		</li>
	</ul>
</div>
<div class="ui-layout-north">
	<div class="header_wrapper">
		<h1><img src="/images/title.png" border="0" class="title_img" /></h1>
		<div>
			<ul class="top_btn">
				<li><a href="#" class="topbtn_point" onclick="getWfsValue('info');" title="점검색"></a></li>
				<li><a href="#" class="topbtn_reset" onclick="apiMap.initAll();" title="초기화"></a></li>
			</ul> 
		</div>
	</div>	
</div>
</body>
</html>