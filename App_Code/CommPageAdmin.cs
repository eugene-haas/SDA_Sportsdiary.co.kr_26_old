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
using System.Security.Cryptography;

/// <summary>
/// CommPage의 요약 설명입니다.
/// </summary>
public class CommPageAdmin : System.Web.UI.Page 
{

    private void Page_Load(object sender, System.EventArgs e) 
    {
        if (!IsPostBack)
        {

            //권한설정.
            /*
            if (Request.ServerVariables["REMOTE_ADDR"] != "::1" && Request.Cookies["UserID"] == null)
            {
                string alertMsg = "접근권한이 없습니다. 로그인 하시기 바랍니다.";
                string str = "<script>alert('" + alertMsg + "');history.back(); </script>";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "done", str);
            }
            */

        }
    }


    public static string SHA256Hash(string Data)
    {
        SHA256 sha = new SHA256Managed();
        byte[] hash = sha.ComputeHash(Encoding.ASCII.GetBytes(Data));
        StringBuilder stringBuilder = new StringBuilder();
        foreach (byte b in hash)
        {
            stringBuilder.AppendFormat("{0:x2}", b);
        }
        return stringBuilder.ToString();
    } 

    //인젝션방어를 위한 문자열변환
    protected string InjectionDefender(string getString)
    {
        getString = getString.Replace("'", "''");
        getString = getString.Replace("declare", "");
        getString = getString.Replace("@variable ", "");
        getString = getString.Replace("@@variable ", "");
        getString = getString.Replace("exec ", "");

        getString = getString.Replace("chr(39)", "");
        getString = getString.Replace("select", "");
        getString = getString.Replace("xp_", "");
        getString = getString.Replace("char", "");

        return getString;
    }


    //숫자여부 체크
    protected bool numericCheck(string strNumber)
    {

        try
        {
            int iNumber = Convert.ToInt32(strNumber);
            return true;
        }
        catch
        {
            return false;
        }
    }


    protected string reUserGubun(string getUserGubun)
    {

        //사용자구분(1.개인,2.법인,3.개인사업자)
        string strUserGubun = "";
        if (getUserGubun == "1")
        {
            strUserGubun = "개인회원";
        }
        else if (getUserGubun == "2")
        {
            strUserGubun = "법인회원";
        }
        else if (getUserGubun == "3")
        {
            strUserGubun = "개인사업자";
        }

        return strUserGubun;
    }




    override protected void OnInit(EventArgs e) 
    { 
        InitializeComponent(); base.OnInit(e); 
    }
    private void InitializeComponent() 
    { 
        this.Load += new System.EventHandler(this.Page_Load); 
    }


    //protected string strDsn()
    //{
    //    return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    //}

    //protected string strAdmin()
    //{
    //    return ConfigurationManager.ConnectionStrings["ConnectionAdmin"].ConnectionString;
    //}

    protected string strDsn()
    {
        return "Data Source=db.itemcenter.co.kr;Initial Catalog=sportsdiary;Integrated Security=false;User ID=sportsdiary;Password=dnlemfkdls715)@*@;";
    }

    protected string strAdmin()
    {
        return "Data Source=db.itemcenter.co.kr;Initial Catalog=sportsdiary;Integrated Security=false;User ID=sportsdiary;Password=dnlemfkdls715)@*@;";
    }


    //gridview rowspan 처리.
    protected void RowSpanGridView(GridView gvName, int spcolumn)
    {
        int RowSpan = 1;
        for (int i = gvName.Rows.Count - 1; i > 0; i--)
        {
            if (gvName.Rows[i].Cells[spcolumn].Text == gvName.Rows[i - 1].Cells[spcolumn].Text && gvName.Rows[i].Cells[spcolumn].Text != "" && gvName.Rows[i].Cells[spcolumn].Text != "&nbsp;")
            {
                RowSpan++;
                gvName.Rows[i - 1].Cells[spcolumn].RowSpan = RowSpan;
                gvName.Rows[i].Cells[spcolumn].Visible = false;

            }
            else
            {
                RowSpan = 1;
            }
            
        }
    }


    protected void RowSpanGridView1(GridView gvName, int spcolumn, int targetcolum)
    {
        int RowSpan = 1;
        for (int i = gvName.Rows.Count - 1; i > 0; i--)
        {

            if (gvName.Rows[i].Cells[spcolumn].Text == gvName.Rows[i - 1].Cells[spcolumn].Text && gvName.Rows[i].Cells[spcolumn].Text != "")
            {
                RowSpan++;

                gvName.Rows[i - 1].Cells[targetcolum].RowSpan = RowSpan;
                gvName.Rows[i].Cells[targetcolum].Visible = false;

                //gvName.Rows[i - 1].Cells[targetcolum1].Text = RowSpan.ToString();


            }
            else
            {
                RowSpan = 1;
            }
        }
    }


    protected void RowSpanGridColor(GridView gvName, int spcolumn)
    {
        int RowSpan = 1;
        for (int i = gvName.Rows.Count - 1; i > 0; i--)
        {
            if (gvName.Rows[i].Cells[spcolumn].Text == gvName.Rows[i - 1].Cells[spcolumn].Text && gvName.Rows[i].Cells[spcolumn].Text != "" && gvName.Rows[i].Cells[spcolumn].Text != "&nbsp;")
            {
                RowSpan++;
//                gvName.Rows[i - 1].BackColor = Color.FromName("#cccccc");
//                gvName.Rows[i].BackColor = Color.FromName("#cccccc");

                gvName.Rows[i - 1].Cells[1].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i - 1].Cells[2].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i - 1].Cells[3].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i - 1].Cells[4].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i - 1].Cells[5].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i - 1].Cells[6].ForeColor = Color.FromName("#b7571e");

                gvName.Rows[i].Cells[1].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i].Cells[2].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i].Cells[3].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i].Cells[4].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i].Cells[5].ForeColor = Color.FromName("#b7571e");
                gvName.Rows[i].Cells[6].ForeColor = Color.FromName("#b7571e");


            }
            else
            {
                RowSpan = 1;
            }

        }
    }


    //공통공통코드
    protected void drPubCode(DropDownList Success, string ppubcode)
    {
        SqlConnection DbCon = new SqlConnection(strAdmin());

        string strSql = "Select * from tblPubCode Where PpubCode='" + ppubcode + "' and DelYN='N' Order By OrderBy";

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

    //공통공통코드(선택)
    protected void drSelPubCode(DropDownList Success, string ppubcode, string PubValue)
    {
        SqlConnection DbCon = new SqlConnection(strAdmin());

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


    //문자열변환하여 뿌려주기(View)
    protected string MakeBrTag(string m_str)
    {
        StringBuilder SB = new StringBuilder(m_str);
        return SB.Replace("\x0A", "<br>").ToString();
    }


    protected string returnNowDate()
    {
        SqlConnection DbCon = new SqlConnection(strAdmin());
        string strSql = "Select Convert(varchar(6),Year(getdate()))+'년 '+ Convert(varchar(6),Month(getdate())) +'월 '+ Convert(varchar(6),Day(getdate())) +'일' as DateNowTime ";

        SqlCommand DsCom = new SqlCommand(strSql, DbCon);
        DsCom.Connection.Open();
        SqlDataReader reader = null;
        reader = DsCom.ExecuteReader();

        string reCodeShortName = "";

        if (reader.Read())
        {
            reCodeShortName = reader["DateNowTime"].ToString();
        }
        reader.Close();
        DbCon.Close();
        DsCom.Connection.Close();
        return reCodeShortName;
    }



    //엑셀공통함수(시작)
    public void SaveAsExcel(DataSet dsResult, ArrayList columns, string subject, string fileName)
    {
        if (fileName.Equals(null) && fileName.Equals(""))
            fileName = DateTime.Now.ToString("yyyyMMdd") + ".xls";

        System.Web.HttpContext.Current.Response.Buffer = true;

        DataGrid dgExcel = new DataGrid();
        dgExcel.ShowHeader = true;

        dgExcel.Caption = subject;

        dgExcel.AutoGenerateColumns = false;

        foreach (object column in columns)
            dgExcel.Columns.Add((BoundColumn)column);

        dgExcel.HeaderStyle.BackColor = Color.FromName("powderblue");
        dgExcel.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        dgExcel.HeaderStyle.Height = 25;
        dgExcel.HeaderStyle.Font.Bold = true;

        dgExcel.DataSource = dsResult;
        dgExcel.DataBind();

        Response.Clear();

        Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", fileName));
        Response.ContentType = "application/unknown";
        // System.Web.HttpContext.Current.Response.ContentType = "application/vnd.ms-excel"; 

        /////////////////////////////////////////////////////////////////////////////////////////////////
        ///  한글이 깨지는 경우 web.config의 globalization을 euc-kr로 바꿔주세요.
        /// <globalization requestEncoding="euc-kr" responseEncoding="euc-kr" />
        /////////////////////////////////////////////////////////////////////////////////////////////////

        Response.Write("<meta http-equiv=Content-Type content='text/html; charset=utf-8'>");
        //System.Web.HttpContext.Current.Response.Write
        //    ("<style>br {mso-data-placement:same-cell;}</style>");

        dgExcel.EnableViewState = false;

        System.IO.StringWriter sWriter = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htmlWriter = new System.Web.UI.HtmlTextWriter(sWriter);

        dgExcel.RenderControl(htmlWriter);

        Response.Write(sWriter.ToString());

        dgExcel.Dispose();

        Response.End();

    }



    //엑셀공통함수(시작)
    public void SaveAsExcel(DataTable dsResult, ArrayList columns, string subject, string fileName)
    {
        if (fileName.Equals(null) && fileName.Equals(""))
            fileName = DateTime.Now.ToString("yyyyMMdd") + ".xls";

        System.Web.HttpContext.Current.Response.Buffer = true;

        DataGrid dgExcel = new DataGrid();
        dgExcel.ShowHeader = true;

        dgExcel.Caption = subject;

        dgExcel.AutoGenerateColumns = false;

        foreach (object column in columns)
        dgExcel.Columns.Add((BoundColumn)column);
        dgExcel.HeaderStyle.BackColor = Color.FromName("powderblue");
        dgExcel.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        dgExcel.HeaderStyle.Height = 25;
        dgExcel.HeaderStyle.Font.Bold = true;

        dgExcel.DataSource = dsResult;
        dgExcel.DataBind();

        System.Web.HttpContext.Current.Response.AddHeader
            ("Content-Disposition", string.Format("attachment;filename={0}", fileName));
        System.Web.HttpContext.Current.Response.ContentType = "application/unknown";
        // System.Web.HttpContext.Current.Response.ContentType = "application/vnd.ms-excel"; 


        /////////////////////////////////////////////////////////////////////////////////////////////////
        ///  한글이 깨지는 경우 web.config의 globalization을 euc-kr로 바꿔주세요.
        /// <globalization requestEncoding="euc-kr" responseEncoding="euc-kr" />
        /////////////////////////////////////////////////////////////////////////////////////////////////

        System.Web.HttpContext.Current.Response.Write
            ("<meta http-equiv=Content-Type content='text/html; charset=utf-8'>");
        //System.Web.HttpContext.Current.Response.Write
        //    ("<style>br {mso-data-placement:same-cell;}</style>");

        dgExcel.EnableViewState = false;

        System.IO.StringWriter sWriter = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htmlWriter = new System.Web.UI.HtmlTextWriter(sWriter);

        dgExcel.RenderControl(htmlWriter);

        System.Web.HttpContext.Current.Response.Write(sWriter.ToString());
        System.Web.HttpContext.Current.Response.End();

        dgExcel.Dispose();
    }


    public BoundColumn CreateBoundColumn(string DataFieldValue, string HeaderTextValue)
    {
        // Create a BoundColumn.
        BoundColumn column = new BoundColumn();

        // Set the properties of the BoundColumn.
        column.DataField = DataFieldValue;
        column.HeaderText = HeaderTextValue;
        return column;
    }

    public BoundColumn CreateBoundColumn(string DataFieldValue, string HeaderTextValue, string FormatValue, HorizontalAlign AlignValue)
    {
        // Create a BoundColumn using the overloaded CreateBoundColumn method.
        BoundColumn column = CreateBoundColumn(DataFieldValue, HeaderTextValue);

        // Set the properties of the BoundColumn.
        column.DataFormatString = FormatValue;
        column.ItemStyle.HorizontalAlign = AlignValue;
        return column;
    }
    //엑셀공통함수(끝)

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



        //사용권한에따른 버튼 제어
        if (returnValue != "N" || Request.ServerVariables["REMOTE_ADDR"] == "127.0.0.1")
        {
            if (ExecuteGubun == "Insert" || ExecuteGubun == "Update")
            {
                //입력일경우만 스타일 바꾸어준다.
                getButton.Enabled = true;
                getButton.CssClass = "btnStyleY";
            }
            else
            {
                getButton.Enabled = true;
                getButton.CssClass = "btnStyle";
            }
        }
        else
        {
            //getButton.Enabled = false;
            //getButton.CssClass = "btnDisable";
            //getButton.ToolTip = "해당사용자는 해당 기능을 사용할 권한이 없습니다.";
            getButton.Visible = false;

        }


    }








    //대상으로 않잡힌 항목은 회색으로 쓴다.
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

    //listbox multi check
    protected string setListBox1(string strColumns, ListBox lbControl)
    {

        //multiselect value check
        string string1 = "and (";
        string string2 = "";
        string string3 = ")";
        foreach (ListItem item in lbControl.Items)
        {
            if (item.Selected)
            {
                string2 += strColumns + " like '%" + item.Value + "%' or ";
            }
        }

        string WheresrSpecialCode = "";
        if (string2 != "")
        {
            string2 = string2.ToString().Substring(0, string2.Length - 3);
            WheresrSpecialCode = string2;
            WheresrSpecialCode = string1 + string2 + string3;
            return WheresrSpecialCode;
        }
        else
        {
            return "";
        }
    }

    protected string setListBox2(string strColumns, ListBox lbControl)
    {

        //multiselect value check
        string string1 = "and (";
        string string2 = "";
        string string3 = ")";
        foreach (ListItem item in lbControl.Items)
        {
            if (item.Selected)
            {
                string2 += strColumns + " like '%" + item.Value + "' or ";
            }
        }

        string WheresrSpecialCode = "";
        if (string2 != "")
        {
            string2 = string2.ToString().Substring(0, string2.Length - 3);
            WheresrSpecialCode = string2;
            WheresrSpecialCode = string1 + string2 + string3;
            return WheresrSpecialCode;
        }
        else
        {
            return "";
        }
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




} 
