<%
'#############################################
'오전 오후
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	gbidx = oJSONoutput.Get("GBIDX")
	timestr = oJSONoutput.Get("TIMESTR") '10:00 오전 13:00 오후
	
	Set db = new clsDBHelper 


		'Grouplevelidx  부서를 합쳐서 경기를 진행
		SQL = "Select isnull(Grouplevelidx,'') From tblRGameLevel Where RGameLevelidx = "  & lidx

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		grp_idx = rs(0)

		If grp_idx = "" Or grp_idx = "0" then

				'라운드가 설정되어있고 심판이 배정되어있고 심사가 진행된게 있다면?
				'라운드가 새로 생성된다면 기존 정보를 지운다. 
				SQL = "select max(judgeEndCnt) from sd_gameMember_roundRecord where lidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If isNull(rs(0)) = True Or rs(0) = "0" then
					SQL = "update tblRGameLevel set tryoutgamestarttime = '" & timestr & "' where RGameLevelidx = "  & lidx
					Call db.execSQLRs(SQL , null, ConStr)
				Else
					Call oJSONoutput.Set("result", 23 ) '심사내용있음
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
				End if


		
		Else '통합 부서 

				'라운드가 설정되어있고 심판이 배정되어있고 심사가 진행된게 있다면?
				'라운드가 새로 생성된다면 기존 정보를 지운다. 
				SQL = "select max(judgeEndCnt) from sd_gameMember_roundRecord where lidx in ( Select  RGameLevelidx From tblRGameLevel Where  Grouplevelidx = "  & grp_idx & " )"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If isNull(rs(0)) = True Or rs(0) = "0" then
					SQL =  "update tblRGameLevel set tryoutgamestarttime = '" & timestr & "' where RGameLevelidx in ( Select  RGameLevelidx From tblRGameLevel Where  Grouplevelidx = "  & grp_idx & " )"
					Call db.execSQLRs(SQL , null, ConStr)
				Else
					Call oJSONoutput.Set("result", 23 ) '심사내용있음
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
				End if


		End if


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>