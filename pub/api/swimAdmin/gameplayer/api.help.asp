<%
	'request
	If hasown(oJSONoutput, "HELPNO") = "ok" then
		helpno = oJSONoutput.HELPNO
	End If

	'Set db = new clsDBHelper





	%>
<div class="modal-dialog">

	<div class="modal-content">


		<div class='modal-header'>
			<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
			<h3 id='myModalLabel'>도움말</h3>
		</div>
		<div class="modal-body">


		<div id="orderinfo" style="width:98%;margin:auto;height:500px;overflow:auto;border: 1px solid #73AD21;">

		<%
		Select Case HELPNO
		Case "1"
		%>
		검색<br>
		* 우승자 체크박스 : 우승자 체크박스 선택시 우승자들만 검색해 주는 기능<br>
		* 검색기능 : 이름, 부서, 전화번호, 오픈부반영부서 <br>
		------------------------------------------------------------------------<br>
		오픈부 반영위치<br>
		* 오픈부의 랭킹 포인트를 합산 할 부서 설정 (?)<br>

		------------------------------------------------------------------------<br>
		개나리, 신인부 승급자 설정<br>
		* 승급자 설정: 승급자로 설정되면 다음동일대회가 발생 후 결과 처리까지 양쪽에 저장됩니다. (다음동일대회 결과반영 후 양쪽 저장 중지)<br>
		* 전년도 (우승자) 초기화 : 당해연도 이전 승급자들의 양쪽에 저장되는 것을  중지 시킵니다.<br>
		* Y/N : 승급자 들이 양쪽에 반영된다면 (Y) 반영되지 않는다면 (N)으로 표시됩니다.<br>
		* 오픈부점수 반영 : 기본설정인 사람중 신인부로 참가 신청을 할 경우 신인부로 자동 등록 됩니다.<br>

		------------------------------------------------------------------------<br>
		랭킹포인트합산<br>
		* 랭킹포인트 합산 버튼(같은이름+) : 합산할 플레이어를 정한 후 동일한 이름의 선수를 불러와 표시해준다.<br>
		* 체크된 값과 통합하기 버튼 : 선택된 선수로 아래 리스트의 선수들을 체크하면 선택된 선수로 포인트가 통합 된다.<br>


		------------------------------------------------------------------------<br><br>
		이후 구조설계및 진행<br>
		chkTIDX (이것보다작은 TIDX값에서는 양쪽 배분을 하지 않는다.) >> api.result.asp 파일 조건 추가 및 작업<br>
		startrnkdate (양쪽배분 시작 날짜 - sd_tennisTitle 에 대회시작 날짜와 비교해서 chkTIDX 값을 찾는값으로 사용한다.) >> 선수정보랭키반영및 결과 반영시 조건 추가<br>
		endRnkdate (입력값이 있을경우 랭킹산정 초기화 여부를 확인한다.)  >> 랭킹결과 생성에서 조건및 내용 추가 <br>
		2등 2번 ,3등 3번 (1년안에) 의 대회 값은 (2등2회랭킹과 , 3등3회랭킹으로 사용한다.)  >>  랭킹결과창에서 각 조건을 구한 후 조건자들 (자동지정) 수동지정의 어려움..발생<br>
		승급자 설정에서 Y,N 버튼 클릭시 생성화면 설정 ( 외부 승급자 기간 설정용으로 사용한다. KATO개나리부등 ) 시작년도월, 01 ~ 종료년도월01로 사용한다. >> 외부랭킹자들을 위한 인터페이스 생성<br>



		<%Case Else%>

		<%End Select %>
		</div>

		</div>
		<div class="modal-footer">
			<button type="button" data-dismiss='modal' aria-hidden='true' class="btn">닫기</button>
		</div>
	</div>
</div>






<%
  'db.Dispose
  'Set db = Nothing
%>
