<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
seq         = fInject(Request("seq"))
GroupGameGb = fInject(Request("GroupGameGb"))
RGameLevelIDX = fInject(Request("RGameLevelIDX"))

if trim(seq) = "" then
	Response.end
end if

If GroupGameGb = SportsCode&"040001" Then 


	'삭제전 선수,팀정보
	LSQL = "SELECT PlayerIDX "
	LSQL = LSQL&" ,Team "
	LSQL = LSQL&" ,GameTitleIDX"
	LSQL = LSQL&" ,Level"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "
	LSQL = LSQL&" WHERE RPlayerMasterIDX = '"&seq&"'"
	'Response.Write LSQL&"<br>"

	Set LRs = Dbcon.Execute(LSQL)

	If Not(LRs.Eof Or LRs.Bof) Then 
		Old_PlayerIDX    = LRs("PlayerIDX")
		Old_Team         = LRs("Team")
		Old_GameTitleIDX = LRs("GameTitleIDX")
		Old_Level        = LRs("Level")
		'tblGameRequest
		RUpdate = "Update SportsDiary.dbo.tblGameRequest"
		RUpdate = RUpdate&" SET DelYN='Y'"
		RUpdate = RUpdate&" WHERE GameTitleIDX='"&Old_GameTitleIDX&"'"
		RUpdate = RUpdate&" AND PlayerCode='"&Old_PlayerIDX&"'"
		RUpdate = RUpdate&" AND Team='"&Old_Team&"'"
		RUpdate = RUpdate&" AND Level = '"&Old_Level&"'"
		RUpdate = RUpdate&" AND DelYN='N'"
		'Response.Write RUpdate
		'Response.End
		Dbcon.Execute(RUpdate)
	End If 	



	DSQL = " UPDATE SportsDiary.dbo.tblRPlayerMaster " 
	DSQL = DSQL & "  SET DELYN = 'Y'"
	DSQL = DSQL & " WHERE DelYN = 'N'"
	DSQL = DSQL & " AND RPlayerMasterIDX = '" & seq & "'"
	Dbcon.Execute(DSQL)
	


	'===========================================================================================
	'==================================== TotRound Update ======================================
	'해당선수 업데이트후 TotRound 업데이트 처리
		CSQL = "SELECT Count(RPlayerMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRPlayerMaster"
		CSQL = CSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N'"

		Set CRs = Dbcon.Execute(CSQL)

		TotCnt = CRs("Cnt")

		CRs.Close
		Set CRs = Nothing 
		If TotCnt = 0 Then 
			TotRound = 0
		ElseIf TotCnt > 0 And TotCnt <= 2 Then 
			TotRound = 2
		ElseIf TotCnt > 2 And TotCnt <= 4 Then 
			TotRound = 4
		ElseIf TotCnt > 4 And TotCnt <= 8 Then 
			TotRound = 8
		ElseIf TotCnt > 8 And TotCnt <= 16 Then 
			TotRound = 16
		ElseIf TotCnt > 16 And TotCnt <= 32 Then 
			TotRound = 32
		ElseIf TotCnt > 32 And TotCnt <= 64 Then 
			TotRound = 64
		ElseIf TotCnt > 64 And TotCnt <= 128 Then 
			TotRound = 128
		ElseIf TotCnt > 128 And TotCnt <= 256 Then 
			TotRound = 256
		End If 

		RoundUpSQL = "Update SportsDiary.dbo.tblRGameLevel SET TotRound='"&TotRound&"' WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
		Dbcon.Execute(RoundUpSQL)
	'==================================== TotRound Update ======================================
	'===========================================================================================	




	response.write "TRUE"
	response.end
ElseIf GroupGameGb = SportsCode&"040002" Then 
	ChkSQL = "SELECT "
	ChkSQL = ChkSQL&"Team"
	ChkSQL = ChkSQL&",TeamGb"
	ChkSQL = ChkSQL&",Sex"
	ChkSQL = ChkSQL&",GroupGameGb"
	ChkSQL = ChkSQL&",RGameLevelIDX"
	ChkSQL = ChkSQL&",GameTitleIDX"
	ChkSQL = ChkSQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster"
	ChkSQL = ChkSQL&" WHERE DelYN='N' AND RGameGroupSchoolMasterIDX = '"& seq &"'"

	Set CRs = Dbcon.Execute(ChkSQL)

	'등록된 데이터가 있다면 모두 삭제 처리
	If Not (CRs.Eof Or CRs.Bof) Then 

		'해당 학교에 등록된 선수 정보도 삭제해 준다.
		PlayerDel = "Update SportsDiary.dbo.tblRPlayerMaster "
		PlayerDel = PlayerDel&" Set DelYN='Y'"
		PlayerDel = PlayerDel&"	WHERE "
		PlayerDel = PlayerDel&" Team='"&CRs("Team")&"'"
		PlayerDel = PlayerDel&" AND TeamGb = '"&CRs("TeamGb")&"'"
		PlayerDel = PlayerDel&" AND Sex = '"&CRs("Sex")&"'"
		PlayerDel = PlayerDel&"	And GroupGameGb='"&CRs("GroupGameGb")&"'"
		PlayerDel = PlayerDel&"	And RGameLevelIDX='"&CRs("RGameLevelIDX")&"'"
		PlayerDel = PlayerDel&"	And GameTitleIDX='"&CRs("GameTitleIDX")&"'"		

		Dbcon.Execute(PlayerDel)
		
		CRs.Close
		Set CRs = Nothing 
	End If 


	DSQL = " UPDATE SportsDiary.dbo.tblRGameGroupSchoolMaster " 
	DSQL = DSQL & "  SET DELYN = 'Y'"
	DSQL = DSQL & " WHERE DelYN = 'N'"
	DSQL = DSQL & " AND RGameGroupSchoolMasterIDX = '" & seq & "'"
	Dbcon.Execute(DSQL)


		'===========================================================================================
		'==================================== TotRound Update ======================================
		'해당학교 업데이트후 TotRound 업데이트 처리
			CSQL = "SELECT Count(RGameGroupSchoolMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRGameGroupSchoolMaster"
			CSQL = CSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N'"

			Set CRs2 = Dbcon.Execute(CSQL)

			TotCnt = CRs2("Cnt")

			CRs2.Close
			Set CRs2 = Nothing 

			If TotCnt = 0 Then 
				TotRound = 2
			ElseIf TotCnt > 0 And TotCnt <= 2 Then 
				TotRound = 2
			ElseIf TotCnt > 2 And TotCnt <= 4 Then 
				TotRound = 4
			ElseIf TotCnt > 4 And TotCnt <= 8 Then 
				TotRound = 8
			ElseIf TotCnt > 8 And TotCnt <= 16 Then 
				TotRound = 16
			ElseIf TotCnt > 16 And TotCnt <= 32 Then 
				TotRound = 32
			ElseIf TotCnt > 32 And TotCnt <= 64 Then 
				TotRound = 64
			ElseIf TotCnt > 64 And TotCnt <= 128 Then 
				TotRound = 128
			ElseIf TotCnt > 128 And TotCnt <= 256 Then 
				TotRound = 256
			End If 

			RoundUpSQL = "Update SportsDiary.dbo.tblRGameLevel SET TotRound='"&TotRound&"' WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
			Dbcon.Execute(RoundUpSQL)
		'==================================== TotRound Update ======================================
		'===========================================================================================	


	response.write "TRUE"
	response.end
End If 




Dbclose()


%>