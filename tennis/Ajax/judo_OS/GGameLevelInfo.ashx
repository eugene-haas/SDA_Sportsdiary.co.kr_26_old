<%@ WebHandler Language="C#" Class="GGame_GGameLevelInfo" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameLevelInfo : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<LevelInfo_return> list = new List<LevelInfo_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            LevelInfo_get objLevelInfo_get = Deserialize<LevelInfo_get>(strJson);

            if (objLevelInfo_get != null)
            {
                string strSportsGb = objLevelInfo_get.SportsGb;
                string strGameTitleIDX = objLevelInfo_get.GameTitleIDX;
                string strTeamGb = objLevelInfo_get.TeamGb;
                string strSex = objLevelInfo_get.Sex;
                string strLevel = objLevelInfo_get.Level;
                string strGroupGameGb = objLevelInfo_get.GroupGameGb;


                string strSql = "SELECT A.GameType, A.RGameLevelidx, B.HostCode, "
                    + " CONVERT(BigInt,ISNULL(SportsDiary.dbo.FN_RPlayerCnt(A.RGameLevelidx, 'sd042001'),'0')) + CONVERT(BigInt,ISNULL(SportsDiary.dbo.FN_RPlayerCnt(A.RGameLevelidx, 'sd042002'),'0')) AS PlayerCnt,"
                    + " AreaNameUseYN"
                    + " FROM SportsDiary.dbo.tblRGameLevel A"
                    + " INNER JOIN SportsDiary.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
                    + " WHERE A.SportsGb = '" + strSportsGb + "'"
                    + " AND A.GameTitleIDX = '" + strGameTitleIDX + "'"
                    + " AND A.TeamGb = '" + strTeamGb + "'"
                    + " AND A.Sex = '" + strSex + "'"
                    + " AND A.[Level] = '" + strLevel + "'"
                    + " AND A.GroupGameGb = '" + strGroupGameGb + "'"
                    + " AND A.DelYN = 'N'"
                    + " AND B.DelYN = 'N'";            
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    LevelInfo_return LevelInfo_returnItem = new LevelInfo_return();

                    LevelInfo_returnItem.GameType = reader["GameType"].ToString();
                    LevelInfo_returnItem.RGameLevelidx = reader["RGameLevelidx"].ToString();
                    LevelInfo_returnItem.HostCode = reader["HostCode"].ToString();
                    LevelInfo_returnItem.PlayerCnt = reader["PlayerCnt"].ToString();
                    LevelInfo_returnItem.AreaNameUseYN = reader["AreaNameUseYN"].ToString();
                    
                    
                    list.Add(LevelInfo_returnItem);

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
 

    public class LevelInfo_return
    {

        private System.String r_GameType;
        private System.String r_RGameLevelidx;
        private System.String r_HostCode;
        private System.String r_PlayerCnt;
        private System.String r_AreaNameUseYN;
        
        
        public LevelInfo_return()
        {
        
        }

        public string GameType { get { return r_GameType; } set { r_GameType = value; } }
        public string RGameLevelidx { get { return r_RGameLevelidx; } set { r_RGameLevelidx = value; } }
        public string HostCode { get { return r_HostCode; } set { r_HostCode = value; } }
        public string PlayerCnt { get { return r_PlayerCnt; } set { r_PlayerCnt = value; } }
        public string AreaNameUseYN { get { return r_AreaNameUseYN; } set { r_AreaNameUseYN = value; } }
        
        
    }

    
    //값받는부분
    public class LevelInfo_get
    {
        public string SportsGb { get; set; }
        public string GameTitleIDX { get; set; }
        public string TeamGb { get; set; }
        public string Sex { get; set; }
        public string Level { get; set; }
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