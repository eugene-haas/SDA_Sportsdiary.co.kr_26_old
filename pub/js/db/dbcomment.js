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

//alert(location.hostname.split(".")[0].toLowerCase() );

mx.SendPacket = function( sender, packet){

	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure

	switch (location.hostname.split(".")[0].toLowerCase())	{
	case 'ridingadmin': var url = "/pub/ajax/riding/reqdbcomment.asp";	;break;
	case 'swadmin':	 var url = "/pub/ajax/swim/reqdbcomment.asp";	break;
	case 'rtadmin':		 var url = "/pub/ajax/rookietennis/reqdbcomment.asp"; 	break;
	case 'swimadmin':
	case 'swimming':		 var url = "/pub/ajax/swimming/reqdbcomment.asp"; 	break;
	default:  var url = "/pub/ajax/adm/reqdbcomment.asp"; 	break;
	}



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
		case 1212: location.href="tablehelp.asp"; return; break;
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_TABLECLUMN:	this.OnClumn( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_TABLECMT:	this.OnComment( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_COLUMNCMT:	this.OnComment( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_TABLELIST :	this.OnList( reqcmd, jsondata, htmldata, sender );		break;
	}
};


mx.OnList =  function(cmd, packet, html, sender){
	document.getElementById("myModal").innerHTML = html;
	$("#modalB").modal('hide');
	$('#myModal').modal('show');
	
	// document.getElementById("modalB").innerHTML = html;
	//
	// if( $("#modalB").css("display") == "none" ) {
	// 	$('#modalB').modal('show');
	// }
	//$("#modalB").is($("#modalB").show()) {
	//}
};



mx.OnIIS =  function(cmd, packet, html, sender){
	document.getElementById("dbselect").style.display = "none";
	document.getElementById("axcontents").innerHTML = html;
};



mx.OnClumn =  function(cmd, packet, html, sender){
	if( $('#modalB').length == 0 ){
		$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
	}
	//var inner = document.getElementById("modalB");
	//if(inner){
	//	inner.innerHTML = html;
	//}
	//else {
	document.getElementById("modalB").innerHTML = html;
	//}
	$('#modalB').modal('show');
};


mx.OnComment =  function(cmd, packet, html, sender){
	sender.style.borderColor  = 'red';
};


mx.goPage = function(packet, pageno){
	packet.PN = pageno;
	mx.SendPacket( null, packet);
};


mx.goPageSearch = function(packet, pageno,f1,f2){
	packet.F1 = f1;
	packet.F2 = f2;
	packet.PN = pageno;
	mx.SendPacket( null, packet);
};

mx.goPageLnCnt = function(packet, pageno,ps){
	packet.PS = ps;
	packet.PN = pageno;
	mx.SendPacket( null, packet);
};

mx.copyTable =function(tableName){
	var packet = {};
	packet.CMD = mx.CMD_A6;
	var control = document.getElementById(tableName).value;
	if(confirm ("["+ control + "]" +" 테이블을 복사하시겠습니까?")){
		packet.TABLENAME = control;
    mx.SendPacket(null, packet)
  }
};

mx.go = function(packet,pageno){
	packet.pg = pageno;
	var gourl = location.href;
	if( document.ssfrom == undefined ){
		document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
	}
	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};

mx.goPN = function(packet,pageno){
	packet.PN = pageno;
	var gourl = location.href;
	if( document.ssfrom == undefined ){
		document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
	}
	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};

mx.goSearch = function(packet, pageno,f1,f2){
	packet.F1 = f1;
	packet.F2 = f2;
	packet.PN = pageno;
	var gourl = location.href;
	if( document.ssfrom == undefined ){
		document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
	}

	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};







//클립보드에 붙여넣기
mx.copyField = function(fieldstr){
	var copybox = document.getElementById( "tablefield" );
	copybox.select();
	document.execCommand( 'Copy' );
	alert('클립보드에 복사되었습니다. Ctrl + V 로 붙여넣기 하세요.');
};








///////////////////////////////////////////////////////////////




$.getScript('/pub/js/excel/xlsx.full.min.js',function(){
//	console.log('script loading!!');
});
$.getScript('/pub/js/excel/FileSaver.min.js',function(){
//	console.log('2 script loading!!');
});




//공통
// 참고 출처 : https://redstapler.co/sheetjs-tutorial-create-xlsx/
mx.s2ab = function(s) { 
    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
    var view = new Uint8Array(buf);  //create uint8array as viewer
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
    return buf;    
};

mx.exportExcel = function( xlsname, sheetname ,xlstableid){ 
	excelHandler.tablename = xlsname;
	excelHandler.sheetname = sheetname;
	excelHandler.xlstableid = xlstableid;

    // step 1. workbook 생성
    var wb = XLSX.utils.book_new();

    // step 2. 시트 만들기 
    var newWorksheet = excelHandler.getWorksheet();

	//간격조정때 사용
//      var wsrows =  [            
//            {wch: 10}, // A Cell Width
//            {wch: 50}, // B Cell Width
//         ];
//      newWorksheet['!cols'] = wsrows;


    // step 3. workbook에 새로만든 워크시트에 이름을 주고 붙인다.  
    XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());

    // step 4. 엑셀 파일 만들기 
    var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});

    // step 5. 엑셀 파일 내보내기 
    saveAs(new Blob([mx.s2ab(wbout)],{type:"application/octet-stream"}), excelHandler.getExcelFileName());
};

var excelHandler = {
		tablename : 'gamename',
		sheetname : 'sheetname',
		xlstableid : 'xlstbl',

        getExcelFileName : function(){
            return this.tablename+ '.xlsx';
        },
        getSheetName : function(){
            return this.sheetname;
        },
        getExcelData : function(){
            return document.getElementById(this.xlstableid); 
        },
        getWorksheet : function(){
            return XLSX.utils.table_to_sheet(this.getExcelData());
        }
}