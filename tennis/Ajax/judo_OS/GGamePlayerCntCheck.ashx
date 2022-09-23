<%@ WebHandler Language="C#" Class="GGame_GGamePlayerCntCheck" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGamePlayerCntCheck : CommPage, IHttpHandler
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
                string strRGameLevelidx = objCheckcnt_get.RGameLevelidx;
                string strGroupGameNum = objCheckcnt_get.GroupGameNum;
                string strGameNum = objCheckcnt_get.GameNum;

                string strSql = "SELECT RPlayerIDX, PlayerIDX "
                + " FROM SportsDiary.dbo.tblRPlayer A"
                + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "' "
                + " AND GroupGameNum = '" + strGroupGameNum + "'"
                + " AND" 
                + "	("
                + " Game1R = '" + strGameNum + "' OR"
		        + " Game2R = '" + strGameNum + "' OR"
		        + " Game3R = '" + strGameNum + "' OR"
		        + " Game4R = '" + strGameNum + "' OR"
		        + " Game5R = '" + strGameNum + "' OR"
                + " Game6R = '" + strGameNum + "' OR"
                + " Game7R = '" + strGameNum + "' OR"
                + " Game8R = '" + strGameNum + "' OR"
                + " Game9R = '" + strGameNum + "' OR"
                + " Game10R = '" + strGameNum + "' OR"
                + " Game11R = '" + strGameNum + "' OR"                                                                                                
                + " Game12R = '" + strGameNum + "'"
	            + " )"
                + " AND A.DelYN = 'N'"
                + " ORDER BY PlayerNum ASC";                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    Checkcnt_return Checkcnt_returnItem = new Checkcnt_return();

                    Checkcnt_returnItem.RPlayerIDX = reader["RPlayerIDX"].ToString();
                    Checkcnt_returnItem.PlayerIDX = reader["PlayerIDX"].ToString();

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

        private System.String r_RPlayerIDX;
        private System.String r_PlayerIDX;      
        
        
        public Checkcnt_return()
        {
        
        }

        public string RPlayerIDX { get { return r_RPlayerIDX; } set { r_RPlayerIDX = value; } }
        public string PlayerIDX { get { return r_PlayerIDX; } set { r_PlayerIDX = value; } }
        
    }

    
    //값받는부분
    public class Checkcnt_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameNum { get; set; }
        public string GameNum { get; set; }
        
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