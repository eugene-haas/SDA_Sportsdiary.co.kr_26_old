<%
'비디오 게시판은 tid = 2
tid = 2
uploadAdmin = iLoginID
uploadIP = Request.ServerVariables("REMOTE_ADDR")

If hasown(oJSONoutput, "SEQ") = "ok" Then
    seq = chkStrRpl(oJSONoutput.SEQ,"")
End If

If hasown(oJSONoutput, "VIDEOID") = "ok" Then
    videoID = chkStrRpl(oJSONoutput.VIDEOID,"")
End If


Set db = new clsDBHelper

insertTable = " sd_bikeBoard_c "
insertField = " ( seq, tid, pid, filename, title, writeday ) "
insertValues = " ( "& seq &", "& tid &", '"& uploadAdmin &"', '"& videoID &"', "& seq &", getdate() ) "
SQL = " SET NOCOUNT ON INSERT INTO " & insertTable & insertField & " VALUES "& insertValues &" SELECT @@IDENTITY "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
cIDX = rs(0)

SQL = " SELECT idx, filename AS url FROM sd_bikeBoard_c WHERE idx = "& cIDX &" "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
url = rs("url")

'영상갯수 정보 업데이트
SQL = " UPDATE sd_bikeBoard SET tailcnt = (SELECT COUNT(idx) FROM sd_bikeBoard_c WHERE tid = "& tid &" AND seq = "& seq &" ) WHERE seq = "& seq &" "
Call db.ExecSQLRs(SQL, null, ConStr)

db.dispose

MODE = "edit"
%>
<!-- #include virtual = "/pub/html/bike/board/video/urlform.asp" -->
