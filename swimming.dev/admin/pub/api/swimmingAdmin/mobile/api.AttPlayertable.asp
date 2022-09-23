<%
'#############################################
'참가한 종목 대진표 검색
'#############################################
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If
	
	If hasown(oJSONoutput, "CDA") = "ok" then
		cda = oJSONoutput.CDA
	End If
	
	'경기순서
	If hasown(oJSONoutput, "DD") = "ok" then
		dd = Replace(oJSONoutput.DD,"/","-")
	End If
	If hasown(oJSONoutput, "AMPM") = "ok" then
		ampm = oJSONoutput.AMPM
	End if	

	Set db = new clsDBHelper



	If DD <> "" then
		'오전 오후
		If ampm = "am" then
			SQL = "select GbIDX from tblRGameLevel where delyn = 'N' and  gametitleidx = " &tidx& " and ("
			SQL = SQL & " (cda = 'D2' and tryoutgamedate = '"&dd&"' and tryoutgameingS > 0) or "
			SQL = SQL & " ( cda in ('E2','F2') and ((tryoutgamedate = '"&dd&"' and tryoutgamestarttime = '10:00') or (finalgamedate = '"&dd&"' and finalgamestarttime = '10:00')) ) "
			SQL = SQL & " )		"
		Else
			SQL = "select GbIDX from tblRGameLevel where delyn = 'N' and  gametitleidx = " &tidx& " and ("
			SQL = SQL & " (cda = 'D2' and finalgamedate = '"&dd&"' and finalgameingS > 0) or "
			SQL = SQL & " ( cda in ('E2','F2') and ((tryoutgamedate = '"&dd&"' and tryoutgamestarttime = '13:00') or (finalgamedate = '"&dd&"' and finalgamestarttime = '13:00')) ) "
			SQL = SQL & " )		"
		End if
	
' Response.write sql
' response.end

			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		ingbidx = ""
		If Not rs.EOF Then
			arrR = rs.GetRows()

			If IsArray(arrR) Then  '오전
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					gbidx = arrR(0, ari)
					If ari = 0 Then
						ingbidx = gbidx
					Else
						ingbidx = ingbidx & "," & gbidx
					End if
				Next 
			End if
		End If
	End if


	fld = " (case when max(itgubun) = 'I' then a.playeridx  else b.playeridx   end) as pidx  ,(case when max(itgubun) = 'I' then max(a.UserName)  else max(b.username)  end) as unm  , max(a.team) as team ,max(a.teamnm) as tnm, max(a.gametitleidx) as tidx, max(a.cda) as cda " ', max(a.levelno) as lno 이건 페이지 그릴때 나오도록 하자....

	If DD = "" then
	SQL = "  ;with attplayer as  "
	SQL = SQL & "( select top 20 "&fld&" from  sd_gameMember as a left join sd_gameMember_partner as b on a.gameMemberIDX = b.gameMemberIDX and b.delYN = 'N'  where a.gametitleidx = "&tidx&" and (a.username like '"&sval &"%' or b.username like '"&sval&"%')  and a.DelYN = 'N'  group by a.playeridx, b.playeridx order by unm )"
	SQL = SQL & "  select * from attplayer group by pidx,unm,team,tnm,tidx,cda "

	Else
	
	If ingbidx <> "" then
		SQL = "  ;with attplayer as  "
		SQL = SQL & "( select top 20 "&fld&" from  sd_gameMember as a left join sd_gameMember_partner as b on a.gameMemberIDX = b.gameMemberIDX and b.delYN = 'N'  where a.gametitleidx = "&tidx&" and (a.username like '"&sval &"%' or b.username like '"&sval&"%') and gbidx in ("&ingbidx&") and a.DelYN = 'N' group by a.playeridx, b.playeridx order by unm )"
		SQL = SQL & "  select * from attplayer group by pidx,unm,team,tnm,tidx,cda " 'lno
		End If
	End If
	

'Response.write sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Response.end

	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>