//도구##################################################################
	var px =  px || {};

	px.goSubmit = function(packet,gourl){

		
	console.log($('#ssform').length + "머지"); 

		var typechkbox =  false;
		if (packet.hasOwnProperty('F1')) {
				//alert(packet.F1 + ' ' + $.isArray(packet.F1));
				if($.isArray(packet.F1)){

					for (var i = 0;i < packet.F1.length  ;i++ )
					{
						typechkbox =  false;						
						for (var n = 0;n< packet.F3.length ;n++ ){
							if (Number(packet.F1[i]) == Number(packet.F3[n])){ //체크박스라면
								typechkbox = true;
							}
						}
						
						if (typechkbox == true){
							if (  $("#F1_"+ i).is(":checked")  ){
								packet.F2[i] = px.strReplaceAll($('#F1_'+ i).val(),",","`");
							}
							else{
								packet.F2[i] = '';				
							}
						}else{
							if (packet.F2[i] != null){
								if(packet.F2[i] == ''){ //입력값이 직접 들어가있다면 그대로 넣는다.
									packet.F2[i] = px.strReplaceAll($('#F1_'+ i).val(),",","`");
								}
							}

						}
					}

				}
				//alert(packet.F2);
		}
		
		if(!document.getElementById("p")){
		//if( $('#ssform').length == 0 ){
				//document.body.innerHTML = "<form method='post' name='ssform' id='ssform' style='display:none;'><input type='hidden' name='p' id='p'></form>";
				$('body').append("<form method='post' name='ssform' id='ssform' style='display:none;'><input type='hidden' name='p' id='p'></form>");
			document.ssform.target = "_self";
			document.ssform.p.value =   JSON.stringify( packet  );
			document.ssform.action = gourl;
			document.ssform.submit();
		}		
		else{
			document.ssform.target = "_self";
			document.ssform.p.value =   JSON.stringify( packet  );
			document.ssform.action = gourl;
			document.ssform.submit();		
		}
	};
	/* =================================================================================== 
	Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
	=================================================================================== */
	px.strPrintf = function()
	{
	   var content = arguments[0];
	   for (var i=0; i < arguments.length-1; i++)
	   {
			   var replacement = '{' + i + '}';
			   content = content.replace(replacement, arguments[i+1]);  
	   }
	   return content;
	};




	/*  =================================================================================== 
	replace All - 정규식 이용 , strSrc의 문자열 str1을 str2로 변환시킨다. 
	=================================================================================== */    
	px.strReplaceAll = function(strSrc, str1, str2) {        
	var regExp = new RegExp(str1, "g");
	if (strSrc != undefined){
		strSrc = strSrc.replace( regExp, str2); 
	}
	return strSrc; 
	};

	px.chkValue = function(chkval,msg){
	if (chkval == "" || chkval == undefined){
		alert(msg + "주세요.");
		return false;
	}
	return true;
	};

	px.goPN = function(packet,pageno){
	packet.PN = pageno;
	var gourl = location.href;
		document.ssform.p.value = JSON.stringify(packet);
		document.ssform.action = gourl;
		document.ssform.submit();
	};


	px.goPNHome = function(packet,pageno){
	if(!document.getElementById("p")){
		$('body').append("<form method='post' name='ssform' id='ssform' style='display:none;'><input type='hidden' name='p' id='p'></form>");
	}
//	if( $('#ssform').length == 0 ){
//			document.body.innerHTML = "<form method='post' name='ssform' id='ssform' style='display:none;'><input type='hidden' name='p' id='p'></form>";
//	}
	packet.PN = pageno;
	var gourl = location.href;
		document.ssform.p.value = JSON.stringify(packet);
		document.ssform.action = gourl;
		document.ssform.submit();
	};




	px.goPrint = function(packet, gameround){
		packet.gameround = gameround;
		document.ssform.target = "_blank";
		document.ssform.p.value = JSON.stringify(packet);
		document.ssform.action = "print.asp";
		document.ssform.submit();
	};

	px.Print = function(packet, targeturl){
		document.ssform.target = "_blank";
		document.ssform.p.value = JSON.stringify(packet);
		document.ssform.action = targeturl;
		document.ssform.submit();
	};


	//input 기본값으로 0이되었을경우 처리
	px.chkZero = function(inputobj){
		if (inputobj.value == 0 )	{
			inputobj.value = '';
		}
		//console.log(inputobj.value);
	};

	px.setZero = function(inputobj){
		if (inputobj.value == '' )	{
			inputobj.value = 0;
		}
	};


	//스토리지에 저장해두기
	px.saveText = function(el){
		localStorage.setItem(el.id,el.value);
	};


	//input에 저장된스토리지 모두 불러오기
	px.allStorage = function() {
		var archive = [],
			keys = Object.keys(localStorage),
			i = 0, key;
		for (; key = keys[i]; i++) {
			//obj = {};
			//obj['"'+key+'"'] = localStorage.getItem(key);
			//archive.push( obj );
			$('#'+key).val(localStorage.getItem(key));
		}
		//return archive; //배열에 key값이 동적인 객체를 넣을때 
	};

//도구##################################################################
px.checkAll = function (el) {
	var checkStatus = el.is(":checked");
	var $checkTable = el.parents("Table");
	var $checkList = $checkTable.find("input[type='checkbox']");
	if (checkStatus) {
		$checkList.prop("checked", true);
	} else {
		$checkList.prop("checked", false);
	}
};