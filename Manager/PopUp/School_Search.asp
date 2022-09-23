<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Search_Text = Request("Search_Text")
	Level_Type = Request("Level_Type")
%>
<script>
function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var settp  = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	var f = document.popup_frm;
	if(f.Search_Text.value==""){
		alert("찾으실 소속명을 입력해 주세요.");
		f.Search_Text.focus();

	}



	//다음조회를 조회보다 먼저 눌렀을 경우 막는다
	if (tp=="N" && settp=="") {
		alert ("조회 데이타가 없습니다!");

	}

	//다음조회 후 조회를 누르면 처음부터 조회한다
	if (tp=="F" && settp=="N") {
		setkey = "";
		nowcnt.innerText=0;
		list.innerHTML = "";
	}
	//조회시작 효과
	//parent.fBottom.popupOpen("btnview","btnnext","조회중입니다!");

	//tp : F-조회, N-다음조회
	//setkey : 다음조회를 위하여 키를 던진다 전 조회 마지막 데이타를 키로 만든다

	var strAjaxUrl = "/Manager/Ajax/School_Search.asp";
	var Search_Text         = f.Search_Text.value;
	var Level_Type          = f.Level_Type.value;

	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',			
		data: { 
			tp            : tp,
			key           : setkey,
			Search_Text   : Search_Text ,
			Level_Type    : Level_Type  
		},		
		success: function(retDATA) {
			//document.write(retDATA);
			if(retDATA){
				//alert(retDATA);
				var strcut = retDATA.split("ㅹ");								
				//다음조회가 있는 경우에만 데이터를 출력한다
				if (strcut[0] != "null") {								
					document.getElementById("settp").value = strcut[2]
					document.getElementById("setkey").value = strcut[1]
					totcnt.innerText = strcut[3]
					nowcnt.innerText = Number(nowcnt.innerText) + Number(strcut[4])
				
					list.innerHTML = list.innerHTML + strcut[0];

					//조회종료 효과
					//parent.fBottom.popupClose("btnview","btnnext","");
				}

				if (strcut[0] == "null") {
					//조회종료 효과
					//parent.fBottom.popupClose("btnview","btnnext","");
					alert ("조회 데이타가 없습니다!");
				}
			}
		}, error: function(xhr, status, error){						
			//parent.fBottom.popupClose("btnsave","btnsave","");
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
		}
	});	
}

function chk_data(code,name,teamgb){
	opener.document.getElementById("NowSchIDX").value = code
	opener.document.getElementById("NowSchName").value = name
	opener.document.getElementById("TeamGb").value = teamgb
	/*체급 체크*/
	if(document.popup_frm.Level_Type.value == "1"){
		if(opener.document.getElementById("TeamGb").value!="" && opener.document.getElementById("Sex").value){
			opener.chk_level();
			//alert(opener.document.getElementById("TeamGb").value);
		}
	}
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
				<strong>소속찾기</strong>
			</h1>
		</div>
		<!-- E : tit-popup 타이틀 -->
		<!-- S : popup-inner 팝업 콘텐츠 -->
		<div class="popup-inner">
			<!-- S : pop-view 검색조건-->
			<form name="popup_frm" method="post">
			<input type="hidden" name="Level_Type" value="<%=Level_Type%>">
			<div class="pop-view">
				<!--<input type="text" name="Search_Text" id="Search_Text" class="input-small" onKeyUp="if(event.keyCode==13){view_frm('F');}">-->
				<input type="text" name="Search_Text" id="Search_Text" class="input-small">				
				<a href="javascript:view_frm('F');" class="btn-sch-pop"><i class="icon-sch"><img src="../images/icon_sch.png" alt="" /></i>검색</a>
			</div>
			</form>
			<!-- E : pop-view 검색조건 -->
			<!-- S : sch-result-pop 검색결과 -->
			<div class="sch-result-pop">
				<a href="javascript:view_frm('N');" class="btn-more-result">
					전체 (<strong id="totcnt">0</strong>)건 / <strong class="current">현재(<span id="nowcnt">0</span>)</strong>
					<!--//<i class="fa fa-plus" aria-hidden="true"></i>-->
				</a>
			</div>
			<!-- E : sch-result-pop 검색결과 -->
			<!--  S : table-list-wrap 리스트-->
			<div class="table-list-wrap">
				<table class="table-list">
					<caption>조회 리스트</caption>
					<colgroup>
						<col width="60px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">선택</th>
							<th scope="col">소속지역</th>
							<th scope="col">소속명</th>
						</tr>
					</thead>
					<input type="hidden" id="settp" value="" />        
					<input type="hidden" id="setkey" value="" />        
					<input type="hidden" id="setseq" value="" />        
					<tbody id="list">
						<!--
						<tr>
							<th scope="row"><a href="#" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
							<td>22351</td>
							<td>일반부</td>
						</tr>						
						-->
					</tbody>
				</table>
				<a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!--  E : table-list-wrap 리스트-->
		</div>
		<!-- E : popup-inner 팝업 콘텐츠 -->
	</div>
	<div class="btn-center-list">
		<a href="javascript:self.close();" class="btn">닫기</a>
	</div>
</div>