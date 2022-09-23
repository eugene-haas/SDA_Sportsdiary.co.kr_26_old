<%
Set db = new clsDBHelper

uploadAdmin = iLoginID
uploadIP = Request.ServerVariables("REMOTE_ADDR")
'num 구하기, video게시물은 tid = 2 , 이미지 게시물은 tid = 1
tid = 2
SQL = " SELECT TOP 1 num FROM sd_bikeBoard WHERE tid = "& tid &" ORDER BY num DESC "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
num =  rs(0) + 1

If hasown(oJSONoutput, "GY") = "ok" Then  '게임년도
    gy = chkStrRpl(oJSONoutput.GY,"")
End If

If hasown(oJSONoutput, "GTITLE") = "ok" Then  '대회 IDX
    gtitle = chkStrRpl(oJSONoutput.GTITLE,"")
End If

If hasown(oJSONoutput, "LEVELNO") = "ok" Then  '부 IDX
    levelno = chkStrRpl(oJSONoutput.LEVELNO,"")
End If

If hasown(oJSONoutput, "BTITLE") = "ok" Then  '게시글 제목
    btitle = chkStrRpl(oJSONoutput.BTITLE,"")
End If

If hasown(oJSONoutput, "SEQ") = "ok" Then  '비디오 URL array
    seq = oJSONoutput.SEQ
Else
    response.end
End If


updateTable = " sd_bikeBoard "
updateField = " titleIDX = "& gtitle &", levelNo = "& levelno &", tid = "& tid &", pid = '"& uploadAdmin &"', ip = '"& uploadIP &"', title = '"& btitle &"' "
updateWhere = " seq = "& seq &" "
SQL = " UPDATE "& updateTable &" SET "& updateField &" WHERE "& updateWhere &" "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

db.dispose



%>
