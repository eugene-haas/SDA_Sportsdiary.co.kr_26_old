<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
' If Request.Cookies("UserID") = "" Then
'   Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
'   Response.End
' End If 
%>
<%
  
  '경기장 최대 갯수
  MaxStadiumNumber = "2"
  '경기장번호
  StadiumNumber = fInject(Request("StadiumNumber"))
  
  If StadiumNumber = "" Then
    StadiumNumber = "1"
  Else
    If StadiumNumber = MaxStadiumNumber Then 
			Pre_StadiumNumber = MaxStadiumNumber
      StadiumNumber = "1"
    Else
			Pre_StadiumNumber = StadiumNumber
      StadiumNumber = StadiumNumber+1
    End If 

  End If 


	'StadiumNumber = "1"

  GameDay = fInject(Request("GameDay"))

	GameTitleIDX = fInject(Request("GameTitleIDX"))

  'NowYear = Year(Now())
  'NowMonth = AddZero(Month(Now()))
  'NowDay = AddZero(Day(Now()))

  If GameDay = "" Then 
'   GameDay = NowYear & "-" & NowMonth & "-" & NowDay
    GameDay = "2017-08-11"
  End If 

  '대회정보
	If GameTitleIDX = "" Then
    GameTitleIDX = "60"
	End If

   'SQL = "SELECT Top 100 B.PlayerResultIDX, B.RGameLevelidx, ISNULL(SportsDiary.dbo.FN_PlayerName(B.LPlayerIDX),'미확정') AS LUserName, 'ISNULL(SportsDiary.dbo.FN_PlayerName(B.RPlayerIDX),'미확정') AS RUserName, "
   'SQL = SQL&" SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName,"
   'SQL = SQL&" B.GroupGameNum AS GroupGameNum, B.GameNum AS GameNum, B.LPlayerIDX, B.RPlayerIDX,"
   'SQL = SQL&" B.LTeam, LTeamDtl, B.RTeam, B.RTeamDtl, B.LResult, B.RResult, B.GameStatus AS GameStatus, "
   'SQL = SQL&" SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM, "
   'SQL = SQL&" SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGBNM,"
   'SQL = SQL&" SportsDiary.dbo.FN_LevelNm('judo',B.TeamGb,B.Level) AS LevelNM,"
   'SQL = SQL&" B.Sex, B.GroupGameGb AS GroupGameGb, B.NowRoundNM AS NowRoundNM, B.CheifMain, B.CheifSub1, B.CheifSub2"
	 'SQL = SQL&" ,B.TempNum AS TempNum "
	 'SQL = SQL&" ,B.StadiumNumber AS StadiumNumber "
	 
   'SQL = SQL&" FROM SportsDiary.dbo.tblRgameLevel A "
   'SQL = SQL&" INNER JOIN SportsDiary.dbo.tblPlayerResult B ON B.RGameLevelidx = A.RGameLevelidx "
   'SQL = SQL&" AND B.GameTitleIDX = '"&GameTitleIDX&"' "
   'SQL = SQL&" AND A.GameDay = '"&GameDay&"'"
   'SQL = SQL&" AND B.StadiumNumber = '"&StadiumNumber&"'"
   'SQL = SQL&" AND A.DelYN = 'N'"
   'SQL = SQL&" AND B.DelYN = 'N'"
	 'SQL = SQL&" AND ISNULL(B.TurnNum,'')<>''"
	 'SQL = SQL&" AND ISNULL(B.TurnNum,'')<>'0'"
	 'SQL = SQL&" AND ISNULL(B.TurnNum,'')<>'10000'"
	 'SQL = SQL&" AND B.PlayerResultIDX<>'88973'"
   ''WSQL = SQL&" AND B.NowRound < 3 "	 
   'SQL = SQL&" AND ISNULL(B.GameStatus,'') <> 'sd050002'"
   'SQL = SQL&" AND (B.GroupGameGb = 'sd040001' OR (B.GroupGameGb = 'sd040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' )))"
   'SQL = SQL&" ORDER BY  B.TurnNum "

		SQL = "SELECT Top 10 B.PlayerResultIDX, B.RGameLevelidx, ISNULL(SportsDiary.dbo.FN_PlayerName(B.LPlayerIDX),'미확정') AS LUserName,"
		SQL = SQL& " ISNULL(SportsDiary.dbo.FN_PlayerName(B.RPlayerIDX),'미확정') AS RUserName,"
		SQL = SQL& " SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName,"
		SQL = SQL& " B.GroupGameNum AS GroupGameNum, B.GameNum AS GameNum, B.LPlayerIDX, B.RPlayerIDX,"
		SQL = SQL& " B.LTeam, CASE WHEN LTeamDtl = '0' THEN '' ELSE LTeamDtl END AS LTeamDtlNM, B.RTeam, CASE WHEN B.RTeamDtl = '0' THEN '' ELSE B.RTeamDtl END AS RTeamDtlNM,"
		SQL = SQL& " B.LResult, B.RResult, B.GameStatus AS GameStatus,"
		SQL = SQL& " SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM,"
		SQL = SQL& " SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGBNM,"
		SQL = SQL& " SportsDiary.dbo.FN_LevelNm('judo',B.TeamGb,B.Level) AS LevelNM,"
		SQL = SQL& " B.Sex, B.GroupGameGb AS GroupGameGb, B.NowRoundNM AS NowRoundNM, B.CheifMain, B.CheifSub1, B.CheifSub2 "
		SQL = SQL& " ,B.StadiumNumber "
		SQL = SQL& " ,B.TurnNum "
		SQL = SQL& " ,B.TempNum	"
		SQL = SQL& " ,Sportsdiary.dbo.FN_TeamSidoNm('judo',B.LTeam) AS LSidoNm "
		SQL = SQL& " ,Sportsdiary.dbo.FN_TeamSidoNm('judo',B.RTeam) AS RSidoNm "
		SQL = SQL& " FROM SportsDiary.dbo.tblRgameLevel A "
		SQL = SQL& " INNER JOIN ("
		SQL = SQL& " 			SELECT PlayerResultIDX, RGameLevelidx, LPlayerIDX, RPlayerIDX, SportsGb, TeamGb, LTeam, RTeam,"
		SQL = SQL& " 			GroupGameNum, GameNum, LTeamDtl, RTeamDtl, LResult, RResult, GameStatus, GroupGameGb, Level, NowRoundNM,"
		SQL = SQL& " 			Sex, CheifMain, CheifSub1, CheifSub2, StadiumNumber, TurnNum, GameTitleIDX, DelYN, GameDay,"
		SQL = SQL& " 			ROW_NUMBER() OVER(ORDER BY ISNULL(TurnNum,'') ASC) AS TempNum"
		SQL = SQL& " 			FROM SportsDiary.dbo.tblPlayerResult"
		SQL = SQL& " 			WHERE GameTitleIDX = '" & GameTitleIDX & "'"
		SQL = SQL& " 			AND StadiumNumber = '" & StadiumNumber & "'"
		SQL = SQL& " 			AND DelYN = 'N'"
		SQL = SQL& " 			AND ISNULL(TurnNum,'')<>''"
		SQL = SQL& " 			) B ON B.RGameLevelidx = A.RGameLevelidx "
		SQL = SQL& " AND A.GameDay = '" & GameDay & "'"
		SQL = SQL& " AND A.DelYN = 'N'"
		SQL = SQL& " AND ("
		SQL = SQL& " 	ISNULL(GameStatus,'') = ''"
		SQL = SQL& " 		OR GameStatus = 'sd050001'"
		SQL = SQL& " 		OR("
		SQL = SQL& " 			GameStatus = 'sd050002'"
		SQL = SQL& " 			AND (LResult = 'sd019006' OR RResult = 'sd019006')"
		SQL = SQL& " 			AND ISNULL(SportsDiary.dbo.FN_BeforeGameStatus (B.SportsGb, B.GameTitleIDX , B.StadiumNumber, B.GameDay, B.TurnNum),'') IN ('','sd050001')"
		SQL = SQL& " 			)"
		SQL = SQL& " 	)"
		SQL = SQL& " AND (B.GroupGameGb = 'sd040001' OR (B.GroupGameGb = 'sd040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' )))"
		SQL = SQL& " ORDER BY B.StadiumNumber, B.TurnNum"   
   
   'Response.Write SQL
   'Response.End
   Set Rs = Dbcon.execute(SQL)
%>
  <head>
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
  </head>
  <link rel="stylesheet" href="../css/round_board.css">
  
  <section>
    <div id="content">  
       <!--  경기일자:<%=GameDay%> 경기장번호:<%=StadiumNumber%>경기장 -->
    <!-- S: head_info -->
    <div class="head_info clearfix">
      <!-- <p class="game_day"><%=GameDay%></p> -->
      <h1>
        <a href="javascript:chk_frm();"><img src="../images/roundBoard/logo.png" alt="스포츠다이어리 유도"></a>
      </h1>
			 <div class="stadium_box">
        <!-- <p class="stadium_num prev_stad"><%=StadiumNumber%>경기장</p> -->
        <p class="stadium_num prev_stad"><%=Pre_StadiumNumber%>경기장</p>
        <p class="stadium_num"><%=StadiumNumber%>경기장</p>
        <p class="stadium_num next_stad"><%=Pre_StadiumNumber%>경기장</p>
        <!-- <p class="stadium_num next_stad"><%=StadiumNumber%>경기장</p> -->
      </div>
      <p class="institute">
        <img src="../images/roundBoard/logo_kja.png" alt="대한유도회">
        <!-- <img src="../images/roundBoard/logo_kijf.png" alt="한국실업유도연"> -->
        <!-- <img src="../images/roundBoard/logo_kjhs.png" alt="한국초중고등학교유도연맹"> -->
        <!-- <img src="../images/roundBoard/logo_kujf.png" alt="한국대학유도연맹"> -->
        <!-- <img src="../images/roundBoard/logo_sja.png" alt="서울특별시유도회"> -->
        <!-- <img src="../images/roundBoard/logo_kwf.png" alt="대한레슬링협회"> -->
      </p>
    </div>
    <!-- E: head_info -->
		<div class="txt_box">
      <p class="info_txt fl">※경기순서는 경기운영시 일부 변경 될 수 있습니다.</p>
      <p class="info_txt fr">※<strong>부전승</strong>의 경우 진행사항표에 표기되지 않습니다.</p>
    </div>
    <!-- S : 리스트 -->
    <table class="table-list">
      <caption>순서 리스트</caption>
      <colgroup>
			  <!--<col width="*" />-->
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
      </colgroup>
      <thead>
        <tr>
				  <!--<th scope="col">강수</th>-->
          <th scope="col">강수</th>
          <th scope="col">구분</th>
          <th scope="col">소속/체급</th>
          <th scope="col">경기번호</th>
          <th scope="col">소속</th>
          <th scope="col">대결선수</th>
          <th scope="col">VS</th>
          <th scope="col">대결선수</th>
          <th scope="col">소속</th>
          <th scope="col">진행사항</th>
        </tr>
      </thead>
      <tbody>
        <%
          If Not (Rs.Eof Or Rs.Bof) Then
						k = 1
            Do Until Rs.Eof 
        %>

        <tr>
					<!--<td><%=k%></td>-->
          <td><%=Rs("NowRoundNM")%></td>
          <td><%=Rs("GroupGameGbNM")%></td>
          <td><%=Rs("TeamGBNM")%>&nbsp;<%=Rs("LevelNM")%></td>
					<td><%=Rs("StadiumNumber")%>-<%=Rs("TempNum")%></td>
					<!--
          <td><%If Rs("GroupGameGb") = "sd040001" Then %><%=Rs("GameNum")%><%Else%><%=Rs("GroupGameNum")%><%End If%></td>
					-->
          <td><%=Rs("LSchoolName")%></td>
          <td><%=Rs("LUserName")%></td>
          <td>VS</td>
          <td><%=Rs("RUserName")%></td>
          <td><%=Rs("RSchoolName")%></td>
          <td><%=k%>
					<%If Rs("GameStatus") = "sd050001" Then %>
						<span class="playing">진행중</span>
					<%ElseIf Rs("LResult") = "sd019006" Or Rs("RResult") = "sd019006" Then %>
						부전승
					<%Else%>
					<%End If%></td>
        </tr>
        <%        
							k = k + 1
              Rs.MoveNext
            Loop 
          End If 
        %>
      </tbody>
    </table>
    <!-- E : 리스트 -->
  <div class="footer_ad">
      <div class="left_txt">
        <p class="txt"><strong>[대진표 및 경기결과]</strong>를 모바일에서 쉽게 확인하세요!</p>
        <span class="caution">선수무료가입</span>
      </div>
      <ul class="btn_box">
        <li><a href="#"><img src="../images/roundBoard/google_play_btn.png" alt="구글플레이"></a></li>
        <li><a href="#"><img src="../images/roundBoard/app_store_btn.png" alt="앱스토어"></a></li>
      </ul>
      <div class="right_txt">
        <span class="caution">지도자용가입</span>
        <p class="txt txt_2">경기장 내 스포츠다이어리 직원을 찾아주세요.</p>
      </div>
    </div>
    </div>
  <section>


<form name="frm" method="post" >
<input type="hidden" name="GameTitleIDX" value="<%=GameTitleIDX%>">
<input type="hidden" name="StadiumNumber" value="<%=StadiumNumber%>">
<input type="hidden" name="GameDay" value="<%=GameDay%>">
</form>
<script>
 setInterval(function(){ chk_frm(); }, 9000);

function chk_frm(){
  var f = document.frm;
//	f.target = "fPage";
  f.action = "RoundBoard_New2.asp";
  f.submit();
}
</script>
<script src="../js/round_board.js"></script>
