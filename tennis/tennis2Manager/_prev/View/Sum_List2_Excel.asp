<!DOCTYPE HTML>
<html lang="ko">
<head>
  <title>SportsDiary Admin</title>
  <meta charset="utf-8" />
  <script src="/Manager/Js/jquery-1.12.2.min.js"></script>
  <script src="/Manager/js/jquery-migrate-1.4.1.min.js"></script>
  <!--<script src="/Manager/js/library/html5shiv.min.js"></script>-->
  <script src="/Manager/js/library/selectivizr-min.js"></script>
  <!--상태바 관련-->
  <script type="text/javascript" src="/Manager/Script/common.js"></script>
  <script type="text/javascript" src="/Manager/Script/popup.js"></script>
  <!--상태바 관련-->
  <script type="text/javascript" src="/Manager/Js/js.js"></script>
</head>
<!--#include virtual="/Manager/Library/config.asp"-->
<%
  If Request.Cookies("UserID") = "" Then
    Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
    Response.End
  End If 
%>
<%
  GameTitleIDX = fInject(Request("GameTitleIDX"))

  'Response.Write GameTitleIDX
  'Response.End
  If GameTitleIDX = "" Then 
    Response.Write "<script>alert('잘못된 경로로 접근하셨습니다.');history.back();</script>"
    Response.End
  Else
    GSQL = "SELECT GameTitleName "
    GSQL = GSQL&" FROM Sportsdiary.dbo.tblGameTitle "
    GSQL = GSQL&" WHERE DelYN='N'" 
    GSQL = GSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

    Set GRs = Dbcon.Execute(GSQL)

    If Not(GRs.Eof Or GRs.Bof) Then 
      GameTitleName = GRs("GameTitleName")
    Else
      Response.Write "<script>alert('잘못된 경로로 접근하셨습니다.');history.back();</script>"
      Response.End
    End If 
    GRs.Close
    Set GRs = Nothing     
  End If 

	fileNm = GameTitleName&" 단체전 참가신청 현황"
	
	'Response.Buffer = True
	'Response.ContentType = "application/excel"
	'Response.AddHeader "content-disposition", "inline; filename=" & fileNm
	
	Response.Buffer = True
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-disposition","attachment;filename=" & fileNm & ".xls"

%>
<!--대회 타이틀 S-->
<table class="match_title_table" style="width: 99%;margin: 0 auto; margin-top: 8px; margin-bottom: 21px;">
  <tr>
    <td colspan="11" style="font-size: 24px; font-weight: bold; text-align: center;"><span style="text-decoration: underline;"><%=GameTitleName%></span></td>
  </tr>
  <tr style="font-size: 20px; font-weight: bold; text-align: center;">
    <td colspan="11">단체전 참가신청 현황</td>
  </tr>
<!--대회 타이틀 E-->
<table class="match_stat_table" style="width: 99%;margin: 0 auto; border: 1px solid #333;">
  <tr style="border-bottom: 1px solid #333; background-color: #ddd; color: #000; border-bottom: 3px double #333; font-weight: bold;">
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;">&nbsp;</td>
    <%
      TSQL = "SELECT TeamGbNm FROM  Sportsdiary.dbo.tblTeamgbinfo WHERE SportsGb='"&Request.Cookies("SportsGb")&"' order by OrderBy ASC "
      Set TRs = Dbcon.Execute(TSQL)
      If Not(TRs.Eof Or TRs.Bof) Then 
        Do Until TRs.Eof
        '해당 종별 SQL
    %>
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=TRs("TeamGbNM")%></td>
    <%
          TRs.MoveNext
        Loop 
      End If 
    %>
  </tr>
  <%
    '시도 SQL
    ASQL = "SELECT Sido, SidoNm FROM Sportsdiary.dbo.tblSidoinfo "
    ASQL = ASQL&" WHERE SportsGb='"&Request.Cookies("SportsGb")&"'"
    ASQL = ASQL&" AND DelYN='N'"
    ASQL = ASQL&" AND Sido<>'18'"

    Set ARs = Dbcon.Execute(ASQL)

    If Not (ARs.Eof Or ARs.Bof) Then 
      
      Do Until ARs.Eof      
      i = 1 
  %>
  <tr style="border-bottom: 1px solid #333;">
    <td style="text-align: center; font-weight: bold; padding-top: 10px; padding-bottom: 10px; border-left: 1px solid #333; border-right: 1px solid #333; width: 80px;"><%=ARs("SidoNm")%></td>
    <%
      TSQL = "SELECT TeamGb,TeamGbNm FROM  Sportsdiary.dbo.tblTeamgbinfo WHERE SportsGb='"&Request.Cookies("SportsGb")&"' order by OrderBy ASC "
      Set TRs = Dbcon.Execute(TSQL)
      
      If Not(TRs.Eof Or TRs.Bof) Then 
        Do Until TRs.Eof
          TSQL2 = "SELECT TI.TeamNm AS TeamNm "
          TSQL2 = TSQL2&" FROM Sportsdiary.dbo.tblRGameGroupSchoolMaster PM "
          TSQL2 = TSQL2&" JOIN Sportsdiary.dbo.tblTeaminfo TI "
          TSQL2 = TSQL2&" ON PM.Team = TI.Team "
          TSQL2 = TSQL2&" WHERE PM.gametitleidx='"&GameTitleIDX&"'"
          TSQL2 = TSQL2&" AND PM.groupgamegb='"&SportsCode&"040002'"
          TSQL2 = TSQL2&" AND PM.DelYN='N'"
          TSQL2 = TSQL2&" AND TI.sido='"&ARs("Sido")&"'"    
          TSQL2 = TSQL2&" AND PM.TeamGb = '"&TRs("TeamGb")&"'"

          Set TRs2 = Dbcon.Execute(TSQL2)
    %>
    <td  style="text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;">
    <%
      If Not(TRs2.Eof Or TRs2.Bof) Then 
        Do Until TRs2.Eof 
            Response.Write TRs2("TeamNm")&"<br>"    
            If i = 1 Then 
              SumCnt1 = SumCnt1 + 1
            ElseIf i = 2 Then 
              SumCnt2 = SumCnt2 + 1
            ElseIf i = 3 Then 
              SumCnt3 = SumCnt3 + 1
            ElseIf i = 4 Then 
              SumCnt4 = SumCnt4 + 1
            ElseIf i = 5 Then 
              SumCnt5 = SumCnt5 + 1
            ElseIf i = 6 Then 
              SumCnt6 = SumCnt6 + 1
            ElseIf i = 7 Then 
              SumCnt7 = SumCnt7 + 1
            ElseIf i = 8 Then 
              SumCnt8 = SumCnt8 + 1
            ElseIf i = 9 Then 
              SumCnt9 = SumCnt9 + 1
            ElseIf i = 10 Then 
              SumCnt10 = SumCnt10 + 1
            End If 
          TRs2.MoveNext
        Loop 
      End If 
    %>
    </td>   
    <%
            i = i + 1 
          TRs.MoveNext
        Loop  
      End If 
    %>
  </tr>
  <%
        
        ARs.MoveNext
      Loop 
    End If 
  %>
  <!--종별 합계-->
  <tr class="stat_total" style="background-color: #ddd; border-top: 3px double #333; border-bottom: 1px solid #333">
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;">계</td>
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt1%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt2%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt3%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt4%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt5%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt6%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt7%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt8%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt9%></td>   
    <td style="font-weight: bold; text-align: center; padding-top: 6px; padding-bottom: 6px; border-left: 1px solid #333; border-right: 1px solid #333;"><%=SumCnt10%></td>    
  </tr>
  <!--종별 합계-->
  <%
    SumCnt = SumCnt1 + SumCnt2 + SumCnt3 + SumCnt4 + SumCnt5 + SumCnt6 + SumCnt7 + SumCnt8 + SumCnt9 + SumCnt10
  %>
  <!-- 총합계-->
  <tr class="stat_total_last" style="border-bottom: none;">
    <td colspan="11" align="right" style="padding-top: 10px; padding-bottom: 10px;"><%=SumCnt%>팀</td>    
  </tr>
  <!-- 총합계-->
</table>
<%
Response.Flush
Response.End

%>