<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>poi 검색</title>
</head>
<body>
<div id="westDiv">
	<input type="hidden" id="vCategory" value="Jibun"/>
	<div class="search_terms">
		<div class="search_title">
			<img src="/images/search/searchicon_white.png" alt="" class="searchicon_white"/>
			구주소
		</div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="terms_box">
			<tr>
				<td><img src="/images/search/terms_box_top.png" class="term_box_top" alt="" /></td>
			</tr>
			<tr>
				<td class="terms_box_middle">
					<ul>
						<li><img src="/images/search/list-st.png" alt="" class="list-st"/>검색어 :
						<span style="padding:0 0 0 4px;"></span>
						<input type="text" id="vNm" class="terms_input" name="vNm" value="" onkeypress="if (event.keyCode==13){ javascript:vSearchL();};"/>
						</li>
					</ul>
					<div class="search_btn">
						<a href="javascript:vSearchL();"><img src="/images/search/search_btn.png" alt="" /></a>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="westResult">
		<div class="search_result">
			<div class="result_title">
				<img src="/images/search/searchicon_black.png" alt="" class="searchicon_black"/>
				검색결과
			</div>
			<div class="result_space">  
				<div class="scroll">
					<div id="west_indicator" style="display:none">
						로딩중...
					</div>
					<table cellspacing="0" cellpadding="0" class="result_box">						
						<tr>	                        
						<td colspan="3">검색결과가 없습니다.</td>								
						<tr>																	
					</table>
				</div>
			</div>
		</div>
	</div>
</div>	
</body>
</html>