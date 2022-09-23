<%@ WebHandler Language="C#" Class="GGame_GGameSearchList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameSearchList : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<PubCodes> list = new List<PubCodes>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            TrainInfo objTraining = Deserialize<TrainInfo>(strJson);

            if (objTraining != null)
            {
                string strSportsGb = objTraining.SportsGb;
                string strGameTitleIDX = objTraining.GameTitleIDX;
                string strTeamGb = objTraining.TeamGb;
                string strSex = objTraining.Sex;
                string strLevel = objTraining.Level;
                string strGroupGameGb = objTraining.GroupGameGb;
                string strLeftRightGb = objTraining.LeftRightGb;
                string strGameNumArray = objTraining.GameNumArray;
                
                    
                //string strSportsGb = "judo";
                //string strGameTitleIDX = "21";
                //string strTeamGb = "sd011002";
                //string strSex = "WoMan";
                //string strLevel = "lv006005";
                //string strGroupGameGb = "sd040001"; 
                string strSql = "";
                string strWHERESql = ""; 

                if (strGroupGameGb == "sd040001"){
                    //개인전일경우만 추가.
                    /*
                    strSql = " Select  "
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " B.PlayerIDX AS UserIDX,B.SchIDX,B.UserName AS UserName, "
                    + " B.PlayerNum AS UserNum,B.UnearnWin,B.LeftRightGb,C.SchoolName, '0' AS PlayerCnt,"
                    + " TitleResult, A.RGameLevelidx"
                    + " From tblRGameLevel A "
                    + " LEFT OUTER JOIN tblRPlayer B ON A.SportsGb=B.SportsGb and A.GameTitleIDX=B.GameTitleIDX "
                    + "     AND A.TeamGb=B.TeamGb "
                    + "     AND A.Level=B.Level "
                    + "     AND A.Sex=B.Sex "
                    + "     AND A.GroupGameGb = B.GroupGameGb "
                    + " LEFT OUTER JOIN tblSchoolList C On B.SportsGb=C.SportsGb and B.SchIDX=C.SchIDX "
					+ " LEFT OUTER JOIN ("
                    + "                 SELECT TitleResult"                    
                    + "                 tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.SportsGb = A.SportsGb"
					+ " 	AND D.GameTitleIDX=A.GameTitleIDX"
					+ " 	AND D.TeamGb=A.TeamGb"
					+ " 	AND D.Level = A.Level"
					+ " 	AND D.Sex = A.Sex"
					+ " 	AND D.GroupGameGb = A.GroupGameGb"
					+ " 	AND D.PlayerIDX = B.PlayerIDX"
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb='" + strTeamGb + "' "
                    + " AND A.Level='" + strLevel + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND B.LeftRightGb='" + strLeftRightGb + "' "
                    + " AND A.GroupGameGb='sd040001'"
                    + " AND A.DelYN='N'"
                    + " AND B.DelYN='N'"
                    + " AND C.DelYN='N'"
                    + " ORDER BY LeftRightGb,PlayerNum ASC";
                    */

                    /*
                    strSql = " Select  "
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " B.PlayerIDX AS UserIDX,B.SchIDX,B.UserName AS UserName, "
                    + " B.PlayerNum AS UserNum,B.UnearnWin,B.LeftRightGb,C.SchoolName, '0' AS PlayerCnt,"
                    + " TitleResult, A.RGameLevelidx"
                    + " From tblRGameLevel A "
                    + " LEFT OUTER JOIN tblRPlayer B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " LEFT OUTER JOIN tblSchoolList C On B.SportsGb = C.SportsGb and B.SchIDX = C.SchIDX "
                    + " LEFT OUTER JOIN ("
                    + "                 SELECT TitleResult, RGameLevelidx, PlayerIDX"
                    + "                 FROM tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.RGameLevelidx=A.RGameLevelidx AND D.PlayerIDX = B.PlayerIDX"
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb='" + strTeamGb + "' "
                    + " AND A.Level='" + strLevel + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND B.LeftRightGb='" + strLeftRightGb + "' "
                    + " AND A.GroupGameGb='sd040001'"
                    + " AND A.DelYN='N'"
                    + " AND B.DelYN='N'"
                    + " AND C.DelYN='N'"
                    + " ORDER BY LeftRightGb,PlayerNum ASC";      
                    
                    */

                    if (ChkInt(strGameNumArray) == true)
                    {

                        strWHERESql = "AND (B.Game1R = '" + strGameNumArray + "'"
                        + " OR B.Game2R = '" + strGameNumArray + "'"
                        + " OR B.Game3R = '" + strGameNumArray + "'"
                        + " OR B.Game4R = '" + strGameNumArray + "'"
                        + " OR B.Game5R = '" + strGameNumArray + "'"
                        + " OR B.Game6R = '" + strGameNumArray + "'"
                        + " OR B.Game7R = '" + strGameNumArray + "'"
                        + " OR B.Game8R = '" + strGameNumArray + "'"
                        + " OR B.Game9R = '" + strGameNumArray + "'"
                        + " OR B.Game10R = '" + strGameNumArray + "'"
                        + " OR B.Game11R = '" + strGameNumArray + "'"
                        + " OR B.Game12R = '" + strGameNumArray + "')";
                        
                    }

                    strSql = " Select  "
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " B.PlayerIDX AS UserIDX, B.Team, B.TeamDtl,"
                    + " B.UserName AS UserName, "
                    + " B.PlayerNum AS UserNum,B.UnearnWin,B.LeftRightGb, Sportsdiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) AS SchoolName, '0' AS PlayerCnt,"
                    + " TitleResult, A.RGameLevelidx, E.LPlayerResult AS LPlayerDualResult, E.RPlayerResult AS RPlayerDualResult, SportsDiary.dbo.FN_TeamSidoNm('" + strSportsGb + "',Team) AS TeamSidoNm,"
                    + " B.WeightFailYN"
                    + " From tblRGameLevel A "
                    + " LEFT OUTER JOIN tblRPlayer B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " LEFT OUTER JOIN ("
                    + "                 SELECT TOP 1 TitleResult, RGameLevelidx, PlayerIDX"
                    + "                 FROM tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.RGameLevelidx=A.RGameLevelidx AND D.PlayerIDX = B.PlayerIDX"
                    
                    + " LEFT OUTER JOIN ("
                    + "                SELECT LPlayerResult, RPlayerResult, RGameLevelidx, LPlayerIDX, RPlayerIDX"
                    + "                FROM tblRGameResult"
                    + "                WHERE DelYN = 'N'"
                    + "                AND (LPlayerResult <> '' AND RPlayerResult <> '')"
                    
                    //경기도중 추가. 리그전 표가 상이하여
                    + "                AND (LPlayerResult = 'sd019021' OR RPlayerResult = 'sd019021')"
                    
                    + "                AND ROUND = '01'"
                    + "                ) E ON E.RGameLevelidx=A.RGameLevelidx AND (E.LPlayerIDX = B.PlayerIDX OR E.RPlayerIDX = B.PlayerIDX)"               
                    
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb ='" + strTeamGb + "' "
                    + " AND A.Level='" + strLevel + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND B.LeftRightGb='" + strLeftRightGb + "' "
                    + " AND A.GroupGameGb='sd040001'"
                    + " AND A.DelYN='N'"
                    + " AND (B.DelYN='N' OR B.DelYN IS NULL)"
                    + strWHERESql
                    + " ORDER BY LeftRightGb,PlayerNum ASC";                          
                                        
                    
                }
                else if (strGroupGameGb == "sd040002")
                {

                    //tblrgamegroupschool은 단체전 테이블이므로 GroupGameGb이 없음
                    //단체전
                    /*
                    strSql = " SELECT"
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " B.SchIDX AS UserIDX,B.SchIDX,B.SchoolName AS UserName, "
                    + " B.SchNum AS UserNum,B.UnearnWin,B.LeftRightGb, '' AS SchoolName,"
					+ " ("
					+ " SELECT COUNT(SchIDX) from tblrplayer S1"
					+ " WHERE S1.SportsGb = B.SportsGb"
					+ " AND S1.GameTitleIDX = B.GameTitleIDX"
					+ " AND S1.TeamGb = B.TeamGb"
					+ " AND S1.Sex = B.Sex"
					+ " AND S1.SchIDX = B.SchIDX"
					+ " ) AS PlayerCnt, "
                    + " D.TitleResult, A.RGameLevelidx"
                    + " FROM tblRGameLevel A"
                    + " LEFT Outer Join tblrgamegroupschool B ON A.SportsGb=B.SportsGb "
                    + " AND A.GameTitleIDX=B.GameTitleIDX"
                    + " AND A.TeamGb=B.TeamGb "
                    + " AND  A.Sex=B.Sex "
					+ " LEFT OUTER JOIN tblGameScore D ON D.SportsGb = B.SportsGb"
					+ " 	AND D.GameTitleIDX=A.GameTitleIDX"
					+ " 	AND D.TeamGb=A.TeamGb"
					+ " 	AND D.Level = A.Level"
					+ " 	AND D.Sex = A.Sex"
					+ " 	AND D.GroupGameGb = A.GroupGameGb"
					+ " 	AND D.SchIDX = B.SchIdx"
                    + " WHERE A.SportsGb='" + strSportsGb + "' "
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb='" + strTeamGb + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND B.LeftRightGb='" + strLeftRightGb + "'"
                    + " AND A.GroupGameGb='sd040002' "
                    //+ " AND A.DelYN='N'"
                    //+ " AND B.DelYN='N'"
                    //+ " AND D.DelYN='N'"                     
                    + " Order by LeftRightGb,SchNum asc ";   
                    */

                    strSql = " SELECT"
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " B.Team AS UserIDX, B.Team, B.TeamDtl, B.SchoolName AS UserName, "
                    + " B.SchNum AS UserNum,B.UnearnWin,B.LeftRightGb, '' AS SchoolName,"
                    + " ("
                    + " SELECT COUNT(Team) from tblrplayer S1"
                    + " WHERE S1.SportsGb = B.SportsGb"
                    + " AND S1.GameTitleIDX = B.GameTitleIDX"
                    + " AND S1.TeamGb = B.TeamGb"
                    + " AND S1.Sex = B.Sex"
                    + " AND S1.Team = B.Team"
                    + " AND S1.TeamDtl = B.TeamDtl"
                    + " ) AS PlayerCnt, "
                    + " D.TitleResult, A.RGameLevelidx,"
                    + " '' AS LPlayerDualResult, '' AS RPlayerDualResult, SportsDiary.dbo.FN_TeamSidoNm('" + strSportsGb + "',B.Team) AS TeamSidoNm,"
                    + " B.WeightFailYN"
                    + " FROM tblRGameLevel A"
                    + " LEFT Outer Join tblrgamegroupschool B ON B.RGameLevelidx = A.RGameLevelidx "
                    + " LEFT OUTER JOIN ("
                    + "                 SELECT TOP 1 TitleResult, RGameLevelidx, Team, TeamDtl"
                    + "                 FROM tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.RGameLevelidx = A.RGameLevelidx AND D.Team = B.Team AND D.TeamDtl = B.TeamDtl"
                    + " WHERE A.SportsGb='" + strSportsGb + "' "
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb='" + strTeamGb + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND B.LeftRightGb='" + strLeftRightGb + "'"
                    + " AND A.GroupGameGb='sd040002' "
                    + " AND A.DelYN='N' "
                    + " AND B.DelYN='N' "                    
                    + " Order by LeftRightGb,SchNum asc ";                      
                }                          

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    PubCodes PubCodeItem = new PubCodes();

                    PubCodeItem.SportsGb = reader["SportsGb"].ToString();
                    PubCodeItem.GameTitleIDX = reader["GameTitleIDX"].ToString();
                    PubCodeItem.TeamGb = reader["TeamGb"].ToString();
                    PubCodeItem.Sex = reader["Sex"].ToString();
                    PubCodeItem.Level = reader["Level"].ToString();
                    PubCodeItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    PubCodeItem.TotRound = reader["TotRound"].ToString();
                    PubCodeItem.GameDay = reader["GameDay"].ToString();
                    PubCodeItem.GameTime = reader["GameTime"].ToString();
                    PubCodeItem.UserName = reader["UserName"].ToString();
                    PubCodeItem.UserIDX = reader["UserIDX"].ToString();
                    PubCodeItem.PlayerNum = reader["UserNum"].ToString(); //PlayerNum
                    PubCodeItem.UnearnWin = reader["UnearnWin"].ToString();
                    PubCodeItem.LeftRightGb = reader["LeftRightGb"].ToString();
                    PubCodeItem.Team = reader["Team"].ToString();
                    PubCodeItem.TeamDtl = reader["TeamDtl"].ToString();
                    
                    PubCodeItem.SchoolName = reader["SchoolName"].ToString();
                    PubCodeItem.TitleResult = reader["TitleResult"].ToString();
                    PubCodeItem.RGameLevelidx = reader["RGameLevelidx"].ToString();

                    PubCodeItem.LPlayerDualResult = reader["LPlayerDualResult"].ToString();
                    PubCodeItem.RPlayerDualResult = reader["RPlayerDualResult"].ToString();

                    PubCodeItem.TeamSidoNm = reader["TeamSidoNm"].ToString();
                    PubCodeItem.WeightFailYN = reader["WeightFailYN"].ToString();                    
                    
                    
                    
   
                    
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


        private System.String sportsgb;
        private System.String gametitleidx;
        private System.String teamgb;
        private System.String sex;
        private System.String level;
        private System.String groupgamegb;
        private System.String totround;
        private System.String gameday;
        private System.String gametime;

        private System.String username;
        private System.String useridx;
        
        private System.String playernum;
        private System.String unearnwin;
        private System.String leftrightgb;
        private System.String team;
        private System.String teamdtl;
        private System.String schoolname;
        
        private System.String titleresult;
        private System.String rgamelevelidx;

        private System.String lplayerdualresult;
        private System.String rplayerdualresult;

        private System.String teamsidonm;
        private System.String weightfailyn;        
        
                
        public PubCodes()
        {
        
        }

        public string SportsGb { get { return sportsgb; } set { sportsgb = value; } }
        public string GameTitleIDX { get { return gametitleidx; } set { gametitleidx = value; } }
        public string TeamGb { get { return teamgb; } set { teamgb = value; } }
        public string Sex { get { return sex; } set { sex = value; } }
        public string Level { get { return level; } set { level = value; } }
        public string GroupGameGb { get { return groupgamegb; } set { groupgamegb = value; } }
        public string TotRound { get { return totround; } set { totround = value; } }
        public string GameDay { get { return gameday; } set { gameday = value; } }
        public string GameTime { get { return gametime; } set { gametime = value; } }

        public string UserName { get { return username; } set { username = value; } }
        public string UserIDX { get { return useridx; } set { useridx = value; } }
        
        public string PlayerNum { get { return playernum; } set { playernum = value; } }
        public string UnearnWin { get { return unearnwin; } set { unearnwin = value; } }
        public string LeftRightGb { get { return leftrightgb; } set { leftrightgb = value; } }
        public string Team { get { return team; } set { team = value; } }
        public string TeamDtl { get { return teamdtl; } set { teamdtl = value; } }
        public string SchoolName { get { return schoolname; } set { schoolname = value; } }

        public string TitleResult { get { return titleresult; } set { titleresult = value; } }
        public string RGameLevelidx { get { return rgamelevelidx; } set { rgamelevelidx = value; } }

        public string LPlayerDualResult { get { return lplayerdualresult; } set { lplayerdualresult = value; } }
        public string RPlayerDualResult { get { return rplayerdualresult; } set { rplayerdualresult = value; } }

        public string TeamSidoNm { get { return teamsidonm; } set { teamsidonm = value; } }
        public string WeightFailYN { get { return weightfailyn; } set { weightfailyn = value; } }
        
    }

    
    //값받는부분
    public class TrainInfo
    {
        public string SportsGb { get; set; }
        public string GameTitleIDX { get; set; }
        public string TeamGb { get; set; }
        public string Sex { get; set; }
        public string Level { get; set; }
        public string GroupGameGb { get; set; }
        public string LeftRightGb { get; set; }
        public string GameNumArray { get; set; }
        
    }    
    

    // Converts the specified JSON string to an object of type T
    public T Deserialize<T>(string context)
    {
        string jsonData = context;

        //cast to specified objectType
        var obj = (T)new JavaScriptSerializer().Deserialize<T>(jsonData);
        return obj;
    }

    public bool ChkInt(string sParam)
    {
        try
        {
            int i = int.Parse(sParam);
            return true;
        }
        catch
        {
            return false;
        }
    }

    


}