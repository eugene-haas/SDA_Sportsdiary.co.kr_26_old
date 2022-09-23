var global_filepathUrl_script = "/File/FileDown/";
var global_filepathImgUrl_script = "/File/FileImg/";
var global_filepathUrl_ADIMG_script = "/ADImgR/tennis/";

var global_SSUrl_script = "http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/";
var global_SSUrl_TN_script = "http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_";

//숫자입력체크
function chk_Number(event) {
	event = event || window.event;

	var keyID = (event.which) ? event.which : event.keyCode;

	console.log(keyID);

	if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
		return;
	else
		return event.target.value.replace(/[^0-9]/g, "");
}
/*
//숫자입력체크
function chk_Number(){
  if ((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;
}
*/

function chk_logout(){
	if(confirm('로그아웃 하시겠습니까?')){
		/*
		var expdate = new Date();
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건

		setCookie('SportsGb', '', expdate, '.sportsdiary.co.kr');
		setCookie('sd_saveid', '', expdate, '.sportsdiary.co.kr');
		setCookie('sd_savepass', '', expdate, '.sportsdiary.co.kr');
		*/

		$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/logout.asp');

	}
	else{
		return;
	}
}

/*Select Box 생성*/
function make_box(element,attname,code,action_type){

  //alert(action_type)
  if(action_type=="TeamGb"){
    var strAjaxUrl = "../Select/TeamGb_Select.asp";
  }
  else if(action_type=="AreaGb"){
    var strAjaxUrl = "../Select/AreaGb_Select.asp";
  }
  else if(action_type=="TeamCode"){
    var strAjaxUrl = "../Select/TeamCode_Select.asp";
    //make_box("sel_TeamCode","TeamCode",inputdata,"TeamCode")
  }
  else if(action_type=="Join_TeamGb"){
    var strAjaxUrl = "../Select/Join_TeamGb_Select.asp";
  }
  else if(action_type=="Join_AreaGb"){
    var strAjaxUrl = "../Select/Join_AreaGb_Select.asp";
  }
  else if(action_type=="Join_TeamCode"){
      var strAjaxUrl = "../Select/Join_TeamCode_Select.asp";
    //make_box("sel_TeamCode","TeamCode",inputdata,"TeamCode")
  }

  //선수체급조회(회원가입 EnterType=E)
  else if(action_type=="Join_PlayerLevel"){
      var strAjaxUrl = "../Select/Join_PlayerLevel_Select.asp";
    var SEX = $('input:radio[name="SEX"]:checked').val();
    var TeamGb = $("#TeamGb").val();
  }

  //생활체육 선수 체급조회(회원가입 EnterType=A)
  else if(action_type=="Join_PlayerLevel_A"){
      var strAjaxUrl = "../Select/Join_PlayerLevel_Select_A.asp";
    var SEX = $('input:radio[name="SEX"]:checked').val();
    var TeamGb = $("#TeamGb").val();
    var EnterType = $("#EnterType").val();
  }

  //선수체급조회(myinfo.asp EnterType=E)
  else if(action_type=="myinfo_PlayerLevel"){
      var strAjaxUrl = "../Select/myinfo_PlayerLevel_Select.asp";
    var SEX = $('#SEX').val();
    var TeamGb = $("#TeamGb").val();
  }

  //생활체육 선수체급조회(myinfo_type2.asp)
  else if(action_type=="myinfo_PlayerLevel_A"){
      var strAjaxUrl = "../Select/myinfo_PlayerLevel_Select_A.asp";
    var SEX = $('#SEX').val();
    var TeamGb = $("#TeamGb").val();
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //생활체육 지역조회
  else if(action_type=="Join_AreaGb_A"){
    var strAjaxUrl = "../Select/Join_AreaGb_Select_A.asp";
  }

  //생활체육 상세지역조회
  else if(action_type=="Join_AreaGbDt_A"){
    var strAjaxUrl = "../Select/Join_AreaGbDt_Select_A.asp";
  }

  //생활체육 팀소속조회
  else if(action_type=="Join_TeamCode_A"){
      var strAjaxUrl = "../Select/Join_TeamCode_Select_A.asp";
    var EnterType = $("#EnterType").val();
    }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //소속팀 변경
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //생활체육 지역조회(myinfo.asp)
  else if(action_type=="myinfo_AreaGb_CA"){
    var strAjaxUrl = "../Select/myinfo_AreaGb_Select_A.asp";
  }

  //생활체육 상세지역조회(myinfo.asp)
  else if(action_type=="myinfo_AreaGbDt_CA"){
    var strAjaxUrl = "../Select/myinfo_AreaGbDt_Select_A.asp";
  }
  //생활체육(main/join4_type5.asp)
  //사용손, 백핸드타입, 복식리턴포지션 select
  else if(action_type=="Join_HandUse" || action_type=="Join_HandType" || action_type=="Join_PositionReturn"){
      var strAjaxUrl = "../Select/join4_type5_select.asp";
  }
  //생활체육 팀소속조회(myinfo.asp)
  else if(action_type=="myinfo_TeamCode_CA"){
      var strAjaxUrl = "../Select/myinfo_TeamCode_Select_A.asp";
    }

  else if(action_type=="myinfo_TeamGb_CE"){
    var strAjaxUrl = "../Select/myinfo_TeamGb_Select.asp";
  }
  else if(action_type=="myinfo_AreaGb_CE"){
    var strAjaxUrl = "../Select/myinfo_AreaGb_Select.asp";
  }
  else if(action_type=="myinfo_TeamCode_CE"){
      var strAjaxUrl = "../Select/myinfo_TeamCode_Select.asp";
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //국가대표 팀조회(join2.asp, myinfo.asp)
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  else if(action_type=="Join_TeamCode_K"){
      var strAjaxUrl = "../Select/Join_TeamCode_Select_K.asp";
    var EnterType = $("#EnterType").val();
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  else if (action_type == "train_Code") {
        var strAjaxUrl = "../Select/train_Select.asp";
    }
  else if (action_type == "PPUB_Code") {
        var strAjaxUrl = "../Select/Pub_Select.asp";
    }
  else if (action_type == "StimFistCd") {
        var strAjaxUrl = "../Select/Strength_FistInfo.asp";
  }
  else if (action_type == "Info_MapGb") {
        var strAjaxUrl = "../Select/Info_Map_Select.asp";
    }
  else{
  }


  $.ajax({
    url: strAjaxUrl,
    type: 'POST',
    dataType: 'html',
    data: {
      element   : element
      ,attname  : attname
      ,code   : code
      ,SEX    : SEX
      ,TeamGb   : TeamGb
      ,EnterType  : EnterType   //회원구분[E:엘리트 | A:생활체육 | K:국가대표]
    },
    success: function(retDATA) {

      //console.log(retDATA);

      if(retDATA){
        $("#"+element).html(retDATA);
      }

      if (retDATA == null) {
        //조회종료 효과
        alert ("조회 데이타가 없습니다!");
        return;
      }
    },
    error: function(xhr, status, error){
      //조회종료 효과
      //parent.fBottom.popupClose("","","");
      if(error !=''){
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        setseq = "";
        return;
      }
    }
  });
}

function fn_mclicklink(igb, ilnk) {

	if (igb == "2") {

		if (ilnk == "") {

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

		}
		else {
			window.location.href = ilnk;
		}

	}

}

//var fn_ADLOG_Result = "";
function fn_ADLOG(isportsgb, iproductlocateidx, iuserid, imemberidx) {

	var strAjaxUrl = "../Ajax/ADLOG.asp";
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

			}
		}, error: function (xhr, status, error) {
			if (error != "") {
				alert("ADLOG, 오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
		}
	});

	//alert('isportsgb : ' + isportsgb + ' , ilocateidx : ' + ilocateidx + ' , iuserid : ' + iuserid + ' , imemberidx : ' + imemberidx);

}

function chk_logout(){
	if(confirm('로그아웃 하시겠습니까?')){
		/*
		var expdate = new Date();
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건

		setCookie('SportsGb', '', expdate, '.sportsdiary.co.kr');
		setCookie('sd_saveid', '', expdate, '.sportsdiary.co.kr');
		setCookie('sd_savepass', '', expdate, '.sportsdiary.co.kr');
		*/

		$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/logout.asp');

	}
	else{
		return;
	}
}
/*
  function chk_logout(){
    var expdate = new Date();

    if(confirm("로그아웃 하시겠습니까?")){
      expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
      setCookie("sd_saveid", "", expdate, ".sportsdiary.co.kr");
      setCookie("sd_savepass", "", expdate, ".sportsdiary.co.kr");

      var strAjaxUrl = "../../../sdmain/Ajax/logout.asp";

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

              //$(location).attr('replace','../Main/login.asp');   //a href
              window.location.replace("../../../sdmain/login.asp");

            }else{
              alert('로그아웃중에 오류가 발생하였습니다.');
              return;
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
    else{
      return;
    }
  }
*/



// =====================================
function autoHypenPhone(str,elem){
  str = str.replace(/[^0-9]/g, '');
  var tmp = '';
  var f = document.getElementById(elem);
  if( str.length < 4){
    f.value =  str;
  }else if(str.length < 7){
    tmp += str.substr(0, 3);
    tmp += '-';
    tmp += str.substr(3);
    f.value =  tmp;
  }else if(str.length < 11){
    tmp += str.substr(0, 3);
    tmp += '-';
    tmp += str.substr(3, 3);
    tmp += '-';
    tmp += str.substr(6);
    f.value =  tmp;
  }else{
    tmp += str.substr(0, 3);
    tmp += '-';
    tmp += str.substr(3, 4);
    tmp += '-';
    tmp += str.substr(7);
    f.value =  tmp;
  }
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

function fn_OSCHK(){

	var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기

	if (varUA.match('android') != null) {
		return "AND";
	} else if (varUA.indexOf("iphone") > -1 || varUA.indexOf("ipad") > -1 || varUA.indexOf("ipod") > -1) {

		return "IOS";

	} else {

		return "OTH";

	}
}
// =====================================
