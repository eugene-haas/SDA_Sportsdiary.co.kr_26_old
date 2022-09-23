﻿function main_move(inx) {
	setCookie(inx);
	if (inx =="1" || inx=="0") {
		location.href = "./adminindex.asp";	
	} else if (inx=="2") {
		location.href = "./request_search.asp";
	} else if (inx=="3") {
		location.href = "./edu_member_search.asp";
	} else if (inx=="4") {
		location.href = "./request_trans_search.asp";
	} else if (inx=="5") {
		location.href = "./member_search.asp";
	} else if (inx=="6") {
		location.href = "./notice_search.asp?gcode=n0001";		
	} else if (inx=="7") {
		location.href = "./stat1_search.asp";
	} else if (inx=="8") {
		location.href = "./subject_search.asp";
	} else if (inx=="9") {
		location.href = "./admin_view.asp";
	} else if (inx=="10") {
		window.open("http://as82.kr/execute/ManualLauncher.exe","iDoctorPro","width=940,height=600,left=100,top=100");
	}
}

function setCookie(no){
	 var d = new Date();
	d.setTime(d.getTime() + (d*24*60*60*1000));
	var expires = "expires="+ d.toUTCString();
	document.cookie = "mno="+no+";"+expires+"; path=/";
}


function sub_move(inx,jnx) {
	if (inx ==1) {
		if (jnx==1)	{
			location.href = "./request_search.asp";
		} else if (jnx==2)	{
			location.href = "./request_team_search.asp";
		} else if (jnx==3)	{
			location.href = "./request_telephone_search.asp";
		} else if (jnx==4)	{
			location.href = "./request_cancel_search.asp?sch_opt2=1";
		} else if (jnx==5)	{
			location.href = "./request_cancel_search.asp?sch_opt2=2";
		} else if (jnx==6)	{
			location.href = "./request_cancel_report.asp";
		} else if (jnx==7)	{
			location.href = "./request_date_change.asp";
		} else if (jnx==8)	{
			location.href = "./request_sale_search_old.asp";
		} else if (jnx==9)	{
			location.href = "./request_none_search.asp";
		} else if (jnx==10)	{
			window.open("../main/group_off_process.asp");
		}
	} else if (inx==2) {
		if (jnx==1)	{
			location.href = "./edu_member_search.asp";
		} else if (jnx==2)	{
			location.href = "./edu_request_search.asp";
		} else if (jnx==3)	{
			location.href = "./online_make_search.asp";
		} else if (jnx==4)	{
			location.href = "./qa1_bank_list.asp";
		} else if (jnx==5)	{
			location.href = "./qa2_list.asp";
		} else if (jnx==6)	{
			location.href = "./test_ck_search.asp";
		} else if (jnx==7)	{
			location.href = "./offline_make_search.asp";
		} else if (jnx==8)	{
			location.href = "./offline_bank_search.asp";
		} else if (jnx==9)	{
			location.href = "./admin_area_search.asp";
		} else if (jnx==10)	{
			location.href = "./class_no.asp";
		} else if (jnx==11)	{
			location.href = "./paper_a_search.asp";
		} else if (jnx==12)	{
			location.href = "./paper_b_search.asp";
		} else if (jnx==13)	{
			location.href = "./tutor_search.asp";
		} else if (jnx==14)	{
			location.href = "./online_test_check.asp";
		} else if (jnx==15)	{
			location.href = "./isu_view.asp";
		} else if (jnx==16)	{
			location.href = "./acc_make_search.asp";
		}
	} else if (inx==3) {
		if (jnx==1)	{
			location.href = "./request_trans_search.asp";
		} else if (jnx==2)	{
			location.href = "./request_book_search.asp";
		} else if (jnx==3)	{
			location.href = "./request_ticket_search.asp";
		} else if (jnx==4)	{
			location.href = "./paytrans_search2_new.asp";
		} else if (jnx==5)	{
			location.href = "./paytrans_search2.asp";
		} else if (jnx==6)	{
			location.href = "./statistics3.asp";
		} else if (jnx==7)	{
			location.href = "./cppay_search.asp";
		} else if (jnx==8)	{
			location.href = "./oppay_search.asp";
		} else if (jnx==9)	{
			location.href = "./paytrans_lb_search.asp";
		} else if (jnx==10)	{
			location.href = "./book_ea_search.asp";
		} else if (jnx==11)	{
			location.href = "./book_sd_search.asp";
		} else if (jnx==12)	{
			location.href = "./coupon_search.asp";
		} else if (jnx==13)	{
			location.href = "./coupon_old_search.asp";
		} else if (jnx==14)	{
			location.href = "./license_search.asp";
		} else if (jnx==15)	{
			location.href = "./payhistory_search.asp";
		} else if (jnx==16)	{
			location.href = "./sms_send_search.asp";
		} else if (jnx==17)	{
			location.href = "./mail_send_search.asp";
		} else if (jnx==18)	{
			location.href = "./acc_daily_search.asp";
		} else if (jnx==19)	{
			location.href = "./acc_last_search.asp";
		} else if (jnx==20)	{
			location.href = "./acc_make_search.asp";
		} else if (jnx==21)	{
			location.href = "./stat16_search.asp";
		} else if (jnx==22)	{
			location.href = "./bookStore_list_2017.asp";
		} else if (jnx==23)	{
			location.href = "./bookMaker_list.asp";
		} else if (jnx==24)	{
			location.href = "./bookDetail_list.asp";
		}
	} else if (inx==4) {
		if (jnx==1)	{
			location.href = "./member_search.asp";
		} else if (jnx==2) {
			location.href = "./member_search.asp?sch_opt3=2";
		} else if (jnx==3) {
			location.href = "./member_out_search.asp";
		} else if (jnx==4) {
			location.href = "./payhistory_search.asp?ldx=4";
		} else if (jnx==5) {
			location.href = "./pointhistory_search.asp";
		} else if (jnx==6) {
			location.href = "./coupon_search.asp?ldx=4";
		} else if (jnx==7) {
			location.href = "./admin_search.asp?sch_opt2=3";
		} else if (jnx==8) {
			location.href = "./admin_search.asp";
		}
	} else if (inx==5) {
		if (jnx==1)	{
			location.href = "./notice_search.asp?gcode=n0002";
		} else if (jnx==2)	{
			location.href = "./notice_search.asp?gcode=n0001";
		} else if (jnx==3)	{
			location.href = "./notice_search.asp?gcode=n0005";
		} else if (jnx==4)	{
			location.href = "./notice_search.asp?gcode=n0004";
		} else if (jnx==5)	{
			location.href = "./notice_study_search.asp";
		} else if (jnx==6)	{
			location.href = "./notice_search.asp?gcode=n0003";
		} else if (jnx==7)	{
			location.href = "./board_search.asp?board_code=n0000s0000";
		} else if (jnx==8)	{
			location.href = "./opp_search.asp?board_code=n0000s0000";
		} else if (jnx==9)	{
			location.href = "./board_search.asp?board_code=tp001";
		} else if (jnx==10)	{
			location.href = "./board_search.asp?board_code=tf001";
		} else if (jnx==11)	{
			location.href = "./board_search.asp?board_code=np001";
		} else if (jnx==12)	{
			location.href = "./board.asp?inx=1";
		} else if (jnx==13)	{
			location.href = "./board.asp?inx=2";
	  /*} else if (jnx==14)	{
			location.href = "./notice_search.asp?gcode=n0102";
		} else if (jnx==15)	{
			location.href = "./board_search.asp?board_code=tp012"; 
		} else if (jnx==13)	{
			location.href = "./board_search.asp?board_code=tf012";  */
		} else if (jnx==14)	{ 
			location.href = "./promotion_search.asp?gcode=a0005";		    //컬럼게시판	
		} else if (jnx==15)	{ 
			location.href = "./board_search.asp?board_code=m0000";		    //법인 튜터모드 학습Q&A		
		} else if (jnx==16)	{ 
			location.href = "./notice_search.asp?gcode=n0103";				//[17년 학부모] 공지사항
		} else if (jnx==17)	{
			location.href = "./board_search.asp?board_code=tp015";			//[17년 학부모] 질문게시판
		} else if (jnx==18)	{
			location.href = "./board_search.asp?board_code=tf015";			//[17년 학부모] 커뮤니티
		/*} else if (jnx==17)	{ //
			location.href = "./notice_search.asp?gcode=n0201";
		} else if (jnx==21)	{
			location.href = "./board_search.asp?board_code=tp021";
		} else if (jnx==22)	{
			location.href = "./board_search.asp?board_code=tf021";
		} else if (jnx==23)	{ //
			location.href = "./board_search.asp?board_code=tf023";
		} else if (jnx==24)	{
			location.href = "./board_search.asp?board_code=tf022";*/

		} else if (jnx==19)	{												// [16년 초등돌봄 ] start
			location.href = "./notice_search.asp?gcode=n0202";
		} else if (jnx==20)	{
			location.href = "./board_search.asp?board_code=tp022";
		} else if (jnx==21)	{
			location.href = "./board_search.asp?board_code=tf024";
		} else if (jnx==22)	{ //
			location.href = "./board_search.asp?board_code=tf025";
		} else if (jnx==23)	{
			location.href = "./board_search.asp?board_code=tf026";			// [16년 초등돌봄 ] end
		} else if (jnx==24)	{
			location.href = "./board_search.asp?board_code=tf027";			// [16년 초등돌봄 ] 입금 확인 게시판 end
			
		} else if (jnx==25)	{ //											// 경기 마을 START
			location.href = "./notice_search.asp?gcode=n0301";
		} else if (jnx==26)	{
			location.href = "./board_search.asp?board_code=tf031";
		} else if (jnx==27)	{
			location.href = "./board_search.asp?board_code=tp031";
		} else if (jnx==28)	{ //
			location.href = "./board_search.asp?board_code=tf032";
		} else if (jnx==29)	{
			location.href = "./board_search.asp?board_code=tp032";
		} else if (jnx==30)	{
			location.href = "./faq_search.asp?board_code=n0001";
		} else if (jnx==31)	{
			location.href = "./faq_search.asp?board_code=n0003";
		} else if (jnx==32)	{
			location.href = "./faq_search.asp?board_code=n0002";
		} else if (jnx==33)	{
			location.href = "./news_search.asp";
		} else if (jnx==34)	{
			location.href = "./webpage_search.asp";
		} else if (jnx==35)	{
			location.href = "./poll_search.asp";
		} else if (jnx==36)	{
			memo_pop('2');
		}
	} else if (inx==6) {
		if (jnx==1)	{
			location.href = "./stat1_search.asp";
		} else if (jnx==2)	{
			location.href = "./stat2_search.asp";
		} else if (jnx==3)	{
			location.href = "./stat3_search.asp";
		} else if (jnx==4)	{
			location.href = "./stat4_search.asp";
		} else if (jnx==5)	{
			location.href = "./stat5_search.asp";
		} else if (jnx==6)	{
			location.href = "./stat17_search.asp";
		} else if (jnx==7)	{
			location.href = "./stat_member_search.asp";
		} else if (jnx==8)	{
			location.href = "./stat7_search.asp";
		} else if (jnx==9)	{
			location.href = "./stat8_search.asp";
		} else if (jnx==10)	{
			location.href = "./stat8_search_keris.asp";
		} else if (jnx==11)	{
			location.href = "./stat9_search.asp";
		} else if (jnx==12)	{
			location.href = "./stat10_search.asp";
		} else if (jnx==13)	{
			location.href = "./sms_send_search.asp?rnx=6";
		} else if (jnx==14)	{
			location.href = "./sms_log_search.asp?rnx=6";
		} else if (jnx==15)	{
			window.open('../sms/sms_group.asp','sms','scrollbars=no,resizable=no');
		} else if (jnx==16)	{
			location.href = "./mail_send_search.asp?rnx=6";
		} else if (jnx==17)	{
			location.href = "./research_result_search.asp";
		} else if (jnx==18)	{
			location.href = "./stat15_search.asp?rnx=4";
		} else if (jnx==19)	{
			location.href = "./stat15_search.asp?rnx=5";
		} else if (jnx==20)	{
			location.href = "./stat11_search.asp";
		} else if (jnx==21)	{
			location.href = "./stat13_search.asp";
		} else if (jnx==22)	{
			window.open("http://weblog.cafe24.com");
		}
	} else if (inx==7) {
		if (jnx==1)	{
			location.href = "./ncode_search.asp";
		} else if (jnx==2)	{
			location.href = "./ncode_search.asp?sch_opt5=4";
		} else if (jnx==3)	{
			location.href = "./ncode_search.asp?sch_opt5=3";
		} else if (jnx==4)	{
			location.href = "./ncode_search.asp?sch_opt5=2";
		} else if (jnx==5)	{
			location.href = "./ncode_search.asp?sch_opt5=5";
		} else if (jnx==6)	{
			location.href = "./ncode_search.asp?sch_opt5=6";
		} else if (jnx==7)	{
			location.href = "./ncode_search.asp?sch_opt5=7";
		} else if (jnx==8)	{
			location.href = "./ncode_search.asp?sch_opt5=8";
		} else if (jnx==9)	{
			location.href = "./pcate_search.asp?gcode=p0001";
		} else if (jnx==10)	{
			location.href = "./subject_search.asp";
		} else if (jnx==11)	{
			location.href = "./book_search.asp";
		} else if (jnx==12)	{
			location.href = "./pcate_search.asp?gcode=s0002";
		} else if (jnx==13)	{
			location.href = "./pcate_search.asp?gcode=s0001";
		} else if (jnx==14)	{
			location.href = "./research_search.asp";
		} else if (jnx==15 || jnx==16)	{
			location.href = "./pcate_search.asp?gcode=n0001";
		} else if (jnx==17)	{
			location.href = "./mcate_search.asp?gcode=n0006";
		} else if (jnx==18)	{
			location.href = "./mcate_search.asp?gcode=n0016";
		} else if (jnx==19)	{
			location.href = "./pcate_search.asp?gcode=n0002";
		} else if (jnx==20)	{
			location.href = "./pcate_search.asp?gcode=n0003";
		} else if (jnx==21)	{
			location.href = "./pcate_search.asp?gcode=n0004";
		} else if (jnx==22)	{
			location.href = "./pcate_search.asp?gcode=tp001";
		} else if (jnx==23)	{
			location.href = "./pcate_search.asp?gcode=tf001";
		} else if (jnx==24)	{
			location.href = "./pcate_search.asp?gcode=np001";
		} else if (jnx==25)	{
			location.href = "./pcate_search.asp?gcode=n0010";
		} else if (jnx==26)	{
			location.href = "./pcate_search.asp?gcode=n0011";
		} else if (jnx==27)	{
			location.href = "./pcate_search.asp?gcode=n0012";
		} else if (jnx==28)	{
			location.href = "./school_search.asp";
		}
	} else if (inx==8) {
		if (jnx==1)	{
			location.href = "./banner_newModelsubMenuImg.asp";
		} else if (jnx==2)	{
			location.href = "./banner_newModelsubMenuImg.asp";	//메뉴-서브메뉴 옆이미지			
		} else if (jnx==3)	{
			location.href = "./banner_newModel.asp";				//메인화면관리	
		} else if (jnx==4)	{
			location.href = "./banner_newModelImages.asp";			//메인이미지변경
		} else if (jnx==5)	{
			location.href = "./banner_top.asp";			//상단롤링배너						
		} else if (jnx==6)	{
			location.href = "./banner_top.asp";			//상단롤링배너			
		} else if (jnx==7)	{
			location.href = "./banner_search.asp?gcode=n0001";			//메인관리 
		} else if (jnx==8)	{
			location.href = "./contents_view.asp?gcode=n0001";			//직무연수모집안내 
		} else if (jnx==9)	{
			location.href = "./banner_search.asp?gcode=n0006";			//우측 이벤트Tab 배너1
		} else if (jnx==10)	{
			location.href = "./banner_search.asp?gcode=n0002";			//우측 이벤트Tab 배너2
		} else if (jnx==11)	{
			location.href = "./contents_view.asp?gcode=n0002";			//우측 인기과Tab
		} else if (jnx==12)	{
			location.href = "./contents_view.asp?gcode=n0003";			//우측 신규과정Tab 
		} else if (jnx==13)	{
			location.href = "./contents_view.asp?gcode=n0004";			//우측 추천과정Tab
		} else if (jnx==14)	{
			location.href = "./banner_search.asp?gcode=n0004";			//신규추천과정 배너
		} else if (jnx==15)	{
			location.href = "./banner_search.asp?gcode=n0003";			//로그인배너
		} else if (jnx==16)	{
			location.href = "./system_search.asp?gcode=n0013";			//직무연수안내 설정
		} else if (jnx==17){
			location.href = "./banner_process_detail.asp";				//과정상세 배너설정
		} else if (jnx==18)	{
			location.href = "./promotion_search.asp?gcode=a0001";		//테마추천 과정안내 
		} else if (jnx==19)	{
			location.href = "./promotion_search.asp?gcode=a0002";		//현장스케치(단체연수)
		} else if (jnx==20)	{
			location.href = "./promotion_search.asp?gcode=a0003";		//MOU소식
		} else if (jnx==21)	{
			location.href = "./contents_view.asp?gcode=n0006";			//마일리지안내
		} else if (jnx==22)	{
			location.href = "./contents_view.asp?gcode=n0008";			//스마트이러닝 안내
		} else if (jnx==23)	{
			location.href = "./contents_view.asp?gcode=n0007";			//기업연혁
		} else if (jnx==24)	{
			location.href = "./promotion_search.asp?gcode=a0004";		//이벤트알림정보
		} else if (jnx==25)	{
			location.href = "./other_info.asp";							//로그인연동링크 및 기타
		} else if (jnx==26)	{
			location.href = "./system_search.asp?gcode=n0014";			//메인공지뷰설정
		} else if (jnx==27)	{
			location.href = "./main_best5.asp";							//메인 베스트5설정
		} else if (jnx==28)	{
			location.href = "./banner_search.asp?gcode=n0007";			//모바일메인배너
		}
	} else if (inx==9) {
		if (jnx==1)	{
			location.href = "./groupstudy_search.asp";
		} else if (jnx==2)	{
			location.href = "./groupstudy_manage.asp";
		} else if (jnx==3)	{
			location.href = "./groupstudy_contents.asp";
		} else if (jnx==4)	{
			location.href = "./groupstudy_contentsTake.asp";
		} else if (jnx==5)	{
			location.href = "./groupstudy_mou.asp";
		} else if (jnx==6)	{
			location.href = "./groupstudy_businessHistory.asp";
		} else if (jnx==7)	{
			location.href = "./promotion_search.asp?gcode=a0006";			//학부모연수관리 
		}								
	}
}

function mainTabControl(lmni) {
	if (document.getElementById("maintabmnu" + lmni).style.display=="block") {
		document.getElementById("maintabmnu" + lmni).style.display="none";
		document.getElementById("maintabimg" + lmni).src="./admin_images/lmnu" + lmni + "_off.gif";
	} else {
		document.getElementById("maintabmnu" + lmni).style.display="block";
		document.getElementById("maintabimg" + lmni).src="./admin_images/lmnu" + lmni + "_on.gif";
	}
}

function memo_pop(k) {
	var tmps = String(k);
	var p_h = 382;
	var p_w = 399;	
	if (tmps.length <= 1) {
		window.open("./memo_view.asp?inx=" + tmps, "memo_pop", "scrollbars=auto,resizable=yes,width=" + String(p_w) + ",height=" + String(p_h) + ",left=" + String((screen.width-p_w)/2) + ",top=" + String((screen.height-p_h)/2));
	} else {
		window.open("./memo_view.asp?inx=3&send_id=" + tmps, "memo_pop", "scrollbars=auto,resizable=yes,width=" + String(p_w) + ",height=" + String(p_h) + ",left=" + String((screen.width-p_w)/2) + ",top=" + String((screen.height-p_h)/2));
	}
}

function area_pop(ncode) {
		common_frame2.location.href = "../loading.htm";
		PopStatic_Menu();
		document.getElementById('plyr_back').style.display = "block";
		document.getElementById('plyr_fore').style.display = "none";	
		document.getElementById('plyr_quick').style.display = "block";
		common_frame2.location.href = "../sub/area_search.asp?ncode=" + ncode;
}

function replaceAllForSpecialChar(val){
	//변수를 선언하고
	var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;

	//replace 에서 사용합니다.
	return val.replace(re, "");
}
