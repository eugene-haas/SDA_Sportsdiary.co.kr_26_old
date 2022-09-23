/* File Created: 7월 14, 2017 */

/* 
사용법
onclick="post_to_url('./Post_formget.asp', {'test':'ming'});"  
params : 전송 데이터 {'q':'a','s':'b','c':'d'...}으로 묶어서 배열 입력
method : 전송 방식(생략가능)
*/

var global_filepathImgUrl_script = "/FileImg/"

function post_to_url(path, params, method) {

  method = method || "post"; //method 부분은 입력안하면 자동으로 post가 된다.

  var form = document.createElement("form");

  form.setAttribute("method", method);

  form.setAttribute("action", path);

  for (var key in params) {

    var hiddenField = document.createElement("input");

    hiddenField.setAttribute("type", "hidden");

    hiddenField.setAttribute("name", key);

    hiddenField.setAttribute("value", params[key]);

    form.appendChild(hiddenField);

  }

  document.body.appendChild(form);

  form.submit();

}


function post_to_url_popup(strtarget, path, params, method) {

	method = method || "post"; //method 부분은 입력안하면 자동으로 post가 된다.

	var form = document.createElement("form");

	form.setAttribute("method", method);

	form.setAttribute("target", strtarget);

	form.setAttribute("action", path);

	for (var key in params) {

	  var hiddenField = document.createElement("input");

	  hiddenField.setAttribute("type", "hidden");

	  hiddenField.setAttribute("name", key);

	  hiddenField.setAttribute("value", params[key]);

	  form.appendChild(hiddenField);

	}

	document.body.appendChild(form);

	form.submit();

  }   


function post_to_url_openType(path, params, method, openType) {

  method = method || "post"; //method 부분은 입력안하면 자동으로 post가 된다.

  var form = document.createElement("form");

  form.setAttribute("method", method);

	form.setAttribute("action", path);
	
	form.setAttribute("target", openType);


  for (var key in params) {

    var hiddenField = document.createElement("input");

    hiddenField.setAttribute("type", "hidden");

    hiddenField.setAttribute("name", key);

    hiddenField.setAttribute("value", params[key]);

    form.appendChild(hiddenField);

  }

  document.body.appendChild(form);

  form.submit();

}



function fn_NewTabLink(path) {

  window.open(path,"");

}

function fn_Link(path) {
  location.href = path;
}

	function chk_logout(){
		if(confirm("로그아웃 하시겠습니까?")){
		
			var strAjaxUrl = "/Ajax/logout.asp";
			
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',			
				data: { 
				},		
				success: function(retDATA) {
					if(retDATA){
						if (retDATA=="TRUE") {
							alert("정상적으로 로그아웃 되었습니다.\n로그인 후 서비스를 이용하세요");
							$(location).attr('href','/');   //a href		
							return;						
						}
						else{
							alert('로그아웃중에 오류가 발생하였습니다.');	
							return;
						}
					}
				}, 
				error: function(xhr, status, error){						
					if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");
						return;
					} 
				}
			});
		}
		else	{
			return;
		}
	}


	function chk_logout_Admin() {
		if (confirm("로그아웃 하시겠습니까?")) {

			var strAjaxUrl = "/Ajax/AdminLogout.asp";

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
				},
				success: function (retDATA) {
					if (retDATA) {
						if (retDATA == "TRUE") {
							alert("정상적으로 로그아웃 되었습니다.\n로그인 후 서비스를 이용하세요");
							$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/main/AdminMenu/admin_Login.asp');   //a href	
							return;
						}
						else {
							alert('로그아웃중에 오류가 발생하였습니다.');
							return;
						}
					}
				},
				error: function (xhr, status, error) {
					if (error != "") {
						alert("오류발생! - 시스템관리자에게 문의하십시오!");
						return;
					}
				}
			});
		}
		else {
			return;
		}
	}


	function Checkfiles_Img(fileID) {
		var fup = document.getElementById(fileID);
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "doc" || ext == "png" || ext == "") {
			return true;
		} else {
			alert("이미지 파일만 가능 합니다.");
			fup.value = "";
			fup.focus();
			return false;
		}
	}

	function Checkfiles_Pdf(fileID) {
		var fup = document.getElementById(fileID);
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (ext == "pdf" || ext == "") {
			return true;
		} else {
			alert("PDF 파일만 가능 합니다.");
			fup.value = "";
			fup.focus();
			return false;
		}
	}

  function CheckFiles_Size(fileID)
  {
		var size= 2097152; //2MB
		var oFile = document.getElementById(fileID).files[0];
		if(oFile.size >= size){
    alert('2MB 이상 업로드 할 수 없습니다.');
    return false;
		}
  }

	//make select box
	function make_box(element, attname, code, action_type){
		var strAjaxUrl = '';    
		var fnd_EnterType = $('#fnd_EnterType').val();	
		
		switch(action_type){
			case 'AreaGb' 	: strAjaxUrl = '/Ajax/Request/Select_AreaGb.asp'; break;		//지역조회
			case 'AreaGbDt' : strAjaxUrl = '/Ajax/Request/Select_AreaGbDt.asp';	break;		//상세지역조회	
			case 'GameType' : strAjaxUrl = '/Ajax/Request/Select_GameType.asp';	break;		//경기구분조회[개인전|단체전]		
			case 'GameGroup' : strAjaxUrl = '/Ajax/Request/Select_GameGroup.asp'; break;	//경기구분조회			
			case 'GameLevel' : strAjaxUrl = '/Ajax/Request/Select_GameLevel.asp'; break;	//경기종목조회	
			case 'Info_SponType' : strAjaxUrl = '/Ajax/SponType_Select.asp'; break;			//후원사구분	
			case 'Info_SuccAsso' : strAjaxUrl = '/Ajax/SuccAsso_Select.asp'; break;			//협회정보
			case 'Info_AssoCode' : strAjaxUrl = '/Ajax/Association_Select.asp'; break;		//협회정보	
			case 'Info_Successive' : strAjaxUrl = '/Ajax/Successive_Select.asp'; break;		//역대타이틀 정보 	
			case 'Info_Country' : strAjaxUrl = '/Ajax/Country_Select.asp'; break;			//국가정보 		
			case 'Info_MajorGame' : strAjaxUrl = '/Ajax/MajorGame_Select.asp'; break;		//주요국제대회 			
			case 'Info_MajorCub' : strAjaxUrl = '/Ajax/MajorCub_Select.asp'; break;			//세계남여단체전 				
			case 'Info_Coach' : strAjaxUrl = '/Ajax/LeaderInfo_Mod_Select.asp'; break;		//코치구분
			case 'Info_KoreaTeam' : strAjaxUrl = '/Ajax/PlayerInfo_Select.asp'; break;		//대표팀구분	
			case 'Info_RefereeGb' : strAjaxUrl = '/Ajax/GameTitle_Referee_Select.asp'; break; //심판구분			
			case 'Info_PlayerNational' : strAjaxUrl = '/Ajax/PlayerInfo_National_Select.asp'; break; //내외국인구분				
			case 'RegYear_Team' : strAjaxUrl = '/Ajax/State_RegTeam_Select.asp'; break; 	//등록팀 년도 /main_HP/State_RegTeam.asp
			case 'RegYear_Player' : strAjaxUrl = '/Ajax/PlayerInfo_list_Select.asp'; break;	//등록팀 년도 /main_HP/PlayerInfo_list.asp
			case 'RegYear_Leader' : strAjaxUrl = '/Ajax/LeaderInfo_list_Select.asp'; break;	//등록팀 년도 /main_HP/LeaderInfo_list.asp					
			case 'TeamGb' : strAjaxUrl = '/Ajax/State_RegTeam_TeamGb_Select.asp'; break;	//종별 /main_HP/State_RegTeam.asp
			case 'ApprovalGb' : strAjaxUrl = '/Ajax/TeamTransfer_Select.asp'; break;	//동의서 여부 /main_HP/TeamTransfer_Write.asp	
			case 'Info_Board' 	: strAjaxUrl = '/Ajax/Select_InfoBoard.asp'; break;		//게시판 구분조회
		}
		
		//console.log(strAjaxUrl);
		
		if(strAjaxUrl){
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html', 
				async: false,				
				data: { 
					element			: element
					,attname		: attname
					,code			: code 
					,fnd_EnterType	: fnd_EnterType
				},    
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA)	$('#'+element).html(retDATA);
				}, 
				error: function(xhr, status, error){           
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}    
				}
			});	
		}
	}		


	function maxLengthCheck(object){
		if(object.value.length > object.maxLength){
			object.value = object.value.slice(0, object.maxLength);
		}  
	}

	/*
	//숫자입력체크
	function chk_Number(){
		if ((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
	}
	*/

	//숫자입력체크
	function chk_Number(event){
		event = event || window.event;
		
		var keyID = (event.which) ? event.which : event.keyCode;
		
		//console.log(keyID);
		
		if((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39) 
			return;
		else
			return event.target.value.replace(/[^0-9]/g, '');
	}

	function jXrTrim(ixStr) {
        return ixStr.replace(/(^\s*)|(\s*$)/g, "");
    }

    //Submit
    function jXrSubmit(ixObj, ixOpt, ixAct, ixTag) {
        var jVxOpt_Type;

        if(ixOpt == true){
            //UpLoad
            jVxOpt_Type = "multipart/form-data";
        }
        else{
            //Normal
            jVxOpt_Type = "application/x-www-form-urlencoded";
        }
        with(ixObj){
            action = ixAct;
            target = ixTag;
            encoding = jVxOpt_Type;
            submit();
        }
    }

	//입력값 체크
	//영문[Eng], 숫자[Digit], 영문or숫자[EngDigit]
	function chk_InputValue(obj, valType){
		var regexp = '';
		var msg = '';
		
		switch(valType){
			case "Digit"		: regexp = /[^0-9]/gi;			msg = "숫자만 입력하세요.";	break;
			case "Eng"			: regexp = /[^a-z]/gi; 			msg = "영문만 입력하세요."; break;
			case "EngDigit"		: regexp = /[^a-z0-9]/gi; 		msg = "영문 또는 숫자를 입력하세요."; break;
			case "EngSpace"		: regexp = /[^a-zA-Z\s]+$/gi; 	msg = "영문(공백포함)만 입력하세요."; break;	
			default				: regexp = /[^0-9]/gi;			msg = "숫자만 입력하세요.";
		}
		
		if(regexp.test($('#'+obj.id).val())){
			alert(msg);
			$('#'+obj.id).focus();
			$('#'+obj.id).val($('#'+obj.id).val().replace(regexp,""));
			return;
		}	
	}

	//이미지삽입 - 업로드 완료페이지에서 호출됨.
	function insertIMG2(fileNm) {

		var ivalueContents = oEditors.getById["iContents"].getIR();
		var isHTML = "<p><img src='" + global_filepathImgUrl_script + fileNm + "' border='0'></p>";

		var sHTML = ivalueContents + isHTML;
		//alert(sHTML);

		$("#iContents").text(sHTML);
		oEditors.getById["iContents"].exec("LOAD_CONTENTS_FIELD");
		//oEditors.getById["iContents"].exec("PASTE_HTML", [sHTML]);
	}

	function Checkfiles_Img1(fileID) {
		var fup = document.getElementById(fileID);
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);

		if (ext == "") {
			
		}
		else {
			//if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG") {
			if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "doc" || ext == "png" || ext == "") {
				return "Y";
			} else {
				alert("이미지 파일만 가능 합니다.");
				fup.value = "";
				//fup.focus();
				return "N";
			}
		}
	}

	function CheckFiles_Size1(fileID) {
		//var size = 5242880; //5MB
		var size = 2097152;
		var oFile = document.getElementById(fileID).files[0];

		if (oFile.size >= size) {
			alert('2MB 이상 업로드 할 수 없습니다.');
			document.getElementById(fileID).value = "";
			return "N";
		}
		else {
			return "Y";
		}

	}

	function insertMovie2(fileLink) {

		//alert(fileLink);

		var isHTML = "";

		//isHTML = '<tr>';
		//isHTML = isHTML + '	<th>링크영상<p></p>미리보기</th>';
		//isHTML = isHTML + '	<td colspan="2">';
		isHTML = isHTML + '	  <iframe width="240" height="160" src="https://www.youtube.com/embed/' + fileLink + '" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>';
		//isHTML = isHTML + '	</td>';
		//isHTML = isHTML + '</tr>';

		$('#divM1').html(isHTML);

	}

	function insertMovie3(fileLink) {

		//alert(fileLink);

		var isHTML = "";

		//isHTML = '<tr>';
		//isHTML = isHTML + '	<th>링크영상<p></p>미리보기</th>';
		//isHTML = isHTML + '	<td colspan="2">';
		isHTML = isHTML + '	  <iframe width="240" height="160" src="' + fileLink + '" allowfullscreen frameborder="0" scrolling="no"></iframe>';
		//isHTML = isHTML + '	</td>';
		//isHTML = isHTML + '</tr>';

		$('#divM1').html(isHTML);

	}