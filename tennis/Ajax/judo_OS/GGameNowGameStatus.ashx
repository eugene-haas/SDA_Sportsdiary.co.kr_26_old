<%@ WebHandler Language="C#" Class="GGame_GGameNowGameStatus" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameNowGameStatus : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<NowStatus_return> list = new List<NowStatus_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            NowStatus_get objNowStatus_get = Deserialize<NowStatus_get>(strJson);

            if (objNowStatus_get != null)
            {

                string strRGameLevelidx = objNowStatus_get.RGameLevelidx;
                string strGroupGameNum = objNowStatus_get.GroupGameNum;
                string strGameNum = objNowStatus_get.GameNum;                                  

                /*
                string strSql = "SELECT GameStatus, StadiumNumber"
                + " FROM tblRgameProgress"
                + " WHERE SportsGb = '" + strSportsGb + "'"
                + " AND GameTitleIDX = '" + strGameTitleIDX + "'"
                + " AND RGameLevelIDX = '" + strRGameLevelidx + "'"
                + " AND GroupGameNum = '" + strGroupGameNum + "'"
                + " AND GameNum = '" + strGameNum + "'"
                + " AND DelYN = 'N'";
                */

                /*
                string strSql = "SELECT A.GameStatus, A.StadiumNumber, B.RGameResultIDX"
                + " FROM tblRgameProgress A"
                + " LEFT JOIN ( "
                + "     SELECT RGameLevelIDX, GroupGameNum, GameNum, RGameResultIDX"
                + "     FROM tblRGameResult"
                + "     WHERE DelYN = 'N'"
                + "      ) AS B "
                + "      ON B.RGameLevelIDX = A.RGameLevelIDX AND A.GroupGameNum = B.GroupGameNum AND A.GameNum = B.GameNum"
                + " WHERE A.SportsGb = '" + strSportsGb + "'"
                + " AND A.GameTitleIDX = '" + strGameTitleIDX + "'"
                + " AND A.RGameLevelIDX = '" + strRGameLevelidx + "'"
                + " AND A.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND A.GameNum = '" + strGameNum + "'"
                + " AND A.DelYN = 'N'";
                */

                string strSql = "SELECT CASE WHEN LPlayerResult = '' THEN RPlayerResult "
                + " 	WHEN RPlayerResult = '' THEN LPlayerResult"
                + "	WHEN LPlayerResult <> '' AND RPlayerResult <> '' THEN LPlayerResult END AS GameStatus,"
                + "	StadiumNumber "
                + " FROM tblRGameResult A"
                + " WHERE A.RGameLevelIDX = '" + strRGameLevelidx + "'"
                + " AND A.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND A.GameNum = '" + strGameNum + "'"
                + " AND A.DelYN = 'N'"                
                + ""
                + " UNION ALL"
                + ""
                + " SELECT A.GameStatus, A.StadiumNumber"
                + " FROM tblRgameProgress A"
                + " WHERE A.RGameLevelIDX = '" + strRGameLevelidx + "'"
                + " AND A.GroupGameNum = '" + strGroupGameNum + "'"
                + " AND A.GameNum = '" + strGameNum + "'"
                + " AND A.DelYN = 'N'";
                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    NowStatus_return NowStatus_returnItem = new NowStatus_return();

                    NowStatus_returnItem.GameStatus = reader["GameStatus"].ToString();
                    NowStatus_returnItem.StadiumNumber = reader["StadiumNumber"].ToString();
                    
                    list.Add(NowStatus_returnItem);

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
 

    public class NowStatus_return
    {

        private System.String r_GameStatus;
        private System.String r_StadiumNumber;

        
        
        public NowStatus_return()
        {
        
        }

        public string GameStatus { get { return r_GameStatus; } set { r_GameStatus = value; } }
        public string StadiumNumber { get { return r_StadiumNumber; } set { r_StadiumNumber = value; } }
        
    }

    
    //값받는부분
    public class NowStatus_get
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

