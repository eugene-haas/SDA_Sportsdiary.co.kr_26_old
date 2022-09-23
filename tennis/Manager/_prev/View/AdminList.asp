<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<style>
  #content {position: relative;}
  div.loaction {margin-bottom: 190px;}
  .top-navi {top: 48px; left: -40px; width: 100%; min-width: 731px; padding-left: 40px; margin-right: 40px;}
</style>
<script type="text/javascript">
//관리자등록
function input_frm(){
	var f = document.frm;
	if(f.SportsGb.value==""){
		alert("종목을 선택해 주세요.");
		f.SportsGb.focus();
		return false;
	}
	if(f.UserID.value==""){
		alert("사용하실 아이디를 입력해 주세요.");
		f.UserID.focus();
		return false;
	}
	//아이디중복확인
	if(f.ChkID.value=="N"){
		alert("아이디 중복확인을 해주세요.");
		return false;
	}

	if(f.UserID.value!=f.Hidden_UserID.value){
		alert("아이디 중복확인을 해주세요.");
		return false;
	}
	
	if(f.UserPass.value==""){
		alert("사용하실 비밀번호를 입력해 주세요.");
		f.UserPass.focus();
		return false;
	}
	if(f.UserPass_Re.value==""){
		alert("사용하실 비밀번호 확인을 입력해 주세요.");
		f.UserPass_Re.focus();
		return false;
	}
	if(f.UserPass.value!=f.UserPass_Re.value){
		alert("비밀번호가 일치하지 않습니다.");
		f.UserPass.value="";
		f.UserPass_Re.value="";
		f.UserPass.focus();
		return false;
	}
	if(f.UserName.value==""){
		alert("사용하실 관리자명을 입력해 주세요.");
		f.UserName.focus();
		return false;
	}
	if(f.UserGubun.value==""){
		alert("관리자 구분을 선택해 주세요.");
		f.UserGubun.focus();
		return false;
	}
	if(f.HandPhone.value==""){
		alert("관리자 연락처를 입력해 주세요.");
		f.HandPhone.focus();
		return false;
	}
	if(f.Company.value==""){
		alert("관리자 협회명을 입력해 주세요.");
		f.Company.focus();
		return false;
	}
	if(f.DelYN.value==""){
		alert("관리자 사용여부를 입력해 주세요.");
		return false;
	}

	if(f.UserID.value!=f.Hidden_UserID.value){
		alert("아이디 중복확인 후 아이디가 변경되었습니다. 중복확인 해 주세요.");
		f.ChkID.value="N";
		f.Hidden_UserID.value="";
		return false;
	}
	var strAjaxUrl="/Manager/ajax/AdminID_Insert.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsGb      : f.SportsGb.value,
				ChkID         : f.ChkID.value ,
				UserID        : f.UserID.value ,
				Hidden_UserID : f.Hidden_UserID.value ,
				UserPass      : f.UserPass.value , 
				UserPass_Re   : f.UserPass_Re.value ,
				UserName      : f.UserName.value ,
				UserGubun     : f.UserGubun.value ,
				HostCode      : f.HostCode.value ,
				HandPhone     : f.HandPhone.value ,
				Company       : f.Company.value,
				DelYN         : f.DelYN.value
			},
			success: function(retDATA) {
				if(retDATA=="true"){			
					alert("등록되었습니다.");						
					f.ChkID.value = "Y";
					f.Hidden_UserID.value = f.UserID.value;
				}else if(retDATA=="same"){
					alert("이미사용중인 아이디입니다.");											
					f.UserID.value="";
					f.ChkID.value="N";
					f.Hidden_UserID.value="";
				}else if(retDATA=="false"){
					alert("아이디 입력 후 중복확인을 눌러주세요.");
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				//parent.fBottom.popupClose("btnview","btnnext","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});

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
	var Search_Type = sf.Search_Type.value
	var Search_Text = sf.Search_Text.value

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
	var strAjaxUrl="/Manager/ajax/AdminList_View.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				tp          : tp,
				key         : setkey,
				Search_Type : Search_Type , 
				Search_Text : Search_Text 
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
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});
	}	


function input_data(seq){	
	//parent.fBottom.popupOpen("","","CONTENTS 조회중입니다!");
	var strAjaxUrl="/Manager/Ajax/AdminList_DataView.asp";
	
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { seq: seq},
			success: function(retDATA) {
				//document.write(retDATA);
				if(retDATA){	
					
					var strcut = retDATA.split("|>");			
					var f = document.frm;
					f.SportsGb.value    = strcut[0];
					f.UserID.value      = strcut[1];
					f.UserPass.value    = strcut[2];
					f.UserPass_Re.value = strcut[2];
					f.UserName.value    = strcut[3];
					f.UserGubun.value   = strcut[4];
					f.HostCode.value    = strcut[5];
					f.HandPhone.value   = strcut[6];
					f.Company.value     = strcut[7];
					f.DelYN.value       = strcut[8];					

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




//수정폼 체크 S
function update_frm(){		
	var f = document.frm;
	var seq = document.getElementById('setseq').value;
	
	if (seq==''){
		alert ("수정 대상을 선택하십시오!");
		return false;
	}
	if(f.UserPass.value==""){
			alert("사용하실 비밀번호를 입력해 주세요.");
			f.UserPass.focus();
			return false;
		}
		if(f.UserPass_Re.value==""){
			alert("사용하실 비밀번호 확인을 입력해 주세요.");
			f.UserPass_Re.focus();
			return false;
		}
		if(f.UserPass.value!=f.UserPass_Re.value){
			alert("비밀번호가 일치하지 않습니다.");
			f.UserPass.value="";
			f.UserPass_Re.value="";
			f.UserPass.focus();
			return false;
		}
		if(f.UserName.value==""){
			alert("사용하실 관리자명을 입력해 주세요.");
			f.UserName.focus();
			return false;
		}
		if(f.UserGubun.value==""){
			alert("관리자 구분을 선택해 주세요.");
			f.UserGubun.focus();
			return false;
		}
		if(f.HandPhone.value==""){
			alert("관리자 연락처를 입력해 주세요.");
			f.HandPhone.focus();
			return false;
		}
		if(f.Company.value==""){
			alert("관리자 협회명을 입력해 주세요.");
			f.Company.focus();
			return false;
		}
		if(f.DelYN.value==""){
			alert("관리자 사용여부를 입력해 주세요.");
			return false;
		}

	var strAjaxUrl="/Manager/ajax/AdminList_Update.asp";
	var HandPhone = f.HandPhone.value;
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				seq           : seq,
				SportsGb      : f.SportsGb.value,
				UserPass      : f.UserPass.value , 
				UserName      : f.UserName.value ,
				UserGubun     : f.UserGubun.value ,
				HostCode      : f.HostCode.value ,
				HandPhone     : HandPhone ,
				Company       : f.Company.value,
				DelYN         : f.DelYN.value
			},
			success: function(retDATA) {
				document.write (retDATA)
				if(retDATA=="true"){			
					alert("수정되었습니다.");					
					view_frm("F");
				}else{
					alert ("수정중 에러발생 - 시스템관리자에게 문의하십시오!");				
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});
}







//아이디중복확인
function chk_id(){
	var f = document.frm;
	if(f.UserID.value==""){
		alert("아이디 입력 후 중복확인을 해주세요.");
		f.UserID.focus();
		return false;
	}
	var UserID = f.UserID.value;
	var strAjaxUrl="/Manager/ajax/Check_AdminID.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				UserID    : UserID
			},
			success: function(retDATA) {
				if(retDATA=="true"){			
					alert("등록가능한 아이디입니다.");						
					f.ChkID.value = "Y";
					f.Hidden_UserID.value = f.UserID.value;
				}else if(retDATA=="same"){
					alert("이미사용중인 아이디입니다.");											
					f.UserID.value="";
					f.ChkID.value="N";
					f.Hidden_UserID.value="";
				}else if(retDATA=="false"){
					alert("아이디 입력 후 중복확인을 눌러주세요.");
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				//parent.fBottom.popupClose("btnview","btnnext","");
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			}
		});

}
</script>
<body onLoad="view_frm('F')">
<!--<body>-->
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>관리자관리</strong> &gt; 관리자리스트
			</div>
			<!-- S : top-navi -->
			<div class="top-navi" >
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit" style="height: 50px;">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>관리자리스트</strong>
						</h3>
						<!--<a href="#" id="input_button_type" class="btn-top-sdr open" title="더보기" onclick="input_view();"></a>-->
						<a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onClick="input_view();"></a>
						<!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
						<a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>-->
					</div>
					<!--입력폼 S-->
					<form name="frm" id="frm" method="post">
					<input type="hidden" name="ChkID" id="ChkID" value="N">
					<input type="hidden" name="Hidden_UserID" id="Hidden_UserID">
					<!--종목-->
					<div class="top-navi-btm" id="input_area">
						<div class="navi-tp-table-wrap">
							<table class="navi-tp-table">
								<tr>
									<td>종목</td>
									<td>
										<select name="SportsGb" id="SportsGb">
											<option value="">=선택=</option>
											<%
												SQL = "SELECT PubName , PubCode  FROM Sportsdiary.dbo.tblPubCode WHERE DelYN='N' AND PPubCode='sd000'"

												If Request.Cookies("HostCode") <> "" Then 
													SQL = SQL&" AND SportsGb = '"&Request.Cookies("SportsGb")&"'"
												End If 

												Set Rs = Dbcon.Execute(SQL)

												If Not(Rs.Eof Or Rs.Bof) Then 
													Do Until Rs.Eof 
											%>
											<option value="<%=Rs("PubCode")%>"><%=Rs("PubName")%></option>
											<%
														Rs.MoveNext
													Loop 
												End If 

												Rs.Close
												Set Rs = Nothing 

											%>
										</select>
									</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td>관리자아이디</td>
									<td><input type="text" name="UserID" id="UserID" class="input-small" /><a href="#" class="btn" onClick="chk_id()">중복확인</a></td>
									<td>관리자 비밀번호</td>
									<td><input type="password" name="UserPass" id="UserPass" class="input-small" /></td>
									<td>관리자 비밀번호 확인</td>
									<td><input type="password" name="UserPass_Re" id="UserPass_Re" class="input-small" /><a href="#" class="btn">초기화</a>
									</td>
								</tr>
								<tr>
									<td>관리자명</td>
									<td><input type="text" name="UserName" id="UserName" class="input-small" /></td>
									<td>관리자구분</td>
									<td>
										<select name="UserGubun" id="UserGubun">
											<%
												SQL = "SELECT PubName , PubCode  FROM Sportsdiary.dbo.tblPubCode WHERE DelYN='N' AND PPubCode='ad001'"

												If Request.Cookies("HostCode") <> "" Then 
													SQL = SQL&" AND SportsGb = '"&Request.Cookies("SportsGb")&"'"
												End If 

												Set Rs = Dbcon.Execute(SQL)

												If Not(Rs.Eof Or Rs.Bof) Then 
													Do Until Rs.Eof 
											%>
											<option value="<%=Rs("PubCode")%>"><%=Rs("PubName")%></option>
											<%
														Rs.MoveNext
													Loop 
												End If 

												Rs.Close
												Set Rs = Nothing 

											%>
										</select>
									</td>
									<td>협회구분</td>
									<td>
										<select name="HostCode" id="HostCode">
											<option value="">==미선택==</option>
											<%
												SQL = "SELECT PubName , PubCode FROM Sportsdiary.dbo.tblPubCode WHERE DelYN='N' AND PPubCode='sd053'"

												Set Rs = Dbcon.Execute(SQL)

												If Not(Rs.Eof Or Rs.Bof) Then 
													Do Until Rs.Eof 
											%>
											<option value="<%=Rs("PubCode")%>"><%=Rs("PubName")%></option>
											<%
														Rs.MoveNext
													Loop 
												End If 

												Rs.Close
												Set Rs = Nothing 

											%>
										</select>
									</td>
									<tr>
										<td>관리자연락처</td>
										<td><input type="text" name="HandPhone" id="HandPhone" class="input-small"></td>
										<td>관리자협회명</td>
										<td><input type="text" name="Company" id="Company" class="input-small"></td>
										<td>사용여부</td>
										<td>
											<select name="DelYN" id="DelYN">
												<option value="">==선택==</option>
												<option value="N">사용중</option>
												<option value="Y">사용안함</option>
											</select>
										</td>
									</tr>
								</tr>
							</table>
						</div>					
					</div>
					</form>
				<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->				
				<!-- S : btn-right-list 버튼 -->
					<div class="btn-right-list">
						<a href="#" id="btnsave" class="btn" onClick="input_frm();" accesskey="i">등록(I)</a>
						<a href="#" id="btnupdate" class="btn" onClick="update_frm();" accesskey="e">수정(E)</a>
						<a href="#" id="btndel" class="btn btn-delete" onClick="del_frm();" accesskey="r">삭제(R)</a>
						<!--<a href="#" class="btn">목록보기</a>-->
					</div>
					<!-- E : btn-right-list 버튼 -->
			<!-- E : top-navi -->
			</div>
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
								<th scope="row">
									<select name="Search_Type">
										<option value="UserID">관리자아이디</option>
										<option value="UserName">관리자명</option>
									</select>
								</th>
								<td><input type="text" name="Search_Text" id="Search_Text" class="input-small" /></td>
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
					<caption>관리자 리스트</caption>
					<colgroup>
						<col width="44px" />
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
							<th scope="col">번호</th>
							<th scope="col">종목구분</th>
							<th scope="col">관리자구분</th>
							<th scope="col">관리자명</th>
							<th scope="col">관리자아이디</th>
							<th scope="col">협회구분</th>
							<th scope="col">관리자연락처</th>
							<th scope="col">사용여부</th>
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
<!--리스트 E-->
<!-- sticky -->
<script src="../js/js.js"></script>
</body>