<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, memberIdx

titleIdx = fInject(Request("titleIdx"))
If titleIdx = "" Then
  Response.End
End If

SQL = " SELECT PPubCode FROM tblPubCode WHERE DelYN = 'N' GROUP BY PPubCode  "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrCode  = rs.getRows()
End If

jsonStr = "{"
If IsArray(arrCode) Then
  For c = 0 To Ubound(arrCode, 2)
    code = arrCode(0, c)

    jsonStr = jsonStr & " """& code &""": ["

    SQL = " SELECT PubCodeIdx, PubName, PPubName, OrderBy FROM tblPubCode WHERE PPubCode = '"& code &"' AND DelYN = 'N' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrOption = rs.getRows()
      If IsArray(arrOption) Then
        For o = 0 To Ubound(arrOption, 2)
          PubCodeIdx = arrOption(0, o)
          PubName    = arrOption(1, o)
          PPubName   = arrOption(2, o)
          OrderBy    = arrOption(3, o)
          jsonStr = jsonStr & "{""idx"": """& PubCodeIdx &""", ""name"": """& PubName &""", ""kind"": """& PPubName &""", ""order"": """& OrderBy &"""}"
          If o < Ubound(arrOption, 2) Then
            jsonStr = jsonStr & ","
          End If
        Next
      End If
    End If

    jsonStr = jsonStr & "]"
    If c < Ubound(arrCode, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If

' S: 사은품리스트
SQL = " SELECT GiftIdx, GiftOption, GiftName  FROM tblBikeGift WHERE TitleIdx = "& titleIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrGift = rs.getRows()
End If

jsonStr = jsonStr & ", ""gift"": ["
If IsArray(arrGift) Then
  For g = 0 To Ubound(arrGift, 2)
    GiftIdx    = arrGift(0, g)
    GiftOption = arrGift(1, g)
    GiftName   = arrGift(2, g)
    jsonStr = jsonStr & "{""giftNo"": "& GiftIdx &", ""name"": """& GiftName &""", ""option"": """& GiftOption &"""}"

    If g < Ubound(arrGift, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If
jsonStr = jsonStr & "]"
' E: 사은품리스트

jsonStr = jsonStr & "}"

Response.Write jsonStr
Response.End
%>
