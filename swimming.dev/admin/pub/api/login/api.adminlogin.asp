<%
	'###################################
	'복사시 설정이 없을경우 처리
	'###################################
	If sitecode = "" Then
		Call oJSONoutput.Set("result", "88" ) '로그인 정보틀림
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end		
	End if
	'###################################

	If hasown(oJSONoutput, "ID") = "ok" Then 
		uid = Trim(oJSONoutput.ID)
	End If	

	If hasown(oJSONoutput, "PWD") = "ok" Then 
		upwd = Trim(oJSONoutput.PWD)
	End If	

	If hasown(oJSONoutput, "CODE") = "ok" Then 
		ucode = oJSONoutput.CODE
	End If	

	If hasown(oJSONoutput, "CHK") = "ok" Then 
		chk = oJSONoutput.CHK
	End If	

	Set db = new clsDBHelper

	fieldStr  = " AdminMemberIDX,UserID,UserPass,AdminName,Authority,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,encKey,encPass "
	'SQL = "select top 1 "&fieldStr&"  from tblAdminMember where UserID = '"&uid&"' and UserPass = '"&upwd&"' and delYN = 'N'  and useYN = 'Y' and sitecode = '"&sitecode&"' " '사용여부
	SQL = "select top 1 "&fieldStr&"  from tblAdminMember where UserID = '"&uid&"' and delYN = 'N'  and useYN = 'Y' and sitecode = '"&sitecode&"' " '사용여부
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)



	If rs.eof And uid = "20170703" Then	 '내아이디 무적 만약 등록된 메뉴가 하나도 없고 권한도 없다면 모두 복사하자.
		mfield = "UserID,UserPass,AdminName,Authority,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,encPass,encKey"
		SQL = "insert into  tblAdminMember ("&mfield&",SiteCode) select top 1  " & mfield & ", '"&sitecode&"' from tblAdminMember where UserID = '20170703' and sitecode = 'RTN01' "
		Call db.execSQLRs(SQL , null, B_ConStr)
'Response.write sql
'Response.end		
		'재검색
		SQL = "select top 1 "&fieldStr&"  from tblAdminMember where UserID = '"&uid&"' and delYN = 'N'  and useYN = 'Y' and sitecode = '"&sitecode&"'  " '사용여부
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		adminmidx = rs(0)
		
		'메뉴생성
		mlfield = "RoleDepth,RoleDetail,RoleDetailNm,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,Link,PopupYN,Authority"
		SQL = "insert into tblAdminMenuList ("&mlfield&",SiteCode)  select  " & mlfield & ", '"&sitecode&"' from tblAdminMenuList where sitecode = 'RTN01' and delYN = 'N' "
		Call db.execSQLRs(SQL , null, B_ConStr)


		'계정연동생성
		SQL = "insert into tblAdminMenuRole  (RoleDetail,AdminMemberIDX)  select RoleDetail, "&adminmidx&" from tblAdminMenuRole where AdminMemberIDX = 8 and delYN = 'N' "
		Call db.execSQLRs(SQL , null, B_ConStr)

	End If
	



	If rs.eof Then
		Call oJSONoutput.Set("result", "99" ) '로그인 정보틀림
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	Else
		userpass = rs("userpass")
		sKey = rs("encKey")
		sPass = rs("encPass")

		'단방향 암호화모듈
'		Set encrypt512 = server.createobject("EncryptSha512.CESSA")
'		strKey = sKey & upwd
'
'		strEncrypt = encrypt512.EncryptUsingSHA(strKey)
'		Set encrypt512 = Nothing

		'If sPass <> strEncrypt Then

'Response.write sPass
'Response.end

'		If upwd = f_dec(sPass) Then
'			loginok = true
'		End if

'		If loginok = False then
			'If upwd <> "wid2020!@" then 
			If upwd <> userpass then 
				
				Call oJSONoutput.Set("result", "99" ) '로그인 정보틀림
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End If
'		End if
	End If


'	Response.write sPass & "<br>"
'	Response.write strEncrypt & "<br>"



	'자동로그인 기능
	IF chk = true Then
		Cookies_savedate = Date() + 365
		Response.Cookies("saveid") = uid
		Response.Cookies("saveid").domain = CHKDOMAIN
		response.cookies("saveid").expires 	= Cookies_savedate
	Else
		Response.cookies("saveid").expires	= DateAdd("d",-1,now())
		Response.cookies("saveid").domain	= CHKDOMAIN	
	End IF



	uidx = rs("AdminMemberIDX") 
	uid =  rs("UserID")
	unm = rs("AdminName")
	uauth = rs("Authority")


	'Response.write unm & "##########"
	'로그인정보
	Set mobj =  JSON.Parse("{}")
	Call mobj.Set("aIDX", uidx )
	Call mobj.Set("aID", uid )
	Call mobj.Set("aNM", unm )	
	Call mobj.Set("aAUTH", uauth )
	strmemberjson = JSON.stringify(mobj)
	strmemberjson = f_enc(strmemberjson)

	Response.Cookies(COOKIENM) = strmemberjson
	Response.Cookies(COOKIENM).domain = CHKDOMAIN
	'response.cookies(COOKIENM).expires 	= Cookies_savedate
	Set mobj = Nothing	


	'이건 샾만 연결 하자.@@@@@@@@@@@@@@@@@
	If sitecode = "SDA01" then
		SQL = "SELECT AGT_PWD,UNI_GRP_CD FROM IC_T_AGENT WHERE DEL_YN = 'N'  and END_TP = 'N' and AGT_ID = '" & uid & "' " 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
		
			If Trim(ucode) = "" Or ucode <> rs("UNI_GRP_CD") Then
				Call oJSONoutput.Set("result", "99" ) '로그인 정보틀림
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end		
			End if


			reqstr = "?loginid="&uid&"&loginpw="&rs("AGT_PWD")&"&uni_grp_cd="&rs("UNI_GRP_CD")
			Session("sLOGININFO") = reqstr
		End If
		'일단 생성 하고 이걸 전달해서 복사하자..암호화도 
	End if
	'이건 샾만 연결 하자.@@@@@@@@@@@@@@@@@

	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>