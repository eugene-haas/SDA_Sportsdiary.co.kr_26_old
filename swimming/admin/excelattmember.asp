<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
  'request 처리##############
	F2 = request("f2")
	F3 = request("f3")

	Set db = new clsDBHelper


'	Select Case F3
'	Case "0" : findschool = ""
'	Case "1" : findschool = " and c.teamnm like '%초등학교' "
'	Case "2" : findschool = " and c.teamnm like '%중학교' "
'	Case "3" : findschool = " and c.teamnm like '%고등학교%' "
'	Case "4" : findschool = " and c.teamnm like '%대학교%' "
'	Case "5" : findschool = " and  not (c.teamnm like '%초등학교'  or c.teamnm like '%중학교'  or c.teamnm like '%고등학교'  or c.teamnm like '%대학교'  )   "
'	End Select 

	Select Case f3
	Case "" : findschool = ""
	Case Else
		findschool = " and (Select top 1 cdb as ccode from tblGameRequest_imsi where team = c.team  and tidx = '"&F2&"' and delyn = 'N'   )  = '"&F3&"'  "
	End Select 


	strTableName = " tblSwwimingOrderTable as a INNER JOIN sd_gameTitle as b ON a.gametitleidx = b.gametitleidx and b.delyn = 'N'  inner join tblteaminfo as c on a.team = c.team "

	strFieldName = "a.orderidx,a.or_num,a.team,c.teamnm ,a.leaderidx,a.leadername,a.OorderPayType, a.oorderstate, ( REPLACE(CONVERT(VARCHAR, CAST(a.orderprice AS MONEY),1),'.00','')   ) as price, a.resultmsg, a.vact_num, a.vact_bankcode,a.vactbankname,a.vact_inputname, a.order_tid, a.order_moid,a.reg_date,a.refundbnk,a.refundcc,a.refundnm,a.refunddate  "
	strFieldName  = strFieldName & ", b.gametitleidx,b.gubun,b.gamearea,b.gametitlename,b.titlecode,b.attmoney,b.games,b.gamee,b.atts,b.atte,b.gametype,b.entertype  "
	strFieldName  = strFieldName & ", (Select count(*) from tblGameRequest_imsi as x where x.team = a.team  and x.tidx = '"&F2&"' and x.delyn = 'N'  and leaderidx = a.leaderidx )  as cnt "
	strFieldName  = strFieldName & ", (Select top 1 fileUrl  from sd_schoolConfirm as s where s.team = a.team  and s.gametitleidx = '"&F2&"'   and leaderidx = a.leaderidx  )  as fileurl " '학교장확인서

	strSort = "  order by orderidx  desc "
	strSortR = "  order by orderidx "

	strWhere = " a.Del_YN = 'N' and a.gubun='1' and b.gametitleidx = '"&F2&"'  and oorderstate = '01' " & findschool

	SQL = "Select "&strFieldName&" from "&strTableName&"  where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  If Not rs.EOF Then
		arrP = rs.GetRows()
			'페이지 팀코드 구하기
			For ari = LBound(arrP, 2) To UBound(arrP, 2)
				teamcd = arrP(2, ari)
				leaderidx = arrP(4,ari)
				If ari = 0 then
					teamwhere = "'"&teamcd&"'"
					inleader =  leaderidx
				Else
					teamwhere = teamwhere & "," & "'" & teamcd & "'"
					inleader = inleader & "," & leaderidx 
				End if
			Next
			
	  End If

	totalcnt = 0
	If teamwhere <> "" then
	'카운트 전체
	'SQL = "Select count(*) from tblGameRequest_imsi as c  where tidx = '"&F2&"' and team in ("&teamwhere&") and delyn = 'N' " & findschool
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'totalcnt = rs(0)
	





	
	'참가자정보
	fldboo = " ,(SELECT  STUFF(( select ','+ CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM for XML path('') ),1,1, '' )) as '참가종목' "

'	fld = " a.playeridx as 'key' ,a.username as '이름',a.birthday as '생년',  (case when   a.sex = 1 then '남'  else '여' end) as '성별'                    ,a.CDBNM as '참여부',a.userclass  as '학년' " & fldboo & ", a.team"
'	SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team in ("&teamwhere&")  and a.tidx = '"&F2&"' and delyn = 'N'  order by a.team"

	fld = " a.kskey as '선수번호' ,a.username as '이름',a.birthday as '생년월일',  (case when   a.sex = 1 then '남'  else '여' end) as '성별'                    ,a.CDBNM as '부서',a.userclass  as '학년'  , a.teamnm as '소속' ,b.cdanm as '종목'  ,( case when itgubun = 'I' then '개인' else '단체' end ) as '구분' , b.cdcnm  as '세부종목'  ,a.sidonm as '시도' "	
	fld = fld & " ,c.userphone as '전화번호'  ,c.email as '이메일' ,c.usernameen as '영문명' ,c.usernamecn as '한자' "

	SQL = "Select "&fld&" from tblGameRequest_imsi as a  inner Join tblGameRequest_imsi_r as b on a.seq = b.seq and b.delyn = 'N'  "
	SQL = SQL & " inner  join tblplayer as c on a.playeridx = c.playeridx "	
	SQL = SQL & "	where a.team in ("&teamwhere&") and a.leaderidx in ("&inleader&") and a.tidx = '"&F2&"' and a.delyn = 'N'   "
	SQL = SQL & " order by a.team"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)





'	If Not rs.EOF Then
'		arrA = rs.GetRows()
'	End if
	End if	


	Sub rsDrowexcel(ByVal rs)
	Dim i ,n 
		'For i = 0 To Rs.Fields.Count - 1
			'response.write  Rs.Fields(i).name &","
		'Next

		%><table class='table' id="tblrsdrow"><thead id="headtest"><%

		For i = 0 To Rs.Fields.Count - 1
			%><th><%=Rs.Fields(i).name%></th><%
		Next
		%></thead><%

		ReDim rsdata(Rs.Fields.Count) '필드값저장
		
		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>

				<tr class="gametitle">
					<%
						For n = 0 To Rs.Fields.Count - 1

								If n  = 4 Then
									If InStr(rsdata(n),"초등") > 0 Then
										If isNumeric(rsdata(5)) then

											If CDbl(rsdata(5)) < 5 Then
												rsdata(n) = Replace(rsdata(n) , "초등", "유년")
											End If
											
										End if
									End If
								End if


								%><td <%If n= 0 Or n = 2 Or n = 11 then%>style="mso-number-format:'\@'"<%End if%>><%=rsdata(n)%></td><%
						Next
					%>
				</tr>

			<%
		rs.movenext
		Loop


		If Not rs.eof then
		rs.movefirst
		End if
		%></tbody></table><%
	End Sub



	'엑셀출력################
	Response.Buffer = True     
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename=참가신청.xls"
	'엑셀출력################
%>


<%'<html xmlns="http://www.w3.org/1999/xhtml">%>
<html lang="ko">
  <head>
  
    <meta charset="utf-8">
    <title>참가신청</title>
  </head>
  <body>


<%
	Call rsdrowexcel(rs)


	Call db.Dispose
	Set db = Nothing
%>




  </body>
</html>



