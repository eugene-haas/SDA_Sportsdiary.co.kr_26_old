<%
'#############################################

'대회번호_조수

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "GAMEDATE") = "ok" Then
		gamedate = oJSONoutput.GAMEDATE
	End If

	If hasown(oJSONoutput, "AMPM") = "ok" Then
		ampm = oJSONoutput.AMPM
	End If


	Set db = new clsDBHelper


	'공통정보 따로 가져오기
	SQL = "Select  gametitlename from sd_gameTitle  where delYN = 'N'  and GameTitleIDX = "&tidx&" "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		gametitle = rs(0)
		Call oJSONoutput.Set("TITLE", gametitle )
	Else
		Call oJSONoutput.Set("result", 99 ) '조회정보 없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	End if


	If ampm = "am" then	'오전
		fld = " gameno as GNO , joono as JCNT "
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&gamedate&"' and tryoutgameingS > 0) order by gameno "
	Else
		fld = " gameno2 as GNO , joono2 as JCNT "
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (finalgamedate = '"&gamedate&"' and finalgameingS > 0)    order by gameno2 "
	End If
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	list = jsonTors_arr(rs)
	Set list = JSON.Parse( join(array(list)) )

	Call oJSONoutput.Set("LIST", list )
	Call oJSONoutput.Set("result", 0 )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
