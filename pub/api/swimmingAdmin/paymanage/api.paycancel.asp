<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''결제정보 취소요청을 완료로 변경 (상태값 확인후

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	OIDX = oJSONoutput.Get("OIDX")

	Set db = new clsDBHelper

	SQL = "UPDATE tblSwwimingOrderTable Set  Oorderstate= case when Oorderstate = '88' then '89' else '88' end where OrderIDX =  '"&OIDX&"' "
	Call db.execSQLRs(SQL , null, ConStr)
	'###################

	Call oJSONoutput.Set("result", "0" ) '메시지없이 종료
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing



%> 