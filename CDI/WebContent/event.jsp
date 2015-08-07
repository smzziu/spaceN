<%-- <%@// page import="com.sun.media.sound.AlawCodec"%> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		httpclient.getParams().setParameter("http.connection.timeout", 5000);
		httpclient.getParams().setParameter("http.socket.timeout", 5000);

		//	�������
		HttpGet httpget = new HttpGet("http://openapi.its.go.kr/api/NEventIdentity?key=1412568714281&ReqType=2&MinX=126.100000&MaxX=128.890000&MinY=34.100000&MaxY=39.100000&type=its");		
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

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>공사정보</title>
<link href="/maps/documentation/javascript/examples/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false&language=ko"></script>
<script type="text/javascript"> 
	window.onload=initialize;
	var map;
	
	function toggleBounce(){
		if (marker.getAnimation() != null) 
    	{
			marker.setAnimation(null);
    	} 
    	else 
    	{
			marker.setAnimation(google.maps.Animation.BOUNCE);
    	}
  	}
	
	function initialize(){
		var element = document.getElementById("map");
		 
	    var mapOptions = {
			zoom: 7,
			zoomControl: true,
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			center: new google.maps.LatLng(36.54675499755641,127.439302673339844)
		};
		map = new google.maps.Map(element, mapOptions);
	    
	    var strType="";
		var strDate="";
		var strMsg="";
		var strSplit = new Array();
		var nMapDataCnt = '<%=nMapDataCnt%>';
		var retMapData = '<%=retMapData%>';
		var temp = retMapData.split(", ");
		alert(nMapDataCnt);
		for(var i=0;i<nMapDataCnt;i++){
			strSplit = temp[i].split("|");
			/* if(strSplit[7] == '0') strType = "통제없음";
			else if(strSplit[7] == '1') strType = "갓길통제";
			else if(strSplit[7] == '2') strType = "차로부분통제";
			else if(strSplit[7] == '3') strType = "전면통제";			
			else strType = ""; */
			
			strDate = strSplit[11] + "~" + strSplit[1];
			strMsg = strSplit[6];
			
			addMarker(strSplit[2],strSplit[5],strType,strMsg,strDate);
		}
	}
	
	function addMarker(xPos, yPos, iType, iMsg, iDuration){
		var image = new google.maps.MarkerImage('../Resource/images/icon_construction.png',
				new google.maps.Size(16, 16),
				new google.maps.Point(0,0),
				new google.maps.Point(0, 16));
		var pos = new google.maps.LatLng(xPos,yPos);
		var marker = new google.maps.Marker({  
		    position: pos,
		    title: "테스트",
		    icon: image
		});
		
		marker.setMap(map);
	}
</script>
</head>
<body>
	<div id="map" style="width: 400px; height: 480px;"></div>
</body>
</html>