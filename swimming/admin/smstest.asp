<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.lte.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/players.js<%=CONST_JSVER%>8"></script>
</head>
<body <%=CONST_BODY%>>


문자전송 테스트 막아둠
<%
Response.end
sendType = 3
title = "수영문자테스트"
msg = "문자야"
sitecode= ""
fromphone = "024204236"
tophone = "01047093650"


Call sendPhoneMessage(db,sendType, title, msg, sitecode, fromphone, tophone)
%>






</body>
</html>	