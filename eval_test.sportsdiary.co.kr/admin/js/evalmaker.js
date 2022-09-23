var mx = mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;
mx.CMD_CREATE = 100;
mx.CMD_READ = 20000;
mx.CMD_UPDATE = 300;
mx.CMD_DELETE = 400;

mx.CMD_EVALCODECREATE = 110;
mx.CMD_GETITEMLIST = 21000;

mx.CMD_SETTYPE = 500;
mx.CMD_SETPOINT = 510;
mx.CMD_EVALMEMBERWINDOW = 50000;
mx.CMD_SETMEMBER = 51000;
mx.CMD_DELMEMBER = 52000;
mx.CMD_DELITEM = 410;
mx.CMD_SETORDER = 310;
mx.CMD_SETORDER1 = 320;
mx.CMD_SETORDER2 = 330;

mx.CMD_GRPTOTAL = 220;

mx.CMD_ITEMNMUPDATE = 340;
////////////////////////////////////////



mx.ajaxurl = "/api/req/reqEvalMaker.asp";
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

mx.IsJsonString = function (str) {
  try {
    var json = JSON.parse(str);
    return (typeof json === 'object');
  } catch (e) {
    return false;
  }
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
      if (mx.IsJsonString(data) == false)
        htmldata = data;
      else
        jsondata = JSON.parse(data);
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

    case mx.CMD_SETORDER:
    case mx.CMD_DELITEM:
      //jsondata.CNT = 0 window.location.reload();
      if (jsondata.CNT == 0) {
        window.location.reload();
      }
      else {
        this.getGameList(sender, jsondata.IIDX2, jsondata.TIDX, jsondata.CDA, jsondata.CDB);
      }
      break;
    case mx.CMD_ITEMNMUPDATE:
    case mx.CMD_GRPTOTAL: return; break;


    case mx.CMD_SETPOINT:
    case mx.CMD_SETTYPE:
      if (jsondata.resetjudge == 'Y') {
        $("#mcnt_" + jsondata.IDX).text(0);
      }
      return; break;

    case mx.CMD_DELMEMBER:
    case mx.CMD_SETMEMBER:
    case mx.CMD_EVALMEMBERWINDOW:
    case mx.CMD_GETITEMLIST:
    case mx.CMD_READ: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;

    case mx.CMD_SETORDER1:
    case mx.CMD_SETORDER2:
    case mx.CMD_DELETE:
    case mx.CMD_UPDATE: window.location.reload(); break;

    case mx.CMD_EVALCODECREATE:
      mx.input_edit('', jsondata.MENUNO, '');
      break;


    case mx.CMD_CREATE:
      px.goSubmit({ 'EvalTableIDX': jsondata.EvalTableIDX, 'RegYear': jsondata.RegYear, 'F1': jsondata.F1, 'F2': jsondata.F2, 'F3': jsondata.F3 }, '/admin/evalmaker.asp');
      break;

  }
};


//요청##################################################################
mx.setItemNm = function (itemidx, itemnm) {
  var obj = {};
  obj.CMD = mx.CMD_ITEMNMUPDATE;
  obj.IIDX = itemidx;
  obj.INM = itemnm;
  mx.SendPacket(null, obj);
};


mx.getGrpTotal = function (tableidx) {
  var obj = {};
  obj.CMD = mx.CMD_GRPTOTAL;
  obj.TIDX = tableidx;
  mx.SendPacket(null, obj);
};


mx.setOrder1 = function (itemidx2, chkobj) {
  var obj = {};
  obj.CMD = mx.CMD_SETORDER1;
  obj.IIDX2 = itemidx2;
  obj.SETVAL = chkobj.val();
  obj.DEFVAL = chkobj.prop('defaultValue');
  mx.SendPacket(null, obj);
};
mx.setOrder2 = function (itemidx2, chkobj) {
  var obj = {};
  obj.CMD = mx.CMD_SETORDER2;
  obj.IIDX2 = itemidx2;
  obj.SETVAL = chkobj.val();
  obj.DEFVAL = chkobj.prop('defaultValue');
  mx.SendPacket(null, obj);
};

mx.setOrder = function (itemidx2, itemidx3, chkobj) {
  var obj = {};
  obj.CMD = mx.CMD_SETORDER;
  obj.IIDX = itemidx3;
  obj.IIDX2 = itemidx2;
  obj.SETVAL = chkobj.val();
  obj.DEFVAL = chkobj.prop('defaultValue');
  // if ($.isNumeric(obj.SETVAL)) {
  //   alert('숫자만 입력해주세요.');
  //   return;
  // }
  // else {
  mx.SendPacket("game_" + itemidx2, obj);
  //}
};


mx.delItem = function (itemidx2, itemidx3) {
  if (confirm('선택한 항목을 삭제하시겠습니까?')) {
    var obj = {};
    obj.CMD = mx.CMD_DELITEM;
    obj.IIDX = itemidx3;
    obj.IIDX2 = itemidx2;
    mx.SendPacket("game_" + itemidx2, obj);
  } else {
    return;
  }
};

mx.delMember = function (memberidx, itemidx) {
  $('#setjftr_' + memberidx).remove();
  $("#mcnt_" + itemidx).text(Number($("#mcnt_" + itemidx).text()) - 1);

  var obj = {};
  obj.CMD = mx.CMD_DELMEMBER;
  obj.AIDX = memberidx;
  obj.IIDX = itemidx;
  mx.SendPacket("memberarea", obj);
};

mx.setMember = function (adminidx, tableidx, itemidx, itemtypeidx, regyear) {
  $('#jftr_' + adminidx).remove();

  $("#mcnt_" + itemidx).text(Number($("#mcnt_" + itemidx).text()) + 1);

  var obj = {};
  obj.CMD = mx.CMD_SETMEMBER;
  obj.AIDX = adminidx;
  obj.TIDX = tableidx;
  obj.IIDX = itemidx;
  obj.ITIDX = itemtypeidx;
  obj.RY = regyear;
  mx.SendPacket("jsetarea", obj);
};

mx.getWindow = function (tableidx, itemidx, regyear) { //배정
  var obj = {};
  obj.CMD = mx.CMD_EVALMEMBERWINDOW;
  obj.TIDX = tableidx;
  obj.IIDX = itemidx;
  obj.RY = regyear;
  mx.SendPacket('modalB', obj);
};

mx.setType = function (sender, chkobj, typeno, gunno, CD3IDX) {
  var obj = {};
  obj.CMD = mx.CMD_SETTYPE;
  obj.IDX = CD3IDX;  //evalitem
  obj.TYPENO = typeno;
  obj.GUNNO = gunno;

  if (chkobj.is(':checked') == true) {
    obj.CHK = "Y";
  }
  else {
    obj.CHK = "N";
    $('#bp' + sender).val('');
  }

  mx.SendPacket(sender, obj);
};

mx.setPoint = function (sender, chkobj, typeno, gunno, CD3IDX) {
  var obj = {};
  obj.CMD = mx.CMD_SETPOINT;
  obj.IDX = CD3IDX;  //evalitem
  obj.TYPENO = typeno;
  obj.GUNNO = gunno;
  obj.SETVAL = chkobj.val();
  //obj.DEFVAL = chkobj.prop('defaultValue');

  if ($('#ck' + sender).is(':checked') == false) {
    if (obj.SETVAL > 0) {
      obj.CHK = "Y";
      $('#ck' + sender).prop("checked", true);
      //console.log(1);
    }
    else {
      obj.CHK = "N";
    }
  }
  if ($('#ck' + sender).is(':checked') == true) {
    if (obj.SETVAL == '' || obj.SETVAL == 0) {
      obj.CHK = "N";
      $('#ck' + sender).prop("checked", false);
      //console.log(2);
    }
    else {
      obj.CHK = "Y";
    }
  }

  mx.SendPacket(sender, obj);
};


mx.getGameList = function (sender, idx, tidx, CDA, CDB) {
  var obj = {};
  obj.CMD = mx.CMD_GETITEMLIST;
  obj.IDX = idx;
  obj.TIDX = tidx;
  obj.CDA = CDA;
  obj.CDB = CDB;
  mx.SendPacket(sender, obj);
};

//항목생성
mx.input_frm = function (lastno) {
  var obj = {};
  obj.CMD = mx.CMD_CREATE;
  obj.TIDX = $('#tidx').val();
  //종목 개인[단체] 성별 부서 세부종목
  obj.PARR = new Array();

  var allidarr = [];
  for (var x = 0; x < lastno; x++) {
    allidarr[x] = "mk_g" + x;
  }

  for (var i = 0; i < allidarr.length; i++) {
    obj.PARR[i] = $("#" + allidarr[i]).val();
  }

  var msgarr = [];
  for (var x = 0; x < lastno; x++) {
    msgarr[x] = "";
  }
  //체크할항목
  msgarr[0] = "평가군을 선택해 ";
  msgarr[1] = "회원군을 선택해 ";
  msgarr[2] = "종목단체명을 입력해 ";

  var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
  for (var x = 0; x < lastno; x++) {
    passarrno[x] = 0;
  }
  //체크할항목
  passarrno[0] = 1;
  passarrno[1] = 1;
  passarrno[2] = 1;

  for (var i = 0; i < obj.PARR.length; i++) {
    if (passarrno[i] == 1) {
      if (px.chkValue(obj.PARR[i], msgarr[i]) == false) {
        $("#" + allidarr[i]).focus();
        return;
      }
    }
  }
  mx.SendPacket(null, obj);
};



//추가항목생성
mx.evalcode = new Array(0, 0, 0);
mx.input_edit = function (idx, menuno, selectvalue) { //idx edit key , menuno depth number
  var obj = {};
  var reqvalue;

  switch (Number(menuno)) {
    case 1: reqvalue = $('#mk_g0').val(); break;
    case 2: reqvalue = $('#mk_g1').val(); break;
    case 3: reqvalue = $('#mk_g2').val(); break;
  }

  if (selectvalue == "insert") {
    var GbPrompt = prompt("추가할 항목을 입력해주세요", '');
    if (GbPrompt != null && GbPrompt != "") {
      obj.CMD = mx.CMD_EVALCODECREATE;
      obj.DEPNM = GbPrompt;
      obj.MENUNO = menuno;
      mx.evalcode[0] = $('#mk_g0').val();
      mx.evalcode[1] = $('#mk_g1').val();
      mx.evalcode[2] = $('#mk_g2').val();
      obj.PARR = mx.evalcode;
      //console.log(obj.PARR);
      mx.SendPacket('gameinput_area', obj);
      return;
    }
    else {
      if (GbPrompt == null) {
        return;
      }
      alert("생성할 항목명을 입력해 주세요");
      mx.input_edit(idx, menuno, selectvalue);
      return;
    }
  }
  if (Number(menuno) == 3) {
    return;
  }

  if (idx != "") {
    $("#contest tr").css("background-color", "white");
    $("#titlelist_" + idx).css("background-color", "#BFBFBF");
  }
  obj.CMD = mx.CMD_READ;
  obj.IDX = idx;
  obj.TIDX = $('#tidx').val();
  obj.MNNO = menuno;
  obj.PARR = new Array();

  var allidarr = [];
  for (var x = 0; x < 3; x++) {
    allidarr[x] = "mk_g" + x;
  }

  for (var i = 0; i < allidarr.length; i++) {
    obj.PARR[i] = $("#" + allidarr[i]).val();
  }
  mx.evalcode = obj.PARR;

  mx.SendPacket('gameinput_area', obj);
};






//응답##################################################################
mx.OndrowHTML = function (cmd, packet, html, sender) {
  if (sender == "modalB") {
    if ($('#modalB').length == 0) {
      $('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
    }
    document.getElementById("modalB").innerHTML = html;
    $('#modalB').modal('show');
  }
  else {
    $("#" + sender).fadeIn("slow", function () {
      document.getElementById(sender).innerHTML = html;
    });

  }
};


//클릭위치로 돌려놓기
$(document).ready(function () {

  $('html, body').animate({ scrollTop: localStorage.getItem('scrollpostion') }, 400);
  $(document).click(function (event) {
    window.toriScroll = $(document).scrollTop();
    localStorage.setItem('scrollpostion', window.toriScroll);
    console.log(window.toriScroll);
  });

});