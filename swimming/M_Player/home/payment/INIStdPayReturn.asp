<!--#include virtual ="/pub/header.swimmingAdmin.asp" -->
<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%
	'dim gopaymethod		: gopaymethod		= fInject(Request("gopaymethod"))		'gopaymethod


	leaderinfo = request.Cookies("leaderinfo")


	If f_dec(request("merchantData")) <> ""  Then

'		Set leader = JSON.Parse( join(array(leaderinfo)) )
'		s_team =  leader.Get("a")
'		s_username =  leader.Get("b")
'		s_birthday = leader.Get("c")
'		s_userphone =  leader.Get("d")
'		s_tidx = leader.Get("e")
'		s_idx = leader.Get("f")

'	leaderinfo = session("leaderinfo") '시간되면 만료되니까 (만료되도 진행해야할까)
'	If isArray(leaderinfo) = True And session("chkrndno") = "" Then
'
'		s_team =  leaderinfo(0)
'		s_username =  leaderinfo(1)
'		s_birthday =  leaderinfo(2)
'		s_userphone =  leaderinfo(3)
'		s_tidx = leaderinfo(4)

		'session("leaderinfo") = "" '새로고침 막음용 
	Else
		Response.redirect "/home/page/list-pro.asp"
		Response.end
	End If


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
		'#############################
		' 인증결과 파라미터 일괄 수신
		'#############################

		Set oJSON = New aspJSON
		'#####################
		' 인증이 성공일 경우만
		'#####################
		if ("0000"=request("resultCode")) then

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

				
			'#####################
			' 2.signature 생성
			'#####################
				signParam = "authToken=" & replace(authToken," ", "+")	
				signParam = signParam & "&timestamp=" & timestamp
				' signature 데이터 생성 (signParam을 알파벳 순으로 hash)
				signature = MakeSignature(signParam)
				
			'#####################
			' 3.API 요청 전문 생성
			'#####################

				dim xmlHttp,  postdat
				Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP")

				send_text = "mid="&maid
				send_text = send_text & "&timestamp="&timestamp
				send_text = send_text & "&signature="&signature
				send_text = send_text & "&authToken="&Server.URLEncode(authToken)
				send_text = send_text & "&&charset="&charset
				send_text = send_text & "&format="&format
			
			'#####################
			' 4.API 통신 시작
			'#####################

			'##승인요청 API 요청##
 			xmlHttp.Open "POST", authUrl, False
 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
			xmlHttp.Send send_text
			result=Cstr( xmlHttp.responseText )

			Set oJSON = New aspJSON
			oJSON.loadJSON(result)

			'############################################################
			'5.API 통신결과 처리(***가맹점 개발수정***)
			'############################################################
			'## 승인 API 결과 ##

			' signature 데이터 생성 
			authSignature = MakeSignatureAuth(maid, timestamp, oJSON.data("MOID"), oJSON.data("TotPrice"))

			sub CencelafterOK(msg)
				Dim send_text, ask_result

				send_text = "timestamp="&timestamp
				send_text = send_text & "&mid="&maid
				send_text = send_text & "&tid="&oJSON.data("tid")
				send_text = send_text & "&authToken="&Server.URLEncode(authToken)
				send_text = send_text & "&signature="&signature
				send_text = send_text & "&SignKey="&signKey
				send_text = send_text & "&format="&format
				send_text = send_text & "&charset="&charset
				
				xmlHttp.Open "POST", netCancel, False
				xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
				xmlHttp.Send send_text
				ask_result=Cstr( xmlHttp.responseText )
				Set xmlHttp = nothing
				Response.write ("<script language='javascript'>alert('"&msg&"'); location.href='/home/page/list-pro.asp?r="&request("resultCode")&"' </script>")		
			End Sub 
			



			if "0000"=oJSON.data("resultCode") and authSignature =oJSON.data("authSignature")  then

			    '/*****************************************************************************
			    ' * 여기에 가맹점 내부 DB에 결제 결과를 반영하는 관련 프로그램 코드를 구현한다.  
			    '
			    '   [중요!] 승인내용에 이상이 없음을 확인한 뒤 가맹점 DB에 해당건이 정상처리 되었음을 반영함
			    '            처리중 에러 발생시 망취소를 한다.
			    '******************************************************************************/

						On Error Resume Next			' 에러가 날 경우 실행

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
							%><!-- #include virtual = "/include/inc.requestOK.asp" --><%

							Call db.Dispose
							Set db = Nothing
						End If
						

						'///////////////////////////////////////////////////////
						If InStr(merchantData,"-:-") > 0 Then '증명서발급 

							pidx = Mid(merchantData,4) '선수키
							paygubun = "2"

							Order_tid = oJSON.data("tid") '거래번호
							Order_MOID = oJSON.data("MOID") '주문번호
							PayMethod= oJSON.data("payMethod") '결제방식

							endurl = "/home/page/certificate_userlist.asp?p=1"

							Set db = new clsDBHelper
							
									'년도에 등록된 코치인지 확인 한다. (엘리트만)
									SQL = "Select username,team,cTemp1,ctemp2,ctemp3,ctemp4  from tblPlayer where playeridx = '"&pidx&"' "
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

									If Not rs.eof Then
										tidx = 0
										leaderidx = pidx
										leadernm = rs(0)
										tcode = rs(1)
										temp1 = rs(2) '발급용도
										temp2 = rs(3) '제출처
										temp3 = rs(4) '증명서 종료 1,2 참가확인서, 실적증명서
										temp4 = rs(5) '대회참가목록 출력 tblrecord index 들
									Else
										'오류 ~ 선수정보없음
										Call CencelafterOK("선수정보 없음" & leaderidx)
										Response.end
									End if


									'결제정보체크
										SQL_Order = "Select orderidx From tblSwwimingOrderTable "
										SQL_Order = SQL_Order & " Where del_yn = 'N'  "
										SQL_Order = SQL_Order & " and gametitleidx = '0'	"
										SQL_Order = SQL_Order & " and LeaderIDX = '"&pidx&"'  and  oorderstate in ( '01', '00') and gubun= '2' and info3 = '"&temp3&"' and  reg_date >= '"&date&"'  and reg_date < '"& date+1 &"' " '가상계좌이고 00 결제전이 있어도 결제되면 안됨
										Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)
										If Not rs.eof Then
											'결제정보가 있는데 오면 안됨.
											Call CencelafterOK("결제정보있음_"&rs(0))
											Response.end
										End if


									'가상계좌여부 확인 (가상계좌처리)
										If PayMethod = "VBank" Then
											payOK = "N"
											delYN = "Y"
										Else
											payOK = "Y"
											delYN = "N"
										End if


							Call db.Dispose
							Set db = Nothing
						End if


					' 이부분에 DB 기록등 내부 서비스 구현 #####################################################

					' 에러 발생시 망취소
							If Err.Number > 0 Then 
							'### 망취소 통신 시작
								Call CencelafterOK("망취소")
								Response.End 
								'################# ask_result로 반환된 전문 중  "resultCode": "0000"  이면 정상 망취소 처리.
			  			End If   
						Err.Clear      ' Clear the error.
						On Error GoTo 0
					' 망취소여기까지
				Set xmlHttp = nothing
				
				'거래 성공 여부 :성공
				'결과 내용" & oJSON.data("resultMsg")	

			else
				'거래 성공 여부
				'실패" & oJSON.data("resultCode")
				if not (signature = oJSON.data("authSignature")) and "0000"=oJSON.data("resultCode") Then	' authSignature 값이 일치하지 않을 경우 패킷조작을 의심해봐야함
								
						'결과 내용 * 데이터 위변조 체크 실패
								
						if "0000"=oJSON.data("resultCode")  Then		
							' 승인은 이루어 졌지만 authSignature이 일치 하지 않는 경우 망취소
							Call CencelafterOK("의심패킷망취소")
							Response.End 
							'################# ask_result로 반환된 전문 중  "resultCode": "0000"  이면 정상 망취소 처리.
						end if
								
				else
					'결과 내용
					' &oJSON.data("resultMsg")	

				end if

			end if
			
					

			'공통 부분만


				'거래 번호
				' &oJSON.data("tid")
				'결제방법(지불수단)
				' &oJSON.data("payMethod")
				'결과 코드
				' &oJSON.data("resultCode")
				'결제완료금액
				' &oJSON.data("TotPrice") & 원
				'주문 번호
				' &oJSON.data("MOID")
				'승인날짜
				' &oJSON.data("applDate")
				'승인시간
				' &oJSON.data("applTime")
			
			Order_tid = oJSON.data("tid") '거래번호
			Order_MOID = oJSON.data("MOID") '주문번호

			if "VBank"=(oJSON.data("payMethod")) then'가상계좌
				
				'입금 계좌번호
				' & oJSON.data("VACT_Num")
				'입금 은행코드
				' & oJSON.data("VACT_BankCode")
				'입금 은행명
				' & oJSON.data("vactBankName")
				'예금주 명
				' & oJSON.data("VACT_Name")
				'송금자 명
				' & oJSON.data("VACT_InputName")
				'송금 일자
				' & oJSON.data("VACT_Date")
				'송금 시간
				' & oJSON.data("VACT_Time")
					

				VACT_Num = oJSON.data("VACT_Num")
				VACT_BankCode=oJSON.data("VACT_BankCode")
				vactBankName=oJSON.data("vactBankName")	
				VACT_InputName=oJSON.data("VACT_InputName")
				

			elseif ("DirectBank"=(oJSON.data("payMethod"))) then'실시간계좌이체
				
				'은행코드
				' & oJSON.data("ACCT_BankCode")
				
				'현금영수증 발급결과코드
				' & oJSON.data("CSHR_ResultCode")
				
				'현금영수증 발급구분코드</p> <font color=red><b>(0 - 소득공제용, 1 - 지출증빙용)</b></font></th>")
				' & oJSON.data("CSHR_Type")
				
			
				VACT_BankCode=oJSON.data("ACCT_BankCode")
			

			elseif "HPP"=(oJSON.data("payMethod")) then	'휴대폰
				
				'통신사
				' & oJSON.data("HPP_Corp")
				
				'결제장치
				' & oJSON.data("payDevice")
				
				'휴대폰번호
				' & oJSON.data("HPP_Num")
				
				HPP_Corp = oJSON.data("HPP_Corp")	
				HPP_Num  = oJSON.data("HPP_Num")


			else '카드 VCard, Card ...
				quota = CLng(oJSON.data("CARD_Quota"))
				
				if(oJSON.data("EventCode")<>null) then				
					
					'이벤트 코드					
					' & oJSON.data("EventCode")
				end if
				
				'카드정보 
					'카드번호
					' & oJSON.data("CARD_Num")
					
					'할부기간
					' & oJSON.data("CARD_Quota")
					'CARD_Num = oJSON.data("CARD_Num")
					'if("1"=(oJSON.data("CARD_Interest")) or "1"=(oJSON.data("EventCode"))) then
					'	할부 유형
					'	response.write("<td class='td02'><p>무이자</p></td></tr>")	
					'elseif quota > 0 and  not "1"=(oJSON.data("CARD_Interest")) then
					'	할부 유형
					'	response.write("<td class='td02'><p>유이자 <font color='red'> *유이자로 표시되더라도 EventCode 및 EDI에 따라 무이자 처리가 될 수 있습니다.</font></p></td></tr>")
					'end If
					'
					'if("1"=(oJSON.data("point"))) then
					'	response.write("<td class='td02'><p></p></td></tr>")
					'	포인트 사용 여부
					'	response.write("<td class='td02'><p>사용</p></td></tr>")
					'else
					'	response.write("<td class='td02'><p></p></td></tr>")
					'	포인트 사용 여부
					'	response.write("<td class='td02'><p>미사용</p></td></tr>")
					'end if
					
					'카드 종류
					' & oJSON.data("CARD_Code")
					'카드 발급사
					' & oJSON.data("CARD_BankCode")
					'부분취소 가능여부
					' & oJSON.data("CARD_PRTC_CODE")
					'체크카드 여부
					' & oJSON.data("CARD_CheckFlag")
			
					' 수신결과를 파싱후 resultCode가 "0000"이면 승인성공 이외 실패 가맹점에서 스스로 파싱후 내부 DB 처리 후 화면에 결과 표시
					' payViewType을 popup으로 해서 결제를 하셨을 경우 내부처리후 스크립트를 이용해 opener의 화면 전환처리를 하세요
				'카드정보
			end if

		else 
				'#############
				' 인증 실패시
				'#############
				'response.write("<br/><br/><br/>")
				'response.write("####인증실패####")
				If paygubun = "1" then
				Response.write ("<script language='javascript'>alert('인증에실패하였습니다.'); location.href='/home/page/list-pro.asp?r="&request("resultCode")&"' </script>")		
				Else
				Response.write ("<script language='javascript'>alert('인증에실패하였습니다.'); location.href='/home/page/certificate.asp?r="&request("resultCode")&"' </script>")		
				End if
					'For each item in Request.Form
						'	for i = 1 to Request.Form(item).Count
						'		if not(item="authToken") then
						'				response.write("<pre>" & item & " = " & Request.Form(item)(i) & "</pre>")
						'			end if
						' Next
					'Next
				Response.End 

		end If
		


		



		'문제가 생기면 여기 서 찾자...TB_LOG_TRACESWIM
		logstr = "authSignature:" &authSignature &","& "signature:"& signature &","& "oJSONdata:"&oJSON.data("authSignature")
		Call TraceLogInsert( "pay", logstr ,oJSON.data("payMethod"),"/home/payment/INIStdPayReturn.asp","SYSTEM",Request.ServerVariables("REMOTE_ADDR"))




		If oJSON.data("resultCode") = "0000" Then 
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

			'Response.write ("<script language='javascript'>alert('주문결제 완료'); location.href='/home/page/list-pro.asp' </script>")
			If PayMethod = "VBank" then
				Response.write ("<script language='javascript'>alert('신청 되었습니다. \n 페이지에서 가상계좌를 확인하시고 입금하시면 신청이 완료됩니다.'); location.href='"&endurl&"'; </script>")
			Else
				Response.write ("<script language='javascript'>alert('신청이 완료되었습니다.'); location.href='"&endurl&"'; </script>")
			End if
		Else
			Response.write ("<script language='javascript'>alert('결제 오류'); location.href='"&endurl&"'; </script>")
		End If		


	Set oJSON = Nothing



%>
	</body>
</html>
