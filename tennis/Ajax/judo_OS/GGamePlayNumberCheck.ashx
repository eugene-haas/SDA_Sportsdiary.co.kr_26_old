<%@ WebHandler Language="C#" Class="GGamePlayNumberCheck" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

public class GGamePlayNumberCheck : CommPage, IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        context.Response.ContentType = "text/plain";

        List<Round_return> list = new List<Round_return>();

        SqlConnection DbCon = new SqlConnection(strDsn());

        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            Round_get objRound_get = Deserialize<Round_get>(strJson);

            if (objRound_get != null)
            {
                string strRGameLevelidx = objRound_get.RGameLevelidx;

                string strSql = "";


                strSql = " SELECT SUM(Count8) AS Count8, SUM(Count9) AS Count9, "
                + " SUM(Count10) AS Count10, SUM(Count11) AS Count11, "
                + " SUM(Count12) AS Count12, SUM(Count13) AS Count13, "
                + " SUM(Count14) AS Count14, SUM(Count15) AS Count15"
                + " FROM"
                + "     ("
                + "     SELECT CASE WHEN Game4R = '8' THEN 1 ELSE 0 END AS Count8,"
                + "     CASE WHEN Game4R = '9' THEN 1 ELSE 0 END AS Count9,"
                + "     CASE WHEN Game5R = '10' THEN 1 ELSE 0 END AS Count10,"
                + "     CASE WHEN Game5R = '11' THEN 1 ELSE 0 END AS Count11,"
                + "     CASE WHEN Game6R = '12' THEN 1 ELSE 0 END AS Count12,"
                + "     CASE WHEN Game7R = '13' THEN 1 ELSE 0 END AS Count13,"
                + "     CASE WHEN Game8R = '14' THEN 1 ELSE 0 END AS Count14,"
                + "     CASE WHEN Game9R = '15' THEN 1 ELSE 0 END AS Count15"
                + "     FROM tblRPlayer "
                + "     WHERE DelYN = 'N'"
                + "     AND RGameLevelidx = '" + strRGameLevelidx + "'"
                + "     ) AS AA";
                

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    Round_return Round_returnItem = new Round_return();

                    Round_returnItem.strCount8 = reader["Count8"].ToString();
                    Round_returnItem.strCount9 = reader["Count9"].ToString();
                    Round_returnItem.strCount10 = reader["Count10"].ToString();
                    Round_returnItem.strCount11 = reader["Count11"].ToString();
                    Round_returnItem.strCount12 = reader["Count12"].ToString();
                    Round_returnItem.strCount13 = reader["Count13"].ToString();
                    Round_returnItem.strCount14 = reader["Count14"].ToString();
                    Round_returnItem.strCount15 = reader["Count15"].ToString();

                    list.Add(Round_returnItem);

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


    public class Round_return
    {

        private System.String r_strCount8;
        private System.String r_strCount9;
        private System.String r_strCount10;
        private System.String r_strCount11;
        private System.String r_strCount12;
        private System.String r_strCount13;
        private System.String r_strCount14;
        private System.String r_strCount15;

        public Round_return()
        {

        }

        public string strCount8 { get { return r_strCount8; } set { r_strCount8 = value; } }
        public string strCount9 { get { return r_strCount9; } set { r_strCount9 = value; } }
        public string strCount10 { get { return r_strCount10; } set { r_strCount10 = value; } }
        public string strCount11 { get { return r_strCount11; } set { r_strCount11 = value; } }
        public string strCount12 { get { return r_strCount12; } set { r_strCount12 = value; } }
        public string strCount13 { get { return r_strCount13; } set { r_strCount13 = value; } }
        public string strCount14 { get { return r_strCount14; } set { r_strCount14 = value; } }
        public string strCount15 { get { return r_strCount15; } set { r_strCount15 = value; } }                                                        


    }


    //값받는부분
    public class Round_get
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
