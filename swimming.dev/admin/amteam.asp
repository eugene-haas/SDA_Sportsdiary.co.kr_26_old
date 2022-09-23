<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.lte.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/team.js<%=CONST_JSVER%>8"></script>
</head>


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
                document.getElementById('mk_g11').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('mk_g12').value = fullAddr;
                document.getElementById('mk_g12').focus();

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



<body <%=CONST_BODY%>>

<div class="wrapper">

  <!-- #include virtual = "/pub/html/swimming/html.header.lte.asp" -->
  <!-- #include virtual = "/pub/html/swimming/html.left.lte.asp" -->


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%=menustr(0)%>
        <small>출전선수관리</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
        <li class="active">출전선수관리</li>
      </ol>
    </section>

    <section class="content">
			<!-- #include file = "./body/c.amteam.asp" -->
    </section>
  </div>

  <!-- #include virtual = "/pub/html/swimming/html.footer.lte.asp" -->

  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->





<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>

<!-- DataTables -->
<script src="/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/plugins/datatables/dataTables.bootstrap.min.js"></script>

<!-- SlimScroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>

<script src="/dist/js/app.min.js"></script><!-- AdminLTE App -->

<!-- AdminLTE for demo purposes -->
<%'<script src="/dist/js/demo.js"></script>%>





<!-- date-range-picker -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
<script src="/plugins/daterangepicker/daterangepicker.js"></script>
<!-- bootstrap datepicker -->
<script src="/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- bootstrap time picker -->
<script src="/plugins/timepicker/bootstrap-timepicker.min.js"></script>
<!-- iCheck 1.0.1 -->
<script src="/plugins/iCheck/icheck.min.js"></script>


<!-- Page script -->












</body>
</html>	