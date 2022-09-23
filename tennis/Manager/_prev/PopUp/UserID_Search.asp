<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Search_Text = Request("Search_Text")
%>
<script>
function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var f = document.popup_frm;
	if(f.Search_Text.value==""){
		alert("사용하실 아이디를 입력해 주세요.");
		f.Search_Text.focus();
		return;
	}

	var strAjaxUrl = "/Manager/Ajax/UserID_Search.asp";
	var Search_Text         = f.Search_Text.value;

	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',			
		data: { 
			Search_Text   : Search_Text 
		},		
		success: function(retDATA) {
			//document.write(retDATA);
			if(retDATA){
				var strcut = retDATA.split("ㅹ");								
				//다음조회가 있는 경우에만 데이터를 출력한다
				if (strcut[0] != "null") {												
					list.innerHTML = strcut[0];

					//조회종료 효과
					//parent.fBottom.popupClose("btnview","btnnext","");
				}

				if (strcut[0] == "null") {
					//조회종료 효과
					//parent.fBottom.popupClose("btnview","btnnext","");
					list.innerHTML = strcut[0];
				}
			}
		}, error: function(xhr, status, error){						
			//parent.fBottom.popupClose("btnsave","btnsave","");
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
		}
	});	
}

function chk_sch(obj){
	opener.document.getElementById("Chk_ID").value = "Y"
	opener.document.getElementById("Hidden_UserID").value = obj;
	opener.document.getElementById("UserID").value = obj;
	self.close();
}
</script>

<!-- psd에선 width가 930px로 되어있네요 -->
<div class="popup-wrap">
	<div class="popup">
		<!-- S : tit-popup 타이틀 -->
		<div class="tit-popup">
			<h1>
				<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
				<strong>아이디 중복확인</strong>
			</h1>
		</div>
		<!-- E : tit-popup 타이틀 -->
		<!-- S : popup-inner 팝업 콘텐츠 -->
		<div class="popup-inner">
			<!-- S : pop-view 검색조건-->
			<form name="popup_frm" method="post">
			<div class="pop-view">
				<!--<input type="text" name="Search_Text" id="Search_Text" class="input-small" onKeyUp="if(event.keyCode==13){view_frm('F');}">-->
				<input type="text" name="Search_Text" id="Search_Text" class="input-small">				
				<a href="javascript:view_frm('F');" class="btn-sch-pop"><i class="icon-sch"><img src="../images/icon_sch.png" alt="" /></i>검색</a>
			</div>
			</form>
			<!-- E : pop-view 검색조건 -->
			<!--  S : table-list-wrap 리스트-->
			<div class="table-list-wrap">
				<table class="table-list">
					<caption>조회 리스트</caption>
					<colgroup>
						<col width="60px" />
						<col width="*" />
					</colgroup>					
					<tbody id="list">
						<tr>
							<td colspan="2">사용하실 아이디를 입력해 주세요.</td>
						</tr>
						<!--
						<tr>
							<th scope="row"><a href="#" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
							<td>22351</td>
							<td>일반부</td>
						</tr>						
						-->
					</tbody>
				</table>
			</div>
			<!--  E : table-list-wrap 리스트-->
		</div>
		<!-- E : popup-inner 팝업 콘텐츠 -->
	</div>
	<div class="btn-center-list">
		<a href="javascript:self.close();" class="btn">닫기</a>
	</div>
</div>