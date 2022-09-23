<%


eventYear = oJSONoutput.eventYear
classCode = oJSONoutput.classCode
gameName = oJSONoutput.gameName

Set db = new clsDBHelper

strtable = " k_gameVideoInfo a"
strfield1 = " GameVideoIDX, GameVideo, (select className from tblClassList where classCode = a.classCode) AS className, "
strfield2 = " GameSDate, GameEDate, GameName, GameAgeDistinctText, GameGroupTypeText, "
strfield3 = " GameMember,GameMemberGenderText, GameMatchTypeText, GameOrder "
strfield4 = ", ISNULL(( SELECT DetailType FROM k_detailTypeList b WHERE a.GameDetailTypeIDX = b.idx ),'') detailType, WriteDate "
strwhere = " EventYear = " & eventYear & " AND classCode = '" & classCode & "' AND GameName like '%" & gameName & "%'  AND DelYN = 'N' "
strOrder = " GameEDate DESC "
SQL = " SELECT " & strfield1 & strfield2 & strfield3 & strfield4 &  " FROM " & strtable & " WHERE " & strwhere & " ORDER BY "& strOrder &" "




Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

IF USER_IP = "118.33.86.240" THEN
' 	response.write SQL
' 	response.end
End IF


If Not rs.EOF Then
	arrRS = rs.getrows()
Else
	result = 1
	Call oJSONoutput.Set("result", result )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.Write "`##`"
End If

db.dispose()
Set db = Nothing


%>

<!-- #include virtual="/pub/html/ksports/gameSearchList.asp" -->
