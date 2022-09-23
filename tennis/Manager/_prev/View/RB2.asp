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
  MaxStadiumNumber = "1"
  '경기장번호
  StadiumNumber = fInject(Request("StadiumNumber"))
  
  If StadiumNumber = "" Then
    StadiumNumber = "1"
  Else
    If StadiumNumber = MaxStadiumNumber Then 
      StadiumNumber = "1"
    Else
      StadiumNumber = StadiumNumber+1
    End If 

  End If 


	StadiumNumber = "2"

  GameDay = fInject(Request("GameDay"))

  NowYear = Year(Now())
  NowMonth = AddZero(Month(Now()))
  NowDay = AddZero(Day(Now()))

  If GameDay = "" Then 
'   GameDay = NowYear & "-" & NowMonth & "-" & NowDay
    GameDay = "2017-05-16"
  End If 

    '대회정보
    GameTitleIDX = "53"

   SQL = "SELECT Top 10 B.PlayerResultIDX, B.RGameLevelidx, ISNULL(SportsDiary.dbo.FN_PlayerName(B.LPlayerIDX),'미정') AS LUserName, ISNULL(SportsDiary.dbo.FN_PlayerName(B.RPlayerIDX),'미정') AS RUserName, "
   SQL = SQL&" SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName,"
   SQL = SQL&" B.GroupGameNum AS GroupGameNum, B.GameNum AS GameNum, B.LPlayerIDX, B.RPlayerIDX,"
   SQL = SQL&" B.LTeam, LTeamDtl, B.RTeam, B.RTeamDtl, B.LResult, B.RResult, B.GameStatus AS GameStatus, "
   SQL = SQL&" SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM, "
   SQL = SQL&" SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGBNM,"
   SQL = SQL&" SportsDiary.dbo.FN_LevelNm('judo',B.TeamGb,B.Level) AS LevelNM,"
   SQL = SQL&" B.Sex, B.GroupGameGb AS GroupGameGb, B.NowRoundNM AS NowRoundNM, B.CheifMain, B.CheifSub1, B.CheifSub2"
   SQL = SQL&" FROM SportsDiary.dbo.tblRgameLevel A "
   SQL = SQL&" INNER JOIN SportsDiary.dbo.tblPlayerResult B ON B.RGameLevelidx = A.RGameLevelidx "
   SQL = SQL&" AND B.GameTitleIDX = '"&GameTitleIDX&"' "
   SQL = SQL&" AND A.GameDay = '"&GameDay&"'"
   SQL = SQL&" AND B.StadiumNumber = '"&StadiumNumber&"'"
   SQL = SQL&" AND A.DelYN = 'N'"
   SQL = SQL&" AND B.DelYN = 'N'"
	 SQL = SQL&" AND ISNULL(B.TurnNum,'')<>''"
   SQL = SQL&" AND B.NowRound > 2 "
 '  SQL = SQL&" AND ISNULL(B.GameStatus,'') <> 'sd050002'"
   SQL = SQL&" AND (B.GroupGameGb = 'sd040001' OR (B.GroupGameGb = 'sd040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' )))"
   SQL = SQL&" ORDER BY B.StadiumNumber, B.TurnNum "
   
   
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
        <img src="../images/roundBoard/logo.png" alt="스포츠다이어리 유도">
      </h1>
      <p class="stadium_num"><%=StadiumNumber%>경기장</p>
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
    <!-- S : 리스트 -->
    <table class="table-list">
      <caption>순서 리스트</caption>
      <colgroup>
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
            Do Until Rs.Eof 
        %>

        <tr>
          <td><%=Rs("NowRoundNM")%></td>
          <td><%=Rs("GroupGameGbNM")%></td>
          <td><%=Rs("TeamGBNM")%>&nbsp;<%=Rs("LevelNM")%></td>
          <td><%If Rs("GroupGameGb") = "sd040001" Then %><%=Rs("GameNum")%><%Else%><%=Rs("GroupGameNum")%><%End If%></td>
          <td><%=Rs("LSchoolName")%></td>
          <td><%=Rs("LUserName")%></td>
          <td>VS</td>
          <td><%=Rs("RUserName")%></td>
          <td><%=Rs("RSchoolName")%></td>
          <td><%If Rs("GameStatus") = "sd050001" Then %><span class="playing">진행중</span><%Else%><%End If%></td>
        </tr>
        <%        
              Rs.MoveNext
            Loop 
          End If 
        %>
      </tbody>
    </table>
    <!-- E : 리스트 -->
  <p class="info_txt">※<strong>부전승</strong>의 경우 진행사항표에 표기되지 않습니다.</p>
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
  f.action = "RB2.asp";
  f.submit();
}
</script>
<script src="../js/round_board.js"></script>
