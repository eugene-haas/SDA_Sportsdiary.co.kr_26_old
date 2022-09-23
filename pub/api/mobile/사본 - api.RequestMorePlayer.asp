<%
	'request
	pageno = oJSONoutput.NKEY
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.LevelNo
	pidx  = oJSONoutput.pidx
	Fnd_Kw  = oJSONoutput.Fnd_Kw
    

	Set db = new clsDBHelper
   SQL = "  select  a.GameTitleIDX,d.GameTitleName,d.GameTitleLevel, b.TeamGb,b.TeamGbNm,a.Level,c.LevelNm,RequestIDX,a.UserName,PaymentNm,PaymentDt,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2 ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,a.DelYN "
   SQL = SQL&"  , ROW_NUMBER()over(PARTITION BY a.GameTitleIDX,a.Level order by a.GameTitleIDX,a.Level,RequestIDX ) row_num " 
   SQL = SQL&"  , b.EntryCntGame , b.cfg,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d "  
   SQL = SQL&"  ,case when ISNULL(s.gameMemberIDX,'') ='' then 'N' else 'Y' end ch_m "  
   SQL = SQL&"  from tblGameRequest as a " 
   SQL = SQL&"  inner join tblLevelInfo c on  a.SportsGb = c.SportsGb and a.Level = c.Level and c.DelYN='N' " 
   SQL = SQL&"  inner join tblRGameLevel b on a.GameTitleIDX = b.GameTitleIDX and a.SportsGb = b.SportsGb and b.DelYN='N' and b.TeamGb = c.TeamGb and b.Level=c.Level  " 
   SQL = SQL&"  inner join sd_TennisTitle d on a.GameTitleIDX = d.GameTitleIDX and a.SportsGb = d.SportsGb and d.DelYN='N' " 
   SQL = SQL&"  LEFT JOIN sd_TennisMember s	on a.GameTitleIDX = s.GameTitleIDX and a.Level = s.gamekey3 and s.DelYN='N' and a.P1_PlayerIDX= s.PlayerIDX and isnull(Round,0)=0 "  
   SQL = SQL&"  where  a.DelYN = 'N' " 

    if idx <> "" then 
		SQL = SQL&"  and a.GameTitleIDX = "&idx&"   " 
    end if 

	If levelno <> "" Then
	   SQL = SQL&"   and a.level = '"&levelno&"' " 
    end if


	intPageNum = pageno
	intPageSize = 10

    startseq = (pageno - 1 )*intPageSize+1
    endseq =pageno*intPageSize

    SQL = "select* from ("&SQL&") a "
    SQL = SQL&"  where  a.DelYN = 'N' " 
    if pidx <>"" then 
         SQL  = SQL & " and ( a.P1_PlayerIDX = "&pidx&" or a.P2_PlayerIDX = "&pidx&") " 
    end if 
    if Fnd_Kw <>"" then 
        SQL  = SQL & " and ( a.P1_UserName like '%"&Fnd_Kw&"%' or a.P2_UserName like '%"&Fnd_Kw&"%') " 
    end if 

    'SQL =SQL &  " where row_num between "&startseq&" and "&endseq & ""
    SQL =SQL &  " order by  GameTitleIDX,a.Level,RequestIDX desc"

   Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "0" )
    'Call oJSONoutput.Set("sql_se", SQL )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
     %>
     <dd><%'SQL %></dd>
     <%

TeamGbNm =""
LevelNm =""
'Response.Write SQL
If Not rs.EOF Then 
	i = 0
	Do Until rs.eof
        if TeamGbNm <> rs("TeamGbNm") or  LevelNm  <> rs("LevelNm")  then 
        %>
            <dd>
                <div class="info_title">
                     <span class="name"><%=rs("TeamGbNm") %>  - <%=rs("LevelNm") %>  ( 제한:<%=Rs("EntryCntGame") %>팀 ) </span>
                </div> 
            </dd>
        <%
            TeamGbNm=  rs("TeamGbNm") 
            LevelNm=  rs("LevelNm") 
        end if 
	    %>
        <dd>
        <%
            strSt = rs("GameTitleIDX") 
            strSt = strSt &"|" &rs("TeamGb") 
            strSt = strSt &"|" &rs("Level") 
            strSt = strSt &"|" &rs("RequestIDX") 
            strSt = strSt &"|" &rs("Ch_i") 
            strSt = strSt &"|" &rs("Ch_u") 
            strSt = strSt &"|" &rs("Ch_d") 
         %>
            <a href="javascript:chk_frm('FndPwd','<%=strSt %>');">
			    <div>
				    <span class="l_number">
					    <span class="Rnumber"><%=rs("row_num") %></span>
                        <%if Cdbl(rs("EntryCntGame")) >= Cdbl(rs("row_num")) then %>
                             <%if Cstr(rs("ch_m")) ="Y" then %>  
                            
                             <%else %>
                                <span class="btn_org"> 대기 <i></i></span>
                             <%end if  %>
                        <%else %>
                             <%if Cstr(rs("ch_m")) ="Y" then %>  
                       
                             <%else %>
                                <span class="btn_org"> 대기 <i></i></span>
                             <%end if  %> 
                        <%end if %>
				    </span>  
				    <span class="r_con">
					    <div class="con_box">
						    <ul>
							   
							    <li>
								    <span class="club_btn_g">참가자 <i></i></span>
								    <span class="name"><%=rs("P1_UserName") %> </span>
								    (
								    <span><%if rs("P1_TeamNm") <>"" then  %> <%=rs("P1_TeamNm") %><%end if  %>  </span>
                                    <%if rs("P1_TeamNm") <>"" then  %> 
                                          <%if rs("P1_TeamNm2") <>"" then  %>/<%end if  %>
                                    <%end if  %>  
                                    <span><%if rs("P1_TeamNm2") <>"" then  %> <%=rs("P1_TeamNm2") %><%end if  %>  </span>
                                    )
							    </li>
							    <li>
								    <span class="club_btn_y">파트너 <i></i></span>
								    <span class="name"><%=rs("P2_UserName") %></span>
								    (
                                    <span><%if rs("P2_TeamNm") <>"" then  %> <%=rs("P2_TeamNm") %><%end if  %>  </span>
                                    <%if rs("P2_TeamNm") <>"" then  %> 
                                        <%if rs("P2_TeamNm2") <>"" then  %> /<%end if  %>
                                    <%end if  %>  
                                     <span><%if rs("P2_TeamNm2") <>"" then  %> <%=rs("P2_TeamNm2") %><%end if  %>  </span>
                                     )
							    </li>
						    </ul>
					    </div>
				    </span>  
			    </div>
		    </a>
	    </dd>
	    <%
	i = i + 1
	rs.movenext
	Loop
else
	%>
    <dd id="ErrorMs">
		<div>
			<span class="">검색 결과가 없습니다.</span> 
		</div>
	</dd>
	<%
End if
 

db.Dispose
Set db = Nothing
%>