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

	'유저 검색
    top = "top 100" 
 
	strSql = "SELECT " & top & " UserName,PlayerIDX,isnull(UserPhone,'')UserPhone,Birthday,Sex,isnull(Team,'')Team,isnull(TeamNm,'')TeamNm,isnull(Team2,'')Team2,isnull(Team2Nm,'')Team2Nm,userLevel  from tblPlayer where DelYN = 'N' and UserName like '" & uname & "%' " 
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt-1)

	i = 0
    If Not rs.eof Then
	Do Until rs.eof
	Set rsarr = jsObject() 
		rsarr("idx") = rs("PlayerIDX")
		rsarr("name") = rs("UserName") 
		rsarr("phone") =""&left(rs("UserPhone"),3)&"-****-" & Right(rs("UserPhone"),4)
        rsarr("phone1") =""&Replace(rs("UserPhone"),"-","")
		rsarr("tm1c") = rs("Team")
		rsarr("tm1") = rs("TeamNm")
		rsarr("tm2c") = rs("Team2")
		rsarr("tm2") = rs("Team2Nm")
		rsarr("grade") = rs("userLevel")
         
		Set JSONarr(i) = rsarr
	i = i + 1
	rs.movenext
	Loop
    end if 

	Call oJSONoutput.Set("result", "0" )
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)


	db.Dispose
	Set db = Nothing
%>