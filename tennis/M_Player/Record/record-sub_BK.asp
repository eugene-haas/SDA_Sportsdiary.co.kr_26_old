<script type="text/javascript">

  function iMainTotal(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    //alert(iGameTitleIDX);

    iprofile(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

    iResult_Total(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

    iResult_NowYear(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

    iGameResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

    iSkillResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

    iTimeResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX);

  }

  function iprofile(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strAjaxUrl = "../Ajax/record-sub-profile.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iSelPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iprofile').html(retDATA);
        } else {
          $('#iprofile').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function iResult_Total(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strAjaxUrl = "../Ajax/record-sub-total.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iSelPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iResultTotal').html(retDATA);
        } else {
          $('#iResultTotal').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function iResult_NowYear(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strAjaxUrl = "../Ajax/record-sub-nowyear.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iSelPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iResultNowYear').html(retDATA);
        } else {
          $('#iResultNowYear').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function iGameResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strAjaxUrl = "../Ajax/record-sub-gameresult.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iSelPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iGameResult').html(retDATA);
        } else {
          $('#iGameResult').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }


  function iSkillResult(iSDate, iEDate, iGameTitleIDX, iSelPlayerIDX) {

    var strAjaxUrl = "../Ajax/record-sub-skillresult.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iSelPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iSkillResult').html(retDATA);
        } else {
          $('#iSkillResult').html("");
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


<!-- S: modal-player-profile -->
<div class="modal fade confirm-modal modal-player-profile" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">선수 프로필</h4>
			</div>
			<div class="modal-body">
				<!-- S: main stat-record -->
				<div class="main stat-record" id="maincontents">


					<!-- S: player-profile -->
					<div class="player-profile" id="iprofile">
						
					</div>
					<!-- E: player-profile -->


					<div class="record-modal-wrap">


						<!-- S: 전적 record -->
						<section class="record">
								<h3>전적 <span class="record-info">＊통산전적은 2017년부터 기록됩니다.</span></h3>
								<div class="gray-box">
										<dl class="clearfix">
												<dt>통산전적(승률)</dt>
												<dd id="iResultTotal">200전 160승 40패(70.5%)</dd>
										</dl>
										<dl class="clearfix">
												<dt>올 시즌 전적(승률)</dt>
												<dd id="iResultNowYear">120전 90승 30패(76%)</dd>
										</dl>
								</div>
						</section>
						<!-- E: 전적 record -->


						<!-- S: 최근 경기이력 best-win -->
						<section class="record best-win">
								<h3>최근 입상이력 <span class="record-info">*입상이력은 개인전만 반영됩니다.</span></h3>
								<div class="gray-box">
										<!-- S: 2017 -->
                    <dl class="year" id="iGameResult">
                      <dd>데이터가 없습니다.</dd>
                    </dl>
                    <!-- E: 2017 -->
								</div>
						</section>
						<!-- E: 최근 경기이력 best-win -->



						<!-- S: 대회기록 best-win -->
						<section class="record best-win">
							<h3>대회기록</h3>
							<div class="gray-box">
									<h4>기술별 득실점</h4>


									<!-- S: between-chart -->
									<div class="between-chart container" id="iSkillResult">
											
									</div>
									<!-- E: between-chart -->
                  <p class="no-apply-txt">※ 지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>


									<!-- S: time-record-chart -->
									<div class="time-record-chart">
											<h4>시간대별 득실점</h4>
											<div id="time-record-chart"></div>
									</div>
									<!-- E: time-record-chart -->


							</div>
					</section>
					<!-- E: 대회기록 best-win -->
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- E: modal-player-profile -->