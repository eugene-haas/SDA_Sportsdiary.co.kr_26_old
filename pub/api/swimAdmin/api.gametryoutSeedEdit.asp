<%

'#############################################

'예선대진표에서 시드(체크박스)변경 시, 상태 UPDATE

'#############################################
	'request



	idx = oJSONoutput.IDX
	seed = oJSONoutput.SEED

	If seed = true Then
		seed = "Y"
	Else
		seed = "N"
	End If

	Set db = new clsDBHelper

	strTableName = " sd_TennisMember "
	strFieldName = " GameTitleIDX, TeamGb, gamekey3, tryoutgroupno  "
	strWhere = " gameMemberIDX = '" & idx & "'"

	strSql = "SELECT top 1 " & strFieldName
	strSql = strSql &  "  FROM  " & strTableName
	strSql = strSql &  " WHERE " & strWhere
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 


	If Not rs.eof Then
		str_GameTitleIDX = rs("GameTitleIDX")
		str_TeamGb = rs("TeamGb")
		str_gamekey3 = rs("gamekey3")
		str_tryoutgroupno = rs("tryoutgroupno")
	Else
		Response.End
	End If

	updatevalue = " SeedFlag = '" & seed & "'"
	strSql = " Update sd_TennisMember Set  " & updatevalue  
	strSql = strSql & " WHERE GameTitleIDX = '" & str_GameTitleIDX & "'"
	strSql = strSql & " AND TeamGb = '" & str_TeamGb & "'"
	strSql = strSql & " AND gamekey3 = '" & str_gamekey3 & "'"
	strSql = strSql & " AND tryoutgroupno = '" & str_tryoutgroupno & "'"
	strSql = strSql & " AND (gubun = '0' OR gubun = '1')"

	Call db.execSQLRs(strSql , null, ConStr)

  db.Dispose
  Set db = Nothing
%>
