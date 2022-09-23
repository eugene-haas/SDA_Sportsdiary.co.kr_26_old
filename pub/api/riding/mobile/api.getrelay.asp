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





'리그토너먼트 구분 2, 3 
SQL = "Select max(gubun),count(*) from SD_tennisMember where gametitleidx ="&tidx&" and gamekey3 = '"&gbidx&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.eof Then
	gubunLT = rs(0)
	relayMembercnt = rs(1)
	gangtdno = getN(relayMembercnt)
End if



'토너먼트 리스트###################################################################
fldnm = " username,total_order,t_win,t_lose "

'and round = 1 마장마술에서 쓰는 라운드 개념과 다름 실지 토너먼트 라운드 수가 들어감
SQL = "Select top 4 " & fldnm & " from SD_tennisMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"'  and gubun < 100  and total_order > 0 and total_order < 5 order by total_order asc"
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
            <button class="matchbtn on" id ="m1" onclick="mx.getRelayInfo(mx.vobj, <%=tidx%>,<%=gbidx%>,'<%=gameno%>','<%=tm%>','<%=title%>')">대진표<span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/settings_backup_restore_white_@3x.png"></span></button>
            <button class="matchbtn" id="m2" onclick="mx.getRelayInfoOrder(mx.vobj, <%=tidx%>,<%=gbidx%>,'<%=gameno%>','<%=tm%>','<%=title%>')">순위<span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/settings_backup_restore_white_@3x.png" alt=""></span></button>
          </div>
        </div>


        <div class="gameBoard__wrap">
          <!-- 해당 경기 목록이 불러와지면 -->
          <div>

				


<%If gubunLT = "2" Then '리그

'					Lfld = " a.gameMemberidx,a.playeridx,a.username,a.tryoutgroupno,a.tryoutsortno,a.gamekey3,a.gametitleidx,a.pubname   ,b.playeridx,b.username "
'					SQL = "Select "&Lfld&" from sd_tennisMember as a left join  sd_tennisMember_partner as b on a.gameMemberidx = b.gameMemberidx  where a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.delyn = 'N' order by a.tryoutsortno "
'					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'					arrT = rs.GetRows()
'
'					Call drowLeage(arrT, "")


					gfldL = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxL group by pnm for XML path('') ),1,1, '' ))  as pnmL " '그룹소속선수들
					gfldR = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxR group by pnm for XML path('') ),1,1, '' ))  as pnmR " '그룹소속선수들

					'라운드 형태로 테이블 그림
					SQL = "Select orderno,idx,teamnmL,teamnmR,hnmL,hnmR,midxL,midxR "&gfldL&gfldR&",sayoocode,errL,errR ,errDocL,errDocR,   midxL,midxR,winMidx from sd_gameMember_vs as a   where tidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and delyn = 'N' order by orderno "

					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
					arrL = rs.GetRows()
					'Call getrowsdrow(arrL)
					End if

			%>

	  <ul class="gameBoard" id="tournament2">

	<li class="gameBoard__item" style="padding:5px;">
		<%
		If IsArray(arrZ) Then 
			For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
				Response.write arrZ(1,ari) & "등 " &  arrZ(0,ari) & " ["&arrZ(2,ari)&"승 "&arrZ(3,ari)&"패] <br>"
			Next
		End if
		%>
	</li>


				<%
					If IsArray(arrL) Then 
						For ari = LBound(arrL, 2) To UBound(arrL, 2)
							l_orderno = arrL(0,ari)
							l_idx = arrL(1,ari)
							l_teamnmL = arrL(2,ari)
							l_teamnmR = arrL(3,ari)
							l_hnmL = arrL(4,ari)
							l_hnmR = arrL(5,ari)
							l_errL = isnulldefault(arrL(11,ari),"")
							l_errR = isNulldefault(arrL(12,ari),"")
							l_errDocL = isnulldefault(arrL(13,ari),"")
							l_errdocR = isNulldefault(arrL(14,ari),"")

							l_midxL = arrL(15,ari)
							l_midxR = arrL(16,ari)
							l_winMidx = arrL(17,ari)

			l_pnmL = arrL(8, ari) '선수들
			If InStr(l_pnmL ,",") > 0 then
			pnmarrL = Split(l_pnmL,",")
				pnmL0 = pnmarrL(0)
				pnmL1 = pnmarrL(1)
				pnmL2 = pnmarrL(2)
			Else
				pnmL0 = ""
				pnmL1 = ""
				pnmL2 = ""
			End If

			l_pnmR = arrL(9, ari) '선수들
			If InStr(l_pnmR ,",") > 0 then
				pnmarrR = Split(l_pnmR,",")
				pnmR0 = pnmarrR(0)
				pnmR1 = pnmarrR(1)
				pnmR2 = pnmarrR(2)
			else
				pnmR0 = ""
				pnmR1 = ""
				pnmR2 = ""
			End if			

					%>
<li class="gameBoard__item">


<p class="gameBoard__header"><span class="gameBoard__index"><%=l_orderno%>R</span>
	<span class="gameBoard__txt">
		<a href="javascript:mx.showplayer(<%=l_midxL%>,'<%=l_hnmL%>')"><%=l_teamnmL%> [<%=l_hnmL%>]</a>
	</span>
	<%If l_MidxL = l_winMidx then%><span class="gameBoard__status s_schedule">승</span><%End if%>
</p>

<p class="gameBoard__header" style="margin-bottom:-5px;"><span class="gameBoard__index" style="background:#ffffff;">&nbsp;</span>
	<span class="gameBoard__txt">
		<a href="javascript:mx.showplayer(<%=l_midxR%>,'<%=l_hnmR%>')"><%=l_teamnmR%> [<%=l_hnmR%>]</a>
	</span>
	<%If l_MidxR = l_winMidx then%><span class="gameBoard__status s_schedule_under">승</span><%End if%>
</p>



							  <!-- <tr> -->
								<!-- <td style="width:100px;text-align:center;" rowspan="2"><%=l_orderno%> R</td>
								<td><span><%=l_teamnmL%></span></td>
								<td><span><%=l_hnmL%></span></td>
								<td><span><%=pnmL0%></span></td>
								<td><span><%=pnmL1%></span></td>
								<td><span><%=pnmL2%></span></td>
								<td>
								<span>
									<%If l_errR = "e" then%>E<%End if%>
									<%If l_errR = "r" then%>R<%End if%>
									<%If l_errR = "w" then%>W<%End if%>
									<%If l_errR = "d" then%>D<%End if%>
								</span>
								</td>
								<td><%If l_MidxL = l_winMidx then%>승<%End if%></td>
							  </tr>

							  <tr>
								<td><span><%=l_teamnmR%></span></td>
								<td><span><%=l_hnmR%></span></td>
								<td><span><%=pnmR0%></span></td>
								<td><span><%=pnmR1%></span></td>
								<td><span><%=pnmR2%></span></td>
								<td>
								<span>
									<%If l_errR = "e" then%>E<%End if%>
									<%If l_errR = "r" then%>R<%End if%>
									<%If l_errR = "w" then%>W<%End if%>
									<%If l_errR = "d" then%>D<%End if%>
								</span>
								</td>
								<td><%If l_MidxR = l_winMidx then%>승<%End if%></td> -->
							  <!-- </tr> -->
</li>
					<%

						Next
					End if
			%>
	  </ul>
			<%	

			
ElseIf gubunLT = "3" Then '토너먼트%>

	  <ul class="gameBoard" id="tournament2">
	  <li class="gameBoard__item">

                <div class="recordTable__wrap">
                  <div class="recordTable">


				<script type="text/javascript">
					mx.makeGameTable(<%=tidx%>,'<%=gbidx%>',3,'drow');
				</script>

                  </div>
				</div>


	  </li>
	  </ul>

<%End if%>




          </div>
        </div>