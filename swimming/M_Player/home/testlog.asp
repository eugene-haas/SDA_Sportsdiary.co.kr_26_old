<!--#include virtual ="/pub/header.swimmingAdmin.asp" -->
<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef}
		body, tr, td {font-size:11pt font-family:굴림,verdana color:#433F37 line-height:19px}
		table, img {border:none}
		
	</style>
	<link rel="stylesheet" href="/home/payment/css/group.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#242424">


		
<%

		authSignature = "a"
		signature = "b"
		JSONdata =  "j"

		'logstr = "authSignature:"& authSignature &","& "signature:"& signature &","& "oJSONdata:"&oJSONdata
		'Call TraceLogInsert( "pay", logstr ,"payMethod","/home/payment/INIStdPayReturn.asp","SYSTEM",Request.ServerVariables("REMOTE_ADDR"))

%>
	</body>
</html>
