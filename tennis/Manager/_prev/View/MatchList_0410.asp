<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%

nowdate =  Date()&"-"&AddZero(Hour(Now))&":"&AddZero(Minute(now))&":"&AddZero(Second(now))
	StadiumNumber = fInject(Request("StadiumNumber"))
	
	If StadiumNumber = "" Then
		'StadiumNumber = "1"
	End If 

	GameDay = fInject(Request("GameDay"))

	If GameDay = "" Then 
		GameDay = "2017-04-02"
	End If 


  Search_GroupGameGb = fInject(Request("Search_GroupGameGb"))

	Search_TeamGb      = fInject(Request("Search_TeamGb"))


  Level              = fInject(Request("Level"))

 SQL = "SELECT B.PlayerResultIDX  AS PlayerResultIDX, B.RGameLevelidx, SportsDiary.dbo.FN_PlayerName(B.LPlayerIDX) AS LUserName, SportsDiary.dbo.FN_PlayerName(B.RPlayerIDX) AS RUserName, "
 SQL = SQL&" SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.LTeam) AS LSchoolName, SportsDiary.dbo.FN_TeamNM(B.SportsGb, B.TeamGb, B.RTeam) AS RSchoolName, "
 SQL = SQL&" B.GroupGameNum, B.GameNum, B.LPlayerIDX, B.RPlayerIDX, "
 SQL = SQL&" B.LTeam, LTeamDtl, B.RTeam, B.RTeamDtl, B.LResult, B.RResult, B.GameStatus, " 
 SQL = SQL&" SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM, "
 SQL = SQL&" SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGBNM, "
 SQL = SQL&" SportsDiary.dbo.FN_LevelNM(B.SportsGb, B.TeamGb, B.Level) AS LevelNM, "
 SQL = SQL&" B.Sex, B.GroupGameGb AS GroupGameGb "
 SQL = SQL&" ,B.MediaLink AS MediaLink"
 SQL = SQL&" ,B.StadiumNumber AS StadiumNumber"
 SQL = SQL&" FROM SportsDiary.dbo.tblRgameLevel A "
 SQL = SQL&" INNER JOIN SportsDiary.dbo.tblPlayerResult B ON B.RGameLevelidx = A.RGameLevelidx "
 SQL = SQL&" AND B.GameTitleIDX = '44' "
 SQL = SQL&" AND A.GameDay = '"&GameDay&"' "
  
 SQL = SQL&" AND A.DelYN = 'N' "
 SQL = SQL&" AND B.DelYN = 'N' "


 '경기장
 If StadiumNumber <> "" Then 
 SQL = SQL&" AND B.StadiumNumber = '"&StadiumNumber&"'"
 End If 

 '경기구분
 If Search_GroupGameGb <> "" Then 
 SQL = SQL&" AND B.GroupGameGb = '"&Search_GroupGameGb&"'"
 End If 

 '
 If Search_TeamGb <> "" Then 
 SQL = SQL&" AND B.TeamGb = '"&Search_TeamGb&"'"
 End If 

  If Level <> "" Then 
 SQL = SQL&" AND B.Level = '"&Level&"'"
 End If 
 





 SQL = SQL&" AND (B.GroupGameGb = 'sd040001' OR (B.GroupGameGb = 'sd040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' ))) "
 SQL = SQL&" ORDER BY OrderByNum, B.Level, CONVERT(BigInt,B.GroupGameNum), CONVERT(BigInt,B.GameNum) "
'Response.Write SQL
'Response.End
 Set Rs = Dbcon.execute(SQL)
%>
<script type="text/javascript">
//조회부분셀렉트박스생성
make_box("sel_Search_GroupGameGb","Search_GroupGameGb","<%=Search_GroupGameGb%>","GroupGameGb")
make_box("sel_Search_TeamGb","Search_TeamGb","<%=Search_TeamGb%>","TeamGb2")


make_box_level("sel_Level","Level","<%=Level%>","Level_Check","<%=Search_TeamGb%>")	



//체급셀렉트박스
function chk_level(){	
	if(document.getElementById("Search_TeamGb").value!=""){
		make_box_level("sel_Level","Level","","Level_Check",document.getElementById("Search_TeamGb").value)
	}
}

function copy_path(data){
	//alert(data);
	if (window.clipboardData.setData("text", data+"/"+getTimeStamp()))
  	alert("클립보드 복사가 완료되었습니다!");
  else
   alert("클립보드 복사가 실패하였습니다!");	
}	


function chk_frm(){
 var f = document.search_frm;
 f.submit();
}




//document.write(getTimeStamp() + '<br />');




function getTimeStamp() {
  var d = new Date();

  var s =
    leadingZeros(d.getFullYear(), 4) + '-' +
    leadingZeros(d.getMonth() + 1, 2) + '-' +
    leadingZeros(d.getDate(), 2) + ' ' +

    leadingZeros(d.getHours(), 2) + ':' +
    leadingZeros(d.getMinutes(), 2) + ':' +
    leadingZeros(d.getSeconds(), 2);

  return s;
}



function leadingZeros(n, digits) {
  var zero = '';
  n = n.toString();

  if (n.length < digits) {
    for (i = 0; i < digits - n.length; i++)
      zero += '0';
  }
  return zero + n;
}
</script>
	<section>
		<div id="content">
		<form method="post" name="search_frm" id="search_frm" action="MatchList_0410.asp"> 
		<input type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="47">
		<div class="sch">
			<table class="sch-table">
				<caption>검색조건 선택 및 입력</caption>
				<colgroup>
					<col width="80px" />
					<col width="*" />
					<col width="80px" />
					<col width="*" />
					<col width="80px" />
					<col width="*" />
					<col width="80px" />
					<col width="*" />
					<col width="80px" />
					<col width="*" />

				</colgroup>				 
				<tbody>
					<tr>
						<th scope="row"><label for="competition-name-2">대회일자</label></th>
						<td id="sel_GameTitle">
							<select id="GameDay" name="GameDay">
								<option value="">전체</option>
								<option value="2017-04-02" <%If GameDay = "2017-04-02" Then %>selected <%End If %>>2017-04-02</option>
							</select>
						</td>
						<th scope="row">경기장번호</th>
						<td>
							<select id="StadiumNumber" name="StadiumNumber">
							<option value="">전체</option>
								<option value="1" <%If StadiumNumber = "1" Then %>selected <%End If %>>1경기장</option>
								<option value="2" <%If StadiumNumber = "2" Then %>selected <%End If %>>2경기장</option>
								<option value="3" <%If StadiumNumber = "3" Then %>selected <%End If %>>3경기장</option>
								<option value="4" <%If StadiumNumber = "4" Then %>selected <%End If %>>4경기장</option>
							</select>
						</td>						
						<th scope="row">경기구분</th>
						<td id="sel_Search_GroupGameGb">
							<select id="Search_GroupGameGb" name="Search_GroupGameGb" onchange="change_GroupGameGb(this)">
								<option value="sd040001" <%If Search_GroupGameGb = "sd040001" Then %>selected <%End If %>>개인전</option>
								<option value="sd040002" <%If Search_GroupGameGb = "sd040002" Then %>selected <%End If %>>단체전</option>
							</select>
						</td>			
						<th scope="row">소속</th>
						<td id="sel_Search_TeamGb">
							<select id="Search_TeamGb" name="Search_TeamGb">
								<option value="">::소속구분선택::</option>
							</select>
						</td>								
						<th scope="row">체급</th>
						<td id="sel_Level">

              <select id="Level" onclick="alert('소속 성별 선택후 체급을 선택해 주세요.');">
                <option value="">::체급선택::</option>
              </select>
     								
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</form>
		<div class="btn-right-list">
			<a href="javascript:chk_frm();" class="btn" id="btnview" accesskey="s">검색(S)</a>
		</div>
		<!-- S : 리스트 -->
		<table class="table-list">
			<caption>대회 리스트</caption>
			<colgroup>
			<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="50" />
			</colgroup>
			<thead>
				<tr>
				  <th scope="col">일련번호</th>
					<th scope="col">경기장</th>
					<th scope="col">선수명</th>
					<th scope="col">경기</th>
					<th scope="col">체급</th>
					<th scope="col">복사</th>
					
				</tr>
			</thead>
			<tbody>
				<%
					If Not (Rs.Eof Or Rs.Bof) Then
						Do Until Rs.Eof 
				%>
				<tr>
					<td><%=Rs("PlayerResultIDX")%></td>
					<td class="left">제<%=Rs("StadiumNumber")%>경기장</td>
					<%
					'	If GroupGameGb ="sd040001" Then 
					%>
					<td>(<%=Rs("LSchoolName")%>)<%=Rs("LUserName")%> VS <%=Rs("RUserName")%>(<%=Rs("RSchoolName")%>)</td>
					<%
					'	Else 
					%>
					<!--<td><%=Rs("LSchoolName")%> VS <%=Rs("RSchoolName")%></td>-->
					<%
					'	End If 
					%>
					<td class="left"><%=Rs("GroupGameGbNM")%></td>
					<td class="left"><%=Rs("TeamGBNM")%> <%=Rs("LevelNM")%></td>
					<%
						'If GroupGameGb ="sd040001" Then 
					%>
					<!--<td class="left"><input type="button" value="복사" onclick="copy_path('<%=Rs("StadiumNumber")%>경기장<%=Rs("LUserName")%> VS <%=Rs("RUserName")%> <%=Rs("TeamGBNM")%> <%=Rs("LevelNM")%>/<%=Rs("PlayerResultIDX")%>');"></td>-->
					<%
						'Else 
					%>
					
					<td class="left"><input type="button" value="복사" onclick="copy_path('<%=Rs("StadiumNumber")%>경기장<%=Rs("LSchoolName")%> VS <%=Rs("RSchoolName")%> <%=Rs("TeamGBNM")%> <%=Rs("LevelNM")%>/<%=Rs("PlayerResultIDX")%>/<%=nowdate%>');"></td>
					<%
					'	End If 
					%>
				</tr>
				<%
							Rs.MoveNext
						Loop 
					End If 
				%>
			</tbody>
		</table>
		<!-- E : 리스트 -->
		</div>
	<section>