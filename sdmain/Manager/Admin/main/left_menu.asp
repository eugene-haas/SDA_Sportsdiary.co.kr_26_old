
<!-- S : navi left-navi 네비게이션 -->
<nav>
  <div id="left-navi">

    <!--<div class="depth">
      <h2>어드민 관리</h2>
      <ul>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./Admin_List.asp')">어드민 관리</a></li>
      </ul>
    </div>-->

		<!--<div class="depth">
      <h2>어드민관리</h2>
      <ul class="depth-2">
        <li class="depth-2">
          어드민관리
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Admin_List.asp')">어드민관리</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>-->

						
<%
						
	iLoginID = Request.Cookies("UserID")
	'iLoginID = decode(iLoginID,0)
  iLoginID = crypt.DecryptStringENC(iLoginID)

	LCnt = 0

	iType = "2"

	LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End
		
	Set LRs = DBCon7.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof

				LCnt = LCnt + 1
				iRoleDetailGroup1 = LRs("RoleDetailGroup1")
				iRoleDetailGroup1Nm = LRs("RoleDetailGroup1Nm")
%>
		<div class="depth">
      <h2><%=iRoleDetailGroup1Nm %></h2>
      <ul class="depth-2" id="RG1_<%=iRoleDetailGroup1 %>">

			</ul>
    </div>
<%
			LRs.MoveNext
		Loop

	End If

	LRs.close



	LCnt1 = 0

	iType = "3"

	LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End
		
	Set LRs = DBCon7.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then

	Do Until LRs.Eof

				LCnt1 = LCnt1 + 1
				iRoleDetailGroup1 = iRoleDetailGroup1&"^"&LRs("RoleDetailGroup1")&""
				iRoleDetailGroup1Nm = iRoleDetailGroup1Nm&"^"&LRs("RoleDetailGroup1Nm")&""
				iRoleDetailGroup2 = iRoleDetailGroup2&"^"&LRs("RoleDetailGroup2")&""
				iRoleDetailGroup2Nm = iRoleDetailGroup2Nm&"^"&LRs("RoleDetailGroup2Nm")&""

			LRs.MoveNext
		Loop
					
	End If

	LRs.close



	LCnt2 = 0

	iType = "4"

	LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End
		
	Set LRs = DBCon7.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then

	Do Until LRs.Eof

				LCnt2 = LCnt2 + 1
				iRoleDetail_2 = iRoleDetail_2&"^"&LRs("RoleDetail")&""
				iRoleDetailNm_2 = iRoleDetailNm_2&"^"&LRs("RoleDetailNm")&""
				iRoleDetailGroup1_2 = iRoleDetailGroup1_2&"^"&LRs("RoleDetailGroup1")&""
				iRoleDetailGroup1Nm_2 = iRoleDetailGroup1Nm_2&"^"&LRs("RoleDetailGroup1Nm")&""
				iRoleDetailGroup2_2 = iRoleDetailGroup2_2&"^"&LRs("RoleDetailGroup2")&""
				iRoleDetailGroup2Nm_2 = iRoleDetailGroup2Nm_2&"^"&LRs("RoleDetailGroup2Nm")&""
				iLink_2 = iLink_2&"^"&LRs("Link")&""

			LRs.MoveNext
		Loop
					
	End If

	LRs.close

	
%>

<% if LCnt1 > 0 then %>

<script type="text/javascript">

	var LCnt1 = Number("<%=LCnt1%>");

	if (LCnt1 > 0) {

		var iRoleDetailGroup1 = "<%=iRoleDetailGroup1%>";
		var iRoleDetailGroup1Nm = "<%=iRoleDetailGroup1Nm%>";
		var iRoleDetailGroup2 = "<%=iRoleDetailGroup2%>";
		var iRoleDetailGroup2Nm = "<%=iRoleDetailGroup2Nm%>";

		var iRoleDetailGroup1arr = iRoleDetailGroup1.split("^");
		var iRoleDetailGroup1Nmarr = iRoleDetailGroup1Nm.split("^");
		var iRoleDetailGroup2arr = iRoleDetailGroup2.split("^");
		var iRoleDetailGroup2Nmarr = iRoleDetailGroup2Nm.split("^");

		for (var i = 1; i < LCnt1 + 1; i++) {

			var iHtmlSum2 = "";

			iHtmlSum2 = iHtmlSum2 + '<li class="depth-2">' + iRoleDetailGroup2Nmarr[i] + '<ul class="depth-3" id="RG2_' + iRoleDetailGroup2arr[i] + '"></ul></li>';

			$('#RG1_' + iRoleDetailGroup1arr[i] + '').append(iHtmlSum2);

		}

		var LCnt2 = Number("<%=LCnt2%>");

		if (LCnt2 > 0) {

			var iRoleDetail_2 = "<%=iRoleDetail_2%>";
			var iRoleDetailNm_2 = "<%=iRoleDetailNm_2%>";
			var iRoleDetailGroup1_2 = "<%=iRoleDetailGroup1_2%>";
			var iRoleDetailGroup1Nm_2 = "<%=iRoleDetailGroup1Nm_2%>";
			var iRoleDetailGroup2_2 = "<%=iRoleDetailGroup2_2%>";
			var iRoleDetailGroup2Nm_2 = "<%=iRoleDetailGroup2Nm_2%>";
			var iLink_2 = "<%=iLink_2%>";

			var iRoleDetail_2arr = iRoleDetail_2.split("^");
			var iRoleDetailNm_2arr = iRoleDetailNm_2.split("^");
			var iRoleDetailGroup1_2arr = iRoleDetailGroup1_2.split("^");
			var iRoleDetailGroup1Nm_2arr = iRoleDetailGroup1Nm_2.split("^");
			var iRoleDetailGroup2_2arr = iRoleDetailGroup2_2.split("^");
			var iRoleDetailGroup2Nm_2arr = iRoleDetailGroup2Nm_2.split("^");
			var iLink_2arr = iLink_2.split("^");

			for (i = 1; i < LCnt2 + 1; i++) {

				iHtmlSum2 = "";

				iHtmlSum2 = iHtmlSum2 + '<li><a href="javascript:;" onclick="javascript:fn_Link(&#39;' + iLink_2arr[i] + '&#39;)">' + iRoleDetailNm_2arr[i] + '</a></li>';

				$('#RG2_' + iRoleDetailGroup2_2arr[i] + '').append(iHtmlSum2);

			}

		}

	}

</script>

<% end if %>

    <!--<div class="depth">
      <h2>회원 관리</h2>
        <ul>
          <li class="depth-2">회원 관리
              <ul class="depth-3" id="FB">
                <li>
                  <a href="javascript:;" onclick="javascript:fn_Link('./User_List.asp')">회원정보</a>
                </li>
                <li>
                  <a href="javascript:;" onclick="javascript:fn_Link('./User_List_withdraw.asp')">탈퇴신청목록</a>
                </li>
              </ul>
          </li>  
        </ul>
    </div>-->

		<!--<div class="depth">
      <h2>협회정보</h2>
      <ul class="depth-2">
        <li class="depth-2">
          협회소개
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Info_Business_List.asp')">경영공시</a>
            </li>
          </ul>
        </li>
        <li class="depth-2">
          유도소개
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Info_JudoWord_List.asp')">유도용어</a>
            </li>
						<li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Info_SkillWord_List.asp')">기술용어</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>-->

		<!--<div class="depth">
      <h2>유도소식 </h2>
      <ul class="depth-2">
        <li class="depth-2">
          뉴스/공지
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./News_Notice_List.asp')">뉴스공지</a>
            </li>
          </ul>
        </li>
        <li class="depth-2">
          계간유도
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./News_Magazine_View_List.asp')">계간유도</a>
            </li>
						<li>
              <a href="javascript:;" onclick="javascript:fn_Link('./News_Magazine_Req_List.asp')">구독신청/내역조회</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>-->

    <!--<div class="depth">
      <h2>대회정보 </h2>
      <ul class="depth-2">
    <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./International_Schedule_List.asp')">국제대회</a></li>
      </ul>
    </div>-->

		<!--<div class="depth">
      <h2>팀/선수정보</h2>
      <ul class="depth-2">
        <li class="depth-2">
          팀/선수정보
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_team_info.asp')">팀정보</a>
            </li>
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_PlayerRegist.asp')">선수등록현황</a>
            </li>
          </ul>
        </li>
				<li class="depth-2">
          대표팀정보
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_A_entry.asp')">국가대표팀</a>
            </li>
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_A_Sub.asp')">국가대표후보선수</a>
            </li>
						<li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_A_Youth.asp')">청소년선수</a>
            </li>
						<li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_A_Children.asp')">꿈나무선수</a>
            </li>
          </ul>
        </li>
<li class="depth-2">
          심판/지도자정보
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_Inter_Judge.asp')">국제심판</a>
            </li>
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_Country_Judge.asp')">국내1급심판</a>
            </li>
						<li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Player_Coach.asp')">1급지도자</a>
            </li>
          </ul>
        </li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./Stadium_List.asp')">유도장정보</a></li>
      </ul>
    </div>-->

    <!--<div class="depth">
      <h2>커뮤니티</h2>
      <ul class="depth-2">
        <li class="depth-2">
          갤러리
          <ul class="depth-3">
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Community_Photo_List.asp')">포토갤러리</a>
            </li>
            <li>
              <a href="javascript:;" onclick="javascript:fn_Link('./Community_Motion_List.asp')">동영상갤러리</a>
            </li> 
          </ul>
        </li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./FAQ_list.asp')">FAQ</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_NewTabLink('/Community/Qa/list.asp')">질문과 답변(링크)</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_NewTabLink('/Community/Free/list.asp')">자유게시판(링크)</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_NewTabLink('/Community/Talk/list.asp')">관장님 대화방(링크)</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_NewTabLink('/Community/Info/list.asp')">시도지부/연맹 소식(링크)</a></li>
      </ul>
    </div>-->

    <!--<div class="depth">
      <h2>온라인서비스</h2>
      <ul class="depth-2">
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./Certificate_list.asp')">선수증 재발급</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./License_List.asp')">단증조회 및 재발급</a></li>
        <li class="depth-2"><a href="javascript:;" onclick="javascript:fn_Link('./Level_List.asp')">승단 리스트</a></li>
                
      </ul>
    </div>-->

  </div>
</nav>
<!-- E : navi -->