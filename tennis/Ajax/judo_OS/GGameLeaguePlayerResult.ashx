<%@ WebHandler Language="C#" Class="GGame_GGameLeaguePlayerResult" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameLeaguePlayerResult : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<League_return> list = new List<League_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            League_get objLeague_get = Deserialize<League_get>(strJson);

            if (objLeague_get != null)
            {

                string strRGameLevelidx = objLeague_get.RGameLevelidx;
                string strGroupGameGb = objLeague_get.GroupGameGb;
                string strPlayerIDX = objLeague_get.PlayerIDX;
                string strTeamDtl = objLeague_get.TeamDtl;
                string strGameType = objLeague_get.GameType;
                

                string strSql = "";
                string strWHERE = "";
                /*
                //개인전
                if (strGroupGameGb == "sd040001")
                {
                    strSql = "SELECT WinCnt, DrawCnt, LoseCnt, Jumsu, PlayerIDX, '' AS TeamDtl, RankNum"
                        + " FROM"
                        + " 	("
                        + " 	SELECT SUM(WinNum) AS WinCnt,"
                        + " 	SUM(DrawNum) AS DrawCnt,"
                        + " 	SUM(LoseNum) AS LoseCnt,"
                        + " 	SUM(Jumsu) AS Jumsu,"
                        + " 	PlayerIDX,"
                        + " 	DENSE_RANK() OVER (ORDER BY SUM(Jumsu) DESC, SUM(WinNum) DESC) AS RankNum"
                        + " 	FROM "
                        + " 		("
                        + " 		SELECT CASE WHEN PlayerResult <> '' "
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + " 			THEN 1 ELSE 0 END AS WinNum,"
                        + " 		CASE WHEN ISNULL(PlayerResult,'') = 'sd019024'"
                        + " 			THEN 1 ELSE 0 END AS DrawNum,"
                        + " 		CASE WHEN PlayerResult = '' OR ISNULL(PlayerResult,'') = 'sd019012'"
                        + " 			THEN 1 ELSE 0 END AS LoseNum,"
                        + " 		ISNULL(P1.PubJumsu,0) AS Jumsu, C.PlayerIDX"
                        + " 		FROM tblRgameLevel A"
                        + " 		INNER JOIN tblRPlayer B ON B.RGameLevelidx = A.RGameLevelidx"
                        + " 		LEFT JOIN ("
                        + "                     SELECT LPlayerIDX AS PlayerIDX,"
                        + "                     	  LPlayerResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  DelYN"
                        + "                     FROM tblRgameResult"
                        + "                     "
                        + "                     UNION ALL"
                        + "                     "
                        + "                     SELECT RPlayerIDX AS PlayerIDX,"
                        + "                     	  RPlayerResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  DelYN"
                        + "                     FROM tblRgameResult"
                        + "                 ) AS C ON C.RGameLevelidx = A.RGameLevelidx AND C.PlayerIDX = B.PlayerIDX"
                        + " 		LEFT JOIN tblPubCode P1 ON P1.PubCode = C.PlayerResult"
                        + " 		WHERE A.RGameLevelidx  = '" + strRGameLevelidx + "'"
                        + " 		AND A.DelYN = 'N'"
                        + " 		AND B.DelYN = 'N'"
                        + " 		AND (C.DelYN = 'N' OR C.DelYN IS NULL)"
                        + " 		) AS AA"
                        + " 	GROUP BY PlayerIDX"
                        + " 	) AS BB"
                        + " WHERE PlayerIDX = '" + strPlayerIDX + "'";
                }
                else {
                    strSql = " SELECT WinCnt, DrawCnt, LoseCnt, Jumsu, BB.Team, BB.TeamDtl, RankNum"
                        + " FROM"
                        + " 	("
                        + ""
                        + " 	SELECT SUM(WinNum) AS WinCnt,"
                        + " 	SUM(DrawNum) AS DrawCnt,"
                        + " 	SUM(LoseNum) AS LoseCnt,"
                        + " 	SUM(Jumsu) AS Jumsu,"
                        + " 	AA.Team, AA.TeamDtl, AA.RGameLevelidx,"
                        + "     DENSE_RANK() OVER (ORDER BY SUM(Jumsu) DESC, SUM(WinNum) DESC) AS RankNum"
                        + " 	FROM "
                        + " 		("
                        + " 		SELECT CASE WHEN PlayerResult <> '' "
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + " 			THEN 1 ELSE 0 END AS WinNum,"
                        + " 		CASE WHEN ISNULL(PlayerResult,'') = 'sd019024'"
                        + " 			THEN 1 ELSE 0 END AS DrawNum,"
                        + " 		CASE WHEN PlayerResult = '' OR ISNULL(PlayerResult,'') = 'sd019012'"
                        + " 			THEN 1 ELSE 0 END AS LoseNum,"
                        + " 		C.Team, C.TeamDtl, A.RGameLevelidx,"
                        + ""
                        + "		    CASE WHEN PlayerResult <> '' "
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + "			THEN CONVERT(bigint,Jumsu) ELSE 0 END AS Jumsu"
                        + ""
                        + " 		FROM tblRgameLevel A"
                        + " 		INNER JOIN tblRgameGroupSchool B ON B.RGameLevelidx = A.RGameLevelidx"
                        + " 		LEFT JOIN ("
                        + "                     SELECT LTeam AS Team,"
                        + "                     	  LTeamDtl AS TeamDtl,"                        
                        + "                     	  LResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  LJumsu AS Jumsu,"
                        + "                     	  DelYN"
                        + "                     FROM tblRgameGroup"
                        + ""
                        + "                     UNION ALL"
                        + ""
                        + "                     SELECT RTeam AS Team,"
                        + "                     	  RTeamDtl AS TeamDtl,"                            
                        + "                     	  RResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  RJumsu AS Jumsu,"                        
                        + "                     	  DelYN"
                        + "                     FROM tblRgameGroup"
                        + "                 ) AS C ON C.RGameLevelidx = A.RGameLevelidx AND C.Team = B.Team AND C.TeamDtl = B.TeamDtl"
                        + " 		WHERE A.RGameLevelidx  = '" + strRGameLevelidx + "'"
                        + " 		AND A.DelYN = 'N'"
                        + " 		AND B.DelYN = 'N'"
                        + " 		AND (C.DelYN = 'N' OR C.DelYN IS NULL)"
                        + " 		) AS AA"
                        + " 	GROUP BY AA.Team, AA.TeamDtl, AA.RGameLevelidx"
                        + ""
                        + " 	) AS BB"
                        + ""
                        + " WHERE BB.Team = '" + strPlayerIDX + "'"
                        + " AND BB.TeamDtl = '" + strTeamDtl + "'"
                        + " GROUP BY WinCnt, DrawCnt, Jumsu, LoseCnt, BB.Team, BB.TeamDtl, RankNum";
                }
                
                */

                //개인전
                if (strGroupGameGb == "sd040001")
                {

                    if (strGameType == "sd043004")
                    {
                        strWHERE = " AND C.GameNum IN ('2','3','4')";
                    }
                    
                    strSql = "SELECT WinCnt, DrawCnt, LoseCnt, Jumsu, PlayerIDX, '' AS Team, '' AS TeamDtl, RankNum"
                        + " FROM"
                        + " 	("
                        + " 	SELECT SUM(WinNum) AS WinCnt,"
                        + " 	SUM(DrawNum) AS DrawCnt,"
                        + " 	SUM(LoseNum) AS LoseCnt,"
                        + " 	SUM(CONVERT(FLOAT,Jumsu)) AS Jumsu,"
                        + " 	PlayerIDX,"
                        + " 	DENSE_RANK() OVER (ORDER BY SUM(ISNULL(WinNum,0)) DESC, SUM(CONVERT(FLOAT,Jumsu)) DESC) AS RankNum"
                        + " 	FROM "
                        + " 		("
                        + " 		SELECT CASE WHEN PlayerResult <> '' "
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + " 			THEN 1 ELSE 0 END AS WinNum,"
                        + " 		CASE WHEN ISNULL(PlayerResult,'') = 'sd019024'"
                        + " 			THEN 1 ELSE 0 END AS DrawNum,"
                        + " 		CASE WHEN PlayerResult = '' OR ISNULL(PlayerResult,'') = 'sd019012'"
                        + " 			THEN 1 ELSE 0 END AS LoseNum,"
                        + " 		C.Jumsu, C.PlayerIDX"
                        + " 		FROM tblRgameLevel A"
                        + " 		INNER JOIN tblRPlayer B ON B.RGameLevelidx = A.RGameLevelidx"
                        + " 		LEFT JOIN ("
                        + "                     SELECT LPlayerIDX AS PlayerIDX,"
                        + "                     	  LPlayerResult AS PlayerResult,"
                        + "                     	  LJumsu AS Jumsu,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  DelYN,"
                        + "                     	  GameNum"
                        + "                     FROM tblRgameResult"
                        + "                     "
                        + "                     UNION ALL"
                        + "                     "
                        + "                     SELECT RPlayerIDX AS PlayerIDX,"
                        + "                     	  RPlayerResult AS PlayerResult,"
                        + "                     	  RJumsu AS Jumsu,"                        
                        + "                     	  RGameLevelidx,"
                        + "                     	  DelYN,"
                        + "                     	  GameNum"
                        + "                     FROM tblRgameResult"
                        + "                 ) AS C ON C.RGameLevelidx = A.RGameLevelidx AND C.PlayerIDX = B.PlayerIDX"
                        + " 		WHERE A.RGameLevelidx  = '" + strRGameLevelidx + "'"
                        + " 		AND A.DelYN = 'N'"
                        + " 		AND B.DelYN = 'N'"
                        + " 		AND (C.DelYN = 'N' OR C.DelYN IS NULL)"
                        + strWHERE
                        + " 		) AS AA"
                        + " 	GROUP BY PlayerIDX"
                        + " 	) AS BB"
                        + " WHERE PlayerIDX = '" + strPlayerIDX + "'";
                }
                else
                {

                    if (strGameType == "sd043004")
                    {
                        strWHERE = " AND C.GroupGameNum IN ('2','3','4')";
                    }                    
                    
                    strSql = " SELECT WinCnt, DrawCnt, LoseCnt, Jumsu, '' AS PlayerIDX, BB.Team, BB.TeamDtl, RankNum"
                        + " FROM"
                        + " 	("
                        + ""
                        + " 	SELECT SUM(WinNum) AS WinCnt,"
                        + " 	SUM(DrawNum) AS DrawCnt,"
                        + " 	SUM(LoseNum) AS LoseCnt,"
                        + " 	SUM(Jumsu) AS Jumsu,"
                        + " 	AA.Team, AA.TeamDtl, AA.RGameLevelidx,"
                        + "     DENSE_RANK() OVER (ORDER BY SUM(ISNULL(WinNum,0)) DESC, SUM(CONVERT(FLOAT,Jumsu)) DESC) AS RankNum"
                        + " 	FROM "
                        + " 		("
                        + " 		SELECT CASE WHEN PlayerResult <> '' "
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + " 			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + " 			THEN 1 ELSE 0 END AS WinNum,"
                        + " 		CASE WHEN ISNULL(PlayerResult,'') = 'sd019024'"
                        + " 			THEN 1 ELSE 0 END AS DrawNum,"
                        + " 		CASE WHEN PlayerResult = '' OR ISNULL(PlayerResult,'') = 'sd019012'"
                        + " 			THEN 1 ELSE 0 END AS LoseNum,"
                        + " 		C.Team, C.TeamDtl, A.RGameLevelidx,"
                        + ""
                        + "		    CASE WHEN PlayerResult <> '' "
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019012'"
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019024'"
                        + "			AND ISNULL(PlayerResult,'') <> 'sd019021'"
                        + "			THEN CONVERT(FLOAT,Jumsu) ELSE 0 END AS Jumsu"
                        + ""
                        + " 		FROM tblRgameLevel A"
                        + " 		INNER JOIN tblRgameGroupSchool B ON B.RGameLevelidx = A.RGameLevelidx"
                        + " 		LEFT JOIN ("
                        + "                     SELECT LTeam AS Team,"
                        + "                     	  LTeamDtl AS TeamDtl,"
                        + "                     	  LResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  LJumsu AS Jumsu,"
                        + "                     	  DelYN,"
                        + "                     	  GroupGameNum"
                        + "                     FROM tblRgameGroup"
                        + ""
                        + "                     UNION ALL"
                        + ""
                        + "                     SELECT RTeam AS Team,"
                        + "                     	  RTeamDtl AS TeamDtl,"
                        + "                     	  RResult AS PlayerResult,"
                        + "                     	  RGameLevelidx,"
                        + "                     	  RJumsu AS Jumsu,"
                        + "                     	  DelYN,"
                        + "                     	  GroupGameNum"
                        + "                     FROM tblRgameGroup"
                        + "                 ) AS C ON C.RGameLevelidx = A.RGameLevelidx AND C.Team = B.Team AND C.TeamDtl = B.TeamDtl"
                        + " 		WHERE A.RGameLevelidx  = '" + strRGameLevelidx + "'"
                        + " 		AND A.DelYN = 'N'"
                        + " 		AND B.DelYN = 'N'"
                        + " 		AND (C.DelYN = 'N' OR C.DelYN IS NULL)"
                        + strWHERE
                        + " 		) AS AA"
                        + " 	GROUP BY AA.Team, AA.TeamDtl, AA.RGameLevelidx"
                        + ""
                        + " 	) AS BB"
                        + ""
                        + " WHERE BB.Team = '" + strPlayerIDX + "'"
                        + " AND BB.TeamDtl = '" + strTeamDtl + "'"
                        + " GROUP BY WinCnt, DrawCnt, Jumsu, LoseCnt, BB.Team, BB.TeamDtl, RankNum";
                }                
                
                
                                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    League_return League_returnItem = new League_return();


                    League_returnItem.WinCnt = reader["WinCnt"].ToString();
                    League_returnItem.DrawCnt = reader["DrawCnt"].ToString();
                    League_returnItem.LoseCnt = reader["LoseCnt"].ToString();
                    League_returnItem.Jumsu = reader["Jumsu"].ToString();
                    League_returnItem.RankNum = reader["RankNum"].ToString();    
                                    
                    list.Add(League_returnItem);

                }

                reader.Close();
                DsCom.Connection.Close();
                DbCon.Close();
                context.Response.Write(new JavaScriptSerializer().Serialize(list).ToString());
                
            }
            
        }
        catch (Exception ex)
        {
            context.Response.Write("Error :" + ex.Message);
        }
    
    }

    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
 

    public class League_return
    {                 

        private System.String r_WinCnt;
        private System.String r_DrawCnt;
        private System.String r_LoseCnt;
        private System.String r_Jumsu;
        private System.String r_RankNum;      
              
          
        public League_return()
        {
        
        }


        public string WinCnt { get { return r_WinCnt; } set { r_WinCnt = value; } }
        public string DrawCnt { get { return r_DrawCnt; } set { r_DrawCnt = value; } }
        public string LoseCnt { get { return r_LoseCnt; } set { r_LoseCnt = value; } }
        public string Jumsu { get { return r_Jumsu; } set { r_Jumsu = value; } }
        public string RankNum { get { return r_RankNum; } set { r_RankNum = value; } }
        
        
    }

    
    //값받는부분
    public class League_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameGb { get; set; }
        public string PlayerIDX { get; set; }
        public string TeamDtl { get; set; }
        public string GameType { get; set; }
        
        
    }    
    

    // Converts the specified JSON string to an object of type T
    public T Deserialize<T>(string context)
    {
        string jsonData = context;

        //cast to specified objectType
        var obj = (T)new JavaScriptSerializer().Deserialize<T>(jsonData);
        return obj;
    }


}