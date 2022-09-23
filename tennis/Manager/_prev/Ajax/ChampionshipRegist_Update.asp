<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq	         = fInject(Request("seq")) 

	RGameLevelIDX  = fInject(Request("RGameLevelIDX")) '"115" '
	GameTitleIDX   = fInject(Request("GameTitleIDX"))   '"39" '
	GroupGameGb    = fInject(Request("GroupGameGb")) ' "sd040001" '
	TeamGb         = fInject(Request("TeamGb")) ' "sd011001" '
	Sex            = fInject(Request("Sex"))   '"Man"
	Level          = fInject(Request("Level")) '"lv007007" '
	Team         = fInject(Request("Team")) '"18945" '
	PlayerIDX      = fInject(Request("PlayerIDX")) '"138" '
	SportsGb       = Request.Cookies("SportsGb")

	
	If seq = "" Then 
		Response.End
	End If 



	If GroupGameGb = SportsCode&"040001" Then 
		'개인전일때
		'선수 체급 업데이트
		SSQL = "SELECT "
		SSQL = SSQL&" UserName "
		SSQL = SSQL&" FROM SportsDiary.dbo.tblPlayer "
		SSQL = SSQL&" WHERE PlayerIDX='"&PlayerIDX&"'"
		Set SRs = Dbcon.Execute(SSQL)

		If SRs.Eof Or SRs.Bof Then 
			Response.Write "NONE"
			Response.End
		Else
			UserName = SRs("UserName")
			
			UpSQL = "Update SportsDiary.dbo.tblPlayer"
			UpSQL = UpSQL&" SET Level='"&Level&"'"
			UpSQL = UpSQL&" ,Team ='"&Team&"'"
			UpSQL = UpSQL&" WHERE PlayerIDX='"&PlayerIDX&"'"
			'Response.Write UpSQL
			'Response.End
			Dbcon.Execute(UpSQL)
		End If 
		

		'바뀌기전 선수,팀정보
		LSQL = "SELECT PlayerIDX "
		LSQL = LSQL&" ,Team "
		LSQL = LSQL&" From SportsDiary.dbo.tblRPlayerMaster"
		LSQL = LSQL&" WHERE RPlayerMasterIDX = '"&seq&"'"
		Set LRs = Dbcon.Execute(LSQL)
		'Response.Write LSQL
		'Response.End
		If LRs.Eof Or LRs.Bof Then 
			Response.Write "NONE"
			Response.End
		Else
			Old_PlayerIDX = LRs("PlayerIDX")
			Old_Team      = LRs("Team")
		End If 



		'출전선수정보 업데이트
		UpSQL2 = "Update SportsDiary.dbo.tblRPlayerMaster"
		UpSQL2 = UpSQL2&" SET "
		UpSQL2 = UpSQL2&" PlayerIDX = '"&PlayerIDX&"'"
		UpSQL2 = UpSQL2&" ,Team = '"&Team&"'"
		UpSQL2 = UpSQL2&" ,UserName = '"&UserName&"'"
		UpSQL2 = UpSQL2&" WHERE RPlayerMasterIDX = '"&seq&"'"
		Dbcon.Execute(UpSQL2)


		'tblGameRequest
		RUpdate = "Update SportsDiary.dbo.tblGameRequest"
		RUpdate = RUpdate&" SET PlayerCode='"&PlayerIDX&"'"
		RUpdate = RUpdate&" ,Team = '"&Team&"'"
		RUpdate = RUpdate&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
		RUpdate = RUpdate&" AND PlayerCode='"&Old_PlayerIDX&"'"
		RUpdate = RUpdate&" AND Team='"&Old_Team&"'"
		RUpdate = RUpdate&" AND Level = '"&Level&"'"
		RUpdate = RUpdate&" AND DelYN='N'"
		'Response.Write RUpdate
		'Response.End
		Dbcon.Execute(RUpdate)

		'===========================================================================================
		'==================================== TotRound Update ======================================
		'해당선수 업데이트후 TotRound 업데이트 처리
			CSQL = "SELECT Count(RPlayerMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRPlayerMaster"
			CSQL = CSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N'"

			Set CRs = Dbcon.Execute(CSQL)

			TotCnt = CRs("Cnt")

			CRs.Close
			Set CRs = Nothing 

			If TotCnt > 0 And TotCnt <= 2 Then 
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




		Response.Write "TRUE"
		Response.End

	ElseIf GroupGameGb = SportsCode&"040002" Then 
	'단체전일때

		'학교명가져오기
		NSQL = "SELECT"
		NSQL = NSQL&" TeamNm "
		NSQL = NSQL&" FROM SportsDiary.dbo.tblTeamInfo"
		NSQL = NSQL&" WHERE Team='"&Team&"'"
		
		Set NRs = Dbcon.Execute(NSQL)
		
		If Not (NRs.Eof Or NRs.Bof) Then 
			TeamName = NRs("TeamNm")
		Else
			Response.Write "NONE"
			Response.End
		End If 

		UpSQL3 = "Update SportsDiary.dbo.tblRGameGroupSchoolMaster"
		UpSQL3 = UpSQL3&" SET "
		UpSQL3 = UpSQL3&" Team = '"&Team&"'" 
		UpSQL3 = UpSQL3&" ,SchoolName='"&TeamName&"'"
		UpSQL3 = UpSQL3&" ,TeamGb='"&TeamGb&"'"		
		UpSQL3 = UpSQL3&" WHERE RGameGroupSchoolMasterIDX='"&seq&"'"
		Dbcon.Execute(UpSQL3)


		'===========================================================================================
		'==================================== TotRound Update ======================================
		'해당학교 업데이트후 TotRound 업데이트 처리
			CSQL = "SELECT Count(RGameGroupSchoolMasterIDX) AS Cnt FROM SportsDiary.dbo.tblRGameGroupSchoolMaster"
			CSQL = CSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N'"

			Set CRs = Dbcon.Execute(CSQL)

			TotCnt = CRs("Cnt")

			CRs.Close
			Set CRs = Nothing 

			If TotCnt > 0 And TotCnt <= 2 Then 
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



		Response.Write "TRUE"
		Response.End
	End If 



	DbClose()


	
%>