<%@ WebHandler Language="C#" Class="GGame_GGameRoundListDetail" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameRoundListDetail : CommPage, IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        context.Response.ContentType = "text/plain";

        List<RoundDetail_return> list = new List<RoundDetail_return>();

        SqlConnection DbCon = new SqlConnection(strDsn());

        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            RoundDetail_get objRoundDetail_get = Deserialize<RoundDetail_get>(strJson);

            if (objRoundDetail_get != null)
            {
                string strRGameLevelidx = objRoundDetail_get.RGameLevelidx;
                string strGroupGameGb = objRoundDetail_get.GroupGameGb;
                string strRound = objRoundDetail_get.strRound;                
                

                string strSql = "";

                //해당경기의 ROUND 구하기 (몇강인지..)

                //개인전
                if (strGroupGameGb == "sd040001")
                {
                    
                    strSql = "SELECT GameNum, LPlayerName, LPlayerResult, RPlayerName, RPlayerResult,"
                    + " CASE WHEN P1.PubName <> '' THEN P1.PubName ELSE P2.PubName END AS GameResult"
                    + " FROM tblRGameResult A"
                    + " INNER JOIN tblRGameLevel B ON"
                    + " A.GameTitleIDX = B.GameTitleIDX"
                    + " AND A.SportsGb = B.SportsGb"
                    + " AND A.TeamGb = B.TeamGb"
                    + " AND A.Level = B.Level"
                    + " AND A.GroupGameGb = B.GroupGameGb"
                    + " AND A.Sex = B.Sex"
                    + " LEFT JOIN tblPubCode P1 ON P1.PubCode = A.LPlayerResult"
                    + " LEFT JOIN tblPubCode P2 ON P2.PubCode = A.RPlayerResult"
                    + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                    + " AND A.GroupGameGb = '" + strGroupGameGb + "'"
                    + " AND ISNULL(A.[Round],'0') = '" + strRound + "'"
                    + " AND A.DelYN = 'N'"
                    + " AND B.DelYN = 'N'"                    
                    + " ORDER BY A.GameNum DESC";

                }
                //단체전
                else
                {
                    strSql = "SELECT GroupGameNum AS GameNum, SportsDiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.LTeam) AS LPlayerName, A.LResult AS LPlayerResult, SportsDiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.RTeam) AS RPlayerName, A.RResult AS RPlayerResult,"
                    + " CASE WHEN P1.PubName <> '' THEN P1.PubName ELSE P2.PubName END AS GameResult,''RTeamNm,''LTeamNm"
                    + " FROM tblRGameGroup A"
                    + " INNER JOIN tblRGameLevel B ON"
                    + " A.GameTitleIDX = B.GameTitleIDX"
                    + " AND A.SportsGb = B.SportsGb"
                    + " AND A.TeamGb = B.TeamGb"
                    + " AND A.Sex = B.Sex"
                    + " LEFT JOIN tblPubCode P1 ON P1.PubCode = A.LResult"
                    + " LEFT JOIN tblPubCode P2 ON P2.PubCode = A.RResult"
                    + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                    + " AND B.GroupGameGb = '" + strGroupGameGb + "'"
                    + " AND ISNULL(A.[Round],'0') = '" + strRound + "'"
                    + " AND A.DelYN = 'N'"
                    + " AND B.DelYN = 'N'"
                    + " ORDER BY A.GroupGameNum DESC";
                }


                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    RoundDetail_return RoundDetail_returnItem = new RoundDetail_return();

                    RoundDetail_returnItem.GameNum = reader["GameNum"].ToString();
                    RoundDetail_returnItem.LPlayerName = reader["LPlayerName"].ToString();
                    RoundDetail_returnItem.LPlayerResult = reader["LPlayerResult"].ToString();
                    RoundDetail_returnItem.RPlayerName = reader["RPlayerName"].ToString();
                    RoundDetail_returnItem.RPlayerResult = reader["RPlayerResult"].ToString();
                    RoundDetail_returnItem.GameResult = reader["GameResult"].ToString();
                    list.Add(RoundDetail_returnItem);

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


    public class RoundDetail_return
    {
        
        private System.String r_GameNum;
        private System.String r_LPlayerName;
        private System.String r_LPlayerResult;
        private System.String r_RPlayerName;
        private System.String r_RPlayerResult;
        private System.String r_GameResult;

        public RoundDetail_return()
        {

        }

        public string GameNum { get { return r_GameNum; } set { r_GameNum = value; } }
        public string LPlayerName { get { return r_LPlayerName; } set { r_LPlayerName = value; } }
        public string LPlayerResult { get { return r_LPlayerResult; } set { r_LPlayerResult = value; } }
        public string RPlayerName { get { return r_RPlayerName; } set { r_RPlayerName = value; } }
        public string RPlayerResult { get { return r_RPlayerResult; } set { r_RPlayerResult = value; } }
        public string GameResult { get { return r_GameResult; } set { r_GameResult = value; } }

    }


    //값받는부분
    public class RoundDetail_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameGb { get; set; }
        public string strRound { get; set; }

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
