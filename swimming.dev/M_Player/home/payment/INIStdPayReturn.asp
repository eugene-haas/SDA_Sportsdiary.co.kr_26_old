<!--#include virtual ="/pub/header.swimmingAdmin.asp" -->
<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%
	'dim gopaymethod		: gopaymethod		= fInject(Request("gopaymethod"))		'gopaymethod
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
	<!--div style="padding:10pxwidth:100%font-size:14pxcolor: #ffffffbackground-color: #000000text-align: center">
		이니시스 표준결제 인증결과 수신 / 승인요청, 승인결과 표시 샘플
	</div-->
<% 

resultCode = "0000"

		'#############################
		' 인증결과 파라미터 일괄 수신
		'#############################

		Set oJSON = New aspJSON
		'#####################
		' 인증이 성공일 경우만
		'#####################
		if "0000"=resultCode then

			'####인증성공/승인요청####
			'############################################
			' 1.전문 필드 값 설정(***가맹점 개발수정***)
			'############################################
			
				maid 			= request("mid")							' 가맹점 ID 수신 받은 데이터로 설정
				signKey		= "Z1NGZDJSd0M2T3RXVzdZayt0SDA1UT09"		' 가맹점에 제공된 키(웹표준 사인키) (가맹점 수정후 고정) !!!절대!! 전문 데이터로 설정금지
				correct 		= "09"										' 표준시와의 차이를 2자리 숫자로 입력 (예: 대한민국은 표준시와 9시간 차이이므로 09)
				timestamp	= time_stamp(correct)
				charset 		= "UTF-8"									' 리턴형식[UTF-8,EUC-KR](가맹점 수정후 고정)
				format 		= "JSON"									' 리턴형식[XML,JSON,NVP](가맹점 수정후 고정)	
				
				authToken	= request("authToken")				' 취소 요청 tid에 따라서 유동적(가맹점 수정후 고정)
				authUrl		= request("authUrl")					' 승인요청 API url(수신 받은 값으로 설정, 임의 세팅 금지)
				netCancel	= request("netCancelUrl")			' 망취소 API url(수신 받은 값으로 설정, 임의 세팅 금지)
				merchantData= f_dec(request("merchantData"))		' 가맹점 관리데이터 수신  (tid, tm >>  tidx, teamcode)
		

					' 이부분에 DB 기록등 내부 서비스 구현 #####################################################

						'merchantData tid,tm 
						If InStr(merchantData,"SW") > 0 then
							swkey = Split(merchantData,"SW")

							tidx = swkey(0) '게임인덱스
							paygubun = "1"
							tcode = "SW" & swkey(1) '팀코드
							leaderidx = swkey(2) '리더테이블 고유증가값

							Order_tid = oJSON.data("tid") '거래번호
							Order_MOID = oJSON.data("MOID") '주문번호
							PayMethod= oJSON.data("payMethod")

							endurl = "/home/page/list-pro.asp" '카드결제핸드폰결제만...

							Set db = new clsDBHelper
							%>
							<%'<!-- #include virtual = "/include/inc.requestOK.asp" -->%>
							<!-- #include file = "../../include/inc.requestOK.asp" -->
							<% 


							Call db.Dispose
							Set db = Nothing
						End If
						

						'///////////////////////////////////////////////////////
	

			
			Order_tid = oJSON.data("tid") '거래번호
			Order_MOID = oJSON.data("MOID") '주문번호

			if "VBank"=(oJSON.data("payMethod")) then'가상계좌
				VACT_Num = oJSON.data("VACT_Num")
				VACT_BankCode=oJSON.data("VACT_BankCode")
				vactBankName=oJSON.data("vactBankName")	
				VACT_InputName=oJSON.data("VACT_InputName")

			elseif ("DirectBank"=(oJSON.data("payMethod"))) then'실시간계좌이체
			
				VACT_BankCode=oJSON.data("ACCT_BankCode")
			

			elseif "HPP"=(oJSON.data("payMethod")) then	'휴대폰

				HPP_Corp = oJSON.data("HPP_Corp")	
				HPP_Num  = oJSON.data("HPP_Num")


			else '카드
				quota = CLng(oJSON.data("CARD_Quota"))
				
				if(oJSON.data("EventCode")<>null) then				

				end if
	

				'카드정보
			end if

		else 
				'#############
				' 인증 실패시
				'#############
				Response.End 
		end If
		


	
		If resultCode = "0000" Then 
			'주문 데이터 등록
			

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
			order_sql = order_sql & "		 ,VACT_Num  "
			order_sql = order_sql & "		 ,VACT_BankCode  "
			order_sql = order_sql & "		 ,vactBankName  "
			order_sql = order_sql & "		 ,VACT_InputName  "
			order_sql = order_sql & "		 ,Order_tid  " '거래번호
			order_sql = order_sql & "		 ,Order_MOID  " '주문번호

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
			order_sql = order_sql & "		 ,'"&paygubun&"'	" '참가신청 1 증명서 2
			order_sql = order_sql & "		 ,'"&tcode&"'			"
			order_sql = order_sql & "		 ,'"&leaderidx&"'		"
			order_sql = order_sql & "		 ,'"&leadernm&"'		"
			order_sql = order_sql & "		 ,'"&oJSON.data("payMethod")&"'	"

			If PayMethod = "VBank" Then
			order_sql = order_sql & "		 ,'00'  " '00: 입근전 / 01:입금완료 / 99 : 입금취소
			Else
			order_sql = order_sql & "		 ,'01'  " '00: 입근전 / 01:입금완료 / 99 : 입금취소
			End If
			
			order_sql = order_sql & "		 ,'"&oJSON.data("TotPrice")&"'  " '00: 입근전 / 01:입금완료 / 99 : 입금취소	
			order_sql = order_sql & "		 ,'"&oJSON.data("resultMsg")&"'		"
			order_sql = order_sql & "		 ,'"&VACT_Num&"'  "
			order_sql = order_sql & "		 ,'"&VACT_BankCode&"'	"
			order_sql = order_sql & "		 ,'"&vactBankName&"'	"
			order_sql = order_sql & "		 ,'"&VACT_InputName&"'	"
			order_sql = order_sql & "		 ,'"&Order_tid&"'		"
			order_sql = order_sql & "		 ,'"&Order_MOID&"'		"

			order_sql = order_sql & "		 ,'"&temp1&"'		"
			order_sql = order_sql & "		 ,'"&temp2&"'		"
			order_sql = order_sql & "		 ,'"&temp3&"'		"
			order_sql = order_sql & "		 ,'"&temp4&"'		"

			order_sql = order_sql & "		 ,getdate()	"
			order_sql = order_sql & "		 ,'N'	"
			order_sql = order_sql & "	)			"
			
			Set db = new clsDBHelper
			Call db.execSQLRs(order_sql , null, ConStr)		
			If PayMethod = "VBank" then
				'Response.write ("<script language='javascript'>alert('신청 되었습니다. \n 페이지에서 가상계좌를 확인하시고 입금하시면 신청이 완료됩니다.'); location.href='"&endurl&"'; </script>")
			Else
				'Response.write ("<script language='javascript'>alert('신청이 완료되었습니다.'); location.href='"&endurl&"'; </script>")
			End If

		End If		


	Set oJSON = Nothing



%>
	</body>
</html>
