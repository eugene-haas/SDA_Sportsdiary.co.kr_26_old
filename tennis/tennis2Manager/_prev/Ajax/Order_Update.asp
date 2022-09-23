<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
 RGameLevelIDX = fInject(Request("RGameLevelIDX"))

' RGameLevelIDX = "1469"
 'Response.Write RGameLevelIDX

	Dim ReturnSTR()
	Dim strGameNum
	Dim Count : Count = 1
	
	 '같은소속이있는지 체크
	 GSQL ="SELECT Team FROM SportsDiary.dbo.tblRPlayerMaster "
	 GSQL = GSQL&" WHERE DelYN='N'"
	 GSQL = GSQL&" AND RGameLevelIDX='"&RGameLevelIDX&"'"
	 GSQL = GSQL&" Group By Team Having Count(Team) > 1 "
	 Set GRs = Dbcon.Execute(GSQL)
	 'Response.Write GSQL
	 'Response.End

	'중복팀이 없을경우
	'기존데이터 삭제처리
	DelSQL = "Delete From Sportsdiary.dbo.tblRPlayer Where  RGameLevelidx='"&RGameLevelidx&"'"

	Dbcon.Execute(DelSQL)			
	
	DelSQL2 = "Delete From Sportsdiary.dbo.tblPlayerResult Where  RGameLevelidx='"&RGameLevelidx&"'"
	'Response.Write DelSQL2
	'Response.End
	Dbcon.Execute(DelSQL2)		





	



	If Not(GRs.Eof Or GRs.Bof) Then 
		'중복팀이 있을경우 		
		USQL = "SELECT PlayerIDX, UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm,GameTitleIDX,Sex,TeamGb "
		USQL = USQL&" ,(SELECT COUNT(Team) FROM Sportsdiary.dbo.tblRPlayerMaster WHERE DelYN='N' AND RGameLevelIDX='"&RGameLevelIDX&"' AND Team=B.Team) AS A "
		USQL = USQL&" FROM Sportsdiary.dbo.tblRPlayerMaster B WHERE DelYN='N' AND RGameLevelIDX='"&RGameLevelIDX&"' "
		USQL = USQL&" ORDER BY A DESC,BallNum"


		Set URs = Dbcon.Execute(USQL)
		If Not(URs.Bof Or URs.Eof) Then

			Arr_Player = URs.Getrows()
			Cnt_Arr_Player = UBound(Arr_Player,2)
			ReDim ReturnSTR(Cnt_Arr_Player)

			For i = 0 To Cnt_Arr_Player
				ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
				If i = 0 Then 
					GameTitleIDX = Arr_Player(6,i) 
					Sex = Arr_Player(7,i) 
					TeamGb = Arr_Player(8,i) 
				End If 
			Next
		


						If Cnt_Arr_Player <> "" Then 		
	
							For i = 0 To Cnt_Arr_Player

								For j = 0 To Cnt_Arr_Player 

									If i <> j  Then 

										If i < j Then
											ReturnSTR(i) = ReturnSTR(i) & "," & Count
											ReturnSTR(j) = ReturnSTR(j) & "," & Count
										

											Count = Count + 1
										End If
									End If 
								Next
							Next
						End If

				For i=0 To UBound(ReturnSTR,1)
					If i = 0 Then
						GameNum = GameNum & Mid(ReturnSTR(i),1)
					Else
						GameNum = GameNum & "|" & Mid(ReturnSTR(i),1)
					End If
				Next
		End If



		First_Arr_GameNum = Split(GameNum,"|")

		PlayerNum = 0

		For i = 0 To UBound(First_Arr_GameNum,1)
			'Response.WRite First_Arr_GameNum(i)
			'Response.End
			Second_Arr_GameNum = Split(First_Arr_GameNum(i),",")

			PlayerNum = i + 101

			InSQL = "Insert Into tblRPlayer ("
			InSQL = InSQL & " SportsGb,"
			InSQL = InSQL & " GameTitleIDX,"
			InSQL = InSQL & " SchIDX,"
			InSQL = InSQL & " PlayerIDX,"
			InSQL = InSQL & " UserName,"
			InSQL = InSQL & " Level,"
			InSQL = InSQL & " TeamGb,"
			InSQL = InSQL & " Sex,"
			InSQL = InSQL & " PlayerNum,"
			InSQL = InSQL & " UnearnWin,"
			InSQL = InSQL & " LeftRightGb,"
			InSQL = InSQL & " GroupGameNum,"

			InSQL = InSQL & " Team,"
			InSQL = InSQL & " TeamDtl,"
			'Response.WRite UBound(Second_Arr_GameNum)
			'Response.End

			For j = 6 To UBound(Second_Arr_GameNum)
				InSQL = InSQL & " Game" & j - 5& "R,"
			Next

			InSQL = InSQL & " GroupGameGb,"
			InSQL = InSQL & " RGameLevelIDX,"
			InSQL = InSQL & " DelYN"
			InSQL = InSQL & ")"
			InSQL = InSQL & " VALUES ("
			InSQL = InSQL & " '"&Request.Cookies("SportsGb")&"',"
			InSQL = InSQL & " '"&GameTitleIDX&"',"
			InSQL = InSQL & " '',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(0) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(1) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(4) &"',"
			InSQL = InSQL & " '"&TeamGb&"',"
			InSQL = InSQL & " '"&Sex&"',"
			InSQL = InSQL & " '" & PlayerNum & "',"
			InSQL = InSQL & " '"&SportsCode&"042001',"
			InSQL = InSQL & " '"&SportsCode&"030001',"
			InSQL = InSQL & " '0',"

			InSQL = InSQL & " '"& Second_Arr_GameNum(2) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(3) &"',"


			For j = 6 To UBound(Second_Arr_GameNum)
				InSQL = InSQL & "'" & Second_Arr_GameNum(j) & "',"
			Next

			InSQL = InSQL & " '"&SportsCode&"040001',"
			InSQL = InSQL & " '"&RGameLevelIDX&"',"

			InSQL = InSQL & " 'N')"
			'Response.Write InSQL&"<br>"
			'Response.End

			Dbcon.Execute(InSQL)		

		Next
		
		ProcedureSQL = " EXEC Sportsdiary.dbo.Insert_tblPlayerResult_Wres_Level "
		ProcedureSQL = ProcedureSQL & " @RGameLevelIDX = "&RGameLevelIDX
		Dbcon.Execute(ProcedureSQL)


		'참가자수 카운트
		PSQL ="SELECT Count(Team) AS Cnt FROM SportsDiary.dbo.tblRPlayerMaster "
		PSQL = PSQL&" WHERE DelYN='N'"
		PSQL = PSQL&" AND RGameLevelIDX='"&RGameLevelIDX&"'"
		
		Set PRs = Dbcon.Execute(PSQL)

		If PRs("Cnt") = "5" Then 
			CntGameNum = "1,9,7,5,6,10,3,4,8,2"

			Arr_CntGameNum = Split(CntGameNum,",")
		ElseIf PRs("Cnt") = "4" Then 
			CntGameNum = "1,5,3,4,6,2"
			Arr_CntGameNum = Split(CntGameNum,",")
		ElseIf PRs("Cnt") = "3" Then 
			CntGameNum = "1,3,2"
			Arr_CntGameNum = Split(CntGameNum,",")
		End If 		
		
		TempSQL = "SELECT PlayerResultIDX FROM sportsdiary.dbo.tblplayerresult where delyn='N' and RGameLevelIDX='"&RGameLevelIDX&"' ORDER BY PlayerResultIDX ASC"

		Set TempRs = Dbcon.Execute(TempSQL)
		
		k = 0
		Do Until TempRs.Eof 
			USQL = "Update sportsdiary.dbo.tblplayerresult SET TempTurnNuM='"&Arr_CntGameNum(k)&"' WHERE PlayerResultIDX='"&TempRs("PlayerResultIDX")&"'"
			Dbcon.Execute(USQL)
			k = k + 1
			TempRs.MoveNext
		Loop 

  


		Response.Write "true"
		Response.End
	Else
		
		'해당체급 등록된 선수 조회	
		USQL = " SELECT PlayerIDX, UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm,GameTitleIDX,Sex,TeamGb"
		USQL = USQL&" FROM SportsDiary.dbo.tblRPlayerMaster"
		USQL = USQL&" WHERE DelYN = 'N'"
		USQL = USQL&" AND RgameLevelIDX = '" & RGameLevelIDX & "'"
		USQL = USQL&" ORDER BY BallNum"	



			Set URs = Dbcon.Execute(USQL)
			If Not(URs.Bof Or URs.Eof) Then

				Arr_Player = URs.Getrows()
				Cnt_Arr_Player = UBound(Arr_Player,2)
				ReDim ReturnSTR(Cnt_Arr_Player)

				For i = 0 To Cnt_Arr_Player
					ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
					If i = 0 Then 
						GameTitleIDX = Arr_Player(6,i) 
						Sex = Arr_Player(7,i) 
						TeamGb = Arr_Player(8,i) 
					End If 
				Next
			


							If Cnt_Arr_Player <> "" Then 		
		
								For i = 0 To Cnt_Arr_Player

									For j = 0 To Cnt_Arr_Player 

										If i <> j  Then 

											If i < j Then
												ReturnSTR(i) = ReturnSTR(i) & "," & Count
												ReturnSTR(j) = ReturnSTR(j) & "," & Count
											

												Count = Count + 1
											End If
										End If 
									Next
								Next
							End If

					For i=0 To UBound(ReturnSTR,1)
						If i = 0 Then
							GameNum = GameNum & Mid(ReturnSTR(i),1)
						Else
							GameNum = GameNum & "|" & Mid(ReturnSTR(i),1)
						End If
					Next
			End If

		'Response.WRite GameNum
		'Response.End

		First_Arr_GameNum = Split(GameNum,"|")

		PlayerNum = 0


	
		

		For i = 0 To UBound(First_Arr_GameNum,1)
			'Response.WRite First_Arr_GameNum(i)
			'Response.End
			Second_Arr_GameNum = Split(First_Arr_GameNum(i),",")

			PlayerNum = i + 101

			InSQL = "Insert Into tblRPlayer ("
			InSQL = InSQL & " SportsGb,"
			InSQL = InSQL & " GameTitleIDX,"
			InSQL = InSQL & " SchIDX,"
			InSQL = InSQL & " PlayerIDX,"
			InSQL = InSQL & " UserName,"
			InSQL = InSQL & " Level,"
			InSQL = InSQL & " TeamGb,"
			InSQL = InSQL & " Sex,"
			InSQL = InSQL & " PlayerNum,"
			InSQL = InSQL & " UnearnWin,"
			InSQL = InSQL & " LeftRightGb,"
			InSQL = InSQL & " GroupGameNum,"

			InSQL = InSQL & " Team,"
			InSQL = InSQL & " TeamDtl,"
			'Response.WRite UBound(Second_Arr_GameNum)
			'Response.End

			For j = 6 To UBound(Second_Arr_GameNum)
				InSQL = InSQL & " Game" & j - 5& "R,"
			Next

			InSQL = InSQL & " GroupGameGb,"
			InSQL = InSQL & " RGameLevelIDX,"
			InSQL = InSQL & " DelYN"
			InSQL = InSQL & ")"
			InSQL = InSQL & " VALUES ("
			InSQL = InSQL & " '"&Request.Cookies("SportsGb")&"',"
			InSQL = InSQL & " '"&GameTitleIDX&"',"
			InSQL = InSQL & " '',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(0) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(1) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(4) &"',"
			InSQL = InSQL & " '"&TeamGb&"',"
			InSQL = InSQL & " '"&Sex&"',"
			InSQL = InSQL & " '" & PlayerNum & "',"
			InSQL = InSQL & " '"&SportsCode&"042001',"
			InSQL = InSQL & " '"&SportsCode&"030001',"
			InSQL = InSQL & " '0',"

			InSQL = InSQL & " '"& Second_Arr_GameNum(2) &"',"
			InSQL = InSQL & " '"& Second_Arr_GameNum(3) &"',"


			For j = 6 To UBound(Second_Arr_GameNum)
				InSQL = InSQL & "'" & Second_Arr_GameNum(j) & "',"
			Next

			InSQL = InSQL & " '"&SportsCode&"040001',"
			InSQL = InSQL & " '"&RGameLevelIDX&"',"
			InSQL = InSQL & " 'N')"
			'Response.Write InSQL&"<br>"
			'Response.End

			Dbcon.Execute(InSQL)		

		Next
		
		ProcedureSQL = " EXEC Sportsdiary.dbo.Insert_tblPlayerResult_Wres_Level "
		ProcedureSQL = ProcedureSQL & " @RGameLevelIDX = "&RGameLevelIDX
		Dbcon.Execute(ProcedureSQL)

		

		'참가자수 카운트
		PSQL ="SELECT Count(Team) AS Cnt FROM SportsDiary.dbo.tblRPlayerMaster "
		PSQL = PSQL&" WHERE DelYN='N'"
		PSQL = PSQL&" AND RGameLevelIDX='"&RGameLevelIDX&"'"
		
		Set PRs = Dbcon.Execute(PSQL)

		If PRs("Cnt") = "5" Then 
			CntGameNum = "9,7,5,3,4,8,1,2,6,10"
			Arr_CntGameNum = Split(CntGameNum,",")
		ElseIf PRs("Cnt") = "4" Then 
			CntGameNum = "5,3,1,2,4,6"
			Arr_CntGameNum = Split(CntGameNum,",")
		ElseIf PRs("Cnt") = "3" Then 
			CntGameNum = "1,3,2"
			Arr_CntGameNum = Split(CntGameNum,",")
		End If 		
		
		TempSQL = "SELECT PlayerResultIDX FROM sportsdiary.dbo.tblplayerresult where delyn='N' and RGameLevelIDX='"&RGameLevelIDX&"' ORDER BY PlayerResultIDX ASC"

		Set TempRs = Dbcon.Execute(TempSQL)
		
		k = 0
		Do Until TempRs.Eof 
			USQL = "Update sportsdiary.dbo.tblplayerresult SET TempTurnNuM='"&Arr_CntGameNum(k)&"' WHERE PlayerResultIDX='"&TempRs("PlayerResultIDX")&"'"
			'Response.WRite USQL
			Dbcon.Execute(USQL)
			k = k + 1
			TempRs.MoveNext
		Loop 

		Response.Write "true"
		Response.End
	End If 
%>