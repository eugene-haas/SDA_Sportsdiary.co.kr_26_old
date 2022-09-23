<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameTitleIDX = fInject(Request("GameTitleIDX"))

'GameTitleIDX = "52"

If GameTitleIDX  = "" Then 
	Response.Write "null"
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

'Response.WRite LSQL
'Response.End

	Set LRs = Dbcon.Execute(LSQL)


	If Not(LRs.Eof Or LRs.Bof) Then 
	
		Set zip = Server.CreateObject("TABSUpload4.ZipFile")
		FileNm = "D:\sportsdiary.co.kr\manager\upload\zip\학교장확인서"&NotDT&".zip"
		FileNm2 = "학교장확인서"&NotDT&".zip"
		If zip.Create(FileNm, "") Then

			Do Until LRs.Eof 
				zip.AddFile "D:\sportsdiary.co.kr\Request\judo\upload\"&LRs("Principal")
				LRs.MoveNext
			Loop 
			zip.Close
			
			
			Set Download = Server.CreateObject("TABSUpload4.download")

			Download.FilePath=FileNm
			
			Download.TransferFile true,true
			Set download=Nothing
			Response.Write "true"
		End If


	Else
		Response.Write "null"
		Response.End
	End If 







%>
<script type="text/javascript">
self.close();
</script>