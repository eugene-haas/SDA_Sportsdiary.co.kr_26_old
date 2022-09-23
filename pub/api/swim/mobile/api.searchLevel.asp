<%
	idx = oJSONoutput.IDX 
	Set db = new clsDBHelper

    if idx <>"" then  
        SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level "  & _ 
        " ,case when isnull(c.LevelNm,'')='' then '' when c.LevelNm='없음' then '' else c.LevelNm end LevelNm  "  & _ 
        " ,GameDay,GameTime,EntryCntGame"  & _ 
        " ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt"  & _ 
        "  from tblRGameLevel b  "  & _ 
        "  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "  & _ 
        "  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "  & _ 
        "  where b.DelYN='N'  and c.LevelNm not like '%최종%'  " & _ 
        "   and b.GameTitleIDX='"&idx&"'"  & _ 
        "  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,left(b.cfg,1)  "

        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        If Not rs.EOF  Then 
            Call oJSONoutput.Set("result", "82" )
        else
	        Call oJSONoutput.Set("result", "83" )
        end if 
    else
	    Call oJSONoutput.Set("result", "83" )
    end if 


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
    Response.write "`##`"
    
    %><option value="" >:: 부서 전체 조회 ::</option><%
    if idx <>""  then
        If Not rs.EOF  Then 
            Do Until rs.eof
            %> 
              <option value="<%=Rs("Level") %>" <%if levelno =Rs("Level") then %> selected <%end if %>><%=replace(Rs("TeamGbNm"),"부","") %><%if Rs("LevelNm") <>"" then  %>(<%=Rs("LevelNm") %>)<%end if%> <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
            <%
            rs.movenext
            Loop
        end if 
    end if 

	db.Dispose
	Set db = Nothing
%>