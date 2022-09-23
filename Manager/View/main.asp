<!--#include virtual="/Manager/Common/common_header.asp"-->
<script type="text/javascript">
//리스트
function view_frm(tp){

	var list   = document.getElementById("gametitlelist");
	list.innerHTML = "";

		


	//tp : F-조회, N-다음조회
	//setkey : 다음조회를 위하여 키를 던진다 전 조회 마지막 데이타를 키로 만든다
	var strAjaxUrl="/Manager/ajax/Main_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {

			},
			success: function(retDATA) {
				if(retDATA){			
					retDATA = trim(retDATA);	
					
					var strcut = retDATA.split("ㅹ");				
				
					//다음조회가 있는 경우에만 데이터를 출력한다
					if (strcut[0] != "null") {																			
						list.innerHTML = list.innerHTML + strcut[0];
					}
					if (strcut[0] == "null") {
						alert ("조회 데이타가 없습니다!");
					}
				}
			}, error: function(xhr, status, error){
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
		});
	}	




</script>
<body onload="view_frm('F')">
	<section>
		<div id="content">
		<!-- S : main-top -->

		<div class="main-top">
			<!--<a href="#" class="btn-top"><i><img src="../images/icon_main_calendar.png" alt="" /></i> 달력보기</a>
			<a href="#" class="btn-top type2"><i><img src="../images/icon_main_list.png" alt="" /></i> 목록보기</a>
			-->
		</div>

		<!-- E : main-top -->
		<!-- S : 리스트 -->
		<table class="table-list">
			<caption>대회 리스트</caption>
			<colgroup>
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">년도</th>					
					<th scope="col">대회기간</th>
					<th scope="col">주최</th>
					<th scope="col">대회명</th>
					<th scope="col">지역</th>
					<th scope="col">장소</th>
				</tr>
			</thead>
			<tbody id="gametitlelist">


			</tbody>
		</table>
		<!-- E : 리스트 -->
		</div>
	<section>
	</body>