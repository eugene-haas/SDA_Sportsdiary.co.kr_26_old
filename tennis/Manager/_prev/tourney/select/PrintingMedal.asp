<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameYear = fInject(Request("Search_GameYear"))
SportsGb  =   fInject(Request("SportsGb"))
GameTitleIDX  =   fInject(Request("GameTitleIDX"))
GameTitleName   =   fInject(Request("GameTitleName"))
gametype  =   fInject(Request("game-type"))
GameDay   =   fInject(Request("GameDay"))
GroupGameGb   =  fInject(Request("game-type"))
EnterType =   fInject(Request("EnterType"))
TeamGb   =   fInject(Request("TeamGb"))

'Response.Write "<br/>GameYear:"&GameYear 
'Response.Write "<br/>SportsGb:"&SportsGb
'Response.Write "<br/>GameTitleIDX:"&GameTitleIDX
'Response.Write "<br/>GameTitleName:"&GameTitleName
'Response.Write "<br/>gametype:"&gametype
'Response.Write "<br/>GameDay:"&GameDay
'Response.Write "<br/>GroupGameGb:"&GroupGameGb
'Response.Write "<br/>TeamGb:"&TeamGb 
'Response.Write "<br/>EnterType:"&EnterType

If SportsGb <> "" Then 
    GSQL = "SELECT EnterType ,case EnterType when 'A' then '아마추어' else '엘리트' end EnterTypeNm "
    GSQL = GSQL &" FROM Sportsdiary.dbo.tblGametitle  " 
    GSQL = GSQL &" WHERE ViewState='1' AND DelYN='N' AND GameYear='"&GameYear&"' AND GameTitleIDX='"&GameTitleIDX&"'  AND SportsGb='"&SportsGb&"' GROUP BY EnterType ORDER BY EnterType DESC "

    Set GRs = Dbcon.Execute(GSQL)

    If Not(GRs.Eof Or GRs.Bof) Then 
        Do Until GRs.Eof 
            EnterType= GRs("EnterType")  
        GRs.MoveNext
        Loop 
    End If 
End If 

seq=0
%>
<head>
    <title>입상현황</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="-1">
    <link href="../css/bootstrap-theme.css" rel="stylesheet" type="text/css" />
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css" />
      <!-- bootstrap popover -->
    <link href="../css/tourney.css" rel="stylesheet" type="text/css" />
    <link href="../../css/style.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../css/print_medal.css">

    <script src="../../../webtournament/www/js/global.js"></script>
    <script src="../js/jquery-1.12.2.min.js"></script>
</head>

<script type="text/javascript">
    var pageTitle = "입상현황";
    var GameYear = "<%=GameYear %>";
    var SportsGb = "<%=SportsGb %>";
    var GameTitleIDX = "<%=GameTitleIDX %>";
    var GameTitleName = "<%=GameTitleName %>";
    var GroupGameGb = "<%=GroupGameGb %>";
    var TeamGb = "<%=TeamGb %>";
    var EnterType = "<%=EnterType %>";
    var GameDay = "<%=GameDay %>";
    var onLoad = function () {
        window.document.close();
        window.focus();
        window.print();
        window.close();
    }


</script>
<body  onload="onLoad()" id="AppBody">
<section>
<div id="content" class="background-print-img">

    <%
   strSql = "SELECT A.SportsGb,A.GameTitleIDX,Sportsdiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbName, A.TeamGb, A.GroupGameGb"
   strSql = strSql& " FROM tblRGameLevel A INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx "
   strSql = strSql& " WHERE a.SportsGb = '" &SportsGb&"'" 
   strSql = strSql& " AND a.GameTitleIDX = '" &GameTitleIDX&"'"        
   
   if GameDay<>"" then
   strSql = strSql&  " AND A.GameDay = '" &GameDay&"'"
   end if
    
   if GroupGameGb<>"" then
   strSql = strSql&  " AND A.GroupGameGb = '" &GroupGameGb&"'"
   end if

   if TeamGb<>"" then
   strSql = strSql&  " AND A.TeamGb = '" &TeamGb&"'"
   end if
    
   strSql = strSql& " AND A.DelYN = 'N'" 
   strSql = strSql& " AND B.DelYN = 'N'" 
   strSql = strSql& " GROUP BY A.SportsGb,A.GameTitleIDX,A.GroupGameGb, A.TeamGb"

    Set Rs = Dbcon.execute(strSql)
    If Not (Rs.Eof Or Rs.Bof) Then
    Do Until Rs.Eof 

    %>
    <!-- S: list_body --> 
   
     <div id="list_body" class="<% if Rs("GroupGameGb")="sd040001" then  %> <%end if %>" > 
     <%
     classdds="a4"
     if Rs("GroupGameGb")="sd040001" then 
        %>
        <div class="sub sub-main tourney container-fluid">
                <h2 class="top-navi-tit maintitle"><%=GameTitleName %></h2>
        </div>
        
        <%
     else
        classdds=""
        if seq=0 then
        %>
    <div class="sub sub-main tourney container-fluid">
            <h2 class="top-navi-tit maintitle" ><%=GameTitleName %></h2>
    </div>
        <%
        end if

     end if 
     %>

    <div class="operating-medal <%=classdds %>">
        <h3 class="top-navi-tit">
            <span class="circle_icon"></span>
            <strong><%=Rs("TeamGbName") %></strong>
            <strong>[<%=Rs("GroupGameGbName") %>]</strong>
        </h3>
        
        <table class="table table-bordered table-striped operating-medal-table" style=" text-align:center">
            <caption>검색조건 선택 및 입력</caption>
            <colgroup>
                <col width="70px" />
                <col width="70px" />
                <col width="70px" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
                <col width="*" />
            </colgroup> 
            <thead>
                <!-- <tr class="bg">
                  <td colspan="8"><span class="table-header-bg"><img src="../../images/print/table_header_bg_1280.png" alt></span></td>
                </tr> -->
                <tr class="title">
                    <th>대전방식</th>
                    <th>성별</th>
                    <th>체급</th>
                    <th><span class="gold-medal"><img src="../../../Webtournament/www/images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
                    <th><span class="silver-medal"><img src="../../../Webtournament/www/images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
                    <th><span class="bronze-medal"><img src="../../../Webtournament/www/images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
                    <th><span class="bronze-medal"><img src="../../../Webtournament/www/images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if Rs("GroupGameGb")="sd040001" then
                seq=0
                DetSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                DetSql =  DetSql& " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                DetSql =  DetSql& " GroupGameGb, TeamGb, Sex, Level"
                DetSql =  DetSql& " FROM "
                DetSql =  DetSql& "     ("
                DetSql =  DetSql& "     SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN UserName ELSE '' END AS GoldUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN UserName ELSE '' END AS SilverUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN UserName ELSE '' END AS BronzeUserName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN UserName ELSE '' END AS BronzeUserName2,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                DetSql =  DetSql& "     A.SportsGb"
                DetSql =  DetSql& "     FROM tblRGameLevel A"
                DetSql =  DetSql& "     INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                DetSql =  DetSql& "     INNER JOIN tblRPlayer C ON C.RGameLevelidx = B.RGameLevelidx AND C.PlayerIDX = B.PlayerIDX"
                DetSql =  DetSql& "     WHERE A.SportsGb = '" & Rs("SportsGb") & "'"
                DetSql =  DetSql& "     AND A.GameTitleIDX = '" & Rs("GameTitleIDX") & "'"

               if GameDay<>"" then
               DetSql =  DetSql& "  AND A.GameDay = '" & GameDay & "'"
               end if

                DetSql =  DetSql& "     AND A.TeamGb = '" & Rs("TeamGb") & "'"
                DetSql =  DetSql& "     AND B.GroupGameGb = '" & Rs("GroupGameGb") & "'"
                DetSql =  DetSql& "     AND A.DelYN = 'N'"
                DetSql =  DetSql& "     AND B.DelYN = 'N'"
                DetSql =  DetSql& "     AND C.DelYN = 'N'"
                DetSql =  DetSql& "     ) AS AA"
                DetSql =  DetSql& " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb"

                else
                seq=seq+1

                DetSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                DetSql =  DetSql& " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                DetSql =  DetSql& " GroupGameGb, TeamGb, Sex, Level"
                DetSql =  DetSql& " FROM "
                DetSql =  DetSql& "     ("
                DetSql =  DetSql& "     SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                DetSql =  DetSql& "     '' AS GoldUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                DetSql =  DetSql& "     '' AS SilverUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                DetSql =  DetSql& "     '' AS BronzeUserName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                DetSql =  DetSql& "     '' AS BronzeUserName2,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                DetSql =  DetSql& "     A.SportsGb"
                DetSql =  DetSql& "     FROM tblRGameLevel A"
                DetSql =  DetSql& "     INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                DetSql =  DetSql& "     WHERE A.SportsGb = '" & Rs("SportsGb") & "'"
                DetSql =  DetSql& "     AND A.GameTitleIDX = '" & Rs("GameTitleIDX") & "'"

               if GameDay<>"" then
               DetSql =  DetSql& "  AND A.GameDay = '" & GameDay & "'"
               end if

                DetSql =  DetSql& "     AND A.TeamGb = '" & Rs("TeamGb") & "'"
                DetSql =  DetSql& "     AND B.GroupGameGb = '" & Rs("GroupGameGb") & "'"
                DetSql =  DetSql& "     AND A.DelYN = 'N'"
                DetSql =  DetSql& "     AND B.DelYN = 'N'"
                DetSql =  DetSql& "     ) AS AA"
                DetSql =  DetSql& " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb"  

                end if

              
                %>
               <!-- <tr>
                    <td colspan=9>-->
                    <% 
                     ' Response.Write DetSql
                    %> 
                   <!-- </td>
                </tr>-->
                <%
                Set detailRs = Dbcon.execute(DetSql)
                If Not (detailRs.Eof Or detailRs.Bof) Then
                Do Until detailRs.Eof 
                %>
                <tr>    
                    <td><%=detailRs("GameType") %></td> 
                    <td class="<%=detailRs("Sex") %>"><% IF detailRs("Sex")="Man" then%>남자<%else %>여자<%end if %></td>   
                    <td><%=detailRs("LevelName") %></td>    
                    <td>        <p class="player"><%=detailRs("GoldUserName") %></p>        <p class="school"><%=mid(detailRs("GoldSCName"),1,7) %></p> </td>   
                    <td>        <p class="player"><%=detailRs("SilverUserName") %></p>      <p class="school"><%=mid(detailRs("SilverSCName"),1,7) %></p>   </td>   
                    <td>        <p class="player"><%=detailRs("BronzeUserName1") %></p>     <p class="school"><%=mid(detailRs("BronzeSCName1"),1,7) %></p>  </td>   
                    <td>        <p class="player"><%=detailRs("BronzeUserName2") %></p>     <p class="school"><%=mid(detailRs("BronzeSCName2"),1,7) %></p>  </td>   
                </tr>
                <%
                detailRs.MoveNext
                Loop 
                End If 
                 %>
            </tbody>
        </table>
    </div>
    </div>
    <!-- E: list_body -->
    <%
    Rs.MoveNext
    Loop 
    End If 
    %>
</div>
</section>
<script src="js/trans_film_rec.js"></script>
</body>



                
                    








