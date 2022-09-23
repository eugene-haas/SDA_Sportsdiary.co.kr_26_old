<%@ WebHandler Language="C#" Class="GGame_GGameRoundList" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameRoundList : CommPage, IHttpHandler
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
                string strGroupGameGb = objRound_get.GroupGameGb;

                string strSql = "";
                
                string strFROM_Sql= "";

                //해당경기의 ROUND 구하기 (몇강인지..)

                if (strGroupGameGb == "sd040001")
                {
                    strFROM_Sql = " FROM SportsDiary.dbo.tblRGameResult A";
                }
                else {
                    strFROM_Sql = " FROM SportsDiary.dbo.tblRGameGroup A";
                }

                strSql = "SELECT [ROUND] AS strRound,"
                + "  CASE WHEN CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.ROUND))) = '2' THEN '결승' "
				+ "	 WHEN CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.ROUND))) = '4' THEN '준결승' "
                + "	 ELSE CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.ROUND))) + '강' END  AS strGameClassNum"
                + strFROM_Sql
                + " INNER JOIN SportsDiary.dbo.tblRGameLevel B ON"
                + " A.RGameLevelIdx = B.RGameLevelIdx"
                + " WHERE A.RGameLevelidx = '" + strRGameLevelidx + "'"
                + " AND A.DelYN = 'N'"
                + " AND B.DelYN = 'N'"                
                + " GROUP BY [ROUND]"
                + " ORDER BY [ROUND] DESC";

                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {

                    Round_return Round_returnItem = new Round_return();

                    Round_returnItem.strRound = reader["strRound"].ToString();
                    Round_returnItem.strGameClassNum = reader["strGameClassNum"].ToString();
                    
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

        private System.String r_strRound;
        private System.String r_strGameClassNum;

        public Round_return()
        {

        }

        public string strRound { get { return r_strRound; } set { r_strRound = value; } }
        public string strGameClassNum { get { return r_strGameClassNum; } set { r_strGameClassNum = value; } }
        

    }


    //값받는부분
    public class Round_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameGb { get; set; }

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
