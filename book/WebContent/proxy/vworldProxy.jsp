<%@page contentType="text/html; charset=euc-kr" pageEncoding="EUC-KR"%><%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%><%@page import="java.io.InputStream"%>
<%@page import="java.io.OutputStream"%><%@page import="java.io.IOException"%>
<%@page import="java.util.Enumeration"%><%@page import="java.net.HttpURLConnection"%><%@page import="java.net.URL"%>
<%@page import="java.net.MalformedURLException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>

<%
URL url=null;
HttpURLConnection http=null;

try {
	
	String UrlString="http://openapi.its.go.kr/api/NCCTVInfo?key=1412568714281&ReqType=1&MinX=126.100000&MaxX=130.890000&MinY=34.100000&MaxY=39.100000&type=its";
	//String UrlString="http://apis.vworld.kr/coord2jibun.do?x=126.960790964222&y=37.3980980566935&apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17&domain=localhost:8080&output=json&epsg=EPSG:4326";
	url = new URL(UrlString);
	
	http = (HttpURLConnection) url.openConnection();
  } catch (MalformedURLException e){
    e.printStackTrace();
  } catch (IOException e) {
    e.printStackTrace();
  }



byte[] buffer = new byte[8192];
int read = -1;

InputStream is = http.getInputStream();
response.setStatus(http.getResponseCode());
String HTTP_OK= http.getResponseMessage();
//System.out.println(" HTTP_OK: "+HTTP_OK);

out.clear();

ServletOutputStream sos = response.getOutputStream();  

response.resetBuffer();

while ((read = is.read(buffer)) != -1) {
	sos.write(buffer, 0, read);
	System.out.println("buffer : "+sos);
}
response.flushBuffer();
sos.close();
http.disconnect();
%>