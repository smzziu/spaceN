package egovframework.got.com.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class naverSearch
{
  private String url = "http://175.158.1.51/search";
  private String key = null;
  private String target = null;
  private String sort = null;
  private int start = 1;
  private int display = 10;

  public naverSearch(String target, String key, int start)
  {
    this.target = target;
    this.key = key;
    this.start = start;
    System.out.println(url);
    System.out.println(key);
    System.out.println(target);
    System.out.println(sort);  
    System.out.println(start);
    System.out.println(display);
  }

  public ArrayList doSearch(String query)
  {
    ArrayList resultList = new ArrayList();
    try
    {
      StringBuffer sendURL = new StringBuffer(this.url);
      sendURL.append("?target=" + this.target);
      sendURL.append("&key=" + this.key);
      sendURL.append("&start=" + this.start);
      sendURL.append("&display=" + this.display);
      sendURL.append("&query=" + URLEncoder.encode(query, "UTF-8"));
      if (this.sort != null) {
        sendURL.append("&sort=" + this.sort);
      }

      URL send = new URL(sendURL.toString());
      HttpURLConnection con = (HttpURLConnection)send.openConnection();
      BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
      InputSource is = new InputSource(br);
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setIgnoringElementContentWhitespace(true);
      DocumentBuilder db = factory.newDocumentBuilder();

      Document doc = db.parse(is);
      Element root = doc.getDocumentElement();

      NodeList ch = root.getElementsByTagName("channel");

      if (ch.getLength() > 0) {
        NodeList channel = ch.item(0).getChildNodes();
        HashMap info = new HashMap();
        for (int i = 0; i < channel.getLength(); i++) {
          Node n = channel.item(i);
          String tagName = n.getNodeName();
          if (tagName.equals("item")) break;
          String nodeValue = "";
          try { nodeValue = n.getFirstChild().getNodeValue(); } catch (NullPointerException localNullPointerException) {
          }info.put(tagName, nodeValue);
        }
        resultList.add(info);

        NodeList item = root.getElementsByTagName("item");
        for (int i = 0; i < item.getLength(); i++) {
          HashMap hashmap = new HashMap();
          NodeList nodelist = item.item(i).getChildNodes();

          for (int j = 0; j < nodelist.getLength(); j++) {
            Node n = nodelist.item(j);
            String tagName = n.getNodeName();
            String nodeValue = "";
            try { nodeValue = n.getFirstChild().getNodeValue(); } catch (NullPointerException localNullPointerException1) {
            }hashmap.put(tagName, nodeValue);
          }
          resultList.add(hashmap);
        }
      }
      else
      {
        try {
          Node error_code = root.getElementsByTagName("error_code").item(0);
          Node message = root.getElementsByTagName("message").item(0);
          String codeStr = "에러코드 : " + error_code.getFirstChild().getNodeValue();
          String msgStr = "에러메세지 : " + message.getFirstChild().getNodeValue();
          throw new Exception(codeStr + msgStr);
        } catch (Exception e) {
          throw new Exception(e.getMessage());
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
    return resultList;
  }

  public ArrayList doSearch(String query, int start, int display)
  {
    this.start = start;
    this.display = display;
    return doSearch(query);
  }

  public ArrayList doSearch(String query, String sort)
  {
    this.sort = sort;
    return doSearch(query);
  }

  public ArrayList doSearch(String query, int start, int display, String sort)
  {
    this.sort = sort;
    return doSearch(query, start, display);
  }
}