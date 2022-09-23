<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 

	GameTitleIDX  = fInject(Request("gametitleidx"))  '대회IDX
	GameTitleName = fInject(Request("gametitlename")) '대회명
%>

<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script language="javascript">
$(document).ready(function(){
	init();
});

function some_init(seq,gbname,gender,level,player){		
	
	if(confirm("["+gbname+"] ["+gender+"] ["+level+"] ["+player+"]\n\n"+"해당 경기에 입력된 모든 승점과 기술을 초기화 하시겠습니까?")){
		
		var inurl = document.getElementById(seq);					
		var strAjaxUrl = "/Manager/Ajax/ChampionshipiNit_Some_del.asp";
				
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				seq              : seq				
			},		
			success: function(retDATA) {				
				if(retDATA){					
					if (retDATA=='TRUE') {
						alert('해당 경기에 기술/승점 초기화가 완료되었습니다!\n\n'+'['+gbname+'] ['+gender+'] ['+level+'] ['+player+']');								
					}	else {
						alert('예외가 발생하여 초기화가 실패하였습니다!');								
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

function all_init(seq,gbname,gender,level,player){		
	
	if(confirm("["+gbname+"] ["+gender+"] ["+level+"]\n\n"+"해당 체급 경기에 입력된 모든 데이타를 초기화 하시겠습니까?")){
		
		var inurl = document.getElementById(seq);					
		var strAjaxUrl = "/Manager/Ajax/ChampionshipiNit_All_del.asp";
				
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				seq              : seq				
			},		
			success: function(retDATA) {				
				if(retDATA){					
					if (retDATA=='TRUE') {
						alert('해당 체급에 데이타 초기화가 완료되었습니다!\n\n'+'['+gbname+'] ['+gender+'] ['+level+']');
						view_frm("F");	
					}	else {
						alert('예외가 발생하여 초기화가 실패하였습니다!');								
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

function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var settp  = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_GameYear     = sf.Search_GameYear.value;
	var Search_GameTitleIDX = sf.Search_GameTitleIDX.value;
	var Search_GroupGameGb  = sf.Search_GroupGameGb.value;	
	var Search_TeamGb       = sf.Search_TeamGb.value;	
	var Search_Sex          = sf.Search_Sex.value;
	//var Search_Level        = document.getElementById("Search_Level").value;
	var Search_Stadium      = sf.Search_Stadium.value;	
	var player              = document.getElementById("player").value;	
	
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
	
	
	//tp : F-조회, N-다음조회
	//setkey : 다음조회를 위하여 키를 던진다 전 조회 마지막 데이타를 키로 만든다
	var strAjaxUrl="/Manager/ajax/ChampionshipGroupiNit_View.asp";

	//location.href="/Manager/ajax/ChampionshipGroupiNit_View.asp";

	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',

			data: {
				tp: tp,
				key: setkey,
				Search_GameYear     : Search_GameYear,
				Search_GameTitleIDX : Search_GameTitleIDX ,
				Search_GroupGameGb  : Search_GroupGameGb ,				
				Search_TeamGb       : Search_TeamGb ,				
				Search_Sex          : Search_Sex, 
				//Search_Level        : Search_Level,
				Search_Stadium      : Search_Stadium,
				player              : player

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

	
//대회명셀렉트박스
make_box("sel_Search_Year","Search_GameYear","","Year_GameTitle" )

function chk_GameTitle(obj){
	make_box("sel_Search_GameTitle","Search_GameTitleIDX",obj,"GameTitle_Year_change")	
}

function reset_groupgame(str_RGamelevelIDX, str_GroupGameNum, str_LTeamName, str_RTeamName){
	
	if(!confirm("[" + str_RGamelevelIDX + "]" + str_LTeamName + " VS " + str_RTeamName + " 경기를 리셋합니다. 동의하시면 확인버튼을 눌러주세요.")){
		return;
	}

	var strAjaxUrl="/Manager/ajax/ChampionshipGroupiNit_Delete.asp";

	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',

			data: {
				RgameLevelIDX: str_RGamelevelIDX,
				GroupGameNum: str_GroupGameNum
			},

			success: function(retDATA) {	


				if(retDATA){					
					if (retDATA=='TRUE') {
						alert('해당 경기에 기술/승점 초기화가 완료되었습니다!');								
					}	else {
						alert('예외가 발생하여 초기화가 실패하였습니다!');								
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

//구분(개인전,단체전)
/*
function chk_GroupGameGb(obj){			
	make_box("sel_Search_GroupGameGb","Search_GroupGameGb","","GroupGameGb2")
}
*/

//소속
function chk_GameGb(obj){					
	make_box("sel_Search_TeamGb","Search_TeamGb","","TeamGb3")
}

//성별
function chk_SexGb(obj){		
	make_box("sel_Search_Sex","Search_Sex","","Sex_Select_Change2")
}

//체급셀렉트박스
function chk_LevelGb(){
	if(document.getElementById("Search_TeamGb").value!="" && document.getElementById("Search_Sex").value !=""){
		make_box_level("sel_Search_Level","Search_Level","","Level_Check",document.getElementById("Search_TeamGb").value,document.getElementById("Search_Sex").value)
	}
}


</script>

<body onLoad="view_frm('F');">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>경기관리</strong> &gt; 단체전초기화
				<span id="Depth_GameTitle">
				<%
					If gametitlename <> "" Then  
				%>
				&gt; <%=gametitlename%>
				<%
					End If 
				%>
				</span>
				
			</div>
			
			<!-- E : tab 대회정보관리 -->
			<!-- S : sch 검색조건 선택 및 입력 -->
			<form name="search_frm" method="post">
			<div class="sch">
					<table class="sch-table">
						<caption>검색조건 선택 및 입력</caption>
						<colgroup>					
							<col width="40px" />		
							<col width="*" />
							<col width="50px" />
							<col width="*" />
							<col width="40px" />
							<col width="*" />
							<col width="40px" />
							<col width="*" />
							<col width="40px" />		
							<col width="*" />							
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">연도</th>
								<td id="sel_Search_Year">
									<select id="Search_GameYear" name="Search_GameYear"><option value="">연도</option></select>
								</td>
								
								<th scope="row"><label for="competition-name-2">대회명</label></th>								
								<td id="sel_Search_GameTitle">
									<select id="Search_GameTitleIDX" name="Search_GameTitleIDX">
										<option value="">==선택==</option>
									</select>
								</td>
								
								<th scope="row">구분</th>
								<td id="sel_Search_GroupGameGb">
									<select id="Search_GroupGameGb" name="Search_GroupGameGb">
										<option value="">==선택==</option>
									</select>
								</td>								
								
								<th scope="row">소속</th>
								<td id="sel_Search_TeamGb">
									<select id="Search_TeamGb" name="Search_TeamGb">
										<option value="" selected>==선택==</option>																				
									</select>
								</td>	
								
								<th scope="row">성별</th>
								<td id="sel_Search_Sex">
									<select id="Search_Sex" name="Search_Sex">
										<option value="" selected>==선택==</option>
									</select>
								</td>
								</tr>							
								<!--
								<th scope="row">체급</th>
								<td id="sel_Search_Level">
									<select id="Search_Level" name="Search_Level">
										<option value="">==선택==</option>
									</select>
								</td>	
								-->
								<th scope="row" style="width:80px;">경기장번호</th>
								<td id="sel_Search_Stadium">
									<select id="Search_Stadium" name="Search_Level">
										<option value="">==선택==</option>
										<option value="1">1경기장</option>
										<option value="2">2경기장</option>
										<option value="3">3경기장</option>
										<option value="4">4경기장</option>
										<option value="5">5경기장</option>
										<option value="6">6경기장</option>
										<option value="7">7경기장</option>
										<option value="8">8경기장</option>
										<option value="9">9경기장</option>
										<option value="10">10경기장</option>
										<option value="11">11경기장</option>
										<option value="12">12경기장</option>
										<option value="13">13경기장</option>
										<option value="14">14경기장</option>
										<option value="15">15경기장</option>
										<option value="16">16경기장</option>
										<option value="17">17경기장</option>
										<option value="18">18경기장</option>
										<option value="19">19경기장</option>
										<option value="20">20경기장</option>										
									</select>
								</td>	
								
								<th scope="row" style="width:50px;">소속명</th>
								<td><input style="width:100%;" type="text" name="player" id="player" class="input-small"></td>
							
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
					<caption>대회정보관리 리스트</caption>
					<colgroup>						
						<col width="*" />
						<col width="*" />
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
							<th scope="col">구분</th>							
							<th scope="col">종별</th>
							<th scope="col">대진</th>
							<th scope="col">라운드</th>
							<th scope="col">경기번호</th>
							<th scope="col">경기장번호</th>							
							<th scope="col">리셋버튼</th>							
						</tr>
					</thead>
					<input type="hidden" id="settp" value="" />        
					<input type="hidden" id="setkey" value="" />        
					<input type="hidden" id="setseq" value="" />  
					<tbody id="list">
						<!--
						<tr>
							<th scope="row">1</th>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td><a href="#" class="btn-list">출전선수관리 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
						</tr>
						-->
					</tbody>
				</table>
				<!-- E : table-list -->
				<a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
	<!-- sticky -->
	<script src="../js/js.js"></script>
</div>
<!-- E : container -->
</body>