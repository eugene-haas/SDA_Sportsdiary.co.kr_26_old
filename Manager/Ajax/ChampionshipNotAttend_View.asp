<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "50"

	'조회조건 데이터
	Search_GameYear = fInject(Request("Search_GameYear"))
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))	
	Search_TeamGb       = fInject(Request("Search_TeamGb"))	
	Search_Sex          = fInject(Request("Search_Sex"))
	Search_Level        = fInject(Request("Search_Level"))
	player              = fInject(Request("player"))
	
	WSQL = ""
	
	if Search_GroupGameGb = "1" then '개인전
	
		If Search_GameYear <> "" Then 
			WSQL = WSQL&" AND C1.GameYear = '"&Search_GameYear&"'"
		End If 
	
		If Search_GameTitleIDX <> "" Then 
			WSQL = WSQL&" AND A1.GameTitleIDX = '"&Search_GameTitleIDX&"'"
		End If 

		If Search_TeamGb <> "" Then 
			WSQL = WSQL&" AND A1.TeamGb = '"&Search_TeamGb&"'"
		End If 	
	
		If Search_Sex <> "" Then 
			WSQL = WSQL&" AND A1.Sex = '"&Search_Sex&"'"
		End If 
		
		If Search_Level <> "" Then 
			WSQL = WSQL&" AND A1.LevelA = '"&Search_Level&"'"
		End If 
		
		If player <> "" Then 
			WSQL = WSQL&" AND (ISNULL(A1.LUserName,'') LIKE '%"&player&"%' OR ISNULL(A1.RUserName,'') LIKE '%"&player&"%')"
		End If
		
		LSQL = " SELECT TOP " & ViewCnt & " A1.RGameLevelidx RGameLevelidx"
		LSQL = LSQL & "      ,A1.GameTitleIDX GameTitleIDX"
		LSQL = LSQL & "      ,A1.GameTitleName GameTitleName"
		LSQL = LSQL & "      ,A1.TeamGb TeamGb"
		LSQL = LSQL & "      ,A1.GroupGameGbName GroupGameGbName"
		LSQL = LSQL & "      ,A1.GroupGameGb GroupGameGb"
		LSQL = LSQL & "      ,A1.Gender Gender"
		LSQL = LSQL & "      ,A1.Sex Sex"
		LSQL = LSQL & "      ,A1.Level Level"
		LSQL = LSQL & "      ,A1.LevelA LevelA"
		LSQL = LSQL & "      ,A1.Game1R Game1R"
		LSQL = LSQL & "      ,A1.LUserName LUserName"
		LSQL = LSQL & "      ,A1.RUserName RUserName"
		LSQL = LSQL & "      ,A1.LPlayerIDX LPlayerIDX"
		LSQL = LSQL & "      ,A1.RPlayerIDX RPlayerIDX"
		LSQL = LSQL & "      ,A1.LSchIDX LSchIDX"
		LSQL = LSQL & "      ,A1.RSchIDX RSchIDX"
		LSQL = LSQL & "      ,B1.LPlayerResult LPlayerResult"
		LSQL = LSQL & "      ,B1.RPlayerResult RPlayerResult"
		LSQL = LSQL & "      ,Sportsdiary.dbo.FN_PubName(B1.LPlayerResult) LPlayerResultNm"
		LSQL = LSQL & "      ,Sportsdiary.dbo.FN_PubName(B1.RPlayerResult) RPlayerResultNm "   
		LSQL = LSQL & "      ,B1.RGameResultIDX"
		LSQL = LSQL & "      ,CONVERT(VARCHAR,ISNULL(A1.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(A1.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(A1.Sex,''))+CONVERT(VARCHAR,ISNULL(A1.Level,''))+CONVERT(VARCHAR,ISNULL(A1.LPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.RPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.Game1R,''))+ISNULL(A1.TeamGb,'') NextKey    "
		LSQL = LSQL & "FROM ("
		LSQL = LSQL & "		SELECT A.RGameLevelidx RGameLevelidx"
		LSQL = LSQL & "            ,A.GameTitleIDX GameTitleIDX"
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName"
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName"
		LSQL = LSQL & "            ,CASE WHEN A.Sex = 'Man' THEN '남자' "
		LSQL = LSQL & "                  WHEN A.Sex = 'Woman' THEN '여자'" 
		LSQL = LSQL & "             ELSE '' END Gender "
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_PubName(A.Level) Level"
		LSQL = LSQL & "            ,A.Game1R Game1R"
		LSQL = LSQL & "            ,A.UserName LUserName"
		LSQL = LSQL & "            ,B.UserName RUserName"
		LSQL = LSQL & "            ,A.PlayerIDX LPlayerIDX"
		LSQL = LSQL & "            ,B.PlayerIDX RPlayerIDX"
		LSQL = LSQL & "            ,A.SchIDX LSchIDX"
		LSQL = LSQL & "            ,B.SchIDX RSchIDX"
		LSQL = LSQL & "            ,A.GroupGameGb GroupGameGb"
		LSQL = LSQL & "            ,A.Sex Sex"
		LSQL = LSQL & "            ,A.TeamGb TeamGb"
		LSQL = LSQL & "            ,A.Level LevelA"      
		LSQL = LSQL & "      FROM Sportsdiary.dbo.tblrplayer A"
		LSQL = LSQL & "      INNER JOIN Sportsdiary.dbo.tblrplayer B ON A.Game1R = B.Game1R"
		LSQL = LSQL & "               AND A.PlayerIDX <> B.PlayerIDX"
		LSQL = LSQL & "               AND B.RGameLevelidx = A.RGameLevelidx"
		LSQL = LSQL & "               AND A.PlayerNum < B.PlayerNum"
		LSQL = LSQL & "      WHERE (A.Game1R <> '')"
		LSQL = LSQL & "      AND A.Game1R is not null"
		LSQL = LSQL & "      AND A.DelYN = 'N'"
		LSQL = LSQL & "      AND A.GroupGameGb = 'sd040001'"
		LSQL = LSQL & "      "
		LSQL = LSQL & "      UNION ALL"
		LSQL = LSQL & "      "
		LSQL = LSQL & "		SELECT A.RGameLevelidx RGameLevelidx"
		LSQL = LSQL & "            ,A.GameTitleIDX GameTitleIDX"
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName"
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName"
		LSQL = LSQL & "            ,CASE WHEN A.Sex = 'Man' THEN '남자' "
		LSQL = LSQL & "                  WHEN A.Sex = 'Woman' THEN '여자' "
		LSQL = LSQL & "             ELSE '' END Gender "
		LSQL = LSQL & "            ,SportsDiary.dbo.FN_PubName(A.Level) Level"
		LSQL = LSQL & "            ,A.Game2R Game2R"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.UserName ELSE '' END LUserName"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.UserName ELSE '' END RUserName"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.PlayerIDX ELSE '' END LUserName"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.PlayerIDX ELSE '' END RUserName"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.SchIDX ELSE '' END LUserName"
		LSQL = LSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.SchIDX ELSE '' END RUserName"
		LSQL = LSQL & "            ,A.GroupGameGb GroupGameGb"
		LSQL = LSQL & "            ,A.Sex Sex"
		LSQL = LSQL & "            ,A.TeamGb TeamGb"
		LSQL = LSQL & "            ,A.LevelA LevelA " 
		LSQL = LSQL & "      FROM"
		LSQL = LSQL & "			("
		LSQL = LSQL & "			SELECT RGameLevelidx RGameLevelidx"
		LSQL = LSQL & "				  ,GameTitleIDX GameTitleIDX"
		LSQL = LSQL & "				  ,SportsDiary.dbo.FN_GameTitleName(GameTitleIDX) AS GameTitleName"
		LSQL = LSQL & "				  ,SportsDiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName"
		LSQL = LSQL & "				  ,CASE WHEN Sex = 'Man' THEN '남자' "
		LSQL = LSQL & "						WHEN Sex = 'Woman' THEN '여자' "
		LSQL = LSQL & "				   ELSE '' END Gender "
		LSQL = LSQL & "				  ,SportsDiary.dbo.FN_PubName(Level) Level"
		LSQL = LSQL & "				  ,Game2R Game2R "
		LSQL = LSQL & "				  ,GroupGameGb GroupGameGb"
		LSQL = LSQL & "				  ,Sex Sex"
		LSQL = LSQL & "				  ,TeamGb TeamGb"
		LSQL = LSQL & "				  ,Level LevelA"   
		LSQL = LSQL & "				  ,UserName"
		LSQL = LSQL & "				  ,PlayerIDX"
		LSQL = LSQL & "				  ,SchIDX"
		LSQL = LSQL & "				  ,SportsDiary.dbo.FN_PlayerLeftRight(RGameLevelidx, PlayerIDX,Game2R) AS LRGubun"
		LSQL = LSQL & "			FROM Sportsdiary.dbo.tblrplayer"
		LSQL = LSQL & "			WHERE (UnearnWin = 'sd042002')"
		LSQL = LSQL & "			AND Game1R is not null"
		LSQL = LSQL & "			AND DelYN = 'N'"
		LSQL = LSQL & "			AND GroupGameGb = 'sd040001'"
		LSQL = LSQL & ""
		LSQL = LSQL & "			) AS A"
		LSQL = LSQL & ""
		LSQL = LSQL & " ) A1"
		LSQL = LSQL & "   LEFT OUTER JOIN (SELECT  LPlayerIDX "
		LSQL = LSQL & "                           ,RPlayerIDX "
		LSQL = LSQL & "                           ,LPlayerResult "
		LSQL = LSQL & "                           ,RPlayerResult "
		LSQL = LSQL & "                           ,GameTitleIDX "
		LSQL = LSQL & "                           ,GroupGameGb "
		LSQL = LSQL & "                           ,Sex "
		LSQL = LSQL & "                           ,Level "
		LSQL = LSQL & "                           ,GroupGameNum"
		LSQL = LSQL & "                           ,GameNum "
		LSQL = LSQL & "                           ,RGameResultIDX"
		LSQL = LSQL & "                     FROM Sportsdiary.dbo.tblRgameResult "
		LSQL = LSQL & "                     WHERE DelYN = 'N' ) B1 ON    A1.GameTitleIDX = B1.GameTitleIDX "
		LSQL = LSQL & "                                             AND A1.GroupGameGb = B1.GroupGameGb "
		LSQL = LSQL & "                                             AND A1.Sex = B1.Sex "
		LSQL = LSQL & "                                             AND A1.LevelA = B1.Level"
		LSQL = LSQL & "                                             --AND A1.LPlayerIDX = B1.LPlayerIDX"
		LSQL = LSQL & "                                             -- AND A1.RPlayerIDX = B1.RPlayerIDX"
		LSQL = LSQL & "                                             AND A1.Game1R = B1.GameNum"
		LSQL = LSQL & "    LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX"
		LSQL = LSQL & "                           ,GameYear GameYear "
		LSQL = LSQL & "                     FROM SportsDiary.dbo.tblGameTitle "
		LSQL = LSQL & "                     WHERE DelYN='N') C1 ON A1.GameTitleIDX = C1.GameTitleIDX 	 "
		LSQL = LSQL & "WHERE A1.GameTitleIDX <> 0 "

    
    If Trim(strkey) <> "" Then 
			LSQL = LSQL & " AND (CONVERT(VARCHAR,ISNULL(A1.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(A1.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(A1.Sex,''))+CONVERT(VARCHAR,ISNULL(A1.Level,''))+CONVERT(VARCHAR,ISNULL(A1.LPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.RPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.Game1R,''))+ISNULL(A1.TeamGb,'')) < '" & strkey & "'"
		End If 
		
    LSQL = LSQL & WSQL        			
				
		LSQL = LSQL & " ORDER BY (CONVERT(VARCHAR,ISNULL(A1.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(A1.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(A1.Sex,''))+CONVERT(VARCHAR,ISNULL(A1.Level,''))+CONVERT(VARCHAR,ISNULL(A1.LPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.RPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.Game1R,''))+ISNULL(A1.TeamGb,'')) DESC "
		
		
		
	  CNTSQL = " SELECT COUNT(A2.RGameLevelidx) CNT "
		CNTSQL = CNTSQL & "      ,A1.GameTitleIDX GameTitleIDX"
		CNTSQL = CNTSQL & "      ,A1.GameTitleName GameTitleName"
		CNTSQL = CNTSQL & "      ,A1.TeamGb TeamGb"
		CNTSQL = CNTSQL & "      ,A1.GroupGameGbName GroupGameGbName"
		CNTSQL = CNTSQL & "      ,A1.GroupGameGb GroupGameGb"
		CNTSQL = CNTSQL & "      ,A1.Gender Gender"
		CNTSQL = CNTSQL & "      ,A1.Sex Sex"
		CNTSQL = CNTSQL & "      ,A1.Level Level"
		CNTSQL = CNTSQL & "      ,A1.LevelA LevelA"
		CNTSQL = CNTSQL & "      ,A1.Game1R Game1R"
		CNTSQL = CNTSQL & "      ,A1.LUserName LUserName"
		CNTSQL = CNTSQL & "      ,A1.RUserName RUserName"
		CNTSQL = CNTSQL & "      ,A1.LPlayerIDX LPlayerIDX"
		CNTSQL = CNTSQL & "      ,A1.RPlayerIDX RPlayerIDX"
		CNTSQL = CNTSQL & "      ,A1.LSchIDX LSchIDX"
		CNTSQL = CNTSQL & "      ,A1.RSchIDX RSchIDX"
		CNTSQL = CNTSQL & "      ,B1.LPlayerResult LPlayerResult"
		CNTSQL = CNTSQL & "      ,B1.RPlayerResult RPlayerResult"
		CNTSQL = CNTSQL & "      ,Sportsdiary.dbo.FN_PubName(B1.LPlayerResult) LPlayerResultNm"
		CNTSQL = CNTSQL & "      ,Sportsdiary.dbo.FN_PubName(B1.RPlayerResult) RPlayerResultNm "   
		CNTSQL = CNTSQL & "      ,B1.RGameResultIDX"
		CNTSQL = CNTSQL & "      ,CONVERT(VARCHAR,ISNULL(A1.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(A1.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(A1.Sex,''))+CONVERT(VARCHAR,ISNULL(A1.Level,''))+CONVERT(VARCHAR,ISNULL(A1.LPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.RPlayerIDX,''))+CONVERT(VARCHAR,ISNULL(A1.Game1R,''))+ISNULL(A1.TeamGb,'') NextKey    "
		CNTSQL = CNTSQL & "FROM ("
		CNTSQL = CNTSQL & "		SELECT A.RGameLevelidx RGameLevelidx"
		CNTSQL = CNTSQL & "            ,A.GameTitleIDX GameTitleIDX"
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName"
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName"
		CNTSQL = CNTSQL & "            ,CASE WHEN A.Sex = 'Man' THEN '남자' "
		CNTSQL = CNTSQL & "                  WHEN A.Sex = 'Woman' THEN '여자'" 
		CNTSQL = CNTSQL & "             ELSE '' END Gender "
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_PubName(A.Level) Level"
		CNTSQL = CNTSQL & "            ,A.Game1R Game1R"
		CNTSQL = CNTSQL & "            ,A.UserName LUserName"
		CNTSQL = CNTSQL & "            ,B.UserName RUserName"
		CNTSQL = CNTSQL & "            ,A.PlayerIDX LPlayerIDX"
		CNTSQL = CNTSQL & "            ,B.PlayerIDX RPlayerIDX"
		CNTSQL = CNTSQL & "            ,A.SchIDX LSchIDX"
		CNTSQL = CNTSQL & "            ,B.SchIDX RSchIDX"
		CNTSQL = CNTSQL & "            ,A.GroupGameGb GroupGameGb"
		CNTSQL = CNTSQL & "            ,A.Sex Sex"
		CNTSQL = CNTSQL & "            ,A.TeamGb TeamGb"
		CNTSQL = CNTSQL & "            ,A.Level LevelA"      
		CNTSQL = CNTSQL & "      FROM Sportsdiary.dbo.tblrplayer A"
		CNTSQL = CNTSQL & "      INNER JOIN Sportsdiary.dbo.tblrplayer B ON A.Game1R = B.Game1R"
		CNTSQL = CNTSQL & "               AND A.PlayerIDX <> B.PlayerIDX"
		CNTSQL = CNTSQL & "               AND B.RGameLevelidx = A.RGameLevelidx"
		CNTSQL = CNTSQL & "               AND A.PlayerNum < B.PlayerNum"
		CNTSQL = CNTSQL & "      WHERE (A.Game1R <> '')"
		CNTSQL = CNTSQL & "      AND A.Game1R is not null"
		CNTSQL = CNTSQL & "      AND A.DelYN = 'N'"
		CNTSQL = CNTSQL & "      AND A.GroupGameGb = 'sd040001'"
		CNTSQL = CNTSQL & "      "
		CNTSQL = CNTSQL & "      UNION ALL"
		CNTSQL = CNTSQL & "      "
		CNTSQL = CNTSQL & "		SELECT A.RGameLevelidx RGameLevelidx"
		CNTSQL = CNTSQL & "            ,A.GameTitleIDX GameTitleIDX"
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName"
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName"
		CNTSQL = CNTSQL & "            ,CASE WHEN A.Sex = 'Man' THEN '남자' "
		CNTSQL = CNTSQL & "                  WHEN A.Sex = 'Woman' THEN '여자' "
		CNTSQL = CNTSQL & "             ELSE '' END Gender "
		CNTSQL = CNTSQL & "            ,SportsDiary.dbo.FN_PubName(A.Level) Level"
		CNTSQL = CNTSQL & "            ,A.Game2R Game2R"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.UserName ELSE '' END LUserName"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.UserName ELSE '' END RUserName"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.PlayerIDX ELSE '' END LUserName"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.PlayerIDX ELSE '' END RUserName"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Left' Then A.SchIDX ELSE '' END LUserName"
		CNTSQL = CNTSQL & "            ,CASE WHEN LRGubun = 'Right' Then A.SchIDX ELSE '' END RUserName"
		CNTSQL = CNTSQL & "            ,A.GroupGameGb GroupGameGb"
		CNTSQL = CNTSQL & "            ,A.Sex Sex"
		CNTSQL = CNTSQL & "            ,A.TeamGb TeamGb"
		CNTSQL = CNTSQL & "            ,A.LevelA LevelA " 
		CNTSQL = CNTSQL & "      FROM"
		CNTSQL = CNTSQL & "			("
		CNTSQL = CNTSQL & "			SELECT RGameLevelidx RGameLevelidx"
		CNTSQL = CNTSQL & "				  ,GameTitleIDX GameTitleIDX"
		CNTSQL = CNTSQL & "				  ,SportsDiary.dbo.FN_GameTitleName(GameTitleIDX) AS GameTitleName"
		CNTSQL = CNTSQL & "				  ,SportsDiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName"
		CNTSQL = CNTSQL & "				  ,CASE WHEN Sex = 'Man' THEN '남자' "
		CNTSQL = CNTSQL & "						WHEN Sex = 'Woman' THEN '여자' "
		CNTSQL = CNTSQL & "				   ELSE '' END Gender "
		CNTSQL = CNTSQL & "				  ,SportsDiary.dbo.FN_PubName(Level) Level"
		CNTSQL = CNTSQL & "				  ,Game2R Game2R "
		CNTSQL = CNTSQL & "				  ,GroupGameGb GroupGameGb"
		CNTSQL = CNTSQL & "				  ,Sex Sex"
		CNTSQL = CNTSQL & "				  ,TeamGb TeamGb"
		CNTSQL = CNTSQL & "				  ,Level LevelA"   
		CNTSQL = CNTSQL & "				  ,UserName"
		CNTSQL = CNTSQL & "				  ,PlayerIDX"
		CNTSQL = CNTSQL & "				  ,SchIDX"
		CNTSQL = CNTSQL & "				  ,SportsDiary.dbo.FN_PlayerLeftRight(RGameLevelidx, PlayerIDX,Game2R) AS LRGubun"
		CNTSQL = CNTSQL & "			FROM Sportsdiary.dbo.tblrplayer"
		CNTSQL = CNTSQL & "			WHERE (UnearnWin = 'sd042002')"
		CNTSQL = CNTSQL & "			AND Game1R is not null"
		CNTSQL = CNTSQL & "			AND DelYN = 'N'"
		CNTSQL = CNTSQL & "			AND GroupGameGb = 'sd040001'"
		CNTSQL = CNTSQL & ""
		CNTSQL = CNTSQL & "			) AS A"
		CNTSQL = CNTSQL & ""
		CNTSQL = CNTSQL & " ) A1"
		CNTSQL = CNTSQL & "   LEFT OUTER JOIN (SELECT  LPlayerIDX "
		CNTSQL = CNTSQL & "                           ,RPlayerIDX "
		CNTSQL = CNTSQL & "                           ,LPlayerResult "
		CNTSQL = CNTSQL & "                           ,RPlayerResult "
		CNTSQL = CNTSQL & "                           ,GameTitleIDX "
		CNTSQL = CNTSQL & "                           ,GroupGameGb "
		CNTSQL = CNTSQL & "                           ,Sex "
		CNTSQL = CNTSQL & "                           ,Level "
		CNTSQL = CNTSQL & "                           ,GroupGameNum"
		CNTSQL = CNTSQL & "                           ,GameNum "
		CNTSQL = CNTSQL & "                           ,RGameResultIDX"
		CNTSQL = CNTSQL & "                     FROM Sportsdiary.dbo.tblRgameResult "
		CNTSQL = CNTSQL & "                     WHERE DelYN = 'N' ) B1 ON    A1.GameTitleIDX = B1.GameTitleIDX "
		CNTSQL = CNTSQL & "                                             AND A1.GroupGameGb = B1.GroupGameGb "
		CNTSQL = CNTSQL & "                                             AND A1.Sex = B1.Sex "
		CNTSQL = CNTSQL & "                                             AND A1.LevelA = B1.Level"
		CNTSQL = CNTSQL & "                                             --AND A1.LPlayerIDX = B1.LPlayerIDX"
		CNTSQL = CNTSQL & "                                             -- AND A1.RPlayerIDX = B1.RPlayerIDX"
		CNTSQL = CNTSQL & "                                             AND A1.Game1R = B1.GameNum"
		CNTSQL = CNTSQL & "    LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX"
		CNTSQL = CNTSQL & "                           ,GameYear GameYear "
		CNTSQL = CNTSQL & "                     FROM SportsDiary.dbo.tblGameTitle "
		CNTSQL = CNTSQL & "                     WHERE DelYN='N') C1 ON A1.GameTitleIDX = C1.GameTitleIDX 	 "
		CNTSQL = CNTSQL & "WHERE A1.GameTitleIDX <> 0 "
	end if

	Dbopen()
  Set LRs = Dbcon.Execute(LSQL)
	Set CRs = Dbcon.Execute(CNTSQL)

	'다음조회 데이타는 행을 변경한다
	If Strtp = "N" Then 
	End If 

%>
<%
	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
		Response.End
	Else 
%>
	<%
		intCnt = 0

		Do Until LRs.Eof 										
	%>
	
	<tr>		
		<td style="cursor:pointer;text-align:left;padding-left:10px;"><%=LRs("GameTitleName")%></td>
		<td style="cursor:pointer;"><%=LRs("GroupGameGbName")%></td>
		<td style="cursor:pointer;"><%=LRs("Gender")%></td>
		<td style="cursor:pointer;"><%=LRs("Level")%></td>
		<td style="cursor:pointer;"><%=LRs("Game1R")%></td>		
		<td style="cursor:pointer;"><%=LRs("LUserName")%></td>	
		<td style="cursor:pointer;color:blue;" onclick="relt_update('B','<%=Search_GroupGameGb%>','<%=LRs("LPlayerIDX")%>','<%=LRs("RPlayerIDX")%>','<%=LRs("LUserName")%>','<%=LRs("RUserName")%>','<%=LRs("LPlayerResult")%>','<%=LRs("RPlayerResult")%>','<%=LRs("GameTitleIDX")%>','<%=LRs("GroupGameGb")%>','<%=LRs("Sex")%>','<%=LRs("Gender")%>','<%=LRs("LevelA")%>','<%=LRs("RGameLevelidx")%>','<%=LRs("TeamGb")%>','<%=LRs("Game1R")%>','<%=LRs("LSchIDX")%>','<%=LRs("RSchIDX")%>');">불참처리</td>	
		<td style="cursor:pointer;"><%=LRs("LPlayerResultNm")%></td>
		<td style="cursor:pointer;"><%=LRs("RUserName")%></td>		
		<td style="cursor:pointer;color:blue;" onclick="relt_update('C','<%=Search_GroupGameGb%>','<%=LRs("LPlayerIDX")%>','<%=LRs("RPlayerIDX")%>','<%=LRs("LUserName")%>','<%=LRs("RUserName")%>','<%=LRs("LPlayerResult")%>','<%=LRs("RPlayerResult")%>','<%=LRs("GameTitleIDX")%>','<%=LRs("GroupGameGb")%>','<%=LRs("Sex")%>','<%=LRs("Gender")%>','<%=LRs("LevelA")%>','<%=LRs("RGameLevelidx")%>','<%=LRs("TeamGb")%>','<%=LRs("Game1R")%>','<%=LRs("LSchIDX")%>','<%=LRs("RSchIDX")%>');">불참처리</td>	
		<td style="cursor:pointer;"><%=LRs("RPlayerResultNm")%></td>
								
		<td style="cursor:pointer;color:red;" onclick="relt_update('A','<%=Search_GroupGameGb%>','<%=LRs("LPlayerIDX")%>','<%=LRs("RPlayerIDX")%>','<%=LRs("LUserName")%>','<%=LRs("RUserName")%>','<%=LRs("LPlayerResult")%>','<%=LRs("RPlayerResult")%>','<%=LRs("GameTitleIDX")%>','<%=LRs("GroupGameGb")%>','<%=LRs("Sex")%>','<%=LRs("Gender")%>','<%=LRs("LevelA")%>','<%=LRs("RGameLevelidx")%>','<%=LRs("TeamGb")%>','<%=LRs("Game1R")%>','<%=LRs("LSchIDX")%>','<%=LRs("RSchIDX")%>');">동시불참처리</td>		
			
	</tr>
<%
			'다음조회를 위하여 키를 생성한다.
			strsetkey = LRs("NextKey")				
			LRs.MoveNext
			intCnt = intCnt + 1
		Loop 
%>
		ㅹ<%=encode(strsetkey,0)%>ㅹ<%=StrTp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
	End If 
%>
<% LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing

	Dbclose()
%>
