<%
'#############################################
'결승 라운드 참가자로 만든다.
'#############################################
	'request
	jc_id = oJSONoutput.ID 'tblRGameLevel jc_idx
	jc_value = oJSONoutput.VALUE

	tidx = oJSONoutput.TIDX
	levelno = oJSONoutput.LEVELNO

	idx = Replace(jc_id,"jc_","")

	Set db = new clsDBHelper

	'예선 편성완료된 조가 있는지 확인
	SQL = "select gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and DelYN = 'N' and gubun = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'편성완료된 조가 있어
	If Not rs.eof Then
		Call oJSONoutput.Set("result", 5001 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	else
		'없다면 업데이트
		SQL = "Update tblRGameLevel Set JooCnt = " & jc_value & ",lastjoono = "& jc_value &" where RGameLevelidx = " & idx 
		Call db.execSQLRs(SQL , null, ConStr)
	End if



	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>