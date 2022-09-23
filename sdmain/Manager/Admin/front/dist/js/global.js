
  var SelPubCode = function(id,ppubcode,selpubcode)
  {
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
		
		
    var jsonData = JSON.stringify(obj);

        $.ajax({
            url: '/ajax/judo_os/management/DirPubCodeList.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
    
			//훈련 select 세팅
			function fsuccess(data){

				
        var myArr = JSON.parse(data);

      	//$(id).find("option").remove();
				$(id).children("option").not("[value='']").remove();
				
        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {
            var varPubCode = myArr[i].PubCode;
            var varPubName = myArr[i].PubName;
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;
            var varOrderBy = myArr[i].OrderBy;

			if (varPubCode == selpubcode)
			{
				$(id).append("<option value='"+ varPubCode +"' selected>"+ varPubName +"</option>");
			}
			else
			{
				$(id).append("<option value='"+ varPubCode +"'>"+ varPubName +"</option>");
			}
            
          }
        }
        
        $d.resolve(data);
			}

			function ferror(error) {
        console.log(error);
				$d.reject(error);
			}

    return $d.progress();
  };

  var SelTeamCode = function(id,selTeamGb)
  {
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.EnterType = localStorage.getItem("EnterType");

		
		
    var jsonData = JSON.stringify(obj);

        $.ajax({
            url: '/ajax/judo_OS/management/DirTeam.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
    
			//훈련 select 세팅
			function fsuccess(data){


        var myArr = JSON.parse(data);

      	//$(id).find("option").remove();
				$(id).children("option").not("[value='']").remove();
				
        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {

            var varSportsGb = myArr[i].SportsGb;
            var varTeamGb = myArr[i].TeamGb;
            var varTeamGbNm = myArr[i].TeamGbNm;

			if (varTeamGb == selTeamGb)
			{
				$(id).append("<option value='"+ varTeamGb +"' selected>"+ varTeamGbNm +"</option>");
			}
			else
			{
				$(id).append("<option value='"+ varTeamGb +"'>"+ varTeamGbNm +"</option>");
			}
            
          }
        }
        
        $d.resolve(data);
			}

			function ferror(error) {
        console.log(error);
				$d.reject(error);
			}

    return $d.progress();
  };

  var SelTeamCode_NowGame = function(id,selTeamGb)
  {
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.EnterType = localStorage.getItem("EnterType");
    obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

		
		
    var jsonData = JSON.stringify(obj);

        $.ajax({
            url: '/ajax/judo_OS/management/DirTeamNowGame.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
    
			//훈련 select 세팅
			function fsuccess(data){


        var myArr = JSON.parse(data);

      	//$(id).find("option").remove();
				$(id).children("option").not("[value='']").remove();
				
        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {

            var varSportsGb = myArr[i].SportsGb;
            var varTeamGb = myArr[i].TeamGb;
            var varTeamGbNm = myArr[i].TeamGbNm;

			if (varTeamGb == selTeamGb)
			{
				$(id).append("<option value='"+ varTeamGb +"' selected>"+ varTeamGbNm +"</option>");
			}
			else
			{
				$(id).append("<option value='"+ varTeamGb +"'>"+ varTeamGbNm +"</option>");
			}
            
          }
        }
        
        $d.resolve(data);
			}

			function ferror(error) {
        console.log(error);
				$d.reject(error);
			}

    return $d.progress();
  };


  var SelPPubCode_spec = function(id)
  {
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    var jsonData = JSON.stringify(obj);

        $.ajax({
            url: '/management/DirPPubCodeList_spec.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
		});
    
			//훈련 select 세팅
		function fsuccess(data){

			
        var myArr = JSON.parse(data);

      	//$(id).find("option").remove();
		$(id).children("option").not("[value='']").remove();
				
        if (myArr.length > 0)
        {
          
          var varLeft = "";
          var varRight = "";
          var varOther = "";
          
          for (var i = 0; i < myArr.length; i++)
          {
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;
            

            if (varPPubCode == "sp001" || varPPubCode == "sp002" || varPPubCode == "sp003" || varPPubCode == "sp004") {
              varLeft+="<option value='"+ varPPubCode +"_sp030001'>[좌]"+ varPPubName +"</option>";
            }
            
          }

          for (var i = 0; i < myArr.length; i++)
          {
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;

            if (varPPubCode == "sp001" || varPPubCode == "sp002" || varPPubCode == "sp003" || varPPubCode == "sp004") {
              varRight+="<option value='"+ varPPubCode +"_sp030002'>[우]"+ varPPubName +"</option>";
            } else {
              varOther+="<option value='"+ varPPubCode +"'>"+ varPPubName +"</option>";
            }
          }
          
          $(id).append(varLeft);
          $(id).append(varRight);
          $(id).append(varOther);
          
        }
//        console.log(data);
        $d.resolve(data);
		}

		function ferror() {
			console.log(error);
			$d.reject(error);
		}

    return $d.progress();
  };


  var SelPubCode_spec = function(id,ppubcode)
  {
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
    var jsonData = JSON.stringify(obj);

	  
	$.ajax({
		url: '/management/DirPubCodeList_spec.ashx',
		type: 'post',
		data: jsonData,
		success: function(data){fsuccess(data)},error:ferror
	});

		//훈련 select 세팅
	function fsuccess(data){

	var myArr = JSON.parse(data);

	//$(id).find("option").remove();
	$(id).children("option").not("[value='']").remove();

		if (myArr.length > 0)
		{
		  for (var i = 0; i < myArr.length; i++)
		  {
			var varPubCode = myArr[i].PubCode;
			var varPubName = myArr[i].PubName;
			var varPPubCode = myArr[i].PPubCode;
			var varPPubName = myArr[i].PPubName;
			var varOrderBy = myArr[i].OrderBy;

			$(id).append("<option value='"+ varPubCode +"'>"+ varPubName +"</option>");
		  }
		}
		$d.resolve(data);
	}

	function ferror() {
		console.log(error);
		$d.reject(error);
	}

    return $d.progress();
  };




  function ChkPubCode(id,ppubcode,checkgroup) {

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
    var jsonData = JSON.stringify(obj);

        $.ajax({
            url: '/management/DirPubCodeList.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
		
			//훈련 select 세팅
			function fsuccess(data){

        var myArr = JSON.parse(data);

        $(id).html('');
        //$(id).children("option").not("[value='']").remove();

        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {
            var varPubCode = myArr[i].PubCode;
            var varPubName = myArr[i].PubName;
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;
            var varOrderBy = myArr[i].OrderBy;

            $(id).append("<label class='checkbox checkbox-padding-left widget uib_w_40 d-margins' data-uib='twitter%20bootstrap/checkbox' data-ver='1'><input type='checkbox' name='"+ checkgroup +"' value='"+ varPubCode +"'>"+ varPubName +"</label>");
						
          }
        }
        $d.resolve(data);
			}

			function ferror() {
        console.log(error);
				$d.reject(error);
			}

    return $d.progress();

  }    


  function ChkPubCode_spec(id,ppubcode,checkgroup) {

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
    var jsonData = JSON.stringify(obj);

    
        $.ajax({
            url: '/management/DirPubCodeListIN_spec.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
		
			//훈련 select 세팅
			function fsuccess(data){

        var myArr = JSON.parse(data);
        
        $(id).html('');
        //$(id).children("option").not("[value='']").remove();

        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {
            var varPubCode = myArr[i].PubCode;
            var varPubName = myArr[i].PubName;
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;
            var varOrderBy = myArr[i].OrderBy;

            $(id).append("<label class='checkbox checkbox-padding-left widget uib_w_40 d-margins' data-uib='twitter%20bootstrap/checkbox' style='font-size:13px;font-weight:normal;margin-bottom:5px;margin-top:5px;' data-ver='1'><input type='checkbox' name='"+ checkgroup +"' value='"+ varPubCode +"'>"+ varPubName +"</label>");
						
          }
        }
        $d.resolve(data);
			}

			function ferror() {
				$d.reject(error);
			}

    return $d.progress();

  }    


  function ChkPubCode_spec_readonly(id,ppubcode,checkgroup) {

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
    var jsonData = JSON.stringify(obj);

    
        $.ajax({
            url: '/management/DirPubCodeListIN_spec.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});
		
			//훈련 select 세팅
			function fsuccess(data){

        var myArr = JSON.parse(data);
        
        $(id).html('');
        //$(id).children("option").not("[value='']").remove();

        if (myArr.length > 0)
        {
          for (var i = 0; i < myArr.length; i++)
          {
            var varPubCode = myArr[i].PubCode;
            var varPubName = myArr[i].PubName;
            var varPPubCode = myArr[i].PPubCode;
            var varPPubName = myArr[i].PPubName;
            var varOrderBy = myArr[i].OrderBy;

            $(id).append("<label class='checkbox checkbox-padding-left widget uib_w_40 d-margins' data-uib='twitter%20bootstrap/checkbox' style='font-size:13px;font-weight:normal;margin-bottom:5px;margin-top:5px;' data-ver='1'><input type='checkbox' name='"+ checkgroup +"' value='"+ varPubCode +"' disabled>"+ varPubName +"</label>");
						
          }
        }
        $d.resolve(data);
			}

			function ferror() {
				$d.reject(error);
			}

    return $d.progress();

  }    




  var drTrainPub = function(id,ppubcode)
  {

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.PPubCode = ppubcode;
    var jsonData = JSON.stringify(obj);

		$.ajax({
				url: '/management/DirPubCodeList.ashx',
				type: 'post',
				data: jsonData,
				success: function(data){fsuccess(data)},error:ferror
		});
		
		
      
    function fsuccess(data) {

        var myArr = JSON.parse(data);

        //$(id).html('');
        $(id).children("option").not("[value='']").remove();
      
      
				for (var i = 0; i < myArr.length; i++) {
					var varPubCode = myArr[i].PubCode;
					var varPubName = myArr[i].PubName;
					var varPPubCode = myArr[i].PPubCode;
					var varPPubName = myArr[i].PPubName;
					var varOrderBy = myArr[i].OrderBy;

					$(id).append("<div class='table-thing widget uib_w_122 d-margins trining_jumsu_label label_fontsize_default' data-uib='twitter%20bootstrap/select' data-ver='1'> "
					+ "<label class='narrow-control label-inline'>"+ varPubName +"</label> "
					+ "<select class='wide-control form-control default' name='"+ id +"' id='"+ varPubCode +"'>"
					+ " <option value=''>시간부여</option> "
					+ " <option value='0.5'>0.5</option> "
					+ " <option value='1.0'>1.0</option> "
					+ " <option value='1.5'>1.5</option> "
					+ " <option value='2.0'>2.0</option> "
					+ " <option value='2.5'>2.5</option> "
					+ " <option value='3.0'>3.0</option> "
					+ "</select>"
					+ "</div>");

					$d.resolve(data);
					
				}
			
    }
      
    function ferror() {
      $d.reject(error);
    }

    return $d.progress();
  }






	var drGameTitle = function(id)
	{

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");

    var jsonData = JSON.stringify(obj);

		
      $.ajax({
          url: '/management/GameTitleList.ashx',
          type: 'post',
          data: jsonData,
          success: function(data){fsuccess(data)},error:ferror
      });

			//훈련 select 세팅
			function fsuccess(data){

        $(id).children('option').not('[value=""]').remove();
        
				$.each(JSON.parse(data), function(idx, obj) {
					$(id).append("<option value='"+ obj.GameTitleIDX +"'>"+ obj.GameTitleName +"</option>");
				});

				//초기로딩시에는 value='' 없음을 선택해 준다.
//				console.log("$("+id+").val($('"+id+" option:first').val());");
//				$.globalEval("$("+id+").val($('"+id+" option:first').val());");
				
				//$("#GameTitleIDX").val($("#GameTitleIDX option:first").val());
				//$("#GameTitleIDX option[value='']").attr('selected', true);
				
        $d.resolve(data);

			}

			function ferror() {
				$d.reject(error);
			}

    return $d.progress();
		
	}



	var drGameTitleBetween = function(id,seDateS,seDateE)
	{

    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
		obj.seDateS = seDateS;
		obj.seDateE = seDateE;
		
    
    var jsonData = JSON.stringify(obj);

  //  console.log(jsonData);
		
        $.ajax({
            url: '/management/GameTitleBetweenList.ashx',
            type: 'post',
            data: jsonData,
            success: function(data){fsuccess(data)},error:ferror
				});

			//훈련 select 세팅
			function fsuccess(data){

//        console.log(data);
        $(id).children("option").not("[value='']").remove();
        
				$.each(JSON.parse(data), function(idx, obj) {
					$(id).append("<option value='"+ obj.GameTitleIDX +"'>"+ obj.GameTitleName +"</option>");
				});
				
        $d.resolve(data);

			}

			function ferror() {
				$d.reject(error);
			}

    return $d.progress();
		
	}


	//학교select (지역구분,팀구분)
	var selectSchool = function(id,Area,Team,SportsGb){
    var $d=$.Deferred();
		
		var obj = {};
		obj.AreaGb = Area;
		obj.TeamGb = Team;
		obj.SportsGb = SportsGb;
		
		
		var jsonData = JSON.stringify(obj);
		
		$.ajax({
				url: '/login/SchoolList.ashx',
				type: 'post',
				data: jsonData,
				success: function (data) {
						var myArr = JSON.parse(data);

						//$(id).find("option").remove();
            $(id).children("option").not("[value='']").remove();
						if (myArr.length > 0)
						{

							for (var i = 0; i < myArr.length; i++)
							{

								var varSchIDX = myArr[i].SchIDX;
								var varSchoolCode = myArr[i].SchoolCode;
								var varSchoolName = myArr[i].SchoolName;

								$(id).append("<option value='"+ varSchIDX +"'>"+ varSchoolName +"</option>");

							}

						}

					$d.resolve(data);

				},
				error: function (errorText) {
					console.log(errorText);
					navigator.notification.alert("네트워크를 확인하시기 바랍니다.",null,"sports diary","확인");
					$d.reject(error);
				}

		});

		return $d.progress();

	}



	//선수select (id,학교idx,선수idx,종목구분)
	var selectOpPlayer = function(id,SchIDX,PlayerIDX,SportsGb){
    var $d=$.Deferred();
		
		var obj = {};
		obj.SchIDX = SchIDX;
		obj.SportsGb = SportsGb;
		obj.PlayerIDX = PlayerIDX;
		
		var jsonData = JSON.stringify(obj);
		
		$.ajax({
				url: '/Game/tblOpPlayerList.ashx',
				type: 'post',
				data: jsonData,
				success: function (data) {
						var myArr = JSON.parse(data);
					
						//$(id).find("option").remove();
            $(id).children("option").not("[value='']").remove();

						if (myArr.length > 0)
						{

							for (var i = 0; i < myArr.length; i++)
							{

								var varOpPlayerIDX = myArr[i].OpPlayerIDX;
								var varOpPlayerName = myArr[i].OpPlayerName;
								var varSchoolName = myArr[i].SchoolName;
								var varOpPlayerBego = myArr[i].OpPlayerBego;

								$(id).append("<option value='"+ varOpPlayerIDX +"'>"+ varOpPlayerName +"</option>");

							}

						}

					$d.resolve(data);
          //console.log(data);
				},
				error: function (errorText) {
					navigator.notification.alert("네트워크를 확인하시기 바랍니다.",null,"sports diary","확인");
					$d.reject(error);
				}

		});

		return $d.progress();

	}

  //날짜리턴 2016-01-01 -> 2016년01월01일
	var returnYYMMDD=function(getday){
    var hicheck = getday.indexOf("-");
    var returnday = "";
    if (hicheck > 0){
      var dayarray = getday.split("-");
      returnday += dayarray[0]+"년"+dayarray[1]+"월"+dayarray[2]+"일";
    }
    return returnday;
  }


    //인터넷체크
    function checkInternet() {
        document.addEventListener("intel.xdk.device.connection.update",function(){
             if(intel.xdk.device.connection == "ethernet")
             {
                 //ethernet
             }
             else if(intel.xdk.device.connection == "wifi")
             {
                 //wifi
             }
             else if(intel.xdk.device.connection == "cell")
             {
                 //cell
             }
             else if(intel.xdk.device.connection == "none")
             {
                 //no internet is available
             }
             else if(intel.xdk.device.connection == "unknown")
             {
                 //determining connection type. Till now its unknown. You should check for it later again. 
             }
             else
             {
                 //some other connection type.
             }

             alert(intel.xdk.device.connection);
         },false);
         intel.xdk.device.updateConnection();

    }


	// 스크립트처리.
		String.prototype.replaceAll = function(search, replace)
		{
				if(!replace){
						return this;
				}
				return this.replace(new RegExp('[' + search + ']', 'g'), replace);
		};

		var scriptXSS = function(msg){
				msg = msg.replaceAll("&", "&amp;");
				msg = msg.replaceAll("<", "&lt;");
				msg = msg.replaceAll(">", "&gt;");
				msg = msg.replaceAll("(", "&#40;");
				msg = msg.replaceAll(")", "&#41;");
				msg = msg.replaceAll("\"", "&quot;");
				msg = msg.replaceAll("'", "&#x27;"); 
				return msg;
		}

    var getUrlParameter = function(name){
      
        var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if (results==null){
           return null;
        }
        else{
           return results[1] || 0;
        }
    };



		//지도자버전에서 검색 선수목록 공통 SSG 20160727
		var drPlayerList = function(id,Sex,SchIDX)
		{

			var defer=$.Deferred();
			var obj = {};

			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.Sex = Sex;
			obj.SchIDX = SchIDX;

			var jsonData = JSON.stringify(obj);

			$.ajax({
					url: '/CManagement/tblPlayerList.ashx',
					type: 'post',
					data: jsonData,
					success: function(data){fsuccess(data)},error:ferror
			});

			//훈련 select 세팅
			function fsuccess(data){

				var myArr = JSON.parse(data);

				$(id).html("");
				var divider = "";

				$(id).append("<li data-value=''><a href='#'>선수선택</a></li>");

				if (myArr.length > 0)
				{
					for (var i = 0; i < myArr.length; i++)
					{
						if (divider != myArr[i].Sex && divider != "" && myArr[i].Sex != ""){
							$(id).append("<li class='divider'></li>");
						}

						$(id).append("<li data-value='"+ myArr[i].PlayerIDX +"'><a href='#'>"+ myArr[i].UserName +"</a></li>");
						divider = myArr[i].Sex;
					}
				}

				defer.resolve(data);

			}

			function ferror() {
				defer.reject(error);
			}
			return defer.progress();
		}



		var drPlayerListLevel = function(id,Sex,SchIDX,Level)
		{

			var defer=$.Deferred();
			var obj = {};

			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.Sex = Sex;
			obj.SchIDX = SchIDX;
			obj.Level = Level;

			var jsonData = JSON.stringify(obj);

			$.ajax({
					url: '/CManagement/tblPlayerListLevel.ashx',
					type: 'post',
					data: jsonData,
					success: function(data){fsuccess(data)},error:ferror
			});

			//훈련 select 세팅
			function fsuccess(data){

				var myArr = JSON.parse(data);

				$(id).html("");
				var divider = "";

				$(id).append("<li data-value=''><a href='#'>선수선택</a></li>");
				
				if (myArr.length > 0)
				{
					for (var i = 0; i < myArr.length; i++)
					{
						if (divider != myArr[i].Sex && divider != "" && myArr[i].Sex != ""){
							$(id).append("<li class='divider'></li>");
						}

						$(id).append("<li data-value='"+ myArr[i].PlayerIDX +"'><a href='#'>"+ myArr[i].UserName +"</a></li>");
						divider = myArr[i].Sex;
					}
				}

				defer.resolve(data);

			}

			function ferror() {
				defer.reject(error);
			}
			return defer.progress();
		}
		
		
		
		
		//지도자버전에서 검색 체급목록 공통 SSG 20160802
		var drLevelList = function(id,TeamGb,Sex,SchIDX,selpubcode)
		{

			var defer=$.Deferred();
			var obj = {};

			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.TeamGb = TeamGb;
			obj.Sex = Sex;
			obj.SchIDX = SchIDX;

			var jsonData = JSON.stringify(obj);

			$.ajax({
					url: '/CManagement/tblLevelList.ashx',
					type: 'post',
					data: jsonData,
					success: function(data){fsuccess(data)},error:ferror
			});

			//훈련 select 세팅
			function fsuccess(data){

				var myArr = JSON.parse(data);
				//$(id).children("option").not("[value='']").remove();
				$(id).children("option").remove();
				
				//console.log(myArr);
				
				if (myArr.length > 0)
				{

					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){

						$(id).append("<option value='' selected>::체급선택::</option>");

						for (var i = 0; i < myArr.length; i++)
						{

							if (myArr[i].PubCode == selpubcode)
							{
								$(id).append("<option value='"+ myArr[i].PubCode +"' selected>"+ myArr[i].PubName +"</option>");
							}
							else
							{
								$(id).append("<option value='"+ myArr[i].PubCode +"'>"+ myArr[i].PubName +"</option>");
							}
							
						}
					}
					else{
						//$(id).children("option").remove();
						$(id).append("<option value='' selected>해당없음</option>");
					}
				}
				else{
					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){		
						$(id).append("<option value='' selected>::체급선택::</option>");						
					}
					else{
						//$(id).children("option").remove();
						$(id).append("<option value='' selected>해당없음</option>");					
					}
				}

				defer.resolve(data);

			}

			function ferror() {
				defer.reject(error);
			}
			return defer.progress();
		}
		

		//지도자버전에서 검색 체급목록 공통 SSG 20160802
		var drLevelList_sum = function(id,TeamGb,sellevelcode)
		{

			var defer=$.Deferred();
			var obj = {};

			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.TeamGb = TeamGb;

			var jsonData = JSON.stringify(obj);

			//console.log(obj);

			$.ajax({
					url: '/Ajax/judo_OS/Management/LevelInfo_sum.ashx',
					type: 'post',
					data: jsonData,
					success: function(data){fsuccess(data)},error:ferror
			});

			//훈련 select 세팅
			function fsuccess(data){


				console.log(data);

				var myArr = JSON.parse(data);
				//$(id).children("option").not("[value='']").remove();
				$(id).children("option").remove();
				
				
				if (myArr.length > 0)
				{


					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){

						$(id).append("<option data-sex='' data-level='' value='' selected>::체급선택::</option>");

						for (var i = 0; i < myArr.length; i++)
						{
							var varSex = "";
							
							if(myArr[i].Sex == "Man"){
								varSex = "남자";
							}
							else{
								varSex = "여자";								
							}

							if ( myArr[i].Sex + "|" + myArr[i].Level == sellevelcode)
							{
								$(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"' selected>" +  /*varSex + " " +*/ myArr[i].LevelNm + "</option>");
							}
							else
							{
								$(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"'>" +  /*varSex + " " +*/ myArr[i].LevelNm +"</option>");
							}
							
						}
					}
					else{

						//$(id).children("option").remove();
						//$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
						//$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");


						$(id).append("<option data-sex='"+myArr[0].Sex+"' data-level='' value='WoMan' >무차별</option>");
					}
				}
				else{
					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){		
						$(id).append("<option data-sex='' data-level='' value='' selected>::체급선택::</option>");						
					}
					else{

						//$(id).children("option").remove();
						//$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
						//$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");			

						$(id).append("<option data-sex='' data-level='' value='' >무차별</option>");
					}
				}

				defer.resolve(data);

			}

			function ferror() {
				defer.reject(error);
			}
			return defer.progress();
		}
		
		//지도자버전에서 검색 체급목록 공통 SSG 20160802
		var drLevelList_sum_NowGame = function(id,TeamGb,sellevelcode)
		{


			var defer=$.Deferred();
			var obj = {};

			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.TeamGb = TeamGb;
			obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

			var jsonData = JSON.stringify(obj);

			//console.log(obj);

			$.ajax({
					url: '/Ajax/judo_OS/Management/LevelInfo_sum_NowGame.ashx',
					type: 'post',
					data: jsonData,
					success: function(data){fsuccess(data)},error:ferror
			});

			//훈련 select 세팅
			function fsuccess(data){


				console.log(data);

				var myArr = JSON.parse(data);
				//$(id).children("option").not("[value='']").remove();
				$(id).children("option").remove();
				
				
				if (myArr.length > 0)
				{


					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){

						$(id).append("<option data-sex='' data-level='' value='' selected>::체급선택::</option>");

						for (var i = 0; i < myArr.length; i++)
						{
							var varSex = "";
							
							if(myArr[i].Sex == "Man"){
								varSex = "남자";
							}
							else{
								varSex = "여자";								
							}

							if ( myArr[i].Sex + "|" + myArr[i].Level == sellevelcode)
							{
								$(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"' selected>" +  /*varSex + " " +*/ myArr[i].LevelNm + "</option>");
							}
							else
							{
								$(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"'>" +  /*varSex + " " +*/ myArr[i].LevelNm +"</option>");
							}
							
						}
					}
					else{

						//$(id).children("option").remove();
						//$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
						//$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");


						$(id).append("<option data-sex='"+myArr[0].Sex+"' data-level='' value='WoMan' >무차별</option>");
					}
				}
				else{
					if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){		
						$(id).append("<option data-sex='' data-level='' value='' selected>::체급선택1::</option>");						
					}
					else{

						//$(id).children("option").remove();
						//$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
						//$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");			

						$(id).append("<option data-sex='' data-level='' value='' >무차별</option>");
					}
				}

				defer.resolve(data);

			}

			function ferror() {
				defer.reject(error);
			}
			return defer.progress();
		}
		

    //null 처리 함수.
    var replaceNull = function (value) {
        return (value.length > 0) ? value : "";
    };


		//오늘날짜
		var setToDay=function(id){
			var now = new Date();
			var year= now.getFullYear();
			var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
			var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
			var chan_val = year + '-' + mon + '-' + day;
			$("#"+id).val(chan_val);
			localStorage.setItem(id,chan_val);
		}

		
		
		//그래프 bar height size 
		var varHeightFunction=function(sdata){

				//출력갯수만큼 사이즈 지정
				var varHeight = "";
				var setcount = sdata.match(/<set/g); 
				if(setcount != null) {
						varHeight = (setcount.length*25)+100; // 2개이므로 2가 출력된다!
						varHeight = varHeight+"px";
				} else {
						varHeight = "700px";
				}

			return varHeight;
		}
		
		function addzero(str,legnth){
			if(str.length == 1){
				str = "0" + str;
			}
			return str;
		}		

	var apploading = function(obj, str){
		$("#" + obj).oLoader({
		backgroundColor:'#fff',
		//image: 'images/ownageLoader/loader1.gif',
		style: "<div style='position:absolute;left:460px;bottom:350px;background:#000;color:#fff;padding:20px;border-radius:4px; width:350px; margin:0 auto; text-align:center;'>"+str+"<br><br><img src='./images/ownageLoader/loader1.gif'></div>",
		fadeInTime: 100,
		fadeOutTime: 100,
		fadeLevel: 0.5
		});			
	}
			