<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function aaa() {
	var f  = document.frm;
	if(f.attachfile.value=="") {
		alert("파일을 선택하십시오.");
		return false;
	}
	f.action="excel_rplayermaster_ok.asp" 
	f.submit();
}
//-->
</SCRIPT>
<form  method="post" name="frm"  enctype="multipart/form-data">
<input type="file" name="attachfile"/>
<input type="button" value="업로드" onclick="aaa();">
</form>