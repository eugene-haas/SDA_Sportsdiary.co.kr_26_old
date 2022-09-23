<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDX  = fInject(Request("GameTitleIDX"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	Level         = fInject(Request("Level"))
	TeamGb        = fInject(Request("TeamGb"))
	Sex           = fInject(Request("Sex"))
	TotRound      = fInject(Request("TotRound"))
	pair_cnt      = fInject(Request("pair_cnt"))
	R2_Cnt        = fInject(Request("R2_Cnt"))
	R3_Cnt        = fInject(Request("R3_Cnt"))
	R4_Cnt        = fInject(Request("R4_Cnt"))
	R5_Cnt        = fInject(Request("R5_Cnt"))
	R6_Cnt        = fInject(Request("R6_Cnt"))

	'대회 강수 TotRound
'	Response.Write GameTitleIDX&"<br>"
'	Response.Write RGameLevelIDX&"<br>"
'	Response.Write TotRound&"<br>"
'	Response.Write pair_cnt&"<br>"
'	Response.Write R2_Cnt&"<br>"
'	Response.Write R3_Cnt&"<br>"
'	Response.Write R4_Cnt&"<br>"
'	Response.Write R5_Cnt&"<br>"
'	Response.Write R6_Cnt&"<br>"


	Player1  = fInject(Request("Player1"))
	Player2  = fInject(Request("Player2"))
	Player3  = fInject(Request("Player3"))
	Player4  = fInject(Request("Player4"))
	Player5  = fInject(Request("Player5"))
	Player6  = fInject(Request("Player6"))
	Player7  = fInject(Request("Player7"))
	Player8  = fInject(Request("Player8"))
	Player9  = fInject(Request("Player9"))
	Player10 = fInject(Request("Player10"))
	Player11 = fInject(Request("Player11"))
	Player12 = fInject(Request("Player12"))
	Player13 = fInject(Request("Player13"))
	Player14 = fInject(Request("Player14"))
	Player15 = fInject(Request("Player15"))
	Player16 = fInject(Request("Player16"))
	Player17 = fInject(Request("Player17"))
	Player18 = fInject(Request("Player18"))
	Player19 = fInject(Request("Player19"))
	Player20 = fInject(Request("Player20"))
	Player21 = fInject(Request("Player21"))
	Player22 = fInject(Request("Player22"))
	Player23 = fInject(Request("Player23"))
	Player24 = fInject(Request("Player24"))
	Player25 = fInject(Request("Player25"))
	Player26 = fInject(Request("Player26"))
	Player27 = fInject(Request("Player27"))
	Player28 = fInject(Request("Player28"))
	Player29 = fInject(Request("Player29"))
	Player30 = fInject(Request("Player30"))
	Player31 = fInject(Request("Player31"))
	Player32 = fInject(Request("Player32"))

	Player33 = fInject(Request("Player33"))
	Player34 = fInject(Request("Player34"))
	Player35 = fInject(Request("Player35"))
	Player36 = fInject(Request("Player36"))
	Player37 = fInject(Request("Player37"))
	Player38 = fInject(Request("Player38"))
	Player39 = fInject(Request("Player39"))
	Player40 = fInject(Request("Player40"))
	Player41 = fInject(Request("Player41"))
	Player42 = fInject(Request("Player42"))
	Player43 = fInject(Request("Player43"))
	Player44 = fInject(Request("Player44"))
	Player45 = fInject(Request("Player45"))
	Player46 = fInject(Request("Player46"))
	Player47 = fInject(Request("Player47"))
	Player48 = fInject(Request("Player48"))
	Player49 = fInject(Request("Player49"))
	Player50 = fInject(Request("Player50"))
	Player51 = fInject(Request("Player51"))
	Player52 = fInject(Request("Player52"))
	Player53 = fInject(Request("Player53"))
	Player54 = fInject(Request("Player54"))
	Player55 = fInject(Request("Player55"))
	Player56 = fInject(Request("Player56"))
	Player57 = fInject(Request("Player57"))
	Player58 = fInject(Request("Player58"))
	Player59 = fInject(Request("Player59"))
	Player60 = fInject(Request("Player60"))
	Player61 = fInject(Request("Player61"))
	Player62 = fInject(Request("Player62"))
	Player63 = fInject(Request("Player63"))
	Player64 = fInject(Request("Player64"))





	Hidden_Data1  = fInject(Request("Hidden_Data1"))
	Hidden_Data2  = fInject(Request("Hidden_Data2"))
	Hidden_Data3  = fInject(Request("Hidden_Data3"))
	Hidden_Data4  = fInject(Request("Hidden_Data4"))
	Hidden_Data5  = fInject(Request("Hidden_Data5"))
	Hidden_Data6  = fInject(Request("Hidden_Data6"))
	Hidden_Data7  = fInject(Request("Hidden_Data7"))
	Hidden_Data8  = fInject(Request("Hidden_Data8"))
	Hidden_Data9  = fInject(Request("Hidden_Data9"))
	Hidden_Data10 = fInject(Request("Hidden_Data10"))
	Hidden_Data11 = fInject(Request("Hidden_Data11"))
	Hidden_Data12 = fInject(Request("Hidden_Data12"))
	Hidden_Data13 = fInject(Request("Hidden_Data13"))
	Hidden_Data14 = fInject(Request("Hidden_Data14"))
	Hidden_Data15 = fInject(Request("Hidden_Data15"))
	Hidden_Data16 = fInject(Request("Hidden_Data16"))
	Hidden_Data17 = fInject(Request("Hidden_Data17"))
	Hidden_Data18 = fInject(Request("Hidden_Data18"))
	Hidden_Data19 = fInject(Request("Hidden_Data19"))
	Hidden_Data20 = fInject(Request("Hidden_Data20"))
	Hidden_Data21 = fInject(Request("Hidden_Data21"))
	Hidden_Data22 = fInject(Request("Hidden_Data22"))
	Hidden_Data23 = fInject(Request("Hidden_Data23"))
	Hidden_Data24 = fInject(Request("Hidden_Data24"))
	Hidden_Data25 = fInject(Request("Hidden_Data25"))
	Hidden_Data26 = fInject(Request("Hidden_Data26"))
	Hidden_Data27 = fInject(Request("Hidden_Data27"))
	Hidden_Data28 = fInject(Request("Hidden_Data28"))
	Hidden_Data29 = fInject(Request("Hidden_Data29"))
	Hidden_Data30 = fInject(Request("Hidden_Data30"))
	Hidden_Data31 = fInject(Request("Hidden_Data31"))
	Hidden_Data32 = fInject(Request("Hidden_Data32"))
	Hidden_Data33 = fInject(Request("Hidden_Data33"))
	Hidden_Data34 = fInject(Request("Hidden_Data34"))
	Hidden_Data35 = fInject(Request("Hidden_Data35"))
	Hidden_Data36 = fInject(Request("Hidden_Data36"))
	Hidden_Data37 = fInject(Request("Hidden_Data37"))
	Hidden_Data38 = fInject(Request("Hidden_Data38"))
	Hidden_Data39 = fInject(Request("Hidden_Data39"))
	Hidden_Data40 = fInject(Request("Hidden_Data40"))
	Hidden_Data41 = fInject(Request("Hidden_Data41"))
	Hidden_Data42 = fInject(Request("Hidden_Data42"))
	Hidden_Data43 = fInject(Request("Hidden_Data43"))
	Hidden_Data44 = fInject(Request("Hidden_Data44"))
	Hidden_Data45 = fInject(Request("Hidden_Data45"))
	Hidden_Data46 = fInject(Request("Hidden_Data46"))
	Hidden_Data47 = fInject(Request("Hidden_Data47"))
	Hidden_Data48 = fInject(Request("Hidden_Data48"))
	Hidden_Data49 = fInject(Request("Hidden_Data49"))
	Hidden_Data50 = fInject(Request("Hidden_Data50"))
	Hidden_Data51 = fInject(Request("Hidden_Data51"))
	Hidden_Data52 = fInject(Request("Hidden_Data52"))
	Hidden_Data53 = fInject(Request("Hidden_Data53"))
	Hidden_Data54 = fInject(Request("Hidden_Data54"))
	Hidden_Data55 = fInject(Request("Hidden_Data55"))
	Hidden_Data56 = fInject(Request("Hidden_Data56"))
	Hidden_Data57 = fInject(Request("Hidden_Data57"))
	Hidden_Data58 = fInject(Request("Hidden_Data58"))
	Hidden_Data59 = fInject(Request("Hidden_Data59"))
	Hidden_Data60 = fInject(Request("Hidden_Data60"))
	Hidden_Data61 = fInject(Request("Hidden_Data61"))
	Hidden_Data62 = fInject(Request("Hidden_Data62"))
	Hidden_Data63 = fInject(Request("Hidden_Data63"))
	Hidden_Data64 = fInject(Request("Hidden_Data64"))



	

	R1_Num1   = fInject(Request("R1_Num1"))
	R1_Num2   = fInject(Request("R1_Num2"))
	R1_Num3   = fInject(Request("R1_Num3"))
	R1_Num4   = fInject(Request("R1_Num4"))
	R1_Num5   = fInject(Request("R1_Num5"))
	R1_Num6   = fInject(Request("R1_Num6"))
	R1_Num7   = fInject(Request("R1_Num7"))
	R1_Num8   = fInject(Request("R1_Num8"))
	R1_Num9   = fInject(Request("R1_Num9"))
	R1_Num10  = fInject(Request("R1_Num10"))
	R1_Num11  = fInject(Request("R1_Num11"))
	R1_Num12  = fInject(Request("R1_Num12"))
	R1_Num13  = fInject(Request("R1_Num13"))
	R1_Num14  = fInject(Request("R1_Num14"))
	R1_Num15  = fInject(Request("R1_Num15"))
	R1_Num16  = fInject(Request("R1_Num16"))

	R1_Num17  = fInject(Request("R1_Num17"))
	R1_Num18  = fInject(Request("R1_Num18"))
	R1_Num19  = fInject(Request("R1_Num19"))
	R1_Num20  = fInject(Request("R1_Num20"))
	R1_Num21  = fInject(Request("R1_Num21"))
	R1_Num22  = fInject(Request("R1_Num22"))
	R1_Num23  = fInject(Request("R1_Num23"))
	R1_Num24  = fInject(Request("R1_Num24"))
	R1_Num25  = fInject(Request("R1_Num25"))
	R1_Num26  = fInject(Request("R1_Num26"))
	R1_Num27  = fInject(Request("R1_Num27"))
	R1_Num28  = fInject(Request("R1_Num28"))
	R1_Num29  = fInject(Request("R1_Num29"))
	R1_Num30  = fInject(Request("R1_Num30"))
	R1_Num31  = fInject(Request("R1_Num31"))
	R1_Num32  = fInject(Request("R1_Num32"))

	R2_Num1   = fInject(Request("R2_Num1"))
	R2_Num2   = fInject(Request("R2_Num2"))
	R2_Num3   = fInject(Request("R2_Num3"))
	R2_Num4   = fInject(Request("R2_Num4"))
	R2_Num5   = fInject(Request("R2_Num5"))
	R2_Num6   = fInject(Request("R2_Num6"))
	R2_Num7   = fInject(Request("R2_Num7"))
	R2_Num8   = fInject(Request("R2_Num8"))
	R2_Num9   = fInject(Request("R2_Num9"))
	R2_Num10  = fInject(Request("R2_Num10"))
	R2_Num11  = fInject(Request("R2_Num11"))
	R2_Num12  = fInject(Request("R2_Num12"))
	R2_Num13  = fInject(Request("R2_Num13"))
	R2_Num14  = fInject(Request("R2_Num14"))
	R2_Num15  = fInject(Request("R2_Num15"))
	R2_Num16  = fInject(Request("R2_Num16"))

	R3_Num1  = fInject(Request("R3_Num1"))
	R3_Num2  = fInject(Request("R3_Num2"))
	R3_Num3  = fInject(Request("R3_Num3"))
	R3_Num4  = fInject(Request("R3_Num4"))
	R3_Num5  = fInject(Request("R3_Num5"))
	R3_Num6  = fInject(Request("R3_Num6"))
	R3_Num7  = fInject(Request("R3_Num7"))
	R3_Num8  = fInject(Request("R3_Num8"))

	R4_Num1  = fInject(Request("R4_Num1"))
	R4_Num2  = fInject(Request("R4_Num2"))
	R4_Num3  = fInject(Request("R4_Num3"))
	R4_Num4  = fInject(Request("R4_Num4"))

	R5_Num1  = fInject(Request("R5_Num1"))
	R5_Num2  = fInject(Request("R5_Num2"))

	R6_Num1  = R5_Num2+1





	'Response.Write Hidden_Data1&"<br>"


	'기존 데이터 체크
	ChkSQL = "SELECT "
	ChkSQL = ChkSQL&" Count(RPlayerIDX) AS Cnt"
	ChkSQL = ChkSQL&" From Sportsdiary.dbo.tblRPlayer"
	ChkSQL = ChkSQL&" Where GameTitleIDX='"&GameTitleIDX&"'"
	ChkSQL = ChkSQL&" AND RGameLevelidx='"&RGameLevelidx&"'"
	Set CRs = Dbcon.Execute(chkSQL)

	If CRs("Cnt") > 0 Then 
		DelSQL = "Delete From tblRPlayer Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
		Dbcon.Execute(DelSQL)			
	End If 




	'sd042001 일반전 sd042002 부전승
	'왼쪽오른쪽 sd030001 왼 sd030002 오
	'개인전 'sd040001' 단체전 sd040002

	'=========================================================  왼쪽데이터 ===============================================================================	
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  왼쪽데이터 ===============================================================================
	If Hidden_Data1 <> "" And Hidden_Data2 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data2&"','judo','"&GameTitleIDX&"','','"&Player2&"','"&Level&"','"&TeamGb&"','"&Sex&"','102','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042002','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data3 <> "" And Hidden_Data4 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data4&"','judo','"&GameTitleIDX&"','','"&Player4&"','"&Level&"','"&TeamGb&"','"&Sex&"','104','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042002','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data5 <> "" And Hidden_Data6 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042001','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data6&"','judo','"&GameTitleIDX&"','','"&Player6&"','"&Level&"','"&TeamGb&"','"&Sex&"','106','sd042001','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042002','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data7 <> "" And Hidden_Data8 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042001','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data8&"','judo','"&GameTitleIDX&"','','"&Player8&"','"&Level&"','"&TeamGb&"','"&Sex&"','108','sd042001','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042002','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data9 <> "" And Hidden_Data10 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data9&"','judo','"&GameTitleIDX&"','','"&Player9&"','"&Level&"','"&TeamGb&"','"&Sex&"','109','sd042001','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data10&"','judo','"&GameTitleIDX&"','','"&Player10&"','"&Level&"','"&TeamGb&"','"&Sex&"','110','sd042001','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data9&"','judo','"&GameTitleIDX&"','','"&Player9&"','"&Level&"','"&TeamGb&"','"&Sex&"','109','sd042002','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data11 <> "" And Hidden_Data12 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data11&"','judo','"&GameTitleIDX&"','','"&Player11&"','"&Level&"','"&TeamGb&"','"&Sex&"','111','sd042001','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data12&"','judo','"&GameTitleIDX&"','','"&Player12&"','"&Level&"','"&TeamGb&"','"&Sex&"','112','sd042001','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data11&"','judo','"&GameTitleIDX&"','','"&Player11&"','"&Level&"','"&TeamGb&"','"&Sex&"','111','sd042002','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data13 <> "" And Hidden_Data14 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data13&"','judo','"&GameTitleIDX&"','','"&Player13&"','"&Level&"','"&TeamGb&"','"&Sex&"','113','sd042001','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data14&"','judo','"&GameTitleIDX&"','','"&Player14&"','"&Level&"','"&TeamGb&"','"&Sex&"','114','sd042001','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data13&"','judo','"&GameTitleIDX&"','','"&Player13&"','"&Level&"','"&TeamGb&"','"&Sex&"','113','sd042002','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data15 <> "" And Hidden_Data16 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data15&"','judo','"&GameTitleIDX&"','','"&Player15&"','"&Level&"','"&TeamGb&"','"&Sex&"','115','sd042001','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data16&"','judo','"&GameTitleIDX&"','','"&Player16&"','"&Level&"','"&TeamGb&"','"&Sex&"','116','sd042001','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data15&"','judo','"&GameTitleIDX&"','','"&Player15&"','"&Level&"','"&TeamGb&"','"&Sex&"','115','sd042002','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	

	If Hidden_Data17 <> "" And Hidden_Data18 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data17&"','judo','"&GameTitleIDX&"','','"&Player17&"','"&Level&"','"&TeamGb&"','"&Sex&"','117','sd042001','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data18&"','judo','"&GameTitleIDX&"','','"&Player18&"','"&Level&"','"&TeamGb&"','"&Sex&"','118','sd042001','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data17&"','judo','"&GameTitleIDX&"','','"&Player17&"','"&Level&"','"&TeamGb&"','"&Sex&"','117','sd042002','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data19 <> "" And Hidden_Data20 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data19&"','judo','"&GameTitleIDX&"','','"&Player19&"','"&Level&"','"&TeamGb&"','"&Sex&"','119','sd042001','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data20&"','judo','"&GameTitleIDX&"','','"&Player20&"','"&Level&"','"&TeamGb&"','"&Sex&"','120','sd042001','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data19&"','judo','"&GameTitleIDX&"','','"&Player19&"','"&Level&"','"&TeamGb&"','"&Sex&"','119','sd042002','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data21 <> "" And Hidden_Data22 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data21&"','judo','"&GameTitleIDX&"','','"&Player21&"','"&Level&"','"&TeamGb&"','"&Sex&"','121','sd042001','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data22&"','judo','"&GameTitleIDX&"','','"&Player22&"','"&Level&"','"&TeamGb&"','"&Sex&"','122','sd042001','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data21&"','judo','"&GameTitleIDX&"','','"&Player21&"','"&Level&"','"&TeamGb&"','"&Sex&"','121','sd042002','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data23 <> "" And Hidden_Data24 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data23&"','judo','"&GameTitleIDX&"','','"&Player23&"','"&Level&"','"&TeamGb&"','"&Sex&"','123','sd042001','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data24&"','judo','"&GameTitleIDX&"','','"&Player24&"','"&Level&"','"&TeamGb&"','"&Sex&"','124','sd042001','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data23&"','judo','"&GameTitleIDX&"','','"&Player23&"','"&Level&"','"&TeamGb&"','"&Sex&"','123','sd042002','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data25 <> "" And Hidden_Data26 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data25&"','judo','"&GameTitleIDX&"','','"&Player25&"','"&Level&"','"&TeamGb&"','"&Sex&"','125','sd042001','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data26&"','judo','"&GameTitleIDX&"','','"&Player26&"','"&Level&"','"&TeamGb&"','"&Sex&"','126','sd042001','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data25&"','judo','"&GameTitleIDX&"','','"&Player25&"','"&Level&"','"&TeamGb&"','"&Sex&"','125','sd042002','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data27 <> "" And Hidden_Data28 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data27&"','judo','"&GameTitleIDX&"','','"&Player27&"','"&Level&"','"&TeamGb&"','"&Sex&"','127','sd042001','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data28&"','judo','"&GameTitleIDX&"','','"&Player28&"','"&Level&"','"&TeamGb&"','"&Sex&"','128','sd042001','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data27&"','judo','"&GameTitleIDX&"','','"&Player27&"','"&Level&"','"&TeamGb&"','"&Sex&"','127','sd042002','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data29 <> "" And Hidden_Data30 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data29&"','judo','"&GameTitleIDX&"','','"&Player29&"','"&Level&"','"&TeamGb&"','"&Sex&"','129','sd042001','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data30&"','judo','"&GameTitleIDX&"','','"&Player30&"','"&Level&"','"&TeamGb&"','"&Sex&"','130','sd042001','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data29&"','judo','"&GameTitleIDX&"','','"&Player29&"','"&Level&"','"&TeamGb&"','"&Sex&"','129','sd042002','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data31 <> "" And Hidden_Data32 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data31&"','judo','"&GameTitleIDX&"','','"&Player31&"','"&Level&"','"&TeamGb&"','"&Sex&"','131','sd042001','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data32&"','judo','"&GameTitleIDX&"','','"&Player32&"','"&Level&"','"&TeamGb&"','"&Sex&"','132','sd042001','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data31&"','judo','"&GameTitleIDX&"','','"&Player31&"','"&Level&"','"&TeamGb&"','"&Sex&"','131','sd042002','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	
	'=========================================================  왼쪽데이터 ===============================================================================	
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	If Hidden_Data33 <> "" And Hidden_Data34 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data33&"','judo','"&GameTitleIDX&"','','"&Player33&"','"&Level&"','"&TeamGb&"','"&Sex&"','133','sd042001','sd030002','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data34&"','judo','"&GameTitleIDX&"','','"&Player34&"','"&Level&"','"&TeamGb&"','"&Sex&"','134','sd042001','sd030002','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data33&"','judo','"&GameTitleIDX&"','','"&Player33&"','"&Level&"','"&TeamGb&"','"&Sex&"','133','sd042002','sd030002','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data35 <> "" And Hidden_Data36 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data35&"','judo','"&GameTitleIDX&"','','"&Player35&"','"&Level&"','"&TeamGb&"','"&Sex&"','135','sd042001','sd030002','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data36&"','judo','"&GameTitleIDX&"','','"&Player36&"','"&Level&"','"&TeamGb&"','"&Sex&"','136','sd042001','sd030002','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data35&"','judo','"&GameTitleIDX&"','','"&Player35&"','"&Level&"','"&TeamGb&"','"&Sex&"','135','sd042002','sd030002','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data37 <> "" And Hidden_Data38 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data37&"','judo','"&GameTitleIDX&"','','"&Player37&"','"&Level&"','"&TeamGb&"','"&Sex&"','137','sd042001','sd030002','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data38&"','judo','"&GameTitleIDX&"','','"&Player38&"','"&Level&"','"&TeamGb&"','"&Sex&"','138','sd042001','sd030002','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data37&"','judo','"&GameTitleIDX&"','','"&Player37&"','"&Level&"','"&TeamGb&"','"&Sex&"','137','sd042002','sd030002','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data39 <> "" And Hidden_Data40 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data39&"','judo','"&GameTitleIDX&"','','"&Player39&"','"&Level&"','"&TeamGb&"','"&Sex&"','139','sd042001','sd030002','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data40&"','judo','"&GameTitleIDX&"','','"&Player40&"','"&Level&"','"&TeamGb&"','"&Sex&"','140','sd042001','sd030002','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data39&"','judo','"&GameTitleIDX&"','','"&Player39&"','"&Level&"','"&TeamGb&"','"&Sex&"','139','sd042002','sd030002','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data41 <> "" And Hidden_Data42 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data41&"','judo','"&GameTitleIDX&"','','"&Player41&"','"&Level&"','"&TeamGb&"','"&Sex&"','141','sd042001','sd030002','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data42&"','judo','"&GameTitleIDX&"','','"&Player42&"','"&Level&"','"&TeamGb&"','"&Sex&"','142','sd042001','sd030002','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data41&"','judo','"&GameTitleIDX&"','','"&Player41&"','"&Level&"','"&TeamGb&"','"&Sex&"','141','sd042002','sd030002','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data43 <> "" And Hidden_Data44 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data43&"','judo','"&GameTitleIDX&"','','"&Player43&"','"&Level&"','"&TeamGb&"','"&Sex&"','143','sd042001','sd030002','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data44&"','judo','"&GameTitleIDX&"','','"&Player44&"','"&Level&"','"&TeamGb&"','"&Sex&"','144','sd042001','sd030002','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data43&"','judo','"&GameTitleIDX&"','','"&Player43&"','"&Level&"','"&TeamGb&"','"&Sex&"','143','sd042002','sd030002','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data45 <> "" And Hidden_Data46 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data45&"','judo','"&GameTitleIDX&"','','"&Player45&"','"&Level&"','"&TeamGb&"','"&Sex&"','145','sd042001','sd030002','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data46&"','judo','"&GameTitleIDX&"','','"&Player46&"','"&Level&"','"&TeamGb&"','"&Sex&"','146','sd042001','sd030002','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data45&"','judo','"&GameTitleIDX&"','','"&Player45&"','"&Level&"','"&TeamGb&"','"&Sex&"','145','sd042002','sd030002','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data47 <> "" And Hidden_Data48 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data47&"','judo','"&GameTitleIDX&"','','"&Player47&"','"&Level&"','"&TeamGb&"','"&Sex&"','147','sd042001','sd030002','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data48&"','judo','"&GameTitleIDX&"','','"&Player48&"','"&Level&"','"&TeamGb&"','"&Sex&"','148','sd042001','sd030002','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data47&"','judo','"&GameTitleIDX&"','','"&Player47&"','"&Level&"','"&TeamGb&"','"&Sex&"','147','sd042002','sd030002','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	

	If Hidden_Data49 <> "" And Hidden_Data50 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data49&"','judo','"&GameTitleIDX&"','','"&Player49&"','"&Level&"','"&TeamGb&"','"&Sex&"','149','sd042001','sd030002','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data50&"','judo','"&GameTitleIDX&"','','"&Player50&"','"&Level&"','"&TeamGb&"','"&Sex&"','150','sd042001','sd030002','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data49&"','judo','"&GameTitleIDX&"','','"&Player49&"','"&Level&"','"&TeamGb&"','"&Sex&"','149','sd042002','sd030002','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data51 <> "" And Hidden_Data52 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data51&"','judo','"&GameTitleIDX&"','','"&Player51&"','"&Level&"','"&TeamGb&"','"&Sex&"','151','sd042001','sd030002','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data52&"','judo','"&GameTitleIDX&"','','"&Player52&"','"&Level&"','"&TeamGb&"','"&Sex&"','152','sd042001','sd030002','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data51&"','judo','"&GameTitleIDX&"','','"&Player51&"','"&Level&"','"&TeamGb&"','"&Sex&"','151','sd042002','sd030002','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data53 <> "" And Hidden_Data54 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data53&"','judo','"&GameTitleIDX&"','','"&Player53&"','"&Level&"','"&TeamGb&"','"&Sex&"','153','sd042001','sd030002','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data54&"','judo','"&GameTitleIDX&"','','"&Player54&"','"&Level&"','"&TeamGb&"','"&Sex&"','154','sd042001','sd030002','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data53&"','judo','"&GameTitleIDX&"','','"&Player53&"','"&Level&"','"&TeamGb&"','"&Sex&"','153','sd042002','sd030002','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data55 <> "" And Hidden_Data56 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data55&"','judo','"&GameTitleIDX&"','','"&Player55&"','"&Level&"','"&TeamGb&"','"&Sex&"','155','sd042001','sd030002','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data56&"','judo','"&GameTitleIDX&"','','"&Player56&"','"&Level&"','"&TeamGb&"','"&Sex&"','156','sd042001','sd030002','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data55&"','judo','"&GameTitleIDX&"','','"&Player55&"','"&Level&"','"&TeamGb&"','"&Sex&"','155','sd042002','sd030002','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data57 <> "" And Hidden_Data58 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data57&"','judo','"&GameTitleIDX&"','','"&Player57&"','"&Level&"','"&TeamGb&"','"&Sex&"','157','sd042001','sd030002','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data58&"','judo','"&GameTitleIDX&"','','"&Player58&"','"&Level&"','"&TeamGb&"','"&Sex&"','158','sd042001','sd030002','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data57&"','judo','"&GameTitleIDX&"','','"&Player57&"','"&Level&"','"&TeamGb&"','"&Sex&"','157','sd042002','sd030002','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data59 <> "" And Hidden_Data60 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data59&"','judo','"&GameTitleIDX&"','','"&Player59&"','"&Level&"','"&TeamGb&"','"&Sex&"','159','sd042001','sd030002','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data60&"','judo','"&GameTitleIDX&"','','"&Player60&"','"&Level&"','"&TeamGb&"','"&Sex&"','160','sd042001','sd030002','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data59&"','judo','"&GameTitleIDX&"','','"&Player59&"','"&Level&"','"&TeamGb&"','"&Sex&"','159','sd042002','sd030002','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data61 <> "" And Hidden_Data62 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data61&"','judo','"&GameTitleIDX&"','','"&Player61&"','"&Level&"','"&TeamGb&"','"&Sex&"','161','sd042001','sd030002','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data62&"','judo','"&GameTitleIDX&"','','"&Player62&"','"&Level&"','"&TeamGb&"','"&Sex&"','162','sd042001','sd030002','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data61&"','judo','"&GameTitleIDX&"','','"&Player61&"','"&Level&"','"&TeamGb&"','"&Sex&"','161','sd042002','sd030002','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data63 <> "" And Hidden_Data64 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data63&"','judo','"&GameTitleIDX&"','','"&Player63&"','"&Level&"','"&TeamGb&"','"&Sex&"','163','sd042001','sd030002','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data64&"','judo','"&GameTitleIDX&"','','"&Player64&"','"&Level&"','"&TeamGb&"','"&Sex&"','164','sd042001','sd030002','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data63&"','judo','"&GameTitleIDX&"','','"&Player63&"','"&Level&"','"&TeamGb&"','"&Sex&"','163','sd042002','sd030002','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	


	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'학교정보 업데이트
	UpSQL = "UPDATE tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From Sportsdiary.dbo.tblRPlayer RP JOIN Sportsdiary.dbo.tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/MatchInfo64_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=sd040001','_blank'); 
// location.href='TournamentInfo.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'
</script>
