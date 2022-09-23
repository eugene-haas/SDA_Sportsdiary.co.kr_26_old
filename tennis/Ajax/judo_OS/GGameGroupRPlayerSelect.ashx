<%@ WebHandler Language="C#" Class="GGame_GGameGroupRPlayerSelect" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupRPlayerSelect : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<GPlayerList_return> list = new List<GPlayerList_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            GPlayerList_get objGPlayerList_get = Deserialize<GPlayerList_get>(strJson);

            if (objGPlayerList_get != null)
            {
                string strRGameLevelidx = objGPlayerList_get.RGameLevelidx;
                string strGroupGameNum = objGPlayerList_get.GroupGameNum;
                string strGameType = objGPlayerList_get.GameType;
                
                
              /*
                string strSql = " SELECT LP.UserName AS LUserName, SportsDiary.dbo.FN_PubName(LP.Level) AS LLevelName, P3.PubName AS LPlayerResult, P3.PubJumsu AS LJumsu,"
                + " CASE WHEN LPlayerResult IS NOT NULL THEN "
                + " (SELECT TOP 1 Sportsdiary.dbo.FN_PubName_Spec(LSpecialtyDtl) "
                + "  FROM tblRgameResultDtl "
                + "  WHERE RGameLevelidx = '" + strRGameLevelidx + "'"
                + "  AND GroupGameNum = '" + strGroupGameNum + "'"
                + "  AND GameNum = LP.Game1R"
                + "  AND DelYN = 'N'"
                + "  AND LPlayerIDX = LP.PlayerIDX"
                + "  AND LSpecialtyDtl <> '' "
                + "  AND SportsGb = 'judo' "                                
                + "  ORDER BY RGameResultDtlIdx DESC "
                + "  ) ELSE NULL END AS LFinalSkill, "
                + "  CASE WHEN RPlayerResult IS NOT NULL THEN "
                + " (SELECT TOP 1 Sportsdiary.dbo.FN_PubName_Spec(RSpecialtyDtl) "
                + "  FROM tblRgameResultDtl "
                + "  WHERE RGameLevelidx = '" + strRGameLevelidx + "'"
                + "  AND GroupGameNum = '" + strGroupGameNum + "'"
                + "  AND GameNum = LP.Game1R"
                + "  AND DelYN = 'N'"
                + "  AND RPlayerIDX = RP.PlayerIDX"
                + "  AND RSpecialtyDtl <> '' "
                + "  AND DelYN = 'N' "
                + "  ORDER BY RGameResultDtlIdx DESC "
                + "  ) ELSE NULL END AS RFinalSkill, "
                + " P4.PubJumsu AS RJumsu, "
                + " P4.PubName AS RPlayerResult, SportsDiary.dbo.FN_LevelNm(RP.SportsGb, RP.TeamGb, RP.Level) AS RLevelName, RP.UserName AS RUserName, LP.Game1R AS GameNum, LPlayerResult, RPlayerResult, "
                + " LP.GroupAddGame AS LGroupAddGame, RP.GroupAddGame AS RGroupAddGame"
                + " FROM ("
				+ " 	 SELECT TOP 1 Team, TeamDtl"
				+ " 	 FROM tblRGameGroupSchool"
                + " 	 WHERE (Game1R = '" + strGroupGameNum + "' OR"
                + " 	 Game2R = '" + strGroupGameNum + "' OR"
                + " 	 Game3R = '" + strGroupGameNum + "' OR"
                + " 	 Game4R = '" + strGroupGameNum + "' OR"
                + " 	 Game5R = '" + strGroupGameNum + "' OR"
                + " 	 Game6R = '" + strGroupGameNum + "' OR"
                + " 	 Game7R = '" + strGroupGameNum + "' OR"
                + " 	 Game8R = '" + strGroupGameNum + "' OR"
                + " 	 Game9R = '" + strGroupGameNum + "' OR"
                + " 	 Game10R = '" + strGroupGameNum + "' OR"
                + " 	 Game11R = '" + strGroupGameNum + "' OR"                
                + " 	 Game12R = '" + strGroupGameNum + "') "
                + "      AND Team + TeamDtl NOT IN "
				+ " 			   ("
                + " 			   SELECT Team + TeamDtl AS Team_TeamDtl FROM"
				+ " 				   ("
                + " 				   SELECT SportsGb, LTeam AS Team, LTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (LResult = '' OR LResult = 'sd019012' OR LResult = 'sd019024' OR LResult = 'sd019021') AND DelYN = 'N'"
				+ " 				   UNION ALL"
                + " 				   SELECT SportsGb, RTeam AS Team, RTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (RResult = '' OR LResult = 'sd019012' OR LResult = 'sd019024' OR LResult = 'sd019021') AND DelYN = 'N'"
				+ " 				   ) AS LP"
                + " 			   WHERE LP.RGameLevelidx = '" + strRGameLevelidx + "'"
                + " 			   AND LP.GroupGameNum < " + strGroupGameNum
				+ " 			   ) "
                + "      AND RGameLevelidx='" + strRGameLevelidx + "'"
                + "      ORDER BY SchNum ASC"
				+ " 	 ) SC"
                + " INNER JOIN tblRPlayer LP ON SC.Team = LP.Team AND SC.TeamDtl = LP.TeamDtl"
                + " INNER JOIN tblRPlayer RP ON RP.RGameLevelIDX = LP.RGameLevelIDX"
                + " AND LP.Game1R = RP.Game1R"
                + " AND (LP.Team + LP.TeamDtl <> RP.Team + RP.TeamDtl) "
                + " AND LP.PlayerIDX <> RP.PlayerIDX"
                + " LEFT JOIN "
				+ "     ("
				+ "     SELECT GameTitleIDX, LPlayerResult, RPlayerResult, GroupGameNum,"
				+ "     SportsGb, TeamGb, Sex, GroupGameGb, GameNum, RGameLevelIDX"
				+ "     FROM "
				+ "     tblRGameResult"
                + "     WHERE GroupGameNum = '" + strGroupGameNum + "'"
				+ "     ) AS GR ON LP.GameTitleIDX = GR.GameTitleIDX "
                + " AND LP.RGameLevelIDX = GR.RGameLevelIDX "
                + " AND LP.Game1R = GR.GameNum"
                + " LEFT JOIN tblPubCode P3 ON P3.PubCode = GR.LPlayerResult"
                + " LEFT JOIN tblPubCode P4 ON P4.PubCode = GR.RPlayerResult"

                + " WHERE LP.RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND LP.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND RP.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND LP.DelYN = 'N'"
                + " AND RP.DelYN = 'N'"
                + " ORDER BY CONVERT(BigInt,ISNULL(LP.Game1R,0)) ASC";
              */
                string where1 = "";

                if (strRGameLevelidx != "581" && strGameType != "sd043001" && strGameType != "sd043004")
                {
                    where1 = "      AND Team + TeamDtl NOT IN "
                    + " 			   ("
                    + " 			   SELECT Team + TeamDtl AS Team_TeamDtl FROM"
                    + " 				   ("
                    + " 				   SELECT SportsGb, LTeam AS Team, LTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (LResult = '' OR LResult = 'sd019012' OR LResult = 'sd019024' OR LResult = 'sd019021') AND DelYN = 'N'"
                    + " 				   UNION ALL"
                    + " 				   SELECT SportsGb, RTeam AS Team, RTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (RResult = '' OR RResult = 'sd019012' OR RResult = 'sd019024' OR RResult = 'sd019021') AND DelYN = 'N'"
                    + " 				   ) AS LP"
                    + " 			   WHERE LP.RGameLevelidx = '" + strRGameLevelidx + "'"
                    + " 			   AND LP.GroupGameNum < " + strGroupGameNum
                    + " 			   ) ";            
                }

                string strSql = " SELECT LP.UserName AS LUserName, SportsDiary.dbo.FN_LevelNm(LP.SportsGb, LP.TeamGb, LP.Level)  AS LLevelName, P3.PubName AS LPlayerResult, GR.LJumsu,"
                + " CASE WHEN LPlayerResult IS NOT NULL THEN "
                + " (SELECT TOP 1 Sportsdiary.dbo.FN_PubName_Spec(LSpecialtyDtl) "
                + "  FROM tblRgameResultDtl "
                + "  WHERE RGameLevelidx = '" + strRGameLevelidx + "'"
                + "  AND GroupGameNum = '" + strGroupGameNum + "'"
                + "  AND GameNum = LP.Game1R"
                + "  AND DelYN = 'N'"
                + "  AND LPlayerIDX = LP.PlayerIDX"
                + "  AND LSpecialtyDtl <> '' "
                + "  AND SportsGb = 'judo' "
                + "  ORDER BY RGameResultDtlIdx DESC "
                + "  ) ELSE NULL END AS LFinalSkill, "
                + "  CASE WHEN RPlayerResult IS NOT NULL THEN "
                + " (SELECT TOP 1 Sportsdiary.dbo.FN_PubName_Spec(RSpecialtyDtl) "
                + "  FROM tblRgameResultDtl "
                + "  WHERE RGameLevelidx = '" + strRGameLevelidx + "'"
                + "  AND GroupGameNum = '" + strGroupGameNum + "'"
                + "  AND GameNum = LP.Game1R"
                + "  AND DelYN = 'N'"
                + "  AND RPlayerIDX = RP.PlayerIDX"
                + "  AND RSpecialtyDtl <> '' "
                + "  AND DelYN = 'N' "
                + "  ORDER BY RGameResultDtlIdx DESC "
                + "  ) ELSE NULL END AS RFinalSkill, "
                + " GR.RJumsu, "
                + " P4.PubName AS RPlayerResult, SportsDiary.dbo.FN_LevelNm(RP.SportsGb, RP.TeamGb, RP.Level) AS RLevelName, RP.UserName AS RUserName, LP.Game1R AS GameNum, LPlayerResult, RPlayerResult, "
                + " LP.GroupAddGame AS LGroupAddGame, RP.GroupAddGame AS RGroupAddGame"
                + " FROM ("
                + " 	 SELECT TOP 1 Team, TeamDtl"
                + " 	 FROM tblRGameGroupSchool"
                + " 	 WHERE (Game1R = '" + strGroupGameNum + "' OR"
                + " 	 Game2R = '" + strGroupGameNum + "' OR"
                + " 	 Game3R = '" + strGroupGameNum + "' OR"
                + " 	 Game4R = '" + strGroupGameNum + "' OR"
                + " 	 Game5R = '" + strGroupGameNum + "' OR"
                + " 	 Game6R = '" + strGroupGameNum + "' OR"
                + " 	 Game7R = '" + strGroupGameNum + "' OR"
                + " 	 Game8R = '" + strGroupGameNum + "' OR"
                + " 	 Game9R = '" + strGroupGameNum + "' OR"
                + " 	 Game10R = '" + strGroupGameNum + "' OR"
                + " 	 Game11R = '" + strGroupGameNum + "' OR"
                + " 	 Game12R = '" + strGroupGameNum + "') "
                /*
                + "      AND Team + TeamDtl NOT IN "
                + " 			   ("
                + " 			   SELECT Team + TeamDtl AS Team_TeamDtl FROM"
                + " 				   ("
                + " 				   SELECT SportsGb, LTeam AS Team, LTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (LResult = '' OR LResult = 'sd019012' OR LResult = 'sd019024' OR LResult = 'sd019021') AND DelYN = 'N'"
                + " 				   UNION ALL"
                + " 				   SELECT SportsGb, RTeam AS Team, RTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, RGameLevelidx FROM tblrgamegroup WHERE (RResult = '' OR RResult = 'sd019012' OR RResult = 'sd019024' OR RResult = 'sd019021') AND DelYN = 'N'"
                + " 				   ) AS LP"
                + " 			   WHERE LP.RGameLevelidx = '" + strRGameLevelidx + "'"
                + " 			   AND LP.GroupGameNum < " + strGroupGameNum
                + " 			   ) "
                */
                + where1
                + "      AND RGameLevelidx='" + strRGameLevelidx + "'"
                + "      AND DelYN='N'"
                + "      ORDER BY SchNum ASC"
                + " 	 ) SC"
                + " INNER JOIN tblRPlayer LP ON SC.Team = LP.Team AND SC.TeamDtl = LP.TeamDtl"
                + " INNER JOIN tblRPlayer RP ON RP.RGameLevelIDX = LP.RGameLevelIDX"
                + " AND LP.Game1R = RP.Game1R"
                + " AND (LP.Team + LP.TeamDtl <> RP.Team + RP.TeamDtl) "
                + " AND LP.PlayerIDX <> RP.PlayerIDX"
                + " LEFT JOIN "
                + "     ("
                + "     SELECT GameTitleIDX, LPlayerResult, RPlayerResult, GroupGameNum,"
                + "     SportsGb, TeamGb, Sex, GroupGameGb, GameNum, RGameLevelIDX, LJumsu, RJumsu"
                + "     FROM "
                + "     tblRGameResult"
                + "     WHERE GroupGameNum = '" + strGroupGameNum + "'"
                + "     AND DelYN = 'N'"
                + "     ) AS GR ON LP.GameTitleIDX = GR.GameTitleIDX "
                + " AND LP.RGameLevelIDX = GR.RGameLevelIDX "
                + " AND LP.Game1R = GR.GameNum"
                + " LEFT JOIN tblPubCode P3 ON P3.PubCode = GR.LPlayerResult"
                + " LEFT JOIN tblPubCode P4 ON P4.PubCode = GR.RPlayerResult"

                + " WHERE LP.RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND LP.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND RP.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND LP.DelYN = 'N'"
                + " AND RP.DelYN = 'N'"
                + " ORDER BY CONVERT(BigInt,ISNULL(LP.Game1R,0)) ASC";                

                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    GPlayerList_return GPlayerList_returnItem = new GPlayerList_return();

                    GPlayerList_returnItem.LUserName = reader["LUserName"].ToString();
                    GPlayerList_returnItem.LLevelName = reader["LLevelName"].ToString();
                    GPlayerList_returnItem.LPlayerResult = reader["LPlayerResult"].ToString();
                    GPlayerList_returnItem.LJumsu = reader["LJumsu"].ToString();
                    GPlayerList_returnItem.RJumsu = reader["RJumsu"].ToString();
                    GPlayerList_returnItem.RPlayerResult = reader["RPlayerResult"].ToString();
                    GPlayerList_returnItem.RLevelName = reader["RLevelName"].ToString();
                    GPlayerList_returnItem.RUserName = reader["RUserName"].ToString();
                    GPlayerList_returnItem.GameNum = reader["GameNum"].ToString();
                    GPlayerList_returnItem.LFinalSkill = reader["LFinalSkill"].ToString();
                    GPlayerList_returnItem.RFinalSkill = reader["RFinalSkill"].ToString();
                    GPlayerList_returnItem.RFinalSkill = reader["RFinalSkill"].ToString();
                    GPlayerList_returnItem.LGroupAddGame = reader["LGroupAddGame"].ToString();
                    GPlayerList_returnItem.RGroupAddGame = reader["RGroupAddGame"].ToString();
                    
                                                                                                                               
                              
                    list.Add(GPlayerList_returnItem);

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
 

    public class GPlayerList_return
    {

        private System.String lusername;
        private System.String llevelname;
        private System.String lplayerresult;
        private System.String ljumsu;
        private System.String rjumsu;         
        private System.String rplayerresult;      
        private System.String rlevelname;      
        private System.String rusername;
        private System.String gamenum;   
        private System.String lfinalskill;   
        private System.String rfinalskill;
        
        private System.String lgroupaddgame;
        private System.String rgroupaddgame;

        public GPlayerList_return()
        {
        
        }             

        public string LUserName { get { return lusername; } set { lusername = value; } }
        public string LLevelName { get { return llevelname; } set { llevelname = value; } }
        public string LPlayerResult { get { return lplayerresult; } set { lplayerresult = value; } }
        public string LJumsu { get { return ljumsu; } set { ljumsu = value; } }
        public string RJumsu { get { return rjumsu; } set { rjumsu = value; } }
        public string RPlayerResult { get { return rplayerresult; } set { rplayerresult = value; } }
        public string RLevelName { get { return rlevelname; } set { rlevelname = value; } }
        public string RUserName { get { return rusername; } set { rusername = value; } }
        public string GameNum { get { return gamenum; } set { gamenum = value; } }
        public string LFinalSkill { get { return lfinalskill; } set { lfinalskill = value; } }
        public string RFinalSkill { get { return rfinalskill; } set { rfinalskill = value; } }          
        public string LGroupAddGame { get { return lgroupaddgame; } set { lgroupaddgame = value; } }  
        public string RGroupAddGame { get { return rgroupaddgame; } set { rgroupaddgame = value; } } 
        
        
        
    }

    
    //값받는부분
    public class GPlayerList_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameNum { get; set; }
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
