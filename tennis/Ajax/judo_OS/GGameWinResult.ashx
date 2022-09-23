<%@ WebHandler Language="C#" Class="GGame_GGameWinResult" %>


using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameWinResult : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<GameResult_return> list = new List<GameResult_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            GameResult_get objGameResult_get = Deserialize<GameResult_get>(strJson);

            if (objGameResult_get != null)
            {
                string strRGameLevelidx = objGameResult_get.RGameLevelidx;
                string strPlayerGameNum = objGameResult_get.PlayerGameNum;
                string strGroupGameNum = objGameResult_get.GroupGameNum;
                

                string WHERE_Level = "";
                string WHERE_GroupGameNum = "";                
                

                string strSql = "SELECT LPlayerName, RPlayerName, SportsDiary.dbo.FN_PubName(A.LPlayerResult) AS LResult, A.LPlayerResult,"
                + " SportsDiary.dbo.FN_PubName(A.RPlayerResult) AS RResult, A.RPlayerResult, SportsDiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.LTeam) AS LSchoolName , SportsDiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.RTeam) AS RSchoolName,"
                + " SportsDiary.dbo.FN_SkillResult(A.LPlayerResult) AS LSkillResult, SportsDiary.dbo.FN_SkillResult(A.RPlayerResult) AS RSkillResult, SportsDiary.Dbo.FN_MediaLink(A.RGameLevelidx, A.GroupGameNum, A.GameNum) AS MediaLink,"
                + " SportsDiary.dbo.FN_TeamSidoNm('judo',A.LTeam) AS LTeamSidoNm, SportsDiary.dbo.FN_TeamSidoNm('judo',A.RTeam) AS RTeamSidoNm"
                + " FROM tblRGameResult A"
                + " WHERE  A.RGameLevelidx='" + strRGameLevelidx + "' "
                + " AND A.GroupGameNum='" + strGroupGameNum + "' "
                + " AND A.GameNum='" + strPlayerGameNum + "'"
                + " AND A.DelYN = 'N'"; 
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    GameResult_return GameResult_returnItem = new GameResult_return();

                    GameResult_returnItem.LPlayerName = reader["LPlayerName"].ToString();
                    GameResult_returnItem.RPlayerName = reader["RPlayerName"].ToString();
                    GameResult_returnItem.LResult = reader["LResult"].ToString();
                    GameResult_returnItem.LPlayerResult = reader["LPlayerResult"].ToString();
                    GameResult_returnItem.RResult = reader["RResult"].ToString();
                    GameResult_returnItem.RPlayerResult = reader["RPlayerResult"].ToString();

                    GameResult_returnItem.LSchoolName = reader["LSchoolName"].ToString();
                    GameResult_returnItem.RSchoolName = reader["RSchoolName"].ToString();

                    GameResult_returnItem.LSkillResult = reader["LSkillResult"].ToString();
                    GameResult_returnItem.RSkillResult = reader["RSkillResult"].ToString();

                    GameResult_returnItem.MediaLink = reader["MediaLink"].ToString();

                    GameResult_returnItem.LTeamSidoNm = reader["LTeamSidoNm"].ToString();
                    GameResult_returnItem.RTeamSidoNm = reader["RTeamSidoNm"].ToString();
                    
                    
                    
                        
                        
                    list.Add(GameResult_returnItem);

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
 

    public class GameResult_return
    {

        private System.String lplayername;
        private System.String rplayername;
        private System.String lresult;
        private System.String lplayerresult;
        private System.String rresult;
        private System.String rplayerresult;    
        private System.String lschoolname;
        private System.String rschoolname;

        private System.String lskillresult;
        private System.String rskillresult;

        private System.String medialink;  
        
        private System.String lteamsidonm;  
        private System.String rteamsidonm;  
        
        
        
        
       
        
        public GameResult_return()
        {
        
        }

        public string LPlayerName { get { return lplayername; } set { lplayername = value; } }
        public string RPlayerName { get { return rplayername; } set { rplayername = value; } }
        public string LResult { get { return lresult; } set { lresult = value; } }
        public string LPlayerResult { get { return lplayerresult; } set { lplayerresult = value; } }
        public string RResult { get { return rresult; } set { rresult = value; } }
        public string RPlayerResult { get { return rplayerresult; } set { rplayerresult = value; } }

        public string LSchoolName { get { return lschoolname; } set { lschoolname = value; } }
        public string RSchoolName { get { return rschoolname; } set { rschoolname = value; } }

        public string LSkillResult { get { return lskillresult; } set { lskillresult = value; } }
        public string RSkillResult { get { return rskillresult; } set { rskillresult = value; } }

        public string MediaLink { get { return medialink; } set { medialink = value; } }

        public string LTeamSidoNm { get { return lteamsidonm; } set { lteamsidonm = value; } }
        public string RTeamSidoNm { get { return rteamsidonm; } set { rteamsidonm = value; } }     
       
        
    }

    
    //값받는부분
    public class GameResult_get
    {
        public string RGameLevelidx { get; set; }
        public string PlayerGameNum { get; set; }
        public string GroupGameNum { get; set; }      
          
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

