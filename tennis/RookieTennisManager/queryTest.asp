<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.v1.asp" -->
</head>

<body <%=CONST_BODY%>>


<!-- #include virtual = "/pub/html/RookietennisAdmin/html.header.asp" -->

<div id="body">
<br><br><br><br><br>
<%
'쿼리테스트 
'홀수 sortNo 짝수 sortNo stateno= 1 경기종료
'tblgamerequest 에서 playeridx 각각자져오기
rfiled  ="r.resultIDX , r.gameMemberIDX1, r.gameMemberIDX2,r.winresult, r.m1set1,r.m2set1, p.gamememberidx,p.pidxs  "

ptbl = "( Select a.gamememberidx,(Cast(a.playerIDX as varchar)  + ',' + Cast(b.playerIDX as varchar)) As pidxs From sd_tennisMember As a INNER JOIN sd_tennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX where a.gametitleidx = 119 and gamekey3 = '20101014' ) as p "

pSQLA = "( Select (Cast(a.playerIDX as varchar)  + ',' + Cast(b.playerIDX as varchar)) As pidxs From sd_tennisMember As a INNER JOIN sd_tennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX where a.gameMemberIDX = r.gameMemberIDX1 ) as pidxsA"

pSQLB = "( Select (Cast(a.playerIDX as varchar)  + ',' + Cast(b.playerIDX as varchar)) As pidxs From sd_tennisMember As a INNER JOIN sd_tennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX where a.gameMemberIDX = r.gameMemberIDX2 ) as pidxsB"


pointQ = " (Select (Cast(sum(leftscore) as varchar)  + ',' + Cast(sum(rightscore) as varchar)) As sumpts from sd_TennisResult_record  where resultIDX = r.resultIDX and setno = 1 and  gameend = 1 ) as sumpts"


'SQL = "select  "&rfiled&","&pSQLA&","&pSQLB&", "&pointQ&" from sd_TennisResult as r where GameTitleIDX = 119 and [Level] = '20101014' and delyn = 'N' and stateno= 1 and r.resultIDX = 47101 order by resultIDX desc"
'SQL = "select  "&rfiled&","&pSQLA&","&pSQLB&", "&pointQ&" from sd_TennisResult as r where GameTitleIDX = 119 and [Level] = '20101014' and delyn = 'N' and stateno= 1  order by resultIDX desc"

'SQL = "select  "&rfiled&","&pSQLA&","&pSQLB&", "&pointQ&" from sd_TennisResult as r where GameTitleIDX = 119 and [Level] = '20101014' and delyn = 'N' and stateno= 1  and (pidxsA = '15272,14966' or pidxsB = '15272,14966')"


SQL = "select  "&rfiled&","&pointQ&" from sd_TennisResult as r inner join "&ptbl&" On r.gameMemberIDX1 = p.gamememberidx or r.gameMemberIDX2 = p.gamememberidx where r.GameTitleIDX = 119 and r.Level = '20101014' and r.delyn = 'N' and r.stateno= 1  "


'Response.write sql
'Response.end
'SQL = "select  "&rfiled&","&pSQLA&","&pSQLB&" from sd_TennisResult as r where GameTitleIDX = 119 and [Level] = '20101014' and delyn = 'N' and stateno= 1 order by resultIDX desc"






'=======================
tidx = "119"
levelno = "20101014"
rfield  ="r.resultIDX , r.gameMemberIDX1 as midx1, r.gameMemberIDX2 as midx2,r.winresult, r.m1set1,r.m2set1   ,p.gamememberidx as mymidx ,p.pidxs "
rfield = rfield & " ,(Select (Cast(sum(leftscore) as varchar)  + ',' + Cast(sum(rightscore) as varchar)) As sumpts from sd_TennisResult_record  where resultIDX = r.resultIDX and setno = 1 and  gameend = 1 ) as sumpts"

ptblsub = "( Select gamememberidx,  Cast(playerIDX as varchar) As pidxs From sd_tennisMember where gametitleidx = '"&tidx&"' and gamekey3 = '"&levelno&"' ) as p "

SQL = "select  "&rfield&" from sd_TennisResult as r inner join "&ptblsub&" On r.gameMemberIDX1 = p.gamememberidx or r.gameMemberIDX2 = p.gamememberidx where r.GameTitleIDX =  '"&tidx&"' and r.Level = '"&levelno&"' and r.delyn = 'N' and r.stateno= 1  and  p.pidxs = '9958'  "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)







Call rsdrow(rs)
%>



</div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" -->	
</body>
</html>