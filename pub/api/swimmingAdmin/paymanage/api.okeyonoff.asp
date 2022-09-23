<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''결제정보 취소요청을 완료로 변경 (상태값 확인후

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	seq = oJSONoutput.Get("SEQ")
	ok =  oJSONoutput.Get("OK")

	Set db = new clsDBHelper

	SQL = "UPDATE tblSwwimingOrderTable Set  okey = "&ok&" where OrderIDX =  '"&seq&"' "
	Call db.execSQLRs(SQL , null, ConStr)
	'###################

	Call oJSONoutput.Set("result", "0" ) '메시지없이 종료
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing



%> 