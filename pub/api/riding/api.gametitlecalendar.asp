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



	SQL = "	SELECT A.GameTitleIDX as id " 
	SQL = SQL & "		,GameTitleName as title, '' as url "  
	SQL = SQL & "		, 'S' as EnterType "    
	SQL = SQL & "		,cast(B.sdate as date) as start   "
	SQL = SQL & "		,cast(B.edate as date) as [end], '#E46C0A' as color  ,B.teamGb as teamgb,B.teamGbNm as teamgbnm "
	SQL = SQL & "	FROM sd_RookieTennis.dbo.sd_TennisTitle A"
	SQL = SQL & "		inner join("
	SQL = SQL & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
	SQL = SQL & "			FROM sd_RookieTennis.dbo.tblRGameLevel "
	SQL = SQL & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)   and gameday >= '"&sdate&"' and gameday < '"&edate&"' "		 
	SQL = SQL & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"	
	SQL = SQL & "		) B on A.GameTitleIDX = B.GameTitleIDX"			
	SQL = SQL & "	WHERE A.DelYN = 'N' "  
	SQL = SQL & "	AND viewState = 'Y' " 



	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)





	jsonstr = jsonTors_arr(rs)
	Response.Write CStr(jsonstr)

	db.Dispose
	Set db = Nothing
%>
