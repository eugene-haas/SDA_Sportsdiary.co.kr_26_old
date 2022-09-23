<!--#include virtual ="/pub/header.swimmingAdmin.asp" -->
<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%
	'dim gopaymethod		: gopaymethod		= fInject(Request("gopaymethod"))		'gopaymethod
	leaderinfo = request.Cookies("leaderinfo")

	merchantData= f_dec(request("merchantData"))		' 가맹점 관리데이터 수신  (tid, tm >>  tidx, teamcode)

	'주문번호 생성(주문번호 먼저 생성되는 버전)	
	Dim rndValue, rndSeed,or_num
	rndSeed = 20 '1~40
	 
	Randomize ' 난수 발생기 초기화
	rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생
	
	or_num = Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())&rndValue

%>
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
		'#############################
		' 인증결과 파라미터 일괄 수신
		'#############################


						'merchantData tid,tm 
						If InStr(merchantData,"SW") > 0 then
							swkey = Split(merchantData,"SW")

							tidx = swkey(0) '게임인덱스
							paygubun = "1"
							tcode = "SW" & swkey(1) '팀코드
							leaderidx = swkey(2) '리더테이블 고유증가값

							Set db = new clsDBHelper
							%>
							<!-- #include virtual = "/include/inc.requestOK.asp" -->
							<%

								order_sql = " insert Into tblSwwimingOrderTable	"
								order_sql = order_sql & "	(			"
								order_sql = order_sql & "		  OR_NUM	"
								order_sql = order_sql & "		 ,GameTitleIDX	"
								order_sql = order_sql & "		 ,gubun	"
								order_sql = order_sql & "		 ,Team  "
								order_sql = order_sql & "		 ,LeaderIDX  "
								order_sql = order_sql & "		 ,LeaderName  "
								order_sql = order_sql & "		 ,OorderPayType  "
								order_sql = order_sql & "		 ,OorderState  "
								order_sql = order_sql & "		 ,OrderPrice  "
								order_sql = order_sql & "		 ,resultMsg  "

								order_sql = order_sql & "		 ,info1  "
								order_sql = order_sql & "		 ,info2  "
								order_sql = order_sql & "		 ,info3  "
								order_sql = order_sql & "		 ,info4  "


								order_sql = order_sql & "		 ,reg_date  "
								order_sql = order_sql & "		 ,del_yn   "
								order_sql = order_sql & "	) values  "
								order_sql = order_sql & "	(			"
								order_sql = order_sql & "		  '"&or_num&"'	"
								order_sql = order_sql & "		 ,'"&tidx&"'	"
								order_sql = order_sql & "		 ,'1'	" '참가신청 1 증명서 2
								order_sql = order_sql & "		 ,'"&tcode&"'			"
								order_sql = order_sql & "		 ,'"&leaderidx&"'		"
								order_sql = order_sql & "		 ,'"&leadernm&"'		"
								order_sql = order_sql & "		 ,''	"

								order_sql = order_sql & "		 ,'01'  " '00: 입근전 / 01:입금완료 / 99 : 입금취소
								order_sql = order_sql & "		 ,'0'  " 
								order_sql = order_sql & "		 ,'참가완료'		"


								order_sql = order_sql & "		 ,'"&temp1&"'		"
								order_sql = order_sql & "		 ,'"&temp2&"'		"
								order_sql = order_sql & "		 ,'"&temp3&"'		"
								order_sql = order_sql & "		 ,'"&temp4&"'		"

								order_sql = order_sql & "		 ,getdate()	"
								order_sql = order_sql & "		 ,'N'	"
								order_sql = order_sql & "	)			"
								Call db.execSQLRs(order_sql , null, ConStr)		

							Call db.Dispose
							Set db = Nothing
						End If

			Response.write ("<script language='javascript'>alert('신청이 완료되었습니다.'); location.href='/home/page/list-pro.asp'; </script>")
%>
	</body>
</html>
