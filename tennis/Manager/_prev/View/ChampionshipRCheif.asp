<!--#include virtual="/Manager_Wres/Common/common_header.asp"-->
<!--#include virtual="/Manager_Wres/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager_Wres/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script>
	/*
	make_box("sel_Year2","Search_GameYear","","Year")
	make_box("sel_Location2","Search_Sido","","Area_Small")


	make_box("sel_Year","GameYear","","Year")
	make_box("sel_Location","Sido","","Area")
	make_box("sel_GameSYear","GameS_Year","","Year")
	make_box("sel_GameSMonth","GameS_Month","","Month")
	make_box("sel_GameSDay","GameS_Day","","Day")
	make_box("sel_GameEYear","GameE_Year","","Year")
	make_box("sel_GameEMonth","GameE_Month","","Month")
	make_box("sel_GameEDay","GameE_Day","","Day")
	

	make_box("sel_GameRcvSYear","GameRcv_SYear","","Year")
	make_box("sel_GameRcvSMonth","GameRcv_SMonth","","Month")
	make_box("sel_GameRcvSDay","GameRcv_SDay","","Day")
	make_box("sel_GameRcvEYear","GameRcv_EYear","","Year")
	make_box("sel_GameRcvEMonth","GameRcv_EMonth","","Month")
	make_box("sel_GameRcvEDay","GameRcv_EDay","","Day")

	
	//주최정보SELECT
	make_box("sel_HostCode","HostCode","","HostCode")
	*/


</script>
<script language="javascript">



//입력폼 체크 S
function input_frm(){		
	var f = document.frm;
	if(f.GameTitleIDX.value==""){
		alert("대회명을 선택해주세요.");
		f.GameTitleIDX.focus();
		return false;
	}
	if(f.GameDay.value==""){
		alert("심판배정 대회날짜를 선택해주세요.");
		f.GameDay.focus();
		return false;
	}
	if(f.CheifIdx.value==""){
		alert("대회날짜를 선택해주세요.");
		f.CheifIdx.focus();
		return false;
	}
	if(f.CheifType.value==""){
		alert("심판구분을 선택해주세요.");
		f.CheifType.focus();
		return false;
	}
	if(f.StadiumNumber.value==""){
		alert("경기장을 선택해주세요.");
		f.StadiumNumber.focus();
		return false;
	}
	if(f.CheifLevel.value==""){
		alert("심판번호를 선택해주세요.");
		f.CheifLevel.focus();
		return false;
	}

	if(confirm("심판 입력을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager_Wres/Ajax/ChampionshipRCheif_Insert.asp";
		var GameTitleIDX     = f.GameTitleIDX.value;
		var GameDay          = f.GameDay.value;
		var CheifIdx         = f.CheifIdx.value;
		var CheifType				 = f.CheifType.value;
		var StadiumNumber    = f.StadiumNumber.value;
		var CheifLevel       = f.CheifLevel.value;

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				GameTitleIDX   : GameTitleIDX ,
				GameDay        : GameDay  ,
				CheifIdx       : CheifIdx ,
				CheifType			 : CheifType ,
				StadiumNumber  : StadiumNumber ,
				CheifLevel     : CheifLevel
				

			},		
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){
					//parent.fBottom.popupClose("btnsave","btnsave","");
					if (retDATA=='TRUE') {
						alert('입력이 완료되었습니다!');		
						view_frm("F");						
					}	else if(retDATA=='SAME'){
						alert('해당일자에 이미 등록된 심판 입니다.!');								
					} else {
						alert('예외가 발생하여 입력이 실패하였습니다!');								
					}
				}
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});		
	}
}


//수정폼 체크 S
function update_frm(){		
	var f = document.frm;
	var seq = document.getElementById('setseq').value;
	
	if (seq==''){
		alert ("수정 대상을 선택하십시오!");
		return false;
	}
	if(f.GameGb.value==""){
		alert("대회구분을 선택해 주세요");
		f.GameGb.focus();
		return false;
	}
	if(f.SportsGb.value==""){
		alert("종목을 선택해 주세요.");
		f.SportsGb.focus();
		return false;
	}
	if(f.GameYear.value==""){
		alert("대회년도를 선택해 주세요");
		f.GameYear.focus();
		return false;
	}
	if(f.GameTitleName.value==""){
		alert("대회명을 입력해 주세요");
		f.GameTitleName.focus();
		return false;
	}
	if(f.Sido.value==""){
		alert("대회개최 지역을 선택해 주세요");
		f.Sido.focus();
		return false;
	}
	if(f.SidoDtl.value==""){
		alert("대회개최 상세지역을 입력해 주세요");
		f.SidoDtl.focus();
		return false;
	}
	if(f.GameS_Year.value==""){
		alert("대회 시작년도를 선택해 주세요");
		f.GameS_Year.focus();
		return false;
	}
	if(f.GameS_Month.value==""){
		alert("대회 시작월을 선택해 주세요");
		f.GameS_Month.focus();
		return false;
	}
	if(f.GameS_Day.value==""){
		alert("대회 시작일을 선택해 주세요");
		f.GameS_Day.focus();
		return false;
	}
	if(f.GameE_Year.value==""){
		alert("대회종료 년도를 선택해 주세요");
		f.GameE_Year.focus();
		return false;
	}
	if(f.GameE_Month.value==""){
		alert("대회종료 월을 선택해 주세요");
		f.GameE_Month.focus();
		return false;
	}
	if(f.GameE_Day.value==""){
		alert("대회종료 일을 선택해 주세요");
		f.GameE_Day.focus();
		return false;
	}	
	if(f.GameArea.value==""){
		alert("대회 개최 장소를 입력해 주세요");
		f.GameArea.focus();
		return false;
	}
	//접수시작년도
	/*
	if(f.GameRcv_SYear.value==""){
		alert("접수 시작년도를 선택해 주세요");
		f.GameRcv_SYear.focus();
		return false;
	}
	if(f.GameRcv_SMonth.value==""){
		alert("접수 시작월을 선택해 주세요");
		f.GameRcv_SMonth.focus();
		return false;
	}
	if(f.GameRcv_SDay.value==""){
		alert("접수 시작일을 선택해 주세요");
		f.GameRcv_SDay.focus();
		return false;
	}
	if(f.GameRcv_EYear.value==""){
		alert("접수종료 년도를 선택해 주세요");
		f.GameRcv_EYear.focus();
		return false;
	}
	if(f.GameRcv_EMonth.value==""){
		alert("접수종료 월을 선택해 주세요");
		f.GameRcv_EMonth.focus();
		return false;
	}
	if(f.GameRcv_EDay.value==""){
		alert("접수종료 일을 선택해 주세요");
		f.GameRcv_EDay.focus();
		return false;
	}	
	*/
	if(f.EnterType.value==""){
		alert("동호인 참가여부를 선택해 주세요");
		f.EnterType.focus();
		return false;
	}	
	if(f.HostCode.value==""){
		alert("대회주최를 선택해 주세요.");
		f.HostCode.focus();
		return false;
	}

	if(confirm("심판 수정을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager_Wres/Ajax/ChampionshipInfo_Update.asp";
		var SportsGb       = f.SportsGb.value;
		var GameGb         = f.GameGb.value;
		var GameYear       = f.GameYear.value;
		var GameTitleName  = f.GameTitleName.value;
		var Sido           = f.Sido.value;
		var SidoDtl        = f.SidoDtl.value;
		var GameS_Year     = f.GameS_Year.value;
		var GameS_Month    = f.GameS_Month.value;
		var GameS_Day      = f.GameS_Day.value;
		var GameE_Year     = f.GameE_Year.value;
		var GameE_Month    = f.GameE_Month.value;
		var GameE_Day      = f.GameE_Day.value;
		var GameArea       = f.GameArea.value;
		var GameRcv_SYear  = f.GameRcv_SYear.value;
		var GameRcv_SMonth = f.GameRcv_SMonth.value;
		var GameRcv_SDay   = f.GameRcv_SDay.value;
		var GameRcv_EYear  = f.GameRcv_EYear.value;
		var GameRcv_EMonth = f.GameRcv_EMonth.value;
		var GameRcv_EDay   = f.GameRcv_EDay.value;
		var EnterType      = f.EnterType.value;
		var HostCode       = f.HostCode.value;
		var ViewYN         = f.ViewYN.value;
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				seq            : seq,
				SportsGb       : SportsGb ,
				GameGb         : GameGb  ,
				GameYear       : GameYear ,
				GameTitleName  : GameTitleName ,
				Sido           : Sido ,
				SidoDtl        : SidoDtl ,
				GameS_Year     : GameS_Year ,
				GameS_Month    : GameS_Month ,
				GameS_Day      : GameS_Day ,
				GameE_Year     : GameE_Year ,
				GameE_Month    : GameE_Month ,
				GameE_Day      : GameE_Day ,
				GameArea       : GameArea	,	
				GameRcv_SYear  : GameRcv_SYear ,
				GameRcv_SMonth : GameRcv_SMonth ,
				GameRcv_SDay   : GameRcv_SDay ,
				GameRcv_EYear  : GameRcv_EYear ,
				GameRcv_EMonth : GameRcv_EMonth ,
				GameRcv_EDay   : GameRcv_EDay ,
				EnterType      : EnterType ,
				HostCode       : HostCode ,
				ViewYN         : ViewYN
			},		
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){
					if (retDATA=='TRUE') {
						alert('수정이 완료되었습니다!');		
						view_frm("F");						
					}	else {
						alert('예외가 발생하여 입력이 실패하였습니다!');								
					}
				}
			}, error: function(xhr, status, error){						
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});		
	}
}



//리스트
function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var settp  = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_GameYear      = sf.Search_GameYear.value
	var Search_GameTitleName = sf.Search_GameTitleName.value
	var Search_CheifName		 = sf.Search_CheifName.value
	var Search_Sido          = sf.Search_Sido.value
	var Search_StadiumNumber = sf.Search_StadiumNumber.value

	//다음조회를 조회보다 먼저 눌렀을 경우 막는다
	if (tp=="N" && settp=="") {
		alert ("조회 데이타가 없습니다!");

	}

	//조회를 누르면 무조건 처음부터 조회한다
	if (tp=="F" && settp=="F") {
		setkey = "";		
		nowcnt.innerText=0;
		list.innerHTML = "";
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
	var strAjaxUrl="/Manager_Wres/ajax/ChampionshipRcheif_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				tp                   : tp,
				key                  : setkey,
				Search_GameYear      : Search_GameYear , 
				Search_GameTitleName : Search_GameTitleName ,
				Search_CheifName		 : Search_CheifName,
				Search_Sido          : Search_Sido ,
				Search_StadiumNumber : Search_StadiumNumber 

			},
			success: function(retDATA) {
				if(retDATA){			
					retDATA = trim(retDATA);	
					
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
				//조회종료 효과
				//parent.fBottom.popupClose("btnview","btnnext","");
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
		});
	}	



function input_data(RCheifIDX){	
	//parent.fBottom.popupOpen("","","CONTENTS 조회중입니다!");
	var strAjaxUrl="/Manager_Wres/Ajax/ChampionshipRCheif_DataView.asp";
	
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { RCheifIDX: RCheifIDX},
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){	

					var strcut = retDATA.split("|>");			
					var f = document.frm;
					f.RCheifIDX.value         = strcut[0];
					f.GameTitleIDX.value       = strcut[1];
					f.CheifType.value       = strcut[2];
					f.CheifLevel.value  = strcut[3];
					f.CheifNameText.value           = strcut[5];
					f.StadiumNumber.value     = strcut[7];

					make_box("sel_Search_GameDay","GameDay",$("#GameTitleIDX").val(),"GameDay_change");

					f.GameDay.value = strcut[8];
					f.GameYear.value = strcut[9];

					chk_CheifIDX('CheifIdx', 'CheifIdx', $("#CheifNameText").val());
					

					//parent.fBottom.popupClose("","","");	
					//document.getElementById("setseq").value = seq;				
				}			
				
				if (retDATA == null) {
					//조회종료 효과
					//parent.fBottom.popupClose("","","");
					alert ("조회 데이타가 없습니다!");
					document.getElementById("setseq").value = "";
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				//parent.fBottom.popupClose("","","");
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				setseq = "";
			}
		});
}


function del_frm () {		
	var RCheifIDX = document.getElementById('RCheifIDX').value;	
	if (RCheifIDX=='') {
		alert ("삭제 대상을 선택하십시오!");
		return false;
	}
	
	if(confirm("심판를 삭제하시겠습니까?")){

				
		//parent.fBottom.popupOpen("btndel","btndel","삭제중입니다!");
		var strAjaxUrl = "/Manager_Wres/Ajax/ChampionshipRCheif_Del.asp";
		var retDATA="";
		 
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: { RCheifIDX: RCheifIDX },		
			success: function(retDATA) {
				if(retDATA){
					//parent.fBottom.popupClose("btndel","btndel","");
					if(retDATA=='TRUE') {
						alert('삭제가 완료되었습니다!');		
						view_frm("F");						
					}else{
					alert('예외가 발생하여 삭제가 실패하였습니다!');								
					}
				}
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btndel","btndel","");
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});	
	}
}




/*심판관리 열고닫기S*/
function input_view(){
	if(document.getElementById("input_area").offsetHeight>0){
		document.getElementById("input_area").style.display="none";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}else{
		document.getElementById("input_area").style.display="block";
		document.getElementById("input_button_type").className = "btn-top-sdr close";
	}						
}
/*심판관리 열고닫기E*/

/* 개인전 단체전 체급 등록현황S */
function view_level(gametitleidx,gametitlename,group_type){
	location.href="/Manager_Wres/View/ChampionshipLevel.asp?gametitleidx="+gametitleidx+"&gametitlename="+gametitlename+"&group_type="+group_type;
}
/* 개인전 단체전 체급 등록현황S */


//학교장확인서리스트
function confirm_data(gametitleidx){
	location.href="Confirm_List.asp?GameTitleIDX="+gametitleidx;
}
//개인전현황
function sum_data(type,gametitleidx){
	if(type=="1"){
		location.href="Sum_List1.asp?GameTitleIDX="+gametitleidx;	
	}else if(type=="2"){
	location.href="Sum_List2.asp?GameTitleIDX="+gametitleidx;	
	}
}

//구분(개인전,단체전)
function chk_GroupGameGb(obj){			


	make_box("sel_Search_GameDay","GameDay",$("#GameTitleIDX").val(),"GameDay_change");
}


//소속명 검색
function chk_CheifIDX(element,attname,CheifName){

	

	var f = document.frm;
	var strAjaxUrl = "/Manager_Wres/Select/CheifIDX_Select.asp";
	var element = element;
	var attname = attname;
	var CheifName = CheifName;
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				element  : element ,
				attname  : attname ,
				CheifName  : CheifName
			},		
			success: function(retDATA) {

					console.log(retDATA);

					if(retDATA){	

						document.getElementById(element).innerHTML = retDATA;

					}			
			}, error: function(xhr, status, error){						
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});

}

make_box("sel_Search_Year","GameYear","2017","Year_GameTitle" );
make_box("sel_Search_GameTitle","GameTitleIDX","2017","GameTitle_Year_change");
make_box("sel_Search_GameTitle2","Search_GameTitleIDX","2017","GameTitle_Year_change");


make_box("sel_Search_GameDay","GameDay","2017","GameDay_change");


make_box("sel_Year2","Search_GameYear","","Year")
make_box("sel_Location2","Search_Sido","","Area_Small")

//make_box("sel_Search_GameDay","Search_GameDay","2017","GameDay_change");




</script>

<style>
  #content {position: relative;}
  div.loaction {margin-bottom: 190px;}
  .top-navi {top: 48px; left: -40px; width: 100%; min-width: 731px; padding-left: 40px; margin-right: 40px;}
</style>
<body onload="view_frm('F')">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>심판관리</strong> &gt; 심판관리
			</div>
			<!-- S : top-navi -->
			<div class="top-navi" >
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit" style="height: 50px;">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>심판정보</strong>
						</h3>
						<!--<a href="#" id="input_button_type" class="btn-top-sdr open" title="더보기" onclick="input_view();"></a>-->
						<a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onclick="input_view();"></a>
						<!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
						<a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>-->
					</div>
					<!-- E : top-navi-tp 접혔을 때 -->
					<!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
					<form name="frm" method="post">
					<input type="hidden" name="RCheifIDX" id="RCheifIDX" value="">
					<!--종목-->
					<div class="top-navi-btm" id="input_area">
						<div class="navi-tp-table-wrap">
							<table class="navi-tp-table">
								<caption>심판 기본정보</caption>
								<colgroup>
									<col width="90px" />
									<col width="*" />
									<col width="90px" />
									<col width="*" />
									<col width="90px" />
									<col width="*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">연도</th>
										<td id="sel_Search_Year">
											<select id="GameYear" name="GameYear"><option value="">연도</option></select>
										</td>
										<th scope="row">대회명</th>
										<td id="sel_Search_GameTitle">
											
											<select id="GameTitleIDX" name="GameTitleIDX">
												<option value="">==선택==</option>
											</select>
										
										</td>
										<th scope="row">날짜</th>
										<td id="sel_Search_GameDay">
											<select id="GameDay" name="GameDay">
												<option value="">==선택==</option>
											</select>											
										</td>
									</tr>
									<tr>
										<th scope="row">심판명</th>
										<td>
											<input type="text" name="CheifNameText" id="CheifNameText" class="input-small" onkeyup="chk_CheifIDX('CheifIdx', 'CheifIdx', this.value)"/>
											<select id="CheifIdx" name="CheifIdx">
												<option value="">==선택==</option>
											</select>
										</td>
										<th scope="row">구분/경기장</th>
										<td>
											<select id="CheifType" name="CheifType">
												<option value="">==선택==</option>
												<option value="wr060001">주심</option>
												<option value="wr060002">부심</option>
												<option value="wr060003">심판장</option>
											</select>	
											/
											<select id="StadiumNumber" name="StadiumNumber">
												<option value="">==선택==</option>
												<option value="A">A매트</option>
												<option value="B">B매트</option>
												<option value="C">C매트</option>
												<option value="D">D매트</option>
												<option value="E">E매트</option>
												<option value="F">F매트</option>	
											</select>	
										</td>
										<th scope="row">심판번호</th>
										<td>
											<input type="text" name="CheifLevel" id="CheifLevel" class="input-small" />												
										</td>

									</tr>
								

								</tbody>
							</table>
						</div>
						<!-- S : btn-right-list 버튼 -->
						<div class="btn-right-list">
							<a href="#" id="btnsave" class="btn" onclick="input_frm();" accesskey="i">등록(I)</a>
							<a href="#" id="btnupdate" class="btn" onclick="update_frm();" accesskey="e">수정(E)</a>
							<a href="#" id="btndel" class="btn btn-delete" onclick="del_frm();" accesskey="r">삭제(R)</a>
							<!--<a href="#" class="btn">목록보기</a>-->
						</div>
						<!-- E : btn-right-list 버튼 -->
					</div>
					</form>
					<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
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
							<col width="50px" />
							<col width="*" />
							<col width="50px" />
							<col width="*" />
							<col width="50px" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">연도</th>
								<td id="sel_Year2"><select name="Search_GameYear" id="Search_GameYear"></select></td>

								<th scope="row"><label for="competition-name-2">대회명</label></th>
								<td>
									<input type="text" name="Search_GameTitleName" id="Search_GameTitleName" class="txt-bold"  />
								</td>

								<td id="sel_Search_GameTitle2">
											
									<select id="Search_GameTitleIDX" name="Search_GameTitleIDX">
										<option value="">==선택==</option>
									</select>
										
								</td>

								<th scope="row">심판명</th>
								<td>
									<input type="text" name="Search_CheifName" id="Search_CheifName" class="txt-bold"  />
								</td>
								<th scope="row">지역</th>
								<td>
									<span id="sel_Location2"><select name="Search_Sido" id="Search_Sido"></select></span>
								</td>
								<th scope="row">경기장</th>
								<td>
									<span>
										<select name="Search_StadiumNumber" id="Search_StadiumNumber">
											<option value="">==선택==</option>
											<option value="A">A매트</option>
											<option value="B">B매트</option>
											<option value="C">C매트</option>
											<option value="D">D매트</option>
											<option value="E">E매트</option>
											<option value="F">F매트</option>
										</select>
									</span>
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
				<a href="javascript:view_frm('N');" class="btn-more-result">
					전체 (<strong id="totcnt">0</strong>)건 / <strong class="current" >현재(<span id="nowcnt">0</span>)</strong>
					<!--//<i class="fa fa-plus" aria-hidden="true"></i>-->					
				</a>
			</div>
			<div class="table-list-wrap">
				<!-- S : table-list -->
				<table class="table-list">
					<caption>심판관리 리스트</caption>
					<colgroup>

						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>

							<th scope="col">대회명</th>
							<th scope="col">심판번호</th>
							<th scope="col">경기장</th>
							<th scope="col">심판명</th>
							<th scope="col">구분</th>
							<th scope="col">지역</th>
							<th scope="col">배정일자</th>
						</tr>
					</thead>
					<input type="hidden" id="settp" value="" />        
					<input type="hidden" id="setkey" value="" />        
					<input type="hidden" id="setseq" value="" />        
					<tbody id="list">																
					</tbody>
				</table>
				<!-- E : table-list -->
				<a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
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