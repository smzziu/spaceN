<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>.
<SCRIPT language="JavaScript" type="text/javascript" 
				src="http://map.vworld.kr/js/vworldMapInit.js.do?apiKey=FB0671EB-7343-3B8D-A0B3-67678B13B3AF"></SCRIPT>
<script>


	var map = null;
	var SOPPlugin;
	vworld.showMode = false;
	vworld.init("vMap" // rootDiv
	, "earth-first" //mapType
	, function() {
	}, initCallback, function(){ alert("fail"); } // failCallback
	);

	function initCallback(obj) {
		SOPPlugin = obj;
		SOPPlugin.getViewCamera().moveLonLat(126.9601975, 37.535007);
		SOPPlugin.getViewCamera().setAltitude(5000);

		var SOPLayerList = SOPPlugin.getLayerList();
		var ddragLon, ddragLat, udragLon, udragLat;

		window.sop.earth.addEventListener(SOPPlugin, "lmousedown", function(
				event) {
			var cod = event.getMapCoordinate();
			ddragLon = cod.Longitude;
			ddragLat = cod.Latitude;
		});

		window.sop.earth.addEventListener(SOPPlugin, "lmouseup",
				function(event) {
					var cod = event.getMapCoordinate();
					udragLon = cod.Longitude;
					udragLat = cod.Latitude;
					if (ddragLon == udragLon && ddragLat == udragLat) {
						alert('click');
					} else {
						alert('drag');
					}
				});
	}
</script>

</head>
<body>
	<div id="vMap" style="width:800px;height:600px;"></div>
</body>
</html>