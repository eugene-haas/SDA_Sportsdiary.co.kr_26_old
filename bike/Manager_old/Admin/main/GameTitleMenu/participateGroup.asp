<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameTitleMenu/participate.js"></script>

<%
  tidx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  En_tidx =crypt.EncryptStringENC(tidx)
  tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))
  En_tGameLevelIdx= crypt.EncryptStringENC(tGameLevelIdx)

 	NowPage = fInject(Request("i2"))  ' 현재페이지
 	PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0

	'Request Data
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
%>

<script type="text/javascript">

	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	function WriteLink(i2) {
		post_to_url('./participate.asp', { 'i2': i2, 'iType': '1' });
	}

	function ReadLink(i1, i2) {
		post_to_url('./participate.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
	}

	function PagingLink(i2) {
		post_to_url('./participate.asp', { 'i2': i2,'tGameLevelIdx' : '<%=tGameLevelIdx%>','tidx' : <%=tidx%> ,'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;
		post_to_url('./participate.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

</script>

<%
  LSQL = " SELECT Top 1 GameTitleName, EnterType  "
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRS("GameTitleName")
			tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF

  LSQL = " SELECT Top 1 e.PubName as GroupGameGbNm, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when  'man'then	'남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayType, a.Level, d.LevelNm as LevelNm, a.GroupGameGb "
  LSQL = LSQL & "  FROM tblGameLevel a "
	LSQL = LSQL & "  LEFT JOIN tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblPubcode c on a.PlayType = c.PubCode and  c.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblLevelInfo d on a.Level  = d.Level and d.DelYN = 'N' "
  LSQL = LSQL & "  LEFT JOIN tblPubcode e on a.GroupGameGb= e.PubCode and e.DelYN ='N' "	
  LSQL = LSQL & " WHERE a.DelYN = 'N' and GameTitleIDX = " & tidx & " and a.GameLevelidx = " & tGameLevelIdx
	'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeamGbNm = LRS("TeamGbNm")
			tSex = LRS("Sex")
      En_tSex = crypt.EncryptStringENC(tSex)
			tPlayType = LRS("PlayType")
			tLevelNm = LRS("LevelNm")
      tLevel = LRS("Level")
      En_tLevel = crypt.EncryptStringENC(tLevel)
			tGroupGameGb = LRS("GroupGameGb")
      En_tGroupGameGb = crypt.EncryptStringENC(tLevel)
      tGroupGameGbNm = LRS("GroupGameGbNm")
      LRs.MoveNext
    Loop
  End IF

  iType = 2
  LSQL = "EXEC GameRequestPlayer_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"
	'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
		Loop
	End If


  
%>

<section>
	<div id="content">
		<!-- S : 내용 시작 -->
<div class="contents">
			<!-- S: 네비게이션 -->
			<div class="navigation_box">
				대회 > 대회종목 > 대회신청자 현황
			</div>
      <div class="navi-tp-table-wrap" id="gamelevelinput_area">
      <div class="top-navi-inner">  
        <div class="top-navi-btm">
          <div class="top-navi-tp">
            <h3 class="top-navi-tit">
            <strong id="Depth_GameTitle"> <%=tGameTitleName%></strong>
           
            <div class="top-navi-btm">
              <div class="navi-tp-table-wrap" id="input_area">
                <table class="navi-tp-table">
                  <caption>대회정보관리 기본정보</caption>
                  <colgroup>
                    <col width="64px">
                    <col width="*">
                    <col width="64px">
                    <col width="*">
                    <col width="94px">
                    <col width="*">
                    <col width="94px">
                    <col width="*">									
                  </colgroup>
                  <tbody>
                    <tr>
                      
                    </tr>
                    <tr>
                      <th scope="row"><label for="competition-name">대회명</label></th>
                      <td><%=tGameTitleName%></td>
                      <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
                      <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=En_tidx%>">
                      <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=En_tGameLevelIdx%>">
                      <th scope="row">구분</th>
                      <td><%=tGroupGameGbNm%></td>
                      <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=En_tGroupGameGb%>">
                      <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
                    </tr>
                    <tr>
                      <th scope="row">성별</th>
                      <td> <%=tSex%> </td>
                      <input type="hidden" name="Sex" id="Sex" value="<%=tSex%>">
                      <th scope="row">종목</th>
                      <td><%=tLevelNm%></td>
                      <input type="hidden" name="Level" id="Level" value="<%=En_tLevel%>">
                      <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
                      <th scope="row"></th>
                      <td></td>
                    </tr>
                    <tr>
                      <th scope="row">선수명</th>
                      <td>
                        <span><input type="text" name="strMember" id="strMember" placeholder=""></span>
                        <input type="hidden" name="hiddenMemberName" id="hiddenMemberName" value="">
                        <input type="hidden" name="hiddenMemberIdx" id="hiddenMemberIdx" value="">
                      </td>
                      <th scope="row">소속</th>
                      <td id="tdTeam" name ="tdTeam"></td>
                      <input type="hidden" name="hiddenTeam" id="hiddenTeam" value="">
                      <input type="hidden" name="hiddenTeamName" id="hiddenTeamName" value="">
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
        </div>
      </div>
     </div>
       <div class="btn-right-list">
            <a href="#" id="btnsave" class="btn" onclick="inputGameParticipate_frm(<%=NowPage%>);" accesskey="i">등록(I)</a>
            <a href="#" id="btnupdate" class="btn" onclick="updateGameParticipate_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
            <a href="#" id="btndel" class="btn btn-delete" onclick="delGameParticipate_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
          </div>
      <div>
					<span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
				</div>		
        
        <table class="table-list">
          <thead>
            <tr>
              <th>번호</th>
              <th>신청그룹 번호</th>    <!-- 경기 방법 (단식 ,복식,혼합 복식)-->
              <th>이름</th>
              <th>팀명</th>
              <th>등록일자</th> 
            </tr>
          </thead>
          <colgroup>
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="100px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
          </colgroup>
            <tbody id="contest">
            <%
              iType = 1
              LSQL = "EXEC GameRequestPlayer_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & tIdx & "','" & tGameLevelIdx & "','" & iTemp & "','" & iLoginID & "'"

              'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
              'LSQL = LSQL & " FROM  tblGameTitle a "
              'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
              'LSQL = LSQL & " WHERE a.DELYN = 'N' "
              'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
              'response.End
              
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    RNum = LRs("Num")
                    RGameRequestPlayerIDX = LRs("GameRequestPlayerIDX")
                    En_RGameRequestPlayerIDX =  crypt.EncryptStringENC(RGameRequestPlayerIDX)
                    RGameRequestGroupIDX = LRs("GameRequestGroupIDX")
                    RGameTitleIDX = LRs("GameTitleIDX")
                    RGameLevelIDX = LRs("GameLevelIDX")
                    RMemberIDX = LRs("MemberIDX")
                    RTeamName = LRs("TeamName")
                    RMemberName = LRs("MemberName")
                    RTeamCode = LRs("TeamCode") 
                    REditDate = LRs("EditDate")
                    RDelYN = LRs("DelYN")
                    RWriteDate = LRs("WriteDate")
                    %>
                    <tr>

                      <td  style="cursor:pointer" onclick='javascript:SelParticipate("<%=En_RGameRequestPlayerIDX%>")'>
                        <%=RNum%>
                      </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipate("<%=En_RGameRequestPlayerIDX%>")'>
                        <%=RGameRequestGroupIDX%>
                      </td>
                        <td  style="cursor:pointer" onclick='javascript:SelParticipate("<%=En_RGameRequestPlayerIDX%>")'>
                        <%=RMemberName%>
                      </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipate("<%=En_RGameRequestPlayerIDX%>")'>
                        <%=RTeamName%>
                      </td>
                      <td  style="cursor:pointer" onclick='javascript:SelParticipate("<%=En_RGameRequestPlayerIDX%>")'>
                        <%=RWriteDate%>
                      </td>
                    </tr>
                    <%
                  LRs.MoveNext
                Loop
              End If
              LRs.close
            %>
          </tbody>
        </table>

        <!-- E : 리스트형 20개씩 노출 -->
			  <div class="bullet-wrap">
					<div class="board-bullet pagination">
					<%
					if cdbl(iTotalCount) > 0 then
					%>
						<!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
					<%
          ELSE
          %>
          <div class="board-bullet Non-pagination" >
              데이터가 존재하지 않습니다.
          </div>
          <%
          End If
					%>
          </div>
				</div>
      <div>
      <div>
    </div>
  </div>
  </div>
</section>
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>