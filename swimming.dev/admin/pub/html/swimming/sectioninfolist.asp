
	<tr class="gametitle" id="titlelist_<%=l_midx%>"  style="text-align:center;<%If CDbl(chkrowno) mod 2 = 1 And gameTypestr = "예선" then%>background:#CED7DD;<%End if%>">

		<%If chkrowno > 0 then%>
		<%If ari =  0 or prejoo <> chkrowno Then%>
			<td  rowspan="<%=Cdbl(raneCnt)*2%>" style="vertical-align:middle;background:#ffffff;"><span><%=chkrowno%>조</span></td>
		<%End if%>
		<%else%>
		<td>&nbsp;</td>
		<%End if%>

		<td>
		<%If chkrowno > 0 then%>
			<span><%=l_raneno%></span><%'레인%>
		<%End if%>
		</td>
		<td><%=l_ksportsno%></td>
		<td><%=l_userName%></td>
		<td><%=l_TeamNm%></td>
		<td><%=l_totalorderno%></td><%'총순위%>
		<td><%Call SetRC(SinRC)%></td>
		<td><span><%=l_result%></span></td>
		<td><a href="javascript:mx.setSectionRecord(<%=l_midx%>,<%=l_gno%>,'<%=ampm%>')" class="btn btn-default">입력</a></td> 
	</tr>

	<tr>
		<td colspan="7" STYLE="BACKGROUND:#ffffff">

			<%
'idx,gameMemberidx,AMPM,sectionno,section50,section100,section150,section200,section250,section300,section350,section400,section450,section500,section550,section600,section650,section700,section750,section800,section850,section900,section950,section1000,section1050,section1100,section1150,section1200,section1250,section1300,section1350,section1400,section1450,section1500,r50,r100,r150,r200,r250,r300,r350,r400,r450,r500,r550,r600,r650,r700,r750,r800,r850,r900,r950,r1000,r1050,r1100,r1150,r1200,r1250,r1300,r1350,r1400,r1450,r1500

			If IsArray(arrSec) Then
				For si = LBound(arrSec, 2) To UBound(arrSec, 2)

					s_gameMemberidx = arrSec(1, si)
					s_ampm = arrSec(2, si)

					if Cstr(l_midx) = Cstr(s_gameMemberidx) and Lcase(s_ampm) = Lcase(ampm) Then
					s_sectionno = arrSec(3,si) '마지막 저장된 필드번호


					'필드 루프 생성
						s_sectionfldno = s_sectionno/50
						
						for f = 1 to s_sectionfldno
							s_sectionfld = f * 50
							s_sectionrc = arrSec(3 + f ,si)
							s_gamerc = arrSec(33 + f, si)

							'Response.write  s_sectionrc & "-"
							'If a = "asadf" then
							%><div style="float:left;border:2px solid #1C6EA4;border-radius: 7px;padding:3px;" ><%call tabledrow(s_sectionfld,s_sectionrc,s_gamerc)%></div><%
							'End if
						next

					end if

				Next
			End if
			%>
		</td>
	</tr>
<%
prejoo = chkrowno
%>
