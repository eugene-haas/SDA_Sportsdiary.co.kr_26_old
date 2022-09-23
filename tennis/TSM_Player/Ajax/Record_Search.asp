<!--#include file="../Library/ajax_config.asp"-->
<%
	Dim iTotalCount, iTotalPage, LCnt0 '페이징
	LCnt0 = 0
	Dim LCnt, NowPage, PagePerData '리스트
	LCnt = 0
  Dim iType : iType =  2   'iType :  조회 
	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)  '로그인아이디 복호화 
	fnd_keyWord = request("fnd_keyWord") '선수명 키워드 
  PlayerIDX = request("PlayerIDX") 
  response.write PlayerIDX
  NowPage = Request("i2")   ' 현재 페이지
	If Len(NowPage) = 0 Then
	NowPage = 1
	End If
	PagePerData = global_PagePerData  ' 한 화면에 출력할 갯수
	BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
	Search_NewTeamGbName = Request("Search_NewTeamGbName")  '선수  부서명  
   'iType: 1  페이지count, NowPage 현재페이지,  PagePerData 한 화면에 출력할 count,  BlockPage 페이지엥 표시될 count , TeamGb	 부서, KEYWORD 검색키워드 
   LSQL = " EXEC Search_TennisRPing_log_RankingList_New01 '1' ,'"&NowPage&"', 10, 10, '"&Search_NewTeamGbName&"', '"&fnd_keyWord&"', '"&PlayerIDX&"'"
   'Response.write LSQL 
     Set LRss = DBcon4.ExeCute(LSQL) 
     If Not (LRss.Eof Or LRss.Bof) Then 
      TotalPage = LRss("TotalPage")  ' 전체페이지 수 
     End if
  %>
<%  
     'iType: 2  리스트 조회 ,  NowPage 현재페이지,  PagePerData 한 화면에 출력할 count,  BlockPage 페이지엥 표시될 count , TeamGb	 부서, KEYWORD 검색키워드 
  LSQL = " EXEC Search_TennisRPing_log_RankingList_New01 '"&iType&"' ,'"&NowPage&"', 10, 10, '"&Search_NewTeamGbName&"', '"&fnd_keyWord&"', '"&PlayerIDX&"'"
     'Response.write LSQL
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt = LCnt + 1
%>
	<li class="s_ranking">
		<p class="l_recordList__no"><%=LRs("Rankcnt")%></p>  <!-- 랭킹 순위 --> 
		<button class="l_recordList_btn" onclick="openDetail();fn_ReadView('<%=LRs("PlayerIDX")%>','<%=LRs("totPnt")%>','<%=LRs("userName")%>','<%=LRs("TeamNm")%>','<%=LRs("Team2Nm")%>');">
			<p class="l_recordList__name"><%=LRs("userName")%></p>  <!-- 선수명 --> 
     <% if  LRs("Team2Nm") = "" then %>  <!-- 소속 클럽 2번째가 없을 경우 예외처리 --> 
        <p class="l_recordList__pos"><%=LRs("TeamNm")%></p>
      <% elseif  LRs("TeamNm") = "" then  %>
        <p class="l_recordList__pos"> <%=LRs("Team2Nm")%></p>
      <% else  %>
      	<p class="l_recordList__pos"><%=LRs("TeamNm")%>&nbsp;,&nbsp;<%=LRs("Team2Nm")%></p> <!--소속 클럽 --> 
      <% end if  %>
		</button>
		<p class="l_recordList__point"><%=formatnumber(LRs("totPnt"), 0)%>p</p> <!-- 포인트 총점 --> 
	</li>
<%
		LRs.MoveNext
	Loop
End If
%>
<!-- Totalpage : 전체페이지수 Ajax id로 값 전달  --> 
<input type="hidden" id="hdtcnt" value="<%=TotalPage %>" /> 
<%
LRs.close
 LRss.close 
DBClose4()
%>

