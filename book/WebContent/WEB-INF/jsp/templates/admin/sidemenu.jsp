<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">

	function del(){
		var test = confirm("정말 접속로그 초기화 하시겠습니까? ");
		if(test){
			location.href = "/op_usrlogin_a004.do";
		}
	}
		
</script>

<div class="section"> 

		<div class="user">
			<strong><c:out value='${rMap.__adminInfo__.USR_NAM}'/></strong>님 <a href="/op_usrlogout_a001.do"><img src="images/admin/btn_logout.gif" alt="logout" /></a>
		</div>
		
		
		<div id="lnb">
			<p class="lnb_t">사용자관리</p>
			<ul>
				<li>
					<p class="d1">메인</p>
					<ul class="d2">
						<li><a href="/op_statistic_s001.do">사용현황 조회</a></li>
						<li><a href="javascript:del();">접속로그 초기화</a></li>
					</ul>
				</li>
				<li>
					<p class="d1">계정관리</p>
					<ul class="d2">
						<li><a href="/op_usradmin_s001.do">운영자관리</a></li>
						<li><a href="/op_usrmember_s001.do">사용자관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
		
		<c:if test="${fn:startsWith(rMap.MENU_ID,'10_2')}">
		<div id="lnb">
			<p class="lnb_t">오픈플랫폼</p>
			<ul>
				<li>
					<p class="d1">오픈플랫폼</p>
					<ul class="d2">
						<li><a href="/op_brdnotice_s001.do">공지사항</a></li>
						<li><a href="/op_brddata_s001.do">자료실</a></li>
						<li><a href="/op_brdmedia_s001.do">보도자료</a></li>
						<li><a href="/op_brdfaq_s001.do">FAQ</a></li>
						<li><a href="/op_brdqna_s001.do">문의하기</a></li>
					</ul>
				</li>
			</ul>
		</div>
		</c:if>
		<c:if test="${fn:startsWith(rMap.MENU_ID,'10_3')}">
		<div id="lnb">
			<p class="lnb_t">공간정보 서비스</p>
			<ul>
				<li>
					<p class="d1">공간정보 서비스</p>
					<ul class="d2">
						<li><a href="/op_mapnotice_s001.do">지도 공지사항</a></li>
						<li><a href="/op_mapfaq_s001.do">지도 FAQ</a></li>
						<li><a href="/op_mapqna_s001.do">지도 문의하기</a></li>
						<li><a href="/op_brdplugin_s001.do">플러그인관리</a></li>
					</ul>
				</li>
			</ul>
		</div>
		</c:if>
		<c:if test="${fn:startsWith(rMap.MENU_ID,'10_4')}">
		<div id="lnb">
			<p class="lnb_t">개발자센터</p>
			<ul>
				<li>
					<p class="d1">개발자센터</p>
					<ul class="d2">
						<li><a href="/op_apikey_s001.do">오픈API 승인관리</a></li>
						<li><a href="/op_apiguide_s001.do">오픈API 레퍼런스</a></li>
						<li><a href="/op_apinotice_s001.do">오픈API 새소식</a></li>
						<li><a href="/op_apidata_s001.do">오픈API 자료실</a></li>
						<li><a href="/op_apifaq_s001.do">오픈API FAQ</a></li>
						<li><a href="/op_apiqna_s001.do">오픈API 문의하기</a></li>
					</ul>
				</li>
			</ul>
		</div>
		</c:if>
		<c:if test="${fn:startsWith(rMap.MENU_ID,'10_5')}">
		<div id="lnb">
			<p class="lnb_t">통계 및 현황</p>
			<ul>
				<li>
					<p class="d1">통계처리</p>
					<ul class="d2">
						<li><a href="/op_statistic_s002.do">일일접속자수 조회</a></li>
						<li><a href="/op_statistic_s003.do">접속자 통계</a></li>
						<li><a href="/op_statistic_s004.do">기간별 통계</a></li>
					</ul>
				</li>
				<li>
					<p class="d1">로그관리</p>
					<ul class="d2">
						<li><a href="/op_loglogview_s003.do">시스템 로그 조회</a></li>
						<li><a href="/op_loglogview_s001.do">다운로드 로그 검색</a></li>
						<li><a href="/op_loglogview_s002.do">다운로드 통계</a></li>
					</ul>
				</li>
				<li>
					<p class="d1">현황관리</p>
					<ul class="d2">
						<li><a href="/op_apiacc_s.do">인증키별 접속현황 조회</a></li>
						<li><a href="/op_apidata_s00.do">인증키별 테이터 사용량</a></li>
						<li><a href="/op_apidata_s01.do">접속자별 사용량 조회</a></li>
					</ul>
				</li>
			</ul>
		</div>
		
		</c:if>
    
</div>
				
			