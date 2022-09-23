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
using System.Text;
using System.Security.Cryptography;


/// <summary>
/// CommPage의 요약 설명입니다.
/// </summary>
public class CommPageBoard : System.Web.UI.Page 
{

    private void Page_Load(object sender, System.EventArgs e) 
    {
        if (!IsPostBack)
        {
            //권한설정.

            //if (Request.ServerVariables["REMOTE_ADDR"] != "127.0.0.1" && Request.Cookies["UserID"] == null && Response.Cookies["CAFE"]["StudNo"] == null)
            //{
            //    string alertMsg = "접근권한이 없습니다. 확인하시기 바랍니다.";
            //    string str = "<script>alert('" + alertMsg + "');history.back(); </script>";
            //    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "done", str);
            //}

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


    //인젝션방어를 위한 문자열변환
    public string InjectionDefender(string getString)
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
        getString = getString.Replace(";", "");


        return getString;
    }



    //문자열변환하여 뿌려주기(View)
    protected string MakeBrTag(string m_str)
    {
        StringBuilder SB = new StringBuilder(m_str);
        return SB.Replace("\x0A", "<br/>").ToString();
    }

    protected string MakeBrTagObject(object m_str)
    {
        string strm_str = (string)m_str;
        StringBuilder SB = new StringBuilder(strm_str);
        return SB.Replace("\x0A", "<br/>").ToString();
    }


    public string strDsn()
    {
        return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    }

    protected string strAdmin()
    {
        return ConfigurationManager.ConnectionStrings["ConnectionAdmin"].ConnectionString;
    }



    //게시판 파일다운로드 1기가까지 받을수 있도록 버퍼링 늘리기.
    protected void DataDownloadFile(string strFilePath)
    {

        System.IO.Stream iStream = null;

        // Buffer to read 10K bytes in chunk:
        byte[] buffer = new Byte[10000];

        // Length of the file:
        int length;

        // Total bytes to read:
        long dataToRead;

        // Identify the file to download including its path.
        string filepath = strFilePath;

        // Identify the file name.
        string filename = System.IO.Path.GetFileName(filepath);

        try
        {
            // Open the file.
            iStream = new System.IO.FileStream(filepath, System.IO.FileMode.Open,
                        System.IO.FileAccess.Read, System.IO.FileShare.Read);


            // Total bytes to read:
            dataToRead = iStream.Length;

            Response.ContentType = "multipart/form-data";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlPathEncode(filename));

            // Read the bytes.
            while (dataToRead > 0)
            {
                // Verify that the client is connected.
                if (Response.IsClientConnected)
                {
                    // Read the data in buffer.
                    length = iStream.Read(buffer, 0, 10000);

                    // Write the data to the current output stream.
                    Response.OutputStream.Write(buffer, 0, length);

                    // Flush the data to the HTML output.
                    Response.Flush();

                    buffer = new Byte[10000];
                    dataToRead = dataToRead - length;
                }
                else
                {
                    //prevent infinite loop if user disconnects
                    dataToRead = -1;
                }
            }
        }
        catch (Exception ex)
        {
            // Trap the error, if any.
            Response.Write("Error : " + ex.Message);
        }
        finally
        {
            if (iStream != null)
            {
                //Close the file.
                iStream.Close();
            }
            Response.Close();
        }

    }



    //레프트메뉴구분(교수,학생)
    protected void setLeftMenuCookies(Panel getPanel1, Panel getPanel2)
    {

        if (Request.Cookies["Gubun"] != null)
        {

            if (HttpUtility.UrlDecode(Request.Cookies["Gubun"].Value) == "교수")
            {
                getPanel1.Visible = true;      //교수
                getPanel2.Visible = false;       //학생
            }
            else
            {
                getPanel1.Visible = false;
                getPanel2.Visible = true;

            }
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


        // || Request.ServerVariables["REMOTE_ADDR"] == "127.0.0.1"
        //사용권한에따른 버튼 제어
        if (returnValue != "N")
        {
            if (ExecuteGubun == "Insert")
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
            getButton.Enabled = false;
            getButton.CssClass = "btnDisable";
            getButton.ToolTip = "해당사용자는 해당 메뉴를 사용할 권한이 없습니다.";
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





    override protected void OnInit(EventArgs e) 
    { 
        InitializeComponent(); base.OnInit(e); 
    } 
    private void InitializeComponent() 
    { 
        this.Load += new System.EventHandler(this.Page_Load); 
    }




} 
