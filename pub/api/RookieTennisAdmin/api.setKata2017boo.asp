<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
Response.End



nkey =oJSONoutput.NKEY

Set db = new clsDBHelper



'################################################################
'If CDbl(nkey) < 9000 then
'nkey = 9497
'End if

'nkey
If CDbl(nkey) = 0 Or CDbl(nkey) = 1  Then
	SQL = "select top 1 playeridx,UserName,UserPhone from tblPlayer where playeridx > 0 and imsi1='체크전' and DelYN='N' order by playerIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
Else
	SQL = "select top 1 playeridx,UserName,UserPhone from tblPlayer where playeridx > "&nkey&" and imsi1='체크전' and DelYN='N' order by playerIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
End If

msg = sql


'SQL = "select min(playeridx),UserName,UserPhone,COUNT(*)as c from tblPlayer where DelYN='N' group by UserName,UserPhone order by c desc"
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If rs.eof Then
	oJSONoutput.NKEY = "끝"
else
	pidx = rs(0)
	uname = rs(1)
	uphone = rs(2)

	SQL = "select playeridx from tblplayer where username = '" & uname & "' and userphone = '"&uphone&"' and delYN = 'N' order by playeridx asc"
	Set rsc = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rsc.RecordCount

	If CDbl(rscnt) > 1 Then

		i = 1
		Do Until rsc.eof
			If i = 1 then
				orgpidx = rsc(0)
			Else
				'랭킹포인트 update
				targetpidx = rsc(0)
				SQL1 = "update sd_TennisRPoint_log set PlayerIDX = "&orgpidx&" where PlayerIDX= " & targetpidx
				Call db.execSQLRs(SQL1 , null, ConStr)

				'랭킹포인트 update
				SQL2 = "update tblGameRequest set P1_PlayerIDX = "&orgpidx&" where P1_PlayerIDX= " & targetpidx
				Call db.execSQLRs(SQL2 , null, ConStr)
				SQL3 = "update tblGameRequest set P2_PlayerIDX = "&orgpidx&" where P2_PlayerIDX= " & targetpidx
				Call db.execSQLRs(SQL3 , null, ConStr)

				'참가신청 update
				SQL4 = "update sd_TennisMember set PlayerIDX="&orgpidx&" where PlayerIDX= " & targetpidx
				Call db.execSQLRs(SQL4 , null, ConStr)
				SQL5 = "update sd_TennisMember_partner set PlayerIDX="&orgpidx&" where PlayerIDX= " & targetpidx
				Call db.execSQLRs(SQL5 , null, ConStr)

				SQL6 = "delete from tblplayer where playerIDX = " & targetpidx
				Call db.execSQLRs(SQL6 , null, ConStr)
			End if

			'SQL = "update tblplayer Set imsi1 = '완료' where playeridx = " & pidx
			'Call db.execSQLRs(SQL , null, ConStr)
			pinfo = uname & " " & uphone & " 랭킹포인트 확인 - 참가신청확인 삭제   "&sql1&"<br>"

		i = i + 1
		rsc.movenext
		Loop
		oJSONoutput.NKEY = pidx

	Else
		oJSONoutput.NKEY = pidx
		SQL = "update tblplayer Set imsi1 = '완료' where playeridx = " & pidx
		Call db.execSQLRs(SQL , null, ConStr)

		pinfo =" 한명 "&msg&"<br>"
	End if




	
End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

Response.write pinfo & "<br>"




db.Dispose
Set db = Nothing
%>