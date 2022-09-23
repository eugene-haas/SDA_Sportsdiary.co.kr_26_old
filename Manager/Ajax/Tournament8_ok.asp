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
	'Response.Write pair_cnt&"<br>"
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


	Hidden_Data1   = fInject(Request("Hidden_Data1"))
	Hidden_Data2   = fInject(Request("Hidden_Data2"))
	Hidden_Data3   = fInject(Request("Hidden_Data3"))
	Hidden_Data4   = fInject(Request("Hidden_Data4"))
	Hidden_Data5   = fInject(Request("Hidden_Data5"))
	Hidden_Data6   = fInject(Request("Hidden_Data6"))
	Hidden_Data7   = fInject(Request("Hidden_Data7"))
	Hidden_Data8   = fInject(Request("Hidden_Data8"))
	

	R1_Num1         = fInject(Request("R1_Num1"))
	R1_Num2         = fInject(Request("R1_Num2"))
	R1_Num3         = fInject(Request("R1_Num3"))
	R1_Num4         = fInject(Request("R1_Num4"))

	R2_Num1         = fInject(Request("R2_Num1"))
	R2_Num2         = fInject(Request("R2_Num2"))

	R3_Num1         = R2_Num2+1

	'Response.Write Hidden_Data1&"<br>"


	'기존 데이터 체크
	chkSQL = "SELECT Count(RPlayerIDX) AS Cnt From tblRPlayer Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
	Set CRs = Dbcon.Execute(chkSQL)

	If CRs("Cnt") > 0 Then 
		DelSQL = "Delete From tblRPlayer Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
		Dbcon.Execute(DelSQL)			
	End If 




	'sd042001 일반전 sd042002 부전승
	'왼쪽오른쪽 sd030001 왼 sd030002 오
	'개인전 'sd040001' 단체전 sd040002

	
	If Hidden_Data1 <> "" And Hidden_Data2 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data2&"','judo','"&GameTitleIDX&"','','"&Player2&"','"&Level&"','"&TeamGb&"','"&Sex&"','102','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042002','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data3 <> "" And Hidden_Data4 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data4&"','judo','"&GameTitleIDX&"','','"&Player4&"','"&Level&"','"&TeamGb&"','"&Sex&"','104','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042002','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data5 <> "" And Hidden_Data6 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042001','sd030002','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data6&"','judo','"&GameTitleIDX&"','','"&Player6&"','"&Level&"','"&TeamGb&"','"&Sex&"','106','sd042001','sd030002','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042002','sd030002','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data7 <> "" And Hidden_Data8 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042001','sd030002','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data8&"','judo','"&GameTitleIDX&"','','"&Player8&"','"&Level&"','"&TeamGb&"','"&Sex&"','108','sd042001','sd030002','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
'		Response.Write InSQL
'		Response.End
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042002','sd030002','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','','','','','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	'학교정보 업데이트
	UpSQL = "UPDATE tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From tblRPlayer RP JOIN tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/Match8_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=sd040001','_blank'); 
 location.href='TournamentInfo.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'

</script>
