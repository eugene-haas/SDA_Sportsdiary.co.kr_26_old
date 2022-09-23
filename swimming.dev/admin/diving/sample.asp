<!-- #include virtual = "/pub/header.종목.asp" -->
<%
'DB오픈
	Set db = new clsDBHelper 
'##############################################
' 소스 뷰 경계
'##############################################
%>

<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/종목폴더/head.asp" -->
	<script type="text/javascript" src="/pub/js/페이지별스크립트.js<%=CONST_JSVER%>"></script>
	
  </head>
<body>
		<!--모달 또는 폼 정의 -->
    <div id="myModal"></div>
    <form method='post' name='sform'><input type='hidden' name='p'></form>

  <div class="wrapper">
    <!-- #include virtual = "/pub/html/종목폴더/html.header.asp" -->
    <!-- #include virtual = "/pub/html/종목폴더/html.left.asp" -->

      <section class="content">
      <!-- #include file = "./body/c.컨텐츠명.asp" --> 
      </section>
  </div>

  <!-- #include virtual = "/pub/html/종목폴더/html.footer.asp" -->
  <!--DB종료-->
</div>
</body>
</html>	
