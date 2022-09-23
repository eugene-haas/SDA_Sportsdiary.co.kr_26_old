<!--#include file="../dev/dist/config.asp"-->

<%

	Check_AdminLogin()

  iType = fInject(Request("iType"))							' 1:글쓰기, 2:수정
  
  iAdminMenuListIDX = fInject(Request("iAdminMenuListIDX"))           ' 수정시 글번호
  AdminMenuListIDX = decode(iAdminMenuListIDX,0)

  NowPage = fInject(Request("iNowPage"))				' 현재페이지

  RoleDetail = fInject(Request("iRoleDetail"))  
  RoleDetailNm = fInject(Request("iRoleDetailNm"))
	Link = fInject(Request("iLink"))
	RoleDetailGroup1 = fInject(Request("iRoleDetailGroup1"))
	RoleDetailGroup1Nm = fInject(Request("iRoleDetailGroup1Nm"))
	RoleDetailGroup2 = fInject(Request("iRoleDetailGroup2"))
	RoleDetailGroup2Nm = fInject(Request("iRoleDetailGroup2Nm"))
	UseYN = fInject(Request("selUseYN"))

  iID = fInject(Request("iID"))						' 로그인ID
	iLoginID = decode(iID,0)

	'chkiRoleDetail2 = fInject(Request("chkiRoleDetail2"))
	'chkiRoleDetail2arr = split(chkiRoleDetail2,",")
	'
	'For i=LBound(chkiRoleDetail2arr) to UBound(chkiRoleDetail2arr)
	'
	'	if i = 0 then
	'		iRole = Trim(chkiRoleDetail2arr(i))
	'	else
	'		iRole = iRole + "^" + Trim(chkiRoleDetail2arr(i))
	'	end if
	'
	'Next

	' 어드민관리메뉴 코드
	RoleType = "MNM"
%>

<!--#include file="CheckRole.asp"-->

<%
  Dim LCnt
  LCnt = 0

  LSQL = "EXEC AdminMenu_M '" & iType & "','" & AdminMenuListIDX & "','" & iLoginID & "','" & RoleDetail & "','" & RoleDetailNm & "','" & Link & "','" & RoleDetailGroup1 & "','" & RoleDetailGroup1Nm & "','" & RoleDetailGroup2 & "','" & RoleDetailGroup2Nm & "','" & UseYN & "','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon5.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        iAdminMenuListIDX = LRs("AdminMenuListIDX")

      LRs.MoveNext
		Loop

	End If

  LRs.close
  
  
  response.Write "<script type='text/javascript'>alert('메뉴 등록이 잘 돼었습니다.');location.href='./Admin_MenuList.asp';</script>"
  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  response.End
  

  Tennis_DBClose()
%>