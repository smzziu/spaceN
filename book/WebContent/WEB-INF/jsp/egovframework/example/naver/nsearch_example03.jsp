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
<title>3차원지도에 마커로 표시하기</title>
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
	vworld.init("vMap", "earth-first", 
		function() {        
		},
		function (obj){
			apiMap3D = obj;
			map3DLayerList = apiMap3D.getLayerList();
			mapView = apiMap3D.getView();	
		}
		,function (msg){alert('oh my god');}
	);
	
}); 

function nLocalL(index){
	var pageIndex = index;
	if(pageIndex == null){
		pageIndex = 1;
	}	
	var nNm = $("#nNm").val();
	var params="nNm="+nNm+"&pageIndex="+pageIndex;  
	if(nNm == null || nNm==""){
		alert("검색명을 입력해 주세요.");		
		return false;
	}else{
		$.ajax({
		    type : "POST",
		    async : true,
		    url : "/nsearch_example03_1.do",
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
		    	nSearchLmove();
		    },
		    complete: function() {
		    	$('#west_indicator').fadeOut();
		    }
		});
	}
}

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
}

function nLocalMove(title,cnt,address,description,link,telephone,roadAddress,category){
	
	var nx = new Array();
	var ny = new Array();
	
	nx[cnt-1] = $("[name=nX]").eq(cnt-1).val();
	ny[cnt-1] = $("[name=nY]").eq(cnt-1).val();
	
	var popupContentHTML = "";
    	popupContentHTML += "<div class='popup_area'>";
    	popupContentHTML += "<div class='titlePop'>"+title+"</div>";
    	popupContentHTML += "<div class='clear'></div>";
    	popupContentHTML += "<div class='contents'>";
    	popupContentHTML += "<div class='detail'>";
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
    console.log(popupContentHTML);
    alert(popupContentHTML);
    mapView.mapReset();
	addMarker3D(nx[cnt-1], ny[cnt-1], popupContentHTML, imgUrl);
	
}

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
		poi.set(vec4);
		var sym=poi.getSymbol();
		var icon=sym.getIcon();
		icon.setNormalIcon(imgCount);
		sym.setIcon(icon);
		poi.setSymbol(sym);
		poi.setDescription(message);
		//poi.setDescription("test");
		apiMap3D.getView().addChild(poi,8);
		window.sop.earth.addEventListener(poi, "lmouseup", map3DBalloon);
	}
}

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
<div class="ui-layout-west">
	<div id="westDiv">
		<div class="search_terms">
			<div class="search_title">
				<img src="/images/search/searchicon_white.png" alt="" class="searchicon_white"/>
				네이버
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
							<input type="text" id="nNm" class="terms_input" name="nNm" value="" onkeypress="if (event.keyCode==13){ javascript:nLocalL();};"/>
							</li>
						</ul>
						<div class="search_btn">
							<a href="javascript:nLocalL();"><img src="/images/search/search_btn.png" alt="" /></a>
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
						<div id="west_indicator" style="display:none">
							로딩중...
						</div>
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