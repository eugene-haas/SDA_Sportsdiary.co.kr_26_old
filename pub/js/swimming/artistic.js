var mn =  mn || {};

mn.CMD_DATAGUBUN = 10000;

//메뉴관리
mn.CMD_MENU_WFORM = 50000;
mn.CMD_MENU_WOK = 50001;
mn.CMD_INSERTDEP1 = 50002; //대분류선택
mn.CMD_SHOPMEMBER = 51000;


mn.CMD_BTNST = 210; //버튼상태변경
mn.CMD_CNGTXT = 220; //텍스트 변경
mn.CMD_ADMIN_WOK = 230; //관리자등록
mn.CMD_ADMIN_EOK = 240; //'관리자수정
mn.CMD_DELMENU = 250; //삭제



mn.ajaxurl = "/pub/ajax/swimming/reqAdmin.asp";
console.log(mn.ajaxurl);
mn.ajaxtype = "POST";
mn.dataType = "text";

mn.SendEx = function( sender, packet, urlAjax){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:urlAjax,type:mn.ajaxtype,data:strdata,dataType:mn.dataType,
	success: function(returnData){
		//console.log(returnData);
		mn.Receive( packet.CMD, returnData, sender )
		}
	});
};

mn.Receive = function( reqcmd, data, sender ){
	//console.log(data);
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > mn.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
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
            case 2: alert('중복 데이터가 존재합니다.');return;  break;
            case 5: alert('대메뉴와 중메뉴를 먼저 선택해주십시오.');return;  break;
            case 100: return;   break; //메시지 없슴
		}
  }

    switch (Number(reqcmd)) {
		case mn.CMD_SHOPMEMBER :
		case mn.CMD_MENU_WFORM: this.OnwritePop( reqcmd, jsondata, htmldata, sender );		break;
        case mn.CMD_MENU_WOK:
		case mn.CMD_INSERTDEP1: this.OnDrawHTML( reqcmd, jsondata, htmldata, sender );		break;
        case mn.CMD_BTNST: this.OnToggleBtn( reqcmd, jsondata, htmldata, sender );		break;
        case mn.CMD_CNGTXT: this.OnChangeValue( reqcmd, jsondata, htmldata, sender );		break;
        case mn.CMD_DELMENU:
		case mn.CMD_ADMIN_EOK:
		case mn.CMD_ADMIN_WOK: location.reload();		break;
	}
};

///////////////////////////
//요청					      //
///////////////////////////
mn.Search = function(packet, f1,f2){
	packet.F1 = f1;
	packet.F2 = f2;
	mn.SendEx('modalS',packet,mn.ajaxurl);
};


//생성 팝업창 요청
mn.shopMemberInfo = function(sender,formno,seq) {
	var obj = {};
    obj.CMD = mn.CMD_SHOPMEMBER;
	obj.FORMNO = formno;
	obj.SEQ = seq;
    mn.SendEx(sender,obj,mn.ajaxurl);
};



//생성 팝업창 요청
mn.writePop = function(sender,formno,seq) {
	var obj = {};
    obj.CMD = mn.CMD_MENU_WFORM;
	obj.FORMNO = formno;
	obj.SEQ = seq;
    mn.SendEx(sender,obj,mn.ajaxurl);
};

//생성 메뉴선택
mn.SelectDEP = function(depno, selectid, drowid , cmd) {
  var GbVal = $("#" + selectid).val();

  var obj = {};
  obj.CMD = cmd;
  obj.DEPNO = depno;
  obj.DPTYPE = GbVal;
  obj.DEP1 = $("#dep01").val();
  obj.DEP2 = $("#dep02").val();
  obj.DEP3 = $("#dep03").val();
  obj.NMURL = $("#nm_url").val();
  obj.ACLASS = $("#ad_class").val();

  if(GbVal == "insert" ) {
		var GbPrompt = prompt("메뉴명을 입력해주세요",'');
		if(GbPrompt != null && GbPrompt != "") {
		  obj.DEPNM = GbPrompt;
		  mn.SendEx(drowid,obj,mn.ajaxurl);
		}
		else{
			if (depno == 1 ){
				$('#dep02 option')[0].text = '=중메뉴 (대분류선택 후 활성화)=';
				$('#dep02 option')[0].selected = true;
				$( '#dep02' ).attr( 'disabled', true );

			    $( '#dep03' ).attr( 'placeholder', '중 메뉴 활성화 후 입력' );
				$( '#dep03' ).attr( 'disabled', true );
			}
			if (depno == 2){
			    $( '#dep03' ).attr( 'placeholder', '중 메뉴 활성화 후 입력' );
				$( '#dep02' ).attr( 'disabled', true );
				$( '#dep03' ).attr( 'disabled', true );
			}
		}
  }
  else{
	  obj.DEPNM = GbVal;
	  mn.SendEx(drowid,obj,mn.ajaxurl);
  }
};


mn.writeOK = function(depno, selectid, drowid , cmd) {

  var obj = {};
  obj.CMD = cmd;
  obj.DEPNO = depno;

  obj.DEP1 = $("#dep01").val();
	if (obj.DEP1 == ''){
		alert("대메뉴를 선택해주십시오.");
		 $( "#dep01" ).focus();
		return;
	}
  obj.DEP2 = $("#dep02").val();
	if (obj.DEP2 == ''){
		alert("중메뉴를 선택해주십시오.");
		 $( "#dep02" ).focus();
		return;
	}
  obj.DEP3 = $("#dep03").val();
	if (obj.DEP3 == ''){
		alert("소메뉴를 입력해 주십시오.");
		 $( "#dep03" ).focus();
		return;
	}
  obj.NMURL = $("#nm_url").val();
	if (obj.NMURL == ''){
		alert("메뉴 경로를  입력해 주십시오.");
		 $( "#nm_url" ).focus();
		return;
	}

  obj.ACLASS = $("#ad_class").val();
	if (obj.ACLASS == ''){
		alert("등급을 선택해 주십시오.");
		 $( "#ad_class" ).focus();
		return;
	}
  mn.SendEx(drowid,obj,mn.ajaxurl);
};

mn.delLine = function(sender, seq, btnno){
  if (confirm("삭제 하시겠습니까?")) {
	  var obj = {};
	  obj.CMD = mn.CMD_DELMENU;
	  obj.SEQ = seq;
	  obj.BTNTYPENO = btnno;
	  mn.SendEx(sender,obj,mn.ajaxurl);
  }
  else{
	return;
  }
}


mn.adminWriteOK = function(cmd) {

  var obj = {};
  obj.CMD = cmd;

  obj.AID = $("#ad_id").val();
	if (obj.AID == ''){
		alert("아이디를 입력해주십시오.");
		 $( "#ad_id" ).focus();
		return;
	}
  obj.APWD = $("#ad_pwd").val();
	if (obj.APWD == ''){
		alert("패스워드를 입력해 주십시오.");
		 $( "#ad_pwd" ).focus();
		return;
	}
  obj.ANAME = $("#ad_name").val();
	if (obj.ANAME == ''){
		alert("이름을  입력해 주십시오.");
		 $( "#ad_name" ).focus();
		return;
	}
  obj.ACLASS = $("#ad_class").val();
	if (obj.ACLASS == ''){
		alert("등급을 선택해 주십시오.");
		 $( "#ad_class" ).focus();
		return;
	}

	var chkval='';
	$("input[name=ad_name]:checked").each(
		function() {
			if (chkval == ''){
				chkval =  $(this).val();
			}
			else{
				chkval = chkval + "," + $(this).val();
			}
		}
	);
  obj.KIND_CODE = "F2";
  obj.CHKMNIDXARR = chkval;
  mn.SendEx(null,obj,mn.ajaxurl);
};


mn.adminEditOK = function(cmd,seq) {

  var obj = {};
  obj.CMD = cmd;
  obj.SEQ = seq;

  obj.AID = $("#ad_id").val();
	if (obj.AID == ''){
		alert("아이디를 입력해주십시오.");
		 $( "#ad_id" ).focus();
		return;
	}
  obj.APWD = $("#ad_pwd").val();
	if (obj.APWD == ''){
		alert("패스워드를 입력해 주십시오.");
		 $( "#ad_pwd" ).focus();
		return;
	}
  obj.ANAME = $("#ad_name").val();
	if (obj.ANAME == ''){
		alert("이름을  입력해 주십시오.");
		 $( "#ad_name" ).focus();
		return;
	}
  obj.ACLASS = $("#ad_class").val();
	if (obj.ACLASS == ''){
		alert("등급을 선택해 주십시오.");
		 $( "#ad_class" ).focus();
		return;
	}

	var chkval='';
	$("input[name=ad_name]:checked").each(
		function() {
			if (chkval == ''){
				chkval =  $(this).val();
			}
			else{
				chkval = chkval + "," + $(this).val();
			}
		}
	);
  obj.KIND_CODE = "F2";
  obj.CHKMNIDXARR = chkval;
  mn.SendEx(null,obj,mn.ajaxurl);
};


//버튼상태변경
mn.setBtnState = function(sender,seq,svalue,btntypeno) {
    var obj = {};
    obj.CMD = mn.CMD_BTNST;
    obj.SEQ = seq;
    obj.SVAL = svalue;
	obj.BTNTYPENO = btntypeno;
    mn.SendEx(sender,obj,mn.ajaxurl);
};


mn.setTXT = function(sender,seq,svalue,txttypeno) {
    var obj = {};
    obj.CMD = mn.CMD_CNGTXT;
    obj.SEQ = seq;
    obj.SVAL = svalue;
	obj.BTNTYPENO = txttypeno;
    mn.SendEx(sender,obj,mn.ajaxurl);
};

///////////////////////////
//응답					      //
///////////////////////////
mn.OnwritePop =  function(cmd, packet, html, sender){
	if( $('#' + sender).length == 0 ){
		$('body').append("<div class='modal fade basic-modal myModal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>");
	}
	$('#' + sender).html(html);
	$('#' + sender).modal('show');
};


mn.OnDrawHTML =  function(cmd, packet, html, sender){
	$('#' + sender).html(html);
};


mn.OnToggleBtn =  function(cmd, packet, html, sender){
	console.log(cmd, packet, html, sender)
	if($('#'+sender).hasClass('btn-warning')){

		$('#'+sender)[0].className = 'btn btn-fix-sm btn-primary';
		$('#'+sender).html('Y');

	}
	else{

		$('#'+sender)[0].className = 'btn btn-fix-sm btn-warning';
		$('#'+sender).html('N');
	}
};


mn.OnChangeValue =  function(cmd, packet, html, sender){
	//모든 박스 초기화
	$('.table-box table tr td input' ).css('border-color', '');

	var colorCode = "#" + Math.round(Math.random() * 0xffffff).toString(16);
	$('#' + sender).css('border-color', colorCode);
};
