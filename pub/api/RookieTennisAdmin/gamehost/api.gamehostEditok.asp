<%
'#############################################
'선수 정보 수정 ( 이름은 변경 되지 않습니다.)
'#############################################
	'request
	idx = oJSONoutput.idx
	hostname = oJSONoutput.hostname

	Set db = new clsDBHelper

	tablename = " tblGameHost "
	updatevalue = " hostname='"&hostname&"' "
	SQL = " Update  "&tablename&" Set  " & updatevalue & " where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)

	idx = idx
	hostimg = ""
	makegamecnt = 0
	writeday = Date()

  db.Dispose
  Set db = Nothing
%>

	<!-- #include virtual = "/pub/html/RookietennisAdmin/gamehost/html.GameHostList.asp" -->