<%
'#############################################

'종목 전체 업데이트

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End if

	If hasown(oJSONoutput, "GHANGEGNO") = "ok" then
		r_sno= oJSONoutput.GHANGEGNO
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End if

	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End if

	Set db = new clsDBHelper


	'마장마술인 경우 시간도 상대와 바꾸어야한다.
	SQL = "Select top 1 max(tryoutsortno)  from sd_TennisMember  where delYN= 'N' and gametitleidx = "& r_tidx &" and  gamekey3 = '"&r_gbidx&"' and  round= 1 and gubun < 100 " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	'맥스보다 크다면 백..~~~~
	If isNull(rs(0))  = false Then 

		If CDbl(rs(0)) < CDbl(r_sno)  Then 
			Call oJSONoutput.Set("result", "21" ) '수정시 세부종목 변경 불가
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			rs.close
			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End
		End If
	End if


	SQL = "Select top 1 tryoutsortno,CONVERT(CHAR(23), gametime , 20) as gtm  from sd_TennisMember where gamememberidx = " & r_idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		i_sno = rs("tryoutsortno") '원래가지고 있던 번호
		i_gametime = rs("gtm")
	End If
	
	SQL = "Select top 1 gamememberidx,CONVERT(CHAR(23), gametime , 20) as gtm  from sd_TennisMember where delYN= 'N' and gametitleidx = "& r_tidx &" and  gamekey3 = '"&r_gbidx&"' and  round= 1 and gubun < 100 and  tryoutsortno = '" & r_sno & "' " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		target_midx = rs("gamememberidx")
		r_gametime = rs("gtm")
	End If


	SQL = "Update sd_TennisMember Set tryoutsortno = " & i_sno & ",gametime = '"&i_gametime&"' where gamememberidx = " & target_midx   '바뀔 번호를 원래번호로 바꾸고
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "Update sd_TennisMember Set tryoutsortno = " & r_sno & ",gametime = '"&r_gametime&"' where delYN= 'N' and gamememberidx = " & r_idx   '나는...
	Call db.execSQLRs(SQL , null, ConStr)

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>
