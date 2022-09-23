<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/proof_pre.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서 발급 신청(기존)
    '===================================================================================================================================
	
	Dim division, pl1_name

	division			= fInject(Trim(Request.form("division")))
	pl1_name			= fInject(Trim(Request.form("pl1_name")))

	Check_AdminLogin()

	Call DBOpen2()
%>
<!--#include file="../include/head.asp"-->
<script language=JavaScript>
<!--

function pl2_search()
{
	if (form.pl1_name.value.length == 0 )
	{
		alert("개인 성명을 입력해 주십시요.");
		form.pl1_name.focus();
		return false;
	}else{
		  document.form.action="proof_pre.asp";
		  document.form.submit();
	}
}

function team_search()
{
    url = "team_search.asp?flag=0"
    window.open(url,"team_search","toolbar=no,menubar=no,scrollbars=yes,resizable=yes,width=377,height=177");
}



function checkValue(form)
{
	if ((form.pl1_name.value.length == 0 || form.pl1_no1.value.length == 0) && (form.tm_kname.value.length == 0))
	{
		alert("개인 성명과 생년월일 또는 단체명을 입력해 주십시요.");
		form.pl1_name.focus();
		return false;
	}

	if (form.nono.value.length == 0)
	{
		alert("발급번호를 입력해 주십시요.");
		form.nono.focus();
		return false;
	}

	if (form.print_count.value.length == 0)
	{
		alert("발급부수를 입력해 주십시요.");
		form.print_count.focus();
		return false;
	}

	if (form.use.value.length == 0)
	{
		alert("증명서 사용 용도를 입력해 주십시요.");
		form.use.focus();
		return false;
	}

	if (form.present.value.length == 0)
	{
		alert("증명서의 제출처를 입력해 주십시요.");
		form.present.focus();
		return false;
	}

	if (form.witness.value.length == 0)
	{
		alert("기록 대조·확인자의 성명을 입력해 주십시요.");
		form.witness.focus();
		return false;
	}

	if (form.witness2.value.length == 0)
	{
		alert("사무국장 성명을 입력해 주십시요.");
		form.witness2.focus();
		return false;
	}
	form.submit();
}
//-->
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
			<form name="form" method="post" action="proof_pre_view.asp">
			<!-- S: 신청 테이블 -->
			<table class="left-head view-table issued_box_table">
			
				<tbody>
					<tr class="short-line">
						<th>발급요청자</th>
						<td>
							<div class="issued_box">
								<ul>
									<li>
										<span class="l_con">
											<input type="radio" class="radio_in" name="division" value="1" checked>
											<span class="">개인&nbsp;- [성명]</span>	
										</span>
										<input type="text" name="pl1_name" value="<%=pl1_name%>" maxlength="20" class="in_1">
										<a href=# Onclick="JavaScript:pl2_search();" class="menu_sub btn">[찾기]</a>
										<span class="">[생년월일]</span>
										<select name="pl1_no1" class="in_1">
											<option value=0>선택하세요</option>
											<%
												IF Len(pl1_name)>=2 then
													SQLString = "SELECT distinct(pl1_no1) FROM people1_d_damo WHERE pl1_name='"&pl1_name&"' AND pl2_serial is not null ORDER bY pl1_no1"
													Response.Write SQLString
													SET rs2 = DBCon2.Execute(SQLString)
													IF rs2.EOF AND rs2.BOF then
														rs2.Close
														Set rs2=Nothing
													ELSE
														rs2.MoveFirst
														DO While NOT rs2.EOF 
															pl1_no1				= rs2("pl1_no1")
												%>
												<option value=<%=pl1_no1%>>
													<%=pl1_no1%>
												</option>
												<%
													rs2.MoveNext
													LOOP
													rs2.Close
													Set rs2=Nothing
												END IF
											End if
											%>
										</select>
									</li>
									<li>
										<span class="l_con">
											<input type="radio" name="division" value="2" class="radio_in">
											<span class="">단체&nbsp;- [단체명]</span>
										</span>
										<input type="text" name="tm_kname" size="20"  class="in_1 inputfield">
										<input type="hidden" name="tm_id" class="in_1 inputfield">
										<a href="JavaScript:team_search();" class="btn">검색</a>
										<span class="">(정확한 단체명 입력을 위해서 검색 버튼을 눌러 단체명을 검색해 주십시요)</span>
									</li>
								</ul>
							</div>
						</td>
					</tr>
					<tr class="short-line">
						<th>발급번호</th>
						<td>
							<div class="con">
								<input type=text name=nono size=15 class="in_1 inputfield">
							</div>
						</td>
					</tr>
					<tr class="short-line">
						<th>발급매수</th>
						<td>
							<div class="con">
								<input type=text name=print_count size=5 class="in_1 inputfield">
							</div>
						</td>
					</tr>
					<tr class="">
						<th>주소</th>
						<td>
							<input type=text name=add size=50 class="in_2 inputfield">
						</td>
					</tr>
			
					<tr class="">
						<th>소속</th>
						<td>
							<input type=text name=position size=30 class="in_2 inputfield">
						</td>
					</tr>
					<tr id="div_POST" class="addr_line tr_view">
						<th>용도</th>
						<td>
							<input type=text name=use size=30  class="in_2 inputfield">
						</td>
					</tr>
					<tr>
						<th>제출처</th>
						<td>
							<input type=text name=present size=30  class="in_2 inputfield">
						</td>
					</tr>
					<tr class="tiny-line">
						<th>증명서 종류</th>
						<td>
							<input type=radio name=sort value=1 checked style="vertical-align: -13px"> 
							<span class="">경기 실적&nbsp;&nbsp;</span>
							<input type=radio name=sort value=2 style="vertical-align: -13px">
							<span class="">지도 실적</span>
						</td>
					</tr>
					<tr>
						<th>기록 대조·확인자</th>
						<td>
							<input type=text name=witness size=30 class="in_2 inputfield">
						</td>
					</tr>
					<tr>
						<th>사무처장</th>
						<td>
							<input type=text name=witness2 size=30 class="in_2 inputfield" value="박종훈">
						</td>
					</tr>
					<tr>
						<th>기간</th>
						<td>
							<select name=start_year class="in_1 inputfield">
								<option value=0></option>
								<%
									for i=1988 to year(now)
								%>
									<option value="<%=i%>">
										<%=i&"년도"%>
									</option>
									<%
									next
									%>
							</select>
							<span class="">부터</span>
							<select name=end_year  class="in_1 inputfield">
								<option value=0></option>
								<%
									for i=1988 to year(now)
									%>
									<option value="<%=i%>">
										<%=i&"년도"%>
									</option>
									<%
									next
									%>
							</select>
							<span class="">까지</span>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- E: 신청 테이블 -->
			</form>
			<!-- S: btn-list-center -->
			<div class="btn-list-center">
				<a href="javascript:;" onClick="checkValue(document.form);" class="btn btn-confirm">신청</a> 
			</div>
			<!-- E: btn-list-center -->
		<!-- E : table-list --> 
		<!-- E : 리스트형 20개씩 노출 --> 
		</div>
	</div>
	<!-- E : content cert_regist --> 
<!--#include file="../include/footer.asp"-->
<%Call DBClose2()%>