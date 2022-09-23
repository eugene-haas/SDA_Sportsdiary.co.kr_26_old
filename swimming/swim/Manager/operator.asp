<!-- #include virtual = "/pub/header.swimAdmin.asp" -->

<%
  Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
  <!-- #include virtual = "/pub/html/swimAdmin/html.head.v1.asp" -->
  <%'<script type="text/javascript" src="/pub/js/swim/tablesort.js"></script>%>
  <script type="text/javascript" src="/pub/js/swim/tennis_operator.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>

  <!-- #include virtual = "/pub/html/swimAdmin/html.header.asp" -->

  <div id="body">
    <aside>
    <!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
    </aside>

    <article>
    <!-- #include file = "./body/c.operator.asp" -->
    </article>
  </div>

  <!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->
</body>
</html>
