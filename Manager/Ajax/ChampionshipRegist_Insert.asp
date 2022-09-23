<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
		RGameLevelIDX  = fInject(Request("RGameLevelIDX")) '"115" '
		GameTitleIDX   = fInject(Request("GameTitleIDX"))   '"39" '
		GroupGameGb    = fInject(Request("GroupGameGb")) ' "sd040001" '
		TeamGb         = fInject(Request("TeamGb")) ' "sd011001" '
		Sex            = fInject(Request("Sex"))   '"Man"
		Level          = fInject(Request("Level")) '"lv007007" '
		Team         = fInject(Request("Team")) '"18945" '
		PlayerIDX      = fInject(Request("PlayerIDX")) '"138" '
		SportsGb       = "judo"



'RGameLevelIDX = "455"
'GameTitleIDX = "49"
'GroupGameGb = "sd040001"
'TeamGb = "41001"
'Sex = "Man"
'Level = "41001001"
'Team = "ju02840"
'PlayerIDX = "6257"



	'중복체크
	If GroupGameGb = "sd040001" Then 
	  '개인전일때
		ChkSQL = "SELECT"
		ChkSQL = ChkSQL&" Count(RPlayerMasterIDX) AS Cnt"
		ChkSQL = ChkSQL&" FROM SportsDiary.dbo.tblRPlayerMaster"
		ChkSQL = ChkSQL&" WHERE DelYN='N' "
		ChkSQL = ChkSQL&" AND PlayerIDX='"&PlayerIDX&"'"
		ChkSQL = ChkSQL&" AND RGameLevelIDX='"&RGameLevelIDX&"'"
		'Response.Write ChkSQL
		'Response.End

		Set CRs = Dbcon.Execute(ChkSQL)

		If CRs("Cnt") > 0 Then 
			Response.Write "SAME"
			Response.End

		Else 

			'선수 체급 업데이트
			SSQL = "SELECT "
			SSQL = SSQL&" UserName "
			SSQL = SSQL&" ,PlayerGb "
			SSQL = SSQL&" ,PlayerGrade "
			SSQL = SSQL&" FROM SportsDiary.dbo.tblPlayer "
			SSQL = SSQL&" WHERE PlayerIDX='"&PlayerIDX&"'"
			Set SRs = Dbcon.Execute(SSQL)

			If SRs.Eof Or SRs.Bof Then 
				Response.Write "NONE"
				Response.End
			Else
				UserName = SRs("UserName")
				PlayerGb = SRs("PlayerGb")
				PlayerGrade = SRs("PlayerGrade")
				
				UpSQL = "Update SportsDiary.dbo.tblPlayer"
				UpSQL = UpSQL&" SET Level='"&Level&"'"
				UpSQL = UpSQL&" ,Team ='"&Team&"'"
				UpSQL = UpSQL&" WHERE PlayerIDX='"&PlayerIDX&"'"
				'Response.Write UpSQL
				'Response.End
				Dbcon.Execute(UpSQL)
			End If 
			
			InSQL = "Insert Into SportsDiary.dbo.tblRPlayerMaster"
			InSQL = InSQL&"("
			InSQL = InSQL&"PlayerIDX"
			InSQL = InSQL&",WriteDate"
			InSQL = InSQL&",EditDate"
			InSQL = InSQL&",Team"
			InSQL = InSQL&",SportsGb"
			InSQL = InSQL&",TeamGb"
			InSQL = InSQL&",Sex"
			InSQL = InSQL&",Level"
			InSQL = InSQL&",UserName"
			InSQL = InSQL&",GroupGameGb"
			InSQL = InSQL&",RGameLevelIDX"
			InSQL = InSQL&",GameTitleIDX"
			InSQL = InSQL&",DelYN"
			InSQL = InSQL&")"
			InSQL = InSQL&" Values "
			InSQL = InSQL&"("
			InSQL = InSQL&"'"&PlayerIDX&"'"
			InSQL = InSQL&",getdate()"
			InSQL = InSQL&",getdate()"
			InSQL = InSQL&",'"&Team&"'"
			InSQL = InSQL&",'"&SportsGb&"'"
			InSQL = InSQL&",'"&TeamGb&"'"
			InSQL = InSQL&",'"&Sex&"'"
			InSQL = InSQL&",'"&Level&"'"
			InSQL = InSQL&",'"&UserName&"'"
			InSQL = InSQL&",'"&GroupGameGb&"'"
			InSQL = InSQL&",'"&RGameLevelIDX&"'"
			InSQL = InSQL&",'"&GameTitleIDX&"'"
			InSQL = InSQL&",'N'"
			InSQL = InSQL&")"

			Dbcon.Execute(InSQL)

			'===========================================================================================			
			'신규참가신청 테이블 tblGameRequest insert==================================================
			
			'기존내역 삭제 업데이트			
			DSQL = "Update Sportsdiary.dbo.tblGameRequest"
			DSQL = DSQL&" SET DelYN='Y'"
			DSQL = DSQL&" WHERE DelYN='N'"
			DSQL = DSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"
			DSQL = DSQL&" AND Team   ='"&Team&"'"
			DSQL = DSQL&" AND TeamGb ='"&TeamGb&"'"
			DSQL = DSQL&" AND Level  ='"&Level&"'"
			DSQL = DSQL&" AND PlayerCode = '"&PlayerIDX&"'"
			Dbcon.Execute (DSQL)

			'신규내역 입력
			InSQL = "Insert Into SportsDiary.dbo.tblGameRequest "
			InSQL = InSQL&"("
			InSQL = InSQL&"SportsGb"
			InSQL = InSQL&",GameTitleIDX"
			InSQL = InSQL&",UserPhone"
			InSQL = InSQL&",DelYN"
			InSQL = InSQL&",WriteDate"
			InSQL = InSQL&",PlayerCode"
			InSQL = InSQL&",Team"
			InSQL = InSQL&",TeamDtl"
			InSQL = InSQL&",Sex"
			InSQL = InSQL&",sido"
			InSQL = InSQL&",TeamGb"
			InSQL = InSQL&",Level"
			InSQL = InSQL&",PlayerType"
			InSQL = InSQL&",EnterType"
			InSQL = InSQL&",GroupGameGb"
			InSQL = InSQL&",PlayerGrade"
			InSQL = InSQL&",SubstituteYN"			
			InSQL = InSQL&",LeaderNM"			
			InSQL = InSQL&",TeamTel"		
			InSQL = InSQL&",LeaderHP"		
			InSQL = InSQL&",LeaderEmail"					
			InSQL = InSQL&",Principal"
			InSQL = InSQL&")"
			InSQL = InSQL&" VALUES "
			InSQL = InSQL&"("
			InSQL = InSQL&"'judo'"
			InSQL = InSQL&",'"&GameTitleIDX&"'"
			InSQL = InSQL&",'"&TeamTel&"'"
			InSQL = InSQL&",'N'"
			InSQL = InSQL&",getdate()"
			InSQL = InSQL&",'"&Trim(PlayerIDX)&"'"
			InSQL = InSQL&",'"&Team&"'"
			InSQL = InSQL&",'0'"
			InSQL = InSQL&",'"&Sex&"'"
			InSQL = InSQL&",'"&Sido&"'"
			InSQL = InSQL&",'"&Trim(TeamGb)&"'"
			InSQL = InSQL&",'"&Trim(Level)&"'"
			InSQL = InSQL&",'"&PlayerGb&"'"
			InSQL = InSQL&",'"&EnterType&"'"
			InSQL = InSQL&",'sd040001'"
			InSQL = InSQL&",'"&Trim(PlayerGrade)&"'"
			'후보여부
			InSQL = InSQL&",'N'"						
			InSQL = InSQL&",''"						
			InSQL = InSQL&",''"						
			InSQL = InSQL&",''"
			InSQL = InSQL&",''"
			InSQL = InSQL&",''"
			InSQL = InSQL&")"
'			Response.Write InSQL
'			Response.End
			Dbcon.Execute(InSQL)

			'신규참가신청 테이블 tblGameRequest insert==================================================

		
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
			'Response.End
		End If 
		
	Else
		'단체전일때
		ChkSQL = "SELECT"
		ChkSQL = ChkSQL&" Count(RGameGroupSchoolMasterIDX) AS Cnt"
		ChkSQL = ChkSQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster"
		ChkSQL = ChkSQL&" WHERE DelYN='N'"
		ChkSQL = ChkSQL&" AND Team='"&Team&"'"
		ChkSQL = ChkSQL&" AND RGameLevelIDX='"&RGameLevelIDX&"'"
		'Response.Write ChkSQL
		'Response.End

		Set CRs = Dbcon.Execute(ChkSQL)
		'단체전중복체크안함
'		If CRs("Cnt") > 0 Then 
'			Response.Write "SAME"
'			Response.End
'		Else
			
			NSQL = "SELECT"
			NSQL = NSQL&" TeamNm "
			NSQL = NSQL&" FROM SportsDiary.dbo.tblTeamInfo"
			NSQL = NSQL&" WHERE Team='"&Team&"'"

			Set NRs = Dbcon.Execute(NSQL)
			If Not (NRs.Eof Or NRs.Bof) Then 
				TeamNm = NRs("TeamNm")
			Else
				Response.Write "NONE"
				Response.End
			End If 
			
			NRs.Close
			Set NRs = Nothing 

			InSQL = "Insert Into SportsDiary.dbo.tblRGameGroupSchoolMaster"
			InSQL = InSQL&"("
			InSQL = InSQL&"WriteDate"
			InSQL = InSQL&",EditDate"
			InSQL = InSQL&",Team"
			InSQL = InSQL&",SportsGb"
			InSQL = InSQL&",TeamGb"
			InSQL = InSQL&",Sex"
			InSQL = InSQL&",Level"
			InSQL = InSQL&",SchoolName"
			InSQL = InSQL&",GroupGameGb"
			InSQL = InSQL&",RGameLevelIDX"
			InSQL = InSQL&",GameTitleIDX"
			InSQL = InSQL&",DelYN"
			InSQL = InSQL&")"
			InSQL = InSQL&" Values "
			InSQL = InSQL&"("
			InSQL = InSQL&"getdate()"
			InSQL = InSQL&",getdate()"
			InSQL = InSQL&",'"&Team&"'"
			InSQL = InSQL&",'"&SportsGb&"'"
			InSQL = InSQL&",'"&TeamGb&"'"
			InSQL = InSQL&",'"&Sex&"'"
			InSQL = InSQL&",'"&Level&"'"
			InSQL = InSQL&",'"&TeamNm&"'"
			InSQL = InSQL&",'"&GroupGameGb&"'"
			InSQL = InSQL&",'"&RGameLevelIDX&"'"
			InSQL = InSQL&",'"&GameTitleIDX&"'"
			InSQL = InSQL&",'N'"			
			InSQL = InSQL&")"
			
'			Response.Write InSQL
'			Response.End

			Dbcon.Execute(InSQL)



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
		'End If 단체전 중복체크 안함


		
	End If 
	Dbclose()
%>