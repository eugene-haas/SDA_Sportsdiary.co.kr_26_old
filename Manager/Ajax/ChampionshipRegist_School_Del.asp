<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
seq         = fInject(Request("seq"))

if trim(seq) = "" then
	response.end
end if


	'삭제전 선수,팀정보
	LSQL = "SELECT PlayerIDX "
	LSQL = LSQL&" ,Team "
	LSQL = LSQL&" ,GameTitleIDX"
	LSQL = LSQL&" ,Level"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "
	LSQL = LSQL&" WHERE RPlayerMasterIDX = '"&seq&"'"
	'Response.Write LSQL&"<br>"

	Set LRs = Dbcon.Execute(LSQL)
	
		
	If Not(LRs.Eof Or LRs.Bof) Then 
		Old_PlayerIDX    = LRs("PlayerIDX")
		Old_Team         = LRs("Team")
		Old_GameTitleIDX = LRs("GameTitleIDX")
		Old_Level        = LRs("Level")
		'tblGameRequest
		RUpdate = "Update SportsDiary.dbo.tblGameRequest"
		RUpdate = RUpdate&" SET DelYN='Y'"
		RUpdate = RUpdate&" WHERE GameTitleIDX='"&Old_GameTitleIDX&"'"
		RUpdate = RUpdate&" AND PlayerCode='"&Old_PlayerIDX&"'"
		RUpdate = RUpdate&" AND Team='"&Old_Team&"'"
		RUpdate = RUpdate&" AND GroupGameGb = 'sd040002'"
		RUpdate = RUpdate&" AND DelYN='N'"
		'Response.Write RUpdate
		'Response.End
		Dbcon.Execute(RUpdate)
	End If 	


	'삭제처리





	DSQL = " UPDATE SportsDiary.dbo.tblRPlayerMaster " 
	DSQL = DSQL & "  SET DELYN = 'Y'"
	DSQL = DSQL & " WHERE DelYN = 'N'"
	DSQL = DSQL & " AND RPlayerMasterIDX = '" & seq & "'"
	Dbcon.Execute(DSQL)

	

	







	response.write "TRUE"
	response.end





Dbclose()


%>