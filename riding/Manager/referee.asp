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
  <script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/referee.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>
  <div class="t_default">

    <div id="myModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>


    <!-- #include virtual = "/pub/html/riding/html.header.asp" -->

    <div id="body">
      <aside>
	  <%pagename = "makeplayer.asp"%>
	  <!-- #include virtual = "/pub/html/riding/html.left.asp" -->
	  <%pagename = "referee.asp"%>
	  </aside>

      <article id="sc_body">
      <!-- #include file = "./body/c.referee.asp" -->
      </article>
    </div>

    <!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
  </div>
</body>
</html>
