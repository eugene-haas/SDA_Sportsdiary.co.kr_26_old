<!--#include file="../Library/ajax_config_26.asp"-->
<%
	Check_Login()

	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	iGameTitleIDX = fInject(Request("iGameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  'SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = fInject(Request("SportsGb"))
  iEnterType = EnterType
 '2017-06-26 추가 


  'iPlayerIDX = "1403"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  'response.Write retext
  
  Dim LRsCnt1, iSpecialtyDtlName1, iSpecialtyDtl1
  LRsCnt1 = 0

  iType = "44"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & iGameTitleIDX & "','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<!-- S: 대회기록 best-win -->
<section class="record best-win">
  <h3>대회기록</h3>
  <h4>기술별 성공률</h4>
  <!-- S: between-chart -->
	
	<div class="between-chart container skill_succ" id="ihtmldivSkill">
		<ul class="chart-title flex">
				<li>기술명</li>
				<li>성공률</li>
		</ul>
<%
		Do Until LRs.Eof

      LRsCnt1 = LRsCnt1 + 1
%>
		<ul class="skill-list flex">
			<li><%=LRs("SkillNm") %></li>
			<li><span><%=LRs("PlusCnt") %>/<%=LRs("TotalCnt") %>(<%=LRs("SuccessRate") %>%)</span><span class="fill y" style="width: <%=LRs("SuccessRate") %>%;"></span><span class="mask"></span></li>
		</ul>
<%
    LRs.MoveNext
		Loop
%>
	</div>

	<!-- E: between-chart -->
  <!--<p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>-->

  <!-- S: time-record-chart -->
	<!--<div class="time-record-chart">
    <h3>시간대별 득실점</h3>
    <div id="time-record-chart"></div>
  </div>-->
  <!-- E: time-record-chart -->
</section>
<!-- E: 대회기록 best-win -->
<%
  else
%>

<!-- S: 대회기록 best-win -->
<section class="record best-win">
  <h3>대회기록</h3>
  <h4>기술별 성공률</h4>
  <!-- S: between-chart -->

	<div class="between-chart container skill_succ" id="ihtmldivSkill">
		<br />
    <center><dl>조회된 데이터가 없습니다.</dl></center>
	</div>

  <!-- E: between-chart -->
  <!--<p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>-->

  <!-- S: time-record-chart -->
<!--  <div class="time-record-chart">
    <h3>시간대별 득실점</h3>
    <div id="time-record-chart"></div>
  </div>-->
  <!-- E: time-record-chart -->
</section>
<!-- E: 대회기록 best-win -->

<%
	End If

  LRs.close

  Dbclose()
%>