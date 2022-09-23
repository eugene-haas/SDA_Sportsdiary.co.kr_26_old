<%
'######################
' 대회정보 등록
'######################

idx = oJSONoutput.IDX
classCode = oJSONoutput.classCode
className = oJSONoutput.className
eventYear = oJSONoutput.eventYear
gameCode = oJSONoutput.gameCode
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

	tablename = " K_gamevideoInfo "
	updatevalue = " ClassCode='" & classCode & "', EventYear=" & eventYear & ", GameCode='" & gameCode & "', GameSDate='" & gameSDate & "', GameEDate='" & gameEDate & "', GameName='" & gameName & "', GameVideo='" & gameVideo & "', GameAgeDistinct='" & gameAgeDistinct & "', "
	updatevalue = updatevalue & " GameAgeDistinctText='" & gameAgeDistinctText & "', GameGroupType='" & gameGroupType & "', GamegroupTypeText='" & gamegroupTypeText & "', GameMatchType='" & gameMatchType & "', GameMatchTypeText='" & gameMatchTypeText & "', "
	updatevalue = updatevalue & "  GameOrder='" & gameOrder & "', GameMember='" & gameMember & "', GameMemberGender='" & gameMemberGender & "', GameMemberGenderText='" & gameMemberGenderText & "', WriteDate= getdate(), GameDetailTypeIDX= '"& detailType &"' "
	SQL = " Update  "&tablename&" Set  " & updatevalue & " where GameVideoIDX= " & idx
	Call db.execSQLRs(SQL , null, ConStr)

  SQL2 = " UPDATE k_gameFileName SET FileName = '"& gameFileName &"' WHERE GameVideo = '"& gameVideo &"'  "
  Call db.execSQLRs(SQL2 , null, ConStr)

	'세부종별 가져오기
	If detailType <> "" Then
	SQL = " SELECT detailType from k_detailTypeList WHERE idx = "&detailType&" "
	set rs = db.ExecSQLReturnRS(SQL, nul, ConStr)
	rsDetailType = rs("detailType")
	End IF

gameVideoIDX = idx
rsEventYear = eventYear
rsClassCode = classCode
rsGameName = gameName
rsGameCode = gameCode
rsClassName = className
rsGameSDate = gameSDate
rsGameEDate = gameEDate
rsGameAgeDistinct = gameAgeDistinctText
rsGameGroupType = gameGroupTypeText
rsGameMatchType = gameMatchTypeText
rsGameMemberGender = gameMemberGenderText
rsGameOrder = gameOrder
rsGameMember = gameMember
rsGameVideo = gameVideo


db.Dispose
Set rs = Nothing

%>
<!-- #include virtual = "/pub/html/ksports/gamelist.asp" -->
