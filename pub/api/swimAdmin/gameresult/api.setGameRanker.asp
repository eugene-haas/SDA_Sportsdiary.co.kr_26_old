<%
'#############################################


'#############################################
	'request
	tidx = oJSONoutput.TIDX
	levelno = oJSONoutput.LEVELNO
	pname = oJSONoutput.NAME
	ppoint = oJSONoutput.POINT
	prankno = oJSONoutput.RANKNO

	Set db = new clsDBHelper


	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

'	'중복이름이 있는지 검사
	SQL = "Select rankno,userName,getpoint,idx,PlayerIDX from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & "and userName = '"&pname&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	If Not rs.eof Then
		Call oJSONoutput.Set("result", "1001" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End if	


	If Left(levelno,5)  = "20120" Then '단체전
		'pname => "플레이어 인덱스로 받아서 처리"
		If isnumeric(pname) = True Then
			playeridx = pname
			SQL = "Select max(username),count(*) from tblplayer where playeridx = '"&pname&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			pname = rs(0)
		else
			SQL = "Select max(playeridx), count(*) from tblplayer where username = '"&pname&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			playeridx = rs(0)
		End if

		If CDbl(rs(1)) = 1 Then

			SQL = "select a.GameTitleName, b.GameDay,titleGrade,titleCode from sd_TennisTitle as a inner join tblRGameLevel as b on a.GameTitleIDX = b.GameTitleIDX  where a.GameTitleIDX = "&tidx&" and b.Level = '"&levelno&"'"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Selectquery = "Select top 1 '"&playeridx&"','"&pname&"', "&ppoint&","&prankno&", '"&rs(2)&"','"&rs(3)&"',"&tidx&",'"&rs(0)&"','"&Left(levelno,5)&"','단체전','"&rs(1)&"','Y' from sd_TennisRPoint_log "
			SQL = "SET NOCOUNT ON Insert into sd_TennisRPoint_log (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,adminINdata) " & Selectquery & " SELECT @@IDENTITY"
'Response.write sql
'Response.end
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idx = rs(0)
'Response.write sql
		Else
			Call oJSONoutput.Set("result", "1004" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

	else

		strwhere = " a.GameTitleIDX = " & tidx & " and  a.teamGb = " & Left(levelno,5)  & " and a.playerIDX > 1 and (a.userName = '"&pname&"' or b.userName = '"&pname&"') " 
		strfield = " a.playerIDX, b.playerIDX,a.userName,b.userName " '& rank1boo & rank2boo
		SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			'대회 참가자 인지 검사 (단체전 제외)
			Call oJSONoutput.Set("result", "1002" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		else
			Do Until rs.eof 
				apidx = rs(0)
				bpidx = rs(1)
				aname = rs(2)
				bname = rs(3)

				If pname = aname Then
					pidx = apidx
				End if
				If pname = bname Then
					pidx = bpidx
				End if	
			rs.movenext
			Loop
		End if

		'인서트 'td 생성  *** 관리자가 넣어준 내용이므로 재편성시 지워지면 안된다. adminINdata = 'Y'
		Selectquery = "Select top 1 "&pidx&",'"&pname&"', "&ppoint&","&prankno&", titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,'Y' from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5)
		SQL = "SET NOCOUNT ON Insert into sd_TennisRPoint_log (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,adminINdata) " & Selectquery & " SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)
	End if

  db.Dispose
  Set db = Nothing
%>
<tr class="rgametitle"  id="r_<%=idx%>">
<td><%=pname%></td>
<td><input type='text' id='prank_<%=idx%>' value='<%=prankno%>' onblur="if(this.value !=''){sd.changeRank(<%=idx%>,this.value,<%=levelno%>)}"></td>
<td><input type='text' id='pt_<%=idx%>' value='<%=ppoint%>' onblur="if(this.value !=''){sd.changePt(<%=idx%>,this.value,<%=levelno%>)}"></td>
<td><a href="javascript:sd.delranker(<%=idx%>)" class='btn'>삭제</a></td>
</tr>