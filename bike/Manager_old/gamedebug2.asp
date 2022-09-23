<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->

<%
  Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->
<script type="text/javascript" src="/pub/js/tennis_gameDebug.js?ver=15"></script>
</head>

<body <%=CONST_BODY%>>

<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm">
    
  </div>
</div>


<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body">
  <article>
  <!-- #include file = "./body/c.gameDebug2.asp" -->
  </article>
</div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" --> 
</body>
</html>