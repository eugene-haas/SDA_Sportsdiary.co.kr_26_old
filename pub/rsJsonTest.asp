<!-- #include virtual = "/pub/header.RookieTennis.asp" -->


<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<%
Function jsonTors_arr(rs)
	Dim rsObj,subObj, fieldarr, i, arr, mainObj


	Set mainObj = jsObject()

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

		mainObj("main") = rsObj
		mainObj("main2") = rsObj
		mainObj("main3") = rsObj

		jsonTors_arr = toJSON(mainObj)
	Else
		jsonTors_arr = rsObj
	End if
End Function



Function jsonTors(rs)
	Dim rsObj, subObj, fieldarr, arr

	Set rsObj = JSON.Parse("{}")
	Set subObj = JSON.Parse("{}")

	ReDim fieldarr(Rs.Fields.Count-1)
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then
		arr = rs.GetRows()

		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)

				For c = LBound(arr, 1) To UBound(arr, 1)
					Call subObj.Set( fieldarr(c), arr(c, ar) )
				Next

				Call rsObj.Set( ar ,  subObj)
			Next
		End if

		jsonTors = JSON.stringify(rsObj)

	Else
		jsontors = rsObj
	End if

End function
 





		s_date = "2018-12-08"
		sdate = Left(dateAdd("m" , -1, s_date),7) & "-20"
		edate = Left(dateAdd("m" , 1, s_date),7) & "-10"

'Response.write sdate & " " & edate & "<br><br>"




Set db = new clsDBHelper

' appkey = "ZDMQQISOP4X1VON2KCI2H45ODC2JQFPU"
' appsecret = "6KAsLgV1SVCfaaltZuI5X7aJJXVhUkJg"
'
'SQL ="INSERT INTO FingerPush.dbo.TBL_FINGERPUSH_QUEUE(appkey,appsecret,msgtitle,msgcontents,identify,mode,senddate,wdate,udate) values('"&appkey&"','"&appsecret&"','루키테니스제목','루키테니스푸시내용','mujerk', 'STOS',getdate(),getdate(),getdate()) "
'Call db.execSQLRs(SQL , null, ConStr)



'SQL ="SELECT playeridx,username FROM tblplayer "
'SQL ="SELECT top 3 * FROM FingerPush.dbo.TBL_FINGERPUSH_QUEUE "


	SQL = " 			SELECT A.GameTitleIDX as id "
	SQL = SQL & "		,GameTitleName as title, '' as url "
	SQL = SQL & "		,A.EnterType"
	SQL = SQL & "		,cast(B.sdate as date) as start   "
	SQL = SQL & "		,cast(B.edate as date) as [end] "
	SQL = SQL & "	FROM sd_TennisTitle A"
	SQL = SQL & "		inner join("
	SQL = SQL & "			SELECT GameTitleIDX, TeamGb, TeamGbNm, GameDay sdate, GameDay edate"
	SQL = SQL & "			FROM tblRGameLevel "
	SQL = SQL & "			WHERE DelYN = 'N' AND NOT(GameDay = '' OR GameDay is null)"
	SQL = SQL & "			GROUP BY GameTitleIDX, TeamGb, TeamGbNm, GameDay"
	SQL = SQL & "		) B on A.GameTitleIDX = B.GameTitleIDX"
	SQL = SQL & "	WHERE A.DelYN = 'N' "
	SQL = SQL & "		AND viewState = 'Y' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


SQL = "select top 10  gametitleidx,games,gamee,gametitlename from sd_tennistitle"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


arrStr = jsonTors_arr(rs)
Response.write arrStr

Response.ContentType = "application/json"

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsDrow(rs)


'Response.write dateAdd("m" , 1, "2018-10-11")

%>
