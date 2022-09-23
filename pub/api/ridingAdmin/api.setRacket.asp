<%
'#############################################
'라켓정보저장
'#############################################
	
	If hasown(oJSONoutput, "titleidx") = "ok" then
		titleidx = oJSONoutput.titleidx
	End If
	If hasown(oJSONoutput, "levelno") = "ok" then
		levelno = oJSONoutput.levelno
	End If
	If hasown(oJSONoutput, "playeridx") = "ok" then
		playeridx = oJSONoutput.playeridx
	End If
	If hasown(oJSONoutput, "itemIDX") = "ok" then
		itemIDX = oJSONoutput.itemIDX
	End If

	result = 0	

	If itemIDX <> "" then
		Set db = new clsDBHelper

		'itemSetHistory 테이블에 아이템set 존재 여부확인
		SQL = "SELECT COUNT(playerIDX) AS rsCnt FROM sd_TennisItemSetHistory WHERE playerIDX = '"& playeridx &"' AND GameTitleIDX = '"& titleidx &"' AND levelno = '"& levelno &"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		cnt = rs(0)

		If CDbl(cnt) = 0 Then

			strtable = " sd_TennisItemSetHistory "
			strwhere = "   GameTitleIDX = " & titleidx & " AND playerIDX = " & playeridx & " AND levelno = " & levelno & " "
			strsort = " "
			insertfiled = " ( " & titleidx & ", " & playeridx & ", " & levelno & ", " & itemIDX & ", (SELECT itemName FROM sd_tennisItem WHERE itemIDX = " & itemIDX & " ), GETDATE() ) "
			SQL2 = "INSERT INTO "& strtable & " VALUES " & insertfiled

'Response.write sql2
'Response.end
'			
			Set rs2 = db.ExecSQLReturnRS(SQL2 , null, ConStr)

			db.dispose
			Set rs2 = nothing

		ElseIf cnt = 1 Then  
			strtable = " sd_TennisItemSetHistory "
			strwhere = "   GameTitleIDX = " & titleidx & " AND playerIDX = " & playeridx & " AND levelno = " & levelno & " "
			strsort = " "
			strfield = " item1IDX = " & itemIDX & ", item1Name = (SELECT itemName FROM sd_tennisItem WHERE itemIDX = " & itemIDX & "), WriteDate = GETDATE()  "
			SQL2 = "UPDATE "& strtable & " SET " & strfield & " where " & strwhere 
			Set rs2 = db.ExecSQLReturnRS(SQL2 , null, ConStr)
			
			db.dispose
			Set rs2 = nothing
			
		Else
			result = 100

		End If 

		strtable = " sd_TennisItemSetHistory "
		strwhere = "   GameTitleIDX = " & titleidx & " AND playerIDX = " & playeridx & " AND levelno = " & levelno & " "
		strsort = " "
		strfield = " item1Name "
		SQL3 = "SELECT "& strfield & " FROM " & strtable & " where " & strwhere
		Set rs3 = db.ExecSQLReturnRS(SQL3 , null, ConStr)
		
		racketName = rs3(0)
		db.dispose
		Set rs3 = Nothing
	
	Else 
		racketName = ""

	End If


	
	Call oJSONoutput.Set("result", result )
	Call oJSONoutput.Set("racketName", racketName )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson



%>