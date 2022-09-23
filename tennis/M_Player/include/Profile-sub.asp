<script type="text/javascript">

	function iMainTotal(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX, iSelType, iteamgb) {

		//alert(iSportsGb + iSDate + iEDate + iGameTitleIDX + iSelPlayerIDX + iSelType);

  	if (iSelType.indexOf('1') >= 0) {
		
  		iprofile(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
		
  	}

  	if (iSelType.indexOf('2') >= 0) {
		
  		iResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
		
  	}

  	if (iSelType.indexOf('3') >= 0) {
		
  		iGameResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
		
  	}

  	if (iSelType.indexOf('4') >= 0) {

  		iSkillResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

  	}


		//iTimeResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);


  	if (iSelType.indexOf('6') >= 0) {

  		iRankingPoint(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX, iteamgb);

  	}

  }

	// 프로필
	function iprofile(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		//alert(iSelPlayerIDX);
		$('#maincontents_1').html("");

  	var strAjaxUrl = "../Ajax/Stat-sub-profile.asp";
  	$.ajax({
  		url: strAjaxUrl,
  		type: 'POST',
  		dataType: 'html',
  		//async: false,
  		data: {
  			SportsGb: iSportsGb,
  			SDate: iSDate,
  			EDate: iEDate,
  			iPlayerIDX: iSelPlayerIDX,
  			iGameTitleIDX: iGameTitleIDX
  		},
  		success: function (retDATA) {
  			if (retDATA) {
  				$('#maincontents_1').append(retDATA);
  			} else {
  				$('#maincontents_1').append("");
  			}
  		}, error: function (xhr, status, error) {
  			if (error != '') {
  				alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
  			}
  		}
  	});

	}

	// 전적
	function iResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		$('#maincontents_2').html("");

		var strAjaxUrl = "../Ajax/Stat-sub-iResult.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
		  //async: false,
			data: {
				//SportsGb: iSportsGb,
				//SDate: iSDate,
				//EDate: iEDate,
				//iPlayerIDX: iSelPlayerIDX,
				//iGameTitleIDX: iGameTitleIDX
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#maincontents_2').append(retDATA);

					iResult_Total(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
					iResult_NowYear(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
				} else {
					$('#maincontents_2').append("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

		//iResult_Total(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);
		//iResult_NowYear(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

	}

	// 전적 > 통산전적
	function iResult_Total(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		var strAjaxUrl = "../Ajax/Stat-sub-total.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			//async: false,
			data: {
				SportsGb: iSportsGb,
				SDate: iSDate,
				EDate: iEDate,
				iPlayerIDX: iSelPlayerIDX,
				iGameTitleIDX: iGameTitleIDX
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#iResultTotal').html(retDATA);
				} else {
					$('#iResultTotal').html("데이터가 없습니다.");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

	}

	// 전적 > 올시즌전적
	function iResult_NowYear(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		var strAjaxUrl = "../Ajax/Stat-sub-nowyear.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsGb: iSportsGb,
				SDate: iSDate,
				EDate: iEDate,
				iPlayerIDX: iSelPlayerIDX,
				iGameTitleIDX: iGameTitleIDX
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#iResultNowYear').html(retDATA);
				} else {
					$('#iResultNowYear').html("데이터가 없습니다.");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

	}

	// 최근 입상이력
	function iGameResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		$('#maincontents_3').html("");

		var strAjaxUrl = "../Ajax/Stat-sub-gameresult.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsGb: iSportsGb,
				SDate: iSDate,
				EDate: iEDate,
				iPlayerIDX: iSelPlayerIDX,
				iGameTitleIDX: iGameTitleIDX
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#maincontents_3').append(retDATA);
				} else {
					$('#maincontents_3').append("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

	}

	// 기술별 성공률
	function iSkillResult(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

		$('#maincontents_4').html("");

		var strAjaxUrl = "../Ajax/Stat-sub-skillresult.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsGb: iSportsGb,
				SDate: iSDate,
				EDate: iEDate,
				iPlayerIDX: iSelPlayerIDX,
				iGameTitleIDX: iGameTitleIDX
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#maincontents_4').append(retDATA);
				} else {
					$('#maincontents_4').append("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

	}


	// 랭킹포인트
	function iRankingPoint(iSportsGb, iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX, iteamgb) {

		//alert(iSelPlayerIDX);

		$('#maincontents_6').html("");

		var strAjaxUrl = "../Ajax/Stat-sub-rankingresult.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsGb: iSportsGb,
				SDate: iSDate,
				EDate: iEDate,
				iPlayerIDX: iSelPlayerIDX,
				iGameTitleIDX: iGameTitleIDX,
				iteamgb: iteamgb
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#maincontents_6').append(retDATA);
				} else {
					$('#maincontents_6').append("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
				}
			}
		});

	}



  function iTimeResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strJsonUrl = "../Json/record-sub.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&iPlayerIDX=" + iSelPlayerIDX + "&GameTitleIDX=" + iGameTitleIDX;

    FusionCharts.ready(function () {
      //Creating a new inline theme.
      //You can move this entire code block to a separate file, and load.
      FusionCharts.register('theme', {
        name: 'fire',
        theme: {
          base: {
            chart: {
              paletteColors: '#FF4444, #FFBB33, #99CC00, #33B5E5, #AA66CC',
              baseFontColor: '#36474D',
              baseFont: 'Helvetica Neue,Arial',
              captionFontSize: '14',
              subcaptionFontSize: '14',
              subcaptionFontBold: '0',
              showBorder: '0',
              bgColor: '#ffffff',
              showShadow: '0',
              canvasBgColor: '#ffffff',
              canvasBorderAlpha: '0',
              useplotgradientcolor: '0',
              useRoundEdges: '0',
              showPlotBorder: '0',
              showAlternateHGridColor: '0',
              showAlternateVGridColor: '0',
              toolTipBorderThickness: '0',
              toolTipBgColor: '#99CC00',
              toolTipBgAlpha: '90',
              toolTipBorderRadius: '2',
              toolTipPadding: '5',
              legendBgAlpha: '0',
              legendBorderAlpha: '0',
              legendShadow: '0',
              legendItemFontSize: '14',
              divlineAlpha: '100',
              divlineColor: '#36474D',
              divlineThickness: '1',
              divLineIsDashed: '1',
              divLineDashLen: '1',
              divLineGapLen: '1',
              showHoverEffect: '1',
              valueFontSize: '14',
              showXAxisLine: '1',
              xAxisLineThickness: '1',
              xAxisLineColor: '#36474D'
            }
          },
          mscolumn2d: {
            chart: {
              valueFontColor: '#FFFFFF', //overwrite base value
              valueBgColor: '#000000',
              valueBgAlpha: '30',
              placeValuesInside: '1',
              rotateValues: '0'
            }
          }
        }
      });

      var revenueChart = new FusionCharts({
        type: 'mscolumn2d',
        renderAt: 'time-record-chart',
        width: '100%',
        height: '260',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });

  }

</script>

