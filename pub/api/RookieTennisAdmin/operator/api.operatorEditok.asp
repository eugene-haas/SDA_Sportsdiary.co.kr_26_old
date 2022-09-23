<%
'#############################################
'관리자계정
'#############################################
	'request
	idx = oJSONoutput.idx
	admin_id = oJSONoutput.ADID
	admin_pwd = oJSONoutput.ADPWD
	admin_title = oJSONoutput.ADTITLE

	Set db = new clsDBHelper

'	insertfield = " SportsGb,HostCode,ManagerName,ManagerID,ManagerPwd,Gubun,WriteDate "
	tablename = " tblGameManager "
	updatevalue = " ManagerName='"&admin_title&"',ManagerID='"&admin_id&"',ManagerPwd='"&admin_pwd&"'  "
	SQL = " Update  "&tablename&" Set  " & updatevalue & " where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)

	idx = idx
	writeday = Date()

  db.Dispose
  Set db = Nothing

	passstar = "*******************************************"
%>

		<!-- #include virtual = "/pub/html/RookietennisAdmin/operator/html.operatorList.asp" -->