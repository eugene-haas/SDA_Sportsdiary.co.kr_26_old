<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
  Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.asp" -->
<%'<script type="text/javascript" src="/pub/js/RookieTennis/tablesort.js"></script>%>
<script type="text/javascript" src="/pub/js/RookieTennis/menu1/tn_1_5.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.header.asp" -->

<div id="body">
  <aside>
  <!-- #include virtual = "/pub/html/RookietennisAdmin/html.left.asp" -->
  </aside>

  <article>
  <!-- #include file = "./body/c.titleCode.asp" -->
  </article>
</div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" --> 
</body>
</html>