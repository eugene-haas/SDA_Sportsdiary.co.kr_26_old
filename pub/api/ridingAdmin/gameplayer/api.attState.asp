<%
'#############################################

'#############################################

'request
idx = oJSONoutput.IDX
chk = oJSONoutput.CHK
'cfg = oJSONoutput.CFG
typeno = oJSONoutput.TYPENO

Set db = new clsDBHelper

SQL = " Select cfg from tblRGameLevel where RGameLevelidx= " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
cfg = rs(0)

chk1 = Left(cfg,1) '변형요강
chk2 = Mid(cfg,2,1)
chk3 = Mid(cfg,3,1)
chk4 = Mid(cfg,4,1)

Select Case CStr(typeno)
Case "1" '신청
	makecfg = chk1 & chk & chk3 & chk4
Case "2" '수정
	makecfg = chk1 & chk2 & chk & chk4
Case "3" '삭제
	makecfg = chk1 & chk2 & chk3 & chk
End Select 


SQL = " Update  tblRGameLevel Set  cfg='"&makecfg&"' where RGameLevelidx= " & idx
Call db.execSQLRs(SQL , null, ConStr)

'#############################################


Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>
