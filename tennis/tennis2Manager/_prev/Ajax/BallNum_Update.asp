<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	PlayerIDX     = fInject(Request("PlayerIDX"))
	BallNum       = fInject(Request("BallNum"))

	'RGameLevelIDX  = "1487"
	'PlayerIDX      ="8961"
	'BallNum        ="1"

	USQL = "Update Sportsdiary.dbo.tblRPlayerMaster Set BallNum='"&BallNum&"'"
	USQL = USQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
	USQL = USQL&" AND DelYN='N'" 
	USQL = USQL&" AND PlayerIDX='"&PlayerIDX&"'"

	Dbcon.Execute(USQL)

	'해당체급 볼넘버 카운팅
	CSQL = "SELECT Count(RGameLevelIDX) AS Cnt FROM Sportsdiary.dbo.tblRPlayerMaster WHERE DelYN='N' AND RGameLevelIDX='"&RGameLevelIDX&"' AND ISNULL(BallNum,'') = ''"

'	Response.Write CSQL

	Set CRs = Dbcon.Execute(CSQL)

	If CRs("Cnt") = "0" Then 
		Response.Write "all"
		Response.End
	Else
		Response.Write "none"
		Response.End
	End If 

%>