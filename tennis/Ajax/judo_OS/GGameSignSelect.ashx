<%@ WebHandler Language="C#" Class="GGame_GGameSignSelect" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameSignSelect : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<SignSelect_return> list = new List<SignSelect_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            SignSelect_get objSignSelect_get = Deserialize<SignSelect_get>(strJson);

            if (objSignSelect_get != null)
            {
                string strRGameLevelidx = objSignSelect_get.RGameLevelidx;
                string strGroupGameNum = objSignSelect_get.GroupGameNum;
                string strPlayerGameNum = objSignSelect_get.PlayerGameNum;

                /*--2017-08-08 변경 싸인데이터불러오기 경기결과테이블 -> 경기순서테이블--*/
                /*
                string strSql = "SELECT ChiefSign, AssChiefSign1, AssChiefSign2"
                + " FROM tblRGameResult"
                + " WHERE RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND GroupGameNum='" + strGroupGameNum + "'"
                + " AND GameNum='" + strPlayerGameNum + "'"
                + " AND DelYN='N'";
                */

                string strSql = "SELECT ChiefSign, AssCheifSign1, AssCheifSign2"
                + " FROM tblPlayerResult"
                + " WHERE RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND GroupGameNum='" + strGroupGameNum + "'"
                + " AND GameNum='" + strPlayerGameNum + "'"
                + " AND DelYN='N'";                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    SignSelect_return SignSelect_returnItem = new SignSelect_return();


                    SignSelect_returnItem.ChiefSign = reader["ChiefSign"].ToString();
                    SignSelect_returnItem.AssChiefSign1 = reader["AssCheifSign1"].ToString();
                    SignSelect_returnItem.AssChiefSign2 = reader["AssCheifSign2"].ToString();
                    list.Add(SignSelect_returnItem);

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
 

    public class SignSelect_return
    {

        private System.String chiefsign;
        private System.String asschiefsign1;
        private System.String asschiefsign2;
        
        public SignSelect_return()
        {
        
        }

        public string ChiefSign { get { return chiefsign; } set { chiefsign = value; } }
        public string AssChiefSign1 { get { return asschiefsign1; } set { asschiefsign1 = value; } }
        public string AssChiefSign2 { get { return asschiefsign2; } set { asschiefsign2 = value; } }
        
    }

    
    //값받는부분
    public class SignSelect_get
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

