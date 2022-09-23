<!-- #include virtual = "/pub/header.bm.asp" -->
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>
<head>
<!-- #include virtual = "/pub/html/html.head.bmscore.asp" -->
<style type="text/css">
.no-spinners {
  height:100%;width:100%;border:0px;
  outline:none;
  text-align:center;
  padding:0px;
  margin:0px;

  -moz-appearance:textfield;
}

.no-spinners::-webkit-outer-spin-button,
.no-spinners::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}	
</style>
<script type="text/javascript" src="/pub/js/bm_scorePage.js?ver=<%= second(now)%>"></script>
</head>

<body <%=CONST_BODY%>>

<!-- #include file = "./body/body.scorePage.asp" -->


<!-- #include virtual = "/pub/html/html.footer.bmscore.asp" -->
</body>
</html>