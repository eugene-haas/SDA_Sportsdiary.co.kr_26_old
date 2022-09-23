<%@ WebHandler Language="C#" Class="GGame_tblGameResultDtlSelect_Log" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_tblGameResultDtlSelect_Log : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<ResultDtlLog_return> list = new List<ResultDtlLog_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            ResultDtlLog_get objResultDtlLog_get = Deserialize<ResultDtlLog_get>(strJson);

            if (objResultDtlLog_get != null)
            {
                string strRGameLevelidx = objResultDtlLog_get.RGameLevelidx;
                string strGroupGameNum = objResultDtlLog_get.GroupGameNum;                
                string strPlayerGameNum = objResultDtlLog_get.PlayerGameNum;
                string strOrderbyType = objResultDtlLog_get.OrderbyType;
                
               
                string WHERE_GroupGameGb = "";
                string WHERE_Level = "";
                string JOIN_Level = "";

                string strOrderBy = "";

                if (strOrderbyType == "ScoreBoard")
                {
                    strOrderbyType = " ORDER BY OverTime ASC, CheckTime, IDX ASC";
                }
                else {
                    strOrderbyType = " ORDER BY OverTime DESC, CheckTime, IDX ASC";
                }

                string strSql = "SELECT RGameResultDtlIDX, Sportsdiary.dbo.FN_PubName(A.LeftRight) AS LeftRight, Sportsdiary.dbo.FN_PubName(A.JumsuGb) AS JumsuGb,"
                    + " P3.PPubName AS SpecialtyGb, Sportsdiary.dbo.FN_PubName_Spec(A.SpecialtyDtl) AS SpecialtyDtl,"
                    + " CheckTime, A.PlayerPosition, A.IDX, RP.UserName AS PlayerName, OverTime"
                    + " FROM"
                    + "     ("
                    + "     SELECT B.RGameResultDtlIDX, B.GameTitleIDX, B.SportsGb, B.TeamGb, B.Sex, B.Level, B.GroupGameGb, B.GameNum, B.CheckTime, B.IDX, B.DELYN, B.WriteDate, B.OverTime, B.GroupGameNum, RGameLevelIDX,"
                    + "     CASE WHEN B.LJumsuGb <> '' Then B.LLeftRight Else B.RLeftRight End AS LeftRight,"
                    + "     CASE WHEN B.LJumsuGb <> '' Then B.LJumsuGb Else B.RJumsuGb End AS JumsuGb,"
                    + "     CASE WHEN B.LJumsuGb <> '' Then B.LSpecialtyGb Else B.RSpecialtyGb End AS SpecialtyGb,"
                    + "     CASE WHEN B.LJumsuGb <> '' Then B.LSpecialtyDtl Else B.RSpecialtyDtl End AS SpecialtyDtl,"
                    + "     CASE WHEN B.LJumsuGb <> '' Then 'LPlayer' Else 'RPlayer' End AS PlayerPosition, "
                    + "     CASE WHEN B.LJumsuGb <> '' Then B.LPlayerIDX Else B.RPlayerIDX End AS PlayerIDX "                    
                    + "     FROM tblRGameResultDtl B "
                    + " 	WHERE B.RGameLevelidx='" + strRGameLevelidx + "' "
                    + " 	AND B.GroupGameNum='" + strGroupGameNum + "'"                 
                    + " 	AND B.GameNum='" + strPlayerGameNum + "'"
                    + " 	AND B.DELYN='N'"
                    + "    ) AS A"
                    + " LEFT JOIN (SELECT PPubCode, PPubName FROM tblPubCode_spec GROUP BY PPubCode, PPubName) P3 ON P3.PPubCode = A.SpecialtyGb"
                    + " LEFT JOIN tblRPlayer RP ON RP.RGameLevelIDX = A.RGameLevelIDX AND RP.PlayerIDX = A.PlayerIDX AND RP.GroupGameNum = A.GroupGameNum "
                    + " WHERE "
                    + "  ("
                    + " 	RP.Game1R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game2R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game3R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game4R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game5R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game6R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game7R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game8R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game9R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game10R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game11R = '" + strPlayerGameNum + "' OR"
                    + " 	RP.Game12R = '" + strPlayerGameNum + "'"                                                                                                    
                    + "  )"
                    + " AND (RP.DelYN = 'N' OR RP.DelYN IS NULL)"
                    + strOrderbyType;




                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {
                   
                    ResultDtlLog_return ResultDtlLog_returnItem = new ResultDtlLog_return();


                    ResultDtlLog_returnItem.LeftRight = reader["LeftRight"].ToString();
                    ResultDtlLog_returnItem.JumsuGb = reader["JumsuGb"].ToString();
                    ResultDtlLog_returnItem.SpecialtyGb = reader["SpecialtyGb"].ToString();
                    ResultDtlLog_returnItem.SpecialtyDtl = reader["SpecialtyDtl"].ToString();
                    ResultDtlLog_returnItem.CheckTime = reader["CheckTime"].ToString();
                    ResultDtlLog_returnItem.PlayerName = reader["PlayerName"].ToString();
                    ResultDtlLog_returnItem.PlayerPosition = reader["PlayerPosition"].ToString();
                    ResultDtlLog_returnItem.Idx = reader["Idx"].ToString();
                    ResultDtlLog_returnItem.OverTime = reader["OverTime"].ToString();
                    ResultDtlLog_returnItem.RGameResultDtlIDX = reader["RGameResultDtlIDX"].ToString();
                    

                    
                    
                    list.Add(ResultDtlLog_returnItem);

                }

                reader.Close();
                DsCom.Connection.Close();
                DbCon.Close();
                context.Response.Write(new JavaScriptSerializer().Serialize(list).ToString());
                //context.Response.Write(strSql);
                
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
 

    public class ResultDtlLog_return
    {

        private System.String leftright;
        private System.String jumsugb;
        private System.String specialtygb;
        private System.String specialtydtl;
        private System.String checktime;
        private System.String playername;
        private System.String playerposition;
        private System.String idx;
        private System.String overtime;    
        private System.String rgameresultdtlidx;    
        
        
                    
        
        
        
        public ResultDtlLog_return()
        {
        
        }

        public string LeftRight { get { return leftright; } set { leftright = value; } }
        public string JumsuGb { get { return jumsugb; } set { jumsugb = value; } }
        public string SpecialtyGb { get { return specialtygb; } set { specialtygb = value; } }
        public string SpecialtyDtl { get { return specialtydtl; } set { specialtydtl = value; } }
        public string CheckTime { get { return checktime; } set { checktime = value; } }
        public string PlayerName { get { return playername; } set { playername = value; } }
        public string PlayerPosition { get { return playerposition; } set { playerposition = value; } }
        public string Idx { get { return idx; } set { idx = value; } }
        public string OverTime { get { return overtime; } set { overtime = value; } }
        public string RGameResultDtlIDX { get { return rgameresultdtlidx; } set { rgameresultdtlidx = value; } }
    }

    
    //값받는부분
    public class ResultDtlLog_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameNum { get; set; }             
        public string PlayerGameNum { get; set; }
        public string OrderbyType { get; set; }   
        
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