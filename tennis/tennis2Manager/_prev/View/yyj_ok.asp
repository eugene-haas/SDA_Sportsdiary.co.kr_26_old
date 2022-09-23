<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Lottery_Type = fInject(Request("Lottery_Type"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	GameType     = fInject(Request("GameType"))
	TeamGb       = fInject(Request("TeamGb"))
	Level        = fInject(Request("Level"))
	TotRound     = fInject(Request("TotRound"))
	PlayerCnt    = fInject(Request("PlayerCnt"))
	NoMatchCnt   = fInject(Request("NoMatchCnt"))
	NoMatchNum   = fInject(Request("NoMatchNum"))
	seed         = fInject(Request("seed"))
	seedcnt      = fInject(Request("seedcnt"))
'무작위추첨,53,sd040001,31001,31001005,128,65,63,
	'Lottery_Type = "중고연맹1라운드제외"
	'Lottery_Type = "시드추첨"	
	'GameTitleIDX = "71"
	'GameType     = "sd040001"
	'TeamGb       = "31002"
	'Level        = "31002005"
	'TotRound     = "32"
	'PlayerCnt    = "24"
	'NoMatchCnt   = "8"
	'NoMatchNum   = "2,18,26,10,6,22,28,12" 
	'seed  = "7082,592,"
	'seedcnt = "2"

'//시드추첨,71|sd040001|31002|31002005|32|24|8|2,18,26,10,6,22,28,12|16|6|7082,592,|2
		'부전승의 갯수가 0이상일경우 tblNoMatchInfo 테이블에서 부전승 칸 및 순서 배열의 값을 가지고 온다.
		'If NoMatchCnt > 0 Then 
			USQL = "SELECT NoMatchNum,MatchNum FROM Sportsdiary.dbo.tblNoMatchInfo WHERE SportsGb='"&Request.Cookies("SportsGb")&"' AND TotRound='"&TotRound&"' AND NoMatchCnt='"&NoMatchCnt&"'"
			
			If Lottery_Type = "시드추첨" Then 
				USQL = USQL&" AND GameType='seed'"
			Else
				USQL = USQL&" AND GameType='normal'"
			End If 			


			Set URs = Dbcon.Execute(USQL)

			If Not(URs.Eof Or URs.Bof) Then 
				NoMatchNum = URs("NoMatchNum")
				MatchNum   = URs("MatchNum")
			Else
				NoMatchNum = "0"
				MatchNum   = "0"
			End If 
		'Else
		'	NoMatchNum = "0"
		'	MatchNum   = "0"
		'End If 

		'Response.WRite USQL&"<br>"
		'Response.WRite NoMatchNum

		'부전승배열
		Arrary_NoMatchNum = Split(NoMatchNum,",")
		'입력순서배열
		Arrary_MatchNum = Split(MatchNum,",")









		DSQL = "DELETE FROM SportsDiary.dbo.tblLottery_Tmp WHERE GameTitleIDX='"&GametitleIDX&"' AND TeamGb='"&TeamGb&"' AND Level='"&Level&"'"
		Dbcon.Execute(DSQL)

	'============================================================================================================================================
	'무작위추첨 Start ===========================================================================================================================
	'============================================================================================================================================
	If Lottery_Type = "무작위추첨" Then 

			SQL  = "SELECT PlayerIDX,UserName,Team,Sportsdiary.dbo.FN_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team) AS TeamNM FROM Sportsdiary.dbo.tblRPlayerMaster"
			SQL = SQL&" WHERE DelYN='N' "
			SQL = SQL&" AND GameTitleIDX='"&GameTitleIDX&"'"
			SQL = SQL&" AND TeamGb='"&TeamGb&"'"
			SQL = SQL&" AND Level='"&Level&"'"
			SQL = SQL&" AND GroupGameGb='"&SportsCode&"040001'"
			SQL = SQL&" ORDER BY NewID()"
			'Response.Write SQL
			'Response.End
			Set Rs = Dbcon.Execute(SQL)

			'Response.Write MatchNum
			

			If Not(Rs.Eof Or Rs.Bof) Then 
				Do Until Rs.Eof 
					ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&Rs("PlayerIDX")&"','"&Rs("UserName")&"','"&Rs("Team")&"','"&Rs("TeamNm")&"','"&Arrary_MatchNum(i)&"')"
					'Response.Write ISQL&"<br>"
					Dbcon.Execute(ISQL)
					i = i + 1
					Rs.MoveNext
				Loop 			
				
				SSQL = "SELECT GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum "
				SSQL = SSQL&" FROM Sportsdiary.dbo.tblLottery_Tmp "
				SSQL = SSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
				SSQL = SSQL&" AND teamGb='"&TeamGb&"'"
				SSQL = SSQL&" AND Level='"&Level&"'"
				SSQL = SSQL&" ORDER BY OrderNum "
				Set SRs = Dbcon.Execute(SSQL)

				If Not(SRs.Eof Or SRs.Bof) Then 
					x = 1
					Do Until SRs.Eof 
						If x = 1 Then 
							RetData =  SRs("PlayerIDX")&"|"&SRs("UserName")&"|"&SRs("Team")&"|"&SRs("TeamNm")&"|"&SRs("OrderNum")
						Else
							RetData = RetData&"*"&SRs("PlayerIDX")&"|"&SRs("UserName")&"|"&SRs("Team")&"|"&SRs("TeamNm")&"|"&SRs("OrderNum")
'							RetData = RetData&"*"&SRs("PlayerIDX")&"|"&SRs("UserName")&"|"&SRs("Team")&"|"&SRs("TeamNm")&"|"&x
						End If 
						x = x + 1
						SRs.MoveNext
					Loop 
				End If 
			Else
				Response.Write "<script>alert('추첨중 오류가 발생하였습니다.')</script>"
				Response.End
			End If 

	End If 
	'============================================================================================================================================
	'무작위추첨 End =============================================================================================================================
	'============================================================================================================================================
	'============================================================================================================================================
	'1라운드 같은 학교 제외 Start ===============================================================================================================
	'============================================================================================================================================	
	'(총강수/2 = 1라운드수) < 동일학교참가명수
	If Lottery_Type = "중고연맹1라운드제외" Then 



		CSQL = "SELECT COUNT(Team) AS Cnt,Team "
		CSQL = CSQL&" FROM Sportsdiary.dbo.tblrplayermaster "
		CSQL = CSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
		CSQL = CSQL&" And DelYN='N'"
		CSQL = CSQL&" AND teamGb='"&TeamGb&"'"
		CSQL = CSQL&" AND Level='"&Level&"'"
		CSQL = CSQL&" Group by Team "
		
		
		RanNum =  random_str()

		If RanNum = "1" Then 
		'한체급에 가장 많이 나온 학교 순으로 정렬
		CSQL = CSQL&" ORDER BY Cnt DESC"
		ElseIf RanNum = "2" Then 
		'한체급에 가장 적게 나온 학교 순으로 정렬
		CSQL = CSQL&" ORDER BY Cnt ASC"
		ElseIf RanNum = "3" Then 
		'팀코드정렬 
		CSQL = CSQL&" ORDER BY Team DESC"
		ElseIf RanNum = "4" Then 
		'팀코드정렬 
		CSQL = CSQL&" ORDER BY Team ASC"
	  End If 

		Set CRs = Dbcon.Execute(CSQL)
		i = 0
		k = 1
		If Not(CRs.Eof Or CRs.Bof) Then 
			Do Until CRs.Eof 
					RSQL = "SELECT PlayerIDX,UserName,Sportsdiary.dbo.FN_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team) AS TeamNM  FROM Sportsdiary.dbo.tblRplayerMaster "
					RSQL = RSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
					RSQL = RSQL&" And DelYN='N'"
					RSQL = RSQL&" AND teamGb='"&TeamGb&"'"
					RSQL = RSQL&" AND Level='"&Level&"'"
					RSQL = RSQL&" AND Team='"&CRs("Team")&"'"
					RSQL = RSQL&" AND GroupGameGb='"&SportsCode&"040001'"
					RSQL = RSQL&" Order By NewID()"
						
					Set RRs = Dbcon.Execute(RSQL)
							
					If Not (RRs.Eof Or RRs.Bof) Then 													

							Do Until RRs.Eof 
'								
								If TotRound = "2" Then 
									If Arrary_MatchNum(i) = "1" Then 
										Position = "L1"
									Else
										Position = "R1"
									End If 
								ElseIf TotRound = "4" Then 
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
										Position = "L1"
									Else
										Position = "R1"
									End If 
								ElseIf TotRound = "8" Then 
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
										Position = "L1"
									ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
										Position = "L2"
									ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then 
										Position = "R1"
									ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
										Position = "R2"
									End If 
								ElseIf TotRound = "16" Then
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Or Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Or Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Or Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
										Position = "R1"
									ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Or Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
										Position = "R2"
									End If 
								ElseIf TotRound = "32" Then 
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Or Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Or Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Or Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Or Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Or Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
										Position = "R1"
									ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Or Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
										Position = "R2"
									ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Or Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
										Position = "R3"
									ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Or Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
										Position = "R4"
									End If 
								ElseIf TotRound = "64" Then 
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Or Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Or Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Or Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Or Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Or Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
										Position = "L5"
									ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Or Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
										Position = "L6"
									ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Or Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
										Position = "L7"
									ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Or Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
										Position = "L8"
									ElseIf Arrary_MatchNum(i) = "33" Or Arrary_MatchNum(i) = "34" Or Arrary_MatchNum(i) = "35" Or Arrary_MatchNum(i) = "36" Then 
										Position = "R1"
									ElseIf Arrary_MatchNum(i) = "37" Or Arrary_MatchNum(i) = "38" Or Arrary_MatchNum(i) = "39" Or Arrary_MatchNum(i) = "40" Then 
										Position = "R2"
									ElseIf Arrary_MatchNum(i) = "41" Or Arrary_MatchNum(i) = "42" Or Arrary_MatchNum(i) = "43" Or Arrary_MatchNum(i) = "44" Then 
										Position = "R3"
									ElseIf Arrary_MatchNum(i) = "45" Or Arrary_MatchNum(i) = "46" Or Arrary_MatchNum(i) = "47" Or Arrary_MatchNum(i) = "48" Then 
										Position = "R4"
									ElseIf Arrary_MatchNum(i) = "49" Or Arrary_MatchNum(i) = "50" Or Arrary_MatchNum(i) = "51" Or Arrary_MatchNum(i) = "52" Then 
										Position = "R5"
									ElseIf Arrary_MatchNum(i) = "53" Or Arrary_MatchNum(i) = "54" Or Arrary_MatchNum(i) = "55" Or Arrary_MatchNum(i) = "56" Then 
										Position = "R6"
									ElseIf Arrary_MatchNum(i) = "57" Or Arrary_MatchNum(i) = "58" Or Arrary_MatchNum(i) = "59" Or Arrary_MatchNum(i) = "60" Then 
										Position = "R7"
									ElseIf Arrary_MatchNum(i) = "61" Or Arrary_MatchNum(i) = "62" Or Arrary_MatchNum(i) = "63" Or Arrary_MatchNum(i) = "64" Then 
										Position = "R8"
									End If 
								ElseIf TotRound = "128" Then 
									If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Or Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Or Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Or Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Or Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Or Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
										Position = "L5"
									ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Or Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
										Position = "L6"
									ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Or Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
										Position = "L7"
									ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Or Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
										Position = "L8"
									ElseIf Arrary_MatchNum(i) = "33" Or Arrary_MatchNum(i) = "34" Or Arrary_MatchNum(i) = "35" Or Arrary_MatchNum(i) = "36" Then 
										Position = "L9"
									ElseIf Arrary_MatchNum(i) = "37" Or Arrary_MatchNum(i) = "38" Or Arrary_MatchNum(i) = "39" Or Arrary_MatchNum(i) = "40" Then 
										Position = "L10"
									ElseIf Arrary_MatchNum(i) = "41" Or Arrary_MatchNum(i) = "42" Or Arrary_MatchNum(i) = "43" Or Arrary_MatchNum(i) = "44" Then 
										Position = "L11"
									ElseIf Arrary_MatchNum(i) = "45" Or Arrary_MatchNum(i) = "46" Or Arrary_MatchNum(i) = "47" Or Arrary_MatchNum(i) = "48" Then 
										Position = "L12"
									ElseIf Arrary_MatchNum(i) = "49" Or Arrary_MatchNum(i) = "50" Or Arrary_MatchNum(i) = "51" Or Arrary_MatchNum(i) = "52" Then 
										Position = "L13"
									ElseIf Arrary_MatchNum(i) = "53" Or Arrary_MatchNum(i) = "54" Or Arrary_MatchNum(i) = "55" Or Arrary_MatchNum(i) = "56" Then 
										Position = "L14"
									ElseIf Arrary_MatchNum(i) = "57" Or Arrary_MatchNum(i) = "58" Or Arrary_MatchNum(i) = "59" Or Arrary_MatchNum(i) = "60" Then 
										Position = "L15"
									ElseIf Arrary_MatchNum(i) = "61" Or Arrary_MatchNum(i) = "62" Or Arrary_MatchNum(i) = "63" Or Arrary_MatchNum(i) = "64" Then 
										Position = "L16"
									ElseIf Arrary_MatchNum(i) = "65" Or Arrary_MatchNum(i) = "66" Or Arrary_MatchNum(i) = "67" Or Arrary_MatchNum(i) = "68" Then 
										Position = "R1"
									ElseIf Arrary_MatchNum(i) = "69" Or Arrary_MatchNum(i) = "70" Or Arrary_MatchNum(i) = "71" Or Arrary_MatchNum(i) = "72" Then 
										Position = "R2"
									ElseIf Arrary_MatchNum(i) = "73" Or Arrary_MatchNum(i) = "74" Or Arrary_MatchNum(i) = "75" Or Arrary_MatchNum(i) = "76" Then 
										Position = "R3"
									ElseIf Arrary_MatchNum(i) = "77" Or Arrary_MatchNum(i) = "78" Or Arrary_MatchNum(i) = "79" Or Arrary_MatchNum(i) = "80" Then 
										Position = "R4"
									ElseIf Arrary_MatchNum(i) = "81" Or Arrary_MatchNum(i) = "82" Or Arrary_MatchNum(i) = "83" Or Arrary_MatchNum(i) = "84" Then 
										Position = "R5"
									ElseIf Arrary_MatchNum(i) = "85" Or Arrary_MatchNum(i) = "86" Or Arrary_MatchNum(i) = "87" Or Arrary_MatchNum(i) = "88" Then 
										Position = "R6"
									ElseIf Arrary_MatchNum(i) = "89" Or Arrary_MatchNum(i) = "90" Or Arrary_MatchNum(i) = "91" Or Arrary_MatchNum(i) = "92" Then 
										Position = "R7"
									ElseIf Arrary_MatchNum(i) = "93" Or Arrary_MatchNum(i) = "94" Or Arrary_MatchNum(i) = "95" Or Arrary_MatchNum(i) = "96" Then 
										Position = "R8"
									ElseIf Arrary_MatchNum(i) = "97" Or Arrary_MatchNum(i) = "98" Or Arrary_MatchNum(i) = "99" Or Arrary_MatchNum(i) = "100" Then 
										Position = "R9"
									ElseIf Arrary_MatchNum(i) = "101" Or Arrary_MatchNum(i) = "102" Or Arrary_MatchNum(i) = "103" Or Arrary_MatchNum(i) = "104" Then 
										Position = "R10"
									ElseIf Arrary_MatchNum(i) = "105" Or Arrary_MatchNum(i) = "106" Or Arrary_MatchNum(i) = "107" Or Arrary_MatchNum(i) = "108" Then 
										Position = "R11"
									ElseIf Arrary_MatchNum(i) = "109" Or Arrary_MatchNum(i) = "110" Or Arrary_MatchNum(i) = "111" Or Arrary_MatchNum(i) = "112" Then 
										Position = "R12"
									ElseIf Arrary_MatchNum(i) = "113" Or Arrary_MatchNum(i) = "114" Or Arrary_MatchNum(i) = "115" Or Arrary_MatchNum(i) = "116" Then 
										Position = "R13"
									ElseIf Arrary_MatchNum(i) = "117" Or Arrary_MatchNum(i) = "118" Or Arrary_MatchNum(i) = "119" Or Arrary_MatchNum(i) = "120" Then 
										Position = "R14"
									ElseIf Arrary_MatchNum(i) = "121" Or Arrary_MatchNum(i) = "122" Or Arrary_MatchNum(i) = "123" Or Arrary_MatchNum(i) = "124" Then 
										Position = "R15"
									ElseIf Arrary_MatchNum(i) = "125" Or Arrary_MatchNum(i) = "126" Or Arrary_MatchNum(i) = "127" Or Arrary_MatchNum(i) = "128" Then 
										Position = "R16"
									End If 
								End If 
								

'								Response.Write RRs("PlayerIDX")&","&RRs("UserName")&","&RRs("TeamNM")&array_aa(i)&"<br>"
								ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum,Position) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&RRs("PlayerIDX")&"','"&RRs("UserName")&"','"&CRs("Team")&"','"&RRs("TeamNm")&"','"&Arrary_MatchNum(i)&"','"&Position&"')"
								'Response.Write ISQL&"<br>"

								Dbcon.Execute(ISQL)



								i = i + 1
								k = k + 1
								RRs.MoveNext
							Loop 						
						
					End If 

				CRs.MoveNext
			Loop 

			GSQL = "SELECT DISTINCT(Position) AS Position FROM Sportsdiary.dbo.tblLottery_Tmp "
			GSQL = GSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
			GSQL = GSQL&" AND teamGb='"&TeamGb&"'"
			GSQL = GSQL&" AND Level='"&Level&"'"
			'Response.Write GSQL
			'Response.End
			Set GRs = Dbcon.Execute(GSQL)
			x = 1
			RetData = ""
			If Not(GRs.Eof Or GRs.Bof) Then 
				Do Until GRs.Eof 
					
					
					SSQL = "SELECT OrderNum "
					SSQL = SSQL&" FROM Sportsdiary.dbo.tblLottery_Tmp "
					SSQL = SSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
					SSQL = SSQL&" AND teamGb='"&TeamGb&"'"
					SSQL = SSQL&" AND Level='"&Level&"'"
					SSQL = SSQL&" AND Position='"&GRs("Position")&"'"
					SSQL = SSQL&" Order By OrderNum"
					'Response.Write SSQL
					'Response.End

					Set SRs = Dbcon.Execute(SSQL)

					SSQL2 = "SELECT GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum "
					SSQL2 = SSQL2&" FROM Sportsdiary.dbo.tblLottery_Tmp "
					SSQL2 = SSQL2&" WHERE gametitleidx='"&GameTitleIDX&"'"
					SSQL2 = SSQL2&" AND teamGb='"&TeamGb&"'"
					SSQL2 = SSQL2&" AND Level='"&Level&"'"
					SSQL2 = SSQL2&" AND Position='"&GRs("Position")&"'"
					SSQL2 = SSQL2&" Order By NewID()"

					Set SRs2 = Dbcon.Execute(SSQL2)

					If Not(SRs.Eof Or SRs.Bof) Then 
						Do Until SRs.Eof 
							
							If x = 1 Then 
								RetData =  SRs2("PlayerIDX")&"|"&SRs2("UserName")&"|"&SRs2("Team")&"|"&SRs2("TeamNm")&"|"&SRs("OrderNum")
							Else
								RetData = RetData&"*"&SRs2("PlayerIDX")&"|"&SRs2("UserName")&"|"&SRs2("Team")&"|"&SRs2("TeamNm")&"|"&SRs("OrderNum")
							End If 							
							x = x + 1
							SRs.MoveNext
							SRs2.MoveNext
						Loop 
					End If 


					GRs.MoveNext
				Loop 
			End If 		
	

		End If 
	End If 
	'============================================================================================================================================
	'1라운드 같은 학교 제외 End =================================================================================================================
	'============================================================================================================================================
	'============================================================================================================================================
	'시트추첨 Start =============================================================================================================================
	'============================================================================================================================================
	If Lottery_Type = "시드추첨" Then 		
		'Response.Write Left(seed,Len(seed)-1)&"<br>"
		'Response.Write seedcnt
		'Response.End

		SeedIDX = Left(seed,Len(seed)-1)

		Array_SeedIDX = Split(SeedIDX,",")
		

		x = 1
		seedNum = ""
		seedTeam    = ""
		For i=0 To Ubound(Array_SeedIDX)
			'Response.Write Array_SeedIDX(i)&"<br>"					
			'시드순서대로 선수정보 셀렉트
			SSQL = "SELECT top 1 SeedNum,Position "
			SSQL = SSQL&" FROM Sportsdiary.dbo.tblSeedInfo "
			SSQL = SSQL&" WHERE TotRound = '"&TotRound&"'"
			SSQL = SSQL&" AND SeedCnt = '"&SeedCnt&"'"
			SSQL = SSQL&" AND Num='"&x&"'"
			SSQL = SSQL&" Order By NewID()"
			'Response.Write SSQL
			'Response.End
			Set SRs = Dbcon.Execute(SSQL)


			PSQL = "SELECT PlayerIDX,UserName,Team,Sportsdiary.dbo.FN_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team) AS TeamNM "
			PSQL = PSQL&" FROM Sportsdiary.dbo.tblrPlayerMaster "
			PSQL = PSQL&" WHERE DelYN='N' "
			PSQL = PSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"
			PSQL = PSQL&" AND TeamGb='"&TeamGb&"'"
			PSQL = PSQL&" AND Level='"&Level&"'"
			PSQL = PSQL&" AND PlayerIDX='"&Array_SeedIDX(i)&"'"
			PSQL = PSQL&" AND GroupGameGb='"&SportsCode&"040001'"

			'Response.Write PSQL&"<br>"

			Set PRs = Dbcon.Execute(PSQL)

			If Not(PRs.Eof Or PRs.Bof) Then 
				'============================================================================================================================================================================
				ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum,Position) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&PRs("PlayerIDX")&"','"&PRs("UserName")&"','"&PRs("Team")&"','"&PRs("TeamNm")&"','"&SRs("SeedNum")&"','"&SRs("Position")&"')"
				
				'Response.Write ISQL&"<br>"
				
				Dbcon.Execute(ISQL)
				If x = 1 Then 
					seedNum  = seedNum & SRs("SeedNum")
					seedTeam = seedTeam    & PRs("Team")
				Else
					seedNum  = seedNum &","& SRs("SeedNum")
					seedTeam = seedTeam    & PRs("Team")
				End If 
				'============================================================================================================================================================================
			End If 
			
			PRs.Close
			Set PRs = Nothing 
			x = x + 1
		Next
		'Response.Write seedNum&"xxxx"

		'Response.End

		Arrary_seedNum = Split(seedNum,",")
		

		'시드배정자를 제외한 선수정보
		CSQL = "SELECT COUNT(Team) AS Cnt,Team "
		CSQL = CSQL&" FROM Sportsdiary.dbo.tblrplayermaster "
		CSQL = CSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
		CSQL = CSQL&" And DelYN='N'"
		CSQL = CSQL&" AND teamGb='"&TeamGb&"'"
		CSQL = CSQL&" AND Level='"&Level&"'"
		CSQL = CSQL&" AND PlayerIDX Not In ("&SeedIDX&")"
		CSQL = CSQL&" Group by Team "
				
				
		RanNum =  random_str()

		If RanNum = "1" Then 
		'한체급에 가장 많이 나온 학교 순으로 정렬
		CSQL = CSQL&" ORDER BY Cnt DESC"
		ElseIf RanNum = "2" Then 
		'한체급에 가장 적게 나온 학교 순으로 정렬
		CSQL = CSQL&" ORDER BY Cnt ASC"
		ElseIf RanNum = "3" Then 
		'팀코드정렬 
		CSQL = CSQL&" ORDER BY Team DESC"
		ElseIf RanNum = "4" Then 
		'팀코드정렬 
		CSQL = CSQL&" ORDER BY Team ASC"
		End If 

		Set CRs = Dbcon.Execute(CSQL)
		'Response.Write CSQL
		'Response.End
		i = 0
		k = 1
		'Response.Write CSQL&"<br>"

		'Response.Write MatchNum&"<br>"
		'seedNum for 문
		
		For j = 0 To Ubound(Arrary_seedNum)
			Temp_MatchNum = ""
			'Match 순서 for 문
			For i = 0 To Ubound(Arrary_MatchNum)
				If Arrary_seedNum(j) <> Arrary_MatchNum(i) Then 				
					 Temp_MatchNum = Temp_MatchNum&Arrary_MatchNum(i)&","
				End If 
			Next
			Arrary_MatchNum = Split(Temp_MatchNum,",")
			'Response.Write Temp_MatchNum&"<br>"
		Next	

		'Response.Write Temp_MatchNum&"aaaa<br>"
'		Response.End

		'Response.WRite Temp_MatchNum
'		Response.End
		Arrary_MatchNum = Split(Temp_MatchNum,",")

		'For f = 0 To Ubound(Arrary_MatchNum)
			'Response.Write Arrary_MatchNum(f)&"<br>"
		'Next
		
		'Response.End

		For i = 0 To Ubound(Arrary_MatchNum) 
			

				If Not(CRs.Eof Or CRs.Bof) Then 
					Do Until CRs.Eof 
							RSQL = "SELECT PlayerIDX,UserName,Sportsdiary.dbo.FN_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team) AS TeamNM  FROM Sportsdiary.dbo.tblRplayerMaster "
							RSQL = RSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
							RSQL = RSQL&" And DelYN='N'"
							RSQL = RSQL&" AND teamGb='"&TeamGb&"'"
							RSQL = RSQL&" AND Level='"&Level&"'"
							RSQL = RSQL&" AND Team='"&CRs("Team")&"'"
							RSQL = RSQL&" AND PlayerIDX Not In ("&SeedIDX&")"
							RSQL = RSQL&" AND GroupGameGb='"&SportsCode&"040001'"
							RSQL = RSQL&" Order By NewID()"
								
							Set RRs = Dbcon.Execute(RSQL)
									
							If Not (RRs.Eof Or RRs.Bof) Then 													

									Do Until RRs.Eof 
		'								
										If TotRound = "2" Then 
											If Arrary_MatchNum(i) = "1" Then 
												Position = "L1"
											Else
												Position = "R1"
											End If 
										ElseIf TotRound = "4" Then 
											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
												Position = "L1"
											Else
												Position = "R1"
											End If 
										ElseIf TotRound = "8" Then 
											'Response.End
											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
												Position = "L2"
											ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then 
												Position = "R1"
											ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
												Position = "R2"
											End If 
										ElseIf TotRound = "16" Then

											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
												Position = "L2"
											ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then 
												Position = "L3"
											ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then
												Position = "L4"											
											ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Then 
												Position = "R1"
											ElseIf Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
												Position = "R2"
											ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Then
												Position = "R3"
											ElseIf Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
												Position = "R4"
											End If 
										ElseIf TotRound = "32" Then 
											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then 
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
												Position = "L2"
											ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then 
												Position = "L3"
											ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
												Position = "L4"
											ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Then 
												Position = "L5"
											ElseIf Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
												Position = "L6"
											ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Then 
												Position = "L7"
											ElseIf Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
												Position = "L8"
											ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Then 
												Position = "R1"
											ElseIf Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
												Position = "R2"
											ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Then
												Position = "R3"
											ElseIf Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
												Position = "R4"
											ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Then
												Position = "R5"
											ElseIf Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
												Position = "R6"
											ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Then
												Position = "R7"
											ElseIf Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
												Position = "R8"
											End If 
										ElseIf TotRound = "64" Then 
											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
												Position = "L2"
											ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then
												Position = "L3"
											ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
												Position = "L4"
											ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Then
												Position = "L5"
											ElseIf Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
												Position = "L6"
											ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Then
												Position = "L7"
											ElseIf Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
												Position = "L8"
											ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Then
												Position = "L9"
											ElseIf Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
												Position = "L10"
											ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Then
												Position = "L11"
											ElseIf Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
												Position = "L12"
											ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Then
												Position = "L13"
											ElseIf Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
												Position = "L14"
											ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Then
												Position = "L15"
											ElseIf Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
												Position = "L16"
											ElseIf Arrary_MatchNum(i) = "33" Or Arrary_MatchNum(i) = "34" Then
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "35" Or Arrary_MatchNum(i) = "36" Then 
												Position = "R2"
											ElseIf Arrary_MatchNum(i) = "37" Or Arrary_MatchNum(i) = "38" Then
												Position = "R3"
											ElseIf Arrary_MatchNum(i) = "39" Or Arrary_MatchNum(i) = "40" Then 
												Position = "R4"
											ElseIf Arrary_MatchNum(i) = "41" Or Arrary_MatchNum(i) = "42" Then
												Position = "R5"
											ElseIf Arrary_MatchNum(i) = "43" Or Arrary_MatchNum(i) = "44" Then 
												Position = "R6"
											ElseIf Arrary_MatchNum(i) = "45" Or Arrary_MatchNum(i) = "46" Then
												Position = "R7"
											ElseIf Arrary_MatchNum(i) = "47" Or Arrary_MatchNum(i) = "48" Then 
												Position = "R8"
											ElseIf Arrary_MatchNum(i) = "49" Or Arrary_MatchNum(i) = "50" Then
												Position = "R9"
											ElseIf Arrary_MatchNum(i) = "51" Or Arrary_MatchNum(i) = "52" Then 
												Position = "R10"
											ElseIf Arrary_MatchNum(i) = "53" Or Arrary_MatchNum(i) = "54" Then
												Position = "R11"
											ElseIf Arrary_MatchNum(i) = "55" Or Arrary_MatchNum(i) = "56" Then 
												Position = "R12"
											ElseIf Arrary_MatchNum(i) = "57" Or Arrary_MatchNum(i) = "58" Then
												Position = "R13"
											ElseIf Arrary_MatchNum(i) = "59" Or Arrary_MatchNum(i) = "60" Then 
												Position = "R14"
											ElseIf Arrary_MatchNum(i) = "61" Or Arrary_MatchNum(i) = "62" Then
												Position = "R15"
											ElseIf Arrary_MatchNum(i) = "63" Or Arrary_MatchNum(i) = "64" Then 
												Position = "R16"
											End If 
										ElseIf TotRound = "128" Then 
											If Arrary_MatchNum(i) = "1" Or Arrary_MatchNum(i) = "2" Then
												Position = "L1"
											ElseIf Arrary_MatchNum(i) = "3" Or Arrary_MatchNum(i) = "4" Then 
												Position = "L2"
											ElseIf Arrary_MatchNum(i) = "5" Or Arrary_MatchNum(i) = "6" Then
												Position = "L3"
											ElseIf Arrary_MatchNum(i) = "7" Or Arrary_MatchNum(i) = "8" Then 
												Position = "L4"
											ElseIf Arrary_MatchNum(i) = "9" Or Arrary_MatchNum(i) = "10" Then
												Position = "L5"
											ElseIf Arrary_MatchNum(i) = "11" Or Arrary_MatchNum(i) = "12" Then 
												Position = "L6"
											ElseIf Arrary_MatchNum(i) = "13" Or Arrary_MatchNum(i) = "14" Then
												Position = "L7"
											ElseIf Arrary_MatchNum(i) = "15" Or Arrary_MatchNum(i) = "16" Then 
												Position = "L8"
											ElseIf Arrary_MatchNum(i) = "17" Or Arrary_MatchNum(i) = "18" Then
												Position = "L9"
											ElseIf Arrary_MatchNum(i) = "19" Or Arrary_MatchNum(i) = "20" Then 
												Position = "L10"
											ElseIf Arrary_MatchNum(i) = "21" Or Arrary_MatchNum(i) = "22" Then
												Position = "L11"
											ElseIf Arrary_MatchNum(i) = "23" Or Arrary_MatchNum(i) = "24" Then 
												Position = "L12"
											ElseIf Arrary_MatchNum(i) = "25" Or Arrary_MatchNum(i) = "26" Then
												Position = "L13"
											ElseIf Arrary_MatchNum(i) = "27" Or Arrary_MatchNum(i) = "28" Then 
												Position = "L14"
											ElseIf Arrary_MatchNum(i) = "29" Or Arrary_MatchNum(i) = "30" Then
												Position = "L15"
											ElseIf Arrary_MatchNum(i) = "31" Or Arrary_MatchNum(i) = "32" Then 
												Position = "L16"
											ElseIf Arrary_MatchNum(i) = "33" Or Arrary_MatchNum(i) = "34" Then
												Position = "L17"
											ElseIf Arrary_MatchNum(i) = "35" Or Arrary_MatchNum(i) = "36" Then 
												Position = "L18"
											ElseIf Arrary_MatchNum(i) = "37" Or Arrary_MatchNum(i) = "38" Then
												Position = "L19"
											ElseIf Arrary_MatchNum(i) = "39" Or Arrary_MatchNum(i) = "40" Then 
												Position = "L20"
											ElseIf Arrary_MatchNum(i) = "41" Or Arrary_MatchNum(i) = "42" Then
												Position = "L21"
											ElseIf Arrary_MatchNum(i) = "43" Or Arrary_MatchNum(i) = "44" Then 
												Position = "L22"
											ElseIf Arrary_MatchNum(i) = "45" Or Arrary_MatchNum(i) = "46" Then
												Position = "L23"
											ElseIf Arrary_MatchNum(i) = "47" Or Arrary_MatchNum(i) = "48" Then 
												Position = "L24"
											ElseIf Arrary_MatchNum(i) = "49" Or Arrary_MatchNum(i) = "50" Then
												Position = "L25"
											ElseIf Arrary_MatchNum(i) = "51" Or Arrary_MatchNum(i) = "52" Then 
												Position = "L26"
											ElseIf Arrary_MatchNum(i) = "53" Or Arrary_MatchNum(i) = "54" Then
												Position = "L27"
											ElseIf Arrary_MatchNum(i) = "55" Or Arrary_MatchNum(i) = "56" Then 
												Position = "L28"
											ElseIf Arrary_MatchNum(i) = "57" Or Arrary_MatchNum(i) = "58" Then
												Position = "L29"
											ElseIf Arrary_MatchNum(i) = "59" Or Arrary_MatchNum(i) = "60" Then 
												Position = "L30"
											ElseIf Arrary_MatchNum(i) = "61" Or Arrary_MatchNum(i) = "62" Then
												Position = "L31"
											ElseIf Arrary_MatchNum(i) = "63" Or Arrary_MatchNum(i) = "64" Then 
												Position = "L32"
											ElseIf Arrary_MatchNum(i) = "65" Or Arrary_MatchNum(i) = "66" Then
												Position = "R1"
											ElseIf Arrary_MatchNum(i) = "67" Or Arrary_MatchNum(i) = "68" Then 
												Position = "R2"
											ElseIf Arrary_MatchNum(i) = "69" Or Arrary_MatchNum(i) = "70" Then
												Position = "R3"
											ElseIf Arrary_MatchNum(i) = "71" Or Arrary_MatchNum(i) = "72" Then 
												Position = "R4"
											ElseIf Arrary_MatchNum(i) = "73" Or Arrary_MatchNum(i) = "74" Then
												Position = "R5"
											ElseIf Arrary_MatchNum(i) = "75" Or Arrary_MatchNum(i) = "76" Then 
												Position = "R6"
											ElseIf Arrary_MatchNum(i) = "77" Or Arrary_MatchNum(i) = "78" Then
												Position = "R7"
											ElseIf Arrary_MatchNum(i) = "79" Or Arrary_MatchNum(i) = "80" Then 
												Position = "R8"
											ElseIf Arrary_MatchNum(i) = "81" Or Arrary_MatchNum(i) = "82" Then
												Position = "R9"
											ElseIf Arrary_MatchNum(i) = "83" Or Arrary_MatchNum(i) = "84" Then 
												Position = "R10"
											ElseIf Arrary_MatchNum(i) = "85" Or Arrary_MatchNum(i) = "86" Then
												Position = "R11"
											ElseIf Arrary_MatchNum(i) = "87" Or Arrary_MatchNum(i) = "88" Then 
												Position = "R12"
											ElseIf Arrary_MatchNum(i) = "89" Or Arrary_MatchNum(i) = "90" Then
												Position = "R13"
											ElseIf Arrary_MatchNum(i) = "91" Or Arrary_MatchNum(i) = "92" Then 
												Position = "R14"
											ElseIf Arrary_MatchNum(i) = "93" Or Arrary_MatchNum(i) = "94" Then
												Position = "R15"
											ElseIf Arrary_MatchNum(i) = "95" Or Arrary_MatchNum(i) = "96" Then 
												Position = "R16"
											ElseIf Arrary_MatchNum(i) = "97" Or Arrary_MatchNum(i) = "98" Then
												Position = "R17"
											ElseIf Arrary_MatchNum(i) = "99" Or Arrary_MatchNum(i) = "100" Then 
												Position = "R18"
											ElseIf Arrary_MatchNum(i) = "101" Or Arrary_MatchNum(i) = "102" Then
												Position = "R19"
											ElseIf Arrary_MatchNum(i) = "103" Or Arrary_MatchNum(i) = "104" Then 
												Position = "R20"
											ElseIf Arrary_MatchNum(i) = "105" Or Arrary_MatchNum(i) = "106" Then
												Position = "R21"
											ElseIf Arrary_MatchNum(i) = "107" Or Arrary_MatchNum(i) = "108" Then 
												Position = "R22"
											ElseIf Arrary_MatchNum(i) = "109" Or Arrary_MatchNum(i) = "110" Then
												Position = "R23"
											ElseIf Arrary_MatchNum(i) = "111" Or Arrary_MatchNum(i) = "112" Then 
												Position = "R24"
											ElseIf Arrary_MatchNum(i) = "113" Or Arrary_MatchNum(i) = "114" Then
												Position = "R25"
											ElseIf Arrary_MatchNum(i) = "115" Or Arrary_MatchNum(i) = "116" Then 
												Position = "R26"
											ElseIf Arrary_MatchNum(i) = "117" Or Arrary_MatchNum(i) = "118" Then
												Position = "R27"
											ElseIf Arrary_MatchNum(i) = "119" Or Arrary_MatchNum(i) = "120" Then 
												Position = "R28"
											ElseIf Arrary_MatchNum(i) = "121" Or Arrary_MatchNum(i) = "122" Then
												Position = "R29"
											ElseIf Arrary_MatchNum(i) = "123" Or Arrary_MatchNum(i) = "124" Then 
												Position = "R30"
											ElseIf Arrary_MatchNum(i) = "125" Or Arrary_MatchNum(i) = "126" Then
												Position = "R31"
											ElseIf Arrary_MatchNum(i) = "127" Or Arrary_MatchNum(i) = "128" Then 
												Position = "R32"
											End If 
										End If 
										

		'								Response.Write RRs("PlayerIDX")&","&RRs("UserName")&","&RRs("TeamNM")&array_aa(i)&"<br>"
										ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum,Position) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&RRs("PlayerIDX")&"','"&RRs("UserName")&"','"&CRs("Team")&"','"&RRs("TeamNm")&"','"&Arrary_MatchNum(i)&"','"&Position&"')"
										'Response.Write ISQL&"<br>"

										Dbcon.Execute(ISQL)



										i = i + 1
										k = k + 1
										RRs.MoveNext
									Loop 						
								
							End If 

						CRs.MoveNext
					Loop 


					GSQL = "SELECT DISTINCT(Position) AS Position FROM Sportsdiary.dbo.tblLottery_Tmp "
					GSQL = GSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
					GSQL = GSQL&" AND teamGb='"&TeamGb&"'"
					GSQL = GSQL&" AND Level='"&Level&"'"
					'Response.Write GSQL
					'Response.End
					Set GRs = Dbcon.Execute(GSQL)
					x = 1
					RetData = ""
					If Not(GRs.Eof Or GRs.Bof) Then 
						Do Until GRs.Eof 
							
							
							SSQL = "SELECT OrderNum "
							SSQL = SSQL&" FROM Sportsdiary.dbo.tblLottery_Tmp "
							SSQL = SSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
							SSQL = SSQL&" AND teamGb='"&TeamGb&"'"
							SSQL = SSQL&" AND Level='"&Level&"'"
							SSQL = SSQL&" AND Position='"&GRs("Position")&"'"
							SSQL = SSQL&" Order By OrderNum"
							'Response.Write "<br>"&SSQL
							'Response.End

							Set SRs = Dbcon.Execute(SSQL)

							SSQL2 = "SELECT GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum "
							SSQL2 = SSQL2&" FROM Sportsdiary.dbo.tblLottery_Tmp "
							SSQL2 = SSQL2&" WHERE gametitleidx='"&GameTitleIDX&"'"
							SSQL2 = SSQL2&" AND teamGb='"&TeamGb&"'"
							SSQL2 = SSQL2&" AND Level='"&Level&"'"
							SSQL2 = SSQL2&" AND Position='"&GRs("Position")&"'"
							'SSQL2 = SSQL2&" Order By OrderNum"
							SSQL2 = SSQL2&" Order By NewID()"

							Set SRs2 = Dbcon.Execute(SSQL2)

							If Not(SRs.Eof Or SRs.Bof) Then 
								Do Until SRs.Eof 
									
									If x = 1 Then 
										RetData =  SRs2("PlayerIDX")&"|"&SRs2("UserName")&"|"&SRs2("Team")&"|"&SRs2("TeamNm")&"|"&SRs("OrderNum")
									Else
										RetData = RetData&"*"&SRs2("PlayerIDX")&"|"&SRs2("UserName")&"|"&SRs2("Team")&"|"&SRs2("TeamNm")&"|"&SRs("OrderNum")
									End If 							
									x = x + 1
									SRs.MoveNext
									SRs2.MoveNext
								Loop 
							End If 


							GRs.MoveNext
						Loop 
					End If 		
				End If 

		Next	


	End If 
	'============================================================================================================================================
	'시트추첨 Start =============================================================================================================================
	'============================================================================================================================================
	Response.Write RetData
%>