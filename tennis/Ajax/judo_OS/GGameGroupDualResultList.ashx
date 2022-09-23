<%@ WebHandler Language="C#" Class="GGame_GGameGroupDualResultList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupDualResultList : CommPage, IHttpHandler
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
                string strGroupGameNum = objDualResult_get.GroupGameNum;

                string WHERE_GroupGameNum = "";


                string strSql = " SELECT B.LResult, B.RResult, SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName,"
                + " SportsDiary.dbo.FN_PubName(B.LResult) AS LResultName, SportsDiary.dbo.FN_PubName(B.RResult) AS RResultName"
                + " FROM tblRgameGroup B"
                + " WHERE B.GameTitleIDX='" + strRGameLevelidx + "'"
                + " AND B.GameNum='" + strGroupGameNum + "'"
                + " AND B.DELYN='N'";            
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    DualResult_return DualResult_returnItem = new DualResult_return();

                    DualResult_returnItem.LResult = reader["LResult"].ToString();
                    DualResult_returnItem.RResult = reader["RResult"].ToString();
                    DualResult_returnItem.LSchoolName = reader["LSchoolName"].ToString();
                    DualResult_returnItem.RSchoolName = reader["RSchoolName"].ToString();
                    DualResult_returnItem.LResultName = reader["LResultName"].ToString();
                    DualResult_returnItem.RResultName = reader["RResultName"].ToString();
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

        private System.String r_LResult;
        private System.String r_RResult;
        private System.String r_LSchoolName;
        private System.String r_RSchoolName;
        private System.String r_LResultName;
        private System.String r_RResultName;
        
        public DualResult_return()
        {
        
        }

        public string LResult { get { return r_LResult; } set { r_LResult = value; } }
        public string RResult { get { return r_RResult; } set { r_RResult = value; } }
        public string LSchoolName { get { return r_LSchoolName; } set { r_LSchoolName = value; } }
        public string RSchoolName { get { return r_RSchoolName; } set { r_RSchoolName = value; } }
        public string LResultName { get { return r_LResultName; } set { r_LResultName = value; } }
        public string RResultName { get { return r_RResultName; } set { r_RResultName = value; } }
        
        
    }

    
    //값받는부분
    public class DualResult_get
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

