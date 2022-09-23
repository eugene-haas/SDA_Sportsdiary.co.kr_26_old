<!-- #include virtual = "/pub/header.adm.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){

	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	If request("test") = "t" Then
		REQ ="{""CMD"":40000,""IDX"":""TfMwxibSFNU+QkrPw68VFg=="",""TID"":1,""PN"":1}"
	Else
		REQ = request("REQ")
	End if
	'REQ ="{""CMD"":30002,""IDX"":49}"

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	'define CMD
	CMD_EDITOR = 40000 '게시판 편집기 
	CMD_EDITOROK = 40001

	
	CMD_LOGIN = 1
	CMD_VACCRESET = 422 '계좌정리
	CMD_SETFLAG	 = 500	'참가,달력, 대진표 설정변경

	CMD_GAMEGRADEPERSONAPPEND = 30000

	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004

	CMD_RNKLIST = 40003	'랭킹리스트목록
	CMD_SETRNKINFO = 40004	'반영후 목록 출력

	CMD_GAMEGRADEPERSONAPPEND_app = 30005 'app 켈린더 조회
	CMD_MAKEGOODS = 50000 ' 상품등록창 오픈
	CMD_INSERTDEP1 = 50002 '저장	
	CMD_DELFILE = 51000 '파일삭제




	Select Case CDbl(CMD)

	Case CMD_EDITOR
		%><!-- #include virtual = "/pub/api/adm/api.editor.asp" --><%
	Response.End
	Case CMD_EDITOROK
		%><!-- #include virtual = "/pub/api/adm/api.editorOK.asp" --><%
	Response.End



	Case CMD_DELFILE
	%><!-- #include virtual = "/pub/up/api.delFile.asp" --><%
	Response.End

	Case CMD_SETFLAG
	%><!-- #include virtual = "/pub/api/RidingAdmin/api.setFlag.asp" --><%
	Response.End


	Case CMD_MAKEGOODS
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.goodsForm.asp" --><%
	Response.end
	Case CMD_INSERTDEP1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.goodsFormOK.asp" --><%
	Response.end


	Case CMD_RNKLIST,CMD_SETRNKINFO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rnklist.asp" --><%
	Response.End

	Case CMD_VACCRESET
	%><!-- #include virtual = "/pub/api/RidingAdmin/api.vaccreset.asp" --><%
	Response.End




	Case CMD_GAMEGRADEPERSONAPPEND
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.contestmore.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputdel.asp" --><%
	Response.end


	End select
%>
