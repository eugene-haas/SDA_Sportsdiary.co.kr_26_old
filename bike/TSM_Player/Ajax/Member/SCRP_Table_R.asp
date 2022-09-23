<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, memberIdx, memberBirth, target

memberIdx = fInject(Request("memberIdx"))
titleIdx = fInject(Request("titleIdx"))
If titleIdx = "" Or memberIdx = "" Then
  response.end
End If

SQL = " SELECT Sex FROM SD_Member.dbo.tblMember WHERE MemberIDX = '"& memberIdx &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  sex = rs("Sex")
  If GetAdultBasedOnTitle(titleIdx, memberIdx, db) = "Y" And sex = "Man" Then
    target = "ManAdult"
  ElseIF sex = "WoMan" Then
    target = "Woman"
  Else
    target = "ManJuvenile"
  End If
End If

jsonStr = "{"


SQL = " SELECT Category, Star FROM tblBikeSCRP WHERE Target = '"& target &"' AND DelYN = 'N'  GROUP BY Category, Star ORDER BY Star ASC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrCategory = rs.getRows()
End If

' 카테고리조건으로 분류
If IsArray(arrCategory) Then
  ' S: 등급구분
  jsonStr = jsonStr& """scrp"": ["

  For c = 0 To Ubound(arrCategory, 2)
    category  = arrCategory(0, c)
    star      = arrCategory(1, c)
    gradeText = GetSCRPName(star, category, 0)

    ' S: 등급별내용
    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & """scrpGrade"": """& gradeText &""" , "

    ' rating 리스트
    SQL = " SELECT SCRPRatingIdx, Rating FROM tblBikeSCRP WHERE Target = '"& target &"' AND Category = '"& category &"' GROUP By Rating, SCRPRatingIdx "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrRating = rs.getRows()
    End If

    ' 상세정보 리스트
    SQL = " SELECT SCRPRatingIdx, ContentTitle, ContentDetail FROM tblBikeSCRP WHERE Target = '"& target &"' AND Category = '"& category &"' AND DelYN = 'N' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrSCRP = rs.getRows()
    End If

    ' S:상세정보 JSON
    jsonStr = jsonStr & " ""scrpList"": ["

    If IsArray(arrRating) Then
      For r = 0 To Ubound(arrRating, 2)
        ridx    = arrRating(0, r)
        rating = arrRating(1, r)

        jsonStr = jsonStr & "{"
        jsonStr = jsonStr & """scrpLevelNo"": "& ridx &", ""scrpLevel"": """& rating &""", "

        ' S:상세정보 item
        jsonStr = jsonStr & " ""items"": ["
        If IsArray(arrSCRP) Then
          arrSCRPCount = Ubound(arrSCRP, 2)
          For s = 0 To arrSCRPCount
            sIdx = arrSCRP(0, s)
            title = arrSCRP(1, s)
            detail = arrSCRP(2, s)
            If s < arrSCRPCount Then
              nextSIdx = arrSCRP(0, (s+1))
            Else
              nextSIdx = 0
            End If

            If sIdx = ridx Then
              jsonStr = jsonStr & "{""title"": """& title &""", ""desc"": """& detail &"""}"
              If sIdx = nextSIdx Then
                jsonStr = jsonStr & ","
              End if
            End If

          Next
        End If
        jsonStr = jsonStr & "]}"
        If r < Ubound(arrRating, 2) Then
          jsonStr = jsonStr & ","
        End If
        ' S:상세정보 item

      Next
    End If
    jsonStr = jsonStr & "]"
    ' E:상세정보 JSON

    jsonStr = jsonStr & "}"
    ' E: 등급별내용
    If c < Ubound(arrCategory, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next

  jsonStr = jsonStr & "]"
  ' E: 등급구분
End If

jsonStr = jsonStr & "}"

Response.Write jsonStr
Response.End
%>
