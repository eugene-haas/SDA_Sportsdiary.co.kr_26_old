<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
UserID   = fInject(Request("UserID"))
UserPass = fInject(Request("UserPass"))


If Trim(UserID) = "" Or Trim(UserPass) = "" then 
	Response.Write "FALSE"
	Response.End
End If 

	
	ChkSQL = " SELECT "
	ChkSQL = ChkSQL&"   IDX"         '회원코드
	ChkSQL = ChkSQL&" , UserID"      '아이디
	ChkSQL = ChkSQL&" , UserName"    '사용자명
	ChkSQL = ChkSQL&" , HandPhone"   '연락처
	ChkSQL = ChkSQL&" , SportsDiary.dbo.FN_PubName(PartCode) AS PartName"     '관리자구분
	ChkSQL = ChkSQL&" , ISNULL(SportsDiary.dbo.FN_PubName(SportsGb),'') AS SportsName"     '종목명
	ChkSQL = ChkSQL&" , ISNULL(SportsGb,'') AS SportsGb"     '종목구분
	ChkSQL = ChkSQL&" , ISNULL(HostCode,'') AS HostCode" '협회구분
	ChkSQL = ChkSQL&" From SportsDiary.dbo.tblUserInfo"
	ChkSQL = ChkSQL&" WHERE DelGubun = 'N'"
	ChkSQL = ChkSQL&" AND UserID = '"&UserID&"'"
	ChkSQL = ChkSQL&" AND UserPass = '"&UserPass&"'"
	'ChkSql = ChkSQL&" AND Convert(varchar(10),UserEndDate,112) > '"&Global_DT&"'"

'Response.Write (ChkSQL)
'Response.End

Set CRs = Dbcon.Execute(ChkSQL)
If Not(CRs.Eof Or CRs.Bof) Then 
	'마지막 접속일 업데이트
	UpSQL = "Update SportsDiary.dbo.tblUserInfo"
	UpSQL = UpSQL&" SET UpdateDate=getdate()"
	UpSQL = UpSQL&" WHERE IDX='"&CRs("IDX")&"'"

	Dbcon.Execute(UpSQL)

	'회원정보쿠키
	Response.Cookies("UserIDX")        = Trim(CRs("IDX"))
	Response.Cookies("UserID")     = Trim(CRs("UserID"))
	Response.Cookies("UserName")   = Trim(CRs("UserName"))		
	Response.Cookies("SportsName") = Trim(CRs("SportsName"))
	Response.Cookies("SportsGb") = Trim(CRs("SportsGb"))
	
	IF CRs("PartName")<>"" Then Response.Cookies("PartName")   = Trim(CRs("PartName"))	
	IF CRs("HandPhone")<>"" Then	Response.Cookies("HandPhone")  = Trim(CRs("HandPhone"))	
	IF CRs("HostCode")<>"" Then	Response.Cookies("HostCode")   = Trim(CRs("HostCode"))


	Response.Write "TRUE"
	Response.End	
Else
	Response.Write "FALSE"
	Response.End
End If 

	CRs.Close
Set CRs = Nothing 

DbClose()

%>