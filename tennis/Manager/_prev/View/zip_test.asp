<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameTitleIDX = fInject(Request("GameTitleIDX"))

GameTitleIDX = "52"

If GameTitleIDX  = "" Then 
	Response.Write "<script>alert('잘못된 경로로 접근하셨습니다.');</script>"
	Response.End
End If 



'Response.Write NotDT
'Response.End



	LSQL = "SELECT distinct(Team),Case When Sex ='Man' Then '남성' When Sex = 'WoMan' Then '여성' End AS Sex ,Principal,Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) AS TeamNm "
	LSQL = LSQL&" FROM Sportsdiary.dbo.tblGameRequest "
	LSQL = LSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND ( "
	LSQL = LSQL&" TeamGb='11001' OR TeamGb='11002' "
	LSQL = LSQL&" OR TeamGb='21001' OR TeamGb='21002' "
	LSQL = LSQL&" OR TeamGb='31001' OR TeamGb='31002' "
	LSQL = LSQL&" )"
	If Search_TeamNm <> "" Then 
		LSQL = LSQL&" Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) "
	End If 
	LSQL = LSQL&" AND ISNULL(Principal,'') <>''"

	LSQL = LSQL&" ORDER BY Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) ASC "


	Set LRs = Dbcon.Execute(LSQL)


	If Not(LRs.Eof Or LRs.Bof) Then 
	
		Set zip = Server.CreateObject("TABSUpload4.ZipFile")
		FileNm = "D:\sportsdiary.co.kr\manager\upload\zip\학교장확인서"&NotDT&".zip"
		If zip.Create(FileNm, "") Then

			Do Until LRs.Eof 
				zip.AddFile "D:\sportsdiary.co.kr\Request\judo\upload\"&LRs("Principal")
				LRs.MoveNext
			Loop 
			zip.Close
			
		End If
		Response.Write FileNm
	Else
		Response.Write "<script>alert('첨부된 파일이 없습니다.');</script>"
		Response.End
	End If 

%>

<script>window.location.assign('/Manager/View/download_zip.asp?filename=D:\sportsdiary.co.kr\manager\upload\zip\학교장확인서20170417114251.zip');</script>