<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''1서브 지정후 수정버튼 클릭시 초기화

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	If hasown(oJSONoutput, "IDX") = "ok" then
		tidx = oJSONoutput.IDX
	End if
	If hasown(oJSONoutput, "BTNNO") = "ok" then
		btnno = oJSONoutput.BTNNO
	End if

	Set db = new clsDBHelper
	
	'ViewYN = rs("ViewYN")
	'MatchYN = rs("stateNo")
	'ViewState = rs("ViewState")

	Select Case CStr(btnno)
	Case "1"
	SQL = "UPDATE sd_TennisTitle Set  ViewYN = case when ViewYN = 'Y' then 'N' else 'Y' end where GameTitleIDX = " & tidx
	Case "2"
	SQL = "UPDATE sd_TennisTitle Set  ViewState = case when ViewState = 'Y' then 'N' else 'Y' end   where GameTitleIDX = " & tidx
	Case "3"
	SQL = "UPDATE sd_TennisTitle Set  stateNo = case when stateNo = '0' then '1' else '0' end  where GameTitleIDX = " & tidx
	End select

	Call db.execSQLRs(SQL , null, ConStr)
	'###################

	Call oJSONoutput.Set("result", "100" ) '메시지없이 종료
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 