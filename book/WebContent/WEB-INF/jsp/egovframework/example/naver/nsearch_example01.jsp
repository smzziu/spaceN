<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>웹페이지에 결과 표시하기</title>
<link rel="stylesheet" href="/css/ui/left_search.css" type="text/css" media="screen" />
<script src="http://code.jquery.com/jquery-1.7.js" type="text/javascript"></script>
<script type="text/javascript">

function nLocalL(index){
	var pageIndex = index;
	if(pageIndex == null){
		pageIndex = 1;
	}	
	var nNm = $("#nNm").val();
	var params="nNm="+nNm+"&pageIndex="+pageIndex;  
	if(nNm == null || nNm==""){
		alert("검색명을 입력해 주세요.");		
		return false;
	}else{
		$.ajax({
		    type : "POST",
		    async : true,
		    url : "/nsearch_example01_1.do",
		    data : params,
		    dataType : "html",
		    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    error : function(request, status, error) {
		    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
		    },
		    success : function(response, status, request) {
		    	$('#westResult').html(response); 
		    	nSearchLmove();
		    },
		    beforeSend: function() {
		    	$('#west_indicator').show().fadeIn('fast');
		    },
		    complete: function() {
		    	$('#west_indicator').fadeOut();
		    }
		});
	}
}

</script>

</head>
<body>
<div class="search_terms">
	<div class="search_title">
		<img src="/images/search/searchicon_white.png" alt="" class="searchicon_white"/>
		네이버
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
				<input type="text" id="nNm" class="terms_input" name="nNm" value="" onkeypress="if (event.keyCode==13){ javascript:nLocalL();};"/>
					</li>
				</ul>
				<div class="search_btn">
					<a href="javascript:nLocalL();"><img src="/images/search/search_btn.png" alt="" /></a>
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
</body>
</html>