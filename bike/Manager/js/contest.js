

var accessTitle = function (mode, titleIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/contest/ajax_title_access.asp"
  packet.mode = mode
  packet.titleIdx = titleIdx;
  packet.titleHeadIdx = $("#titleHead option:selected").data("titleHeadIdx");
  packet.titleName = $("#titleName").val();
  packet.titleType = $("#titleType option:selected").val();
  packet.sido = $("#sido option:selected").data("sidoNum");
  packet.gameArea = $("#gameArea option:selected").data("gameAreaIdx");
  packet.addressZip = $("#addressZip").val();
  packet.address = $("#address").val();
  packet.addressDetail = $("#addressDetail").val();
  packet.gameStartDate = $("#gameStartDate").val();
  packet.gameEndDate = $("#gameEndDate").val();
  packet.applyStartDate = $("#applyStartDate").val();
  packet.applyEndDate = $("#applyEndDate").val();
  packet.hostCode = $("#host option:selected").data("hostCode");
  var data = JSON.stringify(packet);
  // console.log(data);
  //
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      var alertText = ""
      if (mode === "insert") {
        alert("대회입력완료");
        $("#infoList").html(retDATA);
      } else if (mode === "update" ) {
        alert("대회정보 수정완료");
        $("#infoList").html(retDATA);
      } else if (mode === "delete") {
        alert("대회삭제완료");
        location.reload();
      }
    },
    error: function (xhr, status, error) {
    }
  });
}


var addInput = function ($el, type, typeText) {
  if ($el.find("option:selected").val() === "add") {
    var packet = {};
    var ajaxUrl = "/ajax/contest/ajax_title_add_input.asp"
    var value = prompt(typeText + "을(를) 입력해주세요.");
    packet.type = type;
    packet.value = value;
    var data = JSON.stringify(packet);
    // console.log(data)
    if (value) {
      $.ajax({
        url: ajaxUrl,
        type: 'POST',
        data: "req=" + data,
        success: function(returnData) {
          returnData = JSON.stringify(returnData);
          if (!returnData.errorCode) {
            returnIdx = returnData.returnIdx;
            // $("#" + type).append("<option value='' data-game-area-idx="+ returnIdx +">"+ value +"</option>");
            location.reload();
          }
        },
        error: function (xhr, status, error) {
        }
      });
    } else {
      alert("추가생성할 값을 입력해주세요.");
    }
  }
}

var selectTitle = function (titleIdx, $el) {
  var packet = {};
  var ajaxUrl = "/contest/info_input.asp"
  packet.titleIdx = titleIdx;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#inputForm").html(retDATA);
      bindDatetimepicker(); // common.js 에 있음
      $(".title_row").removeClass("success");
      $el.addClass("success");
    },
    error: function (xhr, status, error) {
    }
  });
}

var changeOpenState = function (openType, titleIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/contest/ajax_title_change_openState.asp"
  var switchId = $("#" + openType + titleIdx);
  packet.titleIdx = titleIdx;
  packet.openType = openType;
  packet.openState = switchId.data("openState");
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      retDATA = JSON.parse(retDATA);
      var changeState = retDATA.changeState;
      switchId.data("openState", changeState);
    },
    error: function (xhr, status, error) {
    }
  });
}

var setFileInfo = function (titleIdx, fileType, imgPath) {
  var imgPath = $("#" + fileType + titleIdx).data("imgPath")
  $("#titleIdx").val(titleIdx);
  $("#fileType").val(fileType);
  $("#viewImg").attr("src", imgPath); // 미리보기 이미지
  $("#uploadImage").val(""); // 업로드된 파일 비우기
  $("#uploadImage")[0].files[0] = ""; // 업로드된 파일 비우기
}

var saveFile = function () {
  var ajaxUrl = "/ajax/contest/ajax_file_upload.asp"
  var formData = new FormData();
  var titleIdx = $("#titleIdx").val();
  var fileType = $("#fileType").val();
  formData.append("titleIdx", titleIdx);
  formData.append("fileType", fileType);
  formData.append("uploadIMG", $("#uploadImage")[0].files[0]);
//  if (!$("#uploadImage").val()) {
//    alert("파일을 등록해주세요");
//    return;
//  } else {
    $.ajax({
      url: ajaxUrl,
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(retDATA) {
        alert("저장되었습니다.")
        $("#" + fileType + titleIdx).data("imgPath", retDATA);
        $("#viewImg").attr("src", retDATA);
      },
      error: function (xhr, status, error) {
      }
    });
//  }
}



var mx =  mx || {};
//========================
mx.CMD_DATAGUBUN = 10000;
//========================
mx.CMD_EDITOR = 40000;
mx.CMD_EDITOROK = 40001;

mx.ajaxurl = "/pub/ajax/bike/reqBikeResult.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";

mx.SendPacket = function( sender, packet){
    //console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:mx.ajaxurl,type:mx.ajaxtype,data:strdata,dataType:mx.dataType,
	success: function(returnData){
		mx.ReceivePacket( packet.CMD, returnData, sender )
		}
	});
};

mx.ReceivePacket = function( reqcmd, data, sender ){
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
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
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_EDITOR:	this.OnEditor( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITOROK:	this.OnEditorOK( reqcmd, jsondata, htmldata, sender );		break;
	}

};




mx.editor =  function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_EDITOR;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	mx.SendPacket('myModal', obj);
};

mx.editOK = function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_EDITOROK;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	var editor = CKEDITOR.instances.editor1;
	var contents = editor.getData();
	if (editor.getData() == ''){
		editor.focus();
		return;
	}
	obj.CONTENTS = contents;
	mx.SendPacket('myModal', obj);
};


mx.OnEditor =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	$('#'+sender).addClass('on');

	CKEDITOR.replace( 'editor1' );

};

mx.OnEditorOK =  function(cmd, packet, html, sender){
	alert("저장이 완료 되었습니다.");
};

