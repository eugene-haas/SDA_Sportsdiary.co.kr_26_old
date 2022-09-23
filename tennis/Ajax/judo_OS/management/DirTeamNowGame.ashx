<%@ WebHandler Language="C#" Class="Ajax_judo_OS_DirTeamNowGame" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

//공통코드 로드
public class Ajax_judo_OS_DirTeamNowGame : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<PubCodes> list = new List<PubCodes>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            TrainInfo obj = Deserialize<TrainInfo>(strJson);

            if (obj != null)
            {
                string strSportsGb = obj.SportsGb;
                string strEnterType = obj.EnterType;
                string strGameTitleIDX = obj.GameTitleIDX;
                

                string strSql = "SELECT A.SportsGb, A.TeamGb, SportsDiary.dbo.FN_TeamGbNm(A.SportsGb, A.TeamGb) AS TeamGbNm"
                    + " FROM tblRGameLevel A"
                    + " INNER JOIN tblTeamGbInfo B ON B.SportsGb = A.SportsGb AND B.TeamGb = A.TeamGb"
                    + " WHERE A.DelYN = 'N'"
                    + " AND B.DelYN = 'N'"
                    + " AND A.SportsGb = '" + strSportsGb + "'"
                    + " AND A.GameTitleIDX = '" + strGameTitleIDX + "'"
                    + " AND B.EnterType = (select EnterType from tblGameTitle where DelYN='N' and SportsGb='" + strSportsGb + "' and GameTitleIDX='" + strGameTitleIDX + "' group by EnterType) "
                    + " GROUP BY A.SportsGb, A.TeamGb, B.EnterType, B.OrderBy"
                    + " ORDER BY B.OrderBy ASC";



                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    PubCodes PubCodeItem = new PubCodes();

                    PubCodeItem.SportsGb = reader["SportsGb"].ToString();
                    PubCodeItem.TeamGb = reader["TeamGb"].ToString();
                    PubCodeItem.TeamGbNm = reader["TeamGbNm"].ToString();
                    list.Add(PubCodeItem);
                    
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
 

    public class PubCodes
    {

        private System.String R_SportsGb;
        private System.String R_TeamGb;
        private System.String R_TeamGbNm;
        
        public PubCodes()
        {
        
        }

        public string SportsGb { get { return R_SportsGb; } set { R_SportsGb = value; } }
        public string TeamGb { get { return R_TeamGb; } set { R_TeamGb = value; } }
        public string TeamGbNm { get { return R_TeamGbNm; } set { R_TeamGbNm = value; } }

        
    }

    
    //값받는부분
    public class TrainInfo
    {

        public string SportsGb { get; set; }
        public string EnterType { get; set; }
        public string GameTitleIDX { get; set; }

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