<%@ WebHandler Language="C#" Class="GGame_GGameResultList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameResultList : CommPage, IHttpHandler
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
                string strRGameLevelidx = objTraining.RGameLevelidx;
                

                                    
                //string strSportsGb = "judo";
                //string strGameTitleIDX = "9";
                //string strTeamGb = "sd011002";
                //string strSex = "WoMan";
                //string strLevel = "lv006005";
                //string strGroupGameGb = "sd040001";
                
                string andGroupGameGb = "";
                if (strGroupGameGb == "sd040001")
                {
                    //개인전(sd040001)일경우만 추가.
                    andGroupGameGb = " and A.GroupGameGb='sd040001' ";
                }
                else {
                    //개인전(sd040001)일경우만 추가.
                    andGroupGameGb = " and A.GroupGameGb='sd040002' ";                
                }

                //테이블
                //tblPubCode : 옵션모아놓은 테이블
                //tblRGameResult : 경기결과(토너먼트)

                string strSql = "";

                if (strGroupGameGb == "sd040001")
                {
                    /*
                    strSql = " Select  "
                    + " A.GameTitleIDX,A.SportsGb,A.TeamGb,A.Sex,A.[Level], "
                    + " A.GroupGameGb,A.GameNum,A.LPlayerIDX,A.RPlayerIDX, "
                    + " A.LPlayerResult, "
                    + " IsNull(P1.PubName,'') as LPlayerResultNm, "
                    + " A.LSchIDX,A.RSchIDX,A.GameDay, "
                    + " A.LPlayerNum,A.RPlayerNum,A.LPlayerName,A.RPlayerName, "
                    + " A.LJumsu,A.RJumsu, "
                    + " A.RPlayerResult, "
                    + " IsNull(P2.PubName,'') as RPlayerResultNm, "
                    + " A.GroupGameNum, "
                    + " A.ChiefSign,A.AssChiefSign1,A.[Round],A.AssChiefSign2 "
                    + " From tblRGameResult A "
                    + " Left Outer Join tblPubCode P1 On A.SportsGb=P1.SportsGb and A.LPlayerResult=P1.PubCode "
                    + " Left Outer Join tblPubCode P2 On A.SportsGb=P2.SportsGb and A.RPlayerResult=P2.PubCode "
                    + " Where A.SportsGb='" + strSportsGb + "'  " //judo : 유도
                    + " and A.GameTitleIDX='" + strGameTitleIDX + "' " //대회IDX 
                    + " and A.TeamGb='" + strTeamGb + "' " //학교구분
                    + " and A.Level='" + strLevel + "' " //체급
                    + " and A.Sex='" + strSex + "' " //성별
                    + " and A.GroupGameGb='sd040001' "
                    + " Order by GameNum asc ";
                    */

                    strSql = " Select  "
                    + " A.GameTitleIDX,A.SportsGb,A.TeamGb,A.Sex,A.[Level], "
                    + " A.GroupGameGb,A.GameNum,A.LPlayerIDX,A.RPlayerIDX, "
                    + " A.LPlayerResult, "
                    + " IsNull(Sportsdiary.dbo.FN_PubName(A.LPlayerResult),'') as LPlayerResultNm, "
                    + " A.LTeam, A.RTeam, A.LTeamDtl, A.RTeamDtl, A.GameDay, "
                    + " A.LPlayerNum,A.RPlayerNum,A.LPlayerName,A.RPlayerName, "
                    + " A.LJumsu,A.RJumsu, "
                    + " A.RPlayerResult, "
                    + " IsNull(Sportsdiary.dbo.FN_PubName(A.RPlayerResult),'') as RPlayerResultNm, "
                    + " A.GroupGameNum, "
                    + " A.ChiefSign,A.AssChiefSign1,A.[Round],A.AssChiefSign2, "
                    + " SportsDiary.Dbo.FN_MediaLink(A.RGameLevelidx, A.GroupGameNum, A.GameNum) AS MediaLink"
                    + " From tblRGameResult A "
                    + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                    + " AND A.DelYN = 'N'"
                    + " Order by GameNum asc ";                    
                }
                else
                {
                    /*
                    strSql = " SELECT "
                    + " A.GameTitleIDX,A.SportsGb,A.TeamGb,A.Sex,A.[Level], "
                    + " A.GroupGameGb,C.GameNum,C.LSchIDX AS LPlayerIDX, C.RSchIDX AS RPlayerIDX, "
                    + " C.LResult AS LPlayerResult, "
                    + " IsNull(P1.PubName,'') as LPlayerResultNm, "
                    + " C.LSchIDX, C.RSchIDX, A.GameDay, "
                    + " '' AS LPlayerNum, '' AS RPlayerNum, SC1.SchoolName AS LPlayerName, SC2.SchoolName AS RPlayerName, "
                    + " '' AS LJumsu,'' AS RJumsu, "
                    + " C.RResult AS RPlayerResult, "
                    + " IsNull(P2.PubName,'') as RPlayerResultNm, "
                    + " C.GroupGameNum, "
                    + " C.ChiefSign,C.AssChiefSign1,C.[Round],C.AssChiefSign2 "
                    + " FROM tblRGameLevel A"
                    + " INNER Join tblrgamegroup C ON C.GameTitleIDX = A.GameTitleIDX AND C.SportsGb = A.SportsGb AND C.TeamGb = A.TeamGb AND C.Sex = A.Sex"
                    + " LEFT Join tblPubCode P1 On A.SportsGb=P1.SportsGb and C.LResult=P1.PubCode"
                    + " LEFT Join tblPubCode P2 On A.SportsGb=P2.SportsGb and C.RResult=P2.PubCode"
                    + " LEFT Join tblSchoolList SC1 On SC1.SchIDX = C.LSchIDX"
                    + " LEFT Join tblSchoolList SC2 On SC2.SchIDX = C.RSchIDX"
                    + " WHERE A.SportsGb='" + strSportsGb + "'"
                    + " AND A.GameTitleIDX='" + strGameTitleIDX + "'"
                    + " AND A.TeamGb='" + strTeamGb + "' "
                    + " AND A.Sex='" + strSex + "'  "
                    + " AND A.GroupGameGb='sd040002'";
                    */
                    strSql = " SELECT "
                    + " A.GameTitleIDX,A.SportsGb,A.TeamGb,A.Sex,A.[Level], "
                    + " A.GroupGameGb,C.GameNum ,C.LTeam AS LPlayerIDX, C.RTeam AS RPlayerIDX, "
                    + " C.LResult AS LPlayerResult, "
                    + " IsNull(Sportsdiary.dbo.FN_PubName(C.LResult),'') as LPlayerResultNm, "
                    + " C.LTeam, C.RTeam, C.LTeamDtl, C.RTeamDtl, A.GameDay, "
                    + " '' AS LPlayerNum, '' AS RPlayerNum, SportsDiary.dbo.FN_TeamNm(C.SportsGb, C.TeamGb, C.LTeam) AS LPlayerName, SportsDiary.dbo.FN_TeamNm(C.SportsGb, C.TeamGb, C.RTeam) AS RPlayerName, "
                    + " '' AS LJumsu,'' AS RJumsu, "
                    + " C.RResult AS RPlayerResult, "
                    + " IsNull(Sportsdiary.dbo.FN_PubName(C.RResult),'') as RPlayerResultNm, "
                    + " C.GroupGameNum, "
                    + " C.ChiefSign,C.AssChiefSign1,C.[Round],C.AssChiefSign2, "
                    + " SportsDiary.Dbo.FN_MediaLink(C.RGameLevelidx, C.GroupGameNum, '0') AS MediaLink"
                    + " FROM tblRGameLevel A"
                    + " INNER Join tblrgamegroup C ON C.RGameLevelidx = A.RGameLevelidx"
                    + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                    + " AND A.DelYN = 'N'"
                    + " AND C.DelYN = 'N'";

                }
                

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    PubCodes PubCodeItem = new PubCodes();

                    PubCodeItem.GameTitleIDX = reader["GameTitleIDX"].ToString();
                    PubCodeItem.SportsGb = reader["SportsGb"].ToString();
                    PubCodeItem.TeamGb = reader["TeamGb"].ToString();
                    PubCodeItem.Sex = reader["Sex"].ToString();
                    PubCodeItem.Level = reader["Level"].ToString();
                    PubCodeItem.GroupGameGb = reader["GroupGameGb"].ToString();
                    PubCodeItem.GameNum = reader["GameNum"].ToString();
                    PubCodeItem.LPlayerIDX = reader["LPlayerIDX"].ToString();
                    PubCodeItem.RPlayerIDX = reader["RPlayerIDX"].ToString();

                    PubCodeItem.LPlayerResult = reader["LPlayerResult"].ToString();
                    PubCodeItem.LPlayerResultNm = reader["LPlayerResultNm"].ToString();
                    PubCodeItem.LTeam = reader["LTeam"].ToString();
                    PubCodeItem.LTeamDtl = reader["LTeamDtl"].ToString();
                    PubCodeItem.RTeam = reader["RTeam"].ToString();
                    PubCodeItem.RTeamDtl = reader["RTeamDtl"].ToString();                    
                    PubCodeItem.GameDay = reader["GameDay"].ToString();

                    PubCodeItem.LPlayerNum = reader["LPlayerNum"].ToString();
                    PubCodeItem.RPlayerNum = reader["RPlayerNum"].ToString();

                    PubCodeItem.LPlayerName = reader["LPlayerName"].ToString();
                    PubCodeItem.RPlayerName = reader["RPlayerName"].ToString();
                    PubCodeItem.LJumsu = reader["LJumsu"].ToString();
                    PubCodeItem.RJumsu = reader["RJumsu"].ToString();
                    PubCodeItem.RPlayerResult = reader["RPlayerResult"].ToString();
                    PubCodeItem.RPlayerResultNm = reader["RPlayerResultNm"].ToString();
                    PubCodeItem.GroupGameNum = reader["GroupGameNum"].ToString();
                    PubCodeItem.ChiefSign = reader["ChiefSign"].ToString();
                    PubCodeItem.AssChiefSign1 = reader["AssChiefSign1"].ToString();
                    PubCodeItem.Round = reader["Round"].ToString();
                    PubCodeItem.AssChiefSign2 = reader["AssChiefSign2"].ToString();

                    PubCodeItem.MediaLink = reader["MediaLink"].ToString();
                    
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
        private System.String gamenum;
        private System.String lplayeridx;
        private System.String rplayeridx;
        private System.String lplayerresult;

        private System.String lteam;
        private System.String rteam;
        private System.String lteamdtl;
        private System.String rteamdtl;
               
        private System.String gameday;
        private System.String lplayernum;
        private System.String rplayernum;
        private System.String lplayername;
        private System.String rplayername;
        private System.String ljumsu;
        private System.String rjumsu;
        private System.String rplayerresult;
        private System.String groupgamenum;
        private System.String chiefsign;
        private System.String asschiefsign1;
        private System.String round;
        private System.String asschiefsign2;
        private System.String lplayerresultnm;
        private System.String rplayerresultnm;

        private System.String medialink;
                        
        public PubCodes()
        {
        
        }

        public string SportsGb { get { return sportsgb; } set { sportsgb = value; } }
        public string GameTitleIDX { get { return gametitleidx; } set { gametitleidx = value; } }
        public string TeamGb { get { return teamgb; } set { teamgb = value; } }
        public string Sex { get { return sex; } set { sex = value; } }
        public string Level { get { return level; } set { level = value; } }
        public string GroupGameGb { get { return groupgamegb; } set { groupgamegb = value; } }
        public string GameNum { get { return gamenum; } set { gamenum = value; } }
        public string LPlayerIDX { get { return lplayeridx; } set { lplayeridx = value; } }
        public string RPlayerIDX { get { return rplayeridx; } set { rplayeridx = value; } }
        public string LPlayerResult { get { return lplayerresult; } set { lplayerresult = value; } }

        public string LTeam { get { return lteam; } set { lteam = value; } }
        public string RTeam { get { return rteam; } set { rteam = value; } }
        public string LTeamDtl { get { return lteamdtl; } set { lteamdtl = value; } }
        public string RTeamDtl { get { return rteamdtl; } set { rteamdtl = value; } }        
        
        public string GameDay { get { return gameday; } set { gameday = value; } }
        public string LPlayerNum { get { return lplayernum; } set { lplayernum = value; } }
        public string RPlayerNum { get { return rplayernum; } set { rplayernum = value; } }
        public string LPlayerName { get { return lplayername; } set { lplayername = value; } }
        public string RPlayerName { get { return rplayername; } set { rplayername = value; } }
        public string LJumsu { get { return ljumsu; } set { ljumsu = value; } }
        public string RJumsu { get { return rjumsu; } set { rjumsu = value; } }
        public string RPlayerResult { get { return rplayerresult; } set { rplayerresult = value; } }
        public string GroupGameNum { get { return groupgamenum; } set { groupgamenum = value; } }
        public string ChiefSign { get { return chiefsign; } set { chiefsign = value; } }
        public string AssChiefSign1 { get { return asschiefsign1; } set { asschiefsign1 = value; } }
        public string Round { get { return round; } set { round = value; } }
        public string AssChiefSign2 { get { return asschiefsign2; } set { asschiefsign2 = value; } }

        public string LPlayerResultNm { get { return lplayerresultnm; } set { lplayerresultnm = value; } }
        public string RPlayerResultNm { get { return rplayerresultnm; } set { rplayerresultnm = value; } }

        public string MediaLink { get { return medialink; } set { medialink = value; } }
        
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