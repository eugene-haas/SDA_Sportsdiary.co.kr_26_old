<!-- #include virtual = "/pub/header.adm.asp" -->

<%
  'request 처리##############
	f1= oJSONoutput.Get("F1")
	f2= oJSONoutput.Get("F2")

	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=sportsdiary;Data Source=" & DB_IP & ";"
	Set db = new clsDBHelper


F1 = oJSONoutput.Get("F1") 
F2 = oJSONoutput.Get("F2") 

if f1 = "" then
tidx = 42
else
tidx = F1
end if


if f1 = "" then
tidx = 42
else
tidx = F1
end if






%>
<%'<html xmlns="http://www.w3.org/1999/xhtml">%>
<html lang="ko">
  <head>
  
    <meta charset="utf-8">
    <title></title>

	<style>
      .tbl-match{width:628px;}
      .tbl-match__con{margin:48px 0 0;width:100%;}
      .tbl-match__con span{display:block;width:100%;font-size:15px;font-weight:400px;text-align:right;line-height:24px;}

	  .tbl-match__con__tbl{width:628px;box-sizing:border-box;border-collapse:collapse;border-spacing:0;}
      .tbl-match__con__tbl caption{font-size:15px;font-weight:400px;text-align:left;line-height:24px;}
      .tbl-match__con__tbl th,
      .tbl-match__con__tbl td{line-height:22px;font-size:14px;color:#000;font-weight:400px;border:1 solid #000;text-align:center;}
      .tbl-match__con__tbl th:nth-child(1),
      .tbl-match__con__tbl td:nth-child(1){width:44px;}
      .tbl-match__con__tbl th:nth-child(2),
      .tbl-match__con__tbl td:nth-child(2){width:85px;}
      .tbl-match__con__tbl th:nth-child(3),
      .tbl-match__con__tbl td:nth-child(3),
      .tbl-match__con__tbl th:nth-child(8),
      .tbl-match__con__tbl td:nth-child(8){width:69px;}
      .tbl-match__con__tbl th:nth-child(5),
      .tbl-match__con__tbl td:nth-child(5){width:85px;}
      .tbl-match__con__tbl th:nth-child(6),
      .tbl-match__con__tbl td:nth-child(6),
      .tbl-match__con__tbl th:nth-child(7),
      .tbl-match__con__tbl td:nth-child(7){width:45px;}
    </style>
  </head>
  <body>
<%




subtitle = array("","대회판결종류횟수","부별 최종판결종류수","부별 기술별상세","기술별판정")

SQL = "select gameyear as '년도',gametitlename as '대회명' from tblGametitle where gametitleidx = "& tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
title = rs(1) & " ("&rs(0)&")" & subtitle(f2)
response.write "<br><br>"&rs(1) & " ("&rs(0)&")" & subtitle(f2)

select case F2 
case 1
	'대회판결종류횟수
	SQL = ";with result as (select "
	'SQL = SQL & "  rd.groupgamegb "
	SQL = SQL & " (select pubname from tblPubCode where SportsGb = 'judo' and pubcode = r.LPlayerResult or pubcode = r.RPlayerResult) as 'a' "
	SQL = SQL & " from tblRGameResult as r   " 
	'SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&" "
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"  and r.teamgb in (31001, 31002) " '고등엘리트만
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
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"  and r.teamgb in (31001, 31002) " '고등엘리트만

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
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"  and r.teamgb in (31001, 31002) " '고등엘리트만
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
	SQL = SQL & " where r.DelYN = 'N' and  r.GameTitleIDX = "&tidx&"  and r.teamgb in (31001, 31002)   )" '고등엘리트만


	SQL = SQL & " select "
	SQL = SQL & " a , b ,count(*) as '횟수' "
	SQL = SQL & " from result where a is not null group by a,b order by a,b" 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'response.write sql
	'response.write "기술별 판정"

	
	
	
	
	call rsdrow(rs)
end select 








'엑셀출력################
	Response.Buffer = True     
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&title& ".xls"
'엑셀출력################






	Call db.Dispose
	Set db = Nothing

%>
  </body>
</html>