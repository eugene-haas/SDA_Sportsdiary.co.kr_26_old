/*	
//입력값 체크
//영문[Eng], 숫자[Digit], 영문or숫자[EngDigit]
function chk_InputValue(obj, valType){
    var regexp = '';
    var msg = '';

    switch(valType){
        case 'Digit'		: regexp = /[^0-9]/gi;			msg = '숫자만 입력하세요.';	break;
        case 'Eng'			: regexp = /[^a-zA-Z]/gi; 		msg = '영문만 입력하세요.'; break;
        case 'EngSpace'		: regexp = /[^a-zA-Z\s]+$/gi; 	msg = '영문(공백포함)만 입력하세요.'; break;
        case 'EngDigit'		: regexp = /[^a-z0-9]/gi; 		msg = '영문 또는 숫자를 입력하세요.'; break;
        default				: regexp = /[^0-9]/gi;			msg = '숫자만 입력하세요.';
    }

    if(regexp.test($('#'+obj.id).val())){
        alert(msg);
        $('#'+obj.id).focus();
        $('#'+obj.id).val($('#'+obj.id).val().replace(regexp,''));
        return;
    }	
}

function maxLengthCheck(object){
    if(object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }    
}
    
*/

//전화걸기
function callNumber(num){
	location.href='tel:'+num;
}

function post_to_url(path, params, method) {

  method = method || "post"; //method 부분은 입력안하면 자동으로 post가 된다.

  var form = document.createElement("form");

  form.setAttribute("method", method);

  form.setAttribute("action", path);

  console.log(params);

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
