<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
		RGameLevelIDX  = fInject(Request("RGameLevelIDX")) '"115" '
		GameTitleIDX   = fInject(Request("GameTitleIDX"))   '"39" '
		GroupGameGb    = fInject(Request("GroupGameGb")) ' "sd040002" '
		TeamGb         = fInject(Request("TeamGb")) ' "sd011001" '
		Sex            = fInject(Request("Sex"))   '"Man"
		Level          = fInject(Request("Level")) '"lv007007" '
		Team         = fInject(Request("Team")) '"18945" '
		PlayerIDX      = fInject(Request("PlayerIDX")) '"138" '
		SportsGb       = "judo"


		'RGameLevelIDX  ="470"
		'GameTitleIDX  ="49"
		'GroupGameGb  ="sd040002"
		'TeamGb  ="41002"
		'Sex  ="WoMan"
		'Level  =""
		'Team  ="JU02841"
		'PlayerIDX  ="6342"



	'중복체크
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
			SSQL = "SELECT"
			SSQL = SSQL&" Level"
			SSQL = SSQL&" ,UserName"
			SSQL = SSQL&" ,PlayerGrade "
			SSQL = SSQL&" FROM SportsDiary.dbo.tblPlayer"
			SSQL = SSQL&" WHERE PlayerIDX='"&PlayerIDX&"'"
			SSQL = SSQL&"  AND DelYN='N'"
			SSQL = SSQL&"  AND NowRegYN='Y'"

			Set SRs = Dbcon.Execute(SSQL)

			If Not(SRs.Eof Or SRs.Bof) Then 
				PlayerGrade = SRs("PlayerGrade")
				UserName    = SRs("UserName")
			Else
				Response.Write "NONE"
				Response.End
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
			'Response.Write InSQL
			'Response.End
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
			DSQL = DSQL&" AND GroupGameGb  ='sd040002'"
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
			InSQL = InSQL&",'sd040002'"
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


			Response.Write "TRUE"
			Response.End
		End If 

	CRs.Close
	Set CRs = Nothing 
	Dbclose()
%>