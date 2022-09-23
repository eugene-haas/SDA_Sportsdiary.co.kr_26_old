<%
 'Controller ################################################################################################



ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=sportsdiary;Data Source=" & DB_IP & ";"

'샘플쿼리~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	SQL = "select top 10 "
	SQL = SQL & " (select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.LPlayerResult or pubcode = r.RPlayerResult) as '결과', "
	SQL = SQL & " (select pubname from tblPubCode where pubcode = rd.LJumsuGb or PubCode = rd.RJumsuGb) as '판정', " 
	'SQL = SQL & " (select pubcode from tblPubCode where pubcode = rd.LJumsuGb or PubCode = rd.RJumsuGb) as '코드', " 

	SQL = SQL & " (select top 1 PPubName from tblPubCode_spec where ppubcode =  rd.LSpecialtyGb or pubcode =  rd.RSpecialtyGb)  as '기술', " 
	'SQL = SQL & " (select top 1 ppubcode from tblPubCode_spec where ppubcode =  rd.LSpecialtyGb or pubcode =  rd.RSpecialtyGb)  as '코드', " 

	SQL = SQL & " (select PubName from tblPubCode_spec where pubcode =  rd.LSpecialtyDtl or pubcode =  rd.RSpecialtyDtl) as '상세', " 
	'SQL = SQL & " (select pubcode from tblPubCode_spec where pubcode =  rd.LSpecialtyDtl or pubcode =  rd.RSpecialtyDtl) as '코드', " 

	SQL = SQL & " case when rd.groupgamegb = 'sd040001' then '개인전' else '단체전' end as '개인단체', " 
	SQL = SQL & " (select  PubName from tblPubCode where pubcode =  rd.RLeftRight or pubcode =  rd.LLeftRight) as '기술방향', " 

	
	if tidx = "42" then
	SQL = SQL & " (select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.Level) as '체급', "'2017년도만사용동트는만사용..ㅡㅡ동트는 동해 2017활체육 전국유도대회
	else
	SQL = SQL & " (select levelnm from tblLevelInfo where SportsGb = 'judo' and level = r.Level) as '체급', " 
	end if
	SQL = SQL & " r.Level as '코드', "
	if tidx = "42" then
	SQL = SQL & " (select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.TeamGb) as '부서', "
	else
	SQL = SQL & " (select pteamgbnm from [tblTeamGbInfo] where SportsGb = 'judo' and teamgb = r.TeamGb) as '부서', "
  end if

	SQL = SQL & " r.TeamGb as '부서', "

	SQL = SQL & " r.Sex,r.GameNum,year(r.GameDay) as year,r.LPlayerName,r.RPlayerName,r.LJumsu,r.RJumsu "
	'SQL = SQL & " RPlayerResult,GroupGameNum,ChiefSign,AssChiefSign1,Round,AssChiefSign2,StadiumNumber,WriteDate,WorkDt,DelYN,MediaLink,RGameResultDtlIDX,RGameLevelidx,GameTitleIDX,SportsGb"
	'SQL = SQL & " TeamGb,Sex,Level,GroupGameGb,GroupGameNum,GameNum,OverTime,CheckTime,idx,LPlayerIDX,LPlayerNum,LLeftRight,LJumsu,RPlayerIDX,RPlayerNum,"
	'SQL = SQL & " RLeftRight,RJumsu,JumsuType,WorkDt,DelYN,WriteDate " 
	SQL = SQL & " from tblRGameResult as r inner join tblRGameResultDtl as rd on r.RGameLevelidx = rd.RGameLevelidx and r.Level = rd.Level and r.gamenum = rd.gamenum and rd.DelYN = 'N'  " 
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = 126 order by r.rgamelevelidx,r.gamenum " 
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'call rsdrow(rs)
	'rss = rs.GetRows()
	'call getrowsdrow(rss)
'샘플쿼리~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



'============================================
'대회명 (년도) 대회장소 출력
'42,60,93,133,143,159
F1 = oJSONoutput.Get("F1") 
F2 = oJSONoutput.Get("F2") 

if f1 = "" then
tidx = 42
else
tidx = F1
end if



'42,60,93,133,143,159 
SQL = "select gameyear as '년도',gametitlename as '대회명','<a href=""javascript:px.goSubmit({''F1'':'+cast(gametitleidx as varchar)+',''F2'':1},''judolog.asp'')"" class=""btn"">대회선택</a>' from tblGametitle where gametitleidx in (44,97,167) "


'44  - 2017 세계 및 아시아유소년선수권대회 파견 대표선발전
'97 - 2018 세계 및 아시아 유소년선수권대회 대표 선발전
'167 - 제47회 춘계전국초중고등학교유도연맹전 


'& tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
call rsdrow(rs)


%>
<a href="javascript:px.goSubmit({'F1':<%=tidx%>,'F2':1},'judolog.asp')" class="btn btn-primary" style="margin:3px;">대회판결종류횟수</a>
<a href="javascript:px.goSubmit({'F1':<%=tidx%>,'F2':2},'judolog.asp')" class="btn btn-primary" style="margin:3px;">부별 최종판결종류수</a>
<a href="javascript:px.goSubmit({'F1':<%=tidx%>,'F2':3},'judolog.asp')" class="btn btn-primary" style="margin:3px;">부별 기술별상세</a>
<a href="javascript:px.goSubmit({'F1':<%=tidx%>,'F2':4},'judolog.asp')" class="btn btn-primary" style="margin:3px;">기술별판정</a>


<%

SQL = "select gameyear as '년도',gametitlename as '대회명' from tblGametitle where gametitleidx = "& tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
response.write "<br><br>"&rs(1) & " ("&rs(0)&")" 

%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:px.goSubmit({'F1':<%=tidx%>,'F2':<%=f2%>},'exceljudo.asp')" class="btn btn-primary" style="margin:3px;">액셀다운로드</a>
<%

'고등부만.하려면
'select * from [tblTeamGbInfo] where SportsGb = 'judo' and pteamgb = 31 엘리트 (고등) teamgb = (31001, 31002

select case F2 
case 1
	'대회판결종류횟수
	SQL = ";with result as (select "
	'SQL = SQL & "  rd.groupgamegb "
	SQL = SQL & " (select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.LPlayerResult or pubcode = r.RPlayerResult) as 'a' "
	SQL = SQL & " from tblRGameResult as r   " 
	'SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" "
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" and r.	teamgb in (31001, 31002) " '고등부 엘리트만

	SQL = SQL & " )" 

	SQL = SQL & "select a as '판정',count(a) as '판정수' from result group by a " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write "대회판결종류횟수"
	call rsdrow(rs)

case 2
	'부별 최종판결종류수
	SQL = ";with result as (select "
	SQL = SQL & "  r.groupgamegb,r.rgamelevelidx "
	SQL = SQL & " ,case when r.groupgamegb = 'sd040001' then '개인전' else '단체전' end as 'a' " 
	
	if tidx = "42" then
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.TeamGb) as 'b' "
	else
	SQL = SQL & " ,(select pteamgbnm from [tblTeamGbInfo] where SportsGb = 'judo' and teamgb = r.TeamGb) as 'b' " '부서
  end if

	
	
	SQL = SQL & " ,r.sex as 'c' "
	if tidx = "42" then
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.Level) as 'd' "
	else
	SQL = SQL & " ,(select levelnm from tblLevelInfo where SportsGb = 'judo' and level = r.Level) as 'd' "  '체급
	end if
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.LPlayerResult or pubcode = r.RPlayerResult) as 'e' "
	SQL = SQL & " from tblRGameResult as r " 
	'SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" "
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"  and r.teamgb in (31001, 31002) " '고등부 엘리트만
	SQL = SQL & " )" 

	SQL = SQL & "select isNull(a,'')+' '+isNull(b,'')+ ' ' +(case when c = 'Man' then '(남)' else '(여)' end)+' '+isNull(d,'') as '부서',e as '판정',count(e) as '판정수' from result group by groupgamegb,rgamelevelidx,a,b,c,d,e "
	SQL = SQL & " order by groupgamegb,rgamelevelidx" 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write "부별 최종판결종류수"
	call rsdrow(rs)

case 3
	'기술별상세
	SQL = ";with result as (select "
	SQL = SQL & "  rd.groupgamegb,r.rgamelevelidx "

	SQL = SQL & " ,case when rd.groupgamegb = 'sd040001' then '개인전' else '단체전' end as 'a' " 
	if tidx = "42" then
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.TeamGb) as 'b' "
	else
	SQL = SQL & " ,(select pteamgbnm from [tblTeamGbInfo] where SportsGb = 'judo' and teamgb = r.TeamGb) as 'b' " '부서
  end if
	
	SQL = SQL & " ,r.sex as 'c' "
		if tidx = "42" then
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.Level) as 'd' "
	else
	SQL = SQL & " ,(select levelnm from tblLevelInfo where SportsGb = 'judo' and level = r.Level) as 'd' "  '체급
	end if
	SQL = SQL & " ,(select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.LPlayerResult or pubcode = r.RPlayerResult) as 'e' "
	SQL = SQL & " ,(select pubname from tblPubCode where pubcode = rd.LJumsuGb or PubCode = rd.RJumsuGb) as 'f' " 
	SQL = SQL & " ,(select top 1 PPubName from tblPubCode_spec where ppubcode =  rd.LSpecialtyGb or pubcode =  rd.RSpecialtyGb)  as 'g' " 
	SQL = SQL & " ,(select PubName from tblPubCode_spec where pubcode =  rd.LSpecialtyDtl or pubcode =  rd.RSpecialtyDtl) as 'h' " 
	SQL = SQL & " ,(select  PubName from tblPubCode where pubcode =  rd.RLeftRight or pubcode =  rd.LLeftRight) as 'i' " 

	SQL = SQL & " from tblRGameResult as r inner join tblRGameResultDtl as rd on r.RGameLevelidx = rd.RGameLevelidx and r.Level = rd.Level and r.gamenum = rd.gamenum and rd.DelYN = 'N'  " 
	'SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" "
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" and r.teamgb in (31001, 31002) " '고등부 엘리트만
	
	SQL = SQL & ")"

	SQL = SQL & " select "
	SQL = SQL & " isNull(a,'')+' '+isNull(b,'')+ ' ' +(case when c = 'Man' then '(남)' else '(여)' end)+' '+isNull(d,'') as '부서',e as '승패',f as '판정',g as '구분',h as '상세',i as '방향' ,count(f) as '판정수' "
	SQL = SQL & " from result group by groupgamegb,rgamelevelidx,a,b,c,d,e,f,g,h,i " 
	SQL = SQL & " order by groupgamegb,rgamelevelidx " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write "부별 기술별상세"
	call rsdrow(rs)
case 4
	'기술별 판정
	SQL = ";with result as (select "
	SQL = SQL & " (select PubName from tblPubCode_spec where pubcode =  rd.LSpecialtyDtl or pubcode =  rd.RSpecialtyDtl) as 'a' " 
	SQL = SQL & " ,(select pubname from tblPubCode where pubcode = rd.LJumsuGb or PubCode = rd.RJumsuGb) as 'b' " 

	SQL = SQL & " from tblRGameResult as r inner join tblRGameResultDtl as rd on r.RGameLevelidx = rd.RGameLevelidx and r.Level = rd.Level and r.gamenum = rd.gamenum and rd.DelYN = 'N'  " 
	'SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" )"
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"   and r.teamgb in (31001, 31002)  ) "  '고등부 엘리트만


	SQL = SQL & " select "
	SQL = SQL & " a , b ,count(*) as '횟수' "
	SQL = SQL & " from result where a is not null group by a,b order by a,b" 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write sql
	'response.write "기술별 판정"
	call rsdrow(rs)
end select 
%>
