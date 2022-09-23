<%
	seq = oJSONoutput.get("SEQ")
	btntypeno = oJSONoutput.get("BTNTYPENO")


	Select Case CDbl(btntypeno)
	Case 1 : 

	Case Else
		Call oJSONoutput.Set("result", "100" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End Select 

	'여러사이트 등록
	session_scode = session("scode")
	if session_scode <> "" then
		sitecode = session_scode
	end if
	'여러사이트 등록

	Set db = new clsDBHelper

	
	'최종이라면 앞단 2댑스 삭제
	'2댑스도 1개라면 1댑스도 삭제
	
	SQL = "select RoleDetailGroup1,RoleDetailGroup2,RoleDetail from tbladminmenulist where AdminMenuListIDX = " & seq
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
	cd1 = rs(0)
	cd2 = rs(1)
	cd3 = rs(2) '사이트 고유

	SQL = "select count(RoleDetail) from tbladminmenulist where  delyn = 'N' and sitecode = '"&sitecode&"' and RoleDetailGroup1= '"&cd1&"' and RoleDetailGroup2 = '"&cd2&"' and RoleDetail <> '' " '3단계 갯수
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
 
	if Cdbl(rs(0)) = 1 then
		
		'2단계갯수
		SQL = "select count(RoleDetail) from tbladminmenulist where delyn = 'N' and sitecode = '"&sitecode&"' and RoleDetailGroup1= '"&cd1&"' and RoleDetailGroup2 <> '' and (RoleDetail = '' or RoleDetail is null )  " '2단계 갯수
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		'2단계삭제
		SQL = "update tbladminmenulist set delyn = 'Y' where delyn = 'N' and sitecode = '"&sitecode&"' and RoleDetailGroup1= '"&cd1&"' and RoleDetailGroup2 = '"&cd2&"' " '2,3단계삭제
		Call db.execSQLRs(SQL , null, B_ConStr)

		if Cdbl(rs(0)) = 1 then
			'1단계삭제
			SQL = "update tbladminmenulist set delyn = 'Y' where delyn = 'N' and sitecode = '"&sitecode&"' and RoleDetailGroup1= '"&cd1&"' " '1,2,3단계삭제
			Call db.execSQLRs(SQL , null, B_ConStr)
		end if

	end if

	'선택항목삭제 3단계
	SQL = "update tbladminmenulist Set DELYN = 'Y' ,modID = '"&Cookies_aID&"' , moddate = getdate()  where AdminMenuListIDX  =  " & seq
	'tblAdminMenuRole 계정에 등록된 정보도 삭제
	SQL = SQL & " update tblAdminMenuRole set delyn = 'Y' where sitecode = '"&sitecode&"' and RoleDetail = '"&cd3&"' "	
	Call db.execSQLRs(SQL , null, B_ConStr)
	
	



	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>