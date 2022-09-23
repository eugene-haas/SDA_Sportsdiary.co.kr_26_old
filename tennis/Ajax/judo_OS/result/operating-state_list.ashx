<%@ WebHandler Language="C#" Class="GGameResult_operating_state_list" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGameResult_operating_state_list : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<statelist_return> list = new List<statelist_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            statelist_get objTraining = Deserialize<statelist_get>(strJson);

            if (objTraining != null)
            {   
                string strSportsGb = objTraining.SportsGb;
                string strGameTitleIDX = objTraining.GameTitleIDX;
                string strGameDay = objTraining.GameDay;
                string strStadiumNumber = objTraining.StadiumNumber;

                string WHEREStadiumNumber = "";

                if (strStadiumNumber != "")
                {
                    WHEREStadiumNumber = " AND StadiumNumber = '" + strStadiumNumber + "'";
                }

                string strSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_PubName(TeamGb) AS TeamGbName, TeamGb, GroupGameGb"
                + " FROM tblRGameLevel"
                + " WHERE SportsGb = '" + strSportsGb + "'"
                + " AND GameTitleIDX = '" + strGameTitleIDX + "'"                
                + " AND GameDay = '" + strGameDay + "'"
                + " AND DelYN = 'N'"
                + WHEREStadiumNumber
                + " GROUP BY GroupGameGb, TeamGb";

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    statelist_return statelist_returnItem = new statelist_return();

                    statelist_returnItem.GroupGameGbName = reader["GroupGameGbName"].ToString();
                    statelist_returnItem.TeamGbName = reader["TeamGbName"].ToString();
                    statelist_returnItem.TeamGb = reader["TeamGb"].ToString();
                    statelist_returnItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    
                    list.Add(statelist_returnItem);        

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
 

    public class statelist_return
    { 

        private System.String r_GroupGameGbName;
        private System.String r_TeamGbName;
        private System.String r_TeamGb;
        private System.String r_GroupGameGb;
        
                
        public statelist_return()
        {
        
        }

        public string GroupGameGbName { get { return r_GroupGameGbName; } set { r_GroupGameGbName = value; } }
        public string TeamGbName { get { return r_TeamGbName; } set { r_TeamGbName = value; } }
        public string TeamGb { get { return r_TeamGb; } set { r_TeamGb = value; } }
        public string GroupGameGb { get { return r_GroupGameGb; } set { r_GroupGameGb = value; } }

    }

    
    //값받는부분
    public class statelist_get
    {
       
        public string SportsGb { get; set; }
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