<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	GameTitleIDX = fInject(Request("GameTitleIDX"))
'	GameTitleIDX = "52"
	If GameTitleIDX = "" Then 
		Response.Write "false"
		Response.End
	End If 

	'대회 체급정보 중복 제거 
	LSQL = "SELECT Distinct(RGameLevelIDX) AS RGameLevelIDX,GroupGameGb,GameDay "
	LSQL = LSQL&" FROM Sportsdiary.dbo.tblPlayerResult"
	LSQL = LSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"



	Set LRs = Dbcon.Execute(LSQL)


	If Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			
			MSQL = "SELECT PlayerResultIDX,GameType FROM Sportsdiary.dbo.tblPlayerResult "
			MSQL = MSQL&" WHERE     (GameTitleIDX = '"&GameTitleIDX&"') "
			MSQL = MSQL&" AND RGameLevelidx = '"&LRs("RGameLevelIDX")&"' "
			If Right(LRs("GroupGameGb"),1) = "1" Then 
				'개인전일경우 정렬 순서
				MSQL = MSQL&" ORDER BY CONVERT(bigint, GameNum) DESC "
			Else
				'단체전일경우 정렬 순서
				MSQL = MSQL&" ORDER BY CONVERT(bigint, GroupGameNum) DESC "
			End If 

			Set MRs = Dbcon.Execute(MSQL)
			
			i = 1 
			Do Until MRs.Eof 
'				Response.Write MRs("PlayerResultIDX")&"<br>"
					If MRs("GameType") = SportsCode&"043001" Then 
						NowRoundNm = "리그"
						NowRound = "1"
					Else
						If i = 1 Then 
							NowRoundNm = "결승"
							NowRound = "1"
						ElseIf i >= 2 And i =<3 Then 
							NowRoundNm = "준결승"
							NowRound = "2"
						ElseIf i >= 4 And i =<7 Then 
							NowRoundNm = "8강"
							NowRound = "3"
						ElseIf i >= 8 And i =<15 Then 
							NowRoundNm = "16강"
							NowRound = "4"						
						ElseIf i >= 16 And i =<31 Then
							NowRoundNm = "32강"
							NowRound = "5"						
						ElseIf i >= 32 And i =<63 Then
							NowRoundNm = "64강"
							NowRound = "6"						
						ElseIf i >= 64 And i =<127 Then
							NowRoundNm = "128강"
							NowRound = "7"						
						ElseIf i >= 128 And i =<383 Then  
							NowRoundNm = "256강"
							NowRound = "8"						
						End If 
					End If 

					UpSQL = "Update Sportsdiary.dbo.tblPlayerResult "
					UpSQL = UpSQL&" SET NowRoundNm = '"&NowRoundNm&"'"
					UpSQL = UpSQL&" ,NowRound ='"&NowRound&"'"
					UpSQL = UpSQL&" WHERE PlayerResultIDX = '"&MRs("PlayerResultIDX")&"'"

					'Response.Write UpSQL&"<br>"

					Dbcon.Execute(UpSQL)					

					i = i + 1
				MRs.MoveNext
			Loop 
			LRs.MoveNext
		Loop 

		Response.Write "true"
		Response.End
	Else
		Response.Write "false"
		Response.End
	End If 

	

%>