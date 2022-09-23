<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<%
	GameTitleIDX = fInject(Request("GameTitleIDX"))

	'Response.Write GameTitleIDX
	'Response.End
	If GameTitleIDX = "" Then 
		Response.Write "<script>alert('잘못된 경로로 접근하셨습니다.');history.back();</script>"
		Response.End

	Else
		GSQL = "SELECT GameTitleName "
		GSQL = GSQL&" FROM Sportsdiary.dbo.tblGameTitle "
		GSQL = GSQL&" WHERE DelYN='N'" 
		GSQL = GSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

		Set GRs = Dbcon.Execute(GSQL)

		If Not(GRs.Eof Or GRs.Bof) Then 
			GameTitleName = GRs("GameTitleName")
		Else
			Response.Write "<script>alert('잘못된 경로로 접근하셨습니다.');history.back();</script>"
			Response.End
		End If 

		GRs.Close
		Set GRs = Nothing 
		
	End If 

%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script language="javascript">
//리스트
function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.
	var GameTitleIDX = "<%=GameTitleIDX%>";
	var list   = document.getElementById("list");
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_TeamNm      = sf.Search_TeamNm.value

	//다음조회를 조회보다 먼저 눌렀을 경우 막는다
	if (tp=="N" && settp=="") {
		alert ("조회 데이타가 없습니다!");

	}
	//tp : F-조회, N-다음조회
	//setkey : 다음조회를 위하여 키를 던진다 전 조회 마지막 데이타를 키로 만든다
	var strAjaxUrl="/Manager/ajax/ConfirmList_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				GameTitleIDX    : GameTitleIDX ,
				Search_TeamNm : Search_TeamNm 
			},
			success: function(retDATA) {
				if(retDATA){		
					strcut = retDATA.split("ㅹ")
					if (strcut[0] != "null") {								
						totcnt.innerText = strcut[0]
						nowcnt.innerText = strcut[0]					
						list.innerHTML = list.innerHTML + strcut[1];
					}
					if (strcut[0] == "null") {
						alert ("조회 데이타가 없습니다!");
					}
				}
			}, error: function(xhr, status, error){
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});
	}	
function down_data(obj){
//	alert(obj)
	window.location.assign('download.asp?filename='+obj);
}

function chk_zip(obj){
	window.open("/Manager/ajax/ConfirmList_Zip.asp?GameTitleIDX="+obj,"_blank","width=400 height=400")
	/*
	var strAjaxUrl="/Manager/ajax/ConfirmList_Zip.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				GameTitleIDX    : obj 				
			},
			success: function(retDATA) {
					//document.write (retDATA);

				if(retDATA){										

					if (retDATA == "null") {
						alert ("조회 데이타가 없습니다!");
					}else{
						document.write (retDATA);
					}
				}
			}, error: function(xhr, status, error){
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
		});
		*/
}


</script>

<style>
  #content {position: relative;}
  div.loaction {margin-bottom: 190px;}
  .top-navi {top: 48px; left: -40px; width: 100%; min-width: 731px; padding-left: 40px; margin-right: 40px;}
</style>
<body>
<!--<body onload="view_frm('F')">-->
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회정보관리</strong> &gt;<%=GameTitleName%>&gt; 학교장확인서
			</div>
			<!-- S : top-navi -->
			<div class="top-navi" >
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->					
					<!-- E : top-navi-tp 접혔을 때 -->
				</div>
			</div>
			<!-- E : top-navi -->
			<!-- S : sch 검색조건 선택 및 입력 -->
			<form name="search_frm" method="post">
			<div class="sch">
					<table class="sch-table">
						<caption>검색조건 선택 및 입력</caption>
						<colgroup>
							<col width="50px" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="competition-name-2">학교명</label></th>
								<td>
									<input type="text" name="Search_TeamNm" id="Search_TeamNm" class="txt-bold" />
								</td>
							</tr>
						</tbody>
					</table>
			</div>
			<div class="btn-right-list">
				<a href="javascript:view_frm('F');" class="btn" id="btnview" accesskey="s">검색(S)</a>
			</div>
			</form>
			<!-- E : sch 검색조건 선택 및 입력 -->
			<!-- S : 리스트형 20개씩 노출 -->
			<div class="sch-result">
				<a href="javascript:chk_zip('<%=GameTitleIDX%>');">확인서다운로드</a>
				<a href="javascript:view_frm('F');" class="btn-more-result">
					전체 (<strong id="totcnt">0</strong>)건 / <strong class="current" >현재(<span id="nowcnt">0</span>)</strong>
					<!--//<i class="fa fa-plus" aria-hidden="true"></i>-->					
				</a>
			</div>
			<div class="table-list-wrap">
				<!-- S : table-list -->
				<table class="table-list">
					<caption>대회정보관리 리스트</caption>
					<colgroup>
						<col width="44px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<!--<col width="80px" />-->
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">학교명</th>
							<th scope="col">성별</th>
							<th scope="col">학교장확인서첨부여부</th>
							<th scope="col">학교장확인서보기</th>
							<!--<th scope="col">확인서등록</th>-->
						</tr>
					</thead>
					<input type="hidden" id="settp" value="" />        
					<input type="hidden" id="setkey" value="" />        
					<input type="hidden" id="setseq" value="" />        
					<tbody id="list">																
					</tbody>
				</table>
				<!-- E : table-list -->
				<!--<a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>-->
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
<!-- sticky -->
<script src="../js/js.js"></script>
</body>