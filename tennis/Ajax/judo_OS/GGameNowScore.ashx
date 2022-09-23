<%@ WebHandler Language="C#" Class="GGame_GGameNowScore" %>


using System;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public class GGame_GGameNowScore : CommPage, IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";

        List<NowScore_return> list = new List<NowScore_return>();
        
        SqlConnection DbCon = new SqlConnection(strDsn());
        
        try
        {
            string strJson = new StreamReader(context.Request.InputStream).ReadToEnd();
            NowScore_get objNowScore_get = Deserialize<NowScore_get>(strJson);

            if (objNowScore_get != null)
            {
                string strRGameLevelidx = objNowScore_get.RGameLevelidx;
                string strGroupGameNum = objNowScore_get.GroupGameNum;
                string strPlayerGameNum = objNowScore_get.PlayerGameNum;

                string WHERE_GroupGameNum = "";


                string strSql = "SELECT BB.Left01 + BB.Plus_Left01 AS Left01, BB.Plus_Left02 AS Left02, BB.Left03, BB.Left04, BB.Left05, BB.Left06, BB.Left07, "
                              + " BB.Right01 + BB.Plus_Right01 AS Right01, BB.Plus_Right02 AS Right02, BB.Right03, BB.Right04, BB.Right05, BB.Right06, BB.Right07"
                              + " FROM"
                              + " ("
                              + " 	SELECT Sum(Case AA.LJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Left01, "
                              + " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Left02, "
                              + " 	Sum(Case AA.LJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Left03, "
                              + " 	Sum(Case AA.LJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Left04, "
                            + " 	Sum(Case AA.LJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Left05, "
                            + " 	Sum(Case AA.LJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Left06, "
                            + " 	Sum(Case AA.LJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Left07, "
                              + " 	Sum(Case AA.RJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Right01, "
                              + " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Right02, "
                              + " 	Sum(Case AA.RJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Right03, "
                              + " 	Sum(Case AA.RJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Right04,"
                            + " 	Sum(Case AA.RJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Right05,"
                            + " 	Sum(Case AA.RJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Right06,"
                            + " 	Sum(Case AA.RJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Right07,"
                              //2017 동트는동해 생활체육까지의 경기규칙
                              /*
                              + " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) / 2 as Plus_Left01,"
                              + " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) % 2 as Plus_Left02,"
                              + " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) / 2 as Plus_Right01,"
                              + " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) % 2 as Plus_Right02 "
                              */

                              + " 	0 as Plus_Left01,"
                              + " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Left02,"
                              + " 	0 as Plus_Right01,"
                              + " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Right02 "                              
                              + " 	FROM "
                              + " 	( "
                              + " 		SELECT COUNT(*) AS Jumsu, LJumsuGb , RJumsuGb "
                              + " 		FROM tblRGameResultDtl B "
                              + " 		LEFT JOIN ("
                              + "                  SELECT RGameLevelidx, GameNum, GroupGameNum"
                              + "                  FROM"
                              + "                  tblRGameResult WHERE DELYN = 'N'"
                              + "                 ) AS A  "
                              + " 		ON A.RGameLevelidx = B.RGameLevelidx "
                              + " 		   AND A.GameNum = B.GameNum "
                              + " 		   AND A.GroupGameNum = B.GroupGameNum "
                              + " 		WHERE B.RGameLevelidx='" + strRGameLevelidx + "' "
                              + "       AND B.GroupGameNum='" + strGroupGameNum + "'"                              
                              + " 		AND B.GameNum='" + strPlayerGameNum + "'"
                              + " 		AND B.DELYN='N'"
                              + " 		AND (LJumsuGb <> '' OR RJumsuGb <> '')"
                              + " 		GROUP BY LJumsuGb, RJumsuGb"
                              + " 	) AA"
                              + " ) AS BB";                
                
                SqlCommand DsCom = new SqlCommand(strSql, DbCon);
                DsCom.Connection.Open();
                SqlDataReader reader = null;
                reader = DsCom.ExecuteReader();

                while (reader.Read())
                {


                    NowScore_return NowScore_returnItem = new NowScore_return();

                    NowScore_returnItem.Left01 = reader["Left01"].ToString();
                    NowScore_returnItem.Left02 = reader["Left02"].ToString();
                    NowScore_returnItem.Left03 = reader["Left03"].ToString();
                    NowScore_returnItem.Left04 = reader["Left04"].ToString();
                    NowScore_returnItem.Left05 = reader["Left05"].ToString();
                    NowScore_returnItem.Left06 = reader["Left06"].ToString();
                    NowScore_returnItem.Left07 = reader["Left07"].ToString();
                    NowScore_returnItem.Right01 = reader["Right01"].ToString();
                    NowScore_returnItem.Right02 = reader["Right02"].ToString();
                    NowScore_returnItem.Right03 = reader["Right03"].ToString();
                    NowScore_returnItem.Right04 = reader["Right04"].ToString();
                    NowScore_returnItem.Right05 = reader["Right05"].ToString();
                    NowScore_returnItem.Right06 = reader["Right06"].ToString();
                    NowScore_returnItem.Right07 = reader["Right07"].ToString();
                    list.Add(NowScore_returnItem);

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
 

    public class NowScore_return
    {

        private System.String left01;
        private System.String left02;
        private System.String left03;
        private System.String left04;
        private System.String left05;
        private System.String left06;
        private System.String left07;                        
        private System.String right01;
        private System.String right02;
        private System.String right03;
        private System.String right04;
        private System.String right05;
        private System.String right06;
        private System.String right07;        
        
        public NowScore_return()
        {
        
        }

        public string Left01 { get { return left01; } set { left01 = value; } }
        public string Left02 { get { return left02; } set { left02 = value; } }
        public string Left03 { get { return left03; } set { left03 = value; } }
        public string Left04 { get { return left04; } set { left04 = value; } }
        public string Left05 { get { return left05; } set { left05 = value; } }
        public string Left06 { get { return left06; } set { left06 = value; } }
        public string Left07 { get { return left07; } set { left07 = value; } }
        public string Right01 { get { return right01; } set { right01 = value; } }
        public string Right02 { get { return right02; } set { right02 = value; } }
        public string Right03 { get { return right03; } set { right03 = value; } }
        public string Right04 { get { return right04; } set { right04 = value; } }
        public string Right05 { get { return right05; } set { right05 = value; } }
        public string Right06 { get { return right06; } set { right06 = value; } }
        public string Right07 { get { return right07; } set { right07 = value; } }
        
    }

    
    //값받는부분
    public class NowScore_get
    {
        public string RGameLevelidx { get; set; }
        public string GroupGameNum { get; set; }         
        public string PlayerGameNum { get; set; }               
        
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

