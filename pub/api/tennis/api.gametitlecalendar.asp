<%
	Set db = new clsDBHelper

	strSql = " 			SELECT A.GameTitleIDX" 
	strSql = strSql & "		,GameTitleName"  
	strSql = strSql & "		,A.EnterType"    
	strSql = strSql & "		,cast(B.sdate as date) as sdate "
	strSql = strSql & "		,cast(B.edate as date) as edate "
	strSql = strSql & "	FROM sd_TennisTitle A"
	strSql = strSql & "		inner join("
	strSql = strSql & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
	strSql = strSql & "			FROM [SD_Tennis].[dbo].[tblRGameLevel]"
	strSql = strSql & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)"		 
	strSql = strSql & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"	
	strSql = strSql & "		) B on A.GameTitleIDX = B.GameTitleIDX"			
	strSql = strSql & "	WHERE A.DelYN = 'N'"  
	strSql = strSql & "		AND viewState = 'Y'" 	
	
	
'	strSql = " select GameTitleIDX , GameTitleName " & _
'            " , cast(GameS as date) as sdate " & _
'            " , cast(dateadd(day,1,GameE) as date) as edate " & _
'            " , EnterType   " & _
'            " from sd_TennisTitle  " & _
'            " where DelYN = 'N' " & _
'            " and viewState = 'Y'"  

'    if cmd = 25 then 
'        strSql =  strSql & " and GameTitleIDX not in (21,24,26) "
'    end if 


	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount

	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 

		rsarr("id") = rs("GameTitleIDX")
		title = Trim(rs("GameTitleName"))
		If InStr(title," ") > 0 Then
			titlearr = Split(title, " " )
			rsarr("title") = titlearr(1)
		Else
			rsarr("title") = title
		End if

		rsarr("url") = ""
		rsarr("start") = rs("sdate")
		rsarr("end") = rs("edate")
		rsarr("EnterType") = rs("EnterType") 
		Set JSONarr(i) = rsarr
		
		
		
		
		
'		rsarr("id") = rs("GameTitleIDX")
'		rsarr("title") = rs("GameTitleName")
'		rsarr("url") = ""
'		rsarr("start") = rs("sdate")
'		rsarr("end") = rs("edate")
'		rsarr("EnterType") = rs("EnterType") 

		Set JSONarr(i) = rsarr

	i = i + 1
	rs.movenext
	Loop
	datalen = Ubound(JSONarr) - 1

	jsonstr = toJSON(JSONarr)

	
	'response.ContentType="text/plain"	
	Response.Write CStr(jsonstr)

	db.Dispose
	Set db = Nothing
%>