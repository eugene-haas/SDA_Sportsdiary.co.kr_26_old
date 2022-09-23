<%'<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->%>
<%
	'테스트 확인
'	Set db = new clsDBHelper
'	tidx = "129"
'	tcode = "SW00732"
'	leaderidx = "5615"
'	PayMethod = "Card"
'	Order_tid = "StdpayCARDswsportsdi20210129102059065945"
'	Order_MOID = "swsportsdi_1611883239202"


			Set db = new clsDBHelper
			'년도에 등록된 코치인지 확인 한다. (엘리트만)
			SQL = "Select username,team,cTemp1,ctemp2,ctemp3  from tblPlayer where playeridx = '"&pidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				tidx = 0
				leadernm = rs(0)
				tcode = rs(1)
				temp1 = rs(2) '발급용도
				temp2 = rs(3) '제출처
				temp3 = rs(4) '증명서 종료 1,2 참가확인서, 실적증명서
			Else
				'오류 ~ 선수정보없음
				Call CencelafterOK("선수정보 없음" & leaderidx)
				Response.end
			End if


			'결제정보체크
				SQL_Order = "Select orderidx From tblSwwimingOrderTable "
				SQL_Order = SQL_Order & " Where del_yn = 'N'  "
				SQL_Order = SQL_Order & " and gametitleidx = '0'	"
				SQL_Order = SQL_Order & " and LeaderIDX = '"&pidx&"'  and  oorderstate in ( '01', '00')    and reg_date >= '"&date&"'   and reg_date < '"& date+1 &"' " '가상계좌이고 00 결제전이 있어도 결제되면 안됨
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
%>