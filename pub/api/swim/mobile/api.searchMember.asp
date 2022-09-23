<%
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		uname = oJSONoutput.SVAL
		uname = Replace(uname, " " , "") '공백제거
	End If
	
	If stateRegExp(uname ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
		Call oJSONoutput.Set("result", "10" ) '사용하면 안되는 문자발생
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	tidx = oJSONoutput.tidx
	levelno =  oJSONoutput.levelno


	Set db = new clsDBHelper

	Dim arrFieldNm(100) '100개이상 필드 생성할일 없겠지 ㅡㅡ


	mfield = " m.MemberIDX as midx,m.UserName as name,m.UserPhone as phone1,m.Birthday,m.Sex "
	pfield = " ,a.MemberIDX,a.PlayerIDX as idx,isnull(a.Team,'')tm1c,isnull(a.TeamNm,'')tm1,isnull(a.Team2,'')tm2c,isnull(a.Team2Nm,'')tm2,a.userLevel as grade, '' ReIDX1,'' ReIDX2 , a.sidogu,a.gamestartyymm,    a.stateNo,a.lastorder,a.sdpoint  "


	SQL = "select top 100 " & mfield & pfield & " from SD_Member.dbo.tblMember as m "
	SQL = SQL &" left join SD_RookieTennis.dbo.tblPlayer a On m.memberIDX = a.memberIDX and a.DelYN = 'N' and (a.TeamGB = '' or a.TeamGB = '"&Left(levelno,5)&"')   " '같은 스타
	SQL = SQL &" left join tblGameRequest b on a.PlayerIDX = b.P1_PlayerIDX and b.GameTitleIDX='"&tidx&"' and b.Level='"&levelno&"' and b.DelYN='N'   "
	SQL = SQL &" left join tblGameRequest c on a.PlayerIDX = c.P2_PlayerIDX and c.GameTitleIDX='"&tidx&"' and c.Level='"&levelno&"' and c.DelYN='N'   "
	SQL = SQL &" where m.delYN = 'N'  and m.userName like '"&uname&"%' " 




	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	For n = 0 To Rs.Fields.Count - 1
		arrFieldNm(n+ i) = Rs.Fields(n).name
	Next

	If Not rs.EOF Then 
		arr = rs.GetRows()
	End If

'	Call getRowsDrow(arr)


	If IsArray(arr) Then
		ReDim JSONarr(UBound(arr, 2)+1)

		For ar = LBound(arr, 2) To UBound(arr, 2) 
		Set rsarr = jsObject() 
			
			For c = LBound(arr, 1) To UBound(arr, 1) 
			Select Case arrFieldNm(c)
			Case "phone1" 
				rsarr(arrFieldNm(c)) =  Replace(arr(c, ar),"-","")
				If arr(c, ar) = "" Then
					rsarr("phone") =""
					UserPhone=""
				else
					rsarr("phone") =""&left(arr(c, ar),3)&"-****-" & Right(arr(c, ar),4)
					UserPhone=""&left(arr(c, ar),3)&"-****-" & Right(arr(c, ar),4)
				end if 

				if  Len(UserPhone)<=10 then 
					UserPhone=""
				else
					UserPhone="("&UserPhone&")"
				end if  
				
			Case "name"  
				rsarr(arrFieldNm(c)) =  arr(c, ar)
				username =  arr(c, ar)

			Case "Birthday" : rsarr(arrFieldNm(c)) =  Left(arr(c, ar),4) & "**"
			Case "Sex" : rsarr(arrFieldNm(c)) =  strSex(arr(c, ar))

			Case "MemberIDX" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "PlayerIDX" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "sidogu" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "gamestartyymm" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case Else 
				rsarr(arrFieldNm(c)) =  arr(c, ar)
			End Select
			Next
			rsarr("label") = username & UserPhone 
	
		Set JSONarr(ar) = rsarr
		Next
	else
		ReDim JSONarr(1)
	End if

	Set rsarr = jsObject() 
	rsarr("idx") = 0
	rsarr("midx") = 0
	rsarr("name") = ""
	Set JSONarr(ar) = rsarr


	Call oJSONoutput.Set("result", "0" )
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)


	db.Dispose
	Set db = Nothing
%>