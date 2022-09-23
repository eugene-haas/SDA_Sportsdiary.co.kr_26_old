<!--#include file="../Library/ajax_config.asp"-->
<%

	SportsGb 		= Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
	StimFistCd 		= fInject(Request("StimFistCd"))

	If SportsGb = "" OR StimFistCd="0" Then
		Response.Write "FALSE"
		Response.End
	Else

            SQL = " EXEC View_Strength_FistInfo '"&SportsGb&"','"&StimFistCd&"'"
		    SET LRs = DBCon.Execute(SQL)
		    IF Not(LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                StimFistNm	=LRs("StimFistNm")
                StimGideFile=LRs("StimGideFile")
                LRs.MoveNext
                Loop
            Else
			    Response.Write SQL
			    Response.End
		    End IF
		    LRs.Close
		    SET LRs = Nothing
        %>

                <!-- S: list-bu-navy-wrap -->
                <div class="list-bu-navy-wrap bg-gray">
                <!-- S: tip-title -->
                <div class="tip-title">
                    <a href=".tip-cont" data-toggle="collapse">
                    <h3>
                        <span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/strength/icon_hand@3x.png" alt=""></span>
                        <span><%=StimFistNm %> 가이드 팁 보기</span>
                        <span class="img-round"><span class="caret"></span></span>
                    </h3>
                    </a>
                </div>
                <!-- E: tip-title -->
                </div>
                <!-- E: list-bu-navy-wrap -->
                <!-- S: tip-cont -->

<!--1	근력 측정
2	근파워(순발력) 측정
3	유연성 측정
4	민첩성 측정
5	근지구력 측정
6	협응력(밸런스) 측정
7	심폐지구력 측정-->
                <div class="tip-cont container collapse">
                <%
                    IF StimFistCd="1" THEN
                    %>
                    <p class="tip-txt">1회에 최대로 들 수 있는 무게(1RM)를 실시하여 근육의 파워를 직접 측정합니다.</p>
                    <h4 class="l-bar">측정순서</h4>
                    <ul class="user-guide">
                        <li><span class="number-list">1</span>기본 적당한 무게부터 시작합니다. <br> (스쿼트의 경우 본인 몸무게 부터 시작해서 10kg씩 증가 측정)</li>
                        <li><span class="number-list">2</span>1회를 들어 올릴 수 있는 수준의 무게로 점차적으로 무게를 올립니다.</li>
                        <li><span class="number-list">3</span>세트와 세트 사이에 휴식시간은 약 2분입니다.</li>
                        <li><span class="number-list">4</span>최대의 무게를 들었던 최종 무게수치를 기록합니다.</li>
                    </ul>
                    <!-- S: muscle-way -->
                    <div class="muscle-way container">
                        <h4 class="muscle-sub-title"><img src="http://img.sportsdiary.co.kr/sdapp/strength/squat-title@3x.png" alt="스쿼트 측정기준">
                        </h4>
                        <p><img src="http://img.sportsdiary.co.kr/sdapp/strength/squat@3x.png" alt="">
                        <h4 class="muscle-sub-title2"><img src="http://img.sportsdiary.co.kr/sdapp/strength/muscle-sub-title@3x.png" alt="벤치프레스 측정기준">
                        </h4>
                        <img src="http://img.sportsdiary.co.kr/sdapp/strength/muscles-way@3x.png" alt="">
                    </div>
                    <!-- E: muscle-way -->
                    <!-- S: know-detail -->
                    <div class="know-detail">
                        <h4><span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-note@3x.png" alt></span><span class="tit">자세하게 알아볼까요?</span></h4>
                        <div class="cont-box">
                        <dl>
                            <dt>1RM 결정법 : WO + WL</dt>
                            <dd><span class="dot"></span>WO : 약간 부겁다고 생각되는 중량<br>(7~10회 반복 수축이 가능한 무게)</dd>
                            <dd><span class="dot"></span>WL : WOx0.025xR(반복횟수)</dd>
                        </dl>
                        <p class="examp">예) 중량 40kg, 최대 10회 반복할 경우 </br>WL = 40x0.025x10=10<br>1RM=40+10=50kg </p>
                        </div>
                    </div>
                    <!-- E: know-detail -->
                    <%
                    ELSEIF StimFistCd="2" THEN
                    %>
                        <p class="tip-txt">단 시간 내의 운동수행 능력을 측정합니다.</p>
                        <h4 class="l-bar">측정순서</h4>
                        <h5 class="list-title">제자리 멀리뛰기</h5>
                        <ul class="user-guide">
                          <li><span class="number-list">1</span>표시선을 넘지 않도록 서서 도움닫기 없이 팔이나 다리 등 전신을 이용하여 충분히 반동을 주어 전방으로 최대한 멀리 뜁니다. </li>
                          <li><span class="number-list">2</span>발구름은 양발을 동시에 해야합니다.</li>
                          <li><span class="number-list">3</span>기록은 출발점에서 착지한 신체의 가장 뒷부분을 기준으로 직각으로 측정합니다.</li>
                        </ul>
                        <!-- S: muscle-way -->
                        <div class="muscle-way power container">
                          <img src="http://img.sportsdiary.co.kr/sdapp/strength/power-jump@3x.png" alt="">
                        </div>
                        <!-- E: muscle-way -->
                        <h5 class="list-title">서전트(제자리 높이뛰기)</h5>
                        <ul class="user-guide">
                          <li><span class="number-list">1</span>똑바로 선 자세에서 한쪽 팔을 최대한 뻗은 높이를 벽면에 표시합니다.</li>
                          <li><span class="number-list">2</span>제자리에서 발구름 없이 최대한 높이 뛰어 벽면에 표시한 위치보다 더 높이 뛰려고 노력하고 손끝의 위치를 표시합니다.</li>
                          <li><span class="number-list">3</span>①표시와 ②표시의 결과사이의 거리로 기록합니다.</li>
                        </ul>
                        <!-- S: muscle-way -->
                        <div class="muscle-way power container">
                          <img src="http://img.sportsdiary.co.kr/sdapp/strength/sergent@3x.png" alt="">
                        </div>
                        <!-- E: muscle-way -->
                    <%
                    ELSEIF StimFistCd="3" THEN
                    %>
                            <p class="tip-txt">신체의 유연성과 밸런스를 측정합니다.</p>
                            <h4 class="l-bar">측정순서</h4>
                            <h5 class="list-title">윗몸 앞으로 굽히기(체전굴)</h5>
                            <ul class="user-guide">
                              <li><span class="number-list">1</span>바닥에 앉을 때 다리를 곧게 펴고 앉습니다.</li>
                              <li><span class="number-list">2</span>양손을 위로 올려 머리를 가운데에 둡니다.</li>
                              <li><span class="number-list">3</span>반동을 주지않고 천천히 윗몸을 앞으로 굽히면서 두손의 손 끝은 다리를 가볍게 스치면서 곧게 내려 폅니다.</li>
                              <li><span class="number-list">4</span>윗몸이 최대한으로 굽혀졌을 때 손끝이 내려간 거리를 잽니다.</li>
                              <li><span class="number-list">5</span>이때 가운데 손가락으로 재고 3초간 상체와 두팔을 고정시키고, 머리는 양팔 사이로 넣습니다.</li>
                              <li><span class="number-list">6</span>총 2회 실시하며 가장 좋은 기록을 잽니다.</li>
                            </ul>
                            <!-- S: muscle-way -->
                            <div class="muscle-way power container">
                              <img src="http://img.sportsdiary.co.kr/sdapp/strength/flexi-1@3x.png" alt="">
                            </div>
                            <!-- E: muscle-way -->

                            <h5 class="list-title">윗몸 뒤로 젖히기(체후굴)</h5>
                            <ul class="user-guide">
                              <li><span class="number-list">1</span>피검자가 엎드려서 양손을 허리뒤로 열중쉬어 자세를 취합니다.</li>
                              <li><span class="number-list">2</span>보조자가 대퇴부 위치에서 무릎 위쪽을 잡아주는 역할을 합니다.</li>
                              <li><span class="number-list">3</span>피검자는 엎드린 상태에서 최대한 윗몸을 뒤로 젖히면서 턱을 위로 내밉니다.(윗몸을 뒤로 젖힐 때 반동을 써서는 안 됨)</li>
                              <li><span class="number-list">4</span>매트 또는 바닥에서부터 하약골(턱아래) 부분까지 수직거리를 잽니다.</li>
                              <li><span class="number-list">5</span>총 2회 실시하며 가장 좋은 기록을 잽니다.(자로 재도 무관 합니다.)</li>
                            </ul>
                            <!-- S: muscle-way -->
                            <div class="muscle-way container">
                              <img src="http://img.sportsdiary.co.kr/sdapp/strength/flexi-2@3x.png" alt>
                            </div>
                            <!-- E: muscle-way -->

                    <%
                    ELSEIF StimFistCd="4" THEN
                    %>
                        <p class="tip-txt">속도와 정확성을 가지고 몸의 위치를 빠르고 부드럽게 반응하는 능력을 기록합니다.</p>
                        <h4 class="l-bar">측정순서</h4>
                        <h5 class="list-title">사이드 스텝</h5>
                        <ul class="user-guide">
                          <li><span class="number-list">1</span>120cm 간격의 3줄 평행선을 긋고, 중앙의 선을 밟지 않은 상태에서 두발을 어깨넓이로 벌리고 준비자세를 취합니다.</li>
                          <li><span class="number-list">2</span>[시작]하는 신호와 함께 오른발이 오른쪽 선을 넘어서도록 오른편으로 사이드 스텝을 합니다. 이때 횟수를 1개로 합니다.</li>
                          <li><span class="number-list">3</span>오른쪽 선을 넘어 섰으면 빠른 동작으로 반대쪽 선으로 돌아 옵니다. 이때 횟수를 2개로 합니다.</li>
                          <li><span class="number-list">4</span>이 동작을 좌우로 교대하여 20초간 지속 반복 합니다.</li>
                          <li><span class="number-list">5</span>총 2세트를 실시하여 좋은 기록을 입력합니다.</li>
                        </ul>
                        <!-- S: muscle-way -->
                        <div class="muscle-way power container">
                          <img src="http://img.sportsdiary.co.kr/sdapp/strength/agility-1@3x.png" alt="">
                        </div>
                        <!-- E: muscle-way -->

                    <%
                    ELSEIF StimFistCd="5" THEN
                    %>
                        <p class="tip-txt">일정한 시간내에 최대의 반복횟수를 끌어올릴 수 있는 근육의 지구력 측정입니다.</p>
                        <h4 class="l-bar">측정순서</h4>
                        <h5 class="list-title">팔굽혀펴기 / 윗몸일으키기</h5>
                        <ul class="user-guide">
                          <li><span class="number-list">1</span>모든 측정은 1분동안 반복 실시 합니다.</li>
                          <li><span class="number-list">2</span>1분 내, 가장 많은  횟수를 기록합니다.</li>
                        </ul>
                    <%
                    ELSEIF StimFistCd="6" THEN
                    %>
                        <p class="tip-txt">끊임없이 변화하는 운동과제에 대하여 신속, 정확하게 대응할 수 있는 신체의 운동수행능력을 말합니다.</p>
                        <h4 class="l-bar">측정순서</h4>
                        <h5 class="list-title">눈감고 외발서기</h5>
                        <ul class="user-guide">
                          <li><span class="number-list">1</span>지면 위에 눈을 감고섭니다.</li>
                          <li><span class="number-list">2</span>한 발로 중심을 잡고 나머지 한 발을 뒤로 올립니다. 이 때, 동시에 몸통도 앞으로 숙이고 양팔을 벌려 균형을 유지합니다.</li>
                          <li><span class="number-list">3</span>중심축 다리를 땅에 닿지 않게 하고 시간을 기록합니다. 이때, 최대한 다리부분이 수평을 이루도록 합니다.</li>
                        </ul>
                        <!-- S: muscle-way -->
                        <div class="muscle-way power container">
                          <img src="http://img.sportsdiary.co.kr/sdapp/strength/balance-1@3x.png" alt="">
                        </div>
                    <%
                    ELSEIF StimFistCd="7" THEN
                    %>
                        <p class="tip-txt">정해진 속도 내에 반복해서 달릴 수 있는 최대의 횟수를 측정 합니다.</p>
                        <h4 class="l-bar">측정순서</h4>
                        <ul class="user-guide heart">
                          <li><span class="number-list">1</span>10M 거리의 양쪽 끝을 테이프 혹은 별도로 표시합니다.</li>
                          <li><span class="number-list">2</span>출발신호 관리자가 별도로 출발신호를 울립니다.</li>
                          <li><span class="number-list">3</span>편도 달리기와 편도 달리기 사이의 시간은 현장에서 조절하여 정하고, 점점 쉬는 구간의 시간을 줄여나갑니다.</li>
                          <li><span class="number-list">4</span>매번 편도 10M를 먼저 도착한 사람은 다음 출발신호가 울릴 때까지 대기하고, 다시 출발신호가 울리면 반대쪽 라인 끝을 향해 달립니다.</li>
                          <li><span class="number-list">5</span>왕복하는 동안 정해진 주기에 따라 속도가 빨라집니다.</li>
                          <li><span class="number-list">6</span>정해는 횟수 없이 무한 반복되고, 최후 1인이 남을 때 검사는 종료 됩니다.</li>
                          <li><span class="number-list orangy">7</span>반복되는 구간별로 출발신호에 따t라오지 못하여 지목받는 사람은 본인의 종료된 마지막 횟수를 기록합니다.(편도 횟수로 기록)</li>
                        </ul>
                        <h4 class="muscle-sub-title"><img src="http://img.sportsdiary.co.kr/sdapp/strength/heart-sub-title@3x.png" alt="셔틀런 측정기준"></h4>
                        <!-- S: muscle-way -->
                        <div class="muscle-way container">
                          <img src="http://img.sportsdiary.co.kr/sdapp/strength/shuttle-run@3x.png" alt>
                        </div>
                        <!-- E: muscle-way -->
                    <%
                    END IF
                     %>
                    <!-- S: tip-footer -->
                    <div class="tip-footer">
                        <h4 class="l-bar">출처</h4>
                        <ul class="clearfix">
                            <li><img src="http://img.sportsdiary.co.kr/sdapp/strength/sociate-1@3x.png" alt=""></li>
                            <li><img src="http://img.sportsdiary.co.kr/sdapp/strength/sociate-2@3x.png" alt=""></li>
                        </ul>
                        <p class="tip-info">체력측정의 방법은 국가대표 선수들의 체력측정 방법과 동일합니다.</p>
                    </div>
                <!-- E: tip-footer -->
                </div>
                <!-- E: tip-cont -->
        <%
	End If
 Dbclose()

%>
