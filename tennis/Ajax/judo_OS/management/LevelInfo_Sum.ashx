<%@ WebHandler Language="C#" Class="Ajax_Judo_OS_LevelInfo_Sum" %>
using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

//선수리드트 로드
public class Ajax_Judo_OS_LevelInfo_Sum : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<PlayerLevel_return> list = new List<PlayerLevel_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            PlayerLevel_get objTraining = Deserialize<PlayerLevel_get>(strJson);

            if (objTraining != null)
            {
                string strSportsGb = objTraining.SportsGb;
                string strTeamGb = objTraining.TeamGb;

                
                string strSql = "SELECT A.Sex, A.TeamGb, A.TeamGbNm, B.Level, B.LevelNm "
                    + " FROM tblTeamGbInfo A"
                    + " INNER JOIN tblLevelInfo B ON B.TeamGb = A.TeamGb AND B.SportsGb = A.SportsGb"
                    + " WHERE A.TeamGb = '" + strTeamGb + "'"
                    + " AND A.SportsGb = '" + strSportsGb + "'"
                    + " AND A.DelYN = 'N'"
                    + " AND B.DelYN = 'N'"
                    + " AND B.DelYN = 'N'"
                    + " AND B.Level <> '11002999'"
                    + " AND B.Level <> '21002999'"
                    + " ORDER BY B.OrderBY ASC";


                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    PlayerLevel_return PubCodeItem = new PlayerLevel_return();

                    PubCodeItem.Sex = reader["Sex"].ToString();
                    PubCodeItem.TeamGb = reader["TeamGb"].ToString();
                    PubCodeItem.TeamGbNm = reader["TeamGbNm"].ToString();
                    PubCodeItem.Level = reader["Level"].ToString();
                    PubCodeItem.LevelNm = reader["LevelNm"].ToString();
                    
                    list.Add(PubCodeItem);

                }

                reader.Close();
                DsCom.Connection.Close();
                DbCon.Close();
                context.Response.Write(new JavaScriptSerializer().Serialize(list).ToString());
            }

            //ErrorLog("Clogin_tblPlayerList.ashx", "tblPlayerList", "", strJson, "");
            
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
 

    public class PlayerLevel_return
    {
        
        private System.String R_Sex;
        private System.String R_TeamGb;
        private System.String R_TeamGbNm;
        private System.String R_Level;
        private System.String R_LevelNm;

        public PlayerLevel_return()
        {
        
        }

        public string Sex { get { return R_Sex; } set { R_Sex = value; } }
        public string TeamGb { get { return R_TeamGb; } set { R_TeamGb = value; } }
        public string TeamGbNm { get { return R_TeamGbNm; } set { R_TeamGbNm = value; } }
        public string Level { get { return R_Level; } set { R_Level = value; } }
        public string LevelNm { get { return R_LevelNm; } set { R_LevelNm = value; } }
        
    }

    
    //값받는부분
    public class PlayerLevel_get
    {
        public string SportsGb { get; set; }
        public string TeamGb { get; set; }
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