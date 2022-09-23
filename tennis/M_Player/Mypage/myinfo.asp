<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
  <!-- #include file="../Library/sub_config.asp" -->

	<%
	   	'Myinfo.asp 출력 및 수정페이지
	    '종목계정사용 안함으로 로그인체크 아래 주석처리
	    'Check_Login()	'request.Cookies(SportsGb)("MemberIDX")

		dim Cookie_SDMemberIDX  : Cookie_SDMemberIDX  = decode(request.Cookies("SD")("MemberIDX"),0)
		dim UserID        		: UserID      		= request.Cookies("SD")("UserID")
		dim UserName      		: UserName      	= request.Cookies("SD")("UserName")
		dim SportsType      	: SportsType    	= request.Cookies(SportsGb)("SportsGb")
		dim EnterType      	 	: EnterType     	= request.Cookies(SportsGb)("EnterType")
		dim chk_IMG 			: chk_IMG 			= FALSE 								'이미지첨부유무

	    '선수보호자의 경우 선수 MemberIDX 교체되었기 때문에 선수보호자의 MemberIDX 로 대입
	   	'/Libary/common_function.asp
		dim MemberIDX			: MemberIDX 		= COOKIE_MEMBER_IDX()

		dim CSQL, CRs

	    '서브계정 가입정보 있는 경우
	    IF MemberIDX <> "" Then

	        CSQL = "        SELECT T.* "
	        CSQL = CSQL & "   	,M.UserEnName "
	        CSQL = CSQL & "   	,M.UserPhone "
	        CSQL = CSQL & "   	,M.Email "
	        CSQL = CSQL & "   	,CONVERT(CHAR, CONVERT(DATE, M.Birthday), 102) Birthday "
	        CSQL = CSQL & "   	,M.Sex "
	        CSQL = CSQL & "   	,M.ZipCode "
	        CSQL = CSQL & "   	,M.Address "
	        CSQL = CSQL & "   	,M.AddressDtl "
	        CSQL = CSQL & "   	,M.EmailYn "
	        CSQL = CSQL & "   	,M.SmsYn "
	        CSQL = CSQL & "   	,ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', T.Team),'') TeamNm"
	        CSQL = CSQL & "   	,ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', T.Team2),'') TeamNm2"
	        CSQL = CSQL & "   	,CASE T.PlayerReln WHEN 'T' THEN L.PersonNum WHEN 'R' THEN P.PersonCode ELSE '' END PersonCode "
	        CSQL = CSQL & "   	,[SD_Tennis].[dbo].[FN_PubName]('sd03900' + T.LeaderType) LeaderTypeNm "
	        CSQL = CSQL & "   	,P.UserName PlayerName"
	        CSQL = CSQL & "   	,P.Birthday	PlayerBirth"
	        CSQL = CSQL & "   	,P.UserPhone PlayerPhone"
	        CSQL = CSQL & "   	,CASE P.SEX WHEN 'Man' THEN '남자' ELSE '여자' END PlayerSEX"
	        CSQL = CSQL & "   	,ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', P.Team),'') PlayerTeamNm "
	        CSQL = CSQL & "   	,ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', P.Team2),'') PlayerTeamNm2 "
	        CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] M "
	        CSQL = CSQL & "     inner join [SD_Tennis].[dbo].[tblMember] T on M.UserID = T.SD_UserID AND T.DelYN = 'N' AND T.MemberIDX = '"&MemberIDX&"' AND T.SportsType = '"&SportsGb&"' "
	        CSQL = CSQL & "     left join [SD_Tennis].[dbo].[tblLeader] L on T.LeaderIDX = L.LeaderIDX AND L.DelYN = 'N' AND L.SportsGb = '"&SportsGb&"' "
	        CSQL = CSQL & "     left join [SD_Tennis].[dbo].[tblPlayer] P on T.PlayerIDX = P.PlayerIDX AND P.DelYN = 'N' AND P.SportsGb = '"&SportsGb&"' "
	        CSQL = CSQL & " WHERE M.DelYN = 'N' "
	        CSQL = CSQL & "     AND M.MemberIDX = '"&Cookie_SDMemberIDX&"'"

	        ' response.Write CSQL
	        ' response.End()

	        SET CRs = DBCon3.Execute(CSQL)
	        IF CRs.eof or CRs.bof Then
	            response.Write "<script>alert('일치하는 정보가 없습니다.'); history.back();</script>"
	            response.End()
	        Else
	            TeamNm          = CRs("TeamNm")
	            TeamNm2         = CRs("TeamNm2")
	            Team            = CRs("Team")
	            Team2           = CRs("Team2")
	            PlayerIDX       = CRs("PlayerIDX")
	            PlayerName      = CRs("PlayerName")
	            PlayerBirth     = CRs("PlayerBirth")
	            PlayerPhone     = CRs("PlayerPhone")
	            PlayerSEX       = CRs("PlayerSEX")
	            PlayerTeamNm    = CRs("PlayerTeamNm")
	            PlayerTeamNm2   = CRs("PlayerTeamNm2")
	            UserEnName      = CRs("UserEnName")
	            UserPhone       = CRs("UserPhone")
	            Job             = CRs("Job")
	            Interest        = CRs("Interest")
	            Birthday        = CRs("Birthday")
	            SEX             = CRs("SEX")
	            PlayerStartYear = CRs("PlayerStartYear")
	            Tall            = CRs("Tall")
	            Weight          = CRs("Weight")
	            BloodType       = CRs("BloodType")
	            Email           = CRs("Email")
	            PhotoPath       = CRs("PhotoPath")
	            ZipCode         = CRs("ZipCode")
	            Address         = CRs("Address")
	            AddressDtl      = CRs("AddressDtl")
	            WriteDate       = CRs("WriteDate")
	            PlayerReln      = CRs("PlayerReln")
	            PlayerRelnMemo  = CRs("PlayerRelnMemo")
	            EmailYn         = CRs("EmailYn")
	            SmsYn           = CRs("SmsYn")
	            PersonCode      = CRs("PersonCode")
	            LeaderType      = CRs("LeaderType")
	            LeaderTypeNm    = CRs("LeaderTypeNm")
	            Specialty       = CRs("Specialty")
	            HandUse       	= CRs("HandUse")
	            HandType        = CRs("HandType")
	            PositionReturn  = CRs("PositionReturn")
	            LessonArea      = CRs("LessonArea")
	            LessonArea2     = CRs("LessonArea2")
	            LessonAreaDt    = CRs("LessonAreaDt")
	            CourtNm       	= CRs("CourtNm")
	            ShopNm        	= CRs("ShopNm")

	            IF UserPhone <> "" Then
	                CUserPhone = split(UserPhone, "-")
	                UserPhone1 = CUserPhone(0)
	                UserPhone2 = CUserPhone(1)
	                UserPhone3 = CUserPhone(2)
	            End IF

	            IF Email <>"" Then
	                CEmail = split(Email, "@")
	                Email1 = CEmail(0)
	                Email2 = CEmail(1)
	            End IF

	            IF len(PhotoPath)>1 Then
	                chk_IMG = TRUE
	                PhotoPath   = "../"& mid(PhotoPath, 4, len(PhotoPath))
	            Else
	                PhotoPath = ImgDefault
	            End IF


	        End IF
	            CRs.Close
	        SET CRs = Nothing

	    '서브계정가입이 안된 경우 통합로그인 정보 출력
	    Else

			CSQL = "        SELECT UserID"
			CSQL = CSQL & "   	,UserName "
			CSQL = CSQL & "   	,UserEnName "
			CSQL = CSQL & "   	,UserPhone "
			CSQL = CSQL & "   	,Email "
			CSQL = CSQL & "   	,CONVERT(CHAR, CONVERT(DATE, Birthday), 102) Birthday "
			CSQL = CSQL & "   	,Sex "
			CSQL = CSQL & "   	,ZipCode "
			CSQL = CSQL & "   	,Address "
			CSQL = CSQL & "   	,AddressDtl "
			CSQL = CSQL & "   	,EmailYn "
			CSQL = CSQL & "   	,SmsYn "
			CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & "     AND MemberIDX = '"&Cookie_SDMemberIDX&"'"

			SET CRs = DBCon3.Execute(CSQL)
			IF CRs.eof or CRs.bof Then
				response.Write "<script>alert('일치하는 정보가 없습니다.'); history.back();</script>"
				response.End()
			Else
				UserID	    	= CRs("UserID")
				UserName	    = CRs("UserName")
				UserEnName      = CRs("UserEnName")
				UserPhone       = CRs("UserPhone")
				Birthday        = CRs("Birthday")
				SEX             = CRs("SEX")
				Email           = CRs("Email")
				ZipCode         = CRs("ZipCode")
				Address         = CRs("Address")
				AddressDtl      = CRs("AddressDtl")
				EmailYn         = CRs("EmailYn")
				SmsYn           = CRs("SmsYn")

				IF UserPhone <> "" Then
					CUserPhone = split(UserPhone, "-")
					UserPhone1 = CUserPhone(0)
					UserPhone2 = CUserPhone(1)
					UserPhone3 = CUserPhone(2)
				End IF

				IF Email <>"" Then
					CEmail = split(Email, "@")
					Email1 = CEmail(0)
					Email2 = CEmail(1)
				End IF

				IF len(PhotoPath)>1 Then
					chk_IMG = TRUE
					PhotoPath   = "../"& mid(PhotoPath, 4, len(PhotoPath))
				Else
					PhotoPath = ImgDefault
				End IF
			End IF
				CRs.Close
			SET CRs = Nothing
		End IF
	  	'response.write "Specialty="&Specialty
	%>
</head>
<body>
<div class="l m_bg_edf0f4">
	<script type="text/javascript">
		//회원정보 수정항목 체크
		function chk_frm(){
	        /*
			//영문이름 체크
			if(!$('#UserEnName').val()){
				alert('영문이름을 입력해 주세요.');
				$('#UserEnName').focus();
				return;
			}
			else{

				// /[0-9]|[^\!-z]/gi 영문만 공백포함(\s)
				var regexp = /[0-9]|[^\!-z\s]/gi;

				if(regexp.test($('#UserEnName').val())){
					alert('영문만 입력 가능합니다.');
					$('#UserEnName').focus();
					$('#UserEnName').val($('#UserEnName').val().replace(/[0-9]|[^\!-z\s]/gi,''));
					return;
				}
			}
	        */
	        if($('#UserEnName').val()){
	            // /[0-9]|[^\!-z]/gi 영문만 공백포함(\s)
				var regexp = /[0-9]|[^\!-z\s]/gi;

				if(regexp.test($('#UserEnName').val())){
					alert('영문만 입력 가능합니다.');
					$('#UserEnName').focus();
					$('#UserEnName').val($('#UserEnName').val().replace(/[0-9]|[^\!-z\s]/gi,''));
					return;
				}
	        }

			//휴대폰번호체크
			if(!$('#UserPhone1').val()){
				alert('휴대폰 번호를 선택해 주세요.');
				$('#UserPhone1').focus();
				return;
			}

			if(!$('#UserPhone2').val()){
				alert('휴대폰 번호를 입력해 주세요.');
				$('#UserPhone2').focus();
				return;
			}

			if(!$('#UserPhone3').val()){
				alert('휴대폰 번호를 입력해 주세요.');
				$('#UserPhone3').focus();
				return;
			}

			//SMS인증체크
			if($('#Hidden_UserPhone1').val()+$('#Hidden_UserPhone2').val()+$('#Hidden_UserPhone3').val()==$('#UserPhone1').val()+$('#UserPhone2').val()+$('#UserPhone3').val()){
				$('#Hidden_SMS').val('Y');
			}

			if($('#Hidden_SMS').val()=='N'){
				alert('휴대폰 인증을 진행해 주세요.');
				$('#sms_button').focus();
				return;
			}


			//SMS인증 후 휴대폰 번호가 변경되었는지 검증
			if($('#UserPhone1').val()!=$('#Hidden_UserPhone1').val() || $('#UserPhone2').val()!=$('#Hidden_UserPhone2').val() || $('#UserPhone3').val()!=$('#Hidden_UserPhone3').val()) {
				$('#Hidden_SMS').val('N');
				$('#Auth_Num').val('');
				$('#Re_Auth_Num').val('');

				alert('휴대폰 번호가 변경되었습니다. 재인증을 받아주세요.');
				return;
			}

	        /*
			//이메일체크
			if(!$('#UserEmail1').val().replace(/ /g, '')){
				alert('이메일을 입력해 주세요');
				$('#UserEmail1').focus();
				return;
			}

			if(!$('#UserEmail2').val().replace(/ /g, '')){
				alert('이메일을 입력해 주세요');
				$('#UserEmail2').focus();
				return;
			}
	        */



	        if(!$('#UserEmail1').val() || !$('#UserEmail2').val()){
	            var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	            var email = $('#UserEmail1').val().replace(/ /g, '') +'@' + $('#UserEmail2').val().replace(/ /g, '');

	            if(!regex.test(email)){
	                alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');
	                return;
	            }
	        }

	        /*
			//주소체크
			if(!$('#ZipCode').val()){
				alert('주소를 입력해 주세요');
				return;
			}

			if(!$('#UserAddr').val()){
				alert('주소를 입력해 주세요');
				return;
			}
	        */

	    /*
		<%
		SELECT CASE PlayerReln
			CASE "T"  '지도자
			%>

			//레슨지역 시/도
			if(!$('#AreaGb').val()){
				alert('레슨지역 시/도를 선택해 주세요.');
				$('#AreaGb').focus();
				return;
			}

			//레슨지역 시/군/구
			if(!$('#AreaGbDt').val()){
				alert('레슨지역 시/군/구를 선택해 주세요.');
				$('#AreaGbDt').focus();
				return;
			}

			//레슨지역 상세주소
			if(!$('#LessonAreaDt').val()){
				alert('레슨지역 상세주소를 입력해 주세요.');
				$('#LessonAreaDt').focus();
				return;
			}

			//레슨코트명
			if(!$('#CourtNm').val()){
				alert('레슨코트명을 입력해 주세요.');
				$('#CourtNm').focus();
				return;
			}

			//운동시작년도
			if(!$('#PlayerStartYear').val()){
				alert('운동시작년도를 입력해 주세요.');
				$('#PlayerStartYear').focus();
				return;
			}

			<%
			CASE "D"  '일반가입회원
			%>

			if(!$('#Job').val()){
				alert('현재 직업군을 선택해 주세요.');
				$('#Job').focus();
				return;
			}

			var Inter_IntArr='';
			var cnt_Inter=0;

			$('input[name=Interest]:checkbox').each(function() {
				if($(this).is(':checked')){
					Inter_IntArr += '|' + $(this).val();
					cnt_Inter += 1;
				}
			});

			if(cnt_Inter == 0){
				alert('관심분야는 최소 1개 이상 선택해주세요.');
				return;
			}

			<%
			CASE "R","K","S"
			%>

			//소속1
			if(!$('#Team').val() || !$('#TeamNm').val()){
				alert('소속1을 입력해 주세요.');
				$('#TeamNm').focus();
				return;
			}

			//운동시작년도
			if(!$('#PlayerStartYear').val()){
				alert('운동시작년도를 입력해 주세요.');
				$('#PlayerStartYear').focus();
				return;
			}

			//사용손
			if(!$('#HandUse').val()){
				alert('사용손을 선택해 주세요.');
				$('#HandUse').focus();
				return;
			}

			//복식리턴포지션
			if(!$('#PositionReturn').val()){
				alert('복식 리턴 포지션 선택해 주세요.');
				$('#PositionReturn').focus();
				return;
			}

			//백핸드타입
			if(!$('#HandType').val()){
				alert('백핸드타입 선택해 주세요.');
				$('#HandType').focus();
				return;
			}

			var Skill_IntArr='';
			var cnt_Skill=0;

			$('input[name=Skill]:checkbox').each(function() {
				if($(this).is(':checked')) {
					Skill_IntArr += '|' + $(this).val();
					cnt_Skill += 1;
				}
			});

			if(cnt_Skill == 0){
				alert('주특기는 최소 1개 이상 선택해주세요.');
				return;
			}

		<%
			CASE ELSE
		END SELECT
		%>
	    */

			//휴대폰인증이 끝났다면 휴대폰 번호 변경이 되었는지 체크
			if($('#Hidden_SMS').val()=='Y'){
				var a = $('#UserPhone1').val() + $('#UserPhone2').val() + $('#UserPhone3').val();
				var b = $('#Hidden_UserPhone1').val() + $('#Hidden_UserPhone2').val() + $('#Hidden_UserPhone3').val();

				if(a!=b){	//휴대폰번호가 변경이 됐다면 재진행
					$('#Hidden_SMS').val('N');
					$('#Auth_Num').val('');
					$('#Re_Auth_Num').val('');

					alert('휴대폰 번호가 변경되었습니다.\n다시 인증절차를 진행해주세요');
					return;
				}
			}

			var SmsYn = '';
			var EmailYn = '';

			var strAjaxUrl = '../Ajax/join_mod_OK.asp';
			var PlayerIDX = $('#PlayerIDX').val();
			var MemberIDX = $('#MemberIDX').val();
			var Cookie_SDMemberIDX = $('#Cookie_SDMemberIDX').val();
			var UserEnName = $('#UserEnName').val();
			var UserPhone = $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, '');
			var UserEmail = $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, '');
			var Hidden_SmsYn = $('#Hidden_SmsYn').val();
			var Hidden_EmailYn = $('#Hidden_EmailYn').val();
			var ZipCode = $('#ZipCode').val();
			var UserAddr = $('#UserAddr').val();
			var UserAddrDtl = $('#UserAddrDtl').val();
			var PlayerReln = $('#PlayerReln').val();

			if($('#AgreeSMS').is(':checked') == true) SmsYn = 'Y';
			else SmsYn = 'N';

			if($('#AgreeEmail').is(':checked') == true) EmailYn = 'Y';
			else EmailYn = 'N';

	    /*
		<%
	    '계정별 추가정보
		SELECT CASE PlayerReln
			CASE "T"
			%>
	        var Team              = $('#Team').val();
	        var TeamNm            = $('#TeamNm').val();
	        var PlayerStartYear   = $('#PlayerStartYear').val();
	        var PlayerTall        = $('#PlayerTall').val();
	        var PlayerWeight      = $('#PlayerWeight').val();
	        var BloodType         = $('#BloodType').val();
	        var LeaderType        = $('input:radio[name=LeaderType]:checked').val();
	        var LessonArea        = $('#AreaGb').val();
	        var LessonArea2       = $('#AreaGbDt').val();
	        var LessonAreaDt      = $('#LessonAreaDt').val();
	        var CourtNm           = $('#CourtNm').val();
	        var ShopNm            = $('#ShopNm').val();
	      	<%
	      	CASE "R","K","S"
	      	%>
	        var Team              = $('#Team').val();
	        var Team2             = $('#Team2').val();
	        var TeamNm            = $('#TeamNm').val();
	        var TeamNm2           = $('#TeamNm2').val();
	        var PlayerStartYear   = $('#PlayerStartYear').val();
	        var PlayerTall        = $('#PlayerTall').val();
	        var PlayerWeight      = $('#PlayerWeight').val();
	        var BloodType         = $('#BloodType').val();
	        var HandUse           = $('#HandUse').val();
	        var PositionReturn    = $('#PositionReturn').val();
	        var HandType          = $('#HandType').val();
	      	<%
	      	CASE "D"
	      	%>
	        var Job               = $('#Job').val();
	      	<%
	      	CASE ELSE
	    END SELECT
	    %>
	    */

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					PlayerIDX         	: PlayerIDX
					,MemberIDX        	: MemberIDX
					,Cookie_SDMemberIDX : Cookie_SDMemberIDX
					,PlayerReln       	: PlayerReln
					,UserEnName       	: UserEnName
					,UserPhone        	: UserPhone
					,UserEmail        	: UserEmail
					,SmsYn            	: SmsYn
					,EmailYn          	: EmailYn
					,Hidden_SmsYn     	: Hidden_SmsYn
					,Hidden_EmailYn   	: Hidden_EmailYn
					,ZipCode          	: ZipCode
					,UserAddr         	: UserAddr
					,UserAddrDtl      	: UserAddrDtl
	            /*
				<%
				SELECT CASE PlayerReln
					CASE "T"
					%>
					,Team         		: Team
					,TeamNm         	: TeamNm
					,PlayerStartYear    : PlayerStartYear
					,PlayerTall       	: PlayerTall
					,PlayerWeight       : PlayerWeight
					,BloodType        	: BloodType
					,LeaderType       	: LeaderType
					,LessonArea       	: LessonArea
					,LessonArea2        : LessonArea2
					,LessonAreaDt       : LessonAreaDt
					,CourtNm          	: CourtNm
					,ShopNm         	: ShopNm

					<%
					CASE "R","K","S"
					%>

					,Team         		: Team
					,TeamNm         	: TeamNm
					,Team2        		: Team2
					,TeamNm2        	: TeamNm2
					,PlayerStartYear  	: PlayerStartYear
					,PlayerTall       	: PlayerTall
					,PlayerWeight     	: PlayerWeight
					,BloodType        	: BloodType
					,Specialty        	: Skill_IntArr
					,HandUse        	: HandUse
					,PositionReturn     : PositionReturn
					,HandType         	: HandType

					<%
					CASE "D"
					%>

					,Job            	: Job
					,Interest         	: Inter_IntArr

					<%
					CASE ELSE
				END SELECT
				%>
	            */
	      		},
				success: function(retDATA) {

					console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if (strcut[0] == 'TRUE') {
							alert('정보를 업데이트 하였습니다.');

							$('form[name=s_frm]').attr('action','./myinfo.asp');
							$('form[name=s_frm]').submit();
						}
						else{  //FALSE|
							var msg = '';

							switch (strcut[1]) {
								case '99'   : msg = '일치하는 회원정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
								case '66'   : msg = '회원정보 수정에 실패하였습니다.\n관리자에게 문의하세요.'; break;
								default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
							}
							alert(msg);
							return;
						}
					}
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}


		//이메일 도메인 선택입력
		function chk_Email(){
			if(!$('#EmailList').val()) $('#UserEmail2').val('');
			else $('#UserEmail2').val($('#EmailList').val());
		}


		//SMS인증
		function chk_sms(){
			//휴대폰번호체크
			if(!$('#UserPhone1').val()){
				alert('휴대폰 번호를 선택해 주세요.');
				$('#UserPhone1').focus();
				return;
			}

			if(!$('#UserPhone2').val()){
				alert('휴대폰 번호를 입력해 주세요.');
				$('#UserPhone2').focus();
				return;
			}

			if(!$('#UserPhone3').val()){
				alert('휴대폰 번호를 입력해 주세요.');
				$('#UserPhone3').focus();
				return;
			}

			//휴대폰인증체크 여부
			if($('#Hidden_SMS').val()=='N'){

				//인증진행
				var strAjaxUrl = '../Ajax/Check_AuthNum.asp';
				var UserPhone1 = $('#UserPhone1').val();
				var UserPhone2 = $('#UserPhone2').val();
				var UserPhone3 = $('#UserPhone3').val();

				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
						UserPhone1   : UserPhone1
						,UserPhone2   : UserPhone2
						,UserPhone3   : UserPhone3
					},
					success: function(retDATA) {
						if(retDATA){

							var strcut = retDATA.split('|');

							if (strcut[0]=='TRUE') {
								$('#Auth_Num').val(strcut[1]);
								$('#Hidden_UserPhone1').val(strcut[2]);
								$('#Hidden_UserPhone2').val(strcut[3]);
								$('#Hidden_UserPhone3').val(strcut[4]);

								$('#CHK_REAUTH').css({'display':'flex'});
								// $('#chk_Agree').show();
								// $('#chk_Agree').text('※인증번호가 발송되었습니다.');

								$('#sms_button').text('다시받기');
								alert('인증번호가 발송 되었습니다.\n통신사 사정에 따라 최대 1분이 소요될 수 있습니다.');

								$('#Re_Auth_Num').focus();
							}
							else{
								alert('인증번호가 발송되지 않았습니다.\n휴대폰 번호를 확인해 주세요');
								return;
							}
						}
					},
					error: function (xhr, status, error) {
						if(error!=''){
							alert ('오류발생! - 시스템관리자에게 문의하십시오!');
							return;
						}
					}
				});
			}
		}

		//인증번호 체크
		function chk_Auth_Num(){
			if(!$('#Re_Auth_Num').val()){
				alert('인증번호를 입력해 주세요.');
				$('#Re_Auth_Num').focus();
				return;
			}
			else{

				var a = $('#Auth_Num').val();
				var b = $('#Re_Auth_Num').val();

				// $('#chk_Agree').text('');
				// $('#chk_Agree').css('display', 'none');

				if(a!=b){
					alert('인증번호가 일치하지 않습니다\n다시 인증절차를 진행하세요');
					$('#Hidden_SMS').val('N');
					//$('#Auth_Num').val('');
					$('#Re_Auth_Num').val('');
					return;
				}
				else{
					alert('인증이 성공하였습니다.');
					$('#CHK_REAUTH').hide();
					$('#Hidden_SMS').val('Y');

					$('#sms_button').text('인증완료');
					$('#sms_button').removeAttr('href');

					return;
				}
			}
		}


		//회원프로필 이미지 업로드
		function Chk_Write(){
			/*
			if(!$('#b_upFile').val()){
				alert('첨부할 이미지를 선택해주세요.');
				return;
			}
			*/

			var strAjaxUrl = '../Ajax/join_mod_imgOK.asp';
			var formData = new FormData();

			formData.append('MemberIDX', $('#MemberIDX').val());
			formData.append('PlayerIDX', $('#PlayerIDX').val());
			formData.append('b_upFile', $('input[name=b_upFile]')[0].files[0]);

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false,
				success: function(retDATA) {

					var strcut = retDATA.split('|');

					if(strcut[0]=='TRUE'){

						$('#imgMyinfo').attr('src', strcut[1]);
						$('#imgGnb').attr('src', strcut[1]);
						$('#imgDel').css('display',''); //삭제버튼 활성화
						$('#b_upFile').val('');     //input[file] 최기화
						// alert('첨부이미지를 업데이트 하였습니다');
					}
					else{
						switch(strcut[1]) {
							case 1: alert('이미지파일만 업로드 가능합니다'); break;
							case 2: alert('첨부할 이미지파일을 선택하세요'); break;
							case 3: alert('일치하는 정보가 없습니다'); break;
							default: break;
						}
					}
				},
				error: function (xhr, status, error) {
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		//첨부파일 선택
		function fnUpload(){
			$('#b_upFile').click();
		}

		//다이얼로그에서 이미지 선택시 바로 Save
		$('#b_upFile').live('change', function(){
			Chk_Write();
		});

		//회원프로필 등록된 이미지 삭제와 프로필이미지 기본이미지로 변경
		function Chk_Del_Image(){

			if(confirm('프로필 이미지를 삭제하시겠습니까?')){

				var strAjaxUrl = '../Ajax/join_mod_imgDEL.asp';
				var MemberIDX = $('#MemberIDX').val();
				var PlayerIDX = $('#PlayerIDX').val();

				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: { },
					success: function(retDATA) {
						var strcut = retDATA.split('|');

						if(strcut[0]=='TRUE'){
							$('#imgDel').css('display','none');     								//삭제버튼 비활성화
							$('#imgGnb').attr('src', '../images/include/gnb/profile@3x.png'); 		//기본이미지로 초기화
							$('#imgMyinfo').attr('src', '../images/include/gnb/profile@3x.png'); 	//기본이미지로 초기화

							alert('프로필 이미지를 삭제하였습니다.');
							return;
						}
						else{
							$('#imgDel').css('display','');

							switch(strcut[1]) {
								case 1	: alert('일치하는 정보가 없습니다.'); break;
								default	: alert('잘못된 접근입니다.');
							}
						}
					},
					error: function (xhr, status, error) {
						if(error!=''){
							alert ('오류발생! - 시스템관리자에게 문의하십시오!');
							return;
						}
					}
				});
			}
			else{
				return;
			}
		}

		//리스트 관심분야
		function chk_InterestType(){
			var IntArr = '<%=Interest%>';
			var strAjaxUrl = '../Ajax/join_interest.asp';

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					IntArr  : IntArr
				},
				success: function(retDATA) {
					$('#div_Interest').html(retDATA);
					// 실행
					$('.fav-list').tabFavList();
				},
				error: function (xhr, status, error) {
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		//관심분야 체크 최대3개까지 선택가능
		$(document).on('click','#div_Interest li',function() {
			var cnt = 0;
			var index = $('#div_Interest li').index(this);

			$('input:checkbox[name=Interest]').each(function (i) {
				if(this.checked) cnt += 1;
			});

			if(cnt>3) {
				$('#div_Interest li:eq('+index+') a').removeClass('on');
				$('#div_Interest li:eq('+index+') a input').prop('checked', false);

				alert('관심분야는 최대 3개까지 선택할 수 있습니다.');
				return;
			}
		});

		//직업군 셀렉박스
		function make_boxJob(element, attname){
			var strAjaxUrl = '../Select/Join_Job_Select.asp';
			var strJob = '<%=Job%>';


			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					element   : element
					,attname  : attname
					,strJob   : strJob
				},
				success: function(retDATA) {
					$('#'+element).html(retDATA);
				},
				error: function (xhr, status, error) {
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		//주특기 목록 출력
		function chk_InfoSkill(){
			var IntArr = '<%=Specialty%>';
			var strAjaxUrl = '../Ajax/join2_type5_userInfo_Skill.asp';

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					IntArr : IntArr
				},
				success: function(retDATA) {
					$('#div_Skill').html(retDATA);
					// 실행
					$('.fav-list').tabFavList();
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}


		//주특기 최대 3개까지 선택가능
		$(document).on('click','#div_Skill li',function() {
			var cnt = 0;
			var index = $('#div_Skill li').index(this);

			$('input:checkbox[name=Skill]').each(function (i) {
				if(this.checked) cnt += 1;
			});

			if(cnt>3) {
				$('#div_Skill li:eq('+index+') a').removeClass('on');
				$('#div_Skill li:eq('+index+') a input').prop('checked', false);

				alert('주특기는 최대 3개까지 선택할 수 있습니다.');
				return;
			}
		});


		// label 밑의 input 실행
		function inputExc($this){
			var ipt = $this.find('input');

			if ($this.hasClass('on')) {
				ipt.prop('checked', false);
			}
			else {
				ipt.prop('checked', true);
			}
		}

		//선수데이터 열람동의 History
		function CHK_AgreeHistory(){

			var strAjaxUrl = '../Ajax/myinfo_AgreeHistory.asp';
			var PlayerIDX = $('#PlayerIDX').val();
			var PlayerReln = $('#PlayerReln').val();
			var Team = $('#Team').val();
			var Team2 = $('#Team2').val();

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					PlayerIDX   : PlayerIDX
					,PlayerReln : PlayerReln
					,Team       : Team
					,Team2 		: Team2
				},
				success: function(retDATA) {

					console.log(retDATA);

					$('#AgrHistory').html(retDATA);
				},
				error: function (xhr, status, error) {
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}


		//프로필이미지 등록
		function profile_appreceive(str){
			//$('#Hidden_Profile').val(str);
			if (str.match('/FALSE_')){
				alert('사진등록에 실패하였습니다.');
				return;
			}
			else{

				var strAjaxUrl = '../AppConnect/Profilepath.asp';

				$('#imgMyinfo').attr('src','../upload/../upload/' + str);
				$('#imgGnb').attr('src','../upload/../upload/' + str);
				$('#imgMyinfoBig').attr('src','../upload/../upload/' + str);


				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
						str : str
					},
					success: function(retDATA) {
						alert('사진이 등록되었습니다.');
						$('#imgDel').css('display','');     //삭제버튼 활성화
					},
					error: function (xhr, status, error) {
						if(error!=''){
							alert ('오류발생! - 시스템관리자에게 문의하십시오!');
							return;
						}
					}
				});
			}
		}

		//회원프로필 첨부이미지 미리보기
		function readURL(input) {
			if (input.files && input.files[0]) {

				//파일을 읽기 위한 FileReader객체 생성
				var reader = new FileReader();

				reader.onload = function (e) {

				//파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
				$('#imgMyinfo').attr('src', e.target.result);
				//이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
				//(아래 코드에서 읽어들인 dataURL형식)
				}

				reader.readAsDataURL(input.files[0]);
				//File내용을 읽어 dataURL형식의 문자열로 저장
			}
		}

		//file 양식으로 이미지를 선택(값이 변경) 되었을때 처리하는 코드
		$('#b_upFile').change(function() {
			//alert(this.value); //선택한 이미지 경로 표시
			readURL(this);
		});



		//소속정보 조회 후 Input 필드에 넣기
		function Info_InputData(valObj, valCode, valObjNm, valName, sObj){

			//console.log(valObj + '=' + valCode);
			//console.log(valObjNm + '=' + valName);

			$('#'+valObj).val(valCode);
			$('#'+valObjNm).val(valName);

			$('#'+sObj).hide();
		}

		//소속정보 입력 자동완성 기능
		//소속1, 2 순차 조회
		function FND_TeamInfo(val, valName, valCode, sObj, keycode){

			var strAjaxUrl = '../ajax/join1_type5_player_team.asp';
			var Fnd_KeyWord = val.replace(/ /g, '');        	//클럽명 공백제거
			var Fnd_TeamNm = valName.id;
			var chk_Team = '';      							//소속2 검색시 소속1과 중복되는지 체크

			if(Fnd_TeamNm == 'TeamNm2'){
				if(!$('#TeamNm').val()) {
					alert('소속1 검색을 진행하세요.');
					$('#'+Fnd_TeamNm).val('');
					$('#'+valCode).val('');
					$('#TeamNm').focus();
					return;
				}
				else{
					chk_Team = $('#Team').val() ;
				}
			}

			//방향키 keydown/keyup시 조회안되게(키포커스 이동 막음)
			if(keycode==37||keycode==38||keycode==39||keycode==40){ }
				else{

				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
						Fnd_KeyWord : Fnd_KeyWord
						,Fnd_TeamNm : Fnd_TeamNm  	//TeamNm
						,Fnd_Team	: valCode   	//Team
						,chk_Team 	: chk_Team    	//소속2 검색시 소속1과 중복되는지 체크
						,sObj   	: sObj      	//view list id
					},
					success: function(retDATA) {

						//console.log(retDATA);

						$('#'+sObj).children().remove();
						$('#'+sObj).append(retDATA);

						//console.log($('#'+sObj+'_'+valCnt).children().length);


						if ($('#'+sObj).children().length > 0) {
							$('#'+sObj).show();

							$('.sub.mypage').click(function(e){
								$('#'+sObj).hide();
								e.stopPropagation();
							});

							$('.input-control').on('focus, keyup', function(e){
								$('#'+sObj).hide();

								$(this).parents('label').siblings('.input-control').show();
								e.stopPropagation();
								e.preventDefault();
							});
						}
						else {
							$('#'+sObj).hide();
						}
					},
					error: function(xhr, status, error){
						if(error!=''){
							alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!');
							return;
						}
					}
				});
			}
		}

		//상세지역 조회 셀렉박스 생성
		function chk_AreaGbDt(code){
			make_box('sel_AreaGbDt', 'AreaGbDt', code, 'Join_AreaGbDt_A');
		}

		//프로필이미지 업로드 버튼 클릭시 alert처리(App 이미지 업로드 처리문제로 인한 사용보류)
		function myprofile_ready(){
			alert('사진 업로드 기능은 추후 업데이트 예정입니다.');
			return;
		}

		$(document).ready(function(){

			//프로필 이미지 버튼 컨트롤
			if(isMobile.iOS()){
				$('#btn_Profile_iOS').css('display','');
				$('#btn_Profile_Android').css('display','none');
				$('#btn_Profile_PC').css('display','none');
			}
			else if(isMobile.Android()){
				$('#btn_Profile_iOS').css('display','none');
				$('#btn_Profile_Android').css('display','');
				$('#btn_Profile_PC').css('display','none');
			}
			else{
				$('#btn_Profile_iOS').css('display','none');
				$('#btn_Profile_Android').css('display','none');
				$('#btn_Profile_PC').css('display','');
			}

	     /*
		<%
		SELECT CASE PlayerReln

			'일반가입회원
			CASE "D"
			%>
			chk_InterestType();       //관심분야
			make_boxJob('sel_Job','Job'); //셀렉박스 생성 - 직업

			<%
			'등록선수/비등록선수/일반예비후보선수
			CASE "R","K", "S"
			%>

			CHK_AgreeHistory();     //선수데이터 열람동의 History
			chk_InfoSkill();      //주특기 목록 출력
			make_box('sel_HandUse','HandUse','<%=HandUse%>','Join_HandUse');        //사용손
			make_box('sel_HandType','HandType','<%=HandType%>','Join_HandType');   //백핸드타입
			make_box('sel_PositionReturn','PositionReturn','<%=PositionReturn%>','Join_PositionReturn');  //복식리턴포지션

			<%
			CASE "T"  '팀매니저
			%>

			make_box('sel_AreaGb','AreaGb','<%=LessonArea%>','Join_AreaGb_A');

			<%
				IF LessonArea <> "" Then
			%>
			$.when( $.ajax(make_box('sel_AreaGb','AreaGb','<%=LessonArea%>','Join_AreaGb_A'))).then(function() {
				var code = $('#AreaGb').val()+',<%=LessonArea2%>';

				chk_AreaGbDt(code);
			});
			<%
				End IF

			'부모
			CASE Else
			%>

			CHK_AgreeHistory(); //선수데이터 열람동의 History

		<%
		END SELECT
		%>
	    */
		});

	</script>
	<!--S: 다음 주소찾기 API-->
	<div id="wrap" style="display: none; border:1px solid #000; width:100%; height:100%; margin:48px 0; position: absolute; z-index:1000;"> <img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onClick="foldDaumPostcode()" alt="접기 버튼"> </div>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script>
	    // 우편번호 찾기 찾기 화면을 넣을 element
	    var element_wrap = document.getElementById('wrap');

	    function foldDaumPostcode() {
	        // iframe을 넣은 element를 안보이게 한다.
	        element_wrap.style.display = 'none';
	    }

	    function execDaumPostCode() {
	        // 현재 scroll 위치를 저장해놓는다.
	        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var fullAddr = data.address; // 최종 주소 변수
	                var extraAddr = ''; // 조합형 주소 변수

	                // 기본 주소가 도로명 타입일때 조합한다.
	                if(data.addressType === 'R'){
	                    //법정동명이 있을 경우 추가한다.
	                    if(data.bname !== ''){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있을 경우 추가한다.
	                    if(data.buildingName !== ''){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('UserAddr').value = fullAddr;
	              	document.getElementById('UserAddrDtl').focus();


	                // iframe을 넣은 element를 안보이게 한다.
	                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
	                element_wrap.style.display = 'none';

	                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
	                document.body.scrollTop = currentScroll;
	            },
	            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
	            onresize : function(size) {
	                element_wrap.style.height = size.height+'px';
	            },
	            width : '100%',
	            height : '100%'
	        }).embed(element_wrap);

	        // iframe을 넣은 element를 보이게 한다.
	        element_wrap.style.display = 'block';
	    }

	    var isMobile = {
			Android: function () {
					 return navigator.userAgent.match(/Android/i);
			},
			BlackBerry: function () {
					 return navigator.userAgent.match(/BlackBerry/i);
			},
			iOS: function () {
					 return navigator.userAgent.match(/iPhone|iPad|iPod/i);
			},
			Opera: function () {
					 return navigator.userAgent.match(/Opera Mini/i);
			},
			Windows: function () {
					 return navigator.userAgent.match(/IEMobile/i);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	    };

	</script>
	<!--E: 다음 주소찾기 API-->

	<!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
		<div class="m_header s_sub">
	    <!-- #include file="../include/header_back.asp" -->
	    <h1 class="m_header__tit">내 정보 관리</h1>
	    <!-- #include file="../include/header_gnb.asp" -->
		</div>
  </div>

	<div class="l_content m_scroll [ _content _scroll ]">
		<form name="s_frm" method="post">
		  <input type="hidden" name="Cookie_SDMemberIDX" id="Cookie_SDMemberIDX" value="<%=Cookie_SDMemberIDX%>" />
		  <input type="hidden" name="MemberIDX" id="MemberIDX" value="<%=MemberIDX%>" />
		  <input type="hidden" name="PlayerIDX" id="PlayerIDX" value="<%=PlayerIDX%>" />
		  <input type="hidden" name="Team" id="Team" value="<%=Team%>" />
		  <input type="hidden" name="Team2" id="Team2" value="<%=Team2%>" />
		  <input type="hidden" name="PlayerReln" id="PlayerReln" value="<%=PlayerReln%>" />
		  <input type="hidden" name="Hidden_SmsYn" id="Hidden_SmsYn" value="<%=SmsYn%>" />
		  <input type="hidden" name="Hidden_EmailYn" id="Hidden_EmailYn" value="<%=EmailYn%>" />
		  <input type="hidden" name="SEX" id="SEX" value="<%=SEX%>" />
		  <input type="hidden" name="TeamGb" id="TeamGb" value="<%=TeamGb%>">
		  <!--체육인번호 조회 START-->
		  <input type="hidden" name="SportsType" id="SportsType" value="<%=SportsType%>" />
		  <input type="hidden" name="AthleteNum" id="AthleteNum" />
		  <input type="hidden" name="AthleteYN" id="AthleteYN" value="N" />
		  <input type="hidden" name="UserName" id="UserName" value="<%=UserName%>" />
		  <input type="hidden" name="Birthday" id="Birthday" value="<%=Birthday%>" />
		  <!--체육인번호 조회 END-->
		  <!--국가대표 계정등록 START-->
		  <input type="hidden" name="Hidden_UserID" id="Hidden_UserID" />
		  <input type="hidden" name="ID_CheckYN" id="ID_CheckYN" value="N" />
		  <input type="hidden" name="EnterType" id="EnterType" value="K" />
		  <!--국가대표 팀 조회하기 위한 설정값-->
		  <!--국가대표소속 조회 조건-->
		  <!--국가대표 계정등록 END-->
		  <!--계정 로그인 전환 START-->
		  <input type="hidden" name="PlayerIDXNow" id="PlayerIDXNow" value="<%=PlayerIDXNow%>" />
		  <input type="hidden" name="TeamNow" id="TeamNow" value="<%=TeamNow%>" />
		  <!--계정 로그인 전환 END-->
		  <fieldset>
		    <legend>마이페이지 내정보 관리</legend>

				<p class="m_guideTxt">기본정보</p>

		    <ul class="m_form">
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">아이디</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt"><%=UserID%></span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이름</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt"><%=UserName %></span>
						</p>
		      </li>

          <!-- <li class="m_form__item">
              <p class="m_form__labelWrap">영문이름</p>
              <p class="m_form__inputWrap"><input type="text" name="UserEnName" id="UserEnName" placeholder="Hong Gil Dong" value="<%=UserEnName%>" /></p>
          </li> -->

		      <li class="m_form__item">
		        <p class="m_form__labelWrap">성별</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt"><%IF Sex = "Man" Then response.Write "남자" Else response.Write "여자" End IF%></span>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">생년월일</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt"><%=Birthday%></span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">휴대폰<span class="m_form__labelTxtStar">＊</span></p>
		        <div class="m_form__inputWrap">

		          <select name="UserPhone1" id="UserPhone1" class="m_form__select s_phone">
		            <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
		            <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
		            <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
		            <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
		            <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
		            <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
		          </select>

		          <span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone2" id="UserPhone2" class="m_form__input s_phone" maxlength="4" value="<%=UserPhone2%>" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}"/>
							<span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone3" id="UserPhone3" class="m_form__input s_phone" maxlength="4" value="<%=UserPhone3%>" />
							<a href="javascript:chk_sms();" class="m_form__btn s_phone" id="sms_button">인증</a>

		          <!--휴대폰번호 변경 체크를 위한 hidden data-->
		          <!--SMS인증여부-->
		          <input type="hidden" name="Hidden_SMS" id="Hidden_SMS" value="N">
		          <input type="hidden" name="Hidden_UserPhone1" id="Hidden_UserPhone1" value="<%=UserPhone1%>" />
		          <input type="hidden" name="Hidden_UserPhone2" id="Hidden_UserPhone2" value="<%=UserPhone2%>" />
		          <input type="hidden" name="Hidden_UserPhone3" id="Hidden_UserPhone3" value="<%=UserPhone3%>" />
		          <input type="hidden" name="Auth_Num" id="Auth_Num" value="" />
		          <!--휴대폰번호 변경 체크를 위한 hidden data-->
		          <!--//<input type="button" class="btn-gray" value="인증" />-->
		        </div>
		      </li>
		      <li id="CHK_REAUTH" class="m_form__item s_linkedItem s_hidden">
		        <p class="m_form__labelWrap s_hidden">휴대폰 인증번호 입력</p>
		        <div class="m_form__inputWrap">
		          <input type="number" name="Re_Auth_Num" id="Re_Auth_Num" class="m_form__input s_phoneAuth" placeholder="인증번호 입력" />
		          <a href="javascript:chk_Auth_Num()" class="m_form__btn s_phoneAuth">확인</a>
							<p id="chk_Agree" class="m_form__txt s_alert"></p>
						</div>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">휴대폰 수신동의</p>
		        <div class="m_form__inputWrap">
		          <label for="AgreeSMS" class="m_form__checkWrap img-replace sms <%IF SmsYn = "Y" Then response.Write "on" End IF%>" onClick="inputExc($(this));">
								수신동의<input type="checkbox" name="AgreeSMS" id="AgreeSMS" class="m_form__check" <%IF SmsYn = "Y" Then response.Write "checked" End IF%> />
		          </label>
							<p class="m_form__infoTxt">
								<span>※</span>대회정보, 선수정보, 이벤트 및 광고 등 다양한 정보를 SMS로 받아 보실 수 있습니다.
							</p>
		        </div>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이메일</p>
		        <p class="m_form__inputWrap">
		          <input type="text" name="UserEmail1" id="UserEmail1" placeholder="sample123456" class="m_form__input s_email" value="<%=Email1%>" />
		          <span class="m_form__txt s_email">@</span>
		          <input type="text" name="UserEmail2" id="UserEmail2" placeholder="hanmail.net" class="m_form__input s_email" value="<%=Email2%>" />
		          <select name="EmailList" id="EmailList" class="m_form__select" onChange="chk_Email();">
		            <option value="">직접입력</option>
		            <option value="gmail.com" <%IF Email2 = "gmail.com" Then response.Write "selected" End IF%>>gmail.com</option>
		            <option value="hanmail.net" <%IF Email2 = "hanmail.net" Then response.Write "selected" End IF%>>hanmail.net</option>
		            <option value="hotmail.com" <%IF Email2 = "hotmail.com" Then response.Write "selected" End IF%>>hotmail.com</option>
		            <option value="naver.com" <%IF Email2 = "naver.com" Then response.Write "selected" End IF%>>naver.com</option>
		            <option value="nate.com" <%IF Email2 = "nate.com" Then response.Write "selected" End IF%>>nate.com</option>
		          </select>
		        </p>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">이메일 수신동의</p>
		        <p class="m_form__inputWrap">
		          <label for="AgreeEmail" class="m_form__checkWrap img-replace sms <%IF EmailYn = "Y" Then response.Write "on" End IF%>" onClick="inputExc($(this));">
								수신동의<input type="checkbox" name="AgreeEmail" id="AgreeEmail" class="m_form__check" <%IF EmailYn = "Y" Then response.Write "checked" End IF%> />
		          </label>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">주소</p>
		        <p class="m_form__inputWrap">
		          <input type="text" readonly name="ZipCode" id="ZipCode" class="m_form__input s_post" value="<%=ZipCode%>" />
		          <a href="javascript:execDaumPostCode();" class="m_form__btn s_post">우편번호 검색</a>
		          <input type="text" readonly name="UserAddr" id="UserAddr" class="m_form__input" value="<%=Address%>" />
		          <input type="text" name="UserAddrDtl" id="UserAddrDtl" class="m_form__input" placeholder="나머지 주소 입력" value="<%=AddressDtl%>" />
		        </p>
		      </li>
		    </ul>
		  </fieldset>
		</form>

		<div class="m_bottomBtn">
			<a href="./mypage.asp" class="m_bottomBtn__btn s_cancel">수정취소</a>
			<a href="javascript:chk_frm();" class="m_bottomBtn__btn s_modify">수정완료</a>
		</div>

	</div>

	<!-- #include file="../include/bottom_menu.asp" -->
	<!-- #include file= "../include/bot_config.asp" -->

	<script>
	  <%

	  '모달 실행시 셀렉박스 생성
	  SELECt CASE PlayerReln
	    CASE "R", "K", "S"

	      '소속변경 셀렉박스 생성
	      response.Write "  $('#belong_change').on('shown.bs.modal', function (evt) {"

	      IF EnterType = "E" Then
	        response.Write "make_box('sel_TeamGb_CE','PTeamGb_CE','','myinfo_TeamGb_CE');"      '셀렉박스 생성 - 소속구분(소속팀 변경)
	        response.Write "make_box('sel_AreaGb_CE','AreaGb_CE','','myinfo_AreaGb_CE');"       '셀렉박스 생성 - 지역(소속팀 변경)
	      Else
	        response.Write "make_box('sel_AreaGb_CA','AreaGb_CA','','myinfo_AreaGb_CA');"     '셀렉박스 생성 - 지역(소속팀 변경)
	      END IF

	      response.Write "  });"

	      '국가대표 계정등록시 셀렉박스 생성
	      IF PlayerReln = "R" and EnterType = "E" Then
	        response.Write " $('#regist_a').on('shown.bs.modal', function (evt) {"
	        response.Write "  make_box('sel_TeamCode_K','TeamCode_K','','Join_TeamCode_K');"      '셀렉박스 생성 - 소속팀(국가대표 팀소속 등록)
	        response.Write " });"
	      End IF

	      '비등록선수의 등록선수로 전환할 경우 체육인번호 조회 셀렉박스 생성
	      IF(PlayerReln = "K" or PlayerReln = "S") and EnterType = "E" Then
	        response.Write " $('#import-number').on('shown.bs.modal', function (evt) {"
	        response.Write "  make_box('sel_TeamGb','PTeamGb','','Join_TeamGb');"           '셀렉박스 생성 - 소속구분(체육인번호 조회)
	        response.Write "  make_box('sel_AreaGb','AreaGb','','Join_AreaGb');"            '셀렉박스 생성 - 지역(체육인번호 조회)
	        response.Write " });"
	      End IF

	    CASE ELSE
	  END SELECT
	  %>
	</script>

</div>
</body>
</html>
