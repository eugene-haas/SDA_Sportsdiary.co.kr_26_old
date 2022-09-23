var mx = mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;
mx.CMD_CREATE = 100;
mx.CMD_READ = 20000;
mx.CMD_UPDATE = 200;
mx.CMD_DELETE = 300;

mx.CMD_SETENDFLAG = 210;
mx.CMD_SETUSEFLAG = 220;
////////////////////////////////////////



mx.ajaxurl = "/api/req/reqEvalIndex.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";

mx.SendPacket = function (sender, packet) {
  console.log(px.strReplaceAll(JSON.stringify(packet), '\"', '\"\"'));
  var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
  $.ajax({
    url: mx.ajaxurl, type: mx.ajaxtype, data: strdata, dataType: mx.dataType,
    success: function (returnData) {
      mx.ReceivePacket(packet.CMD, returnData, sender)
    }
  });
};

mx.ReceivePacket = function (reqcmd, data, sender) {// data는 response string
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if (Number(reqcmd) > mx.CMD_DATAGUBUN) {
    if (data.indexOf("`##`") !== -1) {
      resdata = data.split("`##`");
      jsondata = resdata[0];
      if (jsondata != '') { jsondata = JSON.parse(jsondata); }
      htmldata = resdata[1];
    }
    else {
      htmldata = data;
    }
  }
  else {
    if (typeof data == 'string') { jsondata = JSON.parse(data); }
    else { jsondata = data; }
  }

  if (jsondata != '' && jsondata != null) {
    switch (Number(jsondata.result)) {
      case 0: break;
      case 100: return; break; //메시지 없슴
      case 111: alert(jsondata.servermsg); return; break;
      case 112: alert(jsondata.servermsg); window.location.reload(); break;
        return; break;
    }
  }

  switch (Number(reqcmd)) {
    case mx.CMD_READ: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
    case mx.CMD_SETUSEFLAG:
    case mx.CMD_SETENDFLAG:
    case mx.CMD_DELETE:
    case mx.CMD_UPDATE:
    case mx.CMD_CREATE: window.location.reload(); break;
  }
};


//요청##################################################################
mx.input_frm = function (lastno) {
  var obj = {};
  obj.CMD = mx.CMD_CREATE;
  obj.REGYEAR = $('#F1').val();
  mx.SendPacket(null, obj);
};

mx.del_frm = function (idx) {
  var obj = {};
  obj.CMD = mx.CMD_DELETE;
  obj.IDX = idx;

  if (confirm('대상을 삭제하시겠습니까?')) {
    mx.SendPacket('titlelist_' + obj.IDX, obj);
  } else {
    return;
  }
};

mx.setEndFlag = function (tidx) {
  var obj = {};
  obj.CMD = mx.CMD_SETENDFLAG;
  obj.TIDX = tidx;
  mx.SendPacket(null, obj);
};

mx.setUseFlag = function (tidx) {
  var obj = {};
  obj.CMD = mx.CMD_SETUSEFLAG;
  obj.TIDX = tidx;
  mx.SendPacket(null, obj);
};

//응답##################################################################

mx.OndrowHTML = function (cmd, packet, html, sender) {
  document.getElementById(sender).innerHTML = html;
};

