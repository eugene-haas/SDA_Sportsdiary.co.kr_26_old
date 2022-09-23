<%@ WebHandler Language="C#" Class="GGame_GGameGroupPlayerList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupPlayerList : CommPage, IHttpHandler
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
                string strTeam = objGPlayerList_get.Team;
                string strTeamDtl = objGPlayerList_get.TeamDtl;


                string strSql = " SELECT PlayerIDX, Team, TeamDtl, UserName, B.Level, SportsDiary.dbo.FN_LevelNm(B.SportsGb, B.TeamGb, B.Level) AS LevelName, B.Level AS LevelIdx"
                + " FROM tblRGameLevel A"
                + " INNER JOIN tblRPlayerMaster B ON B.RGameLevelIDX = A.RGameLevelIDX"
                + " LEFT JOIN tblPubCode P1 ON P1.PubCode = B.Level"
                + " WHERE A.RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND B.Team = '" + strTeam + "'"
                + " AND B.TeamDtl = '" + strTeamDtl + "'"
                + " AND B.DelYN = 'N'";
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    GPlayerList_return GPlayerList_returnItem = new GPlayerList_return();


                    GPlayerList_returnItem.PlayerIDX = reader["PlayerIDX"].ToString();
                    GPlayerList_returnItem.Team = reader["Team"].ToString();
                    GPlayerList_returnItem.TeamDtl = reader["TeamDtl"].ToString();
                    GPlayerList_returnItem.UserName = reader["UserName"].ToString();
                    GPlayerList_returnItem.Level = reader["Level"].ToString();
                    GPlayerList_returnItem.LevelName = reader["LevelName"].ToString();
                    GPlayerList_returnItem.LevelIdx = reader["LevelIdx"].ToString();     
                          
                               
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

        private System.String playeriDX;
        private System.String team;
        private System.String teamdtl;
        private System.String username;
        private System.String level;
        private System.String levelname;      
        private System.String levelidx;              
               
           
        public GPlayerList_return()
        {
        
        }


        public string PlayerIDX { get { return playeriDX; } set { playeriDX = value; } }
        public string Team { get { return team; } set { team = value; } }
        public string TeamDtl { get { return teamdtl; } set { teamdtl = value; } }
        public string UserName { get { return username; } set { username = value; } }
        public string Level { get { return level; } set { level = value; } }
        public string LevelName { get { return level; } set { level = value; } }
        public string LevelIdx { get { return levelidx; } set { levelidx = value; } }    
        
    }

    
    //값받는부분
    public class GPlayerList_get
    {
        public string RGameLevelidx { get; set; }
        public string Team { get; set; }
        public string TeamDtl { get; set; }
        
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
