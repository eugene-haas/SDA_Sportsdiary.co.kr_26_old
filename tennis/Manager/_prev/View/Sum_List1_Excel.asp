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

	fileNm = GameTitleName&" 개인전 참가신청 현황"
	
	'Response.Buffer = True
	'Response.ContentType = "application/excel"
	'Response.AddHeader "content-disposition", "inline; filename=" & fileNm
	
	Response.Buffer = True
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-disposition","attachment;filename=" & fileNm & ".xls"
%>

<!--대회 타이틀 S-->
<table class="match_title_table" style="width: 99%; margin: 0 auto; margin-top: 8px; margin-bottom: 21px;">
  <tr>
    <td colspan="4" style="font-size: 24px; font-weight: bold; text-align: center;"><span style="text-decoration: underline;"><%=GameTitleName%></span></td>
  </tr>
  <tr style="font-size: 20px; font-weight: bold; text-align: center;">
    <td colspan="4" style="height: 50px; vertical-align: top;">개인전 참가신청 현황</td>
  </tr>
<!--대회 타이틀 E-->
  <tr style="font-weight: bold; border-bottom: 3px double #333; background-color: #ddd;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border: 1px solid #333;">종별</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border: 1px solid #333;">구분</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border: 1px solid #333;">체급</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border: 1px solid #333; position: relative; left: -1px;">참가인원</td>
  </tr>
  <%
    JSQL = "SELECT PTeamGbNm, TeamGbNm, TeamGb FROM Sportsdiary.dbo.tblteamgbinfo WHERE sportsgb='"&Request.Cookies("SportsGb")&"' Order By Orderby ASC"

    Set JRs = Dbcon.Execute(JSQL)

    If Not(JRs.Bof Or JRs.Eof) Then 
      TotSum = "0"
      Do Until JRs.Eof 
  %>
  <tr>
    <!--종별이름-->
    <td style="font-weight: bold; text-align: center; border: 1px solid #333;"><%=JRs("PTeamGbNm")%></td>
    <!--종별구분-->
    <td style="font-weight: bold; text-align: center; border: 1px solid #333;"><%=JRs("TeamGbNm")%></td>
    <!--체급정보-->
    <td style="position: relative; top: 1px;">
      <table class="match_weight_table" style="width: 100.1%; border-bottom: 1px solid #333;"> 
        <!--종별체급리스트-->
        <tr style="border-bottom: 1px dotted #333; text-align: center;">
          <%
            LSQL = "SELECT Sportsdiary.dbo.FN_Levelnm('"&Request.Cookies("SportsGb")&"',teamgb,level) AS LevelNM "
            LSQL = LSQL&" FROM Sportsdiary.dbo.tblRgameLevel "
            LSQL = LSQL&" WHERE Delyn='N'"
            LSQL = LSQL&" AND GroupGamegb='"&SportsCode&"040001'"
            LSQL = LSQL&" AND Teamgb='"&JRs("TeamGb")&"'"
            LSQL = LSQL&" AND GameTitleidx='"&GameTitleIDX&"'"
            LSQL = LSQL&" ORDER By Level "
            Set LRs = Dbcon.Execute(LSQL)

            If Not(LRs.Eof Or LRs.Bof) Then 
              i = 1
              Do Until LRs.Eof 
          %>
          <td style="border-right: 1px dotted #000; height: 40px; width: 9%;"><%=LRs("LevelNm")%></td>
          <%		
									i = i + 1
                LRs.MoveNext
              Loop 
						Else
							i = 1
            End If 
          %>
          <%
            If i < 10 Then 
              For k = i To 9
          %>
          <td style="width: 9%; height: 40px; border-right: 1px dotted #333;">&nbsp;</td>
          <%		
              Next
            End If 
          %>
        </tr>
        <!--종별체급합계-->
        <tr style="border-bottom: 1px dotted #000; text-align: center;">
          <%
            LSQL2 = "SELECT Level "
            LSQL2 = LSQL2&" FROM Sportsdiary.dbo.tblRgameLevel "
            LSQL2 = LSQL2&" WHERE Delyn='N'"
            LSQL2 = LSQL2&" AND GroupGamegb='"&SportsCode&"040001'"
            LSQL2 = LSQL2&" AND Teamgb='"&JRs("TeamGb")&"'"
            LSQL2 = LSQL2&" AND GameTitleidx='"&GameTitleIDX&"'"
            LSQL2 = LSQL2&" ORDER By Level "
            Set LRs2 = Dbcon.Execute(LSQL2)
            SumCnt = "0"
            If Not(LRs2.Eof Or LRs2.Bof) Then 
              i = 1
              Do Until LRs2.Eof 
                CntSQL = "SELECT Count(RPlayerMasterIDX) AS Cnt FROM Sportsdiary.dbo.tblRPlayerMaster WHERE DelYN='N' AND GameTitleIDX='"&GameTitleIDX&"' AND Level='"&LRs2("Level")&"' AND GroupGamegb='"&SportsCode&"040001'"
                'Response.Write CntSQL&"<br>"
                Set CRs = Dbcon.Execute(CntSQL)
          %>
          <td style="border-right: 1px dotted #000; padding-top: 10px; padding-bottom: 10px;"><%=CRs("Cnt")%></td>
          <%      SumCnt = SumCnt + CRs("Cnt")
									i = i + 1
                LRs2.MoveNext
              Loop 
						Else
							i = 1
            End If 
          %>
          <%
            If i < 10 Then 
              For k = i To 9
          %>
          <td style="height: 40px; border-right: 1px dotted #333;">&nbsp;</td>
          <%
              Next
            End If 
          %>
        </tr>
      </table>
    </td>
    <!--체급정보-->
    <!--합계-->
    <td style="text-align: center; border-left: 1px solid #333; border-right: 1px solid #333; border-bottom: 1px solid #333;"><%=SumCnt%></td>
    <%
      If JRs("TeamGb") = "11001" Then 
        Sum_11001 = SumCnt
      ElseIf JRs("TeamGb") = "11002" Then 
        Sum_11002 = SumCnt
      ElseIf JRs("TeamGb") = "21001" Then 
        Sum_21001 = SumCnt
      ElseIf JRs("TeamGb") = "21002" Then 
        Sum_21002 = SumCnt
      ElseIf JRs("TeamGb") = "31001" Then 
        Sum_31001 = SumCnt
      ElseIf JRs("TeamGb") = "31002" Then 
        Sum_31002 = SumCnt
      ElseIf JRs("TeamGb") = "41001" Then 
        Sum_41001 = SumCnt
      ElseIf JRs("TeamGb") = "41002" Then 
        Sum_41002 = SumCnt
      ElseIf JRs("TeamGb") = "51001" Then 
        Sum_51001 = SumCnt
      ElseIf JRs("TeamGb") = "51002" Then 
        Sum_51002 = SumCnt
      End If 
    %>
    <%
      TotSum = TotSum + SumCnt
    %>
  </tr>
  <%
        JRs.MoveNext
      Loop 
    End If 
  %>

  <tr style="background-color: #ddd; color: #333; border-bottom: 3px double #333;">
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; font-size: 13px; font-weight: bold; border: 1px solid #333; border-top: 0;">구분</td>
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; font-size: 13px; font-weight: bold; border: 1px solid #333; border-top: 0;">남자</td>
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; font-size: 13px; font-weight: bold; border: 1px solid #333; border-top: 0;">여자</td>
    <td style="text-align: center; padding-top: 6px; padding-bottom: 6px; font-size: 13px; font-weight: bold; border: 1px solid #333; border-top: 0;">비고</td>
  </tr>
  <tr style="border-bottom: 1px dotted #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">초등부</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_11001%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_11002%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"></td>
  </tr>
  <tr style="border-bottom: 1px dotted #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">중등부</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_21001%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_21002%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"></td>
  </tr>
  <tr style="border-bottom: 1px dotted #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">고등부</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_31001%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_31002%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"></td>
  </tr>
  <tr style="border-bottom: 1px dotted #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">대학부</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_41001%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_41002%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"></td>
  </tr>
  <tr style="border-bottom: 1px dotted #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">일반부</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_51001%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Sum_51002%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"></td>
  </tr>
  <%    
    Man_Sum = Sum_11001+Sum_21001+Sum_31001+Sum_41001+Sum_51001
    WoMan_Sum = Sum_11002+Sum_21002+Sum_31002+Sum_41002+Sum_51002
  %>
  <tr style="background-color: #ddd; color: #333; font-weight: bold; text-align: center; border-top: 3px double #333;">
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;">계</td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=Man_Sum%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=WoMan_Sum%></td>
    <td style="text-align: center; padding-top: 10px; padding-bottom: 10px; border-right: 1px solid #333;"><%=TotSum%></td>
  </tr>
</table>
