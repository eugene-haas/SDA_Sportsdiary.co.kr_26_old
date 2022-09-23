<%
	Years = oJSONoutput.Years  
	idx = oJSONoutput.IDX 
    if Years="" then 
        Years=year(date)
    End If 


	Set db = new clsDBHelper
 
    SQL = " select GameTitleIDX,GameTitleName,GameYear,titleCode,titleGrade,GameS   from View_game_title_list" 
    SQL = SQL &" where 1=1 and ViewState ='Y'"
    if Years <>"" then
        SQL = SQL &" and GameYear='"&Years&"'"
    end if
    SQL = SQL &"  group by GameTitleIDX,GameTitleName,GameYear,titleCode,titleGrade,GameS "  
    SQL = SQL &"  order by GameYear desc,GameS desc,GameTitleIDX"  
    'Response.Write SQL
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF  Then 
        Call oJSONoutput.Set("result", "82" )
    else
	    Call oJSONoutput.Set("result", "83" )
    end if 
 
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
    Response.write "`##`"
    
    %><option value="" >:: 대회 전체 조회 ::</option><%
    If Not rs.EOF  Then 
        Do Until rs.eof
            titleGradeNm = findGrade(rs("titleGrade") )
            if titleGradeNm <> "" then 
                titleGradeNm  =titleGradeNm 
            end if 
        %> 
            <option value="<%=Rs("GameTitleIDX") %>" <%if idx =Cdbl(Rs("GameTitleIDX")) then %> selected <%end if %>>[<%=titleGradeNm  %>]<%=Rs("GameTitleName") %></option>
        <%
        rs.movenext
        Loop
    end if 

	db.Dispose
	Set db = Nothing
%>

