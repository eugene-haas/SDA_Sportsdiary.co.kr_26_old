<!--#include virtual="/Library/Config.asp"-->
<%
	UserId     = fInject(Request("Userid"))
	UserPwd    = fInject(Request("UserPwd"))

	If UserID = "" Or UserPwd = "" Then 
		Response.End
	End If 

	LoginSQL = "SELECT "
	LoginSQL = LoginSQL&" IDX"
	LoginSQL = LoginSQL&" ,UserName"
	LoginSQL = LoginSQL&" ,PartCode"
	LoginSQL = LoginSQL&" ,UserGubun"
	LoginSQL = LoginSQL&" FROM tblUserInfo "
	'삭제여부 
	LoginSQL = LoginSQL&" WHERE DelGubun='N'"
	LoginSQL = LoginSQL&" AND UserID='"&UserId&"'"
	LoginSQL = LoginSQL&" AND UserPwd='"&UserPwd&"'"

	
	Dbopen()
	Set CRs = Dbcon.Execute(CSQL)
	Dbclose()
	
	If Not(CRs.Eof Or CRs.Bof) Then 
		'관리자코드
		Response.Cookies("UserSEQ")   = trim(CRs("IDX"))
		'AgtID
		Response.Cookies("UserID")   = trim(UserId)
		'AgtNm
		Response.Cookies("UserName")   = CRs("UserName")

		Response.Cookies("UserPart")   = CRs("PartCode")

		Response.Cookies("UserGubun")   = CRs("UserGubun")


		Response.Write "<script>location.href='/Manager/Main.asp'</script>"
		
		Response.end

	Else
		'로그인 정보 없음 
		Response.Write "<script>alert('등록된 정보가없습니다.\n아이디/비밀번호 정보를 확인해 주세요.');location.href='gate.asp'</script>"
		Response.end
	End If 

	CRs.close
	Set CRs = Nothing 
Dbclose()
%>