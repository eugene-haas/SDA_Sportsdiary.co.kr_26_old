<!--#include file="../Library/ajax_config_26.asp"-->
<%
  Check_Login()
  
  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  iteamgb = fInject(Request("isub_iteamgb"))
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  EnterType =  Request.Cookies(SportsGb)("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  PlayerIDX = ""
  TxtName = ""
	iSchGubun = ""
	iFnd_KeyWord = ""
	iGameTitleIDX = ""
  
  isub_iteamgbNm = fInject(Request("isub_iteamgbNm"))

  Dim iSDate
  iSDate = MID(SDate,1,4)

	Dim iEDate
  iEDate = MID(EDate,1,4)

  'Team = decode(Team,0)
  'PlayerIDX = decode(PlayerIDX,0)

  'if GroupGameGb = "sd040001" then
  '
  'elseif GroupGameGb = "" then
  '
  'else
  '  Level = ""
  'end if

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  Dim LRsCnt1, iGameTitleIDX1, iGameTitleIDXCnt1, iGameTitleName1, iGameS1, iGameE1, iiGameTitleIDXCntTotal1
  LRsCnt1 = 0
  iiGameTitleIDXCntTotal1 = 0

  iType = "31"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & iSDate & "','" & iEDate & "','" & iteamgb & "','" & PlayerIDX & "','" & iEnterType & "','" & iGameTitleIDX & "','" & iSchGubun & "','" & iFnd_KeyWord & "','','','','',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then 
%>
<table class="rank-tb">
	<thead>
		<tr>
			<th>순위</th>
			<th>이름(소속)</th>
			<th>경기수</th>
			<th>승(勝)</th>
			<th>패(敗)</th>
			<th>승률</th>
		</tr>
	</thead>
	<tbody>
<%
    Do Until LRs.Eof
      
        LRsCnt1 = LRsCnt1 + 1
        'iGameTitleIDX1 = iGameTitleIDX1&"^"&LRs("GameTitleIDX")&""
 %>        
        <tr>
			    <td><%=LRs("iRank") %></td>
					<td class="belong">
				    <a href="javascript:;" onclick="javascript:iMainTotal('<%=iSportsGb %>','<%=SDate %>','<%=EDate %>','','<%=encode(LRs("PlayerIDX"),0) %>','1^2^3^4');" data-toggle="modal" data-target=".modal-player-profile">
						  <p><%=LRs("UserName") %></p>
							<span><%=LRs("TeamNm") %></span>
						</a>
			    </td>
			    <td><%=LRs("TotalCnt") %></td>
			    <td><%=LRs("WinCnt") %></td>
			    <td><%=LRs("LoseCnt") %></td>
			    <td><%=LRs("ResultPercent") %>%</td>
		    </tr>
<%
      LRs.MoveNext
    Loop
%>
  </tbody>
</table>
<%
  End If 

  LRs.Close


  Dbclose()


  'if iGameTitleIDX1 <> "" then
  '  iGameTitleIDX1arr = Split(iGameTitleIDX1, "^")
  'end if
  '
  'if iGameTitleIDXCnt1 <> "" then
  '  iGameTitleIDXCnt1arr = Split(iGameTitleIDXCnt1, "^")
  'end if
  '
  'if iGameTitleName1 <> "" then
  '  iGameTitleName1arr = Split(iGameTitleName1, "^")
  'end if
  '
  'if iGameS1 <> "" then
  '  iGameS1arr = Split(iGameS1, "^")
  'end if
  '
  'if iGameE1 <> "" then
  '  iGameE1arr = Split(iGameE1, "^")
  'end if
  '
  'For i = 1 To LRsCnt1 Step 1
  '  iiGameTitleIDXCntTotal1 = iiGameTitleIDXCntTotal1 + CInt(iGameTitleIDXCnt1arr(i))
  'Next

%>
