<!--#include file="../dev/dist/config.asp"-->

<%

  txtID = fInject(Request("txtID"))						
  psAdmin = fInject(Request("psAdmin"))						


  Dim LCnt, LoginIDYN
  LCnt = 0
	LoginIDYN = "N"

  LSQL = "EXEC AdminMember_Login_S '" & txtID & "','" & psAdmin & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon5.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        LoginIDYN = LRs("LoginIDYN")
				UserID = LRs("UserID")
				AdminName = LRs("AdminName")

      LRs.MoveNext
		Loop

	Else
		response.Write "<script type='text/javascript'>alert('등록된 사용자가 없습니다.');location.href='./Admin_Login.asp';</script>"

	End If

  LRs.close
  
	'response.Write "LoginIDYN="&LoginIDYN&"<br>"
	'response.Write "UserID="&UserID&"<br>"
	'response.Write "AdminName="&AdminName&"<br>"
  'response.End

  if LoginIDYN = "N" then
		response.Write "<script type='text/javascript'>alert('등록된 사용자가 없습니다.');location.href='./Admin_Login.asp';</script>"
		'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
		response.End
	else

		'Response.Cookies("UserName") = ""
		'Response.Cookies("UserID") = ""
		'Response.Cookies("AdminYN") = ""

		Response.Cookies("UserName").Domain  = ".sportsdiary.co.kr"   '사용자명
		Response.Cookies("UserName").path = "/"
		Response.Cookies("UserName") = AdminName
		Response.Cookies("UserID").Domain  = ".sportsdiary.co.kr"   '사용자명
		Response.Cookies("UserID").path = "/"
		Response.Cookies("UserID") = encode(UserID,0)
		Response.Cookies("AdminYN").Domain  = ".sportsdiary.co.kr"   '사용자명
		Response.Cookies("AdminYN").path = "/"
		Response.Cookies("AdminYN") = encode("Y",0)

		'Session("UserName") = AdminName
		'Session("UserID") = encode(UserID,0)
		'Session("AdminYN") = encode("Y",0)

		response.Write "<script type='text/javascript'>location.href='./Admin_Index.asp';</script>"
		'response.Write "<script type='text/javascript'>alert('등록된 사용자 입니다.');</script>"
		response.End
	end if
  

	Tennis_DBClose()
%>