<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
    tid = 100
	title = "선수정보수정요청"
	idx = 0
    pid=""
	tidx = 0
	levelno = 0
    SQL = "select top 1 * from sd_TennisBoard "
    SQL = SQL & " where seq > 0 and writeday>=dateadd(DAY,-1,GETDATE()) "

	If hasown(oJSONoutput, "idx") = "ok" then
		idx = oJSONoutput.idx
        SQL = SQL & " and seq = " & idx
	End If

	If hasown(oJSONoutput, "pid") = "ok" then
		pid = oJSONoutput.pid
	End If

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
        SQL = SQL & " and GameTitleIDX = " & tidx
	End If

	If hasown(oJSONoutput, "levelno") = "ok" then
		levelno = oJSONoutput.levelno
	End if

     SQL = SQL & " and tid = " & tid
     SQL = SQL & " order by writeday desc "

    Set db = new clsDBHelper
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.eof Then
        title= textareaEncode(rs("title"))
    	contents = textareaEncode(rs("contents"))
    End if
	db.Dispose
	Set db = Nothing
%>

<div style="margin:5px;">*선수정보수정요청 완료후에도 기존정보로 참가신청이 가능합니다.</div>
<div style="margin:5px;color:red;" >*선수명과 전화번호 미 입력시 변경 불가합니다.반드시 이름과 전화번호를 입력해주세요.</div>
<%
    if contents ="" then
        'sample = "<table class='type03'>"
        'sample = sample & "<tr><th scope='row'>선수명</th><td style='width:200px;'>&nbsp;</td></tr>"
        'sample = sample & "<tr><th scope='row'>전화번호</th><td>&nbsp;</td></tr>"
        'sample = sample & "<tr><th scope='row'>소속팀명1</th><td>&nbsp;</td></tr>"
        'sample = sample & "<tr><th scope='row'>소속팀명2</th><td>&nbsp;</td></tr>"
        'sample = sample & "</table>"
        '
        %>
<textarea name="playeredit" id="playeredit"  style="display: block;width:100%;height:220px;padding:5px;border:0;overflow-y:scroll;line-height: 30px;" wrap="hard">
* 참가부서명 [필수]:
1. 선수명 :
2. 현재 전화번호 :
3. 변경할 전화번호 :
4. 현재 클럽1 :
5. 현재 클럽2 :
6. 변경할 클럽1 :
7. 변경할 클럽2 : </textarea>
        <%
    else
        %>
        <textarea name="playeredit" id="playeredit"  style="width:100%;height:220px;padding:5px;border:0;overflow-y:hidden;background:clear;line-height:30px;"><%=contents %></textarea> 
        <%

    end if


%>
