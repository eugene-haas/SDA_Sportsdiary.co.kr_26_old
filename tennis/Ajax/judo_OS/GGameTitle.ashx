<%@ WebHandler Language="C#" Class="GGame_GGameTitle" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameTitle : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<ScoreDetail> list = new List<ScoreDetail>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            Scoreinfo objScoreinfo = Deserialize<Scoreinfo>(strJson);

            if (objScoreinfo != null)
            {
                string strSportsGb = objScoreinfo.SportsGb;
                string strGameTitleIDX = objScoreinfo.GameTitleIDX;
                string strTeamGb = objScoreinfo.TeamGb;
                string strSex = objScoreinfo.Sex;
                string strLevel = objScoreinfo.Level;
                string strGroupGameGb = objScoreinfo.GroupGameGb;
                string strPlayerGameNum = objScoreinfo.PlayerGameNum;
                string strGroupGameNum = objScoreinfo.GroupGameNum;
                string strPlayRound = objScoreinfo.PlayRound;
                
                
                string strSql = "";

                strSql = "SELECT A.SportsGb,"
                + " CONVERT(VARCHAR(10),A.GameS,23) AS GameS, "
                + " A.GameTitleName, "
                + " SportsDiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, "
                + " SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGbName, "
                + " CASE B.Sex WHEN 'WoMan' THEN '여자' ELSE '남자' END AS Sex, "
                + " SportsDiary.dbo.FN_LevelNm(B.SportsGb, B.TeamGb, B.Level) AS LevelName, "
                + " SportsDiary.dbo.FN_Round_NM(B.TotRound, '" + strPlayRound + "')  AS TotRound, "
                + " B.RGameLevelidx,"
                + " B.GameType,"
                + " B.EntryCnt,"
                + " B.StadiumNumber,"
                + " SportsDiary.dbo.FN_Tmp_StadiumNumber(B.RgameLevelidx, B.GroupGameGb, '" + strGroupGameNum + "', '" + strPlayerGameNum + "') AS Tmp_StadiumNumber,"
                + " AreaNameUseYN"
                + " FROM SportsDiary.dbo.tblGameTitle A"
                + " INNER JOIN tblRGameLevel B ON B.GameTitleIDX = A.GameTitleIDX"
                + " WHERE A.GameTitleIDX = '" + strGameTitleIDX + "'"
                + " AND B.TeamGb='" + strTeamGb + "'"
                + " AND ISNULL(B.Level,'') = '" + strLevel + "'"
                + " AND B.GroupGameGb = '" + strGroupGameGb + "'  "
                + " AND B.Sex = '" + strSex + "'"
                + " AND A.DelYN = 'N'"
                + " AND B.DelYN = 'N'";               
                                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    ScoreDetail ScoreDetailItem = new ScoreDetail();


                    ScoreDetailItem.SportsGb = reader["SportsGb"].ToString();
                    ScoreDetailItem.GameDate = reader["GameS"].ToString();
                    ScoreDetailItem.GameTitleName = reader["GameTitleName"].ToString();
                    ScoreDetailItem.GroupGameGbName = reader["GroupGameGbName"].ToString();
                    ScoreDetailItem.TeamGbName = reader["TeamGbName"].ToString();
                    ScoreDetailItem.SexName = reader["Sex"].ToString();
                    ScoreDetailItem.LevelName = reader["LevelName"].ToString();
                    ScoreDetailItem.TotRoundName = reader["TotRound"].ToString();

                    ScoreDetailItem.RGameLevelidx = reader["RGameLevelidx"].ToString();
                    ScoreDetailItem.GameType = reader["GameType"].ToString();
                    ScoreDetailItem.EntryCnt = reader["EntryCnt"].ToString();
                    ScoreDetailItem.StadiumNumber = reader["StadiumNumber"].ToString();
                    ScoreDetailItem.Tmp_StadiumNumber = reader["Tmp_StadiumNumber"].ToString();
                    ScoreDetailItem.AreaNameUseYN = reader["AreaNameUseYN"].ToString();    
                    
                    
                               
                    list.Add(ScoreDetailItem);

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
 

    public class ScoreDetail
    {

        private System.String sportsgb;
        private System.String gamedate;
        private System.String gametitlename;
        private System.String groupgamegbname;
        private System.String teamgbname;
        private System.String sexname;
        private System.String levelname;
        private System.String totroundname; 
        
        private System.String rgamelevelidx;
        private System.String gametype;
        private System.String entrycnt;
        private System.String stadiumnumber;  
        private System.String tmp_stadiumnumber;  
        
        private System.String areanameuseryn;  
        
          
        public ScoreDetail()
        {
        
        }


        public string SportsGb { get { return sportsgb; } set { sportsgb = value; } }
        public string GameDate { get { return gamedate; } set { gamedate = value; } }
        public string GameTitleName { get { return gametitlename; } set { gametitlename = value; } }
        public string GroupGameGbName { get { return groupgamegbname; } set { groupgamegbname = value; } }
        public string TeamGbName { get { return teamgbname; } set { teamgbname = value; } }
        public string SexName { get { return sexname; } set { sexname = value; } }
        public string LevelName { get { return levelname; } set { levelname = value; } }
        public string TotRoundName { get { return totroundname; } set { totroundname = value; } }
        public string RGameLevelidx { get { return rgamelevelidx; } set { rgamelevelidx = value; } }
        public string GameType { get { return gametype; } set { gametype = value; } }
        public string EntryCnt { get { return entrycnt; } set { entrycnt = value; } }
        public string StadiumNumber { get { return stadiumnumber; } set { stadiumnumber = value; } }
        public string Tmp_StadiumNumber { get { return tmp_stadiumnumber; } set { tmp_stadiumnumber = value; } }

        public string AreaNameUseYN { get { return areanameuseryn; } set { areanameuseryn = value; } }     
        
           
        
    }

    
    //값받는부분
    public class Scoreinfo
    {
        public string SportsGb { get; set; }
        public string GameTitleIDX { get; set; }
        public string TeamGb { get; set; }
        public string Sex { get; set; }
        public string Level { get; set; }
        public string GroupGameGb { get; set; }
        public string PlayerGameNum { get; set; }
        public string GroupGameNum { get; set; }
        public string PlayRound { get; set; }       
        
         
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

