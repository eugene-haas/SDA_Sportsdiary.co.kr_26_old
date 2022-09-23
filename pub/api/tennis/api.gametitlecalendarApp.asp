<%
'#########################
'받는 URL
'http://tennis.sportsdiary.co.kr/pub/ajax/reqTennis.asp?REQ=25&typeSq=app&start=2018-11-25&end=2019-01-06&_=1547600799144
'CMD 25
'#########################

	sdate = request("start")
	edate = request("end")
	gp = request("gp") ' 공백 K S


	If edate = "" Then
		s_date = sdate
		sdate = Left(dateAdd("m" , -1, s_date),7) & "-20"
		edate = Left(dateAdd("m" , 1, s_date),7) & "-10"
	End if


	'If hasown(oJSONoutput, "gp") = "ok" then
	'	gp = oJSONoutput.gp ' 0전체 1 kata 2 sd 랭킹전
	'End if


	'#########################
	Function jsonTors_arr(rs)
		Dim rsObj,subObj, fieldarr

		ReDim rsObj(rs.RecordCount - 1)
		ReDim fieldarr(Rs.Fields.Count-1)
		For i = 0 To Rs.Fields.Count - 1
			fieldarr(i) = Rs.Fields(i).name
		Next

		If Not rs.EOF Then 
			arr = rs.GetRows()

			If IsArray(arr) Then
				For ar = LBound(arr, 2) To UBound(arr, 2) 

					Set subObj = jsObject() 
					For c = LBound(arr, 1) To UBound(arr, 1) 
						subObj(fieldarr(c)) = arr(c, ar)
					Next
					Set rsObj(ar) = subObj
				Next
			End if

			jsonTors_arr = toJSON(rsObj)
		Else
			jsonTors_arr = toJSON(rsObj)
		End if
	End Function
	'#########################

    
	Set db = new clsDBHelper

If gp = "" Or gp = "K" then
	SQL = " 			SELECT A.GameTitleIDX as id " 
	SQL = SQL & "		,GameTitleName as title, '' as url "  
	SQL = SQL & "		, 'K' as EnterType "    
	SQL = SQL & "		,cast(B.sdate as date) as start   "
	SQL = SQL & "		,cast(B.edate as date) as [end] , '#3A87AD' as color  ,B.teamGb as teamgb,B.teamGbNm as teamgbnm  "
	SQL = SQL & "	FROM sd_TennisTitle A"
	SQL = SQL & "		inner join("
	SQL = SQL & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
	SQL = SQL & "			FROM tblRGameLevel "
	SQL = SQL & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)   and gameday >= '"&sdate&"' and gameday < '"&edate&"' "		 
	SQL = SQL & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"	
	SQL = SQL & "		) B on A.GameTitleIDX = B.GameTitleIDX"			
	SQL = SQL & "	WHERE A.DelYN = 'N' "  
	SQL = SQL & "		AND viewState = 'Y' " 
End if



'루키테니스 삭제
'If gp= "" Or gp = "S" Then
'	If gp = "" then
'	SQL = SQL & "	union "
'	End if
'
'	SQL = SQL & "	SELECT A.GameTitleIDX as id " 
'	SQL = SQL & "		,GameTitleName as title, '' as url "  
'	SQL = SQL & "		, 'S' as EnterType "    
'	SQL = SQL & "		,cast(B.sdate as date) as start   "
'	SQL = SQL & "		,cast(B.edate as date) as [end], '#E46C0A' as color  ,B.teamGb as teamgb,B.teamGbNm as teamgbnm "
'	SQL = SQL & "	FROM sd_RookieTennis.dbo.sd_TennisTitle A"
'	SQL = SQL & "		inner join("
'	SQL = SQL & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
'	SQL = SQL & "			FROM sd_RookieTennis.dbo.tblRGameLevel "
'	SQL = SQL & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)   and gameday >= '"&sdate&"' and gameday < '"&edate&"' "		 
'	SQL = SQL & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"	
'	SQL = SQL & "		) B on A.GameTitleIDX = B.GameTitleIDX"			
'	SQL = SQL & "	WHERE A.DelYN = 'N' "  
'	SQL = SQL & "	AND viewState = 'Y' " 
'End if


'    if cmd = 25 then 
'        strSql =  strSql & " AND A.GameTitleIDX not in (21,24,25,26)"
'    end if 

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


If request("test") = "t" Then

	  Response.write sql & "<br><br>"
		'	  Response.end
End if



	jsonstr = jsonTors_arr(rs)

'#############################
	'	rscnt =  rs.RecordCount
	'
	'	ReDim JSONarr(rscnt-1)
	'
	'	i = 0
	'	Do Until rs.eof
	'	Set rsarr = jsObject() 
	'		rsarr("id") = rs("id")
	'		title = Trim(rs("title"))
	'		If InStr(title," ") > 0 Then
	'			titlearr = Split(title, " " )
	'			rsarr("title") = titlearr(1)
	'		Else
	'			rsarr("title") = title
	'		End if
	'
	'		rsarr("url") = ""
	'		rsarr("start") = rs("start")
	'		rsarr("end") = rs("end")
	'		rsarr("EnterType") = rs("EnterType") 
	'		Set JSONarr(i) = rsarr
	'
	'	i = i + 1
	'	rs.movenext
	'	Loop
	'	datalen = Ubound(JSONarr) - 1
	'
	'	jsonstr = toJSON(JSONarr)
'#############################


	
	'response.ContentType="text/plain"	
	Response.Write CStr(jsonstr)

	db.Dispose
	Set db = Nothing


'SELECT A.GameTitleIDX as id ,GameTitleName as title, '' as url ,A.EnterType	,cast(B.sdate as date) as start ,cast(B.edate as date) as [end] FROM sd_TennisTitle A	inner join(	SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate	FROM tblRGameLevel WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null) and sdate >= ''2018-11-01' and edate < '2018-12-01' GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay	) B on A.GameTitleIDX = B.GameTitleIDX	WHERE A.DelYN = 'N' AND viewState = 'Y'
%>
