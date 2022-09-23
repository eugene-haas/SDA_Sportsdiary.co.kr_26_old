<%
	'request
	pageno = oJSONoutput.NKEY
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.LevelNo
	pidx  = oJSONoutput.pidx 
	Years  = oJSONoutput.Years 

    If hasown(oJSONoutput, "Fnd_Kw") = "ok" then	 
	    Fnd_Kw = oJSONoutput.Fnd_Kw
    else
        Fnd_Kw=""
    end if    
    
	intPageNum = pageno
	intPageSize = 10
 
    if Years="" then 
        Years=year(date)
    End If 

	Set db = new clsDBHelper

	If idx = "" Then
		SQL = "select top 1 aa.gametitleidx from (select top 10 GameTitleIDX from sd_TennisTitle order by GameTitleIDX desc) as aa order by GameTitleIDX"
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		mintidx = rs(0)
	End if

    if idx <> "" and  levelno <> ""  then 
        cSQL=" select a.Level,b.LevelNm   from tblRGameLevel a     inner join tblLevelInfo b    on a.TeamGb = b.TeamGb    and a.Level = b.Level and a.DelYN='N'   and b.DelYN='N' "
        cSQL= cSQL& " and a.GameTitleIDX='"&idx&"' and a.Level ='"&levelno&"' "
        Set rs = db.ExecSQLReturnRS(cSQL , null, ConStr)
        If rs.EOF Then 
            levelno =""
        end if
    end if
   

	   attstate = " ( Select top 1 gameMemberIDX from sd_tennisMember where GameTitleIDX =  r.GameTitleIDX and gamekey3 = r.Level and PlayerIDX = r.P1_PlayerIDX ) as attmember "
If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
       SQL = "    " & attstate & ", "
else
       SQL = "  select  " 
End if
       SQL = SQL&"   ROW_NUMBER()over(PARTITION BY r.GameTitleIDX,r.Level order by r.GameTitleIDX,r.Level,RequestIDX ) row_num " 
       SQL = SQL&"  , RequestIDX "
       SQL = SQL&"  , r.GameTitleIDX, d.GameTitleName, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,r.Level,c.LevelNm, (b.fee + b.fund) as acctotal  " 
       SQL = SQL&"  , r.UserName,PaymentNm,PaymentDt,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2 ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,r.DelYN  " 
       SQL = SQL&"  , d.titleCode,d.titleGrade " 
       SQL = SQL&"  , b.EntryCntGame , b.cfg,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d "  
       SQL = SQL&"  ,''ch_m , Case When ISNULL(f.VACCT_NO,'') = '' then '' When ISNULL(f.VACCT_NO,'') = '1' then '1' else '2' end as VACCT_NO , f.CUST_NM " 
       SQL = SQL&"  from tblGameRequest as r " 
       SQL = SQL&"  inner join tblLevelInfo c on  r.SportsGb = c.SportsGb and r.Level = c.Level and c.DelYN='N' and c.LevelNm <> '최종라운드' and  r.DelYN = 'N' " 
       SQL = SQL&"  inner join tblRGameLevel b on r.GameTitleIDX = b.GameTitleIDX and r.SportsGb = b.SportsGb and b.DelYN='N' and b.TeamGb = c.TeamGb and b.Level=c.Level  " 
	   SQL = SQL&"  inner join sd_TennisTitle d on r.GameTitleIDX = d.GameTitleIDX and r.SportsGb = d.SportsGb and d.DelYN='N' and  d.GameYear ='"&Years&"'  "
'	   SQL = SQL&"  inner join sd_TennisTitle d on r.GameTitleIDX = d.GameTitleIDX and r.SportsGb = d.SportsGb and d.DelYN='N' and d.ViewYN in ('Y','N') and d.GameYear ='"&Years&"'  "
	   SQL = SQL&"  left join TB_RVAS_LIST f on r.requestIDX = f.CUST_CD " 

	   SQL = SQL&"  where  r.DelYN = 'N' "
    if idx <> "" then 
		SQL = SQL&"  and r.GameTitleIDX = "&idx&"   " 
    Else
		SQL = SQL&"  and r.GameTitleIDX >= "&mintidx
	end if 

	If idx <> "" and levelno <> "" Then
	   SQL = SQL&"   and r.level = '"&levelno&"' " 
    end if

	'#############


    attstate = " ( Select top 1 gameMemberIDX from sd_tennisMember where GameTitleIDX =  a.GameTitleIDX and gamekey3 = a.Level and PlayerIDX = a.P1_PlayerIDX ) as attmember "
    strFieldName="  row_num	,GameTitleIDX	,GameTitleName	,TeamGb	,TeamGbNm	,Level	,LevelNm	,RequestIDX	,UserName	,PaymentNm	,PaymentDt	,P1_PlayerIDX	,P1_UserName	,P1_TeamNm	,P1_TeamNm2	,P2_PlayerIDX	,P2_UserName	,P2_TeamNm	,P2_TeamNm2	,DelYN	,titleCode	,titleGrade	,EntryCntGame	,cfg	,Ch_i	,Ch_u	,Ch_d	,ch_m, VACCT_NO, CUST_NM ,acctotal ," & attstate
    strTableName=" ("&SQL&") a  "
'	If idx <> "" Then
'	strWhere = "    a.DelYN = 'N'  and a.GameTitleIDX = " & idx
'	else
	strWhere = "    a.DelYN = 'N'  " 
'	End if

	strSort = "  ORDER By VACCT_NO asc,RequestIDX desc"
	strSortR = "  ORDER By  VACCT_NO desc,RequestIDX asc"



    if pidx <>"" then 
         strWhere  = strWhere & " and ( a.P1_PlayerIDX = "&pidx&" or a.P2_PlayerIDX = "&pidx&") " 
    end if 
    if Fnd_Kw <>"" then 
        strWhere  = strWhere & " and ( a.P1_UserName like '%"&Fnd_Kw&"%' or a.P2_UserName like '%"&Fnd_Kw&"%') " 
    end if 


If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'Response.write sql
'Response.end
End if

If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
	Set rs = GetBBSSelectRS2( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage , SQL)
else
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
End If

If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'Response.write "여기까지"
'Response.end
End if


    startidx = intTotalCnt - (intPageSize*(intPageNum-1))
    endidx = intTotalCnt - (intPageSize*intPageNum)+1

	If CDbl(intPageNum) = 1 Then
	startno = 1 
	else
	startno = (intPageSize * (intPageNum - 1)) +  startno + 1
	End if
   
   if request("test") ="t" then 
'		Response.write sql
'       Response.Write intPageSize &"<br>"&"<br>"
'       Response.Write intPageNum &"<br>"&"<br>"
'       Response.Write intTotalCnt &"<br>"&"<br>"
'       Response.Write intTotalPage &"<br>"&"<br>"
'
'
'       Response.Write  "=========<br>"&"<br>"
'       Response.Write  (intPageSize*(intPageNum-1)+1)  &"<br>"&"<br>"
'       Response.Write  (intPageSize*intPageNum)  &"<br>"&"<br>"
'
'       
'       Response.Write  intTotalCnt - (intPageSize*(intPageNum-1))  &"<br>"&"<br>"
'       Response.Write  intTotalCnt - (intPageSize*intPageNum)+1  &"<br>"&"<br>"
'
'       Response.Write strFieldName &"<br>"&"<br>"
'       Response.Write strTableName  &"<br>"&"<br>"
'       Response.Write strWhere &"<br>"&"<br>"
   end if
    


    If CDbl(pageno) >= CDbl(intTotalPage) Then
	    lastpage = "_end"
    Else
	    lastpage = "_ing"
    End if

    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "0" ) 
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
 
TeamGbNm =""
LevelNm ="" 

If Not rs.EOF  Then 
	i = 0
	Do Until rs.eof
		VACCT_NO = rs("VACCT_NO")  '입금완료된 가상계좌번호 (1 현금으로 수취)
		CUST_NM = rs("CUST_NM") '입금자 명 ('별도입금')
		acctotal = rs("acctotal") '설정된 참가비


        titleGradeNm = findGrade(rs("titleGrade") )
        if titleGradeNm <> "" then 
            titleGradeNm  =titleGradeNm '&"그룹"
        end if 

		if TeamGbNm <> rs("TeamGbNm") or  LevelNm  <> rs("LevelNm")  then 
            TeamGbNm=  replace(rs("TeamGbNm") ,"부","")
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
            <div>
                <div class="ggsc_list">
                    <ul>
								<!-- s: 타이틀명 -->
                                <% if CMD ="30000" and i=0 then %>
								<li class="title_bg">
									<div>
										<dl>
											<dt class="list_number">순번</dt>
											<dt class="list_name center">대회명</dt>
											<dt class="list_level">부서명</dt>
											<dt class="team_1"><div class="team_box">선수1<div></dt>
											<dt class="team_2"><div class="team_box">선수2</div></dt>
										</dl>
									</div>
								</li>
                                <%end if  %>
								<!-- e: 타이틀명 -->
                        
                    </ul>
                </div>
            </div>
            <a href="javascript:chk_frm('FndPwd','<%=strSt %>');">
			    <div>
						<div class="ggsc_list">
							<ul>
								<li>
									<div>
										<dl> 
											<dt class="list_number"><%=startidx %></dt>
											<dt class="list_name">[<%=titleGradeNm  %>]<%=rs("GameTitleName") %></dt>
											<dt class="list_level"><%=TeamGbNm %>(<%=LevelNm %>)
												<span class="c_999">
													<%'if Cdbl(rs("EntryCntGame")) >= Cdbl(rs("row_num")) then %>
													<%If rs("attmember") <> "" Or isnull(rs("attmember")) = False then%>
														
														<%If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만%>
															<%If VACCT_NO = "" Or isNull(VACCT_NO) = True then%>
															<span class="btn_red"> 미입금 <i></i></span>
															<%else%>
															<span class="btn_green"> 입금완료<i></i></span>
															<%End if%>
														<%End if%>

													<%else %>
														<span class="btn_org"> 대기 <i></i></span>
													<%end if %>
												</span>
											</dt>
											<dt class="team_1">
												<div class="team_box">
													<span class="team_name"><%=rs("P1_UserName") %></span>
													<span class="team_club">
														<span><%if rs("P1_TeamNm") <>"" then  %> <%=rs("P1_TeamNm") %><%end if  %></span>
														<span><%if rs("P1_TeamNm") <>"" then  %>  <%if rs("P1_TeamNm2") <>"" then  %>/<%end if  %><%end if  %> </span>
														<span><%if rs("P1_TeamNm2") <>"" then  %> <%=rs("P1_TeamNm2") %><%end if  %></span>
													</span>
												</div>
											</dt>
											<dt class="team_2">
												<div class="team_box">
													<span class="team_name"><%=rs("P2_UserName") %></span>
													<span class="team_club">
														<span><%if rs("P2_TeamNm") <>"" then  %> <%=rs("P2_TeamNm") %><%end if  %></span>
														<span><%if rs("P2_TeamNm") <>"" then  %>  <%if rs("P2_TeamNm2") <>"" then  %>/<%end if  %><%end if  %> </span>
														<span><%if rs("P2_TeamNm2") <>"" then  %> <%=rs("P2_TeamNm2") %><%end if  %></span>
													</span>
												</div>
											</dt>
										</dl>
									</div>
								</li>
							</ul>
						</div>
			    </div>
		    </a>
	    </dd>
	    <%
	i = i + 1
    startidx = startidx -1 
	startno = startno + 1
	rs.movenext
	Loop
else
    if pageno >1 then 
	%>
    <dd id="ErrorMs">
		<div>
			<span class=""></span> 
		</div>
	</dd>
	<%
    else
	%>
    <dd id="ErrorMs">
		<div>
            <div class="ggsc_list">
				<ul>
					<li> <span class="">검색 결과가 없습니다.</span> </li>
				</ul>
			</div>
		</div>
	</dd>
	<%
    end if 
End if
    if lastpage <>"_end" then
    %>
		<a href="javascript:chk_frm('FndAddList',<%=(pageno+1) %>);" class="more_btn"> 더보기</a>
    <%
    end if 
db.Dispose
Set db = Nothing
%>