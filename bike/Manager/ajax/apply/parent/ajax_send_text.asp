<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
SET ajaxDb = Server.CreateObject("ADODB.Connection")
    ajaxDb.CommandTimeout = 1000
    ajaxDb.Open B_ConStr
Dim req
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  parentInfoIdx = oJSONoutput.parentInfoIdx
  userName      = oJSONoutput.userName
End If

SQL = " SELECT MemberIdx, TitleIdx, ParentPhone FROM tblBikeParentInfo WHERE ParentInfoIdx = "& parentInfoIdx &" "
Set rs = ajaxDb.Execute(SQL)
If Not rs.eof Then
  memberIdx   = rs("MemberIdx")
  titleIdx    = rs("TitleIdx")
  parentPhone = rs("ParentPhone")
  parentPhone = Replace(parentPhone, "-", "")
End If

p = encode(parentInfoIdx & "," & memberIdx & "," & titleIdx, 0)
pageLink    = "http://bike.sportsdiary.co.kr/bike/event/pagree.asp?p="& p &" "
kind = "parentAgree"
content = GetTextContent(ajaxDb, kind, pageLink, titleIdx, userName)
Call SendText(ajaxDb, parentPhone, TitleName, content)

strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
%>
