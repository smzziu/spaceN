<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>baseMap</title>

<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출 시작  -->
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=369C4265-766B-31D6-9469-8FB5ECC1BE17"></script>
<!-- API key를 포함하여 브이월드 API URL을 지정하여 호출끝  -->
<script type="text/javascript">

var apiMap;//2D map
var SOPPlugin;//3D map
vworld.showMode = true;//브이월드 배경지도 설정 컨트롤 유무(true:배경지도를 컨트롤 할수 있는 버튼 생성/false:버튼 해제) 
/**
 * - rootDiv, mapType, mapFunc, 3D initCall, 3D failCall
 * - 브이월드 5가지 파라미터를 셋팅하여 지도 호출
 */
vworld.init("vMap", "map-first", function(){});



</script>
</head>
<body>

<!-- 지도가 들어갈 영역 시작 -->
<div id="vMap" style="width:800px;height:600px;left:0px;top:0px"></div>
<!-- 지도가 들어갈 영역 끝 -->
<br>
* 통합지도를 초기화를 하여 화면에 지도를 표출하기 위해서는 <font color="red">rootDiv, mapType, mapFunc, 3D initCall, 3D failCall</font> 5가지를 설정해야 한다.

</body>
</html>