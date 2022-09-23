<%@ WebHandler Language="C#" Class="GGameResult_operating_medal_detail" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGameResult_operating_medal_detail : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<medaldetail_return> list = new List<medaldetail_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            medaldetail_get objTraining = Deserialize<medaldetail_get>(strJson);

            if (objTraining != null)
            {   
                string strSportsGb = objTraining.SportsGb;
                string strGameTitleIDX = objTraining.GameTitleIDX;
                string strGameDay = objTraining.GameDay;
                string strTeamGb = objTraining.TeamGb;
                string strGroupGameGb = objTraining.GroupGameGb;

                string strSql = "";

                if (strGroupGameGb == "sd040001")
                {

                    strSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                    + " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                    + " GroupGameGb, TeamGb, Sex, Level"
                    + " FROM "
                    + " 	("
                    + " 	SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                    + " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                    + " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN UserName ELSE '' END AS GoldUserName,"
                    + "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                    + " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                    + " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN UserName ELSE '' END AS SilverUserName,"
                    + "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN UserName ELSE '' END AS BronzeUserName1,"
                    + "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN UserName ELSE '' END AS BronzeUserName2,"
                    + "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                    + "     A.SportsGb"
                    + " 	FROM tblRGameLevel A"
                    + " 	INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " 	INNER JOIN tblRPlayer C ON C.RGameLevelidx = B.RGameLevelidx AND C.PlayerIDX = B.PlayerIDX"
                    + " 	WHERE A.SportsGb = '" + strSportsGb + "'"
                    + "     AND A.GameTitleIDX = '" + strGameTitleIDX + "'"
                    + " 	AND A.GameDay = '" + strGameDay + "'"
                    + " 	AND A.TeamGb = '" + strTeamGb + "'"
                    + " 	AND B.GroupGameGb = 'sd040001'"
                    + " 	AND A.DelYN = 'N'"
                    + " 	AND B.DelYN = 'N'"
                    + " 	AND C.DelYN = 'N'"
                    + " 	) AS AA"
                    + " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb";

                }
                else {
                    strSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                    + " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                    + " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                    + " GroupGameGb, TeamGb, Sex, Level"
                    + " FROM "
                    + " 	("
                    + " 	SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                    + " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                    + " 	'' AS GoldUserName,"
                    + "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                    + " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                    + " 	'' AS SilverUserName,"
                    + "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                    + " 	'' AS BronzeUserName1,"
                    + "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                    + " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                    + " 	'' AS BronzeUserName2,"
                    + "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                    + "     A.SportsGb"
                    + " 	FROM tblRGameLevel A"
                    + " 	INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " 	WHERE A.SportsGb = '" + strSportsGb + "'"
                    + "     AND A.GameTitleIDX = '" + strGameTitleIDX + "'"
                    + " 	AND A.GameDay = '" + strGameDay + "'"
                    + " 	AND A.TeamGb = '" + strTeamGb + "'"
                    + " 	AND B.GroupGameGb = 'sd040002'"
                    + " 	AND A.DelYN = 'N'"
                    + " 	AND B.DelYN = 'N'"
                    + " 	) AS AA"
                    + " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb";    
                }

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    medaldetail_return medaldetail_returnItem = new medaldetail_return();

                    medaldetail_returnItem.GroupGameGbName = reader["GroupGameGbName"].ToString();
                    medaldetail_returnItem.TeamGbName = reader["TeamGbName"].ToString();
                    medaldetail_returnItem.LevelName = reader["LevelName"].ToString();
                    medaldetail_returnItem.Sex = reader["Sex"].ToString();
                    medaldetail_returnItem.GameType = reader["GameType"].ToString();
                    medaldetail_returnItem.GoldMedalName = reader["GoldMedalName"].ToString();
                    medaldetail_returnItem.GoldUserName = reader["GoldUserName"].ToString();
                    medaldetail_returnItem.GoldSCName = reader["GoldSCName"].ToString();
                    medaldetail_returnItem.SilverName = reader["SilverName"].ToString();
                    medaldetail_returnItem.SilverUserName = reader["SilverUserName"].ToString();
                    medaldetail_returnItem.SilverSCName = reader["SilverSCName"].ToString();
                    medaldetail_returnItem.Bronze1Name = reader["Bronze1Name"].ToString();
                    medaldetail_returnItem.BronzeUserName1 = reader["BronzeUserName1"].ToString();
                    medaldetail_returnItem.BronzeSCName1 = reader["BronzeSCName1"].ToString();
                    medaldetail_returnItem.Bronze2Name = reader["Bronze2Name"].ToString();
                    medaldetail_returnItem.BronzeUserName2 = reader["BronzeUserName2"].ToString();
                    medaldetail_returnItem.BronzeSCName2 = reader["BronzeSCName2"].ToString();
                    medaldetail_returnItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    medaldetail_returnItem.TeamGb = reader["TeamGb"].ToString();
                    medaldetail_returnItem.Level = reader["Level"].ToString();
                    
                    list.Add(medaldetail_returnItem);        

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
 

    public class medaldetail_return
    { 
        
        private System.String r_GroupGameGbName;
        private System.String r_TeamGbName;
        private System.String r_LevelName;
        private System.String r_Sex;
        private System.String r_GameType;   
        private System.String r_GoldMedalName;
        private System.String r_GoldUserName;
        private System.String r_GoldSCName;
        private System.String r_SilverName;
        private System.String r_SilverUserName;
        private System.String r_SilverSCName;
        private System.String r_Bronze1Name;
        private System.String r_BronzeUserName1;
        private System.String r_BronzeSCName1;
        private System.String r_Bronze2Name;
        private System.String r_BronzeUserName2;
        private System.String r_BronzeSCName2;
        private System.String r_GroupGameGb;
        private System.String r_TeamGb;
        private System.String r_Level;  
        
                
        public medaldetail_return()
        {
        
        }

        public string GroupGameGbName { get { return r_GroupGameGbName; } set { r_GroupGameGbName = value; } }
        public string TeamGbName { get { return r_TeamGbName; } set { r_TeamGbName = value; } }
        public string LevelName { get { return r_LevelName; } set { r_LevelName = value; } }
        public string Sex { get { return r_Sex; } set { r_Sex = value; } }
        public string GameType { get { return r_GameType; } set { r_GameType = value; } }
        public string GoldMedalName { get { return r_GoldMedalName; } set { r_GoldMedalName = value; } }
        public string GoldUserName { get { return r_GoldUserName; } set { r_GoldUserName = value; } }
        public string GoldSCName { get { return r_GoldSCName; } set { r_GoldSCName = value; } }
        public string SilverName { get { return r_SilverName; } set { r_SilverName = value; } }
        public string SilverUserName { get { return r_SilverUserName; } set { r_SilverUserName = value; } }
        public string SilverSCName { get { return r_SilverSCName; } set { r_SilverSCName = value; } }
        public string Bronze1Name { get { return r_Bronze1Name; } set { r_Bronze1Name = value; } }
        public string BronzeUserName1 { get { return r_BronzeUserName1; } set { r_BronzeUserName1 = value; } }
        public string BronzeSCName1 { get { return r_BronzeSCName1; } set { r_BronzeSCName1 = value; } }
        public string Bronze2Name { get { return r_Bronze2Name; } set { r_Bronze2Name = value; } }
        public string BronzeUserName2 { get { return r_BronzeUserName2; } set { r_BronzeUserName2 = value; } }
        public string BronzeSCName2 { get { return r_BronzeSCName2; } set { r_BronzeSCName2 = value; } }
        public string GroupGameGb { get { return r_GroupGameGb; } set { r_GroupGameGb = value; } }
        public string TeamGb { get { return r_TeamGb; } set { r_TeamGb = value; } }
        public string Level { get { return r_Level; } set { r_Level = value; } }


    }

    
    //값받는부분
    public class medaldetail_get
    {
       
        public string SportsGb { get; set; }
        public string GameTitleIDX { get; set; }
        public string GameDay { get; set; }       
        public string TeamGb { get; set; }
        public string GroupGameGb { get; set; }   
            
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