<%@ WebHandler Language="C#" Class="GGame_GGameDualResultList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameDualResultList : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<DualResult_return> list = new List<DualResult_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            DualResult_get objDualResult_get = Deserialize<DualResult_get>(strJson);

            if (objDualResult_get != null)
            {
                string strRGameLevelidx = objDualResult_get.RGameLevelidx;
                string strPlayerGameNum = objDualResult_get.PlayerGameNum;
                string strGroupGameNum = objDualResult_get.GroupGameNum;
                

                string WHERE_GroupGameNum = "";


                string strSql = " SELECT LPlayerResult"
                + " FROM tblRGameResult "
                + " WHERE RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND GroupGameNum='" + strGroupGameNum + "'"
                + " AND GameNum='" + strPlayerGameNum + "'"
                + " AND DELYN='N'"
                + " AND (LPlayerResult <> '' AND RPlayerResult <> '')";            
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    DualResult_return DualResult_returnItem = new DualResult_return();

                    DualResult_returnItem.LPlayerResult = reader["LPlayerResult"].ToString();
                    list.Add(DualResult_returnItem);

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
 

    public class DualResult_return
    {

        private System.String r_LPlayerResult;     
        
        public DualResult_return()
        {
        
        }

        public string LPlayerResult { get { return r_LPlayerResult; } set { r_LPlayerResult = value; } }

    }

    
    //값받는부분
    public class DualResult_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameNum { get; set; }        
        public string PlayerGameNum { get; set; }
        
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

