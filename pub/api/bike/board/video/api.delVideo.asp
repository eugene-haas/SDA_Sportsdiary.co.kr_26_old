<%

Set db = new clsDBHelper

If hasown(oJSONoutput, "CIDX") = "ok" Then
    cIDX = chkStrRpl(oJSONoutput.CIDX,"")
End If

If hasown(oJSONoutput, "SEQ") = "ok" Then
    seq = chkStrRpl(oJSONoutput.SEQ,"")
End If

'삭제
SQL = " DELETE FROM sd_bikeBoard_c WHERE idx = "& cIDX &"  "
Call db.ExecSQLRs(SQL, null, ConStr)

'영상갯수 업데이트
SQL = " UPDATE sd_bikeBoard SET tailcnt = (SELECT COUNT(idx) FROM sd_bikeBoard_c WHERE seq = "& seq &" ) WHERE seq = "& seq &" "
Call db.ExecSQLRs(SQL, null, ConStr)

db.dispose

%>
