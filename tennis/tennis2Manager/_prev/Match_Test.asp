<%
	
	GameTitleIDX = "71"


	'대회참가인원 리스트

	LSQL = "SELECT * FROM Sportsdiary.dbo.tblRPlayerMaster WHERE GameTitleIDX='"&GameTitleIDX&"' AND DelYN='N'"

	Set LRs = Dbcon.Execute(LSQL)


	If Not (LRs.Eof Or LRs.Bof) Then 

		
	End If 
%>