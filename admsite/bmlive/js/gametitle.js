
//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = "/pub/ajax/reqTennisContestlevel.asp";
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
  //  apploading("AppBody", "로딩 중 입니다.");
  //}

  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( mx.IsHttpSuccess( xhr ) ){
      
        //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){       
        //  $('#AppBody').oLoader('hide');
        //}

        mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };

  xhr.send( strdata );
 
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

  var rsp = null;
  var callback = null;
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
      try{
        jsondata = JSON.parse(data); 
      }
      catch(ex)
      {
        
      }
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
    case 100: return;   break; //메시지 없슴
    case 101: mx.ChkIngGame(jsondata);   break; //메시지 없슴
    case 5: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');    break; 
    case 999: console.log(jsondata.SqlQuery);    break; //메시지 없슴
    case 1234: alert('입력중인 경기일수 있으니 테블릿에서 확인해주십시오. 결과처리도 테블릿에서 하여 주십시오.');    break; //경기종료 테블릿 입력 값이 존재하는경우 
    }
  }
  
  switch (Number(reqcmd)) {
  case mx.CMD_SETTOURN:
  case mx.CMD_MAKETEMPPLAYER:
  case mx.CMD_SETRANKING:

  case mx.CMD_INPUTREGION:
  case mx.CMD_SETWINNER:
  case mx.CMD_GAMECANCEL = 50:

//  case mx.CMD_GAMEADDITIONFLAG : 
  case mx.CMD_CHANGESELECTAREA :
  case mx.CMD_FILLINGEMPTYENTRY:
  case mx.CMD_TOURNCHANGESELECTAREA:
  case mx.CMD_SETTOURNJOO:
  case mx.CMD_SETTOURNWINNER:
  case mx.CMD_JOODIVISION:
  case mx.CMD_JOOAREA:
  case mx.CMD_SETCOURT:this.OnReLoad( reqcmd, jsondata, htmldata, sender );   break;

 // case mx.CMD_SETJOO:this.OnReLoadLeague( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_GAMEINPUT:  this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_CONTESTAPPEND:  this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;

  
  case mx.CMD_RoundJoo:
  case mx.CMD_RoundEdit:
  case mx.CMD_LEAGUEJOO:
  case mx.CMD_FIND1:
  case mx.CMD_FIND2:
  case mx.CMD_GAMEINPUTEDITOK:
  case mx.CMD_INSERTGROUPGAMEGB:
  case mx.CMD_INSERTLEVELGB:
  
  case mx.CMD_GAMEINPUTEDIT:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_GAMEINPUTDEL: this.OndelHTML( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_TOURN:
  case mx.CMD_LEAGUE: this.OntableHTML( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_INPUTLEVEL  : this.OnLevelModal( reqcmd, jsondata, htmldata, sender );   break; 
  //case mx.CMD_SETLEAGUERANKING: this.delayHTML( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_SETCOURT_Try: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_RNDNOEDIT: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_SETCOURT_Try:
  case mx.CMD_SETLEAGUERANKING: 
  case mx.CMD_RNDNOEDIT: 
  case mx.CMD_RPOINTEDIT:
  case mx.CMD_SETJOO:

  case mx.CMD_GAMEADDITIONFLAG :  this.OnJooRefresh( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHLEAGUEJOO : this.OnDrawingJoo( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHGAMECOURT  : this.OnDrawingCourt( reqcmd, jsondata, htmldata, sender );   break; 

  case mx.CMD_TOURNLASTROUND  : this.OnlastRDProcess( reqcmd, jsondata, htmldata, sender );   break; 
  case mx.CMD_UPDATEMEMBER:this.OnModalUpdateMember( reqcmd, jsondata, htmldata, sender );   break; 

  }
};
