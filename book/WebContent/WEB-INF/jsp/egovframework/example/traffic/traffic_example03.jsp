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
<link rel="stylesheet" href="/css/popup.css" type="text/css" media="screen" />
<link rel="stylesheet" href="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.css" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script src="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript">
var apiMap3D;
var map3DLayerList;
var mapView;
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
	
	vworld.showMode = false; 
	vworld.init("vMap", "earth-first", 
		function() {        
		}
		,function (obj){
			apiMap3D = obj;
			map3DLayerList = apiMap3D.getLayerList();
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
	if(layerName == "NCCTVIts"){
		if(isCheck){
			mapView.mapReset();
			getCctv('its');
		}else{
			mapView.mapReset();
		}
	}else if(layerName == "NCCTVEx"){
		if(isCheck){
			mapView.mapReset();
			getCctv('ex');
		}else{
			mapView.mapReset();
		}
	}else if(layerName == "NEventIdentityIts"){
		if(isCheck){
			mapView.mapReset();
			getNEventId('its');
		}else{
			mapView.mapReset();
		}
	}else if(layerName == "NEventIdentityEx"){
		if(isCheck){
			mapView.mapReset();
			getNEventId('ex');
		}else{
			mapView.mapReset();
		}
	}else if(layerName == "RseIncidentInfo"){
		if(isCheck){
			mapView.mapReset();
			getIncident();
		}else{
			mapView.mapReset();
		}
	}
}

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
	    	
	    	for(var i=0;i<data.length;i++){
	    		cctvtype[i] = data[i].getElementsByTagName('cctvtype')[0].firstChild.nodeValue;
	    		cctvurl[i] = data[i].getElementsByTagName('cctvurl')[0].firstChild.nodeValue;
	    		coordy[i] = data[i].getElementsByTagName('coordy')[0].firstChild.nodeValue;
	    		coordx[i] = data[i].getElementsByTagName('coordx')[0].firstChild.nodeValue;
	    		cctvformat[i] = data[i].getElementsByTagName('cctvformat')[0].firstChild.nodeValue;
	    		cctvname[i] = data[i].getElementsByTagName('cctvname')[0].firstChild.nodeValue;
	    		
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
	    			
	    	    var imgUrl = "http://map.vworld.krhttp://localhost:8080/images/symbol/ico_cctv_dark_small.png";
	    	    
	    	    layerMarker3D('cctv', coordx[i], coordy[i], popupContentHTML, imgUrl);
	    	    
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
		    		
		    		var popupContentHTML = "";
		    		    popupContentHTML += "<div class='popup_area'>";
		    			popupContentHTML += "<div class='titlePop'>"+eventid[i]+"</div>";
		    			popupContentHTML += "<div class='clear'></div>";
		    			popupContentHTML += "<div class='contents'>";
		    			popupContentHTML += "<div class='detail'>";
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
		    			
		    	    var imgUrl = "http://localhost:8080/images/icon_construction.png";
		    	    layerMarker3D('NEventIdentity', coordx[i], coordy[i], popupContentHTML, imgUrl);
		    	    
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
		    	groupMarker = new vworld.GroupMarker('RseIncidentInfo');
		    	
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
		    		
		    		var popupContentHTML = "";
		    		    popupContentHTML += "<div class='popup_area'>";
		    			popupContentHTML += "<div class='titlePop'>"+routename[i]+"</div>";
		    			popupContentHTML += "<div class='clear'></div>";
		    			popupContentHTML += "<div class='contents'>";
		    			popupContentHTML += "<div class='detail'>";
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
		    			
		    	    var imgUrl = "http://localhost:8080/images/icon_trafficmap_accident.png";
		    	    
		    	    layerMarker3D('RseIncidentInfo', coordx[i], coordy[i], popupContentHTML, imgUrl);
		    	    
		    	}
	    	}else{
	    		alert("교통안전도우미 정보가 없습니다.");
	    	}
	    }
	});
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
</script>
</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="vMap" style="width:100%;height:100%"></div>
</div>
<div class="ui-layout-east">
	<ul id="tree">
		<li>
			<strong>교통정보</strong>
			<ul>
				<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NEventIdentityIts" value="NEventIdentityIts" onclick="reloadLayers(this.value,this.checked)">공사정보(국도)</li>
				<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NEventIdentityEx" value="NEventIdentityEx" onclick="reloadLayers(this.value,this.checked)">공사정보(고속도로)</li>
				<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NCCTVIts" value="NCCTVIts" onclick="reloadLayers(this.value,this.checked)">CCTV(국도)</li>
				<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NCCTVEx" value="NCCTVEx" onclick="reloadLayers(this.value,this.checked)">CCTV(고속도로)</li>
				<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="RseIncidentInfo" value="RseIncidentInfo" onclick="reloadLayers(this.value,this.checked)">교통안전도우미</li>
			</ul>
		</li>
	</ul>
</div>
</body>
</html>