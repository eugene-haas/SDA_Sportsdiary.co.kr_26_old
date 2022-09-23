<%@ WebHandler Language="C#" Class="GGame_GGameGroupWinResult" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupWinResult : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<WinResult_return> list = new List<WinResult_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            WinResult_get objWinResult_get = Deserialize<WinResult_get>(strJson);

            if (objWinResult_get != null)
            {
                string strRGameLevelidx = objWinResult_get.RGameLevelidx;
                string strGroupGameNum = objWinResult_get.GroupGameNum;
      
            
                
                string strSql = " SELECT "
                + " AA.LeftSchoolName,"
                + " AA.LTeam, AA.LTeamDtl,"
                + " SUM(LeftWinNum) AS LeftWinCnt,"
                + " SUM(LeftDrawNum) AS LeftDrawCnt,"
                + " SUM(LeftLoseNum) AS LeftLoseCnt,"
                + " SUM(CONVERT(FLOAT,LeftJumsu)) AS LeftJumsu,"
                + " AA.RightSchoolName,"
                + " AA.RTeam, AA.RTeamDtl,"
                + " SUM(RightWinNum) AS RightWinCnt,"
                + " SUM(RightDrawNum) AS RightDrawCnt,"
                + " SUM(RightLoseNum) AS RightLoseCnt,"
                + " SUM(CONVERT(FLOAT,RightJumsu)) AS RightJumsu,"
                + " SUM(GameCnt) AS GameCnt"
                + " FROM"
                + " ("

                + " SELECT CASE WHEN ISNULL(LPlayerResult,'') <> '' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019012' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019024' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019021' "
                + " 	THEN 1 ELSE 0 END LeftWinNum, "
                + " CASE WHEN ISNULL(LPlayerResult,'') = 'sd019024' "
                + " 	THEN 1 ELSE 0 END LeftDrawNum, "
                + " CASE WHEN ISNULL(LPlayerResult,'') = '' OR ISNULL(LPlayerResult,'') = 'sd019012' THEN 1 ELSE 0 END LeftLoseNum, "
                + " ISNULL(A.LJumsu,'0') AS LeftJumsu,"
                + " ISNULL(A.RJumsu,'0') AS RightJumsu,"
                + " CASE WHEN ISNULL(RPlayerResult,'') <> '' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019012' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019024' "
                + " 	AND ISNULL(LPlayerResult,'') <> 'sd019021' "
                + " 	THEN 1 ELSE 0 END RightWinNum, "
                + " CASE WHEN ISNULL(RPlayerResult,'') = 'sd019024' "
                + " 	THEN 1 ELSE 0 END RightDrawNum,"
                + " CASE WHEN ISNULL(RPlayerResult,'') = '' OR ISNULL(RPlayerResult,'') = 'sd019012' THEN 1 ELSE 0 END RightLoseNum,"

                + " LPlayerResult,"
                + " RPlayerResult,"
                + " A.LTeam, A.LTeamDtl,"
                + " A.RTeam, A.RTeamDtl,"
                + " Sportsdiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.LTeam) AS LeftSchoolName,"
                + " Sportsdiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.RTeam) AS RightSchoolName,"
                + " CASE WHEN RGameResultIDX IS NULL THEN 0 ELSE 1 END AS GameCnt"
                + " FROM tblRGameResult A"
                + " WHERE A.RGameLevelidx='" + strRGameLevelidx + "'"
                + " AND A.GroupGameNum='" + strGroupGameNum + "'"
                + " AND A.DelYN='N'"
                + " ) AS AA"
                + " GROUP BY LTeam, RTeam, LTeamDtl, RTeamDtl, LeftSchoolName, RightSchoolName";

                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    WinResult_return WinResult_returnItem = new WinResult_return();


                    WinResult_returnItem.LeftSchoolName = reader["LeftSchoolName"].ToString();
                    WinResult_returnItem.LTeam = reader["LTeam"].ToString();
                    WinResult_returnItem.LTeamDtl = reader["LTeamDtl"].ToString();                    
                    WinResult_returnItem.LeftWinCnt = reader["LeftWinCnt"].ToString();
                    WinResult_returnItem.LeftDrawCnt = reader["LeftDrawCnt"].ToString();
                    WinResult_returnItem.LeftLoseCnt = reader["LeftLoseCnt"].ToString();
                    WinResult_returnItem.LeftJumsu = reader["LeftJumsu"].ToString();
                    WinResult_returnItem.RightSchoolName = reader["RightSchoolName"].ToString();
                    WinResult_returnItem.RTeam = reader["RTeam"].ToString();
                    WinResult_returnItem.RTeamDtl = reader["RTeamDtl"].ToString();                    
                    WinResult_returnItem.RightWinCnt = reader["RightWinCnt"].ToString();
                    WinResult_returnItem.RightDrawCnt = reader["RightDrawCnt"].ToString();
                    WinResult_returnItem.RightLoseCnt = reader["RightLoseCnt"].ToString();
                    WinResult_returnItem.RightJumsu = reader["RightJumsu"].ToString();
                    WinResult_returnItem.GameCnt = reader["GameCnt"].ToString();                         
                               
                    list.Add(WinResult_returnItem);

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
 

    public class WinResult_return
    {                 

        private System.String leftschoolname;
        private System.String lteam;
        private System.String lteamdtl;
        private System.String leftwincnt;
        private System.String leftdrawcnt;            
        private System.String leftlosecnt;
        private System.String leftjumsu;
        private System.String rightschoolname;
        private System.String rteam;
        private System.String rteamdtl;
        private System.String rightwincnt;
        private System.String rightdrawcnt;
        private System.String rightlosecnt;
        private System.String rightjumsu;
        private System.String gamecnt;
        
        
        
           
          
        public WinResult_return()
        {
        
        }


        public string LeftSchoolName { get { return leftschoolname; } set { leftschoolname = value; } }
        public string LTeam { get { return lteam; } set { lteam = value; } }
        public string LTeamDtl { get { return lteamdtl; } set { lteamdtl = value; } }
        public string LeftWinCnt { get { return leftwincnt; } set { leftwincnt = value; } }

        public string LeftDrawCnt { get { return leftdrawcnt; } set { leftdrawcnt = value; } }
        public string LeftLoseCnt { get { return leftlosecnt; } set { leftlosecnt = value; } }
        public string LeftJumsu { get { return leftjumsu; } set { leftjumsu = value; } }
        public string RightSchoolName { get { return rightschoolname; } set { rightschoolname = value; } }
        public string RTeam { get { return rteam; } set { rteam = value; } }
        public string RTeamDtl { get { return rteam; } set { rteam = value; } }        
        public string RightWinCnt { get { return rightwincnt; } set { rightwincnt = value; } }

        public string RightDrawCnt { get { return rightdrawcnt; } set { rightdrawcnt = value; } }
        public string RightLoseCnt { get { return rightlosecnt; } set { rightlosecnt = value; } }
        public string RightJumsu { get { return rightjumsu; } set { rightjumsu = value; } }
        public string GameCnt { get { return gamecnt; } set { gamecnt = value; } }
        
    }

    
    //값받는부분
    public class WinResult_get
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