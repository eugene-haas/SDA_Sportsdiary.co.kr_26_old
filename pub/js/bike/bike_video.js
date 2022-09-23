var mx =  mx || {};

mx.CMD_PUBSHOW = 300;
mx.CMD_DATAGUBUN = 10000;

mx.CMD_FINDYEAR = 21000;
mx.CMD_FINDLEVELNO = 21001;

mx.CMD_OPENEDITOR = 40000; // 비디오 게시물 등록/수정 에디터
mx.CMD_WVIDEO = 40001; // 비디오 게시물 등록
mx.CMD_EVIDEO = 40002; // 비디오 게시물 수정
mx.CMD_ADDURL = 40003; // url입력필드 추가
mx.CMD_ADDVIDEO = 40004; // 수정모드에서 비디오 주소 추가
mx.CMD_DELVIDEO = 40005; // 수정모드에서 비디오 주소 삭제

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

mx.ajaxurl = "/pub/ajax/bike/board/reqVideo.asp";
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
    console.log(JSON.stringify( packet ) );
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

	if( jsondata !='' && jsondata != null ){
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
		case mx.CMD_PUBSHOW : mx.goPageBBS(jsondata.pg); break;
    case mx.CMD_FINDYEAR: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  	case mx.CMD_FINDLEVELNO: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  	case mx.CMD_W: this.OndrowEditor( reqcmd, jsondata, htmldata, sender );		break;
  	case mx.CMD_OPENEDITOR:	this.OndrowEditor( reqcmd, jsondata, htmldata, sender ); break;
		case mx.CMD_WVIDEO: alert("등록되었습니다."); location.href="/board/video.asp"; break;
    case mx.CMD_ADDURL: this.BeforeHTML( reqcmd, jsondata, htmldata, sender ); break;
		case mx.CMD_EVIDEO: alert("수정되었습니다."); location.href="/board/video.asp"; break;
		case mx.CMD_ADDVIDEO: this.BeforeHTML( reqcmd, jsondata, htmldata, sender ); break;
		case mx.CMD_DELVIDEO: this.OndelHTML( reqcmd, jsondata, htmldata, sender ); break;

	}
};


mx.OndrowHTML =  function ( cmd, packet, html, sender ) {
	document.getElementById(sender).innerHTML = html;
};

mx.BeforeHTML = function ( cmd, packet, html, sender ) {
  $("#previewVideo").parents("tr").before(html);
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
};

mx.goPage = function ( cmd, packet, pageno ) {
	if( document.sform == undefined ){
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

mx.searchBBS = function(pageno){
	var obj ={};
	obj.pg = pageno;
	obj.SEQ = 0;

	obj.tid = $("#tid").val();
	obj.GY = $("#sgameYear").val();
	obj.tidx = $("#sgametitle").val();
	obj.levelno = $("#slevelno").val();

	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.action = "video.asp";
	document.sform.submit();
};


mx.OndrowEditor =  function ( cmd, packet, html, sender ) {
	$('#videoList').hide();
	document.getElementById(sender).innerHTML = html;
	$('#videoEditor').show();
};

//편집 모드
mx.bbsEditor = function ( mode, seq, urlCnt ) {
  var obj = {};

  obj.MODE = mode;
	if ( mode == "edit" ) {
		obj.SEQ = seq;
		obj.URLCNT = urlCnt;
	};
  obj.CMD = this.CMD_OPENEDITOR;

  mx.SendPacket('videoEditor', obj);
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


//리스트 보기
mx.bbsList = function ( cmd, packet, pageno ) {
	$('#bbsEditor').hide();
	$('#bbsList').show();
};

mx.addUrl = function () {
  var obj = {};
  obj.CMD = this.CMD_ADDURL;
  obj.ADD = "Y";
  mx.SendPacket("previewVideo", obj);
  document.eform.urlCnt.value = Number(document.eform.urlCnt.value) + 1;
};

mx.removeUrl = function ( e ) {
  e.parents('tr').remove();
  document.eform.urlCnt.value = Number(document.eform.urlCnt.value) - 1;
};

mx.previewVideo = function ( e ) {
  var obj = {};
  var inputUrl, videoId, url;
  inputUrl = e.siblings('input').val();
  if ( inputUrl ) {
      // videoId = inputUrl.split("watch?v=")[1].substring(0, 11);
			videoId = mx.getIdFromUrl(inputUrl);
      if ( videoId ) {
        url = "https://www.youtube.com/embed/" + videoId;
        $("#ytbFrame").attr('src', url);
      } else {
        alert("정상적인 주소가 아닙니다.");
      };
  } else {
    alert("주소를 입력해주세요.");
  };
};

mx.SelectYear = function ( drowtype ) {
    var obj = {};
    obj.CMD = mx.CMD_FINDYEAR;
	  obj.GY = $("#sgameYear").val();
	  obj.DROWTYPE = drowtype;
	  if ( obj.DROWTYPE == 'B' )
	  {
		  mx.SendPacket('wyear', obj);
	  }
	  else{
		  mx.SendPacket('gamefind_area', obj);
	  }
};


mx.SelectTitle = function ( drowtype ) {
    var obj = {};
    obj.CMD = mx.CMD_FINDLEVELNO;
	  obj.GY = $("#sgameYear").val();
	  obj.TIDX = $("#sgametitle").val();
	  obj.DROWTYPE = drowtype;
	  if ( obj.DROWTYPE == 'B' ){
		  mx.SendPacket('wlevel', obj);
	  }
	  else{
		  mx.SendPacket('gamefind_area', obj);
	  }
};




mx.getVideoUrl = function ( i ) {
	return $("input[video]").eq(i).val();
};

mx.getIdFromUrl = function ( videoUrl ) {
	var videoID;
	if ( videoUrl.indexOf("watch?v=") >= 0 ) {
		videoID = videoUrl.split("watch?v=")[1].substring(0, 11);
		return videoID;
	} else if ( videoUrl.indexOf("https://youtu.be/") >= 0 ) {
		videoID = videoUrl.split("https://youtu.be/")[1].substring(0, 11);
		return videoID;
	} else {
		return false;
	};
};

//jquery object value 확인
mx.checkValue = function (obj ,jo, pn, text ) {
	if ( jo.val() ) {
		obj[pn] = jo.val();
		return
	} else {
		alert(text);
		return false;
	};
};

mx.writeVideo = function () {
    var obj = {},
				videoUrls = new Array,
				arrVal = new Array,
    		urlCnt = document.eform.urlCnt.value;

		obj.CMD = this.CMD_WVIDEO;

		mx.checkValue(obj, $("#sgameYear"), "GY", "년도를 선택해주세요.");
		mx.checkValue(obj, $("#sgametitle"), "GTITLE", "대회를 선택해주세요.");
		mx.checkValue(obj, $("#slevelno"), "LEVELNO", "종목를 선택해주세요.");
		mx.checkValue(obj, $("#btitle"), "BTITLE", "제목을 입력해주세요.");

    for ( var i = 0; i < urlCnt; i++ ) {
			var videoUrl, videoId;
      if ( mx.getVideoUrl(i) ) {
				//video attribute 를 가지고있는 input을 찾아서 value를 가져온다.
				videoUrl = mx.getVideoUrl(i);
				//url을  "watch?=v" 기준으로 나눠서 11자리 ID 를 얻는다, youtu.be 형식으로도 id를 얻도록 수정
				videoId = mx.getIdFromUrl(videoUrl);
				if ( videoId ) {
						videoUrls.push(videoId);
				} else {
						alert("영상주소 비정상");
						$("input[video]").eq(i).focus();
						return;
				}
      };
    };
		obj.URLS = videoUrls;
    mx.SendPacket(null, obj);
		//console.log (obj);
};

mx.editVideo = function ( seq ) {
	var obj = {};

	obj.CMD = this.CMD_EVIDEO;
	mx.checkValue(obj, $("#sgameYear"), "GY", "년도를 선택해주세요.");
	mx.checkValue(obj, $("#sgametitle"), "GTITLE", "대회를 선택해주세요.");
	mx.checkValue(obj, $("#slevelno"), "LEVELNO", "종목를 선택해주세요.");
	mx.checkValue(obj, $("#btitle"), "BTITLE", "제목을 입력해주세요.");
	obj.SEQ = seq

	mx.SendPacket(null, obj);
	//console.log (obj);
};

mx.addVideo = function ( seq ) {
	var inputUrl, videoUrl;
	var obj = {};
	obj.CMD = this.CMD_ADDVIDEO;
	obj.SEQ = seq;
	inputUrl = $("#urlInputForm").val();
	if ( mx.getIdFromUrl(inputUrl) ) {
		videoID = mx.getIdFromUrl(inputUrl);
		obj.VIDEOID = videoID;
	} else {
		alert("주소형식 오류");
		return;
	};
	mx.SendPacket(null, obj);
};

mx.delVideo = function ( cIDX, seq ) {
	var obj = {};
	obj.CMD = this.CMD_DELVIDEO;
	obj.SEQ = seq
	obj.CIDX = cIDX;
	//console.log(obj);
	mx.SendPacket("video_"+cIDX, obj);
};

// 체크박스, 앱노출 기능
mx.pubShow = function(packet){
	mx.ajaxurl = "/pub/ajax/bike/reqBBS.asp";
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
  mx.SendPacket('videoEditor', packet);
	mx.ajaxurl = "/pub/ajax/bike/board/reqVideo.asp";
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
