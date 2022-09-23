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
<script type="text/javascript" src="/pub/js/tennis_gamerullfree.js?ver=2"></script>



<style>
  .rtable {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
	font-size:15px;
	text-align:center;
  }
  .rtable th,.rtable td {
    border: 1px solid #444444;
    padding: 10px;
	padding:0px;
	font-size:14px;
  }
	.top_table{width:100%;max-width:;margin-top:20px;}
	.top_table table{width:100%;border-left:1px solid #ced5e3;}
	.top_table table tr th{background:#3f4953;color:#fff;height:40px;vertical-align: middle;font-size:17px;border-bottom: 3px solid #ff4c00;font-family:'NanumGothicB';border-right:1px solid #ced5e3;}
	.top_table table tr td{border-right:1px solid #ced5e3;border-bottom:1px solid #ced5e3;height:40px;vertical-align: middle;text-align:center;font-size:15px;color:#333;}
	.top_table table tr td span{background: #e8ebf0;display:block;height:40px;line-height:40px;font-family:'NanumGothicB';}
	.top_table table tr td .change_btn{width:90%;height:30px;line-height:30px;background:#637AA1;color:#fff;font-family:'NanumGothicB';display:block;margin:auto;}
	.top_table table tr td input{width:90%;height:30px;margin-bottom:0;text-align:center;font-size:18px;}
	.bt_table{width:100%;margin-top:20px;}
	.bt_table table{border-top:2px solid #ff4c00;border-left:1px solid #ced5e3;}
	.bt_table table tr th{height:40px;vertical-align: middle;background:#e8ebf0;text-align:center;border-right:1px solid #ced5e3;border-bottom:1px solid #ced5e3;font-size:16px;font-family:'NanumGothicB';}
	.bt_table table tr td{text-align:center;height:40px;vertical-align: middle;border-right:1px solid #ced5e3;border-bottom:1px solid #ced5e3;}
	.bt_table table tr td input{width:90%;height:30px;margin-bottom:0;text-align:center;font-size:18px;}
	.bt_table table tr th.l_bg{background:#3f4953;font-size:16px;font-family:'NanumGothicB';color:#fff;}
	.bt_table table tr td.l_bg{background:#3f4953;font-size:16px;font-family:'NanumGothicB';color:#fff;}
</style>

</head>

<body <%=CONST_BODY%>>

<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.gamerullfree.asp" -->
	</article>
</div>



<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
</body>
</html>