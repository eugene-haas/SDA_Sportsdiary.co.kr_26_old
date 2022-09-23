<%@ WebHandler Language="C#" Class="GGameSearchList_NationalLoser" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

public class GGameSearchList_NationalLoser : CommPage, IHttpHandler 
{


    public void ProcessRequest(HttpContext context)
    {

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
                string strGameType = objTraining.GameType;
                


                //string strSportsGb = "judo";
                //string strGameTitleIDX = "21";
                //string strTeamGb = "sd011002";
                //string strSex = "WoMan";
                //string strLevel = "lv006005";
                //string strGroupGameGb = "sd040001"; 
                string strSql = "";
                string strWHERESql = "";
                string strORDERSql = "";
                /*
                패자부활전
                
                */
                if (strGameType == "sd043005")
                {
                    if (strLeftRightGb == "sd030001")
                    {
                        strWHERESql = " AND ("
                            + " 	 (B.Game4R = '8' OR B.Game4R = '9') OR "
                            + " 	 (B.Game5R = '8' OR B.Game5R = '9') OR "
                            + " 	 (B.Game6R = '8' OR B.Game6R = '9') OR "
                            + " 	 (B.Game7R = '8' OR B.Game7R = '9') OR "
                            + " 	 (B.Game8R = '8' OR B.Game8R = '9') OR "
                            + " 	 (B.Game9R = '8' OR B.Game9R = '9') OR "
                            + " 	 (B.Game10R = '8' OR B.Game10R = '9') OR "
                            + " 	 (B.Game11R = '8' OR B.Game11R = '9') OR "
                            + " 	 (B.Game12R = '8' OR B.Game12R = '9') "
                            + " 	) ";
                    }
                    else if (strLeftRightGb == "sd030002")
                    {
                        strWHERESql = " AND ("
                            + " 	 (B.Game4R = '11' ) OR "
                            + " 	 (B.Game5R = '11' ) OR "
                            + " 	 (B.Game6R = '11' ) OR "
                            + " 	 (B.Game7R = '11' ) OR "
                            + " 	 (B.Game8R = '11' ) OR "
                            + " 	 (B.Game9R = '11' ) OR "
                            + " 	 (B.Game10R = '11' ) OR "
                            + " 	 (B.Game11R = '11' ) OR "
                            + " 	 (B.Game12R = '11' ) "
                            + " 	) ";

                    }
                    else
                    {
                        strWHERESql = " AND ("
                            + " 	 (B.Game4R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game5R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game6R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game7R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game8R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game9R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game10R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game11R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game12R = '" + strGameNumArray + "' ) "
                            + " 	) ";

                    }
                    
                    if (strGameNumArray == "13")
                    {
                        strORDERSql = " ORDER BY B.Game6R ASC";
                    }
                    else if (strGameNumArray == "14" || strGameNumArray == "15")
                    {
                        strORDERSql = " ORDER BY B.Game7R ASC";
                    }                        
                    else{
                        strORDERSql = " ORDER BY LeftRightGb,PlayerNum ASC ";         
                    }                    
                }
                else if (strGameType == "sd043006")
                {
                    strWHERESql = " AND ("
                        + " 	 (B.Game1R = '4' ) OR "
                        + " 	 (B.Game2R = '4' ) OR "
                        + " 	 (B.Game3R = '4' ) OR "
                        + " 	 (B.Game4R = '4' ) OR "
                        + " 	 (B.Game5R = '4' ) OR "
                        + " 	 (B.Game6R = '4' ) OR "
                        + " 	 (B.Game7R = '4' ) OR "
                        + " 	 (B.Game8R = '4' ) OR "
                        + " 	 (B.Game9R = '4' ) OR "
                        + " 	 (B.Game10R = '4' ) OR "
                        + " 	 (B.Game11R = '4' ) OR "
                        + " 	 (B.Game12R = '4' ) "
                        + " 	) ";
                    
                    strORDERSql = " ORDER BY LeftRightGb,PlayerNum ASC ";         
                }
                else if (strGameType == "sd043004")
                {
                        strWHERESql = " AND ("
                            + " 	 (B.Game1R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game2R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game3R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game4R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game5R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game6R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game7R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game8R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game9R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game10R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game11R = '" + strGameNumArray + "' ) OR "
                            + " 	 (B.Game12R = '" + strGameNumArray + "' ) "
                            + " 	) ";

                        strORDERSql = " ORDER BY LeftRightGb,PlayerNum ASC ";           
                }

                if (strGroupGameGb == "sd040001")
                {


                    /*토너먼트 오른쪽(sd030002)은 강제로 부전승처리(sd042002) */
                    strSql = " SELECT"
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " CASE WHEN nojoinChangeYN = 'Y' AND B.Sex = 'Man' THEN '1496' WHEN nojoinChangeYN = 'Y' AND B.Sex = 'WoMan' THEN '1497' ELSE B.PlayerIDX END AS UserIDX,"
                    + " CASE WHEN nojoinChangeYN = 'Y' THEN '22369' ELSE B.Team END AS Team, "
                    + " CASE WHEN nojoinChangeYN = 'Y' THEN '불참학교' ELSE B.TeamDtl END AS TeamDtl,"
                    + " CASE WHEN nojoinChangeYN = 'Y' THEN '불참자' ELSE B.UserName END AS UserName, "
                    + " B.PlayerNum AS UserNum,"
                    + " CASE WHEN '" + strLeftRightGb + "' = 'sd030002' THEN 'sd042002' ELSE B.UnearnWin END AS UnearnWin,"
                    + " B.LeftRightGb,"
                    + " CASE WHEN nojoinChangeYN = 'Y' THEN '' ELSE Sportsdiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) END AS SchoolName,"
                    + " '0' AS PlayerCnt,"
                    + " TitleResult, A.RGameLevelidx, E.LPlayerResult AS LPlayerDualResult, E.RPlayerResult AS RPlayerDualResult, SportsDiary.dbo.FN_TeamSidoNm(' + strSportsGb + ',Team) AS TeamSidoNm,"
                    + " B.WeightFailYN"
                    + " From tblRGameLevel A "
                    + " LEFT OUTER JOIN tblRPlayer B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " LEFT OUTER JOIN ("
                    + "                 SELECT TOP 1 TitleResult, RGameLevelidx, PlayerIDX"
                    + "                 FROM tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.RGameLevelidx=A.RGameLevelidx AND D.PlayerIDX = B.PlayerIDX"
                    + " "
                    + " LEFT OUTER JOIN ("
                    + "                SELECT LPlayerResult, RPlayerResult, RGameLevelidx, LPlayerIDX, RPlayerIDX"
                    + "                FROM tblRGameResult"
                    + "                WHERE DelYN = 'N'"
                    + "                AND (LPlayerResult <> '' AND RPlayerResult <> '')"
                    + " "
                    + "                AND (LPlayerResult = 'sd019021' OR RPlayerResult = 'sd019021')"
                    + " "
                    + "                AND ROUND = '01'"
                    + "                ) E ON E.RGameLevelidx=A.RGameLevelidx AND (E.LPlayerIDX = B.PlayerIDX OR E.RPlayerIDX = B.PlayerIDX) "
                    + " "
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "' "
                    + " AND A.TeamGb ='" + strTeamGb + "' "
                    + " AND A.Level='" + strLevel + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND A.GroupGameGb='sd040001'"
                    + " AND A.DelYN='N'"
                    + " AND (B.DelYN='N' OR B.DelYN IS NULL)"
                    + strWHERESql
                    + strORDERSql;


                }
                if (strGroupGameGb == "sd040002")
                {

                    strSql = " SELECT"
                    + " A.SportsGb,A.GameTitleIDX,A.TeamGb, "
                    + " A.Sex,A.Level,A.GroupGameGb, "
                    + " A.TotRound,A.GameDay,A.GameTime, "
                    + " A.WriteDate,A.EditDate, "
                    + " '' AS UserIDX,"
                    + " CASE WHEN B.nojoinChangeYN = 'Y' THEN '22369' ELSE B.Team END AS Team, "
                    + " CASE WHEN B.nojoinChangeYN = 'Y' THEN '불참학교' ELSE B.TeamDtl END AS TeamDtl,"
                    + " '' AS UserName, "
                    + " B.SchNum AS UserNum,"
                    + " CASE WHEN '" + strLeftRightGb + "' = 'sd030002' THEN 'sd042002' ELSE B.UnearnWin END AS UnearnWin,"
                    + " B.LeftRightGb,"
                    + " CASE WHEN B.nojoinChangeYN = 'Y' THEN '' ELSE Sportsdiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) END AS SchoolName,"
                    + " '0' AS PlayerCnt,"
                    + " TitleResult, A.RGameLevelidx, E.LResult AS LPlayerDualResult, E.RResult AS RPlayerDualResult, SportsDiary.dbo.FN_TeamSidoNm(' + strSportsGb + ',B.Team) AS TeamSidoNm,"
                    + " B.WeightFailYN"                    
                    + " From tblRGameLevel A "
                    + " LEFT OUTER JOIN tblRGameGroupSchool B ON B.RGameLevelidx = A.RGameLevelidx"
                    + " LEFT OUTER JOIN ("
                    + "                 SELECT TOP 1 TitleResult, RGameLevelidx, Team, TeamDtl"
                    + "                 FROM tblGameScore"
                    + "                 WHERE DelYN = 'N'"
                    + "                 ) D ON D.RGameLevelidx=A.RGameLevelidx AND D.Team = B.Team AND D.TeamDtl = B.TeamDtl"
                    + " "
                    + " LEFT OUTER JOIN ("
                    + "                SELECT LResult, RResult, RGameLevelidx, LTeam, LTeamDtl, RTeam, RTeamDtl"
                    + "                FROM tblRgameGroup"
                    + "                WHERE DelYN = 'N'"
                    + "                AND (LResult <> '' AND RResult <> '')"
                    + " "
                    + "                AND (LResult = 'sd019021' OR LResult = 'sd019021')"
                    + " "
                    + "                AND ROUND = '01'"
                    + "                ) E ON E.RGameLevelidx=A.RGameLevelidx AND ((E.LTeam = B.Team AND E.LTeamDtl = B.TeamDtl) OR (E.RTeam = B.Team AND E.RTeamDtl = B.TeamDtl)) "
                    + " "
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "'"
                    + " AND A.TeamGb ='" + strTeamGb + "' "
                    + " AND A.Sex='" + strSex + "' "
                    + " AND A.GroupGameGb='sd040002'"
                    + " AND A.DelYN='N'"
                    + " AND (B.DelYN='N' OR B.DelYN IS NULL)"
                    + strWHERESql;
                                        
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