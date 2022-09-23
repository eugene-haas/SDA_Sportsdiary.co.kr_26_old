//도구##################################################################
	var px =  px || {};

	px.goSubmit = function(packet,gourl){
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
		document.ssform.target = "_self";
		document.ssform.p.value =   JSON.stringify( packet  );
		document.ssform.action = gourl;
		document.ssform.submit();
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


	px.goPrint = function(packet, gameround){
		packet.gameround = gameround;
		document.ssform.target = "_blank";
		document.ssform.p.value = JSON.stringify(packet);
		document.ssform.action = "print.asp";
		document.ssform.submit();
	};
//도구##################################################################