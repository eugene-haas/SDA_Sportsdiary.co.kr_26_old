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


<%
    if contents ="" then
        %>
<textarea name="playeredit" id="playeredit" class="infoModify__textarea" wrap="hard">
* 참가부서명 [필수]:
1. 선수명 :
2. 현재 전화번호 :
3. 변경할 전화번호 :
4. 현재 단체명 :
5. 변경할 단체명 :
</textarea>
        <%
    else
        %>
        <textarea name="playeredit" id="playeredit" class="infoModify__textarea" ><%=contents %></textarea>
        <%

    end if


%>
