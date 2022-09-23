<!--#include file="../Library/ajax_config_26.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  iteamgb = fInject(Request("iteamgb"))

	'SDate = fInject(Request("SDate"))
	'EDate = fInject(Request("EDate"))
	'iPlayerIDX = fInject(Request("iPlayerIDX"))
	'iGameTitleIDX = fInject(Request("iGameTitleIDX"))
	
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	PlayerIDX = decode(iPlayerIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  EnterType =  Request.Cookies(SportsGb)("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"

	'PlayerIDX = ""
  'TxtName = ""
	iSchGubun = ""
	iFnd_KeyWord = ""
	iGameTitleIDX = ""

	Dim iSDate
  iSDate = MID(SDate,1,4)

	Dim iEDate
  iEDate = MID(EDate,1,4)

  Dim LRsCnt1
  LRsCnt1 = 0

  iType = "62"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & iSDate & "','" & iEDate & "','" & iteamgb & "','" & PlayerIDX & "','" & iEnterType & "','" & iGameTitleIDX & "','" & iSchGubun & "','" & iFnd_KeyWord & "','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<div id="ihtmldiv1">
	<!-- S: 최근 경기이력 best-win -->
	<section class="record best-win">
		<h3>대회별 랭킹포인트 <!--<span class="record-info">＊입상이력은 개인전만 반영됩니다.</span>--></h3>
		<dl class="clearfix" id="iRangkingpoint">
<%
		Do Until LRs.Eof
%>
			<dd><%=LRs("GameTitleIDXNm") %> / <%=LRs("rankingpoint") %> </dd>
<%
      LRs.MoveNext
		Loop
%>
			</dl>
	</section>
	<!-- E: 최근 경기이력 best-win -->
</div>
<%
  else
%>
<div id="ihtmldiv1">
	<!-- S: 최근 경기이력 best-win -->
	<section class="record best-win">
		<h3>대회별 랭킹포인트 <!--<span class="record-info">＊입상이력은 개인전만 반영됩니다.</span>--></h3>
		<dl class="clearfix" id="iRangkingpoint">
			<dd>조회된 데이터가 없습니다.</dd>
		</dl>
	</section>
	<!-- E: 최근 경기이력 best-win -->
</div>
<%  
	End If

  LRs.close

  Dbclose()
%>