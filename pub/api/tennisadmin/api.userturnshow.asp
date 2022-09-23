<%
'#############################################
' 본선 대진표 사용자 화면 표시여부 (대회마다)
'#############################################

'request
tidx = oJSONoutput.TIDX


Set db = new clsDBHelper

SQL = "update sd_TennisTitle Set  tnshowhide = case when tnshowhide = 'Y' then 'N' else 'Y' end where gametitleidx = " & tidx
Call db.execSQLRs(SQL , null, ConStr)



db.Dispose
Set db = Nothing
%>