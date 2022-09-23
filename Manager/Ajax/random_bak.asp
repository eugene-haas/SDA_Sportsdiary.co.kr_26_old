<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))

	'대회강수
	totcnt = "32"
	'대회번호
	Gametitleidx  = "48"
	'체급번호
	RGameLevelIDX = "421"


	'해당체급 총참가자수
	totplayer = "31"



	'부전승의 갯수 구함
	UnearnWin = totcnt - totplayer
	

	'부전승자 구함
	If UnearnWin > 0 Then 
		USQL = "SELECT Top "&UnearnWin
		USQL = USQL&" PlayerIDX "
		USQL = USQL&" FROM Sportsdiary.dbo.tblRPlayerMaster "
		USQL = USQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
		USQL = USQL&" AND GametitleIDX = '"&GameTitleIDX&"'"
		USQL = USQL&" AND DelYN='N'"
		USQL = USQL&" Order By Newid()"
		Set URs = Dbcon.Execute(USQL)

		UnearnWinIDX = ""
		If Not(URs.Eof Or URs.Bof) Then 
			Do Until URs.Eof 
				If UnearnWinIDX = "" Then 
					UnearnWinIDX = UnearnWinIDX&URs("PlayerIDX")
				Else 
					UnearnWinIDX = UnearnWinIDX&","&URs("PlayerIDX")
				End If 
				URs.MoveNext
			Loop 
		End If 
	End If 


	

	'참가수가 많은 팀 순서 대로 정렬(부전승에서 빠진 선수는 제회)
	CSQL = "SELECT "
	CSQL = CSQL&" COUNT(Team) AS TCnt ,Team"
	CSQL = CSQL&" FROM Sportsdiary.dbo.tblRPlayerMaster "
	CSQL = CSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
	CSQL = CSQL&" AND GametitleIDX = '"&GameTitleIDX&"'"
	
	'부전승 처리 된 선수들은 제외
	If UnearnWinIDX <> "" Then 
		CSQL = CSQL&" AND PlayerIDX Not In ("&UnearnWinIDX&")"
	End If 

	CSQL = CSQL&" AND DelYN='N'"
	CSQL = CSQL&" Group By Team "
	CSQL = CSQL&" Order By COUNT(Team) DESC "
	
	Set CRs = Dbcon.Execute(CSQL)

	'Response.Write CSQL
	'Response.End 




	'부전승을 제외한 나머지 데이터 합	
	NormalCnt = totplayer - UnearnWin
	LTeam = ""
	RTeam = ""
	NoMatch = ""
	NoMatch = ""
	Do Until CRs.Eof 
		'Response.Write CRs("Team")
		


			'참가팀많은 순으로 선수 배열
			TSQL = "SELECT PlayerIDX FROM Sportsdiary.dbo.tblRPlayerMaster "
			TSQL = TSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
			TSQL = TSQL&" AND GametitleIDX = '"&GameTitleIDX&"'"
			TSQL = TSQL&" AND Team = '"&CRs("Team")&"'"
			TSQL = TSQL&" AND DelYN='N'"
			

			Response.Write RandomSQL&"<br>"
			Response.End 



		

		CRs.MoveNext
	Loop 

		Response.Write NoMatch
%>