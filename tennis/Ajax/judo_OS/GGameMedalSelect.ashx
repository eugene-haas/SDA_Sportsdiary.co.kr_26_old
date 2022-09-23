<%@ WebHandler Language="C#" Class="GGame_GGameMedalSelect" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameMedalSelect : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<Medal_return> list = new List<Medal_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            Medal_get objMedal_get = Deserialize<Medal_get>(strJson);

            if (objMedal_get != null)
            {
                string strRGameLevelidx = objMedal_get.RGameLevelidx;

                string strSql = "";

                //현재 체급게임의 메달구하기
                
               strSql = " SELECT A.TitleResult, "
                   + " CASE WHEN B.GroupGameGb = 'sd040001' THEN SportsDiary.dbo.FN_PlayerName(A.PlayerIDX) ELSE '' END AS UserName, Sportsdiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, A.Team) AS SchoolName"
                   + " FROM tblGameScore A"
                   + " INNER JOIN tblRgameLevel B ON B.RGameLevelidx = A.RGameLevelidx"
                   + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                   + " AND A.DelYN = 'N'"                        
                   +" ORDER BY GameRanking ASC";                    
  
                    
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    Medal_return Medal_returnItem = new Medal_return();

                    Medal_returnItem.TitleResult = reader["TitleResult"].ToString();
                    Medal_returnItem.UserName = reader["UserName"].ToString();
                    Medal_returnItem.SchoolName = reader["SchoolName"].ToString();
                    list.Add(Medal_returnItem);

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
 

    public class Medal_return
    {

        private System.String r_TitleResult;
        private System.String r_UserName;
        private System.String r_SchoolName;
        
        public Medal_return()
        {
        
        }

        public string TitleResult { get { return r_TitleResult; } set { r_TitleResult = value; } }
        public string UserName { get { return r_UserName; } set { r_UserName = value; } }
        public string SchoolName { get { return r_SchoolName; } set { r_SchoolName = value; } }
        
    }

    
    //값받는부분
    public class Medal_get
    {
        public string RGameLevelidx { get; set; }

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

