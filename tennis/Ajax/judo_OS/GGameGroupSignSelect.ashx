<%@ WebHandler Language="C#" Class="GGame_GGameGroupSignSelect" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupSignSelect : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<GSignSelect_return> list = new List<GSignSelect_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            GSignSelect_get objGSignSelect_get = Deserialize<GSignSelect_get>(strJson);

            if (objGSignSelect_get != null)
            {
                string strRGameLevelidx = objGSignSelect_get.RGameLevelidx;
                string strGroupGameNum = objGSignSelect_get.GroupGameNum;

                /*
                string strSql = "SELECT ChiefSign, AssChiefSign1, AssChiefSign2"
                + " FROM tblRGameGroup"
                + " WHERE RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND GroupGameNum = '" + strGroupGameNum + "'";             
                */

                
                string strSql = "SELECT GroupChiefSign, GroupAssChiefSign1, GroupAssChiefSign2"
                + " FROM tblPlayerResult"
                + " WHERE RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND GroupGameNum = '" + strGroupGameNum + "'"
                + " AND GameNum = '0'"
                + " AND DelYN = 'N'";                                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    GSignSelect_return GSignSelect_returnItem = new GSignSelect_return();


                    GSignSelect_returnItem.ChiefSign = reader["GroupChiefSign"].ToString();
                    GSignSelect_returnItem.AssChiefSign1 = reader["GroupAssChiefSign1"].ToString();
                    GSignSelect_returnItem.AssChiefSign2 = reader["GroupAssChiefSign2"].ToString();
                    list.Add(GSignSelect_returnItem);

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
 

    public class GSignSelect_return
    {

        private System.String chiefsign;
        private System.String asschiefsign1;
        private System.String asschiefsign2;
        
        public GSignSelect_return()
        {
        
        }

        public string ChiefSign { get { return chiefsign; } set { chiefsign = value; } }
        public string AssChiefSign1 { get { return asschiefsign1; } set { asschiefsign1 = value; } }
        public string AssChiefSign2 { get { return asschiefsign2; } set { asschiefsign2 = value; } }
        
    }

    
    //값받는부분
    public class GSignSelect_get
    {
        public string RGameLevelidx { get; set; }
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

