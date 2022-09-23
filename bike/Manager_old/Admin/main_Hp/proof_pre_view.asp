<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/proof_pre.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서 발급 신청(기존)
    '===================================================================================================================================

	Server.ScriptTimeOut=9000000
	
	Dim first_page_count, next_page_count
	Dim division, pl1_name, pl1_no1, tm_kname, tm_id, use, present, sort, witness, witness2
	Dim start_year, end_year, nono, print_count, add, position
	Dim proof_name, now_year

	Check_AdminLogin()

	first_page_count	= 40
	next_page_count		= 60

	division			= fInject(Trim(Request.form("division")))		' 발급요청자 1-개인 2-단체
	pl1_name			= fInject(Trim(Request.form("pl1_name")))

	pl1_no1				= fInject(Trim(Request.form("pl1_no1")))
	tm_kname			= fInject(Trim(Request.form("tm_kname")))
	tm_id				= fInject(Trim(Request.form("tm_id")))
	use					= fInject(Trim(Request.form("use")))
	present				= fInject(Trim(Request.form("present")))
	sort				= fInject(Trim(Request.form("sort")))			' 증명서 종류 1-경기실적 2-지도실적	
	witness				= fInject(Trim(Request.form("witness")))
	witness2			= fInject(Trim(Request.form("witness2")))
	start_year			= fInject(Trim(Request.form("start_year")))
	end_year			= fInject(Trim(Request.form("end_year")))
	nono				= fInject(Trim(Request.form("nono")))
	print_count			= fInject(Trim(Request.form("print_count")))
	add					= fInject(Trim(Request.form("add")))
	position			= fInject(Trim(Request.form("position")))

	If sort=1 Then 
		proof_name			= "경기"
	Else
		proof_name			= "지도"
	End if

	If Month(now)>2 Then 
		now_year			= Year(now)
	Else
		now_year			= Year(now)-1
	End if

	Call DBOpen2()
%>
<!--#include file="../include/head.asp"-->
<style type="text/css">
	H6 { page-break-before:always;height:0; line-height:0; }
	
	.pr_font   { font-family:"굴림",verdana; font-size:9pt; color:#1B1B1B; text-decoration: none; line-height:15pt;  }
	.b_tblr { font-family: "바탕", "Verdana"; font-size: 12pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; color: #000000}
	.b_tblr11 { font-family: "바탕", "Verdana"; font-size: 11pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; color: #000000}
	.b_tbr { font-family: "바탕", "Verdana"; font-size: 12pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: #CCCCCC 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; color: #000000}
	.b_tbr11 { font-family: "바탕", "Verdana"; font-size: 11pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: #CCCCCC 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; color: #000000; padding-left:5px;}
	.b_blr { font-family: "바탕", "Verdana"; font-size: 12pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: #CCCCCC 1px solid; color: #000000}
	.b_blr11 { font-family: "바탕", "Verdana"; font-size: 11pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: #CCCCCC 1px solid; color: #000000}
	.b_br { font-family: "바탕", "Verdana"; font-size: 12pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: #CCCCCC 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: #CCCCCC 1px solid; color: #000000}
	.b_br11 { font-family: "바탕", "Verdana"; font-size: 11pt; BACKGROUND-COLOR: #FFFFFF; BORDER-BOTTOM: black 1px solid; BORDER-LEFT: #CCCCCC 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: #CCCCCC 1px solid; color: #000000; padding-left:5px;}
	.height1   { font-family:"굴림",verdana; font-size:1px; color:ffffff;text-decoration: none;  line-height:0pt; }
</style>
	<script>
	  var locationStr = "proof_pre";
	</script>
	<!-- S : content -->
	<div id="content" class="cert_regist">
		<!-- S: page_title -->
		<div class="page_title clearfix">
			<h2>증명서발급신청(기존)</h2>		

			<!-- S: 네비게이션 -->
			<div  class="navigation_box">
				<span class="ic_deco">
					<i class="fas fa-angle-right fa-border"></i>
				</span>
				<ul>
					<li>홈페이지관리</li>
					<li>온라인서비스</li> 
					<li><a href="./cert_regist.asp">증명서발급신청(기존)</a></li>
				</ul>
			</div>
			<!-- E: 네비게이션 -->
		</div>
		<!-- E: page_title -->

		<!-- S : 리스트형 20개씩 노출 -->
		<div id="board-contents" class="table-list-wrap"> 
		<!-- S : table-list -->
			<%
			'개인 증명서일 경우
			IF Cint(division)=1 then
				SQLString = "SELECT * FROM people1_d_damo WHERE pl1_name='"&pl1_name&"' AND pl1_no1="&pl1_no1&"  and pl2_serial is not null order by  pl1_serial  desc "
				'Response.Write SQLString
				SET rs = DBCon2.Execute(SQLString)

				IF rs.EOF AND rs.BOF then
					'DoHBack "죄송합니다. 해당 데이타가 없습니다.\n다시한번 확인해 주십시요."
				Else
					If pl1_no1 <> "" And pl1_no1 <> 0 Then
						pl1_no11			= left(pl1_no1,2)
							If pl1_no11<20 then
								pl1_no11		= "20"&pl1_no11
							Else
								pl1_no11		= "19"&pl1_no11
							End if
						pl1_no12			= Cint(Mid(pl1_no1,3,2))
							IF Len(pl1_no12)=1 then
								pl1_no12		= " "&pl1_no12
							End if
						pl1_no13			= Cint(Right(pl1_no1,2))
							IF Len(pl1_no13)=1 then
								pl1_no13		= " "&pl1_no13
							End If
					Else
						pl1_no11 = ""
						pl1_no12 = ""
						pl1_no13 = ""
					End If 

					pl1_add1				= rs("pl1_add1")
					pl1_add2				= rs("pl1_add2")

					pl2_serial				= rs("pl2_serial")

					Set rs1 = CreateObject("ADODB.RecordSet")
					SQLString = "SELECT top 1 * FROM team_d WHERE tm_year="&now_year&" AND"
					'SQLString = "SELECT * FROM team_d WHERE"
					SQLString = SQLString & " (tm_type<=3) AND ( pl2_serial_head="&pl2_serial&"  OR  pl2_serial_head2="&pl2_serial&"  OR  "
					SQLString = SQLString & "  pl2_serial_couch="&pl2_serial&"  OR  "
					SQLString = SQLString & "  pl2_serial_couch2="&pl2_serial&"  OR  "
					SQLString = SQLString & "  pl2_serial_sir="&pl2_serial&"  OR  "
					SQLString = SQLString & "  pl2_serial_pl="&pl2_serial&"   "
					iiii = 1
					Do While iiii <= 60
						SQLString = SQLString & "  OR  pl2_serial_"&iiii&"="&pl2_serial&"  "
						iiii = iiii + 1			
					Loop
					SQLString = SQLString & " )   order by tm_year desc,tm_serial desc,tm_id   "

					SET rs1 = DBCon2.Execute(SQLString)
					If rs1.EOF AND rs1.BOF then
					Else
						'중복/겸임 가능성 판단
						pl2_fposition=""
						pl2_position_line=0
						tm_year_before	= year(now)-1
						tm_id_before	= ""
						rs1.MoveFirst

						Do While NOT rs1.EOF
						tm_year				= rs1("tm_year")
						tm_id					= rs1("tm_id")
						if Cint(tm_year)=>Cint(tm_year_before) AND tm_id_before<>tm_id then
							tm_year_before			= tm_year
							tm_id_before				= tm_id

							tm_kname			= rs1("tm_kname")
							tm_kname			= replace(tm_kname,"(남)","")
							tm_kname			= replace(tm_kname,"(여)","")

							IF Cdbl(pl2_serial)=rs1("pl2_serial_head") then
								pl2_position				= "감독"
							Elseif Cdbl(pl2_serial)=rs1("pl2_serial_head2") then
								pl2_position				= "감독"
							Elseif Cdbl(pl2_serial)=rs1("pl2_serial_couch") OR Cdbl(pl2_serial)=rs1("pl2_serial_couch2")  then
								pl2_position				= "코치"
							Elseif Cdbl(pl2_serial)=rs1("pl2_serial_sir") then
								pl2_position				= "주무"
							Elseif Cdbl(pl2_serial)=rs1("pl2_serial_trainer1") then
								pl2_position				= "트레이너"
							Elseif Cdbl(pl2_serial)=rs1("pl2_serial_trainer2") then
								pl2_position				= "트레이너"
							Else
								pl2_position				= "선수"
							End if

							if Len(pl2_fposition)>2 then
								'pl2_fposition   = pl2_fposition&"<br>"&tm_kname&" "&pl2_position
								'pl2_position_line=pl2_position_line+1
							else
								pl2_fposition   = tm_kname&" "&pl2_position
							end if

							tm_id_before= rs1("tm_id")
							tm_year_before = rs1("tm_year")
						end if
						rs1.MoveNext
						LOOP

					End if
					rs1.Close
					Set rs1=Nothing
				End if
				rs.Close
				Set rs=Nothing

				if sort=2 then
					'팀이동자인지 아닌지 판단(20040114 이선경)  --- 지도실적용		
					SQLString = "SELECT * FROM move_d WHERE pl2_serial="&pl2_serial
					SET rs = DBCon2.Execute(SQLString)
					If rs.EOF AND rs.BOF then
						move_div = 1
						rs.Close
						Set rs=Nothing
					Else
						move_div = 0
						tm_serial_new	= rs("tm_serial_new")
						tm_id_new		= rs("tm_id_new")
						tm_serial_old	= rs("tm_serial_old")
						tm_id_old			= rs("tm_id_old")
						move_year		= year(rs("move_date"))
						move_date		= FormatDateTime(rs("move_date"),2)
						move_date		= replace(move_date,"-","")
						rs.Close
						Set rs=Nothing
					End if
				End If
			%>
			<table border=0 cellpadding=0 cellspacing=10 width="100%" height=100%>
				<tr width=100% height=100%>
					<td height=100%>
						<table width="100%" border=0 cellpadding=0 cellspacing=0>
							<tr height=60>
								<td align=center><font style="font-family:바탕; font-size:20pt; color:#000000; line-height:30pt;"><b><%=proof_name%>실적 증명서</b></font></td>
							</tr>
							<tr height=100%>
								<td width="100%" height=100%>
									<table width="100%" border=0 cellpadding=4 cellspacing=0 class=pr_font  valign=top >
										<tr>
											<td width=12% align=center class=b_tblr>종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
											<td width=48% class=b_tbr11>배드민턴</td>
											<td width=12% align=center class=b_tbr>발급번호</td>
											<td width=28% class=b_tbr11><%=nono%></td>
										</tr>
										<tr>
											<td align=center class=b_blr>발급일자</td>
											<td class=b_br11><%=year(now)%>년 <%=month(now)%>월 <%=day(now)%>일</td>
											<td align=center class=b_br>발급부수</td>
											<td class=b_br11><%=print_count%> 매</td>
										</tr>
										<tr>
											<td align=center class=b_blr>성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
											<td class=b_br11><%=pl1_name%></td>
											<td align=center class=b_br>생년월일</td>
											<td class=b_br11><%=pl1_no11%>.<%=pl1_no12%>.<%=pl1_no13%>.</td>
										</tr>
										<tr>
											<td align=center class=b_blr>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>
											<%If Len(add)>0 then%>
											<td class=b_br11><%=add%></td>
											<%Else%>
											<td class=b_br11><%=pl1_add1%>&nbsp;<%=pl1_add2%></td>
											<%End if%>
											<td align=center class=b_br>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</td>
											<%If Len(position)>0 then%>
											<td class=b_br11><%=position%></td>
											<%Elseif len(pl2_fposition)>0 then%>
											<td class=b_br11><%=pl2_fposition%></td>
											<%Else%>
											<td class=b_br11>&nbsp;</td>
											<%End if%>
										</tr>
										<tr>
											<td align=center class=b_blr>용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;도</td>
											<td class=b_br11><%=use%>&nbsp;</td>
											<td align=center class=b_br>제&nbsp;&nbsp;출&nbsp;&nbsp;처</td>
											<td class=b_br11><%=present%>&nbsp;</td>
										</tr>
										<tr height=100%>
											<td colspan=4 class=b_blr height=100% valign=top>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font valign=top>
													<%
													'국내대회 먼저 출력

													'경기 실적일 경우
													If sort=1 then

														SQLString = "SELECT et.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc FROM event_d ev,entree_d et,event_winner ew"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"
														SQLString = SQLString & " AND (et.pl2_serial_1="&pl2_serial&" OR et.pl2_serial_2="&pl2_serial&") AND (11<=ev_type AND ev_type<=30)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & " AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End If

														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%국가대표%'   and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " UNION"
														SQLString = SQLString & " SELECT et.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc FROM event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial AND dn.et_serial=et.et_serial)"
														SQLString = SQLString & " AND et_pc=3 AND (dn.pl2_serial_1="&pl2_serial
														For i=2 to 20
														SQLString = SQLString & " OR dn.pl2_serial_"&i&"="&pl2_serial
														Next

														'국내대회만 먼저 출력함(20030324)
														SQLString = SQLString & ") AND (11<=ev_type AND ev_type<=30)"

														'2003 코리아오픈 이전 경기일때이므로 (20030906 이선경)
														SQLString = SQLString & " AND (convert(varchar(10),ev_stime,112)<20030401 )"


														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if

														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%국가대표%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														'2003 코리아오픈 이후 경기에 대해서는 실제 경기참여자만 뽑아냄 (20030906 이선경)

														SQLString = SQLString & " UNION"
														SQLString = SQLString & " SELECT et.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc "
														SQLString = SQLString & " FROM event_d ev,entree_d et,event_winner ew,sub_game_d sg"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial "
														SQLString = SQLString & " AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"
														SQLString = SQLString & " AND et_pc=3 "
														SQLString = SQLString & " AND (((ew.et_serial=sg.et_serial_a) "
														SQLString = SQLString & " AND (sg.ss1_pl2_serial_a_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss1_pl2_serial_a_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss2_pl2_serial_a_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss2_pl2_serial_a_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss3_pl2_serial_a_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss3_pl2_serial_a_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss4_pl2_serial_a_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss4_pl2_serial_a_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss5_pl2_serial_a_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss5_pl2_serial_a_2="&pl2_serial&"))"
														SQLString = SQLString & " OR ((ew.et_serial=sg.et_serial_b) "
														SQLString = SQLString & " AND (sg.ss1_pl2_serial_b_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss1_pl2_serial_b_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss2_pl2_serial_b_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss2_pl2_serial_b_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss3_pl2_serial_b_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss3_pl2_serial_b_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss4_pl2_serial_b_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss4_pl2_serial_b_2="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss5_pl2_serial_b_1="&pl2_serial&""
														SQLString = SQLString & " OR sg.ss5_pl2_serial_b_2="&pl2_serial&")))"
														SQLString = SQLString & " AND (sg.ev_serial=ev.ev_serial)"

														'국내대회만 먼저 출력함(20030324)
														SQLString = SQLString & " AND (11<=ev_type AND ev_type<=30)"

														'2003 코리아오픈 이후 경기일때이므로 (20030906 이선경)
														SQLString = SQLString & " AND (convert(varchar(10),ev_stime,112)>=20030401 )"


														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if

														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'   and ev_kname not like '%국가대표%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " ORDER BY ev.ev_stime,ew.win_name"

													Else '지도 실적일 경우
														SQLString = "SELECT tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc "
														SQLString = SQLString & " FROM team_d tm, event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"

														'20030121 수정 (국내팀은 국내경기 실적만 인정되도록 함)
														'20030122 국가대표 임원의 경우 재직 기간의 실적만 인정하도록 수정
														'20040427 지도 소속의 선수들 국제대회도 출력
														'SQLString = SQLString & " AND ((tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100)) OR (tm.tm_type=5 AND (ev.ev_type<=10 OR ev.ev_type=100) AND (ev.ev_stime>tm.tm_sdate AND ev.ev_etime<tm.tm_edate)))"
														SQLString = SQLString & " AND ((tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100) AND tm.tm_year<=2003 AND ev.ev_stime>tm.tm_sdate) OR (tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100 AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate) and tm.tm_year>2003)) OR ((tm.tm_type=5 OR tm.tm_type=11) AND (ev.ev_type<=10 OR ev.ev_type=100) AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate)))"

														SQLString = SQLString & " AND (tm.tm_id=ew.tm_id OR ("
														for i=1 to 59
														SQLString = SQLString & " (et.pl2_serial_1=tm.pl2_serial_"&i&" AND et.pl2_serial_1<>0) OR (et.pl2_serial_2=tm.pl2_serial_"&i&" AND et.pl2_serial_2<>0) OR"
														next
														SQLString = SQLString & " (et.pl2_serial_1=tm.pl2_serial_60 AND et.pl2_serial_1<>0) OR (et.pl2_serial_2=tm.pl2_serial_60 AND et.pl2_serial_2<>0)))"

														'20030121 (이선경)
														'대표코치일 경우에는 해당팀의 실적을 모두 지도 실적으로 인정함  (pl2_serial_couch~5)
														'20040324 지도실적에서 주무는 제외 (이선경)
														'분야별 코치는 ew.win_name에 해당 분야 이름이 들어간 경우만 인정함 (pl2_serial_couch_ms/ws/md/wd/mxd/mt/wt)
														SQLString = SQLString & " AND (tm.pl2_serial_head="&pl2_serial&" OR tm.pl2_serial_head2="&pl2_serial&" OR tm.pl2_serial_head_couch="&pl2_serial&" OR tm.pl2_serial_couch="&pl2_serial&" OR tm.pl2_serial_couch2="&pl2_serial&" OR tm.pl2_serial_couch3="&pl2_serial&" OR tm.pl2_serial_couch4="&pl2_serial&" OR tm.pl2_serial_couch5="&pl2_serial& "  OR tm.pl2_serial_couch6="&pl2_serial& " OR tm.pl2_serial_couch7="&pl2_serial& "OR tm.pl2_serial_trainer1="&pl2_serial&" OR tm.pl2_serial_trainer2="&pl2_serial
														SQLString = SQLString & " OR (tm.pl2_serial_trainer1="&pl2_serial&") OR (tm.pl2_serial_trainer2="&pl2_serial&")"

														SQLString = SQLString & " OR (tm.pl2_serial_couch_ms="&pl2_serial&" AND ew.win_name like '%남자단식%' )"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ws="&pl2_serial&" AND ew.win_name like '%여자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_md="&pl2_serial&" AND ew.win_name like '%남자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wd="&pl2_serial&" AND ew.win_name like '%여자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mxd="&pl2_serial&" AND ew.win_name like '%혼합복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mt="&pl2_serial&" AND ew.win_name like '%남자단체%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wt="&pl2_serial&" AND ew.win_name like '%여자단체%')"
														SQLString = SQLString & ")"

														SQLString = SQLString & " AND ((tm.tm_year+1=year(ev.ev_stime) and month(ev.ev_stime)<3) OR (tm.tm_year=year(ev.ev_stime) and month(ev.ev_stime)>2)) AND ev.ct_serial=1029 AND ev.ev_type<>100"

														'국내대회만 먼저 출력함(20030324)
														SQLString = SQLString & " AND (11<=ev_type AND ev_type<=30)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if

														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%국가대표%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"
														SQLString = SQLString & " Group By tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc"

														SQLString = SQLString & " UNION"
														SQLString = SQLString & " SELECT tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc "
														SQLString = SQLString & " FROM team_d tm, event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial  AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial AND dn.et_serial=et.et_serial)"
														'20030121 수정 (국내팀은 국내경기 실적만 인정되도록 함)
														'20030122 국가대표 임원의 경우 재직 기간의 실적만 인정하도록 수정
														'SQLString = SQLString & " AND ((tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100)) OR (tm.tm_type=5 AND (ev.ev_type<=10 OR ev.ev_type=100) AND (ev.ev_stime>tm.tm_sdate AND ev.ev_etime<tm.tm_edate)))"
														SQLString = SQLString & " AND ((tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100) AND tm.tm_year<=2003 ) OR (tm.tm_type<=3 AND (ev.ev_type>10 AND ev.ev_type<>100 AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate) AND tm.tm_edate>ev.ev_etime and tm.tm_year>2003)) OR ((tm.tm_type=5 OR tm.tm_type=11) AND (ev.ev_type<=10 OR ev.ev_type=100) AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate)))"

														SQLString = SQLString & " AND (tm.tm_id=ew.tm_id OR ("
														for i=1 to 59
														for ii=1 to 20
														SQLString = SQLString & " (dn.pl2_serial_"&ii&"=tm.pl2_serial_"&i&" AND dn.pl2_serial_"&ii&"<>0 ) OR "
														next
														next
														SQLString = SQLString & " (dn.pl2_serial_1=tm.pl2_serial_60 AND dn.pl2_serial_1<>0)"
														SQLString = SQLString & " ))"

														SQLString = SQLString & " AND (tm.pl2_serial_head="&pl2_serial&" OR tm.pl2_serial_head2="&pl2_serial&" OR tm.pl2_serial_head_couch="&pl2_serial&" OR tm.pl2_serial_couch="&pl2_serial&" OR tm.pl2_serial_couch2="&pl2_serial&" OR tm.pl2_serial_couch3="&pl2_serial&" OR tm.pl2_serial_couch4="&pl2_serial&" OR tm.pl2_serial_couch5="&pl2_serial& "  OR tm.pl2_serial_couch6="&pl2_serial& " OR tm.pl2_serial_couch7="&pl2_serial& "OR tm.pl2_serial_trainer1="&pl2_serial&" OR tm.pl2_serial_trainer2="&pl2_serial
														SQLString = SQLString & " OR (tm.pl2_serial_trainer1="&pl2_serial&") OR (tm.pl2_serial_trainer2="&pl2_serial&")"

														SQLString = SQLString & " OR (tm.pl2_serial_couch_ms="&pl2_serial&" AND ew.win_name like '%남자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ws="&pl2_serial&" AND ew.win_name like '%여자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_md="&pl2_serial&" AND ew.win_name like '%남자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wd="&pl2_serial&" AND ew.win_name like '%여자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mxd="&pl2_serial&" AND ew.win_name like '%혼합복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mt="&pl2_serial&" AND ew.win_name like '%남자단체%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wt="&pl2_serial&" AND ew.win_name like '%여자단체%')"
														SQLString = SQLString & ")"

														SQLString = SQLString & " AND ((tm.tm_year+1=year(ev.ev_stime) and month(ev.ev_stime)<3) OR (tm.tm_year=year(ev.ev_stime) and month(ev.ev_stime)>2)) AND ev.ct_serial=1029 AND ev.ev_type<>100"

														'국내대회만 먼저 출력함(20030324)
														SQLString = SQLString & " AND (11<=ev_type AND ev_type<=30)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if
														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'   and ev_kname not like '%국가대표%' and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " Group By tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc"

														SQLString = SQLString & " ORDER BY tm.tm_year , ev.ev_stime,ew.win_name"

													End if '경기실적 또는 지도 실적 구분 끝
													SET rs1 = DBCon2.Execute(SQLString)
													IF rs1.EOF AND rs1.BOF then
													%>
													<tr><td></td>	</tr>
													<tr>
														<td>
														<table width="100%" border=0 cellpadding=0 cellspacing=0>
															<tr>
													<%Else%>
													<tr>
														<td align=center>ㅡㅡㅡㅡㅡ 국내대회 ㅡㅡㅡㅡㅡ</td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%>일자</td>
																	<%if sort=2 then%>
																	<td align=center width=33%>대회명</td>
																	<td align=center width=20%>소속</td>
																	<td align=center width=20%>성적</td>
																	<%else%>
																	<td align=center width=50%>대회명</td>
																	<td align=center width=20%>소속</td>
																	<td align=center width=13%>성적</td>
																	<%end if%>
																</tr>																
																<%
																	rs1.MoveFirst
																	total_count			= rs1.RecordCount
																	if total_count-first_page_count < 5 then
																		first_page_count			= 41
																	end if
																	print_page=1
																	record_row=1
																	record_row2=1

																	Do While Not rs1.EOF

																		'20040126 추가
																		ev_stime_div		= FormatDateTime(rs1("ev_stime"),2)
																		ev_stime_div		= replace(ev_stime_div,"-","")

																		if move_div=0 AND move_date>ev_stime_div AND rs1("tm_id")=tm_id_new AND sort=2 then
																			rs1.MoveNext	'20040126 추가
																		else
																			ev_serial					= rs1("ev_serial")
																			tm_id						= rs1("tm_id")
																			tm_id2						= rs1("tm_id2")
																			ev_s_year				= year(rs1("ev_stime"))
																			ev_s_year2				= Cint(year(rs1("ev_stime"))-1)
																			ev_s_month				= month(rs1("ev_stime")) '3월이전 경기기록은 전년도 팀으로 기록함 (20040319 이선경)-> 2월로 변경 (20040618)

																			tm_ok			= 1
																			tm_kname			= ""
																			'1) 두 팀중에서 해당년도의 해당 선수의 소속을 찾음
																			if Len(tm_id2)>2 then
																				if ev_s_month>2 then'3월이전 경기기록은 전년도 팀으로 기록함 (20040319 이선경)
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND (tm_type<=3 OR tm_type=101) AND (tm_id="&Cint(tm_id)&" OR tm_id="&Cint(tm_id2)&")"
																				else
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year2&" AND (tm_type<=3 OR tm_type=101) AND (tm_id="&Cint(tm_id)&" OR tm_id="&Cint(tm_id2)&")"
																				end if
																			else
																				if ev_s_month>2 then'3월이전 경기기록은 전년도 팀으로 기록함 (20040319 이선경) -> 2월로 변경(20040618)
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND (tm_type<=3 OR tm_type=101) AND tm_id="&Cint(tm_id)
																				else
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year2&" AND (tm_type<=3 OR tm_type=101) AND tm_id="&Cint(tm_id)
																				end if
																			end if
																			Set rs2 = DBCon2.Execute(SQLString)
																			If rs2.EOF AND rs2.BOF then
																				tm_kname			= ""
																				tm_ok				= 1
																			Else
																				rs2.MoveFirst
																				Do While NOT rs2.EOF
																					if sort=1 then '경기실적의 경우 (20040227-이선경)
																						for i=1 to 60
																							if rs2("pl2_serial_"&i)=pl2_serial then
																								tm_kname		= rs2("tm_kname")
																								tm_kname		= replace(tm_kname,"(남)","")
																								tm_kname		= replace(tm_kname,"(여)","")
																								tm_kname		= replace(tm_kname,"(주)","")
																								tm_ok			= 0
																								i=57
																							end if
																						next						
																					else '지도실적의 경우
																						if rs2("pl2_serial_head")=pl2_serial OR rs2("pl2_serial_head2")=pl2_serial OR rs2("pl2_serial_head_couch")=pl2_serial OR  rs2("pl2_serial_couch")=pl2_serial OR rs2("pl2_serial_couch2")=pl2_serial OR rs2("pl2_serial_couch3")=pl2_serial OR rs2("pl2_serial_couch4")=pl2_serial OR rs2("pl2_serial_couch5")=pl2_serial OR rs2("pl2_serial_couch6")=pl2_serial OR rs2("pl2_serial_couch7")=pl2_serial OR rs2("pl2_serial_couch_ms")=pl2_serial OR rs2("pl2_serial_couch_ws")=pl2_serial OR rs2("pl2_serial_couch_md")=pl2_serial OR rs2("pl2_serial_couch_wd")=pl2_serial OR rs2("pl2_serial_couch_mxd")=pl2_serial OR rs2("pl2_serial_couch_mt")=pl2_serial  OR rs2("pl2_serial_couch_wt")=pl2_serial then
																								tm_kname		= rs2("tm_kname")
																								'지도실적의 경우 남여팀을 동시에 지도할수 있으므로 표시해줌 --한국체대 (20040426)
																								if instr(tm_kname,"한국체육대")=0 then
																								tm_kname		= replace(tm_kname,"(남)","")
																								tm_kname		= replace(tm_kname,"(여)","")
																								tm_kname		= replace(tm_kname,"(주)","")
																								end if
																								tm_ok			= 0
																						end if					
																					end if
																				rs2.MoveNext
																				LOOP
																			End if
																			rs2.Close
																			Set rs2=Nothing

																			'2) 두팀중에 없을경우에는 해당년도 등록팀중에서 해당 선수가 소속된 팀을 찾음
																			if Cint(tm_ok)=1 then
																				if ev_s_month>2 then'3월이전 경기기록은 전년도 팀으로 기록함 (20040319 이선경)-> 2월로 변경(20040618)
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND (tm_type<=3 OR tm_type=101)"
																				else
																					SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year2&" AND (tm_type<=3 OR tm_type=101)"
																				end if

																				SET rs5 = DBCon2.Execute(SQLString)
																				If rs5.EOF AND rs5.BOF then
																					tm_kname			= ""
																				Else
																					rs5.MoveFirst
																					Do While NOT rs5.EOF
																						if sort=1 then '경기실적의 경우 (20040227-이선경)
																							for i=1 to 60
																								if rs5("pl2_serial_"&i)=pl2_serial then
																									tm_kname		= rs5("tm_kname")
																									tm_kname		= replace(tm_kname,"(남)","")
																									tm_kname		= replace(tm_kname,"(여)","")
																									tm_kname		= replace(tm_kname,"(주)","")
																									tm_ok			= 0
																									i=57

																									'If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
																									'	Response.Write "tm_kname ======"& tm_kname &"<br />"
																									'End If 
																								end if
																							next
																						else '지도실적의 경우
																							if rs5("pl2_serial_head")=pl2_serial OR rs5("pl2_serial_head2")=pl2_serial OR rs5("pl2_serial_head_couch")=pl2_serial OR rs5("pl2_serial_couch")=pl2_serial OR rs5("pl2_serial_couch2")=pl2_serial OR rs5("pl2_serial_couch3")=pl2_serial OR rs5("pl2_serial_couch4")=pl2_serial OR rs5("pl2_serial_couch5")=pl2_serial OR rs5("pl2_serial_couch6")=pl2_serial OR rs5("pl2_serial_couch7")=pl2_serial OR rs5("pl2_serial_couch_ms")=pl2_serial OR rs5("pl2_serial_couch_ws")=pl2_serial OR rs5("pl2_serial_couch_md")=pl2_serial OR rs5("pl2_serial_couch_wd")=pl2_serial OR rs5("pl2_serial_couch_mxd")=pl2_serial OR rs5("pl2_serial_couch_mt")=pl2_serial  OR rs5("pl2_serial_couch_wt")=pl2_serial then
																								tm_kname		= rs5("tm_kname")
																								if instr(tm_kname,"한국체육대")=0 then
																									tm_kname		= replace(tm_kname,"(남)","")
																									tm_kname		= replace(tm_kname,"(여)","")
																									tm_kname		= replace(tm_kname,"(주)","")
																								end if
																								tm_ok			= 0
																							end if
																						end if
																					rs5.MoveNext
																					LOOP
																				End if
																				rs5.Close
																				Set rs5=Nothing
																			end If

																			win_player=""

																			'수상자 이름 찾기 (2004.10.18 서명원감독 요구로 추가)
																			pl2_serial_1				= rs1("pl2_serial_1")
																			pl2_serial_2				= rs1("pl2_serial_2")

																			'pl2_serial_1로 찾기
																			SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_1
																			SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																			for i=1 to 59
																			SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_1&") OR "
																			next
																			SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_1&"))"
																			Set rs2 = DBCon2.Execute(SQLString)
																			If rs2.EOF AND rs2.BOF then
																				win_player1=""
																			Else
																				win_player1= rs2("pl2_kname")
																			End if
																			rs2.Close
																			Set rs2=Nothing
																		
																			'pl2_serial_2로 찾기
																			SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_2
																			SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																			for i=1 to 59
																			SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_2&") OR "
																			next
																			SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_2&"))"
																			Set rs2 = DBCon2.Execute(SQLString)
																			If rs2.EOF AND rs2.BOF then
																				win_player2=""
																			Else
																				win_player2= rs2("pl2_kname")
																			End if
																			rs2.Close
																			Set rs2=Nothing

																			if win_player1=win_player2 then
																				win_player = win_player1
																			else
																				if len(win_player1)>1 AND len(win_player2)>1 then
																					win_player = win_player1&"/"&win_player2
																				elseif len(win_player1)>1 AND len(win_player2)=0 then
																					win_player = win_player1
																				elseif len(win_player1)=0 AND len(win_player2)>1 then
																					win_player = win_player2
																				end if
																			end if

																			If Len(rs1("ev_stime"))>0 then
																				ev_stime				= split(FormatDateTime(rs1("ev_stime"),2),"-")

																				ev_stime_y			= ev_stime(0)
																				ev_stime_m			= Cint(ev_stime(1))
																				IF Len(ev_stime_m)=1 then
																					ev_stime_m		= "&nbsp;"&ev_stime_m
																				End if
																				ev_stime_d			= Cint(ev_stime(2))
																				IF Len(ev_stime_d)=1 then
																					ev_stime_d		= "&nbsp;"&ev_stime_d
																				End if
																			End if

																			If Len(rs1("ev_etime"))>0 then
																				ev_etime				= split(FormatDateTime(rs1("ev_etime"),2),"-")

																				ev_etime_y			= ev_etime(0)
																				ev_etime_m			= Cint(ev_etime(1))
																				IF Len(ev_etime_m)=1 then
																					ev_etime_m		= "&nbsp;"&ev_etime_m
																				End if
																				ev_etime_d			= Cint(ev_etime(2))
																				IF Len(ev_etime_d)=1 then
																					ev_etime_d		= "&nbsp;"&ev_etime_d
																				End if
																			End If
																			
																			win_name				= rs1("win_name")
																			win_name				= replace(win_name," ","")
																			win_name				= replace(win_name,"단체전","단체")
																			win_name				= replace(win_name,"혼합복식","혼복")

																			if instr(win_name, "부") > 0 then 
																				temp111			= split(win_name,"부")
																				win_name			= temp111(1)
																			end if

																			if instr(win_name, "학교") > 0 then 
																				temp112			= split(win_name,"학교")
																				win_name			= temp112(1)
																			end if

																			if instr(win_name, "개인전") > 0 then 
																				temp113			= split(win_name,"개인전")
																				win_name			= "단식"&temp113(1)
																			end if

																			if instr(win_name, "단식") > 0 then 
																				win_name			= split(win_name,"단식")
																				win_name_last	= "단식"&win_name(1)
																			elseif instr(win_name, "복식") > 0 then 
																				win_name			= split(win_name,"복식")
																				win_name_last	= "복식"&win_name(1)
																			elseif instr(win_name, "혼복") > 0 then 
																				win_name			= split(win_name,"혼복")
																				win_name_last	= "혼복"&win_name(1)
																			elseif instr(win_name, "단체") > 0 then 
																				if sort=1 then
																				win_name			= split(win_name,"단체")
																				win_name_last	= "단체"&win_name(1)
																				else
																				win_name			= win_name
																				win_name_last	= win_name
																				end if
																			else
																				win_name_last			= win_name
																			end if

																			if Len(win_name_last)<4 then
																				win_name_last = "단체"&win_name_last
																			end if

																			if instr(rs1("ev_kname"),"(고·대)")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"(고·대)","")
																			elseif instr(rs1("ev_kname"),"(고.대)")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"(고.대)","")
																			elseif instr(rs1("ev_kname"),"-초.중.고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-초.중.고등부","")
																			elseif instr(rs1("ev_kname"),"-대학부,일반부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-대학부,일반부","")
																			elseif instr(rs1("ev_kname"),"-초등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-초등부","")
																			elseif instr(rs1("ev_kname"),"-중학부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-중학부","")
																			elseif instr(rs1("ev_kname"),"-중.고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-중.고등부","")
																			elseif instr(rs1("ev_kname"),"- 중.고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 중.고등부","")
																			elseif instr(rs1("ev_kname"),"- 고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 고등부","")
																			elseif instr(rs1("ev_kname"),"- 대학부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 대학부","")
																			elseif instr(rs1("ev_kname"),"-대학부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-대학부","")
																			elseif instr(rs1("ev_kname"),"-일반부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"-일반부","")
																			elseif instr(rs1("ev_kname"),"-초.중.고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 초.중.고등부","")
																			elseif instr(rs1("ev_kname"),"-대학부,일반부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 대학부,일반부","")
																			elseif instr(rs1("ev_kname"),"-초등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 초등부","")
																			elseif instr(rs1("ev_kname"),"-중학부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 중학부","")
																			elseif instr(rs1("ev_kname"),"-중.고등부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 중.고등부","")
																			elseif instr(rs1("ev_kname"),"-대학부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 대학부","")
																			elseif instr(rs1("ev_kname"),"-일반부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"- 일반부","")
																			elseif instr(rs1("ev_kname"),"-일반부")>0 then
																				ev_kname				= replace(rs1("ev_kname"),"(초.중)","")
																			else
																				ev_kname				= rs1("ev_kname")
																			end if


																%>
																<tr height=18>
																	<td valign=top><%=ev_stime_y&"."&ev_stime_m&"."&ev_stime_d%><% if ev_stime_m<>ev_etime_m OR ev_stime_d<>ev_etime_d then%> - <% if ev_stime_m<>ev_etime_m then%><%=ev_etime_m&"."%><% end if %><%=ev_etime_d%><%end if%></td>
																	<td valign=top><%=ev_kname%></td>
																	<td valign=top align=center><%=tm_kname%></td>
																	<td valign=top <%if sort=1 then%>align=center<%end if%>><%=win_name_last%><% if instr(win_name_last,"단체")=0 AND sort=2 then%> (<%=win_player%>)<% end if%></td>
																</tr>
																<%
																	if len(ev_kname)>24 then    '20151207 대회명 2줄 됨에 따른 카운트수 늘리기
																		record_row=record_row+2
																		record_row2=record_row2+2
																	else
																		record_row=record_row+1
																		record_row2=record_row2+1
																	end if

																	IF print_page=1 then
																		IF record_row = first_page_count-pl2_position_line then
																			print_page = print_page +1
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=0 cellpadding=0 cellspacing=0 width="100%" class=pr_font >
										<tr>
											<td colspan=4 class=b_tblr>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font>
													<tr>
														<td align=center><!-- <u>ㅡ 국내대회 ㅡ</u> --></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%><!-- 일자 --></td>
																	<%if sort=2 then%>
																	<td align=center width=33%><!-- 대회명 --></td>
																	<td align=center width=20%></td>
																	<td align=center width=20%><!--성적--></td>
																	<%else%>
																	<td align=center width=50%><!-- 대회명 --></td>
																	<td align=center width=20%><!--소속...원래 20% 입상자 관련하여 바꿈(2004.10.20)--></td>
																	<td align=center width=13%><!--성적--></td>
																	<%end if%>
																</tr>																
																<%
																			record_row=1	
																		End if
																	Else
																		IF record_row = 45  then
																			print_page = print_page +1
																			record_row=1	
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=0 cellpadding=0 cellspacing=0 width="100%" class=pr_font>
										<tr>
											<td colspan=4 class=b_tblr>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font>
													<%
													IF total_count<>record_row2-1 then
													%>
													<tr>
														<td align=center><!-- <u>ㅡ 국내대회 ㅡ</u>  --> </td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%><!-- 일자 --></td>
																	<%if sort<>1 then%>
																	<td align=center width=33%><!-- 대회명 --></td>
																	<td align=center width=20%></td>
																	<td align=center width=20%><!--성적--></td>
																	<%else%>
																	<td align=center width=50%><!-- 대회명 --></td>
																	<td align=center width=20%><!--소속...원래 20% 입상자 관련하여 바꿈(2004.10.20)--></td>
																	<td align=center width=13%><!--성적--></td>
																	<%end if%>
																</tr>																
																<%
																Else
																%>
																<tr>
																	<td height="100%"> 
																	  <table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<%
																End if
																			record_row=1	
																		End if
																	End If
																	
																	rs1.MoveNext
																	end if '20040126
																	LOOP
																End if
																rs1.Close
																Set rs1=Nothing
																%>
															</table>
														</td>
													</tr>
													<%
													IF total_count<>record_row2-1 AND record_row>0 then
													%>
													<tr height=30><td><% record_row=record_row+3%></td></tr>
													<%
													End if
													%>

													<%
													'국제대회 출력

													'경기 실적일 경우
													If sort=1 then

														SQLString = "SELECT et.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc FROM event_d ev,entree_d et,event_winner ew"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"
														SQLString = SQLString & " AND (et.pl2_serial_1="&pl2_serial&" OR et.pl2_serial_2="&pl2_serial&") AND ((0<=ev_type AND ev_type<=10) OR ev_type=100)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if

														SQLString = SQLString & " UNION"
														SQLString = SQLString & " SELECT et.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc FROM event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial AND dn.et_serial=et.et_serial)"
														SQLString = SQLString & " AND et_pc=3 AND (dn.pl2_serial_1="&pl2_serial
														For i=2 to 20
														SQLString = SQLString & "OR dn.pl2_serial_"&i&"="&pl2_serial
														Next
														'국내대회만 먼저 출력함(20030324)
														SQLString = SQLString & ") AND ((0<=ev_type AND ev_type<=10) OR ev_type=100)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if
														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " ORDER BY ev.ev_stime,ew.win_name"
													Else '지도 실적일 경우

														SQLString = "SELECT tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc "
														SQLString = SQLString & " FROM team_d tm, event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"

														'20030121 수정 (국내팀은 국내경기 실적만 인정되도록 함)
														'20030122 국가대표 임원의 경우 재직 기간의 실적만 인정하도록 수정
														'20040427 지도 소속의 선수들 국제대회도 출력
														SQLString = SQLString & "AND ((tm.tm_type<=3 OR (tm.tm_type=5 OR tm.tm_type=11) AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) AND convert(char(8),ev.ev_etime,112)<=convert(char(8),tm.tm_edate,112))) AND  ((ev_type<=10  OR ev_type=100) AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate)))"
														SQLString = SQLString & " AND (tm.tm_id=ew.tm_id OR ("
														for i=1 to 59
														SQLString = SQLString & " (et.pl2_serial_1=tm.pl2_serial_"&i&" AND et.pl2_serial_1<>0) OR (et.pl2_serial_2=tm.pl2_serial_"&i&" AND et.pl2_serial_2<>0) OR"
														next
														SQLString = SQLString & " (et.pl2_serial_1=tm.pl2_serial_60 AND et.pl2_serial_1<>0) OR (et.pl2_serial_2=tm.pl2_serial_60 AND et.pl2_serial_2<>0)))"

														'20030121 (이선경)
														'대표코치일 경우에는 해당팀의 실적을 모두 지도 실적으로 인정함  (pl2_serial_couch~5)
														'20040324 지도실적에서 주무는 제외 (이선경
														'SQLString = SQLString & " AND (tm.pl2_serial_head="&pl2_serial&" OR tm.pl2_serial_couch="&pl2_serial&" OR tm.pl2_serial_couch2="&pl2_serial&" OR tm.pl2_serial_couch3="&pl2_serial&" OR tm.pl2_serial_couch4="&pl2_serial&" OR tm.pl2_serial_couch5="&pl2_serial&" OR tm.pl2_serial_sir="&pl2_serial
														'분야별 코치는 ew.win_name에 해당 분야 이름이 들어간 경우만 인정함 (pl2_serial_couch_ms/ws/md/wd/mxd/mt/wt)
														SQLString = SQLString & " AND (tm.pl2_serial_head="&pl2_serial&" OR tm.pl2_serial_head2="&pl2_serial&" OR tm.pl2_serial_head_couch="&pl2_serial&" OR tm.pl2_serial_couch="&pl2_serial&" OR tm.pl2_serial_couch2="&pl2_serial&" OR tm.pl2_serial_couch3="&pl2_serial&" OR tm.pl2_serial_couch4="&pl2_serial&" OR tm.pl2_serial_couch5="&pl2_serial& "  OR tm.pl2_serial_couch6="&pl2_serial& " OR tm.pl2_serial_couch7="&pl2_serial& "OR tm.pl2_serial_trainer1="&pl2_serial&" OR tm.pl2_serial_trainer2="&pl2_serial
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ms="&pl2_serial&" AND ew.win_name like '%남자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ws="&pl2_serial&" AND ew.win_name like '%여자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_md="&pl2_serial&" AND ew.win_name like '%남자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wd="&pl2_serial&" AND ew.win_name like '%여자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mxd="&pl2_serial&" AND ew.win_name like '%혼합복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mt="&pl2_serial&" AND ew.win_name like '%남자단체%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wt="&pl2_serial&" AND ew.win_name like '%여자단체%')"
														SQLString = SQLString & ")"

														SQLString = SQLString & " AND (((tm.tm_year+1=year(ev.ev_stime) and month(ev.ev_stime)<3 and (tm_type<>5 and tm_type<>11) ) OR (tm.tm_year=year(ev.ev_stime) and month(ev.ev_stime)>2) and (tm_type<>5 and tm_type<>11)) or (tm.tm_year=year(ev.ev_stime) and (tm_type=5 or tm_type=11))) "
														'SQLString = SQLString & " AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) and year(tm.tm_sdate)>2003)"     '''''추가(2010.06.21)
														SQLString = SQLString & " AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) )"     '''''추가(2010.06.21)
														'국내대회만 먼저 출력함(20030324)
														'SQLString = SQLString & " AND (11<=ev_type AND ev_type<=30)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if
														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " Group By tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc"

														SQLString = SQLString & " UNION"
														SQLString = SQLString & " SELECT tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc "
														SQLString = SQLString & " FROM team_d tm, event_d ev,entree_d et,event_winner ew,danche_d dn"
														SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND ew.et_serial=et.et_serial AND ev.ev_serial=et.ev_serial)"
														'20030121 수정 (국내팀은 국내경기 실적만 인정되도록 함)
														'20030122 국가대표 임원의 경우 재직 기간의 실적만 인정하도록 수정
														SQLString = SQLString & "AND ((tm.tm_type<=3 OR ((tm.tm_type=5 OR tm.tm_type=11)) AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) AND convert(char(8),ev.ev_etime,112)<=convert(char(8),tm.tm_edate,112))) AND ((ev_type<=10  OR ev_type=100) AND (ev.ev_stime > tm.tm_sdate AND ev.ev_etime < tm.tm_edate)))"

														SQLString = SQLString & " AND ("
														for i=1 to 59
															for ii=1 to 20
														SQLString = SQLString & " (dn.pl2_serial_"&ii&"=tm.pl2_serial_"&i&" AND dn.pl2_serial_"&ii&"<>0 AND et.et_pc=3 and dn.et_serial=ew.et_serial) OR"
															next
														next

														SQLString = SQLString & " (dn.pl2_serial_1=tm.pl2_serial_60 AND dn.pl2_serial_1<>0 AND et.et_pc=3 and dn.et_serial=ew.et_serial)"
														SQLString = SQLString & " )"

														SQLString = SQLString & " AND (tm.pl2_serial_head="&pl2_serial&" OR tm.pl2_serial_head2="&pl2_serial&"  OR tm.pl2_serial_head_couch="&pl2_serial&" OR tm.pl2_serial_couch="&pl2_serial&" OR tm.pl2_serial_couch2="&pl2_serial&" OR tm.pl2_serial_couch3="&pl2_serial&" OR tm.pl2_serial_couch4="&pl2_serial&" OR tm.pl2_serial_couch5="&pl2_serial& "  OR tm.pl2_serial_couch6="&pl2_serial& " OR tm.pl2_serial_couch7="&pl2_serial& " OR tm.pl2_serial_trainer1="&pl2_serial&" OR tm.pl2_serial_trainer2="&pl2_serial
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ms="&pl2_serial&" AND ew.win_name like '%남자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_ws="&pl2_serial&" AND ew.win_name like '%여자단식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_md="&pl2_serial&" AND ew.win_name like '%남자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wd="&pl2_serial&" AND ew.win_name like '%여자복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mxd="&pl2_serial&" AND ew.win_name like '%혼합복식%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_mt="&pl2_serial&" AND ew.win_name like '%남자단체%')"
														SQLString = SQLString & " OR (tm.pl2_serial_couch_wt="&pl2_serial&" AND ew.win_name like '%여자단체%')"
														SQLString = SQLString & ")"

														SQLString = SQLString & " AND (((tm.tm_year+1=year(ev.ev_stime) and month(ev.ev_stime)<3 and (tm_type<>5 and tm_type<>11) ) OR (tm.tm_year=year(ev.ev_stime) and month(ev.ev_stime)>2) and (tm_type<>5 and tm_type<>11)) or (tm.tm_year=year(ev.ev_stime) and (tm_type=5 or tm_type=11))) "
														'SQLString = SQLString & " AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) and year(tm.tm_sdate)>2003)"     '''''추가(2010.06.21)
														SQLString = SQLString & " AND (convert(char(8),ev.ev_stime,112)>=convert(char(8),tm.tm_sdate,112) )"     '''''추가(2010.06.21)

														'국내대회만 먼저 출력함(20030324)
														'SQLString = SQLString & " AND (11<=ev_type AND ev_type<=30)"

														'실적검색 시작기간이 입력되었을 경우
														If Len(start_year)>2  then
														SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
														End if
														'실적검색 마감기간이 입력되었을 경우
														If Len(end_year)>2 then
														SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
														End if
														SQLString = SQLString & " AND (ev_kname not like '%예선%' and ev_kname not like '%평가%'  and ev_kname not like '%한·일%' and ev_kname not like '%한·중·일%')"

														SQLString = SQLString & " Group By tm.tm_year,tm.tm_id,et.tm_id2,ev.ev_stime,ev.ev_etime,ev.ev_kname,ew.win_name,ev.ev_serial,et.pl2_serial_1, et.pl2_serial_2,et.et_pc"

														SQLString = SQLString & " ORDER BY tm.tm_year,ev.ev_stime,ew.win_name"
													End if '경기실적 또는 지도 실적 구분 끝

													Set rs1 = DBCon2.Execute(SQLString)
													IF rs1.EOF AND rs1.BOF then
														'response.write  rs1.RecordCount
													Else
														rs1.MoveFirst
														total_count			= rs1.RecordCount
														record_row2		= 1
													%>
													<%
													IF record_row>0 then
													%>
													<tr height=30><td><% record_row=record_row+4%></td></tr>
													<%
													else
														record_row=0
														print_page=1
													End if
													%>
													<%
														IF print_page=1 then
															IF record_row > first_page_count-pl2_position_line then
																print_page = print_page +1
													%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=0 cellpadding=0 cellspacing=0 width="100%" class=pr_font >
										<tr>
											<td colspan=4 class=b_tblr>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font>
													<%
																record_row=1
															End if
														End if
													%>
													<tr>
														<td align=center>ㅡㅡㅡㅡㅡ 국제대회 ㅡㅡㅡㅡㅡ</td>
													</tr>		
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%>일자</td>
																	<td align=center width=50%>대회명</td>
																	<%if sort=2 then%>
																	<td align=center width=5%><!--소속...원래 20% 입상자 관련하여 바꿈(2004.10.20)--></td>
																	<td align=center width=28%>성적</td>
																	<%else%>
																	<td align=center width=5%></td>
																	<td align=center width=28%>성적</td>
																	<%end if%>
																</tr>																
																<%
																	Do While Not rs1.EOF
																		ev_serial					= rs1("ev_serial")
																		tm_id						= rs1("tm_id")
																		tm_id2						= rs1("tm_id2")
																		ev_s_year					= year(rs1("ev_stime"))

																		tm_ok			= 1
																		'1) 두 팀중에서 해당년도의 해당 선수의 소속을 찾음
																		if Len(tm_id2)>2 then
																		SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND tm_type<3 AND (tm_id="&tm_id&" OR tm_id="&tm_id2&")"
																		else
																		SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND tm_type<3 AND tm_id="&tm_id
																		end if
																		Set rs2 = DBCon2.Execute(SQLString)
																		If rs2.EOF AND rs2.BOF then
																			tm_kname			= ""
																			tm_ok			= 1
																		Else
																			rs2.MoveFirst
																			Do While NOT rs2.EOF
																				for i=1 to 60
																					if rs2("pl2_serial_"&i)=pl2_serial then
																						tm_kname		= rs2("tm_kname")
																						tm_kname		= replace(tm_kname,"(남)","")
																						tm_kname		= replace(tm_kname,"(여)","")
																						tm_kname		= replace(tm_kname,"(주)","")
																						tm_ok			= 0
																						i=57
																					end if
																				next
																			rs2.MoveNext
																			LOOP
																		End if
																		rs2.Close
																		Set rs2=Nothing

																		'2) 두팀중에 없을경우에는 해당년도 등록팀중에서 해당 선수가 소속된 팀을 찾음
																		if tm_ok=1 then
																			SQLString = "SELECT * FROM team_d WHERE tm_year="&ev_s_year&" AND tm_type<3"
																			Set rs5 = DBCon2.Execute(SQLString)
																			If rs5.EOF AND rs5.BOF then
																				tm_kname			= ""
																			Else
																				rs5.MoveFirst
																				tm_ok			= 1
																				Do While NOT rs5.EOF
																					for i=1 to 60
																						if rs5("pl2_serial_"&i)=pl2_serial then
																							tm_kname		= rs5("tm_kname")
																							tm_kname		= replace(tm_kname,"(남)","")
																							tm_kname		= replace(tm_kname,"(여)","")
																							tm_kname		= replace(tm_kname,"(주)","")
																							i=57
																							tm_ok			= 0
																						end if
																					next
																				rs5.MoveNext
																				LOOP
																			End if
																			rs5.Close
																			Set rs5=Nothing
																		end if

																		win_player=""

																		'수상자 이름 찾기 (2004.10.18 서명원감독 요구로 추가)
																		pl2_serial_1				= rs1("pl2_serial_1")
																		pl2_serial_2				= rs1("pl2_serial_2")

																		'pl2_serial_1로 찾기
																		SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_1
																		SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																		for i=1 to 59
																		SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_1&") OR "
																		next
																		SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_1&"))"
																		Set rs2 = DBCon2.Execute(SQLString)
																		If rs2.EOF AND rs2.BOF then
																			win_player1=""
																		Else
																			win_player1= rs2("pl2_kname")
																		End if
																		rs2.Close
																		Set rs2=Nothing
																		
																		'pl2_serial_2로 찾기
																		SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_2
																		SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																		for i=1 to 59
																		SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_2&") OR "
																		next
																		SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_2&"))"
																		Set rs2 = DBCon2.Execute(SQLString)
																		If rs2.EOF AND rs2.BOF then
																			win_player2=""
																		Else
																			win_player2= rs2("pl2_kname")
																		End if
																		rs2.Close
																		Set rs2=Nothing

																		if win_player1=win_player2 then
																			win_player = win_player1
																		else
																			if len(win_player1)>1 AND len(win_player2)>1 then
																				win_player = win_player1&"/"&win_player2
																			elseif len(win_player1)>1 AND len(win_player2)=0 then
																				win_player = win_player1
																			elseif len(win_player1)=0 AND len(win_player2)>1 then
																				win_player = win_player2
																			end if
																		end if																					

																		If Len(rs1("ev_stime"))>0 then
																		ev_stime				= split(FormatDateTime(rs1("ev_stime"),2),"-")

																		ev_stime_y			= ev_stime(0)
																		ev_stime_m			= Cint(ev_stime(1))
																			IF Len(ev_stime_m)=1 then
																				ev_stime_m		= "&nbsp;"&ev_stime_m
																			End if
																		ev_stime_d			= Cint(ev_stime(2))
																			IF Len(ev_stime_d)=1 then
																				ev_stime_d		= "&nbsp;"&ev_stime_d
																			End if
																		End if

																		If Len(rs1("ev_etime"))>0 then
																		ev_etime				= split(FormatDateTime(rs1("ev_etime"),2),"-")

																		ev_etime_y			= ev_etime(0)
																		ev_etime_m			= Cint(ev_etime(1))
																			IF Len(ev_etime_m)=1 then
																				ev_etime_m		= "&nbsp;"&ev_etime_m
																			End if
																		ev_etime_d			= Cint(ev_etime(2))
																			IF Len(ev_etime_d)=1 then
																				ev_etime_d		= "&nbsp;"&ev_etime_d
																			End if
																		End if
																	
																		ev_kname				= rs1("ev_kname")
																		ev_kname				= replace(ev_kname,"(배드민턴)","")

																		win_name				= rs1("win_name")
																		win_name				= replace(win_name," ","")
																		win_name				= replace(win_name,"단체전","단체")
																		win_name				= replace(win_name,"혼합복식","혼복")

																		if instr(win_name, "부") > 0 then 
																			temp111			= split(win_name,"부")
																			win_name			= temp111(1)
																		end if

																		if instr(win_name, "학교") > 0 then 
																			temp112			= split(win_name,"학교")
																			win_name			= temp112(1)
																		end if

																		if instr(win_name, "개인전") > 0 then 
																			temp113			= split(win_name,"개인전")
																			win_name			= "단식"&temp113(1)
																		end if

																		if instr(win_name, "단식") > 0 then 
																			win_name			= split(win_name,"단식")
																			win_name_last	= "단식"&win_name(1)
																		elseif instr(win_name, "복식") > 0 then 
																			win_name			= split(win_name,"복식")
																			win_name_last	= "복식"&win_name(1)
																		elseif instr(win_name, "혼복") > 0 then 
																			win_name			= split(win_name,"혼복")
																			win_name_last	= "혼복"&win_name(1)
																		elseif instr(win_name, "단체") > 0 then 
																			if sort=1 then
																			win_name			= split(win_name,"단체")
																			win_name_last	= "단체"&win_name(1)
																			else
																			win_name			= win_name
																			win_name_last	= win_name
																			end if
																		else
																			win_name_last			= win_name
																		end if

																		if Len(win_name_last)<3 then
																			win_name_last = "단체"&win_name_last
																		end if
																%>
																<tr height=18>
																	<td valign=top width=17%><%=ev_stime_y&"."&ev_stime_m&"."&ev_stime_d%><% if ev_stime_m<>ev_etime_m OR ev_stime_d<>ev_etime_d then%> - <% if ev_stime_m<>ev_etime_m then%><%=ev_etime_m&"."%><% end if %><%=ev_etime_d%><%end if%></td>
																	<td valign=top width=50%><%=ev_kname%></td>
																	<%if sort=2 then%>
																	<td valign=top align=center width=5%><!--<%=tm_kname%>--></td>
																	<td valign=top width=28% <%if sort=1 then%>align=center<%end if%>><%=win_name_last%> <% if instr(win_name_last,"단체")=0 AND sort=2 then%> (<%=win_player%>)<% end if%></td>
																	<%else%>
																	<td valign=top align=center width=5%><!--<%=tm_kname%>--></td>
																	<td valign=top width=28% align=center><%=win_name_last%></td>
																	<%end if%>
																</tr>
																<%
																	record_row=record_row+1
																	record_row2=record_row2+1
																	IF print_page=1 then
																		IF record_row =  first_page_count-pl2_position_line  then
																			print_page = print_page +1
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=0 cellpadding=0 cellspacing=0 width="100%" class=pr_font>
										<tr>
											<td colspan=4 class=b_tblr>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font>
													<%
													IF rs1.MoveNext <> rs1.EOF then
													%>
													<tr>
														<td align=center><!-- <u>ㅡ 국제대회 ㅡ</u> --></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%><!-- 일자 --></td>
																	<td align=center width=50%><!-- 대회명 --></td>
																	<%if sort<>1 then%>
																	<td align=center width=5%><!--소속 원래 20%--></td>
																	<td align=center width=28%><!-- 성적 --></td>
																	<%else%>
																	<td align=center width=5%><!--소속 원래 20%--></td>
																	<td align=center width=28%><!-- 성적 --></td>
																	<%end if%>
																</tr>																
													<%
													Else
													%>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
													<%
													End if
																record_row=1	
															End if
														Else
															IF record_row = 35  then
																print_page = print_page +1
													%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=0 cellpadding=0 cellspacing=0 width="100%" class=pr_font>
										<tr>
											<td colspan=4 class=b_tblr>
												<table border=0 cellpadding=5 cellspacing=0 width=100% class=pr_font>
													<%
													IF total_count<>record_row2-1 then
													%>
													<tr>
														<td align=center><!--<u>ㅡ 국제대회 ㅡ</u>--></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=17%><!--일자--></td>
																	<td align=center width=50%><!--대회명--></td>
																	<td align=center width=5%><!--소속 20%--></td>
																	<td align=center width=28%><!--성적--></td>
																</tr>																

													<%
													Else
													%>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
													<%
													End if
																record_row=1	
															End if
														End if

														if rs1.EOF OR rs1.BOF then
														
														else
														'if total_count=record_row2 then
														'else
														rs1.MoveNext
														'end if
														end if
														LOOP
													End if
													rs1.Close
													Set rs1=Nothing
													%>

															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr height=25 valign=top>
											<td colspan=4 class=b_blr>
												<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
													<tr>
														<td align=center width=20%>기록 대조·확인자</td>
														<td width=30%><%=witness%>&nbsp;&nbsp;&nbsp;(인)</td>
														<td width=1>|</td>
														<td align=center width=20%>사무국장</td>
														<td width=30%><%=witness2%>&nbsp;&nbsp;&nbsp;(인)</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height=60 valign=bottom>
								<td align=center class=pr_font>
									<b><font style="font-family:바탕; font-size:20pt; color:#000000; line-height:25pt;">대 한 배 드 민 턴 협 회 장</font></b><br>
									<!--<b>회&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장 &nbsp;&nbsp;<font style="font-family:바탕; font-size:17pt; color:#000000; line-height:20pt;">강&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;영 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;중</font></b>-->
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<%
			'단체 실적 증명서일 경우
			Else
				tm_kname2			= replace(tm_kname,"(남)","")
				tm_kname2			= replace(tm_kname2,"(여)","")

			'단체의 기본 정보 가져오기			
			SQLString = "SELECT * FROM team_d WHERE tm_kname='"&tm_kname&"'"
			SET rs = DBCon2.Execute(SQLString)
			If rs.EOF AND rs.BOF then
			Else
				tm_add1		= rs("tm_add1")
				tm_add2		= rs("tm_add2")
					tm_add	= tm_add1&" "& tm_add2
					if instr(tm_add,"(")>0 then
						tm_add_div			= split(tm_add,"(")
						tm_add				= tm_add_div(0)
					end if
			End if
			rs.Close
			Set rs=Nothing
			%>
			<table border="0" cellpadding="0" cellspacing="10" width="100%" height="100%">
				<tr width="100%" height="100%">
					<td height="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr height=60>
								<td align=center><font style="font-family:바탕; font-size:20pt; color:#000000; line-height:30pt;"><b><%=proof_name%>실적 증명서</b></font></td>
							</tr>
							<tr>
								<td>
									 <table width="100%" border="0" cellpadding="4" cellspacing="0" class="pr_font" valign="top">
										<tr>
											<td width=15% align=center class="b_tblr">종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
											<td width=45% class="b_tbr11">배드민턴</td>
											<td width=15% align=center class="b_tbr">발급번호</td>
											<td width=25% class="b_tbr11"><%=nono%></td>
										</tr>
										<tr>
											<td align=center class="b_blr">발급일자</td>
											<td class="b_br11"><%=year(now)%>년 <%=month(now)%>월 <%=day(now)%>일</td>
											<td align=center class="b_blr">발급부수</td>
											<td class="b_br11"><%=print_count%> 매</td>
										</tr>
										<tr>
											<td align=center class="b_blr">단&nbsp;체&nbsp;명</td>
											<td colspan=3 class="b_br11"><%=tm_kname2%></td>
										</tr>
										<tr>
											<td align=center class="b_blr">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>
											<td colspan=3 class="b_br11"><%=tm_add%></td>
										</tr>
										<tr>
											<td align=center class="b_blr">용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;도</td>
											<td class="b_br11"><%=use%>&nbsp;</td>
											<td align=center class="b_blr">제&nbsp;&nbsp;출&nbsp;&nbsp;처</td>
											<td class="b_br11"><%=present%>&nbsp;</td>
										</tr>
										<tr>
											<td colspan="4" class="b_blr" height="100%" valign="top">
												<table border="0" cellpadding="5" cellspacing="0" width="100%" class="pr_font" valign="top">
													<tr>
														<td align=center><u><%=proof_name%> 실적</u></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=19%>일자</td>
																	<td align=center width=50%>대회명</td>
																	<td align=center colspan=2 width=31%>성적</td>
																</tr>																
																<%
																SQLString =  "SELECT distinct(tm.tm_id),tm.tm_year,ev.ev_kname,ew.win_name,ev.ev_stime,ev.ev_etime,et.et_serial,et.pl2_serial_1, et.pl2_serial_2,ev.ev_serial  FROM team_d tm, event_d ev,event_winner ew,entree_d et"
																SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND et.ev_serial=ev.ev_serial)"
																SQLString = SQLString & " AND (((tm.tm_type=5) AND (ev.ev_type<=10 OR ev.ev_type=100)) OR (tm.tm_type<>5 AND (ev.ev_type>10 AND ev.ev_type<>100)))" 
																SQLString = SQLString & " AND (ew.et_serial=et.et_serial AND (tm.tm_id=et.tm_id OR tm.tm_id=et.tm_id2))"
																SQLString = SQLString & " AND tm.tm_year=year(ev.ev_stime)"
																SQLString = SQLString & " AND tm.tm_id="&tm_id

																'팀 소속 선수의 성적도 반영 (2004/01/02 이선경)
																SQLString = SQLString & " UNION"
																SQLString =  "SELECT distinct(tm.tm_id),tm.tm_year,ev.ev_kname,ew.win_name,ev.ev_stime,ev.ev_etime,et.et_serial,et.pl2_serial_1, et.pl2_serial_2,ev.ev_serial  FROM team_d tm, event_d ev,event_winner ew,entree_d et"
																SQLString = SQLString & " WHERE (ev.ev_serial=ew.ev_serial AND ew.ev_serial=ev.ev_serial AND et.ev_serial=ev.ev_serial)"
																SQLString = SQLString & " AND (ew.et_serial=et.et_serial)"

																SQLString = SQLString & " AND (((tm.pl2_serial_1=et.pl2_serial_1 AND et.pl2_serial_1<>0) OR (tm.pl2_serial_1=et.pl2_serial_2 AND et.pl2_serial_2<>0)"
																for k=2 to 60
																SQLString = SQLString & "OR (tm.pl2_serial_"&k&"=et.pl2_serial_1 AND et.pl2_serial_1<>0) OR (tm.pl2_serial_"&k&"=et.pl2_serial_2 AND et.pl2_serial_2<>0)"
																next
																SQLString = SQLString & " ) OR tm.tm_id=et.tm_id OR tm.tm_id=et.tm_id2)"

																SQLString = SQLString & " AND tm.tm_year=year(ev.ev_stime)"
																SQLString = SQLString & " AND tm.tm_id="&tm_id

																'실적검색 시작기간이 입력되었을 경우
																If Len(start_year)>2  then
																SQLString = SQLString & " AND ("&Cint(start_year)&"<=year(ev.ev_stime))"
																End if
																'실적검색 마감기간이 입력되었을 경우
																If Len(end_year)>2 then
																SQLString = SQLString & "AND (year(ev.ev_stime)<="&Cint(end_year)&")"
																End if

																'평가전은 임의로 삭제 (2005.10.06)
																SQLString = SQLString & "AND ev_kname not like '%평가%'"
																'예선전은 임의로 삭제 (2006.02.10)
																SQLString = SQLString & " AND (ev_kname not like '%예선%' )"

																SQLString = SQLString & " ORDER BY tm.tm_year,ev_stime" 
																'Response.Write SQLString
																Set rs1 = DBCon2.Execute(SQLString)
																IF rs1.EOF AND rs1.BOF then
																Else

																	rs1.MoveFirst
																	print_page=1
																	record_row=1
																	Do While Not rs1.EOF 
																		'ev_serial					= rs1("ev_serial")
																		'tm_id						= rs1("tm_id")

																		win_player=""

																		'수상자 이름 찾기 (2004.10.18 서명원감독 요구로 추가)
																		pl2_serial_1				= rs1("pl2_serial_1")
																		pl2_serial_2				= rs1("pl2_serial_2")
																		tm_id						= rs1("tm_id")

																		'pl2_serial_1로 찾기
																		SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_1
																		SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																		for i=1 to 59
																		SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_1&") OR "
																		next
																		SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_1&"))"
																		Set rs2 = DBCon2.Execute(SQLString)
																		If rs2.EOF AND rs2.BOF then
																			win_player1=""
																		Else
																			win_player1= rs2("pl2_kname")
																		End if
																		rs2.Close
																		Set rs2=Nothing

																		'pl2_serial_2로 찾기
																		SQLString = "SELECT * FROM people2_d, team_d tm WHERE pl2_serial="&pl2_serial_2
																		SQLString = SQLString & " AND tm_id="&tm_id&" AND ("
																		for i=1 to 59
																		SQLString = SQLString & "(tm.pl2_serial_"&i&"="&pl2_serial_2&") OR "
																		next
																		SQLString = SQLString & "(tm.pl2_serial_60="&pl2_serial_2&"))"
																		Set rs2 = DBCon2.Execute(SQLString)
																		If rs2.EOF AND rs2.BOF then
																			win_player2=""
																		Else
																			win_player2= rs2("pl2_kname")
																		End if
																		rs2.Close
																		Set rs2=Nothing

																		if win_player1=win_player2 then
																			win_player = win_player1
																		else
																			if len(win_player1)>1 AND len(win_player2)>1 then
																				win_player = win_player1&"/"&win_player2
																			elseif len(win_player1)>1 AND len(win_player2)=0 then
																				win_player = win_player1
																			elseif len(win_player1)=0 AND len(win_player2)>1 then
																				win_player = win_player2
																			end if
																		end if

																		If Len(rs1("ev_stime"))>0 then
																		ev_stime				= split(FormatDateTime(rs1("ev_stime"),2),"-")

																		ev_stime_y			= ev_stime(0)
																		ev_stime_m			= Cint(ev_stime(1))
																			IF Len(ev_stime_m)=1 then
																				ev_stime_m		= "&nbsp;"&ev_stime_m
																			End if
																		ev_stime_d			= Cint(ev_stime(2))
																			IF Len(ev_stime_d)=1 then
																				ev_stime_d		= "&nbsp;"&ev_stime_d
																			End if
																		End if

																		If Len(rs1("ev_etime"))>0 then
																		ev_etime				= split(FormatDateTime(rs1("ev_etime"),2),"-")

																		ev_etime_y			= ev_etime(0)
																		ev_etime_m			= Cint(ev_etime(1))
																			IF Len(ev_etime_m)=1 then
																				ev_etime_m		= "&nbsp;"&ev_etime_m
																			End if
																		ev_etime_d			= Cint(ev_etime(2))
																			IF Len(ev_etime_d)=1 then
																				ev_etime_d		= "&nbsp;"&ev_etime_d
																			End if
																		End if
																	
																%>
																<tr height=40>
																	<td valign=top><%=ev_stime_y&"."&ev_stime_m&"."&ev_stime_d%> - <% if ev_stime_m<>ev_etime_m then%><%=ev_etime_m&"."%><% end if %><%=ev_etime_d%></td>
																	<td valign=top><%=rs1("ev_kname")%></td>
																	<td></td>
																	<td valign=top><%=rs1("win_name")%><% if instr(rs1("win_name"),"단식")>0 OR instr(rs1("win_name"),"복식")>0 then%> (<%=win_player%>)<%end if%></td>
																</tr>
																<%

																	record_row=record_row+1
																	IF print_page=1 then
																		IF record_row = 24  then
																			print_page = print_page +1
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=1 cellpadding=0 cellspacing=0 width=100% class=pr_font bordercolor="FFFFFF" bordercolorlight="CDCDCC" bordercolordark="FFFFFF">
										<tr>
											<td colspan="4" class="b_tblr">
												<table border="0" cellpadding="5" cellspacing="0" width="100%" class="pr_font">
													<tr>
														<td align=center><u><%=proof_name%> 실적</u></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=19%>일자</td>
																	<td align=center width=50%>대회명</td>
																	<td align=center colspan=2 width=31%>성적</td>
																</tr>																
																<%
																			record_row=1	
																		End if
																	Else
																		IF record_row = 34  then
																			print_page = print_page +1
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<H6></H6>
									<table border=1 cellpadding=0 cellspacing=0 width=100% class=pr_font bordercolor="FFFFFF" bordercolorlight="CDCDCC" bordercolordark="FFFFFF">
										<tr>
											<td colspan="4" class="b_tblr">
												<table border="0" cellpadding="5" cellspacing="0" width="100%" class="pr_font">
													<tr>
														<td align=center><u><%=proof_name%> 실적</u></td>
													</tr>
													<tr>
														<td>
															<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
																<tr>
																	<td align=center width=19%>일자</td>
																	<td align=center width=60%>대회명</td>
																	<td align=center colspan=2 width=21%>성적</td>
																</tr>																
																<%
																			record_row=1	
																		End if
																	End if

																	rs1.MoveNext
																	LOOP
																End if
																rs1.Close
																Set rs1=Nothing
																%>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="4" class="b_blr">
												<table border=0 cellpadding=0 cellspacing=0 width=100% class=pr_font>
													<tr>
														<td align=center width=20%>기록 대조·확인자</td>
														<td width=30%><%=witness%>&nbsp;&nbsp;&nbsp;(인)</td>
														<td width=1>|</td>
														<td align=center width=20%>사무국장</td>
														<td width=30%><%=witness2%>&nbsp;&nbsp;&nbsp;(인)</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height=60 valign=center>
								<td align="center" class="pr_font">
									<b><font style="font-family:바탕; font-size:20pt; color:#000000; line-height:25pt;">대 한 배 드 민 턴 협 회 장</font></b><br>
									<!--<b>회&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장 &nbsp;&nbsp;<font style="font-family:바탕; font-size:17pt; color:#000000; line-height:20pt;">강&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;영 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;중</font></b>-->
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<%
			End if

				tm_kname			= replace(tm_kname,"&","^")
				present				= replace(present,"&","^")
			%>
			</table>
			<!-- S: btn-list-center -->
			<div class="btn-list-center">
				<a href="javascript:;" onClick="window.open('proof_print.asp?division=<%=division%>&pl1_name=<%=pl1_name%>&pl1_no1=<%=pl1_no1%>&tm_kname=<%=tm_kname%>&tm_id=<%=tm_id%>&use=<%=use%>&present=<%=present%>&sort=<%=sort%>&witness=<%=witness%>&witness2=<%=witness2%>&start_year=<%=start_year%>&end_year=<%=end_year%>&nono=<%=nono%>&print_count=<%=print_count%>&add=<%=add%>&position=<%=position%>','proof_print','toolbar=no,menubar=yes,scrollbars=yes,resizable=yes,width=750,height=600');" class="btn btn-confirm">인쇄</a> 
			</div>
			<!-- E: btn-list-center -->
		<!-- E : table-list --> 
		<!-- E : 리스트형 20개씩 노출 --> 
		</div>
	</div>
	<!-- E : content cert_regist --> 
<!--#include file="../include/footer.asp"-->
<%Call DBClose2()%>