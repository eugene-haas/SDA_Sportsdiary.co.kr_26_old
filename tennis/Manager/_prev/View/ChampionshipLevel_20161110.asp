<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDX  = fInject(Request("gametitleidx"))  '대회IDX
	GameTitleName = fInject(Request("gametitlename")) '대회명
	Group_Type    = fInject(Request("group_type")) 'one , group
	If Group_Type = "one" Then 
		Group_Type = "sd040001"
	ElseIf Group_Type = "group" Then 
		Group_Type = "sd040002"
	End If 
%>
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<script language="javascript">
$(document).ready(function(){
	init();
});

//입력폼 체크 S
function input_frm(){
	var f = document.frm;
	//대회명
	if(f.GameTitle.value==""){
		alert("대회를 선택해 주세요.");
		f.GameTitle.focus();
		return false;
	}
	//종목선택
	if(f.SportsGb.value==""){
		alert("종목을 선택해 주세요");
	}
	//경기구분
	if(f.GroupGameGb.value==""){
		alert("경기구분을 선택해 주세요.");
		f.GroupGameGb.focus();
		return false;
	}
	//소속구분
	if(f.TeamGb.value==""){
		alert("소속을 선택해 주세요.");
		f.TeamGb.focus();
		return false;
	}
	//성별
	if(f.Sex_Type[0].checked==false && f.Sex_Type[1].checked==false){
		alert("성별을 선택해 주세요");
		return false;
	}	
	if(f.Sex_Type[0].checked){
		f.Sex.value="Man";
	}else{
		f.Sex.value="WoMan";		
	}
	//체급선택
	if(f.GroupGameGb.value == "sd040001" && f.Level.value==""){
		alert("체급을 선택해 주세요.");
		f.Level.focus();
		return false;
	}
	//대전방식선택
	if(f.VersusGb.value==""){
		alert("대전방식을 선택해 주세요.");
		f.VersusGb.focus();
		return false;
	}
	if(f.GameYear.value==""){
		alert("대회년도를 선택해 주세요");
		f.GameYear.focus();
		return false;
	}
	if(f.GameMonth.value==""){
		alert("대회월을 선택해 주세요");
		f.GameMonth.focus();
		return false;
	}
	if(f.GameDay.value==""){
		alert("대회일자를 선택해 주세요");
		f.GameDay.focus();
		return false;
	}
	if(f.GameTime.value==""){
		alert("경기시작시간을 입력해 주세요");
		f.GameTime.focus();
		return false;
	}
	if(confirm("체급등록을 진행하시겠습니까?")){
		var strAjaxUrl = "/Manager/Ajax/ChampionshipLevel_Insert.asp";
		var GameTitle     = f.GameTitle.value;
		var SportsGb      = f.SportsGb.value;
		var GroupGameGb   = f.GroupGameGb.value;
		var TeamGb        = f.TeamGb.value;
		var Sex           = f.Sex.value;
		var Level         = f.Level.value;
		var VersusGb      = f.VersusGb.value;
		var GameYear      = f.GameYear.value;
		var GameMonth     = f.GameMonth.value;
		var GameDay       = f.GameDay.value;
		var GameTime      = f.GameTime.value;


		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',			
			data: { 
				GameTitle    : GameTitle ,
				SportsGb     : SportsGb ,
				GroupGameGb  : GroupGameGb ,
				TeamGb       : TeamGb ,
				Sex          : Sex ,
				Level        : Level ,
				VersusGb     : VersusGb ,
				GameYear     : GameYear ,
				GameMonth    : GameMonth ,
				GameDay      : GameDay ,
				GameTime     : GameTime 
			},		
			success: function(retDATA) {
				if(retDATA){
					//parent.fBottom.popupClose("btnsave","btnsave","");
					if (retDATA=='TRUE') {
						alert('체급등록이 완료되었습니다!');		
						view_frm("F");						
					}	else if(retDATA=='SAME'){
						alert('이미 등록된 체급경기 입니다.!');								
					}else{
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
//입력폼 체크 E






function view_frm(tp){

	//조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
	//이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

	var list   = document.getElementById("list");
	var settp  = document.getElementById("settp").value;			
	var setkey = document.getElementById("setkey").value;			
	var totcnt = document.getElementById("totcnt");			
	var nowcnt = document.getElementById("nowcnt");			
	

	var sf = document.search_frm;
	var Search_GameTitleIDX = sf.Search_GameTitleIDX.value;
	var Search_GroupGameGb  = sf.Search_GroupGameGb.value;
	var Search_TeamGb       = sf.Search_TeamGb.value;
	var Search_Sex          = sf.Search_Sex.value;

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
	var strAjaxUrl="/Manager/ajax/ChampionshipLevel_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',

			data: {
				tp: tp,
				key: setkey,
				Search_GameTitleIDX : Search_GameTitleIDX ,
				Search_GroupGameGb  : Search_GroupGameGb ,
				Search_TeamGb       : Search_TeamGb ,
				Search_Sex          : Search_Sex 

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
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
		});
	}	

</script>
<script>
/*체급입력창 닫기S*/
function input_view(){
	if(document.getElementById("input_area").offsetHeight>0){
		document.getElementById("input_area").style.display="none";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}else{
		document.getElementById("input_area").style.display="block";
		document.getElementById("input_button_type").className = "btn-top-sdr open";
	}						
}
/*체급입력창 닫기E*/
</script>
<script>
//대회명셀렉트박스
make_box("sel_GameTitle","GameTitle",'<%=GameTitleIDX%>',"GameTitle")
//종목셀렉트박스
make_box("sel_SportsGb","SportsGb","judo","SportsGb")
//개인전단체전셀렉트박스
make_box("sel_GroupGameGb","GroupGameGb",'<%=Group_Type%>',"GroupGameGb")
//소속구분셀렉트박스
make_box("sel_TeamGb","TeamGb","","TeamGb2")			
//성별라디오버튼
make_box("radio_SexType","Sex_Type","","Sex_Radio")
//체급셀렉트박스
function chk_level(){
	if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
		make_box_level("sel_Level","Level","","Level_Check",document.getElementById("TeamGb").value,document.getElementById("Sex").value)
	}
}
/*성별체크 클릭시 hidden_insert S*/
function chk_sex(obj){
	document.getElementById("Sex").value = obj;
	/*소속및 성별 체크*/
	if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
		chk_level();
	}
}
/*성별체크 클릭시 hidden_insert E*/
//대전방식셀렉트박스
make_box("sel_VersusGb","VersusGb","","VersusGb");

//경기일자
make_box("sel_Year","GameYear","","Year")
make_box("sel_Month","GameMonth","","Month")
make_box("sel_Day","GameDay","","Day")

//조회부분 셀렉스박스생성
make_box("sel_Search_Year","Search_GameYear","","Year_GameTitle" )
make_box("sel_Search_GameTitle","Search_GameTitleIDX","<%=GameTitleIDX%>","GameTitle")
make_box("sel_Search_GroupGameGb","Search_GroupGameGb","","GroupGameGb")
make_box("sel_Search_TeamGb","Search_TeamGb","","TeamGb")	
make_box("sel_Search_Sex","Search_Sex","","Sex_Select")



function chk_GameTitle(obj){
	make_box("sel_Search_GameTitle","Search_GameTitleIDX",obj,"GameTitle_Year")	
}
</script>
<body onload="view_frm('F');">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회정보관리</strong>
				<span id="Depth_GameTitle">
				<%
					If gametitlename <> "" Then  
				%>
				&gt; <%=gametitlename%>
				<%
					End If 
				%>
				</span>
				<span id="Depth_Group">
				<%
					If group_type <> "" Then 
						
				%>
				&gt; <%If group_type = "sd040001" Then Response.Write "개인전"  Else Response.Write "단체전" End If %>
				<%
					End If
				%>
				</span>
			</div>
			<!-- S : top-navi -->
			<form name="frm" method="post">
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong id="Depth_GameTitle2"><%=gametitlename%></strong>
						</h3>
						<a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onclick="input_view();"></a>
					</div>
					<!-- E : top-navi-tp 접혔을 때 -->
					<!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
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
										<th>종목</th>
										<td id="sel_SportsGb"></td>										
										<th scope="row"><label for="competition-name">대회명</label></th>
										<td id="sel_GameTitle" colspan="3"></td>
										<th scope="row"></th>
										<td></td>
									</tr>
									<tr>
										<th scope="row">구분</th>
										<td id="sel_GroupGameGb">
											<select>
												<option value="">개인전</option>
												<option value="">단체전</option>
											</select>
										</td>
										<th scope="row">소속</th>
										<td id="sel_TeamGb">
											<select>
												<option value="">초등부</option>
												<option value="">중등부</option>
												<option value="">고등부</option>
											</select>
										</td>
										<th scope="row">성별</th>
										<td id="radio_SexType">
											<input type="radio" id="gender-man" name="gender" /> <label for="gender-man" class="man">남</label>
											<input type="radio" id="gender-woman" name="gender" /> <label for="gender-woman">여</label>
										</td>
										<input type="hidden" name="Sex" id="Sex" value="">										
									</tr>
									<tr>
										<th scope="row">체급</th>
										<td id="sel_Level">
											<select>
												<option value="">체급</option>
											</select>
										</td>										
										<th scope="row">대전방식</th>
										<td id="sel_VersusGb">
												<select>
													<option value="op1">토너먼트</option>
													<option value="op2">리그</option>
												</select>
										</td>
										<th scope="row">경기일자</th>
										<td>
											<span id="sel_Year"></span>
											<span id="sel_Month"></span>
											<span id="sel_Day"></span>
											<span><input type="text" name="GameTime" id="GameTime" class="input-small" placeholder="경기시간" /></span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- S : btn-right-list 버튼 -->
						<div class="btn-right-list">
							<a href="#" id="btnsave" class="btn" onclick="input_frm();">등록</a>
							<a href="#" id="btnupdate" class="btn" onclick="update_frm();">수정</a>
							<a href="#" id="btndel" class="btn btn-delete" onclick="del_frm();">삭제</a>
							<a href="#" class="btn">목록보기</a>
						</div>
						<!-- E : btn-right-list 버튼 -->
					</div>
					<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
				</div>
			</div>
			</form>
			<!-- E : top-navi -->
			<!-- S : tab 대회정보관리 -->
			<div class="tab">
				<a href="#" class="on">개인전</a>
				<a href="#">단체전</a>
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
								<td id="sel_Search_GameTitle"><select id="Search_GameTitleIDX" name="Search_GameYear"><option value="<%=GameTitleIDX%>">대회명</option></select></td>
								<th scope="row">구분</th>
								<td id="sel_Search_GroupGameGb">
									<select id="Search_GroupGameGb" name="Search_GroupGameGb"><option value="">선택</option></select>
								</td>
								<th scope="row">소속</th>
								<td id="sel_Search_TeamGb">
									<select id="Search_TeamGb" name="Search_TeamGb"><option value="">선택</option></select>
								</td>								
								<th scope="row">성별</th>
								<td id="sel_Search_Sex"><select id="Search_Sex" name="Search_Sex"><option value="" selected>전체</option></select></td>
							</tr>
						</tbody>
					</table>
			</div>
			<div class="btn-right-list">
				<a href="javascript:view_frm('F');" class="btn" id="btnview">검색</a>
			</div>
			</form>
			<!-- E : sch 검색조건 선택 및 입력 -->
			<!-- S : 리스트형 20개씩 노출 -->
			<div class="sch-result">
				<a href="#" class="btn-more-result">
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
						<col width="125px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">대회명</th>
							<th scope="col">구분</th>
							<th scope="col">소속</th>
							<th scope="col">성별</th>
							<th scope="col">체급</th>
							<th scope="col">대전방식</th>
							<th scope="col">선수관리</th>
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
				<a href="#" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
</body>