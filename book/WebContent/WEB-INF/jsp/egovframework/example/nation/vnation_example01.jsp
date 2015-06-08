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
<link rel="stylesheet" href="/css/popup.css" type="text/css" media="screen" />
<link rel="stylesheet" href="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.css" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script src="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript">
var apiMap;
var groupMarker;
var apiMap3D;
var map3DLayerList;
var impLayer,impLayer2;
var SOPLayer1,SOPLayer2,SOPLayer3,SOPLayer4,SOPLayer5,SOPLayer6,SOPLayer7,SOPLayer7;
$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true
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
			layerLoad();
			map3DLayerList = apiMap3D.getLayerList();
			layerLoad();
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
	if(layerName == "geotwo_postgis:og_tbm_ls"){
		if(isCheck){
			if(vworld.getMode() == 2){
				Layervisibility(layerName, true);
			}else{
				impLayer = new OpenLayers.Layer.WMS('해양정보', 'http://www.khoa.go.kr/oceangrid/cmm/proxyRun.do?call=wms&', {
	                'layers': layerName,
	                'format': 'image/png',
	                'srs': 'EPSG:900913',
	                'exceptions': "text/xml",
	                'version': '1.3.0',
	                'transparent': true
	            }, {
	                'isBaseLayer': false,
	                'singleTile': false,
	                'visibility': true
	            });
				apiMap.addLayer(impLayer);
			}
		}else{
			if(vworld.getMode() == 2){
				Layervisibility(layerName, false);
			}else{
				apiMap.removeLayer(impLayer);
			}
		}
	}else if(layerName == "sf:yeouido_rel"){
		if(isCheck){
			if(vworld.getMode() == 2){
				Layervisibility(layerName, true);
			}else{
				impLayer2 = new OpenLayers.Layer.WMS('여의도', 'http://localhost:8087/geoserver/sf/wms?', {
	                'layers': layerName,
	                'styles': 'green',
	                'format': 'image/png',
	                'srs': 'EPSG:900913',
	                'exceptions': "text/xml",
	                'version': '1.3.0',
	                'transparent': true
	            }, {
	                'isBaseLayer': false,
	                'singleTile': false,
	                'visibility': true
	            });
				apiMap.addLayer(impLayer2);
			}
		}else{
			if(vworld.getMode() == 2){
				Layervisibility(layerName, false);
			}else{
				apiMap.removeLayer(impLayer2);
			}
		}
	}else{
		if(isCheck){
			if(vworld.getMode() == 2){
				Layervisibility(layerName, true);
			}else{
				apiMap.showThemeLayer(layerName, {layers:layerName});
			}
		}else{
			if(vworld.getMode() == 2){
				Layervisibility(layerName, false);
			}else{
				apiMap.hideThemeLayer(layerName);	
			}
		}
	}
}

function layerLoad(){
	if(map3DLayerList != null) {
		
		SOPLayer1 = createWMSLayer("LT_C_SPBD");
		SOPLayer1.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer1.setLayersWMS("LT_C_SPBD");
		SOPLayer1.setStylesWMS("LT_C_SPBD_NL");
		SOPLayer1.setTileSizeWMS(256);
		SOPLayer1.setLevelWMS(13, 15);
		Layervisibility('LT_C_SPBD',false);
	
		SOPLayer2 = createWMSLayer("LT_C_UPISUQ152");
		SOPLayer2.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer2.setLayersWMS("LT_C_UPISUQ152");
		SOPLayer2.setStylesWMS("LT_C_UPISUQ152");
		SOPLayer2.setTileSizeWMS(256);
		SOPLayer2.setLevelWMS(14, 17);
		Layervisibility('LT_C_UPISUQ152',false);
		
		SOPLayer3 = createWMSLayer("LT_C_USFSFFB");
		SOPLayer3.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer3.setLayersWMS("LT_C_USFSFFB");
		SOPLayer3.setStylesWMS("LT_C_USFSFFB");
		SOPLayer3.setTileSizeWMS(256);
		SOPLayer3.setLevelWMS(13, 15);
		Layervisibility('LT_C_USFSFFB',false);
		
		SOPLayer4 = createWMSLayer("LT_C_TDWAREA");
		SOPLayer4.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer4.setLayersWMS("LT_C_TDWAREA");
		SOPLayer4.setStylesWMS("LT_C_TDWAREA");
		SOPLayer4.setTileSizeWMS(256);
		SOPLayer4.setLevelWMS(12, 15);
		Layervisibility('LT_C_TDWAREA',false);
		
		SOPLayer5 = createWMSLayer("LT_L_MOCTLINK");
		SOPLayer5.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer5.setLayersWMS("LT_L_MOCTLINK");
		SOPLayer5.setStylesWMS("LT_L_MOCTLINK_3D");
		SOPLayer5.setTileSizeWMS(256);
		SOPLayer5.setLevelWMS(12, 15);
		Layervisibility('LT_L_MOCTLINK',false);
		
		SOPLayer6 = createWMSLayer("LT_P_MOCTNODE");
		SOPLayer6.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer6.setLayersWMS("LT_P_MOCTNODE");
		SOPLayer6.setStylesWMS("LT_P_MOCTNODE_3D");
		SOPLayer6.setTileSizeWMS(256);
		SOPLayer6.setLevelWMS(12, 15);
		Layervisibility('LT_P_MOCTNODE',false);
		
		SOPLayer7 = createWMSLayer("geotwo_postgis:og_tbm_ls");
		SOPLayer7.setConnectionWMS("www.khoa.go.kr", 80, "/oceangrid/cmm/proxyRun.do?call=wms&");
		SOPLayer7.setLayersWMS("geotwo_postgis:og_tbm_ls");
		SOPLayer7.setTileSizeWMS(256);
		SOPLayer7.setLevelWMS(8, 15);
		Layervisibility('geotwo_postgis:og_tbm_ls',false);
		
		SOPLayer8 = createWMSLayer("sf:yeouido_rel");
		SOPLayer8.setConnectionWMS("localhost", 8087, "/geoserver/sf/wms?");
		SOPLayer8.setLayersWMS("sf:yeouido_rel");
		SOPLayer8.setTileSizeWMS(256);
		SOPLayer8.setLevelWMS(8, 15);
		Layervisibility('sf:yeouido_rel',false);
	}
}

function createWMSLayer(layername){
	if(map3DLayerList != null) {
		var wmsLayer = map3DLayerList.createWMSLayer(layername);/**플러그인에 WMS데이터를 그리기 위한 레이어 생성**/
		
		if(wmsLayer==null){
			wmsLayer=map3DLayerList.nameAtLayer(layername);/**레이어 명에 해당하는 레이어 반환**/
			map3DLayerList.nameAtLayer(layername).clearWMSCashe();/**호출시점까지 적용되어 있던 wms데이터를 삭제 하고 새로운 request로 데이터를 불러온다.**/
		}

		return wmsLayer;
	}

}

function Layervisibility(name,visibility){
	
	if(apiMap3D != null){
		var vis = map3DLayerList.getVisible(name);/**서비스되고 있는 레이어의 보임 상태를 반환**/		
		if(visibility == true){
			vis = apiMap3D.SOPVISIBLE_ON;
		}else{
			vis = apiMap3D.SOPVISIBLE_OFF;
		}	
		
		map3DLayerList.setVisible(name, vis);/**서비스되고 잇는 레이어를 보이거나 보이지 않도록 설정**/

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
			<strong>국가공간정보</strong>
			<ul>
				<li>&nbsp;<input type="checkbox" unchecked id="sf:yeouido_rel" value="sf:yeouido_rel" onclick="reloadLayers(this.value,this.checked)">여의도</li>
				<li>&nbsp;<input type="checkbox" unchecked id="geotwo_postgis:og_tbm_ls" value="geotwo_postgis:og_tbm_ls" onclick="reloadLayers(this.value,this.checked)">기본수준점(TBM)</li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_C_SPBD" value="LT_C_SPBD" onclick="reloadLayers(this.value,this.checked)">새주소건물</li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_C_UPISUQ152" value="LT_C_UPISUQ152" onclick="reloadLayers(this.value,this.checked)">교통시설
				<input type="radio" name="order" value="upisuq152" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_C_USFSFFB" value="LT_C_USFSFFB" onclick="reloadLayers(this.value,this.checked)">소방서관할구역
				<input type="radio" name="order" value="usfsffb" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_C_TDWAREA" value="LT_C_TDWAREA" onclick="reloadLayers(this.value,this.checked)">보행자우선구역
				<input type="radio" name="order" value="tdwarea" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_L_MOCTLINK" value="LT_L_MOCTLINK" onclick="reloadLayers(this.value,this.checked)">교통링크
				<input type="radio" name="order" value="moctlink" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked id="LT_P_MOCTNODE" value="LT_P_MOCTNODE" onclick="reloadLayers(this.value,this.checked)">교통노드
				<input type="radio" name="order" value="moctnode" onclick="getWfsFindLayer(this.value)" /></li>
			</ul>
		</li>
	</ul>
</div>
</body>
</html>