<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 

	
	SportsGb = fInject(Request("SportsGb"))

	GameTitleIDX = fInject(Request("GameTitleIDX"))

	StadiumNumber = fInject(Request("StadiumNumber"))
	
	If StadiumNumber = "" Then
		'StadiumNumber = "1"
	End If 

	GameDay = fInject(Request("GameDay"))

	If GameDay = "" Then 
		GameDay = ""
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
 SQL = SQL&" ,CASE  WHEN ISNULL(B.MediaLink,'')<>'' THEN SUBSTRING(B.MediaLink,0, CHARINDEX('?', B.MediaLink))ELSE ''END  AS MediaLink"
 SQL = SQL&" ,CASE  WHEN ISNULL(B.MediaLink,'')<>'' THEN "
 SQL = SQL&"  case when CHARINDEX('start', B.MediaLink)>0 then Replace(Replace(SUBSTRING(B.MediaLink,CHARINDEX('start', B.MediaLink), CHARINDEX('&end=', B.MediaLink)-CHARINDEX('&start=', B.MediaLink)),'&',''),'start=','') "
 SQL = SQL&"  else '0' end ELSE '0'END MediaStart"

 SQL = SQL&" ,CASE  WHEN ISNULL(B.MediaLink,'')<>'' THEN "
 SQL = SQL&"  case when CHARINDEX('end', B.MediaLink)>0 then Replace(Replace(SUBSTRING(B.MediaLink,CHARINDEX('end', B.MediaLink), CHARINDEX('&autoplay', B.MediaLink)-CHARINDEX('end', B.MediaLink)),'&',''),'end=','') "
 SQL = SQL&"  ELSE '0' end ELSE '0'END MediaEnd"

 SQL = SQL&" ,B.Tmp_StadiumNumber AS StadiumNumber"
 SQL = SQL&" ,B.StartHour AS SHour "
 SQL = SQL&" ,B.StartMinute AS SMinute "
 SQL = SQL&" ,Sportsdiary.dbo.FN_GameStartDate (B.SportsGb, B.RGameLevelIDX, B.GroupGameNum, B.GameNum )  AS WorkDt  "
 SQL = SQL&" FROM SportsDiary.dbo.tblRgameLevel A "
 SQL = SQL&" INNER JOIN SportsDiary.dbo.tblPlayerResult B ON B.RGameLevelidx = A.RGameLevelidx "


 If GameTitleIDX <> "" Then 
	 SQL = SQL&" AND B.GameTitleIDX = '"&GameTitleIDX&"'"
 End If 

 If GameDay <> "" Then 
 SQL = SQL&" AND A.GameDay = '"&GameDay&"'"
 End If 
 SQL = SQL&" AND A.DelYN = 'N'"
 SQL = SQL&" AND B.DelYN = 'N'"
 

 '레슬링동영상 제외리스트.. 양선수패,무승부 및 기권,실격승
 If SportsGb = "wres" Then
	SQL = SQL & " AND ("
	SQL = SQL & " B.RResult <> 'wr052011' AND B.LResult <> 'wr052011' AND"
	SQL = SQL & " B.RResult <> 'wr052012' AND B.LResult <> 'wr052012' AND"
	SQL = SQL & " B.RResult <> 'wr052013' AND B.LResult <> 'wr052013' AND"
	SQL = SQL & " B.RResult <> 'wr052002' AND B.LResult <> 'wr052002' AND"
	SQL = SQL & " B.RResult <> 'wr052005' AND B.LResult <> 'wr052005' "
	SQL = SQL & ")"
 ElseIf SportsGb = "judo" Then 
	SQL = SQL&" AND B.RResult <> 'sd019006' AND B.LResult <> 'sd019006' AND B.RResult <> 'sd019021' AND B.LResult <> 'sd019021' AND B.RResult <> 'sd019012' AND B.LResult <> 'sd019012'"
	SQL = SQL&" AND B.RResult <> 'sd019022' AND B.LResult <> 'sd019022'"
'	SQL = SQL&" AND ( B.RResult <> 'sd019006' AND B.LResult <> 'sd019006' AND B.RResult <> 'sd019021' AND B.LResult <> 'sd019021')"	
 End If

 '경기장
 If StadiumNumber <> "" Then 

	If SportsGb = "wres" Then
		If StadiumNumber = "1" Then
			StadiumNumber = "A"
		ElseIf StadiumNumber = "2" Then
			StadiumNumber = "B"
		ElseIf StadiumNumber = "3" Then
			StadiumNumber = "C"
		ElseIf StadiumNumber = "4" Then
			StadiumNumber = "D"
		End If
	End If

 SQL = SQL&" AND B.Tmp_StadiumNumber = '"&StadiumNumber&"'"
 End If 


 '경기구분
 If Search_GroupGameGb <> "" Then 
 SQL = SQL&" AND RIGHT(B.GroupGameGb,6) = LEFT('"&Search_GroupGameGb&"',6)"
 End If 

 '
 If Search_TeamGb <> "" Then 
 SQL = SQL&" AND B.TeamGb = '"&Search_TeamGb&"'"
 End If 

 If Level <> "" Then 
 SQL = SQL&" AND B.Level = '"&Level&"'"
 End If 
 

	If SportsGb <> "" Then 
		SQL = SQL&" AND B.SportsGb='"&SportsGb&"'"
	End If 


 SQL = SQL&" AND (B.GroupGameGb = '"&SportsCode&"040001' OR (B.GroupGameGb = '"&SportsCode&"040002' AND (ISNULL(B.LPlayerIDX,'') = '' AND ISNULL(B.RPlayerIDX,'') = '' ))) "
 SQL = SQL&" ORDER BY B.StartHour+B.StartMinute "
'Response.Write SQL
'Response.End
 Set Rs = Dbcon.execute(SQL)
%>
<script type="text/javascript">
    //조회부분셀렉트박스생성
    make_box("sel_Search_GroupGameGb", "Search_GroupGameGb", "<%=Search_GroupGameGb%>", "GroupGameGb")
    make_box("sel_Search_TeamGb", "Search_TeamGb", "<%=Search_TeamGb%>", "TeamGb2")
    make_box_level("sel_Level", "Level", "<%=Level%>", "Level_Check", "<%=Search_TeamGb%>")

    //체급셀렉트박스
    function chk_level() {
        if (document.getElementById("Search_TeamGb").value != "") {
            make_box_level("sel_Level", "Level", "", "Level_Check", document.getElementById("Search_TeamGb").value)
        }
    }

    function copy_path(data) {
        //alert(data);
        if (window.clipboardData.setData("text", data))
            alert("클립보드 복사가 완료되었습니다!");
        else
            alert("클립보드 복사가 실패하였습니다!");
    }


    function chk_frm() {
        var f = document.search_frm;
        f.submit();
    }



    function chk_save(objno) {
        var f = eval("document.media_frm" + objno)
        var sf = document.search_frm;
        if (f.MediaLink.value == "") {
            alert("동영상링크를 입력해 주세요");
            return false;
        }

        var sttime = Number(f.MediaStH.value * 60 * 60) + Number(f.MediaStM.value * 60) + Number(f.MediaStS.value);
        var Ettime = Number(f.MediaEtH.value * 60 * 60) + Number(f.MediaEtM.value * 60) + Number(f.MediaEtS.value);

        if (sttime > Ettime) {
            alert("동영상 시간 입력이 잘못 되었습니다.");
            return false;
        } else {
            var timeline = "?fs=1&modestbranding=0";

            if (sttime > 0) {
                timeline = timeline + "&start=" + sttime;
            }

            if (Ettime > 0) {
                timeline = timeline + "&end=" + Ettime;
            } else {
                timeline = timeline + "&end=";
            }
            timeline = timeline + "&autoplay=1&fs=1"

            console.log(f.MediaLink.value + timeline);
            sf.H_MediaLink.value = f.MediaLink.value + timeline;
            sf.H_PlayerResultIDX.value = f.PlayerResultIDX.value;


            var params = jQuery("#search_frm").serialize(); // serialize() : 입력된 모든Element(을)를 문자열의 데이터에 serialize 한다.
            jQuery.ajax({
                url: 'MatchUpload_Ok2.asp',
                type: 'POST',
                data: params,
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                dataType: 'html',
                success: function (result) {
                    if (result) {
                        // 데이타 성공일때 이벤트 작성
                        alert("저장되었습니다.");
                        console.log("저장완료");
                    }
                }
            });

           // sf.action = "MatchUpload_Ok1.asp";
           // sf.submit();   
        }
    }

    //종목선택
    function chk_frm() {
        var f = document.search_frm;
        f.action = "MatchUpload.asp"
        f.submit();
    }

    //NUMBER INPUT 설정
    function maxLengthCheck(object) {
        if (parseInt(object.value.length) > parseInt(object.maxLength)) {
            object.value = object.value.slice(0, object.maxLength);
        }

        if (parseInt(object.value) > parseInt(object.max)) {
            object.value = object.max;
        }
        if (parseInt(object.value) < 0) {
            object.value = 0;
        }

    }
    $(document).ready(function () {
        $(".TimeNumber").on("click", function () { $(this).select(); });
    });



</script>
	<section>		
		<div id="content">
			<div class="loaction">
				<strong>경기관리</strong> &gt; 동영상관리
			</div>
		<form method="post" name="search_frm" id="search_frm" action="Matchupload.asp"> 
		<div class="sch">
			<table class="sch-table">
				<caption>검색조건 선택 및 입력</caption>
				<colgroup>
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="50px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
				</colgroup>				 
				<tbody>
					<tr>
						<th scope="row"><label for="competition-name-2">종목선택</label></th>
						<td>
							<select name="SportsGb" id="SportsGb" onChange="chk_frm();">
								<option value="">=선택=</option>
								<%
									SSQL = "SELECT PubCode,PubName FROM Sportsdiary.dbo.tblPubcode WHERE DelYN='N' AND PPubCode='sd000'"
									Set sRs = Dbcon.Execute(SSQL)
									If Not(SRs.Eof Or SRs.Bof) Then 
										Do Until SRs.Eof 
								%>
								<option value="<%=SRs("PubCode")%>" <%If SRs("PubCode") = SportsGb Then %>selected<%End If%>><%=SRs("PubName")%></option>
								<%
											SRs.MoveNext
										Loop 
									End If 
								%>
							</select>
						</td>
						<th scope="row"><label for="competition-name-2">대회선택</label></th>
						<td>
							<select name="GameTitleIDX" id="GameTitleIDX" onchange="chk_frm();">
								<option value="">=대회선택=</option>
								<%
									If SportsGb <> "" Then 
										GSQL = "SELECT GameTitleIDX,'['+GameS+'~]'+GameTitleName GameTitleName FROM Sportsdiary.dbo.tblGametitle WHERE ViewState='1' AND DelYN='N'  and GameS<= GETDATE() AND SportsGb='"&SportsGb&"' ORDER BY GameS DESC"
										'Response.Write GSQL
										'Response.End
										Set GRs = Dbcon.Execute(GSQL)

										If Not(GRs.Eof Or GRs.Bof) Then 
											Do Until GRs.Eof 
								%>
								<option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
								<%
												GRs.MoveNext
											Loop 
										End If 
									End If 
								%>
							</select>
						</td>
						<th scope="row"><label for="competition-name-2">대회일자</label></th>
						<td >
							<select id="GameDay" name="GameDay" onChange="chk_frm();">
								<option value="">전체</option>
								<%
									If SportsGb<>"" And GameTitleIDX <> "" Then 
									DSQL = "SELECT Distinct(GameDay) AS GameDay FROM Sportsdiary.dbo.tblRgameLevel WHERE GameTitleIDX='"&GameTitleIDX&"' Order By GameDay"

									Set DRs = Dbcon.Execute(DSQL)

										If Not(DRs.Eof Or DRs.Bof) Then 
											Do Until DRs.Eof 
								%>
								<option value="<%=DRs("GameDay")%>" <%If CStr(DRs("GameDay")) = CStr(GameDay) Then %>selected <%End If %>><%=DRs("GameDay")%></option>
								<%
												DRs.MoveNext
											Loop 
										End If 
									End If 
								%>
							</select>
						</td>
                        </tr>
                        <tr>
						<th scope="row">경기장번호</th>
						<td>
							<select id="StadiumNumber" name="StadiumNumber" onChange="chk_frm();">
							<option value="">전체</option>
								<option value="1" <%If StadiumNumber = "1" Then %>selected <%End If %>>1경기장</option>
								<option value="2" <%If StadiumNumber = "2" Then %>selected <%End If %>>2경기장</option>
								<option value="3" <%If StadiumNumber = "3" Then %>selected <%End If %>>3경기장</option>
								<option value="4" <%If StadiumNumber = "4" Then %>selected <%End If %>>4경기장</option>
								<option value="5" <%If StadiumNumber = "5" Then %>selected <%End If %>>5경기장</option>
								<option value="6" <%If StadiumNumber = "6" Then %>selected <%End If %>>6경기장</option>
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
		<input type="hidden" name="H_MediaLink" id="H_MediaLink">
		<input type="hidden" name="H_PlayerResultIDX" id="H_PlayerResultIDX">

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
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col style="min-width:150px" />
				<col style="min-width:150px" />
				<col style="min-width:50px" />
			</colgroup>
			<thead>
				<tr>
				  <th scope="col">No</th>
				  <th scope="col">일련번호</th>
					<th scope="col">경기장</th>
					<th scope="col">선수명</th>
					<th scope="col">경기</th>
					<th scope="col">체급</th>
					<th scope="col">경기시각</th>
					<th scope="col">기록표준시간</th>
					<th scope="col">경로</th>
					<th scope="col">동영상시작</th>
					<th scope="col">동영상종료</th>
					<th scope="col">저장</th>
				</tr>
			</thead>
			<tbody>
				<%
					If SportsGb <> "" And GameTitleIDX <> "" Then 
					i = 1
					MediaLinkCnt = "0"
					NoMediaLinkCnt = "0"
					If Not (Rs.Eof Or Rs.Bof) Then
						Do Until Rs.Eof 
				%>
				<form method="post" name="media_frm<%=i%>" id="media_frm<%=i%>">
				<tr>
					<td><%=i%></td>
					<td><%=Rs("PlayerResultIDX")%></td>
					<td class="left"><%=Rs("StadiumNumber")%></td>
					<td><%=Rs("LUserName")%>(<%=Rs("LSchoolName")%>) VS <%=Rs("RUserName")%>(<%=Rs("RSchoolName")%>)</td>
					<td class="left"><%=Rs("GroupGameGbNM")%></td>
					<td class="left"><%=Rs("TeamGBNM")%> <%=Rs("LevelNM")%></td>
					<td class="left"><%=Rs("SHour")%>시 <%=Rs("SMinute")%>분</td>
					<td class="left"><%=Rs("WorkDt")%></td>
					<td><input type="text"  name="MediaLink" value="<%=Rs("MediaLink")%>"></td>
					<input type="hidden" name="PlayerResultIDX" value="<%=Rs("PlayerResultIDX")%>">
                    <td class="left">
                        <%  
                            MediaStart = Rs("MediaStart")
                            MediaEnd = Rs("MediaEnd")

                            MediaStart_h=0
                            MediaStart_m=0
                            MediaStart_s=0

                            if  MediaStart <>"" then 
                                if MediaStart >= 3600 then
                                    MediaStart_h =(MediaStart\60)\60
                                    MediaStart = MediaStart-MediaStart_h*60*60
                                end if

                                if MediaStart >=60 then 
                                    MediaStart_m =(MediaStart\60)
                                    MediaStart = MediaStart-MediaStart_m*60
                                end if 
                                
                                if MediaStart >=0 then 
                                    MediaStart_s =MediaStart
                                end if 
                            else
                                MediaStart=0
                            end if
                            
                            MediaEnd_h=0
                            MediaEnd_m=0
                            MediaEnd_s=0

                            if  MediaEnd <>"" then 
                                if MediaEnd >= 3600 then
                                    MediaEnd_h =(MediaEnd\60)\60
                                    MediaEnd = MediaEnd-MediaEnd_h*60*60
                                end if

                                if MediaEnd >=60 then 
                                    MediaEnd_m =(MediaEnd\60)
                                    MediaEnd = MediaEnd-MediaEnd_m*60
                                end if 
                                
                                if MediaEnd >=0 then 
                                    MediaEnd_s =MediaEnd
                                end if 
                            else
                                MediaEnd=0
                            end if
                        %>

                        <input id="MediaStH" name="MediaStH" class="TimeNumber" type="number" value="<%=MediaStart_h %>" style="width: 35px" max="24" maxlength="2" oninput="maxLengthCheck(this)"/><label>시</label>
                        <input id="MediaStM" name="MediaStM" class="TimeNumber" type="number" value="<%=MediaStart_m %>" style="width: 35px" max="60" maxlength="2" oninput="maxLengthCheck(this)"/><label>분</label>
                        <input id="MediaStS" name="MediaStS" class="TimeNumber" type="number" value="<%=MediaStart_s %>" style="width: 35px" max="60" maxlength="2" oninput="maxLengthCheck(this)"/><label>초</label>
                    </td>
                    <td class="left">
                        <input id="MediaEtH" name="MediaEtH" class="TimeNumber" type="number" value="<%=MediaEnd_h %>" style="width: 35px" max="24" maxlength="2" oninput="maxLengthCheck(this)"/><label>시</label>
                        <input id="MediaEtM" name="MediaEtM" class="TimeNumber" type="number" value="<%=MediaEnd_m %>" style="width: 35px" max="60" maxlength="2" oninput="maxLengthCheck(this)"/><label>분</label>
                        <input id="MediaEtS" name="MediaEtS" class="TimeNumber" type="number" value="<%=MediaEnd_s %>" style="width: 35px" max="60" maxlength="2" oninput="maxLengthCheck(this)"/><label>초</label>
                     </td>
					<td class="left"><input type="button" value="저장" onclick="chk_save('<%=i%>');"></td>
				</tr>
					 
				</form>
				<%
							If Rs("MediaLink")<>"" Then 
								MediaLinkCnt = MediaLinkCnt + 1
							Else
								NoMediaLinkCnt = NoMediaLinkCnt + 1
							End If 
				      i = i + 1
							Rs.MoveNext
						Loop 
					End If 
					End If 
				%>
			</tbody>
		</table>
		<!-- E : 리스트 -->
		</div>
	<section>
<!--총영상:<%=i-1%>	등록영상:<%=MediaLinkCnt%>개 미등록영상:<%=NoMediaLinkCnt%> 등록율<%=(MediaLinkCnt/(i-1))*100%>%-->