<!-- #include virtual = "/admin/inc/header.eval.asp" -->
<%

	'###################################
	'복사시 설정이 없을경우 처리
	'###################################


	uid = oJSONoutput.Get("ID")
	upwd = oJSONoutput.Get("PWD")


	Set db = new clsDBHelper

	fieldStr  = " AdminMemberIDX,UserID,UserPass,AdminName,Authority,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,DisplayKey,AssociationIDX,AssociationNM "
	SQL = "select top 1 "&fieldStr&" from tblAdminMember where UserID = '"&uid&"' and delYN = 'N'  and useYN = 'Y' and sitecode = 'EVAL1' and encpass = HASHBYTES('SHA2_512','"&upwd&"') " '사용여부
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


	If rs.eof Then
		Call oJSONoutput.Set("errorcode", "ERR-2000" ) '서버에서 메시지 생성 전달
		Call oJSONoutput.Set("servermsg", "아이디 또는 비밀번호가 잘못 입력 되었습니다. "&vbLf&"아이디와 비밀번호를 정확히 입력해 주세요." ) '서버에서 메시지 생성 전달
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If


	Response.cookies("saveid").expires	= DateAdd("d",-1,now())
	Response.cookies("saveid").domain	= CHKDOMAIN	


	uidx = rs("AdminMemberIDX") 
	uid =  rs("UserID")
	unm = rs("AdminName")
	uauth = rs("Authority")
	displaykey = rs("DisplayKey")
	AssociationIDX = rs("AssociationIDX") 
	AssociationNM = rs("AssociationNM")


	'Response.write unm & "##########"
	'로그인정보
	Set mobj =  JSON.Parse("{}")
	Call mobj.Set("aIDX", uidx )
	Call mobj.Set("aID", uid )
	Call mobj.Set("aNM", unm )	
	Call mobj.Set("aAUTH", uauth )
	Call mobj.Set("aDK", displaykey )
	
	Call mobj.Set("aGrpIDX", AssociationIDX )
	Call mobj.Set("aGrpNM", AssociationNM )	


	strmemberjson = JSON.stringify(mobj)
	strmemberjson = f_enc(strmemberjson)

	Response.Cookies(COOKIENM) = strmemberjson
	Response.Cookies(COOKIENM).domain = CHKDOMAIN
	
	Response.Cookies("EVAL1") = strmemberjson
	Response.Cookies("EVAL1").domain = CHKDOMAIN
	
	Set mobj = Nothing	


	Call oJSONoutput.Set("aIDX", uidx )

	Call oJSONoutput.Set("errorcode", "SUCCESS" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>