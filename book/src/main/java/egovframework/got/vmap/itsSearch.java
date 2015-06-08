package egovframework.got.vmap;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;


import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;


import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;


public class itsSearch
{
  private String url = "http://openapi.its.go.kr/api/NCCTVInfo";
  private String key = "1412568714281";
  private String ReqType = "1";
  private String type = "ex";
  private double MinX = 126.100000;
  private double MaxX = 130.890000;
  private double MinY = 34.100000;
  private double MaxY = 39.100000;

  public itsSearch()
  {
	  
  }


  @SuppressWarnings("rawtypes")
  public ArrayList doSearch() throws IOException, ParserConfigurationException, SAXException, TransformerFactoryConfigurationError, TransformerException
    {
  	  
  	  ArrayList<HashMap<String, String>> resultList = new ArrayList<HashMap<String, String>>();
  	  
        StringBuffer sendURL = new StringBuffer(this.url);
        sendURL.append("?key=" + this.key);
        sendURL.append("&ReqType=" + this.ReqType);
        sendURL.append("&type=" + this.type);
        sendURL.append("&MinX=" + this.MinX);
        sendURL.append("&MaxX=" + this.MaxX);
        sendURL.append("&MinY=" + this.MinY);
        sendURL.append("&MaxY=" + this.MaxY);
        URL url = new URL(sendURL.toString());
        System.out.println("url :::: "+url);
        //API 요청 및 반환
        URLConnection conn = url.openConnection();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(conn.getInputStream());
        
        
        NodeList headNodeList = doc.getElementsByTagName("data");

        
        for(int i=0; i<headNodeList.getLength(); i++){
      	  
      	  Node headNode = headNodeList.item(i);
      	  
      		@SuppressWarnings("unused")
  			Element headLineElement = (Element) headNode;
      		  
      		  NodeList notdElement = headNodeList.item(i).getChildNodes();//headLineElement.getElementsByTagName("ZIP_CL");
      		  HashMap<String, String> hashmap = new HashMap<String, String>();
      		  for (int j = 0; j < notdElement.getLength(); j++) {
      			  
      			  Node n = notdElement.item(j);
  	              String tagName = n.getNodeName();
  	              String nodeValue = "";
  	              try { 
  	            	  nodeValue = n.getFirstChild().getNodeValue(); 
  	              } catch (NullPointerException localNullPointerException1) 
  	              {}
  	              hashmap.put(tagName, nodeValue);
  	              
      		  }
      		  resultList.add(hashmap);
        }
        System.out.println("resultList : "+resultList);
       /* NodeList totalCnt = doc.getElementsByTagName("paginationInfo");
        Node headNode = totalCnt.item(0);
        Element headLineElement = (Element) headNode;
        
  	  NodeList totalCntElement = headLineElement.getElementsByTagName("totalRecordCount");
        Element totalCntItem = (Element) totalCntElement.item(0);
        NodeList total = totalCntItem.getChildNodes();
        HashMap<String, String> hashmap = new HashMap<String, String>();
        hashmap.put("totCnt", total.item(0).getTextContent());
        resultList.add(hashmap);
        System.out.println("resultList : "+resultList);
       */
        return resultList;
      
    }


}