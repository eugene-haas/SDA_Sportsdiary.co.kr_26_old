function decodeUTF8(str){return decodeURIComponent(str);}
function encodeUTF8(str){return encodeURIComponent(str);}	

var mx =  mx || {};
mx.CMD_TABLECMT	 =	1; //코멘트 인서트, 업데이트
mx.CMD_COLUMNCMT	 =	2; //코멘트 인서트, 업데이트
mx.CMD_LOGIN = 3; //로그인

mx.CMD_BOARDWRITEOK = 500;



mx.CMD_DATAGUBUN = 10000;
mx.CMD_TABLECLUMN = 10002;
mx.CMD_TABLELIST = 10004;

mx.CMD_A6 = 6; //테이블 복사


mx.CMD_L = 100;
mx.CMD_W = 20000;
mx.CMD_WIMG = 20001;


mx.CMD_FINDYEAR = 21000;
mx.CMD_FINDLEVELNO = 21001;

mx.CMD_DELIMG = 200;
mx.CMD_PUBSHOW = 300;
mx.CMD_DELBBS = 400; //게시물삭제

////////////////////////////////////////
mx.IsHttpSuccess = function( r ){
	try{
		return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
	}
	catch(e){}
	return false;
};

mx.HttpData = function( r, type ){
	var ct = r.getResponseHeader( "Content-Type" );
	var data = !type && ct && ct.indexOf( "xml" ) >=0;
	data = type == "xml" || data ? r.responseXML : r.responseText;
	if( type == "script" ){
		eval.call( "window", data );
	}
	else if( type == "mix" ){
		if ( data.indexOf("$$$$") !== -1 ){
			var mixdata = data.split( "$$$$" );
			( function () { eval.call("window", mixdata[0]); } () );
			data = mixdata[1];
		}
	}
	return data;
};

mx.ajaxurl = "/pub/ajax/bike/reqBBS.asp"; 
mx.SendPacket = function( sender, packet){

	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = mx.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	setTimeout( function(){ reqdone = true; }, timeout );

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
				mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
    console.log(JSON.stringify( packet  ) );	
	xhr.send( strdata );
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
	var rsp = null;
	var callback = null;
	var jsondata = null;
	var htmldata = null;
	var resdata = null;

	
	if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
		htmldata = data;
	}
	else{
		if(typeof data == 'string'){jsondata = JSON.parse(data);}
		else{jsondata = data;}
	}

	if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_W:	this.OndrowEditor( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_WIMG:	this.OndrowImgEditor( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_FINDYEAR:
	case mx.CMD_FINDLEVELNO:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_DELIMG: mx.bbsEditor(mx.CMD_WIMG, jsondata, jsondata.pg); break;
	case mx.CMD_DELBBS: alert('삭제후 리스트로갈수 있게 코딩'); break;
	case mx.CMD_PUBSHOW : mx.goPageBBS(jsondata.pg); break;
	}
};


mx.OndrowEditor =  function(cmd, packet, html, sender){
	$('#bbslist').hide();
	document.getElementById(sender).innerHTML = html;
	CKEDITOR.replace( 'bikeeditor' );
	$('#bbseditor').show();
};

mx.OndrowImgEditor =  function(cmd, packet, html, sender){
	$('#bbslist').hide();
	document.getElementById(sender).innerHTML = html;
	$('#bbseditor').show();
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};


mx.goPage = function(cmd, packet, pageno){
	if( document.sform == undefined){
		document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
	}
	packet.CMD = cmd;
	packet.PN = pageno;
	//document.action = location.href + "?page=" + pageno;
	//document.location = "?page="+pageno;
	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.submit();
	//mx.SendPacket( null, packet);
};


//편집 모드
mx.bbsEditor =function(cmd, packet, pageno){
	packet.PN = pageno;
	packet.CMD = cmd;
    mx.SendPacket('bbseditor', packet)
};
//리스트 보기
mx.bbsList =function(cmd, packet, pageno){
	$('#bbseditor').hide();
	$('#bbslist').show();
};



mx.SelectYear = function(drowtype,pageno) {
      var obj = {};
      obj.CMD = mx.CMD_FINDYEAR;
	  obj.pg = pageno;
	  obj.GY = $("#sgameYear").val();
	  obj.DROWTYPE = drowtype; //리스트 편집기가 같이씀 (구분) 편집기 B
	  if (obj.DROWTYPE == 'B')
	  {
		  mx.SendPacket('wyear', obj);
	  }
	  else{
		  mx.SendPacket('gamefind_area', obj);
	  }
};

mx.SelectTitle = function(drowtype,pageno) {
      var obj = {};
      obj.CMD = mx.CMD_FINDLEVELNO;
	  obj.pg = pageno;
	  obj.GY = $("#sgameYear").val();
	  obj.TIDX = $("#sgametitle").val();
	  obj.DROWTYPE = drowtype;
	  if (obj.DROWTYPE == 'B'){
		  mx.SendPacket('wlevel', obj);
	  }
	  else{
		  mx.SendPacket('gamefind_area', obj);
	  }
};

mx.fsubmit = function(packet){


	  if ($('#sgametitle').val() == "")
	  {
		  alert('대회를 선택해 주세요');
		  return;
	  }
	  if ($('#slevelno').val() == "")
	  {
		  alert('종목을 선택해 주세요');
		  return;
	  }
	  if(packet.SEQ == '' || packet.SEQ == 0){
		  if ($('#iFile_1').val()  =='')
		  {
			  alert('이미지를 1개이상 선택해 주시기 바랍니다.');
			  return;
		  }
		  if ($('#title').val()  =='')
		  {
			  alert('제목을 입력해 주십시오.');
			  return;
		  }
	  }

	
	document.sform.p.value =   JSON.stringify( packet  );
	document.fileform.submit();
};




mx.goPageBBS = function(pageno){
	var obj ={};
	obj.pg = pageno;
	obj.SEQ = 0;

	obj.tid = $("#tid").val();
	obj.GY = $("#sgameYear").val();
	obj.tidx = $("#sgametitle").val();
	obj.levelno = $("#slevelno").val();

	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();
};

mx.searchBBS = function(pageno){
	var obj ={};
	obj.pg = pageno;
	obj.SEQ = 0;

	obj.tid = $("#tid").val();
	obj.GY = $("#sgameYear").val();
	obj.tidx = $("#sgametitle").val();
	obj.levelno = $("#slevelno").val();



	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();
};


/* 체크박스 전체선택, 전체해제 */
mx.chktype = false;
mx.checkAll = function(){
      if( mx.chktype == false ){
        $("input[name=scimg]").prop("checked", true);
		mx.chktype = true;
      }else{
        $("input[name=scimg]").prop("checked", false);
		mx.chktype = false;
      }
};

mx.chk = function(btnid,chkname){
      if( $('#'+btnid).is(":checked") == true ){
        $("input[name="+chkname+"]").prop("checked", true);
		mx.chktype = true;
      }else{
        $("input[name="+chkname+"]").prop("checked", false);
		mx.chktype = false;
      }
};


mx.checkbox = function(formname) {
	for (i = 0; i < formname.length; i++)
	{
		if (formname.item(i).type == 'checkbox')
		{
			if (formname.item(i).checked == false) {
				formname.item(i).checked = true;
			}
			else {
				formname.item(i).checked = false;			    
			}
		}//if end
	}//for end
};


mx.imgDel = function(formname, packet){

  var scimg = "";
  $( "input[name='scimg']:checked" ).each (function (){
    scimg = scimg + $(this).val()+"," ;
  });
  scimg = scimg.substring(0,scimg.lastIndexOf( ",")); //맨끝 콤마 지우기
 
  if(scimg == ''){
    alert("삭제할 대상을 선택하세요.");
    return false;
  }
  packet.CMD = mx.CMD_DELIMG;
  packet.IMGARR = scimg;
  //console.log("### checkRow => {}"+scimg);
  mx.SendPacket('bbseditor', packet);	
};


//만들어 두고 숨김 실지 삭제 하지 않도록
mx.deleteBBS = function(packet){
	//삭제여부확인
  if (confirm("삭제하시겠습니까? 삭제 후 모든자료가 삭제됩니다.")) {
	  packet.CMD = mx.CMD_DELBBS;
	  mx.SendPacket('bbseditor', packet);	
  }
  else{
	return;
  }
};



mx.pubShow = function( packet){

  var showflag = "";
  var hideflag = "";
  $( "input[name='showflag']:checked" ).each (function (){
    showflag = showflag + $(this).val()+"," ;
  });
  showflag = showflag.substring(0,showflag.lastIndexOf( ",")); //맨끝 콤마 지우기
 

  $( "input[name='showflag']:not(:checked)" ).each (function (){
    hideflag = hideflag + $(this).val()+"," ;
  });
  hideflag = hideflag.substring(0,hideflag.lastIndexOf( ",")); //맨끝 콤마 지우기


  packet.CMD = mx.CMD_PUBSHOW;
  packet.HIDEARR = hideflag;
  packet.PUBARR = showflag;
  //console.log("### checkRow => {}"+showflag);
  mx.SendPacket('bbseditor', packet);	
};