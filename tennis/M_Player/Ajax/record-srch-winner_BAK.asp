<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
  SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
  GroupGameGb = fInject(Request("GroupGameGb"))
  TeamGb = fInject(Request("TeamGb"))
  Level = fInject(Request("Level"))
  Selschgubun = fInject(Request("Selschgubun"))
  Txtname = fInject(Request("Txtname"))

  PlayerIDX = ""
	
  Dim iYearSDate
  iYearSDate = MID(SDate,1,4)

	'Team = decode(Team,0)
  if Selschgubun = "schuser" then
	Txtname = decode(Txtname,0)
  end if

  

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  Dim LRsCnt1, iGameTitleIDX1, iGameTitleIDXCnt1, iGameTitleName1, iGameS1, iGameE1, iiGameTitleIDXCntTotal1
  LRsCnt1 = 0
  iiGameTitleIDXCntTotal1 = 0

  iType = "3"
  iSportsGb = "judo"

  LSQL = "EXEC MatchRecord_TM_Match_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','" & Selschgubun & "','" & Txtname & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then 

%>
<!-- S: article-frame -->
<div class="article-frame">
	<h2 class="table-title l-bar">
		<span class="r-bar"><%=iYearSDate %>년</span>
<%

		Do Until LRs.Eof
      
        LRsCnt1 = LRsCnt1 + 1

        if LRsCnt1 = 1 then
%>
    <% if LRs("PhotoPath") = "N" and Selschgubun = "schteam" then %>
    <span><%=LRs("TeamNm") %></span>
    <% elseif LRs("PhotoPath") = "N" and Selschgubun = "schuser" then %>
    <div class="img-round">
			<img src="../images/mixin/profile@3x.png" alt="프로필 사진을 등록해 주세요." />
		</div>
    <span><%=LRs("UserName") %></span>
    <% else %>
    <div class="img-round">
			<img src="../<%=MID(LRs("PhotoPath"),4) %>" alt="" />
		</div>
    <span><%=LRs("UserName") %></span>
    <% end if %>
	</h2>
	<!-- S: fix-table -->
	<div class="fix-table">
		<div class="scroll-table">
			<table class="table table-striped table-winner-total">
				<thead>
					<tr>
						<th>대회 기간</th>
						<th>대회명</th>
						<th>소속구분</th>
						<th>경기방식</th>
						<th>체급</th>
						<th>결과보기</th>
						<th>입상결과</th>
						<th>소속명</th>
						<th>이름</th>
						<th>영상</th>
					</tr>
				</thead>
				<tbody>
<%
        end if

%>        
        <tr>
						<td><%=Mid(LRs("GameS"),6,2) %>/<%=Mid(LRs("GameS"),9) %>~<%=Mid(LRs("GameE"),6,2) %>/<%=Mid(LRs("GameE"),9) %></td>
						<td><%=LRs("GameTitleName") %></td>
						<td><%=LRs("TeamGbName") %></td>
						<td><%=LRs("GroupGameGbName") %></td>
						<td><%=LRs("LevelName") %></td>
						<td><a href="javascript:;" onclick="javascript:iPageMove('<%=LRs("GroupGameGb") %>','<%=LRs("Level") %>','<%=LRs("TeamGb") %>','<%=LRs("GameTitleIDX") %>','<%=LRs("GameTitleName") %>');" class="btn btn-default">보기</a></td>
						<td>
              <% if LRs("TitleResultName") = "금메달" then %>
              <span class="ic-deco medal"><img src="../images/public/golden-medal@3x.png" alt="금" /></span><span>금</span>
              <% elseif LRs("TitleResultName") = "은메달" then %>
              <span class="ic-deco medal"><img src="../images/public/silver-medal@3x.png" alt="은" /></span><span>은</span>
              <% else %>
              <span class="ic-deco medal"><img src="../images/public/bronze-medal@3x.png" alt="동" /></span><span>동</span>
              <% end if %>
						</td>
						<td><%=LRs("TeamNm") %></td>
						<td><%=LRs("UserName") %></td>
						<td>
              <% if LRs("GroupGameGb") = "sd040001" then %>
              <a href="javascript:;" onclick="javascript:iMovieLink('<%=LRs("GameScoreIDX") %>', '<%=LRs("GroupGameGb") %>', '<%=encode(LRs("PlayerIDX"),0) %>')" class="btn btn-film" data-toggle="modal" data-target=".film-modal">
              <% else %>
              <a href="javascript:;" onclick="javascript:iMovieLink('<%=LRs("GameScoreIDX") %>', '<%=LRs("GroupGameGb") %>', '<%=encode(LRs("PlayerIDX"),0) %>')" class="btn btn-film" data-toggle="modal" data-target="#groupround-res">
              <% end if %>
                <img src="../images/public/ic-film@3x.png" alt="" />
              </a>
						</td>
					</tr>  
<%
	    LRs.MoveNext
		Loop
%>
        </tbody>
			</table>
		</div>
	</div>
	<!-- E: fix-table -->
</div>
<!-- E: article-frame -->
<form id="frmMenu">
  <input name="iGroupGameGb" id="iGroupGameGb" type="hidden" value="" />
  <input name="iLevel" id="iLevel" type="hidden" value="" />
  <input name="iTeamGb" id="iTeamGb" type="hidden" value="" />
  <input name="iGameTitleIDX" id="iGameTitleIDX" type="hidden" value="" />
  <input name="iGameTitleName" id="iGameTitleName" type="hidden" value="" />
</form>

<script type="text/javascript">

  function iPageMove(ia, ib, ic, id, ie) {

    alert(ia + ', ' + ib + ', ' + ic + ', ' + id + ', ' + ie);

    $("#iGroupGameGb").val(ia);
    $("#iLevel").val(ib);
    $("#iTeamGb").val(ic);
    $("#iGameTitleIDX").val(id);
    $("#iGameTitleName").val(ie);

    //alert($("#iGroupGameGb").val());

    $("#frmMenu").attr({ action: "../MatchSche/tourney.asp", method: 'post' }).submit();

  }

</script>

<%
	End If 

  LRs.Close


  'Dbclose()

%>

<% if LRsCnt1 < 1 then %>

<div class="article-frame">
  데이터가 없습니다.
</div>

<% end if %>