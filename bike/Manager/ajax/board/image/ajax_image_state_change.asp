<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Dim ajaxDb, imageIdx
SET ajaxDb = Server.CreateObject("ADODB.Connection")
    ajaxDb.CommandTimeout = 1000
    ajaxDb.Open B_ConStr

req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  imageIdx = oJSONoutput.get("imageIdx")
  titleIdx = oJSONoutput.get("titleIdx")
  openState = oJSONoutput.get("openState")

  If openState = "N" Then
    changeState = "Y"
  Else
    changeState = "N"
  End If
End If

' 관리자id
adminId = "jaehongtest"
sitecode = GLOBAL_HOSTCODE

' S:업데이트하려는 이미지정보와 로그인한 아이디의 host가 일치하는지 확인
SQL =       " SELECT COUNT(*) FROM tblBikeImage a "
SQL = SQL & " INNER JOIN tblBikeTitle b ON a.TitleIdx = b.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeHostCode c ON b.HostIdx = c.Hostidx "
SQL = SQL & " WHERE a.ImageIdx = "& imageIdx &" "
SQL = SQL & " AND c.HostCode = '"& sitecode &"' "
SQL = SQL & " AND a.DelYN = 'N' "
SQL = SQL & " AND c.DelYN = 'N' "
Set rs = ajaxDb.Execute(SQL)
If Not rs.eof Then
  isHost = rs(0)
  If isHost = 0 Then
    Response.Write "호스트불일치"
    Response.End
  Else
    SQL = " UPDATE tblBikeImage SET OpenYN = '"& changeState &"', UpdateDate = GETDATE(), Updater = '"& adminId &"' WHERE ImageIdx = "& imageIdx &""
    Call ajaxDb.Execute(SQL)
  End If
End If

oJSONoutput.Set("changeState"), changeState
strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end


Set ajaxDb = nothing
Set rs = nothing


%>
