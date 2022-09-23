<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, memberIdx

titleIdx = fInject(Request("titleIdx"))
memberIdx = fInject(Request("memberIdx"))
eventType = fInject(Request("eventType"))
If titleIdx = "" Or memberIdx = "" Then
  Response.End
End If

SQL = " SELECT Sex FROM SD_Member.dbo.tblMember WHERE memberIdx = '"& memberIdx &"' AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  memberGender = rs("Sex")
  If memberGender = "Man" Then
    memberGenderKor = "남자"
  ElseIf memberGender = "WoMan" Then
    memberGenderKor = "여자"
  End If
Else
  Response.end
End If

SQL =       " SELECT b.Category FROM tblBikeApplyMemberInfo a "
SQL = SQL & " LEFT JOIN (SELECT Category, SCRPRatingIdx  "
SQL = SQL & " 		   FROM tblBikeSCRP) b ON a.SCRP = b.SCRPRatingIdx "
SQL = SQL & " WHERE a.MemberIdx = '"& memberIdx &"' AND a.TitleIdx = "& titleIdx &" "
SQL = SQL & " GROUP BY b.Category "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  SCRP = rs(0)
End If

jsonStr = "{"
' S: 종목전체
jsonStr = jsonStr & " ""eventList"": "
jsonStr = jsonStr & "{"

' 개인종목
SQL =       " SELECT a.EventIdx, a.EventType, a.CourseLength, a.EventDetailType, a.MinPlayer, a.MaxPlayer, a.EventDate, a.RatingCategory, ISNULL(b.Star, 0) Star "
SQL = SQL & " FROM tblBikeEventList a "
SQL = SQL & " LEFT JOIN (SELECT Category, Star FROM tblBikeSCRP GROUP BY Category, Star) b ON a.RatingCategory = b.Category"
SQL = SQL & " WHERE a.DelYN = 'N' AND a.GroupType = '개인' AND a.EventType = '"& eventType &"' AND a.TitleIdx = "& titleIdx &" "
SQL = SQL & " AND (a.Gender = '"& memberGenderKor &"' OR a.Gender = '전체') AND (a.RatingCategory = '"& SCRP &"' Or a.RatingCategory = 'None') "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrSolo = rs.getRows()
End If

' 단체종목
SQL =       " SELECT a.EventIdx, a.EventType, a.CourseLength, a.EventDetailType, a.MinPlayer, a.MaxPlayer, a.EventDate, a.RatingCategory, ISNULL(b.Star, 0) Star "
SQL = SQL & " FROM tblBikeEventList a  "
SQL = SQL & " LEFT JOIN (SELECT Category, Star FROM tblBikeSCRP GROUP BY Category, Star) b ON a.RatingCategory = b.category "
SQL = SQL & " WHERE a.DelYN = 'N' AND a.GroupType = '단체' AND a.EventType = '"& eventType &"' AND a.TitleIdx = "& titleIdx &" "
SQL = SQL & " AND (a.Gender = '"& memberGenderKor &"' OR a.Gender = '전체') AND (a.RatingCategory = '"& SCRP &"' Or a.RatingCategory = 'None') "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrGroup = rs.getRows()
End If

jsonStr = jsonStr & """soloEvent"": ["
If IsArray(arrSolo) Then
  For i = 0 To Ubound(arrSolo, 2)
    EventIdx        = arrSolo(0, i)
    EventType       = arrSolo(1, i)
    CourseLength    = arrSolo(2, i)
    EventDetailType = arrSolo(3, i)
    MinPlayer       = arrSolo(4, i)
    MaxPlayer       = arrSolo(5, i)
    EventDate       = arrSolo(6, i)
    RatingCategory  = arrSolo(7, i)
    Star            = arrSolo(8, i)
    RatingCategoryText = GetSCRPName(Star, RatingCategory, 0)
    jsonStr = jsonStr & "{""eventIdx"": "& EventIdx &", ""eventType"": """& EventType &""", ""name"": """& EventDetailType &""" "
    jsonStr = jsonStr & " ,""minPlayer"": "& MinPlayer &", ""maxPlayer"": "& MaxPlayer &", ""courseLength"": """& CourseLength &""", ""eventDate"": """& EventDate &""", ""ratingCategory"": """& RatingCategoryText &"""} "
    if i < Ubound(arrSolo, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If
jsonStr = jsonStr & "],"


jsonStr = jsonStr & """groupEvent"": ["
If IsArray(arrGroup) Then
  For i = 0 To Ubound(arrGroup, 2)
    EventIdx        = arrGroup(0, i)
    EventType       = arrGroup(1, i)
    CourseLength    = arrGroup(2, i)
    EventDetailType = arrGroup(3, i)
    MinPlayer       = arrGroup(4, i)
    MaxPlayer       = arrGroup(5, i)
    EventDate       = arrGroup(6, i)
    RatingCategory  = arrGroup(7, i)
    Star            = arrGroup(8, i)
    RatingCategoryText = GetSCRPName(Star, RatingCategory, 0)
    jsonStr = jsonStr & "{""eventIdx"": "& EventIdx &", ""eventType"": """& EventType &""", ""name"": """& EventDetailType &""" "
    jsonStr = jsonStr & " ,""minPlayer"": "& MinPlayer &", ""maxPlayer"": "& MaxPlayer &", ""courseLength"": """& CourseLength &""", ""eventDate"": """& EventDate &""", ""ratingCategory"": """& RatingCategoryText &"""} "
    If i < Ubound(arrGroup, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If
jsonStr = jsonStr & "]"

jsonStr = jsonStr & "}"
' E: 종목전체

jsonStr = jsonStr & "}"
Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
