<!--#include file="../Library/ajax_config.asp"-->
<%
  Check_Login()

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  GroupGameGb = fInject(Request("GroupGameGb"))
  TeamGb = fInject(Request("TeamGb"))
  Level = fInject(Request("Level"))
  TxtName = fInject(Request("TxtName"))

 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가

  PlayerIDX = ""

  isub_iteamgbNm = fInject(Request("isub_iteamgbNm"))
  isub_ilevelnameNm = fInject(Request("isub_ilevelnameNm"))
  isub_ipointtypeNm = fInject(Request("isub_ipointtypeNm"))

  Dim iYearSDate
  iYearSDate = MID(SDate,1,4)

  'Team = decode(Team,0)
  'PlayerIDX = decode(PlayerIDX,0)

  if GroupGameGb = "sd040001" then

  elseif GroupGameGb = "" then

  else
    Level = ""
  end if

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  Dim LRsCnt1, iGameTitleIDX1, iGameTitleIDXCnt1, iGameTitleName1, iGameS1, iGameE1, iiGameTitleIDXCntTotal1
  LRsCnt1 = 0
  iiGameTitleIDXCntTotal1 = 0

  iType = "11"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','','" & TxtName & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<h2>
	<span><%=iYearSDate %>년</span> / <span><%=isub_iteamgbNm %></span> / <span><%=isub_ilevelnameNm %></span> / <span><%=isub_ipointtypeNm %></span>
</h2>
<!-- S: match-list -->
<div class="match-list">
	<table class="rank-tb">
		<thead>
			<tr>
				<th>순위</th>
				<th></th>
				<th>이름(소속)</th>
				<th><%=isub_ipointtypeNm %></th>
				<th>총경기수</th>
				<th>득점률</th>
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
				  <td class="profile-img">
					  <span class="img-round">
              <% if LRs("PhotoPath") = "" then  %>
              <img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt="" />
              <% else %>
              <img src="../<%=MID(LRs("PhotoPath"),4) %>" alt="" />
              <% end if %>
					  </span>
				  </td>
				  <td class="belong">
					  <!--<a href="#" data-toggle="modal" data-target=".modal-record-rank">-->
            <a href="javascript:;" onclick="javascript:myPointChart('<%=encode(LRs("PlayerIDX"),0) %>','<%=LRs("UserName") %>','<%=LRs("Teamnm") %>','<%=LRs("PhotoPath") %>')" data-toggle="modal" data-target=".modal-record-rank">
						  <p><%=LRs("UserName") %></p>
						  <span><%=LRs("Teamnm") %></span>
					  </a>
				  </td>
				  <td><%=LRs("ResultCnt") %></td>
				  <td><%=LRs("TotalGameCnt") %></td>
				  <td><%=LRs("ResultPercent") %>%</td>
			  </tr>
<%
      LRs.MoveNext
    Loop
%>
    </tbody>
	</table>
</div>
<!-- E: match-list -->
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
