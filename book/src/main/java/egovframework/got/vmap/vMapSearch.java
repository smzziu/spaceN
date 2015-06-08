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


public class vMapSearch
{
  private String url = "http://map.vworld.kr/search.do";
  private String key = "369C4265-766B-31D6-9469-8FB5ECC1BE17";
  private String category = "Juso";
  private String output = "xml";
  private int pageIndex = 1;
  private int pageUnit = 10;

  public vMapSearch(String category, String key, int pageIndex)
  {
    this.category = category;
    this.key = key;
    this.pageIndex = pageIndex;
  }

@SuppressWarnings("rawtypes")
public ArrayList doSearch(String query) throws IOException, ParserConfigurationException, SAXException, TransformerFactoryConfigurationError, TransformerException
  {
	  
	  ArrayList<HashMap<String, String>> resultList = new ArrayList<HashMap<String, String>>();
	  
      StringBuffer sendURL = new StringBuffer(this.url);
      sendURL.append("?category=" + this.category);
      sendURL.append("&apiKey=" + this.key);
      sendURL.append("&pageIndex=" + this.pageIndex);
      sendURL.append("&pageUnit=" + this.pageUnit);
      sendURL.append("&q=" + URLEncoder.encode(query, "UTF-8"));
      sendURL.append("&output=" + this.output);
      URL url = new URL(sendURL.toString());
      System.out.println("url :::: "+url);
      //API 요청 및 반환
      URLConnection conn = url.openConnection();
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      DocumentBuilder builder = factory.newDocumentBuilder();
      Document doc = builder.parse(conn.getInputStream());
      
      
      NodeList headNodeList = doc.getElementsByTagName("item");

      
      for(int i=0; i<headNodeList.getLength(); i++){
    	  
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
      
      NodeList totalCnt = doc.getElementsByTagName("paginationInfo");
      Node headNode = totalCnt.item(0);
      Element headLineElement = (Element) headNode;
      
	  NodeList totalCntElement = headLineElement.getElementsByTagName("totalRecordCount");
      Element totalCntItem = (Element) totalCntElement.item(0);
      NodeList total = totalCntItem.getChildNodes();
      HashMap<String, String> hashmap = new HashMap<String, String>();
      hashmap.put("totCnt", total.item(0).getTextContent());
      resultList.add(hashmap);
      System.out.println("resultList : "+resultList);
     
      return resultList;
    
  }


}