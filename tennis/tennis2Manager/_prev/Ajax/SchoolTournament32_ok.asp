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
	'Response.Write GameTitleIDX&"<br>"
	'Response.Write RGameLevelIDX&"<br>"
	'Response.Write TotRound&"<br>"
	''Response.Write pair_cnt&"<br>"
	'Response.Write R2_Cnt&"<br>"
	'Response.Write R3_Cnt&"<br>"
	'Response.Write R4_Cnt&"<br>"
	'Response.Write R5_Cnt&"<br>"
	'Response.Write R6_Cnt&"<br>"


	Player1        = fInject(Request("Player1"))
	Player2        = fInject(Request("Player2"))
	Player3        = fInject(Request("Player3"))
	Player4        = fInject(Request("Player4"))
	Player5        = fInject(Request("Player5"))
	Player6        = fInject(Request("Player6"))
	Player7        = fInject(Request("Player7"))
	Player8        = fInject(Request("Player8"))
	Player9        = fInject(Request("Player9"))
	Player10        = fInject(Request("Player10"))
	Player11        = fInject(Request("Player11"))
	Player12        = fInject(Request("Player12"))
	Player13        = fInject(Request("Player13"))
	Player14        = fInject(Request("Player14"))
	Player15        = fInject(Request("Player15"))
	Player16        = fInject(Request("Player16"))
	Player17        = fInject(Request("Player17"))
	Player18        = fInject(Request("Player18"))
	Player19        = fInject(Request("Player19"))
	Player20        = fInject(Request("Player20"))
	Player21        = fInject(Request("Player21"))
	Player22        = fInject(Request("Player22"))
	Player23        = fInject(Request("Player23"))
	Player24        = fInject(Request("Player24"))
	Player25        = fInject(Request("Player25"))
	Player26        = fInject(Request("Player26"))
	Player27        = fInject(Request("Player27"))
	Player28        = fInject(Request("Player28"))
	Player29        = fInject(Request("Player29"))
	Player30        = fInject(Request("Player30"))
	Player31        = fInject(Request("Player31"))
	Player32        = fInject(Request("Player32"))





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

	hidden_data_TeamDtl1  = fInject(Request("hidden_data_TeamDtl1"))
	hidden_data_TeamDtl2  = fInject(Request("hidden_data_TeamDtl2"))
	hidden_data_TeamDtl3  = fInject(Request("hidden_data_TeamDtl3"))
	hidden_data_TeamDtl4  = fInject(Request("hidden_data_TeamDtl4"))
	hidden_data_TeamDtl5  = fInject(Request("hidden_data_TeamDtl5"))
	hidden_data_TeamDtl6  = fInject(Request("hidden_data_TeamDtl6"))
	hidden_data_TeamDtl7  = fInject(Request("hidden_data_TeamDtl7"))
	hidden_data_TeamDtl8  = fInject(Request("hidden_data_TeamDtl8"))
	hidden_data_TeamDtl9  = fInject(Request("hidden_data_TeamDtl9"))
	hidden_data_TeamDtl10 = fInject(Request("hidden_data_TeamDtl10"))
	hidden_data_TeamDtl11 = fInject(Request("hidden_data_TeamDtl11"))
	hidden_data_TeamDtl12 = fInject(Request("hidden_data_TeamDtl12"))
	hidden_data_TeamDtl13 = fInject(Request("hidden_data_TeamDtl13"))
	hidden_data_TeamDtl14 = fInject(Request("hidden_data_TeamDtl14"))
	hidden_data_TeamDtl15 = fInject(Request("hidden_data_TeamDtl15"))
	hidden_data_TeamDtl16 = fInject(Request("hidden_data_TeamDtl16"))
	hidden_data_TeamDtl17 = fInject(Request("hidden_data_TeamDtl17"))
	hidden_data_TeamDtl19 = fInject(Request("hidden_data_TeamDtl19"))
	hidden_data_TeamDtl18 = fInject(Request("hidden_data_TeamDtl18"))
	hidden_data_TeamDtl20 = fInject(Request("hidden_data_TeamDtl20"))
	hidden_data_TeamDtl21 = fInject(Request("hidden_data_TeamDtl21"))
	hidden_data_TeamDtl22 = fInject(Request("hidden_data_TeamDtl22"))
	hidden_data_TeamDtl23 = fInject(Request("hidden_data_TeamDtl23"))
	hidden_data_TeamDtl24 = fInject(Request("hidden_data_TeamDtl24"))
	hidden_data_TeamDtl25 = fInject(Request("hidden_data_TeamDtl25"))
	hidden_data_TeamDtl26 = fInject(Request("hidden_data_TeamDtl26"))
	hidden_data_TeamDtl27 = fInject(Request("hidden_data_TeamDtl27"))
	hidden_data_TeamDtl28 = fInject(Request("hidden_data_TeamDtl28"))
	hidden_data_TeamDtl29 = fInject(Request("hidden_data_TeamDtl29"))
	hidden_data_TeamDtl30 = fInject(Request("hidden_data_TeamDtl30"))
	hidden_data_TeamDtl31 = fInject(Request("hidden_data_TeamDtl31"))
	hidden_data_TeamDtl32 = fInject(Request("hidden_data_TeamDtl32"))



	

	R1_Num1         = fInject(Request("R1_Num1"))
	R1_Num2         = fInject(Request("R1_Num2"))
	R1_Num3         = fInject(Request("R1_Num3"))
	R1_Num4         = fInject(Request("R1_Num4"))
	R1_Num5         = fInject(Request("R1_Num5"))
	R1_Num6         = fInject(Request("R1_Num6"))
	R1_Num7         = fInject(Request("R1_Num7"))
	R1_Num8         = fInject(Request("R1_Num8"))
	R1_Num9         = fInject(Request("R1_Num9"))
	R1_Num10         = fInject(Request("R1_Num10"))
	R1_Num11         = fInject(Request("R1_Num11"))
	R1_Num12         = fInject(Request("R1_Num12"))
	R1_Num13         = fInject(Request("R1_Num13"))
	R1_Num14         = fInject(Request("R1_Num14"))
	R1_Num15         = fInject(Request("R1_Num15"))
	R1_Num16         = fInject(Request("R1_Num16"))

	R2_Num1         = fInject(Request("R2_Num1"))
	R2_Num2         = fInject(Request("R2_Num2"))
	R2_Num3         = fInject(Request("R2_Num3"))
	R2_Num4         = fInject(Request("R2_Num4"))
	R2_Num5         = fInject(Request("R2_Num5"))
	R2_Num6         = fInject(Request("R2_Num6"))
	R2_Num7         = fInject(Request("R2_Num7"))
	R2_Num8         = fInject(Request("R2_Num8"))

	R3_Num1         = fInject(Request("R3_Num1"))
	R3_Num2         = fInject(Request("R3_Num2"))
	R3_Num3         = fInject(Request("R3_Num3"))
	R3_Num4         = fInject(Request("R3_Num4"))


	R4_Num1         = fInject(Request("R4_Num1"))
	R4_Num2         = fInject(Request("R4_Num2"))


	R5_Num1         = R4_Num2+1





	'Response.Write Hidden_Data1&"<br>"


	'기존 데이터 체크
	chkSQL = "SELECT Count(RGameGroupSchoolIDX) AS Cnt From SportsDiary.dbo.tblRGameGroupSchool Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
	Set CRs = Dbcon.Execute(chkSQL)

	If CRs("Cnt") > 0 Then 
		DelSQL = "Delete From SportsDiary.dbo.tblRGameGroupSchool Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
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
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data1&"','"&Player1&"','101','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl1 & "')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)		

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data2&"','"&Player2&"','102','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl2 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data1&"','"&Player1&"','101','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl1 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data3 <> "" And Hidden_Data4 <> "" Then 
		'일반전

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data3&"','"&Player3&"','103','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl3 & "')"
		Dbcon.Execute(InSQL)


		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data4&"','"&Player4&"','104','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R4_Num1&"','','','" & hidden_data_TeamDtl4 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data3&"','"&Player3&"','103','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl3 & "')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data5 <> "" And Hidden_Data6 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data5&"','"&Player5&"','105','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl5 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data6&"','"&Player6&"','106','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl6 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data5&"','"&Player5&"','105','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl5 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data7 <> "" And Hidden_Data8 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data7&"','"&Player7&"','107','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl7 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data8&"','"&Player8&"','108','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl8 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data7&"','"&Player7&"','107','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl7 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data9 <> "" And Hidden_Data10 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data9&"','"&Player9&"','109','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl9 & "')"
		Dbcon.Execute(InSQL)


		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data10&"','"&Player10&"','110','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl10 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data9&"','"&Player9&"','109','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl9 & "')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data11 <> "" And Hidden_Data12 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data11&"','"&Player11&"','111','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl11 & "')"
		Dbcon.Execute(InSQL)


		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data12&"','"&Player12&"','112','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl12 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data11&"','"&Player11&"','111','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl11 & "')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data13 <> "" And Hidden_Data14 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data13&"','"&Player13&"','113','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl13 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data14&"','"&Player14&"','114','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl14 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data13&"','"&Player13&"','113','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl13 & "')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data15 <> "" And Hidden_Data16 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data15&"','"&Player15&"','115','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl15 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data16&"','"&Player16&"','116','"&SportsCode&"042001','"&SportsCode&"030001','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl16 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data15&"','"&Player15&"','115','"&SportsCode&"042002','"&SportsCode&"030001','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl15 & "')"
		Dbcon.Execute(InSQL)
	End If 	
	'=========================================================  왼쪽데이터 ===============================================================================	
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	If Hidden_Data17 <> "" And Hidden_Data18 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data17&"','"&Player17&"','117','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl17 & "')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data18&"','"&Player18&"','118','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl18 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data17&"','"&Player17&"','117','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl17 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data19 <> "" And Hidden_Data20 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data19&"','"&Player19&"','119','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl19 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data20&"','"&Player20&"','120','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl20 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data19&"','"&Player19&"','119','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl19 & "')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data21 <> "" And Hidden_Data22 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data21&"','"&Player21&"','121','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl21 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data22&"','"&Player22&"','122','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl22 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data21&"','"&Player21&"','121','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl21 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data23 <> "" And Hidden_Data24 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data23&"','"&Player23&"','123','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl23 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data24&"','"&Player24&"','124','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl24 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data23&"','"&Player23&"','123','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl23 & "')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data25 <> "" And Hidden_Data26 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data25&"','"&Player25&"','125','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl25 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data26&"','"&Player26&"','126','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl26 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data25&"','"&Player25&"','125','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl25 & "')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data27 <> "" And Hidden_Data28 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data27&"','"&Player27&"','127','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl27 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data28&"','"&Player28&"','128','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl28 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data27&"','"&Player27&"','127','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl27 & "')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data29 <> "" And Hidden_Data30 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data29&"','"&Player29&"','129','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl29 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data30&"','"&Player30&"','130','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl30& "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data29&"','"&Player29&"','129','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl29 & "')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data31 <> "" And Hidden_Data32 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data31&"','"&Player31&"','131','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl31 & "')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data32&"','"&Player32&"','132','"&SportsCode&"042001','"&SportsCode&"030002','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl32 & "')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,GameTitleIDX,RGameLevelidx,TeamGb,Sex,Team,SchoolName,SchNum,UnearnWin,LeftRightGb,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,TeamDtl)"
		InSQL = InSQL&" VALUES "
		InSQL = InSQL&"('"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','"&RGameLevelIDX&"','"&TeamGb&"','"&Sex&"','"&Hidden_Data31&"','"&Player31&"','131','"&SportsCode&"042002','"&SportsCode&"030002','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','','','" & hidden_data_TeamDtl31 & "')"
		Dbcon.Execute(InSQL)
	End If 	




	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'학교정보 업데이트
	UpSQL = "UPDATE Sportsdiary.dbo.tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From Sportsdiary.dbo.tblRPlayer RP JOIN Sportsdiary.dbo.tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/Match32_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=<%=SportsCode%>040002','_blank'); 
 location.href='TournamentInfo.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'
</script>
