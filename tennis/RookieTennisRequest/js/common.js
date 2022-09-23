var global_filepathUrl_ADIMG_script = "/ADImgR/tennis/";

function fn_mclicklink(igb, ilnk) {

	if (igb == "2") {

		if (ilnk == "") {
			return;
		}
		else {

			var varUA = navigator.userAgent.toLowerCase();

			if (varUA.indexOf("iphone") > -1 || varUA.indexOf("ipad") > -1 || varUA.indexOf("ipod") > -1) {

				alert('sportsdiary://urlblank=' + ilnk);

			}
			else {

				//서버페이지에서 한번 걸러서 여긴 실행 안됌

			}

		}

	}
	else {

		if (ilnk == "") {
			return;
		}
		else {
			window.location.href = ilnk;
		}

	}

}

//var fn_ADLOG_Result = "";
function fn_ADLOG(isportsgb, iproductlocateidx, iuserid, imemberidx) {

	var strAjaxUrl = "./Ajax/ADLOG.asp";
	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',
		data: {
			isportsgb: isportsgb,
			iproductlocateidx: iproductlocateidx,
			iuserid: iuserid,
			imemberidx: imemberidx
		},
		//async: false,
		success: function (retDATA) {
			//alert(retDATA);
			if (retDATA == "OK") {
	
				//alert('isportsgb : ' + isportsgb + ' , ilocateidx : ' + ilocateidx + ' , iuserid : ' + iuserid + ' , imemberidx : ' + imemberidx);
	
			} else {
				return;
			}
		}, error: function (xhr, status, error) {
			if (error != "") {
				alert("ADLOG, 오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
		}
	});

	//alert('isportsgb : ' + isportsgb + ' , iproductlocateidx : ' + iproductlocateidx + ' , iuserid : ' + iuserid + ' , imemberidx : ' + imemberidx);

}


// //쿠키정보 저장
// function setCookie (name, value, expires, domain) {
//   var todayDate = new Date();
// //  document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
//   document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + "; domain="+domain+";";
// }
// // 쿠키 가져오기
// function getCookie(cName) {
//   cName = cName + '=';
//
//   var cookieData = document.cookie;
//   var start = cookieData.indexOf(cName);
//   var cValue = '';
//
//   if(start != -1){
//     start += cName.length;
//
//     var end = cookieData.indexOf(';', start);
//
//     if(end == -1)end = cookieData.length;
//
//     cValue = cookieData.substring(start, end);
//   }
//   return unescape(cValue);
// }

//전화걸기
function callNumber(num){
  location.href="tel:"+num;
}

/*
 사용법
 onclick="post_to_url('./Post_formget.asp', {'test':'ming'});"
 params : 전송 데이터 {'q':'a','s':'b','c':'d'...}으로 묶어서 배열 입력
 method : 전송 방식(생략가능)
*/
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

// =====================================
