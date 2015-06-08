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
<title>네이버 검색</title>
</head>
<body>
<c:if test="${empty resultMAP.LIST}">
	<div class="search_result">
		<div class="result_title">
			<img src="/images/search/searchicon_black.png" alt="" class="searchicon_black"/>
			검색결과
		</div>
		<div class="result_space">  
			<div class="scroll">
				<table cellspacing="0" cellpadding="0" class="result_box">						
					<tr>	                        
						<td colspan="3">검색결과가 없습니다.</td>								
					<tr>																	
				</table>
			</div>
		</div>
	</div>
</c:if>
<c:if test="${not empty resultMAP.LIST}">
	<c:forEach var="ndXY" items="${resultMAP.LIST2}" varStatus="status">
		<input type="hidden" id="nX" name="nX" value="<c:out value="${ndXY.trancoodX}"/>">
		<input type="hidden" id="nY" name="nY" value="<c:out value="${ndXY.trancoodY}"/>">
	</c:forEach>
	<div class="search_result">
		<div class="result_title">
			<img src="/images/search/searchicon_black.png" alt="" class="searchicon_black"/>
			검색결과 <fmt:formatNumber value="${totCnt}" pattern="###,###,###"/></span> 건</span>
		</div>
		<div class="result_space">  
			<div class="scroll">
				<div id="west_indicator" style="display:none">
						로딩중...
				</div>	
				<table cellspacing="0" cellpadding="0" class="result_box">
					<c:forEach var="item" items="${resultMAP.LIST}" begin="1" varStatus="status" step="1">
			            <input type="hidden" id="nNo" name="nNo" value="<c:out value="${status.count}"/>">
						<input type="hidden" id="title" name="title" value="<c:out value="${item.title}"/>">
						<input type="hidden" id="address" name="address" value="<c:out value="${item.address}"/>">
						<input type="hidden" id="description" name="description" value="<c:out value="${item.description}"/>">
						<input type="hidden" id="link" name="link" value="<c:out value="${item.link}"/>">
						<input type="hidden" id="telephone" name="telephone" value="<c:out value="${item.telephone}"/>">						
						<input type="hidden" id="roadAddress" name="roadAddress" value="<c:out value="${item.roadAddress}"/>">
						<input type="hidden" id="category" name="category" value="<c:out value="${item.category}"/>">
						<tr>
							<td class="result_name"><img src="/images/search/list-st.png" alt="" class="list-st"/>
								<c:choose>
									 <c:when test="${fn:length(item.juso) > 14}">
									 	<strong title='<c:out value="${item.title}" escapeXml="false"/>'><c:out value="${fn:substring(item.title,0,13)}" escapeXml="false"/>...</strong><br/>
									 </c:when>
									 <c:otherwise>
									 	<strong title='<c:out value="${item.title}" escapeXml="false"/>'><c:out value="${item.title}" escapeXml="false"/></strong><br/>
									 </c:otherwise>
								</c:choose>	
								<c:choose>
									 <c:when test="${fn:length(item.address) > 13}">
									 	<p style="padding-left:20px;" title='<c:out value="${item.address}"/>'><c:out value="${fn:substring(item.address,0,12)}"/>...</p>
									 </c:when>
									 <c:otherwise>
									 	<p style="padding-left:20px;" title='<c:out value="${item.address}" escapeXml="false"/>'><c:out value="${item.address}"/></p>
									 </c:otherwise>
								</c:choose>	
							</td>
							<td class="link_location">
								<a href="javascript:nLocalMove('<c:out value="${item.title}"/>',
								'<c:out value="${status.count}"/>',
								'<c:out value="${item.address}"/>',
								'<c:out value="${item.description}"/>',
								'<c:out value="${item.link}"/>',
								'<c:out value="${item.telephone}"/>',
								'<c:out value="${item.roadAddress}"/>',
								'<c:out value="${item.category}"/>');">
								<img src="/images/search/bul_poi_b_<c:out value="${status.count}" escapeXml="false"/>.png" alt="" class="result_link" />
								</a>
							</td>
						</tr>							
					</c:forEach>	
				</table>
				<br>
				<div style="margin:1px 0 5px 0;text-align:center;letter-spacing:1px;">
	            	<c:if test="${not empty paginationInfo}">
	            		<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="nLocalL" />
					</c:if>                    
            	</div>
			</div>
		</div>
	</div>
</c:if>

</body>
</html>