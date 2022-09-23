var bm=  bm|| {};
////////////////////////////////////////
	bm.CMD_DATAGUBUN = 10000;
	bm.CMD_TARGETDB = 20000;
	bm.CMD_TARGETTABLE = 20001;

////////////////////////////////////////

bm.IsHttpSuccess = function( r ){
	try{
		return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
	}
	catch(e){}
	return false;
};

bm.HttpData = function( r, type ){
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

bm.ajaxurl = "/pub/ajax/reqDB.asp"; 
bm.SendPacket = function( sender, packet){

	console.log(packet);
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = bm.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( bm.IsHttpSuccess( xhr ) ){
				bm.ReceivePacket( reqcmd, bm.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	xhr.send( strdata );
};

bm.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
	var rsp = null;
	var callback = null;
	var jsondata = null;
	var htmldata = null;
	var resdata = null;

	
	if ( Number(reqcmd) > bm.CMD_DATAGUBUN  ){
		if ( data.indexOf("`##`") !== -1 ){
			resdata = data.split( "`##`" );
			jsondata =  resdata[0];
			if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
				htmldata = resdata[1];
		}		
		else{
			htmldata = data;		
		}
	}
	else{
		if(typeof data == 'string'){jsondata = JSON.parse(data);}
		else{jsondata = data;}
	}

	if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 2:	alert('중복된 데이터가 존제합니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case bm.CMD_TARGETDB :
	case 	bm.CMD_TARGETTABLE: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case 	bm.CMD_EDITRESULT: alert('세트종료가 완료되었습니다.');		break;
	
	}
};

bm.SetTargetDB = function(targetid,thisid){
	  obj= {};
	  obj.CMD = bm.CMD_TARGETDB;
	  obj.TARGET = $("#"+thisid).val();
	  obj.TARGETOBJID = targetid + "_targetobj";
	  bm.SendPacket(targetid , obj);  
};

bm.SetTargetTable = function(targetid, thisid, targetdbnm){
	  obj= {};
	  obj.CMD = bm.CMD_TARGETTABLE;
	  obj.TARGET = $("#"+thisid).val();
	  obj.TARGETOBJID = targetid + "_targetobj";
	  obj.TARGETDBNM = targetdbnm;
	  bm.SendPacket(targetid , obj);
};

bm.SetTargetJoinTable = function(targetid, thisid, targetdbnm){
	  obj= {};
	  obj.CMD = bm.CMD_TARGETJOINTABLE;
	  obj.TARGET = $("#"+thisid).val();
	  obj.TARGETOBJID = targetid + "_targetobj";
	  obj.TARGETDBNM = targetdbnm;
	  bm.SendPacket(targetid , obj);
};



bm.targetfield = "";
bm.selectfield = "";
bm.SetTargetField = function(fieldname, inputnm) {
	var fieldstr = bm.targetfield;
	var btnnm = inputnm;
	var orgfld = fieldname;

	switch (inputnm){
	case 'target': 
		fieldstr = bm.targetfield; 
		break;
	case 'select2':
		fieldname = 'b.' + fieldname;
		fieldstr = bm.selectfield;
		inputnm = 'select';
		break;
	case 'select': 
		if ($('#selectfield2').text() != '' ){
			fieldname = 'a.' + fieldname;
		}
		fieldstr = bm.selectfield;
		inputnm = 'select';
		break;
	}


	var findfield = fieldstr.indexOf(fieldname);
	if(findfield == -1){ //넣기 
		if (fieldstr == ''){
			fieldstr = fieldname;
			$('#'+inputnm+'_field').val(fieldstr);
		}
		else{
			fieldstr = fieldstr +","+fieldname;
			$('#'+inputnm+'_field').val(fieldstr);
		}
		$('#'+btnnm+'_'+ orgfld).css('color','red');
	}
	else{ //빼기
		if(fieldstr.indexOf(','+fieldname) != -1){
			fieldstr = fieldstr.replace(','+fieldname,'');
		}
		else if(fieldstr.indexOf(fieldname+',') != -1){
			fieldstr = fieldstr.replace(fieldname+',','');
		}
		else{
			fieldstr = fieldstr.replace(fieldname,'');		
		}
		$('#'+btnnm+'_'+ orgfld).css('color','black');
		$('#'+inputnm+'_field').val(fieldstr);
	}

	switch (inputnm){
	case 'target': bm.targetfield =fieldstr; break;
	case 'select2':
	case 'select': bm.selectfield = fieldstr; break;
	}
};


bm.makeQuery = function(){
	var selectquery = "";
	var query = " insert into ";
	var db1 = $('#dbname').val();
	var db2 = $('#dbname2').val();
	var targettable = $('#tablelist_targetobj').val();
	var selecttable = $('#tablelist2_targetobj').val();
	var jointable = $('#tablelist3_targetobj').val();
	var onquery = $('#onquery').val();
	var wherequery = $('#wherequery').val();
	var targetfield = $('#target_field').val();
	var selectfield = $('#select_field').val();
	if (targetfield == ''){
		return;
	}
	if (selectfield == ''){
		return;
	}
	if ( (targetfield.match(/,/g) || []).length != (selectfield.match(/,/g) || []).length ){
		alert('필드 갯수가 다름니다.');
		return;
	}

	//insert into test1 (text) (select test from test2 )
	if( jointable == ""){
		selectquery = "["+db2+"].[dbo].["+ selecttable+"]";
		if (wherequery != "" ){
			selectquery = selectquery + " where " + wherequery;
		}
	}
	else{ //조인상태
		selectquery = " ["+db2+"].[dbo].["+ selecttable+"] as a INNER JOIN " + "["+db2+"].[dbo].["+ jointable+"] as b  ON " + onquery;
		if (wherequery != "" ){
			selectquery = selectquery + " where " + wherequery;
		}
	}
	query = query + " ["+db1+"].[dbo].["+ targettable+"]"  +" ("+targetfield+") (select "+selectfield+" from "+selectquery+")";
	$('#lastq').val(query);

};


//drow///////////////
bm.OndrowHTML =  function(cmd, packet, html, sender){

	$("#"+sender).html(html);
	//document.getElementById(sender).innerHTML = html;
};
//drow///////////////


















