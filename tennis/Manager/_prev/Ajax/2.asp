<!--#include virtual="/Manager/Library/config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
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



	DelSQL = "Delete From tblRPlayer Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
	Dbcon.Execute(DelSQL)			

	DelSQL2 = "Delete From tblPlayerResult Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
	Dbcon.Execute(DelSQL2)			



	For i = 0 To UBound(First_Arr_GameNum,1)

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

		Dbcon.Execute(InSQL)


	Next

	'Response.End


	ProcedureSQL = " EXEC Sportsdiary.dbo.Insert_tblPlayerResult_Wres_Level "
  ProcedureSQL = ProcedureSQL & " @RGameLevelIDX = "&RGameLevelIDX

	Dbcon.Execute(ProcedureSQL)


	'학교정보 업데이트
	UpSQL = "UPDATE tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From tblRPlayer RP JOIN tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');

 window.open('/Manager/Ajax/MatchLeague_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=<%=SportsCode%>040001','_blank'); 
 location.href='1.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'

</script>
