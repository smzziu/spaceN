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
							<c:if test="${category == 'Poi'}">
							<td class="result_name"><img src="/images/search/list-st.png" alt="" class="list-st"/>
								<input type="hidden" id="vworldNo" name="vworldNo" value="<c:out value="${status.count}"/>">
					            <input type="hidden" id="pnu" name="pnu" value="<c:out value="${item.PNU}"/>">
					            <input type="hidden" id="nameFull" name="nameFull" value="<c:out value="${item.nameFull}"/>">
					            <input type="hidden" id="nameDp" name="nameDp" value="<c:out value="${item.nameDp}"/>">
					            <input type="hidden" id="juso" name="juso" value="<c:out value="${item.juso}"/>">
					            <input type="hidden" id="njuso" name="njuso" value="<c:out value="${item.njuso}"/>">
					            <input type="hidden" id="rdNm" name="rdNm" value="<c:out value="${item.RD_NM}"/>">
					            <input type="hidden" id="zipCl" name="zipCl" value="<c:out value="${item.ZIP_CL}"/>">
					            <input type="hidden" id="nCode" name="nCode" value="<c:out value="${item.NCODE}"/>">
					            <input type="hidden" id="codeName" name="codeName" value="<c:out value="${item.codeName}"/>">
					            <input type="hidden" id="ypos" name="ypos" value="<c:out value="${item.ypos}"/>">
					            <input type="hidden" id="xpos" name="xpos" value="<c:out value="${item.xpos}"/>">
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
							</td>
							<td class="link_location">
								<a href="javascript:vSearchMove('<c:out value="${status.count}"/>',
              					'<c:out value="${item.PNU}"/>',
              					'<c:out value="${item.nameFull}"/>',
              					'<c:out value="${item.nameDp}"/>',
              					'<c:out value="${item.juso}"/>',
              					'<c:out value="${item.njuso}"/>',
              					'<c:out value="${item.RD_NM}"/>',
              					'<c:out value="${item.ZIP_CL}"/>',
              					'<c:out value="${item.NCODE}"/>',
              					'<c:out value="${item.codeName}"/>',
              					'<c:out value="${item.ypos}"/>',
              					'<c:out value="${item.xpos}"/>',
              					'Poi');">
								<img src="/images/search/bul_poi_b_<c:out value="${status.count}" escapeXml="false"/>.png" alt="" class="result_link" />
								</a>
							</td>	
							</c:if>
							<c:if test="${category == 'Jibun'}">
							<td class="result_name"><img src="/images/search/list-st.png" alt="" class="list-st"/>
								<input type="hidden" id="vworldNo" name="vworldNo" value="<c:out value="${status.count}"/>">
					            <input type="hidden" id="juso" name="juso" value="<c:out value="${item.JUSO}"/>">
					            <input type="hidden" id="ypos" name="ypos" value="<c:out value="${item.ypos}"/>">
					            <input type="hidden" id="xpos" name="xpos" value="<c:out value="${item.xpos}"/>">
								<c:choose>
									 <c:when test="${fn:length(item.JUSO) > 14}">
									 	<strong title='<c:out value="${item.JUSO}"/>'><c:out value="${fn:substring(item.JUSO,0,13)}"/>...</strong>
									 </c:when>
									 <c:otherwise>
									 	<strong title='<c:out value="${item.JUSO}" escapeXml="false"/>'><c:out value="${item.JUSO}"/></strong>
									 </c:otherwise>
								</c:choose>	
							</td>
							<td class="link_location">
								<a href="javascript:vSearchMove('<c:out value="${status.count}"/>',
              					'','','','','','','','','',
              					'<c:out value="${item.ypos}"/>',
              					'<c:out value="${item.xpos}"/>',
              					'Jibun');">
								<img src="/images/search/bul_poi_b_<c:out value="${status.count}" escapeXml="false"/>.png" alt="" class="result_link" />
								</a>
							</td>	
							</c:if>
							<c:if test="${category == 'Juso'}">
							<td class="result_name"><img src="/images/search/list-st.png" alt="" class="list-st"/>
								<input type="hidden" id="vworldNo" name="vworldNo" value="<c:out value="${status.count}"/>">
					            <input type="hidden" id="juso" name="juso" value="<c:out value="${item.JUSO}"/>">
					            <input type="hidden" id="zipCl" name="zipCl" value="<c:out value="${item.ZIP_CL}"/>">
					            <input type="hidden" id="ypos" name="ypos" value="<c:out value="${item.ypos}"/>">
					            <input type="hidden" id="xpos" name="xpos" value="<c:out value="${item.xpos}"/>">
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
							</td>	
							<td class="link_location">
								<a href="javascript:vSearchMove('<c:out value="${status.count}"/>',
              					'','','','','','','<c:out value="${item.ZIP_CL}"/>','','',
              					'<c:out value="${item.ypos}"/>',
              					'<c:out value="${item.xpos}"/>',
              					'Jibun');">
								<img src="/images/search/bul_poi_b_<c:out value="${status.count}" escapeXml="false"/>.png" alt="" class="result_link" />
								</a>
							</td>
							</c:if>
						</tr>							
					</c:forEach>	
				</table>
			</div>
		</div>
	</div>
</c:if>
</body>
</html>