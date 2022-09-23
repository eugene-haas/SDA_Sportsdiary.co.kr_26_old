<!--#include virtual="/Manager/Common/common_header.asp"-->
<%
'select *from tblSchoolMaster
%>
<script>
function chk_sch(){
	opener.document.getElementById("Chk_ID").value = "Y"
	opener.document.getElementById("Hidden_UserID").value = "TestID"
	opener.document.getElementById("UserID").value = "TestID"
	self.close();
}
</script>
<input type="button" value="선택" onclick="chk_sch();">