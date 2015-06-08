var apiMap = null;
var apiMap3D = null;
var groupMarker;
var NTrafficInfo;
var findLayerName;
var pClickControl;
var rClickControl;
var preFeatId;
var getWfsPoints;
var dataControl;

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

var storeIndex;
var sketchColor = '#0649FB';
var sketchSymbolizers = {
		'Point': {pointRadius: 3,graphicName: 'square',fillColor: 'white',fillOpacity: 1,strokeWidth: 1,strokeOpacity: 1,strokeColor:sketchColor},
		'Line': {strokeWidth: 3,strokeOpacity: 0.6,strokeColor: sketchColor,strokeDashstyle: 'solid'},
		'Polygon': {strokeWidth: 3,strokeOpacity: 0.6,strokeColor: sketchColor,fillColor: sketchColor,fillOpacity: 0.1}
};
var selFeature = {
		strokeWidth: 4,		
		strokeOpacity: 1,	
		strokeColor: "#20c02f",	
		fillColor: "#fff",		
		fillOpacity: 0.6
};
var selFeatureP = {
		strokeWidth: 4,		
		strokeOpacity: 1,	
		strokeColor: "#ea6721",	
		fillColor: "#fff",		
		fillOpacity: 0.6
};
var searchFeature = {
		strokeWidth: 2.5,	
		strokeOpacity: 0.8,	
		strokeColor: "#ea6721",	
		fillColor: "#fff",		
		fillOpacity: 0.3
};
var map3DLayerList;
var mapView;
var map3DEventLast;
setTimeout(function(){
	vworld.showMode = false; 
	vworld.init("vMap", "earth-first", 
		function() {        
			apiMap = this.vmap; 
			
			//기능버튼 추가
			apiMap.addVWORLDControl("zoomBar");
			apiMap.addVWORLDControl("indexMap");
			apiMap.addVWORLDControl("layerSwitch");					
			apiMap.setIndexMapPosition("right-bottom");
			
			//화면중심점과 레벨로 이동
			//apiMap.setCenterAndZoom(14137025.510094, 4411241.3503068, 8);  
			apiMap.setCenterAndZoom(14150040.662716093, 4495312.9191092625, 18);
			apiMap.addEvent("zoomend", getScaleEvt);
			if(document.createStyleSheet) {
				document.createStyleSheet('/css/popup.css');
			}else{
				var styles = "@import url('/css/popup.css');";
				var newSS=document.createElement('link');
				newSS.rel='stylesheet';
				newSS.href='data:text/css,'+escape(styles);
				document.getElementsByTagName("head")[0].appendChild(newSS);
			}
			
		}
		,function (obj){
			apiMap3D = obj;
			map3DLayerList = apiMap3D.getLayerList();
			mapView = apiMap3D.getView();	
			layerLoad();
		}
		,function (msg){alert('oh my god');}
	);
}, 500);

/**
 * 3D지도 레이어 초기화
 */
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

/**
 * wms 생성
 */
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

/**
 * 레이어 on/off
 */
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

function getExtent1(){
	var bounds = apiMap.getExtent();
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
	var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	bounds = bounds.transform(epsg900913, epsg4326);
	alert(bounds); 
	alert(bounds+" : "+bounds.left);
	alert(bounds+" : "+bounds.bottom);
	alert(bounds+" : "+bounds.right);
	alert(bounds+" : "+bounds.top);
}

function changeMode(idx){
	
	vworld.setMode(idx);
	if(idx == 2){
		$("#layer2D").hide();
		$("#layer3D").show();
	}else{
		$("#layer3D").hide();
		$("#layer2D").show();
	}
	
	var layerInfo;
	var exLayerInfo;
	$("input:checked[name=layerInfo]")
    .each(function(i){
    	layerInfo = $(this).val();
    	if(vworld.getMode() != 2){
    		Layervisibility(layerInfo, false);
    	}else{
    		apiMap.hideThemeLayer(layerInfo);
    	}
    	reloadLayers(layerInfo,'checked');
    });
	
	$("input:checked[name=exLayerInfo]")
    .each(function(i){
    	exLayerInfo = $(this).val();
    	if(vworld.getMode() != 2){
    		mapView.mapReset();
    	}else{
    		groupMarker.removeGroup(exLayerInfo);
    	}
    	reloadLayers(exLayerInfo,'checked');
    });
	
	var category = $("#vCategory").val();
	var vNm = $("#vNm").val();
	if(vNm == undefined || vNm == ""){
		return false;
	}else{
		if(category == "naver"){
			nLocalL(storeIndex);
		}else{
			vSearchL(storeIndex);
		}
	}
	
}

/**
 * its 국가공간정보센터 cctv영상
 */
function getCctv(kind){
	
	var cctvtype = new Array();
	var cctvurl = new Array();
	var coordy = new Array();
	var coordx = new Array();
	var cctvformat = new Array();
	var cctvname = new Array();
	
	var type = kind;
	
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/proxy/proxy.jsp?url="+escape("http://openapi.its.go.kr/api/NCCTVInfo?key=1412568714281&ReqType=1&MinX=126.100000&MaxX=130.890000&MinY=34.100000&MaxY=39.100000&type="+type),
	    dataType : "xml",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(object) {
	    	var data = object.getElementsByTagName('data');
	    	if(vworld.getMode() != 2){
	    		if(type == 'its'){
		    		groupMarker = new vworld.GroupMarker('NCCTVIts');
		    	}else{
		    		groupMarker = new vworld.GroupMarker('NCCTVEx');
		    	}
	    	}
	    	
	    	for(var i=0;i<data.length;i++){
	    		cctvtype[i] = data[i].getElementsByTagName('cctvtype')[0].firstChild.nodeValue;
	    		cctvurl[i] = data[i].getElementsByTagName('cctvurl')[0].firstChild.nodeValue;
	    		coordy[i] = data[i].getElementsByTagName('coordy')[0].firstChild.nodeValue;
	    		coordx[i] = data[i].getElementsByTagName('coordx')[0].firstChild.nodeValue;
	    		cctvformat[i] = data[i].getElementsByTagName('cctvformat')[0].firstChild.nodeValue;
	    		cctvname[i] = data[i].getElementsByTagName('cctvname')[0].firstChild.nodeValue;
	    		
	    		var epsg900913 = new OpenLayers.Projection('EPSG:900913');
	    		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	    		var transCod = new OpenLayers.Geometry.Point(coordx[i], coordy[i]).transform(epsg4326,epsg900913);
	        	
	    		var popupContentHTML = "";
	    		    popupContentHTML += "<div class='popup_area1'>";
	    			popupContentHTML += "<div class='titlePop1'>"+cctvname[i]+"</div>";
	    			popupContentHTML += "<div class='clear1'></div>";
	    			popupContentHTML += "<div class='contents1'>";
	    			popupContentHTML += "<div class='img1'><embed src='"+cctvurl[i]+"' showstatusbar='true'></div>";
	    			popupContentHTML += "<div class='detail1'>";
	    			popupContentHTML += "<table class='table1'>";
	    			popupContentHTML += "<tr>";
	    			popupContentHTML += "<th width='120'>형식</th>";
	    			popupContentHTML += "<td>"+cctvformat[i]+"</td>";
	    			popupContentHTML += "</tr>";
	    			popupContentHTML += "<tr>";
	    			popupContentHTML += "<th>type</th>";
	    			if(cctvtype[i] == 1){
	    				popupContentHTML += "<td>실시간 스트리밍</td>";
	    			}else if(cctvtype[i] == 2){
	    				popupContentHTML += "<td>동영상 파일</td>";
	    			}else{
	    				popupContentHTML += "<td>정지영상</td>";
	    			}
	    			popupContentHTML += "</tr>";
	    			popupContentHTML += "</table>";
	    			popupContentHTML += "</div>";
	    			popupContentHTML += "</div>";
	    			popupContentHTML += "</div>";
	    			
	    	    var imgUrl = "http://map.vworld.kr/images/symbol/ico_cctv_dark_small.png";
	    	    if(type == 'its'){
	    	    	if(vworld.getMode() == 2){
	    	    		layerMarker3D('cctv', coordx[i], coordy[i], popupContentHTML, imgUrl);
	    	    	}else{
	    	    		groupAddMarker('NCCTVIts', transCod.x, transCod.y, '',popupContentHTML, imgUrl);
	    	    	}
	    	    }else{
	    	    	if(vworld.getMode() == 2){
	    	    		layerMarker3D('cctv', coordx[i], coordy[i], popupContentHTML, imgUrl);
	    	    	}else{
	    	    		groupAddMarker('NCCTVEx', transCod.x, transCod.y, '',popupContentHTML, imgUrl);
	    	    	}
	    	    }
	    	    
	    	}
	    }
	});
}


function getNEventId(kind){
	var eventid = new Array();//공사 고유 식별번호
	var eventtype = new Array();//공사정보유형
	var lanesblocktype = new Array();//공사로 인한 차로 차단 방법
	var lanesblocked = new Array();//공사로 인해 차단된 차로 수
	var eventstartday = new Array();//공사 시작일
	var eventendday = new Array();//공사 종료일
	var eventstarttime = new Array();//공사 실제 개시 시간
	var eventendtime = new Array();//공사 실제 종료 시간
	var eventstatusmsg = new Array();//공사 상황정보 메시지
	var expectedcnt = new Array();//우회정보개수
	var expecteddetourmsg = new Array();//우회정보 메시지
	var eventdirection = new Array();//진행방향
	var coordy = new Array();//위도좌표
	var coordx = new Array();//경도좌표
	
	var type = kind;
	
	
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/proxy/proxy.jsp?url="+escape("http://openapi.its.go.kr/api/NEventIdentity?key=1412568714281&ReqType=2&MinX=126.100000&MaxX=130.890000&MinY=34.100000&MaxY=39.100000&type="+type),
	    dataType : "xml",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(object) {
	    	if(object != null){
		    	var data = object.getElementsByTagName('data');
		    	if(vworld.getMode() != 2){
			    	if(type == 'its'){
			    		groupMarker = new vworld.GroupMarker('NEventIdentityIts');
			    	}else{
			    		groupMarker = new vworld.GroupMarker('NEventIdentityEx');
			    	}
		    	}
		    	for(var i=0;i<data.length;i++){
		    		if(data[i].getElementsByTagName('eventid')[0].firstChild == null){
		    			eventid[i] = "";
		    		}else{
		    			eventid[i] = data[i].getElementsByTagName('eventid')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventtype')[0].firstChild == null){
		    			eventtype[i] = "";
		    		}else{
		    			eventtype[i] = data[i].getElementsByTagName('eventtype')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('lanesblocktype')[0].firstChild == null){
		    			lanesblocktype[i] = "";
		    		}else{
		    			lanesblocktype[i] = data[i].getElementsByTagName('lanesblocktype')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('lanesblocked')[0].firstChild == null){
		    			lanesblocked[i] = "";
		    		}else{
		    			lanesblocked[i] = data[i].getElementsByTagName('lanesblocked')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventstartday')[0].firstChild == null){
		    			eventstartday[i] = "";
		    		}else{
		    			eventstartday[i] = data[i].getElementsByTagName('eventstartday')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventendday')[0].firstChild == null){
		    			eventendday[i] = "";
		    		}else{
		    			eventendday[i] = data[i].getElementsByTagName('eventendday')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventstarttime')[0].firstChild == null){
		    			eventstarttime[i] = "";
		    		}else{
		    			eventstarttime[i] = data[i].getElementsByTagName('eventstarttime')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventendtime')[0].firstChild == null){
		    			eventendtime[i] = "";
		    		}else{
		    			eventendtime[i] = data[i].getElementsByTagName('eventendtime')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventstatusmsg')[0].firstChild == null){
		    			eventstatusmsg[i] = "";
		    		}else{
		    			eventstatusmsg[i] = data[i].getElementsByTagName('eventstatusmsg')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('expectedcnt')[0].firstChild == null){
		    			expectedcnt[i] = "";
		    		}else{
		    			expectedcnt[i] = data[i].getElementsByTagName('expectedcnt')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('expecteddetourmsg')[0].firstChild == null){
		    			expecteddetourmsg[i] = "";
		    		}else{
		    			expecteddetourmsg[i] = data[i].getElementsByTagName('expecteddetourmsg')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('eventdirection')[0].firstChild == null){
		    			eventdirection[i] = "";
		    		}else{
		    			eventdirection[i] = data[i].getElementsByTagName('eventdirection')[0].firstChild.nodeValue;
		    		}
		    		coordy[i] = data[i].getElementsByTagName('coordy')[0].firstChild.nodeValue;
		    		coordx[i] = data[i].getElementsByTagName('coordx')[0].firstChild.nodeValue;
		    		
		    		var epsg900913 = new OpenLayers.Projection('EPSG:900913');
		    		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
		    		var transCod = new OpenLayers.Geometry.Point(coordx[i], coordy[i]).transform(epsg4326,epsg900913);
		    		var popupContentHTML = "";
		    		    popupContentHTML += "<div class='popup_area'>";
		    			popupContentHTML += "<div class='titlePop'>"+eventid[i]+"</div>";
		    			popupContentHTML += "<div class='clear'></div>";
		    			popupContentHTML += "<div class='contents'>";
		    			popupContentHTML += "<div class='detail' id='popWidth'>";
		    			popupContentHTML += "<table class='table'>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>공사정보유형</th>";
		    			popupContentHTML += "<td>"+eventtype[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>차로 차단 방법</th>";
		    			if(lanesblocktype[i] == 0){
		    				popupContentHTML += "<td>통제없음</td>";
		    			}else if(lanesblocktype[i] == 1){
		    				popupContentHTML += "<td>갓길통제</td>";
		    			}else if(lanesblocktype[i] == 2){
		    				popupContentHTML += "<td>차로부분통제</td>";
		    			}else{
		    				popupContentHTML += "<td>전면통제</td>";
		    			}
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>차단된 차로 수</th>";
		    			popupContentHTML += "<td>"+lanesblocked[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>공사시작일</th>";
		    			popupContentHTML += "<td>"+eventstartday[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>공사완료일</th>";
		    			popupContentHTML += "<td>"+eventendday[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>상황정보</th>";
		    			popupContentHTML += "<td>"+eventstatusmsg[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>우회정보개수</th>";
		    			popupContentHTML += "<td>"+expectedcnt[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>진행방향</th>";
		    			popupContentHTML += "<td>"+eventdirection[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "</table>";
		    			popupContentHTML += "</div>";
		    			popupContentHTML += "</div>";
		    			popupContentHTML += "</div>";
		    			
		    	    var imgUrl = "/images/icon_construction.png";
		    	    
		    	    if(type == 'its'){
		    	    	if(vworld.getMode() == 2){
		    	    		layerMarker3D('NEventIdentity', coordx[i], coordy[i], popupContentHTML, imgUrl);
		    	    	}else{
		    	    		groupAddMarker('NEventIdentityIts', transCod.x, transCod.y, '',popupContentHTML, imgUrl);
		    	    	}
		    	    }else{
		    	    	if(vworld.getMode() == 2){
		    	    		layerMarker3D('NEventIdentity', coordx[i], coordy[i], popupContentHTML, imgUrl);
		    	    	}else{
		    	    		groupAddMarker('NEventIdentityEx', transCod.x, transCod.y, '',popupContentHTML, imgUrl);
		    	    	}
		    	    }
		    	    
		    	}
	    	}else{
	    		alert("공사정보가 없습니다.");
	    	}
	    }
	});
}

function getIncident(){
	var msg = new Array();//교통안전정보 메세지
	var rseseq = new Array();//제공RSE 순번
	var createdt = new Array();//문안생성일시
	var msgcd = new Array();//콘텐츠 유형
	var priorder = new Array();//우선순위
	var rseid = new Array();//RSE ID
	var routename = new Array();//노선명
	var routeno = new Array();//노선번호
	var rsebound = new Array();//RSE 진행방향
	var bound = new Array();//콘텐츠 노선방향
	var slink_id = new Array();//이벤트 발생 표준링크 ID
	var coordy = new Array();//위도좌표
	var coordx = new Array();//경도좌표
	
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/proxy/proxy.jsp?url="+escape("http://openapi.its.go.kr/api/RseIncidentInfo?key=1412568714281&ReqType=2&MinX=126.100000&MaxX=130.890000&MinY=34.100000&MaxY=39.100000"),
	    dataType : "xml",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(object) {
	    	if(object != null){
		    	var data = object.getElementsByTagName('data');
		    	if(vworld.getMode() != 2){
		    		groupMarker = new vworld.GroupMarker('RseIncidentInfo');
		    	}
		    	for(var i=0;i<data.length;i++){
		    		
		    		if(data[i].getElementsByTagName('msg')[0].firstChild == null){
		    			msg[i] = "";
		    		}else{
		    			msg[i] = data[i].getElementsByTagName('msg')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('rseseq')[0].firstChild == null){
		    			rseseq[i] = "";
		    		}else{
		    			rseseq[i] = data[i].getElementsByTagName('rseseq')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('createdt')[0].firstChild == null){
		    			createdt[i] = "";
		    		}else{
		    			createdt[i] = data[i].getElementsByTagName('createdt')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('msgcd')[0].firstChild == null){
		    			msgcd[i] = "";
		    		}else{
		    			msgcd[i] = data[i].getElementsByTagName('msgcd')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('priorder')[0].firstChild == null){
		    			priorder[i] = "";
		    		}else{
		    			priorder[i] = data[i].getElementsByTagName('priorder')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('rseid')[0].firstChild == null){
		    			rseid[i] = "";
		    		}else{
		    			rseid[i] = data[i].getElementsByTagName('rseid')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('routename')[0].firstChild == null){
		    			routename[i] = "";
		    		}else{
		    			routename[i] = data[i].getElementsByTagName('routename')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('routeno')[0].firstChild == null){
		    			routeno[i] = "";
		    		}else{
		    			routeno[i] = data[i].getElementsByTagName('routeno')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('rsebound')[0].firstChild == null){
		    			rsebound[i] = "";
		    		}else{
		    			rsebound[i] = data[i].getElementsByTagName('rsebound')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('bound')[0].firstChild == null){
		    			bound[i] = "";
		    		}else{
		    			bound[i] = data[i].getElementsByTagName('bound')[0].firstChild.nodeValue;
		    		}
		    		if(data[i].getElementsByTagName('slink_id')[0].firstChild == null){
		    			slink_id[i] = "";
		    		}else{
		    			slink_id[i] = data[i].getElementsByTagName('slink_id')[0].firstChild.nodeValue;
		    		}
		    		coordy[i] = data[i].getElementsByTagName('coordy')[0].firstChild.nodeValue;
		    		coordx[i] = data[i].getElementsByTagName('coordx')[0].firstChild.nodeValue;
		    		
		    		var epsg900913 = new OpenLayers.Projection('EPSG:900913');
		    		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
		    		var transCod = new OpenLayers.Geometry.Point(coordx[i], coordy[i]).transform(epsg4326,epsg900913);
		    		var popupContentHTML = "";
		    		    popupContentHTML += "<div class='popup_area'>";
		    			popupContentHTML += "<div class='titlePop'>"+routename[i]+"</div>";
		    			popupContentHTML += "<div class='clear'></div>";
		    			popupContentHTML += "<div class='contents'>";
		    			popupContentHTML += "<div class='detail' id='popWidth'>";
		    			popupContentHTML += "<table class='table'>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>교통안전정보 메세지</th>";
		    			popupContentHTML += "<td>"+msg[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>제공RSE 순번</th>";
		    			popupContentHTML += "<td>"+rseseq[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>문안생성일시</th>";
		    			popupContentHTML += "<td>"+createdt[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>콘텐츠 유형</th>";
		    			popupContentHTML += "<td>"+msgcd[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>우선순위</th>";
		    			popupContentHTML += "<td>"+priorder[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>RSE ID</th>";
		    			popupContentHTML += "<td>"+rseid[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<th width='120'>노선번호</th>";
		    			popupContentHTML += "<td>"+routeno[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>RSE 진행방향</th>";
		    			popupContentHTML += "<td>"+rsebound[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "<tr>";
		    			popupContentHTML += "<th width='120'>콘텐츠 노선방향</th>";
		    			popupContentHTML += "<td>"+bound[i]+"</td>";
		    			popupContentHTML += "</tr>";
		    			popupContentHTML += "</table>";
		    			popupContentHTML += "</div>";
		    			popupContentHTML += "</div>";
		    			popupContentHTML += "</div>";
		    			
		    	    var imgUrl = "/images/icon_trafficmap_accident.png";
		    	    
	    	    	if(vworld.getMode() == 2){
	    	    		layerMarker3D('RseIncidentInfo', coordx[i], coordy[i], popupContentHTML, imgUrl);
	    	    	}else{
	    	    		groupAddMarker('RseIncidentInfo', transCod.x, transCod.y, '',popupContentHTML, imgUrl);
	    	    	}
		    	    
		    	}
	    	}else{
	    		alert("교통안전도우미 정보가 없습니다.");
	    	}
	    }
	});
}

/**
 * 그룹마커생성
 * @param groupName
 * @param lon
 * @param lat
 * @param title
 * @param desc
 * @param imgurl
 */
function groupAddMarker(groupName, lon, lat,title, desc, imgurl){
	if(groupMarker != undefined){
		var marker = groupMarker.addMarker(groupName, lon, lat,title, desc, imgurl);
		if(marker != undefined){
			if (typeof imgurl == 'string') {marker.setIconImage(marker.icon.url);}
			apiMap.addMarker(marker);
		}
	} else {
		alert('생성된 그룹이 없습니다.');
	}
}

function jsSample2(){
    if(apiMap3D != null){
        var str="";
        var SOPLayerList = apiMap3D.getUserLayer();
        /*var layerCount = SOPLayerList.count();
        for(i=0;i< layerCount;i++){
            str+=SOPLayerList.indexAtLayer(i).getName();
            if(i<layerCount){
                str+="\n";
            }           
        }*/
        alert(SOPLayerList);
    }
}

var layerPoi;
function layerMarker3D(layerId, lon, lat, message, imgurl){
	var imgCount = imgurl;
	if(apiMap3D != null){
		apiMap3D.getUserLayer().removeAll();
		var vec4=apiMap3D.createVec3();
		layerPoi = apiMap3D.createPoint(layerId);
		vec4.Longitude = lon;
		vec4.Latitude = lat;
		vec4.Altitude = 0;
		layerPoi.Set(vec4);
		var sym=layerPoi.getSymbol();
		var icon=sym.getIcon();
		icon.setNormalIcon(imgCount);
		sym.setIcon(icon);
		layerPoi.setSymbol(sym);
		layerPoi.setDescription(message);
		apiMap3D.getView().addChild(layerPoi,8);
		window.sop.earth.addEventListener(layerPoi, "lmouseup", map3DBalloon);
	}
}

/**
 * 레이어 제어
 * @param layerName
 * @param isCheck
 */
function reloadLayers(layerName,isCheck){
	if(vworld.getMode() == 2){
		mapView.mapReset();
	}
	if(layerName == "NCCTVIts"){
		if(isCheck){
			getCctv('its');
		}else{
			if(vworld.getMode() == 2){
				mapView.mapReset();
			}else{
				groupMarker.removeGroup(layerName);
			}
		}
	}else if(layerName == "NCCTVEx"){
		if(isCheck){
			getCctv('ex');
		}else{
			if(vworld.getMode() == 2){
				mapView.mapReset();
			}else{
				groupMarker.removeGroup(layerName);
			}
		}
	}else if(layerName == "NTrafficInfo"){
		if(vworld.getMode() == 2){
			alert("3D 지도에서 제공하지 않는 기능입니다.");
		}else{
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
	}else if(layerName == "NEventIdentityIts"){
		if(isCheck){
			getNEventId('its');
		}else{
			if(vworld.getMode() == 2){
				mapView.mapReset();
			}else{
				groupMarker.removeGroup(layerName);
			}
		}
	}else if(layerName == "NEventIdentityEx"){
		if(isCheck){
			getNEventId('ex');
		}else{
			if(vworld.getMode() == 2){
				mapView.mapReset();
			}else{
				groupMarker.removeGroup(layerName);
			}
		}
	}else if(layerName == "RseIncidentInfo"){
		if(isCheck){
			getIncident();
		}else{
			if(vworld.getMode() == 2){
				mapView.mapReset();
			}else{
				groupMarker.removeGroup(layerName);
			}
		}
	}else if(layerName == "geotwo_postgis:og_tbm_ls"){
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

/**
 * 스케일값 리턴
 * @param e
 */
function getScaleEvt(e){
	var vScale = $("#txtScale");
	var intScale = numchk(parseInt(apiMap.getScale()));
	vScale.val(intScale);
}

/**
 * 스케일값 설정
 * @param e
 */
function setScaleEvt(){
	var vScale = $("#txtScale");
	apiMap.zoomToScale(vScale.val(), true);
}

/**
 * 인덱스 활성화/비활성화
 */
function indexMapControl(){
	var temp = $("#indexChk");
	if(temp.val() == "On"){
		apiMap.removeVWORLDControl("indexMap");
		temp.val("Off");
	}else{
		apiMap.addVWORLDControl("indexMap");
		temp.val("On");
	}
}

/**
 * 검색api
 * @param kind
 */
function vSearch(kind){
	var vKind = kind;
	var params="vKind="+vKind;  
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/vSearch.do",
	    data : params,
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	$('#westDiv').html(response);   
	    },
	    beforeSend: function() {
	    	$('#ajax_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#ajax_indicator').fadeOut();
	    }
	});
}


/**
 * 검색api 결과조회
 * @param index
 * @returns {Boolean}
 */
function vSearchL(index){
	storeIndex = index;
	var pageIndex = index;
	if(pageIndex == null){
		pageIndex = 1;
	}	
	var vNm = $("#vNm").val();
	var category = $("#vCategory").val();
	var params="vNm="+vNm+"&category="+category+"&pageIndex="+pageIndex;  
	if(vNm == null || vNm==""){
		alert("검색명을 입력해 주세요.");		
		return false;
	}else{
		$.ajax({
		    type : "POST",
		    async : true,
		    url : "/vSearchL.do",
		    data : params,
		    dataType : "html",
		    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    error : function(request, status, error) {
		    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
		    },
		    success : function(response, status, request) {
		    	$('#westResult').html(response); 
		    	vSearchLmove(category);
		    },
		    beforeSend: function() {
		    	$('#west_indicator').show().fadeIn('fast');
		    },
		    complete: function() {
		    	$('#west_indicator').fadeOut();
		    }
		});
	}
}

/**
 * 검색api 검색리스트 지도 이동
 */
function vSearchLmove(kind){
	
	var vKind = kind;
	var vx = new Array();
	var vy = new Array();
	var vNo = new Array();
	var vPnu = new Array();
	var vNameFull = new Array();
	var vNameDp = new Array();
	var vNjuso =  new Array();
	var vJuso = new Array();
	var vRdNm = new Array();
	var vZipCl = new Array();
	var vNcode = new Array();
	var vCodeName = new Array();
	
	var xpos = $("[name=xpos]");
    var ypos = $("[name=ypos]");
    var vworldNo = $("[name=vworldNo]");
    var pnu,nameFull,nameDp,juso,njuso,rdNm,zipCl,nCode,codeName;
    if(vKind == "Poi"){
	    pnu = $("[name=pnu]");
	    nameFull = $("[name=nameFull]");
	    nameDp = $("[name=nameDp]");
	    juso = $("[name=juso]");
	    njuso = $("[name=njuso]");
	    rdNm = $("[name=rdNm]");
	    zipCl = $("[name=zipCl]");
	    nCode = $("[name=nCode]");
	    codeName = $("[name=codeName]");
    }
    
    var markers;
    if(vworld.getMode() == 2){
    	$("input[name=xpos]").each(function(idx) {
	    	vx[idx] = xpos.eq(idx).val();
	    	vy[idx] = ypos.eq(idx).val();
	    	
			vNo[idx] = vworldNo.eq(idx).val();
			if(vKind == "Poi"){	
	        	vPnu[idx] = pnu.eq(idx).val();
	        	vNameFull[idx] = nameFull.eq(idx).val();
	        	vNameDp[idx] = nameDp.eq(idx).val();
	        	vJuso[idx] = juso.eq(idx).val();
	        	vNjuso[idx] = njuso.eq(idx).val();
	        	vRdNm[idx] = rdNm.eq(idx).val();
	        	vZipCl[idx] = zipCl.eq(idx).val();
	        	vNcode[idx] = nCode.eq(idx).val();
	        	vCodeName[idx] = codeName.eq(idx).val();
	    	}
			var popupContentHTML = "";
			if(vKind == "Poi"){
			    popupContentHTML += "<div class='popup_area'>";
				popupContentHTML += "<div class='titlePop'>"+vNameFull[idx]+"</div>";
				popupContentHTML += "<div class='clear'></div>";
				popupContentHTML += "<div class='contents'>";
				popupContentHTML += "<div class='detail' id='popWidth'>";
				popupContentHTML += "<table class='table'>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<th width='120'>구주소</th>";
				popupContentHTML += "<td>"+vJuso[idx]+"</td>";
				popupContentHTML += "</tr>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<th>새주소</th>";
				popupContentHTML += "<td>"+vNjuso[idx]+"</td>";
				popupContentHTML += "</tr>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<th>위치이름</th>";
				popupContentHTML += "<td>"+vNameDp[idx]+"</td>";
				popupContentHTML += "</tr>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<th>NCODE</th>";
				popupContentHTML += "<td>"+vNcode[idx]+"</td>";
				popupContentHTML += "</tr>";
				popupContentHTML += "<tr>";
				popupContentHTML += "<th>카테고리</th>";
				popupContentHTML += "<td>"+vCodeName[idx]+"</td>";
				popupContentHTML += "</tr>";
				popupContentHTML += "</table>";
				popupContentHTML += "</div>";
				popupContentHTML += "</div>";
				popupContentHTML += "</div>";
			}
		    var imgUrl = '/images/search/bul_poi_b_'+vNo[idx]+'.png';
		    
	    	mapView.mapReset();
	    	setTimeout(function(){
	    		addMarker3D(vx[idx], vy[idx], popupContentHTML, imgUrl);
	    	}, 100);
	    });
    }else{
    	apiMap.initAll();
    	markers = new OpenLayers.Layer.Markers( "Markers" );
    	 $("input[name=xpos]").each(function(idx) {
    	    	vx[idx] = xpos.eq(idx).val();
    	    	vy[idx] = ypos.eq(idx).val();
    	    	
    			vNo[idx] = vworldNo.eq(idx).val();
    			if(vKind == "Poi"){	
    	        	vPnu[idx] = pnu.eq(idx).val();
    	        	vNameFull[idx] = nameFull.eq(idx).val();
    	        	vNameDp[idx] = nameDp.eq(idx).val();
    	        	vJuso[idx] = juso.eq(idx).val();
    	        	vNjuso[idx] = njuso.eq(idx).val();
    	        	vRdNm[idx] = rdNm.eq(idx).val();
    	        	vZipCl[idx] = zipCl.eq(idx).val();
    	        	vNcode[idx] = nCode.eq(idx).val();
    	        	vCodeName[idx] = codeName.eq(idx).val();
    	    	}
    	    	
    	    	
    	    	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    			var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    			var transCod = new OpenLayers.Geometry.Point(vx[idx], vy[idx]).transform(epsg4326,epsg900913);
    	    	
    			var popupContentHTML = "";
    			if(vKind == "Poi"){
    			    popupContentHTML += "<div class='popup_area'>";
    				popupContentHTML += "<div class='titlePop'>"+vNameFull[idx]+"</div>";
    				popupContentHTML += "<div class='clear'></div>";
    				popupContentHTML += "<div class='contents'>";
    				popupContentHTML += "<div class='detail' id='popWidth'>";
    				popupContentHTML += "<table class='table'>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<th width='120'>구주소</th>";
    				popupContentHTML += "<td>"+vJuso[idx]+"</td>";
    				popupContentHTML += "</tr>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<th>새주소</th>";
    				popupContentHTML += "<td>"+vNjuso[idx]+"</td>";
    				popupContentHTML += "</tr>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<th>위치이름</th>";
    				popupContentHTML += "<td>"+vNameDp[idx]+"</td>";
    				popupContentHTML += "</tr>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<th>NCODE</th>";
    				popupContentHTML += "<td>"+vNcode[idx]+"</td>";
    				popupContentHTML += "</tr>";
    				popupContentHTML += "<tr>";
    				popupContentHTML += "<th>카테고리</th>";
    				popupContentHTML += "<td>"+vCodeName[idx]+"</td>";
    				popupContentHTML += "</tr>";
    				popupContentHTML += "</table>";
    				popupContentHTML += "</div>";
    				popupContentHTML += "</div>";
    				popupContentHTML += "</div>";
    			}
    		    var imgUrl = '/images/search/bul_poi_b_'+vNo[idx]+'.png';
    		    
		    	addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
				markers.addMarker(marker);
    	    });
    	 apiMap.zoomToExtent(markers.getDataExtent());
    	 
    }
   
}

/**
 * 검색 api 개별지도 이동
 * @param cnt
 * @param pnu
 * @param nameFull
 * @param nameDp
 * @param juso
 * @param nJuso
 * @param rdNm
 * @param zipCl
 * @param ncode
 * @param codeName
 * @param ypos
 * @param xpos
 * @param vKind
 */
function vSearchMove(cnt,pnu,nameFull,nameDp,juso,nJuso,rdNm,zipCl,ncode,codeName,ypos,xpos,vKind){
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    var transCod = new OpenLayers.Geometry.Point(xpos, ypos).transform(epsg4326,epsg900913);
    
    var popupContentHTML = "";
    if(vKind == "Poi"){
    	popupContentHTML += "<div class='popup_area'>";
    	popupContentHTML += "<div class='titlePop'>"+nameFull+"</div>";
    	popupContentHTML += "<div class='clear'></div>";
    	popupContentHTML += "<div class='contents'>";
    	popupContentHTML += "<div class='detail' id='popWidth'>";
    	popupContentHTML += "<table class='table'>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th width='120'>구주소</th>";
    	popupContentHTML += "<td>"+juso+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>새주소</th>";
    	popupContentHTML += "<td>"+nJuso+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>위치이름</th>";
    	popupContentHTML += "<td>"+nameDp+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>NCODE</th>";
    	popupContentHTML += "<td>"+ncode+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>카테고리</th>";
    	popupContentHTML += "<td>"+codeName+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "</table>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    }
		
    var imgUrl = '/images/search/bul_poi_b_'+cnt+'.png';
    
    
    if(vworld.getMode() == 2){
    	mapView.mapReset();
    	
    	addMarker3D(xpos, ypos, popupContentHTML, imgUrl);
    }else{
    	apiMap.initAll();
    	addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
	    var markers = new OpenLayers.Layer.Markers( "Markers" );
		markers.addMarker(marker);
		apiMap.zoomToExtent(markers.getDataExtent());
    }
}

/**
 * 네이버 검색 호출
 */
function nLocal(){
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/nLocal.do",
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	$('#westDiv').html(response);   
	    },
	    beforeSend: function() {
	    	$('#ajax_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#ajax_indicator').fadeOut();
	    }
	});
}

/**
 * 네이버 검색 리스트
 * @param index
 * @returns {Boolean}
 */
function nLocalL(index){
	storeIndex = index;
	var pageIndex = index;
	if(pageIndex == null){
		pageIndex = 1;
	}	
	var nNm = $("#vNm").val();
	alert(nNm);
	var params="nNm="+nNm+"&pageIndex="+pageIndex;  
	if(nNm == null || nNm==""){
		alert("검색명을 입력해 주세요.");		
		return false;
	}else{
		$.ajax({
		    type : "POST",
		    async : true,
		    url : "/nLocalL.do",
		    data : params,
		    dataType : "html",
		    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    error : function(request, status, error) {
		    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
		    },
		    success : function(response, status, request) {
		    	$('#westResult').html(response); 
		    	nSearchLmove();
		    },
		    beforeSend: function() {
		    	$('#west_indicator').show().fadeIn('fast');
		    },
		    complete: function() {
		    	$('#west_indicator').fadeOut();
		    }
		});
	}
}

/**
 * 네이버 검색리스트 이동
 */
function nSearchLmove(){
	
	var nx = new Array();
	var ny = new Array();
	var nNo = new Array();
	var nTitle = new Array();
	var nAddress = new Array();
	var nDescript = new Array();
	var nLink = new Array();
	var nTel = new Array();
	var nRoadAddr = new Array();
	var nCategory = new Array();
	
	var naverX = $("[name=nX]");
    var naverY = $("[name=nY]");
    var naverNo = $("[name=nNo]");
    var title = $("[name=title]");
    var address = $("[name=address]");
    var description = $("[name=description]");
    var link = $("[name=link]");
    var telephone = $("[name=telephone]");
    var roadAddress = $("[name=roadAddress]");
    var category = $("[name=category]");
    
    var markers;
    
    if(vworld.getMode() == 2){
    	$("input[name=nX]").each(function(idx) {
        	nx[idx] = naverX.eq(idx).val();
        	ny[idx] = naverY.eq(idx).val();
        	nNo[idx] = naverNo.eq(idx).val();
        	nTitle[idx] = title.eq(idx).val();
        	nAddress[idx] = address.eq(idx).val();
        	nDescript[idx] = description.eq(idx).val();
        	nLink[idx] = link.eq(idx).val();
        	nTel[idx] = telephone.eq(idx).val();
        	nRoadAddr[idx] = roadAddress.eq(idx).val();
        	nCategory[idx] = category.eq(idx).val();
        	
        	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    		var transCod = new OpenLayers.Geometry.Point(nx[idx], ny[idx]).transform(epsg4326,epsg900913);
        	
    		var popupContentHTML = "";
        	popupContentHTML += "<div class='popup_area'>";
        	popupContentHTML += "<div class='titlePop'>"+nTitle[idx]+"</div>";
        	popupContentHTML += "<div class='clear'></div>";
        	popupContentHTML += "<div class='contents'>";
        	popupContentHTML += "<div class='detail' id='popWidth'>";
        	popupContentHTML += "<table class='table'>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th width='120'>구주소</th>";
        	popupContentHTML += "<td>"+nAddress[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>새주소</th>";
        	popupContentHTML += "<td>"+nRoadAddr[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>설명</th>";
        	popupContentHTML += "<td>"+nDescript[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>전화번호</th>";
        	popupContentHTML += "<td>"+nTel[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>카테고리</th>";
        	popupContentHTML += "<td>"+nCategory[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>홈페이지</th>";
        	popupContentHTML += "<td><a herf=# onclick=hpLink('"+nLink[idx]+"')>사이트이동</a></td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "</table>";
        	popupContentHTML += "</div>";
        	popupContentHTML += "</div>";
        	popupContentHTML += "</div>";
        	
    	    var imgUrl = '/images/search/bul_poi_b_'+nNo[idx]+'.png';
    	    mapView.mapReset();
	    	setTimeout(function(){
	    		addMarker3D(nx[idx], ny[idx], popupContentHTML, imgUrl);
	    	}, 100);
        });
    }else{
    	apiMap.initAll();
    	markers = new OpenLayers.Layer.Markers( "Markers" );
    	$("input[name=nX]").each(function(idx) {
        	nx[idx] = naverX.eq(idx).val();
        	ny[idx] = naverY.eq(idx).val();
        	nNo[idx] = naverNo.eq(idx).val();
        	nTitle[idx] = title.eq(idx).val();
        	nAddress[idx] = address.eq(idx).val();
        	nDescript[idx] = description.eq(idx).val();
        	nLink[idx] = link.eq(idx).val();
        	nTel[idx] = telephone.eq(idx).val();
        	nRoadAddr[idx] = roadAddress.eq(idx).val();
        	nCategory[idx] = category.eq(idx).val();
        	
        	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    		var transCod = new OpenLayers.Geometry.Point(nx[idx], ny[idx]).transform(epsg4326,epsg900913);
        	
    		var popupContentHTML = "";
        	popupContentHTML += "<div class='popup_area'>";
        	popupContentHTML += "<div class='titlePop'>"+nTitle[idx]+"</div>";
        	popupContentHTML += "<div class='clear'></div>";
        	popupContentHTML += "<div class='contents'>";
        	popupContentHTML += "<div class='detail' id='popWidth'>";
        	popupContentHTML += "<table class='table'>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th width='120'>구주소</th>";
        	popupContentHTML += "<td>"+nAddress[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>새주소</th>";
        	popupContentHTML += "<td>"+nRoadAddr[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>설명</th>";
        	popupContentHTML += "<td>"+nDescript[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>전화번호</th>";
        	popupContentHTML += "<td>"+nTel[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>카테고리</th>";
        	popupContentHTML += "<td>"+nCategory[idx]+"</td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "<tr>";
        	popupContentHTML += "<th>홈페이지</th>";
        	popupContentHTML += "<td><a herf=# onclick=hpLink('"+nLink[idx]+"')>사이트이동</a></td>";
        	popupContentHTML += "</tr>";
        	popupContentHTML += "</table>";
        	popupContentHTML += "</div>";
        	popupContentHTML += "</div>";
        	popupContentHTML += "</div>";
        	
    	    var imgUrl = '/images/search/bul_poi_b_'+nNo[idx]+'.png';
    	    addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
    		markers.addMarker(marker);
        });
        apiMap.zoomToExtent(markers.getDataExtent());
    }
    
    
}

/**
 * 네이버 개별 지도이동
 * @param title
 * @param cnt
 * @param address
 * @param description
 * @param link
 * @param telephone
 * @param roadAddress
 * @param category
 */
function nLocalMove(title,cnt,address,description,link,telephone,roadAddress,category){
	
	var nx = new Array();
	var ny = new Array();
	
	nx[cnt-1] = $("[name=nX]").eq(cnt-1).val();
	ny[cnt-1] = $("[name=nY]").eq(cnt-1).val();
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
	var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	
	var transCod = new OpenLayers.Geometry.Point(nx[cnt-1], ny[cnt-1]).transform(epsg4326,epsg900913);
	
	var popupContentHTML = "";
    	popupContentHTML += "<div class='popup_area'>";
    	popupContentHTML += "<div class='titlePop'>"+title+"</div>";
    	popupContentHTML += "<div class='clear'></div>";
    	popupContentHTML += "<div class='contents'>";
    	popupContentHTML += "<div class='detail' id='popWidth'>";
    	popupContentHTML += "<table class='table'>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th width='120'>구주소</th>";  
    	popupContentHTML += "<td>"+address+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>새주소</th>";
    	popupContentHTML += "<td>"+roadAddress+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>설명</th>";
    	popupContentHTML += "<td>"+description+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>전화번호</th>";
    	popupContentHTML += "<td>"+telephone+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>카테고리</th>";
    	popupContentHTML += "<td>"+category+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>홈페이지</th>";
    	popupContentHTML += "<td><a herf=# onclick=hpLink('"+link+"')>사이트이동</a></td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "</table>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    
    var imgUrl = '/images/search/bul_poi_b_'+cnt+'.png';
    
    if(vworld.getMode() == 2){
    	mapView.mapReset();
    	addMarker3D(nx[cnt-1], ny[cnt-1], popupContentHTML, imgUrl);
    }else{
    	apiMap.initAll();
    	addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
	    var markers = new OpenLayers.Layer.Markers( "Markers" );
		markers.addMarker(marker);
		apiMap.zoomToExtent(markers.getDataExtent());
    }
    
}

/**
 * 마커 표출
 * @param lon
 * @param lat
 * @param message
 * @param imgurl
 */
function addMarker(lon, lat, message, imgurl){
	
	marker = new vworld.Marker(lon, lat,message,"");
	
	// 마커 아이콘 이미지 파일명 설정합니다.
	if (typeof imgurl == 'string') {marker.setIconImage(imgurl);}
	
	//마커이미지 이벤트 id
	var size = marker.events.element.id.toString();
	
	//마커이미지 이벤트 id + _innerImage = 마커이미지 아이디
	size = size + '_innerImage';
	
	// 마커의 z-Index 설정
	marker.setZindex(3);
	apiMap.addMarker(marker);
	
	var markerImg = $('#'+size);//document.getElementById(size);
	markerImg.width(50);
	markerImg.height(50);//style.height = "60px";
}

/**
 * 3D 마커 생성
 */
function addMarker3D(lon, lat, message, imgurl){
	var imgCount = 'http://localhost:8080'+imgurl+'';
	if(apiMap3D != null){
		apiMap3D.getUserLayer().removeAll();
		apiMap3D.getViewCamera().moveLonLat(lon,lat);
		apiMap3D.getViewCamera().setAltitude(500);
		var vec4=apiMap3D.createVec3();
		var poi = apiMap3D.createPoint('999');
		vec4.Longitude = lon;
		vec4.Latitude = lat;
		vec4.Altitude = 0;
		poi.Set(vec4);
		var sym=poi.getSymbol();
		console.log(11);
		var icon=sym.getIcon();
		console.log(22);
		icon.setNormalIcon(imgCount);
		console.log(33);
		sym.setIcon(icon);
		console.log(44);
		poi.setSymbol(sym);
		console.log(55);
		poi.setDescription(message);
		console.log(66);
		apiMap3D.getView().addChild(poi,8);
		window.sop.earth.addEventListener(poi, "lmouseup", map3DBalloon);
	}
}

/**
 * 3D 말풍선
 * @param event
 */
function map3DBalloon(event){
	if(apiMap3D != null){
		apiMap3D.closeBalloon();
		var balloon = apiMap3D.createHtmlBalloon();
		balloon.setTarget(event.getTarget());
		balloon.setCloseButton(true);
		balloon.setHtmlString(event.getTarget().getDescription());
		balloon.setWidth_(340);
		balloon.setHeight_(315);
		balloon.show_(true);
		apiMap3D.setBalloon(balloon, true);
	}
}

/**
 * 데이터API 레이어 결정 
 * @param wfsFindLayer
 */
function getWfsFindLayer(wfsFindLayer){
  	findLayerName = wfsFindLayer;
}

/**
 * 데이터API 이벤트 등록 및 활성화
 */
function getWfsValue(control){
	dataControl = control;
	if(vworld.getMode() == 2){
		if(dataControl == "info"){
			if(findLayerName == 'spbd'){
				window.sop.earth.addEventListener(apiMap3D, "lmouseup", bldgCall);
			}else{
				window.sop.earth.addEventListener(apiMap3D, "lmouseup", getWfsclick);
			}
			
		}else{
			alert("지원하지 않는 분석입니다.");
		}
	}else{
		apiMap.init();
		pClickControl = null;
		var pointOptions = {persist:true};
		var lineOptions = {persist:true};
		var polygonOptions = {persist:true};
		var radiusOptions = {persist:true,sides:50};
		if(findLayerName == 'spbd'){
			if(dataControl == "polygon" || dataControl == "radius" || dataControl == "line" || dataControl == "buffer"){
				alert("지원하지 않는 공간분석입니다.");
				return;
			}
		}
		if(dataControl == "polygon"){
			if (pClickControl == null) {
				pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Polygon,{handlerOptions:polygonOptions});
				pClickControl.events.on({"measure": getWfsclick});
		    	apiMap.addControl(pClickControl);
			}  
		}else if(dataControl == "radius"){
			if (pClickControl == null) {
				pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.RegularPolygon,{handlerOptions:radiusOptions});
				pClickControl.events.on({"measure": getWfsclick});
		    	apiMap.addControl(pClickControl);
			} 
		}else if(dataControl == "line"){
			if (pClickControl == null) {
				pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Path,{handlerOptions:lineOptions, partialDelay:100});
				pClickControl.events.on({"measure": getWfsclick});
		    	apiMap.addControl(pClickControl);
			} 
		}else if(dataControl == "info"){
			if (pClickControl == null) {
				pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
				pClickControl.events.on({"measure": getWfsclick});
		    	apiMap.addControl(pClickControl);
			} 
		}else if(dataControl == "buffer"){
			if (pClickControl == null) {
				pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
				pClickControl.events.on({"measure": getWfsclick});
		    	apiMap.addControl(pClickControl);
			} 
		}
		pClickControl.activate();
	}
}

/**
 * 3d 건축물대장
 * @param evt
 */
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

/**
 * 모델 하이라이트
 * @param map3DEventLast
 */
function setSetSelectObject(map3DEventLast){
	if(map3DEventLast.getTargetLayer().getName() != "UserLayer"){
		var col=apiMap3D.createColor();
		col.setARGB(125, 255, 255, 0);
		mapView.setSelectColor(col);
		mapView.setSelectObject(map3DEventLast.getTarget());
	}		
}

/**
 * bounds 생성
 * @param bounds
 */
function createBounds(bounds){ // 해당 폴리곤 객체의 Boundary를 표시하기 위한 사각형 폴리곤 그리기 
	var points = [];
	points.push(new OpenLayers.Geometry.Point(bounds.left, bounds.top)); 
	points.push(new OpenLayers.Geometry.Point(bounds.right, bounds.top)); 
	points.push(new OpenLayers.Geometry.Point(bounds.right, bounds.bottom)); 
	points.push(new OpenLayers.Geometry.Point(bounds.left, bounds.bottom)); 
	
	var style = {strokeColor: "#00FF00", fillColor: "#00FF00", strokeOpacity: 1, fillOpacity:0.1, strokeWidth: 2}; 
	var poly = new vworld.Polygon(points, style);
	
	apiMap.vectorLayer.addFeatures([poly]);
}

/**
 * 건축물대장호출
 * @param response
 */
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

/**
 * 데이터API 정보 조회
 * @param evt
 */
var Circle = null;
var tCircle;
function getWfsclick(evt){
	
	if(findLayerName == 'undefined' || findLayerName == '' || findLayerName == null ){
		alert("검색 할 레이어를 선택하시오.");
		return false;
	}
	
	if(vworld.getMode() == 2){
		mapView.mapReset();
		window.sop.earth.removeEventListener(apiMap3D, "lmouseup", getWfsclick);
		getWfsPoints = evt.getMapCoordinate();
	}else{
		getWfsPoints = evt;
		var lineFeature = new OpenLayers.Feature.Vector(getWfsPoints.geometry.clone());
		lineFeature.style = sketchSymbolizers['Polygon'];
		apiMap.vectorLayer.addFeatures([lineFeature]);
		
		if(findLayerName == 'spbd'){
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
	        return;
		}
		
		var radius = document.getElementById("cRadius").value;
		
		if(radius != ""){
		} else {
			radius = 1000;
		}
		
		if(dataControl == "buffer"){
			Circle = new vworld.Circle({x:getWfsPoints.geometry.x, y:getWfsPoints.geometry.y}, radius, selFeature);
			tCircle = Circle.getFeatureById(Circle.id);
			
			createBounds(tCircle.getBounds());
		}
	}
	
	var params = "";
	params += "apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17";
	if(dataControl == "buffer"){
		params += "&geometry=BBOX("+tCircle.getBounds()+")" ;
	}else{
		if(vworld.getMode() == 2){
			params += "&geometry=POINT("+getWfsPoints.Longitude+" "+getWfsPoints.Latitude+")";
		}else{
			params += "&geometry=" + getWfsPoints.geometry;
		}
		
	}
	
	params += "&pageIndex=" + pageInfo.pageIndex;
	params += "&pageUnit=" + pageInfo.pageUnit;
	params += "&domain=localhost:8080";
	params += "&output=json";
	if(vworld.getMode() == 2){
		params += "&srsName=EPSG:4326";
	}else{
		params += "&srsName=EPSG:900913";
	}
	
	params += "&layerUrl="+findLayerName+"/data";
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/vData.do",
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

/**
 * 데이터API 결과값 출력
 * @param count
 */
function getWfsList(count){
	
	var groupid	= 0;
	var content = "";
	apiMap.vectorLayer.addFeatures(vworldInfo.group[groupid].features);
	
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
	
	pClickControl.deactivate();
}

/**
 * 데이터 API 상세조회 
 * @param groupid
 * @param idx
 * @param fid
 */
function drawFeature(groupid, idx, fid){
	closeLayout();
	
	// 이전에 선택한 피처 원래 style로 변경
	var selectedFeat = apiMap.vectorLayer.getFeatureById(preFeatId);//vmap.vectorLayer.getFeatureById(preFeatId);
	if (selectedFeat){
		selectedFeat.style = searchFeature;
		apiMap.vectorLayer.addFeatures([selectedFeat]);
	}
	
	var	feature;
	if(vworldInfo.group){
		feature = vworldInfo.group[groupid].features[idx];
	
	
		if(findLayerName == 'moctnode'){
			feature.style = selFeatureP;
		}else{
			feature.style = selFeature;
		}
		
		apiMap.vectorLayer.addFeatures([feature]);
		
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
			content += "<div class='detail' id='popWidth'>";
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
			content += "<div class='detail' id='popWidth'>";
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
			content += "<div class='detail' id='popWidth'>";
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
			content += "<div class='detail' id='popWidth'>";
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
		apiMap.zoomToExtent(bounds);
		$('#vDataResult').html(content); 
	
	}else{
		alert("검색 영역이 취소 되어 위치를 파악 할 수 없습니다.");
	}
	
}

function closeLayout(){
	myInnerLayout.hide('south');
	
	apiMap.updateSize();
}

/**
 * 데이터 API 페이징
 * @param jsfunc
 * @returns {String}
 */
function jsPagination(jsfunc)
{
	var content = "";
	pageBlock	= parseInt((pageInfo.pageIndex-1) / pageInfo.pageSize);
	pageStart	= (pageBlock * pageInfo.pageSize) + 1;
	pageEnd		= (pageBlock * pageInfo.pageSize) + pageInfo.pageSize;
	preBlock	= (pageStart - 1) < 1 ? 0 : pageStart - 1;
	nextBlock	= (pageEnd + 1) > pageInfo.totalPage ? 0 : pageEnd + 1;

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

/**
 * 페이징을 이용한 조회
 * @param index
 */
function jsPage(index){
	apiMap.vectorLayer.removeFeatures(vworldInfo.group[0].features);
	pageInfo.pageIndex = index;
    getWfsclick(getWfsPoints);
}

/**
 * 로드뷰 이벤트 활성화
 */
var chkEvt = true;
function roadViewStart(){
	if(vworld.getMode() == 2){
		if(chkEvt == true){
			window.sop.earth.addEventListener(apiMap3D, "lmouseup", roadMapclick);
			chkEvt = false;
		}else{
			myInnerLayout.hide('east');
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
			 myInnerLayout.hide('east');
			 chkEvt = true;
		 }
	} 
}

/**
 * 로드뷰 시작 이벤트
 * @param evt
 */
function roadMapclick(evt){
	
	myInnerLayout.toggle('east');
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
	    url : "/dRoadView.do",
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

/**
 * 로드뷰 이동 이벤트
 * @param dRvY
 * @param dRvX
 * @param dRvPoint
 */
function rvMove(dRvX, dRvY, dRvPoint){
	
	if(vworld.getMode() == 2){
		apiMap3D.getViewCamera().moveLonLatAlt(dRvX,dRvY,200);
		apiMap3D.getViewCamera().setTilt(180);
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


/**
 * 숫자 정리
 * @param num
 * @returns
 */
function numchk(num){
	var sign="";
	if(isNaN(num)) {
		alert("숫자만 입력할 수 있습니다");
		return 0;
	}
	if(num==0){ return num; }
	if(num<0){
		num=num*(-1);
		sign="-";
	}else num=num*1;
	num = new String(num);
	var temp="";
	var pos=3;
	num_len=num.length;
	while (num_len>0){
		num_len=num_len-pos;
		if(num_len<0) {
			pos=num_len+pos;
			num_len=0;
		}
		temp=","+num.substr(num_len,pos)+temp;
	}
	return sign+temp.substr(1);
}

/**
 * 홈페이지 링크
 * @param link
 * @returns {Boolean}
 */
function hpLink(link){
	  if(link == undefined || link == ""){
		  alert("홈페이지가 없습니다.");
		  return false;
	  }else{
		  window.open(""+link+"", "링크"); 
	  }
	  
}