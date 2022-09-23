<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))
	GameType      = fInject(Request("GameType"))
	'대회강수
	'totcnt = "32"
	'대회번호
	'Gametitleidx  = "48"
	'체급번호
	'RGameLevelIDX = "421"
	'해당체급 총참가자수
	'totplayer = "31"



	'대회강수
	'totcnt = "4"
	'대회번호
	'Gametitleidx  = "48"
	'체급번호
	'RGameLevelIDX = "391"
	'해당체급 총참가자수
	'totplayer = "4"



	'부전승의 갯수 구함
	UnearnWinCnt = totcnt - totplayer
	
	
	UpSQL = "Update tblRPlayerMaster_Match Set DelYN='Y' WHERE GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelIDX='"&RGameLevelIDX&"'"
	Dbcon.Execute(UpSQL)

'	Response.Write UpSQL
'	Response.End
	
	'부전승자 구함
	If UnearnWinCnt > 0 Then 
		USQL = "SELECT Top "&UnearnWinCnt
		USQL = USQL&" PlayerIDX "
		USQL = USQL&" ,convert(nvarchar(max),UserName)+','+convert(nvarchar(max),PlayerIDX)+'|' AS UnearnWinData"
		USQL = USQL&" FROM Sportsdiary.dbo.tblRPlayerMaster "
		USQL = USQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
		USQL = USQL&" AND GametitleIDX = '"&GameTitleIDX&"'"
		USQL = USQL&" AND DelYN='N'"
		USQL = USQL&" Order By Newid()"
		Set URs = Dbcon.Execute(USQL)

		UnearnWinIDX = ""
		UnearnWinData = ""
		If Not(URs.Eof Or URs.Bof) Then 
			Do Until URs.Eof 
				If UnearnWinIDX = "" Then 
					UnearnWinIDX = UnearnWinIDX&URs("PlayerIDX")
					UnearnWinData = UnearnWinData&URs("UnearnWinData")
				Else 
					UnearnWinIDX = UnearnWinIDX&","&URs("PlayerIDX")
					UnearnWinData = UnearnWinData&URs("UnearnWinData")
				End If 
				URs.MoveNext
			Loop 
		End If 
	End If 

'Response.Write UnearnWinData
'Response.End
	

	'참가수가 많은 팀 랜덤 정렬(부전승에서 빠진 선수는 제외)
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
'	CSQL = CSQL&" Order By COUNT(Team) DESC "
	CSQL = CSQL&" Order By NewID()"
	
	Set CRs = Dbcon.Execute(CSQL)

	'Response.Write CSQL
	'Response.End 






	'부전승을 제외한 나머지 데이터 합	
	NormalCnt = totplayer - UnearnWin
	'짝수홀수 구분
	TCnt = "1"
	'현제데이터 라인
	SCnt = "0"
	'왼쪽선수 수
	LCnt = "0"
	'오른쪽선수 수
	RCnt = "0"
	'왼쪽선수
	LPlayer = ""
	'왼쪽팀
	LTeam   = ""
	'오른쪽선수
	RPlayer = ""
	'오른쪽팀
	RTeam   = ""
	
	Do Until CRs.Eof 
		'Response.Write CRs("Team")
		


			'참가팀많은 순으로 선수 배열
			TSQL = "SELECT PlayerIDX,Team,TeamGb,Sex,Level,UserName FROM Sportsdiary.dbo.tblRPlayerMaster "
			TSQL = TSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
			TSQL = TSQL&" AND GametitleIDX = '"&GameTitleIDX&"'"
			TSQL = TSQL&" AND Team = '"&CRs("Team")&"'"
			TSQL = TSQL&" AND DelYN='N'"
			
			If UnearnWinIDX <> "" Then 
				TSQL = TSQL&" AND PlayerIDX Not In ("&UnearnWinIDX&")"
			End If 

			'Response.Write TSQL
			'Response.End 

			Set TRs = Dbcon.Execute(TSQL)
			
			If Not(TRs.Eof Or TRs.Bof) Then 
				Do Until TRs.Eof 

					If TCnt Mod 2 = 1 And SCnt =< (NormalCnt/2) Then 
						'tblRPlayerMaster_Match Insert ====================================================
						InSQL = "Insert Into tblRPlayerMaster_Match"
						InSQL = InSQL&" ( "
						InSQL = InSQL&" PlayerIDX "
						InSQL = InSQL&" ,Team "
						InSQL = InSQL&" ,TeamDtl "
						InSQL = InSQL&" ,SportsGb "
						InSQL = InSQL&" ,TeamGb "
						InSQL = InSQL&" ,Sex "
						InSQL = InSQL&" ,Level "
						InSQL = InSQL&" ,UserName"
						InSQL = InSQL&" ,GroupGameGb "
						InSQL = InSQL&" ,RGameLevelIDX "
						InSQL = InSQL&" ,GameTitleIDX "
						InSQL = InSQL&" ,DelYN "
						InSQL = InSQL&" ,SeedYN "
						InSQL = InSQL&" ,LRGb"
						InSQL = InSQL&" ) "
						InSQL = InSQL&" VALUES "
						InSQL = InSQL&" ( "
						InSQL = InSQL&" '"&TRs("PlayerIDX")&"'"
						InSQL = InSQL&" ,'"&TRs("Team")&"'"
						InSQL = InSQL&" ,'"&TeamDtl&"'"
						InSQL = InSQL&" ,'judo'"
						InSQL = InSQL&" ,'"&TRs("TeamGb")&"'"
						InSQL = InSQL&" ,'"&TRs("Sex")&"'"
						InSQL = InSQL&" ,'"&TRs("Level")&"'"
						InSQL = InSQL&" ,'"&TRs("UserName")&"'"
						InSQL = InSQL&" ,'"&GameType&"'"
						InSQL = InSQL&" ,'"&RGameLevelIDX&"'"
						InSQL = InSQL&" ,'"&GameTitleIDX&"'"
						InSQL = InSQL&" ,'N'"
						InSQL = InSQL&" ,'N'"
						InSQL = InSQL&" ,'L'"
						InSQL = InSQL&" ) "

						Dbcon.Execute(InSQL)
						'tblRPlayerMaster_Match Insert ====================================================

						LCnt = LCnt + 1
					ElseIf TCnt Mod 2 = 0 And SCnt =< (NormalCnt/2) Then 
						'tblRPlayerMaster_Match Insert ====================================================
						InSQL = "Insert Into tblRPlayerMaster_Match"
						InSQL = InSQL&" ( "
						InSQL = InSQL&" PlayerIDX "
						InSQL = InSQL&" ,Team "
						InSQL = InSQL&" ,TeamDtl "
						InSQL = InSQL&" ,SportsGb "
						InSQL = InSQL&" ,TeamGb "
						InSQL = InSQL&" ,Sex "
						InSQL = InSQL&" ,Level "
						InSQL = InSQL&" ,UserName"
						InSQL = InSQL&" ,GroupGameGb "
						InSQL = InSQL&" ,RGameLevelIDX "
						InSQL = InSQL&" ,GameTitleIDX "
						InSQL = InSQL&" ,DelYN "
						InSQL = InSQL&" ,SeedYN "
						InSQL = InSQL&" ,LRGb"
						InSQL = InSQL&" ) "
						InSQL = InSQL&" VALUES "
						InSQL = InSQL&" ( "
						InSQL = InSQL&" '"&TRs("PlayerIDX")&"'"
						InSQL = InSQL&" ,'"&TRs("Team")&"'"
						InSQL = InSQL&" ,'"&TeamDtl&"'"
						InSQL = InSQL&" ,'judo'"
						InSQL = InSQL&" ,'"&TRs("TeamGb")&"'"
						InSQL = InSQL&" ,'"&TRs("Sex")&"'"
						InSQL = InSQL&" ,'"&TRs("Level")&"'"
						InSQL = InSQL&" ,'"&TRs("UserName")&"'"
						InSQL = InSQL&" ,'"&GameType&"'"
						InSQL = InSQL&" ,'"&RGameLevelIDX&"'"
						InSQL = InSQL&" ,'"&GameTitleIDX&"'"
						InSQL = InSQL&" ,'N'"
						InSQL = InSQL&" ,'N'"
						InSQL = InSQL&" ,'R'"
						InSQL = InSQL&" ) "

						Dbcon.Execute(InSQL)
						'tblRPlayerMaster_Match Insert ====================================================			
						RCnt = RCnt + 1						
					Else
						If LCnt > RCnt Then 
							'tblRPlayerMaster_Match Insert ====================================================
							InSQL = "Insert Into tblRPlayerMaster_Match"
							InSQL = InSQL&" ( "
							InSQL = InSQL&" PlayerIDX "
							InSQL = InSQL&" ,Team "
							InSQL = InSQL&" ,TeamDtl "
							InSQL = InSQL&" ,SportsGb "
							InSQL = InSQL&" ,TeamGb "
							InSQL = InSQL&" ,Sex "
							InSQL = InSQL&" ,Level "
							InSQL = InSQL&" ,UserName"
							InSQL = InSQL&" ,GroupGameGb "
							InSQL = InSQL&" ,RGameLevelIDX "
							InSQL = InSQL&" ,GameTitleIDX "
							InSQL = InSQL&" ,DelYN "
							InSQL = InSQL&" ,SeedYN "
							InSQL = InSQL&" ,LRGb"
							InSQL = InSQL&" ) "
							InSQL = InSQL&" VALUES "
							InSQL = InSQL&" ( "
							InSQL = InSQL&" '"&TRs("PlayerIDX")&"'"
							InSQL = InSQL&" ,'"&TRs("Team")&"'"
							InSQL = InSQL&" ,'"&TeamDtl&"'"
							InSQL = InSQL&" ,'judo'"
							InSQL = InSQL&" ,'"&TRs("TeamGb")&"'"
							InSQL = InSQL&" ,'"&TRs("Sex")&"'"
							InSQL = InSQL&" ,'"&TRs("Level")&"'"
							InSQL = InSQL&" ,'"&TRs("UserName")&"'"
							InSQL = InSQL&" ,'"&GameType&"'"
							InSQL = InSQL&" ,'"&RGameLevelIDX&"'"
							InSQL = InSQL&" ,'"&GameTitleIDX&"'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'R'"
							InSQL = InSQL&" ) "

							Dbcon.Execute(InSQL)
							'tblRPlayerMaster_Match Insert ====================================================			
							RCnt = RCnt + 1						
						ElseIf LCnt < RCnt Then 
							'tblRPlayerMaster_Match Insert ====================================================
							InSQL = "Insert Into tblRPlayerMaster_Match"
							InSQL = InSQL&" ( "
							InSQL = InSQL&" PlayerIDX "
							InSQL = InSQL&" ,Team "
							InSQL = InSQL&" ,TeamDtl "
							InSQL = InSQL&" ,SportsGb "
							InSQL = InSQL&" ,TeamGb "
							InSQL = InSQL&" ,Sex "
							InSQL = InSQL&" ,Level "
							InSQL = InSQL&" ,UserName"
							InSQL = InSQL&" ,GroupGameGb "
							InSQL = InSQL&" ,RGameLevelIDX "
							InSQL = InSQL&" ,GameTitleIDX "
							InSQL = InSQL&" ,DelYN "
							InSQL = InSQL&" ,SeedYN "
							InSQL = InSQL&" ,LRGb"
							InSQL = InSQL&" ) "
							InSQL = InSQL&" VALUES "
							InSQL = InSQL&" ( "
							InSQL = InSQL&" '"&TRs("PlayerIDX")&"'"
							InSQL = InSQL&" ,'"&TRs("Team")&"'"
							InSQL = InSQL&" ,'"&TeamDtl&"'"
							InSQL = InSQL&" ,'judo'"
							InSQL = InSQL&" ,'"&TRs("TeamGb")&"'"
							InSQL = InSQL&" ,'"&TRs("Sex")&"'"
							InSQL = InSQL&" ,'"&TRs("Level")&"'"
							InSQL = InSQL&" ,'"&TRs("UserName")&"'"
							InSQL = InSQL&" ,'"&GameType&"'"
							InSQL = InSQL&" ,'"&RGameLevelIDX&"'"
							InSQL = InSQL&" ,'"&GameTitleIDX&"'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'L'"
							InSQL = InSQL&" ) "
							Dbcon.Execute(InSQL)
							'tblRPlayerMaster_Match Insert ====================================================
							LCnt = LCnt + 1						
						Else 
							'tblRPlayerMaster_Match Insert ====================================================
							InSQL = "Insert Into tblRPlayerMaster_Match"
							InSQL = InSQL&" ( "
							InSQL = InSQL&" PlayerIDX "
							InSQL = InSQL&" ,Team "
							InSQL = InSQL&" ,TeamDtl "
							InSQL = InSQL&" ,SportsGb "
							InSQL = InSQL&" ,TeamGb "
							InSQL = InSQL&" ,Sex "
							InSQL = InSQL&" ,Level "
							InSQL = InSQL&" ,UserName"
							InSQL = InSQL&" ,GroupGameGb "
							InSQL = InSQL&" ,RGameLevelIDX "
							InSQL = InSQL&" ,GameTitleIDX "
							InSQL = InSQL&" ,DelYN "
							InSQL = InSQL&" ,SeedYN "
							InSQL = InSQL&" ,LRGb"
							InSQL = InSQL&" ) "
							InSQL = InSQL&" VALUES "
							InSQL = InSQL&" ( "
							InSQL = InSQL&" '"&TRs("PlayerIDX")&"'"
							InSQL = InSQL&" ,'"&TRs("Team")&"'"
							InSQL = InSQL&" ,'"&TeamDtl&"'"
							InSQL = InSQL&" ,'judo'"
							InSQL = InSQL&" ,'"&TRs("TeamGb")&"'"
							InSQL = InSQL&" ,'"&TRs("Sex")&"'"
							InSQL = InSQL&" ,'"&TRs("Level")&"'"
							InSQL = InSQL&" ,'"&TRs("UserName")&"'"
							InSQL = InSQL&" ,'"&GameType&"'"
							InSQL = InSQL&" ,'"&RGameLevelIDX&"'"
							InSQL = InSQL&" ,'"&GameTitleIDX&"'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'N'"
							InSQL = InSQL&" ,'L'"
							InSQL = InSQL&" ) "
							Dbcon.Execute(InSQL)
							'tblRPlayerMaster_Match Insert ====================================================
							LCnt = LCnt + 1						
						End If 
					End If 
					SCnt = SCnt + 1
					TCnt = TCnt + 1
					TRs.MoveNext
				Loop 

			End If 	

		CRs.MoveNext
	Loop 

	chkSQL = " EXEC Sportsdiary.dbo.View_GameLot_New "
  chkSQL = chkSQL & " @GTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGLevelIDX = '" & RGameLevelIDX & "' "
  chkSQL = chkSQL & ",@seed = '"&seed&"'"
	'Response.Write chkSQL
	'Response.End
	Set CRs2 = Dbcon.Execute(ChkSQL)		
	'Response.Write LPlayer&"<br>"
	'Response.Write LTeam&"<br>"
	'Response.Write RPlayer&"<br>"
	'Response.Write RTeam&"<br>"
	
	
	For i = 1 To totplayer
	
	Next
	
	Response.Write CRs2(0)&UnearnWinData
	Response.End

%>

