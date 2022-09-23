var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_AUTOSUMBOO = 11100; //자동통합
  mx.CMD_SUMBOO = 11000; //수동통합
  mx.CMD_DIVBOO = 12000; //수동해제
 
  mx.CMD_OKYN = 100; //성립부서 확정버튼
  mx.CMD_SETTIMEALL = 13000;//출전순서표 전체시작시간 맞추기
  mx.CMD_SETTIME = 200;// 개별시간설정
  mx.CMD_SETORDER = 14000;	 //경기별 순서생성

  mx.CMD_SETGIVEUP = 300;	 //기권사유선택
  mx.CMD_SETGIVEUPDOC = 301; //사유서제출

  mx.CMD_GAMEINPUT = 15000; //공지사항저장
  mx.CMD_GAMEINPUT2 = 15001; //공지사항저장2
  mx.CMD_GAMEINPUTEDITOK = 15002; //수정
  mx.CMD_GAMEINPUTDEL = 15003; //삭제

  mx.CMD_SETRECORDINIT = 400; //심사지점 수 최고점수 저정
  mx.CMD_SETSIGN = 401;
  mx.CMD_SETSHOW = 402;
  mx.CMD_EXCEPTMAX = 403;
  mx.CMD_EXCEPTMIN = 404;



  mx.CMD_RC01 = 20000; //기록입력시작 01
  mx.CMD_RC02 = 20010; //02
  mx.CMD_RC03 = 500;	 //저장후 reload (지점별저장)
  mx.CMD_MMRCOK = 505;	 //저장후 reload 마장마술 저장 (통합으로)
  mx.CMD_RCCLOSE = 501; //기록창에서 창닫음 (입력상태복구)

  mx.CMD_JRCOK = 510; //장애물 A타입 저장
  mx.CMD_JRCOK2 = 520; //장애물 B타입 저장
  mx.CMD_JRCOK3 = 530; //장애물 C타입 저장
  mx.CMD_JRCOKA_1 = 540; //장애물 A_1타입 저장

  mx.CMD_JREGAME = 600; //재경기생성 
  mx.CMD_JREGAMEDEL = 610; //재경기 삭제

  mx.CMD_SETGAMESTATE = 620; //경기상태변경

  mx.CMD_SUMBOO_INJUDGE = 11101;        // 수동 통합 - 심사기록입력
  mx.CMD_DIVBOO_INJUDGE  = 11102;        // 수동 분리 - 심사기록입력
  mx.CMD_REFRESHBOO_INJUDGE = 11103;    // 부 재조회 - 심사기록입력


  mx.CMD_CHANGEWINDOW = 30000; //변경윈도우

  mx.CMD_SEARCHPLAYER = 30030; //선수검색
  mx.CMD_CHANGEPLAYER = 700;//선수변경
  mx.CMD_CHANGEMAKEPLAYER = 710;//선수생성변경
  
  mx.CMD_SEARCHHORSE = 30040;//말검색
  mx.CMD_CHANGEHORSE = 800;//말변경
  mx.CMD_CHANGEMAKEHORSE = 810;//선수생성변경


  mx.CMD_BMRESULT = 900; //복합마술 경기결과생성
  


  mx.CMD_CHANGEBOO = 30050; //부서변경
  mx.CMD_CHANGEBOOOK = 730;	 //부변경

////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','ming') + "/reqJudge.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";

mx.SendPacket = function( sender, packet){
    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:mx.ajaxurl,type:mx.ajaxtype,data:strdata,dataType:mx.dataType,
	success: function(returnData){
			mx.ReceivePacket( packet.CMD, returnData, sender )
		},

		select: function( event, ui ) {
			// selectEvent
			/*
			$('#playerKey').val(ui.item.key);
			$('#playerName').val(ui.item.label);
			$('#playerNumber').val(ui.item.number);
			$('#playerBirth').val(ui.item.birth);
			*/
			return false;
		}


	});
};

mx.SendPacketEx = function(sender, packet, reqUrl){
    var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );

    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
    $.ajax({
        url : reqUrl, 
        type : mx.ajaxType,
        data : strData, 
        dataType : mx.ajaxDataType, 
        success: function(rcvData) {
			mx.ReceivePacket(packet.CMD, rcvData, sender);
        }             
    });
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

  var jsondata = null;
  var htmldata = null;
  var resdata = null;


  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
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
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 20: alert('부별 조정완료가 되지 않은 부서가 있습니다. 부별조정에서 조정완료하신 후 이용해 주십시오.');return;    break; //메시지 없슴
    case 21: alert('지점 수, 최고기록 가능점수가 완료되지 않았습니다.확인 후 입력해주세요.');return;    break; //메시지 없슴

    case 30: alert('경기시간 2시간전에만 수정가능합니다.');return;    break; //마장마술 시간수정
    case 31: alert('경기시간 1시간전에만 수정가능합니다.');return;    break; //장애물 시간수정 + 기타

    case 40: alert('생성하려는 재경기 단계가 존재합니다. 삭제후 생성해 주세요.');return;    break; 
    case 90: alert('1라운드 이상 진행되어서 부를 통합할 수 없습니다.');return;    break; 

    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_SETGIVEUP :
	//if (jsondata.SAYOU == "W"){
		location.reload(); 
	//	history.go(0);
		return;
	//}
	//else{
	//	return;
	//}
	break;
  case mx.CMD_SETRECORDINIT:
  case mx.CMD_SETGAMESTATE : //시작 진행 종료  
  case mx.CMD_JREGAME : //재경기생성 
  case mx.CMD_JREGAMEDEL : //재경기 삭제
  case mx.CMD_BMRESULT : //복합마술 경기결과생성

  case mx.CMD_JRCOKA_1 : //장애물 A_1타입 저장
  case mx.CMD_JRCOK : //장애물 A타입 저장  
  case mx.CMD_JRCOK2 : //장애물 B타입 저장  
  case mx.CMD_JRCOK3 : //장애물 C타입 저장  
  case mx.CMD_CHANGEPLAYER ://선수변경
  case mx.CMD_CHANGEMAKEPLAYER: //생성변경
  case mx.CMD_CHANGEHORSE ://말변경
  case mx.CMD_CHANGEMAKEHORSE ://선수생성변경
  case mx.CMD_MMRCOK:
  case mx.CMD_SETGIVEUPDOC:
  case mx.CMD_CHANGEBOOOK :	 //부변경
  case mx.CMD_RC03 :   location.reload();    break;//게임번호변경

  case mx.CMD_RCCLOSE : $('#recordInputModal').modal('hide'); break;

  case mx.CMD_SETSIGN:
  case mx.CMD_SETSHOW:
  case mx.CMD_EXCEPTMAX: //다시그림 랭킹 재계산이 필요할꺼 같다...이것도..
  case mx.CMD_EXCEPTMIN:


  case mx.CMD_SETTIME:
  case mx.CMD_OKYN : return;  break;//확정

  case mx.CMD_RC02:
  case mx.CMD_GAMEINPUTEDITOK: //수정
  case mx.CMD_GAMEINPUTDEL: //삭제


  case mx.CMD_GAMEINPUT2 :
  case mx.CMD_GAMEINPUT :
  case mx.CMD_SETORDER :
  case mx.CMD_SETTIMEALL :
  case mx.CMD_DIVBOO :
  case mx.CMD_SUMBOO :
  case mx.CMD_AUTOSUMBOO :
  
  case mx.CMD_REFRESHBOO_INJUDGE :
  case mx.CMD_SETGAMENO :   this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;//게임번호변경

  case mx.CMD_SUMBOO_INJUDGE :
  case mx.CMD_DIVBOO_INJUDGE :
                    this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    
                    window.location.reload();
                    break;//게임번호변경

  case mx.CMD_CHANGEBOO :
  case mx.CMD_CHANGEWINDOW :
  case mx.CMD_RC01  :   this.OndrowModal( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_SEARCHHORSE :
  case mx.CMD_SEARCHPLAYER : this.ONdrowPlayer(reqcmd, jsondata, htmldata, sender );    break;

  }
};
 


//요청##################################################################
	mx.print = function(){
//		 printElement({ leaveOpen: true, printMode: 'popup' }); 

//$('#printdiv, #kitty-two, #kitty-three').printThis({

//			$('#printdiv').printThis({
//				importCSS: false,
//				loadCSS: "",
//				header: "<h1>대회명을 여기다 넣으면 된다.</h1>"
//			});
	};
	


	//경로위반 체크
	mx.vio = 0; //경로위반 기본값
	mx.mmtotal = 0; //지점총점
	mx.mmmax = 0; 
	mx.mmmin = 0;
	mx.perarr = [0,0,0,0,0];
	mx.maxidx = 0; //max 배열인덱스
	mx.minidx = 0; //min 배열인덱스
	mx.setViolation = function(classnm, maxpt,ptcnt,maxchk,minchk,teamgb){ //클래스 문자열 (s) , 지점별최고점수,지점수, 최고점체크,최저점체크,종목(복합마술구분 20103)
		var inno = $('#off2').val();
		if (inno == '' || inno  < 0 ) {
			$('#off2').val(0);
			inno = 0;
		}
		if (inno != '' && inno  > 10 ) {
			$('#off2').val(10);
			inno = 10;
		}
		if ( inno  > 0 ) {
			$('#off2').val(Number(inno));
		}

		//s 1회 -2% 2회 실권
		//나머지 1회 -0.5% 2회 -1% 3회 실권
		if (classnm == 's')	{
			switch (Number(inno))
			{
			case 0 :  
				mx.vio = 0;
				$('#vio_rt').html('');
				break;
			case 1 :  
				mx.vio = 2;
				$('#vio_rt').html('-2%');
				break;
			case 2 :  
				mx.vio = 200;
				$('#vio_rt').html('실권(E)');
				break;
			default :
				mx.vio = 200;
				$('#vio_rt').html('실권(E)');
				break;
			}
		}
		else{
			switch (Number(inno))
			{
			case 0 :  
				mx.vio = 0;
				$('#vio_rt').html('');
				break;
			case 1 :  
				mx.vio = 0.5;
				$('#vio_rt').html('-0.5%');
				break;
			case 2 :  
				mx.vio = 1;
				$('#vio_rt').html('-1%');
				break;
			default :
				mx.vio = 200;
				$('#vio_rt').html('실권(E)');
				break;
			}		
		}

		if (maxchk == 'Y')	{
			ptcnt = ptcnt - 1;
		}
		if (minchk == 'Y'){
			ptcnt = ptcnt - 1;
		}

		var minusptvalue = 0; //최대최소가 선택시 뺄값

		//총점
		if (mx.vio == 200)	{ //vio  200 실권
			var total = mx.totalPer(maxpt,ptcnt,maxchk,minchk, teamgb);
			mx.mmtotal = total; //지점총점

			//총 비율 : (총점 / (최고기록 가능점수 * 지점수)) * 100
			//var tper = (total / (maxpt *ptcnt)) * 100 ; //이전에 총합으로 구한것.....
			var tper = mx.perarr.reduce(function (preValue, currentValue){return preValue + currentValue; }, 0); //배열요소 더하기 (총비율)
			
			if (maxchk == 'Y')	{
				minusptvalue = mx.perarr[mx.maxidx] ;
			}
			if (minchk == 'Y'){
				minusptvalue += Number(mx.perarr[mx.minidx]) ;
			}

			//tper = tper - (mx.perarr[mx.maxidx] + mx.perarr[mx.minidx] ); //최대 최소값 빼자...더한거에서
			tper = (tper - minusptvalue) / ptcnt; //지점수로 나눈다.
			
			if (Number(teamgb) == 20103){
				$('#pertotal').val(Math.floor(tper * 10)/10); //소수점 한자리 버림
			}
			else{
				$('#pertotal').val(tper.toFixed(3));//소수점 3째자리 반올림
			}

			console.log("각지점비율 : " + mx.perarr);

		}
		else{
			var total = mx.totalPer(maxpt,ptcnt,maxchk,minchk ,teamgb);
			mx.mmtotal = total; //지점총점
			//총 비율 : (총점 / (최고기록 가능점수 * 지점수)) * 100
			//var tper = (total / (maxpt *ptcnt)) * 100 ;
			var tper = mx.perarr.reduce(function (preValue, currentValue){return preValue + currentValue; }, 0); //배열요소 더하기 (총비율)
			
			if (maxchk == 'Y')	{
				minusptvalue = mx.perarr[mx.maxidx] ;
			}
			if (minchk == 'Y'){
				minusptvalue += Number(mx.perarr[mx.minidx]) ;
			}

			//tper = tper - (mx.perarr[mx.maxidx] + mx.perarr[mx.minidx] ); //최대 최소값 빼자...더한거에서
			tper = (tper - minusptvalue) / ptcnt; //지점수로 나눈다.

			//console.log("총비율 : " + tper.toFixed(3));
			if (Number(teamgb) == 20103){
				$('#pertotal').val(Math.floor(tper * 10)/10); //소수점 한자리 버림
			}
			else{
				$('#pertotal').val(tper.toFixed(3));//소수점 3째자리 반올림
			}

			console.log("각지점비율 : " + mx.perarr);

		}
	};


	//지점별 비율 구하기
	mx.setPointValue = function(pointvalue, off1, maxpt){
		var pointper = 0;
		var sumvalue = 0;
		if (mx.vio == 200)	{
			sumvalue = pointvalue - Number(off1) - (maxpt * (0/100) );
		}
		else{
			sumvalue = pointvalue - Number(off1) - (maxpt * (mx.vio/100) );
		}
		pointper = (sumvalue / Number(maxpt) )*100;
		return pointper;
	};

	//총비율계산
	mx.totalPer = function(maxpt,ptcnt,maxchk,minchk ,teamgb){
		//총점 :  지점별 총점 합산-감점-(최고기록 가능점수 X 경로위반 감점비율) >> 아래로 바꾸자.
		//19618 총점 : 지점별 비율을 더한걸로. 그래서 각지점값을 각각 구해야한다.

		var sumvalue = 0;
		//감점
		var off1 = $('#off1').val();
		
		if( off1 == '' ){
			$('#off1').val(0);
			off1 = 0; 
		}
		if ( off1  > 0 ) {
			$('#off1').val(Number(off1));
		}

		var valarr = [0,0,0,0,0];

		 if ($("#total_1").length >0 ){
			 if ( Number($("#total_1").val()) > Number(maxpt)   ){
				 $("#total_1").val(maxpt);
			 }

			 if ($("#total_1").val() != '') {
				sumvalue = sumvalue +  Number($("#total_1").val());
				valarr[0] = Number($("#total_1").val());
				mx.perarr[0] = mx.setPointValue(valarr[0], off1, maxpt);//지점비율 구하기 
			 }
		 }
		 if ($("#total_2").length >0 ){
			 if ( Number($("#total_2").val()) > Number(maxpt)   ){
				 $("#total_2").val(maxpt);
			 }

			 if ($("#total_2").val() != '') {
				sumvalue = sumvalue +  Number($("#total_2").val());
				valarr[1] = Number($("#total_2").val());
				mx.perarr[1] = mx.setPointValue(valarr[1], off1, maxpt);//지점비율 구하기 
			 }
		 }
		 if ($("#total_3").length >0 ){
			 if ( Number($("#total_3").val()) > Number(maxpt)   ){
				 $("#total_3").val(maxpt);
			 }
			 
			 if ($("#total_3").val() != '') {
				sumvalue = sumvalue +  Number($("#total_3").val());
				valarr[2] = Number($("#total_3").val());
				mx.perarr[2] = mx.setPointValue(valarr[2], off1, maxpt);//지점비율 구하기 
			 }
		 }
		 if ($("#total_4").length >0 ){
			 if ( Number($("#total_4").val()) > Number(maxpt)   ){
				 $("#total_4").val(maxpt);
			 }
			 
			 if ($("#total_4").val() != '') {
				sumvalue =sumvalue + Number($("#total_4").val());
				valarr[3] = Number($("#total_4").val());
				mx.perarr[3] = mx.setPointValue(valarr[3], off1, maxpt);//지점비율 구하기 
			 }
		 }
		 if ( $("#total_5").length >0 ){
			 if ( Number($("#total_5").val()) > Number(maxpt)   ){
				 $("#total_5").val(maxpt);
			 }

			 if ($("#total_5").val() != '') {
				sumvalue = sumvalue + Number($("#total_5").val());
				valarr[4] = Number($("#total_5").val());
				mx.perarr[4] = mx.setPointValue(valarr[4], off1, maxpt);//지점비율 구하기 
			 }
		 }

		//최고점 최저점 점수 제거 
		var maxval = Math.max.apply(null, valarr);
		var minval = Math.min.apply(null, valarr);
		mx.mmmax = maxval; 
		mx.mmmin = minval;
 

		//만약 최대 최소를 빼야하는경우라면 총합에서 빼자.
		if (maxchk == 'Y')	{
			mx.maxidx = valarr.indexOf( maxval ); //제거할배열 max 인덱스 
			sumvalue = sumvalue - maxval;
		}
		if (minchk == 'Y'){
			mx.mminidx = valarr.indexOf( minval );
			sumvalue = sumvalue - minval;
		}

		if (mx.vio == 200)	{
			sumvalue = sumvalue - Number(off1) - (maxpt * (0/100) );
		}
		else{
			sumvalue = sumvalue - Number(off1) - (maxpt * (mx.vio/100) );
		}
		console.log("총점 : " + sumvalue);
		console.log("최대:" + maxval);
		console.log("최소:" + minval);
		 return sumvalue;
	};





	
	//소수점 자동 생성 (뒤에 두자리 무조건 소수로 )
	mx.setDotAuto = function(inputid){
		var rcval = String($('#'+inputid).val());

		if( rcval.indexOf(".") != -1 && rcval.length >= 7){
			$('#'+inputid).val( rcval.substr(0,6)  );	
			return;
		}


		if( rcval.indexOf(".") != -1 ){
			rcval = rcval.replace("." , "");
		}

		if(rcval.length >= 3){
			$('#'+inputid).val(			rcval.substr(0, rcval.length-2)+"."+ rcval.substring(rcval.length, rcval.length-2)			);
		}
	};



	mx.setGameNo = function(idx, cngval){
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENO;
		obj.IDX = idx;
		obj.TIDX =mx.gameinfo.IDX;;
		obj.GHANGEGNO = cngval;
		mx.SendPacket('listcontents', obj);
    };
    
    //체크항목 부통합 (공통 GBIDX 인지 확인후)
	mx.sumBooInJudge = function(tIdx, gbIdx, orderType){
		var obj = {};
		var gbidx = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
        obj.CMD = mx.CMD_SUMBOO_INJUDGE;
        obj.TIDX = tIdx;
        obj.GBIDX = gbIdx;  
        obj.ODTYPE = orderType;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#contest_sub").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					if (pregbidx != '' && gbidx != pregbidx){
						alert("대회번호가 다른 항목이 존재합니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt < 2 ){
			alert("항목을 2개이상 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 통합 하시겠습니까?') == false) {
			return;
		}	

		mx.SendPacket('contest_sub', obj);
    };

    //체크항목 원래대로 (공통 GBIDX 인지 확인후)
	mx.divBooInJudge = function(tIdx, gbIdx, orderType){
		var obj = {};
		var gbidx = '';
		var pubcode = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
        obj.CMD = mx.CMD_DIVBOO_INJUDGE;
        obj.TIDX = tIdx;
        obj.GBIDX = gbIdx;  
        obj.ODTYPE = orderType;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#contest_sub").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					pubcode =  trCheck[i].id.split("_")[1];
					if (Number(pubcode) < 7 ){
						alert("통합된 부서가 아닙니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt == 0 || chkcnt >1 ){
			alert("1개의 통합된 부서를 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 분리 하시겠습니까? ') == false) {
			return;
		}	

		mx.SendPacket('contest_sub', obj);
	};
	
    
    //체크항목 부통합 (공통 GBIDX 인지 확인후)
	mx.refreshBooInJudge = function(tIdx, gbIdx,gyear){
		var obj = {};
        obj.CMD = mx.CMD_REFRESHBOO_INJUDGE;
        obj.TIDX = tIdx;
        obj.GBIDX = gbIdx;  
		obj.GYEAR = gyear;

        console.log("tIdx = "+ tIdx + " gbIdx = " + gbIdx);

		mx.SendPacket('contest_sub', obj);
	};

    //자동 부통합 (공통 GBIDX 인지 확인후) 
    // string data는 2차원 배열이다. , |로 구분되어 있다. 
	mx.autoSumBoo = function(strRDetail, strBLimit){

        if( (strRDetail == undefined || strBLimit == undefined ) ||
            (strRDetail == "" || strBLimit == "" ) )
            {
                alert("대회 정보가 없습니다. 잠시후에 다시 시도하세요");
                return;
            }

		var obj = {};
        obj.CMD = mx.CMD_AUTOSUMBOO;
        obj.DETAIL = strRDetail;        // List Array
        obj.LIMIT = strBLimit;          // 부별 Limit Array - 

		mx.SendPacket('listcontents', obj);
	};


	//체크항목 부통합 (공통 GBIDX 인지 확인후)
	mx.sumBoo = function(){
		var obj = {};
		var gbidx = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
		obj.CMD = mx.CMD_SUMBOO;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#listcontents").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					if (pregbidx != '' && gbidx != pregbidx){
						alert("대회번호가 다른 항목이 존재합니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt < 2 ){
			alert("항목을 2개이상 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 통합 하시겠습니까?') == false) {
			return;
		}	

		mx.SendPacket('listcontents', obj);
	};
	
	//체크항목 원래대로 (공통 GBIDX 인지 확인후)
	mx.divBoo = function(){
		var obj = {};
		var gbidx = '';
		var pubcode = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
		obj.CMD = mx.CMD_DIVBOO;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#listcontents").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					pubcode =  trCheck[i].id.split("_")[1];
					if (Number(pubcode) < 7 ){
						alert("통합된 부서가 아닙니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt == 0 || chkcnt >1 ){
			alert("1개의 통합된 부서를 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 분리 하시겠습니까? ') == false) {
			return;
		}	

		mx.SendPacket('listcontents', obj);
	};
	
	//확정버튼
	mx.okYN = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_OKYN;	
		obj.IDX = idx;
		if( $('#okYN_'+idx).text() == '확정(N)' )
		{
			$('#okYN_'+idx).text('확정(Y)');
		}
		else
		{
			$('#okYN_'+idx).text('확정(N)');
		}
		mx.SendPacket('null', obj);
	}
	
	//출전순서표 전체 동일시간 설정
	mx.setTimeAll= function(tidx,findyear){

		if (confirm('전체 경기 시작 시간이 모두 적용됩니다. 적용하시겠습니까?')) {
		} else {
			return;
		}	

		var obj = {};
		obj.CMD = mx.CMD_SETTIMEALL;	
		obj.TIDX = tidx;
		obj.FINDYEAR = findyear;
		obj.TM  = $('#allstarttime').val();
		mx.SendPacket('listcontents', obj);
	};

	mx.setTime= function(tidx,findyear,ttype,idx){
		var obj = {};
		obj.CMD = mx.CMD_SETTIME;	
		obj.TTYPE = ttype;
		obj.H = $('#h'+ ttype + "_" + idx).val();
		obj.M = $('#m'+ ttype + "_" + idx).val();
		obj.IDX = idx;

		$('#h'+ ttype + "_" + idx).css("borderColor","green");
		$('#m'+ ttype + "_" + idx).css("borderColor","green");

		obj.TIDX = tidx;
		if (ttype == "g"){
			obj.GBIDX = findyear;
		}
		obj.FINDYEAR = findyear;
		mx.SendPacket('null', obj);
	};
	
	//출전순서부여
	mx.setOrder =function(tidx,findyear,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_SETORDER;	
		obj.TIDX = tidx;
		obj.FINDYEAR = findyear;
		obj.GBIDX = gbidx;
		mx.SendPacket('listcontents', obj);	
	};

	//기권/실격사유
	mx.setGiveUp =function(tidx,gbidx,idx,ridx, chktype){

		var sayou = $('#giveup_'+ idx).val();
		var msg = "기권/실격내용을 취소 하시겠습니까?";
		switch (sayou)
		{
		case "E": msg ="정말 실권( E) 처리 하시겠습니까?"; break;
		case "R": msg ="정말 기권( R) 진행중 처리 하시겠습니까?"; break;
		case "W": msg ="정말 기권(W) 시작전 처리 하시겠습니까?"; break;
		case "D": msg ="정말 기권( D) 처리 하시겠습니까?"; break;
		}

		if (confirm(msg) == false) {
			return;
		}			

		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUP;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.SAYOU = sayou;
		obj.CHKTYPE = chktype; //경기중인경우 시가을 당기지 않는다.
		$('#giveup_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};

	//사유서제출
	mx.setGiveUpDoc =function(tidx,gbidx,idx,ridx){
		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUPDOC;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.SAYOUDOC = $('#giveupdoc_'+ idx).val();
		$('#giveup_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};

	mx.SelectLevelGb = function(ingno) {
		var obj = {};
		obj.PARR = new Array();
		obj.CMD = mx.CMD_FIND1;
		obj.TitleIDX =mx.gameinfo.IDX;;
		obj.TITLE = mx.gameinfo.TITLE;
		var typechkbox = false;
		for (var i = 0 ; i <= ingno ;i++ ){
			obj.PARR[i] = $("#mk_g"+ i ).val();
		}


		var msgarr = ["","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 "]; //메시지
		var passarrno = [0,1,1,1,1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket('level_form', obj);
	};

	
	//심사지점수 최고점수 저장
	mx.setRecordInit = function(tidx,gbidx){
		if (confirm('경기 중 변경 되면 기록 이 모두 삭제 됩니다. 설정 하시겠습니까?') == false) {
			return;
		}	

		var obj = {};
		obj.CMD = mx.CMD_SETRECORDINIT;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		obj.MAXPT = $('#mk_g5').val();
		if (px.chkValue(obj.MAXPT, "지점별 최고 점수를 입력해 ") == false){
			return;
		}

		var judgenmarr = new Array();
		var trCheck = $("#judgePname").find("input[type=checkbox]");

		var n= 0;
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {
				judgenmarr[n] = $("#"+ trCheck[i].id).val();
				n++;
				console.log(judgenmarr);
			}
		}

		if ( judgenmarr.length < 1 ){
			alert("1개 이상의 심사지점을 선택해 주십시오.");
			return;
		}

		obj.PTSU = judgenmarr.length;
		obj.PTNMARR = judgenmarr;

		//점수가 변경됩니다 .정말 저장하시겠습니까
		$('#mk_g5').css("borderColor","green");
		mx.SendPacket('null', obj);		
	};

	//최적시간
	mx.setRecordInit2 = function(tidx,gbidx){
		if (confirm('경기 중 변경 되면 기록 이 모두 삭제 됩니다. 설정 하시겠습니까?') == false) {
			return;
		}	

		var obj = {};
		obj.CMD = mx.CMD_SETRECORDINIT;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.BESTSC = $('#mk_g8').val();

		if ( obj.BESTSC == "" ){
			obj.BESTSC = 0;
		}

		if (Number(obj.BESTSC) == 0 ){
			alert("최적시간(초)를 정확히 입력해 주십시오.");
			return;
		}


		mx.SendPacket('null', obj);		
	};


	//최고점제거 체크
	mx.setExceptMax = function(tidx,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_EXCEPTMAX;	
		if (  $("#mk_g9").is(":checked")  ){
			obj.YN = "N";
		}
		else{
			obj.YN = "Y";		
		}
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		$('#mk_g9').css("borderColor","green");
		mx.SendPacket('null', obj);		
	};

	mx.setExceptMin = function(tidx,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_EXCEPTMIN;	
		if (  $("#mk_g10").is(":checked")  ){
			obj.YN = "N";
		}
		else{
			obj.YN = "Y";		
		}
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		$('#mk_g10').css("borderColor","green");
		mx.SendPacket('null', obj);		
	};


	mx.setSign = function(tidx,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_SETSIGN;	
		if (  $("#mk_g6").is(":checked")  ){
			obj.SIGN = "N";
		}
		else{
			obj.SIGN = "Y";		
		}
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		$('#mk_g6').css("borderColor","green");
		mx.SendPacket('null', obj);		
	};
	

	mx.setShow = function(tidx,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_SETSHOW;	
		if (  $("#mk_g7").is(":checked")  ){
			obj.SHOW = "N";
		}
		else{
			obj.SHOW = "Y";		
		}
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
	
		$('#mk_g7').css("borderColor","green");
		mx.SendPacket('null', obj);		
	};

	//입력시작 01
	mx.inputRecord = function(idx,tidx,gbidx,rdno,kgame){
		var obj = {};
		obj.CMD = mx.CMD_RC01;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.RDNO = rdno; //장매물 A타입에 사용
		obj.KGAME = kgame; //체전여부
		mx.SendPacket('rcmodalcontents', obj);			
	};


	//마장마술 결과저장
	mx.inputRecordMM = function(idx,tidx,gbidx,pubcode,   classnm, maxpt,ptcnt,maxchk,minchk,teamgb){

		mx.setViolation(classnm, maxpt,ptcnt,maxchk,minchk,teamgb);
		
		var obj = {};
		obj.CMD = mx.CMD_MMRCOK;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.PCODE = pubcode;

		 if ($("#total_1").length >0 ){
			 if ($("#total_1").val() != '') {
				obj.B = $("#total_1").val();
			 }
			 else{
				alert("B 지점의 총점을 입력해 주십시오.");
				return;
			 }
		 }
		 if ($("#total_2").length >0 ){
			 if ($("#total_2").val() != '') {
				obj.E = $("#total_2").val();
			 }
			 else{
				alert("E 지점의 총점을 입력해 주십시오.");
				return;
			 }
		 }
		 if ($("#total_3").length >0 ){
			 if ($("#total_3").val() != '') {
				obj.M = $("#total_3").val();
			 }
			 else{
				alert("M 지점의 총점을 입력해 주십시오.");
				return;
			 }
		 }
		 if ($("#total_4").length >0 ){
			 if ($("#total_4").val() != '') {
				obj.C = $("#total_4").val();
			 }
			 else{
				alert("C 지점의 총점을 입력해 주십시오.");
				return;
			 }
		 }
		 if ( $("#total_5").length >0 ){
			 if ($("#total_5").val() != '') {
				obj.H = $("#total_5").val();
			 }
			 else{
				alert("H 지점의 총점을 입력해 주십시오.");
				return;
			 }
		 }

		var off1 = $('#off1').val();
		 if (off1 == '') {
			$('#off1').val(0);
		 }
		obj.OFF1 = off1;
		
		var off2 = $('#off2').val();
		 if (off2 == '') {
			$('#off2').val(0);
		 }
		obj.OFF2 = off2;

		var pertotal = $('#pertotal').val();
		if (pertotal == '' )	{
			alert("각 지점별 총점을 입력 해주세요.");
			return;
		}
		else{
			obj.PERTOTAL = pertotal;
		}

		obj.MMTOTAL = mx.mmtotal; //지점총점
		obj.MMMAX = mx.mmmax;  //최고점
		obj.MMMIN = mx.mmmin; //최저점
		obj.VIO = mx.vio; //경로위반 감점 내용 
		obj.PTPERARR = mx.perarr; //지점별 비율값(배열)



		mx.SendPacket('rcmodalcontents', obj);
	};


	//마장마술 지점별 입력시 사용 @@@@@@@@@@@@@@
		//입력시작 02
		mx.inputRecord2 = function(idx,tidx,gbidx){
			var obj = {};
			obj.CMD = mx.CMD_RC02;	
			obj.IDX = idx;
			obj.TIDX = tidx;
			obj.GBIDX = gbidx;

			obj.PTLOC = $('input[name="point"]:checked').val();

		if( obj.PTLOC == undefined ){
			alert("심판지점을 선택해 주십시오.");
			return;
		}		
			mx.SendPacket('rcmodalcontents', obj);			
		};


		//입력시작 03저장
		mx.inputRecord3 = function(idx,tidx,gbidx,ptloc,pubcode,prept){
			var obj = {};
			obj.CMD = mx.CMD_RC03;	
			obj.IDX = idx;
			obj.TIDX = tidx;
			obj.GBIDX = gbidx;
			obj.PTLOC = ptloc;
			obj.PREPT = prept; //전에 입력된 종합관찰값

			var pt1 = $('#ptnm1').val();
			var pt2 = $('#ptnm2').val();
			var totalsum = $('#pttotal').val();

			if ( Number(totalsum) > Number($('#mk_g5').val()) ){
					alert('총점이 지점별 최고 기록 가능점수 보다 큼니다.');
					return;
			}

			if (pt1 == ""  || pt2 == "" || totalsum == "")	{
				alert("점수를 입력해 주십시오.");
				return;
			}
			obj.PT1 = pt1;
			obj.PT2 = pt2;
			obj.PTA = totalsum;
			obj.PUBCODE = pubcode;

			//화면 reload 또는 리스트 갱신 location.reload();
			mx.SendPacket('rcmodalcontents', obj);
		};
	//마장마술 지점별 입력시 사용 @@@@@@@@@@@@@@


	mx.ptSum = function(){
		var pt1 = $('#ptnm1').val();
		var pt2 = $('#ptnm2').val();

		if (pt1 == ""  || pt2 == "" )	{
			return;
		}
		var totalsum = parseFloat(pt1) + parseFloat(pt2);
		$('#pttotal').val(totalsum.toFixed(2));
		//console.log(totalsum);

	};

	mx.setScState = function(idx,tidx,gbidx,ptloc){
		var obj = {};
		obj.CMD = mx.CMD_RCCLOSE;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.PTLOC = ptloc;
		mx.SendPacket('rcmodalcontents', obj);
	};

	mx.setGameState = function(idx,tidx,gbidx,stno){
		var obj = {};
		obj.CMD = mx.CMD_SETGAMESTATE;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.STNO = stno;

		if (Number(obj.STNO) == 3 ){
			if (confirm('경기 시작으로 리셋 하시겠습니까?') == false) {
				return;
			}	
		}

		mx.SendPacket('listcontents', obj);	
	};


	//장애물 AB 타입 1단계
	mx.jptSum = function(){
		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();

		if (pt1 == ""  || pt2 == "" )	{
			return;
		}
		var totalsum = parseFloat(pt1) + parseFloat(pt2);
		$('#j_pttotal').val(totalsum.toFixed(2));
		//console.log(totalsum);
	};

	//장애물 C 타입 1단계
	mx.jptSum = function(){
		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();

		if (pt1 == ""  || pt2 == "" )	{
			return;
		}
		var totalsum = parseFloat(pt1) + parseFloat(pt2);
		$('#j_pttotal').val(totalsum.toFixed(2));
		//console.log(totalsum);
	};

	//장애물 B 타입 2단계
	mx.jptSum2 = function(){
		var pt1 = $('#j2_pt1').val();
		var pt2 = $('#j2_pt2').val();

		if (pt1 == ""  || pt2 == "" )	{
			return;
		}
		var totalsum = parseFloat(pt1) + parseFloat(pt2);
		$('#j2_pttotal').val(totalsum.toFixed(2));
		//console.log(totalsum);
	};

	//A타입저장
	mx.inputRecordJok = function(idx, tidx, gbidx,pubcode,rdno,kgame){
		var obj = {};
		obj.CMD = mx.CMD_JRCOK;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.RDNO = rdno;
		obj.KGAME = kgame; //체전여부

		var gametime = $('#j_gametime').val();
		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();
		var totalsum = $('#j_pttotal').val();

		if (gametime == "")	{
			alert("소요시간을  입력하여 주십시오.");
			return;
		}
		if (pt1 == ""  || pt2 == "" || totalsum == "")	{
			alert("점수를 입력해 주십시오.");
			return;
		}

		obj.GT = parseFloat(gametime).toFixed(3);
		obj.PT1 = pt1;
		obj.PT2 = pt2;
		obj.PTA = totalsum;
		obj.PUBCODE = pubcode;

		//화면 reload 또는 리스트 갱신 location.reload();
		mx.SendPacket('rcmodalcontents', obj);	
	};

	//A_1타입저장
	mx.inputRecordJokA_1 = function(idx, tidx, gbidx,pubcode,rdno,kgame,bestsc){
		var obj = {};
		obj.CMD = mx.CMD_JRCOKA_1;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.RDNO = rdno;
		obj.KGAME = kgame; //체전여부
		obj.BESTSC = bestsc; //최적시간

		var gametime = $('#j_gametime').val();
		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();
		var totalsum = $('#j_pttotal').val();

		if (gametime == "")	{
			alert("소요시간을  입력하여 주십시오.");
			return;
		}
		if (pt1 == ""  || pt2 == "" || totalsum == "")	{
			alert("점수를 입력해 주십시오.");
			return;
		}

		obj.GT = parseFloat(gametime).toFixed(3);
		obj.PT1 = pt1;
		obj.PT2 = pt2;
		obj.PTA = totalsum;
		obj.PUBCODE = pubcode;

		//화면 reload 또는 리스트 갱신 location.reload();
		mx.SendPacket('rcmodalcontents', obj);	
	};

	//B타입저장
	mx.inputRecordJok2 = function(idx, tidx, gbidx,pubcode){
		var obj = {};
		obj.CMD = mx.CMD_JRCOK2;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		var gametime = $('#j_gametime').val();
		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();
		var totalsum = $('#j_pttotal').val();

		var gametime_2 = $('#j2_gametime').val();
		var pt1_2 = $('#j2_pt1').val();
		var pt2_2 = $('#j2_pt2').val();
		var totalsum_2 = $('#j2_pttotal').val();

		if (gametime == ""){
			alert("1단계 소요시간을  입력하여 주십시오.");
			return;
		}
		if (  pt1 == ""  || pt2 == "" || totalsum == "" )	{
			alert("1단계 점수를 입력해 주십시오.");
			return;
		}

		if (  pt1 != ""  && pt2 != "" && totalsum != "" ){

			if (pt2_2 != "" && gametime_2 == ""){
				alert("2단계 소요시간을  입력하여 주십시오.");
				return;
			}

			if (gametime_2 != "" && pt2_2 == ""){
				alert("2단계 점수를 입력해 주십시오.");
				return;
			}
		}


		obj.GT = parseFloat(gametime).toFixed(3);
		obj.PT1 = pt1;
		obj.PT2 = pt2;
		obj.PTA = totalsum;

		if (gametime_2 != ""){
			obj.GT_2 = parseFloat(gametime_2).toFixed(3);
			obj.PT1_2 = pt1_2;
			obj.PT2_2 = pt2_2;
			obj.PTA_2 = totalsum_2;
		}
		obj.PUBCODE = pubcode;

		//화면 reload 또는 리스트 갱신 location.reload();
		mx.SendPacket('rcmodalcontents', obj);	
	};

	//C타입저장
	mx.inputRecordJok3 = function(idx, tidx, gbidx,pubcode){
		var obj = {};
		obj.CMD = mx.CMD_JRCOK3;	
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;

		var pt1 = $('#j_pt1').val();
		var pt2 = $('#j_pt2').val();
		var totalsum = $('#j_pttotal').val();


		if (pt1 == ""  || pt2 == "" || totalsum == "")	{
			alert("소요시간 또는 벌초를 입력해 주십시오.");
			return;
		}

		obj.PT1 = parseFloat(pt1).toFixed(3);
		obj.PT2 = parseFloat(pt2).toFixed(3);
		obj.PTA = parseFloat(totalsum).toFixed(3);
		obj.PUBCODE = pubcode;

		//화면 reload 또는 리스트 갱신 location.reload();
		mx.SendPacket('rcmodalcontents', obj);	
	};


	//재경기 라운드생성 (재경기횟수 2회초과 금지)
	mx.makeReGame = function(rdno,tidx,gbidx,kgame, gametype){

		//체크박스 체크한 것이 2개이상인지 체크
		//요청
		var trCheck;
		var midx = new Array();
	
		if (kgame == "Y"){ //체전
			switch (Number(rdno))
			{
			case 1:	trCheck = false; 
				if (confirm('2번째 경기를 생성하시겠습니까?') == false) {
					return;
				}				
			break;//순위뒤집어 생성  (만들지 물어보기)
			case 2:	trCheck = false;
				if (confirm('결승 경기를 생성하시겠습니까?') == false) {
					return;
				}			
			break;//합계후 순위로 생성
			case 3:	trCheck = $("#listcontents2").find("input[type=checkbox]"); break;
			case 4:	trCheck = $("#listcontents3").find("input[type=checkbox]"); break;
			case 5:	alert("재경기횟수는 2회를 초과 할 수 없습니다.."); return; break;	
			}		
		}
		else{
			switch (Number(rdno))
			{
			case 1:	trCheck = $("#listcontents").find("input[type=checkbox]"); break;
			case 2:	trCheck = $("#listcontents1").find("input[type=checkbox]"); break;
			case 3:	alert("재경기횟수는 2회를 초과 할 수 없습니다."); return; break;	
			}
		}

		if (trCheck != false){
			var n= 0;
			for (var i = 0 ; i < trCheck.length ;i++ ){
				if( $("#"+ trCheck[i].id).is(":checked") == true ) {
					midx[n] = $("#"+ trCheck[i].id).val();
					n++;
					console.log(midx);
				}
			}

			if ( midx.length < 2 ){
				alert("최종 단계의 항목을 2개이상 선택해  선택해 주세요." );
				return;
			}
		}

		var obj = {};
		obj.CMD = mx.CMD_JREGAME;	
		obj.RDNO = rdno; //요청한라운드 + 1
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.MIDXS = midx;
		obj.KGAME = kgame;
		obj.ORTYPE = gametype;

		//화면 reload 
		mx.SendPacket('rcmodalcontents', obj);	
	};


	//복합마술 결과 생성
	mx.makeBMResult = function(tidx,gbidx,gbidx2,kgame,gametype){
		var trCheck;
		var obj = {};
		obj.CMD = mx.CMD_BMRESULT;   //mx.CMD_JREGAME;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx; //첫번째 경기
		obj.GBIDX2 = gbidx2; //두번재 경기 
		obj.KGAME = kgame; 
		obj.GAMETYPE = gametype;

		//화면 reload  
		mx.SendPacket('rcmodalcontents', obj);	
	};







	//체전인경우 1(출전순서 뒤집어생성)
	mx.makeKReGame = function(rdno,tid,gbidx){
		switch (Number(rdno))  {
		case 1:  //출전순서 뒤집어새성
			//생성요청
		
		break;
		case 2: //체크한동점자들 3라운드로 생성

		//체크박스 체크한 것이 2개이상인지 체크
		var midx = new Array();
	    var trCheck = $("#listcontents").find("input[type=checkbox]");
		var n= 0;
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {
				midx[n] = $("#"+ trCheck[i].id).val();
				n++;
				console.log(midx);
			}
		}
		if ( midx.length < 2 ){
			alert("항목을 2개이상 선택해  선택해 주세요.");
			return;
		}
		//요청			
		
		break;
		}
	};

	//제경기 단계삭제
	mx.delReGame = function (rdno,tidx,gbidx,kgame){

		if (confirm('삭제할 단계의 기록이 모두 지워집니다. 삭제하시겠습니까?') == false) {
			return;
		}	
		
		var obj = {};
		obj.CMD = mx.CMD_JREGAMEDEL;	
		obj.RDNO = rdno; //요청한라운드 + 1
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.KGAME = kgame;	
		mx.SendPacket('rcmodalcontents', obj);	
	};

	//부변경창 오픈
	mx.changeBoo = function(midx,typeno){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEBOO; //부서변경
		obj.MIDX = midx; 
		obj.TYPENO = typeno;
		mx.SendPacket('rcmodalcontents', obj);			
	};

	//부변경
	mx.changeBooOK = function(midx,typeno, selectpidx){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEBOOOK;	
		obj.MIDX = midx; 
		obj.TYPENO = typeno;
		obj.PIDX = selectpidx;
		mx.SendPacket('rcmodalcontents', obj);			
	};

	//변경창오픈
	mx.changeWindow = function(midx,typeno){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEWINDOW;	
		obj.MIDX = midx; 
		obj.TYPENO = typeno;
		mx.SendPacket('rcmodalcontents', obj);			
	};

	//선수검색
	mx.searchPlayer = function(midx,player){
		var obj = {};
		obj.CMD = mx.CMD_SEARCHPLAYER;	
		obj.MIDX = midx; 
		obj.PNM = player;

		mx.SendPacket('rcmodalcontents', obj);			
	};

	//선수변경
	mx.changePlayer = function(midx,pidx){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEPLAYER;	
		obj.MIDX = midx; 
		obj.PIDX = pidx;
		mx.SendPacket('rcmodalcontents', obj);			
	};

	//선수생성변경
	mx.changeMakePlayer = function(midx){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEMAKEPLAYER;	
		obj.MIDX = midx; 

		if( $('#newpname').val() == "" ){
			alert("이름을 입력해 주십시오.");
			return;
		}
		if( $('#newpno').val() == "" ){
			alert("체육인 번호를 입력해 주십시오.");
			return;		
		}
		if( $('#newpbirth').val() == "" ){
			alert("생년월일을 입력해 주십시오.");
			return;		
		}
		obj.NM = $('#newpname').val();
		obj.KNO = $('#newpno').val();
		obj.BIRTH = $('#newpbirth').val();


		mx.SendPacket('rcmodalcontents', obj);			
	};

	//말검색
	mx.searchHorse = function(midx,player){
		var obj = {};
		obj.CMD = mx.CMD_SEARCHHORSE;	
		obj.MIDX = midx; 
		obj.PNM = player;

		mx.SendPacket('rcmodalcontents', obj);			
	};

	//말변경
	mx.changeHorse = function(midx,pidx){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEHORSE;	
		obj.MIDX = midx; 
		obj.PIDX = pidx;
		mx.SendPacket('rcmodalcontents', obj);			
	};

	//말생성변경
	mx.changeMakeHorse = function(midx){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEMAKEHORSE;	
		obj.MIDX = midx; 

		if( $('#newpname').val() == "" ){
			alert("이름을 입력해 주십시오.");
			return;
		}
		if( $('#newpno').val() == "" ){
			alert("여권번호를 입력해 주십시오.");
			return;		
		}

		obj.NM = $('#newpname').val();
		obj.KNO = $('#newpno').val();

		mx.SendPacket('rcmodalcontents', obj);			
	};


//응답##################################################################

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	//$("#drowbody").scrollTop(window.oriScroll);
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_GAMEINPUTEDIT ){
		mx.init();
	}
};

mx.OndrowModal =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#recordInputModal').modal('show');
};

mx.ONdrowPlayer =  function(cmd, packet, html, sender){
	$('#searchplayers').html(html);
};


mx.OndelHTML =  function(cmd, packet, html, sender){
  var trgbstr = $( "#e_gno").val(); //gameno
  $( ".gametitle_" + trgbstr ).remove();
//  if( cmd == mx.CMD_GAMEINPUTDEL){
//    document.getElementById('gameinput_area').innerHTML = html;
//    mx.init();
//  }
};



/////////////////////////////////////////////////////////
//클릭위치로 돌려놓기
$(document).ready(function(){
	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));

	$("#sc_body").click(function(event){
		window.toriScroll = $("#sc_body").scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});




