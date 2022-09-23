<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<%
	'대회정보
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	'Response.Write RGameLevelIDX	

	'대회정보 셀렉트	
	InfoSQL = "SELECT "
	InfoSQL = InfoSQL&" Sportsdiary.dbo.FN_GameTitleName(GameTitleIDX) AS GameTitleName"
	InfoSQL = InfoSQL&" ,Sportsdiary.dbo.FN_PubName(TeamGb) AS TeamGbName"
	InfoSQL = InfoSQL&" ,Sportsdiary.dbo.FN_LevelNm('"&Request.Cookies("SportsGb")&"',TeamGb,Level) AS LevelName"
	InfoSQL = InfoSQL&" ,SportsDiary.dbo.FN_LevelNm('"&Request.Cookies("SportsGb")&"',TeamGb,Level) AS LevelNm "
	InfoSQL = InfoSQL&" ,Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName"
	InfoSQL = InfoSQL&" ,GameTitleIDX"
	InfoSQL = InfoSQL&" ,TeamGb"
	InfoSQL = InfoSQL&" ,Level"
	InfoSQL = InfoSQL&" ,GroupGameGb"
	InfoSQL = InfoSQL&" ,Sex"
	InfoSQL = InfoSQL&" FROM Sportsdiary.dbo.tblRGameLevel "
	InfoSQL = InfoSQL&" WHERE RGameLevelIDX='"&RGameLevelIDX&"'"
	Set IRs = Dbcon.Execute(InfoSQL)

	If Not(IRs.Eof Or IRs.Bof) Then 
		GameTitleName   = IRs("GameTitleName")
		GameTitleIDX    = IRS("GameTitleIDX")
		GroupGameGbName = IRs("GroupGameGbName")
		GroupGameGb     = IRS("GroupGameGb")
		TeamGbName      = IRS("TeamGbName")
		TeamGb          = IRS("TeamGb")
		Sex             = IRS("Sex")
		If Sex = "Man" Then 
			SexName = "남자"
		Else
			SexName = "여자"
		End If 
		LevelName       = IRS("LevelName")
		Level           = IRS("Level")
	Else
		Response.Write "<script>alert('등록된 정보가 없습니다.');</script>"
		Response.End
	End If 

	IRs.close
	Set IRs = Nothing

%>


<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script type="text/javascript">
//입력폼 체크 S
function input_frm(){		
	var f = document.frm;
	if(f.GroupGameGb.value == "<%=SportsCode%>040001"){
	//개인전
		if(f.Team.value==""){
			alert("소속을 선택해 주세요");
			return false;
		}
		if(f.PlayerIDX.value == ""){
			alert("출전선수를 선택해 주세요.");
			f.PlayerIDX.focus();
			return false;
		}
	}else{
	//단체전
		if(f.Team.value==""){
			alert("소속을 선택해 주세요");
			f.TeamNm.focus();
			return false;
		}
	}


	if(confirm("등록을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager/Ajax/ChampionshipRegist_Insert.asp";
		var RGameLevelIDX  = f.RGameLevelIDX.value;
		var GameTitleIDX   = f.GameTitleIDX.value;
		var GroupGameGb    = f.GroupGameGb.value;
		var TeamGb         = f.TeamGb.value;
		var Sex            = f.Sex.value;
		var Level          = f.Level.value;
		var Team           = f.Team.value
		if(f.GroupGameGb.value == "<%=SportsCode%>040001"){
			var PlayerIDX      = f.PlayerIDX.value;
		}else{
			var PlayerIDX      = "";		
		}
		
		/*
		alert(RGameLevelIDX)
		alert(GameTitleIDX)
		alert(GroupGameGb)
		alert(TeamGb)
		alert(Sex)
		alert(Level)
		alert(Team)
		alert(PlayerIDX)
		*/
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				RGameLevelIDX : RGameLevelIDX ,
				GameTitleIDX  : GameTitleIDX ,
				GroupGameGb   : GroupGameGb  ,
				TeamGb        : TeamGb ,
				Sex           : Sex ,
				Level         : Level ,
				Team          : Team ,
				PlayerIDX     : PlayerIDX 
				
			},		
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){
					//parent.fBottom.popupClose("btnsave","btnsave","");
					if (retDATA=='TRUE') {
						alert('출선 선수(소속) 등록이 완료되었습니다!');		
						view_frm("F");			
						f.TeamNm.value = "";						
						f.TeamNm.focus();
					}	else if(retDATA=='SAME'){
						alert('이미 등록된 선수(소속) 입니다.!');								
						f.TeamNm.focus();
					} else if (retDATA=="NONE"){
						alert('선수(소속) 정보를 찾을수 없습니다.!');								
						f.TeamNm.focus();
					} else {
						alert('예외가 발생하여 입력이 실패하였습니다!');								
						f.TeamNm.focus();
					}
				}
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}	
			}
		});		
	}
}

//수정폼 체크 S
function update_frm(){		
	var f = document.frm;
	var seq = document.getElementById('setseq').value;
	if(f.GroupGameGb.value == "<%=SportsCode%>040001"){
	//개인전
		if(f.Team.value==""){
			alert("소속을 선택해 주세요");
			return false;
		}
		if(f.PlayerIDX.value == ""){
			alert("출전선수를 선택해 주세요.");
			f.PlayerIDX.focus();
			return false;
		}
	}else{
	//단체전
		if(f.Team.value==""){
			alert("소속을 선택해 주세요");
			f.TeamNm.focus();
			return false;
		}
	}


	if(confirm("수정을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager/Ajax/ChampionshipRegist_Update.asp";
		var RGameLevelIDX  = f.RGameLevelIDX.value;
		var GameTitleIDX   = f.GameTitleIDX.value;
		var GroupGameGb    = f.GroupGameGb.value;
		var TeamGb         = f.TeamGb.value;
		var Sex            = f.Sex.value;
		var Level          = f.Level.value;
		var Team          = f.Team.value
		if(GroupGameGb == "<%=SportsCode%>040001"){
			var PlayerIDX      = f.PlayerIDX.value;
		}else{
			var PlayerIDX      = "";		
		}

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				seq           : seq ,
				RGameLevelIDX : RGameLevelIDX ,
				GameTitleIDX  : GameTitleIDX ,
				GroupGameGb   : GroupGameGb  ,
				TeamGb        : TeamGb ,
				Sex           : Sex ,
				Level         : Level ,
				Team          : Team ,
				PlayerIDX     : PlayerIDX 

			},		
			success: function(retDATA) {
				//document.write(retDATA)
				if(retDATA){
					if (retDATA=='TRUE') {
						alert('출선 선수(소속) 수정이 완료되었습니다!');		
						view_frm("F");					
						f.SchoolName.focus();
					} else {
						alert('예외가 발생하여 수정이 실패하였습니다!');								
						f.SchoolName.focus();
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
}
//수정폼 체크 E




function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var settp  = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_RGameLevelIDX   = sf.Search_RGameLevelIDX.value;
	var Search_GameTitleName   = sf.Search_GameTitleName.value;
	var Search_GroupGameGbName = sf.Search_GroupGameGbName.value;
	var Search_TeamGbName      = sf.Search_TeamGbName.value;
	var Search_TeamGb          = sf.Search_TeamGb.value;
	var Search_SexName         = sf.Search_SexName.value;
	var Search_LevelName       = sf.Search_LevelName.value;
	var Search_GroupGameGb     = sf.Search_GroupGameGb.value;
	var Search_SchoolName      = sf.Search_SchoolName.value;
	var Search_PlayerName      = sf.Search_PlayerName.value;


	//다음조회를 조회보다 먼저 눌렀을 경우 막는다
	if (tp=="N" && settp=="") {
		alert ("조회 데이타가 없습니다!");
		totcnt.innerText = 0;
		nowcnt.innerText = 0;
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
	var strAjaxUrl="/Manager/ajax/ChampionshipRegist_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',

			data: {
				tp: tp,
				key: setkey,
				Search_RGameLevelIDX   : Search_RGameLevelIDX,
				Search_GameTitleName   : Search_GameTitleName,
				Search_GroupGameGbName : Search_GroupGameGbName,
				Search_TeamGbName      : Search_TeamGbName,
				Search_TeamGb          : Search_TeamGb ,
				Search_SexName         : Search_SexName,
				Search_LevelName       : Search_LevelName,
				Search_GroupGameGb : Search_GroupGameGb,
				Search_SchoolName  : Search_SchoolName ,
				Search_PlayerName  : Search_PlayerName ,
				GameTitleIDX       : "<%=GameTitleIDX%>"
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


//정보입력 S
function input_data(seq,GroupGameGb){	
	var strAjaxUrl="/Manager/Ajax/ChampionshipRegist_DataView.asp";
	
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				seq         : seq ,
				GroupGameGb : GroupGameGb
			},
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){						
					var strcut = retDATA.split("|>");			
					var f = document.frm;

					if(GroupGameGb == "<%=SportsCode%>040001"){
					//개인전일경우						
					//학교명체크
						chk_TeamCode('sel_TeamName','Team',strcut[1],strcut[3])
					//선수명체크
					}else{
					//단체전일경우
					//학교명체크
						chk_TeamCode('sel_TeamName','Team',strcut[1],'')
					}
					document.getElementById("setseq").value = seq;				
				}			
				
				if (retDATA == null) {
					alert ("조회 데이타가 없습니다!");
					document.getElementById("setseq").value = "";
				}
			}, error: function(xhr, status, error){
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
				setseq = "";
			}
		});
}
//정보입력 E 



//정보삭제
function del_frm() {		
	var seq         = document.getElementById('setseq').value;	
	//개인전단체전여부
	var GroupGameGb   = document.getElementById('GroupGameGb').value;	
	var RGameLevelIDX = document.getElementById('Search_RGameLevelIDX').value;	
	
	if (seq=='') {
		alert ("삭제 대상을 선택하십시오!");
		return false;
	}
	
	if(confirm("출선선수(소속)정보를 삭제하시겠습니까?\n소속정보 삭제시 등록된 선수 정보도 함께 삭제 됩니다.")){				

		var strAjaxUrl = "/Manager/Ajax/ChampionshipRegist_Del.asp";
		var retDATA="";
		 
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: {
				seq: seq ,
				GroupGameGb : GroupGameGb ,
				RGameLevelIDX : RGameLevelIDX
			},		
			success: function(retDATA) {
				if(retDATA){
					//document.write(retDATA);
					if (retDATA=='TRUE') {
						alert('삭제가 완료되었습니다!');		
						view_frm("F");						
					}
					else {
					alert('예외가 발생하여 삭제가 실패하였습니다!');								
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
}
//정보삭제 

</script>
<script type="text/javascript">
//소속명 검색
function chk_TeamName(element,attname,code){
	var f = document.frm;
	var strAjaxUrl = "/Manager/Select/TeamListSearch_Select.asp";
	var element = element;
	var attname = attname;
	var code    = code;
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				element  : element ,
				attname  : attname ,
				code     : code
			},		
			success: function(retDATA) {
//				document.write(retDATA);
					if(retDATA){	
						document.getElementById(element).innerHTML = retDATA	
						//개인전일경우 소속팀 명단 로그
						if(f.GroupGameGb.value == "<%=SportsCode%>040001"){
							if(f.Team.value!=""){
								
								chk_Player("sel_Player","PlayerIDX",f.Team.value,"","");
							}
						}
					}			
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});

}

//소속명 검색
function chk_TeamCode(element,attname,team,playercode){
	var f = document.frm;
	var strAjaxUrl = "/Manager/Select/TeamListSearchCode_Select.asp";
	var element = element;
	var attname = attname;
	var team    = team;
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				element  : element ,
				attname  : attname ,
				team  : team
			},		
			success: function(retDATA) {
					if(retDATA){	

						document.getElementById(element).innerHTML = retDATA	
						//개인전일경우 소속팀 명단 로그
						if(f.GroupGameGb.value == "<%=SportsCode%>040001"){
							if(f.Team.value!=""){
								chk_Player("sel_Player","PlayerIDX",team,playercode,"");
							}
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




function chk_Player(element,attname,team,playercode,action_type){
	var f = document.frm;
	var strAjaxUrl = "/Manager/Select/PlayerListSearch_Select.asp";
	//개인전일 경우만 작동함.
	if(f.GroupGameGb.value == "<%=SportsCode%>040001"){		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				Team     : team ,
				element    : element ,
				attname    : attname ,
				playercode : playercode
			},		
			success: function(retDATA) {
					if(retDATA){	
						document.getElementById(element).innerHTML = retDATA							
					}			
			}, error: function(xhr, status, error){						
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}	
			}
		});
	}
}



/*대회정보관리 열고닫기S*/
function input_view(){
	if(document.getElementById("input_area").offsetHeight>0){
		document.getElementById("input_area").style.display="none";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}else{
		document.getElementById("input_area").style.display="block";
		document.getElementById("input_button_type").className = "btn-top-sdr close";
	}						
}
/*대회정보관리 열고닫기E*/


//출전선수등록
function view_player(obj,obj2,obj3){
	location.href="ChampionshipRegist_School.asp?RGameLevelIDX="+obj+"&Team="+obj2+"&Teamdtl="+obj3;
}
</script>
<script type="text/javascript">
//메달변경
function change_medal(MedalType,MasterIDX,Grouptype){
	//메달종류
	//MasterIDX
	//단체전여부
	var strAjaxUrl = "/Manager/Ajax/Medal_Change.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				MedalType     : MedalType ,
				MasterIDX    : MasterIDX ,
				Grouptype    : Grouptype 
			},		
			success: function(retDATA) {
					if(retDATA){	
						if(retDATA=="Del"){
							alert("메달삭제 완료")
						}else if(retDATA=="Ins"){
							alert("메달수여 완료")					
						}
					}			
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}		
			}
		});


}

function down_data(obj){
//	alert(obj)
	window.location.assign('http://sportsdiary.co.kr/request/<%=Request.Cookies("SportsGb")%>/upload/'+obj);
}


function input_ballnum(rgamelevelidx,playeridx,ballnum){
	//alert(rgamelevelidx)
	//alert(playeridx)
	//alert(ballnum)
	//1487,8961,1
	var strAjaxUrl = "/Manager/Ajax/BallNum_Update.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				RGameLevelIDX  : rgamelevelidx ,
				PlayerIDX      : playeridx ,
				BallNum        : ballnum
			},		
			success: function(retDATA) {
					if(retDATA){	
						if(retDATA=="all"){
							//경기순서버튼활성화
							document.getElementById("order_btn").style.display="block";
						}else{							
							document.getElementById("order_btn").style.display="none";
						}
					}			
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}	
			}
		});	
}

//공추첨번호로 순서 초기화
function Order_Update(rgamelevelidx){
	//alert(rgamelevelidx)
	var strAjaxUrl = "/Manager/Ajax/Order_Update.asp";	
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				RGameLevelIDX  : rgamelevelidx 
			},		
			success: function(retDATA) {
					if(retDATA=="true"){
						alert("반영되었습니다")
					}			
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btnsave","btnsave","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}	
			}
		});	

	
}
</script>
<body onLoad="view_frm('F');">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회정보관리</strong> &gt; <%=GameTitleName%> &gt; <%=GroupGameGbName%> &gt; <%If GroupGameGb = SportsCode&"040001" Then %>출전선수관리<%Else%>출전소속관리<%End If%>
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong><%=GameTitleName%></strong>
						</h3>
						<a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onClick="input_view();"></a>
						<!--<a href="#" class="btn-top-sdr open" title="더보기"></a>
						<a href="#" class="btn-top-sdr close" title="닫기"></a>-->
					</div>
					<!-- E : top-navi-tp 접혔을 때 -->
					<!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
					<form name="frm" method="post">
					<input type="hidden" name="RGameLevelIDX" id="RGameLevelIDX" value="<%=RGameLevelIDX%>">
					<div class="top-navi-btm" id="input_area">
						<div class="navi-tp-table-wrap">
							<table class="navi-tp-table">
								<caption>대회정보관리 기본정보</caption>
								<colgroup>
									<col width="64px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />									
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><label for="competition-name">대회명</label></th>
										<td><%=GameTitleName%></td>
										<input type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX%>">
										<th scope="row">구분</th>
										<td><%=GroupGameGbName%></td>
										<input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=GroupGameGb%>">
										<th scope="row">소속</th>
										<td><%=TeamGbName%></td>
										<input type="hidden" name="TeamGb" id="TeamGb" value="<%=TeamGb%>">
									</tr>
									<tr>
										<th scope="row">성별</th>
										<td>
											<%=SexName%>
										</td>
										<input type="hidden" name="Sex" id="Sex" value="<%=Sex%>">
										<th scope="row">체급</th>
										<td><%=LevelName%></td>
										<input type="hidden" name="Level" id="Level" value="<%=Level%>">
										<th scope="row"></th>
										<td></td>
									</tr>
									<tr>
										<th scope="row">소속명</th>
										<td>
											<span><input type="text" name="TeamNm" id="TeamNm" class="input-small" placeholder="" onKeyUp="chk_TeamName('sel_TeamName','Team',this.value)" /></span>
											<span id="sel_TeamName">
												<select name="Team" id="Team">
													<option value="">==선택==</option>													
												</select>
											</span>
										</td>
										<%
											If GroupGameGb = SportsCode&"040001" Then 
										%>
										<th scope="row">선수명</th>
										<td>
											<span id="sel_Player">
												<select name="PlayerIDX" id="PlayerIDX">
													<option value="">==선택==</option>													
												</select>
											</span>
										</td>
										<th scope="row"></th>
										<td>
											<span></span>
										</td>
										<%
											Else 
										%>
										<th scope="row"></th>
										<td>
											<span></span>
										</td>
										<th scope="row"></th>
										<td>
											<span></span>
										</td>
										<%
											End If 
										%>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- S : btn-right-list 버튼 -->
						<div class="btn-right-list">
							<a href="#" class="btn" onClick="input_frm();" accesskey="i" >등록(I)</a>
							<a href="#" class="btn" onClick="update_frm();" accesskey="e">수정(E)</a>
							<a href="#" class="btn btn-delete" onClick="del_frm();" accesskey="r">삭제(R)</a>
							<!--<a href="#" class="btn">목록보기</a>-->
						</div>
						<!-- E : btn-right-list 버튼 -->
					</div>
					</form>
					<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
				</div>
			</div>
			<!-- E : top-navi -->
			<!-- S : tab 대회정보관리 -->
			<!--
			<div class="tab">
				<a href="#" class="on">개인전</a>
				<a href="#">단체전</a>
			</div>-->
			<!-- E : tab 대회정보관리 -->
			<h4 class="stit">출전선수관리</h4>
			<!-- S : sch 검색조건 선택 및 입력 -->
			<form name="search_frm" method="post">
			<input type="hidden" name="Search_RGameLevelIDX" id="Search_RGameLevelIDX" value="<%=RGameLevelIDX%>">
			<input type="hidden" name="Search_GameTitleName" value="<%=GameTitleName%>">
			<input type="hidden" name="Search_GroupGameGbName" value="<%=GroupGameGbName%>">
			<input type="hidden" name="Search_TeamGb" value="<%=TeamGb%>">
			<input type="hidden" name="Search_TeamGbName" value="<%=TeamGbName%>">
			<input type="hidden" name="Search_SexName" value="<%=SexName%>">
			<input type="hidden" name="Search_LevelName" value="<%=LevelName%>">
			<input type="hidden" name="Search_GroupGameGb" id="Search_GroupGameGb" value="<%=GroupGameGb%>">
			<input type="hidden" id="settp" value="" />        
			<input type="hidden" id="setkey" value="" />        
			<input type="hidden" id="setseq" value="" />     
			<div class="sch">
				<table class="sch-table">
					<caption>검색조건 선택 및 입력</caption>
					<colgroup>
						<col width="40px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						<col width="40px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>							
							<th scope="row">소속명</th>
							<td>
								<input type="text" name="Search_SchoolName" id="Search_SchoolName">
							</td>
							<th scope="row">이름</th>
							<td>
								<input type="text" name="Search_PlayerName" id="Search_PlayerName">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-right-list">
				<a href="javascript:view_frm('F');" class="btn" accesskey="s">검색(S)</a>
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
					<caption>대회정보관리 리스트</caption>
					<colgroup>
						<col width="44px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />						
						<%
							'레슬링인경우 해당 체급의 공번호 추첨
							If SportsCode = "wr" Then 
						%>
						<col width="50px" />
						<%
							End If 
						%>
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">대회명</th>
							<th scope="col">구분</th>
							<th scope="col">소속</th>
							<th scope="col">성별</th>

							<th scope="col">소속명</th>
							<%
								If GroupGameGb = SportsCode&"040001" Then 
							%>
							<th scope="col">체급</th>
							<th scope="col">선수명</th>
							<th scope="col">학교장확인서</th>		
							<%
								Else 							
							%>
							<th scope="col">참가자</th>
							<th scope="col">선수등록</th>
							<%
								End If 
							%>
							<th scope="col">메달</th>
							<%
							'레슬링인경우 해당 체급의 공번호 추첨
								If SportsCode = "wr" Then 
							%>
							<th scope="col">추첨번호</th>
							<%
								End If 
							%>
						</tr>
					</thead>
					<tbody id="list">									
					</tbody>
				</table>
				<!-- E : table-list -->
				<a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
			<div class="btn-right-list" id="order_btn" style="display:none;">
				<a href="javascript:Order_Update('<%=RGameLevelIDX%>');" class="btn" accesskey="s">경기순서등록</a>
			</div>
		</div>
		
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
<form action="hidden_frm" id="hidden_frm" method="post">
<input type="text" name="aaa">
</form>
</body>
<!-- sticky -->
<script src="../js/js.js"></script>

