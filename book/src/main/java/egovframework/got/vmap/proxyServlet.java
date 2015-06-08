package egovframework.got.vmap;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class proxyServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "*");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
		HttpURLConnection connection = null;
		InputStream istream = null;
		OutputStream ostream = null;
		InputStream ristream = null;
		OutputStream rostream = null;
		try {
			String mixUrl = request.getParameter("url");
			System.out.println("url=======" + mixUrl);
			URL targetUrl = new URL(mixUrl);
			connection = (HttpURLConnection) targetUrl.openConnection();
			connection.setDoOutput(true);
			connection.setRequestMethod(request.getMethod());
			if (request.getHeader("referer") != null){
				connection.setRequestProperty("referer", request.getHeader("referer"));
			}
			int clength = request.getContentLength();

			if (clength > 0) {
				connection.setDoInput(true);
				istream = request.getInputStream();
				ostream = connection.getOutputStream();
				int length = 5000;
				byte[] bytes = new byte[5000];
				int bytesRead = 0;
				while ((bytesRead = istream.read(bytes, 0, 5000)) > 0) {
					ostream.write(bytes, 0, bytesRead);
				}
			}

			rostream = response.getOutputStream();
			response.setContentType(connection.getContentType());
			ristream = connection.getInputStream();
			int length = 5000;
			byte[] bytes = new byte[5000];
			int bytesRead = 0;
			while ((bytesRead = ristream.read(bytes, 0, 5000)) > 0)
				rostream.write(bytes, 0, bytesRead);
		} catch (Exception e) {
			response.setStatus(500);
			e.printStackTrace();
		} finally {
			if (istream != null)
				istream.close();
			if (ostream != null)
				ostream.close();
			if (ristream != null)
				ristream.close();
			if (rostream != null)
				rostream.close();
		}
	}

	private String getParam(HttpServletRequest request, String name) {

		Map map = (Map) request.getAttribute("Map");
		if (map == null) {
			map = new HashMap();

			Enumeration e = request.getParameterNames();
			while (e.hasMoreElements()) {
				String key = (String) e.nextElement();
				String value = request.getParameter(key);

				try {
					value = new String(value.getBytes("8859_1"), "UTF-8");
					//System.out.println("server request= " + value);
				} catch (Exception ex) {
				}
				map.put(key.toUpperCase(), value);
			}
			request.setAttribute("Map", map);
		}
		return (String) map.get(name.toUpperCase());
	}

	private void proxy(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String urlParam = getParam(request, "URL");
		if (urlParam == null || urlParam.trim().length() == 0) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		boolean doPost = request.getMethod().equalsIgnoreCase("POST");
		URL url = new URL(urlParam);
		HttpURLConnection http = (HttpURLConnection) url.openConnection();
		Enumeration headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String key = (String) headerNames.nextElement();
			if (!key.equalsIgnoreCase("Host")) {
				http.setRequestProperty(key, request.getHeader(key));
			}
		}

		http.setDoInput(true);
		http.setDoOutput(doPost);

		byte[] buffer = new byte[8192];
		int read = -1;

		if (doPost) {
			OutputStream os = http.getOutputStream();
			ServletInputStream sis = request.getInputStream();
			while ((read = sis.read(buffer)) != -1) {
				os.write(buffer, 0, read);
			}
			os.close();
		}

		InputStream is = http.getInputStream();
		response.setStatus(http.getResponseCode());

		response.setContentType("charset=utf-8");
		response.setCharacterEncoding("utf-8");

		Map headerKeys = http.getHeaderFields();
		Set keySet = headerKeys.keySet();
		Iterator iter = keySet.iterator();
		while (iter.hasNext()) {
			String key = (String) iter.next();
			String value = http.getHeaderField(key);
			if (key != null && value != null) {
				response.setHeader(key, value);
				//System.out.println(key + ":" + value);
			}
		}

		ServletOutputStream sos = response.getOutputStream();
		response.resetBuffer();
		while ((read = is.read(buffer)) != -1) {
			sos.write(buffer, 0, read);
		}
		response.flushBuffer();
		sos.close();
	}
}