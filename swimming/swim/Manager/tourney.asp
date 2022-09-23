<!-- #include virtual = "/pub/header.swimAdmin.asp" -->

<%
  Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>
<head>

</head>

<body <%=CONST_BODY%>>
  <div class="backLayer" style="z-index:999;" > </div>
  <div id="loadingDiv" style="z-index:999;"></div>
  <div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>
  
  <!-- #include virtual = "/pub/html/swimAdmin/html.head.asp" -->
  <div id="body">
    <aside>
    <!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
    </aside>

    <article>
      <h1>테니스 대진표</h1>

    </article>
  </div>
  <!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->
</body>
</html>
