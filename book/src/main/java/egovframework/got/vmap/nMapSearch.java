package egovframework.got.vmap;

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

public class nMapSearch {
	private String url = "http://openapi.naver.com/search";
	private String key = null;
	private String target = null;
	private String sort = null;
	private int start = 1;
	private int display = 5;

	public nMapSearch(String target, String key, int start) {
		this.target = target;
		this.key = key;
		this.start = start;
	}

	public ArrayList<HashMap<String, String>> doSearch(String query) {
		ArrayList<HashMap<String, String>> resultList = new ArrayList<HashMap<String, String>>();
	try {
		StringBuffer sendURL = new StringBuffer(this.url);
		sendURL.append("?target=" + this.target);
		sendURL.append("&key=" + this.key);
		sendURL.append("&start=" + this.start);
		sendURL.append("&display=" + this.display);
		sendURL.append("&query=" + URLEncoder.encode(query, "UTF-8"));
		if (this.sort != null) {
			sendURL.append("&sort=" + this.sort);
		}
		System.out.println("네이버에서 주는 데이터 :::" +sendURL.toString());
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
			HashMap<String, String> info = new HashMap<String, String>();
			for (int i = 0; i < channel.getLength(); i++) {
				Node n = channel.item(i);
				String tagName = n.getNodeName();
				if (tagName.equals("item")) break;
				String nodeValue = "";
				try {
					nodeValue = n.getFirstChild().getNodeValue(); 
				} catch (NullPointerException localNullPointerException) {}
				info.put(tagName, nodeValue);
			}
			resultList.add(info);
			
			NodeList item = root.getElementsByTagName("item");
			for (int i = 0; i < item.getLength(); i++) {
				HashMap<String, String> hashmap = new HashMap<String, String>();
				NodeList nodelist = item.item(i).getChildNodes();
				
				for (int j = 0; j < nodelist.getLength(); j++) {
					Node n = nodelist.item(j);
					String tagName = n.getNodeName();
					String nodeValue = "";
					try { 
						nodeValue = n.getFirstChild().getNodeValue(); 
					} catch (NullPointerException localNullPointerException1) {}
					hashmap.put(tagName, nodeValue);
				}
				resultList.add(hashmap);
			}
			System.out.println("resultList : "+resultList);
		} else {
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

}
