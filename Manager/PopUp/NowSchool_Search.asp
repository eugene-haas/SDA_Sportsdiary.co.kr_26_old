<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Search_Text = Request("Search_Text")
	Level_Type = Request("Level_Type")
%>
<script>
function chk_sch(){
	opener.document.getElementById("NowSchIDX").value = "10001"
	opener.document.getElementById("NowSchName").value = "정산고등학교"
	self.close();
}

function chk_frm(){
	var f = document.popup_frm;
	if(f.Search_Text.value==""){
		alert("검색어 입력");
		f.Search_Text.focus();
		return false;
	}
	f.action = "NowSchool_Search.asp";
	f.submit();
}

function chk_data(code,name,teamgb){
	opener.document.getElementById("NowSchIDX").value = code
	opener.document.getElementById("NowSchName").value = name
	opener.document.getElementById("TeamGb").value = teamgb
	/*체급 체크*/
	if(document.popup_frm.Level_Type.value == "1"){
		if(opener.document.getElementById("TeamGb").value!="" && opener.document.getElementById("Sex").value){
			opener.chk_level();
			//alert(opener.document.getElementById("TeamGb").value);
		}
	}
	self.close();
}
</script>
<input type="button" value="선택" onclick="chk_sch();">

<form name="popup_frm" method="post">
<input type="text" name="Search_Text">
<input type="hidden" name="Level_Type" value="<%=Level_Type%>">
<input type="button" value="찾기" onclick="chk_frm();">
</form>
<%
	If Search_Text <> "" Then 
%>
<table border="1">
	<tr>
		<td>코드</td>
		<td>소속명</td>
		<td>소속지역</td>
	</tr>
	<%
		LSQL = "SELECT SchIDX,SportsDiary.dbo.FN_PubName(Sido) AS Sido ,SchoolName ,TeamGb FROM tblSchoolList WHERE SchoolName like '%"&Search_Text&"%'"
		
		Set LRs = Dbcon.Execute(LSQL)

		Dbclose()
		If Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
	%>
	<tr>
		<td onclick="chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>')"><%=LRs("SchIDX")%></td>
		<td onclick="chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>')"><%=LRs("Sido")%></td>
		<td onclick="chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>')"><%=LRs("SchoolName")%></td>
	</tr>
	<%
				LRs.MoveNext
			Loop 
		End If 
	%>
</table>
<%
	End If 
%>