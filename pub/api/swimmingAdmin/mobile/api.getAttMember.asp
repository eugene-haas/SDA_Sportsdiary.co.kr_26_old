<%
'#############################################
'팀 참가신청 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = fInject(oJSONoutput.TIDX)
	End if
	If hasown(oJSONoutput, "LNO") = "ok" then
		levelno = fInject(oJSONoutput.LNO)
	End If
	If hasown(oJSONoutput, "ITGUBUN") = "ok" then
		itgubun = fInject(oJSONoutput.ITGUBUN)
	End if	
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = fInject(oJSONoutput.PIDX)
	End if	

	'종목 (참가자)
	If pidx ="" then
		If itgubun = "T" then	'계영이라면 (단체 수구, 기타)
			fld = " a.CDA,a.CDC, a.CDCNM,a.CDB,a.CDBNM,b.UserName,P1_TEAMNM,sidonm, (select top 1 birthday from tblplayer where playeridx = b.playeridx) as birthday "
			SQL = "select "&fld&" from tblGameRequest as a inner join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where  a.GameTitleIDX = "&tidx&"  and a.DelYN = 'N' and a.levelno = '"&levelno&"'  order by a.sido,p1_teamnm"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		else
			fld = " CDA,CDC, CDCNM,CDB,CDBNM,P1_UserName,P1_TEAMNM,sidonm,p1_birthday "
			SQL = "select "&fld&" from tblGameRequest where GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and delyn = 'N' order by  sido,p1_teamnm"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		End if

	Else
			'솔로 또는 단체
			fld = " a.CDA,a.CDC, a.CDCNM,a.CDB,a.CDBNM, (case when itgubun = 'I' then P1_UserName else b.username  end) as unm   ,P1_TEAMNM,sidonm, (case when itgubun = 'I' then p1_birthday else (select top 1 birthday from tblplayer where playeridx = b.playeridx) end) as birthday "
			SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and (a.p1_playeridx = '"&pidx&"' or b.playeridx = '"&pidx&"')  order by a.sido,p1_teamnm"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if




	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arr = rs.GetRows()
		CDBNM = arr(4,0)
		CDCNM = arr(2,0)
		UNM = arr(5,0)
	End if	

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
'################################################
%>

		  <h3 class="tab_header">
			<%If pidx ="" then%>
			<span id="TabGenderCon"><%=CDBNM%></span><span id="TabDistanceCon"><%=CDCNM%>   <%=ITGUBUN%></span>
			<%else%>
			'<%=UNM%>' 으로 검색한 결과
			<%End if%>
		  </h3>
		  <table>
			<caption>※ 이름 | 소속</caption>
			<%
				If IsArray(arr) Then
					For ari = LBound(arr, 2) To UBound(arr, 2)
						a_CDA = arr(0, ari)
						a_CDC = arr(1, ari)
						a_CDCNM = arr(2, ari)
						a_CDB = arr(3,ari)
						a_CDBNM = arr(4,ari)
						a_UNM1 = arr(5, ari)
						a_TEAMNM = arr(6, ari)
						a_sido = arr(7, ari)
						a_birth = Left(arr(8,ari),2)
						If CDbl(a_birth) > 30 Then
							a_birth = "19" & a_birth
						Else
							a_birth = "20" & a_birth
						End if
						%>
						<tr>
						  <td><%=a_UNM1%> (<%=a_birth%>)  | <%=a_TEAMNM%><%If pidx <> "" then%>&nbsp;[<%=a_CDBNM%> <%=a_CDCNM%>]<%else%>[<%=a_sido%>]<%End if%></td>
						</tr>
						<%
					Next 
				End if
			%>
		  </table>