<html>
<head>
	<meta charset="utf-8"/>
	<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=62f6663bbf630636dc2f9ace306d2daa&libraries=services"></script>
</head>
<body>
	
	<div id="map" style="width:100%;height:200px;"></div>
	<div id="map2" style="width:100%;height:200px;"></div>
	
	<script>
		var container = document.getElementById('map'); // 이미지 지도를 표시할 div  
		var options = {
			center: new daum.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
			level: 3
		};

		var map = new daum.maps.Map(container, options);

		// 주소-좌표 변환 객체를 생성합니다
	 	var geocoder = new daum.maps.services.Geocoder();		
		
		geocoder.addr2coord('서울시 마포구 삼개로 21 근신빌딩', function(status, result) {
		
		var coords = new daum.maps.LatLng(result.addr[0].lat, result.addr[0].lng);
		var marker = new daum.maps.Marker({map: map,	position: coords	});
		var infowindow = new daum.maps.InfoWindow({	content: '<div style="width:150px;text-align:center;padding:6px 0;">위드라인</div>'	});
		
		infowindow.open(map, marker);		
		map.setCenter(coords);
 	   
 	});   
	</script>
	
	<script>
		var container2 = document.getElementById('map2'); // 이미지 지도를 표시할 div  
		var options2 = {
			center: new daum.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
			level: 3
		};

		var map2 = new daum.maps.Map(container2, options2);

		// 주소-좌표 변환 객체를 생성합니다
	 	var geocoder2 = new daum.maps.services.Geocoder();		
		
		geocoder2.addr2coord('경기도 부천시 오정구 고강본동 361-14', function(status, result2) {
		
		var coords2 = new daum.maps.LatLng(result2.addr[0].lat, result2.addr[0].lng);
		var marker2 = new daum.maps.Marker({map: map2,	position: coords2	});
		var infowindow2 = new daum.maps.InfoWindow({	content: '<div style="width:150px;text-align:center;padding:6px 0;">고강본동</div>'	});
		
		infowindow2.open(map2, marker2);		
		map2.setCenter(coords2);
 	   
 	});   
	</script>	
</body>
</html>