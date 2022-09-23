
<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameYear = fInject(Request("GameYear"))
SportsGb = fInject(Request("SportsGb"))
GameTitleIDX = fInject(Request("GameTitleIDX"))
TeamGb = fInject(Request("TeamGb"))
Sex = fInject(Request("Sex"))
Level = fInject(Request("Level"))
GroupGameGb = fInject(Request("GroupGameGb"))
GameType = fInject(Request("GameType"))
RGameLevelidx = fInject(Request("RGameLevelidx"))
EnterType = fInject(Request("EnterType"))
EnterScoreType = fInject(Request("EnterScoreType"))

GameTitleName = fInject(Request("GameTitleName"))
TeamGbNm = fInject(Request("TeamGbNm"))
LevelNm = fInject(Request("LevelNm"))
GroupGameGbNm = fInject(Request("GroupGameGbNm"))
 

 %>
<!-- S: header -->
<div class="table-list-wrap">
    <table class="table-list">
    <tbody>
        <tr class="table-top">
        <td >전체</td>
        <td >경기장</td>
        <td >경기</td>
        <td >순위</td>
       <%if GroupGameGb="sd040001" then%>
        <td >선수</td>
        <td >학교</td>
        <td >vs</td>
        <td >선수</td>
        <td >학교</td>
        <%else %>
        <td >학교</td>
        <td >vs</td>
        <td >학교</td>
        <%end if  %>
        <td >출력</td>
    </tr>
          
 <%
GSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"','playerList'"
'Response.Write    GSQL  
'Response.end 
    Set GRs = Dbcon.Execute(GSQL) 
    If Not(GRs.Eof Or GRs.Bof) Then 
    Do Until GRs.Eof 
            iPlayerResultIdx=(GRs("PlayerResultIdx"))
            iRound=(GRs("Round"))
            iNowRoundNM=(GRs("NowRoundNM"))
            iNowRound=(GRs("NowRound"))
            iTurnNum=(GRs("TurnNum")) 

            if GroupGameGb="sd040001" then
                iLPlayerIDX     =GRs("LPlayerIDX")
                iLTeam          =GRs("LTeam")
                LPlayerName	    =GRs("LPlayerName")
                LSchoolName	    =GRs("LSchoolName")

                iRPlayerIDX     =GRs("RPlayerIDX")
                iRTeam          =GRs("RTeam")
                RPlayerName	    =GRs("RPlayerName")
                RSchoolName		=GRs("RSchoolName")

                s_StadiumNumber =GRs("StadiumNumber")
                s_GameNum       =GRs("GameNum") 
            else
                iLTeam          =GRs("LTeam")
                LSchoolName	    =GRs("LSchoolName")

                iRTeam          =GRs("RTeam")
                RSchoolName		=GRs("RSchoolName")

                s_StadiumNumber =GRs("Tmp_StadiumNumber")
                s_GameNum       =GRs("GroupGameNum")

                
                iNowRound=(GRs("TotRound"))

                if iNowRound ="2" then
                    iNowRoundNM="결승"
                elseif  iNowRound ="4" then
                    iNowRoundNM="준결승"
                else
                    iNowRoundNM=iNowRound&"강"
                end if 

                 
            end if
            divId="" & GRs("RGameLevelidx") &"_"& GRs("GroupGameNum")&"_"& GRs("GameNum") 
%>
<!--  리스트 출력  -->
    <tr>
        <td>
         <form name="form_<%=divId %>" id="form_<%=divId %>" method="post" action="EnterScore_print.asp" target="popup_window"> <!---->
            <input type=checkbox name="check" id="check_<%=divId %>" onclick="EnterScorePrint('<%=divId %>','check','Enter_Score_Print');" />
            <input type=hidden id="input_printIdx<%=divId %>" name="input_printIdx" value="<%=divId %>" />
            <input type=hidden id="input_PlayerResultIdx<%=divId %>" name="input_PlayerResultIdx" value="<%=iPlayerResultIdx %>" />
            <input type=hidden id="input_SportsGb<%=divId %>" name="input_SportsGb" value="<%=SportsGb %>" />
            <input type=hidden id="input_GameTitleIDX<%=divId %>" name="input_GameTitleIDX" value="<%=GameTitleIDX %>" />
            <input type=hidden id="input_RGameLevelidx<%=divId %>" name="input_RGameLevelidx" value="<%=RGameLevelidx %>" />
            <input type=hidden id="input_TeamGb<%=divId %>" name="input_TeamGb" value="<%=TeamGb %>" />
            <input type=hidden id="input_Sex<%=divId %>" name="input_Sex" value="<%=Sex %>" />
            <input type=hidden id="input_Level<%=divId %>" name="input_Level" value="<%=Level %>" />
            <input type=hidden id="input_GroupGameGb<%=divId %>" name="input_GroupGameGb" value="<%=GroupGameGb %>" />
            <input type=hidden id="input_GameType<%=divId %>" name="input_GameType" value="<%=GameType %>" />
            <input type=hidden id="input_GroupGameNum<%=divId %>" name="input_GroupGameNum" value="<%=GRs("GroupGameNum") %>" />
            <input type=hidden id="input_GameNum<%=divId %>" name="input_GameNum" value="<%=GRs("GameNum") %>" />
            <input type=hidden id="input_EnterTypev" name="input_EnterType" value="<%=EnterType %>" />

            <input type=hidden id="input_GroupGameGbNm<%=divId %>" name="input_GroupGameGbNm" value="<%=GroupGameGbNm %>" />
            <input type=hidden id="input_TeamGbNme<%=divId %>" name="input_TeamGbNme" value="<%=TeamGbNm %>" />
            <input type=hidden id="input_LevelNm<%=divId %>" name="input_LevelNm" value="<%=LevelNm %>" />
            <input type=hidden id="input_GameTitleName<%=divId %>" name="input_GameTitleName" value="<%=GameTitleName %>" />
        </form>
        </td>
        <td ><span> <%=s_StadiumNumber %>경기장</span></td>
        <td ><span> <%=s_GameNum %>경기</span>  </td>
        <td ><span><%=iNowRoundNM %></span></td>
        <%if GroupGameGb="sd040001" then%>
        <td ><%=LPlayerName %></td>
        <td ><%=LSchoolName %></td>
        <td >vs </td>
        <td ><%=RPlayerName %></td>
        <td ><%=RSchoolName %></td>
        <%else %>
        <td ><%=LSchoolName %></td>
        <td >vs</td>
        <td ><%=RSchoolName %></td>
        <%end if  %>
        <td><a class="btn-list type1" href="javascript:EnterScorePrint('<%=divId %>','one','');" >기록지출력</a></td>
         <iframe id="Enter_Score_Print_Fr<%=divId %>" name="Enter_Score_Print_Fr<%=divId %>" class="Enter_Score_Print_Fr" src=""></iframe>
    </tr>
<!--  리스트 출력  -->
 <%
    GRs.MoveNext
    Loop 
    else
    Response.Write ""
    End If 
    GRs.Close
    SET GRs = Nothing

%>
    </tbody>
    </table>
</div>

 