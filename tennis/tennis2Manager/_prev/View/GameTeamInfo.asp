<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
  '대회번호
  GameTitleIDX = fInject(Request("GameTitleIDX"))
  '종목구분
  SportsGb     = fInject(Request.Cookies("SportsGb"))
  '협회코드
  HostCode     = fInject(Request.Cookies("HostCode"))

%>
<script type="text/javascript">
function chk_frm(){
  var f = document.frm;
  f.action = "GameTeamInfo.asp"
  f.submit();
}
</script>

<form name="frm" method="post">
<div class="loaction">
<strong>대회관리</strong> &gt; 단체전명단
</div>
  <table>
    <tr>
      <td>대회명</td>
      <td><select name="GameTitleIDX" id="GameTitleIDX" onChange="chk_frm();">
          <option value="">==대회선택==</option>
          <%
          GSQL = "		SELECT GameTitleIDX,GameTitleName "
          GSQL = GSQL&" FROM SportsDiary.dbo.tblGameTitle "
          GSQL = GSQL&" WHERE DelYN='N'"

          If SportsGb <> "" Then 
            GSQL = GSQL&" AND SportsGb = '"&SportsGb&"'"
          End If 

          If HostCode <> "" Then 
            GSQL = GSQL&" AND HostCode = '"&HostCode&"'"
            GSQL = GSQL&" AND ViewState = '1'"
          End If 

          GSQL = GSQL&" ORDER BY GameS Desc "

          Set GRs = Dbcon.Execute(GSQL)

          If Not(GRs.Eof Or GRs.Bof) Then 
            Do Until GRs.Eof 
        %>
          <option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
          <%
              GRs.MoveNext
            Loop 
          End If 
        %>
        </select></td>
    </tr>
  </table>
</form>
<%
  
  If GameTitleIDX <> "" Then 
    '단체전 여부 체크
    ChkSQL = "			SELECT Sportsdiary.dbo.FN_TeamGbNm(SportsGb,TeamGb) AS TeamGbNm,EntryCnt,Sex,RGameLevelIDX "
    ChkSQL = ChkSQL&" 	FROM tblRGameLevel WHERE DelYN='N'"
    If SportsGb <> "" Then 
      ChkSQL = ChkSQL&" 	AND SportsGb='"&SportsGb&"'"
    End If 
    
    ChkSQL = ChkSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"
    ChkSQL = ChkSQL&" AND SubString(GroupGameGb,3,6) ='040002'"

    ChkSQL = ChkSQL&" Order by TeamGb ASC "

    Set CRs = Dbcon.Execute(ChkSQL)

    If Not(CRs.Eof Or CRs.Bof) Then 
%>
<!--종별테이블 S-->
<div class="table-list-wrap">
  <!-- S : table-list -->
  <table class="table-list" style="margin-bottom: 60px;">
    <%
      Do Until CRs.Eof 
    %>
    <tr>
      <td><%=CRs("TeamGbNm")%></td>
    </tr>
    <tr>
      <td style="margin-bottom: 60px;"><table style="width: 100%;">
          <tr>
            <td style="width: 100px;">지역</td>
            <td style="width: 300px;">팀명/구분</td>
            <td style="min-width: 140px;">감독</td>
            <td style="min-width: 140px;">코치</td>
            <%
              For i = 1 To CRs("EntryCnt")
            %>
            <td style="min-width: 80px;"><%=i%></td>
            <%
              Next
              
            %>
          </tr>
          <%
          '단체전 해당 종별 학교 SELECT Start
          TeamSQL = "SELECT SportsDiary.dbo.Fn_LeaderNm(SportsGb,Team) AS LeaderNm "
          TeamSQL = TeamSQL&" ,SportsDiary.dbo.Fn_CoachNm(SportsGb,Team) AS CoachNm"
          TeamSQL = TEamSQL&" ,SportsDiary.dbo.FN_TeamSidoNm(SportsGb,Team) AS TeamSidoNm"
          TeamSQL = TEamSQL&" ,SportsDiary.dbo.FN_TeamSido(SportsGb,Team) AS TeamSido"
          TeamSQL = TeamSQL&" ,SchoolName "
          TeamSQL = TeamSQL&" ,Team "
          TeamSQL = TeamSQL&" ,Teamdtl "
          TeamSQL = TeamSQL&" , CASE WHEN Teamdtl = '0' THEN '' ELSE '(' + Teamdtl + ')' END AS TeamdtlNM "
          TeamSQL = TeamSQL&" ,Sex"
          TeamSQL = TeamSQL&" FROM tblRGameGroupSchoolMaster WHERE DelYN='N' AND GametitleIDX='"&GameTitleIDX&"'"
          TeamSQL = TeamSQL&" AND RGameLevelIDX='"&CRs("RGameLevelIDX")&"'"
          TeamSQL = TeamSQL&" ORDER BY SportsDiary.dbo.FN_TeamSido(SportsGb,Team) ASC ,SchoolName ASC"

          Set TRs = Dbcon.Execute(TeamSQL)

          If Not (TRs.Eof Or TRs.Bof) Then 
            Do Until TRs.Eof 
        %>
          <tr>
            <td><%=TRs("TeamSidoNm")%></td>
            <td><%=TRs("SchoolName")& TRs("TeamdtlNM")%></td>
            <td><%=TRs("LeaderNm")%></td>
            <td><%=TRs("CoachNm")%></td>
            <%
              '해당팀선수조회
              PSQL = "		SELECT UserName, SportsDiary.dbo.FN_LevelNm(sportsgb, Teamgb, Level) AS LevelNM, SubstituteYN"
			  PSQL = PSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "
              PSQL = PSQL&" WHERE SubString(GroupGameGb,3,6) ='040002'"
              PSQL = PSQL&" 	AND DelYN='N'"
              PSQL = PSQL&" 	AND GametitleIDX='"&GameTitleIDX&"'"
              PSQL = PSQL&" 	AND Team='"&TRs("Team")&"'"
              PSQL = PSQL&" 	AND Teamdtl='"&TRs("Teamdtl")&"'"
              PSQL = PSQL&" 	AND Sex='"&TRs("Sex")&"'"
              PSQL = PSQL&" 	AND RGameLevelIDX='"&CRs("RGameLevelIDX")&"'"
              PSQL = PSQL&" ORDER BY SubstituteYN, Level, UserName"
              'Response.Write CRs("EntryCnt")
              Set PRs = Dbcon.Execute(PSQL)
              PCnt = CInt(CRs("EntryCnt")-1)

              reDim Array_PlayerName(PCnt)
              reDim Array_LevelName(PCnt)
              reDim Array_SubstituteYN(PCnt)

              k = 0


              If Not(PRs.Eof Or PRs.Bof) Then
                Do Until PRs.Eof 
                    'Response.WRite k&"xxxxxxxx"
                    'Response.WRite PCnt&"<br>"
                    Array_PlayerName(CInt(k))  = PRs("UserName")
                    Array_LevelName(CInt(k))  = PRs("LevelNM")
					Array_SubstituteYN(CInt(k))  = PRs("SubstituteYN")
										
                  k = k + 1
                  PRs.MoveNext
                Loop 
              End If 
              k = k - 1 
              If k > PCnt Then 
                For x = k To PCnt
                  Array_PlayerName(CInt(x)) = ""       
				  Array_LevelName(CInt(x)) = ""      
				  Array_SubstituteYN(CInt(x)) = ""      
                Next                
              End If 
              For i = 0 To (PCnt)
  
            %>
            <td><%
				'후보선수 여부
				If Array_SubstituteYN(i) = "Y" Then
					Response.Write "<font color='blue'>" & Array_PlayerName(i)
					
					IF Array_LevelName(i) <>"" Then response.Write "(" & Array_LevelName(i) & ")"
					response.Write "</font>"
				Else
					Response.Write Array_PlayerName(i)
					
					IF Array_LevelName(i) <>"" Then response.Write "(" & Array_LevelName(i) & ")"
				End If
			%></td>
            <%
                
              Next
              
            %>
          </tr>
          <%
              TRs.MoveNext
            Loop 
          End If 
          '단체전 해당 종별 학교 SELECT End
        %>
        </table></td>
    </tr>
    <%
        CRs.MoveNext
      Loop 
    %>
  </table>
  <!--종별테이블 E-->
  <%
    End If 
  End If 
%>
  </table>
</div>
