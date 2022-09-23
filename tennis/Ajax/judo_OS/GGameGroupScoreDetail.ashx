<%@ WebHandler Language="C#" Class="GGame_GGameGroupScoreDetail" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameGroupScoreDetail : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<ScoreDetail> list = new List<ScoreDetail>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            Scoreinfo objScoreinfo = Deserialize<Scoreinfo>(strJson);

            if (objScoreinfo != null)
            {
                string strRGameLevelidx = objScoreinfo.RGameLevelidx;
                string strPlayerGameNum = objScoreinfo.PlayerGameNum;
                string strGameType = objScoreinfo.GameType;
                
       
                /*
                string andGroupGameGb = "";
                if (strGroupGameGb == "sd040001"){
                    //개인전(sd040001)일경우만 추가.
                    andGroupGameGb = " and A.GroupGameGb='sd040001' ";
                }
                */

                //테이블
                //tblPubCode : 옵션모아놓은 테이블
                //tblRGameResult : 경기결과(토너먼트)
           

                string strSql = " SELECT A.SportsGb,"
                + " CONVERT(VARCHAR(10),A.GameS,23) AS GameS, "
                + " A.GameTitleName, "
                + " P3.PubName AS GroupGameGbName, "
                + " P1.PubName AS TeamGbName, "
                + " CASE C.Sex WHEN 'WoMan' THEN '여자' ELSE '남자' END AS Sex, "
                + " P2.PubName AS LevelName, "
                + " B.TotRound, "
                + " C.SchoolName,"
                + " C.Team, "
                + " C.TeamDtl, "
                + " C.SchNum,"
                + " B.EntryCnt,"
                + " B.RGameLevelidx,"
                + " SportsDiary.dbo.FN_GroupPlayerLeftRight(B.RGameLevelidx, C.Team, C.TeamDtl, '" + strPlayerGameNum + "') AS TeamLeftRight"
                + " FROM tblGameTitle A"
                + " INNER JOIN tblRGameLevel B ON B.GameTitleIDX = A.GameTitleIDX"
                + " LEFT JOIN tblrgamegroupschool C On C.RGameLevelidx = B.RGameLevelidx "
                + " LEFT JOIN tblPubCode P1 ON B.TeamGb = P1.PubCode"
                + " LEFT JOIN tblPubCode P2 ON B.Level = P2.PubCode"
                + " LEFT JOIN tblPubCode P3 ON B.GroupGameGb = P3.PubCode"
                + " WHERE B.RGameLevelidx = '" + strRGameLevelidx + "'"
                + " AND A.DelYN = 'N'"
                + " AND B.DelYN = 'N'"
                + " AND (C.DelYN = 'N' OR C.DelYN IS NULL)"                
                + " AND ("
                + "     C.Game1R = '" + strPlayerGameNum + "'"
                + "     OR C.Game2R = '" + strPlayerGameNum + "'"
                + "     OR C.Game3R = '" + strPlayerGameNum + "'"
                + "     OR C.Game4R = '" + strPlayerGameNum + "'"
                + "     OR C.Game5R = '" + strPlayerGameNum + "'"
                + "     OR C.Game6R = '" + strPlayerGameNum + "'"
                + "     OR C.Game7R = '" + strPlayerGameNum + "'"
                + "     OR C.Game8R = '" + strPlayerGameNum + "'"
                + "     OR C.Game9R = '" + strPlayerGameNum + "'"
                + "     OR C.Game10R = '" + strPlayerGameNum + "'"
                + "     OR C.Game11R = '" + strPlayerGameNum + "'"
                + "     OR C.Game12R = '" + strPlayerGameNum + "'"
                + "     )";
                
                if (strGameType != "sd043001")
                {
                    if (strGameType == "sd043004" && (strPlayerGameNum == "2" || strPlayerGameNum == "3" || strPlayerGameNum == "4" || strPlayerGameNum == "5" || strPlayerGameNum == "6" || strPlayerGameNum == "7"))
                    {
                        strSql += " AND C.nojoinChangeYN <> 'Y'";
                    }
                    else
                    {
                        strSql += " AND C.Team + C.TeamDtl NOT IN "
                        + "                 ("
                        + "                 SELECT Team + TeamDtl FROM"
                        + "                     ("
                            //+ "                     SELECT LSchIDX AS SchIDX, GameTitleIDX, TeamGb, GroupGameNum, Sex, SportsGb FROM tblrgamegroup WHERE LResult = ''"
                        + "                     SELECT LTeam AS Team, LTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, SportsGb, RGameLevelidx FROM tblrgamegroup WHERE (LResult = '' OR LResult = 'sd019012' OR LResult = 'sd019024' OR LResult = 'sd019021') AND DelYN  = 'N'"
                        + "                     UNION ALL"
                            //+ "                     SELECT RSchIDX AS SchIDX, GameTitleIDX, TeamGb, GroupGameNum, Sex, SportsGb FROM tblrgamegroup WHERE RResult = ''"
                        + "                     SELECT RTeam AS Team, RTeamDtl AS TeamDtl, GameTitleIDX, TeamGb, GroupGameNum, Sex, SportsGb, RGameLevelidx FROM tblrgamegroup WHERE (RResult = '' OR RResult = 'sd019012' OR RResult = 'sd019024' OR RResult = 'sd019021')  AND DelYN  = 'N'"
                        + "                     ) AS LP"
                        + "                 WHERE LP.RGameLevelidx = '" + strRGameLevelidx + "'"
                        + "                 AND LP.GroupGameNum <  " + strPlayerGameNum
                        + "                 )";
                    }
                }
                    strSql +=  " ORDER BY SchNum ASC"; //학교배정번호로 정렬한다(학교배정번호는 연번)
                  
                                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    ScoreDetail ScoreDetailItem = new ScoreDetail();

                    ScoreDetailItem.SportsGb = reader["SportsGb"].ToString();
                    ScoreDetailItem.GameDate = reader["GameS"].ToString();
                    ScoreDetailItem.GameTitleName = reader["GameTitleName"].ToString();
                    ScoreDetailItem.GroupGameGbName = reader["GroupGameGbName"].ToString();
                    ScoreDetailItem.TeamGbName = reader["TeamGbName"].ToString();
                    ScoreDetailItem.SexName = reader["Sex"].ToString();
                    ScoreDetailItem.LevelName = reader["LevelName"].ToString();
                    ScoreDetailItem.TotRoundName = reader["TotRound"].ToString();
                    ScoreDetailItem.SchoolName = reader["SchoolName"].ToString();
                    ScoreDetailItem.Team = reader["Team"].ToString();
                    ScoreDetailItem.TeamDtl = reader["TeamDtl"].ToString();
                    ScoreDetailItem.SchNum = reader["SchNum"].ToString();
                    ScoreDetailItem.EntryCnt = reader["EntryCnt"].ToString();
                    ScoreDetailItem.RGameLevelidx = reader["RGameLevelidx"].ToString();
                    ScoreDetailItem.TeamLeftRight = reader["TeamLeftRight"].ToString();       
                    
                    
                    list.Add(ScoreDetailItem);

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
 

    public class ScoreDetail
    {

        private System.String sportsgb;
        private System.String gamedate;
        private System.String gametitlename;
        private System.String groupgamegbname;
        private System.String teamgbname;
        private System.String sexname;
        private System.String levelname;
        private System.String totroundname;
        private System.String schoolname;
        private System.String team;
        private System.String teamdtl;        
        private System.String schnum;
        private System.String entrycnt;
        private System.String rgamelevelidx;
        private System.String teamleftright;   
          
        public ScoreDetail()
        {
        
        }


        public string SportsGb { get { return sportsgb; } set { sportsgb = value; } }
        public string GameDate { get { return gamedate; } set { gamedate = value; } }
        public string GameTitleName { get { return gametitlename; } set { gametitlename = value; } }
        public string GroupGameGbName { get { return groupgamegbname; } set { groupgamegbname = value; } }
        public string TeamGbName { get { return teamgbname; } set { teamgbname = value; } }
        public string SexName { get { return sexname; } set { sexname = value; } }
        public string LevelName { get { return levelname; } set { levelname = value; } }
        public string TotRoundName { get { return totroundname; } set { totroundname = value; } }
        public string SchoolName { get { return schoolname; } set { schoolname = value; } }
        public string Team { get { return team; } set { team = value; } }
        public string TeamDtl { get { return teamdtl; } set { teamdtl = value; } }
        public string SchNum { get { return schnum; } set { schnum = value; } }
        public string EntryCnt { get { return entrycnt; } set { entrycnt = value; } }
        public string RGameLevelidx { get { return rgamelevelidx; } set { rgamelevelidx = value; } }
        public string TeamLeftRight { get { return teamleftright; } set { teamleftright = value; } }
        
        
    }

    
    //값받는부분
    public class Scoreinfo
    {
        public string RGameLevelidx { get; set; }
        public string PlayerGameNum { get; set; }
        public string GameType { get; set; }               
         
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

