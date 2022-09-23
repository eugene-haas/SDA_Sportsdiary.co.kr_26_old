<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <script src="/pub/js/swimming/gameatt.js?v=190820"></script>
</head>


<%
'#####################################
'결제 관련 페이지 순서
' apply-parti.asp >  apply-parti__pay.asp > /sportsdiary.co.kr/swimming/M_Player/home/payment/INIStdPayReturn.asp
'
'#####################################







'leaderinfo = session("leaderinfo") '시간되면 만료되니까
leaderinfo = request.Cookies("leaderinfo")
'If isArray(leaderinfo) = True And session("chkrndno") = "" Then
If leaderinfo <> "" And session("chkrndno") = "" Then

	Set leader = JSON.Parse( join(array(leaderinfo)) )

'	s_team =  leaderinfo(0)
'	s_username =  leaderinfo(1)
'	s_birthday =  leaderinfo(2)
'	s_userphone =  leaderinfo(3)
'	s_tidx = leaderinfo(4)
'	s_idx = leaderinfo(5)

	s_team =  leader.Get("a")
	s_username =  leader.Get("b")
	s_birthday = leader.Get("c")
	s_userphone =  leader.Get("d")
	s_tidx = leader.Get("e")
	s_idx = leader.Get("f")

	'session("leaderinfo") = "" '새로고침 막음용
Else
	Response.redirect "/home/page/list-pro.asp"
	Response.end
End if






'Response.write isArray(leaderinfo)
'Response.write session("chkrndno")
'Response.end

	'검색인경우...
	'F1
	'F2


	Set db = new clsDBHelper



	'게임정보 (종목당 2명이상참가제한, 선수별 최대 참가종목 가능수)
	SQL = "select  gametitlename,games,gamee,teamLimit,attgameCnt,gamearea from sd_gameTitle where delyn = 'N' and gametitleidx = '" & s_tidx & "'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		title = rs(0)
		games = Replace(Left(rs(1),10),"-",".")
		gamee = Replace(Left(rs(2),10),"-",".")
		gamearea = rs(5)
	End if





	'리더정보
	SQL = "Select team,max(username),max(birthday),max(userphone),max(idx),teamnm,max(kskey)  from tblReader where delyn = 'N' and username = '"&s_username&"' and userphone = '"&s_userphone&"' and startyear = '"&year(now)&"' group by team,teamnm"
	'SQL = "Select team,username,birthday,userphone,max(idx) as idx,teamnm,kskey  from tblReader where delyn = 'N' and username = '"&s_username&"' and userphone = '"&s_userphone&"' and startyear = '"&year(now)&"'  group by team,username,birthday,userphone,teamnm,kskey"
	'SQL = "Select team,teamnm  from tblReader where idx = '"&s_idx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'여러팀의 리더일수 있다.

'################################################
'테스트 2021 5 26
'################################################
If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
'	Response.write SQL & "----------------"
End if
'################################################

	If Not rs.EOF Then
		arrR = rs.GetRows()


		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			t_team = arrR(0, ari)
			t_username= arrR(1, ari)
			t_birthday= arrR(2, ari)
			t_userphone= arrR(3, ari)
			t_idx= arrR(4, ari)
			t_teamnm= arrR(5, ari)
			t_kskey = arrR(6, ari)

			'세션제설정
			If arrR(0, ari) = F2	 then
				s_team =  arrR(0, ari)
				s_username =  arrR(1, ari)
				s_birthday =  arrR(2, ari)
				s_userphone =  arrR(3, ari)
				s_idx = arrR(4, ari)
				s_teamnm = arrR(5, ari)
				s_kskey = arrR(6, ari)


				Dim arrinfo(5)
				arrinfo(0) = s_team
				arrinfo(1) = s_username
				arrinfo(2) = s_birthday
				arrinfo(3) = s_userphone
				arrinfo(4) = s_tidx
				arrinfo(5) = s_idx


				Set mobj =  JSON.Parse("{}")
				Call mobj.Set("a", arrinfo(0) )
				Call mobj.Set("b", arrinfo(1) )
				Call mobj.Set("c", arrinfo(2) )
				Call mobj.Set("d", arrinfo(3) )
				Call mobj.Set("e", arrinfo(4) )
				Call mobj.Set("f", arrinfo(5) )
				strmemberjson = JSON.stringify(mobj)
		'		strmemberjson = f_enc(strmemberjson)

				Response.Cookies("leaderinfo") = strmemberjson
				Response.Cookies("leaderinfo").domain = CHKDOMAIN
				'session("leaderinfo") = arrinfo
			End if
			'세션제설정
		Next

		If s_team <> "" Then
			teamcd = s_team
		else
			teamcd = arrR(0,0)
		end if

		If F2 <> "" Then
			teamcd = F2
		End if





		Function chkfileupload(teamnm)
			Dim chkstr(3)
			Dim i , returnval
			returnval = False

			chkstr(0) = "초등"
			chkstr(1) = "중학교"
			chkstr(2) = "고등학교"
			chkstr(3) = "국제학교" '고등 (서울용산국제학교)

			For i = 0 To ubound(chkstr)
				'Response.write InStr(teamnm, chkstr(i)) & "<br>"
				If InStr(teamnm, chkstr(i)) > 0 Then
					returnval = true
				End if
			Next

			chkfileupload = returnval
		End Function


		If s_teamnm <> "" Then
			chkteamnm = s_teamnm
		else
			chkteamnm = arrR(5,0)
		end if

		'초중고인지 체크
		chkfileteam= chkfileupload(chkteamnm)

		'클럽 국제 등등 이상한학교가 많다 코드로 포함된 선수가 있는 CDB(부) 를 구하자 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 21.03.09 추가 (동현 특이학교 추가 요청) 선수불러올때도 참고하자... 팀명칭은 같으나 코드는 다르다..초중고대 ...
		SQL = "Select top 1 cdb,cdbnm From tblPlayer Where team = '"&teamcd&"' and delyn = 'N' and entertype = 'E'  and CDB in ('Y','Z','7') " '초중고선수가 있다면
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			chkfileteam = false
		Else
			chkfileteam = true
		End if
		'클럽 국제 등등 이상한학교가 많다 코드로 포함된 선수가 있는 CDB(부) 를 구하자 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 21.03.09 추가 (동현 특이학교 추가 요청)




		Function GetRandomNum(nRange)
			Randomize
			GetRandomNum = (Int(nRange * Rnd) + 1)
		End Function



		SQL = "select team,teamnm,fileUrl,gubun from  sd_schoolConfirm  where gametitleidx = '"&s_tidx&"' and team = '"&teamcd&"' and leaderIDX = '"&s_idx&"'  "


'################################################
'테스트 2021 5 26
'################################################
If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
	Response.write teamcd & "----------------"
End if
'################################################


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'If Not rs.eof Then
		Do Until rs.eof 
			c_gubun = rs("gubun")
			furl = rs(2)
			fnm = LCase(Mid(furl, InStrRev(furl, "/") + 1))

			If c_gubun = "1" Then '학교장
				If InStr(fnm,"hwp") > 0 Then
				filestr = 	"<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&furl&"?v="&GetRandomNum(1234)&""">" & fnm & "</a>"
				Else
				filestr = 	"<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&furl&"?v="&GetRandomNum(1234)&""" target=""_blank"">" & fnm & "</a>"
				End If
			Else
				If InStr(fnm,"hwp") > 0 Then
				filestr2 = "<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&furl&"?v="&GetRandomNum(1234)&""">" & fnm & "</a>"
				Else
				filestr2 = "<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&furl&"?v="&GetRandomNum(1234)&""" target=""_blank"">" & fnm & "</a>"
				End If
			End if
		rs.movenext
		loop
		'End if
	End If


	'추가된 선수들
	'order by  isnull(gameorder,'9999')  asc"
	'fldboo = " ,(SELECT  STUFF(( select ','+ CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM for XML path('') ),1,1, '' )) as cdcnm "
	fldboo = " ,(SELECT  STUFF(( select ','+ itgubun + CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM,itgubun order by itgubun for XML path('') ),1,1, '' )) as cdcnm "
	fld = " a.playeridx,a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.seq " & fldboo
	SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team = '"&teamcd&"' and a.tidx = '"&s_tidx&"' and delyn = 'N'  and a.leaderidx = '"&s_idx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql

  If Not rs.EOF Then
	arrP = rs.GetRows()
	'Call getrowsdrow(arrp)
  End If


  '참가신청확인
  SQL_Order = "Select count(*) as Sql_Cnt From tblSwwimingOrderTable "
  SQL_Order = SQL_Order & " Where del_yn = 'N'  and gubun = '1' "
  SQL_Order = SQL_Order & " and gametitleidx = '" & s_tidx & "'	"
  SQL_Order = SQL_Order & " and team = '" & teamcd & "'	"
  SQL_Order = SQL_Order & " and Leaderidx = '"&s_idx&"' and oOrderstate  in ('00', '01' ) "
  Set rs_order_cnt = db.ExecSQLReturnRS(SQL_Order , null, ConStr)

'##############################################
' 소스 뷰 경계
'##############################################
%>
<body <%=CONST_BODY%>>

<%
'		Response.write chkfileteam
'		Response.write  InStr(chkteamnm, "고등학교")
'		Call chkfileupload(chkteamnm)
%>

<%'=F2%>
	<div id="printdiv" style="display:none;"><%'인쇄할내용여기로 불러와%></div>

	<form method='post' name='sform'><input type='hidden' name='p'></form>
	<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
	<input type="hidden" id="tidx" value="<%=s_tidx%>">
	<input type="hidden" id="leaderidx" value="<%=s_idx%>">

    <!-- s 헤더 영역 -->
      <header class="l_header">
        <div class="l_header-wrap clear">
          <h1 class="l_header__con">
            참가신청서
          </h1>
          <a href="http://sw.sportsdiary.co.kr/home/helpmenual.pdf" class="l_header__manual" target="_blank">메뉴얼</a>
        </div>
      </header>
    <!-- e 헤더 영역 -->

    <!-- s 메인 영역 -->
      <div class="l_main">
        <section class="l_main__contents">


			<div class="m_apply-parti">
			  <div class="m_apply-parti__header">
				<h1 class="m_apply-parti__header__con"><%=title%></h1>
				<span><%=games%> ~ <%=gamee%> (<%=gamearea%>)</span>
            <button  class="m_apply-parti__header__btn-print t_pay" type="button"  name="button" onclick="javascript:mx.print(<%=s_tidx%>,'<%=teamcd%>');">참가신청정보출력</button>
			  </div>
			  <ul class="m_apply-parti__con">
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">팀(소속) 정보</h2>


				  <ul class="m_apply-parti__con__list__ul clear">

					<li>
					  <h3>팀명</h3>
						  <div class="list-pro__search__selc-box">
							<select id="teamnm" class="list-pro__search__selc-box__selc" onchange="px.goSubmit({'F1':'team','F2':$(this).val()},'<%=pagename%>')">
								<%
									If IsArray(arrR) Then
										For ari = LBound(arrR, 2) To UBound(arrR, 2)
										t_team = arrR(0, ari)
										t_teamnm= arrR(5, ari)
										%><option value="<%=t_team%>" <%If t_team = teamcd then%>selected<%End if%>><%=t_teamnm%></option><%
										Next
									End if
								%>
							</select>
						  </div>
					</li>

					<li>
					  <h3>팀코드</h3>
					  <span id="teamcd"><%=teamcd%></span>
					</li>
				  </ul>
				  <p class="m_apply-parti__con__list__noti">※ 대한체육회에 등록되어 있는 지도자 정보를 불러옵니다. 정보가 맞지 않을 경우 대한체육회에 접속하여 정보 수정 후 참가신청을 진행해주세요.</p>
				</li>
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">신청자 정보</h2>
				  <ul class="m_apply-parti__con__list__ul clear">
					<li>
					  <h3>이름</h3>
					  <span><%=s_username%> (<%=t_kskey%>)</span>
					</li>
					<li>
					  <h3>연락처</h3>
					  <span><%=s_userphone%></span>
					</li>
				  </ul>
				</li>









<%'초중고만 나오드록 요청 황 20210209%>
<%If chkfileteam  = True then%>
<%'##################################################################################%>
				<form id="FILEFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">학교장 확인서 첨부
                 <span class="m_apply-parti__con__list__h2__noti">※ 파일 재 첨부 시 첨부파일 수정이 가능합니다. (잘못된 파일 등록후 신청 시 참가실격이 될 수 있습니다.) <br>※ 1개 파일만 첨부가 가능하므로 다수학생이 소속된 클럽팀의 경우 취합 후 하나의 파일로 업로드 해 주시기 바랍니다.
				 <br>여러장의 학교장 확인서 첨부시 한 파일로 압축하여 업로드 해야합니다.(두개 이상의 파일 첨부 불가함)
				 </span>
              </h2>
				  <div class="m_apply-parti__con__list__file clear">
					<span>첨부파일</span>
					<div class="m_apply-parti__con__list__file__inp-box">
					  <input type="hidden" id="f_tidx" name="f_tidx" value="<%=s_tidx%>">
					  <input type="hidden" id="f_leaderidx" name="f_leaderidx" value="<%=s_idx%>">
					  <input type="hidden" id="f_teamcd" name="f_teamcd">
					  <input type="hidden" id="f_teamnm" name="f_teamnm">
					  <input id="inpFileApply" name="inpFileApply" type="file" oninput="mx.fileUpload();">
					</div>
					<label for="inpFileApply">파일첨부</label>
					<!--<button id="btnInpFileDel" type="reset" name="button">삭제</button> -->
					<p class="m_apply-parti__con__list__file__noti">(업로드 파일형식 : pdf, jpg, png, hwp 등)</p>
				  </div>
				  <ul class="m_apply-parti__con__list__ul t_w100per clear">
					<li>
					  <h3>첨부파일</h3>
					  <span id="recomfile"><%=filestr%></span>
					</li>
				  </ul>
				</li>
				</form>

				<form id="FILEFORM2" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">학교폭력처분이력부존재서약서 첨부
                 <span class="m_apply-parti__con__list__h2__noti">※ 파일 재 첨부 시 첨부파일 수정이 가능합니다. (잘못된 파일 등록후 신청 시 참가실격이 될 수 있습니다.) <br>※ 1개 파일만 첨부가 가능하므로 다수학생이 소속된 클럽팀의 경우 취합 후 하나의 파일로 업로드 해 주시기 바랍니다.
				 <br>여러장의 학교폭력처분이력부존재서약서 첨부시 한 파일로 압축하여 업로드 해야합니다.(두개 이상의 파일 첨부 불가함)
				 </span>
              </h2>
				  <div class="m_apply-parti__con__list__file clear">
					<span>첨부파일</span>
					<div class="m_apply-parti__con__list__file__inp-box">
					  <input type="hidden" id="f_tidx2" name="f_tidx2" value="<%=s_tidx%>">
					  <input type="hidden" id="f_leaderidx2" name="f_leaderidx2" value="<%=s_idx%>">
					  <input type="hidden" id="f_teamcd2" name="f_teamcd2">
					  <input type="hidden" id="f_teamnm2" name="f_teamnm2">
					  <input id="inpFileApply2" name="inpFileApply2" type="file" oninput="mx.fileUpload2();">
					</div>
					<label for="inpFileApply2">파일첨부</label>
					<!--<button id="btnInpFileDel" type="reset" name="button">삭제</button> -->
					<p class="m_apply-parti__con__list__file__noti">(업로드 파일형식 : pdf, jpg, png, hwp 등)</p>
				  </div>
				  <ul class="m_apply-parti__con__list__ul t_w100per clear">
					<li>
					  <h3>첨부파일</h3>
					  <span id="recomfile2"><%=filestr2%></span>
					</li>
				  </ul>
				</li>
				</form>
<%'##################################################################################%>
<%End if%>






				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">출전 정보
                 <span class="m_apply-parti__con__list__h2__noti">※ 참가종목 선택 후 상단의 '참가신청정보 출력' 버튼으로 신청내역 확인이 가능합니다.<br> ※ 학생 선수는 첨부파일 미 첨부 시 신청 완료 불가하며 필히 문서를 첨부하여야 신청 정보가 저장되며 결제 가능합니다.</span>
              </h2>
				  <div class="m_apply-parti__con__list__tbl-box" id="printarea">
					<table class="m_apply-parti__con__list__tbl t_scroll">
					  <caption>출전정보 표</caption>
					  <thead class="m_apply-parti__con__list__tbl__thead">
						<tr>
						  <th scope="col">이름</th>
						  <th scope="col">생년월일</th>
						  <th scope="col">성별</th>
						  <th scope="col">종별</th>
						  <th scope="col">학년</th>
						  <th scope="col">참가종목</th>
						  <th scope="col"> </th>
						</tr>
					  </thead>

					  <tbody class="m_apply-parti__con__list__tbl__tbody">
						<!-- #applyPartiTbodyNone.s_hide = 첫줄 아무것도없음 숨기기 -->
			<%
				If IsArray(arrP) Then
					For ari = LBound(arrP, 2) To UBound(arrP, 2)
					'a.playeridx,a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass
					a_pidx = arrP(0, ari)
					a_nm = arrP(1, ari)
					a_birth = arrP(2, ari)
					a_sex = arrP(3, ari)
					If a_sex = "1" Then
						a_sexstr = "남"
					Else
						a_sexstr = "여"
					End if
					a_CDB = arrP(4, ari)
					a_CDBNM = arrP(5, ari)
					a_userclass = isNulldefault(arrP(6, ari),"")
					a_seq = arrP(7,ari)

					a_cdcnm = arrP(8,ari)


					If InStr(a_CDBNM,"초등") > 0 then
						If CDbl(a_userclass) < 5 Then
							a_CDBNM = Replace(a_CDBNM , "초등", "유년")
						End if
					End if
					%>
						<tr class="s_selected">
						  <th scope="row"><%=a_nm%></th>
						  <td><%=a_birth%></td>
						  <td><%=a_sexstr%></td>
						  <td><%=a_CDBNM%></td>
						  <td><%=a_userclass%></td>
						  <td>
						  <% If CLng(rs_order_cnt(0)) = 0 Then %>
							<button id="btnPickPlayer01" type="button" name="button" onclick="mx.setBooList(<%=a_seq%>,'<%=a_CDBNM%>',<%=a_sex%>,'<%=a_userclass%>','1')"></button>
						  <% End If %>
						  </td>

						  <td>


							<%If a_cdcnm <> "" Then
								a_cdcnmarr = Split(a_cdcnm,",")
							%>
							<span>참가 종목을 선택해주세요.</span>
							<ul>
							  <%for n = 0 To ubound(a_cdcnmarr)%>

							<%
							If Left(a_cdcnmarr(n),1) = "I" Then
								btnclr = ""
							Else
								btnclr = "style=""border:1px solid #1682D6;box-sizing:border-box;"""
							End if
							%>

							  <li id='li_kind_<%=a_seq%>_<%=n%>' <%=btnclr%>>
								<span><%=Mid(a_cdcnmarr(n),2)%></span>
								<!--결제한 내역이 있으면 삭제기능을 제거한다
								  1) 김동현 수정 (2020년 5월 12일)
								-->

								<% If CLng(rs_order_cnt(0)) = 0 Then %>
									<input type="image" id="inputimg_<%=a_seq%>_<%=n%>" alt="해당 종목 삭제" src="../images/btn-DeliteType01.svg" onclick="mx.delKind(<%=a_seq%>,'<%=a_cdcnmarr(n)%>','li_kind_<%=a_seq%>_<%=n%>')">
								<% End If %>
							  </li>
							  <%next%>

							</ul>
							<%End if%>

						  </td>

						</tr>
					<%
					Next
				Else
				%>
						<tr id="applyPartiTbodyNone"><!-- class="s_hide" -->
						  <td colspan="7">참가 선수를 추가해주세요</td>
						</tr>
				<%
				End if
			%>
					  </tbody>
					</table>

					<table class="m_apply-parti__con__list__tbl">
					  <caption>출전정보 확인 표</caption>
					  <thead class="m_apply-parti__con__list__tbl__thead">
						<!-- <tr class="s_selected">
						  <th scope="col">No</th>
						  <th scope="col">이름</th>
						  <th scope="col">생년월일</th>
						  <th scope="col">성별</th>
						  <th scope="col">종별</th>
						  <th scope="col">학년</th>
						  <th scope="col">세부종목</th>
						</tr>
					  </thead>
					  <tbody class="m_apply-parti__con__list__tbl__tbody">

						<tr>
						  <td>﻿1</td>
						  <th scope="row">﻿﻿최현아1</th>
						  <td>﻿2001.04.06</td>
						  <td>여</td>
						  <td>고등부</td>
						  <td>4</td>
						  <td>개인혼영200m<br>접영200m<br>수구 / 31<br>다이빙 스프링보드 3m<br>다이빙 싱크로다이빙 10m</td>
						</tr> -->
					  </tbody>
					</table>
				  </div>
				  <% If CLng(rs_order_cnt(0)) = 0 Then %>
					<button id="btnPlayerAddRemove" type="button" name="button" onclick="mx.setMemberList()">참가 선수 추가/삭제</button>
				  <% End If %>
				</li>




			  <%
			  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			  'If CLng(rs_order_cnt(0)) > 0 Then %>
			  <%
				  SQL_Order_rs = "Select  "
				  SQL_Order_rs = SQL_Order_rs & "  OrderIDX " '텓이블의 id값
				  SQL_Order_rs = SQL_Order_rs & " ,OR_NUM " '주문번호
				  SQL_Order_rs = SQL_Order_rs & " ,case when OorderPayType = 'Card' then '카드결제' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'DirectBank' then '실시간계좌이체' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'VBank' then '가상계좌' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'HPP' then '휴대폰결제' end as pay_type " '결제종류

				  SQL_Order_rs = SQL_Order_rs & " ,case when OorderState ='00' then '입금대기'  " ' 결제상태 미입금
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='01' then '결제완료' " ' 결제상태 입금
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='88' then '취소요청중' "
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='89' then '취소완료' "
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='99' then '결제취소' end as order_state " ' 결제상태 취소
				  SQL_Order_rs = SQL_Order_rs & " ,OorderState As order_code	"
				  SQL_Order_rs = SQL_Order_rs & " ,isnull(OrderPrice,0)as OrderPrice	"
				  SQL_Order_rs = SQL_Order_rs & " ,Order_tid "
				  SQL_Order_rs = SQL_Order_rs & " ,Order_MOID "
				  SQL_Order_rs = SQL_Order_rs & " ,reg_date "

				  SQL_Order_rs = SQL_Order_rs & " ,vactbankname "
				  SQL_Order_rs = SQL_Order_rs & " ,vact_num "

				  SQL_Order_rs = SQL_Order_rs & " ,reg_date "

				  SQL_Order_rs = SQL_Order_rs & " From tblSwwimingOrderTable "
				  SQL_Order_rs = SQL_Order_rs & " Where del_yn = 'N' and gubun='1' "
				  SQL_Order_rs = SQL_Order_rs & " and gametitleidx = '" & s_tidx & "'	"
				  SQL_Order_rs = SQL_Order_rs & " and team = '"&teamcd&"'"
				  SQL_Order_rs = SQL_Order_rs & " and LeaderIDX = '"&s_idx&"'"
				  Set rs = db.ExecSQLReturnRS(SQL_Order_rs , null, ConStr)
					If Not rs.EOF Then
					arrO = rs.GetRows()
					'Call getrowsdrow(arrO)
					End IF
				  %>
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">결제 정보
                 <span class="m_apply-parti__con__list__h2__noti">※ 결제완료 상태에서는 참가자 종목 추가 및 수정이 불가하니 결제 취소 요청 후 재 등록하시기 바랍니다.</span>
              </h2>
				  <div class="m_apply-parti__con__list__tbl-box">
					<table class="">
					  <caption>결제 정보 표시</caption>
					  <thead class="m_apply-parti__con__list__tbl__thead">
						<tr>
						  <th scope="col" style="width:16%;">주문번호</th>
						  <th scope="col" style="width:16%;">주문형식</th>
						  <th scope="col" style="width:16%;">주문금액</th>
						  <th scope="col" style="width:16%;">주문상태</th>
						  <th scope="col" style="width:16%;">날짜</th>
						  <th scope="col" style="width:16%;">관리</th>
						</tr>
					  </thead>
					  <tbody class="m_apply-parti__con__list__tbl__tbody">
						<!-- #applyPartiTbodyNone.s_hide = 첫줄 아무것도없음 숨기기 -->
						<%
							If IsArray(arrO) Then
								For ari = LBound(arrO, 2) To UBound(arrO, 2)
								p_orderidx = arrO(0, ari)
								p_orderno = arrO(1, ari)
								p_ordertype =arrO(2, ari)
								p_orderstate= arrO(3, ari)
								p_orderprice =arrO(5, ari)
								p_order_tid = arrO(6,ari)
								p_order_mid = arrO(7,ari)
								p_orderdate = arrO(8,ari)

								p_vact_bk = arrO(9,ari)
								p_vact_no = arrO(10,ari)

								%>

								<tr class="s_selected">
								  <th scope="row"><%=p_orderno%></th>
								  <td><%=p_ordertype%>
								  <%
								  If p_ordertype = "가상계좌" then
								  Response.write  ":"&  p_vact_bk & " " & p_vact_no
								  End if
								  %>
								  </td>
								  <td><%=FormatNumber(p_orderprice,0)%>원</td>
								  <td><%=p_orderstate%></td>
								  <td><%
								  Response.write p_orderdate
								  %></td>
								  <td style="float:center;">
									 <div class="order_button">
										<%
										'1. 가상계좌이고 입금대기 중이라면
										'2. 취소하시겠습니까 (결제정보삭제, 	'tblgamereuqest  정보  delete _r  도삭제 다시돌아오기)
										'3. 결제가 완료된것이라면

										If p_orderstate = "취소요청중" Or p_orderstate = "취소완료"   Then
											%>-<%
										else
											If p_ordertype = "가상계좌" And p_orderstate = "입금대기" Then
											%><input type="button" value="취소요청" onclick="javascript:if(confirm('취소 완료 후 재신청 - 결제를 해야 신청이 완료됩니다.\n 정말 취소 하시겠습니까?')){px.goSubmit({oidx:<%=p_orderidx%>,otid:'<%=p_order_tid%>'},'apply-vccdel.asp')}"><%
											else
											%>
											<input type="button" value="취소요청" onclick="javascript:mx.setRefundinfo(<%=p_orderidx%>);">
											<%End if%>
										<%End if%>
									 </div>
								  </td>
								</tr>

								<%
								Next
							End if
						%>

					  </tbody>
					</table>

				</li>

				<%If test = "ok" then' test 취소관련 샘플작업#####%>
				<%
					'								refundURL = "https://iniapi.inicis.com/api/v1/refund"
					'
					'
					'								send_text = "timestamp="&timestamp
					'
					'								send_text = send_text & "&type=Refund"
					'								send_text = send_text & "&paymethod=Card"
					'								send_text = send_text & "&clientIp=115.68.112.26" '요청서버의 아이피?
					'
					'
					'								send_text = send_text & "&mid="&maid '가맹점아이디
					'								send_text = send_text & "&tid="&oJSON.data("tid") '취소요청 TID
					'								send_text = send_text & "&msg=고객취소요청"

													'send_text = send_text & "&authToken="&Server.URLEncode(authToken)
													'send_text = send_text & "&signature="&signature
													'send_text = send_text & "&SignKey="&signKey
													'send_text = send_text & "&format="&Format

					'hashkey="ItEQKi3rY7uvDS8l"
					'MakeSignature

					'								send_text = send_text & "&charset=UTF-8"
					'								send_text = send_text & "&hashData=hash(KEY+type+paymethod+timestamp+clientIp+mid+tid)"
					'
					'
					'				signature = MakeSignature(signParam)
					'
					'					 			xmlHttp.Open "POST", refundURL, False
					'					 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
					'								xmlHttp.Send send_text
					'								ask_result=Cstr( xmlHttp.responseText )
					'								Set xmlHttp = nothing
					'									'response.write "<br>" &  ask_result &"<br>"
					'									'################# ask_result로 반환된 전문 중  "resultCode": "0000"  이면 정상 망취소 처리.
					'
					'								Order_tid = oJSON.data("tid")
					'								response.end
					'			  			End If
					'						Err.Clear      ' Clear the error.
					'						On Error GoTo 0
					'					' 망취소여기까지
					'				Set xmlHttp = nothing
				%>
				<%End if'취소관련 샘플작업#################%>
			  <%'End If
  			  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			  %>



				  <div class="m_apply-parti__footer clear">
					  <button id="btnGoList" type="button" name="button" onclick="px.goSubmit({},'list-pro.asp')">대회리스트</button>
					<!-- <button  type="button" name="button" onclick="$('#printarea').printThis({importCSS: false,loadCSS: '/pub/js/print/print_swim.css',header: '<h1><%=title%></h1>'});">참가신청정보출력</button> -->
					<!-- <button id="btnSaveApply" type="button" name="button">임시 저장</button> -->

					<div class="m_apply-parti__footer__right-group">
					  <% If CLng(rs_order_cnt(0)) = 0 Then %>

					  <button id="btnCompleteApply" type="button" name="button" onclick="mx.wOK(<%=s_tidx%>,<%=s_idx%>,'<%=a_cdcnm%>','<%=teamcd%>')">작성 완료</button><!-- class="s_disable" -->
					  <% End If %>

					</div>
				  </div>



			  <div class="m_apply-parti__footer t_pay clear">
				<div class="m_apply-parti__footer__left-group">
				  <button id="btnGoList" type="button" name="button">리스트 가기</button>
				  <button id="btnApplyPrint" type="button" name="button">참가신청정보출력</button>
				</div>

				<div class="m_apply-parti__footer__right-group">
				  <button id="btnRetouchApply" type="button" name="button">정보 수정</button>
				  <button id="btnCompleteApplyPay"  type="button" name="button">신청 완료</button>
				</div>
			  </div>

			</div>



        </section>
      </div>
    <!-- e 메인 영역 -->











    <!-- s 팝업창 영역 -->
      <div class="l_modal-wrap" id="paycancel">
        <div class="l_modal"  id="cancelbody">
			<!-- 부목록 -->
        </div>
      </div>



      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="player-listModal">
        <div class="l_modal">
          <section class="m_modal-player-list">
            <div class="m_modal-player-list__header">
              <h1 class="m_modal-player-list__header__h1">참가 선수 추가/삭제</h1>
			  <span class="m_modal-player-list__header__noti">사용중</span>
            </div>
            <div class="m_modal-player-list__con" id="playerlist">
				<!-- 내용 -->
			</div>

            <div class="m_modal-player-list__btns clear">
              <button id="btnOkPlayerModal" type="button" name="button" onclick="mx.setPlayer()">확인</button>
              <button onclick="closeModal()" id="btnCancelPlayerModal" type="button" name="button">취소</button>
            </div>
          </section>
        </div>
      </div>


      <div class="l_modal-wrap" id="player-selc-typeModal">
        <div class="l_modal"  id="boolist">
			<!-- 부목록 -->
        </div>
      </div>


	  <div class="l_modal-wrap" id="applyCancelModal">
        <div class="l_modal">
          <section class="m_modal-apply-noti">
            <span class="m_modal-apply-noti__header">작성을 취소하시겠습니까?</span>
            <span class="m_modal-apply-noti__con">작성을 취소하시면 리스트로 돌아갑니다.</span>
            <div class="m_modal-apply-noti__btns clear">
              <button onclick="closeModal()" id="btnOk-ApplyCancelModal" type="button" name="button">확인</button>
              <button onclick="closeModal()" id="btnCancel-ApplyCancelModal" type="button" name="button">취소</button>
            </div>
          </section>
        </div>
      </div>
    <!-- e 팝업창 영역 -->




	<script>
      function closeModal(){
        $('.l_modal-wrap').fadeOut(300);
        $('body').removeClass('s_no-scroll');
      }
    </script>
  </body>
</html>
