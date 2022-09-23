<%
'#############################################
'삭제
'#############################################
	'request
	reqidx = oJSONoutput.get("IDX")
	EvalTableIDX = oJSONoutput.get("ETBLIDX") 'EvalTableIDX 현재진행중인 평가
	
	Set db = new clsDBHelper
	

	SQL = " Update tblAssociation_sub Set "
	SQL = SQL & " delkey = 1 "
	SQL = SQL & " where  delkey = 0 and AssociationIDX = " & reqidx & " and EvalTableIDX = " & EvalTableIDX
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>



