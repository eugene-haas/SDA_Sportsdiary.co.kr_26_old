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


	Hidden_Data1   = fInject(Request("Hidden_Data1"))
	Hidden_Data2   = fInject(Request("Hidden_Data2"))
	Hidden_Data3   = fInject(Request("Hidden_Data3"))
	Hidden_Data4   = fInject(Request("Hidden_Data4"))
	

	R1_Num1         = fInject(Request("R1_Num1"))
	R1_Num2         = fInject(Request("R1_Num2"))

	If R2_Num1 <> "" Then
		R2_Num1         = R1_Num2 + 1
	End If

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
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','"&SportsCode&"042001','"&SportsCode&"030001','0','"&R1_Num1&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data2&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player2&"','"&Level&"','"&TeamGb&"','"&Sex&"','102','"&SportsCode&"042001','"&SportsCode&"030001','0','"&R1_Num1&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','"&SportsCode&"042002','"&SportsCode&"030001','0','"&R1_Num1&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data3 <> "" And Hidden_Data4 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','"&SportsCode&"042001','"&SportsCode&"030002','0','"&R1_Num2&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data4&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player4&"','"&Level&"','"&TeamGb&"','"&Sex&"','104','"&SportsCode&"042001','"&SportsCode&"030002','0','"&R1_Num2&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','"&Request.Cookies("SportsGb")&"','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','"&SportsCode&"042002','"&SportsCode&"030002','0','"&R1_Num2&"','"&R2_Num1&"','','','','','','"&SportsCode&"040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	'학교정보 업데이트
	UpSQL = "UPDATE Sportsdiary.dbo.tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From Sportsdiary.dbo.tblRPlayer RP JOIN Sportsdiary.dbo.tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/Match4_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=<%=SportsCode%>040001','_blank'); 
// location.href='TournamentInfo.asp?GameTitleIDX=<%=TeamGb%>&GameType=<%=TeamGb%>&Level=<%=Level%>'
</script>
