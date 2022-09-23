var px =  px || {};

px.go = function(packet,gourl){

	//if ($("form[name=sform]").length == 0){
	if( document.sfrom == undefined ){
		document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
	}

	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.action = gourl;
	document.sform.submit();
};




//뒤로가기
function goBack( pageName ) {
  var backPage;
  switch (pageName) {
    case "writing.asp" : backPage = "list.asp"; break;
    case "view.asp"    : backPage = "list.asp"; break;
    case "list.asp"    : backPage = "../center.asp"; break;
    case "center.asp"    : backPage = "../index.asp"; break;
	case "order_end.asp"    : backPage = "http://www.sdamall.co.kr/mobile/"; break;
	//case "shipping_add.asp": backPage = "shipping.asp"; break;
	case "info_modified.asp": backPage = "mypage.asp"; break; //회원정보 수정 > 마의페이지

  	//case "shipping.asp": backPage = "mypage.asp"; break; //회원정보 수정 > 마의페이지

  };

  if ( backPage ) {
    location.href = backPage;
  } else {

	   if (localStorage.getItem("history") != null)
	   {
		   var historyTmp = localStorage.getItem("history");
		   var oldhistoryarray = historyTmp.split('|');
		   if (oldhistoryarray.length == 1) {
			    history.back();
		   }
		   else if (oldhistoryarray.length == 2) {
			    if (location.href == oldhistoryarray[0] ){
					if (history.length > 1){
						history.back(-2);
					}
					else{
						history.back();
					}
				}
		   }
		   else if (oldhistoryarray.length == 3) {
			    if (location.href == oldhistoryarray[1] ){
					if (location.href == oldhistoryarray[0] ){
						if (history.length > 2){
							history.back(-3);
						}
						else{
							history.back(-2);
						}
					}
					else{
						history.back(-2);
					}
				}
				else{
					if (location.href == oldhistoryarray[0] ){
						if (history.length > 2){
							history.back(-3);
						}
						else{
							history.back(-2);
						}
					}
					else{
						history.back(-2);
					}
				}
		   }
		   else{
			    history.back();
		   }

//		   $('#lastResults').empty();
//		   for(var i =0; i<oldhistoryarray.length; i++)
//		   {
//			   //$('#lastResults').append('<p>'+oldhistoryarray[i]+'</p>');
//			   alert(oldhistoryarray[i]);
//		   }
	   }
  }
};

function head_cart_count_view()
{

  var strAjaxUrl="/pub/ajax/cart_count_view.asp";
  $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      success: function(retDATA) {
        if(retDATA)
        {
          //console.log(retDATA);
		  if (typeof cart_count_view === undefined){
          cart_count_view.innerHTML = retDATA;
          cart_count_view.style.display = "block";
		  }
		}
      }
  });
}

$(document).ready(function() {
  head_cart_count_view();
    //상품검색 엔터키 이벤트
  $("#search_key").keypress(function (e) {
    if (e.which == 13){
      if ($("#search_key").val()=="")
        {
          alert("검색어를 입력해 주세요");
          $("#search_key").focus();
          return false;
        }
      chk_search_keybord();  // 실행할 이벤트
    }
  });
});


function best_gds_view()
{
  var strAjaxUrl="/mobile/ajax/best_gds.asp";
  //alert(strAjaxUrl);

  $.ajax({
    url: strAjaxUrl,
    type: 'GET',
    dataType: 'html',
    //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
    //data: {TP:strbutton_data},
    success: function(retDATA) {
      if(retDATA)
      {
        gds_view.innerHTML = retDATA;
        gds_view.style.display = "block";
      }
    }
  });
}

function chk_search()
{
  var f = document.frm;

  if (f.search_key.value=="")
  {
    alert("검색어를 입력해 주세요");
    f.search_key.focus();
    return false;
  }

  if (document.getElementById('on-off-switch2').checked==true){

    var strAjaxUrl="/mobile/ajax/search_insert.asp";
    //alert(strAjaxUrl)

    $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
      data: {SearchNm:f.search_key.value},
      success: function(retDATA) {
        if(retDATA)
        {
          if(retDATA =='OK')
          {
            //SearchNm = f.search_key.value;
            //alert(SearchNm);
            f.target = "_self";
            f.action = "/mobile/Search/search_list.asp?search_key="+(encodeURI(f.search_key.value));
            f.submit();
          }
        }
      }
    });
  }
  else
  {
    //SearchNm = f.search_key.value;
    //alert(SearchNm);
    f.target = "_self";
    f.action = "/mobile/Search/search_list.asp?search_key="+(encodeURI(f.search_key.value));

    f.submit();
  }
}

function search_view()
{

  var strAjaxUrl="/mobile/ajax/search_view.asp";
  //alert(strAjaxUrl)

  $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
      //data: {TP:strbutton_data},
      success: function(retDATA) {

        if(retDATA)
        {
          search_view2.innerHTML = retDATA;
          search_view2.style.display = "block";
        }
      }
  });
}

function search_del(idx)
{

  var strAjaxUrl="/mobile/ajax/search_del.asp";
  //alert(strAjaxUrl)

  $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
      data: {idx:idx},
      success: function(retDATA) {
        if(retDATA)
        {
          if(retDATA =='OK')
          {
            search_view();
          }
        }
      }
  });
}

function search_all_del()
{

  var strAjaxUrl="/mobile/ajax/search_all_del.asp";
  //alert(strAjaxUrl)

  $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
      //data: {idx:idx},
      success: function(retDATA) {
        if(retDATA)
        {
          if(retDATA =='OK')
          {
            search_view();
          }
        }
      }
  });
}


//키보드 검색
function chk_search_keybord(){

  var f = document.frm;

  /*if (f.search_key.value=="")
  {
    alert("검색어를 입력해 주세요");
    f.search_key.focus();
    return false;
  }*/

  if (document.getElementById('on-off-switch2').checked==true)
  {

  var strAjaxUrl="/mobile/ajax/search_insert_mhs.asp";
  //alert(strAjaxUrl)

  $.ajax({
      url: strAjaxUrl,
      type: 'GET',
      dataType: 'html',
      //contentType:'application/x-www-form-urlencoded;charset=utf-8;',
      data: {SearchNm:f.search_key.value},
      success: function(retDATA) {

        if(retDATA)
        {
          if(retDATA =='OK')
          {
            //SearchNm = f.search_key.value;
            //alert(SearchNm);
            f.target = "_self";
            f.action = "/mobile/Search/search_list.asp?search_key="+(encodeURI(f.search_key.value));
            f.submit();
          }
        }
      }
    });
  }
  else
  {
    //SearchNm = f.search_key.value;
    //alert(SearchNm);
    f.target = "_self";
    f.action = "/mobile/Search/search_list.asp?search_key="+(encodeURI(f.search_key.value));

    f.submit();
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
var sda =  sda || {};
sda.CMD_DATAGUBUN = 10000;
sda.CMD_BASETRN = 100;
sda.CMD_CHKRETURN = 101;

sda.ajaxurl = "/pub/api/api.info_sel_addr_ok.asp";
sda.ajaxtype = "POST";
sda.dataType = "text";
sda.Send = function( sender, packet){


	var reqcmd = packet.CMD;

	$.ajax({url:sda.ajaxurl,type:sda.ajaxtype,data:packet,dataType:sda.dataType,
	success: function(returnData){
		//console.log(returnData);
		sda.Receive( packet.CMD, returnData, sender )
		}
	});
};

sda.Receive = function( reqcmd, data, sender ){
	//console.log(data);
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > sda.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
      try{jsondata = JSON.parse(data); }
      catch(ex){return;}
    }
  }
  else{//json
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

  switch (Number(reqcmd)) {
	  case sda.CMD_BASETRN: this.OnNotHistory( reqcmd, jsondata, htmldata, sender );		break;
	  case sda.CMD_CHKRETURN: this.OnReturn( reqcmd, jsondata, htmldata, sender );		break;
  }
};

///////////////////////////
//배송지관리
///////////////////////////
sda.sel_addr = function() {	//기본배송지설정
	sda.ajaxurl = "/pub/api/api.info_sel_addr_ok.asp";
	var selectvalue = $(":input:radio[name=re_seq]:checked").val();
	//console.log(selectvalue);
	if (selectvalue != undefined){
		sda.Send("shipping.asp",{"CMD":sda.CMD_BASETRN,"re_seq":selectvalue});
	}
}

sda.addr_delete = function(re_seq) { //삭제
	sda.ajaxurl = "/pub/api/api.del_addr_ok.asp";
	sda.Send("shipping.asp",{"CMD":sda.CMD_BASETRN,"re_seq":re_seq});
};

//필요하면 하자
//sda.addr_modify = function(re_seq) { //수정
//	sda.ajaxurl = "/pub/api/api.shipping_modified_ok.asp.asp";
//	sda.Send("shipping.asp",{"CMD":sda.CMD_BASETRN,"re_seq":re_seq});
//};


sda.chkSpeekEnd = function(gd_seqs) { //스피드상품 만료여부확인
	sda.ajaxurl = "/pub/api/api.speedend.asp";
	sda.Send(null,{"CMD":sda.CMD_CHKRETURN,"gd_seqs":gd_seqs});
};


//////////////////////////////////
sda.OnNotHistory =  function(cmd, packet, html, sender){
	location.replace(sender);
};

sda.OnReturn =  function(cmd, packet, html, sender){
	if (packet.SS == "END" )	{
		alert("만료된 상품이 존재합니다.");
		return;
	}
	else{
		chk_order();
	}
};





//넘겨준 페이지 히스토리 남기기 3뎁스까지만 기억하기
if (localStorage.getItem("history") != null)
{
   var historyTmp = localStorage.getItem("history");
   var oldhistoryarray = historyTmp.split('|');
   if( oldhistoryarray.length > 2 ){
	   historyTmp = oldhistoryarray[1] + "|" + oldhistoryarray[2] + "|" + location.href;
		localStorage.setItem("history",historyTmp);
   }
   else{
		historyTmp += "|"+location.href;
		localStorage.setItem("history",historyTmp);
   }
}
else
{
   var historyTmp = location.href;
   localStorage.setItem("history",historyTmp);
}
//console.log(oldhistoryarray.length + "  " +historyTmp);


// 브라우저, os 확인
var BrowserDetect = {
    init: function () {
        this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
        this.version = this.searchVersion(navigator.userAgent)
            || this.searchVersion(navigator.appVersion)
            || "an unknown version";
        this.OS = this.searchString(this.dataOS) || "an unknown OS";
    },
    searchString: function (data) {
        for (var i = 0; i < data.length; i++) {
            var dataString = data[i].string;
            var dataProp = data[i].prop;
            this.versionSearchString = data[i].versionSearch || data[i].identity;
            if (dataString) {
                if (dataString.indexOf(data[i].subString) != -1)
                    return data[i].identity;
            }
            else if (dataProp)
                return data[i].identity;
        }
    },
    searchVersion: function (dataString) {
        var index = dataString.indexOf(this.versionSearchString);
        if (index == -1) return;
        return parseFloat(dataString.substring(index + this.versionSearchString.length + 1));
    },
    dataBrowser: [
        {
            string: navigator.userAgent,
            subString: "Chrome",
            identity: "Chrome"
        },
        {
            string: navigator.userAgent,
            subString: "OmniWeb",
            versionSearch: "OmniWeb/",
            identity: "OmniWeb"
        },
        {
            string: navigator.vendor,
            subString: "Apple",
            identity: "Safari",
            versionSearch: "Version"
        },
        {
            prop: window.opera,
            identity: "Opera"
        },
        {
            string: navigator.vendor,
            subString: "iCab",
            identity: "iCab"
        },
        {
            string: navigator.vendor,
            subString: "KDE",
            identity: "Konqueror"
        },
        {
            string: navigator.userAgent,
            subString: "Firefox",
            identity: "Firefox"
        },
        {
            string: navigator.vendor,
            subString: "Camino",
            identity: "Camino"
        },
        {  // for newer Netscapes (6+)
            string: navigator.userAgent,
            subString: "Netscape",
            identity: "Netscape"
        },
        {
            string: navigator.userAgent,
            subString: "MSIE",
            identity: "Explorer",
            versionSearch: "MSIE"
        },
        {
            string: navigator.userAgent,
            subString: "Gecko",
            identity: "Mozilla",
            versionSearch: "rv"
        },
        {   // for older Netscapes (4-)
            string: navigator.userAgent,
            subString: "Mozilla",
            identity: "Netscape",
            versionSearch: "Mozilla"
        }
    ],
    dataOS: [
        {
            string: navigator.platform,
            subString: "Win",
            identity: "Windows"
        },
        {
            string: navigator.platform,
            subString: "Mac",
            identity: "Mac"
        },
        {
            string: navigator.userAgent,
            subString: "iPhone",
            identity: "iPhone/iPod"
        },
        {
            string: navigator.platform,
            subString: "Linux",
            identity: "Linux"
        }
    ]

};
BrowserDetect.init();
// console.log(BrowserDetect.browser); // 브라우저 종류
// console.log(BrowserDetect.version); // 브라우저 버전
// console.log(BrowserDetect.OS); // 운영체제 종류

// 숫자입력 확인  html 형식 type="tel"  pattern="[0-9]*"
function checkValue (limit) {
  var browser = BrowserDetect.browser;
  var replaceNum = 0;
  var targetValue = "";

  if (browser == "Safari") {
    targetValue = this.target.value;
    eventKey = this.target.value;
  } else {
    targetValue = event.path[0].value;
    eventKey = event.key;
  };

  replaceNum = targetValue.length - 1;

  if (targetValue.indexOf('#') >= 0) {
    if (browser == "Safari") {
      this.target.value = targetValue.replace('#', '');
    } else {
      event.path[0].value = targetValue.replace('#', '');
    }
  }

  if (targetValue.indexOf('*') >= 0) {
    if (browser == "Safari") {
      this.target.value = targetValue.replace('*', '');
    } else {
      event.path[0].value = targetValue.replace('*', '');
    }
  }

  if (targetValue.length > limit || eventKey == "Unidentified") {
    if (browser == "Safari") {
      this.target.value = targetValue.replace(targetValue[replaceNum], "");
    } else {
      event.path[0].value = targetValue.replace(targetValue[replaceNum], "");
    }
  }
}
