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
	SportsGb       = "judo"

	
	If seq = "" Then 
		Response.End
	End If 




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
			'단체전은 체급이없으므로 업데이트 하지 않음.
			'Dbcon.Execute(UpSQL)
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

		'tblGameRequest
		RUpdate = "Update SportsDiary.dbo.tblGameRequest"
		RUpdate = RUpdate&" SET PlayerCode='"&PlayerIDX&"'"
		RUpdate = RUpdate&" ,Team = '"&Team&"'"
		RUpdate = RUpdate&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
		RUpdate = RUpdate&" AND PlayerCode='"&Old_PlayerIDX&"'"
		RUpdate = RUpdate&" AND Team='"&Old_Team&"'"
		RUpdate = RUpdate&" AND GroupGameGb = 'sd040002'"
		RUpdate = RUpdate&" AND DelYN='N'"
		'Response.Write RUpdate
		'Response.End
		Dbcon.Execute(RUpdate)



		'출전선수정보 업데이트
		UpSQL2 = "Update SportsDiary.dbo.tblRPlayerMaster"
		UpSQL2 = UpSQL2&" SET "
		UpSQL2 = UpSQL2&" PlayerIDX = '"&PlayerIDX&"'"
		UpSQL2 = UpSQL2&" ,Team = '"&Team&"'"
		UpSQL2 = UpSQL2&" ,UserName = '"&UserName&"'"
		UpSQL2 = UpSQL2&" WHERE RPlayerMasterIDX = '"&seq&"'"

		Dbcon.Execute(UpSQL2)

		Response.Write "TRUE"
		Response.End




	DbClose()


	
%>