<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<title>KATA Tennis 대회 참가신청</title>
<%  
	'==============================================================================
	'작성 및 상세정보 조회페이지
	'==============================================================================
	dim act               : act               = fInject(Request("act"))
	dim currPage          : currPage          = fInject(Request("currPage"))
	dim Fnd_KeyWord       : Fnd_KeyWord       = fInject(Request("Fnd_KeyWord"))
	
	
	'대회참가신청 페이지 ./list_repair.asp
	dim RequestIDX       : RequestIDX         = fInject(decode(Request("RequestIDX"), 0)) '참가신청IDX
	dim Fnd_GameTitle     : Fnd_GameTitle     = fInject(Request("Fnd_GameTitle"))     '대회IDX
'	dim RequestGroupNum   : RequestGroupNum   = fInject(decode(Request("RequestGroupNum"), 0))   '참가신청 그룹번호  
	dim GameTitle         : GameTitle         = fInject(Request("GameTitle"))
	dim TeamGb            : TeamGb            = fInject(Request("TeamGb"))
	
	'==============================================================================
	dim SportsGb          : SportsGb          = "tennis"
	
	dim CSQL, CRs
	
	
	'대회정보
	dim GameTitleName, GameS, GameE, GameArea, Sido, GameRcvDateS, GameRcvDateE
	'대회참가신청정보
	dim UserPass, UserName, UserPhone, txtMemo, PaymentDt, PaymentNm
	dim strUserPhone, UserPhone1, UserPhone2, UserPhone3
	
	'  response.Write "act="&act&"<br>"
	'  response.Write "currPage="&currPage&"<br>"
	'  response.Write "Fnd_KeyWord="&Fnd_KeyWord&"<br>"
	'  response.Write "Fnd_GameTitle="&Fnd_GameTitle&"<br>"
	'  response.Write "RequestGroupNum="&RequestGroupNum&"<br>"
	'  response.Write "GameTitle="&GameTitle&"<br>"
	'  response.Write "TeamGb="&TeamGb&"<br>"
	
  
	IF act = "" OR Fnd_GameTitle = "" Then
		response.Write "<script>"
		response.Write "  alert('잘못된 접근입니다. 확인 후 이용하세요.');"
		response.Write "  history.back();"
		response.Write "</script>"
		response.End()
	Else
	
		IF act = "MOD" Then
			
			'대회참가신청정보 조회
			CSQL =      "   SELECT * " 
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
			CSQL = CSQL & " WHERE DelYN = 'N' " 
			CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"'"
			CSQL = CSQL & "   AND GameTitleIDX = '"&Fnd_GameTitle&"'"
			CSQL = CSQL & "   AND RequestIDX = '"&RequestIDX&"'"
			
			SET CRs = Dbcon.Execute(CSQL)
			IF Not(CRs.Eof Or CRs.Bof) Then 
				Level     	= CRs("Level")    '참가신청 종목 상세
				UserPass    = CRs("UserPass")
				UserName    = CRs("UserName")
				UserPhone   = CRs("UserPhone")
				txtMemo     = CRs("txtMemo")
				PaymentDt   = CRs("PaymentDt")
				PaymentNm   = CRs("PaymentNm")
				
				IF UserPhone <> "" Then
					strUserPhone = Split(UserPhone, "-")  
					UserPhone1 = strUserPhone(0)
					UserPhone2 = strUserPhone(1)
					UserPhone3 = strUserPhone(2)            
				End IF
				
				P1_PlayerIDX = CRs("P1_PlayerIDX")
				P1_UserName = CRs("P1_UserName")
				P1_UserLevel = CRs("P1_UserLevel")
				P1_Team = CRs("P1_Team")
				P1_TeamNm = CRs("P1_TeamNm")
				P1_Team2 = CRs("P1_Team2")
				P1_TeamNm2 = CRs("P1_TeamNm2")
				P1_Birthday = CRs("P1_Birthday")
				
				P1_UserPhone = CRs("P1_UserPhone")
				
				IF P1_UserPhone <> "" Then
					strP1_UserPhone = Split(P1_UserPhone, "-")  
					P1_UserPhone1 = strP1_UserPhone(0)
					P1_UserPhone2 = strP1_UserPhone(1)
					P1_UserPhone3 = strP1_UserPhone(2)            
				End IF
				
				P2_PlayerIDX = CRs("P2_PlayerIDX")
				P2_UserName = CRs("P2_UserName")
				P2_UserLevel = CRs("P2_UserLevel")
				P2_Team = CRs("P2_Team")
				P2_TeamNm = CRs("P2_TeamNm")
				P2_Team2 = CRs("P2_Team2")
				P2_TeamNm2 = CRs("P2_TeamNm2")
				P2_Birthday = CRs("P2_Birthday")
				
				P2_UserPhone = CRs("P2_UserPhone")
				
				IF P2_UserPhone <> "" Then
					strP2_UserPhone = Split(P2_UserPhone, "-")  
					P2_UserPhone1 = strP2_UserPhone(0)
					P2_UserPhone2 = strP2_UserPhone(1)
					P2_UserPhone3 = strP2_UserPhone(2)            
				End IF
				
			Else
				response.Write "<script>"
				response.Write "  alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"
				response.Write "  history.back();"
				response.Write "</script>"
				response.End()
			End IF
				CRs.Close
			SET CRs = Nothing
			
		END IF
	
	End IF
  
%>
<script>
	
	//maxlength 체크
	function maxLengthCheck(obj){
		var $this = $(obj);
		
		if(obj.value.length > obj.maxLength){
			obj.value = obj.value.slice(0, obj.maxLength);
			$this.next().next().focus();
		} 
		else if(obj.value.length == obj.maxLength){
			$this.next().next().focus();
		}
		else{}
	}
  
	//create Select box 대회조회 및 대회참가종목 조회
	function FND_SELECTOR(element){
		var strAjaxUrl = "./ajax/Request_Select.asp";  
		var Fnd_GameTitle = $("#Fnd_GameTitle").val();
		var Level = $("#Level").val();    
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { 
				element         : element
				,Level        : Level
				,Fnd_GameTitle  : Fnd_GameTitle
			},
			success: function(retDATA) {
				
				//console.log(retDATA);
				
				if(retDATA){
					
					var strcut = retDATA.split("|");
					
					if(strcut[0]=="TRUE") $('#'+element).append(strcut[1]);
				}       
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
		});
	}
  
	//대회정보 조회(상단 대회정보 출력)
	function FND_GameTitleInfo(element){
		var strAjaxUrl = "./ajax/write_GameTitle_Info.asp";  
		var Fnd_GameTitle = $("#Fnd_GameTitle").val();
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { 
				Fnd_GameTitle  : Fnd_GameTitle
			},
			success: function(retDATA) {
			
				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split("|");
					
					
					if(strcut[0]=="TRUE"){
					
						//상단 대회정보 출력            
						$('#txt_GameTitleName').text(strcut[1]);
						$('#txt_Term').text(strcut[2]);
						//  $('#txt_AreaDtl').text(strcut[3]);
						//  $('#txt_TermRcv').text(strcut[4]);
						
						//대회참가 신청기간이 만료되면 수정 및 삭제권한 없음처리(btn)
						if(strcut[5]=="off"){
							$('#btn_Del').hide();
							$('#btn_Mod').hide();
						}
						else{
							$('#btn_Del').show();
							$('#btn_Mod').show();
						}
						
						//SMS발송을 위한 대회명
						$('#SMS_GameTitleNm').val(strcut[1]);
						
					}
				}       
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
		});
	}    
  
  
	function CHK_OnSubmit(valType){
	
		switch (valType) { 
			case 'GLIST':   //대회정보 목록
				$('form[name=s_frm]').attr('action',"./list.asp");
				$('form[name=s_frm]').submit();
				break;
			
			case 'RLIST':   //대회참가신청 목록
				$('form[name=s_frm]').attr('action',"./list_repair.asp");
				$('form[name=s_frm]').submit();
				break;  
			
			case 'DEL':   //참가신청 정보 삭제
				if(!$('#UserPass').val()){
					alert("비밀번호를 입력해 주세요.");
					$('#UserPass').focus();
					return;
				}
				else{
					if(confirm("대회 참가신청 정보를 취소하시겠습니까?")){
						
						//Info_Request_Del('<%=Fnd_GameTitle%>', '<%=RequestIDX%>');
						$('form[name=s_frm]').attr('action',"./write_del.asp");
						$('form[name=s_frm]').submit();
						
					}
					else{
						return; 
					}      
				}
				break;
			
			default:    //참가신청 정보 작성/수정
			
				if(valType == "MOD") {
					if(confirm("참가신청 정보를 수정하시겠습니까?")){
						ON_Air(valType);  
					}
					else{
						return; 
					}
				}
				else{ //WRITE
					ON_Air(valType);  
				}
				
				break;        
		}
	}
  	
	/*입력정보 확인
  	//--------------------------------------------------------------------------------------
	1) 참가자 신청 및 수정시 입력하는 정보(이름, 클럽)에 해당되는 정보를 db조회하여 선택할 수 있도록
	2) 참가신청은 참가자의 정보가 db에 조회되지 않더라도 신청가능
	3) 참가신청은 참가자의 클럽정보가 db에 조회되지 않더라도 신청가능
	4) 참가신청은 파트너가 없어도 신청가능
	5) 참가신청은 파트너 정보가 db에 조회되지 않더라도 신청가능
	6) 참가신청 정보 수정시 현재의 참가신청 순번을 유지 - 참가신청 날짜시간 순서
	7) 참가신청은 각 부의 참가제한 팀수가 정해져 있기때문에 참가제한 팀수를 넘는 경우는 대기팀으로 자동등록 처리, alert
	8) 참가신청 엔트리에서 취소될 경우 대기팀에서 자동으로 엔트리에 업데이트 - 자동 엔트리에 업데이트 될 경우 문자 발송
	9) 참가신청 취소리스트 관리상 필요함으로 취소리스트 조회할 수 있어야한다.
	10) 선수 정보 db 조회 되지 않으면 KATA 관리자에게 직접 정보등록 요청하도록 alert
	//--------------------------------------------------------------------------------------
	*/
    function ON_Air(val_Type){
		var data, y, m, d, dt;
		var msg = "";
		
		
		if(!$('#UserPass').val()){ 
			alert("비밀번호를 입력하세요");
			$('#UserPass').focus();
			return;
		}
		else{
		  	if($('#UserPass').val().length<4 || $('#UserPass').val().length>12){ 
				alert("패스워드는 4자~12자입니다.");
				$('#UserPass').focus();
				return;
			}   
		}
		
		if(!$('#TeamGb').val()){
			alert("참가종목을 선택하세요");
			$('#TeamGb').focus();
			return;
		}
		
		if(!$('#UserName').val()){ 
			alert("신청자 이름을 입력하세요");
			$('#UserName').focus();
			return;
		}
			
		if(!$('#UserPhone2').val()){
			alert("신청자 전화번호 가운데자리를 입력하세요");
			$('#UserPhone2').focus();
			return;
		}
		
		if(!$('#UserPhone3').val()){
			alert("신청자 전화번호 뒷자리를 입력하세요");
			$('#UserPhone3').focus();
			return;
		}
		
		//참가자 정보
		//--------------------------------------------------------------------------------------
		if(!$('#P1_UserName').val()){
			alert("참가자 이름을 입력하세요");
			$('#P1_UserName').focus();
			return;
		}
		
		if($('#P1_UserPhone2').val() !="" && $("#P1_UserPhone2").val().length < 4){
			alert("전화번호 4자리를 입력하세요");
			$('#P1_UserPhone2').focus();
			return;
		}
		
		if($('#P1_UserPhone3').val() !="" && $("#P1_UserPhone3").val().length < 4){
			alert("전화번호 4자리를 입력하세요");
			$('#P1_UserPhone3').focus();
			return;
		}		
		
		//참가자 생년월일을 입력했을 경우 생년월일 체크
		if($("#P1_Birthday").val()){ 
			data = $("#P1_Birthday").val();
				
			y = parseInt(data.substr(0, 4), 10); 
			m = parseInt(data.substr(4, 2), 10); 
			d = parseInt(data.substr(6, 2), 10); 
		
			dt = new Date(y, m-1, d); 
		
			if(dt.getDate() != d) { 
				alert("참가자 생년월일 일이 유효하지 않습니다.");
				$("#P1_Birthday").focus();
				return;
			}
			else if(dt.getMonth()+1 != m) { 
				alert("참가자 생년월일 월이 유효하지 않습니다.");
				$("#P1_Birthday").focus();
				return;
			}
			else if(dt.getFullYear() != y) { 
				alert("참가자 생년월일 년도가 유효하지 않습니다.");
				$("#P1_Birthday").focus();
				return;
			}
			else { } 
		}
		//파트너 정보
		//--------------------------------------------------------------------------------------
		if($('#P2_UserPhone2').val() !="" && $("#P2_UserPhone2").val().length < 4){
			alert("전화번호 4자리를 입력하세요");
			$('#P2_UserPhone2').focus();
			return;
		}
		
		if($('#P2_UserPhone3').val() !="" && $("#P2_UserPhone3").val().length < 4){
			alert("전화번호 4자리를 입력하세요");
			$('#P2_UserPhone3').focus();
			return;
		}		
		
		//파트너 생년월일을 입력했을 경우 생년월일 체크
		if($("#P2_Birthday").val()){ 
			data = $("#P2_Birthday").val();
				
			y = parseInt(data.substr(0, 4), 10); 
			m = parseInt(data.substr(4, 2), 10); 
			d = parseInt(data.substr(6, 2), 10); 
		
			dt = new Date(y, m-1, d); 
		
			if(dt.getDate() != d) { 
				alert("참가자 생년월일 일이 유효하지 않습니다.");
				$("#P2_Birthday").focus();
				return;
			}
			else if(dt.getMonth()+1 != m) { 
				alert("참가자 생년월일 월이 유효하지 않습니다.");
				$("#P2_Birthday").focus();
				return;
			}
			else if(dt.getFullYear() != y) { 
				alert("참가자 생년월일 년도가 유효하지 않습니다.");
				$("#P2_Birthday").focus();
				return;
			}
			else { } 
		}
		
		//--------------------------------------------------------------------------------------
		var strAjaxUrl = "./ajax/write_Validity_Info.asp";  
		var GameTitle = $('#Fnd_GameTitle').val();
		var TeamGb = $('#TeamGb').val();		
		var P1_PlayerIDX_Old = $('#P1_PlayerIDX_Old').val();
		var P1_PlayerIDX = $('#P1_PlayerIDX').val();		
		var P1_UserName = $('#P1_UserName').val();		
		var P1_Birthday = $('#P1_Birthday').val();
		var P1_TeamOne = $('#P1_TeamOne').val();
		var P1_TeamTwo = $('#P1_TeamTwo').val();
		var P2_PlayerIDX_Old = $('#P2_PlayerIDX_Old').val();
		var P2_PlayerIDX = $('#P2_PlayerIDX').val();
		var P2_UserName = $('#P2_UserName').val();
		var P2_Birthday = $('#P2_Birthday').val();
		var P2_TeamOne = $('#P2_TeamOne').val();
		var P2_TeamTwo = $('#P2_TeamTwo').val();
		var RequestIDX = $('#RequestIDX').val();
		
		var chk_Submit = 0;
			
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { 
				GameTitle     		: GameTitle
				,TeamGb       		: TeamGb
				,P1_PlayerIDX_Old  	: P1_PlayerIDX_Old
				,P1_PlayerIDX  		: P1_PlayerIDX
				,P1_UserName  		: P1_UserName
				,P1_Birthday    	: P1_Birthday
				,P1_TeamOne    		: P1_TeamOne
				,P1_TeamTwo    		: P1_TeamTwo
				,P2_PlayerIDX_Old  	: P2_PlayerIDX_Old
				,P2_PlayerIDX  		: P2_PlayerIDX
				,P2_UserName  		: P2_UserName
				,P2_Birthday    	: P2_Birthday
				,P2_TeamOne    		: P2_TeamOne
				,P2_TeamTwo    		: P2_TeamTwo
				,RequestIDX   		: RequestIDX
				,val_Type     		: val_Type
			},
			success: function(retDATA) {
			
				console.log(retDATA);
				
			
				if(retDATA){
				
					var strcut = retDATA.split("|");
					
					if(strcut[0]=="TRUE"){
						//strcut[1] : 참가제한 팀수
						//strcut[3] : 신청한 팀수
						$('#cntGameLvl').val(strcut[1]);	//참가접수제한 수
						$('#cntReqLvl').val(strcut[2]);		//참가신청한 팀수(현재 신청한 팀 제외)
						
						if(val_Type=="WR"){
							//참가제한 팀 수를 오버시 대기팀으로 접수
							if(strcut[1] <= strcut[2]){
								if(confirm("대회 참가신청 접수가 선착순 마감되었습니다.\n\n참가대기팀으로 접수하시겠습니까?")){
									chk_Submit = 1;
								}
								else{
									return;
								}
							}
						}
						//-----------------------------------------------------------------------------------------------------
						//참가자 정보를 조회하지 않고 입력하는 경우 또는 db에 미등록의 경우
						if(!$('#P1_PlayerIDX').val() || !$('#P1_UserName').val()){
							if(confirm("참가자 정보가 KATA에 등록되어 있지 않습니다.\nKATA에 참가자 정보를 등록하셔야 참가신청이 완료됩니다.\n☎0505-555-0055\n\n참가신청을 진행하시겠습니까?"))	{
								chk_Submit = 1;
							}
							else{
								chk_Submit = 2;
							}
						}
						
						//참가자 소속정보를 조회하지 않고 입력하는 경우 또는 db에 미등록의 경우
						if(!$('#P1_TeamOne').val()){ //P1_Team IDX
							if(confirm("참가자 소속클럽정보가 KATA에 등록되어 있지 않습니다.\nKATA에 참가자 소속클럽정보를 등록하셔야 참가신청이 완료됩니다.\n☎0505-555-0055\n\n참가자 소속클럽정보 없이 참가신청을 진행하시겠습니까?"))	{
								chk_Submit = 1;
							}
							else{
								chk_Submit = 2;
							}
						}
						//-----------------------------------------------------------------------------------------------------
						//파트너 정보를 조회하지 않고 입력하는 경우 또는 db에 미등록의 경우
						if(!$('#P2_PlayerIDX').val() || !$('#P2_UserName').val()){
							if(confirm("파트너 정보가 KATA에 등록되어 있지 않습니다.\nKATA에 파트너 정보를 등록하셔야 참가신청이 완료됩니다.\n☎0505-555-0055\n\n파트너 없이 참가신청을 진행하시겠습니까?"))	{
								chk_Submit = 1; 
							}
							else{
								chk_Submit = 2;
							}
						}
						
						//파트너 소속정보를 조회하지 않고 입력하는 경우 또는 db에 미등록의 경우
						if(!$('#P2_TeamOne').val()){ //P2_Team IDX
							if(confirm("파트너 소속클럽정보가 KATA에 등록되어 있지 않습니다.\nKATA에 파트너 소속클럽정보를 등록하셔야 참가신청이 완료됩니다.\n☎0505-555-0055\n\파트너 소속클럽정보 없이 참가신청을 진행하시겠습니까?"))	{
								chk_Submit = 1;
							}
							else{
								chk_Submit = 2;
							}
						}
						//-----------------------------------------------------------------------------------------------------
						switch (chk_Submit) { 
							case 1 : 	//미입력 정보 있어도 참가신청 가능
								$('form[name=s_frm]').attr('action',"./write_ok.asp");
								$('form[name=s_frm]').submit();			
								break;  
							case 2 : 	
								return;
								break;
							default :
								$('form[name=s_frm]').attr('action',"./write_ok.asp");
								$('form[name=s_frm]').submit();			
								break;
						}

					}   
					else{
						switch (strcut[1]) { 
							case '99' : msg = "이미 참가신청한 정보가 존재합니다.\n["+strcut[2]+"]\n입력하신 정보를 확인해주세요."; break;  
							default   : msg = "잘못된 접근입니다. 확인 후 이용하세요."; break;
						}

						alert(msg);
						return;
					}
				}
				else{
					alert("잘못된 접근입니다. 확인 후 이용하세요."); 
					return;
				}
				
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
		});
	} 

  	/*
	//대회참가신청 정보 삭제
	function Info_Request_Del(valTitle, valIDX){
		var txtErr = "";
		var strAjaxUrl = "./ajax/write_Request_del.asp";      
		var valPass = $('#UserPass').val();
		var valLevel = $('#Level').val();
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { 
				valTitle    : valTitle		//대회IDX
				,valIDX  	: valIDX		//여러팀 신청시 그룹번호
				,valPass    : valPass		//비밀번호
				,valLevel   : valLevel		//대회 참가종목 상세
			},
			success: function(retDATA) {
			
				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split("|");
					
					if(strcut[0]=="TRUE"){
						alert("참가신청 정보를 취소하였습니다.");
						
						$('form[name=s_frm]').attr('action',"./list_repair.asp");
//						$('form[name=s_frm]').submit();           
					}
					else{
						switch (strcut[1]) { 
						case '200'  : txtErr = "잘못된 접근입니다. 확인 후 이용하세요."; break;
						case '99'   : txtErr = "일치하는 정보가 없습니다. 확인 후 이용하세요"; break;
						case '66'   : txtErr = "참가신청정보를 삭제하지 못하였습니다. 확인 후 이용하세요"; break;
						default : break;             
					}
					
					alert(txtErr);  
					return; 
					
					}
				}     
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
		}); 
	}
  	*/
	
   	//선수정보 입력 자동완성 기능
  	function FND_PlayerInfo(val, ObjCnt, sObj, keycode){
  
    	var strAjaxUrl = "./ajax/write_Player_Info.asp";  
    	var Fnd_KeyWord = val.replace(/ /g, '');    //공백제거
    	var cnt = $('.entry').length;	//참가팀 카운트
		var valCnt = ObjCnt + 1;			//입력할 .entry 번호
		var Fnd_ObjPlayer = sObj.slice(0, 2);
		
  		//방향키 keydown/keyup시 조회안되게(키포커스 이동 막음)
		if(keycode==37||keycode==38||keycode==39||keycode==40){	}
		else{
			
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: { 
					Fnd_KeyWord : Fnd_KeyWord
					,Fnd_ObjCnt : ObjCnt
					,Fnd_ObjPlayer : Fnd_ObjPlayer
				},
				success: function(retDATA) {
					
					//console.log(retDATA);					
					
					$('#'+sObj+'_'+valCnt).children().remove();
					$('#'+sObj+'_'+valCnt).append(retDATA);
					
					//console.log($('#'+sObj+'_'+valCnt).children().length);
					
					if ($('#'+sObj+'_'+valCnt).children().length > 0) {
						$('#'+sObj+'_'+valCnt).addClass('on');
						$('.entry_list').autoSrchMove();
					} 
					else {
						$('#'+sObj+'_'+valCnt).removeClass('on');
					}       
				}, 
				error: function(xhr, status, error){
					if(error!=""){ 
						alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
						return; 
					}     
				}
			});   					
		}
	}
  
	//선수정보 조회 값 Box input text box에 넣기
	function Input_PlayerInfo(valPlayer, valCnt, valIDX, valName, valTeam, valTeamNm, valTeam2, valTeam2Nm, valSEX, valBirth, valPhone){
		var P1_Phone1 = valPhone.slice(0,3);
		var P1_Phone2 = valPhone.slice(3,7);
		var P1_Phone3 = valPhone.slice(-4);
		var objCnt = Number(valCnt) + 1;
		
		$('input[name='+valPlayer+'_PlayerIDX]').eq(valCnt).val(valIDX);
		$('input[name='+valPlayer+'_UserName]').eq(valCnt).val(valName);
		$('input[name='+valPlayer+'_TeamOne]').eq(valCnt).val(valTeam);
		$('input[name='+valPlayer+'_TeamTwo]').eq(valCnt).val(valTeam2);
		$('input[name='+valPlayer+'_Birthday]').eq(valCnt).val(valBirth);
		$('input[name='+valPlayer+'_UserPhone1]').eq(valCnt).val(P1_Phone1);
		$('input[name='+valPlayer+'_UserPhone2]').eq(valCnt).val(P1_Phone2);
		$('input[name='+valPlayer+'_UserPhone3]').eq(valCnt).val(P1_Phone3);
		$('input[name='+valPlayer+'_GenderIDX]').eq(valCnt).val(valSEX);		
		$('#'+valPlayer+'_TeamNmOne_'+objCnt).val(valTeamNm);
		$('#'+valPlayer+'_TeamNmTwo_'+objCnt).val(valTeam2Nm);	
	}
  
	$(document).ready(function(){
		//참가종목 조회 초기화
		$('#TeamGb').children('option').remove();
		
		FND_SELECTOR('TeamGb');
		
		//상단 대회정보 조회 출력
		FND_GameTitleInfo();
		
		/*
		// .gender label 이 on 이면 input 체크 되도록
		$('.entry .gender label').each(function(idx, el) {
			if ($(this).hasClass('on')) {
				$(this).find('input').prop('checked','checked');
			}
		});
		*/
	}); // ready end
</script>
</head>
<body class="lack_bg">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
<div class="main">
  <!-- S: cont_box -->
  <div class="cont_box">
    <!-- S: form_header -->
    <div class="form_header">
      <h2 id="txt_GameTitleName" class="title">
        <!--[C그룹] 2017 Flex Power 용인클레이배 테니스대회-->
      </h2>
      <p id="txt_Term" class="term">
        <!--2017.08.11(금) ~ 2017.08.15(화)-->
      </p>
    </div>
    <!-- E: form_header -->
    <!-- S: form_cont -->
    <div class="form_cont">
      <!-- S: form -->
      <form name="s_frm" method="post">
        <input type="hidden" id="act" name="act" value="<%=act%>" />
        <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
        <input type="hidden" id="Fnd_KeyWord" name="Fnd_KeyWord" value="<%=Fnd_KeyWord%>" /><!--./list.asp, ./list_repair.asp KeyWord 검색조건-->
        <input type="hidden" id="GameTitle" name="GameTitle" value="<%=GameTitle%>" /><!--./list_repair.asp GameTitle 검색조건-->
        <input type="hidden" id="Fnd_TeamGb" name="Fnd_TeamGb" value="<%=TeamGb%>" /><!--./list_repair.asp TeamGb 검색조건-->
        <input type="hidden" id="Fnd_GameTitle" name="Fnd_GameTitle" value="<%=Fnd_GameTitle%>" />
        <input type="hidden" id="SMS_GameTitleNm" name="SMS_GameTitleNm" /><!--SMS 발송위한 정보[대회명]-->
        <input type="hidden" id="cntGameLvl" name="cntGameLvl" /><!--참가접수제한 수-->
        <input type="hidden" id="cntReqLvl" name="cntReqLvl" /><!--참가신청한 팀수-->

        <!--수정시-->
        <input type="hidden" id="Level" name="Level" value="<%=Level%>" /><!--참가신청 종목 상세-->
        <input type="hidden" id="RequestIDX" name="RequestIDX" value="<%=RequestIDX%>" />
        <fieldset>
          <!-- legend 안 보임 -->
          <legend>참가신청 작성</legend>
          <!-- legend 안 보임 -->
          <!-- S: form_list -->
          <ul class="form_list">
            <!-- S: 비밀번호 -->
            <li class="el_1">
              <label> <span class="title">비밀번호</span>
                <input type="password" id="UserPass" name="UserPass" maxlength="20" class="ipt"  value="<%=UserPass%>" />
              </label>
            </li>
            <!-- E: 비밀번호 -->
            <!-- S: 대회명 -->
            <!--
              <li class="el_1">
                <label>
                  <span class="title">대회명</span>
                  <select class="ipt" id="GameTitle" name="GameTitle" >
                    <option value="">:: 대회선택 ::</option>
                    <option>[B그룹]2017 프렌드쉽오픈</option>
                    <option>[SA그룹]2017 엔프라니배</option>
                    <option>[C그룹]2017 Flex Power 용인클레이배</option>
                    <option>[B그룹]2017 안양한우리 OPEN</option>
                    <option>[SA그룹]2017 나사라배</option>
                  </select>
                </label>
              </li>
              -->
            <!-- E: 대회명 -->
            <!-- S: 출전종목 -->
            <li class="el_1">
              <label> <span class="title">출전종목</span>
                <select class="ipt" id="TeamGb" name="TeamGb">
                  <option value="">:: 참가종목선택 ::</option>
                  <!--                    
                    <option>국화부</option>
                    <option>개나리부(부천)</option>
                    <option>개나리부(구리)</option>
                    <option>오픈부</option>
                    <option>신인부B(부천)</option>
                    <option>신인부B(구리)</option>
                    -->
                </select>
              </label>
            </li>
            <!-- E: 출전종목 -->
            <!-- S: 신청자 이름 -->
            <li class="reqer el_2">
              <label class="col_1"> <span class="title">신청자 이름</span>
                <input type="text" class="ipt" id="UserName" name="UserName" placeholder=":: 이름을 입력하세요 ::" value="<%=UserName%>" />
              </label>
              <span class="col_1 el_3 phone_line">
              <label> <span class="title">휴대폰 번호</span>
                <select class="ipt col_1" id="UserPhone1" name="UserPhone1">
                  <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
                  <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
                  <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
                  <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
                  <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
                  <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
                </select>
              </label>
              <span class="divn">-</span>
              <input type='number' class="ipt col_1 phone_line" id="UserPhone2" name="UserPhone2" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone2%>" />
              <span class="divn">-</span>
              <input type="number" class="ipt col_1 phone_line" id="UserPhone3" name="UserPhone3" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone3%>" />
              </span> </li>
            <!-- E: 신청자 이름 -->
            <li class="no_bdb">
              <ul class="entry_list">
                <!-- S: 참가자 정보 -->
                <%
                dim i, j
              
                SELECT CASE act 
                  CASE "MOD"                 
                      
                %>
                
                <li id="div_Entry<%=cnt%>" class="entry el_2">
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header"> 
                    	<!--
                    	<a href="#" class="btn btn_party_del"> <span class="ic_deco"> <i class="fa fa-times-circle"></i> </span>
                        -->
                      	<!-- 
                        <span>참가자 삭제</span> 
                        -->
                      <!--
                      </a> <span class="num-box"><%=i%></span>
                      -->
                      <h3>참가자 정보</h3>
                     
                     <!--
                      <label>
                        <input type="checkbox" id="CHK_INFO_SAME" name="CHK_INFO_SAME" autocomplete="off">
                        <span class="txt">신청자 정보와 동일</span> </label>
                     -->
                      
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                      <input type="text" class="ipt" id="P1_UserName" name="P1_UserName" value="<%=P1_UserName%>" autocomplete="off" onKeyUp="FND_PlayerInfo(this.value, $(this).parents('.entry').index(), 'P1_PName', event.keyCode);" />
                    <ul class="auto_srch" id="P1_PName">
                          <li><a href="#">강서어택</a></li>
                          <li><a href="#">강북멋쟁이</a></li>
                          <li><a href="#">강남스타일</a></li>
                          <li><a href="#">강서뚜쟁이</a></li>
                          <li><a href="#">강동막둥이</a></li>
                          <li><a href="#">마포막난이</a></li>
                        </ul>
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P1_UserLevel" name="P1_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" <%IF P1_UserLevel = "A" Then response.Write "selected" End IF%>>A</option>
                          <option value="B" <%IF P1_UserLevel = "B" Then response.Write "selected" End IF%>>B</option>
                          <option value="C" <%IF P1_UserLevel = "C" Then response.Write "selected" End IF%>>C</option>
                          <option value="D" <%IF P1_UserLevel = "D" Then response.Write "selected" End IF%>>D</option>
                          <option value="E" <%IF P1_UserLevel = "E" Then response.Write "selected" End IF%>>E</option>
                          <option value="F" <%IF P1_UserLevel = "F" Then response.Write "selected" End IF%>>F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P1_TeamNmOne" name="P1_TeamNmOne" value="<%=P1_TeamNm%>" />                    
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P1_TeamNmTwo" name="P1_TeamNmTwo" value="<%=P1_TeamNm2%>" />                     
                      </label>
                    </li>
                    <!-- E: 소속 -->                    
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">휴대폰</span>
                        <select class="ipt col_1" id="P1_UserPhone1" name="P1_UserPhone1">
                          <option value="010" <%IF P1_UserPhone1 = "010" Then response.write "selected" End IF%>>010</option>
                          <option value="011" <%IF P1_UserPhone1 = "011" Then response.write "selected" End IF%>>011</option>
                          <option value="016" <%IF P1_UserPhone1 = "016" Then response.write "selected" End IF%>>016</option>
                          <option value="017" <%IF P1_UserPhone1 = "017" Then response.write "selected" End IF%>>017</option>
                          <option value="018" <%IF P1_UserPhone1 = "018" Then response.write "selected" End IF%>>018</option>
                          <option value="019" <%IF P1_UserPhone1 = "019" Then response.write "selected" End IF%>>019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone2" name="P1_UserPhone2" maxlength="4" value="<%=P1_UserPhone2%>" oninput="maxLengthCheck(this);" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone3" name="P1_UserPhone3" maxlength="4" value="<%=P1_UserPhone3%>" oninput="maxLengthCheck(this);" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <input type="number" class="ipt col_1" id="P1_Birthday" name="P1_Birthday" maxlength="8" placeholder="ex)19880725" value="<%=P1_Birthday%>" oninput="maxLengthCheck(this);" />
                      </label>
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header">
                      <h3>파트너 정보</h3>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                      <input type="text" class="ipt" id="P2_UserName" name="P2_UserName" value="<%=P2_UserName%>" autocomplete="off" onKeyUp="FND_PlayerInfo(this.value, $(this).parents('.entry').index(), 'P2_PName', event.keyCode);" />
                    <ul class="auto_srch" id="P2_PName">
                          <li><a href="#">강서어택</a></li>
                          <li><a href="#">강북멋쟁이</a></li>
                          <li><a href="#">강남스타일</a></li>
                          <li><a href="#">강서뚜쟁이</a></li>
                          <li><a href="#">강동막둥이</a></li>
                          <li><a href="#">마포막난이</a></li>
                        </ul>
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P2_UserLevel" name="P2_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" <%IF P2_UserLevel = "A" Then response.Write "selected" End IF%>>A</option>
                          <option value="B" <%IF P2_UserLevel = "B" Then response.Write "selected" End IF%>>B</option>
                          <option value="C" <%IF P2_UserLevel = "C" Then response.Write "selected" End IF%>>C</option>
                          <option value="D" <%IF P2_UserLevel = "D" Then response.Write "selected" End IF%>>D</option>
                          <option value="E" <%IF P2_UserLevel = "E" Then response.Write "selected" End IF%>>E</option>
                          <option value="F" <%IF P2_UserLevel = "F" Then response.Write "selected" End IF%>>F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> 
                      <span class="show_srch col_1 ipt">
                      <input type="text" id="P2_TeamNmOne" name="P2_TeamNmOne" value="<%=P2_TeamNm%>" />                      
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P2_TeamNmTwo" name="P2_TeamNmTwo" value="<%=P2_TeamNm2%>" />                     
                      </label>
                    </li>
                    <!-- E: 소속 -->                    
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">휴대폰</span>
                        <select class="ipt col_1" id="P2_UserPhone1" name="P2_UserPhone1">
                          <option value="010" <%IF P2_UserPhone1 = "010" Then response.write "selected" End IF%>>010</option>
                          <option value="011" <%IF P2_UserPhone1 = "011" Then response.write "selected" End IF%>>011</option>
                          <option value="016" <%IF P2_UserPhone1 = "016" Then response.write "selected" End IF%>>016</option>
                          <option value="017" <%IF P2_UserPhone1 = "017" Then response.write "selected" End IF%>>017</option>
                          <option value="018" <%IF P2_UserPhone1 = "018" Then response.write "selected" End IF%>>018</option>
                          <option value="019" <%IF P2_UserPhone1 = "019" Then response.write "selected" End IF%>>019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone2" name="P2_UserPhone2" maxlength="4" value="<%=P2_UserPhone2%>" oninput="maxLengthCheck(this);" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone3" name="P2_UserPhone3" maxlength="4" value="<%=P2_UserPhone3%>" oninput="maxLengthCheck(this);" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <input type="number" class="ipt col_1" id="P2_Birthday" name="P2_Birthday" maxlength="8" placeholder="ex)19880725" value="<%=P2_Birthday%>" oninput="maxLengthCheck(this);" />
                      </label>
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  
                  
                  <input type="hidden" id="P1_PlayerIDX_Old" name="P1_PlayerIDX_Old" value="<%=P1_PlayerIDX%>" />
                  <input type="hidden" id="P1_PlayerIDX" name="P1_PlayerIDX" value="<%=P1_PlayerIDX%>" />
                  <input type="hidden" id="P1_TeamOne" name="P1_TeamOne" value="<%=P1_Team%>" />
                  <input type="hidden" id="P1_TeamTwo" name="P1_TeamTwo" value="<%=P1_Team2%>" />
                  <input type="hidden" id="P2_PlayerIDX_Old" name="P2_PlayerIDX_Old" value="<%=P2_PlayerIDX%>" />
                  <input type="hidden" id="P2_PlayerIDX" name="P2_PlayerIDX" value="<%=P2_PlayerIDX%>" />                  
                  <input type="hidden" id="P2_TeamOne" name="P2_TeamOne" value="<%=P2_Team%>" />
                  <input type="hidden" id="P2_TeamTwo" name="P2_TeamTwo" value="<%=P2_Team2%>" />  
                  	
                </li>
                <%
            
          
        'WRITE            
        CASE ELSE
        %>
                <li class="entry el_2">
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header"> 
                    <!--
                    <a href="#" class="btn btn_party_del"> <span class="ic_deco"> <i class="fa fa-times-circle"></i> </span>
                    -->
                      <!-- <span>참가자 삭제</span> -->
                      <!--
                      </a> <span class="num-box">1</span>
                      -->
                      <h3>참가자 정보</h3>
                      <!--
                      <label>
                        <input type="checkbox" id="CHK_INFO_SAME" name="CHK_INFO_SAME" autocomplete="off">
                        <span class="txt">신청자 정보와 동일</span> </label>
                     -->
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                      <input type="text" class="ipt" id="P1_UserName" name="P1_UserName" autocomplete="off" onKeyUp="FND_PlayerInfo(this.value, $(this).parents('.entry').index(), 'P1_PName', event.keyCode);" />
                    <ul class="auto_srch" id="P1_PName">
                          <li><a href="#">강서어택</a></li>
                          <li><a href="#">강북멋쟁이</a></li>
                          <li><a href="#">강남스타일</a></li>
                          <li><a href="#">강서뚜쟁이</a></li>
                          <li><a href="#">강동막둥이</a></li>
                          <li><a href="#">마포막난이</a></li>
                        </ul>
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P1_UserLevel" name="P1_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" selected>A</option>
                          <option value="B">B</option>
                          <option value="C">C</option>
                          <option value="D">D</option>
                          <option value="E">E</option>
                          <option value="F">F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 구버전 -->
                    <!-- <li class="el_1">
                        <label>
                          <span class="title">소속</span>
                          <select class="ipt" id="P_ReqClub2" name="P_ReqClub2">
                            <option>:: 소속을 선택하세요 ::</option>
                            <option>무궁화, 삼천리</option>
                            <option>백두산, 한라산</option>
                            <option>직접 입력</option>
                          </select>
                        </label>
                        <ul class="dir_ipt el_2 clearfix">
                          <li>
                            <input type="text">
                          </li>
                          <li class="divn">,</li>
                          <li>
                            <input type="text">
                          </li>
                        </ul>
                      </li> -->
                    <!-- E: 소속 구버전 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P1_TeamNmOne" name="P1_TeamNmOne"  />
                      <!--
                      <ul class="auto_srch" id="P1_ASOne">                        
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>                      
                      </ul>
                      -->
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P1_TeamNmTwo" name="P1_TeamNmTwo" />
                      <!--
                      <ul class="auto_srch" id="P1_ASTwo">
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>                        
                      </ul>
                      -->
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <!--
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="Man" />
                        <span>남자</span> </label>
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="WoMan" />
                        <span>여자</span> </label>
                      </span> </li>
                      -->
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">핸드폰</span>
                        <select class="ipt col_1" id="P1_UserPhone1" name="P1_UserPhone1">
                          <option value="010">010</option>
                          <option value="011">011</option>
                          <option value="016">016</option>
                          <option value="017">017</option>
                          <option value="018">018</option>
                          <option value="019">019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone2" name="P1_UserPhone2" maxlength="4" oninput="maxLengthCheck(this);" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone3" name="P1_UserPhone3" maxlength="4" oninput="maxLengthCheck(this);" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <!-- <select class="ipt col_1" id="P1_BirthdayY" name="P1_BirthdayY">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                        <input type="number" class="ipt col_1" id="P1_Birthday" name="P1_Birthday" maxlength="8" placeholder="ex)19880725" oninput="maxLengthCheck(this);" />
                      </label>
                      <!-- <span class="divn">-</span>
                        <select class="ipt col_1" id="P1_BirthdayM" name="P1_BirthdayM">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select> 
                        <span class="divn">-</span>
                      <select class="ipt col_1" id="P1_BirthdayD" name="P1_BirthdayD">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header">
                      <h3>파트너 정보</h3>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                      <input type="text" class="ipt" id="P2_UserName" name="P2_UserName" autocomplete="off" onKeyUp="FND_PlayerInfo(this.value, $(this).parents('.entry').index(), 'P2_PName', event.keyCode);" />
                    <ul class="auto_srch" id="P2_PName">
                          <li><a href="#">강서어택</a></li>
                          <li><a href="#">강북멋쟁이</a></li>
                          <li><a href="#">강남스타일</a></li>
                          <li><a href="#">강서뚜쟁이</a></li>
                          <li><a href="#">강동막둥이</a></li>
                          <li><a href="#">마포막난이</a></li>
                        </ul>
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P2_UserLevel" name="P2_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" selected>A</option>
                          <option value="B">B</option>
                          <option value="C">C</option>
                          <option value="D">D</option>
                          <option value="E">E</option>
                          <option value="F">F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P2_TeamNmOne" name="P2_TeamNmOne" />
                      <!--
                      <ul class="auto_srch" id="P2_ASOne">
                         <li><a href="#">강서어택</a></li>
                          <li><a href="#">강북멋쟁이</a></li>
                          <li><a href="#">강남스타일</a></li>
                          <li><a href="#">강서뚜쟁이</a></li>
                          <li><a href="#">강동막둥이</a></li>
                          <li><a href="#">마포막난이</a></li> 
                      </ul>
                      -->
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P2_TeamNmTwo" name="P2_TeamNmTwo" />
                      <!--
                      <ul class="auto_srch" id="P2_ASTwo">
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                      </ul>
                      -->
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <!--
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="Man" />
                        <span>남자</span> </label>
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="WoMan" />
                        <span>여자</span> </label>
                      </span> </li>
                      -->
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">핸드폰</span>
                        <select class="ipt col_1" id="P2_UserPhone1" name="P2_UserPhone1">
                          <option value="010">010</option>
                          <option value="011">011</option>
                          <option value="016">016</option>
                          <option value="017">017</option>
                          <option value="018">018</option>
                          <option value="019">019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone2" name="P2_UserPhone2" maxlength="4" oninput="maxLengthCheck(this);" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone3" name="P2_UserPhone3" maxlength="4" oninput="maxLengthCheck(this);" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <!-- <select class="ipt col_1" id="P_ReqBirthdayY2" name="P_ReqBirthdayY2">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                        <input type="number" class="ipt col_1" id="P2_Birthday" name="P2_Birthday" maxlength="8" placeholder="ex)19880725" oninput="maxLengthCheck(this);" />
                      </label>
                      <!-- <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayM2" name="P_ReqBirthdayM2">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select>
                        <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayD2" name="P_ReqBirthdayD2">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <input type="hidden" id="P1_PlayerIDX_Old" name="P1_PlayerIDX_Old" />
                  <input type="hidden" id="P2_PlayerIDX_Old" name="P2_PlayerIDX_Old" />
                  <input type="hidden" id="P1_PlayerIDX" name="P1_PlayerIDX" />
                  <input type="hidden" id="P1_TeamOne" name="P1_TeamOne" />
                  <input type="hidden" id="P1_TeamTwo" name="P1_TeamTwo" />
                  <input type="hidden" id="P2_PlayerIDX" name="P2_PlayerIDX" />
                  <input type="hidden" id="P2_TeamOne" name="P2_TeamOne" />
                  <input type="hidden" id="P2_TeamTwo" name="P2_TeamTwo" />                  
                </li>
                <%
        END SELECT  
          %>
                <!-- E: 참가자 정보 -->
              </ul>
            </li>
            <!-- S: 소속 입력 안내 -->
            <li class="guide_txt club_guide">
              <p>※신규 대회출전자 또는 소속정보 조회가 안 될 경우 KATA에 연락하여 등록하시기 바랍니다.</p>
              <p>※생년월일 입력은 필수입니다. (생년월일 정보로 참가선수의 본인확인 매칭을 통해 대회기록과 다양한 정보를 스포츠다이어리 앱에서 제공해드립니다.)</p>
            </li>
            <!-- E: 소속 입력 안내 -->
            <!-- S: 생년월일 입력 안내 -->
            <li class="guide_txt birth_guide">
              <p><span><i class="fa fa-exclamation-circle" aria-hidden="true"></i></span>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인 절차가 진행됩니다. 반드시 대회 참가자의 휴대폰 번호를 정확하게 입력하시기 바랍니다.</p>
            </li>
            <!-- E: 생년월일 입력 안내 -->
            <!-- 
                S: 참가팀 추가등록 
                버튼 클릭시 
                entry_list 아래 li.entry 가 추가 되도록 구성
              -->
              <!--
            <li class="btn_full no_bdb"> <a href="#" class="btn add_party"> <span class="ic_deco"><i class="fa fa-plus"></i></span> <span>참가팀 추가등록</span> </a> </li>
            -->
            <!-- E: 참가팀 추가등록 -->
            <!-- S: 입금일자 -->
            <li class="title_list"> <span class="big_title">대회참가비 입금정보</span>
              <label> <span class="title">입금일자</span>
                <input type="text" class="ipt" placeholder="ex) 2017.01.01" id="PaymentDt" name="PaymentDt" value="<%=PaymentDt%>" />
              </label>
              <label> <span class="title">입금자명</span>
                <input type="text" class="ipt" id="PaymentNm" name="PaymentNm" value="<%=PaymentNm%>" />
              </label>
            </li>
            <!-- E: 입금일자 -->
            <!-- S: 기타 건의내용 -->
            <li class="title_list user_suggest"> <span class="big_title">기타 건의내용</span>
              <label> <span class="ipt">
                <textarea id="txtMemo" name="txtMemo"><%=txtMemo%></textarea>
                </span> </label>
            </li>
            <!-- E: 기타 건의내용 -->
            <!-- S: guide_txt -->
            <!--
            <li class="guide_txt agree_warn clearfix"> <span class="ic_deco"> <i class="fa fa-exclamation-circle"></i> </span>
              <div class="txt">
                <p>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인절차가 진행됩니다.<br>
                  반드시 대회 참가자의 휴대폰 번호를 정확하게 입력하시기 바랍니다.</p>
              </div>
            </li>
            -->
            <li class="guide_txt down_way">
              <h3 class="tit">대회 참가신청 절차</h3>
              <span class="way_img"> <img src="imgs/write/flow.png" alt="문자발송된 url을 통해 본인확인 절차를 거치면 참가신청이 완료 됩니다."> </span>
            </li>
            
            <!-- E: guide_txt -->
          </ul>
          <!-- E: form_list -->
        </fieldset>
        <%IF act = "WR" Then%>
        <!-- S: cta_btn -->
        <div class="cta_btn"> <a href="javascript:CHK_OnSubmit('GLIST');" class="btn_gray">대회목록보기</a> <a href="javascript:CHK_OnSubmit('RLIST');" class="btn_dark_gray">참가신청목록보기</a> <a href="javascript:CHK_OnSubmit('WR');" class="btn_green">참가신청 완료</a> </div>
        <!-- E: cta_btn -->
        <%Else%>
        <!-- 
            조회 후 보이는 버튼 목록
            신청 삭제 : 내용 삭제 및 취소 (confirm 창으로 재확인)
            수정하기 -> write 상태로 변경
            목록보기 -> 이전 list.asp로 이동
           -->
        <!-- S: cta_btn -->
        <div class="cta_btn"> 
          <a href="javascript:CHK_OnSubmit('GLIST');" class="btn_gray">대회목록보기</a> 
            <a href="javascript:CHK_OnSubmit('RLIST');" class="btn_dark_gray">참가신청목록보기</a> 
            <a href="javascript:CHK_OnSubmit('DEL');" id="btn_Del" class="btn_redy">신청 삭제</a> 
            <a href="javascript:CHK_OnSubmit('MOD');" id="btn_Mod" class="btn_green">수정하기</a> </div>
        <!-- E: cta_btn -->
        <%End IF%>
      </form>
      <!-- E: form -->
    </div>
    <!-- E: form_cont -->
  </div>
  <!-- E: cont_box -->
</div>
<!-- E: main -->
<script src="js/main.js"></script>
</body>
</html>