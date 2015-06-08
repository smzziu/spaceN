<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String vMapKey = (String)request.getAttribute("vMapKey");
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>이차원지도에 마커로 표시하기</title>
<link rel="stylesheet" href="/css/ui/left_search.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/css/popup.css" type="text/css" media="screen" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript">

var apiMap;

$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true
 		, 	west__size:			273
 		,	west__initClosed:	false
 		,	west__initHidden:	false
 		,	center__size:		"auto"
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
	
}); 

function vSearchL(index){
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
		    url : "/vsearch_example02_1.do",
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

function vSearchLmove(kind){
	
	apiMap.initAll();
	
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
    var markers = new OpenLayers.Layer.Markers( "Markers" );
    
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
			popupContentHTML += "<div class='detail'>";
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

function vSearchMove(cnt,pnu,nameFull,nameDp,juso,nJuso,rdNm,zipCl,ncode,codeName,ypos,xpos,vKind){
	
	apiMap.initAll();
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    var transCod = new OpenLayers.Geometry.Point(xpos, ypos).transform(epsg4326,epsg900913);
    
    var popupContentHTML = "";
    if(vKind == "Poi"){
    	popupContentHTML += "<div class='popup_area'>";
    	popupContentHTML += "<div class='titlePop'>"+nameFull+"</div>";
    	popupContentHTML += "<div class='clear'></div>";
    	popupContentHTML += "<div class='contents'>";
    	popupContentHTML += "<div class='detail'>";
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
    
    addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
    
    var markers = new OpenLayers.Layer.Markers( "Markers" );
	markers.addMarker(marker);
	apiMap.zoomToExtent(markers.getDataExtent());
}

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
	
	var markerImg = $('#'+size);
	markerImg.width(50);
	markerImg.height(50);
}


</script>

</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="vMap" style="width:100%;height:100%"></div>
</div>
<div class="ui-layout-west">
	<div id="westDiv">
		<div id="ajax_indicator" style="display:none">
			로딩중...
		</div>
		<div class="search_terms">
			<div class="search_title"> 
				<img src="/images/search/searchicon_white.png" alt="" class="searchicon_white"/>
				<select id="vCategory">
					<option value="Poi">명칭</option>
					<option value="Jibun">지번</option>
					<option value="Juso">도로명</option>
				</select>
			</div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="terms_box">
				<tr>
					<td><img src="/images/search/terms_box_top.png" class="term_box_top" alt="" /></td>
				</tr>
				<tr>
					<td class="terms_box_middle">
						<ul>
							<li><img src="/images/search/list-st.png" alt="" class="list-st"/>검색어 :
								<span style="padding:0 0 0 4px;"></span>
								<input type="text" id="vNm" class="terms_input" name="vNm" value="" onkeypress="if (event.keyCode==13){ javascript:vSearchL();};"/>
							</li>
						</ul>
						<div class="search_btn">
							<a href="javascript:vSearchL();"><img src="/images/search/search_btn.png" alt="" /></a>
						</div>
					</td>
				</tr>
			</table>
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
								<td>검색결과가 없습니다.</td>								
							</tr>																	
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>