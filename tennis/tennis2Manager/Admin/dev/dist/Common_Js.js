/* File Created: 7월 14, 2017 */

/* 
사용법
onclick="post_to_url('./Post_formget.asp', {'test':'ming'});"  
params : 전송 데이터 {'q':'a','s':'b','c':'d'...}으로 묶어서 배열 입력
method : 전송 방식(생략가능)
*/

var global_filepathUrl_script = "/FileDown/";
var global_filepathImgUrl_script = "/FileImg/";

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


function fn_NewTabLink(path) {

  window.open(path,"");

}

function fn_Link(path) {
  location.href = path;
}

function chk_logout() {
	if (confirm("로그아웃 하시겠습니까?")) {

		var strAjaxUrl = "/Ajax/logout.asp";

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
						$(location).attr('href', '/');   //a href		
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


function chk_logout_Admin() {
	if (confirm("로그아웃 하시겠습니까?")) {

		var strAjaxUrl = "./Ajax/AdminLogout.asp";

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
						$(location).attr('href', 'http://tennisadmin.sportsdiary.co.kr/admin/main/admin_Login.asp');   //a href	
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

function chk_logout_Admin1() {

	var strAjaxUrl = "./Ajax/AdminLogout.asp";

	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',
		data: {
		},
		success: function (retDATA) {
			if (retDATA) {
				if (retDATA == "TRUE") {
					alert("정상적인 접근이 아닙니다.\n로그아웃 되었습니다.");
					$(location).attr('href', 'http://tennisadmin.sportsdiary.co.kr/admin/main/admin_Login.asp');   //a href	
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

function Checkfiles_Img1(fileID) {
	var fup = document.getElementById(fileID);
	var fileName = fup.value;
	var ext = fileName.substring(fileName.lastIndexOf('.') + 1);

	if (ext == "") {

	}
	else {
		if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG") {
			return "Y";
		} else {
			alert("GIF, JPG 파일만 가능 합니다.");
			fup.value = "";
			//fup.focus();
			return "N";
		}
	}
}

function Checkfiles_Img2(fileID) {
	var fup = document.getElementById(fileID);
	var fileName = fup.value;
	var ext = fileName.substring(fileName.lastIndexOf('.') + 1);

	if (ext == "") {

	}
	else {
		if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG") {
			return "Y";
		} else {
			alert("GIF, JPG, PNG 파일만 가능 합니다.");
			fup.value = "";
			//fup.focus();
			return "N";
		}
	}
}

function CheckFiles_Size1(fileID) {
	var size = 5242880; //5MB
	var oFile = document.getElementById(fileID).files[0];
	if (oFile.size >= size) {
		alert('5MB 이상 업로드 할 수 없습니다.');
		document.getElementById(fileID).value = "";
		return "N";
	}
}

function CheckFiles_Size2(fileID) {
	var size = 20971520; //20MB
	var oFile = document.getElementById(fileID).files[0];
	if (oFile.size >= size) {
		alert('20MB 이상 업로드 할 수 없습니다.');
		document.getElementById(fileID).value = "";
		return "N";
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

function CheckFiles_Size(fileID) {
	var size = 2097152; //2MB
	var oFile = document.getElementById(fileID).files[0];
	if (oFile.size >= size) {
		alert('2MB 이상 업로드 할 수 없습니다.');
		return false;
	}
}

function Checkfiles_Img3(fileID) {
	var fup = document.getElementById(fileID);
	var fileName = fup.value;
	var ext = fileName.substring(fileName.lastIndexOf('.') + 1);

	if (ext == "") {

	}
	else {
		if (ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG") {

			var CS3 = CheckFiles_Size3(fileID);
			if (CS3 == "Y") {
				return "Y";
			}
			else {
				return CS3;
			}
		} else {
			alert("GIF, JPG 파일만 가능 합니다.");
			fup.value = "";
			//fup.focus();
			return "N";
		}
	}
}

function CheckFiles_Size3(fileID) {
	var size = 5242880; //5MB
	var oFile = document.getElementById(fileID).files[0];
	if (oFile.size >= size) {
		alert('5MB 이상 업로드 할 수 없습니다.');
		document.getElementById(fileID).value = "";
		return "N";
	}
}

function CheckFileExtNm(fileID) {
	var fup = document.getElementById(fileID);
	var fileName = fup.value;
	var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
	return ext;
}

  //maxlength 체크
function maxLengthCheck(object) {
	if (object.value.length > object.maxLength) {
		object.value = object.value.slice(0, object.maxLength);
	}
}

  //입력값 체크
  //영문[Eng], 숫자[Digit], 영문or숫자[EngDigit]
function chk_InputValue(obj, valType) {
	var regexp = '';
	var msg = '';

	switch (valType) {
		case "Digit": regexp = /[^0-9]/gi; msg = "숫자만 입력하세요."; break;
		case "Eng": regexp = /[^a-z]/gi; msg = "영문만 입력하세요."; break;
		case "EngDigit": regexp = /[^a-z0-9]/gi; msg = "영문 또는 숫자를 입력하세요."; break;
		default: regexp = /[^0-9]/gi; msg = "숫자만 입력하세요.";
	}

	if (regexp.test($('#' + obj.id).val())) {
		alert(msg);
		$('#' + obj.id).focus();
		$('#' + obj.id).val($('#' + obj.id).val().replace(regexp, ""));
		return;
	}
}

  //이미지삽입 - 업로드 완료페이지에서 호출됨.
function insertIMG1(fileID) {
	var fup = document.getElementById(fileID);
	var fileName = fup.value;
	var rfileName = fileName.substring(fileName.lastIndexOf('\\') + 1);

	var ivalueContents = oEditors.getById["iContents"].getIR();
	var isHTML = "<p><img src='" + global_filepathImgUrl_script + rfileName + "'></p>";

	var sHTML = ivalueContents + isHTML;
	//alert(sHTML);

	$("#iContents").text(sHTML);
	oEditors.getById["iContents"].exec("LOAD_CONTENTS_FIELD");
	//oEditors.getById["iContents"].exec("PASTE_HTML", [sHTML]);
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

function insertMovie(fileNm1) {

	var ivalueContents = oEditors.getById["iContents"].getIR();
	//var isHTML = "<p><img src='" + global_filepathImgUrl_script + fileNm + "' border='0'></p>";
	var isHTML = "<p><iframe width='240' height='160' src='https://www.youtube.com/embed/" + fileNm1 + "' frameborder='0' gesture='media' allow='encrypted-media' allowfullscreen></iframe></p>"
	//var isHTML = "<p><iframe>test</iframe></p>";
	var sHTML = ivalueContents + isHTML;

	$("#iContents").text(sHTML);
	oEditors.getById["iContents"].exec("LOAD_CONTENTS_FIELD");
	//oEditors.getById["iContents"].exec("PASTE_HTML", [isHTML]);

	alert(oEditors.getById["iContents"].getIR());

}

function showHTML() {
	var sHTML = oEditors.getById["iContents"].getIR();
	alert(sHTML);
}


  //회원프로필 첨부이미지 미리보기  
function readURL(input) {
	if (input.files && input.files[0]) {

		//파일을 읽기 위한 FileReader객체 생성
		var reader = new FileReader();

		reader.onload = function (e) {

			//파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
			$('#blah').attr('src', e.target.result);
			$('#blah1').attr('value', e.target.result);

			$('#hddis').css('display', 'block');

			//test2 = $('#blah1').val();
			//alert(atob(test2));

			//이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
			//(아래 코드에서 읽어들인 dataURL형식)


			// Math.ceil - 1에서 1000까지
			// Math.round - 0에서 1000까지
			//var val = Math.ceil(Math.random() * 1000);

			//$('#imgNumber').text('##image' + val);
		}

		//File내용을 읽어 dataURL형식의 문자열로 저장
		reader.readAsDataURL(input.files[0]);

	}
}