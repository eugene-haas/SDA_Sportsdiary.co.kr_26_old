<%
'#############################################
'릴레이 정보화면
'#############################################
	'request

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "TIDX") = "ok" then
    tidx = fInject(oJSONoutput.TIDX)
  End if

  If hasown(oJSONoutput, "GBIDX") = "ok" then
    gbidx = fInject(oJSONoutput.GBIDX)
  End if

  If hasown(oJSONoutput, "GNO") = "ok" then
    gameno = fInject(oJSONoutput.GNO)
  End if

  If hasown(oJSONoutput, "TM") = "ok" then
    tm = fInject(oJSONoutput.TM)
  End if

  If hasown(oJSONoutput, "TITLE") = "ok" then
    title = fInject(oJSONoutput.TITLE)
  End if


'Response.write "순서"
'Response.end



'리그토너먼트 구분 2, 3 
SQL = "Select max(gubun),count(*) from SD_tennisMember where gametitleidx ="&tidx&" and gamekey3 = '"&gbidx&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.eof Then
	gubunLT = rs(0)
	relayMembercnt = rs(1)
	gangtdno = getN(relayMembercnt)
End if



'토너먼트 리스트###################################################################
gidxfld = ", (SELECT  STUFF(( select top 10 ','+ CAST(idx AS varchar) from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ))  as gidx " '그룹소속선수들
pnmfld = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ) )  as pnm " '그룹소속선수들

tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
fldnm = fldnm & gidxfld & pnmfld  & " , a.t_win, a.t_lose ,a.bigo "


'and round = 1 마장마술에서 쓰는 라운드 개념과 다름 실지 토너먼트 라운드 수가 들어감
SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"'  and a.gubun < 100 and a.playeridx > 0 order by a.total_order asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call rsdrow(rs)
'Response.end

If Not rs.EOF Then
	arrZ = rs.GetRows()
	'리그토너먼트 구분 2, 3 
	'gubunLT = arrZ(1,0)
End If

%>




		<div class="gameHeader">

          <!-- 해당 경기 정보(몇번째 경기, 시간, 대회명) -->
          <div class="gameHeader__txts">
            <p class="gameHeader__header"><span class="gameDetail__order"><%=gameno%></span> <span class="gameHeader__time"><%=tm%></span></p>
            <p class="gameHeader__title"><%=title%></p>
          </div>
         
		  <!-- 기본은 출전순서. 아래 data에서 orderlist가 match -->
          <div class="gameHeader__btnwrap">
            <button class="matchbtn" id="m1" onclick="mx.getRelayInfo(mx.vobj, <%=tidx%>,<%=gbidx%>,'<%=gameno%>','<%=tm%>','<%=title%>')">대진표<span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/settings_backup_restore_white_@3x.png"></span></button>
            <button class="matchbtn on" id="m2" onclick="mx.getRelayInfoOrder(mx.vobj, <%=tidx%>,<%=gbidx%>,'<%=gameno%>','<%=tm%>','<%=title%>')">순위<span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/settings_backup_restore_white_@3x.png" alt=""></span></button>
          </div>
        </div>


        <div class="gameBoard__wrap">
          <!-- 해당 경기 목록이 불러와지면 -->
          <div>

				




	  <ul class="gameBoard" id="tournament2">
	<%
	If IsArray(arrZ) Then 
		For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZ(0, ari) 'idx
			idx = r_a1
			r_a2 = arrZ(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 


			r_a3 = arrZ(2, ari)' pidx
			r_teamnm = arrZ(3, ari) 'unm
			r_a5 = arrZ(4, ari) '종목
			r_a6 = arrZ(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrZ(6, ari) '출전순서
			r_a8 = isNullDefault(arrZ(7, ari),"") '최종결과 (기권/실격포함)

			r_tryoutresult = r_a8 '결과저장

			r_a9 = arrZ(8, ari) '소속
			r_a10 = arrZ(9, ari) '통합부명
			r_a11 = isNullDefault(arrZ(10, ari),"") '참가부명
			r_b1 = arrZ(11, ari) 'pidx 말
			r_b2 = arrZ(12, ari) '말명칭
			r_a12 = arrZ(13, ari) ' 경기시간

			r_a14 = arrZ(14, ari) 'gbidx
			r_a15 = arrZ(15, ari) 'requestIDX 참가신청 인덱스
			r_requestidx = r_a15

			r_a8_1 = arrZ(16, ari) '문서제출여부			

			'##################
			',score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order
			r_sgf = arrZ(17,ari) 'sgf
			r_s1 = isNullDefault(arrZ(18,ari),"")
			r_s2 = isNullDefault(arrZ(19,ari),"")
			r_s3 = isNullDefault(arrZ(20,ari),"")
			r_s4 = isNullDefault(arrZ(21,ari),"")
			r_s5 = isNullDefault(arrZ(22,ari),"")
			r_s6 = isNullDefault(arrZ(29,ari),"")

			r_stotal = arrZ(23,ari) '장애물 소요시간
			r_sper = arrZ(24,ari) '장애물인경우 B,C 타입 소요시간 2
			r_booorder = arrZ(25,ari)
			r_totalorder = arrZ(26,ari)


			r_round = arrZ(28,ari) '재경기라운드 1(본경기) 2 재경기 3 재경기2 (릴레이경우 실지 토너먼트 라운드 수)

			r_per1 = arrZ(30,ari)
			r_per2 = arrZ(31,ari)
			r_per3 = arrZ(32,ari)
			r_per4 = arrZ(33,ari)
			r_per5 = arrZ(34,ari)
			r_total2 = arrZ(35,ari) '종합관찰총점

			r_pcode = arrZ(36,ari) '소팅용 pubcode
			r_midval = isNullDefault(arrZ(37,ari),"") '중간값

			p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

			r_gidx_s = arrZ(38,ari) '참가자들 idx
			r_pnm_s = arrZ(39,ari) '참가자들
			If InStr(r_gidx_s,",") > 0 Then
				r_gidxarr = Split(r_gidx_s,",")
				r_gidx0 = r_gidxarr(0)
				r_gidx1 = r_gidxarr(1)
				r_gidx2 = r_gidxarr(2)
			Else
				r_gidx0 = ""
				r_gidx1 = ""
				r_gidx2 = ""
			End If
			If InStr(r_pnm_s,",") > 0 Then
				r_pnmarr = Split(r_pnm_s,",")
				r_pnm0 = r_pnmarr(0)
				r_pnm1 = r_pnmarr(1)
				r_pnm2 = r_pnmarr(2)
			Else
				r_pnm0 = ""
				r_pnm1 = ""
				r_pnm2 = ""
			End if	
			r_t_win = arrZ(40,ari) '리그승수
			r_t_lose = arrZ(41,ari) '리그패수
			r_bigo = arrZ(42,ari) ' 비고


			'Response.write "@@@@@@@@@@@@@@@@@@@@@@@@"&in01

			If r_a12 <> "" And isnull(r_a12) = false then
				r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
				r_hh = r_gametime(0)
				r_mm = r_gametime(1)
			Else
				r_hh = 0
				r_mm = 0
			End if
			%>
<li class="gameBoard__item">


	<p class="gameBoard__header"><span class="gameBoard__index">
						<%
							Select Case r_totalorder
							Case "200" : orderno = "E"
							Case "300" : orderno = "R"
							Case "400" : orderno = "W"
							Case "500" : orderno = "D"
							Case Else
								orderno = r_totalorder
							End Select 					
						%>
						<%=orderno%>
	위</span>
		<span class="gameBoard__txt">
			<a href="javascript:mx.showplayer(<%=idx%>,'<%=r_b2%>')"><%=r_teamnm%> [<%=r_b2%>]</a>
		</span>
		

	</p>


</li>
					<%

						Next
					End if
			%>
	  </ul>





          </div>
        </div>