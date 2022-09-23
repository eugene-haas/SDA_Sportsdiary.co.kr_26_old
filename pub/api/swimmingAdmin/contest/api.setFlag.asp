<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''1서브 지정후 수정버튼 클릭시 초기화

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	If hasown(oJSONoutput, "SEQ") = "ok" then
		tidx = oJSONoutput.SEQ
	End if
	If hasown(oJSONoutput, "FLD") = "ok" then
		fldnm = oJSONoutput.FLD
	End if

	Set db = new clsDBHelper

	SQL = "UPDATE sd_gameTitle Set  "&fldnm&" = case when "&fldnm&" = 'Y' then 'N' else 'Y' end where GameTitleIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)
	'###################

	Call oJSONoutput.Set("result", "100" ) '메시지없이 종료
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 