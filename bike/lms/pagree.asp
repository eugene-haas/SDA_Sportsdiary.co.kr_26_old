<!-- #include virtual = "/pub/header.bike.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<!DOCTYPE html>
<html>

<!-- #include virtual = "/pub/html/bike/html.head.app.asp" -->

<!-- #include virtual = "/pub/inc/bike/filecheck.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.asp" -->
<%



'링크 패킷생성
'page define##############
'개인종목 단체종목이 있는지 여부와 리스트까지 가져오자...
Call oJSONoutput.Set( "name",  "보호자동의" )
'page define##############	

'##############################################
' 소스 뷰 경계
'##############################################
%>
<!-- #include virtual = "/pub/html/bike/html.head.app.asp" -->
<script type="text/javascript" src="/pub/js/bike/request_history.app.js?ver=3"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<script type="text/javascript">
<!--
var addr =  mx || {};
addr.element_layer;
$(document).ready(function(){
	// 우편번호 찾기 화면을 넣을 element
	addr.element_layer = document.getElementById('dnlayer');
}); 

function closeDaumPostcode() {
	// iframe을 넣은 element를 안보이게 한다.
	addr.element_layer.style.display = 'none';
}

// 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
// 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
function initLayerPosition(){
	var width = 100; //우편번호서비스가 들어갈 element의 width
	var height = 400; //우편번호서비스가 들어갈 element의 height
	var borderWidth = 5; //샘플에서 사용하는 border의 두께

	// 위에서 선언한 값들을 실제 element에 넣는다.
	addr.element_layer.style.width = width + '%';
	addr.element_layer.style.height = height + 'px';
	addr.element_layer.style.border = borderWidth + 'px solid';
	// 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
	addr.element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/4 - borderWidth) + 'px';
}		
	

function Postcode() {

        // iframe을 넣은 element를 보이게 한다.
        addr.element_layer.style.display = 'block';
        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();		
		
		new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('uaddr').value = fullAddr;
                document.getElementById('uaddr2').value= "";
				document.getElementById('uaddr2').focus();

                var DataSido = data.sido;

                if (DataSido == "제주특별자치도") {
                    DataSido = "제주";
                } else if (DataSido == "세종특별자치시") {
                    DataSido = "세종";
                }
                document.getElementById('sido').value = DataSido;

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                addr.element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(addr.element_layer);
}	
//-->
</script>
</head>
<body>
<style type="text/css">
#__daum__layer_1{min-width:auto;}
</style>
<div style="display:table;width:90%;position:fixed;top:50px;left:0;right:0;    box-sizing: border-box;margin:auto;">
 <div id="dnlayer" style="display: none; border:1px solid #000; width:100%; height:100%;">
	<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onClick="closeDaumPostcode()" alt="접기 버튼"> 
 </div>
</div>


 <!-- #include virtual = "/pub/html/bike/form.asp" -->


  <!-- S: sub-header -->
	  <div class="sub-header flex">
		  <!-- #include virtual = "/pub/html/bike/html.header.app.asp" -->
	  </div>
  <!-- E: sub-header -->

  <!-- S: sub-content -->
	  <div class="sub-content guardian">
		  <!-- #include virtual = "/bike/m_player/request/body/c.pagree.asp" -->
	  </div>
  <!-- E: sub-content -->


  <!-- S: bot-config -->
	  <!-- #include virtual = "/bike/m_player/include/bot_config.asp" -->
  <!-- E: bot-config -->


  <!-- #include virtual = "/pub/html/bike/html.footer.app.asp" -->
</body>
</html>