<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<%
Medal_Type = 	fInject(Request("MedalType"))
MasterIDX = 	fInject(Request("MasterIDX"))
Grouptype = 	fInject(Request("Grouptype"))

Response.Write Medal_Type&"<br>"
Response.Write MasterIDX&"<br>"
Response.Write Grouptype&"<br>"


'개인전
If Grouptype = "sd040001" Then 
	'메달타입이 없는 경우 메달 테이블 데이터 조회 후 삭제 처리
	If Medal_Type = "" Then
		'마스터의idx 로 조회
		LSQL = "SELECT RGameLevelIDX,SchIDX,SportsGb,TeamGb,Sex,GroupGameGb,GameTitleIDX,Level,PlayerIDX FROM tblRPlayerMaster Where RPlayerMasterIDX='"&MasterIDX&"'"
		Set LRs = Dbcon.Execute(LSQL)
		
		If Not(LRs.Eof Or LRs.Bof) Then 
			'학교 메달이 있는 경우 삭제 처리
			If Not(LRs.Eof Or LRs.Bof) Then 
				DelSQL = "Update tblGameScore"
				DelSQL = DelSQL&" Set DelYN='Y'"
				DelSQL = DelSQL&" ,MemoLog='수동삭제'"
				DelSQL = DelSQL&" WHERE DelYN='N' "
				DelSQL = DelSQL&" AND RgameLevelIDX='"&LRs("RGameLevelIDX")&"'"
				DelSQL = DelSQL&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
				DelSQL = DelSQL&" AND SportsGb='judo'"
				DelSQL = DelSQL&" AND Sex='"&LRs("Sex")&"'"
				DelSQL = DelSQL&" AND TeamGb='"&LRs("TeamGb")&"'"
				DelSQL = DelSQL&" AND GroupGameGb='sd040001'"
				DelSQL = DelSQL&" AND SchIDX='"&LRs("SchIDX")&"'"
				DelSQL = DelSQL&" AND Level='"&LRs("Level")&"'"
				DelSQL = DelSQL&" AND PlayerIDX='"&LRs("PlayerIDX")&"'"
				Dbcon.Execute(DelSQL)
				Response.Write "Del"
				Response.End
			End If 
		End If 
	Else
		'해당선수 입력 필드 셀렉트
		LSQL = "SELECT GameTitleIDX,RGameLevelIDX,SchIDX,SportsGb,TeamGb,Sex,Level,PlayerIDX,GroupGameGb FROM Sportsdiary.dbo.tblRPlayerMaster Where RPlayerMasterIDX='"&MasterIDX&"'"
		Set LRs = Dbcon.Execute(LSQL)		

		If Not(LRs.Eof Or LRs.Bof) Then 
			'기존정보가 있다면 삭제 처리
			DelSQL = "Update tblGameScore"
			DelSQL = DelSQL&" Set DelYN='Y'"
			DelSQL = DelSQL&" ,MemoLog='수동삭제'"
			DelSQL = DelSQL&" WHERE DelYN='N' "
			DelSQL = DelSQL&" AND RgameLevelIDX='"&LRs("RGameLevelIDX")&"'"
			DelSQL = DelSQL&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
			DelSQL = DelSQL&" AND SportsGb='judo'"
			DelSQL = DelSQL&" AND Sex='"&LRs("Sex")&"'"
			DelSQL = DelSQL&" AND TeamGb='"&LRs("TeamGb")&"'"
			DelSQL = DelSQL&" AND GroupGameGb='sd040002'"
			DelSQL = DelSQL&" AND SchIDX='"&LRs("SchIDX")&"'"
				DelSQL = DelSQL&" AND Level='"&LRs("Level")&"'"
				DelSQL = DelSQL&" AND PlayerIDX='"&LRs("PlayerIDX")&"'"

  		Dbcon.Execute(DelSQL)
			'해당대회체급매달 정보 입력
			'대회체급IDX,대회IDX,종목구분,팀구분,체급,선수IDX,단체전개인전구분,메달단체전개인전구분,학교IDX,성별,메달IDX,게임랭킹,삭제여부,작성일
			'RGameLevelidx,GameTitleIDX,SportsGb,TEamGb,Level,PlayerIDx,GroupGameGb,MedelGubun,SchIDX,Sex,TitleResult,GameRanking,DelYN,WriteDate
			'505	72	20	judo	sd011003	lv003008	441	sd040001	sd033001	18573	Man	sd034003	3	N	2016-11-28 14:15:19.467
			InSQL = " INSERT INTO SportsDiary.dbo.tblGameScore "
			InSQL = InSQL&"(RGameLevelIDX,GameTitleIDX, SportsGb, TeamGb, Level,PlayerIDX, GroupGameGb,MedelGubun, SchIDX, Sex, TitleResult, GameRanking,MemoLog)"
			InSQL = InSQL&" VALUES "
			InSQL = InSQL&"("
			InSQL = InSQL&"'"&LRs("RGameLevelIDX")&"'"
			InSQL = InSQL&",'"&LRs("GameTitleIDX")&"'"
			InSQL = InSQL&",'judo'"
			InSQL = InSQL&",'"&LRs("TeamGb")&"'"
			InSQL = InSQL&",'"&LRs("Level")&"'"
			InSQL = InSQL&",'"&LRs("PlayerIDX")&"'"
			InSQL = InSQL&",'sd040001'"
			InSQL = InSQL&",'"&Medal_Type&"'"
			InSQL = InSQL&",'"&LRs("SchIDX")&"'"
			InSQL = InSQL&",'"&LRs("Sex")&"'"
			InSQL = InSQL&",'"&Medal_Type&"'"
			InSQL = InSQL&",'"&Medal_Score(Medal_Type)&"'"
			InSQL = InSQL&",'수동메달'"
			InSQL = InSQL&")"   
			Dbcon.Execute(InSQL)
			Response.Write "Ins"
			Response.End			
		End If 
	End If 

	


ElseIf Grouptype = "sd040002" Then 
'단체전
	If Medal_Type = "" Then 
		'메달타입이 없는 경우 메달 테이블 데이터 조회 후 삭제 처리
		LSQL = "SELECT RGameLevelIDX,SchIDX,SportsGb,TeamGb,Sex,SchoolName,GroupGameGb,GameTitleIDX FROM Sportsdiary.dbo.tblRGameGroupSchoolMaster Where RGameGroupSchoolMasterIDX='"&MasterIDX&"'"
		Set LRs = Dbcon.Execute(LSQL)
		
		'학교 메달이 있는 경우 삭제 처리
		If Not(LRs.Eof Or LRs.Bof) Then 
			DelSQL = "Update tblGameScore"
			DelSQL = DelSQL&" Set DelYN='Y'"
			DelSQL = DelSQL&" ,MemoLog='수동삭제'"
			DelSQL = DelSQL&" WHERE DelYN='N' "
			DelSQL = DelSQL&" AND RgameLevelIDX='"&LRs("RGameLevelIDX")&"'"
			DelSQL = DelSQL&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
			DelSQL = DelSQL&" AND SportsGb='judo'"
			DelSQL = DelSQL&" AND Sex='"&LRs("Sex")&"'"
			DelSQL = DelSQL&" AND TeamGb='"&LRs("TeamGb")&"'"
			DelSQL = DelSQL&" AND GroupGameGb='sd040002'"
			DelSQL = DelSQL&" AND SchIDX='"&LRs("SchIDX")&"'"
  		Dbcon.Execute(DelSQL)
			Response.Write "Del"
			Response.End
		End If 
	Else
		'해당학교 입력 필드 셀렉트
		LSQL = "SELECT GameTitleIDX,RGameLevelIDX,SchIDX,SportsGb,TeamGb,Sex,SchoolName,GroupGameGb FROM Sportsdiary.dbo.tblRGameGroupSchoolMaster Where RGameGroupSchoolMasterIDX='"&MasterIDX&"'"
		Set LRs = Dbcon.Execute(LSQL)		

		If Not(LRs.Eof Or LRs.Bof) Then 
			'기존정보가 있다면 삭제 처리
			DelSQL = "Update tblGameScore"
			DelSQL = DelSQL&" Set DelYN='Y'"
			DelSQL = DelSQL&" ,MemoLog='수동삭제'"
			DelSQL = DelSQL&" WHERE DelYN='N' "
			DelSQL = DelSQL&" AND RgameLevelIDX='"&LRs("RGameLevelIDX")&"'"
			DelSQL = DelSQL&" AND GameTitleIDX='"&LRs("GameTitleIDX")&"'"
			DelSQL = DelSQL&" AND SportsGb='judo'"
			DelSQL = DelSQL&" AND Sex='"&LRs("Sex")&"'"
			DelSQL = DelSQL&" AND TeamGb='"&LRs("TeamGb")&"'"
			DelSQL = DelSQL&" AND GroupGameGb='sd040002'"
			DelSQL = DelSQL&" AND SchIDX='"&LRs("SchIDX")&"'"
  		Dbcon.Execute(DelSQL)


			'해당대회체급매달 정보 입력
			'대회체급IDX,대회IDX,종목구분,팀구분,체급,선수IDX,단체전개인전구분,메달단체전개인전구분,학교IDX,성별,메달IDX,게임랭킹,삭제여부,작성일
			'RGameLevelidx,GameTitleIDX,SportsGb,TEamGb,Level,PlayerIDx,GroupGameGb,MedelGubun,SchIDX,Sex,TitleResult,GameRanking,DelYN,WriteDate
			'505	72	20	judo	sd011003	lv003008	441	sd040001	sd033001	18573	Man	sd034003	3	N	2016-11-28 14:15:19.467
			InSQL = " INSERT INTO SportsDiary.dbo.tblGameScore "
			InSQL = InSQL&"(RGameLevelIDX,GameTitleIDX, SportsGb, TeamGb, PlayerIDX, GroupGameGb,MedelGubun, SchIDX, Sex, TitleResult, GameRanking,MemoLog)"
			InSQL = InSQL&" VALUES "
			InSQL = InSQL&"("
			InSQL = InSQL&"'"&LRs("RGameLevelIDX")&"'"
			InSQL = InSQL&",'"&LRs("GameTitleIDX")&"'"
			InSQL = InSQL&",'judo'"
			InSQL = InSQL&",'"&LRs("TeamGb")&"'"
			InSQL = InSQL&",'0'"
			InSQL = InSQL&",'sd040002'"
			InSQL = InSQL&",'"&Medal_Type&"'"
			InSQL = InSQL&",'"&LRs("SchIDX")&"'"
			InSQL = InSQL&",'"&LRs("Sex")&"'"
			InSQL = InSQL&",'"&Medal_Type&"'"
			InSQL = InSQL&",'"&Medal_Score(Medal_Type)&"'"
			InSQL = InSQL&",'수동메달'"
			InSQL = InSQL&")"   
			Dbcon.Execute(InSQL)
			Response.Write "Ins"
			Response.End			
		End If 
	End If 

End If 



%>