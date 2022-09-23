<!--#include file="../../dev/dist/config.asp"-->

<%

	Check_AdminLogin()

	iType 				= fInject(Request("iType"))					' 1:글쓰기, 2:수정
	iAdminMemberIDX 	= fInject(Request("iAdminMemberIDX"))       ' 수정시 글번호
	AdminMemberIDX 		= decode(iAdminMemberIDX,0)
	NowPage 			= fInject(Request("iNowPage"))				' 현재페이지
	AdminName 			= fInject(Request("iAdminName"))    		' 조회된 유저
	UserID 				= fInject(Request("iUserID"))
	UserPass 			= fInject(Request("iUserPass"))
	Authority 			= fInject(Request("selAuthority"))
	UseYN 				= fInject(Request("selUseYN"))
	Name 				= fInject(Request("iName"))					' 로그인유저
	iLoginID			= decode(fInject(Request("iID")),0)			' 로그인ID
	chkiRoleDetail2 	= fInject(Request("chkiRoleDetail2"))
	chkiRoleDetail2arr 	= split(chkiRoleDetail2,",")

	
   	For i=LBound(chkiRoleDetail2arr) to UBound(chkiRoleDetail2arr)

		if i = 0 then
			iRole = Trim(chkiRoleDetail2arr(i))
		else
			iRole = iRole + "^" + Trim(chkiRoleDetail2arr(i))
		end if

	Next

	' 어드민관리메뉴 코드
	RoleType = "AM"	
	%>
	<!--#include file="../../include/CheckRole.asp"-->
	<%
	Dim LCnt : LCnt = 0

	LSQL = "EXEC AdminMember_M '" & iType & "','" & AdminName & "','" & UserID & "','" & UserPass & "','" & Authority & "','" & UseYN & "','" & iLoginID & "','" & AdminMemberIDX & "','" & iRole & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End

	Set LRs = DBCon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
			LCnt = LCnt + 1
			iAdminMemberIDX = LRs("AdminMemberIDX")
			LRs.MoveNext
		Loop
	End If
		LRs.close
	SET LRs = Nothing 

	response.Write "<script type='text/javascript'>alert('어드민 등록이 잘 되었습니다.');location.href='./Admin_List.asp';</script>"
	'response.Write "<script type='text/javascript'>alert('글 등록이 잘 되었습니다.');</script>"
	'response.End


	DBClose()
%>