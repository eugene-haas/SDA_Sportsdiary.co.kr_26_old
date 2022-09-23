<!--#include file="../../dev/dist/config.asp"-->
<%

	txtID = fInject(Request("txtID"))
	psAdmin = fInject(Request("psAdmin"))


	Dim LCnt, LoginIDYN
	LCnt = 0
	LoginIDYN = "N"

	LSQL = "EXEC AdminMember_Login_S '" & txtID & "','" & psAdmin & "'"
	'response.Write "LSQL="&LSQL&"<br>"
	'response.End

	Set LRs = DBCon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

			LCnt = LCnt + 1
			LoginIDYN = LRs("LoginIDYN")
			UserID = LRs("UserID")
			AdminName = LRs("AdminName")
			AdminMemberIDX = LRs("AdminMemberIDX")
			Authority = LRs("Authority")


			LRs.MoveNext
		Loop

	LRs.close

	Else
		response.Write "<script type='text/javascript'>alert('등록된 사용자가 없습니다.');location.href='./Admin_Login.asp';</script>"
	End If


	if LoginIDYN = "N" then
		response.Write "<script type='text/javascript'>alert('등록된 사용자가 없습니다.');location.href='./Admin_Login.asp';</script>"
		response.End
	else

		'iType = "1"
		'iSubType = "4"
		'NowPage = "1"
		'GameTitleIDX = ""
		'AdminGameTitleIDX = ""
		'iLoginID = UserID
		'AdminGameTitleR = ""
		'
		'LSQL = "EXEC AdminGameTitle_R '" & iType & "','" & iSubType & "','" & NowPage & "','" & GameTitleIDX & "','" & AdminGameTitleIDX & "','" & iLoginID & "','','','','',''"
		''response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
		''response.End
		'
		'Set LRs = DBCon.Execute(LSQL)
		'If Not (LRs.Eof Or LRs.Bof) Then
		'	Do Until LRs.Eof
		'
		'		AdminGameTitleR = AdminGameTitleR&"_//_"&LRs("GameTitleIDX")&""
		'
		'		LRs.MoveNext
		'	Loop
		'
		'End If
		'
		'LRs.close


		response.Cookies(global_HP).Domain = ".sportsdiary.co.kr"
		response.Cookies(global_HP).path = "/"
		response.Cookies(global_HP)("UserID") = crypt.EncryptStringENC(UserID)			'사용자ID
		response.Cookies(global_HP)("Authority") = crypt.EncryptStringENC(Authority)			'사용자ID

		Response.Cookies("UserName").Domain  = ".sportsdiary.co.kr"
		Response.Cookies("UserName").path = "/"
		Response.Cookies("UserName") = AdminName
		Response.Cookies("UserID").Domain  = ".sportsdiary.co.kr"
		Response.Cookies("UserID").path = "/"
		Response.Cookies("UserID") = encode(UserID,0)
		Response.Cookies("AdminYN").Domain  = ".sportsdiary.co.kr"
		Response.Cookies("AdminYN").path = "/"
		Response.Cookies("AdminYN") = encode("Y",0)
		Response.Cookies("AdminGameTitle").Domain  = ".sportsdiary.co.kr"
		Response.Cookies("AdminGameTitle").path = "/"
		'Response.Cookies("AdminGameTitle") = encode(AdminGameTitleR,0)

		'response.Write "<script type='text/javascript'>location.href='./Admin_Index.asp';</script>"
        response.Write "<script type='text/javascript'>location.href='/index2.asp';</script>"
		response.End

	end if


	DBClose()
%>
