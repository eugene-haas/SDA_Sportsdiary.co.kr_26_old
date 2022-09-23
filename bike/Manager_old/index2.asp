<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/pub/inc/crypt.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.admin.asp" -->


<%
'	Set fs = Server.CreateObject("Scripting.FileSystemObject")
'''	Set objFile = fs.OpenTextFile(server.MapPath(".") & "\"& filename ,8,true)
'	Set objFile = fs.OpenTextFile("D:\sportsdiary.co.kr\bike\Manager\log1.txt" ,8,true)
'	objFile.writeLine("dddaaa")


	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/bike/html.head.admin.asp" -->
<script type="text/javascript" src="/pub/js/bike/bike_findcontestplayer_dev.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>
<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>
<!-- #include virtual = "/pub/html/bike/html.top.admin.asp" -->
<!-- S: content -->
<div class="content">
<!-- #include virtual = "/pub/html/bike/html.left.admin.asp" -->

    <!-- S: right-content -->
    <div class="right-content">
        <!-- S: navigation -->
        <%Call topnav(menustr(0),menustr(1))%>
        <!-- E: navigation -->

    	<div class="pd-30">
            <!-- S: sub-content -->
		    <div class="sub-content">
                <div class="chart-1">
                  <h4 class="h-title">07월 요일별 통계</h4>
                  <div class="box-shadow">
                    <canvas id="myChart"></canvas>
                    <script>
                      var ctx = document.getElementById("myChart");
                      var myChart = new Chart(ctx, {
                          type: 'bar',
                          data: {
                              labels: ["월", "화", "수", "목", "금", "토", "일"],
                              datasets: [{
                                  label: '# 방문자수',
                                  data: [1, 3,4, 7, 12, 33, 3],
                                  backgroundColor: [
                                      'rgba(255, 99, 132, 0.2)',
                                      'rgba(54, 162, 235, 0.2)',
                                      'rgba(255, 206, 86, 0.2)',
                                      'rgba(75, 192, 192, 0.2)',
                                      'rgba(153, 102, 255, 0.2)',
                                      'rgba(255, 159, 64, 0.2)',
                                      'rgba(53, 129, 154, 0.2)',
                                  ],
                                  borderColor: [
                                      'rgba(255,99,132,1)',
                                      'rgba(54, 162, 235, 1)',
                                      'rgba(255, 206, 86, 1)',
                                      'rgba(75, 192, 192, 1)',
                                      'rgba(153, 102, 255, 1)',
                                      'rgba(255, 159, 64, 1)',
                                      'rgba(53, 129, 154, 1)',
                                  ],
                                  borderWidth: 1
                              }]
                          },
                          options: {
                              scales: {
                                  yAxes: [{
                                      ticks: {
                                          beginAtZero:true
                                      }
                                  }]
                              }
                          }
                      });
                      </script>
                    </div>
                  </div>

    	    </div>
            <!-- E: sub-content -->
        </div>

    </div>
    <!-- E: right-content -->
</div>
<!-- E: content -->

<%
global_HP = "bike"

	AdminGameTitlee = fInject(Request.cookies("AdminGameTitle"))
	AdminGameTitle = decode(AdminGameTitlee,0)
	Authority = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("Authority")))

Response.write Authority & "--------"
%>



<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
