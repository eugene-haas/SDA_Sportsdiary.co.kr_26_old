<%

    
	Set db = new clsDBHelper
'	strSql = "WITH CalendarList(GameTitleIDX,TrainStart,TrainEnd,TraingTitle,url,EnterType) AS ( "
'	strSql = strSql &  "	Select TI.GameTitleIDX "
'	strSql = strSql &  "Convert(varchar(10),TI.GameS,121) as TrainStart, "
'	strSql = strSql &  "Convert(varchar(10),DATEADD(DD,1,TI.GameE),121) as TrainEnd, "
'	strSql = strSql &  "IsNull(TI.GameTitleName,'') as TraingTitle, "
'	strSql = strSql &  "'' as url, "
'	strSql = strSql &  "EnterType "                    
'	strSql = strSql &  "From tblGameTitle TI "
'	strSql = strSql &  "Where TI.SportsGb='judo' and TI.DelYN='N' "
'	strSql = strSql &  ") "
'	strSql = strSql &  "SELECT * FROM CalendarList "
'Response.write strSQL
'Response.end

	strSql = " 			SELECT A.GameTitleIDX" 
	strSql = strSql & "		,GameTitleName"  
	strSql = strSql & "		,A.EnterType"    
	strSql = strSql & "		,cast(B.sdate as date) as sdate   "
	strSql = strSql & "		,cast(B.edate as date) as edate"
	strSql = strSql & "	FROM sd_TennisTitle A"
	strSql = strSql & "		inner join("
	strSql = strSql & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
	strSql = strSql & "			FROM [SD_Tennis].[dbo].[tblRGameLevel]"
	strSql = strSql & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)"		 
	strSql = strSql & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"	
	strSql = strSql & "		) B on A.GameTitleIDX = B.GameTitleIDX"			
	strSql = strSql & "	WHERE A.DelYN = 'N'"  
	strSql = strSql & "		AND viewState = 'Y'" 
	  

    if cmd = 25 then 
        strSql =  strSql & " AND A.GameTitleIDX not in (21,24,25,26)"
    end if 


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