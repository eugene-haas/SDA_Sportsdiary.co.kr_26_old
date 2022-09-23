<%@ WebHandler Language="C#" Class="GGameResult_operating_medal_list" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGameResult_operating_medal_list : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<medallist_return> list = new List<medallist_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            medallist_get objTraining = Deserialize<medallist_get>(strJson);

            if (objTraining != null)
            {   
                string strSportsGb = objTraining.SportsGb;
                string strGameTitleIDX = objTraining.GameTitleIDX;
                string strGameDay = objTraining.GameDay;

                string strSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNM(SportsGb, TeamGb) AS TeamGbName, TeamGb, GroupGameGb"
                + " FROM tblRGameLevel"
                + " WHERE SportsGb = '" + strSportsGb + "'"
                + " AND GameTitleIDX = '" + strGameTitleIDX + "'"                
                + " AND GameDay = '" + strGameDay + "'"
                + " AND DelYN = 'N'"
                + " GROUP BY GroupGameGb, TeamGb, SportsGb";

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    medallist_return medallist_returnItem = new medallist_return();

                    medallist_returnItem.GroupGameGbName = reader["GroupGameGbName"].ToString();
                    medallist_returnItem.TeamGbName = reader["TeamGbName"].ToString();
                    medallist_returnItem.TeamGb = reader["TeamGb"].ToString();
                    medallist_returnItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    
                    list.Add(medallist_returnItem);        

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
 

    public class medallist_return
    { 

        private System.String r_GroupGameGbName;
        private System.String r_TeamGbName;
        private System.String r_TeamGb;
        private System.String r_GroupGameGb;
        
                
        public medallist_return()
        {
        
        }

        public string GroupGameGbName { get { return r_GroupGameGbName; } set { r_GroupGameGbName = value; } }
        public string TeamGbName { get { return r_TeamGbName; } set { r_TeamGbName = value; } }
        public string TeamGb { get { return r_TeamGb; } set { r_TeamGb = value; } }
        public string GroupGameGb { get { return r_GroupGameGb; } set { r_GroupGameGb = value; } }

    }

    
    //값받는부분
    public class medallist_get
    {
       
        public string SportsGb { get; set; }
        public string GameTitleIDX { get; set; }
        public string GameDay { get; set; }       
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