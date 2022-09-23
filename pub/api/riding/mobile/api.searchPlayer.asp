<%
	'request
	uname = oJSONoutput.SVAL
	If stateRegExp(uname ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
		Call oJSONoutput.Set("result", "10" ) '사용하면 안되는 문자발생
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	uname = Replace(uname, " " , "") '공백제거

	tidx = oJSONoutput.tidx
	levelno =  oJSONoutput.levelno

	Set db = new clsDBHelper

	strSql="select TeamGb,TeamGbNm from tblRGameLevel where SportsGb='tennis' and GameTitleIDX ='"&tidx&"'  and Level ='"&levelno&"' and DelYN='N' group by TeamGb,TeamGbNm"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr) 
	TeamGb=rs("TeamGb")
	TeamGbNm=rs("TeamGbNm")


	'참가 신청하지 않은 유저 중에 검색작업할것
    top = "top 10" 
 
	strSql = "SELECT " & top & "  a.UserName,a.PlayerIDX,isnull(a.UserPhone,'')UserPhone,a.Birthday,a.Sex,isnull(a.Team,'')Team,isnull(a.TeamNm,'')TeamNm,isnull(a.Team2,'')Team2,isnull(a.Team2Nm,'')Team2Nm,a.userLevel ,a.belongBoo "
    if tidx<> "" and levelno<>"" then 
        strSql = strSql &" ,isnull(b.RequestIDX,'') ReIDX1,isnull(c.RequestIDX,'') ReIDX2 "
    else
        strSql = strSql &" ,'' ReIDX1,'' ReIDX2 "
    end if 
    strSql = strSql &" from tblPlayer a "
    if tidx<> "" and levelno<>"" then 
        strSql = strSql &" left join tblGameRequest b on a.PlayerIDX = b.P1_PlayerIDX and b.GameTitleIDX='"&tidx&"' and b.Level='"&levelno&"' and b.DelYN='N'  and b.SportsGb='tennis' "
        strSql = strSql &" left join tblGameRequest c on a.PlayerIDX = c.P2_PlayerIDX and c.GameTitleIDX='"&tidx&"' and c.Level='"&levelno&"' and c.DelYN='N'  and c.SportsGb='tennis' "
    end if
    strSql = strSql &"   where a.DelYN = 'N' and a.SportsGb='tennis' and a.UserName like '" & uname & "%'  order by len(a.UserName) asc "  
 ' and belongBoo like '%"&TeamGbNm&"%'
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt)

	
'	strSql =  strSql &" and PlayerIDX not in (Select P1_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & tidx & " And Level = " & levelno & " And P1_PlayerIDX is not null " 
'	strSql = strSql &" UNION Select P2_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & tidx & " And Level = " & levelno & " and P2_PlayerIDX is not null) "

	i = 0
    If Not rs.eof Then
		Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("idx") = rs("PlayerIDX")
			rsarr("name") = rs("UserName")
            rsarr("phone1") =""&Replace(rs("UserPhone"),"-","")
			rsarr("tm1c") = rs("Team")
			rsarr("tm1") = rs("TeamNm")
			rsarr("tm2c") = rs("Team2")
			rsarr("tm2") = rs("Team2Nm")
			rsarr("grade") = rs("userLevel")
			rsarr("ReIDX1") = rs("ReIDX1")
			rsarr("ReIDX2") = rs("ReIDX2")
			rsarr("belongBoo") = rs("belongBoo")
            if rs("UserPhone") ="" then 
                rsarr("phone") =""
				UserPhone=""
            else
                rsarr("phone") =""&left(rs("UserPhone"),3)&"-****-" & Right(rs("UserPhone"),4)
				UserPhone=""&left(rs("UserPhone"),3)&"-****-" & Right(rs("UserPhone"),4)
            end if 
            
			if  Len(UserPhone)<=10 then 
				UserPhone=""
			else
				UserPhone="("&UserPhone&")"
			end if  
				
			'#########
				teamTitle=""
				team1 = rs("TeamNm")
				team2 = rs("Team2Nm")
				IF Len(team1) > 0 Then
						teamTitle = "(" & team1
				END IF

				IF LEN(team2) > 0 Then
						IF Len(team1) = 0 Then
								teamTitle = "(" & team2
						Else
								teamTitle = teamTitle & "," & team2
						END IF
				END IF
				
				IF LEN(teamTitle) > 0 Then
						teamTitle = teamTitle & ")"
				END If
				rsarr("teamTitle") = teamTitle

				label = rs("UserName") & UserPhone & teamTitle
			'#########


			rsarr("label") = label 

			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
    end if 

	Set rsarr = jsObject() 
	rsarr("idx") = 0
	rsarr("name") = "신규등록"
	Set JSONarr(i) = rsarr


	Call oJSONoutput.Set("result", "0" )
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)


	db.Dispose
	Set db = Nothing
%>