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

'	If idx = "" Then
'		SQL = "select top 1 aa.gametitleidx from (select top 10 GameTitleIDX from sd_TennisTitle order by GameTitleIDX desc) as aa order by GameTitleIDX"
'        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		mintidx = rs(0)
'	End if

    if idx <> "" and  levelno <> ""  then
        cSQL=" select a.Level,b.LevelNm   from tblRGameLevel a     inner join tblLevelInfo b    on a.TeamGb = b.TeamGb    and a.Level = b.Level and a.DelYN='N'   and b.DelYN='N' "
        cSQL= cSQL& " and a.GameTitleIDX='"&idx&"' and a.Level ='"&levelno&"' "
        Set rs = db.ExecSQLReturnRS(cSQL , null, ConStr)
        If rs.EOF Then
            levelno =""
        end if
    end if


	   attstate = " ( Select top 1 gameMemberIDX from sd_tennisMember where GameTitleIDX =  a.GameTitleIDX and gamekey3 = a.Level and PlayerIDX = a.P1_PlayerIDX ) as attmember "

       SQL = "    " & attstate & ", "
       SQL = SQL&"   ROW_NUMBER()over(PARTITION BY a.GameTitleIDX,a.Level order by a.GameTitleIDX,a.Level,RequestIDX ) row_num "
       SQL = SQL&"  , RequestIDX "
       SQL = SQL&"  , a.GameTitleIDX, d.GameTitleName, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,a.Level,c.LevelNm, (b.fee + b.fund) as acctotal  "
       SQL = SQL&"  , a.UserName,PaymentNm,PaymentDt,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2 ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,a.DelYN  "
       SQL = SQL&"  , d.titleCode,d.titleGrade "
       SQL = SQL&"  , b.EntryCntGame , b.cfg,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d "
       SQL = SQL&"  ,''ch_m , Case When ISNULL(f.VACCT_NO,'') = '' then '' When ISNULL(f.VACCT_NO,'') = '1' then '1' else '2' end as VACCT_NO , f.CUST_NM "
       SQL = SQL&"  from tblGameRequest as a "
	   SQL = SQL&"  inner join tblLevelInfo c on a.Level = c.Level and c.DelYN='N' and c.LevelNm <> '최종라운드'  "
       SQL = SQL&"  inner join tblRGameLevel b on a.GameTitleIDX = b.GameTitleIDX and b.DelYN='N' and b.Level=c.Level  "
	   SQL = SQL&"  inner join sd_TennisTitle d on a.GameTitleIDX = d.GameTitleIDX and d.DelYN='N' and ViewYN = 'Y' "

	   SQL = SQL&"  left join SD_rookieTennis.dbo.TB_RVAS_LIST f on '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)  = f.CUST_CD "




	   SQL = SQL&"  where  a.DelYN = 'N' and d.ViewYN = 'Y' "
    if idx <> "" then
		strWhere = "  and CONVERT(varchar(10),a.GameTitleIDX) = '"& idx & "'"
    Else
		strWhere = "  and CONVERT(varchar(10),a.writedate,121) >= '"&   dateAdd("m",-3, Date())  &"' "
	end if

	If idx <> "" and levelno <> "" Then
	   strWhere  = strWhere & "   and a.level = '"&levelno&"' "
    end if

	'#############

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

'If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
	Set rs = GetBBSSelectRS2( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage , SQL)
'else
'	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
'End If

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
'	   Response.write idx & "<br>"
'	   Response.write sql & "<br>"
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
	%>
	<ul class="entryList__list">
	<%
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


            strSt = rs("GameTitleIDX")
            strSt = strSt &"|" &rs("TeamGb")
            strSt = strSt &"|" &rs("Level")
            strSt = strSt &"|" &rs("RequestIDX")
            strSt = strSt &"|" &rs("Ch_i")
            strSt = strSt &"|" &rs("Ch_u")
            strSt = strSt &"|" &rs("Ch_d")
         %>



            <% if CMD ="30000" and i=0 then %>
			<li class="entryList__item">
                <p class="entryList__row s_header">

					<span class="entryList__cell s_number">순번</span>
					<span class="entryList__cell s_gameTitle">대회명</span>
					<span class="entryList__cell s_level">부서명</span>
					<span class="entryList__cell s_team1">선수1</span>
					<span class="entryList__cell s_team2">선수2</span>

				</p>
			</li>
	        <%end if  %>

			<li class="entryList__item">
	            <a href="javascript:chk_frm('FndPwd','<%=strSt %>');" class="entryList__row">
					<span class="entryList__cell s_number"><%=startidx %></span>
					<span class="entryList__cell s_gameTitle">[<%=titleGradeNm  %>]<%=rs("GameTitleName") %></span>
					<span class="entryList__cell s_level"><%=TeamGbNm %>(<%=LevelNm %>)

						<%'if Cdbl(rs("EntryCntGame")) >= Cdbl(rs("row_num")) then %>
						<%If rs("attmember") <> "" Or isnull(rs("attmember")) = False then%>

							<%If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만%>
								<%If VACCT_NO = "" Or isNull(VACCT_NO) = True then%>

						<span class="entryList__status s_nonDeposit"> 입금대기 </span>

								<%else%>

						<span class="entryList__status s_deposit"> 신청완료 </span>

								<%End if%>
							<%End if%>

						<%else %>

						<span class="entryList__status s_depositStandby"> 신청대기 </span>

						<%end if %>

					</span>
					<span class="entryList__cell s_team1">

						<span class="entryList__name"><%=rs("P1_UserName") %></span>
						<span class="entryList__club">

							<%if rs("P1_TeamNm") <>"" then  %> <%=rs("P1_TeamNm") %><%end if%>
							<%if rs("P1_TeamNm") <>"" then  %> <%if rs("P1_TeamNm2") <>"" then  %>/<%end if%> <%end if%>
							<%if rs("P1_TeamNm2") <>"" then  %> <%=rs("P1_TeamNm2") %><%end if  %>

						</span>

					</span>
					<span class="entryList__cell s_team2">

						<span class="entryList__name"><%=rs("P2_UserName") %></span>
						<span class="entryList__club">

							<%if rs("P2_TeamNm") <>"" then  %> <%=rs("P2_TeamNm") %> <%end if  %>
							<%if rs("P2_TeamNm") <>"" then  %> <%if rs("P2_TeamNm2") <>"" then  %>/<%end if%> <%end if%>
							<%if rs("P2_TeamNm2") <>"" then  %> <%=rs("P2_TeamNm2") %> <%end if  %>

						</span>

					</span>
			    </a>
			</li>
	    <%
	i = i + 1
    startidx = startidx -1
	startno = startno + 1
	rs.movenext
	Loop
	%>
	</ul>
	<%
else
    if pageno >1 then
	%>
    <ul id="ErrorMs">
		<li>
			<span class=""></span>
		</li>
	</ul>
	<%
    else
	%>
    <ul id="ErrorMs">
		<li>
			<span class="">검색 결과가 없습니다.</span>
		</li>
	</ul>
	<%
    end if
End if
    if lastpage <>"_end" then
    %>
		<a href="javascript:chk_frm('FndAddList',<%=(pageno+1) %>);" class="entryList__moreBtn">더보기</a>
    <%
    end if
db.Dispose
Set db = Nothing
%>
