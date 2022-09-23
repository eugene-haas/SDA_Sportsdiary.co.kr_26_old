<%@ WebHandler Language="C#" Class="GGame_GGameOperate" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameOperate : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<Checkcnt_return> list = new List<Checkcnt_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            Checkcnt_get objCheckcnt_get = Deserialize<Checkcnt_get>(strJson);

            if (objCheckcnt_get != null)
            {

                string strGameTitleIDX = objCheckcnt_get.GameTitleIDX;
                string strGameDay = objCheckcnt_get.GameDay;
                string strStadiumNumber = objCheckcnt_get.StadiumNumber;

                string strSql = "SELECT B.PlayerResultIDX, B.RGameLevelidx, SportsDiary.dbo.FN_PlayerName(B.LPlayerIDX) AS LUserName, SportsDiary.dbo.FN_PlayerName(B.RPlayerIDX) AS RUserName,"
                + " SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName,"
                + " B.GroupGameNum, B.GameNum, B.LPlayerIDX, B.RPlayerIDX,"
                + " B.LTeam, LTeamDtl, B.RTeam, B.RTeamDtl, B.LResult, B.RResult, SportsDiary.dbo.FN_PubName(B.GameStatus) AS GameStatus, "
                + " SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM,"
                + " SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGBNM,"
                + " SportsDiary.dbo.FN_LevelNM(B.SportsGb, B.TeamGb, B.Level) AS LevelNM,"
                + " B.Sex, B.GroupGameGb, B.NowRoundNM"
                + " FROM SportsDiary.dbo.tblRgameLevel A"
                + " INNER JOIN SportsDiary.dbo.tblPlayerResult B ON B.RGameLevelidx = A.RGameLevelidx"
                + " AND B.GameTitleIDX = '" + strGameTitleIDX + "' "
                + " AND A.GameDay = '" + strGameDay + "'"
                + " AND B.StadiumNumber = '" + strStadiumNumber + "'"
                + " AND B.TurnNum <> '0'"      
                //+ " AND GroupGameNum = '" + strGroupGameNum + "'"
                //+ " AND GameNum = '" + strGameNum + "'"                
                + " AND (A.DelYN = 'N' OR A.Rgamelevelidx = '1328')"
                + " AND B.DelYN = 'N'"
                + " AND (B.GroupGameGb = 'sd040001' OR (B.GroupGameGb = 'sd040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' )))"
                //+ " ORDER BY B.StadiumNumber ASC, B.TurnNum ASC";
                + " ORDER BY B.TurnNum ASC";
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    Checkcnt_return Checkcnt_returnItem = new Checkcnt_return();

                    Checkcnt_returnItem.PlayerResultIDX = reader["PlayerResultIDX"].ToString();
                    Checkcnt_returnItem.RGameLevelidx = reader["RGameLevelidx"].ToString();
                    Checkcnt_returnItem.LUserName = reader["LUserName"].ToString();
                    Checkcnt_returnItem.RUserName = reader["RUserName"].ToString();
                    Checkcnt_returnItem.LSchoolName = reader["LSchoolName"].ToString();
                    Checkcnt_returnItem.RSchoolName = reader["RSchoolName"].ToString();                    
                    Checkcnt_returnItem.GroupGameNum = reader["GroupGameNum"].ToString();
                    Checkcnt_returnItem.GameNum = reader["GameNum"].ToString();
                    Checkcnt_returnItem.LPlayerIDX = reader["LPlayerIDX"].ToString();
                    Checkcnt_returnItem.RPlayerIDX = reader["RPlayerIDX"].ToString();
                    Checkcnt_returnItem.LTeam = reader["LTeam"].ToString();
                    Checkcnt_returnItem.LTeamDtl = reader["LTeamDtl"].ToString();
                    Checkcnt_returnItem.RTeam = reader["RTeam"].ToString();
                    Checkcnt_returnItem.RTeamDtl = reader["RTeamDtl"].ToString();
                    Checkcnt_returnItem.LResult = reader["LResult"].ToString();
                    Checkcnt_returnItem.RResult = reader["RResult"].ToString();
                    Checkcnt_returnItem.GameStatus = reader["GameStatus"].ToString();      
                    Checkcnt_returnItem.GroupGameGbNM = reader["GroupGameGbNM"].ToString();
                    Checkcnt_returnItem.TeamGBNM = reader["TeamGBNM"].ToString();
                    Checkcnt_returnItem.LevelNM = reader["LevelNM"].ToString();
                    Checkcnt_returnItem.Sex = reader["Sex"].ToString();
                    Checkcnt_returnItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    Checkcnt_returnItem.NowRoundNM = reader["NowRoundNM"].ToString();
                    
                    list.Add(Checkcnt_returnItem);

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
 

    public class Checkcnt_return
    {

        private System.String r_PlayerResultIDX;
        private System.String r_RGameLevelidx;
        private System.String r_LUserName;
        private System.String r_RUserName;
        private System.String r_LSchoolName;
        private System.String r_RSchoolName;   
        private System.String r_GroupGameNum;
        private System.String r_GameNum;
        private System.String r_LPlayerIDX;
        private System.String r_RPlayerIDX;
        private System.String r_LTeam;
        private System.String r_LTeamDtl;
        private System.String r_RTeam;
        private System.String r_RTeamDtl;        
        private System.String r_LResult;
        private System.String r_RResult;
        private System.String r_GameStatus;
        private System.String r_GroupGameGbNM;
        private System.String r_TeamGBNM;
        private System.String r_LevelNM;
        private System.String r_Sex;
        private System.String r_GroupGameGb;
        private System.String r_NowRoundNM;
        
        
         
        
        
        public Checkcnt_return()
        {
        
        }

        public string PlayerResultIDX { get { return r_PlayerResultIDX; } set { r_PlayerResultIDX = value; } }
        public string RGameLevelidx { get { return r_RGameLevelidx; } set { r_RGameLevelidx = value; } }
        public string LUserName { get { return r_LUserName; } set { r_LUserName = value; } }
        public string RUserName { get { return r_RUserName; } set { r_RUserName = value; } }

        public string LSchoolName { get { return r_LSchoolName; } set { r_LSchoolName = value; } }
        public string RSchoolName { get { return r_RSchoolName; } set { r_RSchoolName = value; } }
        
        
        
        public string GroupGameNum { get { return r_GroupGameNum; } set { r_GroupGameNum = value; } }
        public string GameNum { get { return r_GameNum; } set { r_GameNum = value; } }
        public string LPlayerIDX { get { return r_LPlayerIDX; } set { r_LPlayerIDX = value; } }
        public string RPlayerIDX { get { return r_RPlayerIDX; } set { r_RPlayerIDX = value; } }
        public string LTeam { get { return r_LTeam; } set { r_LTeam = value; } }
        public string LTeamDtl { get { return r_LTeamDtl; } set { r_LTeamDtl = value; } }        
        public string RTeam { get { return r_RTeam; } set { r_RTeam = value; } }
        public string RTeamDtl { get { return r_RTeamDtl; } set { r_RTeamDtl = value; } }        
        public string LResult { get { return r_LResult; } set { r_LResult = value; } }
        public string RResult { get { return r_RResult; } set { r_RResult = value; } }
        public string GameStatus { get { return r_GameStatus; } set { r_GameStatus = value; } }
        public string GroupGameGbNM { get { return r_GroupGameGbNM; } set { r_GroupGameGbNM = value; } }
        public string TeamGBNM { get { return r_TeamGBNM; } set { r_TeamGBNM = value; } }
        public string LevelNM { get { return r_LevelNM; } set { r_LevelNM = value; } }
        public string Sex { get { return r_Sex; } set { r_Sex = value; } }
        public string GroupGameGb { get { return r_GroupGameGb; } set { r_GroupGameGb = value; } }
        public string NowRoundNM { get { return r_NowRoundNM; } set { r_NowRoundNM = value; } } 
        
    }

    
    //값받는부분
    public class Checkcnt_get
    {  

        public string GameTitleIDX { get; set; }
        public string GameDay { get; set; }
        public string StadiumNumber { get; set; }
       
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