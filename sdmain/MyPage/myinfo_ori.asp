<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l m_bg_edf0f4 myinfo" v-cloak>

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">마이페이지</h1>
    </div>
	</div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <form name="s_frm" method="post">
		  <fieldset>
		    <legend>마이페이지 내정보 관리</legend>

				<p class="m_guideTxt">기본정보</p>

		    <ul class="m_form">
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">아이디</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{id}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이름</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{myinfo_data.NAME}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">성별</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{myinfo_data.GENDER=="Man"?"남자":"여자"}}</span>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">생년월일</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{birthdayDot(myinfo_data.BIRTHDAY)}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">휴대폰<span class="m_form__labelTxtStar">＊</span></p>
		        <div class="m_form__inputWrap">

		          <select name="UserPhone1" id="UserPhone1" class="m_form__select s_phone" v-model="phoneNo1">
		            <option value="010">010</option>
		            <option value="011">011</option>
		            <option value="016">016</option>
		            <option value="017">017</option>
		            <option value="018">018</option>
		            <option value="019">019</option>
		          </select>

		          <span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone2" id="UserPhone2" class="m_form__input s_phone" maxlength="4" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" v-model="phoneNo2"/>
							<span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone3" id="UserPhone3" class="m_form__input s_phone" maxlength="4" v-model="phoneNo3" />
							<a href="#" @click.prevent="chk_sms" class="m_form__btn s_phone" id="sms_button">인증</a>
		        </div>
		      </li>
		      <li id="CHK_REAUTH" class="m_form__item s_linkedItem s_hidden">
		        <p class="m_form__labelWrap s_hidden">휴대폰 인증번호 입력</p>
		        <div class="m_form__inputWrap">
		          <input type="number" name="Re_Auth_Num" id="Re_Auth_Num" class="m_form__input s_phoneAuth" placeholder="인증번호 입력" v-model="re_auth_num" />
		          <a href="#" @click.prevent="chk_Auth_Num" class="m_form__btn s_phoneAuth">확인</a>
							<p id="chk_Agree" class="m_form__txt s_alert"></p>
						</div>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">휴대폰 수신동의</p>
		        <div class="m_form__inputWrap">
		          <label for="AgreeSMS" class="m_form__checkWrap img-replace sms" v-bind:class="{on: smsyn}">
								수신동의<input type="checkbox" name="AgreeSMS" id="AgreeSMS" class="m_form__check" v-model="smsyn" @change="checkyn" />
		          </label>
							<p class="m_form__infoTxt">
								<span>※</span>대회정보, 선수정보, 이벤트 및 광고 등 다양한 정보를 SMS로 받아 보실 수 있습니다.
							</p>
		        </div>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이메일</p>
		        <p class="m_form__inputWrap">
		          <input type="text" name="UserEmail1" id="UserEmail1" placeholder="sample123456" class="m_form__input s_email" v-model="email1" />
		          <span class="m_form__txt s_email">@</span>
		          <input type="text" name="UserEmail2" id="UserEmail2" placeholder="hanmail.net" class="m_form__input s_email" v-model="email2"/>
              <select name="EmailList" id="EmailList" class="m_form__select" v-model="email_custom" @change="chk_Email">
		            <option value="">직접입력</option>
		            <option value="gmail.com">gmail.com</option>
		            <option value="daum.net">daum.net</option>
		            <option value="hotmail.com">hotmail.com</option>
		            <option value="naver.com">naver.com</option>
		            <option value="nate.com">nate.com</option>
		          </select>
		        </p>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">이메일 수신동의</p>
		        <p class="m_form__inputWrap">
		          <label for="AgreeEmail" class="m_form__checkWrap img-replace sms" v-bind:class="{on: emailyn}">
								수신동의<input type="checkbox" name="AgreeEmail" id="AgreeEmail" class="m_form__check" v-model="emailyn" @change="checkyn" />
		          </label>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">주소</p>
		        <p class="m_form__inputWrap">
		          <input type="text" readonly name="ZipCode" id="ZipCode" class="m_form__input s_post" v-model="zipcode" />
		          <a href="#" @click.prevent="execDaumPostCode" class="m_form__btn s_post">우편번호 검색</a>
		          <input type="text" readonly name="UserAddr" id="UserAddr" class="m_form__input" v-model="addr" />
		          <input type="text" name="UserAddrDtl" id="UserAddrDtl" class="m_form__input" placeholder="나머지 주소 입력" v-model="addr_detail"/>
		        </p>
		      </li>
		    </ul>
		  </fieldset>
		</form>

		<div class="m_bottomBtn">
			<a href="./mypage.asp" class="m_bottomBtn__btn s_cancel">수정취소</a>
			<a href="#" @click.prevent="chk_frm" class="m_bottomBtn__btn s_modify">수정완료</a>
		</div>
	</div>

  <!--S: 다음 주소찾기 API-->
  <div id="wrap" style="display: none; border:1px solid #000; width:100%; height:100%; margin:48px 0; position: absolute; top:0; z-index:1000;"> <img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" @click="foldDaumPostCode" alt="접기 버튼"> </div>
</div>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
  let app=new Vue({
    el:"#app",
    data:{
      id:null,
      myinfo_data:[],
      phoneNo_ori:null,// 저장된 기본 폰 번호
      phoneNo1:null,
      phoneNo2:null,
      phoneNo3:null,
      email1:null,
      email2:null,
      email_custom:false,// 직접입력인지 아닌지
      zipcode:null,
      addr:null,
      addr_detail:null,
      smsyn:null,
      emailyn:null,
      chk_smsyn:null,
      chk_emailyn:null,

      // 인증
      hidden_sms:"N",
      hidden_phoneNo1:null,
      hidden_phoneNo2:null,
      hidden_phoneNo3:null,
      phone_no_change:false,//
      auth_num:"",
      re_auth_num:"",

      ele_wrap:null,// 우편번호 찾기 화면을 넣을 element
    },
    computed:{},
    methods:{
      // sdmain에 위치 //
      // 로그인해야 보임
      // 받을 때
      // http://riding.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"10000","id":"player11"}
      // 보낼 때
      // http://sdmain.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"11000","id":"player11","PHONE":"010-9716-0512","SMSYN":"Y","EMAIL":"phsk2000@gmail.com","EMAILYN":"Y","ZIPCODE":"10005","ADDRESS":"어드렛스","ADDRESSDTL":"디테일을살리고"}
      // 업데이트 잘되면 {"jlist": "OK"} 안되면 {"jlist": "NOT"}
      myInfoData:function(url){
        axios.get(url).then(response=>{
          if(response.data.jlist.length!=undefined){
            this.myinfo_data=response.data.jlist[0];
            this.phoneNo_ori=this.myinfo_data.PHONE;
            this.phoneNo1=this.hidden_phoneNo1=this.myinfo_data.PHONE.split("-")[0];
            this.phoneNo2=this.hidden_phoneNo2=this.myinfo_data.PHONE.split("-")[1];
            this.phoneNo3=this.hidden_phoneNo3=this.myinfo_data.PHONE.split("-")[2];
            this.email1=this.myinfo_data.EMAIL.split('@')[0];
            this.email2=this.email_custom=this.myinfo_data.EMAIL.split('@')[1];
            if(this.email_custom!="gmail.com" || this.email_custom!="daum.net" || this.email_custom!="hotmail.com" || this.email_custom!="naver.com" || this.email_custom!="nate.com"){
              this.email_custom="";
            }
            this.zipcode=this.myinfo_data.ZIPCODE;
            this.addr=this.myinfo_data.ADDRESS;
            this.addr_detail=this.myinfo_data.ADDRESSDTL;

            this.smsyn=this.myinfo_data.SMSYN=="Y"? true : false;
            this.emailyn=this.myinfo_data.EMAILYN=="Y"? true : false;
            this.chk_smsyn=this.myinfo_data.SMSYN;
            this.chk_emailyn=this.myinfo_data.EMAILYN;
          }else{
            this.myinfo_data=response.data.jlist;
          }
        },(error)=>{
          console.log("error. myInfoData");
          console.log(error);
        });
      },
      //
      birthdayDot:function(day){
        if(day!=undefined){
          let txt=day.substr(0,4)+"."+day.substr(4,2)+"."+day.substr(6,2);
          return txt;
        }
      },

      // email change
      chk_Email:function(){
        if(this.email_custom!=""){
          this.email2=this.email_custom;
        }else{
          this.email2="";
          document.getElementById("UserEmail2").focus();
        }
      },

      // 우편번호 찾기 화면 닫기
      foldDaumPostCode:function(){
        this.ele_wrap.style.display="none";
      },
      // 우편번호 찾기 화면
      execDaumPostCode:function(){
        // 현재 scroll 위치 저장
        let currentScroll=Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        document.body.scrollTop=document.documentElement.scrollTop=0;
        new daum.Postcode({
          oncomplete:function(data){
            // 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분

            // 각 주소의 노출 규칙에 따라 주소를 조합
            // 내려오는 변수가 값이 없는 경우엔 공백("")값을 가지므로, 이를 참고하기 분기
            let fulladdr=data.address,// 최종 주소
                extraAddr="";// 조합형 주소
            
            // 기본 주소가 도로명 타입일 때 조합
            if(data.addressType==="R"){
              // 법정동명이 있을 경우 추가
              if(data.bname!==""){
                extraAddr+=data.bname;
              }
              // 건물명이 있을 경우 추가
              if(data.buildingName!==""){
                extraAddr+=(extraAddr!==""?", "+data.buildingName:data.buildingName);
              }
              fulladdr+=(extraAddr!==""?" ("+extraAddr+")":"");
            }
            // 우편번호와 주소 정보를 해당 필드에 넣음
            app.zipcode=data.zonecode;// 5자리 새 우편번호 사용
            app.addr=fulladdr;
            app.addr_detail="";
            document.getElementById("UserAddrDtl").focus();

            // iframe을 넣은 element를 안보이게
            // autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않음
            app.ele_wrap.style.display="none";

            // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치 되돌림
            document.body.scrollTop=document.documentElement.scrollTop=currentScroll;
          },
          onresize:function(size){
            app.ele_wrap.style.height=size.height+"px";
          },
          width:"100%",
          height:"100%"
        }).embed(app.ele_wrap);
        // iframe을 넣은 element를 보이게 한다
        this.ele_wrap.style.display="block";
      },
      
      //
      checkyn:function(){
        this.smsyn? this.chk_smsyn="Y" : this.chk_smsyn="N";
        this.emailyn? this.chk_emailyn="Y" : this.chk_emailyn="N";
      },

      // 회원정보 수정항목 체크
      chk_frm:function(){
        // 휴대폰 번호 체크
        if(this.phoneNo2==""){
          alert("휴대폰 번호를 입력해주세요.")
          document.getElementById("UserPhone2").focus();
          return
        }
        if(this.phoneNo3==""){
          alert("휴대폰 번호를 입력해주세요.")
          document.getElementById("UserPhone3").focus();
          return
        }

        // sms 인증체크(휴대폰 번호가 바뀌었는지)
        if(this.phoneNo_ori==(this.phoneNo1+"-"+this.phoneNo2+"-"+this.phoneNo3)){
          this.hidden_sms="Y";
        }
        if(this.hidden_sms=="N"){
          alert("휴대폰 인증을 진행해 주세요");
          document.getElementById("sms_button").focus();
          return;
        }

        // sms 인증 후 휴대폰 번호가 변경되었는지
        if(this.phoneNo1!=this.hidden_phoneNo1 || this.phoneNo2!=this.hidden_phoneNo2 || this.phoneNo3!=this.hidden_phoneNo3){
          this.hidden_sms="N";
          this.auth_num="";
          this.re_auth_num="";
          alert("휴대폰 번호가 변경되었습니다. 재인증을 받아주세요.");
          $("#sms_button").text("인증");
          return;
        }

        // email 체크
        if(!this.email1 || !this.email2){
          let reg=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/,
              email=this.email1.replace(/ /g,"")+"@"+this.email2.replace(/ /g,"");
          if(!reg.test(email)){
            alert("잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요")
            return;
          }
        }

        // 휴대폰인증이 끝났다면
        if(this.hidden_sms=="Y"){
          // http://sdmain.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"11000","id":"player11","PHONE":"010-9716-0512","SMSYN":"Y","EMAIL":"phsk2000@gmail.com","EMAILYN":"Y","ZIPCODE":"10005","ADDRESS":"어드렛스","ADDRESSDTL":"디테일을살리고"
          // 휴대폰 인증하면 아래 추가
          // ,"PHONEAUTH":"OK"}

          // let sendurl="../ajax/join_mod_OK.asp";
          let userphone=this.phoneNo1+"-"+this.phoneNo2.replace(/ /g,"")+"-"+this.phoneNo3.replace(/ /g,""),
              useremail=this.email1.replace(/ /g,"")+"@"+this.email2.replace(/ /g,"");
          let sendurl;
          if(this.phone_no_change){
            sendurl='http://sdmain.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"11000","id":"'+this.id+'","PHONE":"'+userphone+'","SMSYN":"'+this.chk_smsyn+'","EMAIL":"'+useremail+'","EMAILYN":"'+this.chk_emailyn+'","ZIPCODE":"'+this.zipcode+'","ADDRESS":"'+this.addr+'","ADDRESSDTL":"'+this.addr_detail+'","PHONEAUTH":"OK"}';
          }else{
            sendurl='http://sdmain.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"11000","id":"'+this.id+'","PHONE":"'+userphone+'","SMSYN":"'+this.chk_smsyn+'","EMAIL":"'+useremail+'","EMAILYN":"'+this.chk_emailyn+'","ZIPCODE":"'+this.zipcode+'","ADDRESS":"'+this.addr+'","ADDRESSDTL":"'+this.addr_detail+'"}';
          }
          axios({
            method:"POST",
            url:sendurl
          }).then(response=>{
            // console.log(response);
            // console.log(response.data.jlist);
            if(response.data.jlist=="OK"){
              alert("정보를 업데이트 하였습니다.");
              document.body.scrollTop=document.documentElement.scrollTop=0;
							$("form[name=s_frm]").attr("action","./myinfo.asp");
							$("form[name=s_frm]").submit();
            }else{
							alert("회원정보 수정에 실패하였습니다.\n관리자에게 문의하세요.");
							return;
            }
          }).catch(error=>{
            console.log("수정 실패");
            console.log("failed : "+error);
            if(error!=""){
              alert("오류발생! - 시스템관리자에게 문의하십시오!");
              return;
            }
          });
        }
      },

      // sms 인증
      chk_sms:function(){
        // 휴대폰 번호 체크
        if(this.phoneNo2==""){
          alert("휴대폰 번호를 입력해주세요.")
          document.getElementById("UserPhone2").focus();
          return
        }
        if(this.phoneNo3==""){
          alert("휴대폰 번호를 입력해주세요.")
          document.getElementById("UserPhone3").focus();
          return
        }

        // 휴대폰 인증체크 여부
        if(this.hidden_sms=="N"){
          // 인증진행
          let authurl="../ajax/Check_AuthNum.asp";
          axios({
            method:"POST",
            url:authurl,
            params:{UserPhone1:this.phoneNo1, UserPhone2:this.phoneNo2, UserPhone3:this.phoneNo3}
          }).then(response=>{
            // console.log(response.data);
            if(response){
              let strcut=response.data.split("|");
              // console.log("strcut : "+strcut);

              if(strcut[0]=="TRUE"){
                this.auth_num=strcut[1];
                this.hidden_phoneNo1=strcut[2];
                this.hidden_phoneNo2=strcut[3];
                this.hidden_phoneNo3=strcut[4];
                this.phone_no_change=true;

								$("#CHK_REAUTH").css({"display":"flex"});
								$("#sms_button").text("다시받기");
								alert("인증번호가 발송 되었습니다.\n통신사 사정에 따라 최대 1분이 소요될 수 있습니다.");
                document.getElementById("Re_Auth_Num").focus();
              }else{
                alert("인증번호가 발송되지 않았습니다.\n휴대폰 번호를 확인해 주세요.")
                return;
              }
            }
          }).catch(error=>{
            console.log("휴대폰 인증체크 실패");
            console.log("failed : "+error);
            if(error!=""){
              alert("오류발생! - 시스템관리자에게 문의하십시오!");
              return;
            }
          });
        }
      },
      // 전송된 인증번호 체크
      chk_Auth_Num:function(){
        if(this.re_auth_num==""){
          alert("인증번호를 입력해 주세요.");
          document.getElementById("Re_Auth_Num").focus();
          return;
        }else{
          if(this.auth_num!=this.re_auth_num){
            alert("휴대폰 인증이 실패하였습니다.\n다시 확인해 주세요.");
            this.hidden_sms="N";
            this.re_auth_num="";
            return;
          }else{
            alert("휴대폰 인증이 완료되었습니다.");
            $("#CHK_REAUTH").hide();
            this.hidden_sms="Y";
            $("#sms_button").text("인증완료");
            $("#sms_button").removeAttr("href").attr("disabled", "disabled");
            return;
          }
        }
      },
    },
    created:function(){},
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.id=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserID")+7);
        this.myInfoData('http://sdmain.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"10000","id":"'+this.id+'"}');
      }

      this.ele_wrap=document.getElementById("wrap");
    },
  });
</script>
</body>
</html>
