<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/team_search.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서 발급 신청(기존)
    '===================================================================================================================================
	
	Check_AdminLogin()

	flag = Cint(fInject(Trim(Request.QueryString("flag"))))

	Call DBOpen2()

	If flag = 1 Then
    	search = fInject(Trim(Request("search")))

    	SQLString = "SELECT distinct(tm_kname),tm_id FROM team_d WHERE tm_kname LIKE '%" & search & "%'"
		SET rs = DBCon2.Execute(SQLString)
		count = rs.RecordCount
		If count > 20 Then
			count = 20
		End if

		If rs.EOF AND rs.BOF Then
%>

<script language=JavaScript>
<!--
	alert("검색어에대한 결과가 없습니다.\n\n다시 확인후 검색해 주세요");
	history.back();
-->
</script>

<% Else %>
<html>
<head>
<title>▒ 팀명 검색 결과 ▒</title>
<script language=JavaScript>
<!--
function checkForm(form) {
	if (form.search.value.length == 0)
	{
		alert("찾고자 하는 팀명을 입력해 주세요.");
		form.search.focus();
		return false;
	}
	return true;
}

function setAddress(tm_kname,tm_id) {
	opener.document.form.tm_kname.value = tm_kname;
	opener.document.form.tm_id.value = tm_id;
	this.close();
}
-->
</script>
<script language=JavaScript>
<!--
	//window.resizeTo(348,300);
-->
</script>
<style type="text/css">
	BODY 
	{scrollbar-face-color: #FFFFFF; scrollbar-shadow-color:#492901;
	scrollbar-highlight-color:#492901; scrollbar-3dlight-color:#FFFFFF;
	scrollbar-darkshadow-color:#FFFFFF; scrollbar-track-color:#FFFFFF;
	scrollbar-arrow-color:#492901}
</style>
</head>

<body bgcolor=F7ECAD  topmargin=0 leftmargin=0 marginwidth=0 marginheight=0>
	<form action=team_search.asp?flag=1 method=post name=form onSubmit="return checkForm(this)">
	<table width=100% border=0 cellspacing=10 cellpadding=0 bgcolor=F7ECAD>
		<tr>
			<td>
				<table border=0 cellspacing=0 cellpadding=0  background=<%=url%>/member/images/bg_zip_search.gif width=300 height=100>
					<tr height=40><td colspan=2></td></tr>
					<tr>
						<td width=80></td>
						<td>
							<input class=mailing type=text name=search  size=15 maxlength=15 style="border-width:1; border-color:BBBBBB; border-style:solid;IME-MODE: active;">&nbsp;
							<input type=image src=/images/b_search.gif border=0 align=absmiddle>
						</td>
					</tr>
					<tr>
						<td></td>
						<td class=dong>(예) (주)대교 눈높이,삼성전기(주)</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> 
			<td class=mailing> 
				<font color=492901>☞ 찾으신 경우 아래에서 해당 팀명를 클릭하세요.</font>
			</td>
		 </tr>
		<% 
		Do While Not rs.EOF 
				tm_kname = Trim(rs("tm_kname"))
				tm_id		 = rs("tm_id")
		%>
		<tr>
			<td class=mailing>
				&nbsp;&nbsp;<a href="JavaScript:setAddress('<%=tm_kname %>',<%=tm_id%>)" class=mailing><%=tm_kname %></a>
			</td>
		</tr>
		<% 
			rs.MoveNext 
		Loop
		%>
	</table>
	</form>
</body>
</html>
<%
	rs.close
	Set rs = nothing
  	End if
Else
%>
<html>
<head>
<title>▒ 팀명 검색 결과 ▒</title>
<link rel=stylesheet type=text/css href=/style/style2.css>
<script language=JavaScript>
<!--
function checkForm(form) {
	if (form.search.value.length == 0)
	{
		alert("찾고자 하는 팀명을 입력해 주세요.");
		form.search.focus();
		return false;
	}
	return true;
}
-->
</script>
<script language=JavaScript>
<!--
//window.resizeTo(377,177);
-->
</script>
<style type="text/css">
BODY 
{scrollbar-face-color: #FFFFFF; scrollbar-shadow-color:#492901;
scrollbar-highlight-color:#492901; scrollbar-3dlight-color:#FFFFFF;
scrollbar-darkshadow-color:#FFFFFF; scrollbar-track-color:#FFFFFF;
scrollbar-arrow-color:#492901}
</style>
</head>

<body bgcolor=F7ECAD topmargin=0 leftmargin=0 marginwidth=0 marginheight=0>
<form action=team_search.asp?flag=1 method=post name=form onsubmit="return checkForm(this)">
<table width=100% border=0 cellspacing=10 cellpadding=0 bgcolor=F7ECAD>
	<tr>
		<td width=100% height=100>
			<table border=0 cellspacing=0 cellpadding=0 width=100% height=100 background=/member/images/bg_zip_search.gif>
				<tr height=40><td></td></tr>
				<tr>
					<td width=80></td>
					<td>
						<input class=mailing type=text name=search  size=15 maxlength=15 style="border-width:1; border-color:BBBBBB; border-style:solid;IME-MODE: active;">&nbsp;
           				<input type=image src=/images/b_search.gif border=0 align=absmiddle>
					</td>
				</tr>
				<tr>
					<td></td>
					<td class=dong>(예) (주)대교 눈높이,삼성전기(주) </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=zip>팀명을 입력해 주십시오.</td>
	</tr>
</form>
</body>
</html>
<%
End if
%>
<%Call DBClose2()%>