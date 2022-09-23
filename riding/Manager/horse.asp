<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
  Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
  <!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
  <script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/horse.js<%=CONST_JSVER%>"></script>


<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<script type="text/javascript">

    function Postcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if (data.addressType === 'R') {
                    //법정동명이 있을 경우 추가한다.
                    if (data.bname !== '') {
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if (data.buildingName !== '') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('mk_g20').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('mk_g21').value = fullAddr;
                document.getElementById('mk_g22').focus();

                var DataSido = data.sido;

                if (DataSido == "제주특별자치도") {
                    DataSido = "제주";
                } else if (DataSido == "세종특별자치시") {
                    DataSido = "세종";
                }

                $("#sido").find("option").filter(function (index) {
                    return DataSido === $(this).text();
                }).prop("selected", "selected");

                $("select[name='Sido'] option:contains('" + DataSido + "')").prop("selected", "selected");
                window.close();
            }
        }).open();
    }
   
</script>
</head>

<body <%=CONST_BODY%>>
  <div class="t_default">

    <div id="myModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>


    <!-- #include virtual = "/pub/html/riding/html.header.asp" -->

    <div id="body">
      <aside>
	  <%pagename = "makeplayer.asp"%>
      <!-- #include virtual = "/pub/html/riding/html.left.asp" -->
	  <%pagename = "horse.asp"%>
	  </aside>

      <article id="sc_body">
      <!-- #include file = "./body/c.horse.asp" -->
      </article>
    </div>

    <!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
  </div>
</body>
</html>
