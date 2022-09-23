<%
Dim num, GY, GTITLE, LEVELNO, BTITLE, URLS, uploadIP, UploadAdmin, tid

Set db = new clsDBHelper

uploadAdmin = iLoginID
uploadIP = Request.ServerVariables("REMOTE_ADDR")

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

If hasown(oJSONoutput, "URLS") = "ok" Then  '비디오 URL array
    urls = split(chkStrRpl(oJSONoutput.URLS,""), ",")
End If

'num(게시물순서) 구하기, video게시물은 tid = 2 , 이미지 게시물은 tid = 1
tid = 2
SQL = " SELECT TOP 1 num FROM sd_bikeBoard WHERE tid = "& tid &" ORDER BY num DESC "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
If rs.bof Then
  num = 1
Else
  num =  rs(0) + 1
End If




insertTable = " sd_bikeBoard "
insertField = " ( titleIDX, levelNo, tid, pid, ip, title, writeday, num )"
insertValues = " ( "& gtitle &", "& levelno &", "& tid &", '"& uploadAdmin &"', '"& uploadIP &"', '"& btitle &"', getdate(), "&num&" ) "
SQL = " SET NOCOUNT ON INSERT INTO " & insertTable & insertField & " VALUES "& insertValues &" SELECT @@IDENTITY "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
seq = rs(0)


If Cdbl(seq) > 0 Then
  For i = 0 To Ubound(urls)
    insertTable = " sd_bikeBoard_c "
    insertField = " ( seq, tid, pid, filename, title, writeday ) "
    insertValues = " ( "& seq &", "& tid &", '"& uploadAdmin &"', '"& urls(i) &"', "& seq &", getdate() ) "
    SQL = " INSERT INTO "& insertTable &" "&insertField&" VALUES "&insertValues&" "
    Call db.ExecSQLRs(SQL, null, ConStr)
  Next
End If

'tailcnt 값을 올려준다(영상갯수 culumn)
SQL = " UPDATE sd_bikeBoard SET tailcnt = (SELECT COUNT(idx) FROM sd_bikeBoard_c WHERE tid = "& tid &" AND seq = "& seq &" ) WHERE seq = "& seq &" "
Call db.ExecSQLRs(SQL, null, ConStr)

db.dispose
%>
