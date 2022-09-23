<!--#include virtual="/Manager/Library/config.asp"-->
<!-- #include file="./include/config.asp" -->
<link rel="stylesheet" href="../css/print_supple.css">
<%
  GameTitleIDx = fInject(Request("GameTitleIDx"))
  TeamGb       = fInject(Request("TeamGb"))
  Level        = fInject(Request("Level"))
  GroupGameGb  = fInject(Request("GroupGameGb"))

  'GameTitleIDx = "44"  
  'TeamGb       = "21001"
  'Level        = "21001002"
  'GroupGameGb  = "sd040001"

  '대회정보 선택==========================================================================================
  TSQL = "SELECT "
  TSQL = TSQL&" GameTitleName " 
  TSQL = TSQL&" ,GameS "
  TSQL = TSQL&" ,GameE "
  TSQL = TSQL&" ,GameArea"
  TSQL = TSQL&" ,HostCode"
  TSQL = TSQL&" FROM Sportsdiary.dbo.tblGameTitle " 
  TSQL = TSQL&" WHERE DelYN='N'"
  TSQL = TSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

  Set TRs = Dbcon.Execute(TSQL)

  If Not(TRs.Eof Or TRs.Bof) Then 
    GameTitleName = TRs("GameTitleName")
    GameS         = TRs("GameS")
    GameE         = TRs("GameE")
    GameArea      = TRs("GameArea")
    HostCode      = TRs("HostCode")
  End If 
  '대회정보 선택==========================================================================================
  
  '체급정보 선택==========================================================================================
  If GroupGameGb = SportsCode&"040001" Then 
    LevelSQL ="SELECT "
    LevelSQL = LevelSQL&" LevelNm"
    LevelSQL = LevelSQL&" ,SportsDiary.dbo.Fn_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) As TeamGbNm "
    LevelSQL = LevelSQL&" FROM sportsdiary.dbo.tblLevelInfo "
    LevelSQL = LevelSQL&" WHERE DelYN='N'"
    LevelSQL = LevelSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
    LevelSQL = LevelSQL&" AND Level = '"&Level&"'"
  Else 

    LevelSQL ="SELECT "
    LevelSQL = LevelSQL&" '' AS LevelNm"
    LevelSQL = LevelSQL&" ,SportsDiary.dbo.Fn_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) As TeamGbNm "
    LevelSQL = LevelSQL&" FROM sportsdiary.dbo.tblRGameLevel "
    LevelSQL = LevelSQL&" WHERE DelYN='N'"
    LevelSQL = LevelSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
    LevelSQL = LevelSQL&" AND GameTitleIDx='" & GameTitleIDx & "'"
    LevelSQL = LevelSQL&" AND TeamGb='" & TeamGb & "'"
    LevelSQL = LevelSQL&" AND Level = '"&Level&"'"
  End If 

  'Response.Write LevelSQL
  Set LevelRs = Dbcon.Execute(LevelSQL)

  If Not(LevelRs.Eof Or LevelRs.Bof) Then 
    
    
    If GroupGameGb = SportsCode&"040001" Then 
      GroupGameNm = "개인전"
      TeamGbNm = LevelRs("TeamGbNm")
    ElseIf GroupGameGb = SportsCode&"040002" Then 
      GroupGameNm = "단체전"
    End If 
    
    LevelNm = LevelRs("LevelNm")
      
  End If 
  '체급정보 선택==========================================================================================  

  '참가선수 카운팅========================================================================================
    '개인전
    If GroupGameGb = SportsCode&"040001" Then 
      CSQL = "SELECT "
      CSQL = CSQL&" Count(RplayerIDX) AS Cnt"
      CSQL = CSQL&" FROM SportsDiary.dbo.tblRPlayer"
      CSQL = CSQL&" WHERE DelYn = 'N'"
      CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
      CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
      CSQL = CSQL&" AND Level = '"&Level&"'"
      CSQL = CSQL&" AND GroupGameGb = '"&GroupGameGb&"'"  
    Else 
    '단체전
      CSQL = "SELECT "
      CSQL = CSQL&" Count(RGameGroupSchoolIDX) AS Cnt"
      CSQL = CSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
      CSQL = CSQL&" WHERE DelYn = 'N'"
      CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
      CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
    End If 


  Set CRs = Dbcon.Execute(CSQL)

  LevelCnt = CRs("Cnt")
  '참가선수 카운팅========================================================================================
  

NowYear = Year(Now())
NowMonth = AddZero(Month(Now()))
NowDay = AddZero(Day(Now()))
NowHour = AddZero(Hour(Now))
NowMinute = AddZero(Minute(Now))
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><%=GroupGameNm%>_<%=TeamGbNm%>_<%=LevelNm%></title>
  <link rel="stylesheet" href="./include/css/style_print.css">
</head>
<body>
  <!-- S: header -->
  <div class="header">
    <div class="attend">[경기대진표] <span>참가선수: <%=LevelCnt%><%If GroupGameGb = SportsCode&"040001" Then%>명<%Else%>팀<%End If%></span></div>
    <div class="title">
      <h1><%=GameTitleName%></h1>
      <p class="date"><%=GameS%> ~ <%=GameE%> / <%=GameArea%></p>
      <p class="team"><%=TeamGbNm%> > <%=GroupGameNm%> <%=LevelNm%></p> 
    </div>
  </div>
  <!-- E: header -->
  <!-- S: main -->
  <div class="main clearfix match2">
    <!-- S: left_side -->
    <%
        '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
        '좌측선수정보셀렉트=========================================================

        If GroupGameGb = SportsCode&"040001" Then 
          LSQL = "SELECT top 1 "
          LSQL = LSQL&" Left(UserName,3) AS UserName"
          LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team),5) As TeamNm"
          LSQL = LSQL&" ,UnearnWin"
          LSQL = LSQL&" ,LeftRightGb"
          LSQL = LSQL&" ,WriteDate"
          LSQL = LSQL&" , CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE '(' + TeamDtl + ')' END AS TeamDtlNM"
          LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayer"
          LSQL = LSQL&" WHERE DelYn = 'N'"
          LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
          LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
          LSQL = LSQL&" AND Level = '"&Level&"'"
          LSQL = LSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
          LSQL = LSQL&" AND LeftRightGb = '"&SportsCode&"030001'"
          LSQL = LSQL&" order by RPlayerIDX "
                  
        Else 
          LSQL = "SELECT top 1" 
          LSQL = LSQL&" '' AS UserName"
          LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team),9) As TeamNm"
          LSQL = LSQL&" ,UnearnWin"
          LSQL = LSQL&" ,LeftRightGb"
          LSQL = LSQL&" ,WriteDate"
          LSQL = LSQL&" , CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE '(' + TeamDtl + ')' END AS TeamDtlNM"
          LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
          LSQL = LSQL&" WHERE DelYn = 'N'"
          LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
          LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
          LSQL = LSQL&" AND LeftRightGb = '"&SportsCode&"030001'"
          LSQL = LSQL&" order by RGameGroupSchoolIDX "
        End if
        
        Set LRs = Dbcon.Execute(LSQL)               
        
        
        WriteDate = ""          
        
        If Not(LRs.Eof Or LRs.Bof) Then 
          Do Until LRs.Eof 
            WriteDate = LRs("WriteDate")
            LTeamNm = LRs("TeamNm")
            LUserName = LRs("UserName")
            LTeamDtlNM = LRs("TeamDtlNM")
            LRs.MoveNext
          Loop 
        End If              
    %>
    <div class="left_side jc-center">
      <table class="print_player">
        <tr>
          <td><span class="player_school"><%=LTeamNm & LTeamDtlNM%></span> <%=LUserName%></td>
        </tr>
      </table>
      <!-- S: number-box -->
      <div class="number-box clearfix">
        <!-- S: round-final -->
        <table class="round round-final">
          <tr>
            <td>a-1</td>
          </tr>
        </table>
        <!-- E: round-final -->
      </div>
      <!-- E: number-box -->
    </div>
    <!-- E: left_side -->
    <!-- S: line_area -->
    <div class="line_area">
      <img src="../Images/print/line_match2.png" alt>
    </div>
    <!-- E: line_area -->
    <!-- S: right_side -->
    <%
      If GroupGameGb = SportsCode&"040001" Then 
        RSQL = "SELECT top 1 "
        RSQL = RSQL&" Left(UserName,3) AS UserName"
        RSQL = RSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team),5) As TeamNm"
        RSQL = RSQL&" ,UnearnWin"
        RSQL = RSQL&" ,LeftRightGb"
        RSQL = RSQL&" , CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE '(' + TeamDtl + ')' END AS TeamDtlNM"
        RSQL = RSQL&" FROM SportsDiary.dbo.tblRPlayer"
        RSQL = RSQL&" WHERE DelYn = 'N'"
        RSQL = RSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
        RSQL = RSQL&" AND TeamGb = '"&TeamGb&"'"
        RSQL = RSQL&" AND Level = '"&Level&"'"
        RSQL = RSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
        RSQL = RSQL&" AND LeftRightGb = '"&SportsCode&"030002'"
        RSQL = RSQL&" order by RPlayerIDX "
        'Response.Write RSQL

                
      Else 
        RSQL = "SELECT top 1" 
        'RSQL = RSQL&" Left(SchoolName,3) AS UserName"
        RSQL = RSQL&" '' AS UserName"
        RSQL = RSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('"&Request.Cookies("SportsGb")&"',TeamGb,Team),9) As TeamNm"
        RSQL = RSQL&" ,UnearnWin"
        RSQL = RSQL&" ,LeftRightGb"
        RSQL = RSQL&" , CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE '(' + TeamDtl + ')' END AS TeamDtlNM"
        RSQL = RSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
        RSQL = RSQL&" WHERE DelYn = 'N'"
        RSQL = RSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
        RSQL = RSQL&" AND TeamGb = '"&TeamGb&"'"
        RSQL = RSQL&" AND LeftRightGb = '"&SportsCode&"030002'"
        RSQL = RSQL&" order by RGameGroupSchoolIDX "

      End if
      
      Set RRs = Dbcon.Execute(RSQL)               

      If Not(RRs.Eof Or RRs.Bof) Then 
        Do Until RRs.Eof 
          RTeamNm = RRs("TeamNm")
          RUserName = RRs("UserName")
          RTeamDtlNM = RRs("TeamDtlNM")
          RRs.MoveNext
        Loop 
      End If 
    %>
    <div class="right_side jc-center">
      <table class="print_player">
        <tr>
          <td><%=RUserName%> <span class="player_school"><%=RTeamNm%></span></td>
        </tr>
      </table>
    </div>
    <!-- E: right_side -->
  </div>
  <!-- E: main -->
  <!-- S: footer -->
  <div class="footer">
    <div class="bot_logo">
    <%
      '대한유도회
      If Request.Cookies("SportsGb") = "judo" And HostCode = SportsCode&"053001" Then 
    %>
    <img src="../Images/print/logo_kja.png" alt="대한유도회">
    <%  
      '한국초중고등학교유도연맹
      ElseIf Request.Cookies("SportsGb") = "judo" And  HostCode = SportsCode&"053002" Then 
    %>
    <img src="../Images/print/logo_kjhs2.png" alt="한국초중고등학교연맹">
    <%
      '대학유도연맹
      ElseIf Request.Cookies("SportsGb") = "judo" And  HostCode = SportsCode&"053003" Then 
    %>
    <img src="../Images/print/logo_kujf.png" alt="한국대학유도연맹">
    <%
      '실업유도연맹
      ElseIf Request.Cookies("SportsGb") = "judo" And  HostCode = SportsCode&"053004" Then 
    %>
    <img src="../Images/print/logo_kijf.png" alt="한국실업유도연맹">
    <%
      Else
    %>
    <!--<img src="../Images/print/logo_kja.png" alt="대한유도회">-->
    <%
      End If 
    %>
      <!--<img src="../Images/print/logo_kja.png" alt="대한유도회">-->
      <!-- <img src="../Images/print/logo_kijf.png" alt="한국실업유도연맹"> -->
      <!-- <img src="../Images/print/logo_kujf.png" alt="한국대학유도연맹"> -->
      <!-- <img src="../Images/print/logo_kjhs.png" alt="한국중고등학교연맹"> -->
    </div>
    <div class="print_date">
      Report Created : <%=WriteDate%><!--<%=NowYear%>년 <%=NowMonth%>월 <%=NowDay%>일 <%=NowHour%>:<%=NowMinute%>-->
    </div>
  </div>
  <!-- E: footer -->
</body>
</html>