<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>circle 여러개 생성</title>

<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출 시작  -->
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17"></script> 
<!-- <script type="text/javascript" src="/js/oriApi.js"></script> -->
<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출끝  -->

<script type="text/javascript">

var map = null;  
var output = "xml";
var geometry = "";
var dataApiKey = "369C4265-766B-31D6-9469-8FB5ECC1BE17";
var reqUrl	= "http://apis.vworld.kr/2ddata/";
var service_ = "wkmmbsn";

vworld.showMode = false; 
vworld.init(
	"mapDiv"	// rootDiv
	,"map-only" // mapType
	,function() {         
		map = this.vmap; 
		//기본맵 설정  
		map.setBaseLayer(map.vworldBaseMap); 
		map.setControlsType({"simpleMap": true});	//간단한 화면
		
		map.hideAllThemeLayer(); // 모든 WMS 레이어 숨기기. 지도목록보기로 확인하면 레이어는 존재하는걸 알 수 있습니다.
		map.showThemeLayer('중권역', {layers:'LT_C_UQ111'});
		map.mapRefresh();	// 레이어 새로고침
		
		map.setCenterAndZoom(14131153.372224, 4493937.3249453, 13);
		mapClick_f(14131153.372224, 4493937.3249453);
	}
	,function (obj){SOPPlugin = obj; }//initCallback
	,function (msg){alert('oh my god');}//failCallback
);

function mapClick_f(aX_, aY_){
	var pos = new OpenLayers.LonLat(aX_, aY_);
	
	var infoPixelX = 100;
	var infoPixelY = 100; 
    
    //프록시설정
    OpenLayers.ProxyHost = "proxy.jsp?url=";
    
    infoPixel = map.getPixelFromLonLat(pos);
	var pixelX = infoPixel.x;
	var pixelY = infoPixel.y;

	var pixel = new OpenLayers.Pixel(pixelX-2, pixelY+2);
	var min = thisMap.getLonLatFromPixel(pixel);
	var pixel = new OpenLayers.Pixel(pixelX+2, pixelY-2);
	var max = thisMap.getLonLatFromPixel(pixel);

	var MinX = Math.abs(min.lon);
	var MinY = Math.abs(min.lat);
	var MaxX = Math.abs(max.lon);
	var MaxY = Math.abs(max.lat);
	
	var SearchPoint = MinX + "," + MinY + "," + MaxX + "," + MaxY;		

	var filterText = "BBOX(" + SearchPoint + ")";
	
    fnRequestWFS(filterText, jsRSTreatResponse, jsFailureResponse);		
}

function fnRequestWFS(filterText, success, failure){
geometry = filterText;
	
try {
	var successCall = null;
	var failureCall = null;
		
	if (typeof success == 'function'){successCall = success; }
	if (typeof failure == 'function'){failureCall = failure; }
		
    	var params = "";
	params += "apiKey=" + dataApiKey;
    	if(geometry != ""){
    		params += "&geometry=" + geometry;
    	}
	params += "&output=xml";
	params += "&srsName=EPSG:900913";
	params += "&pageUnit=10"; //한페이지당 레코드 수
	params += "&domain=localhost:8080";
		
	var reqConfig = OpenLayers.Util.extend({
        		url: reqUrl + service_ + "/data?" + params,
        		headers: {"Content-Type": "text/plain"},
        		success: successCall,
        		failure: failureCall,
        		scope: this
    		}, {method: "GET"}); 
	    OpenLayers.Request.issue(reqConfig);
	} catch(e){
		alert("공간정보조회를 실패하였습니다.\n\n" + e.message);
}
}

function jsRSTreatResponse(){
	
}

function jsFailureResponse(){
	
}
</script>
</head>
<body>

<!-- 지도가 들어갈 영역 시작 -->
<div id="mapDiv" style="width:800px;height:600px;left:0px;top:0px"></div>
<!-- 지도가 들어갈 영역 끝 -->

<!-- chart control -->
<div>
	<button type="button" onclick="javascript:createCircle();" name="addpin" >원생성</button>
</div>
<br>
* 원폴리곤의 그릴때 복잡한 수직과 많은 포인트들이 생성되기 때문에 다수의 원폴리곤을 그릴때는 속도가 현저히 느려지는 현상
<!-- chart control -->
</body>
</html>