<!--#include virtual="/pub/header.error.asp"-->
<%
'  Option Explicit

  Const lngMaxFormBytes = 200

  Dim objASPError, blnErrorWritten, strServername, strServerIP, strRemoteIP
  Dim strMethod, lngPos, datNow, strQueryString, strURL

  If Response.Buffer Then
    Response.Clear
    Response.Status = "500 Internal Server Error"
    Response.ContentType = "text/html"
    Response.Expires = 0
  End If

  Set objASPError = Server.GetLastError

  		Response.CharSet="utf-8"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=utf-8"
		'ks_c_5601-1987
%>

<!--#include virtual="/pub/fn/report_500_error.asp"-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML><HEAD><TITLE>페이지를 표시할 수 없습니다.</TITLE>
<META HTTP-EQUIV="Content-Type" Content="text/html; charset=utf-8">
<STYLE type="text/css">
  BODY { font: 8pt/12pt verdana }
  H1 { font: 13pt/15pt verdana }
  H2 { font: 8pt/12pt verdana }
  A:link { color: red }
  A:visited { color: maroon }
</STYLE>
</HEAD><BODY><TABLE width=500 border=0 cellspacing=10><TR><TD>

<h1>페이지를 표시할 수 없습니다.</h1>
연결하려는 페이지에 문제가 있어 페이지를 표시할 수 없습니다.
<hr>
<p>다음을 시도하십시오.</p>
<ul>
<li>웹 사이트 관리자에게 연락하여 이 URL 주소에서 오류가 발생했음을 알리십시오.</li>
</ul>
<hr>
<ul>
<%
  Dim bakCodepage
  on error resume next
	bakCodepage = Session.Codepage
	Session.Codepage = 1252
  on error goto 0

  'Call TraceSysInfo(Request)
  Dim site_code
  site_code = "100"
  Call TraceErrorInfo(Request, objASPError , site_code)

%>

</TD></TR></TABLE></BODY></HTML>