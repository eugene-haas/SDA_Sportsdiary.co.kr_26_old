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

'무작위추첨,53,sd040001,31001,31001005,128,65,63,
'	Lottery_Type = "무작위추첨"
'	Lottery_Type = "1라운드제외"
'	GameTitleIDX = "71"
'	GameType     = "sd040001"
'	TeamGb       = "31001"
'	Level        = "31001005"
'	TotRound     = "128"
'	PlayerCnt    = "90"
'	NoMatchCnt   = "63"
'	NoMatchNum   = "128,64,96,32,112,48,80,16,120,56,88,24,104,40,72,8,124,60,92,28,108,44,76,12,116,52,84,20,100,36,68,4,126,62,94,30,110,46,78,14,118,54,86,22,102,38,70,6,122,58,90,26,106,42,74,10,114,50,82,18,98,34,66,64,9"




		'부전승의 갯수가 0이상일경우 tblNoMatchInfo 테이블에서 부전승 칸의 값을 가지고 온다.
		If NoMatchCnt > 0 Then 
			USQL = "SELECT NoMatchNum FROM Sportsdiary.dbo.tblNoMatchInfo WHERE SportsGb='judo' AND TotRound='"&TotRound&"' AND NoMatchCnt='"&NoMatchCnt&"'"
			
			Set URs = Dbcon.Execute(USQL)

			If Not(URs.Eof Or URs.Bof) Then 
				NoMatchNum = URs("NoMatchNum")
			Else
				NoMatchNum = "0"
			End If 
		Else
			NoMatchNum = "0"
		End If 



	
		Arrary_NoMatchNum = Split(NoMatchNum,",")




		DSQL = "DELETE FROM SportsDiary.dbo.tblLottery_Tmp WHERE GameTitleIDX='"&GametitleIDX&"' AND TeamGb='"&TeamGb&"' AND Level='"&Level&"'"
		Dbcon.Execute(DSQL)

	'============================================================================================================================================
	'무작위추첨 Start ===========================================================================================================================
	'============================================================================================================================================
	If Lottery_Type = "무작위추첨" Then 

			SQL  = "SELECT PlayerIDX,UserName,Team,Sportsdiary.dbo.FN_TeamNm('judo',TeamGb,Team) AS TeamNM FROM Sportsdiary.dbo.tblRPlayerMaster"
			SQL = SQL&" WHERE DelYN='N' "
			SQL = SQL&" AND GameTitleIDX='"&GameTitleIDX&"'"
			SQL = SQL&" AND TeamGb='"&TeamGb&"'"
			SQL = SQL&" AND Level='"&Level&"'"
			SQL = SQL&" AND GroupGameGb='sd040001'"
			SQL = SQL&" ORDER BY NewID()"
			'Response.Write SQL
			'Response.End
			Set Rs = Dbcon.Execute(SQL)

			If TotRound = "2" Then 
				OrderNum = "1,2"
			ElseIf TotRound = "4" Then 
				OrderNum = "1,3,2,4"
			ElseIf TotRound = "8" Then 
				OrderNum = "1,5,3,7,2,6,4,8"
			ElseIf TotRound = "16" Then 
				OrderNum = "1,9,5,13,3,11,7,15,2,10,6,14,4,12,8,16"

			ElseIf TotRound = "32" Then 
				OrderNum = "1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31,2,18,10,26,6,22,14,30,4,20,12,28,8,24,16,32"

			ElseIf TotRound = "64" Then 
				OrderNum = "1,33,17,49,9,41,25,57,5,37,21,53,13,45,29,61,3,35,19,51,11,43,27,59,7,39,23,55,15,47,31,63,2,34,18,50,10,42,26,58,6,38,22,54,14,46,30,62,4,36,20,52,12,44,28,60,8,40,24,56,16,48,32,64"
			ElseIf TotRound = "128" Then 
				OrderNum = "1,65,33,97,17,81,49,113,9,73,41,105,25,89,57,121,5,69,37,101,21,85,53,117,13,77,45,109,29,93,61,125,3,67,35,99,19,83,51,115,11,75,43,107,27,91,59,123,7,71,39,103,23,87,55,119,15,79,47,111,31,95,63,127,"
				OrderNum = OrderNum&"2,66,34,98,18,82,50,114,10,74,42,106,26,90,58,122,6,70,38,102,22,86,54,118,14,78,46,110,30,94,62,126,4,68,36,100,20,84,52,116,12,76,44,108,28,92,60,124,8,72,40,104,24,88,56,120,16,80,48,112,32,96,64,128"
			End If 
			'Response.Write OrderNum
			Arrary_OrderNum = Split(OrderNum,",")

			If Not(Rs.Eof Or Rs.Bof) Then 
				Do Until Rs.Eof 
					ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&Rs("PlayerIDX")&"','"&Rs("UserName")&"','"&Rs("Team")&"','"&Rs("TeamNm")&"','"&Arrary_OrderNum(i)&"')"
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
'Response.End
	'============================================================================================================================================
	'1라운드 같은 학교 제외 Start ===============================================================================================================
	'============================================================================================================================================	
	'(총강수/2 = 1라운드수) < 동일학교참가명수
	If Lottery_Type = "1라운드제외" Then 



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
					RSQL = "SELECT PlayerIDX,UserName,Sportsdiary.dbo.FN_TeamNm('judo',TeamGb,Team) AS TeamNM  FROM Sportsdiary.dbo.tblRplayerMaster "
					RSQL = RSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
					RSQL = RSQL&" And DelYN='N'"
					RSQL = RSQL&" AND teamGb='"&TeamGb&"'"
					RSQL = RSQL&" AND Level='"&Level&"'"
					RSQL = RSQL&" AND Team='"&CRs("Team")&"'"
					RSQL = RSQL&" AND GroupGameGb='sd040001'"
					RSQL = RSQL&" Order By NewID()"
						
					Set RRs = Dbcon.Execute(RSQL)
							
					If Not (RRs.Eof Or RRs.Bof) Then 						
							If TotRound = "2" Then 
								OrderNum = "1,2"
							ElseIf TotRound = "4" Then 
								OrderNum = "1,3,2,4"
							ElseIf TotRound = "8" Then 
								OrderNum = "1,5,3,7,2,6,4,8"
							ElseIf TotRound = "16" Then 
								OrderNum = "1,9,5,13,3,11,7,15,2,10,6,14,4,12,8,16"
							ElseIf TotRound = "32" Then 
								OrderNum = "1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31,2,18,10,26,6,22,14,30,4,20,12,28,8,24,16,32"
							ElseIf TotRound = "64" Then 
							  OrderNum = "1,33,17,49,9,41,25,57,5,37,21,53,13,45,29,61,3,35,19,51,11,43,27,59,7,39,23,55,15,47,31,63,2,34,18,50,10,42,26,58,6,38,22,54,14,46,30,62,4,36,20,52,12,44,28,60,8,40,24,56,16,48,32,64"
							ElseIf TotRound = "128" Then 
								OrderNum = "1,65,33,97,17,81,49,113,9,73,41,105,25,89,57,121,5,69,37,101,21,85,53,117,13,77,45,109,29,93,61,125,3,67,35,99,19,83,51,115,11,75,43,107,27,91,59,123,7,71,39,103,23,87,55,119,15,79,47,111,31,95,63,127,"
								OrderNum = OrderNum&"2,66,34,98,18,82,50,114,10,74,42,106,26,90,58,122,6,70,38,102,22,86,54,118,14,78,46,110,30,94,62,126,4,68,36,100,20,84,52,116,12,76,44,108,28,92,60,124,8,72,40,104,24,88,56,120,16,80,48,112,32,96,64,128"
							End If 

							Arrary_OrderNum = Split(OrderNum,",")
							

							Do Until RRs.Eof 
'								
								If TotRound = "2" Then 
									If Arrary_OrderNum(i) = "1" Then 
										Position = "L1"
									Else
										Position = "R1"
									End If 
								ElseIf TotRound = "4" Then 
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Then 
										Position = "L1"
									Else
										Position = "R1"
									End If 
								ElseIf TotRound = "8" Then 
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Then 
										Position = "L1"
									ElseIf Arrary_OrderNum(i) = "3" Or Arrary_OrderNum(i) = "4" Then 
										Position = "L2"
									ElseIf Arrary_OrderNum(i) = "5" Or Arrary_OrderNum(i) = "6" Then 
										Position = "R1"
									ElseIf Arrary_OrderNum(i) = "7" Or Arrary_OrderNum(i) = "8" Then 
										Position = "R2"
									End If 
								ElseIf TotRound = "16" Then
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Or Arrary_OrderNum(i) = "3" Or Arrary_OrderNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_OrderNum(i) = "5" Or Arrary_OrderNum(i) = "6" Or Arrary_OrderNum(i) = "7" Or Arrary_OrderNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_OrderNum(i) = "9" Or Arrary_OrderNum(i) = "10" Or Arrary_OrderNum(i) = "11" Or Arrary_OrderNum(i) = "12" Then 
										Position = "R1"
									ElseIf Arrary_OrderNum(i) = "13" Or Arrary_OrderNum(i) = "14" Or Arrary_OrderNum(i) = "15" Or Arrary_OrderNum(i) = "16" Then 
										Position = "R2"
									End If 
								ElseIf TotRound = "32" Then 
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Or Arrary_OrderNum(i) = "3" Or Arrary_OrderNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_OrderNum(i) = "5" Or Arrary_OrderNum(i) = "6" Or Arrary_OrderNum(i) = "7" Or Arrary_OrderNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_OrderNum(i) = "9" Or Arrary_OrderNum(i) = "10" Or Arrary_OrderNum(i) = "11" Or Arrary_OrderNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_OrderNum(i) = "13" Or Arrary_OrderNum(i) = "14" Or Arrary_OrderNum(i) = "15" Or Arrary_OrderNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_OrderNum(i) = "17" Or Arrary_OrderNum(i) = "18" Or Arrary_OrderNum(i) = "19" Or Arrary_OrderNum(i) = "20" Then 
										Position = "R1"
									ElseIf Arrary_OrderNum(i) = "21" Or Arrary_OrderNum(i) = "22" Or Arrary_OrderNum(i) = "23" Or Arrary_OrderNum(i) = "24" Then 
										Position = "R2"
									ElseIf Arrary_OrderNum(i) = "25" Or Arrary_OrderNum(i) = "26" Or Arrary_OrderNum(i) = "27" Or Arrary_OrderNum(i) = "28" Then 
										Position = "R3"
									ElseIf Arrary_OrderNum(i) = "29" Or Arrary_OrderNum(i) = "30" Or Arrary_OrderNum(i) = "31" Or Arrary_OrderNum(i) = "32" Then 
										Position = "R4"
									End If 
								ElseIf TotRound = "64" Then 
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Or Arrary_OrderNum(i) = "3" Or Arrary_OrderNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_OrderNum(i) = "5" Or Arrary_OrderNum(i) = "6" Or Arrary_OrderNum(i) = "7" Or Arrary_OrderNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_OrderNum(i) = "9" Or Arrary_OrderNum(i) = "10" Or Arrary_OrderNum(i) = "11" Or Arrary_OrderNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_OrderNum(i) = "13" Or Arrary_OrderNum(i) = "14" Or Arrary_OrderNum(i) = "15" Or Arrary_OrderNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_OrderNum(i) = "17" Or Arrary_OrderNum(i) = "18" Or Arrary_OrderNum(i) = "19" Or Arrary_OrderNum(i) = "20" Then 
										Position = "L5"
									ElseIf Arrary_OrderNum(i) = "21" Or Arrary_OrderNum(i) = "22" Or Arrary_OrderNum(i) = "23" Or Arrary_OrderNum(i) = "24" Then 
										Position = "L6"
									ElseIf Arrary_OrderNum(i) = "25" Or Arrary_OrderNum(i) = "26" Or Arrary_OrderNum(i) = "27" Or Arrary_OrderNum(i) = "28" Then 
										Position = "L7"
									ElseIf Arrary_OrderNum(i) = "29" Or Arrary_OrderNum(i) = "30" Or Arrary_OrderNum(i) = "31" Or Arrary_OrderNum(i) = "32" Then 
										Position = "L8"
									ElseIf Arrary_OrderNum(i) = "33" Or Arrary_OrderNum(i) = "34" Or Arrary_OrderNum(i) = "35" Or Arrary_OrderNum(i) = "36" Then 
										Position = "R1"
									ElseIf Arrary_OrderNum(i) = "37" Or Arrary_OrderNum(i) = "38" Or Arrary_OrderNum(i) = "39" Or Arrary_OrderNum(i) = "40" Then 
										Position = "R2"
									ElseIf Arrary_OrderNum(i) = "41" Or Arrary_OrderNum(i) = "42" Or Arrary_OrderNum(i) = "43" Or Arrary_OrderNum(i) = "44" Then 
										Position = "R3"
									ElseIf Arrary_OrderNum(i) = "45" Or Arrary_OrderNum(i) = "46" Or Arrary_OrderNum(i) = "47" Or Arrary_OrderNum(i) = "48" Then 
										Position = "R4"
									ElseIf Arrary_OrderNum(i) = "49" Or Arrary_OrderNum(i) = "50" Or Arrary_OrderNum(i) = "51" Or Arrary_OrderNum(i) = "52" Then 
										Position = "R5"
									ElseIf Arrary_OrderNum(i) = "53" Or Arrary_OrderNum(i) = "54" Or Arrary_OrderNum(i) = "55" Or Arrary_OrderNum(i) = "56" Then 
										Position = "R6"
									ElseIf Arrary_OrderNum(i) = "57" Or Arrary_OrderNum(i) = "58" Or Arrary_OrderNum(i) = "59" Or Arrary_OrderNum(i) = "60" Then 
										Position = "R7"
									ElseIf Arrary_OrderNum(i) = "61" Or Arrary_OrderNum(i) = "62" Or Arrary_OrderNum(i) = "63" Or Arrary_OrderNum(i) = "64" Then 
										Position = "R8"
									End If 
								ElseIf TotRound = "128" Then 
									If Arrary_OrderNum(i) = "1" Or Arrary_OrderNum(i) = "2" Or Arrary_OrderNum(i) = "3" Or Arrary_OrderNum(i) = "4" Then 
										Position = "L1"
									ElseIf Arrary_OrderNum(i) = "5" Or Arrary_OrderNum(i) = "6" Or Arrary_OrderNum(i) = "7" Or Arrary_OrderNum(i) = "8" Then 
										Position = "L2"
									ElseIf Arrary_OrderNum(i) = "9" Or Arrary_OrderNum(i) = "10" Or Arrary_OrderNum(i) = "11" Or Arrary_OrderNum(i) = "12" Then 
										Position = "L3"
									ElseIf Arrary_OrderNum(i) = "13" Or Arrary_OrderNum(i) = "14" Or Arrary_OrderNum(i) = "15" Or Arrary_OrderNum(i) = "16" Then 
										Position = "L4"
									ElseIf Arrary_OrderNum(i) = "17" Or Arrary_OrderNum(i) = "18" Or Arrary_OrderNum(i) = "19" Or Arrary_OrderNum(i) = "20" Then 
										Position = "L5"
									ElseIf Arrary_OrderNum(i) = "21" Or Arrary_OrderNum(i) = "22" Or Arrary_OrderNum(i) = "23" Or Arrary_OrderNum(i) = "24" Then 
										Position = "L6"
									ElseIf Arrary_OrderNum(i) = "25" Or Arrary_OrderNum(i) = "26" Or Arrary_OrderNum(i) = "27" Or Arrary_OrderNum(i) = "28" Then 
										Position = "L7"
									ElseIf Arrary_OrderNum(i) = "29" Or Arrary_OrderNum(i) = "30" Or Arrary_OrderNum(i) = "31" Or Arrary_OrderNum(i) = "32" Then 
										Position = "L8"
									ElseIf Arrary_OrderNum(i) = "33" Or Arrary_OrderNum(i) = "34" Or Arrary_OrderNum(i) = "35" Or Arrary_OrderNum(i) = "36" Then 
										Position = "L9"
									ElseIf Arrary_OrderNum(i) = "37" Or Arrary_OrderNum(i) = "38" Or Arrary_OrderNum(i) = "39" Or Arrary_OrderNum(i) = "40" Then 
										Position = "L10"
									ElseIf Arrary_OrderNum(i) = "41" Or Arrary_OrderNum(i) = "42" Or Arrary_OrderNum(i) = "43" Or Arrary_OrderNum(i) = "44" Then 
										Position = "L11"
									ElseIf Arrary_OrderNum(i) = "45" Or Arrary_OrderNum(i) = "46" Or Arrary_OrderNum(i) = "47" Or Arrary_OrderNum(i) = "48" Then 
										Position = "L12"
									ElseIf Arrary_OrderNum(i) = "49" Or Arrary_OrderNum(i) = "50" Or Arrary_OrderNum(i) = "51" Or Arrary_OrderNum(i) = "52" Then 
										Position = "L13"
									ElseIf Arrary_OrderNum(i) = "53" Or Arrary_OrderNum(i) = "54" Or Arrary_OrderNum(i) = "55" Or Arrary_OrderNum(i) = "56" Then 
										Position = "L14"
									ElseIf Arrary_OrderNum(i) = "57" Or Arrary_OrderNum(i) = "58" Or Arrary_OrderNum(i) = "59" Or Arrary_OrderNum(i) = "60" Then 
										Position = "L15"
									ElseIf Arrary_OrderNum(i) = "61" Or Arrary_OrderNum(i) = "62" Or Arrary_OrderNum(i) = "63" Or Arrary_OrderNum(i) = "64" Then 
										Position = "L16"
									ElseIf Arrary_OrderNum(i) = "65" Or Arrary_OrderNum(i) = "66" Or Arrary_OrderNum(i) = "67" Or Arrary_OrderNum(i) = "68" Then 
										Position = "R1"
									ElseIf Arrary_OrderNum(i) = "69" Or Arrary_OrderNum(i) = "70" Or Arrary_OrderNum(i) = "71" Or Arrary_OrderNum(i) = "72" Then 
										Position = "R2"
									ElseIf Arrary_OrderNum(i) = "73" Or Arrary_OrderNum(i) = "74" Or Arrary_OrderNum(i) = "75" Or Arrary_OrderNum(i) = "76" Then 
										Position = "R3"
									ElseIf Arrary_OrderNum(i) = "77" Or Arrary_OrderNum(i) = "78" Or Arrary_OrderNum(i) = "79" Or Arrary_OrderNum(i) = "80" Then 
										Position = "R4"
									ElseIf Arrary_OrderNum(i) = "81" Or Arrary_OrderNum(i) = "82" Or Arrary_OrderNum(i) = "83" Or Arrary_OrderNum(i) = "84" Then 
										Position = "R5"
									ElseIf Arrary_OrderNum(i) = "85" Or Arrary_OrderNum(i) = "86" Or Arrary_OrderNum(i) = "87" Or Arrary_OrderNum(i) = "88" Then 
										Position = "R6"
									ElseIf Arrary_OrderNum(i) = "89" Or Arrary_OrderNum(i) = "90" Or Arrary_OrderNum(i) = "91" Or Arrary_OrderNum(i) = "92" Then 
										Position = "R7"
									ElseIf Arrary_OrderNum(i) = "93" Or Arrary_OrderNum(i) = "94" Or Arrary_OrderNum(i) = "95" Or Arrary_OrderNum(i) = "96" Then 
										Position = "R8"
									ElseIf Arrary_OrderNum(i) = "97" Or Arrary_OrderNum(i) = "98" Or Arrary_OrderNum(i) = "99" Or Arrary_OrderNum(i) = "100" Then 
										Position = "R9"
									ElseIf Arrary_OrderNum(i) = "101" Or Arrary_OrderNum(i) = "102" Or Arrary_OrderNum(i) = "103" Or Arrary_OrderNum(i) = "104" Then 
										Position = "R10"
									ElseIf Arrary_OrderNum(i) = "105" Or Arrary_OrderNum(i) = "106" Or Arrary_OrderNum(i) = "107" Or Arrary_OrderNum(i) = "108" Then 
										Position = "R11"
									ElseIf Arrary_OrderNum(i) = "109" Or Arrary_OrderNum(i) = "110" Or Arrary_OrderNum(i) = "111" Or Arrary_OrderNum(i) = "112" Then 
										Position = "R12"
									ElseIf Arrary_OrderNum(i) = "113" Or Arrary_OrderNum(i) = "114" Or Arrary_OrderNum(i) = "115" Or Arrary_OrderNum(i) = "116" Then 
										Position = "R13"
									ElseIf Arrary_OrderNum(i) = "117" Or Arrary_OrderNum(i) = "118" Or Arrary_OrderNum(i) = "119" Or Arrary_OrderNum(i) = "120" Then 
										Position = "R14"
									ElseIf Arrary_OrderNum(i) = "121" Or Arrary_OrderNum(i) = "122" Or Arrary_OrderNum(i) = "123" Or Arrary_OrderNum(i) = "124" Then 
										Position = "R15"
									ElseIf Arrary_OrderNum(i) = "125" Or Arrary_OrderNum(i) = "126" Or Arrary_OrderNum(i) = "127" Or Arrary_OrderNum(i) = "128" Then 
										Position = "R16"
									End If 
								End If 
								

'								Response.Write RRs("PlayerIDX")&","&RRs("UserName")&","&RRs("TeamNM")&array_aa(i)&"<br>"
								ISQL = "INSERT INTO Sportsdiary.dbo.tblLottery_Tmp (GameTitleIDX,TeamGb,Level,PlayerIDX,UserName,Team,TeamNm,OrderNum,Position) VALUES ('"&GameTitleIDX&"','"&TeamGb&"','"&Level&"','"&RRs("PlayerIDX")&"','"&RRs("UserName")&"','"&CRs("Team")&"','"&RRs("TeamNm")&"','"&Arrary_OrderNum(i)&"','"&Position&"')"
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


	End If 
	'============================================================================================================================================
	'시트추첨 Start =============================================================================================================================
	'============================================================================================================================================
	Response.Write RetData



%>