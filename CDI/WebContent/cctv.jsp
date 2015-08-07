<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.net.SocketTimeoutException" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="org.apache.http.HttpEntity" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="org.apache.http.client.HttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.jdom2.input.SAXBuilder" %>
<%@ page import="org.jdom2.Document" %>
<%@ page import="org.jdom2.Element" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %> 

<%!
public ArrayList<String> transferHttp()
{
	ArrayList<String> listMapData = new ArrayList<String>();
	try
	{		
		HttpClient httpclient = new DefaultHttpClient();
		httpclient.getParams().setParameter("http.protocol.expect-continue", false);
		httpclient.getParams().setParameter("http.connection.timeout", 30000);
		httpclient.getParams().setParameter("http.socket.timeout", 30000);

		//	CCTV정보  (its : 도로, ex : 고속도로)
		HttpGet httpget = new HttpGet("http://openapi.its.go.kr/api/NCCTVInfo?key=1412568714281&ReqType=1&MinX=126.100000&MaxX=130.890000&MinY=34.100000&MaxY=39.100000&type=its");		
		HttpResponse resp = httpclient.execute(httpget); 
		HttpEntity responseEntity = resp.getEntity();
		InputStream is = responseEntity.getContent();
		
		SAXBuilder builder = new SAXBuilder();
		Document doc = builder.build(is);
		Element root = doc.getRootElement();
				
		List<Element> elements = root.getChildren();
		for(Element element : elements){
			String strData = "";
			if(element.getName().equals("data")){
				List<Element> items = element.getChildren();
				for(Element item : items){
					strData += item.getText() + "|";
				}
				listMapData.add(strData);
			}
		}
		if(is != null) is.close();		
	}catch (SocketTimeoutException ste) { 
		ste.printStackTrace(); 
	}catch (MalformedURLException mue) { 
		mue.printStackTrace(); 
	}catch (Exception e) { 
		e.printStackTrace(); 
	}
	return listMapData;
}

ArrayList<String> retMapData = transferHttp();
int nMapDataCnt = retMapData.size();
%>
     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>CCTV정보</title>

<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출 시작  -->
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17"></script> 
<!-- <script type="text/javascript" src="/js/oriApi.js"></script> -->
<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출끝  -->

<script type="text/javascript">

var apiMap;//2D map
var SOPPlugin;//3D map
vworld.showMode = false;//브이월드 배경지도 설정 컨트롤 유무(true:배경지도를 컨트롤 할수 있는 버튼 생성/false:버튼 해제)
var mControl;//마커이벤트변수
var tempMarker = null;//임시마커
var retMapData = '<%=retMapData %>';
var nMapDataCnt = <%=nMapDataCnt %>;
var strSplit = new Array();
var markers;
var popupContentHTML;
/**
 * - rootDiv, mapType, mapFunc, 3D initCall, 3D failCall
 * - 브이월드 5가지 파라미터를 셋팅하여 지도 호출
 */
vworld.init("vMap", "map-first", 
	function() {        
		apiMap = this.vmap;//브이월드맵 apiMap에 셋팅 
		apiMap.setBaseLayer(apiMap.vworldBaseMap);//기본맵 설정 
		apiMap.setControlsType({"simpleMap":true});	//간단한 화면
		apiMap.addVWORLDControl("zoomBar");//panzoombar등록
		apiMap.setCenterAndZoom(14243425.793355, 4342305.8698004, 7);//화면중심점과 레벨로 이동 (초기 화면중심점과 레벨) 	
	},
	function (obj){//3D initCall(성공)
		SOPPlugin = obj;
	},
	function (msg){//3D failCall(실패)
		alert(msg);
	}
);

/**
 * 제주도 이동 및 마커찍기
 */
function moveMarker(){
	
	var temp = retMapData.split(", ");
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	for(var i=0;i<nMapDataCnt;i++){
		strSplit = temp[i].split("|");
		if(strSplit[2] == '1') strType = "실시간 스트리밍";
		else if(strSplit[2] == '2') strType = "동영상 파일";
		else if(strSplit[2] == '3') strType = "정지영상";			
		else strType = "";
		
		strMsg = strSplit[7];
		
		//addMarker(strSplit[5],strSplit[8],strType,strSplit[7],strMsg,strSplit[3]);
		
		var transCod = new OpenLayers.Geometry.Point(strSplit[8], strSplit[5]).transform(epsg4326, epsg900913);
		popupContentHTML = "";
		popupContentHTML += "<div>"+strSplit[7]+"</div><br>";
	    popupContentHTML += "<div><embed src='"+strSplit[3]+"' showstatusbar='true'></div>";
		addMarker(transCod.x,transCod.y,popupContentHTML);
		
	}
	
}



var currentPopup;
var markers;
function addMarker(x,y,popupContentHTML) {
	markers = new OpenLayers.Layer.Markers( "Markers" );
	apiMap.addLayer(markers);
	var ll = new OpenLayers.LonLat(x,y);//xy좌표
    var feature = new OpenLayers.Feature(markers,ll);
	
    feature.closeBox = true;
    
    OpenLayers.Popup.FramedCloud.prototype.autoSize = false;
    var AutoSizeFramedCloudMinSize = OpenLayers.Class(OpenLayers.Popup,{	
        'autoSize': false,
        'minSize': new OpenLayers.Size(295,300)
    });
    
    feature.popupClass = AutoSizeFramedCloudMinSize;
    feature.data.popupContentHTML = popupContentHTML;
    feature.data.overflow = "hidden";
	
    var marker = feature.createMarker();
    marker.icon.size = new OpenLayers.Size(20,20);//마커 사이즈
    marker.icon.url='RDL_CCTV_PS.png';//마커 이미지
	marker.icon.imageDiv.style.cursor='hand';

    var markerClick = function (evt) {
    	
    	if (this.popup == null) {
            this.popup = this.createPopup();
            this.popup.setSize(new OpenLayers.Size(325,300));
        	  this.popup.calculateNewPx = function(px) {
        		var newPx = px;
        	    this.anchor.offset.x = 25;	
        	    this.anchor.offset.y = 45;
        	    newPx = px.offset(this.anchor.offset);
        	    return newPx;  
        	  };
        	  
        	apiMap.addPopup(this.popup);
            feature.popup.show();
           
        } else {
      	  feature.popup.toggle();
        }
        currentPopup = this.popup;
        OpenLayers.Event.stop(evt);
    	
    };
    marker.events.register("mousedown", feature, markerClick);//마커 클릭시 일어나는 이벤트
    
    markers.addMarker(marker);

}
</script>
</head>
<body>

<!-- 지도가 들어갈 영역 시작 -->
<div id="vMap" style="width:800px;height:600px;left:0px;top:0px"></div>
<!-- 지도가 들어갈 영역 끝 -->

<!-- chart control -->
<div>
	<button type="button" onclick="javascript:moveMarker();" name="addpin" >cctv 활성화</button>
</div>
<!-- chart control -->
<br>
* 지도 위에 마커를 생성 할 수 있고 원하는 위치에 마커가 이동하여 생성 할 수 있다.
</body>
</html>