<!--#include virtual="/Manager/Library/config.asp"-->
<!-- #include file="./include/config.asp" -->
<%

  GameTitleIDx = fInject(Request("GameTitleIDx"))
  TeamGb       = fInject(Request("TeamGb"))
  Level        = fInject(Request("Level"))
  GroupGameGb  = fInject(Request("GroupGameGb"))
  Count = 1

  NowYear = Year(Now())
  NowMonth = AddZero(Month(Now()))
  NowDay = AddZero(Day(Now()))
  NowHour = AddZero(Hour(Now))
  NowMinute = AddZero(Minute(Now))
  
  'UnearmWin sd042001일반
  'UnearmWin sd04200부전일반
  'LeftRightGb sd033001 왼쪽
  'LeftRightGb sd033002 오른쪽

  '대회정보 선택==========================================================================================
  TSQL = "SELECT "
  TSQL = TSQL&" GameTitleName " 
  TSQL = TSQL&" ,GameS "
  TSQL = TSQL&" ,GameE "
  TSQL = TSQL&" ,GameArea"
  TSQL = TSQL&" ,HostCode AS HostCode"
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
  LevelSQL ="SELECT "
  LevelSQL = LevelSQL&" LevelNm"
  LevelSQL = LevelSQL&" ,SportsDiary.dbo.Fn_TeamGbNm('"&Request.Cookies("SportsGb")&"',TeamGb) As TeamGbNm "
  LevelSQL = LevelSQL&" FROM sportsdiary.dbo.tblLevelInfo "
  LevelSQL = LevelSQL&" WHERE DelYN='N'"
  LevelSQL = LevelSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
  If GroupGameGb = SportsCode&"040001" Then 
    LevelSQL = LevelSQL&" AND Level = '"&Level&"'"
  Else
    LevelSQL = LevelSQL&" AND TeamGb = '"&TeamGb&"'"
  End If

  Set LevelRs = Dbcon.Execute(LevelSQL)

  If Not(LevelRs.Eof Or LevelRs.Bof) Then 
    TeamGbNm = LevelRs("TeamGbNm")
    
    If GroupGameGb = SportsCode&"040001" Then 
      GroupGameNm = "개인전"
      LevelNm = LevelRs("LevelNm")
    ElseIf GroupGameGb = SportsCode&"040002" Then 
      GroupGameNm = "단체전"
    End If 
    
    
      
  End If 

  '체급정보 선택==========================================================================================  

  '참가선수 카운팅========================================================================================
  If GroupGameGb = SportsCode&"040001" Then
    CSQL = "SELECT "
    CSQL = CSQL&" Count(RplayerIDX) AS Cnt"
    CSQL = CSQL&" FROM SportsDiary.dbo.tblRPlayer"
    CSQL = CSQL&" WHERE DelYn = 'N'"
    CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
    CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
    CSQL = CSQL&" AND Level = '"&Level&"'"
    CSQL = CSQL&" AND GroupGameGb = '"&GroupGameGb&"'"

		'Response.Write CSQL
  Else

  CSQL = "SELECT "
  CSQL = CSQL&" Count(RgameGroupSchoolidx) AS Cnt"
  CSQL = CSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
  CSQL = CSQL&" WHERE DelYn = 'N'"
  CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
  CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"

  End If

  Set CRs = Dbcon.Execute(CSQL)

  LevelCnt = CRs("Cnt")
  '참가선수 카운팅========================================================================================

  '개인전 
  If GroupGameGb = SportsCode&"040001" Then
    USQL = " SELECT PlayerIDX, UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
    USQL = USQL&" FROM SportsDiary.dbo.tblRPlayer"
    USQL = USQL&" WHERE DelYN = 'N'"
    USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
    USQL = USQL&" AND GroupGameGb = '" & GroupGameGb & "'"
    USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
    USQL = USQL&" AND Level = '" & Level & "'"
    USQL = USQL&" AND DelYN = 'N'"
    USQL = USQL&" ORDER BY PlayerNum" 
  Else
    USQL = " SELECT '' AS PlayerIDX, '' AS UserName, Team, TeamDtl, '' AS Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
    USQL = USQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
    USQL = USQL&" WHERE DelYN = 'N'"
    USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
    USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
    USQL = USQL&" AND DelYN = 'N'"
    USQL = USQL&" ORDER BY SchNum"
  End If


  Set URs = Dbcon.Execute(USQL)
  If Not(URs.Bof Or URs.Eof) Then

    Arr_Player = URs.Getrows()
    Cnt_Arr_Player = UBound(Arr_Player,2)
    ReDim ReturnSTR(Cnt_Arr_Player)

    For i = 0 To Cnt_Arr_Player
      ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
    Next
  End If

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
  <%
    If LevelCnt > 0 Then 

    '대진표의 높이
    Main_Width  = "1100"
    Main_Height = "750" 
  %>
  <div class="header">
    <div class="attend">[경기대진표] <span>참가선수: <%=UBOUND(Arr_Player,2) + 1%>명</span></div>
    <div class="title">
      <h1><%=GameTitleName%></h1>
      <p class="date"><%=GameS%> ~ <%=GameE%> / <%=GameArea%></p>
      <p class="team"><%=TEamGbNm%> > <%=GroupGameNm%> <%=LevelNm%></p> 
    </div>
  </div>
  <%
    End If
  %>
  <!-- E: header -->
  <!-- S: main -->
  <div class="main clearfix league">
    <div class="line_area">
    <%
      If Cnt_Arr_Player <> "" Then  
    %>
      <table class="table">
        <tbody>
          <tr>
            <th class="team">구분</th>
            <%
              '해당되는 선수수만큼 Loop
              For i = 0 To Cnt_Arr_Player
            %>
            <th>
              <div class="number">
                <!--<span class="round"><%=i+1%></span>-->
              </div>
              <div class="player">
              <%If GroupGameGb = SportsCode&"040001" Then%>
                <span class="name"><%=Arr_Player(1,i)%></span>
                <span class="school"><%=Arr_Player(5,i)%></span>
              <%Else%>
                <span class="name"><%=Arr_Player(5,i)%></span>
              <%End If%>
              </div>
            </th>
            <%
              Next
            %>
          </tr>
          <%
            For i = 0 To Cnt_Arr_Player
          %>  

          <tr>
            <th>
              <div class="number">
                <!--<span class="round"><%=i+1%></span>-->
              </div>
              <div class="player">
              <%If GroupGameGb = SportsCode&"040001" Then%>
                <span class="name"><%=Arr_Player(1,i)%></span>
                <span class="school"><%=Arr_Player(5,i)%></span>
              <%Else%>
                <span class="name"><%=Arr_Player(5,i)%></span>
              <%End If%>
              </div>
            </th>

            <%
              For j = 0 To Cnt_Arr_Player 

                If i <> j  Then 
            %>

            <td>
                  <%If GroupGameGb = SportsCode&"040001" Then%>
                    <span><%=Arr_Player(1,i)%></span>
                    <span>VS</span>
                    <span><%=Arr_Player(1,j)%></span>
                  <%Else%>
                    <span><%=Arr_Player(5,i)%></span>
                    <span>VS</span>
                    <span><%=Arr_Player(5,j)%></span>
                  <%End If%>

                  <%
                    If i < j Then
                      ReturnSTR(i) = ReturnSTR(i) & "," & Count
                      ReturnSTR(j) = ReturnSTR(j) & "," & Count
                        
                  %>
                    <!--<BR>경기순번 : <%=Count%>-->
                  <%
                      Count = Count + 1
                    End If
                  %>
            </td>
            <%
                Else
            %>
            <td class="self">
              <img src="../Images/print/line_league.png" alt>
            </td>
            <%
                End If
              Next
            %>
          </tr>
          <%
            Next
          %>
        </tbody>
      </table>
      <%
        End If
      %>
    </div>
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
      Report Created : <%=NowYear%>년 <%=NowMonth%>월 <%=NowDay%>일 <%=NowHour%>:<%=NowMinute%>
    </div>
  </div>
  <!-- E: footer -->
</body>
</html>