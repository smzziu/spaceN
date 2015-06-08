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
<title>교통지도</title>
<link rel="stylesheet" href="/css/ui/button.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/gis.css" type="text/css"/> 
<link rel="stylesheet" href="/css/ui/layer.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/map_skin1.css" type="text/css"/> 
<link rel="stylesheet" href="/css/ui/paginate.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/header.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/footer.css" type="text/css"/>
<link rel="stylesheet" href="/css/ui/left_search.css" type="text/css" media="screen" />
<link rel="stylesheet" href="/css/ui/footer-rightbox.css" type="text/css"/>
<link rel="stylesheet" href="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.css" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery-latest.js" type="text/javascript"></script>
<script src="http://layout.jquery-dev.com/lib/js/jquery.layout-latest.js" type="text/javascript"></script>
<script src="http://jquery-plugins.bassistance.de/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=<%=vMapKey %>"></script>
<script type="text/javascript" src="/js/map/vMap.js"></script>
<!-- <script src="http://27.101.53.53:8092/daumProxy.jsp"></script> -->
<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=<%=dMapkey %>"></script>

<script type="text/javascript">
var roadWidth;
var roadHeight;
$(document).ready(function() {
	myLayout = $('body').layout({
		applyDemoStyles : true,
	 	north__size:		"auto"
 		,	north__initClosed:	false
 		,	north__initHidden:	false
 		, 	west__size:			273
 		,	west__initClosed:	false
 		,	west__initHidden:	false
 		,	east__size:			300
 		,	east__initClosed:	true
 		,	east__initHidden:	false
 		,	center__size:		"auto"
	});
	
	
	$(window).bind('resize', function(e)
	{
	    window.resizeEvt;
	    $(window).resize(function()
	    {
	        clearTimeout(window.resizeEvt);
	        window.resizeEvt = setTimeout(function()
	        {
	        	var width = $('#innerLayoutCenter').width();
	        	var height = $('#innerLayoutCenter').height();
	    		$('#vMap').width(width);
	    		$('#vMap').height(height);
	    		apiMap.updateSize();
	        }, 250);
	    });
	});


	
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


/**
 * 토글 테스트
 */
function eastLayerOut(){	
	
	myLayout.toggle('east');
	
	apiMap.updateSize();
}

function resizeCenter(){
	apiMap.updateSize();
}

function apiMapRest(){
	if(vworld.getMode() == 2){
		mapView.mapReset();
		$("input:radio[name='exLayerInfo']").removeAttr("checked");
	}else{
		apiMap.initAll();
	}
}
</script>
</head>
<body>
<div id="innerLayout" class="ui-layout-center">
	<div id="innerLayoutCenter" class="ui-layout-center">
		<div id="vMap" style="width:100%;height:100%"></div>
		<div id="dataDiv" style="display:none"></div>
	</div>
	<div class="ui-layout-east" id="dRoadview">
		
	</div>
	<div class="ui-layout-south" id="vDataResult">
		
	</div>
</div>
<div class="ui-layout-east">
	<ul id="tree">
		<li><strong>교통정보</strong>
			
				<ul>
					<div id="layer2D" style="display:none;">
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="NTrafficInfo" value="NTrafficInfo" onclick="reloadLayers(this.value,this.checked)">소통정보</li>
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="NEventIdentityIts" value="NEventIdentityIts" onclick="reloadLayers(this.value,this.checked)">공사정보(국도)</li>
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="NEventIdentityEx" value="NEventIdentityEx" onclick="reloadLayers(this.value,this.checked)">공사정보(고속도로)</li>
						<li>사고정보</li>
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="NCCTVIts" value="NCCTVIts" onclick="reloadLayers(this.value,this.checked)">CCTV(국도)</li>
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="NCCTVEx" value="NCCTVEx" onclick="reloadLayers(this.value,this.checked)">CCTV(고속도로)</li>
						<li>&nbsp;<input type="checkbox" unchecked name="exLayerInfo" id="RseIncidentInfo" value="RseIncidentInfo" onclick="reloadLayers(this.value,this.checked)">교통안전도우미</li>
					</div>
					<div id="layer3D">
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NTrafficInfo" value="NTrafficInfo" onclick="reloadLayers(this.value,this.checked)">소통정보</li>
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NEventIdentityIts" value="NEventIdentityIts" onclick="reloadLayers(this.value,this.checked)">공사정보(국도)</li>
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NEventIdentityEx" value="NEventIdentityEx" onclick="reloadLayers(this.value,this.checked)">공사정보(고속도로)</li>
						<li>사고정보</li>
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NCCTVIts" value="NCCTVIts" onclick="reloadLayers(this.value,this.checked)">CCTV(국도)</li>
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="NCCTVEx" value="NCCTVEx" onclick="reloadLayers(this.value,this.checked)">CCTV(고속도로)</li>
						<li>&nbsp;<input type="radio" unchecked name="exLayerInfo" id="RseIncidentInfo" value="RseIncidentInfo" onclick="reloadLayers(this.value,this.checked)">교통안전도우미</li>
					</div>
				</ul>
			
		</li>
		<li><strong>국가공간정보</strong>
			<ul>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="geotwo_postgis:og_tbm_ls" value="geotwo_postgis:og_tbm_ls" onclick="reloadLayers(this.value,this.checked)">기본수준점(TBM)</li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_C_SPBD" value="LT_C_SPBD" onclick="reloadLayers(this.value,this.checked)">새주소건물
				<input type="radio" name="order" value="spbd" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_C_UPISUQ152" value="LT_C_UPISUQ152" onclick="reloadLayers(this.value,this.checked)">교통시설
				<input type="radio" name="order" value="upisuq152" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_C_USFSFFB" value="LT_C_USFSFFB" onclick="reloadLayers(this.value,this.checked)">소방서관할구역
				<input type="radio" name="order" value="usfsffb" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_C_TDWAREA" value="LT_C_TDWAREA" onclick="reloadLayers(this.value,this.checked)">보행자우선구역
				<input type="radio" name="order" value="tdwarea" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_L_MOCTLINK" value="LT_L_MOCTLINK" onclick="reloadLayers(this.value,this.checked)">교통링크
				<input type="radio" name="order" value="moctlink" onclick="getWfsFindLayer(this.value)" /></li>
				<li>&nbsp;<input type="checkbox" unchecked name="layerInfo" id="LT_P_MOCTNODE" value="LT_P_MOCTNODE" onclick="reloadLayers(this.value,this.checked)">교통노드
				<input type="radio" name="order" value="moctnode" onclick="getWfsFindLayer(this.value)" /></li>
			</ul>
		</li>
	</ul>
</div>
<div class="ui-layout-west">
	<div id="westDiv">
		<input type="hidden" id="vCategory" value="Poi"/>
		<div id="ajax_indicator" style="display:none">
			로딩중...
		</div>
		<div class="search_terms">
			<div class="search_title"> 
				<img src="/images/search/searchicon_white.png" alt="" class="searchicon_white"/>
				poi
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
							<td colspan="3">검색결과가 없습니다.</td>								
							<tr>																	
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>
<div class="ui-layout-north">
	<div class="header_wrapper">
		<h1><img src="/images/title.png" border="0" class="title_img" /></h1>
		<div>
			<ul id="nav">
				<li class="top"><a href="javascript:vSearch('Poi');" id="products" class="top_link"><span class="down">Poi검색</span></a>
				</li>
				<li class="top"><a href="javascript:vSearch('Jibun');" id="products" class="top_link"><span class="down">지번검색</span></a>
				</li>
				<li class="top"><a href="javascript:vSearch('Juso');" id="products" class="top_link"><span class="down">새주소검색</span></a>
				</li>
				<li class="top"><a href="javascript:nLocal();" id="products" class="top_link"><span class="down">네이버지역명검색</span></a>
				</li>
			</ul>
			<ul class="top_btn">
				<li><a href="#" class="topbtn_zoomin" onclick="if(vworld.getMode()!=2){apiMap.zoomBoxIn();}else{alert('3D지도의 기능이 아닙니다.');}" title="확대"></a></li>
				<li><a href="#" class="topbtn_zoomout" onclick="if(vworld.getMode()!=2){apiMap.zoomBoxOut();}else{alert('3D지도의 기능이 아닙니다.');}" title="축소"></a></li>
				<li><a href="#" class="topbtn_move" onclick="if(vworld.getMode()!=2){apiMap.initAll();}else{alert('3D지도의 기능이 아닙니다.');}" title="이동"></a></li>
				<li><a href="#" class="topbtn_prev" onclick="if(vworld.getMode()!=2){apiMap.navi.previous.trigger();}else{alert('3D지도의 기능이 아닙니다.');}" title="이전"></a></li>
				<li><a href="#" class="topbtn_next" onclick="if(vworld.getMode()!=2){apiMap.navi.next.trigger();}else{alert('3D지도의 기능이 아닙니다.');}" title="다음"></a></li>
				<li><a href="#" class="topbtn_reset" onclick="apiMapRest();" title="초기화"></a></li>
				<li><a href="#" class="topbtn_distance" onclick="if(vworld.getMode()!=2){apiMap.calcDistance();}else{alert('3D지도의 기능이 아닙니다.');}" title="거리"></a></li>
				<li><a href="#" class="topbtn_area" onclick="if(vworld.getMode()!=2){apiMap.calcArea();}else{alert('3D지도의 기능이 아닙니다.');}" title="면적"></a></li>
				<li><a href="#" class="topbtn_full" onclick="if(vworld.getMode()!=2){apiMap.fullExtent();}else{alert('3D지도의 기능이 아닙니다.');}" title="전체보기"></a></li>
				<li><a href="#" class="topbtn_polyon" onclick="getWfsValue('polygon');" title="면검색"></a></li>
				<li><a href="#" class="topbtn_radius" onclick="getWfsValue('radius');" title="원검색"></a></li>
				<li><a href="#" class="topbtn_line" onclick="getWfsValue('line');" title="라인검색"></a></li>
				<li><a href="#" class="topbtn_point" onclick="getWfsValue('info');" title="점검색"></a></li>
				<li><a href="#" class="topbtn_buffer" onclick="getWfsValue('buffer');" title="버퍼"></a></li>
				<li><a href="#" class="topbtn_rode" onclick="" title="로드뷰"></a></li>
				<li>
					<span style="padding:1px 3px 0 10px;"><font color="white">버퍼크기</font></span>			
					<input id="cRadius" style="width:60px;"></input>
				</li>
				<li>
					<span style="padding:1px 3px 0 10px;"><font color="white">축척</font></span>			
					<input id="txtScale" style="width:60px;" onkeypress="if (event.keyCode==13){ javascript:setScaleEvt();};"></input>
				</li>
			</ul> 
		</div>
		<ul class="top_btn_right">
			<li><a href="#" onClick="roadViewStart();" class="two_btn"></a></li>
		</ul>
		<div style="float:right">
			<ul class="right_btn"><li><img src="/images/rightbtn_line.png" /></li>
				<li><a href="#" onclick="eastLayerOut();" class="rightbtn_layers"></a></li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>
					<a href="#" onclick="indexMapControl();" class="rightbtn_indexmap"></a>
					<input type="hidden" id="indexChk" value="On"/>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>
					<a href="#" onclick="changeMode(4);" class="rightbtn_gray"></a>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>
					<a href="#" onclick="changeMode(3);" class="rightbtn_night"></a>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>
					<a href="#" onclick="changeMode(1);" class="rightbtn_raster"></a>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>
					<a href="#" onclick="changeMode(0);" class="rightbtn_base"></a>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
				<li>	
					<a href="#" onclick="changeMode(2);" class="rightbtn_earth"></a>
				</li>
				<li><img src="/images/rightbtn_line.png" /></li>
			</ul> 
		</div>
	</div>	
</div>
</body>
<!-- <link rel="stylesheet" href="/css/popup.css" type="text/css"/> -->
</html>