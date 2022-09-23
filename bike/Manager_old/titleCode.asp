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
<%'<script type="text/javascript" src="/pub/js/tablesort.js"></script>%>
<script type="text/javascript" src="/pub/js/menu1/tn_1_5.js?ver=15"></script>
</head>

<body <%=CONST_BODY%>>

<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body">
  <aside>
  <!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
  </aside>

  <article>
  <!-- #include file = "./body/c.titleCode.asp" -->
  </article>
</div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" --> 
</body>
</html>