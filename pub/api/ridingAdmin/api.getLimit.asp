<%
'#######################
'종목별 선수  말 제한 사항 설정
'#######################
	'request 처리##############
	
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then
		gbidx = oJSONoutput.GBIDX
	End If
	If hasown(oJSONoutput, "PTYPE") = "ok" Then
		ptype = oJSONoutput.PTYPE
	End If
	If hasown(oJSONoutput, "GTYPE") = "ok" Then
		gtype = oJSONoutput.GTYPE
	End If

	Set db = new clsDBHelper

	If gtype = "1" Then '개인
		If ptype  = "1" Then '선수 playerlimitidxs
			SQL = "Select top 1 playerlimitidxs from tblRGameLevel where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		Else '말 horselimitidxs
			SQL = "Select top 1 horselimitidxs from tblRGameLevel where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		End if
	Else

		If ptype  = "1" Then '선수 playerlimitidxs
			SQL = "Select top 1 playerlimitidxs2 from tblRGameLevel where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		Else '말 horselimitidxs
			SQL = "Select top 1 horselimitidxs2 from tblRGameLevel where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		End if
	End if


	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		arrstr = rs(0)
		If arrstr = "" Then
			arr = array(0)
		else
			arr =  Split(arrstr,",")
		End if
	End if

	Call oJSONoutput.Set("tidx", tidx ) 
	Call oJSONoutput.Set("gbidx", gbidx ) 
	Call oJSONoutput.Set("idxlist", arr ) 

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>