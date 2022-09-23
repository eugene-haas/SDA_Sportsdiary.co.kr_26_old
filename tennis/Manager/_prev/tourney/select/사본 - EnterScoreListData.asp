<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
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
        <td  >전체</td>
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
            end if

            divId="" & GRs("RGameLevelidx") &"_"& GRs("GroupGameNum")&"_"& GRs("GameNum") 


           ' Response.End
%>
<!--  리스트 출력  -->
    <tr>
        <td >
         <form name="form_<%=divId %>" id="form_<%=divId %>" action="select/EnterScore.asp">
            <input type=checkbox name="check_<%=divId %>" id="check_<%=divId %>" onclick="EnterScorePrint('<%=divId %>','check','Enter_Score_Print');" />
            <input type=hidden id="input_<%=PlayerResultIdx %>" name="input_<%=PlayerResultIdx %>" value="<%=PlayerResultIdx %>" />
            <input type=hidden id="input_<%=SportsGb %>" name="input_<%=SportsGb %>" value="<%=SportsGb %>" />
            <input type=hidden id="input_<%=GameTitleIDX %>" name="input_<%=GameTitleIDX %>" value="<%=GameTitleIDX %>" />
            <input type=hidden id="input_<%=RGameLevelidx %>" name="input_<%=RGameLevelidx %>" value="<%=RGameLevelidx %>" />
            <input type=hidden id="input_<%=TeamGb %>" name="input_<%=TeamGb %>" value="<%=TeamGb %>" />
            <input type=hidden id="input_<%=Sex %>" name="input_<%=Sex %>" value="<%=Sex %>" />
            <input type=hidden id="input_<%=Level %>" name="input_<%=Level %>" value="<%=Level %>" />
            <input type=hidden id="input_<%=GroupGameGb %>" name="input_<%=GroupGameGb %>" value="<%=GroupGameGb %>" />
            <input type=hidden id="input_<%=GameType %>" name="input_<%=GameType %>" value="<%=GameType %>" />
            <input type=hidden id="input_<%=GRs("GroupGameNum") %>" name="input_<%=GRs("GroupGameNum") %>" value="<%=GRs("GroupGameNum") %>" />
            <input type=hidden id="input_<%=GRs("GameNum") %>" name="input_<%=GRs("GameNum") %>" value="<%=GRs("GameNum") %>" />
        </form>
        </td>
        <td ><span> <%=s_StadiumNumber %>경기장</span></td>
        <td ><span> <%=s_GameNum %>경기</span>  </td>
        <td ><span><%=iNowRoundNM %></span></td>
        <%if GroupGameGb="sd040001" then%>
        <td ><%=LPlayerName %></td>
        <td ><%=LSchoolName %></td>
        <td >vs</td>
        <td ><%=RPlayerName %></td>
        <td ><%=RSchoolName %></td>
        <%else %>
        <td ><%=LSchoolName %></td>
        <td >vs</td>
        <td ><%=RSchoolName %></td>
        <%end if  %>
        <td><a class="btn-list type1" href="javascript:EnterScorePrint('<%=divId %>','one','');" >기록지출력</a></td>
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

 