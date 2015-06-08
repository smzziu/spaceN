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
var groupMarker;
var roadWidth;
var roadHeight;
var pClickControl;
var preFeatId;
var pageBlock;
var pageStart;
var pageEnd;
var preBlock;
var nextBlock;
var pageInfo = {
		totalRecord : 	0,
		totalPage	:	0,
		pageIndex	:	1,
		nextPage	:	0,
		prePage		:	0,
		pageUnit	:	5,
		pageSize	:	5
	};
var apiMap3D = null;
var map3DLayerList;
var mapView;
$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true
		,   north__size:		"auto"
	 	,	north__initClosed:	false
	 	,	north__initHidden:	false
 		,	east__size:			300
 		,	east__initClosed:	false
 		,	east__initHidden:	false
 		, 	west__size:			273
 		,	west__initClosed:	false
 		,	west__initHidden:	false
 		,  center:{
	    	onresize : resizeCenter
	    }
	});
	
	vworld.showMode = false; 
	vworld.init("vMap", "earth-first", 
		function() {        
		}
		,function (obj){
			apiMap3D = obj;
			map3DLayerList = apiMap3D.getLayerList();
			mapView = apiMap3D.getView();	
			layerLoad();
		}
		,function (msg){alert('oh my god');}
	);
	
	roadWidth = $('#innerLayout').width();
	roadHeight = $('#innerLayout').height();
	
	myInnerLayout = $('#innerLayout').layout({
		applyDefaultStyles: true
	     ,	south__size : 280
	     ,	south__initClosed:	true
	     ,	south__initHidden:	false
		 ,	east__size : roadWidth/2
    	 ,	east__initClosed:	true
    	 ,	east__initHidden:	true
    	 ,  center:{
    	    	onresize : resizeCenter
    	    }
	});
	
	$("#tree").treeview({
		collapsed: true,
		animated: "medium",
		persist: "location"
	});
}); 

function resizeCenter(){
	apiMap.updateSize();
}

function layerLoad(){
	if(map3DLayerList != null) {
		
		SOPLayer1 = createWMSLayer("LT_C_SPBD");
		SOPLayer1.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer1.setLayersWMS("LT_C_SPBD");
		SOPLayer1.setStylesWMS("LT_C_SPBD_NL");
		SOPLayer1.setTileSizeWMS(256);
		SOPLayer1.setLevelWMS(8, 15);
		Layervisibility('LT_C_SPBD',false);
	
		SOPLayer2 = createWMSLayer("LT_C_UPISUQ152");
		SOPLayer2.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer2.setLayersWMS("LT_C_UPISUQ152");
		SOPLayer2.setStylesWMS("LT_C_UPISUQ152");
		SOPLayer2.setTileSizeWMS(256);
		SOPLayer2.setLevelWMS(8, 17);
		Layervisibility('LT_C_UPISUQ152',false);
		
		SOPLayer3 = createWMSLayer("LT_C_USFSFFB");
		SOPLayer3.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer3.setLayersWMS("LT_C_USFSFFB");
		SOPLayer3.setStylesWMS("LT_C_USFSFFB");
		SOPLayer3.setTileSizeWMS(256);
		SOPLayer3.setLevelWMS(8, 15);
		Layervisibility('LT_C_USFSFFB',false);
		
		SOPLayer4 = createWMSLayer("LT_C_TDWAREA");
		SOPLayer4.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer4.setLayersWMS("LT_C_TDWAREA");
		SOPLayer4.setStylesWMS("LT_C_TDWAREA");
		SOPLayer4.setTileSizeWMS(256);
		SOPLayer4.setLevelWMS(8, 15);
		Layervisibility('LT_C_TDWAREA',false);
		
		SOPLayer5 = createWMSLayer("LT_L_MOCTLINK");
		SOPLayer5.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer5.setLayersWMS("LT_L_MOCTLINK");
		SOPLayer5.setStylesWMS("LT_L_MOCTLINK_3D");
		SOPLayer5.setTileSizeWMS(256);
		SOPLayer5.setLevelWMS(8, 15);
		Layervisibility('LT_L_MOCTLINK',false);
		
		SOPLayer6 = createWMSLayer("LT_P_MOCTNODE");
		SOPLayer6.setConnectionWMS("2d.vworld.kr", 8895, "/2DCache/gis/map/WMS?");
		SOPLayer6.setLayersWMS("LT_P_MOCTNODE");
		SOPLayer6.setStylesWMS("LT_P_MOCTNODE_3D");
		SOPLayer6.setTileSizeWMS(256);
		SOPLayer6.setLevelWMS(8, 15);
		Layervisibility('LT_P_MOCTNODE',false);
		
		SOPLayer7 = createWMSLayer("geotwo_postgis:og_tbm_ls");
		SOPLayer7.setConnectionWMS("www.khoa.go.kr", 80, "/oceangrid/cmm/proxyRun.do?call=wms&");
		SOPLayer7.setLayersWMS("geotwo_postgis:og_tbm_ls");
		SOPLayer7.setTileSizeWMS(256);
		SOPLayer7.setLevelWMS(8, 15);
		Layervisibility('geotwo_postgis:og_tbm_ls',false);
		
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

function reloadLayers(layerName,isCheck){
	if(layerName == "geotwo_postgis:og_tbm_ls"){
		if(isCheck){
			Layervisibility(layerName, true);
		}else{
			Layervisibility(layerName, false);
		}
	}else{
		if(isCheck){
			Layervisibility(layerName, true);
		}else{
			Layervisibility(layerName, false);
		}
	}
}

function getWfsFindLayer(wfsFindLayer){
  	findLayerName = wfsFindLayer;
}

function getWfsValue(control){
	dataControl = control;
	if(dataControl == "info"){
		window.sop.earth.addEventListener(apiMap3D, "lmouseup", getWfsclick);
	}else{
		alert("지원하지 않는 분석입니다.");
	}
}

function getWfsclick(evt){
	mapView.mapReset();
	window.sop.earth.removeEventListener(apiMap3D, "lmouseup", getWfsclick);
	getWfsPoints = evt.getMapCoordinate();
	
	var params = "";
	params += "apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17";
	params += "&geometry=POINT("+getWfsPoints.Longitude+" "+getWfsPoints.Latitude+")";
	
	params += "&pageIndex=" + pageInfo.pageIndex;
	params += "&pageUnit=" + pageInfo.pageUnit;
	params += "&domain=localhost:8080";
	params += "&output=json";
	params += "&srsName=EPSG:4326";
	params += "&layerUrl="+findLayerName+"/data";
	
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/vnation_example03_1.do",
	    data : params,
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	console.log(response);
	    	
	    	$('#dataDiv').html(response); 
	    	
	    	var features;
	    	var json_str = $("#vGml").val();
	    	var geoJson = eval("(" + json_str + ")");
	    	var code = geoJson.header['resultCode'];
			if(code != '200'){
				alert(geojson.header['resultMsg']);
				return;
			}
			var geojson_format = new OpenLayers.Format.GeoJSON();
			features = geojson_format.read(geoJson.featureCollection);
			if(features.length < 1){
				alert("검색된 데이터가 없습니다.");
				return;	
			}
			
			//페이지 정보
			pageInfo.pageIndex = geoJson.paginationInfo['pageIndex'];
			pageInfo.totalPage = geoJson.paginationInfo['totalPageCount'];
			pageInfo.totalRecord	= geoJson.paginationInfo['totalRecordCount'];
			pageInfo.pageUnit		= geoJson.paginationInfo['pageUnit'];
			if(pageInfo.pageIndex < pageInfo.totalPage){
				pageInfo.nextPage = parseInt(pageInfo.pageIndex) + 1;
			}else{
				pageInfo.nextPage = 0;
			}
			if(1 < pageInfo.pageIndex  && 1 < pageInfo.totalPage){
				pageInfo.prePage = parseInt(pageInfo.pageIndex) - 1;
			}else{
				pageInfo.prePage = 0;
			}
			
			features.sort(function(a,b){
				var aval = a.fid.split('.')[0];
				var bval = b.fid.split('.')[0];
				return aval < bval ? -1: aval==bval? 0:1;								
			});
			
			vworldInfo.group = [];
			
			var initGroup = false;
			var curAlias = "";
			var curFeats = [];
			var curGroup = "";					    	
			var tabCount =0;
			for(var i=0;i< features.length;i++) {
				
				initGroup = false;								
				var tmpgroup = features[i].fid.split('.')[0];
				if (curGroup == "" || curGroup != tmpgroup) {
					if (curGroup != "") {
						//피쳐그룹 추가
						vworldInfo.group.push({"alias":curAlias,"layer":curGroup,"features":curFeats});
						tabCount ++;
					} 
					initGroup = true;
					curFeats = [];
					curAlias = "";
					curGroup = tmpgroup;
				}  
				//모든 건수를 목록으로..
				if (initGroup){
					if (curAlias == '') {curAlias = curGroup;}							
				} 
				curFeats.push(features[i]);
				if (i == features.length -1) {
					//피쳐그룹 추가
					vworldInfo.group.push({"alias":curAlias,"layer":curGroup,"features":curFeats});
					tabCount ++;
				}								            								
			}
			
			getWfsList(pageInfo.totalRecord);
			features= null;
	    	
	    },
	    beforeSend: function() {
	    	$('#west_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#west_indicator').fadeOut();
	    }
	});
}

function getWfsList(count){
	
	var groupid	= 0;
	var content = "";
	
	content += "<div class='search_result'>";
	content += "<div class='result_title'>";
	content += "<img src='/images/search/searchicon_black.png' alt='' class='searchicon_black'/>";
	content += "검색결과 <span>"+count+"건</span>";
	content += "</div>";
	content += "<div class='result_space'>";  
	content += "<div class='scroll'>";
	content += "<table cellspacing='0' cellpadding='0' class='result_box'>";
	if(findLayerName == 'upisuq152'){
		for(var idx=0; idx<vworldInfo.group[groupid].features.length; idx++){
			
			var feature = vworldInfo.group[groupid].features[idx];
			var gid = feature.fid.split(".")[1];
			content += "<tr id='"+gid+"' onclick='javascript:drawFeature("+groupid+","+idx+",\""+gid+"\");'>";
			content += "<td class='result_name'><img src='/images/search/list-st.png' alt='' class='list-st'/>";
			content += "<strong>"+(feature.attributes["DGM_NM"]==null?"-":feature.attributes["DGM_NM"])+"</strong><br/>";
			content += "<p style='padding-left:20px;'>"+(feature.attributes["SIG_NAM"]==null?"-":feature.attributes["SIG_NAM"])+"</p>";
			content += "</td>";
			content += "<td class='link_location'>";
			content += "</td>";
			content += "</tr>";	
		}
	}else if(findLayerName == 'usfsffb'){
		for(var idx=0; idx<vworldInfo.group[groupid].features.length; idx++){
			
			var feature = vworldInfo.group[groupid].features[idx];
			var gid = feature.fid.split(".")[1];
			//var geometry = feature.geometry;
			content += "<tr id='"+gid+"' onclick='javascript:drawFeature("+groupid+","+idx+",\""+gid+"\");'>";
			content += "<td class='result_name'><img src='/images/search/list-st.png' alt='' class='list-st'/>";
			content += "<strong>"+(feature.attributes["WARD_NM"]==null?"-":feature.attributes["WARD_NM"])+"</strong><br/>";
			content += "<p style='padding-left:20px;'>"+(feature.attributes["WARD_ID"]==null?"-":feature.attributes["WARD_ID"])+"</p>";
			content += "</td>";
			content += "<td class='link_location'>";
			content += "</td>";
			content += "</tr>";	
		}
	}else if(findLayerName == 'tdwarea'){
		for(var idx=0; idx<vworldInfo.group[groupid].features.length; idx++){
			
			var feature = vworldInfo.group[groupid].features[idx];
			var gid = feature.fid.split(".")[1];
			content += "<tr id='"+gid+"' onclick='javascript:drawFeature("+groupid+","+idx+",\""+gid+"\");'>";
			content += "<td class='result_name'><img src='/images/search/list-st.png' alt='' class='list-st'/>";
			content += "<strong>"+(feature.attributes["SAUP_NAME"]==null?"-":feature.attributes["SAUP_NAME"])+"</strong><br/>";
			content += "<p style='padding-left:20px;'>"+(feature.attributes["SAUP_GUBUN"]==null?"-":feature.attributes["SAUP_GUBUN"])+"</p>";
			content += "</td>";
			content += "<td class='link_location'>";
			content += "</td>";
			content += "</tr>";	
		}
	}else if(findLayerName == 'moctlink'){
		for(var idx=0; idx<vworldInfo.group[groupid].features.length; idx++){
			
			var feature = vworldInfo.group[groupid].features[idx];
			var gid = feature.fid.split(".")[1];
			content += "<tr id='"+gid+"' onclick='javascript:drawFeature("+groupid+","+idx+",\""+gid+"\");'>";
			content += "<td class='result_name'><img src='/images/search/list-st.png' alt='' class='list-st'/>";
			content += "<strong>"+(feature.attributes["ROAD_NAME"]==null?"-":feature.attributes["ROAD_NAME"])+"</strong><br/>";
			content += "<p style='padding-left:20px;'>"+(feature.attributes["RD_TYPE_H"]==null?"-":feature.attributes["RD_TYPE_H"])+"</p>";
			content += "</td>";
			content += "<td class='link_location'>";
			content += "</td>";
			content += "</tr>";	
		}
	}else if(findLayerName == 'moctnode'){
		for(var idx=0; idx<vworldInfo.group[groupid].features.length; idx++){
			
			var feature = vworldInfo.group[groupid].features[idx];
			var gid = feature.fid.split(".")[1];
			content += "<tr id='"+gid+"' onclick='javascript:drawFeature("+groupid+","+idx+",\""+gid+"\");'>";
			content += "<td class='result_name'><img src='/images/search/list-st.png' alt='' class='list-st'/>";
			content += "<strong>"+(feature.attributes["NODE_NAME"]==null?"-":feature.attributes["NODE_NAME"])+"</strong><br/>";
			content += "<p style='padding-left:20px;'>"+(feature.attributes["ND_TYPE_H"]==null?"-":feature.attributes["ND_TYPE_H"])+"</p>";
			content += "</td>";
			content += "<td class='link_location'>";
			content += "</td>";
			content += "</tr>";	
		}
	}
		
	content += "</table>";
	content += "<br>";
	content += "<div style='margin:1px 0 5px 0;text-align:center;letter-spacing:1px;'>";
	content += jsPagination("jsPage");               
	content += "</div>";
	content += "</div>";
	content += "</div>";
	content += "</div>";
	
	$('#westResult').html(content); 
	
}

function jsPagination(jsfunc)
{
	var content = "";
	pageBlock	= parseInt((pageInfo.pageIndex-1) / pageInfo.pageSize);
	pageStart	= (pageBlock * pageInfo.pageSize) + 1;
	pageEnd		= (pageBlock * pageInfo.pageSize) + pageInfo.pageSize;
	preBlock	= (pageStart - 1) < 1 ? 0 : pageStart - 1;
	nextBlock	= (pageEnd + 1) > pageInfo.totalPage ? 0 : pageEnd + 1;
	console.log(pageBlock);
	console.log(pageStart);
	console.log(pageEnd);
	console.log(preBlock);
	console.log(nextBlock);
	if(preBlock > 0){
		content += "<a title='이전' href='javascript:"+jsfunc+"(" + preBlock + ");' class='pre'>이전</a>";
	}else{
		content += "<span class='pre'>이전</span>";
	}

	for(var i=pageStart; i<=pageEnd; i++){
	
		if(pageInfo.totalPage < i){
			break;
		}
		var first;
		var last;
		if(i == pageStart){
			first = " class='first-child' ";
		}
		if(i == pageEnd){
			last = " class='last-child' ";
		}
		if(i == pageInfo.pageIndex){
			content += "<strong"+first + last +">"+i+"</strong>";
		}else{
			content += "<a "+first + last +" href='javascript:"+jsfunc+"(" + i + ");'>"+i+"</a>";
		}
	}
	
	if(nextBlock > 0){
		content += "<a title='다음' href='javascript:"+jsfunc+"(" + nextBlock + ");' class='next'>다음</a>";
	}else{
		content += "<span class='next'>다음</span>";
	}
	return content;
}

function jsPage(index){
	pageInfo.pageIndex = index;
    getWfsclick(getWfsPoints);
}

function drawFeature(groupid, idx, fid){
	closeLayout();
	
	var	feature;
	if(vworldInfo.group){
		feature = vworldInfo.group[groupid].features[idx];
	
		preFeatId = feature.id;
		
		if (groupid >= vworldInfo.group.length || groupid == null) {groupid = 0; }
		if (idx >= vworldInfo.group[groupid].length || idx == null) {idx = 0;}
		
		var feature = vworldInfo.group[groupid].features[idx];
		var bounds = feature.geometry.getBounds();
		var content = "";
		if(findLayerName == 'upisuq152'){
			var dgm_nm = "", dgm_ar = "", dgm_lt = "", sig_nam = "", lcl_nam = "", mls_nam = "", scl_nam = "", atr_nam = "", pmi_nam = "", exc_nam = "";
			
			for (var k in feature.attributes) {  
				if (k.toUpperCase() == "DGM_NM") {
					dgm_nm = feature.attributes[k];
				}
				if (k.toUpperCase() == "DGM_AR") {
					dgm_ar = feature.attributes[k];
				}
				if (k.toUpperCase() == "DGM_LT") {
					dgm_lt = feature.attributes[k];
				}
				if (k.toUpperCase() == "SIG_NAM") {
					sig_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "LCL_NAM") {
					lcl_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "MLS_NAM") {
					mls_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "SCL_NAM") {
					scl_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "ATR_NAM") {
					atr_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "PMI_NAM") {
					pmi_nam = feature.attributes[k];
				}
				if (k.toUpperCase() == "EXC_NAM") {
					exc_nam = feature.attributes[k];
				}
			}
			content += "<div class='popup_area'>";
			content += "<div class='contents'>";
			content += "<div class='detail'>";
			content += "<table class='table'>";
			content += "<tr>";
			content += "<th width='120'>라벨명</th>";
			content += "<td width='250'>"+dgm_nm+"</td>";
			content += "<th width='120'>면적(도형)</th>";
			content += "<td width='250'>"+dgm_ar+"</td>";
			content += "<th width='120'>길이(도형)</th>";
			content += "<td width='250'>"+dgm_lt+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>시군구명</th>";
			content += "<td>"+sig_nam+"</td>";
			content += "<th>도형대분류명</th>";
			content += "<td>"+lcl_nam+"</td>";
			content += "<th>도형중분류명</th>";
			content += "<td>"+mls_nam+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>도형소분류명</th>";
			content += "<td>"+scl_nam+"</td>";
			content += "<th>도형속성명</th>";
			content += "<td>"+atr_nam+"</td>";
			content += "<th>도로기능명</th>";
			content += "<td>"+atr_nam+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>집행상태명</th>";
			content += "<td>"+exc_nam+"</td>";
			content += "</tr>";
			content += "</table>";
			content += "</div>";
			content += "<div class='close_f' onclick='closeLayout();'><img src='/images/btn_close_popup.png'></div>";
			content += "</div>";
			content += "</div>";
			myInnerLayout.show('south');
		}else if(findLayerName == 'tdwarea'){
			var saup_name = "", saup_gubun = "", year_saup = "", year_dsgn = "", saup_area = "";
			
			for (var k in feature.attributes) {  
				if (k.toUpperCase() == "SAUP_NAME") {
					saup_name = feature.attributes[k];
				}
				if (k.toUpperCase() == "SAUP_GUBUN") {
					saup_gubun = feature.attributes[k];
				}
				if (k.toUpperCase() == "YEAR_SAUP") {
					year_saup = feature.attributes[k];
				}
				if (k.toUpperCase() == "YEAR_DSGN") {
					year_dsgn = feature.attributes[k];
				}
				if (k.toUpperCase() == "SAUP_AREA") {
					saup_area = feature.attributes[k];
				}
			}
			content += "<div class='popup_area'>";
			content += "<div class='contents'>";
			content += "<div class='detail'>";
			content += "<table class='table'>";
			content += "<tr>";
			content += "<th width='120'>사업명</th>";
			content += "<td width='250'>"+saup_name+"</td>";
			content += "<th width='120'>연차별구분</th>";
			content += "<td width='250'>"+saup_gubun+"</td>";
			content += "<th width='120'>사업년도</th>";
			content += "<td width='250'>"+year_saup+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>설계년도</th>";
			content += "<td>"+year_dsgn+"</td>";
			content += "<th>사업면적</th>";
			content += "<td>"+saup_area+"</td>";
			content += "</tr>";
			content += "</table>";
			content += "</div>";
			content += "<div class='close_f' onclick='closeLayout();'><img src='/images/btn_close_popup.png'></div>";
			content += "</div>";
			content += "</div>";
			myInnerLayout.show('south');
		}else if(findLayerName == 'moctlink'){
			var link_id = "", road_name = "", max_spd = "", rd_rank_h = "", rd_type_h = "", rest_veh_h = "", rest_w = "", rest_h = "", remark = "";
			
			for (var k in feature.attributes) {  
				if (k.toUpperCase() == "LINK_ID") {
					link_id = feature.attributes[k];
				}
				if (k.toUpperCase() == "ROAD_NAME") {
					road_name = feature.attributes[k];
				}
				if (k.toUpperCase() == "MAX_SPD") {
					max_spd = feature.attributes[k];
				}
				if (k.toUpperCase() == "RD_RANK_H") {
					rd_rank_h = feature.attributes[k];
				}
				if (k.toUpperCase() == "RD_TYPE_H") {
					rd_type_h = feature.attributes[k];
				}
				if (k.toUpperCase() == "REST_VEH_H") {
					rest_veh_h = feature.attributes[k];
				}
				if (k.toUpperCase() == "REST_W") {
					rest_w = feature.attributes[k];
				}
				if (k.toUpperCase() == "REST_H") {
					rest_h = feature.attributes[k];
				}
				if (k.toUpperCase() == "REMARK") {
					remark = feature.attributes[k];
				}
			}
			content += "<div class='popup_area'>";
			content += "<div class='contents'>";
			content += "<div class='detail'>";
			content += "<table class='table'>";
			content += "<tr>";
			content += "<th width='120'>링크ID</th>";
			content += "<td width='250'>"+link_id+"</td>";
			content += "<th width='120'>도로명</th>";
			content += "<td width='250'>"+road_name+"</td>";
			content += "<th width='120'>최고제한속도</th>";
			content += "<td width='250'>"+max_spd+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>도로등급</th>";
			content += "<td>"+rd_rank_h+"</td>";
			content += "<th>도로유형</th>";
			content += "<td>"+rd_type_h+"</td>";
			content += "<th>통행제한차량</th>";
			content += "<td>"+rest_veh_h+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>통과제한하중</th>";
			content += "<td>"+rest_w+"</td>";
			content += "<th>통과제한높이</th>";
			content += "<td>"+rest_h+"</td>";
			content += "<th>비고</th>";
			content += "<td>"+remark+"</td>";
			content += "</tr>";
			content += "</table>";
			content += "</div>";
			content += "<div class='close_f' onclick='closeLayout();'><img src='/images/btn_close_popup.png'></div>";
			content += "</div>";
			content += "</div>";
			myInnerLayout.show('south');
		}else if(findLayerName == 'moctnode'){
			var node_id = "", node_name = "", nd_type_h = "", turn_type = "", remark = "";
			
			for (var k in feature.attributes) {  
				if (k.toUpperCase() == "NODE_ID") {
					node_id = feature.attributes[k];
				}
				if (k.toUpperCase() == "NODE_NAME") {
					node_name = feature.attributes[k];
				}
				if (k.toUpperCase() == "ND_TYPE_H") {
					nd_type_h = feature.attributes[k];
				}
				if (k.toUpperCase() == "TURN_TYPE") {
					turn_type = feature.attributes[k];
				}
				if (k.toUpperCase() == "REMARK") {
					remark = feature.attributes[k];
				}
			}
			content += "<div class='popup_area'>";
			content += "<div class='contents'>";
			content += "<div class='detail'>";
			content += "<table class='table'>";
			content += "<tr>";
			content += "<th width='120'>노드ID</th>";
			content += "<td width='250'>"+node_id+"</td>";
			content += "<th width='120'>노드명</th>";
			content += "<td width='250'>"+node_name+"</td>";
			content += "<th width='120'>노드유형</th>";
			content += "<td width='250'>"+nd_type_h+"</td>";
			content += "</tr>";
			content += "<tr>";
			content += "<th>회전제한유형</th>";
			content += "<td>"+turn_type+"</td>";
			content += "<th>비고</th>";
			content += "<td>"+remark+"</td>";
			content += "</tr>";
			content += "</table>";
			content += "</div>";
			content += "<div class='close_f' onclick='closeLayout();'><img src='/images/btn_close_popup.png'></div>";
			content += "</div>";
			content += "</div>";
			myInnerLayout.show('south');
		}
		$('#vDataResult').html(content); 
	
	}else{
		alert("검색 영역이 취소 되어 위치를 파악 할 수 없습니다.");
	}
}

function closeLayout(){
	myInnerLayout.hide('south');
	
}
</script>
</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="innerLayoutCenter" class="ui-layout-center">
		<div id="vMap" style="width:100%;height:100%"></div>
		<div id="dataDiv" style="display:none"></div>
	</div>
	<div class="ui-layout-south" id="vDataResult">
		
	</div>
</div>
<div class="ui-layout-east">
	<ul id="tree">
		<li>
			<strong>국가공간정보</strong>
			<ul>
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
<div class="ui-layout-north">
	<div class="header_wrapper">
		<h1><img src="/images/title.png" border="0" class="title_img" /></h1>
		<div>
			<ul class="top_btn">
				<li><a href="#" class="topbtn_point" onclick="getWfsValue('info');" title="점검색"></a></li>
			</ul> 
		</div>
	</div>	
</div>
<div class="ui-layout-west">
	<div id="westDiv">
		<input type="hidden" id="vCategory" value="Poi"/>
		<div id="ajax_indicator" style="display:none">
			로딩중...
		</div>
		<div id="westResult">
			<div class="search_result">
				<div class="result_title">
					<img src="/images/search/searchicon_black.png" alt="" class="searchicon_black"/>
					검색결과
				</div>
				<div class="result_space">  
					<div class="scroll">
						<table cellspacing="0" cellpadding="0" class="result_box">						
							<tr>	                        
							<td colspan="3">검색결과가 없습니다.</td>								
							<tr>																	
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>
</body>
</html>