<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, memberIdx

memberIdx = fInject(Request("memberIdx"))
If memberIdx = "" Then
  Response.End
End If


' 가장 최근에 입력한 대회의 titleIdx를 가져온다.
SQL = " SELECT Top 1 TitleIdx FROM tblBikeApplyMemberInfo WHERE MemberIdx = '"& memberIdx &"' ORDER BY WriteDate DESC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  titleIdx = rs("TitleIdx")
  Set rs = nothing
Else
  titleIdx = 0
End If

jsonStr = "{"

' 기본정보
SQL = " SELECT UserName, Sex, Birthday, UserPhone FROM SD_MEMBER.dbo.tblMember WHERE MemberIdx = "& memberIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  UserName  = rs("UserName")
  Sex       = rs("Sex")
  Birthday  = rs("Birthday")
  UserPhone = rs("UserPhone")
  If Cdbl(titleIdx) = 0 Then
    adultYN = GetAdultYN(Birthday, DATE())
  Else
    adultYN = GetAdultBasedOnTitle(titleIdx, memberIdx, db)
  End If
  jsonStr = jsonStr & """memberInfo"": [{""name"": """& UserName &""", ""gender"": """& Sex &""", ""birth"": """& Birthday &""", ""phoneNum"": """& UserPhone &""", ""adultYN"": """& adultYN &""" }]"
End If


' 추가정보
SQL = " SELECT GiftIdx FROM tblBikeGiftSelect WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  giftArray = rs.getRows()
  gjsonStr = gjsonStr & " ""gift"": "

  If IsArray(giftArray) Then
    gjsonStr = gjsonStr & "["
    For g = 0 To Ubound(giftArray, 2)
      giftIdx = giftArray(0, g)
      gjsonStr = gjsonStr & ""& giftIdx &""
      If g < Ubound(giftArray, 2) Then
        gjsonStr = gjsonStr & ","
      End If
    Next
  gjsonStr = gjsonStr & "]"
  Else
    gjsonStr = gjsonStr & """[]"""
  End If

End If

SQL =        " SELECT BloodType, BikeFrame, BikeCareer, b.Star, b.Category, b.Rating, b.SCRPRatingIdx, a.AgreeYN  "
SQL = SQL &  " FROM tblBikeApplyMemberInfo a "
SQL = SQL &  " LEFT JOIN (SELECT Star, Category, Rating, SCRPRatingIdx  "
SQL = SQL &  " 		        FROM tblBikeSCRP   "
SQL = SQL &  " 		        GROUP BY Star, Category, Rating, SCRPRatingIdx)  b ON a.SCRP = b.SCRPRatingIdx "
'2019-07-12 최승규 수정(테이블이 존재하지않음)
'SQL = SQL &  " LEFT JOIN tblBikeAgreement c ON a.MemberIdx = c.MemberIdx AND a.TitleIdx = c.TitleIdx "
SQL = SQL &  " WHERE a.DelYN = 'N' AND a.TitleIdx = "& titleIdx &" AND a.MemberIdx = "& memberIdx
Set rs = db.Execute(SQL)
If Not rs.eof Then
  BloodType      = rs("BloodType")
  BikeFrame      = rs("BikeFrame")
  BikeCareer     = rs("BikeCareer")
  Star           = rs("Star")
  Category       = rs("Category")
  Rating         = rs("Rating")
  SCRPRatingIdx  = rs("SCRPRatingIdx")
  AgreeYN        = rs("AgreeYN")

  scrp = GetSCRPName(Star, Category, Rating)
  scrpGrade = Split(scrp, "/")(0)
  jsonStr = jsonStr & ", ""moreInfo"": [{""blood"": """& BloodType &""", ""frame"": "& BikeFrame &", ""career"": "& BikeCareer &",  ""agree"": """& AgreeYN &""" "
  jsonStr = jsonStr & ", ""scrp"": """& scrp &""", ""scrpGrade"": """& scrpGrade &""", ""scrpLevel"": """& Rating &""",  ""scrpLevelNo"": "& SCRPRatingIdx &" "
  jsonStr = jsonStr & ", "& gjsonStr &"}] "
Else
  jsonStr = jsonStr & ", ""moreInfo"": []"
End If

' 보호자정보
SQL = "SELECT ParentInfoIdx, ParentName, ParentPhone, Relation, Adress, AdressDetail, AgreeYN, WriteDate, AgreeDate "
SQL = SQL & " FROM tblBikeParentInfo WHERE MemberIdx = "& memberIdx &" AND TitleIdx = "& titleIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  ParentInfoIdx = rs("ParentInfoIdx")
  ParentName    = rs("ParentName")
  ParentPhone   = rs("ParentPhone")
  Relation      = rs("Relation")
  Adress        = rs("Adress")
  AdressDetail  = rs("AdressDetail")
  AgreeYN       = rs("AgreeYN")
  WriteDate     = rs("WriteDate")
  AgreeDate     = rs("AgreeDate")

  jsonStr = jsonStr & ", ""parentInfo"": [{""parentInfoIdx"": "& ParentInfoIdx &", ""name"": """& ParentName &""", ""phoneNum"": """& ParentPhone &""", ""relationship"": """& Relation &""",  ""agree"": """& AgreeYN &""" "
  jsonStr = jsonStr & ", ""address"": """& Adress &""", ""addressDetail"": """& AdressDetail &""", ""agreeRequestDate"": """& WriteDate &""",  ""agreeDate"": """& AgreeDate &""" }],"
Else
  jsonStr = jsonStr & ", ""parentInfo"": [],"
End If


jsonStr = jsonStr & """SCRPInfo"":"
jsonStr = jsonStr & "["
' SCRP 선택정보
SQL =       " SELECT Top 1 SCRP, CONVERT(VARCHAR(4), StartDate, 121) ConfigYear, a.TitleIdx, b.TitleName FROM tblBikeApplyMemberInfo a "
SQL = SQL & " LEFT JOIN tblBikeTitle b ON a.TitleIdx = b.TitleIdx "
SQL = SQL & " WHERE MemberIdx = '"& memberIdx &"' "
SQL = SQL & " AND a.DelYN = 'N' "
SQL = SQL & " AND b.DelYN = 'N' "
SQL = SQL & " ORDER BY b.StartDate DESC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  scrp = rs("SCRP")
  configYear = rs("ConfigYear")
  titleIdx = rs("TitleIdx")
  titleName = rs("TitleName")
  jsonStr = jsonStr & "{""scrpLevelNo"": "& scrp &", ""configYear"": """& configYear &""", ""titleIdx"": "& titleIdx &", ""titleName"": """& titleName &"""}"
End If
jsonStr = jsonStr & "]"



jsonStr = jsonStr & "}"
Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
