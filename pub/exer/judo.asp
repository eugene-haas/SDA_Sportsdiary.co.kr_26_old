<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

  <%
    SearchDate    = "2021-11-06"  '조회일정
    GameTitleIDX  = "241"
    GameTitleName  = "2021 회장기전국유도대회 [제50회 전국소년체육대회 및 2022 국가대표 1차 선발전 겸]"



    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLISportsGb = "judo"

  	LocateIDX_1 = "21"
  	'LocateIDX_2 = "10"
  	'LocateIDX_3 = "8"


	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=splog_dbJ0ehU9fpD0tmO1fld;Password=slogp_gGu6+32!k0h04(BqP~4P7;Initial Catalog=sportsdiary;Data Source=49.247.9.88;"
	Set db = new clsDBHelper
  %>

<body>



<%
'받은값
'Response.write  SearchDate &"<br>"
'Response.write  "titleidx : "& GameTitleIDX &"<br>"
'
'Response.write   iLIUserID &"<br>"
'Response.write   iLIMemberIDX &"<br>"
'Response.write   iLISportsGb &"<br>"
'Response.write "--------------------------------------------------<br>"
%>


<!-- <h2 class="title"><%=GameTitleName %></h2><br> -->
<!-- 전체 경기진행 현황 보기<br> -->
<!-- <br><br> -->
<!-- <%=date%><br> -->


<%
'select StadiumNumber,GroupGameNum,GameNum, Tmp_StadiumNumber, TurnNum,gameday,bigo,RECORD_VIDEO_SEQ,game_stime,GAME_ETIME from tblPlayerResult 
'where     gametitleidx = 241   and gameday = '2021-11-06'
'SQL = "select StadiumNumber, GameNum  from tblPlayerResult  where gametitleidx = "&GameTitleIDX&"  and gameday = '"&SearchDate&"' and delyn = 'N'  group by StadiumNumber, GameNum order by StadiumNumber, cast(GameNum as int)"
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsdrow(rs)

callSTime = Timer()


SQL = ";with cte_Info As ( Select RGameLevelidx, PlayerResultIdx, StadiumNumber, TurnNum, NowRoundNM, LResult, RResult, GameStatus, Rteam, LTeam, RPlayerIDX, LPlayerIDX From tblPlayerResult Where DelYN = 'N' And SportsGb = 'judo' And GameTitleIDX = 241 And GameDay = '2021-11-06' And TurnNum Is Not Null And StadiumNumber Is Not Null ) , cte_level As ( Select R.RGameLevelidx, R.[Level], L.LevelNm, R.TeamGb, T.TeamGbNm, R.GroupGameGb, P.PubName As GroupGameGbNm From tblRGameLevel As R Left Join tblLevelInfo As L On L.DelYN = 'N' And L.Level = R.Level And L.SportsGb = 'judo' Inner Join tblTeamGbInfo As T On T.DelYN = 'N' And T.TeamGb = R.TeamGb And T.SportsGb = 'judo' Inner Join tblPubCode As P On P.DelYN = 'N' And P.PubCode = R.GroupGameGb And P.SportsGb = 'judo' Where R.DelYN = 'N' And R.GameTitleIDX = 241 And R.GameDay = '2021-11-06' ) Select ROW_NUMBER() Over(Partition By R.StadiumNumber Order By R.TurnNum) As Idx, R.StadiumNumber, L.RGameLevelidx, R.PlayerResultIdx, IsNull(LTeam, '') As LTeam , IsNull(LT.TeamNm, '') As LTeamNm , IsNull(RTeam, '') As RTeam , IsNull(RT.TeamNm, '') As RTeamNm , IsNull(LPlayerIDX, '') As LPlayerIDX , IsNull(LP.PlayerName, '') As LPlayerName , IsNull(RPlayerIDX, '') As RPlayerIDX , IsNull(RP.PlayerName, '') As RPlayerName , L.[Level], L.LevelNm, L.TeamGb, L.TeamGbNm, L.GroupGameGb, L.GroupGameGbNm, R.NowRoundNM, GameStatus, Case When GameStatus Is Null Then '' When GameStatus = 'sd050001' Then '진행중' When GameStatus = 'sd050002' Then '경기완료' End As GameStatusNm, Case When (RResult Is Null Or Len(RResult) < 1) And (LResult Is Null Or Len(LResult) < 1) Then -1 When (RResult Is Null Or Len(RResult) < 1) Then 1 When (LResult Is Null Or Len(LResult) < 1) Then 2 Else 0 End As win_code From cte_Info As R Inner Join cte_level As L On L.RGameLevelidx = R.RGameLevelidx Left Join (Select Team, TeamNm From tblTeamInfo Where DelYN = 'N') As RT On RT.Team = R.RTeam Left Join (Select Team, TeamNm From tblTeamInfo Where DelYN = 'N') As LT On LT.Team = R.LTeam Left Join (Select PlayerIDX, UserName As PlayerName From tblPlayer Where DelYN = 'N') As RP On RP.PlayerIDX = R.RPlayerIDX Left Join (Select PlayerIDX, UserName As PlayerName From tblPlayer Where DelYN = 'N') As LP On LP.PlayerIDX = R.LPlayerIDX"

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

JsonStr =  jsonTors_arr(rs)

callETime = Timer()


Response.write callETime - callSTime

'Response.Write JsonStr

Set JsonObj = Nothing
Set rs = Nothing
db.Dispose
Set db = Nothing



'Call rsdrow(rs)






If test = "t" then
SQL = "select max(StadiumNumber) from tblPlayerResult  where gametitleidx = "&GameTitleIDX&"  and gameday = '"&SearchDate&"' and delyn = 'N' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

For i = 1 To rs(0)
	Response.write "<a href=''>"& i & " 경기장 </a>&nbsp;&nbsp;&nbsp;"
next

SQL = "select A.StadiumNumber, A.gmax from ("
SQL = SQL & " select StadiumNumber, count(GameNum) OVER(PARTITION BY StadiumNumber) AS 'gmax'    from tblPlayerResult  where gametitleidx = "&GameTitleIDX&"  and gameday = '"&SearchDate&"' and delyn = 'N' ) as A "
SQL = SQL & " group by StadiumNumber, gmax "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
Call rsdrow(rs)

addfld = addfld & " , (SELECT  STUFF(( select ','+ username from tblPlayer where playeridx in (r.Lplayeridx, r.rplayeridx) for XML path('') ),1,1, '' )) "  
addfld = addfld & " , (SELECT  STUFF(( select ','+ TeamNM from tblTeamInfo where team in (r.Lteam, r.rteam) for XML path('') ),1,1, '' )) "  

SQL = "select StadiumNumber,TurnNum,GameNum, round,nowroundnm,nowround,   GroupGameNum, Tmp_StadiumNumber,gameday,bigo,RECORD_VIDEO_SEQ,game_stime,GAME_ETIME "
SQL = SQL & addfld '"  ,Lplayeridx , rplayeridx "
SQL = SQL & " from tblPlayerResult as r "
SQL = SQL & " where  gametitleidx = "&GameTitleIDX&" and gameday = '"&SearchDate&"' and delyn = 'N' and StadiumNumber = 1"
'SQL = SQL & " order by  StadiumNumber, cast(GameNum as int)"
SQL = SQL & " order by  StadiumNumber, TurnNum"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
Call rsdrow(rs)

End if

'Response.write sql

%>




</div>
</body>
</html>
