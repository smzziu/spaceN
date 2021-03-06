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
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>웹페이지에 결과 표시하기</title>
<c:if test="${not empty resultMAP.LIST}">
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
					<c:forEach var="item" items="${resultMAP.LIST}" begin="0" end="${endCnt}" varStatus="status" step="1">
						<tr>
							<td class="result_name"><img src="/images/search/list-st.png" alt="" class="list-st"/>
							<c:if test="${category == 'Poi'}">
								<c:choose>
									 <c:when test="${fn:length(item.juso) > 14}">
									 	<strong title='<c:out value="${item.juso}" escapeXml="false"/>'><c:out value="${fn:substring(item.juso,0,13)}" escapeXml="false"/>...</strong><br/>
									 </c:when>
									 <c:otherwise>
									 	<strong title='<c:out value="${item.juso}" escapeXml="false"/>'><c:out value="${item.juso}" escapeXml="false"/></strong><br/>
									 </c:otherwise>
								</c:choose>	
								<c:choose>
									 <c:when test="${fn:length(item.nameFull) > 13}">
									 	<p style="padding-left:20px;" title='<c:out value="${item.nameFull}"/>'><c:out value="${fn:substring(item.nameFull,0,12)}"/>...</p>
									 </c:when>
									 <c:otherwise>
									 	<p style="padding-left:20px;" title='<c:out value="${item.nameFull}" escapeXml="false"/>'><c:out value="${item.nameFull}"/></p>
									 </c:otherwise>
								</c:choose>	
							</c:if>
							<c:if test="${category == 'Jibun'}">
								<c:choose>
									 <c:when test="${fn:length(item.JUSO) > 14}">
									 	<strong title='<c:out value="${item.JUSO}"/>'><c:out value="${fn:substring(item.JUSO,0,13)}"/>...</strong>
									 </c:when>
									 <c:otherwise>
									 	<strong title='<c:out value="${item.JUSO}" escapeXml="false"/>'><c:out value="${item.JUSO}"/></strong>
									 </c:otherwise>
								</c:choose>	
							</c:if>
							<c:if test="${category == 'Juso'}">
								<c:choose>
									 <c:when test="${fn:length(item.JUSO) > 14}">
									 	<strong title='<c:out value="${item.JUSO}"/>'><c:out value="${fn:substring(item.JUSO,0,13)}"/>...</strong>
									 </c:when>
									 <c:otherwise>
									 	<strong title='<c:out value="${item.JUSO}" escapeXml="false"/>'><c:out value="${item.JUSO}"/></strong>
									 </c:otherwise>
								</c:choose>	
								<c:choose>
									 <c:when test="${fn:length(item.ZIP_CL) > 13}">
									 	<p style="padding-left:20px;" title='<c:out value="${item.ZIP_CL}"/>'><c:out value="${fn:substring(item.ZIP_CL,0,12)}"/>...</p>
									 </c:when>
									 <c:otherwise>
									 	<p style="padding-left:20px;" title='<c:out value="${item.ZIP_CL}" escapeXml="false"/>'><c:out value="${item.ZIP_CL}"/></p>
									 </c:otherwise>
								</c:choose>	
							</c:if>
							</td>
						</tr>							
					</c:forEach>	
				</table>
			</div>
		</div>
	</div>
</c:if>
</body>
</html>