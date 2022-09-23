<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDX  = fInject(Request("GameTitleIDX"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	Level         = fInject(Request("Level"))
	TeamGb        = fInject(Request("TeamGb"))
	Sex           = fInject(Request("Sex"))
	TotRound      = fInject(Request("TotRound"))

	GameNum = fInject(Request("GameNum"))

	First_Arr_GameNum = Split(GameNum,"|")

	PlayerNum = 0


	'기존 데이터 체크
	chkSQL = "SELECT Count(RGameGroupSchoolIDX) AS Cnt From SportsDiary.dbo.tblRGameGroupSchool Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
	Set CRs = Dbcon.Execute(chkSQL)

	If CRs("Cnt") > 0 Then 
		DelSQL = "Delete From SportsDiary.dbo.tblRGameGroupSchool Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
		Dbcon.Execute(DelSQL)			
	End If 



	For i = 0 To UBound(First_Arr_GameNum,1)

		Second_Arr_GameNum = Split(First_Arr_GameNum(i),",")

		PlayerNum = i + 101

		InSQL = "Insert Into tblRGameGroupSchool (SportsGb,"
		InSQL = InSQL&" GameTitleIDX,"
		InSQL = InSQL&" RGameLevelidx,"
		InSQL = InSQL&" TeamGb,"
		InSQL = InSQL&" Sex,"
		InSQL = InSQL&" Team,"
		InSQL = InSQL&" TeamDtl,"
		InSQL = InSQL&" SchoolName,"
		InSQL = InSQL&" SchNum,"
		InSQL = InSQL&" LeftRightGb,"

		For j = 6 To UBound(Second_Arr_GameNum)
			InSQL = InSQL & " Game" & j - 5& "R,"
		Next

		InSQL = InSQL&" UnearnWin"
		InSQL = InSQL&" )"

		InSQL = InSQL&" VALUES "
		InSQL = InSQL&" ("
		InSQL = InSQL&" 'judo',"
		InSQL = InSQL&" '"&GameTitleIDX&"',"
		InSQL = InSQL&" '"&RGameLevelIDX&"',"
		InSQL = InSQL&" '"&TeamGb&"',"
		InSQL = InSQL&" '"&Sex&"',"
		InSQL = InSQL&" '"& Second_Arr_GameNum(2) &"',"
		InSQL = InSQL&" '"& Second_Arr_GameNum(3) &"',"
		InSQL = InSQL&" '"&Second_Arr_GameNum(5)&"',"
		InSQL = InSQL&" '" & PlayerNum & "',"
		InSQL = InSQL&" 'sd030001',"

		For j = 6 To UBound(Second_Arr_GameNum)
			InSQL = InSQL & "'" & Second_Arr_GameNum(j) & "',"
		Next

		InSQL = InSQL&" 'sd042001')"


		Dbcon.Execute(InSQL)


	Next



	'학교정보 업데이트
	UpSQL = "UPDATE tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From tblRPlayer RP JOIN tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/MatchInfoLeague_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=sd040002','_blank'); 
 location.href='TournamentInfo.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'

</script>
