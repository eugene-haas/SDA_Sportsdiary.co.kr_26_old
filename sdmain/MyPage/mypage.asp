<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l mypage" v-cloak>


	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">마이페이지</h1>
    </div>
	</div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_myProfile">
			<div class="m_myProfile__imgWrap">
				<div class="m_myProfile__imgOuter">
					<img id="imgMypage" src="http://img.sportsdiary.co.kr/images/SD/img/profile@3x.png" class="m_myProfile__img" alt="">
				</div>
				<img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon_camera.png" class="m_myProfile__imgIcon" alt="">
			</div>

			<p class="m_myProfile__txtWrap">
				<span class="m_myProfile__name">{{name}}({{id}}) 님</span><br>
				<span class="m_myProfile__belong">{{grade}}</span>
			</p>
		</div>

		<ul class="m_myMenuList">
      <li class="m_myMenuList__item">
        <a href="#" @click.prevent="chk_onSubmitMenu('INFO')" class="m_myMenuList__anchor s_info">
          <span class="m_myMenuList__txt">정보관리</span>
        </a>
      </li>

      <li class="m_myMenuList__item">
        <a href="#" @click.prevent="chk_onSubmitMenu('PASS')" class="m_myMenuList__anchor s_password">
          <span class="m_myMenuList__txt">비밀번호 변경</span>
        </a>
      </li>

			<li class="m_myMenuList__item">
        <a href="http://sdmain.sportsdiary.co.kr/sdmain/PushSetting.asp" class="m_myMenuList__anchor s_push">
          <span class="m_myMenuList__txt">앱 알림 수신 설정</span>
        </a>
      </li>
		</ul>

    <ul class="m_myMenuList s_more">
      <li class="m_myMenuList__item">
        <a href="#" @click.prevent="chk_logout" class="m_myMenuList__anchorOut">
          <span class="m_myMenuList__ic"><i class="fa fa-power-off"></i></span>
          <span class="m_myMenuList__txt"> 로그아웃 </span>
        </a>
      </li>
      <li class="m_myMenuList__item">
        <a href="#" @click.prevent="chk_onSubmitMenu('DROP')" class="m_myMenuList__anchorOut">
          <span class="m_myMenuList__ic"><i class="fa fa-sign-out"></i></span>
          <span class="m_myMenuList__txt"> 회원탈퇴 </span>
        </a>
      </li>
    </ul>
	</div>

</div>

<script>
  let app=new Vue({
    el:"#app",
    data:{
      name:null,
      id:null,
      grade:"일반",
    },
    computed:{},
    methods:{
      // sdmain에 위치 //
      // 로그인해야 보임
      // http://riding.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"10000","id":"player11"}

      chk_onSubmitMenu:function(valType){
        let txt_URL="";
        switch(valType){
          case "DROP" : txt_URL = "http://sdmain.sportsdiary.co.kr/sdmain/user_out.asp"; break; //회원탈퇴
          // case "ADD" : txt_URL = "http://sdmain.sportsdiary.co.kr/sdmain/join_MemberTypeGb.asp"; break;	//계정추가
          // case "SET" : txt_URL = "http://sdmain.sportsdiary.co.kr/sdmain/user_account.asp"; break; //종목메인설정
          case "PASS" : txt_URL = "http://sdmain.sportsdiary.co.kr/sdmain/pwd_change.asp"; break; //비밀번호변경
          case "INFO" : txt_URL = "http://sdmain.sportsdiary.co.kr/sdmain/mypage/myinfo.asp"; break; //MY INFO
        }
        location.href=txt_URL;
      },
      chk_logout:function(){
        if(confirm('로그아웃 하시겠습니까?')){
          location.href="http://sdmain.sportsdiary.co.kr/sdmain/logout.asp";
        }else{
          return;
        }
      }
    },
    created:function(){},
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
			const cookiesStr = this.$cookies.get("SD");
			const user_info = (function(){
				const info = {};
				const list = cookiesStr.split('&');
				for (var i = 0; i < list.length; i++) {
					const splitList = list[i].split('=');
					info[splitList[0]] = splitList[1];
				}
				return info;
			})();
			this.name = user_info.UserName || '';
			this.id = user_info.UserID || '';
        // this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        // this.id=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserID")+7);
      }else{
        location.href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp";
      }
    },
  });
</script>
</body>
</html>
