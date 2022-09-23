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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/contest.js<%=CONST_JSVER%>"></script>

</head>
<body <%=CONST_BODY%>>
  <div class="t_default contest">
    <!-- #include virtual = "/pub/html/riding/html.header.asp" -->
    <div id="body">
      <aside>
			<%pagename = "homephoto.asp"%>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			<%pagename = "homephotowrtie.asp"%>
      </aside>

      <!-- 컨텐츠 시작 -->
      <article>
        <!-- #include virtual = "/body/c.homephotoWrite.asp" -->
      </article>
    </div>
		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
	</div>
</body>
</html>
