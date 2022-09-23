<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script language="javascript">
$(document).ready(function(){
	init();
});

//입력폼 체크 S
function input_frm(){
	var f = document.frm;
	if(f.SportsGb.value==""){
		alert("종목을 선택해 주세요");
		f.SportsGb.focus();
		return false;
	}
	if(f.PlayerGb.value==""){
		alert("회원구분을 선택해 주세요");
		f.PlayerGb.focus();
		return false;
	}
	if(f.NowSchIDX.value==""){
		alert("소속찾기를 사용하여 소속을 선택해 주세요");		
		return false;
	}
	if(f.UserName.value==""){
		alert("이름을 입력해 주세요");
		f.UserName.focus();
		return false;
	}
	if(f.Sex_Type[0].checked==false && f.Sex_Type[1].checked==false){
		alert("성별을 선택해 주세요");
		return false;
	}	
	if(f.Sex_Type[0].checked){
		f.Sex.value="Man";
	}else{
		f.Sex.value="WoMan";		
	}
	
	if(f.UserID.value==""){
		alert("아이디를 입력해 주세요.");
		f.UserID.focus();
		return false
	}

	if(f.Chk_ID.value=="N"){
		alert("아이디 중복확인을 해주세요");
		return false;
	}
	if(f.UserID.value!=f.Hidden_UserID.value){
		alert("아이디가 변경되었습니다. 중복확인을 해주세요.");
		f.Chk_ID.value="N";
		return false;
	}
	if(f.UserPass.value==""){
		alert("비밀번호를 입력해 주세요.");
		f.UserPass.focus();
		return false;
	}
	if(f.UserPass2.value==""){
		alert("비밀번호 확인을 입력해 주세요.");
		f.UserPass2.focus();
		return false;
	}	
	if(f.UserPass.value!=f.UserPass2.value){
		alert("비밀번호가 일치하지 않습니다.");
		f.UserPass.value="";
		f.UserPass2.value="";
		f.UserPass.focus();
		return false;
	}
	if(f.UserPhone.value==""){
		alert("연락처를 입력해 주세요.");
		f.UserPhone.focus();
		return false;
	}
	if(f.Birth_Year.value==""){
		alert("생일년도를 선택해 주세요.");
		f.Birth_Year.focus();
		return false;
	}
	if(f.Birth_Month.value==""){
		alert("생일월을 선택해 주세요.");
		f.Birth_Month.focus();
		return false;
	}
	if(f.Birth_Day.value==""){
		alert("생일을 선택해 주세요.");
		f.Birth_Day.focus();
		return false;
	}

	/*운동관련정보Check S*/
	/*
	if(f.PlayerStartYear.value==""){
		alert("운동시작년도를 선택해 주세요.");
		f.PlayerStartYear.focus();
		return false;
	}

	if(f.Tall.value==""){
		alert("신장을 입력해 주세요.");
		f.Tall.focus();
		return false;
	}

	if(f.Weight.value==""){
		alert("체중을 입력해 주세요.");
		f.Weight.focus();
		return false;
	}
	if(f.BloodType.value==""){
		alert("혈액형을 입력해 주세요.");
		f.BloodType.focus();
		return false;
	}
	if(f.Level.value==""){
		alert("체급을 입력해 주세요.");
		f.Level.focus();
		return false;
	}
	*/
	/*운동관련정보Check E*/

	if(confirm("선수등록을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager/ajax/PlayerInfo_Insert.asp";
		var SportsGb        = f.SportsGb.value;
		var PlayerGb        = f.PlayerGb.value;
		var NowSchIDX       = f.NowSchIDX.value;
		var UserName        = f.UserName.value;
		var Sex             = f.Sex.value;
		var UserID          = f.UserID.value;
		var UserPass        = f.UserPass.value;
		var UserPass2       = f.UserPass2.value;
		var UserPhone       = f.UserPhone.value;
		var Birth_Year      = f.Birth_Year.value;
		var Birth_Month     = f.Birth_Month.value;
		var Birth_Day       = f.Birth_Day.value;
		var PlayerStartYear = f.PlayerStartYear.value;
		var Tall            = f.Tall.value;
		var Weight          = f.Weight.value;
		var BloodType       = f.BloodType.value;
		var Level           = f.Level.value;

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				SportsGb        : SportsGb ,
				PlayerGb        : PlayerGb ,
				NowSchIDX       : NowSchIDX ,
				UserName        : UserName ,
				Sex             : Sex ,
				UserID          : UserID ,
				UserPass        : UserPass ,
				UserPass2       : UserPass2 ,
				UserPhone       : UserPhone ,
				Birth_Year      : Birth_Year ,
				Birth_Month     : Birth_Month ,
				Birth_Day       : Birth_Day ,
				PlayerStartYear : PlayerStartYear ,
				Tall            : Tall ,
				Weight          : Weight ,
				BloodType       : BloodType ,
				Level           : Level 
			
			},		
			success: function(retDATA) {
				if(retDATA){
					//parent.fBottom.popupClose("btnsave","btnsave","");
					if (retDATA=='TRUE') {
						alert('입력이 완료되었습니다!');		
						view_frm("F");						
					}
					else {
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

	if(f.SportsGb.value==""){
		alert("종목을 선택해 주세요");
		f.SportsGb.focus();
		return false;
	}
	if(f.PlayerGb.value==""){
		alert("회원구분을 선택해 주세요");
		f.PlayerGb.focus();
		return false;
	}
	if(f.NowSchIDX.value==""){
		alert("소속찾기를 사용하여 소속을 선택해 주세요");		
		return false;
	}
	if(f.UserName.value==""){
		alert("이름을 입력해 주세요");
		f.UserName.focus();
		return false;
	}
	if(f.Sex_Type[0].checked==false && f.Sex_Type[1].checked==false){
		alert("성별을 선택해 주세요");
		return false;
	}	
	if(f.Sex_Type[0].checked){
		f.Sex.value="Man";
	}else{
		f.Sex.value="WoMan";		
	}
	
	if(f.UserID.value==""){
		alert("아이디를 입력해 주세요.");
		f.UserID.focus();
		return false
	}
	if(f.UserPass.value==""){
		alert("비밀번호를 입력해 주세요.");
		f.UserPass.focus();
		return false;
	}
	if(f.UserPass2.value==""){
		alert("비밀번호 확인을 입력해 주세요.");
		f.UserPass2.focus();
		return false;
	}	
	if(f.UserPass.value!=f.UserPass2.value){
		alert("비밀번호가 일치하지 않습니다.");
		f.UserPass.value="";
		f.UserPass2.value="";
		f.UserPass.focus();
		return false;
	}
	if(f.UserPhone.value==""){
		alert("연락처를 입력해 주세요.");
		f.UserPhone.focus();
		return false;
	}
	if(f.Birth_Year.value==""){
		alert("생일년도를 선택해 주세요.");
		f.Birth_Year.focus();
		return false;
	}
	if(f.Birth_Month.value==""){
		alert("생일월을 선택해 주세요.");
		f.Birth_Month.focus();
		return false;
	}
	if(f.Birth_Day.value==""){
		alert("생일을 선택해 주세요.");
		f.Birth_Day.focus();
		return false;
	}

	/*운동관련정보Check S*/
	/*
	if(f.PlayerStartYear.value==""){
		alert("운동시작년도를 선택해 주세요.");
		f.PlayerStartYear.focus();
		return false;
	}

	if(f.Tall.value==""){
		alert("신장을 입력해 주세요.");
		f.Tall.focus();
		return false;
	}

	if(f.Weight.value==""){
		alert("체중을 입력해 주세요.");
		f.Weight.focus();
		return false;
	}
	if(f.BloodType.value==""){
		alert("혈액형을 입력해 주세요.");
		f.BloodType.focus();
		return false;
	}
	if(f.Level.value==""){
		alert("체급을 입력해 주세요.");
		f.Level.focus();
		return false;
	}
	*/
	/*운동관련정보Check E*/

	if(confirm("선수정보 수정을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager/ajax/PlayerInfo_Update.asp";
		var SportsGb        = f.SportsGb.value;
		var PlayerGb        = f.PlayerGb.value;
		var NowSchIDX       = f.NowSchIDX.value;
		var UserName        = f.UserName.value;
		var Sex             = f.Sex.value;
		var UserID          = f.UserID.value;
		var UserPass        = f.UserPass.value;
		var UserPass2       = f.UserPass2.value;
		var UserPhone       = f.UserPhone.value;
		var Birth_Year      = f.Birth_Year.value;
		var Birth_Month     = f.Birth_Month.value;
		var Birth_Day       = f.Birth_Day.value;
		var PlayerStartYear = f.PlayerStartYear.value;
		var Tall            = f.Tall.value;
		var Weight          = f.Weight.value;
		var BloodType       = f.BloodType.value;
		var Level           = f.Level.value;

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				seq             : seq ,
				SportsGb        : SportsGb ,
				PlayerGb        : PlayerGb ,
				NowSchIDX       : NowSchIDX ,
				UserName        : UserName ,
				Sex             : Sex ,
				UserID          : UserID ,
				UserPass        : UserPass ,
				UserPass2       : UserPass2 ,
				UserPhone       : UserPhone ,
				Birth_Year      : Birth_Year ,
				Birth_Month     : Birth_Month ,
				Birth_Day       : Birth_Day ,
				PlayerStartYear : PlayerStartYear ,
				Tall            : Tall ,
				Weight          : Weight ,
				BloodType       : BloodType ,
				Level           : Level 
			
			},		
			success: function(retDATA) {
				if(retDATA){
					//parent.fBottom.popupClose("btnsave","btnsave","");
					if (retDATA=='TRUE') {
						alert('수정이 완료되었습니다!');		
						view_frm("F");						
					}
					else {
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




function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list = document.getElementById("list");
	var settp = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_SportsGb   = sf.Search_SportsGb.value
	var Search_Area       = sf.Search_Area.value
	var Search_Sex        = sf.Search_Sex.value
	var Search_TeamGb     = sf.Search_TeamGb.value
	var Search_SchoolName = sf.Search_SchoolName.value
	var Search_UserName   = sf.Search_UserName.value

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
	var strAjaxUrl="/Manager/ajax/PlayerInfo_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',




			data: {
				tp: tp,
				key: setkey,
				Search_SportsGb   : Search_SportsGb , 
				Search_Area       : Search_Area ,
				Search_Sex        : Search_Sex ,
				Search_TeamGb     : Search_TeamGb ,
				Search_SchoolName : Search_SchoolName ,
				Search_UserName   : Search_UserName
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
				alert(xhr)
				alert(status)
				alert(error)
				//parent.fBottom.popupClose("btnview","btnnext","");
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!1");
			}
		});
	}	




function input_data(seq){	

	//parent.fBottom.popupOpen("","","CONTENTS 조회중입니다!");
	var strAjaxUrl="/Manager/ajax/PlayerInfo_DataView.asp";
	
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { seq: seq},
			success: function(retDATA) {
				if(retDATA){	
					//alert(retDATA)
					var strcut = retDATA.split("|>");			
					var f = document.frm;
					f.PlayerIDX.value       = strcut[0];
					f.SportsGb.value        = strcut[1];
					f.PlayerGb.value        = strcut[2];
					f.NowSchName.value      = strcut[3];
					f.NowSchIDX.value       = strcut[4];
					f.TeamGb.value          = strcut[5];
					f.UserName.value        = strcut[6];
					f.Sex.value             = strcut[7];
					if (strcut[7]=="Man"){
						f.Sex_Type[0].checked=true;
					}else{
						f.Sex_Type[1].checked=true;					
					}
					f.UserID.value           = strcut[8];
					f.UserPass.value         = strcut[9];
					f.UserPass2.value        = strcut[9];
					f.UserPhone.value        = strcut[10];

					f.Birth_Year.value       = strcut[11];
					f.Birth_Month.value      = strcut[12];
					f.Birth_Day.value        = strcut[13];

					f.PlayerStartYear.value        = strcut[14];
					f.Tall.value        = strcut[15];
					f.Weight.value        = strcut[16];
					f.BloodType.value        = strcut[17];
					make_box_level("sel_Level","Level",strcut[18],"",strcut[5],strcut[7])
					/*
					Sex_Type


					f.UserName.value        = strcut[4];
					f.Sex_Type.value        = strcut[5];
					f.Sex.value             = strcut[6];
					f.UserID.value          = strcut[7];
					f.UserPass.value        = strcut[8];
					f.UserPass2.value       = strcut[9];
					f.UserPhone.value       = strcut[10];
					f.Birth_Year.value      = strcut[11];
					f.Birth_Month.value     = strcut[12];
					f.Birth_Day.value       = strcut[13];
					f.PlayerStartYear.value = strcut[14];
					f.Tall.value            = strcut[15];
					f.Weight.value          = strcut[16];
					f.BloodType.value       = strcut[17];
					f.Level.value					  = strcut[18]; 
					*/

					//parent.fBottom.popupClose("","","");	
					document.getElementById("setseq").value = seq;				
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
	var seq = document.getElementById('setseq').value;	
	if (seq=='') {
		alert ("삭제 대상을 선택하십시오!");
		return false;
	}
	
	if(confirm("회원정보를 삭제하시겠습니까?")){

				
		//parent.fBottom.popupOpen("btndel","btndel","삭제중입니다!");
		var strAjaxUrl = "/Manager/Ajax/PlayerInfo_Del.asp";
		var retDATA="";
		 
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: { seq: seq },		
			success: function(retDATA) {
				if(retDATA){
					//parent.fBottom.popupClose("btndel","btndel","");
					if (retDATA=='TRUE') {
						alert('삭제가 완료되었습니다!');		
						view_frm("F");						
					}
					else {
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




/*개인프로필열고 닫기S*/
function input_view(){
	if(document.getElementById("input_area").offsetHeight>0){
		document.getElementById("input_area").style.display="none";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}else{
		document.getElementById("input_area").style.display="block";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}						
}
/*개인프로필열고 닫기E*/

/*소속찾기 팝업창S*/
function pop_NowSch(){
//	window.open('/Manager/Popup/NowSchool_Search.asp?Level_Type=1','_blank','width=600 height=600');
	window.open('/Manager/Popup/School_Search.asp?Level_Type=1','school_search','width=600 height=350 scrollbars=yes');
}
/*소속찾기 팝업창E*/

/*아이디 중복확인 팝업창S*/
function pop_UserID(){
	window.open('/Manager/Popup/UserID_Search.asp','id_search','width=600 height=260 scrollbars=no');
}
/*아이디 중복확인 팝업창E*/

/*성별체크 클릭시 hidden_insert S*/
function chk_sex(obj){
	document.getElementById("Sex").value = obj;
	/*소속및 성별 체크*/
	if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
		chk_level();
	}
}
/*성별체크 클릭시 hidden_insert E*/
function chk_level(){
	if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
		make_box_level("sel_Level","Level","","Level_Check",document.getElementById("TeamGb").value,document.getElementById("Sex").value)
	}
}
</script>
<script>
	make_box("sel_SportsGb","SportsGb","","SportsGb")
	make_box("sel_PlayerGb","PlayerGb","","PlayerGb")
	make_box("radio_SexType","Sex_Type","","Sex_Radio")
	make_box("sel_Year","Birth_Year","","Year")
	make_box("sel_Month","Birth_Month","","Month")
	make_box("sel_Day","Birth_Day","","Day")
	make_box("sel_StartYear","PlayerStartYear","","PlayYear")
	make_box("sel_Tall","Tall","","Tall")
	make_box("sel_Weight","Weight","","Weight")
	make_box("sel_Blood","BloodType","","Blood")
	make_box("sel_SportsGb2","Search_SportsGb","","SportsGb")
	make_box("sel_Area","Search_Area","","Area")					
	make_box("sel_TeamGb","Search_TeamGb","","TeamGb")			
</script>
<body onload="view_frm('F');">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>회원관리</strong> &gt; 개인프로필
			</div>
			<!-- S : top-navi -->
			<form name="frm" method="post">
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<i class="fa fa-th-large" aria-hidden="true"></i>
							<strong>개인프로필</strong>
						</h3>
						<a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onclick="input_view();"></a>
					</div>
					
					<!-- E : top-navi-tp 접혔을 때 -->
					<!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
					<div class="top-navi-btm" id="input_area">
						<div class="navi-tp-table-wrap">
							<table class="navi-tp-table">
								<caption>개인프로필 기본정보</caption>
								<colgroup>
									<col width="64px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />
								</colgroup>
								<tbody>									
									<tr>
										<th scope="row"><label for="player-code">선수코드</th>
										<td><input type="text" name="PlayerIDX" id="PlayerIDX" readonly /></td>
										<!-- 종목구분S -->
										<th scope="row"><label for="sports-kind">종목</label></th>
										<td id="sel_SportsGb"></td>
										<!-- 종목구분E -->
										<!-- 회원구분S -->
										<th scope="row"><label for="player_type">회원구분</th>
										<td id="sel_PlayerGb"></td>
										<!-- 회원구분E -->
									</tr>
									<tr>
										<!-- 선수코드S -->
										<th scope="row"><label for="nowshcidx">소속</label></th>
										<td>
											<input type="text" id="NowSchName" name="NowSchName" class="input-small" readonly /><!--<input type="button" value="소속찾기" onclick="pop_NowSch();">-->
											<a href="javascript:pop_NowSch();" class="btn-sch-pop">소속찾기</a>
											<input type="hidden" id="NowSchIDX" name="NowSchIDX">
											<input type="hidden" id="TeamGb" name="TeamGb">
										</td>
										<!-- 선수코드E -->
										<!-- 선수명S -->
										<th scope="row"><label for="player-name">이름</label></th>
										<td><input type="text" name="UserName" id="UserName" /></td>
										<!-- 선수명E -->
										<!-- 성별S -->
										<th scope="row">성별</th>
										<td>
											<div id="radio_SexType"></div>
											<input type="hidden" name="Sex" id="Sex" value="">
										</td>
										<!-- 성별E -->
									</tr>
									<tr>
										<th scope="row"><label for="user-name">아이디</label></th>
										<td>
											<input type="text" id="UserID" name="UserID" class="input-small" />
											<!--아이디중복확인 여부-->
											<input type="hidden" name="Chk_ID" id="Chk_ID" value="N">
											<input type="hidden" name="Hidden_UserID" id="Hidden_UserID" value="N">
											<!--<input type="button" value="중복확인"  onclick="pop_UserID();">-->
											<a href="javascript:pop_UserID();" class="btn-sch-pop">중복확인</a>
										</td>
										<th scope="row"><label for="user-pw">비밀번호</th>
										<td><input type="password" id="UserPass" name="UserPass" /></td>
										<th scope="row"><label for="user-pw-2">비밀번호 확인</th>
										<td><input type="password" id="UserPass2" name="UserPass2" /></td>
									</tr>
									<tr>
										<th scope="row"><label for="phone-num">휴대폰</label></th>
										<td>
											<input type="text" id="UserPhone" name="UserPhone" />
										</td>
										<th scope="row">생년월일</th>
										<td>
											<div class="birth-list">
												<span class="birth-year" id="sel_Year"></span>
												<span class="birth-month" id="sel_Month"></span>
												<span class="birth-day" id="sel_Day"></span>
											</div>
										</td>
										<th scope="row"></th>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
						<h4 class="sub-tit">운동정보</h4>
						<table class="navi-btm-table">
							<caption>운동정보 입력</caption>
							<colgroup>
								<col width="146px" />
								<col width="110px" />
								<col width="127px" />
								<col width="136px" />
								<col width="136px" />
							</colgroup>
							<tbody>
								<tr>
									<td>
										시작년도
										<span id="sel_StartYear"></span>										
									</td>
									<td>
										<label for="player-stature">신장</label>
										<span id="sel_Tall"></span> 
									</td>
									<td>
										<label for="player-weight">체중</label>
										<span id="sel_Weight"></span> 
									</td>
									<td>
										<label for="player-blood-type">혈액형</label>
										<span id="sel_Blood"></span> 
									</td>
									<td>
										<label for="weight-division" >체급
										<span id="sel_Level">
										<!--체급선택은 소속 성별이 있는 경우에만 생성된다-->
										<select onclick="alert('소속 성별 입력 후 선택 가능합니다.');">
											<option value="">==선택==</option>
										</select>
										<!--체급선택은 소속 성별이 있는 경우에만 생성된다-->										
										</span> 
									</td>
								</tr>
							</tbody>
						</table>
						<!-- S : btn-right-list 버튼 -->
						<div class="btn-right-list">
							<a href="#" id="btnsave" class="btn" onclick="input_frm();" accesskey="i">등록(I)</a>
							<a href="#" id="btnupdate" class="btn" onclick="update_frm();" accesskey="e">수정(E)</a>
							<a href="#" id="btndel" class="btn btn-delete" onclick="del_frm();" accesskey="r">삭제(R)</a>
							<!--<a href="#" class="btn">목록보기</a>-->
						</div>
						<!-- E : btn-right-list 버튼 -->
					</div>
					<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
				</div>
			</div>
			</form>
			<!-- E : top-navi -->
			<!-- S : sch 검색조건 선택 및 입력 -->
			<form name="search_frm" method="post">
			<div class="sch">
					<table class="sch-table">
						<caption>검색조건 선택 및 입력</caption>
						<colgroup>
							<col width="78px" />
							<col width="*" />
							<col width="50px" />
							<col width="*" />
							<col width="37px" />
							<col width="*" />
							<col width="37px" />
							<col width="*" />
						</colgroup>						
						<tbody>
							<tr>
								<th scope="row">종목</th>
								<td id="sel_SportsGb2"><select name="Search_SportsGb"></select></td>
								<th scope="row">지역</th>
								<td id="sel_Area"><select name="Search_Area"></select></td>
								<th scope="row">성별</th>
								<td id="sel_Sex2">
									<select name="Search_Sex">
										<option value="">==전체=</option>
										<option value="Man">남자</option>
										<option value="WoMan">여자</option>
									</select>
								</td>
								<th>소속</th>
								<td id="sel_TeamGb"><select name="Search_TeamGb"></select></td>
							</tr>
							<tr>
								<th scope="row">소속명</th>
								<td>
									<input type="text" name="Search_SchoolName" id="Search_SchoolName" />
								</td>
								<th scope="row">선수명</th>
								<td>
									<input type="text" name="Search_UserName" id="Search_UserName" />
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
					<caption>개인프로필 리스트</caption>
					<colgroup>
						<col width="44px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="125px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row">번호</th>
							<th scope="row">경기종목</th>
							<th scope="row">소속구분</th>
							<th scope="row">지역</th>
							<th scope="row">소속명</th>
							<th scope="row">성별</th>
							<th scope="row">이름</th>
							<th scope="row">선수코드</th>
							<th scope="row">프로필</th>
						</tr>
					</thead>				
					<input type="hidden" id="settp" value="" />        
					<input type="hidden" id="setkey" value="" />        
					<input type="hidden" id="setseq" value="" />        
					<!--리스트가 보여지는 부분-->
					<tbody id="list">
						<!--
						<tr>
							<th scope="row">1</th>
							<td>유도</td>
							<td>고등부</td>
							<td>서울</td>
							<td>중앙여자고등학교</td>
							<td>여</td>
							<td>최보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
							</td>
						</tr>
						-->
					</tbody>
					<!--리스트가 보여지는 부분-->
				</table>
				<!-- E : table-list -->
				<a href="javascript:view_frm('N');" class="btn-more-list" ><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
<script src="../js/js.js"></script>
</body>