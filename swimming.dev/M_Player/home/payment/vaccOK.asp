<!--#include virtual ="/pub/header.swimmingAdmin.asp" -->
<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%
'가상계좌 결과 처리페이지 
	'1. 이니시스 PG에서 요청했는지 여부( IP로 체크)를 반드시 확인하셔야합니다.
	'2. 리턴 메시지를 반드시 적용해주셔야합니다.
	'  상점 데이터베이스 등록 성공 유무에 따라서 성공시에는 "OK" 문자열만 응답되어야합니다.
	'  ASP : response.write "OK"
	'  JSP : out.print("OK");
	'  PHP : echo "OK";
	'3. 로그를 반드시 작성해주시기 바랍니다.
	'  로그는 문제 발생시 이니시스와 데이터를 확인할 수 있는 근거 데이터이므로 반드시 적용해주시기 바랍니다.

	'이체결과
	'파라미터	설명	SIZE
	'no_tid	이니시스 거래번호	VARCHAR(40)
	'no_oid	상점의 주문번호	VARCHAR(40)
	'cd_bank	계좌를 발급한 은행 코드	VARCHAR(8)
	'cd_deal	거래 취급 기관 코드 (실제입금은행)	VARCHAR(8)
	'dt_trans	금융기관 발생 거래 일자	VARCHAR(8)
	'tm_trans	금융기관 발생 거래 시각	VARCHAR(6)
	'no_vacct	계좌번호	VARCHAR(20)
	'amt_input	입금금액	NUMBER(13)
	'flg_close	마감구분 (0:당일마감전, 1:당일마감후)	CHAR(1)
	'cl_close	마감구분코드 (0:당일마감전, 1:당일마감후)	CHAR(1)
	'type_msg	거래구분 (0200:정상, 0400:취소)	VARCHAR(4)
	'nm_inputbank	입금은행명	VARCHAR(10)
	'nm_input	입금자명	VARCHAR(20)
	'dt_inputstd	입금기준일자	NUMBER(8)
	'dt_calculstd	정산기준일자	NUMBER(8)
	'dt_transbase	거래기준일자	NUMBER(8)
	'cl_trans	거래구분코드 (1100)	VARCHAR(4)
	'cl_kor	한글구분코드	NUMBER(1)
	'dt_cshr	현금영수증 발급일자	NUMBER(8)
	'tm_cshr	현금영수증 발급시간	NUMBER(6)
	'no_cshr_appl	현금영수증 발급번호	NUMBER(9)
	'no_cshr_tid	현금영수증 발급TID	VARCHAR(40)

	'Response.redirect "/home/page/list-pro.asp"
	'Response.end

'################################################ 
'len : 0515
'no_oid : swsportsdi_1594084638002
'type_msg : 0200
'flg_close : 0
'no_tid : 'IniTechPG_swsportsdi20200707104723431145
'amt_check : 0000000000010
'id_merchant : swsportsdi
'no_transseq : 9-00001
'cd_bank : 00000004
'dt_inputstd : 20200707
'cd_deal : 00000004
'dt_trans : 20200707
'no_msgseq : 9-00000001
'dt_transbase : 20200707
'tm_trans : 104723
'cl_trans : 1100
'cd_joinorg : 01306001
'cl_close : 0
'no_vacct : 70219014191042
'cl_kor : 2
'no_msgmanage : 104723-1
'nm_inputbank : __????__
'nm_input : ??浿
'amt_input : 0000000000010
'dt_calculstd : 20200707
'StdpayVBNKswsportsdi20200707101712338509 //TID
'swsportsdi_1594084638002 //주문번호





	Set db = new clsDBHelper

		
		type_msg = request("type_msg")  '0200 정상
		no_oid = request("no_oid") '거래번호
		id_merchant = request("id_merchant")
		no_vacct = request("no_vacct")
	
		'test 실행			
		'no_oid = "swsportsdi_1611820124465"
		'type_msg = "0200"
		'id_merchant = "swsportsdi"
		'no_vacct = "26246109818489"
		
		If id_merchant <> "swsportsdi" Then
			Response.end
		End if

		If type_msg = "0200" Then

			'결제정보체크
				SQL_Order = "Select Oorderstate,gametitleidx,team,gubun,leaderidx From tblSwwimingOrderTable "
				SQL_Order = SQL_Order & " Where del_yn = 'N'  and  order_MOID = '"&no_oid&"' and  vact_num = '"&no_vacct&"' " 
				Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)
				If Not rs.eof Then
					orderstate = rs(0)
					tidx = rs(1)
					tcode = rs(2)
					gubun = rs(3) '참가신청 1 증명서 2
					leaderidx = rs(4)

					If orderstate = "00" Then
						updateOrderstate = "01"
					Else '처리안할꺼임 통과
						updateOrderstate = "00"
						response.write "OK"
						Response.end
					End if
				End if

		Else '0400  취소때옴  '처리안할꺼임 통과
			updateOrderstate = "99"
			'결제취소임 패스 
			response.write "OK"
			Response.End
		End if

		'처리
		SQL = "Update tblSwwimingOrderTable set Oorderstate = '"&updateOrderstate&"' where order_MOID = '"&no_oid&"' " 
		Call db.execSQLRs(SQL , null, ConStr)

		payOK = "Y"
		delYN = "N"

		
		If gubun = "1" then '참가신청 1 증명서 2
				'결제확인 업데이트및 가상계좌사용  delYN  복구 #####################################################
				SQL = "update  tblGameRequest set  payOK = 'Y', delyn = 'N' where Order_MOID = '"&no_oid&"' "
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = "update  tblGameRequest_r set  payOK = 'Y', delyn = 'N' where Order_MOID = '"&no_oid&"' "
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = "update tblGameRequest_imsi set payOk = 'Y' where tidx = " & tidx & " and team = '"&tcode&"' and payOk = 'N' "  '리더정보도 추가해서..
				Call db.execSQLRs(SQL , null, ConStr)

				'sd_gameMember 이걸넣어주어야한다. 
				'개인경기 참가자 넣기
						fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' "
						minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX "
						selectQ = "Select "&fld&" from tblGameRequest where delyn = 'N' and ITgubun= 'I' and  P1_playeridx>0 and GameTitleIDX = " & tidx  & " and p1_team = '"&tcode&"'   and paymentIDX = '"&leaderidx&"'  " '개인 다른 동일한 선수꺼면...어쩌지 할필요 없다 팀에서 다넣는다.

						'가상계좌 결제 완료되는시점이므로  넣어줌
						SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun)  ("&selectQ&")"
						Call db.execSQLRs(SQL , null, ConStr)

				'단체전넣기
						'단체명만 대진표에 넣기 
						fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' ,paymentIDX"
						minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX "
						selectQ = "Select "&fld&" from tblGameRequest  where delyn = 'N' and ITgubun= 'T' and P1_playeridx='0' and GameTitleIDX = " & tidx  & " and  p1_team = '"&tcode&"'    and paymentIDX = '"&leaderidx&"' "

						'음...가상계좌에서 넣으면 안들어간다. 이건 결제 완료되는시점에 넣어주어야한다.
						SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun,leaderidx)  ("&selectQ&")"
						Call db.execSQLRs(SQL , null, ConStr)


						'E2  단체선수 저장 #################21.06.15 (수구는빼야한다)
						selectQ = "Select m.gamememberidx,m.requestidx,a.playeridx,a.kskey,a.username,a.sex,a.team,a.teamnm,a.sido  from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b "
						selectQ = selectQ & " ON a.seq = b.seq and a.tidx = "& tidx &" and a.delyn = 'N' "
						selectQ = selectQ & " inner join sd_gameMember as m "
						selectQ = selectQ & " On a.tidx = m.GameTitleIDX and b.gbidx = m.gbidx   and a.team = m.team and a.leaderIDX = m.leaderidx  and m.DelYN = 'N' and m.ITgubun = 'T'  and ((m.cda = 'E2'  and m.cdc <> '31' ) or (m.cda = 'F2'))  "   
						selectQ = selectQ & " where b.delyn = 'N' and b.ITgubun = 'T' and ((b.cda ='E2'  and b.cdc <> '31') or (m.cda = 'F2')) and a.team = '"&tcode&"'  and a.leaderidx = '"&leaderidx&"' "

						SQL = "Insert Into sd_gameMember_partner (gamememberidx,requestidx,playeridx,ksportsno,username,sex,team,teamnm,sido) ("&selectQ&") "
						Call db.execSQLRs(SQL , null, ConStr)
						'E2  단체선수 저장 #################21.06.15 (수구는빼야한다)



						'신청 계영참가자 넣기(단체전) 음 
						fld = "  c.requestIDX,a.kskey,a.playeridx, a.username,a.userclass,a.team,a.teamnm,a.sex, '"&Order_MOID&"' ,b.capno"				

						selectQ ="				   select "&fld&" from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b ON a.seq = b.seq and a.delyn = 'N'  "
						selectQ = selectQ & "  inner join tblGameRequest as c ON a.tidx = c.gametitleidx and a.team = c.p1_team and b.ITgubun = c.ITgubun and b.levelno = c.levelno and b.delyn = 'N'  "
						selectQ = selectQ & "  where  a.leaderidx = '"&leaderidx&"'  and a.tidx = "&tidx&" and a.team = '"&tcode&"' and c.ITgubun= 'T'  "

						insertFLD = " requestIDX,kskey,playeridx,username,userClass,team,teamnm,sex     ,Order_MOID, capno "					
						SQL = "insert Into tblGameRequest_r ("&insertFLD&")  ("&selectQ&")"
						Call db.execSQLRs(SQL , null, ConStr)

				
						'startType 설정하기 설정하기 (있는것만 업데이트 하는거니 상관없겠지 ..ㅜㅜ)
						SQL = ";with tbl as ( "
						SQL = SQL & " select a.levelno,max(b.gametimess)as gs ,COUNT(*) as cnt from sd_gameMember as a INNER JOIN tblTeamGbInfo as b "
						SQL = SQL & " ON a.cdc = b.teamgb and a.delyn = 'N' and b.delyn = 'N' where a.GameTitleIDX = '"&tidx&"' and a.team = '"&tcode&"'  and cd_type='1' and PTeamGb = 'D2'  group by a.levelno )" 'tblTeamGbInfo.cd_type  레벨찾기

						'음...가상계좌에서 넣으면 안들어간다. 이건 결제 완료되는시점에 넣어주어야한다.
						SQL = SQL & " update sd_gameMember set startType= '3' where GameTitleIDX = '"&tidx&"' and levelno in ( select levelno from tbl where cnt <= 8 or gs >= 320) " '걸리는시간이 320 , 출전선수가 8명이하면 시작을 3으로
						Call db.execSQLRs(SQL , null, ConStr)

						'가상계좌로그
						For Each item In Request.Form
						rvalue = rvalue & item & " : " & Request.Form(item) & ","
						Next

						'For Each item In Request.QueryString
						'rvalue = rvalue & item & " >: " & Request.QueryString(item) & "<br>"
						'Next

						SQL = "insert into tblVACCLOG (rvalue) values ('"&rvalue&"')"
						Call db.execSQLRs(SQL , null, ConStr)
		End if

		db.Dispose
		Set db = Nothing


		' 인증이 성공
		response.write "OK"
%>