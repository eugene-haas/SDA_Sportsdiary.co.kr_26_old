// radio, checkbox. id랑 for가 연결되게
function popupIdFor(idfor,no){
  return idfor+no;
}

// d-day 계산.  ex) dday=2019.03.19
function dDay(dday){
  let d_arr=dday.split(".");
  let current_day=new Date(),
      set_day=new Date(Number(d_arr[0]), Number(d_arr[1])-1, Number(d_arr[2])),
      gap=set_day.getTime()-current_day.getTime();
  let d_day=Math.ceil(gap/(60*1000*60*24));
  return d_day;
}

// : 추가
function addColon(txt){
  if(txt!=""){
    return ": "+txt;
  }
}

// 대회정보의 팝업 링크
function poplink(txt,len,tidx){
  if(txt=="appli"){// 참가신청
    if(len=="plan"){
      alert("참가신청 기간이 아닙니다.");
    }else if(len=="end"){
      alert("참가신청이 마감되었습니다.");
    }
  }else if(txt=="sketch"){// 현장스케치
    if(len==0 || len==undefined){
      alert("등록된 현장스케치 사진이 없습니다.");
    }else{
      location.href="../Result/stadium_sketch.asp?tidx="+tidx;
    }
  }else if(txt=="contestinfo"){// 대회요강
    location.href="../Result/contest_info.asp?tidx="+tidx;
  }else if(txt=="match"){// 출전순서표
    location.href="../Result/match-sch.asp?tidx="+tidx;
  }else if(txt=="video"){// 경기영상
    if(len==0 || len==undefined){
      alert("등록된 경기영상이 없습니다.");
    }else{
      location.href="../Result/gamevideo.asp";
    }
  }
}

//상단 종목 메인메뉴 URL
function chk_TOPMenu_URL(obj){
  switch(obj) {
    case 'badminton'  : $(location).attr('href', 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
    case 'judo'		: $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
    case 'tennis'   : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
    case 'riding'  : $(location).attr('href', 'http://riding.sportsdiary.co.kr/m_player/main/index.asp'); break;
    case 'bike'     : $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
    case 'swim'  : $(location).attr('href', 'http://sw.sportsdiary.co.kr/main/index.asp'); break;
    default       	: $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
  }
}
