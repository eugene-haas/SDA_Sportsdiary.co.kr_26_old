<%
	'###################################
	'복사시 설정이 없을경우 처리
	'###################################

	uid = oJSONoutput.Get("ID")
	upwd = oJSONoutput.Get("PWD")


	Set db = new clsDBHelper

	fieldStr  = " AdminMemberIDX,UserID,UserPass,AdminName,Authority,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,DisplayKey ,AssociationIDX,AssociationNM "
	SQL = "select top 1 "&fieldStr&" from tblAdminMember where UserID = '"&uid&"' and delYN = 'N'  and useYN = 'Y' and sitecode = '"&sitecode&"' and encpass = HASHBYTES('SHA2_512','"&upwd&"') " '사용여부
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


	If rs.eof Then
		Call oJSONoutput.Set("result", "99" ) '로그인 정보틀림
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

	'평가 http://eval.sportsdiary.co.kr/pages/result/total/index.asp
	Response.Cookies("EVAL2") = strmemberjson
	Response.Cookies("EVAL2").domain = CHKDOMAIN

	Set mobj = Nothing	


	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>