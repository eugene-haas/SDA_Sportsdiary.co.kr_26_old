<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	pidx = oJSONoutput.pidx
	levelno = oJSONoutput.levelno
	playerno = oJSONoutput.playerno
	tidx = oJSONoutput.tidx

	Set db = new clsDBHelper
	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then 
		arrRS = rst.GetRows()
	End if

	strSql = "SELECT top 1 UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm,userLevel  from tblPlayer where SportsGb = 'tennis' and DelYN = 'N' and PlayerIDX = " & pidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt-1)

	If Not rs.eof then
		If playerno = "1" then
		p1idx = rs("PlayerIDX")
		p1name = rs("UserName")
		p1phone = rs("UserPhone")
		p1t1 = rs("TeamNm")
		p1t2 = rs("Team2Nm")
		Else
		p2idx = rs("PlayerIDX")
		p2name = rs("UserName")
		p2phone = rs("UserPhone")
		p2t1 = rs("TeamNm")
		p2t2 = rs("Team2Nm")
		End if
	End If
	
	db.Dispose
	Set db = Nothing

Select Case playerno
Case "1"%>
      <span> 이름 : </span>
      <input type="hidden" id="p1idx" value="<%=p1idx%>">
      <input type="text" id="p1name" value="<%=p1name%>" width="100px;" class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
      </br><br>

      <span> 핸드폰 : </span><span id="p1phone"><%=p1phone%></span>
      </br><br>
      <span> 클럽1 : </span><span id="p1team1"><%=p1t1%></span>
      </br><br>
      <span> 클럽2 : </span><span id="p1team2"><%=p1t2%></span>
<%Case "2"%>
      <span> 이름 : </span>
      <input type="hidden" id="p2idx" value="<%=p2idx%>">
      <input type="text" id="p2name" value="<%=p2name%>" width="100px;" class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
      </br><br>

      <span> 핸드폰 : </span><span id="p2phone"><%=p2phone%></span>
      </br><br>
      <span> 클럽1 : </span><span id="p2team1"><%=p2t1%></span>
      </br><br>
      <span> 클럽2 : </span><span id="p2team2"><%=p2t2%></span>
<%End Select%>