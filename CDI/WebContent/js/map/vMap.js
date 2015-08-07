var apiMap = null;
var apiMap3D = null;
var groupMarker;
var NTrafficInfo;
var findLayerName;
var pClickControl;
var rClickControl;
var preFeatId;
var getWfsPoints;
var dataControl;

var pageBlock;
var pageStart;
var pageEnd;
var preBlock;
var nextBlock;

var pageInfo = {
	totalRecord : 	0,
	totalPage	:	0,
	pageIndex	:	1,
	nextPage	:	0,
	prePage		:	0,
	pageUnit	:	5,
	pageSize	:	5
};
var sketchColor = '#0649FB';
var sketchSymbolizers = {
		'Point': {pointRadius: 3,graphicName: 'square',fillColor: 'white',fillOpacity: 1,strokeWidth: 1,strokeOpacity: 1,strokeColor:sketchColor},
		'Line': {strokeWidth: 3,strokeOpacity: 0.6,strokeColor: sketchColor,strokeDashstyle: 'solid'},
		'Polygon': {strokeWidth: 3,strokeOpacity: 0.6,strokeColor: sketchColor,fillColor: sketchColor,fillOpacity: 0.1}
};
var selFeature = {
		strokeWidth: 4,		
		strokeOpacity: 1,	
		strokeColor: "#20c02f",	
		fillColor: "#fff",		
		fillOpacity: 0.6
};
var selFeatureP = {
		strokeWidth: 4,		
		strokeOpacity: 1,	
		strokeColor: "#ea6721",	
		fillColor: "#fff",		
		fillOpacity: 0.6
};
var searchFeature = {
		strokeWidth: 2.5,	
		strokeOpacity: 0.8,	
		strokeColor: "#ea6721",	
		fillColor: "#fff",		
		fillOpacity: 0.3
};
var map3DLayerList;
var mapView;
vworld.useChart = true;//차트 사용 유무
setTimeout(function(){
	vworld.showMode = false; 
	vworld.init("vMap", "base-first", 
		function() {        
			apiMap = this.vmap; 
			
			//기능버튼 추가
			apiMap.addVWORLDControl("zoomBar");
			apiMap.addVWORLDControl("indexMap");
			apiMap.addVWORLDControl("layerSwitch");					
			apiMap.setIndexMapPosition("right-bottom");
			
			//화면중심점과 레벨로 이동
			apiMap.setCenterAndZoom(14137025.510094, 4411241.3503068, 8);  
			apiMap.addEvent("zoomend", getScaleEvt);
			
			OpenLayers.ProxyHost = "/proxy/proxy.jsp?url=";
			
			if(document.createStyleSheet) {
				document.createStyleSheet('/css/popup.css');
			}else{
				var styles = "@import url('/css/popup.css');";
				var newSS=document.createElement('link');
				newSS.rel='stylesheet';
				newSS.href='data:text/css,'+escape(styles);
				document.getElementsByTagName("head")[0].appendChild(newSS);
			}
			
		}
	);
}, 500);


/**
 * 그룹마커생성
 * @param groupName
 * @param lon
 * @param lat
 * @param title
 * @param desc
 * @param imgurl
 */
function groupAddMarker(groupName, lon, lat,title, desc, imgurl){
	if(groupMarker != undefined){
		var marker = groupMarker.addMarker(groupName, lon, lat,title, desc, imgurl);
		if(marker != undefined){
			if (typeof imgurl == 'string') {marker.setIconImage(marker.icon.url);}
			apiMap.addMarker(marker);
		}
	} else {
		alert('생성된 그룹이 없습니다.');
	}
}

/**
 * 레이어 제어
 * @param layerName
 * @param isCheck
 */
var impLayer;
var impLayer2;
var impLayer3;
function reloadLayers(layerName,isCheck,style){
	if(style == 'blue_light2darkblue_pop_14'){
		if(isCheck){
			impLayer = new OpenLayers.Layer.WMS(layerName, 'http://localhost:8087/geoserver/sf/wms?service=WMS&', {
	            'layers': layerName,
	            'styles': style,
	            'format': 'image/png',
	            'srs': 'EPSG:900913',
	            'exceptions': "text/xml",
	            'version': '1.3.0',
	            'transparent': true
	        }, {
	            'isBaseLayer': false,
	            'singleTile': false,
	            'visibility': true
	        });
			apiMap.addLayer(impLayer);
		}else{
			apiMap.removeLayer(impLayer);
		}
	}else if(style == 'green_light2darkgreen_pop_14_65'){
		if(isCheck){
			impLayer2 = new OpenLayers.Layer.WMS(layerName, 'http://localhost:8087/geoserver/sf/wms?service=WMS&', {
	            'layers': layerName,
	            'styles': style,
	            'format': 'image/png',
	            'srs': 'EPSG:900913',
	            'exceptions': "text/xml",
	            'version': '1.3.0',
	            'transparent': true
	        }, {
	            'isBaseLayer': false,
	            'singleTile': false,
	            'visibility': true
	        });
			apiMap.addLayer(impLayer2);
		}else{
			apiMap.removeLayer(impLayer2);
		}
	}else if(style == 'orrd_lightorange2darkred_pop_14_75'){
		if(isCheck){
			impLayer3 = new OpenLayers.Layer.WMS(layerName, 'http://localhost:8087/geoserver/sf/wms?service=WMS&', {
	            'layers': layerName,
	            'styles': style,
	            'format': 'image/png',
	            'srs': 'EPSG:900913',
	            'exceptions': "text/xml",
	            'version': '1.3.0',
	            'transparent': true
	        }, {
	            'isBaseLayer': false,
	            'singleTile': false,
	            'visibility': true
	        });
			apiMap.addLayer(impLayer3);
		}else{
			apiMap.removeLayer(impLayer3);
		}
	}
}

/**
 * 스케일값 리턴
 * @param e
 */
function getScaleEvt(e){
	var vScale = $("#txtScale");
	var intScale = numchk(parseInt(apiMap.getScale()));
	vScale.val(intScale);
}

/**
 * 스케일값 설정
 * @param e
 */
function setScaleEvt(){
	var vScale = $("#txtScale");
	apiMap.zoomToScale(vScale.val(), true);
}

/**
 * 인덱스 활성화/비활성화
 */
function indexMapControl(){
	var temp = $("#indexChk");
	if(temp.val() == "On"){
		apiMap.removeVWORLDControl("indexMap");
		temp.val("Off");
	}else{
		apiMap.addVWORLDControl("indexMap");
		temp.val("On");
	}
}

/**
 * 검색api
 * @param kind
 */
function vSearch(kind){
	var vKind = kind;
	var params="vKind="+vKind;  
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/vSearch.do",
	    data : params,
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	$('#westDiv').html(response);   
	    },
	    beforeSend: function() {
	    	$('#ajax_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#ajax_indicator').fadeOut();
	    }
	});
}


/**
 * 검색api 결과조회
 * @param index
 * @returns {Boolean}
 */
function vSearchL(index){
	var pageIndex = index;
	if(pageIndex == null){
		pageIndex = 1;
	}	
	var vNm = $("#vNm").val();
	var category = $("#vCategory").val();
	var params="vNm="+vNm+"&category="+category+"&pageIndex="+pageIndex;  
	if(vNm == null || vNm==""){
		alert("검색명을 입력해 주세요.");		
		return false;
	}else{
		$.ajax({
		    type : "POST",
		    async : true,
		    url : "/vSearchL.do",
		    data : params,
		    dataType : "html",
		    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    error : function(request, status, error) {
		    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
		    },
		    success : function(response, status, request) {
		    	$('#westResult').html(response); 
		    	vSearchLmove(category);
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

/**
 * 검색api 검색리스트 지도 이동
 */
function vSearchLmove(kind){
	
	var vKind = kind;
	var vx = new Array();
	var vy = new Array();
	var vNo = new Array();
	var vPnu = new Array();
	var vNameFull = new Array();
	var vNameDp = new Array();
	var vNjuso =  new Array();
	var vJuso = new Array();
	var vRdNm = new Array();
	var vZipCl = new Array();
	var vNcode = new Array();
	var vCodeName = new Array();
	
	var xpos = $("[name=xpos]");
    var ypos = $("[name=ypos]");
    var vworldNo = $("[name=vworldNo]");
    var pnu,nameFull,nameDp,juso,njuso,rdNm,zipCl,nCode,codeName;
    if(vKind == "Poi"){
	    pnu = $("[name=pnu]");
	    nameFull = $("[name=nameFull]");
	    nameDp = $("[name=nameDp]");
	    juso = $("[name=juso]");
	    njuso = $("[name=njuso]");
	    rdNm = $("[name=rdNm]");
	    zipCl = $("[name=zipCl]");
	    nCode = $("[name=nCode]");
	    codeName = $("[name=codeName]");
    }
    
    var markers;
	apiMap.initAll();
	markers = new OpenLayers.Layer.Markers( "Markers" );
	 $("input[name=xpos]").each(function(idx) {
    	vx[idx] = xpos.eq(idx).val();
    	vy[idx] = ypos.eq(idx).val();
    	
		vNo[idx] = vworldNo.eq(idx).val();
		if(vKind == "Poi"){	
        	vPnu[idx] = pnu.eq(idx).val();
        	vNameFull[idx] = nameFull.eq(idx).val();
        	vNameDp[idx] = nameDp.eq(idx).val();
        	vJuso[idx] = juso.eq(idx).val();
        	vNjuso[idx] = njuso.eq(idx).val();
        	vRdNm[idx] = rdNm.eq(idx).val();
        	vZipCl[idx] = zipCl.eq(idx).val();
        	vNcode[idx] = nCode.eq(idx).val();
        	vCodeName[idx] = codeName.eq(idx).val();
    	}
    	
    	
    	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
		var epsg4326   = new OpenLayers.Projection('EPSG:4326');
		var transCod = new OpenLayers.Geometry.Point(vx[idx], vy[idx]).transform(epsg4326,epsg900913);
    	
		var popupContentHTML = "";
		if(vKind == "Poi"){
		    popupContentHTML += "<div class='popup_area'>";
			popupContentHTML += "<div class='titlePop'>"+vNameFull[idx]+"</div>";
			popupContentHTML += "<div class='clear'></div>";
			popupContentHTML += "<div class='contents'>";
			popupContentHTML += "<div class='detail'>";
			popupContentHTML += "<table class='table'>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<th width='120'>구주소</th>";
			popupContentHTML += "<td>"+vJuso[idx]+"</td>";
			popupContentHTML += "</tr>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<th>새주소</th>";
			popupContentHTML += "<td>"+vNjuso[idx]+"</td>";
			popupContentHTML += "</tr>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<th>위치이름</th>";
			popupContentHTML += "<td>"+vNameDp[idx]+"</td>";
			popupContentHTML += "</tr>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<th>NCODE</th>";
			popupContentHTML += "<td>"+vNcode[idx]+"</td>";
			popupContentHTML += "</tr>";
			popupContentHTML += "<tr>";
			popupContentHTML += "<th>카테고리</th>";
			popupContentHTML += "<td>"+vCodeName[idx]+"</td>";
			popupContentHTML += "</tr>";
			popupContentHTML += "</table>";
			popupContentHTML += "</div>";
			popupContentHTML += "</div>";
			popupContentHTML += "</div>";
		}
	    var imgUrl = '/images/search/bul_poi_b_'+vNo[idx]+'.png';
	    
    	addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
		markers.addMarker(marker);
    });
 apiMap.zoomToExtent(markers.getDataExtent());
}

/**
 * 검색 api 개별지도 이동
 * @param cnt
 * @param pnu
 * @param nameFull
 * @param nameDp
 * @param juso
 * @param nJuso
 * @param rdNm
 * @param zipCl
 * @param ncode
 * @param codeName
 * @param ypos
 * @param xpos
 * @param vKind
 */
function vSearchMove(cnt,pnu,nameFull,nameDp,juso,nJuso,rdNm,zipCl,ncode,codeName,ypos,xpos,vKind){
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    var transCod = new OpenLayers.Geometry.Point(xpos, ypos).transform(epsg4326,epsg900913);
    
    var popupContentHTML = "";
    if(vKind == "Poi"){
    	popupContentHTML += "<div class='popup_area'>";
    	popupContentHTML += "<div class='titlePop'>"+nameFull+"</div>";
    	popupContentHTML += "<div class='clear'></div>";
    	popupContentHTML += "<div class='contents'>";
    	popupContentHTML += "<div class='detail'>";
    	popupContentHTML += "<table class='table'>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th width='120'>구주소</th>";
    	popupContentHTML += "<td>"+juso+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>새주소</th>";
    	popupContentHTML += "<td>"+nJuso+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>위치이름</th>";
    	popupContentHTML += "<td>"+nameDp+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>NCODE</th>";
    	popupContentHTML += "<td>"+ncode+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "<tr>";
    	popupContentHTML += "<th>카테고리</th>";
    	popupContentHTML += "<td>"+codeName+"</td>";
    	popupContentHTML += "</tr>";
    	popupContentHTML += "</table>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    	popupContentHTML += "</div>";
    }
		
    var imgUrl = '/images/search/bul_poi_b_'+cnt+'.png';
    
	apiMap.initAll();
	addMarker(transCod.x, transCod.y, popupContentHTML, imgUrl);
    var markers = new OpenLayers.Layer.Markers( "Markers" );
	markers.addMarker(marker);
	apiMap.zoomToExtent(markers.getDataExtent());
}


/**
 * 마커 표출
 * @param lon
 * @param lat
 * @param message
 * @param imgurl
 */
function addMarker(lon, lat, message, imgurl){
	
	marker = new vworld.Marker(lon, lat,message,"");
	
	// 마커 아이콘 이미지 파일명 설정합니다.
	if (typeof imgurl == 'string') {marker.setIconImage(imgurl);}
	
	//마커이미지 이벤트 id
	var size = marker.events.element.id.toString();
	
	//마커이미지 이벤트 id + _innerImage = 마커이미지 아이디
	size = size + '_innerImage';
	
	// 마커의 z-Index 설정
	marker.setZindex(3);
	apiMap.addMarker(marker);
	
	var markerImg = $('#'+size);//document.getElementById(size);
	markerImg.width(50);
	markerImg.height(50);//style.height = "60px";
}

/**
 * 데이터API 레이어 결정 
 * @param wfsFindLayer
 */
function getWfsFindLayer(wfsFindLayer){
  	findLayerName = wfsFindLayer;
}

/**
 * 데이터API 이벤트 등록 및 활성화
 */
function getWfsValue(control){
	dataControl = control;
	apiMap.init();
	pClickControl = null;
	var pointOptions = {persist:true};
	if(dataControl == "buffer"){
		if (pClickControl == null) {
			pClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
			pClickControl.events.on({"measure": getWfsclick});
	    	apiMap.addControl(pClickControl);
		} 
	}
	pClickControl.activate();
}

function createBounds(bounds){ // 해당 폴리곤 객체의 Boundary를 표시하기 위한 사각형 폴리곤 그리기 
	var points = [];
	points.push(new OpenLayers.Geometry.Point(bounds.left, bounds.top)); 
	points.push(new OpenLayers.Geometry.Point(bounds.right, bounds.top)); 
	points.push(new OpenLayers.Geometry.Point(bounds.right, bounds.bottom)); 
	points.push(new OpenLayers.Geometry.Point(bounds.left, bounds.bottom)); 
	
	var style = {strokeColor: "#00FF00", fillColor: "#00FF00", strokeOpacity: 1, fillOpacity:0.1, strokeWidth: 2}; 
	var poly = new vworld.Polygon(points, style);
	
	apiMap.vectorLayer.addFeatures([poly]);
}

/**
 * 데이터API 정보 조회
 * @param evt
 */
var Circle = null;
var tCircle;
function getWfsclick(evt){
	
	//OpenLayers.ProxyHost = "/proxy/proxy.jsp?url=";
	
	getWfsPoints = evt;
	
	var lonLatPosition = new OpenLayers.LonLat(getWfsPoints.geometry.x, getWfsPoints.geometry.y);
	var px = apiMap.getPixelFromLonLat(lonLatPosition);
	var pixel = new OpenLayers.Pixel(px.x - 4, px.y + 4);
    var min = thisMap.getLonLatFromPixel(pixel);
    var pixel = new OpenLayers.Pixel(px.x + 4, px.y - 4);
    var max = thisMap.getLonLatFromPixel(pixel);
    var MinX = Math.abs(min.lon);
    var MinY = Math.abs(min.lat);
    var MaxX = Math.abs(max.lon);
    var MaxY = Math.abs(max.lat);
    var SearchPoint = MinX + "," + MinY + "," + MaxX + "," + MaxY;
	var params = "";
	
	params += "service=wfs";
	//params += "&BBOX="+tCircle.getBounds()+"" ;
	params += "&BBOX="+SearchPoint+"" ;
	params += "&version=1.1.0";
	params += "&request=GetFeature";
	params += "&typeNames="+findLayerName+"";
	params += "&output=text/xml;subType=gml/3.1.1/profiles/gmlsf/1.0.0/0";
	params += "&srsName=EPSG:900913";
	//params += "&outputFormat=json";
	//params += "&format_options=callback:getJson";
	
	OpenLayers.loadURL = function(uri, params, caller,
    onComplete, onFailure) {
		if(typeof params == 'string') {
		params = OpenLayers.Util.getParameters(params);
		}
		
		var success = (onComplete) ? onComplete : OpenLayers.nullHandler;
		var failure = (onFailure) ? onFailure : OpenLayers.nullHandler;
		
		return OpenLayers.Request.POST({	
		url: uri, params: params,
		success: success, failure: failure, scope: caller
		});
	};
	
	OpenLayers.loadURL("/proxy/proxy.jsp", "?url=" + escape("http://localhost:8087/geoserver/sf/wfs?" + params), this, wfsClickResult);
    return;
	
}

function wfsClickResult(response){
	
	var g = new OpenLayers.Format.GML.v3();
    var features = g.read(response.responseText);
    
    
    apiMap.vectorLayer.addFeatures(features);
    var popX;
    var popY;
    var pop_14;
    var pop_14_65;
    var pop_14_75;
    var natureTown;
	if (features != null && features.length > 0) {
		for(var i=0;i<features.length;i++) {
			for (var j in features[i].attributes) {
				if(j == "pop_14"){
					pop_14 = features[i].attributes[j];
				}
				if(j == "pop_14_65"){
					pop_14_65 = features[i].attributes[j];
				}
				if(j == "pop_14_75"){
					pop_14_75 = features[i].attributes[j];
				}
				if(j == "자연마을명"){
					natureTown = features[i].attributes[j];
					
					popX = features[i].geometry.getCentroid().x;
					popY = features[i].geometry.getCentroid().y;
					
					createPieChart(pop_14, pop_14_65, pop_14_75, natureTown, popX, popY);
				}
				
			}
		}
	} 
	features= null;
	
}

function wfsClickErr(e){
	alert(e);
}

function createPieChart(pop_14, pop_14_65, pop_14_75, natureTown, popX, popY){
	
	var sum = Number(pop_14)+Number(pop_14_65)+Number(pop_14_75);
	var pop1 = Number(pop_14);
	var pop2 = Number(pop_14_65);
	var pop3 = Number(pop_14_75);
	
	vChartLayer = apiMap.getLayerByName("chartMap");//pieCharMap을 vchartLayer 변수에 저장
	if (vChartLayer == null) {
		//차트객체 생성
		vChartLayer = new vworld.Charts("chartMap",{displayInLayerSwitcher:false}); //false로 반영할것.
	}
	
	//파이chart 보일준비 완료
	vChartLayer.setVisibility(true);
	
	//파이chart 투명도 설정(0~1 실수)
	vChartLayer.setOpacity(1);
	
	//파이 chart 설정
	pieChart = new vworld.Chart(
			new OpenLayers.LonLat(popX,popY),//위치
			{
				type:'pie',//차트 종류(파이:pie,막대:bar,라인:line)
				values:[sum,pop1,pop2,pop3],//통계값
				labels:['계:'+sum,'65세미만:'+pop1,'65세이상:'+pop2,'75세이상:'+pop3],//통계값 라벨
				//labels:['계:5','남:2','여:1','게이:2'],//통계값 라벨
				animate:true,//애니메이션 효과
				minlevel:10,//차트가 보여질 최소 레벨
				makelegend:true,//통계범례
				maxlevel:19,//차트가 보여질 최대 레벨
				title:natureTown,//통계제목
				//title:'서울특별시',//통계제목
				colors:['#d26900','#d89243','#726056','#d26900']//통계색상
			}
	);	
	//pieChart.events.on({"click": getWfsclick});
	vChartLayer.addChart(pieChart);//차트 객체에 파이객체를 add
}

/**
 * 차트 객체 삭제
 */
function delChart(){
	if(vChartLayer != null){
		vChartLayer.clearCharts();//차트 레이어 지우기
		vChartLayer = null;//객체 초기화
	}	
}


/**
 * 로드뷰 이벤트 활성화
 */
var chkEvt = true;
function roadViewStart(){
	 
	if(chkEvt == true){
		apiMap.initAll();
		var pointOptions = {persist:true};
		if (rClickControl == null) {
			rClickControl = new OpenLayers.Control.Measure(OpenLayers.Handler.Point,{handlerOptions:pointOptions});
			rClickControl.events.on({"measure": roadMapclick});
			apiMap.addControl(rClickControl);
		}        
		apiMap.init();
		rClickControl.activate();
		chkEvt = false;
	 }else{
		 apiMap.initAll();
		 rClickControl.deactivate();
		 myInnerLayout.hide('east');
		 chkEvt = true;
	 }
	 
}

/**
 * 로드뷰 시작 이벤트
 * @param evt
 */
function roadMapclick(evt){
	
	myInnerLayout.toggle('east');
	
	apiMap.init();
	var temp = evt.geometry;	
	var pos = new OpenLayers.LonLat(temp.x, temp.y);
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
	var epsg4326   = new OpenLayers.Projection('EPSG:4326');
	
	var transCod = new OpenLayers.Geometry.Point(pos.lon, pos.lat).transform(epsg900913,epsg4326);
	var transY = transCod.y;
	var transX = transCod.x;
	
	var mTw = roadWidth/2;
	var mTh = roadHeight;
	
	var params="transX="+transX+"&transY="+transY+"&dTw="+mTw+"&dTh="+mTh;  
	$.ajax({
	    type : "POST",
	    async : true,
	    url : "/dRoadView.do",
	    data : params,
	    dataType : "html",
	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    error : function(request, status, error) {
	    	alert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	    },
	    success : function(response, status, request) {
	    	$('#dRoadview').html(response);   
	    },
	    beforeSend: function() {
	    	$('#ajax_indicator').show().fadeIn('fast');
	    },
	    complete: function() {
	    	$('#ajax_indicator').fadeOut();
	    }
	});
}

/**
 * 로드뷰 이동 이벤트
 * @param dRvY
 * @param dRvX
 * @param dRvPoint
 */
function rvMove(dRvX, dRvY, dRvPoint){
	
	apiMap.initAll();
	
	var epsg900913 = new OpenLayers.Projection('EPSG:900913');
    var epsg4326   = new OpenLayers.Projection('EPSG:4326');
    
    /**
     * 로드뷰가 이동시에 반환되는 좌표값을 구글좌표로 변환
     */
    var transCod = new OpenLayers.Geometry.Point(dRvX, dRvY).transform(epsg4326, epsg900913);
    /**
     * 변환한 좌표를 지도화면에 반영
     */
    apiMap.setCenter(new OpenLayers.LonLat(transCod.x, transCod.y),19);
    
	marker = new vworld.Marker(transCod.x, transCod.y, null, "");
	
	// 마커 아이콘 이미지 파일명 설정합니다.
	marker.setIconImage("http://localhost:8080/images/roadview.png");
	
	// 마커의 z-Index 설정
	marker.setZindex(3);
	
	apiMap.addMarker(marker);
	
	//마커이미지 이벤트 id
	var rotate = marker.events.element.id.toString();
	
	//마커이미지 이벤트 id + _innerImage = 마커이미지 아이디
	rotate = rotate + '_innerImage';
	
	var markerImg = document.getElementById(rotate);
	markerImg.style.width = "50px";
	markerImg.style.height = "60px";
	
	var browser = navigator.userAgent.toLowerCase();
	
	//마커 회전
	if(dRvPoint != ""){
		if(browser.indexOf("msie 7") != -1 || browser.indexOf("msie 8") != -1){
			try{
				var deg2rad = Math.PI * 2 / 360;
				var rad = dRvPoint * deg2rad;
				var costheta = Math.cos(rad);
				var sintheta = Math.sin(rad);
				markerImg.style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11='1.0', sizingmethod='auto expand')alpha(opacity=100);";
				markerImg.filters.item(0).M11 = costheta;
				markerImg.filters.item(0).M12 = -sintheta;
				markerImg.filters.item(0).M21 = sintheta;
				markerImg.filters.item(0).M22 = costheta;
			}catch(e){	
				
				markerImg.style.MozTransform    = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.WebkitTransform = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.OTransform      = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.MsTransform     = 'rotate(' + dRvPoint + 'deg)';
				markerImg.style.transform       = 'rotate(' + dRvPoint + 'deg)';
			}
		}else{
			markerImg.style.MozTransform    = 'rotate(' + dRvPoint + 'deg)';
			markerImg.style.WebkitTransform = 'rotate(' + dRvPoint + 'deg)';
			markerImg.style.OTransform      = 'rotate(' + dRvPoint + 'deg)';
			markerImg.style.MsTransform     = 'rotate(' + dRvPoint + 'deg)';
			markerImg.style.transform       = 'rotate(' + dRvPoint + 'deg)';
		}
	}
}


/**
 * 숫자 정리
 * @param num
 * @returns
 */
function numchk(num){
	var sign="";
	if(isNaN(num)) {
		alert("숫자만 입력할 수 있습니다");
		return 0;
	}
	if(num==0){ return num; }
	if(num<0){
		num=num*(-1);
		sign="-";
	}else num=num*1;
	num = new String(num);
	var temp="";
	var pos=3;
	num_len=num.length;
	while (num_len>0){
		num_len=num_len-pos;
		if(num_len<0) {
			pos=num_len+pos;
			num_len=0;
		}
		temp=","+num.substr(num_len,pos)+temp;
	}
	return sign+temp.substr(1);
}

/**
 * 홈페이지 링크
 * @param link
 * @returns {Boolean}
 */
function hpLink(link){
	  if(link == undefined || link == ""){
		  alert("홈페이지가 없습니다.");
		  return false;
	  }else{
		  window.open(""+link+"", "링크"); 
	  }
	  
}