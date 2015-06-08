package egovframework.got.vmap;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;


import javax.xml.parsers.ParserConfigurationException;


import org.xml.sax.SAXException;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URLEncoder;
import java.util.ArrayList;


import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

public class vMapData
{
  private String url = "http://apis.vworld.kr/2ddata/";
  private String key = "369C4265-766B-31D6-9469-8FB5ECC1BE17";
  private String output = "xml";
  private String domain = "localhost";
  private int pageIndex = 1;
  private int pageUnit = 10;
  private String srsName = "EPSG:900913";

  public vMapData(String key, int pageIndex, int pageUnit, String output, String domain, String srsName)
  {
    this.key = key;
    this.pageIndex = pageIndex;
    this.pageUnit = pageUnit;
    this.output = output;
    this.domain = domain;
    this.srsName = srsName;
  }

  public ArrayList doSearch(String geometry, String layerUrl) throws IOException, ParserConfigurationException, SAXException, TransformerFactoryConfigurationError, TransformerException
  {
	  
	  ArrayList resultList = new ArrayList();
	  this.url = this.url+layerUrl;
      StringBuffer sendURL = new StringBuffer(this.url);
      sendURL.append("?geometry=" + URLEncoder.encode(geometry, "UTF-8"));
      sendURL.append("&apiKey=" + this.key);
      sendURL.append("&pageIndex=" + this.pageIndex);
      sendURL.append("&pageUnit=" + this.pageUnit);
      sendURL.append("&domain=" + this.domain);
      sendURL.append("&output=" + this.output);
      sendURL.append("&srsName=" + this.srsName);
      System.out.println("데이터 api :: "+sendURL.toString());
      URL url = new URL(sendURL.toString());
      
      //API 요청 및 반환
      URLConnection conn = url.openConnection();
      BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
      String inputLine;
      StringBuffer trancoodLine = new StringBuffer();
      while ((inputLine = br.readLine()) != null) {
    	  trancoodLine.append(inputLine);
      }
      resultList.add(trancoodLine);
      
      return resultList;
    
  }

  public ArrayList doSearch(String geometry, String layerUrl, int pageIndex, int pageUnit) throws IOException, ParserConfigurationException, SAXException, TransformerFactoryConfigurationError, TransformerException
  {
    this.pageIndex = pageIndex;
    this.pageUnit = pageUnit;
    return doSearch(geometry,layerUrl);
  }

}