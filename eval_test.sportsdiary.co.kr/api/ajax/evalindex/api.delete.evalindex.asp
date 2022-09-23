<%
'#############################################
'삭제
'#############################################
	'request
	reqidx = oJSONoutput.get("IDX") 'EvalTableIDX
		
	Set db = new clsDBHelper
	
	'수정모드 확인
	Call chkEndMode(reqidx, oJSONoutput,db,ConStr)


	'평가진행중인경우 삭제불가
	' SQL = "Select EvalTableIDX from  tblEvalValue where delkey = 0 and EvalTableIDX = " & reqidx
	' Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	' if not rs.eof then
	' 	Call oJSONoutput.Set("result", 111 )
	' 	Call oJSONoutput.Set("servermsg", "평가가 진행되어 삭제하실 수 없습니다." )
	' 	strjson = JSON.stringify(oJSONoutput)
	' 	Response.Write strjson
	' 	Response.End	
	' end if


	SQL = " Update tblEvalTable Set "
	SQL = SQL & " delkey = 1 "
	SQL = SQL & " where EvalTableIDX = " & reqidx
	'Call db.execSQLRs(SQL , null, ConStr)

	SQL = SQL & " Update tblAssociation_sub Set "
	SQL = SQL & " delkey = 1 "
	SQL = SQL & " where EvalTableIDX = " & reqidx

	SQL = SQL & "Update tblEvalItem Set delkey = 1 where EvalTableIDX = " & reqidx
	SQL = SQL & "Update tblEvalItemType  Set delkey = 1 where EvalTableIDX = " & reqidx
	SQL = SQL & "Update tblEvalItemTypeGroup  Set delkey = 1 where EvalTableIDX = " & reqidx
	SQL = SQL & "Update tblEvalMember  Set delkey = 1 where EvalTableIDX = " & reqidx
	SQL = SQL & "Update tblEvalValue  Set delkey = 1 where EvalTableIDX = " & reqidx
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>