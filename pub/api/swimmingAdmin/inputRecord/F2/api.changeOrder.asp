<%
'#############################################
'경기순서변경
'#############################################

	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	orderno = oJSONoutput.Get("ORDERNO")
	preorderno = oJSONoutput.Get("PREORDERNO")
	cda = oJSONoutput.Get("CDA")
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper

	'lidx 원래 값 

	'변활할려고 하는 순서가 그룹에 속해있다면..
	SQL = "Select RGameLevelidx, grouplevelidx from tblRGameLevel where gametitleidx = " & tidx &  " and gameno = '"&orderno&"'  and CDA='"&CDA&"'  and delyn='N'   " 
	 Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	 If rs.eof Then
		
		'범위를  벋어남
		Call oJSONoutput.Set("result", 28 ) '부서의 경기순서번호에서 벋어남
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson	
		Response.end

	 Else

		targetlidx = rs(0)
		targetgidx = isNulldefault(rs(1),"")

		If targetgidx <> "" Then
			Call oJSONoutput.Set("result", 25 ) '그룹에 포함된 순서입니다.
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

	 End if

	 
	 SQL = "Update tblRGameLevel Set gameno =  '"& orderno &"' where  RGameLevelidx = " & lidx
	 SQL = SQL & " Update tblRGameLevel Set gameno =  '"& preorderno &"' where  RGameLevelidx = " & targetlidx
	 Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("sql", sql )

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>