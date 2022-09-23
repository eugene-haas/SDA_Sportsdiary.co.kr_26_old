<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->


  <!-- S: content -->
  <div id="content" class="gameTitle index">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>종별관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회정보관리</li>
						<li>대회생성</li>
            <li>종별관리</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->

      
      <div class="GameTitleMenu_management">
				<h2>제37회 회장기 전국 생활체육 배드민턴대회</h2>
        <table cellspacing="0" cellpadding="0">
					<tr>
						<th>대회명</th>
						<td>
							<select name="" id="">
								<option value="">생활체육</option>
							</select>
						</td>
						<th>대회명</th>
						<td class="rb_none" colspan="3">
							<select name="" id="">
								<option value="">단체전</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>대회명</th>
						<td colspan="3" class="rb_none">
							<input type="text" value="제37회 회장기 전국 생활체육" class="in_100">
						</td>
					</tr>
					<tr>
						<th>대회기간</th>
						<td>
							<input type="text" value="2018-02-29">
							<span>~</span>
							<input type="text" value="2018-02-29">
						</td>
						<th>참가신청 기간</th>
						<td class="rb_none">
							<input type="text" value="2018-02-29">
							<span>~</span>
							<input type="text" value="2018-02-29">
						</td>
					</tr>
					<tr>
						<th>대진추첨일</th>
						<td>
							<input type="text" value="2018-02-29">
							<span>~</span>
							<input type="text" value="2018-02-29">
						</td>
						<th>참가신청 노출</th>
						<td class="rb_none">
							<select name="" id="">
								<option value="">미노출</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>개최지역</th>
						<td>
							<select name="" id="">
								<option value="">경남</option>
							</select>
						</td>
						<th>개최장소</th>
						<td class="rb_none">
							<input type="text" value="밀양" class="in_2">
						</td>
					</tr>
					<tr>
						<th>경기구분</th>
						<td>
							<select name="" id="">
								<option value="">엘리트+생활체육</option>
							</select>
						</td>
						<th>경기유형</th>
						<td class="rb_none">
							<select name="" id="">
								<option value="">개인전+단체전</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>기본 랠리포인트</th>
						<td colspan="3" class="rb_none">
							<input type="text" placeholder="기본점수 입력">
							<a href="#" class="black_btn">듀스여부</a>
							<select name="" id="" class="in_3">
								<option value="">있음</option>
							</select>
							<input type="text" placeholder="최종 종료점수 입력" class="in_1">
							<a href="#" class="black_btn">세트설정</a>
							<select name="" id="" class="in_3">
								<option value="">1</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>대진표(심판)노출</th>
						<td>
							<select name="" id="" class="in_3">
								<option value="">미노출</option>
							</select>
						</td>
						<th>SD APP 노출여부</th>
						<td class="rb_none">
							<select name="" id="" class="in_3">
								<option value="">미노출</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>심판기록 앱 URL</th>
						<td colspan="3" class="rb_none">
							<input type="text" value="http://badminton.sportsdiary.co.kr/badminton/SD_OS/calendar.asp" class="in_100">
						</td>
					</tr>
				</table>
				<div class="btn_list">
					<a href="#" class="blue_btn">등록</a>
					<a href="#" class="black_btn">취소</a>
				</div>
      </div>
    <!-- E: content -->
  </div>
  <!-- E: main -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>