<%
'######################
' 대회정보 등록
'######################

If hasown(oJSONoutput, "classCode") = "ok" then
    classCode = oJSONoutput.classCode
Else
    Call oJSONoutput.Set("result", "4" ) '종목코드 없음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.end
End If


eventYear = oJSONoutput.eventYear

If hasown(oJSONoutput, "gameCode") = "ok" then
    gameCode = oJSONoutput.gameCode
Else
    Call oJSONoutput.Set("result", "3" ) '대회코드 없음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.end
End If

gameSDate = oJSONoutput.gameSDate
gameEDate = oJSONoutput.gameEDate
gameName = oJSONoutput.gameName
gameVideo = oJSONoutput.gameVideo
gameAgeDistinct = oJSONoutput.gameAgeDistinct
gameAgeDistinctText = oJSONoutput.gameAgeDistinctText
gameGroupType = oJSONoutput.gameGroupType
gameGroupTypeText = oJSONoutput.gameGroupTypeText
gameMatchType = oJSONoutput.gameMatchType
gameMatchTypeText = oJSONoutput.gameMatchTypeText
gameOrder = oJSONoutput.gameOrder
gameMember = oJSONoutput.gameMember
gameMemberGender = oJSONoutput.gameMemberGender
gameMemberGenderText = oJSONoutput.gameMemberGenderText
detailType = oJSONoutput.detailType
gameFileName = oJSONoutput.gameFileName


Set db = new clsDBHelper

strtable = " k_gameFileName "
insertfiled = " (GameVideo, FileName) "
insertvalue = " ('"& gameVideo &"', '"& gameFileName &"' ) "
SQL = "INSERT INTO "& strtable & insertfiled & " VALUES " & insertvalue
Call db.ExecSQLRS(SQL, null, ConStr)

strtable = " K_gameVideoInfo "
insertfiled = " ( ClassCode, EventYear, GameCode, GameSDate, GameEDate, GameName, GameVideo, GameAgeDistinct, GameAgeDistinctText, GameGroupType, GameGroupTypeText, GameMatchType, GameMatchTypeText, GameOrder, GameMember, GameMemberGender, GameMemberGenderText, GameDetailTypeIDX ,WriteDate, DelYN ) "
insertvalue = " ( '" & classCode & "', '" & eventYear & "', '" & gameCode & "', '" & gameSDate & "', '" & gameEDate & "', '" & gameName & "', '" & gameVideo & "', '" & gameAgeDistinct & "', '" & gameAgeDistinctText & "', '" & gameGroupType & "', '" & gameGroupTypeText & "','" & gameMatchType & "', '" & gameMatchTypeText & "','" & gameOrder & "', '" & gameMember & "', '" & gameMemberGender & "', '" & gameMemberGenderText & "', '" & detailType & "',  getdate(), 'N' ) "
SQL = "SET NOCOUNT ON INSERT INTO "& strtable & insertfiled & " VALUES " & insertvalue & " SELECT @@IDENTITY"

Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
gameVideoIDX = rs(0)


strtable = " K_gameVideoInfo a LEFT JOIN k_gameFileName b ON a.GameVideo = b.GameVideo "
strwhere = " gameVideoIDX= " & gameVideoIDX
strfield = "(select ClassName from tblClassList Where ClassCode = a.ClassCode) AS ClassName, "
strfield = strfield & " GameAgeDistinctText As GameAgeDistinct, "
strfield = strfield & " GameGroupTypeText As GameGroupType, "
strfield = strfield & " GameMatchTypeText As GameMatchType, "
strfield = strfield & " GameMemberGenderText AS GameMemberGender, "
strfield = strfield & " EventYear, GameCode, GameSDate, GameEDate, GameName, a.GameVideo, GameOrder, GameMember, "
strfield = strfield & " ( select DetailType from k_detailtypeList where idx = a.GameDetailTypeIDX ) AS DetailType, "
strfield = strfield & " b.FileName AS GameFileName "
SQL2 = " SELECT " & strfield & " FROM " & strtable & " WHERE " & strwhere

rs2 = db.ExecSQLReturnRS(SQL2, null, ConStr)


rsClassName = rs2("ClassName")
rsGameSDate = rs2("GameSDate")
rsGameEDate = rs2("GameEDate")
rsGameName = rs2("GameName")
rsGameAgeDistinct = rs2("GameAgeDistinct")
rsGameGroupType = rs2("GameGroupType")
rsGameMatchType = rs2("GameMatchType")
rsGameOrder = rs2("GameOrder")
rsGameMember = rs2("GameMember")
rsGameMemberGender = rs2("GameMemberGender")
rsGameVideo = rs2("GameVideo")
rsDetailType = rs2("DetailType")
rsGameFileName = rs2("GameFileName")

db.dispose

Set db = Nothing

result = 0

Call oJSONoutput.Set("result", result )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.Write "`##`"

%>
<!-- #include virtual = "/pub/html/ksports/gamelist.asp" -->
