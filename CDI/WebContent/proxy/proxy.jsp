<%@ page language="java"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%!
	public static String getParam(HttpServletRequest request, String name) {
	 
		Map map = (Map) request.getAttribute("Map");
		if (map == null) {
			map = new HashMap();
	
			Enumeration e = request.getParameterNames();
			while (e.hasMoreElements()) {
				String key = (String) e.nextElement();
				String value = request.getParameter(key);
				
				try {
					value = new String(value.getBytes("8859_1"), "UTF-8");
					System.out.println("server request= "+value);
				} catch (Exception ex) {
				}
				map.put(key.toUpperCase(), value);
				
				System.out.println("key:" + key);
				System.out.println("value:" + value);
			}
			request.setAttribute("Map", map);
		}
		return (String) map.get(name.toUpperCase());
	}

	public static void proxy(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String urlParam = getParam(request, "URL");
		if (urlParam == null || urlParam.trim().length() == 0) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		boolean doPost = request.getMethod().equalsIgnoreCase("POST");
		System.out.println("doPost == "+doPost);
		URL url = new URL(urlParam);
		HttpURLConnection http = (HttpURLConnection) url.openConnection();
		Enumeration headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String key = (String) headerNames.nextElement();
			if (!key.equalsIgnoreCase("Host")) {
				System.out.println("KEY = " + key + ", Value = " + request.getHeader(key));
				http.setRequestProperty(key, request.getHeader(key));
			}
		}
		
		http.setDoInput(true);
		http.setDoOutput(doPost);
	
		
						
		byte[] buffer = new byte[8192];
		int read = -1;
	
		if (doPost) {
			http.setRequestProperty("content-type","");
			System.out.println("doPost2 == "+doPost);
			OutputStream os = http.getOutputStream();
			ServletInputStream sis = request.getInputStream();
			while ((read = sis.read(buffer)) != -1) {
				os.write(buffer, 0, read);
			}
			os.close();
		}
	
		
		System.out.println("respCode = "+http.getResponseCode());
		System.out.println("length = "+http.getContentLength());
		System.out.println("contentType = "+http.getContentType());
		System.out.println("content = "+http.getContent());
		
		
		response.setStatus(http.getResponseCode());
		
		response.setContentType("charset=utf-8");
		response.setCharacterEncoding("utf-8");
		
		Map headerKeys = http.getHeaderFields();
		Set	keySet = headerKeys.keySet();
		Iterator iter = keySet.iterator();
		while (iter.hasNext()) {
			String key = (String) iter.next();
			String value = http.getHeaderField(key);
			if (key != null && value != null) {
				response.setHeader(key, value);
			}
		}
		
		InputStream is = http.getInputStream();
		ServletOutputStream sos = response.getOutputStream();
		response.resetBuffer();
		while ((read = is.read(buffer)) != -1) {
			sos.write(buffer, 0, read);
		}
		response.flushBuffer();
		sos.close();
	}
%><%
	try {
		out.clear();
		proxy(request, response);
	} catch (Exception e) {
		System.out.println("ERROR");
		System.out.println(e.getStackTrace()[0].getMethodName() + ":" + e.getStackTrace()[0].getLineNumber());
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		response.setContentType("text/plain");
		%><%=e.getStackTrace()[0].getMethodName() + ":" + e.getStackTrace()[0].getLineNumber()%><%
	}
	if (true) {
		return;
	}
%>
