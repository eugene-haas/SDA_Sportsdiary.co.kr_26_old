<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
seq = fInject(request("seq"))


if trim(seq) = "" then
	response.end
end if


'체급정보 삭제시 개인전 단체전 체크하여 하위 데이터 삭제 처리

ChkSQL = "SELECT GameTitleIDX"
ChkSQL = ChkSQL&" ,TeamGb"
ChkSQL = ChkSQL&" ,Sex"
ChkSQL = ChkSQL&" ,Level"
ChkSQL = ChkSQL&" ,GroupGameGb"
ChkSQL = ChkSQL&" From SportsDiary.dbo.tblRGameLevel"
ChkSQL = ChkSQL&" WHERE RGameLevelIDX='"& seq &"'"

Set CRs = Dbcon.Execute(ChkSQL)

If Not(CRs.Eof Or CRs.Bof) Then 
	If CRs("GroupGameGb") = "sd040001" Then 
		'개인전 하위 데이터 삭제
		'tblRPlayer
		'tblRPlayerMaster
	ElseIf CRs("GroupGameGb") = "sd004002" Then 
	'단체전 하위 데이터 삭제 처리
		'tblRGameGroupSchoolMaster
		'tblRGameGroupSchool
		'tblRPlayer 
	End If 


End If 



DSQL = " UPDATE SportsDiary.dbo.tblRGameLevel " 
DSQL = DSQL & "  SET DELYN = 'Y'"
DSQL = DSQL & " WHERE DelYN = 'N'"
DSQL = DSQL & " AND RGameLevelIDX = '" & seq & "'"

Dbcon.Execute(DSQL)

Dbclose()

response.write "TRUE"
response.end
%>