using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.IO;
using System.Drawing;
using System.Text;



/// <summary>
/// CommPage의 요약 설명입니다.
/// 
/// </summary>


public class CommPageNo : System.Web.UI.Page
{

    private void Page_Load(object sender, System.EventArgs e)
    {
        if (!IsPostBack)
        {



        }
    }




    override protected void OnInit(EventArgs e)
    {
        InitializeComponent(); base.OnInit(e);
    }
    private void InitializeComponent()
    {
        this.Load += new System.EventHandler(this.Page_Load);
    }


    protected string strDsn()
    {
        return "Data Source=115.68.7.145;Initial Catalog=sportsdiary;Integrated Security=false;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Pooling=true;Min Pool Size=5;Max Pool Size=300";

   
    }


    //그리드뷰 소트시에 불분명한 필드에 대해서 명시적으로 선언하기 위해 처리.
    protected string reSortAlias(string sortExpressionB, string alias, string columns, string sortExpression)
    {
        if (sortExpressionB == columns)
        {
            return alias + "." + sortExpression;
        }
        else
        {
            return sortExpressionB;
        }
    }





    //에러기록
    protected void ErrorLog(string LogName,string MethodName, string ErrorMsg,string txtSql, string UserID)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strMethodName = InjectionDefender(MethodName);
        string strErrorMsg = InjectionDefender(ErrorMsg);
        

        using (SqlConnection con = new SqlConnection(strDsn()))
        using (SqlCommand cmd = con.CreateCommand())
        {
            con.Open();
            cmd.CommandText = "Insert into tblErrorLog(LogName,MethodName,ErrorMsg,strSql,WriteID) values ( "
                        + " @LogName,@strMethodName,@strErrorMsg,@txtSql,@UserID)";

            cmd.Parameters.AddWithValue("@LogName", LogName);
            cmd.Parameters.AddWithValue("@strMethodName", strMethodName);
            cmd.Parameters.AddWithValue("@strErrorMsg", strErrorMsg);
            cmd.Parameters.AddWithValue("@txtSql", txtSql);
            cmd.Parameters.AddWithValue("@UserID", UserID);

            cmd.ExecuteNonQuery();
            con.Close();

            string alertMsg = "오류가 발생하였습니다. 오류 페이지 " + LogName + " 오류 메소드 " + MethodName;
            string str = "<script>alert('" + alertMsg + "');</script>";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "done", str);

        }
        

    }
    


    //listbox multi check
    protected string setListBox(string strColumns, ListBox lbControl)
    {

        //multiselect value check
        string string1 = "and " + strColumns + " in (";
        string string2 = "";
        string string3 = ")";
        foreach (ListItem item in lbControl.Items)
        {
            if (item.Selected)
            {
                string2 += "'" + item.Value + "',";
            }
        }

        string WheresrSpecialCode = "";
        if (string2 != "")
        {
            string2 = string2.ToString().Substring(0, string2.Length - 1);
            WheresrSpecialCode = string1 + string2 + string3;
        }
        //multiselect value check
        return WheresrSpecialCode;
    }


    //공통공통코드
    protected void drPubCode(DropDownList Success, string ppubcode)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strSql = "Select * from tblPubCode Where PpubCode='" + ppubcode + "' and DelGubun='N' Order By SortOrder";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = DsCom.ExecuteReader();

        Success.DataTextField = "PubName";
        Success.DataValueField = "PubCode";
        Success.DataSource = reader;
        Success.DataBind();

        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();

    }

    //공통공통코드
    protected void drPubValue(DropDownList Success, string ppubcode)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strSql = "Select * from tblPubCode Where PpubCode='" + ppubcode + "' and DelGubun='N' Order By SortOrder";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = DsCom.ExecuteReader();

        Success.DataTextField = "PubName";
        Success.DataValueField = "PubValue";
        Success.DataSource = reader;
        Success.DataBind();
        Success.SelectedValue = "100";
        
        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();

    }

    //공통공통코드(선택)
    protected void drSelPubCode(DropDownList Success, string ppubcode, string PubValue)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strSql = "Select * from tblPubCode Where PpubCode='" + ppubcode + "' and DelGubun='N' Order By SortOrder";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = DsCom.ExecuteReader();

        Success.DataTextField = "PubName";
        Success.DataValueField = "PubCode";
        Success.DataSource = reader;
        Success.DataBind();
        Success.SelectedValue = PubValue;

        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();

    }




    protected void lbPubCode(ListBox Success, string ppubcode)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strSql = "Select * from tblPubCode Where PpubCode='" + ppubcode + "' and DelGubun='N' Order By SortOrder";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = DsCom.ExecuteReader();

        Success.DataTextField = "PubName";
        Success.DataValueField = "PubCode";
        Success.DataSource = reader;
        Success.DataBind();

        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();

    }


    //리스트 그룹1
    protected void drPubGrp1(DropDownList drDropDown)
    {
        SqlConnection DbCon = new SqlConnection(strDsn());

        string strSql = "Select * from tblGrp1 Where DelGubun='N' Order By GrpName1 asc";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = DsCom.ExecuteReader();

        drDropDown.DataTextField = "GrpName1";
        drDropDown.DataValueField = "Grp1";
        drDropDown.DataSource = reader;
        drDropDown.DataBind();

        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();
    
    }



    //오늘날짜(기본)
    protected void getNowDate(TextBox start,TextBox end,int diffdate)
    {
        string sYear = DateTime.Now.Year.ToString();
        string sMon = DateTime.Now.Month.ToString();
        string sDay = DateTime.Now.Day.ToString();

        string qMon = (sMon.Length == 1) ? "0" + sMon : sMon;
        string qDay = (sDay.Length == 1) ? "0" + sDay : sDay;

        DateTime addNow = DateTime.Now.AddDays(diffdate);

        string addYear = addNow.Year.ToString();
        string addMon = addNow.Month.ToString();
        string addDay = addNow.Day.ToString();

        string addqMon = (addMon.Length == 1) ? "0" + addMon : addMon;
        string addqDay = (addDay.Length == 1) ? "0" + addDay : addDay;

        start.Text = addYear + "-" + addqMon + "-" + addqDay;
        end.Text = sYear + "-" + qMon + "-" + qDay;
    }







    //년-월-일
    protected void getNowDate(TextBox getSdate)
    {
        string sYear = DateTime.Now.Year.ToString();
        string sMon = DateTime.Now.Month.ToString();
        string sDay = DateTime.Now.Day.ToString();

        string qMon = (sMon.Length == 1) ? "0" + sMon : sMon;
        string qDay = (sDay.Length == 1) ? "0" + sDay : sDay;
        getSdate.Text = sYear + "-" + qMon + "-" + qDay;
    }


    //년-월-일
    protected string getNowDateYear()
    {
        string sYear = DateTime.Now.Year.ToString();
        string sMon = DateTime.Now.Month.ToString();
        string sDay = DateTime.Now.Day.ToString();
        return sYear + "년 " + sMon + "월 " + sDay + "일";
    }

    //년-월-일-시(시작)
    protected void getNowDateHourStart(TextBox getSdate)
    {
        string sYear = DateTime.Now.Year.ToString();
        string sMon = DateTime.Now.Month.ToString();
        string sDay = DateTime.Now.Day.ToString();

        string qMon = (sMon.Length == 1) ? "0" + sMon : sMon;
        string qDay = (sDay.Length == 1) ? "0" + sDay : sDay;
        getSdate.Text = sYear + "-" + qMon + "-" + qDay + "-09";
    }

    //년-월-일-시(종료)
    protected void getNowDateHourEnd(TextBox getSdate)
    {
        string sYear = DateTime.Now.Year.ToString();
        string sMon = DateTime.Now.Month.ToString();
        string sDay = DateTime.Now.Day.ToString();

        string qMon = (sMon.Length == 1) ? "0" + sMon : sMon;
        string qDay = (sDay.Length == 1) ? "0" + sDay : sDay;
        getSdate.Text = sYear + "-" + qMon + "-" + qDay + "-17";
    }

    //년-월-일
    protected string getDateDateTime(string getdatestring)
    {
        if (getdatestring != "")
        {

            string sYear = getdatestring.Substring(0, 4);
            string sMon = getdatestring.Substring(4, 2);
            string sDay = getdatestring.Substring(6, 2);
            return sYear + "년 " + sMon + "월 " + sDay + "일";
        }
        else
        {
            return "";
        }
    }




    //인젝션방어를 위한 문자열변환
    protected string InjectionDefender(string getString)
    {
        getString = getString.Replace("'", "");
        getString = getString.Replace("declare", "");
        getString = getString.Replace("@variable ", "");
        getString = getString.Replace("@@variable ", "");
        getString = getString.Replace("exec ", "");

        getString = getString.Replace("chr(39)", "");
        getString = getString.Replace("select", "");
        getString = getString.Replace("xp_", "");
        getString = getString.Replace("char", "");
        getString = getString.Replace(";", "");
        getString = getString.Replace("--", "");


        return getString;
    }

    //문자열변환하여 뿌려주기(View)
    protected string MakeBrTag(string m_str)
    {
        StringBuilder SB = new StringBuilder(m_str);
        return SB.Replace("\x0A", "<br>").ToString();
    }



    protected string returnNowDate()
    {
        SqlConnection DbCon = new SqlConnection(strDsn());
        string strSql = "Select Convert(varchar(6),Year(getdate()))+'년 '+ Convert(varchar(6),Month(getdate())) +'월 '+ Convert(varchar(6),Day(getdate())) +'일' as DateNowTime ";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = null;
        reader = DsCom.ExecuteReader();

        string rePubName = "";

        if (reader.Read())
        {
            rePubName = reader["DateNowTime"].ToString();
        }
        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();
        return rePubName;
    }


    //증명서출력시 우측상단여백
    protected void tableSetting(Table getTable)
    {
        getTable.Rows[0].Height = int.Parse(Request["Top"].ToString());
        getTable.Rows[0].Cells[0].Width = int.Parse(Request["Left"].ToString());
    }







    //Base64
    protected string base64Encode(string data)
    {
        try
        {
            byte[] encData_byte = new byte[data.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(data);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }
        catch (Exception e)
        {
            throw new Exception("Error in base64Encode" + e.Message);
        }
    }
    public string base64Decode(string data)
    {
        try
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();

            byte[] todecode_byte = Convert.FromBase64String(data);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }
        catch (Exception e)
        {
            throw new Exception("Error in base64Decode" + e.Message);
        }
    }

    //그리드뷰소팅
    public string sortOrder
    {
        get
        {
            if (ViewState["sortOrder"].ToString() == "desc")
            {
                ViewState["sortOrder"] = "asc";
            }
            else
            {
                ViewState["sortOrder"] = "desc";
            }
            return ViewState["sortOrder"].ToString();
        }
        set
        {
            ViewState["sortOrder"] = value;
        }
    }


    //그리드뷰소팅
    public string sortOrder2
    {
        get
        {
            if (ViewState["sortOrder2"].ToString() == "desc")
            {
                ViewState["sortOrder2"] = "asc";
            }
            else
            {
                ViewState["sortOrder2"] = "desc";
            }
            return ViewState["sortOrder2"].ToString();
        }
        set
        {
            ViewState["sortOrder2"] = value;
        }
    }

    //읽기입력수정삭제에 대한 권한 체크함(클릭이벤트제어)
    protected void AuthorityReturn(string MenuName, string ExecuteGubun)
    {
        string returnValue = "N";

        if (Request.Cookies["Authority"] != null)
        {
            string AuthorityCookies = Request.Cookies["Authority"].Value;

            if (AuthorityCookies.Length > 3)
            {
                string[] MenuNameSplit = AuthorityCookies.Split(new char[] { '@' });

                for (int i = 0; i < MenuNameSplit.Length; i++)
                {
                    string[] AuthParam = MenuNameSplit[i].Split(new char[] { '^' });

                    if (AuthParam[0].ToString() == MenuName)
                    {
                        if (ExecuteGubun == "Read")
                        {
                            returnValue = AuthParam[1];
                        }
                        else if (ExecuteGubun == "Insert")
                        {
                            returnValue = AuthParam[2];
                        }
                        else if (ExecuteGubun == "Update")
                        {
                            returnValue = AuthParam[3];
                        }
                        else if (ExecuteGubun == "Delete")
                        {
                            returnValue = AuthParam[4];
                        }

                    }
                }

            }

        }

        if (returnValue != "Y")
        {
            string alertMsg = "해당 아이디는 해당기능을 사용할 권한이 없습니다.";
            string str = "<script>alert('" + alertMsg + "'); </script>";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "done", str);
            return;
        }

    }

    //읽기입력수정삭제에 대한 권한 체크함(클릭이벤트제어)
    protected void AuthorityButton(string MenuName, string ExecuteGubun, Button getButton)
    {
        string returnValue = "N";

        if (Request.Cookies["Authority"] != null)
        {
            string AuthorityCookies = HttpUtility.UrlDecode(Request.Cookies["Authority"].Value);

            if (AuthorityCookies.Length > 3)
            {
                string[] MenuNameSplit = AuthorityCookies.Split(new char[] { '@' });

                for (int i = 0; i < MenuNameSplit.Length; i++)
                {
                    string[] AuthParam = MenuNameSplit[i].Split(new char[] { '^' });

                    if (AuthParam[0].ToString() == MenuName)
                    {
                        if (ExecuteGubun == "Read")
                        {
                            returnValue = AuthParam[1];
                        }
                        else if (ExecuteGubun == "Insert")
                        {
                            returnValue = AuthParam[2];
                        }
                        else if (ExecuteGubun == "Update")
                        {
                            returnValue = AuthParam[3];
                        }
                        else if (ExecuteGubun == "Delete")
                        {
                            returnValue = AuthParam[4];
                        }

                    }
                }

            }

        }



        //사용권한에따른 버튼 제어
        if (returnValue != "N" || Request.ServerVariables["REMOTE_ADDR"] == "::1")
        {
            getButton.Enabled = true;
        }
        else
        {
            getButton.Enabled = false;
            getButton.CssClass = "btnDisable";
            getButton.ToolTip = "해당사용자는 해당 메뉴를 사용할 권한이 없습니다.";
        }


    }




    //상단에서 선택과목 또는 학생에 따라 아래 그리드에서 체크되는 상태를 색깔별로 지정하여 사용자 눈에 띄게 처리함.
    //대상으로 않잡힌 과목은 회색으로 쓴다.
    protected string strReturnString(object getSubjGubun1, object getSubjName1)
    {
        string getSubjGubun = (string)getSubjGubun1;
        string getSubjName = (string)getSubjName1;

        if (getSubjGubun == "")
        {
            return "<span style='color:#9a9a9a'>" + getSubjName + "</span>";
        }
        else
        {
            return "<span style='color:#930000'>" + getSubjName + "</span>";
        }
    }





}
