package egovframework.got.vmap;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;


import org.xml.sax.SAXException;

public class dTranCoord {
    
    public Map<String, String> doSearch(String xx, String yy) throws IOException, ParserConfigurationException, SAXException{
    	//링크 주소 만들기
        String requestUrl = "http://apis.daum.net/local/geo/transcoord?";
        requestUrl += "apikey=" + "a1105cd1a1d204eaebeeb1a6873d90faa755ec10"; //발급된 키
        requestUrl += "&x=" + xx; 
        requestUrl += "&y=" + yy; 
        requestUrl += "&fromCoord=" + "KTM";
        requestUrl += "&toCoord=" + "WGS84";
        requestUrl += "&output=" + "xml";
        System.out.println("url :: "+requestUrl);
        URL url = new URL(requestUrl);
        
        //API 요청 및 반환
        URLConnection conn = url.openConnection();
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        String trancoodLine = "";
        while ((inputLine = br.readLine()) != null) {
            trancoodLine = inputLine;
        }
         
        trancoodLine = trancoodLine.replaceAll("<result x='", "");
        trancoodLine = trancoodLine.replaceAll("' y='", ",");
        trancoodLine = trancoodLine.replaceAll("' />", "");
        
        String trancoodX = trancoodLine.split(",")[0];
        String trancoodY = trancoodLine.split(",")[1];
        
        HashMap<String, String> hashmap = new HashMap();
        hashmap.put("trancoodX", trancoodX);
        hashmap.put("trancoodY", trancoodY);
        return hashmap;
    }


	public Map<String, String> transCoord(String xx, String yy) {
		// TODO Auto-generated method stub
		try {
			return doSearch(xx, yy);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
