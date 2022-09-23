<%
	Function mergeTable(ByRef arrA, ByRef arrB, ByVal Afieldcnt, ByVal Bfieldcnt)
		Dim ar, c, par, keyA, keyB, fieldno
		Dim arrNew()
		'크기지정 (중복필드 0번필드에 불러와야함)
		
		If IsArray(arrA) Then
			ReDim arrNew( Afieldcnt + Bfieldcnt +1 , UBound(arrA, 2) )

			'새로운 배열에 A 복원
			If IsArray(arrA) Then
				For ar = 0 To UBound(arrA, 2) 
					For c = 0 To UBound(arrA, 1)
						arrNew(c , ar) = arrA(c, ar) 'A값 복원
					next
				Next
			End if

			If IsArray(arrNew) Then
				For ar = LBound(arrNew, 2) To UBound(arrNew, 2) 
					keyA = arrNew(0, ar)

						If IsArray(arrB) Then
							For par = LBound(arrB, 2) To UBound(arrB, 2) 
								keyB = arrB(0, par)
								If Cstr(keyA) = Cstr(keyB) Then
									For c = LBound(arrB, 1) To UBound(arrB, 1) 
										fieldno = UBound(arrA, 1) + 1 + c
										arrNew( fieldno ,ar) = arrB(c, par) 
									Next 
									Exit for
								End If
							Next
						End if	
				Next
			End if	
			'Call getRowsDrow(arrNew)
			mergeTable = arrNew
		Else
			mergeTable = ""
		End if
	End function


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


	'참가 신청하지 않은 유저 중에 검색작업할것 ( 부서에 따라서 성별구분할 것)
	If levelno <> "" Then
		if  Left(levelno,5) = "20101" or Left(levelno,5) = "20102" then '여자부
			sexwherestr = " and m.Sex = 'Woman' "
		Else
			sexwherestr = " and m.Sex = 'Man' "
		End if
	End if


	'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
	'투스타 3회우승자 박탈
	SQL = "update tblPlayer Set stateNo = 201 where dblrnk = 'Y' and stateNo = 200 and levelup  <  "&year(date) &"  " '승급자 지위 초기화
	Call db.execSQLRs(SQL , null, ConStr) 


	mfield = " m.MemberIDX as midx,m.UserName as name,m.UserPhone as phone1,m.Birthday,m.Sex,m.userid "
	pfield = " ,a.MemberIDX,a.PlayerIDX as idx,isnull(a.Team,'')tm1c,isnull(a.TeamNm,'')tm1,isnull(a.Team2,'')tm2c,isnull(a.Team2Nm,'')tm2,a.userLevel as grade, '' ReIDX1,'' ReIDX2 , a.sidogu,a.gamestartyymm,    a.stateNo,a.lastorder,a.sdpoint  "

	'제외조건 (카타회원 제거)
	notinquery  = " and m.username + replace(m.userphone,'-','') not in (select username + userphone from SD_Tennis.dbo.tblPlayer) " '카타 플레이어 제외
	'notinquery  = " and m.username + replace(m.userphone,'-','') EXISTS (select username + userphone from SD_Tennis.dbo.tblPlayer) " '카타 플레이어 제외

	'1등 2회이상만 포인트 파트너와 페어불가
	If CDbl(Cookies_firstcnt) > 1 Then '제외조건 (1등 2회인경우 파트너 제약조건)
		notinquery2  ="  and m.MemberIDX not in ( select MemberIDX from SD_RookieTennis.dbo.tblPlayer where  DelYN = 'Y'  or stateNo in ( '1' , '101')  or sdpoint > 0 ) "  '포인트가 있는회원
	Else '박탈회원 삭제 선수 제거
		notinquery2  =" and m.MemberIDX not in ( select MemberIDX from SD_RookieTennis.dbo.tblPlayer where  DelYN = 'Y'  or stateNo in ( '1' , '101') ) " '박탈회원제거
	End if

	SQL = "select top 10 " & mfield & pfield & " from SD_Member.dbo.tblMember as m "
	SQL = SQL &" left join SD_RookieTennis.dbo.tblPlayer a On m.memberIDX = a.memberIDX and a.DelYN = 'N' and (a.TeamGB = '' or a.TeamGB = '"&Left(levelno,5)&"')   " '같은 스타
	SQL = SQL &" left join tblGameRequest b on a.PlayerIDX = b.P1_PlayerIDX and b.GameTitleIDX='"&tidx&"' and b.Level='"&levelno&"' and b.DelYN='N'   "
	SQL = SQL &" left join tblGameRequest c on a.PlayerIDX = c.P2_PlayerIDX and c.GameTitleIDX='"&tidx&"' and c.Level='"&levelno&"' and c.DelYN='N'   "
	SQL = SQL &" where m.delYN = 'N'  and m.userName like '"&uname&"%' " & sexwherestr & notinquery & notinquery2


'Response.write sql
	
'	'순위자라면 ...1 ,2 3
'	If CDbl(Cookies_lastorder) > 0 Then
'		SQL = SQL &"  a.lastorder  = '0' "
'	End if



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

			Case "userid" 
			rsarr(arrFieldNm(c)) =  arr(c, ar)
			userid = arr(c, ar)
			Case "MemberIDX" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "PlayerIDX" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "sidogu" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case "gamestartyymm" : rsarr(arrFieldNm(c)) =  arr(c, ar)
			Case Else 
				rsarr(arrFieldNm(c)) =  arr(c, ar)
			End Select
			Next
			rsarr("label") = username & " : " &  Left(userid,Len(userid) - 2) & "**"   'UserPhone 
	
		Set JSONarr(ar) = rsarr
		Next
	else
		ReDim JSONarr(1)
	End if

	Set rsarr = jsObject() 
'	rsarr("idx") = 0
'	rsarr("midx") = 0
'	rsarr("name") = ""
	Set JSONarr(ar) = rsarr


	Call oJSONoutput.Set("result", "0" )
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)


	db.Dispose
	Set db = Nothing
%>